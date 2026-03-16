use crate::errors::Diagnostic;
use crate::errors::diagnostic::{Edit, LabelKind};
use crate::errors::suggestions::placeholder_for_type;
use crate::lexer::Span;
use crate::parser::ast::*;
use crate::typeck::env::TypeEnv;
use crate::typeck::types::{EnumVariantType, Type};

pub struct TypeChecker {
    pub env: TypeEnv,
    pub diagnostics: Vec<Diagnostic>,
    pub current_fn_return_type: Option<Type>,
    /// Package-declared annotations: (annotation_name, target, component_name)
    /// Populated from component template `annotation <target> <name>(...)` declarations.
    pub package_annotations: Vec<(String, String, String)>,
    /// Per-field mutability registry: (type_name, field_name) → mutable
    /// Fields not in this map default to immutable.
    pub mutable_fields: std::collections::HashSet<(String, String)>,
}

impl TypeChecker {
    pub fn new() -> Self {
        Self {
            env: TypeEnv::new(),
            diagnostics: Vec::new(),
            current_fn_return_type: None,
            package_annotations: Vec::new(),
            mutable_fields: std::collections::HashSet::new(),
        }
    }

    pub fn check_program(&mut self, program: &Program) {
        // First pass: register all top-level declarations
        for stmt in &program.statements {
            self.register_top_level(stmt);
        }

        // Second pass: type check
        for stmt in &program.statements {
            self.check_statement(stmt);
        }
    }

    pub(crate) fn register_top_level(&mut self, stmt: &Statement) {
        match stmt {
            Statement::FnDecl {
                name,
                type_params,
                params,
                return_type,
                span,
                ..
            } => {
                // Check for builtin shadowing
                if crate::registry::BuiltinFnRegistry::all_names().contains(&name.as_str()) {
                    self.diagnostics.push(Diagnostic::error(
                        "F0012",
                        format!("cannot redefine builtin function '{}'", name),
                        *span,
                    ).with_help("choose a different function name".to_string()));
                    return;
                }
                let param_types: Vec<Type> = params
                    .iter()
                    .map(|p| {
                        p.type_ann
                            .as_ref()
                            .map(|t| self.resolve_type_expr(t))
                            .unwrap_or(Type::Unknown)
                    })
                    .collect();
                let ret = return_type
                    .as_ref()
                    .map(|t| self.resolve_type_expr(t))
                    .unwrap_or(Type::Void);
                // Store type params for generic functions (for trait bound checking at call sites)
                if !type_params.is_empty() {
                    self.env.fn_type_params.insert(name.clone(), type_params.clone());
                    let param_type_names: Vec<Option<String>> = params.iter().map(|p| {
                        match &p.type_ann {
                            Some(TypeExpr::Named(n)) => Some(n.clone()),
                            _ => None,
                        }
                    }).collect();
                    self.env.fn_param_type_names.insert(name.clone(), param_type_names);
                }
                self.env.fn_spans.insert(name.clone(), *span);
                self.env.functions.insert(
                    name.clone(),
                    Type::Function {
                        params: param_types,
                        return_type: Box::new(ret),
                    },
                );
            }
            Statement::EnumDecl {
                name, variants, ..
            } => {
                let variant_types: Vec<EnumVariantType> = variants
                    .iter()
                    .map(|v| {
                        let mut boxed_fields = Vec::new();
                        let fields: Vec<(String, Type)> = v
                            .fields
                            .iter()
                            .enumerate()
                            .map(|(i, f)| {
                                let is_self_ref = f.type_ann.as_ref()
                                    .map(|t| type_expr_references_name(t, name))
                                    .unwrap_or(false);
                                let ty = if is_self_ref {
                                    boxed_fields.push(i);
                                    // Use a stub enum type to avoid infinite recursion
                                    Type::Enum { name: name.clone(), variants: vec![] }
                                } else {
                                    f.type_ann
                                        .as_ref()
                                        .map(|t| self.resolve_type_expr(t))
                                        .unwrap_or(Type::Unknown)
                                };
                                (f.name.clone(), ty)
                            })
                            .collect();
                        EnumVariantType {
                            name: v.name.clone(),
                            fields,
                            boxed_fields,
                        }
                    })
                    .collect();
                let enum_type = Type::Enum {
                    name: name.clone(),
                    variants: variant_types,
                };
                self.env.enum_types.insert(name.clone(), enum_type);
            }
            Statement::TypeDecl { name, value, span, .. } => {
                // Check for conflicting annotations in intersection types
                self.check_intersection_annotation_conflicts(value, *span);
                // Extract annotations from the type expression before resolving
                let field_annotations = self.extract_type_annotations(value);
                if !field_annotations.is_empty() {
                    self.env.type_annotations.insert(name.clone(), field_annotations);
                }
                // Track partial types
                if self.is_partial_type_expr(value) {
                    self.env.partial_types.insert(name.clone());
                }
                let ty = self.resolve_type_expr(value);
                let ty = match ty {
                    Type::Struct { fields, .. } => Type::Struct {
                        name: Some(name.clone()),
                        fields,
                    },
                    other => other,
                };
                self.env.type_aliases.insert(name.clone(), ty);
            }
            Statement::ExternFn {
                name,
                params,
                return_type,
                span,
                ..
            } => {
                let param_types: Vec<Type> = params
                    .iter()
                    .map(|p| {
                        p.type_ann
                            .as_ref()
                            .map(|t| self.resolve_type_expr(t))
                            .unwrap_or(Type::Unknown)
                    })
                    .collect();
                let ret = return_type
                    .as_ref()
                    .map(|t| self.resolve_type_expr(t))
                    .unwrap_or(Type::Void);
                self.env.fn_spans.insert(name.clone(), *span);
                self.env.functions.insert(
                    name.clone(),
                    Type::Function {
                        params: param_types,
                        return_type: Box::new(ret),
                    },
                );
                // Extract namespace from package extern fn names (forge_<ns>_<method>)
                if let Some(rest) = name.strip_prefix("forge_") {
                    if let Some(ns_end) = rest.find('_') {
                        self.env.namespaces.insert(rest[..ns_end].to_string());
                    }
                }
            }
            Statement::ImplBlock { type_name, trait_name, methods, .. } => {
                // Register trait implementation
                if let Some(tn) = trait_name {
                    self.env.type_traits
                        .entry(type_name.clone())
                        .or_insert_with(Vec::new)
                        .push(tn.clone());
                }
                // Collect methods first to avoid borrow conflict
                let mut new_methods: Vec<(String, Type)> = Vec::new();
                for m in methods {
                    if let Statement::FnDecl { name, return_type, .. } = m {
                        let ret = return_type.as_ref()
                            .map(|t| self.resolve_type_expr(t))
                            .unwrap_or(Type::Void);
                        new_methods.push((name.clone(), ret));
                    }
                }
                let type_methods = self.env.type_methods
                    .entry(type_name.clone())
                    .or_insert_with(Vec::new);
                for (name, ret) in new_methods {
                    if !type_methods.iter().any(|(n, _)| n == &name) {
                        type_methods.push((name, ret));
                    }
                }
            }
            Statement::Feature(fe) => {
                match fe.feature_id {
                    "enums" => self.register_enum_feature(fe),
                    "functions" => self.register_fn_feature(fe),
                    "structs" => self.register_type_decl_feature(fe),
                    "traits" => self.register_traits_feature(fe),
                    _ => {}
                }
            }
            _ => {}
        }
    }

