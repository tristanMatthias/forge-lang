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
}

impl TypeChecker {
    pub fn new() -> Self {
        Self {
            env: TypeEnv::new(),
            diagnostics: Vec::new(),
            current_fn_return_type: None,
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
            Statement::TypeDecl { name, value, .. } => {
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
            Statement::Return { value, .. } => {
                if let Some(val) = value {
                    self.check_expr(val);
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
                for arg in args {
                    self.check_expr(&arg.value);
                }

                match &callee_type {
                    Type::Function { params, return_type } => {
                        // Check argument count
                        if let Expr::Ident(fn_name, _) = callee.as_ref() {
                            if args.len() != params.len()
                                && !matches!(fn_name.as_str(), "println" | "print" | "string" | "assert" | "sleep" | "channel")
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
                        *return_type.clone()
                    }
                    _ => {
                        if let Expr::Ident(name, _) = callee.as_ref() {
                            match name.as_str() {
                                "println" | "print" => Type::Void,
                                "string" => Type::String,
                                _ => Type::Unknown,
                            }
                        } else {
                            Type::Unknown
                        }
                    }
                }
            }

            Expr::MemberAccess { object, field, .. } => {
                let obj_type = self.check_expr(object);
                // Unwrap optional/nullable for field access
                let effective_type = match &obj_type {
                    Type::Nullable(inner) => inner.as_ref(),
                    _ => &obj_type,
                };
                match effective_type {
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
                    Type::List(_) => match field.as_str() {
                        "length" => Type::Int,
                        _ => Type::Unknown,
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

            Expr::StructLit { fields, .. } => {
                let field_types: Vec<(String, Type)> = fields
                    .iter()
                    .map(|(name, val)| (name.clone(), self.check_expr(val)))
                    .collect();
                Type::Struct {
                    name: None,
                    fields: field_types,
                }
            }

            Expr::TupleLit { elements, .. } => {
                let types: Vec<Type> = elements.iter().map(|e| self.check_expr(e)).collect();
                Type::Tuple(types)
            }

            Expr::ChannelSend { channel, value, .. } => {
                self.check_expr(channel);
                self.check_expr(value);
                Type::Void
            }
            Expr::ChannelReceive { channel, .. } => {
                self.check_expr(channel);
                Type::Unknown
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
            Expr::Is { value, .. } => {
                self.check_expr(value);
                Type::Bool
            }
            Expr::TableLit { columns, rows, .. } => {
                self.check_table_literal(columns, rows)
            }
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
    fn extract_type_annotations(&mut self, type_expr: &TypeExpr) -> Vec<(String, Vec<FieldAnnotation>)> {
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

                        // ── Unknown annotation ──
                        let entry = CORE_ANNOTATIONS.iter().find(|(name, _)| *name == ann_name);
                        if entry.is_none() {
                            self.diagnostics.push(Diagnostic::error(
                                "F0072",
                                format!("unknown annotation @{} on field '{}'. available: @min, @max, @validate, @default, @transform, @pattern",
                                    ann_name, field_name),
                                ann.span,
                            ));
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
    fn is_partial_type_expr(&self, type_expr: &TypeExpr) -> bool {
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
}
