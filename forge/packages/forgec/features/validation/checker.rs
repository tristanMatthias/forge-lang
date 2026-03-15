use crate::errors::Diagnostic;
use crate::lexer::Span;
use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;
use crate::typeck::env::TypeEnv;
use crate::typeck::types::{AnnotationArg, FieldAnnotation, Type};

impl TypeChecker {
    pub(crate) fn extract_type_annotations(&mut self, type_expr: &TypeExpr) -> Vec<(String, Vec<FieldAnnotation>)> {
        /// Known core field annotations and what types they accept
        const CORE_ANNOTATIONS: &[(&str, &[&str])] = &[
            ("min", &["string", "int", "float"]),
            ("max", &["string", "int", "float"]),
            ("validate", &["string", "int", "float", "bool"]),
            ("pattern", &["string"]),
            ("transform", &["string"]),
            ("default", &["string", "int", "float", "bool"]),
        ];

        match type_expr {
            TypeExpr::Struct { fields } => {
                let mut result = Vec::new();
                for (field_name, field_type, anns) in fields {
                    if anns.is_empty() { continue; }

                    let resolved_type = self.resolve_type_expr(field_type);
                    let base_type = match &resolved_type {
                        Type::Nullable(inner) => inner.as_ref(),
                        other => other,
                    };
                    let type_str = match base_type {
                        Type::String => "string",
                        Type::Int => "int",
                        Type::Float => "float",
                        Type::Bool => "bool",
                        _ => "unknown",
                    };
                    let is_nullable = matches!(&resolved_type, Type::Nullable(_));

                    // Track seen annotations for duplicate detection
                    let mut seen_anns: Vec<&str> = Vec::new();
                    // Track min/max values for contradiction detection
                    let mut min_val: Option<(i64, Span)> = None;
                    let mut max_val: Option<(i64, Span)> = None;

                    for ann in anns {
                        let ann_name = ann.name.as_str();

                        // ── Type-level annotation on a field (F0073) ──
                        const TYPE_LEVEL_ANNOTATIONS: &[&str] = &["table"];
                        if TYPE_LEVEL_ANNOTATIONS.contains(&ann_name) {
                            self.diagnostics.push(Diagnostic::error(
                                "F0073",
                                format!("@{} is a type-level annotation and cannot be used on field '{}'",
                                    ann_name, field_name),
                                ann.span,
                            ).with_help(format!("move @{} to the top of the type or model block, before any fields", ann_name)));
                            continue;
                        }

                        // ── Package annotation outside its component context (F0074) ──
                        // Check against dynamically registered package annotations.
                        // Falls back to a hardcoded list for backward compatibility when
                        // no package declarations are loaded (e.g., forge check without packages).
                        let is_package_ann = if !self.package_annotations.is_empty() {
                            self.package_annotations.iter().any(|(name, target, _)| {
                                name == ann_name && (target == "field" || target == "type")
                            })
                        } else {
                            const FALLBACK_PACKAGE_ANNOTATIONS: &[&str] = &["primary", "auto_increment", "unique", "hidden", "owner"];
                            FALLBACK_PACKAGE_ANNOTATIONS.contains(&ann_name)
                        };
                        if is_package_ann {
                            // Find the component name for a better error message
                            let component_name = self.package_annotations.iter()
                                .find(|(name, _, _)| name == ann_name)
                                .map(|(_, _, comp)| comp.as_str())
                                .unwrap_or("component");
                            self.diagnostics.push(Diagnostic::error(
                                "F0074",
                                format!("@{} is a {} annotation and cannot be used on plain type field '{}'",
                                    ann_name, component_name, field_name),
                                ann.span,
                            ).with_help(format!("@{} is only valid inside a {} block — use `{}` instead of `type` if you need {} features",
                                ann_name, component_name, component_name, component_name)));
                            continue;
                        }

                        // ── Unknown annotation (F0072) ──
                        let entry = CORE_ANNOTATIONS.iter().find(|(name, _)| *name == ann_name);
                        if entry.is_none() {
                            let core_names: Vec<&str> = CORE_ANNOTATIONS.iter().map(|(n, _)| *n).collect();
                            let available = core_names.iter().map(|n| format!("@{}", n)).collect::<Vec<_>>().join(", ");
                            let mut diag = Diagnostic::error(
                                "F0072",
                                format!("@{} is not a valid field annotation", ann_name),
                                ann.span,
                            );
                            if let Some(suggestion) = crate::errors::suggestions::did_you_mean(ann_name, &core_names, 2) {
                                diag = diag.with_help(format!("did you mean @{}?", suggestion));
                            } else {
                                diag = diag.with_help(format!("available annotations: {}", available));
                            }
                            self.diagnostics.push(diag);
                            continue;
                        }
                        let (_, allowed_types) = entry.unwrap();

                        // ── Type compatibility ──
                        if !allowed_types.contains(&type_str) {
                            let args_str = Self::format_annotation_args(&ann.args);
                            self.diagnostics.push(Diagnostic::error(
                                "F0080",
                                format!("@{}({}) requires {}, got {} on field '{}'",
                                    ann_name, args_str,
                                    allowed_types.join(" or "), type_str, field_name),
                                ann.span,
                            ));
                            continue;
                        }

                        // ── Duplicate detection ──
                        if seen_anns.contains(&ann_name) && ann_name != "validate" {
                            self.diagnostics.push(Diagnostic::error(
                                "F0080",
                                format!("duplicate @{} on field '{}'. each annotation should appear at most once",
                                    ann_name, field_name),
                                ann.span,
                            ));
                            continue;
                        }
                        seen_anns.push(ann_name);

                        // ── Per-annotation arg validation ──
                        match ann_name {
                            "min" | "max" => {
                                if ann.args.is_empty() {
                                    self.diagnostics.push(Diagnostic::error(
                                        "F0080",
                                        format!("@{} requires an argument — e.g. @{}({})",
                                            ann_name, ann_name,
                                            if type_str == "string" { "1" } else { "0" }),
                                        ann.span,
                                    ));
                                } else if !matches!(ann.args.first(), Some(Expr::IntLit(..))) {
                                    self.diagnostics.push(Diagnostic::error(
                                        "F0080",
                                        format!("@{} expects an integer argument — e.g. @{}(1)",
                                            ann_name, ann_name),
                                        ann.span,
                                    ));
                                } else if let Some(Expr::IntLit(n, _)) = ann.args.first() {
                                    // Track for contradiction check
                                    if ann_name == "min" {
                                        min_val = Some((*n, ann.span));
                                    } else {
                                        max_val = Some((*n, ann.span));
                                    }
                                }
                            }
                            "validate" => {
                                if ann.args.is_empty() {
                                    self.diagnostics.push(Diagnostic::error(
                                        "F0080",
                                        format!("@validate requires an argument — e.g. @validate(email) or @validate((val) -> {{ ... }})"),
                                        ann.span,
                                    ));
                                } else if let Some(Expr::Ident(name, _)) = ann.args.first() {
                                    // Named validators only work on strings
                                    let valid = ["email", "url", "uuid"];
                                    if !valid.contains(&name.as_str()) {
                                        self.diagnostics.push(Diagnostic::error(
                                            "F0080",
                                            format!("unknown validator '{}'. available: email, url, uuid, or use a custom closure", name),
                                            ann.span,
                                        ));
                                    } else if type_str != "string" {
                                        self.diagnostics.push(Diagnostic::error(
                                            "F0080",
                                            format!("@validate({}) requires string, got {} on field '{}'",
                                                name, type_str, field_name),
                                            ann.span,
                                        ));
                                    }
                                }
                                // Closure/expression validators are accepted on any type — no further check needed
                            }
                            "pattern" => {
                                if ann.args.is_empty() {
                                    self.diagnostics.push(Diagnostic::error(
                                        "F0080",
                                        format!("@pattern requires a regex string — e.g. @pattern(\"^[a-z]+$\")"),
                                        ann.span,
                                    ));
                                } else if !matches!(ann.args.first(), Some(Expr::StringLit(..))) {
                                    self.diagnostics.push(Diagnostic::error(
                                        "F0080",
                                        format!("@pattern expects a string argument — e.g. @pattern(\"^[a-z]+$\")"),
                                        ann.span,
                                    ));
                                }
                            }
                            "default" => {
                                if !is_nullable {
                                    self.diagnostics.push(Diagnostic::error(
                                        "F0080",
                                        format!("@default on field '{}' has no effect — the field is not optional. make it nullable with '{}?'",
                                            field_name, type_str),
                                        ann.span,
                                    ));
                                } else if ann.args.is_empty() {
                                    self.diagnostics.push(Diagnostic::error(
                                        "F0080",
                                        format!("@default requires a value — e.g. @default(\"{}\")",
                                            match type_str { "string" => "value", "int" => "0", "float" => "0.0", "bool" => "true", _ => "..." }),
                                        ann.span,
                                    ));
                                } else {
                                    // Check default value type matches field type
                                    let arg_ok = match (ann.args.first(), type_str) {
                                        (Some(Expr::StringLit(..)), "string") => true,
                                        (Some(Expr::Ident(..)), "string") => true, // bare ident as string
                                        (Some(Expr::IntLit(..)), "int") => true,
                                        (Some(Expr::FloatLit(..)), "float") => true,
                                        (Some(Expr::BoolLit(..)), "bool") => true,
                                        _ => false,
                                    };
                                    if !arg_ok {
                                        self.diagnostics.push(Diagnostic::error(
                                            "F0080",
                                            format!("@default value type mismatch — field '{}' is {}, but the default is not",
                                                field_name, type_str),
                                            ann.span,
                                        ));
                                    }
                                }
                            }
                            "transform" => {
                                if ann.args.is_empty() {
                                    self.diagnostics.push(Diagnostic::error(
                                        "F0080",
                                        format!("@transform requires an expression — e.g. @transform(it.lower().trim())"),
                                        ann.span,
                                    ));
                                }
                            }
                            _ => {}
                        }
                    }

                    // ── @min > @max contradiction ──
                    if let (Some((min, _)), Some((max, max_span))) = (min_val, max_val) {
                        if min > max {
                            self.diagnostics.push(Diagnostic::error(
                                "F0080",
                                format!("impossible constraint on field '{}': @min({}) > @max({}) — no value can satisfy both",
                                    field_name, min, max),
                                max_span,
                            ));
                        }
                    }

                    result.push((field_name.clone(), TypeEnv::resolve_annotations(anns)));
                }
                result
            }
            TypeExpr::Named(name) => {
                // Look up annotations from a referenced type
                self.env.type_annotations.get(name).cloned().unwrap_or_default()
            }
            TypeExpr::Without { base, fields: removed } => {
                let base_anns = self.extract_type_annotations(base);
                base_anns.into_iter()
                    .filter(|(name, _)| !removed.contains(name))
                    .collect()
            }
            TypeExpr::Only { base, fields: kept } => {
                let base_anns = self.extract_type_annotations(base);
                base_anns.into_iter()
                    .filter(|(name, _)| kept.contains(name))
                    .collect()
            }
            TypeExpr::TypeWith { base, fields: new_fields } => {
                let mut result = self.extract_type_annotations(base);
                // Add/override annotations from new fields
                for (name, _, anns) in new_fields {
                    if !anns.is_empty() {
                        let resolved = TypeEnv::resolve_annotations(anns);
                        if let Some(pos) = result.iter().position(|(n, _)| n == name) {
                            result[pos] = (name.clone(), resolved);
                        } else {
                            result.push((name.clone(), resolved));
                        }
                    }
                }
                result
            }
            TypeExpr::AsPartial(base) => {
                // Partial types inherit all annotations
                self.extract_type_annotations(base)
            }
            TypeExpr::Intersection(left, right) => {
                let mut result = self.extract_type_annotations(left);
                let right_anns = self.extract_type_annotations(right);
                for (name, anns) in right_anns {
                    if let Some(pos) = result.iter().position(|(n, _)| n == &name) {
                        // Right side overrides left for same field
                        result[pos] = (name, anns);
                    } else {
                        result.push((name, anns));
                    }
                }
                result
            }
            _ => Vec::new(),
        }
    }

