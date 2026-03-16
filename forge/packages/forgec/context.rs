/// Context extraction — generates a machine-readable API surface description.
///
/// Walks the typed AST after parse + type-check and collects all exported
/// symbols: functions, types, enums, traits, and component blocks.
/// Outputs a `.fg`-like text format summarizing the public API.

use crate::parser::ast::{
    ComponentBlockDecl, EnumVariant, Param, Program, Statement, TypeExpr,
};

/// A collected exported symbol from the AST.
enum ExportedItem {
    Function {
        name: String,
        params: Vec<Param>,
        return_type: Option<TypeExpr>,
    },
    TypeDecl {
        name: String,
        value: TypeExpr,
    },
    EnumDecl {
        name: String,
        variants: Vec<EnumVariant>,
    },
    TraitDecl {
        name: String,
        methods: Vec<(String, Vec<Param>, Option<TypeExpr>)>,
    },
    Component {
        component: String,
        name: Option<String>,
    },
    Constant {
        name: String,
        type_ann: Option<TypeExpr>,
    },
}

/// Extract all exported items from a parsed + type-checked program.
fn extract_exports(program: &Program) -> Vec<ExportedItem> {
    let mut items = Vec::new();

    for stmt in &program.statements {
        match stmt {
            Statement::FnDecl {
                name,
                params,
                return_type,
                exported: true,
                ..
            } => {
                items.push(ExportedItem::Function {
                    name: name.clone(),
                    params: params.clone(),
                    return_type: return_type.clone(),
                });
            }

            Statement::TypeDecl {
                name,
                value,
                exported: true,
                ..
            } => {
                items.push(ExportedItem::TypeDecl {
                    name: name.clone(),
                    value: value.clone(),
                });
            }

            Statement::EnumDecl {
                name,
                variants,
                exported: true,
                ..
            } => {
                items.push(ExportedItem::EnumDecl {
                    name: name.clone(),
                    variants: variants.clone(),
                });
            }

            Statement::TraitDecl {
                name,
                methods,
                exported: true,
                ..
            } => {
                let method_sigs: Vec<(String, Vec<Param>, Option<TypeExpr>)> = methods
                    .iter()
                    .map(|m| (m.name.clone(), m.params.clone(), m.return_type.clone()))
                    .collect();
                items.push(ExportedItem::TraitDecl {
                    name: name.clone(),
                    methods: method_sigs,
                });
            }

            Statement::ComponentBlock(decl) => {
                if decl.exported {
                    let comp_name = extract_component_name(decl);
                    items.push(ExportedItem::Component {
                        component: decl.component.clone(),
                        name: comp_name,
                    });
                }
            }

            Statement::Let {
                name,
                type_ann,
                exported: true,
                ..
            }
            | Statement::Const {
                name,
                type_ann,
                exported: true,
                ..
            } => {
                items.push(ExportedItem::Constant {
                    name: name.clone(),
                    type_ann: type_ann.clone(),
                });
            }

            _ => {}
        }
    }

    items
}

/// Try to extract a name from a component block's args (first Ident arg).
fn extract_component_name(decl: &ComponentBlockDecl) -> Option<String> {
    use crate::parser::ast::ComponentArg;
    for arg in &decl.args {
        match arg {
            ComponentArg::Ident(name, _) => return Some(name.clone()),
            _ => {}
        }
    }
    None
}

