use super::*;

impl<'ctx> Codegen<'ctx> {
    /// Compile an extern fn declaration - generates an LLVM external function declaration
    /// with C ABI type mapping.
    pub(crate) fn compile_extern_fn(
        &mut self,
        name: &str,
        params: &[Param],
        return_type: Option<&TypeExpr>,
    ) {
        // Skip if already declared
        if self.module.get_function(name).is_some() {
            return;
        }

        let param_types: Vec<BasicMetadataTypeEnum<'ctx>> = params
            .iter()
            .map(|p| self.extern_type_to_llvm(p.type_ann.as_ref()))
            .collect();

        let fn_type = match return_type {
            None => self.context.void_type().fn_type(&param_types, false),
            Some(ty) => {
                let ret_name = type_expr_name(ty);
                match ret_name.as_str() {
                    "void" => self.context.void_type().fn_type(&param_types, false),
                    "string" | "cstring" | "ptr" => {
                        self.context.ptr_type(AddressSpace::default()).fn_type(&param_types, false)
                    }
                    "int" | "i64" => self.context.i64_type().fn_type(&param_types, false),
                    "i32" => self.context.i32_type().fn_type(&param_types, false),
                    "i16" => self.context.i16_type().fn_type(&param_types, false),
                    "float" | "f64" => self.context.f64_type().fn_type(&param_types, false),
                    "bool" | "i8" => self.context.i8_type().fn_type(&param_types, false),
                    _ => self.context.i64_type().fn_type(&param_types, false),
                }
            }
        };

        self.module.add_function(name, fn_type, None);
    }

    /// Map a Forge type expression to a C ABI LLVM type for extern fn parameters
    fn extern_type_to_llvm(&self, type_ann: Option<&TypeExpr>) -> BasicMetadataTypeEnum<'ctx> {
        match type_ann {
            None => self.context.i64_type().into(),
            Some(ty) => {
                let name = type_expr_name(ty);
                match name.as_str() {
                    "string" | "cstring" | "ptr" => {
                        self.context.ptr_type(AddressSpace::default()).into()
                    }
                    "int" | "i64" => self.context.i64_type().into(),
                    "i32" => self.context.i32_type().into(),
                    "i16" => self.context.i16_type().into(),
                    "float" | "f64" => self.context.f64_type().into(),
                    "bool" | "i8" => self.context.i8_type().into(),
                    _ => self.context.i64_type().into(),
                }
            }
        }
    }
}

/// Extract the type name from a TypeExpr (for C ABI mapping)
fn type_expr_name(ty: &TypeExpr) -> String {
    match ty {
        TypeExpr::Named(name) => name.clone(),
        _ => "unknown".to_string(),
    }
}