    /// Format annotation args for error messages
    fn format_annotation_args(args: &[Expr]) -> String {
        args.iter().map(|a| match a {
            Expr::Ident(name, _) => name.clone(),
            Expr::StringLit(s, _) => format!("\"{}\"", s),
            Expr::IntLit(n, _) => n.to_string(),
            Expr::FloatLit(f, _) => f.to_string(),
            Expr::BoolLit(b, _) => b.to_string(),
            _ => "...".to_string(),
        }).collect::<Vec<_>>().join(", ")
    }

    fn format_field_annotation_args(args: &[AnnotationArg]) -> String {
        args.iter().map(|a| match a {
            AnnotationArg::Int(n) => n.to_string(),
            AnnotationArg::Float(f) => f.to_string(),
            AnnotationArg::String(s) => format!("\"{}\"", s),
            AnnotationArg::Bool(b) => b.to_string(),
            AnnotationArg::Ident(s) => s.clone(),
            AnnotationArg::Expr(_) => "...".to_string(),
        }).collect::<Vec<_>>().join(", ")
    }

    pub(crate) fn check_intersection_annotation_conflicts(&mut self, type_expr: &TypeExpr, span: Span) {
        if let TypeExpr::Intersection(left, right) = type_expr {
            // Recursively check nested intersections
            self.check_intersection_annotation_conflicts(left, span);
            self.check_intersection_annotation_conflicts(right, span);

            let left_anns = self.extract_type_annotations(left);
            let right_anns = self.extract_type_annotations(right);

            for (field_name, right_field_anns) in &right_anns {
                if let Some((_, left_field_anns)) = left_anns.iter().find(|(n, _)| n == field_name) {
                    // Both sides have annotations for this field — check for conflicts
                    for right_ann in right_field_anns {
                        if let Some(left_ann) = left_field_anns.iter().find(|a| a.name == right_ann.name) {
                            // Same annotation name on same field — check if values differ
                            if left_ann.args != right_ann.args {
                                let left_args = Self::format_field_annotation_args(&left_ann.args);
                                let right_args = Self::format_field_annotation_args(&right_ann.args);
                                self.diagnostics.push(Diagnostic::error(
                                    "F0081",
                                    format!(
                                        "conflicting annotations in intersection: field '{}' has conflicting @{}: {} (from left) vs {} (from right)",
                                        field_name, right_ann.name, left_args, right_args
                                    ),
                                    span,
                                ));
                            }
                        }
                    }
                }
            }
        }
    }
}
