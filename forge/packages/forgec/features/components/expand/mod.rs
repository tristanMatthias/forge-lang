pub mod syntax;

use crate::codegen::ServiceInfo;
use crate::lexer::Span;
use crate::parser::ast::*;
use std::collections::HashMap;
use std::sync::atomic::{AtomicUsize, Ordering};

static GENERATED_COUNTER: AtomicUsize = AtomicUsize::new(0);
static UNNAMED_COMPONENT_COUNTER: AtomicUsize = AtomicUsize::new(0);

/// Metadata about a component method for type checker registration
#[derive(Debug, Clone)]
pub struct ComponentMethodInfo {
    pub instance_name: String,
    pub component_kind: String,
    pub method_name: String,
    pub fn_name: String,
    pub params: Vec<Param>,
    pub return_type: Option<TypeExpr>,
}

pub struct ExpansionResult {
    pub type_decl: Option<Statement>,
    pub statements: Vec<Statement>,
    pub startup_stmts: Vec<Statement>,
    pub main_end_stmts: Vec<Statement>,
    pub static_methods: Vec<(String, String, String)>,
    pub component_methods: Vec<ComponentMethodInfo>,
    pub component_type: Option<(String, TypeExpr)>,
    pub extern_fns: Vec<Statement>,
    pub service_info: Option<ServiceInfo>,
}

impl ExpansionResult {
    pub fn new() -> Self {
        Self {
            type_decl: None,
            statements: Vec::new(),
            startup_stmts: Vec::new(),
            main_end_stmts: Vec::new(),
            static_methods: Vec::new(),
            component_methods: Vec::new(),
            component_type: None,
            extern_fns: Vec::new(),
            service_info: None,
        }
    }
}

// ---- AST builder helpers ----

fn sp() -> Span {
    Span { start: 0, end: 0, line: 0, col: 0 }
}

fn ident(name: &str) -> Expr {
    Expr::Ident(name.to_string(), sp())
}

fn call(name: &str, args: Vec<Expr>) -> Expr {
    Expr::Call {
        callee: Box::new(ident(name)),
        args: args
            .into_iter()
            .map(|v| CallArg { name: None, value: v })
            .collect(),
        type_args: vec![],
        span: sp(),
    }
}

fn method_call(obj: &str, method: &str, args: Vec<Expr>) -> Expr {
    Expr::Call {
        callee: Box::new(Expr::MemberAccess {
            object: Box::new(ident(obj)),
            field: method.to_string(),
            span: sp(),
        }),
        args: args
            .into_iter()
            .map(|v| CallArg { name: None, value: v })
            .collect(),
        type_args: vec![],
        span: sp(),
    }
}

fn let_stmt(name: &str, value: Expr) -> Statement {
    Statement::Let {
        name: name.to_string(),
        type_ann: None,
        type_ann_span: None,
        value,
        exported: false,
        span: sp(),
    }
}

fn let_typed(name: &str, ty: TypeExpr, value: Expr) -> Statement {
    Statement::Let {
        name: name.to_string(),
        type_ann: Some(ty),
        type_ann_span: None,
        value,
        exported: false,
        span: sp(),
    }
}

fn expr_stmt(expr: Expr) -> Statement {
    Statement::Expr(expr)
}

fn named_type(name: &str) -> TypeExpr {
    TypeExpr::Named(name.to_string())
}

fn fn_decl(
    name: &str,
    params: Vec<Param>,
    ret_type: Option<TypeExpr>,
    body: Vec<Statement>,
) -> Statement {
    Statement::FnDecl {
        name: name.to_string(),
        type_params: Vec::new(),
        params,
        return_type: ret_type,
        body: Block {
            statements: body,
            span: sp(),
        },
        exported: false,
        span: sp(),
    }
}

fn type_ann_to_str(te: &TypeExpr) -> &str {
    match te {
        TypeExpr::Named(n) => n.as_str(),
        _ => "string",
    }
}

// ---- Schema JSON builder ----
// Serializes schema fields to JSON for the native package library to generate SQL.
// This is generic data serialization — no SQL type mapping knowledge here.

fn build_schema_json(fields: &[ComponentSchemaField], _component_annotations: &[Annotation]) -> String {
    let mut entries = Vec::new();
    for field in fields {
        let mut obj = format!(
            "{{\"name\":\"{}\",\"type\":\"{}\"",
            field.name,
            type_ann_to_str(&field.type_ann)
        );

        if !field.annotations.is_empty() {
            obj.push_str(",\"annotations\":[");
            let anns: Vec<String> = field
                .annotations
                .iter()
                .map(|ann| {
                    if ann.args.is_empty() {
                        format!("{{\"name\":\"{}\"}}", ann.name)
                    } else {
                        let args: Vec<String> = ann
                            .args
                            .iter()
                            .map(|arg| match arg {
                                Expr::BoolLit(b, _) => {
                                    if *b { "true".to_string() } else { "false".to_string() }
                                }
                                Expr::IntLit(n, _) => n.to_string(),
                                Expr::StringLit(s, _) => format!("\"{}\"", s),
                                Expr::Ident(name, _) => format!("\"{}\"", name),
                                _ => "null".to_string(),
                            })
                            .collect();
                        format!("{{\"name\":\"{}\",\"args\":[{}]}}", ann.name, args.join(","))
                    }
                })
                .collect();
            obj.push_str(&anns.join(","));
            obj.push(']');
        }

        obj.push('}');
        entries.push(obj);
    }
    format!("[{}]", entries.join(","))
}

// ---- Template substitution context ----

