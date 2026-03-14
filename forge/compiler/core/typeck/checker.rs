use crate::errors::Diagnostic;
use crate::errors::diagnostic::{Edit, LabelKind};
use crate::errors::suggestions::placeholder_for_type;
use crate::lexer::Span;
use crate::parser::ast::*;
use crate::typeck::env::TypeEnv;
use crate::typeck::types::{EnumVariantType, FieldAnnotation, Type};

pub struct TypeChecker {
    pub env: TypeEnv,
    pub diagnostics: Vec<Diagnostic>,
    pub current_fn_return_type: Option<Type>,
    /// Provider-declared annotations: (annotation_name, target, component_name)
    /// Populated from component template `annotation <target> <name>(...)` declarations.
    pub provider_annotations: Vec<(String, String, String)>,
}

impl TypeChecker {
    pub fn new() -> Self {
        Self {
            env: TypeEnv::new(),
            diagnostics: Vec::new(),
            current_fn_return_type: None,
            provider_annotations: Vec::new(),
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
            }
            Statement::EnumDecl {
                name, variants, ..
            } => {
                let variant_types: Vec<EnumVariantType> = variants
                    .iter()
                    .map(|v| EnumVariantType {
                        name: v.name.clone(),
                        fields: v
                            .fields
                            .iter()
                            .map(|f| {
                                let ty = f
                                    .type_ann
                                    .as_ref()
                                    .map(|t| self.resolve_type_expr(t))
                                    .unwrap_or(Type::Unknown);
                                (f.name.clone(), ty)
                            })
                            .collect(),
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
                // Extract namespace from provider extern fn names (forge_<ns>_<method>)
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
            Statement::Let {
                name,
                type_ann,
                type_ann_span,
                value,
                span,
                ..
            } => {
                let val_type = self.check_expr(value);
                let ty = if let Some(ann) = type_ann {
                    let ann_type = self.resolve_type_expr(ann);
                    self.check_type_mismatch_ctx(&ann_type, &val_type, *span, *type_ann_span, Some(value));
                    ann_type
                } else {
                    val_type
                };
                self.env.define_with_span(name.clone(), ty, false, *span);
            }
            Statement::Mut {
                name,
                type_ann,
                type_ann_span,
                value,
                span,
                ..
            } => {
                let val_type = self.check_expr(value);
                let ty = if let Some(ann) = type_ann {
                    let ann_type = self.resolve_type_expr(ann);
                    self.check_type_mismatch_ctx(&ann_type, &val_type, *span, *type_ann_span, Some(value));
                    ann_type
                } else {
                    val_type
                };
                self.env.define_with_span(name.clone(), ty, true, *span);
            }
            Statement::Const {
                name,
                type_ann,
                type_ann_span,
                value,
                span,
                ..
            } => {
                let val_type = self.check_expr(value);
                let ty = if let Some(ann) = type_ann {
                    let ann_type = self.resolve_type_expr(ann);
                    self.check_type_mismatch_ctx(&ann_type, &val_type, *span, *type_ann_span, Some(value));
                    ann_type
                } else {
                    val_type
                };
                self.env.define_with_span(name.clone(), ty, false, *span);
            }
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
                // Check field assignment on immutable variable: p.x = val
                if let Expr::MemberAccess { object, .. } = target {
                    // Walk through nested member accesses to find the root variable
                    let mut root = object.as_ref();
                    while let Expr::MemberAccess { object: inner, .. } = root {
                        root = inner.as_ref();
                    }
                    if let Expr::Ident(name, _) = root {
                        if let Some(info) = self.env.lookup_and_mark_used(name) {
                            if !info.mutable {
                                self.diagnostics.push(Diagnostic::error(
                                    "F0013",
                                    format!("cannot assign to field of immutable variable '{}'", name),
                                    *span,
                                ));
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
                self.check_expr(body);
            }
            Statement::EnumDecl { .. } | Statement::TypeDecl { .. } => {
                // Already handled in register_top_level
            }
            Statement::Use { .. }
            | Statement::TraitDecl { .. }
            | Statement::ImplBlock { .. }
            | Statement::ExternFn { .. }
            | Statement::ComponentBlock(_)
            | Statement::ComponentTemplateDef(_) => {
                // Phase 2/3 constructs; extern fns are declarations only
            }
            Statement::SpecBlock { body, .. } => {
                self.check_spec_block(body);
            }
            Statement::GivenBlock { body, .. } => {
                self.check_given_block(body);
            }
            Statement::ThenBlock { body, .. } => {
                self.check_then_block(body);
            }
            Statement::ThenShouldFail { body, .. } => {
                self.check_then_should_fail(body);
            }
            Statement::ThenShouldFailWith { body, .. } => {
                self.check_then_should_fail_with(body);
            }
            Statement::ThenWhere { table, body, .. } => {
                self.check_then_where(table, body);
            }
            Statement::SkipBlock { .. } | Statement::TodoStmt { .. } => {
                // No type checking needed
            }
            Statement::Select { arms, .. } => {
                for arm in arms {
                    self.check_expr(&arm.channel);
                    if let Some(guard) = &arm.guard {
                        self.check_expr(guard);
                    }
                    // Register the binding variable in a new scope for the arm body
                    self.env.push_scope();
                    if let Pattern::Ident(name, _) = &arm.binding {
                        self.env.define(name.clone(), Type::Unknown, false);
                    }
                    self.check_block(&arm.body);
                    self.env.pop_scope_silent();
                }
            }
            Statement::Feature(fe) => {
                self.check_feature_stmt(fe);
            }
        }
    }

    /// Dispatch a feature-owned statement to the appropriate feature's checker.
    pub(crate) fn check_feature_stmt(&mut self, fe: &crate::feature::FeatureStmt) {
        match fe.feature_id {
            "defer" => self.check_defer_feature(fe),
            "select_syntax" => self.check_select_feature(fe),
            "for_loops" => self.check_for_feature(fe),
            "while_loops" => self.check_while_loops_feature(fe),
            "enums" => self.check_enum_feature(fe),
            "variables" => self.check_variables_feature(fe),
            "functions" => self.check_functions_feature(fe),
            "structs" => self.check_structs_feature(fe),
            "traits" => self.check_traits_feature(fe),
            "imports" => self.check_imports_feature(fe),
            _ => {} // Unknown feature — no-op
        }
    }

    /// Dispatch a feature-owned expression to the appropriate feature's checker.
    pub(crate) fn check_feature_expr(&mut self, fe: &crate::feature::FeatureExpr) -> Type {
        match fe.feature_id {
            "spawn" => self.check_spawn_feature(fe),
            "ranges" => self.check_range_feature(fe),
            "is_keyword" => self.check_is_feature(fe),
            "with_expression" => self.check_with_feature(fe),
            "pipe_operator" => self.check_pipe_feature(fe),
            "shell_shorthand" => self.check_dollar_exec_feature(fe),
            "table_literal" => self.check_table_lit_feature(fe),
            "closures" => self.check_closure_feature(fe),
            "pattern_matching" => self.check_match_feature(fe),
            "channels" => self.check_channel_feature(fe),
            "if_else" => self.check_if_feature(fe),
            "null_safety" => {
                match fe.kind {
                    "NullCoalesce" => self.check_null_coalesce_feature(fe),
                    "NullPropagate" => self.check_null_propagate_feature(fe),
                    "ForceUnwrap" => {
                        use crate::features::null_safety::types::ForceUnwrapData;
                        if let Some(data) = crate::feature_data!(fe, ForceUnwrapData) {
                            let inner = self.check_expr(&data.operand);
                            match inner {
                                Type::Nullable(t) => *t,
                                other => other,
                            }
                        } else {
                            Type::Unknown
                        }
                    }
                    _ => Type::Unknown,
                }
            }
            "error_propagation" => {
                match fe.kind {
                    "ErrorPropagate" => self.check_error_propagate_feature(fe),
                    "OkExpr" => self.check_ok_expr_feature(fe),
                    "ErrExpr" => self.check_err_expr_feature(fe),
                    "Catch" => self.check_catch_feature(fe),
                    _ => Type::Unknown,
                }
            }
            "structs" => self.check_struct_lit_feature(fe),
            "tuples" => self.check_tuple_lit_feature(fe),
            "collections" => {
                match fe.kind {
                    "ListLit" => self.check_list_lit_feature(fe),
                    "MapLit" => self.check_map_lit_feature(fe),
                    _ => Type::Unknown,
                }
            }
            _ => Type::Unknown,
        }
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
            Expr::StringLit(_, _) => Type::String,
            Expr::BoolLit(_, _) => Type::Bool,
            Expr::NullLit(_) => Type::Nullable(Box::new(Type::Unknown)),
            Expr::TemplateLit { .. } => Type::String,

            Expr::Ident(name, span) => {
                if let Some(info) = self.env.lookup_and_mark_used(name) {
                    info.ty.clone()
                } else if let Some(ty) = self.env.lookup_function(name).cloned() {
                    ty
                } else if name.starts_with('.') {
                    Type::Unknown
                } else if name.starts_with("__destructure") {
                    Type::Void
                } else if self.env.enum_types.contains_key(name) {
                    // Enum name used as a namespace (e.g., Shape.circle)
                    self.env.enum_types[name].clone()
                } else if self.env.type_aliases.contains_key(name) {
                    // Named type used as constructor (e.g., Point { x: 1 })
                    self.env.type_aliases[name].clone()
                } else if self.env.namespaces.contains(name) {
                    // Provider namespace (e.g., json, fs, process)
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
                }
            }

            Expr::Unary { op, operand, .. } => {
                let operand_type = self.check_expr(operand);
                match op {
                    UnaryOp::Not => Type::Bool,
                    UnaryOp::Neg => operand_type,
                }
            }

            Expr::Call { callee, args, span, .. } => {
                let callee_type = self.check_expr(callee);
                let arg_types: Vec<Type> = args.iter().map(|arg| self.check_expr(&arg.value)).collect();

                match &callee_type {
                    Type::Function { params, return_type } => {
                        // Check argument count
                        if let Expr::Ident(fn_name, _) = callee.as_ref() {
                            let is_variadic = matches!(fn_name.as_str(), "println" | "print" | "string" | "assert" | "sleep" | "channel" | "datetime_now" | "datetime_format" | "datetime_parse" | "process_uptime" | "query_gt" | "query_gte" | "query_lt" | "query_lte" | "query_between" | "query_like");
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
                            if fn_name == "validate" && args.len() >= 2 {
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
                        }
                        // Override return type for channel() calls to Channel<T>
                        if let Expr::Ident(fn_name, _) = callee.as_ref() {
                            if fn_name == "channel" {
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
                            match name.as_str() {
                                "println" | "print" => Type::Void,
                                "string" => Type::String,
                                "datetime_now" | "datetime_parse" | "process_uptime" => Type::Int,
                                "datetime_format" | "query_gt" | "query_gte" | "query_lt" | "query_lte" | "query_between" | "query_like" => Type::String,
                                _ => Type::Unknown,
                            }
                        } else if let Expr::MemberAccess { object, field, .. } = callee.as_ref() {
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

            Expr::Index { object, .. } => {
                let obj_type = self.check_expr(object);
                match &obj_type {
                    Type::List(inner) => *inner.clone(),
                    Type::String => Type::String,
                    _ => Type::Unknown,
                }
            }

            Expr::Pipe { left, right, .. } => self.check_pipe(left, right),

            Expr::Closure {
                params, body, ..
            } => {
                self.env.push_scope();
                let param_types: Vec<Type> = params
                    .iter()
                    .map(|p| {
                        let ty = p
                            .type_ann
                            .as_ref()
                            .map(|t| self.resolve_type_expr(t))
                            .unwrap_or(Type::Unknown);
                        self.env.define(p.name.clone(), ty.clone(), false);
                        ty
                    })
                    .collect();
                let ret_type = self.check_expr(body);
                self.env.pop_scope_silent();
                Type::Function {
                    params: param_types,
                    return_type: Box::new(ret_type),
                }
            }

            Expr::If {
                condition,
                then_branch,
                else_branch,
                ..
            } => {
                self.check_expr(condition);
                self.env.push_scope();
                let then_type = self.check_block_type(then_branch);
                self.env.pop_scope_silent();
                if let Some(else_b) = else_branch {
                    self.env.push_scope();
                    let _else_type = self.check_block_type(else_b);
                    self.env.pop_scope_silent();
                }
                then_type
            }

            Expr::Match {
                subject, arms, ..
            } => {
                self.check_expr(subject);
                let mut result_type = Type::Unknown;
                for arm in arms {
                    if let Some(guard) = &arm.guard {
                        self.check_expr(guard);
                    }
                    self.env.push_scope();
                    self.bind_pattern(&arm.pattern);
                    let arm_type = self.check_expr(&arm.body);
                    if result_type == Type::Unknown {
                        result_type = arm_type;
                    }
                    self.env.pop_scope_silent();
                }
                result_type
            }

            Expr::Block(block) => {
                self.env.push_scope();
                let ty = self.check_block_type(block);
                self.env.pop_scope_silent();
                ty
            }

            Expr::NullCoalesce { left, right, .. } => {
                let left_type = self.check_expr(left);
                let right_type = self.check_expr(right);
                match &left_type {
                    Type::Nullable(inner) => *inner.clone(),
                    _ => right_type,
                }
            }

            Expr::NullPropagate { object, field, .. } => {
                let obj_type = self.check_expr(object);
                let inner = match &obj_type {
                    Type::Nullable(inner) => inner.as_ref(),
                    _ => &obj_type,
                };
                let field_type = match inner {
                    Type::Struct { fields, .. } => {
                        fields
                            .iter()
                            .find(|(name, _)| name == field)
                            .map(|(_, ty)| ty.clone())
                            .unwrap_or(Type::Unknown)
                    }
                    Type::String => match field.as_str() {
                        "length" => Type::Int,
                        _ => Type::Unknown,
                    },
                    _ => Type::Unknown,
                };
                Type::Nullable(Box::new(field_type))
            }

            Expr::ErrorPropagate { operand, .. } => {
                let op_type = self.check_expr(operand);
                match &op_type {
                    Type::Result(ok, _) => *ok.clone(),
                    _ => op_type,
                }
            }

            Expr::With { base, updates, .. } => {
                let base_type = self.check_expr(base);
                for (_, val) in updates {
                    self.check_expr(val);
                }
                base_type
            }

            Expr::Range { start, .. } => {
                let start_type = self.check_expr(start);
                Type::Range(Box::new(start_type))
            }

            Expr::OkExpr { value, .. } => {
                let val_type = self.check_expr(value);
                Type::Result(Box::new(val_type), Box::new(Type::String))
            }

            Expr::ErrExpr { value, .. } => {
                let val_type = self.check_expr(value);
                Type::Result(Box::new(Type::Unknown), Box::new(val_type))
            }

            Expr::Catch { expr, handler, binding, .. } => {
                let expr_type = self.check_expr(expr);
                self.env.push_scope();
                if let Some(name) = binding {
                    self.env.define(name.clone(), Type::String, false);
                }
                let handler_type = self.check_block_type(handler);
                self.env.pop_scope_silent();
                match &expr_type {
                    Type::Result(ok, _) => *ok.clone(),
                    _ => handler_type,
                }
            }

            Expr::ListLit { elements, .. } => {
                let elem_type = if let Some(first) = elements.first() {
                    self.check_expr(first)
                } else {
                    Type::Unknown
                };
                for elem in elements.iter().skip(1) {
                    self.check_expr(elem);
                }
                Type::List(Box::new(elem_type))
            }

            Expr::MapLit { entries, .. } => {
                let (key_type, val_type) = if let Some((k, v)) = entries.first() {
                    (self.check_expr(k), self.check_expr(v))
                } else {
                    (Type::Unknown, Type::Unknown)
                };
                Type::Map(Box::new(key_type), Box::new(val_type))
            }

            Expr::StructLit { name: struct_name, fields, span: lit_span } => {
                // Check for duplicate field names
                {
                    let mut seen_fields: std::collections::HashSet<&str> = std::collections::HashSet::new();
                    for (field_name, field_val) in fields {
                        if !seen_fields.insert(field_name.as_str()) {
                            self.diagnostics.push(Diagnostic::error(
                                "F0012",
                                format!("duplicate field '{}' in struct literal", field_name),
                                field_val.span(),
                            ));
                        }
                    }
                }

                let field_types: Vec<(String, Type)> = fields
                    .iter()
                    .map(|(name, val)| (name.clone(), self.check_expr(val)))
                    .collect();

                // For named struct literals (e.g., `User { naem: "alice" }`),
                // validate field names and types against the known type fields.
                if let Some(type_name) = struct_name {
                    let resolved = self.env.resolve_type_name(type_name);
                    if let Type::Struct { fields: type_fields, .. } = &resolved {
                        let known_names: Vec<&str> = type_fields.iter().map(|(n, _)| n.as_str()).collect();
                        for (field_name, field_val) in fields {
                            if let Some((_, expected_ty)) = type_fields.iter().find(|(n, _)| n == field_name) {
                                // Check field type matches declared type
                                let actual_ty = field_types.iter()
                                    .find(|(n, _)| n == field_name)
                                    .map(|(_, t)| t.clone())
                                    .unwrap_or(Type::Unknown);
                                if !self.types_compatible(expected_ty, &actual_ty) {
                                    let field_span = field_val.span();
                                    self.diagnostics.push(Diagnostic::error(
                                        "F0012",
                                        format!(
                                            "type mismatch for field '{}': expected {}, got {}",
                                            field_name, expected_ty, actual_ty
                                        ),
                                        field_span,
                                    ));
                                }
                            } else {
                                let field_span = field_val.span();
                                let mut diag = Diagnostic::error(
                                    "F0020",
                                    format!("'{}' is not a field on {}", field_name, type_name),
                                    *lit_span,
                                )
                                .with_label(field_span, format!("'{}' is not a field on {}", field_name, type_name), LabelKind::Primary);

                                if let Some(suggestion) = crate::errors::did_you_mean(field_name, &known_names, 2) {
                                    diag = diag.with_help(format!("did you mean '{}'?", suggestion));
                                } else {
                                    diag = diag.with_help(format!("available fields on {}: {}", type_name, known_names.join(", ")));
                                }
                                self.diagnostics.push(diag);
                            }
                        }
                    }
                }

                Type::Struct {
                    name: struct_name.clone(),
                    fields: field_types,
                }
            }

            Expr::TupleLit { elements, .. } => {
                let types: Vec<Type> = elements.iter().map(|e| self.check_expr(e)).collect();
                Type::Tuple(types)
            }

            Expr::ChannelSend { channel, value, .. } => {
                self.check_channel_send(channel, value)
            }
            Expr::ChannelReceive { channel, .. } => {
                self.check_channel_receive(channel)
            }
            Expr::SpawnBlock { body, .. } => {
                self.check_block(body);
                Type::Unknown
            }
            Expr::DollarExec { parts, .. } => {
                for part in parts {
                    if let crate::parser::ast::TemplatePart::Expr(e) = part {
                        self.check_expr(e);
                    }
                }
                Type::String
            }
            Expr::TaggedTemplate { tag, parts, type_param, span } => {
                let base_type = self.check_tagged_template(tag, parts, span);
                if let Some(tp) = type_param {
                    self.resolve_type_expr(tp)
                } else {
                    base_type
                }
            }
            Expr::Is { value, .. } => {
                self.check_expr(value);
                Type::Bool
            }
            Expr::TableLit { columns, rows, .. } => {
                self.check_table_literal(columns, rows)
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
    // bind_destructure_pattern: extracted to features/
    // bind_pattern: extracted to features/

    /// Public wrapper to infer the type of an expression (for forge why)
    pub fn infer_type(&mut self, expr: &Expr) -> Type {
        self.check_expr(expr)
    }

    /// Extract field annotations from a type expression, following type operators.
    /// Returns vec of (field_name, annotations) for fields that have annotations.
    pub(crate) fn extract_type_annotations(&mut self, type_expr: &TypeExpr) -> Vec<(String, Vec<FieldAnnotation>)> {
        use crate::typeck::types::FieldAnnotation;
        use crate::typeck::env::TypeEnv;

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

                        // ── Provider annotation outside its component context (F0074) ──
                        // Check against dynamically registered provider annotations.
                        // Falls back to a hardcoded list for backward compatibility when
                        // no provider declarations are loaded (e.g., forge check without providers).
                        let is_provider_ann = if !self.provider_annotations.is_empty() {
                            self.provider_annotations.iter().any(|(name, target, _)| {
                                name == ann_name && (target == "field" || target == "type")
                            })
                        } else {
                            const FALLBACK_PROVIDER_ANNOTATIONS: &[&str] = &["primary", "auto_increment", "unique", "hidden", "owner"];
                            FALLBACK_PROVIDER_ANNOTATIONS.contains(&ann_name)
                        };
                        if is_provider_ann {
                            // Find the component name for a better error message
                            let component_name = self.provider_annotations.iter()
                                .find(|(name, _, _)| name == ann_name)
                                .map(|(_, _, comp)| comp.as_str())
                                .unwrap_or("model");
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

    /// Check if a type expression ends with `as partial`
    pub(crate) fn is_partial_type_expr(&self, type_expr: &TypeExpr) -> bool {
        matches!(type_expr, TypeExpr::AsPartial(_))
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

    fn format_field_annotation_args(args: &[crate::typeck::types::AnnotationArg]) -> String {
        use crate::typeck::types::AnnotationArg;
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
                    "Map" => {
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
                    .map(|(name, ty, _annotations)| (name.clone(), self.resolve_type_expr(ty)))
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
                        for (n, ty, _annotations) in new_fields {
                            let resolved = self.resolve_type_expr(ty);
                            // Check if this field already exists — if so, replace it
                            if let Some(pos) = result_fields.iter().position(|(fname, _)| fname == n) {
                                result_fields[pos] = (n.clone(), resolved);
                            } else {
                                result_fields.push((n.clone(), resolved));
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

    pub(crate) fn check_type_mismatch(&mut self, expected: &Type, actual: &Type, span: Span) {
        self.check_type_mismatch_ctx(expected, actual, span, None, None);
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
            // ptr and string are interchangeable at FFI boundary
            (Type::Ptr, Type::String) | (Type::String, Type::Ptr) => true,
            // Function types are compatible with ptr (function pointers at FFI boundary)
            (Type::Ptr, Type::Function { .. }) | (Type::Function { .. }, Type::Ptr) => true,
            _ => false,
        }
    }

    /// Format function signature for error messages
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
            Type::String => {
                match method {
                    "upper" | "lower" | "trim" | "replace" | "repeat" => Type::String,
                    "contains" | "starts_with" | "ends_with" => Type::Bool,
                    "parse_int" => Type::Int,
                    "split" => Type::List(Box::new(Type::String)),
                    "length" => Type::Int,
                    _ => {
                        let known = ["upper", "lower", "trim", "contains", "split",
                            "starts_with", "ends_with", "replace", "parse_int", "repeat", "length"];
                        let mut diag = Diagnostic::error(
                            "F0020",
                            format!("string has no method '{}'", method),
                            span,
                        );
                        if let Some(suggestion) = crate::errors::did_you_mean(method, &known, 2) {
                            diag = diag.with_help(format!("did you mean '{}'?", suggestion));
                        } else {
                            diag = diag.with_help(format!("available string methods: {}", known.join(", ")));
                        }
                        self.diagnostics.push(diag);
                        Type::Error
                    }
                }
            }
            Type::List(inner) => {
                match method {
                    "push" | "each" | "sorted" | "reverse" | "flat" | "dedup"
                    | "take" | "skip" | "chunks" | "windows" => {
                        match method {
                            "push" | "each" => Type::Void,
                            "sorted" | "reverse" | "flat" | "dedup"
                            | "take" | "skip" => Type::List(inner.clone()),
                            "chunks" | "windows" => Type::List(Box::new(Type::List(inner.clone()))),
                            _ => Type::Unknown,
                        }
                    }
                    "filter" | "map" => Type::List(inner.clone()),
                    "find" | "find_map" => Type::Nullable(inner.clone()),
                    "reduce" => *inner.clone(),
                    "sum" => Type::Int,
                    "join" => Type::String,
                    "contains" | "any" | "all" => Type::Bool,
                    "enumerate" => Type::List(Box::new(Type::Tuple(vec![Type::Int, *inner.clone()]))),
                    "length" | "clone" => {
                        match method {
                            "length" => Type::Int,
                            "clone" => Type::List(inner.clone()),
                            _ => Type::Unknown,
                        }
                    }
                    _ => {
                        let known = ["push", "filter", "map", "find", "reduce", "sum",
                            "join", "each", "sorted", "contains", "any", "all",
                            "enumerate", "length", "clone", "reverse", "flat",
                            "dedup", "take", "skip", "chunks", "windows", "find_map"];
                        let mut diag = Diagnostic::error(
                            "F0020",
                            format!("list has no method '{}'", method),
                            span,
                        );
                        if let Some(suggestion) = crate::errors::did_you_mean(method, &known, 2) {
                            diag = diag.with_help(format!("did you mean '{}'?", suggestion));
                        } else {
                            diag = diag.with_help(format!("available list methods: {}", known.join(", ")));
                        }
                        self.diagnostics.push(diag);
                        Type::Error
                    }
                }
            }
            Type::Map(key_type, val_type) => {
                match method {
                    "get" => Type::Nullable(val_type.clone()),
                    "keys" => Type::List(key_type.clone()),
                    "values" => Type::List(val_type.clone()),
                    "contains_key" | "has" => Type::Bool,
                    "entries" => Type::List(Box::new(Type::Tuple(vec![*key_type.clone(), *val_type.clone()]))),
                    _ => {
                        let known = ["get", "keys", "values", "contains_key", "has", "entries"];
                        let mut diag = Diagnostic::error(
                            "F0020",
                            format!("map has no method '{}'", method),
                            span,
                        );
                        if let Some(suggestion) = crate::errors::did_you_mean(method, &known, 2) {
                            diag = diag.with_help(format!("did you mean '{}'?", suggestion));
                        } else {
                            diag = diag.with_help(format!("available map methods: {}", known.join(", ")));
                        }
                        self.diagnostics.push(diag);
                        Type::Error
                    }
                }
            }
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
                // (otherwise it may have provider-generated methods)
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

        let known_names: Vec<&str> = type_fields.iter().map(|(n, _)| n.as_str()).collect();

        for arg in args {
            if let Expr::StructLit { fields: lit_fields, span: lit_span, .. } = &arg.value {
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
