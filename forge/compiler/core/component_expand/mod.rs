pub mod syntax;

use crate::codegen::ServiceInfo;
use crate::lexer::Span;
use crate::parser::ast::*;
use std::collections::HashMap;
use std::sync::atomic::{AtomicUsize, Ordering};

static GENERATED_COUNTER: AtomicUsize = AtomicUsize::new(0);
static UNNAMED_COMPONENT_COUNTER: AtomicUsize = AtomicUsize::new(0);

/// Result of expanding a component block
#[derive(Debug, Clone)]
pub struct ExpansionResult {
    pub type_decl: Option<Statement>,
    pub statements: Vec<Statement>,
    pub startup_stmts: Vec<Statement>,
    pub main_end_stmts: Vec<Statement>,
    pub static_methods: Vec<(String, String, String)>,
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
// Serializes schema fields to JSON for the native provider library to generate SQL.
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
    model_ref: Option<String>,
    schema: Vec<ComponentSchemaField>,
    schema_json: String,
    config: Vec<ComponentConfig>,
}

struct HookInfo {
    param_name: String,
    body: Block,
}

// ---- Recursive AST substitution ----

fn substitute_ident_string(s: &str, ctx: &SubstitutionContext) -> String {
    let mut result = s.to_string();
    if let Some(ref mr) = ctx.model_ref {
        if result.contains("__tpl_model_ref") {
            result = result.replace("__tpl_model_ref", mr);
        }
    }
    if result.contains("__tpl_name") {
        result = result.replace("__tpl_name", &ctx.name);
    }
    result
}