/// Call `f` with a fully-constructed `SubFns` whose closures are bound to `ctx`.
///
/// The five closures must be stack-allocated in the same frame as the `SubFns`
/// struct they feed into (because `SubFns` holds plain `&dyn Fn` references).
/// This helper encapsulates that stack frame so the two callers don't need to
/// repeat the boilerplate.
fn with_sub_fns<T>(
    ctx: &SubstitutionContext,
    f: impl FnOnce(&crate::feature::SubFns<'_>) -> T,
) -> T {
    let sub_expr = |e: &Expr| substitute_expr(e, ctx);
    let sub_block = |b: &Block| substitute_block(b, ctx);
    let sub_ident = |s: &str| substitute_ident_string(s, ctx);
    let sub_type_expr = |t: &TypeExpr| substitute_type_expr(t, ctx);
    let sub_param = |p: &Param| substitute_param(p, ctx);
    let fns = crate::feature::SubFns {
        sub_expr: &sub_expr,
        sub_block: &sub_block,
        sub_ident: &sub_ident,
        sub_type_expr: &sub_type_expr,
        sub_param: &sub_param,
    };
    f(&fns)
}

struct SubstitutionContext {
    name: String,
    component_kind: String,
    ref_type: Option<String>,
    schema: Vec<ComponentSchemaField>,
    schema_json: String,
    config: Vec<ComponentConfig>,
}

struct HookInfo {
    param_name: String,
    body: Block,
}

// ---- Recursive AST substitution ----

/// Substitute template identifiers in a string (for internal function name construction).
/// Handles `self.X` → `{instance}_X` and `ref.X` → `{ref_type}_X` patterns
/// that have already been resolved to flat ident strings.
fn substitute_ident_string(s: &str, ctx: &SubstitutionContext) -> String {
    let mut result = s.to_string();
    // Legacy $-prefix support during migration (will be removed)
    if let Some(ref mr) = ctx.ref_type {
        if result.contains("$ref") {
            result = result.replace("$ref", mr);
        }
    }
    if result.contains("$name") {
        result = result.replace("$name", &ctx.name);
    }
    result
}

fn substitute_expr(expr: &Expr, ctx: &SubstitutionContext) -> Expr {
    match expr {
        Expr::Ident(name, span) => {
            // Legacy $-prefix support (kept for backward compat during migration)
            if name == "$name_str" {
                return Expr::StringLit(ctx.name.clone(), *span);
            }
            if name == "$schema_json" {
                return Expr::StringLit(ctx.schema_json.clone(), *span);
            }
            if name == "$ref_str" {
                if let Some(ref mr) = ctx.ref_type {
                    return Expr::StringLit(mr.clone(), *span);
                }
            }
            if name.starts_with("$config_") {
                let key = &name["$config_".len()..];
                if let Some(cfg) = ctx.config.iter().find(|c| c.key == key) {
                    return substitute_expr(&cfg.value, ctx);
                }
            }
            // Substring replacement for other $-prefixed idents
            Expr::Ident(substitute_ident_string(name, ctx), *span)
        }
        // Component property access via `self.*`
        Expr::MemberAccess { object, field, span } => {
            if let Expr::Ident(obj_name, _) = object.as_ref() {
                if obj_name == "self" {
                    // `self.name` → instance name as string
                    if field == "name" {
                        return Expr::StringLit(ctx.name.clone(), *span);
                    }
                    // `self.schema` → schema JSON as string
                    if field == "schema" {
                        return Expr::StringLit(ctx.schema_json.clone(), *span);
                    }
                    // `self.ref` → referenced type name as string
                    if field == "ref" {
                        if let Some(ref mr) = ctx.ref_type {
                            return Expr::StringLit(mr.clone(), *span);
                        }
                    }
                    // `self.HANDLER` → `{instance}_{handler}` (function pointer reference)
                    return Expr::Ident(format!("{}_{}", ctx.name, field), *span);
                }
            }
            // `self.config.KEY` → resolved config value
            // This arrives as MemberAccess { object: MemberAccess { object: Ident("self"), field: "config" }, field: KEY }
            if let Expr::MemberAccess { object: inner_obj, field: inner_field, .. } = object.as_ref() {
                if let Expr::Ident(obj_name, _) = inner_obj.as_ref() {
                    if obj_name == "self" && inner_field == "config" {
                        if let Some(cfg) = ctx.config.iter().find(|c| c.key == *field) {
                            return substitute_expr(&cfg.value, ctx);
                        }
                    }
                    // `self.ref.METHOD` → `{ref_type}_{method}`
                    if obj_name == "self" && inner_field == "ref" {
                        if let Some(ref mr) = ctx.ref_type {
                            return Expr::Ident(format!("{}_{}", mr, field), *span);
                        }
                    }
                }
            }
            // Legacy: `config.KEY` without self prefix
            if let Expr::Ident(obj_name, _) = object.as_ref() {
                if obj_name == "config" {
                    if let Some(cfg) = ctx.config.iter().find(|c| c.key == *field) {
                        return substitute_expr(&cfg.value, ctx);
                    }
                }
                // Legacy: `ref.METHOD`
                if obj_name == "ref" {
                    if let Some(ref mr) = ctx.ref_type {
                        return Expr::Ident(format!("{}_{}", mr, field), *span);
                    }
                }
            }
            Expr::MemberAccess {
                object: Box::new(substitute_expr(object, ctx)),
                field: field.clone(),
                span: *span,
            }
        }
        Expr::IntLit(_, _) | Expr::FloatLit(_, _) | Expr::BoolLit(_, _) | Expr::NullLit(_) => {
            expr.clone()
        }
        Expr::StringLit(_, _) => expr.clone(),
        Expr::TemplateLit { parts, span } => {
            Expr::TemplateLit {
                parts: parts
                    .iter()
                    .map(|p| match p {
                        TemplatePart::Literal(s) => TemplatePart::Literal(s.clone()),
                        TemplatePart::Expr(e) => {
                            TemplatePart::Expr(Box::new(substitute_expr(e, ctx)))
                        }
                    })
                    .collect(),
                span: *span,
            }
        }
        Expr::Call { callee, args, type_args, span } => Expr::Call {
            callee: Box::new(substitute_expr(callee, ctx)),
            args: args
                .iter()
                .map(|a| CallArg {
                    name: a.name.clone(),
                    value: substitute_expr(&a.value, ctx),
                })
                .collect(),
            type_args: type_args.clone(),
            span: *span,
        },
        Expr::Binary { left, op, right, span } => Expr::Binary {
            left: Box::new(substitute_expr(left, ctx)),
            op: *op,
            right: Box::new(substitute_expr(right, ctx)),
            span: *span,
        },
        Expr::Unary { op, operand, span } => Expr::Unary {
            op: *op,
            operand: Box::new(substitute_expr(operand, ctx)),
            span: *span,
        },
        Expr::Block(block) => Expr::Block(substitute_block(block, ctx)),
        Expr::Index { object, index, span } => Expr::Index {
            object: Box::new(substitute_expr(object, ctx)),
            index: Box::new(substitute_expr(index, ctx)),
            span: *span,
        },
        Expr::Feature(fe) => substitute_feature_expr(fe, ctx),
    }
}

/// Recursively substitute template placeholders inside Feature variant expressions.
/// Delegates to each feature data type's `substitute_exprs` implementation.
fn substitute_feature_expr(fe: &crate::feature::FeatureExpr, ctx: &SubstitutionContext) -> Expr {
    let new_data = with_sub_fns(ctx, |fns| fe.data.substitute_exprs(fns));
    Expr::Feature(crate::feature::FeatureExpr {
        feature_id: fe.feature_id,
        kind: fe.kind,
        data: new_data,
        span: fe.span,
    })
}


fn substitute_type_expr(te: &TypeExpr, ctx: &SubstitutionContext) -> TypeExpr {
    match te {
        TypeExpr::Named(name) => {
            // Clean template type references
            if name == "Name" {
                return TypeExpr::Named(ctx.name.clone());
            }
            if name == "Schema" {
                return TypeExpr::Struct {
                    fields: map_schema_fields(&ctx.schema, false),
                };
            }
            if name == "SchemaVisible" {
                return TypeExpr::Struct {
                    fields: map_schema_fields(&ctx.schema, true),
                };
            }
            if name == "Ref" {
                if let Some(ref mr) = ctx.ref_type {
                    return TypeExpr::Named(mr.clone());
                }
            }
            // Legacy $-prefix support (kept during migration)
            if name == "$name" {
                return TypeExpr::Named(ctx.name.clone());
            }
            if name == "$schema" {
                return TypeExpr::Struct {
                    fields: map_schema_fields(&ctx.schema, false),
                };
            }
            if name == "$schema_visible" {
                return TypeExpr::Struct {
                    fields: map_schema_fields(&ctx.schema, true),
                };
            }
            if name == "$ref" {
                if let Some(ref mr) = ctx.ref_type {
                    return TypeExpr::Named(mr.clone());
                }
            }
            TypeExpr::Named(name.clone())
        }
        TypeExpr::Nullable(inner)   => TypeExpr::Nullable(Box::new(substitute_type_expr(inner, ctx))),
        TypeExpr::AsPartial(base)   => TypeExpr::AsPartial(Box::new(substitute_type_expr(base, ctx))),
        TypeExpr::Generic { name, args } => TypeExpr::Generic {
            name: name.clone(),
            args: args.iter().map(|a| substitute_type_expr(a, ctx)).collect(),
        },
        TypeExpr::Union(types)  => TypeExpr::Union(types.iter().map(|t| substitute_type_expr(t, ctx)).collect()),
        TypeExpr::Tuple(types)  => TypeExpr::Tuple(types.iter().map(|t| substitute_type_expr(t, ctx)).collect()),
        TypeExpr::Function { params, return_type } => TypeExpr::Function {
            params: params.iter().map(|t| substitute_type_expr(t, ctx)).collect(),
            return_type: Box::new(substitute_type_expr(return_type, ctx)),
        },
        TypeExpr::Struct { fields } => TypeExpr::Struct {
            fields: fields.iter().map(|f| StructFieldDef { name: f.name.clone(), type_expr: substitute_type_expr(&f.type_expr, ctx), annotations: f.annotations.clone(), mutable: f.mutable }).collect(),
        },
        TypeExpr::Without  { base, fields } => TypeExpr::Without  { base: Box::new(substitute_type_expr(base, ctx)), fields: fields.clone() },
        TypeExpr::Only     { base, fields } => TypeExpr::Only     { base: Box::new(substitute_type_expr(base, ctx)), fields: fields.clone() },
        TypeExpr::TypeWith { base, fields } => TypeExpr::TypeWith {
            base: Box::new(substitute_type_expr(base, ctx)),
            fields: fields.iter().map(|f| StructFieldDef { name: f.name.clone(), type_expr: substitute_type_expr(&f.type_expr, ctx), annotations: f.annotations.clone(), mutable: f.mutable }).collect(),
        },
        TypeExpr::Intersection(left, right) => TypeExpr::Intersection(
            Box::new(substitute_type_expr(left, ctx)),
            Box::new(substitute_type_expr(right, ctx)),
        ),
    }
}

fn substitute_param(p: &Param, ctx: &SubstitutionContext) -> Param {
    Param {
        name: p.name.clone(),
        type_ann: p.type_ann.as_ref().map(|t| substitute_type_expr(t, ctx)),
        default: p.default.as_ref().map(|e| substitute_expr(e, ctx)),
        span: p.span,
        mutable: p.mutable,
    }
}

fn substitute_block(block: &Block, ctx: &SubstitutionContext) -> Block {
    Block {
        statements: block
            .statements
            .iter()
            .map(|s| substitute_stmt(s, ctx))
            .collect(),
        span: block.span,
    }
}

fn substitute_stmt(stmt: &Statement, ctx: &SubstitutionContext) -> Statement {
    /// Substitute type annotation and value for Let/Mut/Const, then reconstruct via `ctor`.
    macro_rules! sub_binding {
        ($ctor:ident, $name:expr, $type_ann:expr, $value:expr, $exported:expr, $span:expr) => {
            Statement::$ctor {
                name: $name.clone(),
                type_ann: $type_ann.as_ref().map(|t| substitute_type_expr(t, ctx)),
                type_ann_span: None,
                value: substitute_expr($value, ctx),
                exported: *$exported,
                span: *$span,
            }
        };
    }
    match stmt {
        Statement::Let   { name, type_ann, value, exported, span, .. } => sub_binding!(Let,   name, type_ann, value, exported, span),
        Statement::Mut   { name, type_ann, value, exported, span, .. } => sub_binding!(Mut,   name, type_ann, value, exported, span),
        Statement::Const { name, type_ann, value, exported, span, .. } => sub_binding!(Const, name, type_ann, value, exported, span),
        Statement::Expr(expr) => Statement::Expr(substitute_expr(expr, ctx)),
        Statement::Return { value, span } => Statement::Return {
            value: value.as_ref().map(|v| substitute_expr(v, ctx)),
            span: *span,
        },
        Statement::FnDecl { name, type_params, params, return_type, body, exported, span } => {
            Statement::FnDecl {
                name: substitute_ident_string(name, ctx),
                type_params: type_params.clone(),
                params: params.iter().map(|p| substitute_param(p, ctx)).collect(),
                return_type: return_type.as_ref().map(|t| substitute_type_expr(t, ctx)),
                body: substitute_block(body, ctx),
                exported: *exported,
                span: *span,
            }
        }
        Statement::For { pattern, iterable, body, span } => Statement::For {
            pattern: pattern.clone(),
            iterable: substitute_expr(iterable, ctx),
            body: substitute_block(body, ctx),
            span: *span,
        },
        Statement::While { condition, body, span } => Statement::While {
            condition: substitute_expr(condition, ctx),
            body: substitute_block(body, ctx),
            span: *span,
        },
        Statement::Assign { target, value, span } => Statement::Assign {
            target: substitute_expr(target, ctx),
            value: substitute_expr(value, ctx),
            span: *span,
        },
        Statement::Feature(fe) => {
            substitute_feature_stmt(fe, ctx)
        }
        // Pass through unchanged
        _ => stmt.clone(),
    }
}

/// Substitute template placeholders inside Feature variant statements.
/// Delegates to each feature data type's `substitute_exprs` implementation.
fn substitute_feature_stmt(fe: &crate::feature::FeatureStmt, ctx: &SubstitutionContext) -> Statement {
    let new_data = with_sub_fns(ctx, |fns| fe.data.substitute_exprs(fns));
    reconstruct_feature_stmt(fe, new_data)
}

// ---- Schema field mapping helper ----

/// Map schema fields to struct-style (name, type, annotations) tuples,
/// optionally filtering out fields annotated with @hidden.
fn map_schema_fields(
    schema: &[ComponentSchemaField],
    visible_only: bool,
) -> Vec<StructFieldDef> {
    schema
        .iter()
        .filter(|f| !visible_only || !f.annotations.iter().any(|a| a.name == "hidden"))
        .map(|f| StructFieldDef { name: f.name.clone(), type_expr: f.type_ann.clone(), annotations: Vec::new(), mutable: false })
        .collect()
}

// ---- Component method naming helper ----

/// Build the scoped method name `{component_name}_{method}` used throughout expansion.
fn component_method_name(component_name: &str, method: &str) -> String {
    format!("{}_{}", component_name, method)
}

/// Register a component method in both static_methods (for codegen) and component_methods (for type checking).
fn register_component_method(
    result: &mut ExpansionResult,
    ctx: &SubstitutionContext,
    method_name: &str,
    fn_name: String,
    params: &[Param],
    return_type: &Option<TypeExpr>,
) {
    result.static_methods.push((
        ctx.name.clone(),
        method_name.to_string(),
        fn_name.clone(),
    ));
    result.component_methods.push(ComponentMethodInfo {
        instance_name: ctx.name.clone(),
        component_kind: ctx.component_kind.clone(),
        method_name: method_name.to_string(),
        fn_name,
        params: params.to_vec(),
        return_type: return_type.clone(),
    });
}

// ---- Feature statement reconstruction helper ----

/// Build a `Statement::Feature(FeatureStmt { ... })` from an existing FeatureStmt
/// and new data. Preserves feature_id, kind, and span from the original.
fn reconstruct_feature_stmt(
    fe: &crate::feature::FeatureStmt,
    new_data: Box<dyn crate::feature::FeatureNode>,
) -> Statement {
    Statement::Feature(crate::feature::FeatureStmt {
        feature_id: fe.feature_id,
        kind: fe.kind,
        data: new_data,
        span: fe.span,
    })
}

// ---- @syntax call expansion ----

/// Expand a __component_* call by substituting captured args into the syntax fn body.
/// The syntax fn's params are matched by name against the call's named args.
fn expand_syntax_call(
    syntax_fn: &crate::parser::ast::SyntaxFnDef,
    args: &[CallArg],
    ctx: &SubstitutionContext,
    service_infos: &[ServiceInfo],
) -> Vec<Statement> {
    // Build a map of param_name → captured value (as Expr)
    let mut arg_map: std::collections::HashMap<String, Expr> = std::collections::HashMap::new();
    for arg in args {
        if let Some(ref name) = arg.name {
            arg_map.insert(name.clone(), arg.value.clone());
        }
    }

    // Generate a unique name for $generated
    let gen_id = GENERATED_COUNTER.fetch_add(1, Ordering::SeqCst);
    let generated_name = format!("__generated_handler_{}", gen_id);

    // Process the syntax fn body: substitute param references with captured values,
    // then apply the normal $-prefixed substitution
    let mut expanded_stmts = Vec::new();
    for stmt in &syntax_fn.body.statements {
        let substituted = substitute_stmt(stmt, ctx);
        let with_args = substitute_syntax_args_with_services(&substituted, &arg_map, service_infos);
        // Replace $generated with unique name
        let with_generated = replace_dollar_generated(&with_args, &generated_name);
        expanded_stmts.push(with_generated);
    }
    expanded_stmts
}

/// Like substitute_syntax_args but passes service_infos through for $resolve_service
fn substitute_syntax_args_with_services(stmt: &Statement, args: &std::collections::HashMap<String, Expr>, service_infos: &[ServiceInfo]) -> Statement {
    match stmt {
        Statement::Expr(expr) => Statement::Expr(substitute_syntax_args_expr(expr, args, service_infos)),
        Statement::Let { name, type_ann, value, exported, span, .. } => {
            // Handle $handler_param_N: bind closure param names to template-provided values
            if name.starts_with("$handler_param_") {
                return match try_expand_handler_param(name, value, *exported, *span, args, service_infos) {
                    Some(s) => s,
                    // No matching closure param — drop this placeholder binding
                    None => Statement::Expr(Expr::IntLit(0, sp())),
                };
            }
            Statement::Let {
                name: name.clone(),
                type_ann: type_ann.clone(),
                type_ann_span: None,
                value: substitute_syntax_args_expr(value, args, service_infos),
                exported: *exported,
                span: *span,
            }
        },
        Statement::Return { value, span } => Statement::Return {
            value: value.as_ref().map(|v| substitute_syntax_args_expr(v, args, service_infos)),
            span: *span,
        },
        Statement::FnDecl { name, type_params, params, return_type, body, exported, span } => {
            Statement::FnDecl {
                name: name.clone(),
                type_params: type_params.clone(),
                params: params.clone(),
                return_type: return_type.clone(),
                body: Block {
                    statements: body.statements.iter()
                        .map(|s| substitute_syntax_args_with_services(s, args, service_infos))
                        .collect(),
                    span: body.span,
                },
                exported: *exported,
                span: *span,
            }
        }
        Statement::Feature(fe) => {
            substitute_syntax_args_feature_stmt(fe, args, service_infos)
        }
        _ => stmt.clone(),
    }
}

/// Handle Feature variant in substitute_syntax_args_with_services
fn substitute_syntax_args_feature_stmt(
    fe: &crate::feature::FeatureStmt,
    args: &std::collections::HashMap<String, Expr>,
    service_infos: &[ServiceInfo],
) -> Statement {
    use crate::feature_data;

    match (fe.feature_id, fe.kind) {
        ("variables", "Let") | ("variables", "Mut") | ("variables", "Const") => {
            use crate::features::variables::types::VarDeclData;
            if let Some(data) = feature_data!(fe, VarDeclData) {
                // Handle $handler_param_N for Let kind
                if fe.kind == "Let" && data.name.starts_with("$handler_param_") {
                    // Return as old-style Let since that's what template expansion expects
                    return match try_expand_handler_param(&data.name, &data.value, data.exported, fe.span, args, service_infos) {
                        Some(s) => s,
                        None => Statement::Expr(Expr::IntLit(0, sp())),
                    };
                }
                let new_data = VarDeclData {
                    kind: data.kind.clone(),
                    name: data.name.clone(),
                    type_ann: data.type_ann.clone(),
                    type_ann_span: data.type_ann_span,
                    value: substitute_syntax_args_expr(&data.value, args, service_infos),
                    exported: data.exported,
                };
                reconstruct_feature_stmt(fe, Box::new(new_data))
            } else {
                Statement::Feature(fe.clone())
            }
        }
        ("functions", "FnDecl") => {
            use crate::features::functions::types::FnDeclData;
            if let Some(data) = feature_data!(fe, FnDeclData) {
                let new_data = FnDeclData {
                    name: data.name.clone(),
                    type_params: data.type_params.clone(),
                    params: data.params.clone(),
                    return_type: data.return_type.clone(),
                    body: Block {
                        statements: data.body.statements.iter()
                            .map(|s| substitute_syntax_args_with_services(s, args, service_infos))
                            .collect(),
                        span: data.body.span,
                    },
                    exported: data.exported,
                };
                reconstruct_feature_stmt(fe, Box::new(new_data))
            } else {
                Statement::Feature(fe.clone())
            }
        }
        ("functions", "Return") => {
            use crate::features::functions::types::ReturnData;
            if let Some(data) = feature_data!(fe, ReturnData) {
                let new_data = ReturnData {
                    value: data.value.as_ref().map(|v| substitute_syntax_args_expr(v, args, service_infos)),
                };
                reconstruct_feature_stmt(fe, Box::new(new_data))
            } else {
                Statement::Feature(fe.clone())
            }
        }
        _ => Statement::Feature(fe.clone()),
    }
}

/// Replace all occurrences of $generated in FnDecl names and Ident references
fn replace_dollar_generated(stmt: &Statement, generated_name: &str) -> Statement {
    match stmt {
        Statement::FnDecl { name, type_params, params, return_type, body, exported, span } => {
            let new_name = if name == "$generated" {
                generated_name.to_string()
            } else {
                name.clone()
            };
            Statement::FnDecl {
                name: new_name,
                type_params: type_params.clone(),
                params: params.clone(),
                return_type: return_type.clone(),
                body: Block {
                    statements: body.statements.iter()
                        .map(|s| replace_dollar_generated(s, generated_name))
                        .collect(),
                    span: body.span,
                },
                exported: *exported,
                span: *span,
            }
        }
        Statement::Expr(expr) => Statement::Expr(replace_dollar_generated_expr(expr, generated_name)),
        Statement::Let { name, type_ann, value, exported, span, .. } => Statement::Let {
            name: name.clone(),
            type_ann: type_ann.clone(),
            type_ann_span: None,
            value: replace_dollar_generated_expr(value, generated_name),
            exported: *exported,
            span: *span,
        },
        Statement::Feature(fe) => {
            replace_dollar_generated_feature_stmt(fe, generated_name)
        }
        _ => stmt.clone(),
    }
}

/// Handle Feature variant in replace_dollar_generated
fn replace_dollar_generated_feature_stmt(fe: &crate::feature::FeatureStmt, generated_name: &str) -> Statement {
    use crate::feature_data;

    match (fe.feature_id, fe.kind) {
        ("functions", "FnDecl") => {
            use crate::features::functions::types::FnDeclData;
            if let Some(data) = feature_data!(fe, FnDeclData) {
                let new_name = if data.name == "$generated" {
                    generated_name.to_string()
                } else {
                    data.name.clone()
                };
                let new_data = FnDeclData {
                    name: new_name,
                    type_params: data.type_params.clone(),
                    params: data.params.clone(),
                    return_type: data.return_type.clone(),
                    body: Block {
                        statements: data.body.statements.iter()
                            .map(|s| replace_dollar_generated(s, generated_name))
                            .collect(),
                        span: data.body.span,
                    },
                    exported: data.exported,
                };
                reconstruct_feature_stmt(fe, Box::new(new_data))
            } else {
                Statement::Feature(fe.clone())
            }
        }
        ("variables", "Let") | ("variables", "Mut") | ("variables", "Const") => {
            use crate::features::variables::types::VarDeclData;
            if let Some(data) = feature_data!(fe, VarDeclData) {
                let new_data = VarDeclData {
                    kind: data.kind.clone(),
                    name: data.name.clone(),
                    type_ann: data.type_ann.clone(),
                    type_ann_span: data.type_ann_span,
                    value: replace_dollar_generated_expr(&data.value, generated_name),
                    exported: data.exported,
                };
                reconstruct_feature_stmt(fe, Box::new(new_data))
            } else {
                Statement::Feature(fe.clone())
            }
        }
        _ => Statement::Feature(fe.clone()),
    }
}

fn replace_dollar_generated_expr(expr: &Expr, generated_name: &str) -> Expr {
    match expr {
        Expr::Ident(name, span) => {
            if name == "$generated" {
                Expr::Ident(generated_name.to_string(), *span)
            } else {
                expr.clone()
            }
        }
        Expr::Call { callee, args, type_args, span } => Expr::Call {
            callee: Box::new(replace_dollar_generated_expr(callee, generated_name)),
            args: args.iter().map(|a| CallArg {
                name: a.name.clone(),
                value: replace_dollar_generated_expr(&a.value, generated_name),
            }).collect(),
            type_args: type_args.clone(),
            span: *span,
        },
        _ => expr.clone(),
    }
}

/// Find the Nth param from the first closure found in the args map
fn find_closure_param_in_args(args: &std::collections::HashMap<String, Expr>, idx: usize) -> Option<Param> {
    use crate::feature_data;
    use crate::features::closures::types::ClosureData;
    for value in args.values() {
        if let Expr::Feature(fe) = value {
            if fe.feature_id == "closures" {
                if let Some(data) = feature_data!(fe, ClosureData) {
                    if !data.params.is_empty() {
                        return data.params.get(idx).cloned();
                    }
                }
            }
        }
    }
    None
}

/// If `name` starts with `$handler_param_N`, try to bind to closure param N from `args`.
/// Returns `Some(Statement::Let {...})` if the binding applies, `None` otherwise.
fn try_expand_handler_param(
    name: &str,
    value: &Expr,
    exported: bool,
    span: Span,
    args: &std::collections::HashMap<String, Expr>,
    service_infos: &[ServiceInfo],
) -> Option<Statement> {
    let idx_str = name.strip_prefix("$handler_param_")?;
    let idx: usize = idx_str.parse().ok()?;
    let closure_param = find_closure_param_in_args(args, idx)?;
    let substituted_value = substitute_syntax_args_expr(value, args, service_infos);
    let (final_name, final_type_ann, final_value) = if closure_param.type_ann.is_some() {
        (
            closure_param.name.clone(),
            closure_param.type_ann.clone(),
            Expr::Call {
                callee: Box::new(Expr::MemberAccess {
                    object: Box::new(ident("json")),
                    field: "parse".to_string(),
                    span: sp(),
                }),
                args: vec![CallArg { name: None, value: substituted_value }],
                type_args: vec![],
                span: sp(),
            },
        )
    } else {
        (closure_param.name.clone(), None, substituted_value)
    };
    Some(Statement::Let {
        name: final_name,
        type_ann: final_type_ann,
        type_ann_span: None,
        value: final_value,
        exported,
        span,
    })
}

/// Replace identifiers that match syntax fn param names with their captured values
fn substitute_syntax_args(stmt: &Statement, args: &std::collections::HashMap<String, Expr>) -> Statement {
    substitute_syntax_args_with_services(stmt, args, &[])
}

fn substitute_syntax_args_expr(expr: &Expr, args: &std::collections::HashMap<String, Expr>, service_infos: &[ServiceInfo]) -> Expr {
    match expr {
        Expr::Ident(name, _span) => {
            if let Some(replacement) = args.get(name) {
                // Closure unwrapping: when a handler arg is a closure, unwrap to just the body
                if let Expr::Feature(fe) = replacement {
                    if fe.feature_id == "closures" {
                        if let Some(data) = crate::feature_data!(fe, crate::features::closures::types::ClosureData) {
                            return *data.body.clone();
                        }
                    }
                }
                return replacement.clone();
            }
            expr.clone()
        }
        Expr::Call { callee, args: call_args, type_args, span } => {
            // Handle $resolve_service() intrinsic
            if let Expr::Ident(name, _) = callee.as_ref() {
                if name == "$resolve_service" {
                    if let Some(first_arg) = call_args.first() {
                        let resolved = substitute_syntax_args_expr(&first_arg.value, args, service_infos);
                        if let Expr::StringLit(service_name, s) = &resolved {
                            // Look up service → model table name
                            let table_name = service_infos
                                .iter()
                                .find(|si| si.name == *service_name)
                                .map(|si| si.for_model.clone())
                                .unwrap_or_else(|| service_name.clone());
                            return Expr::StringLit(table_name, *s);
                        }
                        return resolved;
                    }
                }
            }
            Expr::Call {
                callee: Box::new(substitute_syntax_args_expr(callee, args, service_infos)),
                args: call_args.iter().map(|a| CallArg {
                    name: a.name.clone(),
                    value: substitute_syntax_args_expr(&a.value, args, service_infos),
                }).collect(),
                type_args: type_args.clone(),
                span: *span,
            }
        }
        Expr::MemberAccess { object, field, span } => Expr::MemberAccess {
            object: Box::new(substitute_syntax_args_expr(object, args, service_infos)),
            field: field.clone(),
            span: *span,
        },
        Expr::Binary { left, op, right, span } => Expr::Binary {
            left: Box::new(substitute_syntax_args_expr(left, args, service_infos)),
            op: *op,
            right: Box::new(substitute_syntax_args_expr(right, args, service_infos)),
            span: *span,
        },
        Expr::Block(block) => Expr::Block(Block {
            statements: block.statements.iter()
                .map(|s| substitute_syntax_args(s, args))
                .collect(),
            span: block.span,
        }),
        Expr::Feature(ref fe) if fe.kind == "StructLit" => {
            use crate::features::structs::types::StructLitData;
            use crate::feature::FeatureExpr;
            if let Some(data) = crate::feature_data!(fe, StructLitData) {
                Expr::Feature(FeatureExpr {
                    feature_id: fe.feature_id,
                    kind: fe.kind,
                    data: Box::new(StructLitData {
                        name: data.name.clone(),
                        fields: data.fields.iter()
                            .map(|(k, v)| (k.clone(), substitute_syntax_args_expr(v, args, service_infos)))
                            .collect(),
                        span: data.span,
                    }),
                    span: fe.span,
                })
            } else {
                expr.clone()
            }
        }
        Expr::TemplateLit { parts, span } => Expr::TemplateLit {
            parts: parts.iter()
                .map(|p| match p {
                    TemplatePart::Literal(s) => TemplatePart::Literal(s.clone()),
                    TemplatePart::Expr(e) => TemplatePart::Expr(Box::new(substitute_syntax_args_expr(e, args, service_infos))),
                })
                .collect(),
            span: *span,
        },
        _ => expr.clone(),
    }
}

// ---- Config resolution ----

fn resolve_config(
    user_config: &[ComponentConfig],
    schema: &[crate::parser::ast::ConfigSchemaEntry],
) -> Vec<ComponentConfig> {
    let mut resolved = user_config.to_vec();
    for entry in schema {
        let already_set = resolved.iter().any(|c| c.key == entry.key);
        if !already_set {
            if let Some(ref default) = entry.default {
                resolved.push(ComponentConfig {
                    key: entry.key.clone(),
                    value: default.clone(),
                    span: entry.span,
                });
            }
        }
    }
    resolved
}

// ---- Template expansion ----

fn substitute_fn_template(
    decl: &Statement,
    method_name: &str,
    ctx: &SubstitutionContext,
) -> Statement {
    if let Statement::FnDecl { params, return_type, body, span, .. } = decl {
        let fn_name = component_method_name(&ctx.name, method_name);
        Statement::FnDecl {
            name: fn_name,
            type_params: Vec::new(),
            params: params.iter().map(|p| substitute_param(p, ctx)).collect(),
            return_type: return_type.as_ref().map(|t| substitute_type_expr(t, ctx)),
            body: substitute_block(body, ctx),
            exported: false,
            span: *span,
        }
    } else {
        substitute_stmt(decl, ctx)
    }
}

/// Find the name of the first parameter whose type annotation matches `type_name`.
fn find_first_param_by_type<'a>(params: &'a [Param], type_name: &str) -> Option<&'a str> {
    params.iter()
        .find(|p| matches!(&p.type_ann, Some(TypeExpr::Named(t)) if t == type_name))
        .map(|p| p.name.as_str())
}

