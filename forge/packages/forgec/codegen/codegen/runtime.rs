use super::*;

impl<'ctx> Codegen<'ctx> {
    pub(crate) fn declare_runtime_functions(&mut self) {
        use crate::registry::{RuntimeFnRegistry, RuntimeType, RuntimeRetType};

        let i64_type = self.context.i64_type();
        let f64_type = self.context.f64_type();
        let i8_type = self.context.i8_type();
        let i32_type = self.context.i32_type();
        let void_type = self.context.void_type();
        let ptr_type = self.context.ptr_type(AddressSpace::default());
        let string_type = self.string_type();

        for decl in RuntimeFnRegistry::all() {
            // Skip conditional declarations that already exist
            if decl.conditional && self.module.get_function(decl.name).is_some() {
                continue;
            }

            let param_types: Vec<inkwell::types::BasicMetadataTypeEnum<'ctx>> = decl.params.iter().map(|p| match p {
                RuntimeType::I64 => i64_type.into(),
                RuntimeType::F64 => f64_type.into(),
                RuntimeType::I8 => i8_type.into(),
                RuntimeType::Ptr => ptr_type.into(),
                RuntimeType::ForgeString => string_type.into(),
            }).collect();

            // Handle snprintf specially (variadic)
            if decl.name == "snprintf" {
                if self.module.get_function(decl.name).is_none() {
                    let ft = i32_type.fn_type(&[ptr_type.into(), i64_type.into(), ptr_type.into()], true);
                    self.module.add_function(decl.name, ft, None);
                }
                continue;
            }

            match decl.ret {
                RuntimeRetType::Void => {
                    let fn_type = void_type.fn_type(&param_types, false);
                    self.module.add_function(decl.name, fn_type, None);
                }
                RuntimeRetType::I64 => {
                    let fn_type = i64_type.fn_type(&param_types, false);
                    self.module.add_function(decl.name, fn_type, None);
                }
                RuntimeRetType::F64 => {
                    let fn_type = f64_type.fn_type(&param_types, false);
                    self.module.add_function(decl.name, fn_type, None);
                }
                RuntimeRetType::I8 => {
                    let fn_type = i8_type.fn_type(&param_types, false);
                    self.module.add_function(decl.name, fn_type, None);
                }
                RuntimeRetType::I32 => {
                    let fn_type = i32_type.fn_type(&param_types, false);
                    self.module.add_function(decl.name, fn_type, None);
                }
                RuntimeRetType::Ptr => {
                    let fn_type = ptr_type.fn_type(&param_types, false);
                    self.module.add_function(decl.name, fn_type, None);
                }
                RuntimeRetType::ForgeString => {
                    let fn_type = string_type.fn_type(&param_types, false);
                    self.module.add_function(decl.name, fn_type, None);
                }
            }
        }
    }

    /// Declare helper/utility functions needed by codegen.
    /// Core package functions (forge_model_*, forge_http_*) are declared via
    /// extern fn statements from package.fg files, loaded by the driver.
    /// This method only declares runtime helpers used by route/JSON codegen.
    pub(crate) fn declare_package_functions(&mut self) {
        // All package functions are now declared via RuntimeFnDecl registry
        // or via extern fn statements from package.fg files.
        // This method is kept for backward compatibility but is now a no-op
        // since all declarations moved to feature modules.
    }
}
