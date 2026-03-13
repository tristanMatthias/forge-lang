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

fn param(name: &str, ty: TypeExpr) -> Param {
    Param {
        name: name.to_string(),
        type_ann: Some(ty),
        default: None,
        span: sp(),
    }
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
        Expr::Call { callee, args, span } => Expr::Call {
            callee: Box::new(substitute_expr(callee, ctx)),
            args: args
                .iter()
                .map(|a| CallArg {
                    name: a.name.clone(),
                    value: substitute_expr(&a.value, ctx),
                })
                .collect(),
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
        Expr::If { condition, then_branch, else_branch, span } => Expr::If {
            condition: Box::new(substitute_expr(condition, ctx)),
            then_branch: substitute_block(then_branch, ctx),
            else_branch: else_branch.as_ref().map(|b| substitute_block(b, ctx)),
            span: *span,
        },
        Expr::Block(block) => Expr::Block(substitute_block(block, ctx)),
        Expr::Index { object, index, span } => Expr::Index {
            object: Box::new(substitute_expr(object, ctx)),
            index: Box::new(substitute_expr(index, ctx)),
            span: *span,
        },
        Expr::Pipe { left, right, span } => Expr::Pipe {
            left: Box::new(substitute_expr(left, ctx)),
            right: Box::new(substitute_expr(right, ctx)),
            span: *span,
        },
        Expr::ListLit { elements, span } => Expr::ListLit {
            elements: elements.iter().map(|e| substitute_expr(e, ctx)).collect(),
            span: *span,
        },
        Expr::MapLit { entries, span } => Expr::MapLit {
            entries: entries
                .iter()
                .map(|(k, v)| (substitute_expr(k, ctx), substitute_expr(v, ctx)))
                .collect(),
            span: *span,
        },
        Expr::StructLit { name, fields, span } => Expr::StructLit {
            name: name.as_ref().map(|n| substitute_ident_string(n, ctx)),
            fields: fields
                .iter()
                .map(|(k, v)| (k.clone(), substitute_expr(v, ctx)))
                .collect(),
            span: *span,
        },
        Expr::TupleLit { elements, span } => Expr::TupleLit {
            elements: elements.iter().map(|e| substitute_expr(e, ctx)).collect(),
            span: *span,
        },
        Expr::Closure { params, body, span } => Expr::Closure {
            params: params.iter().map(|p| substitute_param(p, ctx)).collect(),
            body: Box::new(substitute_expr(body, ctx)),
            span: *span,
        },
        Expr::Match { subject, arms, span } => Expr::Match {
            subject: Box::new(substitute_expr(subject, ctx)),
            arms: arms
                .iter()
                .map(|a| MatchArm {
                    pattern: a.pattern.clone(),
                    guard: a.guard.as_ref().map(|g| substitute_expr(g, ctx)),
                    body: substitute_expr(&a.body, ctx),
                    span: a.span,
                })
                .collect(),
            span: *span,
        },
        Expr::NullCoalesce { left, right, span } => Expr::NullCoalesce {
            left: Box::new(substitute_expr(left, ctx)),
            right: Box::new(substitute_expr(right, ctx)),
            span: *span,
        },
        Expr::NullPropagate { object, field, span } => Expr::NullPropagate {
            object: Box::new(substitute_expr(object, ctx)),
            field: field.clone(),
            span: *span,
        },
        Expr::ErrorPropagate { operand, span } => Expr::ErrorPropagate {
            operand: Box::new(substitute_expr(operand, ctx)),
            span: *span,
        },
        Expr::With { base, updates, span } => Expr::With {
            base: Box::new(substitute_expr(base, ctx)),
            updates: updates
                .iter()
                .map(|(k, v)| (k.clone(), substitute_expr(v, ctx)))
                .collect(),
            span: *span,
        },
        Expr::Range { start, end, inclusive, span } => Expr::Range {
            start: Box::new(substitute_expr(start, ctx)),
            end: Box::new(substitute_expr(end, ctx)),
            inclusive: *inclusive,
            span: *span,
        },
        Expr::OkExpr { value, span } => Expr::OkExpr {
            value: Box::new(substitute_expr(value, ctx)),
            span: *span,
        },
        Expr::ErrExpr { value, span } => Expr::ErrExpr {
            value: Box::new(substitute_expr(value, ctx)),
            span: *span,
        },
        Expr::Catch { expr, binding, handler, span } => Expr::Catch {
            expr: Box::new(substitute_expr(expr, ctx)),
            binding: binding.clone(),
            handler: substitute_block(handler, ctx),
            span: *span,
        },
        Expr::ChannelSend { channel, value, span } => Expr::ChannelSend {
            channel: Box::new(substitute_expr(channel, ctx)),
            value: Box::new(substitute_expr(value, ctx)),
            span: *span,
        },
        Expr::ChannelReceive { channel, span } => Expr::ChannelReceive {
            channel: Box::new(substitute_expr(channel, ctx)),
            span: *span,
        },
        Expr::SpawnBlock { body, span } => Expr::SpawnBlock {
            body: substitute_block(body, ctx),
            span: *span,
        },
        Expr::DollarExec { parts, span } => Expr::DollarExec {
            parts: parts
                .iter()
                .map(|p| match p {
                    crate::parser::ast::TemplatePart::Literal(s) => {
                        crate::parser::ast::TemplatePart::Literal(substitute_ident_string(s, ctx))
                    }
                    crate::parser::ast::TemplatePart::Expr(e) => {
                        crate::parser::ast::TemplatePart::Expr(Box::new(substitute_expr(e, ctx)))
                    }
                })
                .collect(),
            span: *span,
        },
        Expr::Is { value, pattern, negated, span } => Expr::Is {
            value: Box::new(substitute_expr(value, ctx)),
            pattern: pattern.clone(),
            negated: *negated,
            span: *span,
        },
        Expr::TableLit { columns, rows, span } => Expr::TableLit {
            columns: columns.clone(),
            rows: rows.iter().map(|row| row.iter().map(|e| substitute_expr(e, ctx)).collect()).collect(),
            span: *span,
        },
    }
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
                        .map(|f| (f.name.clone(), f.type_ann.clone()))
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
                .map(|(n, t)| (n.clone(), substitute_type_expr(t, ctx)))
                .collect(),
        },
        TypeExpr::Without { base, fields } => TypeExpr::Without {
            base: Box::new(substitute_type_expr(base, ctx)),
            fields: fields.clone(),
        },
        TypeExpr::TypeWith { base, fields } => TypeExpr::TypeWith {
            base: Box::new(substitute_type_expr(base, ctx)),
            fields: fields.iter().map(|(n, t)| (n.clone(), substitute_type_expr(t, ctx))).collect(),
        },
        TypeExpr::Only { base, fields } => TypeExpr::Only {
            base: Box::new(substitute_type_expr(base, ctx)),
            fields: fields.clone(),
        },
        TypeExpr::AsPartial(base) => TypeExpr::AsPartial(Box::new(substitute_type_expr(base, ctx))),
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
        // Pass through unchanged
        _ => stmt.clone(),
    }
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
        Statement::Let { name, type_ann, value, exported, span, .. } => Statement::Let {
            name: name.clone(),
            type_ann: type_ann.clone(),
            type_ann_span: None,
            value: substitute_syntax_args_expr(value, args, service_infos),
            exported: *exported,
            span: *span,
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
        _ => stmt.clone(),
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
        _ => stmt.clone(),
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
        Expr::Call { callee, args, span } => Expr::Call {
            callee: Box::new(replace_tpl_generated_expr(callee, generated_name)),
            args: args.iter().map(|a| CallArg {
                name: a.name.clone(),
                value: replace_tpl_generated_expr(&a.value, generated_name),
            }).collect(),
            span: *span,
        },
        _ => expr.clone(),
    }
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
                if let Expr::Closure { body, .. } = replacement {
                    return *body.clone();
                }
                return replacement.clone();
            }
            expr.clone()
        }
        Expr::Call { callee, args: call_args, span } => {
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
        Expr::StructLit { name, fields, span } => Expr::StructLit {
            name: name.clone(),
            fields: fields.iter()
                .map(|(k, v)| (k.clone(), substitute_syntax_args_expr(v, args, service_infos)))
                .collect(),
            span: *span,
        },
        Expr::TemplateLit { parts, span } => Expr::TemplateLit {
            parts: parts.iter()
                .map(|p| match p {
                    TemplatePart::Literal(s) => TemplatePart::Literal(s.clone()),
                    TemplatePart::Expr(e) => TemplatePart::Expr(Box::new(substitute_syntax_args_expr(e, args, service_infos))),
                })
                .collect(),
            span: *span,
        },
        Expr::NullCoalesce { left, right, span } => Expr::NullCoalesce {
            left: Box::new(substitute_syntax_args_expr(left, args, service_infos)),
            right: Box::new(substitute_syntax_args_expr(right, args, service_infos)),
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

fn build_hooked_fn(
    method: &str,
    ctx: &SubstitutionContext,
    before_hooks: &HashMap<String, HookInfo>,
    after_hooks: &HashMap<String, HookInfo>,
) -> Statement {
    let model_ref = ctx.model_ref.as_ref().unwrap();
    let fn_name = format!("{}_{}", ctx.name, method);
    let mut body_stmts = Vec::new();

    if method == "create" {
        // Before hook: parse data_json to struct, run hook body
        if let Some(hook) = before_hooks.get("create") {
            body_stmts.push(let_typed(
                &hook.param_name,
                named_type(model_ref),
                method_call("json", "parse", vec![ident("data_json")]),
            ));
            body_stmts.extend(hook.body.statements.clone());
        }

        // Call model create
        let model_create = format!("{}_create", model_ref);
        body_stmts.push(let_stmt("__id", call(&model_create, vec![ident("data_json")])));

        // After hook: get full record, run hook body
        if let Some(hook) = after_hooks.get("create") {
            let get_internal = format!("{}_get_internal", model_ref);
            body_stmts.push(let_stmt(
                &hook.param_name,
                call(&get_internal, vec![ident("__id")]),
            ));
            body_stmts.extend(hook.body.statements.clone());
        }

        body_stmts.push(expr_stmt(ident("__id")));

        fn_decl(
            &fn_name,
            vec![param("data_json", named_type("string"))],
            Some(named_type("int")),
            body_stmts,
        )
    } else {
        // For other hooked ops, generate a simple wrapper (can be extended later)
        fn_decl(&fn_name, vec![], None, vec![])
    }
}

/// Inject before/after hooks into a template-generated component function.
/// Prepends before hook body and appends after hook body around the original function body.
/// Works with any component template that declares events (model, service, etc.).
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
            inject_hook_body(&hook.body, &hook.param_name, &mut new_stmts);
        }

        // Original template function body
        new_stmts.extend(body.statements.clone());

        // After hook: inject user's hook body after the template function body
        if let Some(hook) = after_hooks.get(method_name) {
            if !new_stmts.is_empty() {
                // Preserve the return value: pop last expr, inject hook, push back
                let last = new_stmts.pop();
                // Try to bind hook param to result via get_internal if available
                let get_internal = format!("{}_get_internal", ctx.name);
                let original_name = strip_raw_prefix(&hook.param_name);
                new_stmts.push(let_stmt(
                    &original_name,
                    call(&get_internal, vec![ident("__id")]),
                ));
                inject_hook_body(&hook.body, &hook.param_name, &mut new_stmts);
                if let Some(l) = last {
                    new_stmts.push(l);
                }
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

        // Resolve config: merge user config with schema defaults
        let resolved_config = resolve_config(&merged_config, &template.config_schema);

        let ctx = SubstitutionContext { name, model_ref, schema, schema_json, config: resolved_config };

        // Extract hooks and custom methods from user body
        let (before_hooks, after_hooks, custom_methods) =
            extract_hooks_and_methods(&decl.body.blocks);

        let mut result = ExpansionResult::new();

        for item in &template.body {
            match item {
                ComponentTemplateItem::TypeFromSchema => {
                    result.type_decl = Some(Statement::TypeDecl {
                        name: ctx.name.clone(),
                        type_params: Vec::new(),
                        value: TypeExpr::Struct {
                            fields: ctx
                                .schema
                                .iter()
                                .map(|f| (f.name.clone(), f.type_ann.clone()))
                                .collect(),
                        },
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
                            // Generate hooked wrapper
                            let wrapper = build_hooked_fn(
                                method_name,
                                &ctx,
                                &before_hooks,
                                &after_hooks,
                            );
                            result.statements.push(wrapper);
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
                        matches!(s, Statement::FnDecl { name, .. } if name == &handler_name)
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
            if let Statement::Expr(Expr::Call { callee, args, .. }) = stmt {
                if let Expr::Ident(name, _) = callee.as_ref() {
                    if name.starts_with("__component_") {
                        let fn_name = name.trim_start_matches("__component_");
                        if let Some(syntax_fn) = template.syntax_fns.iter().find(|sf| sf.fn_name == fn_name) {
                            // Substitute captured args into the syntax fn body
                            let expanded = expand_syntax_call(syntax_fn, args, &ctx, service_infos);
                            for s in expanded {
                                match s {
                                    Statement::FnDecl { .. } => result.statements.push(s),
                                    _ => result.startup_stmts.push(s),
                                }
                            }
                        }
                    }
                }
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