/// Inject before/after hooks into a template-generated component function.
/// Prepends before hook body and appends after hook body around the original function body.
/// Works with any component template that declares events (model, service, etc.).
///
/// Hook param binding conventions (all generic, zero package knowledge):
/// - Before hooks with `__raw_` prefix: model `on` syntax, bind param via `json.parse(first_string_param)` as component type
/// - Before hooks without prefix, param not in fn scope, ref_type set: service hook,
///   bind param via `json.parse(first_string_param)` as the wrapped component's type
/// - After hooks with `__raw_` prefix: fetch full record via `get_internal(id_var)`
/// - After hooks without prefix, param not in fn scope, ref_type set: service hook,
///   fetch full record via `{ref_type}_get_internal(id_var)`
/// - After hooks where param matches a fn param: already in scope, no binding needed
fn build_component_hooked_fn(
    method_name: &str,
    ctx: &SubstitutionContext,
    original_fn: &Statement,
    before_hooks: &HashMap<String, HookInfo>,
    after_hooks: &HashMap<String, HookInfo>,
) -> Statement {
    if let Statement::FnDecl { name, type_params, params, return_type, body, exported, span } = original_fn {
        let mut new_stmts = Vec::new();

        // Before hook: inject user's hook body before the template function body
        if let Some(hook) = before_hooks.get(method_name) {
            let original_name = strip_raw_prefix(&hook.param_name);
            let in_fn_scope = params.iter().any(|p| p.name == original_name);

            if !hook.param_name.starts_with("__raw_") && !in_fn_scope {
                if let Some(model_ref) = &ctx.ref_type {
                    // Service hook: bind param to parsed struct from first string param
                    if let Some(str_param) = find_first_param_by_type(params, "string") {
                        new_stmts.push(let_typed(
                            &hook.param_name,
                            named_type(model_ref),
                            method_call("json", "parse", vec![ident(str_param)]),
                        ));
                    }
                }
            } else if hook.param_name.starts_with("__raw_") {
                // Model hook: bind original param name to json.parse(first_string_param)
                // typed as the component's type so the user can access fields like data.title
                if let Some(str_param) = find_first_param_by_type(params, "string") {
                    new_stmts.push(let_typed(
                        &original_name,
                        named_type(&ctx.name),
                        method_call("json", "parse", vec![ident(str_param)]),
                    ));
                }
            }

            inject_hook_body(&hook.body, &hook.param_name, &mut new_stmts);
        }

        // Original template function body
        new_stmts.extend(body.statements.clone());

        // After hook: inject user's hook body after the template function body
        if let Some(hook) = after_hooks.get(method_name) {
            if !new_stmts.is_empty() {
                // Pop last statement to preserve return value
                let last = new_stmts.pop();

                // Determine the ID variable and the return statement.
                // If last is a bare call expr, capture its result in __hook_result
                // so the hook can reference the returned ID.
                let (id_var, return_stmt) = match &last {
                    Some(Statement::Expr(Expr::Ident(name, _))) => {
                        // Already a variable (e.g., __id) — use it directly
                        (name.clone(), last.unwrap())
                    }
                    Some(Statement::Expr(expr)) => {
                        // A call or other expression — capture its result
                        new_stmts.push(let_stmt("__hook_result", expr.clone()));
                        ("__hook_result".to_string(), expr_stmt(ident("__hook_result")))
                    }
                    _ => {
                        // Not an expression — fall back
                        let id = find_id_variable(&body.statements, params);
                        let ret = last.unwrap_or_else(|| expr_stmt(ident(&id)));
                        (id, ret)
                    }
                };

                let original_name = strip_raw_prefix(&hook.param_name);
                let in_fn_scope = params.iter().any(|p| p.name == original_name);

                if hook.param_name.starts_with("__raw_") {
                    // Untyped model hook param → wants full record.
                    // If the fn already returns a struct (e.g. update returns $name),
                    // bind directly to the return value. Otherwise call get_internal(id).
                    let returns_struct = matches!(return_type, Some(TypeExpr::Named(n)) if n == &ctx.name);
                    if returns_struct {
                        new_stmts.push(let_stmt(&original_name, ident(&id_var)));
                    } else {
                        let get_internal = format!("{}_get_internal", ctx.name);
                        new_stmts.push(let_stmt(
                            &original_name,
                            call(&get_internal, vec![ident(&id_var)]),
                        ));
                    }
                } else if !in_fn_scope {
                    if let Some(model_ref) = &ctx.ref_type {
                        // Service hook: fetch full record via model's get_internal
                        // If fn returns model struct, bind directly; else call get_internal
                        let ref_name = model_ref.to_string();
                        let returns_struct = matches!(return_type, Some(TypeExpr::Named(n)) if *n == ref_name);
                        if returns_struct {
                            new_stmts.push(let_stmt(&original_name, ident(&id_var)));
                        } else {
                            let get_internal = format!("{}_get_internal", model_ref);
                            new_stmts.push(let_stmt(
                                &original_name,
                                call(&get_internal, vec![ident(&id_var)]),
                            ));
                        }
                    } else {
                        // Model hook with unmatched param: bind to id variable
                        new_stmts.push(let_stmt(&original_name, ident(&id_var)));
                    }
                }
                // else: param matches a fn param, already in scope

                inject_hook_body(&hook.body, &hook.param_name, &mut new_stmts);
                new_stmts.push(return_stmt);
            }
        }

        Statement::FnDecl {
            name: name.clone(),
            type_params: type_params.clone(),
            params: params.clone(),
            return_type: return_type.clone(),
            body: Block { statements: new_stmts, span: *span },
            exported: *exported,
            span: *span,
        }
    } else {
        original_fn.clone()
    }
}