/// Format a TypeExpr as a human-readable string.
fn format_type_expr(ty: &TypeExpr) -> String {
    match ty {
        TypeExpr::Named(name) => name.clone(),
        TypeExpr::Generic { name, args } => {
            let arg_strs: Vec<String> = args.iter().map(|a| format_type_expr(a)).collect();
            format!("{}<{}>", name, arg_strs.join(", "))
        }
        TypeExpr::Nullable(inner) => format!("{}?", format_type_expr(inner)),
        TypeExpr::Union(types) => {
            let parts: Vec<String> = types.iter().map(|t| format_type_expr(t)).collect();
            parts.join(" | ")
        }
        TypeExpr::Tuple(types) => {
            let parts: Vec<String> = types.iter().map(|t| format_type_expr(t)).collect();
            format!("({})", parts.join(", "))
        }
        TypeExpr::Function {
            params,
            return_type,
        } => {
            let param_strs: Vec<String> = params.iter().map(|p| format_type_expr(p)).collect();
            format!("({}) -> {}", param_strs.join(", "), format_type_expr(return_type))
        }
        TypeExpr::Struct { fields } => {
            if fields.is_empty() {
                "{}".to_string()
            } else {
                let field_strs: Vec<String> = fields
                    .iter()
                    .map(|f| format!("{}: {}", f.name, format_type_expr(&f.type_expr)))
                    .collect();
                format!("{{ {} }}", field_strs.join(", "))
            }
        }
        TypeExpr::Without { base, fields } => {
            format!("{} without {{{}}}", format_type_expr(base), fields.join(", "))
        }
        TypeExpr::TypeWith { base, fields } => {
            let field_strs: Vec<String> = fields
                .iter()
                .map(|f| format!("{}: {}", f.name, format_type_expr(&f.type_expr)))
                .collect();
            format!("{} with {{ {} }}", format_type_expr(base), field_strs.join(", "))
        }
        TypeExpr::Only { base, fields } => {
            format!("{} only {{{}}}", format_type_expr(base), fields.join(", "))
        }
        TypeExpr::AsPartial(inner) => format!("{} as partial", format_type_expr(inner)),
        TypeExpr::Intersection(left, right) => {
            format!("{} & {}", format_type_expr(left), format_type_expr(right))
        }
    }
}

/// Format a parameter as `name: type`.
fn format_param(param: &Param) -> String {
    match &param.type_ann {
        Some(ty) => format!("{}: {}", param.name, format_type_expr(ty)),
        None => param.name.clone(),
    }
}

/// Generate the context output string from extracted items.
fn format_context(items: &[ExportedItem], package_name: Option<&str>) -> String {
    let mut out = String::new();

    // Header
    if let Some(name) = package_name {
        out.push_str(&format!("// Context for: {}\n", name));
    } else {
        out.push_str("// Context\n");
    }
    out.push_str(&format!(
        "// Generated: {}\n",
        chrono_free_timestamp()
    ));
    out.push('\n');

    // Group items by category
    let mut types = Vec::new();
    let mut enums = Vec::new();
    let mut traits = Vec::new();
    let mut functions = Vec::new();
    let mut components = Vec::new();
    let mut constants = Vec::new();

    for item in items {
        match item {
            ExportedItem::TypeDecl { .. } => types.push(item),
            ExportedItem::EnumDecl { .. } => enums.push(item),
            ExportedItem::TraitDecl { .. } => traits.push(item),
            ExportedItem::Function { .. } => functions.push(item),
            ExportedItem::Component { .. } => components.push(item),
            ExportedItem::Constant { .. } => constants.push(item),
        }
    }

    // Types
    if !types.is_empty() {
        out.push_str("// Types\n");
        for item in &types {
            if let ExportedItem::TypeDecl { name, value } = item {
                out.push_str(&format_type_decl(name, value));
                out.push('\n');
            }
        }
        out.push('\n');
    }

    // Enums
    if !enums.is_empty() {
        out.push_str("// Enums\n");
        for item in &enums {
            if let ExportedItem::EnumDecl { name, variants } = item {
                out.push_str(&format_enum_decl(name, variants));
                out.push('\n');
            }
        }
        out.push('\n');
    }

    // Traits
    if !traits.is_empty() {
        out.push_str("// Traits\n");
        for item in &traits {
            if let ExportedItem::TraitDecl { name, methods } = item {
                out.push_str(&format_trait_decl(name, methods));
                out.push('\n');
            }
        }
        out.push('\n');
    }

    // Functions
    if !functions.is_empty() {
        out.push_str("// Functions\n");
        for item in &functions {
            if let ExportedItem::Function {
                name,
                params,
                return_type,
            } = item
            {
                out.push_str(&format_fn_sig(name, params, return_type.as_ref()));
                out.push('\n');
            }
        }
        out.push('\n');
    }

    // Constants
    if !constants.is_empty() {
        out.push_str("// Constants\n");
        for item in &constants {
            if let ExportedItem::Constant { name, type_ann } = item {
                match type_ann {
                    Some(ty) => out.push_str(&format!("export let {}: {}\n", name, format_type_expr(ty))),
                    None => out.push_str(&format!("export let {}\n", name)),
                }
            }
        }
        out.push('\n');
    }

    // Components
    if !components.is_empty() {
        out.push_str("// Components\n");
        for item in &components {
            if let ExportedItem::Component { component, name } = item {
                match name {
                    Some(n) => out.push_str(&format!("// component {} {}\n", component, n)),
                    None => out.push_str(&format!("// component {}\n", component)),
                }
            }
        }
        out.push('\n');
    }

    out
}

