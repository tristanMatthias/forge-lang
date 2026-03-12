pub mod syntax;

use crate::codegen::ServiceInfo;
use crate::lexer::Span;
use crate::parser::ast::*;
use std::collections::HashMap;

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

fn string_lit(s: &str) -> Expr {
    Expr::StringLit(s.to_string(), sp())
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
        value,
        exported: false,
        span: sp(),
    }
}

fn let_typed(name: &str, ty: TypeExpr, value: Expr) -> Statement {
    Statement::Let {
        name: name.to_string(),
        type_ann: Some(ty),
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

fn build_schema_json(fields: &[ComponentSchemaField]) -> String {
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
        Statement::Let { name, type_ann, value, exported, span } => Statement::Let {
            name: name.clone(),
            type_ann: type_ann.as_ref().map(|t| substitute_type_expr(t, ctx)),
            value: substitute_expr(value, ctx),
            exported: *exported,
            span: *span,
        },
        Statement::Mut { name, type_ann, value, exported, span } => Statement::Mut {
            name: name.clone(),
            type_ann: type_ann.as_ref().map(|t| substitute_type_expr(t, ctx)),
            value: substitute_expr(value, ctx),
            exported: *exported,
            span: *span,
        },
        Statement::Const { name, type_ann, value, exported, span } => Statement::Const {
            name: name.clone(),
            type_ann: type_ann.as_ref().map(|t| substitute_type_expr(t, ctx)),
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
) -> Vec<Statement> {
    // Build a map of param_name → captured value (as Expr)
    let mut arg_map: std::collections::HashMap<String, Expr> = std::collections::HashMap::new();
    for arg in args {
        if let Some(ref name) = arg.name {
            arg_map.insert(name.clone(), arg.value.clone());
        }
    }

    // Process the syntax fn body: substitute param references with captured values,
    // then apply the normal __tpl_* substitution
    let mut expanded_stmts = Vec::new();
    for stmt in &syntax_fn.body.statements {
        let substituted = substitute_stmt(stmt, ctx);
        let with_args = substitute_syntax_args(&substituted, &arg_map);
        expanded_stmts.push(with_args);
    }
    expanded_stmts
}

/// Replace identifiers that match syntax fn param names with their captured values
fn substitute_syntax_args(stmt: &Statement, args: &std::collections::HashMap<String, Expr>) -> Statement {
    match stmt {
        Statement::Expr(expr) => Statement::Expr(substitute_syntax_args_expr(expr, args)),
        Statement::Let { name, type_ann, value, exported, span } => Statement::Let {
            name: name.clone(),
            type_ann: type_ann.clone(),
            value: substitute_syntax_args_expr(value, args),
            exported: *exported,
            span: *span,
        },
        Statement::Return { value, span } => Statement::Return {
            value: value.as_ref().map(|v| substitute_syntax_args_expr(v, args)),
            span: *span,
        },
        _ => stmt.clone(),
    }
}

fn substitute_syntax_args_expr(expr: &Expr, args: &std::collections::HashMap<String, Expr>) -> Expr {
    match expr {
        Expr::Ident(name, span) => {
            if let Some(replacement) = args.get(name) {
                return replacement.clone();
            }
            expr.clone()
        }
        Expr::Call { callee, args: call_args, span } => Expr::Call {
            callee: Box::new(substitute_syntax_args_expr(callee, args)),
            args: call_args.iter().map(|a| CallArg {
                name: a.name.clone(),
                value: substitute_syntax_args_expr(&a.value, args),
            }).collect(),
            span: *span,
        },
        Expr::MemberAccess { object, field, span } => Expr::MemberAccess {
            object: Box::new(substitute_syntax_args_expr(object, args)),
            field: field.clone(),
            span: *span,
        },
        Expr::Binary { left, op, right, span } => Expr::Binary {
            left: Box::new(substitute_syntax_args_expr(left, args)),
            op: *op,
            right: Box::new(substitute_syntax_args_expr(right, args)),
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
    /// Expand a component block using the old hardcoded path (server only).
    pub fn expand(component: &str, decl: &ComponentBlockDecl, service_infos: &[ServiceInfo]) -> ExpansionResult {
        match component {
            "server" => Self::expand_server(decl, service_infos),
            _ => ExpansionResult::new(),
        }
    }

    /// Expand a component block using a provider template definition.
    pub fn expand_from_template(
        template: &ComponentTemplateDef,
        decl: &ComponentBlockDecl,
    ) -> ExpansionResult {
        let name = match decl.args.first() {
            Some(ComponentArg::Ident(name, _)) => name.clone(),
            _ => return ExpansionResult::new(),
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
            build_schema_json(&schema)
        } else {
            String::new()
        };

        // Resolve config: merge user config with schema defaults
        let resolved_config = resolve_config(&decl.body.config, &template.config_schema);

        let ctx = SubstitutionContext { name, model_ref, schema, schema_json, config: resolved_config };

        // Extract hooks and custom methods from user body
        let (before_hooks, after_hooks, custom_methods) = if template.has_model_ref {
            extract_hooks_and_methods(&decl.body.blocks)
        } else {
            let methods: Vec<Statement> = decl.body.blocks.iter()
                .filter(|s| matches!(s, Statement::FnDecl { .. }))
                .cloned().collect();
            (HashMap::new(), HashMap::new(), methods)
        };

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
                        result.statements.push(substituted);
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
        // These expand into startup statements (they run during component initialization)
        for stmt in &decl.body.blocks {
            if let Statement::Expr(Expr::Call { callee, args, .. }) = stmt {
                if let Expr::Ident(name, _) = callee.as_ref() {
                    if name.starts_with("__component_") {
                        let fn_name = name.trim_start_matches("__component_");
                        if let Some(syntax_fn) = template.syntax_fns.iter().find(|sf| sf.fn_name == fn_name) {
                            // Substitute captured args into the syntax fn body
                            let expanded = expand_syntax_call(syntax_fn, args, &ctx);
                            for s in expanded {
                                result.startup_stmts.push(s);
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

    /// Expand a server component block into pure AST.
    /// - Mount → startup stmt calling forge_http_mount_crud(table, path)
    /// - Route → FnDecl for C ABI handler + startup stmt calling forge_http_add_route
    /// - Serve → main_end stmt calling forge_http_serve(port)
    fn expand_server(decl: &ComponentBlockDecl, service_infos: &[ServiceInfo]) -> ExpansionResult {
        let mut result = ExpansionResult::new();

        let port = decl
            .args
            .iter()
            .find_map(|a| match a {
                ComponentArg::Named(key, Expr::IntLit(n, _), _) if key == "port" => Some(*n),
                _ => None,
            })
            .unwrap_or(3000);

        for stmt in &decl.body.blocks {
            if let Statement::Expr(Expr::Call {
                callee,
                args,
                span: call_span,
            }) = stmt
            {
                if let Expr::Ident(name, _) = callee.as_ref() {
                    match name.as_str() {
                        "__component_route" => {
                            let method = Self::extract_string_arg(args, "method");
                            let path = Self::extract_string_arg(args, "path");
                            let handler = args
                                .iter()
                                .find_map(|a| {
                                    if a.name.as_deref() == Some("handler") {
                                        Some(a.value.clone())
                                    } else {
                                        None
                                    }
                                })
                                .unwrap_or(Expr::NullLit(*call_span));

                            // Generate handler function + registration call with port
                            let (handler_fn, handler_name) =
                                Self::generate_route_handler(&method, &path, &handler);
                            result.statements.push(handler_fn);
                            result.startup_stmts.push(
                                Self::route_register_stmt(port, &method, &path, &handler_name),
                            );
                        }
                        "__component_mount" => {
                            let service_name = Self::extract_string_arg(args, "service");
                            let mount_path = Self::extract_string_arg(args, "path");

                            // Resolve service → model table name
                            let table_name = service_infos
                                .iter()
                                .find(|si| si.name == service_name)
                                .map(|si| si.for_model.clone())
                                .unwrap_or(service_name.clone());

                            // Generate: forge_http_mount_crud(port, "TableName", "/path")
                            result.startup_stmts.push(expr_stmt(call(
                                "forge_http_mount_crud",
                                vec![Expr::IntLit(port, sp()), string_lit(&table_name), string_lit(&mount_path)],
                            )));
                        }
                        _ => {}
                    }
                }
            }
        }

        // forge_http_serve(port) at end of main
        result.main_end_stmts.push(expr_stmt(call(
            "forge_http_serve",
            vec![Expr::IntLit(port, sp())],
        )));

        result
    }

    /// Generate a route handler function (C ABI compatible) and its registration statement.
    /// The handler function takes raw ptr/int params matching the HandlerFn signature,
    /// evaluates the user's closure body, serializes the result with json.stringify,
    /// and writes it to the response buffer.
    fn generate_route_handler(
        method: &str,
        path: &str,
        handler: &Expr,
    ) -> (Statement, String) {
        let handler_name = format!(
            "__http_handler_{}_{}",
            method.to_lowercase(),
            path.replace('/', "_")
                .replace(':', "p_")
                .trim_start_matches('_')
                .to_string()
        );

        // Extract closure body (or use handler expression directly)
        let handler_body_expr = match handler {
            Expr::Closure { body, .. } => body.as_ref().clone(),
            other => other.clone(),
        };

        // Build function body:
        //   let __req_params_json = __params_json
        //   let __result = <user handler body>
        //   let __json = json.stringify(__result)
        //   forge_http_write_response(__response_buf, __response_buf_len, __json)
        //   200
        let body_stmts = vec![
            let_stmt("__req_params_json", ident("__params_json")),
            let_stmt("__result", handler_body_expr),
            let_stmt(
                "__json",
                method_call("json", "stringify", vec![ident("__result")]),
            ),
            expr_stmt(call(
                "forge_http_write_response",
                vec![
                    ident("__response_buf"),
                    ident("__response_buf_len"),
                    ident("__json"),
                ],
            )),
            expr_stmt(Expr::IntLit(200, sp())),
        ];

        let handler_fn = fn_decl(
            &handler_name,
            vec![
                param("__m", named_type("ptr")),
                param("__p", named_type("ptr")),
                param("__b", named_type("ptr")),
                param("__params_json", named_type("ptr")),
                param("__response_buf", named_type("ptr")),
                param("__response_buf_len", named_type("int")),
            ],
            Some(named_type("int")),
            body_stmts,
        );

        // Port is set by the caller via the returned closure
        (handler_fn, handler_name)
    }

    /// Generate the route registration statement with port.
    fn route_register_stmt(port: i64, method: &str, path: &str, handler_name: &str) -> Statement {
        expr_stmt(call(
            "forge_http_add_route",
            vec![
                Expr::IntLit(port, sp()),
                string_lit(method),
                string_lit(path),
                ident(handler_name),
            ],
        ))
    }

    fn extract_string_arg(args: &[CallArg], name: &str) -> String {
        args.iter()
            .find_map(|a| {
                if a.name.as_deref() == Some(name) {
                    if let Expr::StringLit(s, _) = &a.value {
                        Some(s.clone())
                    } else {
                        None
                    }
                } else {
                    None
                }
            })
            .unwrap_or_default()
    }
}