/// Find the ID variable available in a template function body.
/// Returns "__id" if it's defined in the body (e.g., create template),
/// otherwise returns the first function parameter name.
fn find_id_variable(body_stmts: &[Statement], params: &[Param]) -> String {
    for stmt in body_stmts {
        if let Statement::Let { name, .. } = stmt {
            if name == "__id" {
                return "__id".to_string();
            }
        }
    }
    params.first().map(|p| p.name.clone()).unwrap_or_else(|| "__id".to_string())
}

/// Strip __raw_ prefix added by the on-event parser for C ptr params
fn strip_raw_prefix(name: &str) -> String {
    if name.starts_with("__raw_") {
        name.trim_start_matches("__raw_").to_string()
    } else {
        name.to_string()
    }
}

/// Inject hook body statements, skipping the C ptr conversion prologue
/// that the on-event parser adds for untyped params.
fn inject_hook_body(body: &Block, param_name: &str, stmts: &mut Vec<Statement>) {
    let original_name = strip_raw_prefix(param_name);
    for s in &body.statements {
        // Skip forge_string_new prologue injected by on-event parser
        if let Statement::Let { name: var_name, value: Expr::Call { callee, .. }, .. } = s {
            if *var_name == original_name {
                if let Expr::Ident(fn_name, _) = callee.as_ref() {
                    if fn_name == "forge_string_new" {
                        continue;
                    }
                }
            }
        }
        stmts.push(s.clone());
    }
}