    pub(crate) fn check_statement(&mut self, stmt: &Statement) {
        match stmt {
            Statement::Let { name, type_ann, type_ann_span, value, span, .. } =>
                self.check_binding(name, type_ann.as_ref(), *type_ann_span, value, false, *span),
            Statement::Mut { name, type_ann, type_ann_span, value, span, .. } =>
                self.check_binding(name, type_ann.as_ref(), *type_ann_span, value, true, *span),
            Statement::Const { name, type_ann, type_ann_span, value, span, .. } =>
                self.check_binding(name, type_ann.as_ref(), *type_ann_span, value, false, *span),
            Statement::LetDestructure { pattern, value, .. } => {
                let val_type = self.check_expr(value);
                self.bind_destructure_pattern(pattern, &val_type);
            }
            Statement::Assign { target, value, span } => {
                if let Expr::Ident(name, _) = target {
                    if let Some(info) = self.env.lookup_and_mark_used(name) {
                        if !info.mutable {
                            self.diagnostics.push(Diagnostic::error(
                                "F0013",
                                format!("cannot assign to immutable variable '{}'", name),
                                *span,
                            ));
                        }
                    }
                }
                // Check field assignment: per-field mutability (F0031) and variable mutability (F0013)
                if let Expr::MemberAccess { object, .. } = target {
                    // Check per-field mutability first
                    self.check_field_mutability(target, *span);

                    // Walk through nested member accesses to find the root variable
                    let mut root = object.as_ref();
                    while let Expr::MemberAccess { object: inner, .. } = root {
                        root = inner.as_ref();
                    }
                    if let Expr::Ident(name, _) = root {
                        if let Some(info) = self.env.lookup_and_mark_used(name) {
                            if !info.mutable {
                                // Only emit F0013 for old-style types without mut annotations
                                // For types with field mutability, the per-field check handles it
                                let obj_type = self.env.lookup(name).map(|i| i.ty.clone()).unwrap_or(Type::Unknown);
                                let type_name = match &obj_type {
                                    Type::Struct { name: Some(n), .. } => Some(n.clone()),
                                    _ => None,
                                };
                                let has_mutability_info = type_name.as_ref()
                                    .map(|tn| self.mutable_fields.iter().any(|(t, _)| t == tn))
                                    .unwrap_or(false);
                                if !has_mutability_info {
                                    self.diagnostics.push(Diagnostic::error(
                                        "F0013",
                                        format!("cannot assign to field of immutable variable '{}'", name),
                                        *span,
                                    ));
                                }
                            }
                        }
                    }
                }
                self.check_expr(value);
            }
            Statement::FnDecl {
                name,
                params,
                return_type,
                body,
                ..
            } => {
                self.env.push_scope();

                let ret_type = return_type
                    .as_ref()
                    .map(|t| self.resolve_type_expr(t))
                    .unwrap_or(Type::Void);

                let old_return = self.current_fn_return_type.take();
                self.current_fn_return_type = Some(ret_type.clone());

                for param in params {
                    let ty = param
                        .type_ann
                        .as_ref()
                        .map(|t| self.resolve_type_expr(t))
                        .unwrap_or(Type::Unknown);
                    self.env.define(param.name.clone(), ty, false);
                }

                self.check_block(body);

                self.current_fn_return_type = old_return;
                let unused = self.env.pop_scope();
                for uv in unused {
                    self.diagnostics.push(
                        Diagnostic::warning(
                            "F0801",
                            format!("unused variable '{}'", uv.name),
                            uv.span,
                        )
                        .with_tip(format!(
                            "if this is intentional, prefix it with an underscore: `_{}`",
                            uv.name
                        )),
                    );
                }

                // Also define the function in the current scope as a value
                let param_types: Vec<Type> = params
                    .iter()
                    .map(|p| {
                        p.type_ann
                            .as_ref()
                            .map(|t| self.resolve_type_expr(t))
                            .unwrap_or(Type::Unknown)
                    })
                    .collect();
                self.env.define(
                    name.clone(),
                    Type::Function {
                        params: param_types,
                        return_type: Box::new(ret_type),
                    },
                    false,
                );
            }
            Statement::Expr(expr) => {
                self.check_expr(expr);
            }
            Statement::Return { value, span, .. } => {
                if let Some(val) = value {
                    let val_type = self.check_expr(val);
                    if let Some(expected) = self.current_fn_return_type.clone() {
                        self.check_type_mismatch_ctx(&expected, &val_type, *span, None, Some(val));
                    }
                }
            }
            Statement::For {
                pattern,
                iterable,
                body,
                ..
            } => {
                let iter_type = self.check_expr(iterable);
                self.env.push_scope();
                if let Pattern::Ident(name, _) = pattern {
                    let elem_type = match &iter_type {
                        Type::Range(inner) => *inner.clone(),
                        Type::List(inner) => *inner.clone(),
                        _ => Type::Int,
                    };
                    self.env.define(name.clone(), elem_type, false);
                }
                self.check_block(body);
                self.env.pop_scope_silent();
            }
            Statement::While { condition, body, .. } => {
                self.check_expr(condition);
                self.env.push_scope();
                self.check_block(body);
                self.env.pop_scope_silent();
            }
            Statement::Loop { body, .. } => {
                self.env.push_scope();
                self.check_block(body);
                self.env.pop_scope_silent();
            }
            Statement::Break { value, .. } => {
                if let Some(val) = value {
                    self.check_expr(val);
                }
            }
            Statement::Continue { .. } => {}
            Statement::Defer { body, .. } => {
                self.check_defer_stmt(body);
            }
            Statement::EnumDecl { .. }
            | Statement::TypeDecl { .. }
            | Statement::Use { .. }
            | Statement::ModDecl { .. }
            | Statement::TraitDecl { .. }
            | Statement::ImplBlock { .. }
            | Statement::ExternFn { .. }
            | Statement::ComponentBlock(_)
            | Statement::ComponentTemplateDef(_) => {}
            Statement::SpecBlock { body, .. } => self.check_spec_block(body),
            Statement::GivenBlock { body, .. } => self.check_given_block(body),
            Statement::ThenBlock { body, .. } => self.check_then_block(body),
            Statement::ThenShouldFail { body, .. } => self.check_then_should_fail(body),
            Statement::ThenShouldFailWith { body, .. } => self.check_then_should_fail_with(body),
            Statement::ThenWhere { table, body, .. } => self.check_then_where(table, body),
            Statement::SkipBlock { .. } | Statement::TodoStmt { .. } => {}
            Statement::Select { arms, .. } => self.check_select(arms),
            Statement::Feature(fe) => self.check_feature_stmt(fe),
        }
    }

