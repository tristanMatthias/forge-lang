use super::*;

impl<'ctx> Codegen<'ctx> {
    // compile_extern_fn: extracted to features/
    // extern_type_to_llvm: extracted to features/
}

/// Extract the type name from a TypeExpr (for C ABI mapping)
fn type_expr_name(ty: &TypeExpr) -> String {
    match ty {
        TypeExpr::Named(name) => name.clone(),
        _ => "unknown".to_string(),
    }
}