fn extract_hooks_and_methods(
    blocks: &[Statement],
) -> (
    HashMap<String, HookInfo>,
    HashMap<String, HookInfo>,
    Vec<Statement>,
) {
    let mut before_hooks = HashMap::new();
    let mut after_hooks = HashMap::new();
    let mut custom_methods = Vec::new();

    /// Strip `prefix` from `name`, build a `HookInfo` from `params`/`body`,
    /// and insert it into `map`.
    fn insert_hook(
        map: &mut HashMap<String, HookInfo>,
        name: &str,
        prefix: &str,
        params: &[Param],
        body: &Block,
    ) {
        let operation = name.trim_start_matches(prefix).to_string();
        let param_name = params.first().map(|p| p.name.clone()).unwrap_or_default();
        map.insert(operation, HookInfo { param_name, body: body.clone() });
    }

    // Hook prefix → target map: (prefix, is_before)
    const HOOK_PREFIXES: &[(&str, bool)] = &[
        ("__hook_before_", true),
        ("__hook_after_",  false),
        ("on_before_",     true),
        ("on_after_",      false),
    ];

    for stmt in blocks {
        if let Statement::FnDecl { name, params, body, .. } = stmt {
            let matched = HOOK_PREFIXES.iter().find(|(prefix, _)| name.starts_with(prefix));
            if let Some((prefix, is_before)) = matched {
                let target = if *is_before { &mut before_hooks } else { &mut after_hooks };
                insert_hook(target, name, prefix, params, body);
            } else {
                custom_methods.push(stmt.clone());
            }
        }
    }

    (before_hooks, after_hooks, custom_methods)
}