/// Format a type declaration.
fn format_type_decl(name: &str, value: &TypeExpr) -> String {
    match value {
        TypeExpr::Struct { fields } => {
            if fields.is_empty() {
                format!("export type {} = {{}}", name)
            } else {
                let mut s = format!("export type {} = {{\n", name);
                for f in fields {
                    s.push_str(&format!("    {}: {}\n", f.name, format_type_expr(&f.type_expr)));
                }
                s.push('}');
                s
            }
        }
        _ => format!("export type {} = {}", name, format_type_expr(value)),
    }
}

/// Format an enum declaration.
fn format_enum_decl(name: &str, variants: &[EnumVariant]) -> String {
    let mut s = format!("export enum {} {{\n", name);
    for v in variants {
        if v.fields.is_empty() {
            s.push_str(&format!("    {}\n", v.name));
        } else {
            let fields: Vec<String> = v.fields.iter().map(|p| format_param(p)).collect();
            s.push_str(&format!("    {}({})\n", v.name, fields.join(", ")));
        }
    }
    s.push('}');
    s
}

/// Format a trait declaration.
fn format_trait_decl(
    name: &str,
    methods: &[(String, Vec<Param>, Option<TypeExpr>)],
) -> String {
    let mut s = format!("export trait {} {{\n", name);
    for (mname, params, ret) in methods {
        let param_strs: Vec<String> = params.iter().map(|p| format_param(p)).collect();
        match ret {
            Some(ty) => s.push_str(&format!(
                "    fn {}({}) -> {}\n",
                mname,
                param_strs.join(", "),
                format_type_expr(ty)
            )),
            None => s.push_str(&format!(
                "    fn {}({})\n",
                mname,
                param_strs.join(", ")
            )),
        }
    }
    s.push('}');
    s
}

/// Format a function signature.
fn format_fn_sig(name: &str, params: &[Param], return_type: Option<&TypeExpr>) -> String {
    let param_strs: Vec<String> = params.iter().map(|p| format_param(p)).collect();
    match return_type {
        Some(ty) => format!(
            "export fn {}({}) -> {}",
            name,
            param_strs.join(", "),
            format_type_expr(ty)
        ),
        None => format!("export fn {}({})", name, param_strs.join(", ")),
    }
}

/// Simple timestamp without chrono dependency.
fn chrono_free_timestamp() -> String {
    use std::time::SystemTime;
    match SystemTime::now().duration_since(SystemTime::UNIX_EPOCH) {
        Ok(d) => {
            let secs = d.as_secs();
            // Simple ISO-ish date: just use epoch seconds since we don't have chrono
            // Format as approximate date
            let days = secs / 86400;
            let years = 1970 + days / 365;
            let remaining_days = days % 365;
            let month = remaining_days / 30 + 1;
            let day = remaining_days % 30 + 1;
            format!("{:04}-{:02}-{:02}", years, month, day)
        }
        Err(_) => "unknown".to_string(),
    }
}

/// Run the context extraction pipeline: parse + type-check + extract exports.
/// Returns the formatted context string.
pub fn generate_context(program: &Program, package_name: Option<&str>) -> String {
    let items = extract_exports(program);
    format_context(&items, package_name)
}