    /// Dispatch a feature-owned statement to the appropriate feature's checker.
    pub(crate) fn check_feature_stmt(&mut self, fe: &crate::feature::FeatureStmt) {
        crate::dispatch_feature_stmt!(self, fe, {
            "defer"         => check_defer_feature,
            "select_syntax" => check_select_feature,
            "for_loops"     => check_for_feature,
            "while_loops"   => check_while_loops_feature,
            "enums"         => check_enum_feature,
            "variables"     => check_variables_feature,
            "functions"     => check_functions_feature,
            "structs"       => check_structs_feature,
            "traits"        => check_traits_feature,
            "imports"       => check_imports_feature,
        })
    }

    /// Dispatch a feature-owned expression to the appropriate feature's checker.
    pub(crate) fn check_feature_expr(&mut self, fe: &crate::feature::FeatureExpr) -> Type {
        // ForceUnwrap has inline logic — handle before the dispatch table
        if fe.feature_id == "null_safety" && fe.kind == "ForceUnwrap" {
            use crate::features::null_safety::types::ForceUnwrapData;
            if let Some(data) = crate::feature_data!(fe, ForceUnwrapData) {
                let inner = self.check_expr(&data.operand);
                return match inner {
                    Type::Nullable(t) => *t,
                    other => other,
                };
            }
            return Type::Unknown;
        }
        crate::dispatch_feature_check!(self, fe, {
            ("spawn", _)                       => check_spawn_feature,
            ("ranges", _)                      => check_range_feature,
            ("is_keyword", _)                  => check_is_feature,
            ("with_expression", _)             => check_with_feature,
            ("pipe_operator", _)               => check_pipe_feature,
            ("shell_shorthand", _)             => check_dollar_exec_feature,
            ("tagged_templates", _)            => check_tagged_template_feature,
            ("table_literal", _)               => check_table_lit_feature,
            ("closures", _)                    => check_closure_feature,
            ("pattern_matching", _)            => check_match_feature,
            ("match_tables", _)               => check_match_table_feature,
            ("channels", _)                    => check_channel_feature,
            ("if_else", _)                     => check_if_feature,
            ("null_safety", "NullCoalesce")    => check_null_coalesce_feature,
            ("null_throw", _)                  => check_null_throw_feature,
            ("null_safety", "NullPropagate")   => check_null_propagate_feature,
            ("error_propagation", "ErrorPropagate") => check_error_propagate_feature,
            ("error_propagation", "OkExpr")    => check_ok_expr_feature,
            ("error_propagation", "ErrExpr")   => check_err_expr_feature,
            ("error_propagation", "Catch")     => check_catch_feature,
            ("structs", _)                     => check_struct_lit_feature,
            ("tuples", _)                      => check_tuple_lit_feature,
            ("collections", "ListLit")         => check_list_lit_feature,
            ("collections", "MapLit")          => check_map_lit_feature,
            ("slicing", _)                     => check_slice_feature,
        })
    }

    pub(crate) fn check_block(&mut self, block: &Block) {
        for stmt in &block.statements {
            self.check_statement(stmt);
        }
    }