fn expand_custom_methods(
    custom_methods: &[Statement],
    ctx: &SubstitutionContext,
    result: &mut ExpansionResult,
) {
    let model_ref = match ctx.ref_type.as_ref() {
        Some(mr) => mr,
        None => return,
    };

    for method_stmt in custom_methods {
        if let Statement::FnDecl { name, params, return_type, body, .. } = method_stmt {
            let new_name = component_method_name(&ctx.name, name);

            // Rewrite params typed as the model to `int`
            let new_params: Vec<Param> = params
                .iter()
                .map(|p| {
                    if let Some(TypeExpr::Named(t)) = &p.type_ann {
                        if t == model_ref {
                            return Param {
                                type_ann: Some(named_type("int")),
                                ..p.clone()
                            };
                        }
                    }
                    p.clone()
                })
                .collect();

            let new_return_type = return_type.as_ref().map(|rt| {
                if let TypeExpr::Named(t) = rt {
                    if t == model_ref {
                        return named_type("int");
                    }
                }
                rt.clone()
            });

            result.statements.push(Statement::FnDecl {
                name: new_name.clone(),
                type_params: Vec::new(),
                params: new_params.clone(),
                return_type: new_return_type.clone(),
                body: body.clone(),
                exported: false,
                span: sp(),
            });

            register_component_method(result, ctx, name, new_name, &new_params, &new_return_type);
        }
    }
}