fn substitute_expr(expr: &Expr, ctx: &SubstitutionContext) -> Expr {
    match expr {
        Expr::Ident(name, span) => {
            // Special magic variables → string literals
            if name == "__tpl_name_str" {
                return Expr::StringLit(ctx.name.clone(), *span);
            }
            if name == "__tpl_schema_json" {
                return Expr::StringLit(ctx.schema_json.clone(), *span);
            }
            if name == "__tpl_model_ref_str" {
                if let Some(ref mr) = ctx.model_ref {
                    return Expr::StringLit(mr.clone(), *span);
                }
            }
            // Config access: __tpl_config_KEY → value from component config
            if name.starts_with("__tpl_config_") {
                let key = &name["__tpl_config_".len()..];
                if let Some(cfg) = ctx.config.iter().find(|c| c.key == key) {
                    return substitute_expr(&cfg.value, ctx);
                }
            }
            // Substring replacement for other __tpl_ idents
            Expr::Ident(substitute_ident_string(name, ctx), *span)
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
        Expr::MemberAccess { object, field, span } => Expr::MemberAccess {
            object: Box::new(substitute_expr(object, ctx)),
            field: field.clone(),
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
            if name == "__tpl_name" {
                return TypeExpr::Named(ctx.name.clone());
            }
            if name == "__tpl_schema" {
                return TypeExpr::Struct {
                    fields: ctx
                        .schema
                        .iter()
                        .map(|f| (f.name.clone(), f.type_ann.clone(), Vec::new()))
                        .collect(),
                };
            }
            // Schema excluding @hidden fields — used for response types
            if name == "__tpl_schema_visible" {
                return TypeExpr::Struct {
                    fields: ctx
                        .schema
                        .iter()
                        .filter(|f| !f.annotations.iter().any(|a| a.name == "hidden"))
                        .map(|f| (f.name.clone(), f.type_ann.clone(), Vec::new()))
                        .collect(),
                };
            }
            if name == "__tpl_model_ref" {
                if let Some(ref mr) = ctx.model_ref {
                    return TypeExpr::Named(mr.clone());
                }
            }
            TypeExpr::Named(name.clone())
        }
        TypeExpr::Nullable(inner) => {
            TypeExpr::Nullable(Box::new(substitute_type_expr(inner, ctx)))
        }
        TypeExpr::Generic { name, args } => TypeExpr::Generic {
            name: name.clone(),
            args: args.iter().map(|a| substitute_type_expr(a, ctx)).collect(),
        },
        TypeExpr::Union(types) => {
            TypeExpr::Union(types.iter().map(|t| substitute_type_expr(t, ctx)).collect())
        }
        TypeExpr::Tuple(types) => {
            TypeExpr::Tuple(types.iter().map(|t| substitute_type_expr(t, ctx)).collect())
        }
        TypeExpr::Function { params, return_type } => TypeExpr::Function {
            params: params.iter().map(|t| substitute_type_expr(t, ctx)).collect(),
            return_type: Box::new(substitute_type_expr(return_type, ctx)),
        },
        TypeExpr::Struct { fields } => TypeExpr::Struct {
            fields: fields
                .iter()
                .map(|(n, t, a)| (n.clone(), substitute_type_expr(t, ctx), a.clone()))
                .collect(),
        },
        TypeExpr::Without { base, fields } => TypeExpr::Without {
            base: Box::new(substitute_type_expr(base, ctx)),
            fields: fields.clone(),
        },
        TypeExpr::TypeWith { base, fields } => TypeExpr::TypeWith {
            base: Box::new(substitute_type_expr(base, ctx)),
            fields: fields.iter().map(|(n, t, a)| (n.clone(), substitute_type_expr(t, ctx), a.clone())).collect(),
        },
        TypeExpr::Only { base, fields } => TypeExpr::Only {
            base: Box::new(substitute_type_expr(base, ctx)),
            fields: fields.clone(),
        },
        TypeExpr::AsPartial(base) => TypeExpr::AsPartial(Box::new(substitute_type_expr(base, ctx))),
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
    match stmt {
        Statement::Let { name, type_ann, value, exported, span, .. } => Statement::Let {
            name: name.clone(),
            type_ann: type_ann.as_ref().map(|t| substitute_type_expr(t, ctx)),
            type_ann_span: None,
            value: substitute_expr(value, ctx),
            exported: *exported,
            span: *span,
        },
        Statement::Mut { name, type_ann, value, exported, span, .. } => Statement::Mut {
            name: name.clone(),
            type_ann: type_ann.as_ref().map(|t| substitute_type_expr(t, ctx)),
            type_ann_span: None,
            value: substitute_expr(value, ctx),
            exported: *exported,
            span: *span,
        },
        Statement::Const { name, type_ann, value, exported, span, .. } => Statement::Const {
            name: name.clone(),
            type_ann: type_ann.as_ref().map(|t| substitute_type_expr(t, ctx)),
            type_ann_span: None,
            value: substitute_expr(value, ctx),
            exported: *exported,
            span: *span,
        },
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

    // Generate a unique name for __tpl_generated
    let gen_id = GENERATED_COUNTER.fetch_add(1, Ordering::SeqCst);
    let generated_name = format!("__generated_handler_{}", gen_id);

    // Process the syntax fn body: substitute param references with captured values,
    // then apply the normal __tpl_* substitution
    let mut expanded_stmts = Vec::new();
    for stmt in &syntax_fn.body.statements {
        let substituted = substitute_stmt(stmt, ctx);
        let with_args = substitute_syntax_args_with_services(&substituted, &arg_map, service_infos);
        // Replace __tpl_generated with unique name
        let with_generated = replace_tpl_generated(&with_args, &generated_name);
        expanded_stmts.push(with_generated);
    }
    expanded_stmts
}

/// Like substitute_syntax_args but passes service_infos through for __tpl_resolve_service
fn substitute_syntax_args_with_services(stmt: &Statement, args: &std::collections::HashMap<String, Expr>, service_infos: &[ServiceInfo]) -> Statement {
    match stmt {
        Statement::Expr(expr) => Statement::Expr(substitute_syntax_args_expr(expr, args, service_infos)),
        Statement::Let { name, type_ann, value, exported, span, .. } => {
            // Handle __tpl_handler_param_N: bind closure param names to template-provided values
            if let Some(idx_str) = name.strip_prefix("__tpl_handler_param_") {
                if let Ok(idx) = idx_str.parse::<usize>() {
                    // Find the first closure in args and extract its Nth param
                    if let Some(closure_param) = find_closure_param_in_args(args, idx) {
                        let substituted_value = substitute_syntax_args_expr(value, args, service_infos);
                        // If the closure param has a type annotation, wrap with json.parse()
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
                        return Statement::Let {
                            name: final_name,
                            type_ann: final_type_ann,
                            type_ann_span: None,
                            value: final_value,
                            exported: *exported,
                            span: *span,
                        };
                    }
                    // No matching closure param — drop this placeholder binding
                    return Statement::Expr(Expr::IntLit(0, sp()));
                }
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
    use crate::feature::FeatureStmt;
    use crate::feature_data;

    match (fe.feature_id, fe.kind) {
        ("variables", "Let") | ("variables", "Mut") | ("variables", "Const") => {
            use crate::features::variables::types::VarDeclData;
            if let Some(data) = feature_data!(fe, VarDeclData) {
                // Handle __tpl_handler_param_N for Let kind
                if fe.kind == "Let" {
                    if let Some(idx_str) = data.name.strip_prefix("__tpl_handler_param_") {
                        if let Ok(idx) = idx_str.parse::<usize>() {
                            if let Some(closure_param) = find_closure_param_in_args(args, idx) {
                                let substituted_value = substitute_syntax_args_expr(&data.value, args, service_infos);
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
                                // Return as old-style Let since that's what template expansion expects
                                return Statement::Let {
                                    name: final_name,
                                    type_ann: final_type_ann,
                                    type_ann_span: None,
                                    value: final_value,
                                    exported: data.exported,
                                    span: fe.span,
                                };
                            }
                            return Statement::Expr(Expr::IntLit(0, sp()));
                        }
                    }
                }
                let new_data = VarDeclData {
                    kind: data.kind.clone(),
                    name: data.name.clone(),
                    type_ann: data.type_ann.clone(),
                    type_ann_span: data.type_ann_span,
                    value: substitute_syntax_args_expr(&data.value, args, service_infos),
                    exported: data.exported,
                };
                Statement::Feature(FeatureStmt {
                    feature_id: fe.feature_id,
                    kind: fe.kind,
                    data: Box::new(new_data),
                    span: fe.span,
                })
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
                Statement::Feature(FeatureStmt {
                    feature_id: fe.feature_id,
                    kind: fe.kind,
                    data: Box::new(new_data),
                    span: fe.span,
                })
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
                Statement::Feature(FeatureStmt {
                    feature_id: fe.feature_id,
                    kind: fe.kind,
                    data: Box::new(new_data),
                    span: fe.span,
                })
            } else {
                Statement::Feature(fe.clone())
            }
        }
        _ => Statement::Feature(fe.clone()),
    }
}

/// Replace all occurrences of __tpl_generated in FnDecl names and Ident references
fn replace_tpl_generated(stmt: &Statement, generated_name: &str) -> Statement {
    match stmt {
        Statement::FnDecl { name, type_params, params, return_type, body, exported, span } => {
            let new_name = if name == "__tpl_generated" {
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
                        .map(|s| replace_tpl_generated(s, generated_name))
                        .collect(),
                    span: body.span,
                },
                exported: *exported,
                span: *span,
            }
        }
        Statement::Expr(expr) => Statement::Expr(replace_tpl_generated_expr(expr, generated_name)),
        Statement::Let { name, type_ann, value, exported, span, .. } => Statement::Let {
            name: name.clone(),
            type_ann: type_ann.clone(),
            type_ann_span: None,
            value: replace_tpl_generated_expr(value, generated_name),
            exported: *exported,
            span: *span,
        },
        Statement::Feature(fe) => {
            replace_tpl_generated_feature_stmt(fe, generated_name)
        }
        _ => stmt.clone(),
    }
}

/// Handle Feature variant in replace_tpl_generated
fn replace_tpl_generated_feature_stmt(fe: &crate::feature::FeatureStmt, generated_name: &str) -> Statement {
    use crate::feature::FeatureStmt;
    use crate::feature_data;

    match (fe.feature_id, fe.kind) {
        ("functions", "FnDecl") => {
            use crate::features::functions::types::FnDeclData;
            if let Some(data) = feature_data!(fe, FnDeclData) {
                let new_name = if data.name == "__tpl_generated" {
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
                            .map(|s| replace_tpl_generated(s, generated_name))
                            .collect(),
                        span: data.body.span,
                    },
                    exported: data.exported,
                };
                Statement::Feature(FeatureStmt {
                    feature_id: fe.feature_id,
                    kind: fe.kind,
                    data: Box::new(new_data),
                    span: fe.span,
                })
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
                    value: replace_tpl_generated_expr(&data.value, generated_name),
                    exported: data.exported,
                };
                Statement::Feature(FeatureStmt {
                    feature_id: fe.feature_id,
                    kind: fe.kind,
                    data: Box::new(new_data),
                    span: fe.span,
                })
            } else {
                Statement::Feature(fe.clone())
            }
        }
        _ => Statement::Feature(fe.clone()),
    }
}

fn replace_tpl_generated_expr(expr: &Expr, generated_name: &str) -> Expr {
    match expr {
        Expr::Ident(name, span) => {
            if name == "__tpl_generated" {
                Expr::Ident(generated_name.to_string(), *span)
            } else {
                expr.clone()
            }
        }
        Expr::Call { callee, args, type_args, span } => Expr::Call {
            callee: Box::new(replace_tpl_generated_expr(callee, generated_name)),
            args: args.iter().map(|a| CallArg {
                name: a.name.clone(),
                value: replace_tpl_generated_expr(&a.value, generated_name),
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
            // Handle __tpl_resolve_service() intrinsic
            if let Expr::Ident(name, _) = callee.as_ref() {
                if name == "__tpl_resolve_service" {
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
        let fn_name = format!("{}_{}", ctx.name, method_name);
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
        stmt_clone_with_sub(decl, ctx)
    }
}

fn stmt_clone_with_sub(stmt: &Statement, ctx: &SubstitutionContext) -> Statement {
    substitute_stmt(stmt, ctx)
}

/// Inject before/after hooks into a template-generated component function.
/// Prepends before hook body and appends after hook body around the original function body.
/// Works with any component template that declares events (model, service, etc.).
///
/// Hook param binding conventions (all generic, zero provider knowledge):
/// - Before hooks with `__raw_` prefix: model `on` syntax, bind param via `json.parse(first_string_param)` as component type
/// - Before hooks without prefix, param not in fn scope, model_ref set: service hook,
///   bind param via `json.parse(first_string_param)` as the wrapped component's type
/// - After hooks with `__raw_` prefix: fetch full record via `get_internal(id_var)`
/// - After hooks without prefix, param not in fn scope, model_ref set: service hook,
///   fetch full record via `{model_ref}_get_internal(id_var)`
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
                if let Some(model_ref) = &ctx.model_ref {
                    // Service hook: bind param to parsed struct from first string param
                    let first_string_param = params.iter()
                        .find(|p| matches!(&p.type_ann, Some(TypeExpr::Named(t)) if t == "string"))
                        .map(|p| p.name.clone());
                    if let Some(str_param) = first_string_param {
                        new_stmts.push(let_typed(
                            &hook.param_name,
                            named_type(model_ref),
                            method_call("json", "parse", vec![ident(&str_param)]),
                        ));
                    }
                }
            } else if hook.param_name.starts_with("__raw_") {
                // Model hook: bind original param name to json.parse(first_string_param)
                // typed as the component's type so the user can access fields like data.title
                let first_string_param = params.iter()
                    .find(|p| matches!(&p.type_ann, Some(TypeExpr::Named(t)) if t == "string"))
                    .map(|p| p.name.clone());
                if let Some(str_param) = first_string_param {
                    new_stmts.push(let_typed(
                        &original_name,
                        named_type(&ctx.name),
                        method_call("json", "parse", vec![ident(&str_param)]),
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
                    // If the fn already returns a struct (e.g. update returns __tpl_name),
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
                    if let Some(model_ref) = &ctx.model_ref {
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

    for stmt in blocks {
        if let Statement::FnDecl { name, params, body, .. } = stmt {
            if name.starts_with("__hook_before_") {
                let operation = name.trim_start_matches("__hook_before_").to_string();
                let param_name = params
                    .first()
                    .map(|p| p.name.clone())
                    .unwrap_or_default();
                before_hooks.insert(
                    operation,
                    HookInfo { param_name, body: body.clone() },
                );
            } else if name.starts_with("__hook_after_") {
                let operation = name.trim_start_matches("__hook_after_").to_string();
                let param_name = params
                    .first()
                    .map(|p| p.name.clone())
                    .unwrap_or_default();
                after_hooks.insert(
                    operation,
                    HookInfo { param_name, body: body.clone() },
                );
            } else if name.starts_with("on_before_") {
                // on before_create(data) { ... } syntax
                let operation = name.trim_start_matches("on_before_").to_string();
                let param_name = params
                    .first()
                    .map(|p| p.name.clone())
                    .unwrap_or_default();
                before_hooks.insert(
                    operation,
                    HookInfo { param_name, body: body.clone() },
                );
            } else if name.starts_with("on_after_") {
                // on after_create(record) { ... } syntax
                let operation = name.trim_start_matches("on_after_").to_string();
                let param_name = params
                    .first()
                    .map(|p| p.name.clone())
                    .unwrap_or_default();
                after_hooks.insert(
                    operation,
                    HookInfo { param_name, body: body.clone() },
                );
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
    let model_ref = match ctx.model_ref.as_ref() {
        Some(mr) => mr,
        None => return,
    };

    for method_stmt in custom_methods {
        if let Statement::FnDecl { name, params, return_type, body, .. } = method_stmt {
            let new_name = format!("{}_{}", ctx.name, name);

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
                params: new_params,
                return_type: new_return_type,
                body: body.clone(),
                exported: false,
                span: sp(),
            });

            result.static_methods.push((
                ctx.name.clone(),
                name.clone(),
                new_name,
            ));
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
            let fn_name = format!("{}_{}", ctx.name, name);
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
    /// Expand a component block using a provider template definition.
    pub fn expand_from_template(
        template: &ComponentTemplateDef,
        decl: &ComponentBlockDecl,
        service_infos: &[ServiceInfo],
    ) -> ExpansionResult {
        let name = match decl.args.first() {
            Some(ComponentArg::Ident(name, _)) => name.clone(),
            _ => {
                // Auto-generate name for unnamed components (e.g., `server :3000 { ... }`)
                let id = UNNAMED_COMPONENT_COUNTER.fetch_add(1, Ordering::SeqCst);
                format!("__{}{}", decl.component, id)
            }
        };

        let model_ref = decl
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

        let ctx = SubstitutionContext { name, model_ref, schema, schema_json, config: resolved_config };

        // Extract hooks and custom methods from user body
        let (before_hooks, after_hooks, custom_methods) =
            extract_hooks_and_methods(&decl.body.blocks);

        let mut result = ExpansionResult::new();

        for item in &template.body {
            match item {
                ComponentTemplateItem::TypeFromSchema { visible_only } => {
                    let fields: Vec<_> = if *visible_only {
                        ctx.schema.iter()
                            .filter(|f| !f.annotations.iter().any(|a| a.name == "hidden"))
                            .map(|f| (f.name.clone(), f.type_ann.clone(), Vec::new()))
                            .collect()
                    } else {
                        ctx.schema.iter()
                            .map(|f| (f.name.clone(), f.type_ann.clone(), Vec::new()))
                            .collect()
                    };
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
                    let fn_name = format!("{}_{}", ctx.name, method_name);

                    if template.has_model_ref {
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
                            result.static_methods.push((
                                ctx.name.clone(),
                                method_name.clone(),
                                fn_name,
                            ));
                        } else {
                            // No hooks: map directly to model method
                            let model_ref = ctx.model_ref.as_ref().unwrap();
                            let model_fn = format!("{}_{}", model_ref, method_name);
                            result.static_methods.push((
                                ctx.name.clone(),
                                method_name.clone(),
                                model_fn,
                            ));
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
                        result.static_methods.push((
                            ctx.name.clone(),
                            method_name.clone(),
                            fn_name,
                        ));
                    }
                }
                ComponentTemplateItem::ExternFn(ef) => {
                    result.extern_fns.push(ef.clone());
                }
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
                        let stub_name = format!("{}_{}", ctx.name, event_name);
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

        // Handle custom methods from user body
        if template.has_model_ref {
            expand_custom_methods(&custom_methods, &ctx, &mut result);
        } else if !custom_methods.is_empty() {
            expand_simple_methods(&custom_methods, &ctx, &mut result);
        }

        // Populate service metadata for server mount resolution
        if template.has_model_ref {
            // Service template: build ServiceInfo
            let hooks: Vec<ServiceHook> = {
                let mut h = Vec::new();
                for (op, info) in &before_hooks {
                    h.push(ServiceHook {
                        timing: HookTiming::Before,
                        operation: op.clone(),
                        param: info.param_name.clone(),
                        body: info.body.clone(),
                        span: sp(),
                    });
                }
                for (op, info) in &after_hooks {
                    h.push(ServiceHook {
                        timing: HookTiming::After,
                        operation: op.clone(),
                        param: info.param_name.clone(),
                        body: info.body.clone(),
                        span: sp(),
                    });
                }
                h
            };
            result.service_info = Some(ServiceInfo {
                name: ctx.name.clone(),
                for_model: ctx.model_ref.clone().unwrap_or_default(),
                hooks,
                methods: custom_methods.clone(),
            });
        }

        result
    }
}