    pub(crate) fn check_expr(&mut self, expr: &Expr) -> Type {
        match expr {
            Expr::IntLit(_, _) => Type::Int,
            Expr::FloatLit(_, _) => Type::Float,
            Expr::StringLit(_, _) | Expr::TemplateLit { .. } => Type::String,
            Expr::BoolLit(_, _) => Type::Bool,
            Expr::NullLit(_) => Type::Nullable(Box::new(Type::Unknown)),

            Expr::Ident(name, span) => {
                if let Some(info) = self.env.lookup_and_mark_used(name) {
                    info.ty.clone()
                } else if let Some(ty) = self.env.lookup_function(name).cloned() {
                    ty
                } else if name.starts_with('.') {
                    // Contextual variant — resolve to enum type if unambiguous
                    self.resolve_contextual_variant(name)
                } else if name.starts_with("__destructure") {
                    Type::Void
                } else if self.env.enum_types.contains_key(name) {
                    // Enum name used as a namespace (e.g., Shape.circle)
                    self.env.enum_types[name].clone()
                } else if self.env.type_aliases.contains_key(name) {
                    // Named type used as constructor (e.g., Point { x: 1 })
                    self.env.type_aliases[name].clone()
                } else if self.env.namespaces.contains(name) {
                    // Package namespace (e.g., json, fs, process)
                    Type::Unknown
                } else {
                    let scope_names = self.env.all_names_in_scope();
                    let candidates: Vec<&str> = scope_names.iter().map(|s| s.as_str()).collect();
                    let mut diag = Diagnostic::error(
                        "F0020",
                        format!("undefined variable '{}'", name),
                        *span,
                    );
                    if let Some(suggestion) = crate::errors::did_you_mean(name, &candidates, 2) {
                        diag = diag.with_help(format!("did you mean '{}'?", suggestion));
                    }
                    self.diagnostics.push(diag);
                    Type::Error
                }
            }

            Expr::Binary { left, op, right, .. } => {
                let left_type = self.check_expr(left);
                let right_type = self.check_expr(right);

                // Check for ptr operations first
                if let Some(ptr_result) = self.check_ptr_binary(&left_type, op, &right_type) {
                    return ptr_result;
                }

                match op {
                    BinaryOp::Add | BinaryOp::Sub | BinaryOp::Mul | BinaryOp::Div | BinaryOp::Mod => {
                        if left_type == Type::Float || right_type == Type::Float {
                            Type::Float
                        } else if left_type == Type::Int || left_type == Type::Unknown {
                            Type::Int
                        } else if left_type == Type::String && matches!(op, BinaryOp::Add) {
                            Type::String
                        } else {
                            Type::Int
                        }
                    }
                    BinaryOp::Eq | BinaryOp::NotEq | BinaryOp::Lt | BinaryOp::LtEq | BinaryOp::Gt | BinaryOp::GtEq => {
                        Type::Bool
                    }
                    BinaryOp::And | BinaryOp::Or => Type::Bool,
                    BinaryOp::BitAnd | BinaryOp::BitOr | BinaryOp::BitXor | BinaryOp::Shl | BinaryOp::Shr => {
                        let op_str = match op {
                            BinaryOp::BitAnd => "&",
                            BinaryOp::BitOr => "|",
                            BinaryOp::BitXor => "^",
                            BinaryOp::Shl => "<<",
                            BinaryOp::Shr => ">>",
                            _ => unreachable!(),
                        };
                        if left_type != Type::Int && left_type != Type::Unknown && left_type != Type::Error {
                            self.diagnostics.push(
                                Diagnostic::error(
                                    "F0012",
                                    format!("bitwise operator `{}` requires int operands, found {}", op_str, left_type),
                                    left.span(),
                                ).with_help("bitwise operators only work on int values".to_string()),
                            );
                        }
                        if right_type != Type::Int && right_type != Type::Unknown && right_type != Type::Error {
                            self.diagnostics.push(
                                Diagnostic::error(
                                    "F0012",
                                    format!("bitwise operator `{}` requires int operands, found {}", op_str, right_type),
                                    right.span(),
                                ).with_help("bitwise operators only work on int values".to_string()),
                            );
                        }
                        Type::Int
                    }
                }
            }

            Expr::Unary { op, operand, .. } => {
                let operand_type = self.check_expr(operand);
                match op {
                    UnaryOp::Not => Type::Bool,
                    UnaryOp::Neg => operand_type,
                    UnaryOp::BitNot => {
                        if operand_type != Type::Int && operand_type != Type::Unknown && operand_type != Type::Error {
                            self.diagnostics.push(
                                Diagnostic::error(
                                    "F0012",
                                    format!("bitwise operator `~` requires int operand, found {}", operand_type),
                                    operand.span(),
                                ).with_help("bitwise NOT only works on int values".to_string()),
                            );
                        }
                        Type::Int
                    }
                }
            }

            Expr::Call { callee, args, span, .. } => {
                // Check for ptr bridge calls early, before check_expr(callee)
                // which would fail for `ptr.from_string()` since `ptr` isn't a variable
                if let Expr::MemberAccess { object, field, .. } = callee.as_ref() {
                    if let Expr::Ident(name, _) = object.as_ref() {
                        let arg_exprs: Vec<Expr> = args.iter().map(|a| a.value.clone()).collect();
                        if let Some(result) = self.check_ptr_bridge_call(name, field, &arg_exprs) {
                            return result;
                        }
                    }
                }
                let callee_type = self.check_expr(callee);
                let arg_types: Vec<Type> = args.iter().map(|arg| self.check_expr(&arg.value)).collect();

                match &callee_type {
                    Type::Function { params, return_type } => {
                        // ── Bidirectional type inference for closures ──
                        // If any param is Unknown (untyped closure param), infer it
                        // from the actual arg type at this call site.
                        let has_unknown = params.iter().any(|p| *p == Type::Unknown);
                        let resolved_params: Vec<Type> = if has_unknown {
                            params.iter().enumerate().map(|(i, p)| {
                                if *p == Type::Unknown {
                                    if i < arg_types.len() && arg_types[i] != Type::Unknown {
                                        arg_types[i].clone()
                                    } else {
                                        Type::Int // fallback for truly unknown
                                    }
                                } else {
                                    p.clone()
                                }
                            }).collect()
                        } else {
                            params.clone()
                        };

                        // If we inferred types, update the variable's stored type
                        // so subsequent calls see the resolved param types
                        if has_unknown {
                            if let Expr::Ident(fn_name, _) = callee.as_ref() {
                                let new_type = Type::Function {
                                    params: resolved_params.clone(),
                                    return_type: return_type.clone(),
                                };
                                self.env.update_var_type(fn_name, new_type);
                            }
                        }

                        let params = &resolved_params;

                        // Check argument count
                        if let Expr::Ident(fn_name, _) = callee.as_ref() {
                            let is_variadic = crate::registry::BuiltinFnRegistry::is_variadic(fn_name);
                            if args.len() != params.len() && !is_variadic
                            {
                                let sig = self.format_fn_signature(fn_name, params);
                                let example = self.format_fn_example(fn_name, params);
                                self.diagnostics.push(
                                    Diagnostic::error(
                                        "F0014",
                                        format!(
                                            "function '{}' expects {} argument{}, but {} {} provided",
                                            fn_name,
                                            params.len(),
                                            if params.len() == 1 { "" } else { "s" },
                                            args.len(),
                                            if args.len() == 1 { "was" } else { "were" },
                                        ),
                                        *span,
                                    )
                                    .with_help(format!("expected: {}\n  example:  {}", sig, example)),
                                );
                            }

                            // Check argument types
                            if !is_variadic {
                                for (i, (arg, param_type)) in args.iter().zip(params.iter()).enumerate() {
                                    if i < arg_types.len() {
                                        let arg_type = &arg_types[i];
                                        if !self.types_compatible(param_type, arg_type) {
                                            self.diagnostics.push(
                                                Diagnostic::error(
                                                    "F0012",
                                                    format!(
                                                        "type mismatch in argument {} of '{}': expected {}, found {}",
                                                        i + 1, fn_name, param_type, arg_type,
                                                    ),
                                                    arg.value.span(),
                                                )
                                                .with_help(format!("expected: {}", self.format_fn_signature(fn_name, params))),
                                            );
                                        }
                                    }
                                }
                            }

                            // ── validate()-specific checks ──
                            if crate::registry::BuiltinFnRegistry::get(fn_name).map_or(false, |d| d.feature_id == "validation") && args.len() >= 2 {
                                match &args[1].value {
                                    Expr::Ident(type_name, _) => {
                                        // Check that the type exists and is a struct
                                        let ty = self.env.resolve_type_name(type_name);
                                        if matches!(ty, Type::Error) {
                                            self.diagnostics.push(Diagnostic::error(
                                                "F0012",
                                                format!("unknown type '{}' in validate()", type_name),
                                                *span,
                                            ));
                                        } else if !matches!(ty, Type::Struct { .. }) {
                                            self.diagnostics.push(Diagnostic::error(
                                                "F0012",
                                                format!("validate() expects a struct type, got {}", type_name),
                                                *span,
                                            ));
                                        }
                                    }
                                    _ => {
                                        self.diagnostics.push(
                                            Diagnostic::error(
                                                "F0012",
                                                "validate() requires a type name as the second argument".to_string(),
                                                *span,
                                            )
                                            .with_help("example: validate(data, MyType)".to_string()),
                                        );
                                    }
                                }
                            }

                            // ── Generic trait bound checks ──
                            if let Some(type_params) = self.env.fn_type_params.get(fn_name).cloned() {
                                if let Some(param_type_names) = self.env.fn_param_type_names.get(fn_name).cloned() {
                                    let mut type_param_map: std::collections::HashMap<String, Type> = std::collections::HashMap::new();
                                    for (i, maybe_name) in param_type_names.iter().enumerate() {
                                        if let Some(name) = maybe_name {
                                            if type_params.iter().any(|tp| &tp.name == name) {
                                                if let Some(arg_type) = arg_types.get(i) {
                                                    type_param_map.insert(name.clone(), arg_type.clone());
                                                }
                                            }
                                        }
                                    }
                                    for tp in &type_params {
                                        if let Some(concrete_type) = type_param_map.get(&tp.name) {
                                            for bound in &tp.bounds {
                                                let type_name = self.type_name_for_trait_check(concrete_type);
                                                if let Some(type_name) = type_name {
                                                    let implements = self.env.type_traits
                                                        .get(&type_name)
                                                        .map(|traits| traits.contains(bound))
                                                        .unwrap_or(false);
                                                    if !implements {
                                                        self.diagnostics.push(
                                                            Diagnostic::error("F0012",
                                                                format!("type '{}' does not implement trait '{}'", type_name, bound),
                                                                *span,
                                                            ).with_help(format!(
                                                                "add `impl {} for {} {{ ... }}` to satisfy the trait bound on '{}'",
                                                                bound, type_name, fn_name,
                                                            )),
                                                        );
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        // Override return type for channel() calls to Channel<T>
                        if let Expr::Ident(fn_name, _) = callee.as_ref() {
                            if crate::registry::BuiltinFnRegistry::get(fn_name).map_or(false, |d| d.feature_id == "channels") {
                                if let Expr::Call { type_args, .. } = expr {
                                    if let Some(first_ta) = type_args.first() {
                                        let inner = self.resolve_type_expr(first_ta);
                                        return Type::Channel(Box::new(inner));
                                    }
                                }
                                return Type::Channel(Box::new(Type::Unknown));
                            }
                        }
                        *return_type.clone()
                    }
                    _ => {
                        if let Expr::Ident(name, _) = callee.as_ref() {
                            if let Some(def) = crate::registry::BuiltinFnRegistry::get(name) {
                                def.return_type.to_type()
                            } else {
                                Type::Unknown
                            }
                        } else if let Expr::MemberAccess { object, field, .. } = callee.as_ref() {
                            // Check for ptr bridge calls: string.from_ptr(...), ptr.from_string(...)
                            if let Expr::Ident(name, _) = object.as_ref() {
                                let arg_exprs: Vec<Expr> = args.iter().map(|a| a.value.clone()).collect();
                                if let Some(result) = self.check_ptr_bridge_call(name, field, &arg_exprs) {
                                    return result;
                                }
                            }
                            // Method call: object.method(args)
                            let obj_type = self.check_expr(object);
                            let effective_type = match &obj_type {
                                Type::Nullable(inner) => inner.as_ref().clone(),
                                other => other.clone(),
                            };
                            // Validate struct literal fields against the type's known fields.
                            // When the object is an identifier that is also a type alias (e.g.,
                            // model names like `User`), resolve the struct type for field checking.
                            let resolved_type = if let Type::Unknown = &effective_type {
                                if let Expr::Ident(name, _) = object.as_ref() {
                                    self.env.type_aliases.get(name).cloned()
                                } else {
                                    None
                                }
                            } else {
                                None
                            };
                            let check_type = resolved_type.as_ref().unwrap_or(&effective_type);
                            self.check_struct_literal_fields_in_args(check_type, args);
                            self.check_method_call(&effective_type, field, args.len(), *span)
                        } else {
                            Type::Unknown
                        }
                    }
                }
            }

            Expr::MemberAccess { object, field, span, .. } => {
                // Check if object is a type name used as static method target (e.g., User.create)
                let is_static_access = matches!(object.as_ref(), Expr::Ident(name, _) if {
                    self.env.type_aliases.contains_key(name) || self.env.enum_types.contains_key(name)
                });
                let obj_type = self.check_expr(object);
                // Unwrap optional/nullable for field access
                let effective_type = match &obj_type {
                    Type::Nullable(inner) => inner.as_ref(),
                    _ => &obj_type,
                };
                match effective_type {
                    Type::Struct { name: type_name, fields } => {
                        if let Some((_, ty)) = fields.iter().find(|(name, _)| name == field) {
                            ty.clone()
                        } else if is_static_access {
                            // Static method on a type (e.g., User.create) — allow
                            Type::Unknown
                        } else {
                            // Check if it's an instance method (registered via impl block)
                            let tn = type_name.as_deref().unwrap_or("");
                            if let Some(methods) = self.env.type_methods.get(tn) {
                                if methods.iter().any(|(n, _)| n == field) {
                                    return Type::Unknown;
                                }
                            }
                            // Check trait methods
                            if let Some(trait_names) = self.env.type_traits.get(tn) {
                                for trait_name in trait_names {
                                    if let Some(all_methods) = self.env.trait_all_methods.get(trait_name) {
                                        if all_methods.contains(&field.to_string()) {
                                            return Type::Unknown;
                                        }
                                    }
                                }
                            }
                            let known: Vec<&str> = fields.iter().map(|(n, _)| n.as_str()).collect();
                            let mut diag = Diagnostic::error(
                                "F0020",
                                format!("'{}' has no field '{}'", tn, field),
                                *span,
                            );
                            if let Some(suggestion) = crate::errors::did_you_mean(field, &known, 2) {
                                diag = diag.with_help(format!("did you mean '{}'?", suggestion));
                            } else if !known.is_empty() {
                                diag = diag.with_help(format!("available fields: {}", known.join(", ")));
                            }
                            self.diagnostics.push(diag);
                            Type::Error
                        }
                    }
                    Type::String => match field.as_str() {
                        "length" => Type::Int,
                        _ => Type::Unknown,
                    },
                    Type::List(_) => match field.as_str() {
                        "length" => Type::Int,
                        _ => Type::Unknown,
                    },
                    Type::Enum { name, variants } => {
                        // EnumName.variant → returns the enum type itself
                        if variants.iter().any(|v| v.name == *field) {
                            Type::Enum { name: name.clone(), variants: variants.clone() }
                        } else {
                            Type::Unknown
                        }
                    },
                    _ => Type::Unknown,
                }
            }

            Expr::Index { object, index, .. } => {
                let obj_type = self.check_expr(object);
                match &obj_type {
                    Type::List(inner) => *inner.clone(),
                    Type::String => Type::String,
                    Type::Ptr => self.check_ptr_index(index),
                    _ => Type::Unknown,
                }
            }

            Expr::Block(block) => {
                self.env.push_scope();
                let ty = self.check_block_type(block);
                self.env.pop_scope_silent();
                ty
            }



            Expr::Feature(fe) => self.check_feature_expr(fe),
        }
    }

    pub(crate) fn check_block_type(&mut self, block: &Block) -> Type {
        let mut last_type = Type::Void;
        for stmt in &block.statements {
            match stmt {
                Statement::Expr(expr) => {
                    last_type = self.check_expr(expr);
                }
                Statement::Return { value, .. } => {
                    if let Some(val) = value {
                        last_type = self.check_expr(val);
                    }
                    return last_type;
                }
                _ => {
                    self.check_statement(stmt);
                    last_type = Type::Void;
                }
            }
        }
        last_type
    }

    /// Public wrapper to infer the type of an expression (for forge why)
    pub fn infer_type(&mut self, expr: &Expr) -> Type {
        self.check_expr(expr)
    }

    /// Check if a type expression ends with `as partial`
    pub(crate) fn is_partial_type_expr(&self, type_expr: &TypeExpr) -> bool {
        matches!(type_expr, TypeExpr::AsPartial(_))
    }

    pub fn resolve_type_expr(&self, type_expr: &TypeExpr) -> Type {
        match type_expr {
            TypeExpr::Named(name) => self.env.resolve_type_name(name),
            TypeExpr::Generic { name, args } => {
                let resolved_args: Vec<Type> = args.iter().map(|a| self.resolve_type_expr(a)).collect();
                match name.as_str() {
                    "List" | "list" => {
                        if let Some(inner) = resolved_args.into_iter().next() {
                            Type::List(Box::new(inner))
                        } else {
                            Type::List(Box::new(Type::Unknown))
                        }
                    }
                    "Map" | "map" => {
                        let mut it = resolved_args.into_iter();
                        let key = it.next().unwrap_or(Type::Unknown);
                        let val = it.next().unwrap_or(Type::Unknown);
                        Type::Map(Box::new(key), Box::new(val))
                    }
                    "Result" => {
                        let mut it = resolved_args.into_iter();
                        let ok = it.next().unwrap_or(Type::Unknown);
                        let err = it.next().unwrap_or(Type::String);
                        Type::Result(Box::new(ok), Box::new(err))
                    }
                    _ => Type::Error,
                }
            }
            TypeExpr::Nullable(inner) => {
                Type::Nullable(Box::new(self.resolve_type_expr(inner)))
            }
            TypeExpr::Union(_) => Type::Unknown,
            TypeExpr::Tuple(elems) => {
                Type::Tuple(elems.iter().map(|e| self.resolve_type_expr(e)).collect())
            }
            TypeExpr::Function {
                params,
                return_type,
            } => Type::Function {
                params: params.iter().map(|p| self.resolve_type_expr(p)).collect(),
                return_type: Box::new(self.resolve_type_expr(return_type)),
            },
            TypeExpr::Struct { fields } => Type::Struct {
                name: None,
                fields: fields
                    .iter()
                    .map(|f| (f.name.clone(), self.resolve_type_expr(&f.type_expr)))
                    .collect(),
            },
            TypeExpr::Without { base, fields } => {
                let base_ty = self.resolve_type_expr(base);
                match base_ty {
                    Type::Struct { name, fields: base_fields } => Type::Struct {
                        name,
                        fields: base_fields
                            .into_iter()
                            .filter(|(n, _)| !fields.contains(n))
                            .collect(),
                    },
                    _ => Type::Error,
                }
            }
            TypeExpr::TypeWith { base, fields: new_fields } => {
                let base_ty = self.resolve_type_expr(base);
                match base_ty {
                    Type::Struct { name, fields: base_fields } => {
                        let mut result_fields = base_fields;
                        for f in new_fields {
                            let resolved = self.resolve_type_expr(&f.type_expr);
                            // Check if this field already exists — if so, replace it
                            if let Some(pos) = result_fields.iter().position(|(fname, _)| fname == &f.name) {
                                result_fields[pos] = (f.name.clone(), resolved);
                            } else {
                                result_fields.push((f.name.clone(), resolved));
                            }
                        }
                        Type::Struct {
                            name,
                            fields: result_fields,
                        }
                    }
                    _ => Type::Error,
                }
            }
            TypeExpr::Only { base, fields } => {
                let base_ty = self.resolve_type_expr(base);
                match base_ty {
                    Type::Struct { name, fields: base_fields } => Type::Struct {
                        name,
                        fields: base_fields
                            .into_iter()
                            .filter(|(n, _)| fields.contains(n))
                            .collect(),
                    },
                    _ => Type::Error,
                }
            }
            TypeExpr::AsPartial(base) => {
                let base_ty = self.resolve_type_expr(base);
                match base_ty {
                    Type::Struct { name, fields } => Type::Struct {
                        name,
                        fields: fields
                            .into_iter()
                            .map(|(n, ty)| {
                                let nullable = match &ty {
                                    Type::Nullable(_) => ty,
                                    _ => Type::Nullable(Box::new(ty)),
                                };
                                (n, nullable)
                            })
                            .collect(),
                    },
                    _ => Type::Error,
                }
            }
            TypeExpr::Intersection(left, right) => {
                let left_ty = self.resolve_type_expr(left);
                let right_ty = self.resolve_type_expr(right);
                match (left_ty, right_ty) {
                    (Type::Struct { name: name_l, fields: mut fields_l },
                     Type::Struct { fields: fields_r, .. }) => {
                        // Merge: add right fields that aren't in left
                        for (name, ty) in fields_r {
                            if !fields_l.iter().any(|(n, _)| n == &name) {
                                fields_l.push((name, ty));
                            }
                        }
                        Type::Struct { name: name_l, fields: fields_l }
                    }
                    _ => Type::Error,
                }
            }
        }
    }

    /// Check a variable binding (let/mut/const): resolve type annotation, check mismatch, define.
    fn check_binding(
        &mut self,
        name: &str,
        type_ann: Option<&TypeExpr>,
        type_ann_span: Option<Span>,
        value: &Expr,
        mutable: bool,
        span: Span,
    ) {
        let val_type = self.check_expr(value);
        let ty = if let Some(ann) = type_ann {
            let ann_type = self.resolve_type_expr(ann);
            self.check_type_mismatch_ctx(&ann_type, &val_type, span, type_ann_span, Some(value));
            ann_type
        } else {
            val_type
        };
        self.env.define_with_span(name.to_string(), ty, mutable, span);
    }

    pub(crate) fn check_type_mismatch_ctx(
        &mut self,
        expected: &Type,
        actual: &Type,
        span: Span,
        type_ann_span: Option<Span>,
        value_expr: Option<&Expr>,
    ) {
        if self.types_compatible(expected, actual) {
            return;
        }

        let suggestion = match (expected, actual) {
            (Type::String, Type::Int) => Some("string(value)"),
            (Type::String, Type::Float) => Some("string(value)"),
            (Type::String, Type::Bool) => Some("string(value)"),
            (Type::Int, Type::String) => Some("int(value)"),
            (Type::Float, Type::String) => Some("float(value)"),
            _ => None,
        };

        let mut diag = Diagnostic::error(
            "F0012",
            format!("type mismatch: expected {}, found {}", expected, actual),
            span,
        );

        // Add structured suggestion with type annotation span for autofix
        if let Some(ann_span) = type_ann_span {
            diag = diag.with_suggestion(
                format!("change type annotation to {}", actual),
                vec![Edit {
                    span: ann_span,
                    replacement: format!(": {}", actual),
                }],
                0.95,
            );
        }

        if let Some(conv) = suggestion {
            diag = diag.with_help(format!("try wrapping with {}", conv));
        }

        // Add "because" chain — show where the actual type came from
        if let Some(val_expr) = value_expr {
            match val_expr {
                Expr::Call { callee, .. } => {
                    if let Expr::Ident(fn_name, _) = callee.as_ref() {
                        if let Some(fn_span) = self.env.fn_spans.get(fn_name) {
                            diag = diag.with_label(
                                *fn_span,
                                format!("'{}' returns {} (declared here)", fn_name, actual),
                                LabelKind::Secondary,
                            );
                        }
                    }
                }
                Expr::Ident(var_name, _) => {
                    if let Some(info) = self.env.lookup(var_name) {
                        if let Some(def_span) = info.def_span {
                            diag = diag.with_label(
                                def_span,
                                format!("'{}' is {} (defined here)", var_name, actual),
                                LabelKind::Secondary,
                            );
                        }
                    }
                }
                _ => {}
            }
        }

        self.diagnostics.push(diag);
    }

    /// Check if two types are compatible, treating Unknown as a wildcard.
    /// This is more permissive than strict equality — it allows Unknown to match anything,
    /// even when nested inside Nullable, Result, List, etc.
    pub(crate) fn types_compatible(&self, expected: &Type, actual: &Type) -> bool {
        if matches!(expected, Type::Unknown | Type::Error) || matches!(actual, Type::Unknown | Type::Error) {
            return true;
        }
        if expected == actual {
            return true;
        }
        match (expected, actual) {
            // Nullable expected accepts non-nullable actual (e.g., string? accepts string)
            (Type::Nullable(e), a) if !matches!(a, Type::Nullable(_)) => self.types_compatible(e, a),
            (Type::Nullable(e), Type::Nullable(a)) => self.types_compatible(e, a),
            (Type::List(e), Type::List(a)) => self.types_compatible(e, a),
            (Type::Map(ek, ev), Type::Map(ak, av)) => {
                self.types_compatible(ek, ak) && self.types_compatible(ev, av)
            }
            (Type::Result(eok, eerr), Type::Result(aok, aerr)) => {
                self.types_compatible(eok, aok) && self.types_compatible(eerr, aerr)
            }
            (Type::Tuple(es), Type::Tuple(as_)) if es.len() == as_.len() => {
                es.iter().zip(as_.iter()).all(|(e, a)| self.types_compatible(e, a))
            }
            // Struct compatibility: named struct matches anonymous struct with compatible fields
            (Type::Struct { fields: ef, .. }, Type::Struct { fields: af, .. }) => {
                // Every field in actual must exist in expected with compatible type
                let all_actual_match = af.iter().all(|(an, at)| {
                    ef.iter().any(|(en, et)| {
                        en == an && self.types_compatible(et, at)
                    })
                });
                // Every non-nullable field in expected must be present in actual
                let all_required_present = ef.iter().all(|(en, et)| {
                    matches!(et, Type::Nullable(_))
                        || af.iter().any(|(an, _)| an == en)
                });
                all_actual_match && all_required_present
            }
            // `{}` is parsed as an empty block (Void) but accepted as an empty map/struct literal
            (Type::Map(_, _), Type::Void) => true,
            // ptr and string are interchangeable at FFI boundary
            (Type::Ptr, Type::String) | (Type::String, Type::Ptr) => true,
            // ptr accepts null (null literal is Nullable(Unknown))
            (Type::Ptr, Type::Nullable(_)) => true,
            // Function types are compatible with ptr (function pointers at FFI boundary)
            (Type::Ptr, Type::Function { .. }) | (Type::Function { .. }, Type::Ptr) => true,
            // DynTrait accepts any type that implements the trait
            (Type::DynTrait(trait_name), actual) => {
                if let Some(type_name) = self.type_name_for_trait_check(actual) {
                    self.env.type_traits.get(&type_name)
                        .map_or(false, |traits| traits.contains(trait_name))
                } else {
                    false
                }
            }
            // DynTrait matches DynTrait of the same name
            (a, b) if a == b => true,
            _ => false,
        }
    }

    /// Format function signature for error messages
    fn type_name_for_trait_check(&self, ty: &Type) -> Option<String> {
        match ty {
            Type::Struct { name: Some(n), .. } => Some(n.clone()),
            Type::Int => Some("int".to_string()),
            Type::Float => Some("float".to_string()),
            Type::String => Some("string".to_string()),
            Type::Bool => Some("bool".to_string()),
            _ => None,
        }
    }

    pub(crate) fn format_fn_signature(&self, fn_name: &str, params: &[Type]) -> String {
        let params_str: Vec<String> = params.iter().enumerate().map(|(i, t)| {
            format!("arg{}: {}", i + 1, t)
        }).collect();
        format!("{}({})", fn_name, params_str.join(", "))
    }

    /// Generate example function call with placeholder values
    pub(crate) fn format_fn_example(&self, fn_name: &str, params: &[Type]) -> String {
        let args: Vec<String> = params.iter().map(|t| placeholder_for_type(t)).collect();
        format!("{}({})", fn_name, args.join(", "))
    }

    /// Check method calls on known types and return the result type.
    /// Emits an error diagnostic for undefined methods.
    fn check_method_call(&mut self, obj_type: &Type, method: &str, _arg_count: usize, span: Span) -> Type {
        match obj_type {
            Type::String => self.check_string_method_call(method, span),
            Type::List(inner) => self.check_list_method_call(inner, method, span),
            Type::Map(key_type, val_type) => self.check_map_method_call(key_type, val_type, method, span),
            Type::Struct { name: Some(type_name), .. } => {
                // Check if method exists on this type (from impl blocks)
                if let Some(methods) = self.env.type_methods.get(type_name) {
                    if let Some((_, ret_type)) = methods.iter().find(|(n, _)| n == method) {
                        return ret_type.clone();
                    }
                }
                // Check trait methods (all methods, including defaults)
                if let Some(trait_names) = self.env.type_traits.get(type_name) {
                    for trait_name in trait_names {
                        if let Some(all_methods) = self.env.trait_all_methods.get(trait_name) {
                            if all_methods.contains(&method.to_string()) {
                                return Type::Unknown; // trait method exists, type unknown
                            }
                        }
                    }
                }
                // Only report error if we have tracked methods for this type
                // (otherwise it may have package-generated methods)
                let has_tracked = self.env.type_methods.contains_key(type_name)
                    || self.env.type_traits.contains_key(type_name);
                if has_tracked {
                    let mut known_methods: Vec<String> = Vec::new();
                    if let Some(methods) = self.env.type_methods.get(type_name) {
                        known_methods.extend(methods.iter().map(|(n, _)| n.clone()));
                    }
                    let known_refs: Vec<&str> = known_methods.iter().map(|s| s.as_str()).collect();
                    let mut diag = Diagnostic::error(
                        "F0020",
                        format!("'{}' has no method '{}'", type_name, method),
                        span,
                    );
                    if let Some(suggestion) = crate::errors::did_you_mean(method, &known_refs, 2) {
                        diag = diag.with_help(format!("did you mean '{}'?", suggestion));
                    } else if !known_methods.is_empty() {
                        diag = diag.with_help(format!("available methods: {}", known_methods.join(", ")));
                    }
                    self.diagnostics.push(diag);
                    Type::Error
                } else {
                    Type::Unknown
                }
            }
            // For other types (unknown, generics), don't error
            _ => Type::Unknown,
        }
    }

    /// When a static method is called on a named struct type (e.g., `User.where({...})`),
    /// check struct literal arguments for field names that look like typos of known fields.
    /// Only emits an error when a field is close (edit distance <= 2) to a known field,
    /// since unrecognized fields may be legitimate query parameters or metadata.
    fn check_struct_literal_fields_in_args(&mut self, obj_type: &Type, args: &[CallArg]) {
        // Only check for named struct types (models, type aliases)
        let (type_name, type_fields) = match obj_type {
            Type::Struct { name: Some(name), fields } => (name.clone(), fields.clone()),
            _ => return,
        };

        // Exclude internal fields (prefixed with __) from known names
        let known_names: Vec<&str> = type_fields.iter()
            .map(|(n, _)| n.as_str())
            .filter(|n| !n.starts_with("__"))
            .collect();

        for arg in args {
            let struct_data = if let Expr::Feature(fe) = &arg.value {
                if fe.kind == "StructLit" {
                    crate::feature_data!(fe, crate::features::structs::types::StructLitData)
                } else {
                    None
                }
            } else {
                None
            };
            if let Some(data) = struct_data {
                let lit_fields = &data.fields;
                let lit_span = &data.span;
                for (field_name, field_val) in lit_fields {
                    // Skip exact matches — field is valid
                    if type_fields.iter().any(|(n, _)| n == field_name) {
                        continue;
                    }
                    // Only report if there's a close match (likely typo).
                    // Completely unrecognized fields are silently accepted
                    // since they may be query parameters, metadata, etc.
                    if let Some(suggestion) = crate::errors::did_you_mean(field_name, &known_names, 2) {
                        let field_span = field_val.span();
                        let diag = Diagnostic::error(
                            "F0020",
                            format!("'{}' is not a field on {}", field_name, type_name),
                            *lit_span,
                        )
                        .with_label(field_span, format!("'{}' is not a field on {}", field_name, type_name), LabelKind::Primary)
                        .with_help(format!("did you mean '{}'?", suggestion));
                        self.diagnostics.push(diag);
                    }
                }
            }
        }
    }
}

/// Check if a TypeExpr references a given type name (for detecting self-referential enums).
pub fn type_expr_references_name(expr: &TypeExpr, name: &str) -> bool {
    match expr {
        TypeExpr::Named(n) => n == name,
        TypeExpr::Generic { name: _, args } => args.iter().any(|a| type_expr_references_name(a, name)),
        TypeExpr::Nullable(inner) => type_expr_references_name(inner, name),
        TypeExpr::Union(variants) => variants.iter().any(|v| type_expr_references_name(v, name)),
        TypeExpr::Tuple(elems) => elems.iter().any(|e| type_expr_references_name(e, name)),
        TypeExpr::Function { params, return_type } => {
            params.iter().any(|p| type_expr_references_name(p, name))
                || type_expr_references_name(return_type, name)
        }
        TypeExpr::Struct { fields } => fields.iter().any(|f| type_expr_references_name(&f.type_expr, name)),
        TypeExpr::Without { base, .. } => type_expr_references_name(base, name),
        TypeExpr::TypeWith { base, fields } => {
            type_expr_references_name(base, name)
                || fields.iter().any(|f| type_expr_references_name(&f.type_expr, name))
        }
        TypeExpr::Only { base, .. } => type_expr_references_name(base, name),
        TypeExpr::AsPartial(inner) => type_expr_references_name(inner, name),
        TypeExpr::Intersection(a, b) => {
            type_expr_references_name(a, name) || type_expr_references_name(b, name)
        }
    }
}