fn expand_simple_methods(
    methods: &[Statement],
    ctx: &SubstitutionContext,
    result: &mut ExpansionResult,
) {
    for stmt in methods {
        if let Statement::FnDecl { name, params, return_type, body, .. } = stmt {
            let fn_name = component_method_name(&ctx.name, name);
            result.statements.push(Statement::FnDecl {
                name: fn_name,
                type_params: Vec::new(),
                params: params.clone(),
                return_type: return_type.clone(),
                body: body.clone(),
                exported: false,
                span: sp(),
            });
        }
    }
}

// ---- The component expansion engine ----

pub struct ComponentExpander;

impl ComponentExpander {
    /// Expand a component block using a package template definition.
    pub fn expand_from_template(
        template: &ComponentTemplateDef,
        decl: &ComponentBlockDecl,
        service_infos: &[ServiceInfo],
        all_templates: &[&ComponentTemplateDef],
    ) -> ExpansionResult {
        let name = match decl.args.first() {
            Some(ComponentArg::Ident(name, _)) => name.clone(),
            _ => {
                // Auto-generate name for unnamed components (e.g., `server :3000 { ... }`)
                let id = UNNAMED_COMPONENT_COUNTER.fetch_add(1, Ordering::SeqCst);
                format!("__{}{}", decl.component, id)
            }
        };

        let ref_type = decl
            .args
            .iter()
            .find_map(|a| match a {
                ComponentArg::ForRef(name, _) => Some(name.clone()),
                _ => None,
            });

        let schema = decl.body.schema.clone();
        let schema_json = if template.has_schema && !schema.is_empty() {
            build_schema_json(&schema, &decl.body.annotations)
        } else {
            String::new()
        };

        // Promote ComponentArg::Named entries to config (e.g., `server :3000` → port=3000)
        let mut merged_config = decl.body.config.clone();
        for arg in &decl.args {
            if let ComponentArg::Named(key, value, span) = arg {
                let already_set = merged_config.iter().any(|c| c.key == *key);
                if !already_set {
                    merged_config.push(ComponentConfig {
                        key: key.clone(),
                        value: value.clone(),
                        span: *span,
                    });
                }
            }
        }

        // Promote component-level annotations to config overrides.
        // E.g., @table("blog_posts") on a component that has `config { table_name: ... }`
        // maps annotation name "table" to config key "table_name" (ann_name + "_name").
        for ann in &decl.body.annotations {
            // Try exact match first, then annotation_name convention
            let config_key_candidates = vec![
                ann.name.clone(),
                format!("{}_name", ann.name),
            ];
            for candidate in config_key_candidates {
                let schema_has_key = template.config_schema.iter().any(|e| e.key == candidate);
                let already_set = merged_config.iter().any(|c| c.key == candidate);
                if schema_has_key && !already_set {
                    if let Some(first_arg) = ann.args.first() {
                        merged_config.push(ComponentConfig {
                            key: candidate,
                            value: first_arg.clone(),
                            span: ann.span,
                        });
                    }
                    break;
                }
            }
        }

        // Resolve config: merge user config with schema defaults
        let resolved_config = resolve_config(&merged_config, &template.config_schema);

        let component_kind = template.component_name.clone();
        let ctx = SubstitutionContext { name, component_kind, ref_type, schema, schema_json, config: resolved_config };

        // Extract hooks and custom methods from user body
        let (before_hooks, after_hooks, custom_methods) =
            extract_hooks_and_methods(&decl.body.blocks);

        let mut result = ExpansionResult::new();

        for item in &template.body {
            match item {
                ComponentTemplateItem::TypeFromSchema { visible_only } => {
                    let fields = map_schema_fields(&ctx.schema, *visible_only);
                    result.type_decl = Some(Statement::TypeDecl {
                        name: ctx.name.clone(),
                        type_params: Vec::new(),
                        value: TypeExpr::Struct { fields },
                        exported: false,
                        span: sp(),
                    });
                }
                ComponentTemplateItem::OnStartup(stmts) => {
                    for s in stmts {
                        result.startup_stmts.push(substitute_stmt(s, &ctx));
                    }
                }
                ComponentTemplateItem::OnMainEnd(stmts) => {
                    for s in stmts {
                        result.main_end_stmts.push(substitute_stmt(s, &ctx));
                    }
                }
                ComponentTemplateItem::FnTemplate { method_name, decl: fn_decl_stmt } => {
                    let fn_name = component_method_name(&ctx.name, method_name);

                    // Extract params/return_type for type checker registration
                    let (tpl_params, tpl_ret) = if let Statement::FnDecl { params, return_type, .. } = fn_decl_stmt {
                        (params.clone(), return_type.clone())
                    } else {
                        (vec![], None)
                    };

                    if template.has_ref {
                        // Service template: check for hooks
                        let has_before = before_hooks.contains_key(method_name);
                        let has_after = after_hooks.contains_key(method_name);

                        if has_before || has_after {
                            // Substitute the template function, then inject hooks
                            let substituted =
                                substitute_fn_template(fn_decl_stmt, method_name, &ctx);
                            let hooked = build_component_hooked_fn(
                                method_name, &ctx, &substituted, &before_hooks, &after_hooks,
                            );
                            result.statements.push(hooked);
                            register_component_method(&mut result, &ctx, method_name, fn_name, &tpl_params, &tpl_ret);
                        } else {
                            // No hooks: map directly to model method
                            let model_ref = ctx.ref_type.as_ref().unwrap();
                            let model_fn = format!("{}_{}", model_ref, method_name);
                            register_component_method(&mut result, &ctx, method_name, model_fn, &tpl_params, &tpl_ret);
                        }
                    } else {
                        // Model template: substitute and emit
                        let substituted =
                            substitute_fn_template(fn_decl_stmt, method_name, &ctx);

                        // Inject hooks into model template functions if present
                        let has_before = before_hooks.contains_key(method_name);
                        let has_after = after_hooks.contains_key(method_name);

                        if has_before || has_after {
                            let hooked = build_component_hooked_fn(
                                method_name, &ctx, &substituted, &before_hooks, &after_hooks,
                            );
                            result.statements.push(hooked);
                        } else {
                            result.statements.push(substituted);
                        }
                        register_component_method(&mut result, &ctx, method_name, fn_name, &tpl_params, &tpl_ret);
                    }
                }
                ComponentTemplateItem::InitFn(stmts) => {
                    // fn init() — constructor, treated like on startup for now
                    for s in stmts {
                        result.startup_stmts.push(substitute_stmt(s, &ctx));
                    }
                }
                ComponentTemplateItem::DropFn(stmts) => {
                    // fn drop() — cleanup, treated like on main_end for now
                    for s in stmts {
                        result.main_end_stmts.push(substitute_stmt(s, &ctx));
                    }
                }
                ComponentTemplateItem::FieldDecl { .. } => {
                    // Field declarations are collected during struct generation (future)
                    // For now, no-op during expansion
                }
                ComponentTemplateItem::ExternFn(ef) => {
                    result.extern_fns.push(ef.clone());
                }
                // OnAfterChildren is handled after body block processing (below)
                ComponentTemplateItem::OnAfterChildren(_) => {}
                ComponentTemplateItem::EventDecl { name: event_name, params: event_params, .. } => {
                    // Check if user provided an on_EVENT handler
                    let handler_name = format!("on_{}", event_name);
                    let user_has_handler = decl.body.blocks.iter().any(|s| {
                        match s {
                            Statement::FnDecl { name, .. } => name == &handler_name,
                            Statement::Feature(fe) if fe.feature_id == "functions" && fe.kind == "FnDecl" => {
                                use crate::feature_data;
                                use crate::features::functions::types::FnDeclData;
                                feature_data!(fe, FnDeclData).map_or(false, |d| d.name == handler_name)
                            }
                            _ => false,
                        }
                    });
                    if !user_has_handler {
                        // Generate a no-op stub function
                        let stub_name = component_method_name(&ctx.name, event_name);
                        let stub_params: Vec<Param> = event_params.iter().map(|p| {
                            substitute_param(p, &ctx)
                        }).collect();
                        result.statements.push(fn_decl(
                            &stub_name,
                            stub_params,
                            None,
                            vec![],
                        ));
                    }
                }
            }
        }

        // Handle @syntax-desugared calls from user body (__component_* calls)
        // FnDecl results go to top-level statements, everything else to startup_stmts
        for stmt in &decl.body.blocks {
            match stmt {
                Statement::Expr(Expr::Call { callee, args, .. }) => {
                    if let Expr::Ident(name, _) = callee.as_ref() {
                        if name.starts_with("__component_") {
                            let fn_name = name.trim_start_matches("__component_");
                            if let Some(syntax_fn) = template.syntax_fns.iter().find(|sf| sf.fn_name == fn_name) {
                                let expanded = expand_syntax_call(syntax_fn, args, &ctx, service_infos);
                                for s in expanded {
                                    match &s {
                                        Statement::FnDecl { .. } => result.statements.push(s),
                                        Statement::Feature(fe) if fe.feature_id == "functions" && fe.kind == "FnDecl" => result.statements.push(s),
                                        _ => result.startup_stmts.push(s),
                                    }
                                }
                            }
                        }
                    }
                }
                // Recursively expand nested component blocks (e.g., command/flag inside cli)
                Statement::ComponentBlock(nested_decl) => {
                    if let Some(nested_template) = all_templates.iter().find(|t| t.component_name == nested_decl.component) {
                        let nested_result = Self::expand_from_template(nested_template, nested_decl, service_infos, all_templates);
                        result.startup_stmts.extend(nested_result.startup_stmts);
                        result.main_end_stmts.extend(nested_result.main_end_stmts);
                        result.statements.extend(nested_result.statements);
                        result.extern_fns.extend(nested_result.extern_fns);
                        if let Some(type_decl) = nested_result.type_decl {
                            result.statements.push(type_decl);
                        }
                        if let Some(si) = nested_result.service_info {
                            // Don't overwrite parent service_info
                            if result.service_info.is_none() {
                                result.service_info = Some(si);
                            }
                        }
                    }
                }
                // Pass through FnDecl statements (e.g., middleware handler functions)
                Statement::FnDecl { .. } => {
                    result.statements.push(stmt.clone());
                }
                Statement::Feature(fe) if fe.feature_id == "functions" && fe.kind == "FnDecl" => {
                    result.statements.push(stmt.clone());
                }
                _ => {}
            }
        }

        // Emit OnAfterChildren stmts (e.g., cli_pop after nested commands)
        for item in &template.body {
            if let ComponentTemplateItem::OnAfterChildren(stmts) = item {
                for s in stmts {
                    result.startup_stmts.push(substitute_stmt(s, &ctx));
                }
            }
        }

        // Handle custom methods from user body
        if template.has_ref {
            expand_custom_methods(&custom_methods, &ctx, &mut result);
        } else if !custom_methods.is_empty() {
            expand_simple_methods(&custom_methods, &ctx, &mut result);
        }

        // Populate service metadata for server mount resolution
        if template.has_ref {
            // Service template: build ServiceInfo
            let hooks: Vec<ServiceHook> = before_hooks.iter()
                .map(|(op, info)| ServiceHook { timing: HookTiming::Before, operation: op.clone(), param: info.param_name.clone(), body: info.body.clone(), span: sp() })
                .chain(after_hooks.iter().map(|(op, info)| ServiceHook { timing: HookTiming::After, operation: op.clone(), param: info.param_name.clone(), body: info.body.clone(), span: sp() }))
                .collect();
            result.service_info = Some(ServiceInfo {
                name: ctx.name.clone(),
                for_model: ctx.ref_type.clone().unwrap_or_default(),
                hooks,
                methods: custom_methods.clone(),
            });
        }

        // Generate component struct type for non-schema components
        // Schema components (model) already have a type from TypeFromSchema
        if result.type_decl.is_none() && !result.component_methods.is_empty() {
            let kind = capitalize_first(&ctx.component_kind);
            // Build struct fields: __name + config fields
            let mut fields: Vec<StructFieldDef> = vec![
                StructFieldDef { name: "__name".to_string(), type_expr: TypeExpr::Named("string".to_string()), annotations: vec![], mutable: false },
            ];
            for entry in &template.config_schema {
                fields.push(StructFieldDef { name: entry.key.clone(), type_expr: entry.type_ann.clone(), annotations: vec![], mutable: false });
            }
            for item in &template.body {
                if let ComponentTemplateItem::FieldDecl { name, type_ann, .. } = item {
                    fields.push(StructFieldDef { name: name.clone(), type_expr: type_ann.clone(), annotations: vec![], mutable: false });
                }
            }
            result.component_type = Some((kind, TypeExpr::Struct { fields }));
        }

        result
    }
}

fn capitalize_first(s: &str) -> String {
    let mut chars = s.chars();
    match chars.next() {
        None => String::new(),
        Some(c) => c.to_uppercase().collect::<String>() + chars.as_str(),
    }
}
