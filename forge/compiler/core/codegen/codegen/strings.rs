use super::*;

impl<'ctx> Codegen<'ctx> {
    // compile_template: extracted to features/

    pub(crate) fn value_to_string(
        &mut self,
        val: BasicValueEnum<'ctx>,
        ty: &Type,
    ) -> Option<BasicValueEnum<'ctx>> {
        match ty {
            Type::String => Some(val),
            Type::Int => {
                let conv = self.module.get_function("forge_int_to_string").unwrap();
                let result = self.builder.build_call(conv, &[val.into()], "to_str").unwrap();
                result.try_as_basic_value().left()
            }
            Type::Float => {
                let conv = self.module.get_function("forge_float_to_string").unwrap();
                let result = self.builder.build_call(conv, &[val.into()], "to_str").unwrap();
                result.try_as_basic_value().left()
            }
            Type::Bool => {
                let conv = self.module.get_function("forge_bool_to_string").unwrap();
                let result = self.builder.build_call(conv, &[val.into()], "to_str").unwrap();
                result.try_as_basic_value().left()
            }
            _ => {
                // Try based on LLVM type
                if val.is_int_value() {
                    let bit_width = val.into_int_value().get_type().get_bit_width();
                    if bit_width == 64 {
                        let conv = self.module.get_function("forge_int_to_string").unwrap();
                        let result = self.builder.build_call(conv, &[val.into()], "to_str").unwrap();
                        result.try_as_basic_value().left()
                    } else {
                        let conv = self.module.get_function("forge_bool_to_string").unwrap();
                        let result = self.builder.build_call(conv, &[val.into()], "to_str").unwrap();
                        result.try_as_basic_value().left()
                    }
                } else if val.is_float_value() {
                    let conv = self.module.get_function("forge_float_to_string").unwrap();
                    let result = self.builder.build_call(conv, &[val.into()], "to_str").unwrap();
                    result.try_as_basic_value().left()
                } else if val.is_struct_value() {
                    Some(val) // Assume it's already a ForgeString
                } else {
                    None
                }
            }
        }
    }

    pub(crate) fn compile_string_conversion(&mut self, args: &[CallArg]) -> Option<BasicValueEnum<'ctx>> {
        if args.is_empty() {
            return None;
        }

        let arg = &args[0];
        let val = self.compile_expr(&arg.value)?;
        let arg_type = self.resolve_runtime_type(&arg.value, &val);

        match arg_type {
            Type::Int => {
                let conv_fn = self.module.get_function("forge_int_to_string").unwrap();
                let result = self.builder.build_call(conv_fn, &[val.into()], "to_str").unwrap();
                result.try_as_basic_value().left()
            }
            Type::Float => {
                let conv_fn = self.module.get_function("forge_float_to_string").unwrap();
                let result = self.builder.build_call(conv_fn, &[val.into()], "to_str").unwrap();
                result.try_as_basic_value().left()
            }
            Type::Bool => {
                let conv_fn = self.module.get_function("forge_bool_to_string").unwrap();
                let result = self.builder.build_call(conv_fn, &[val.into()], "to_str").unwrap();
                result.try_as_basic_value().left()
            }
            Type::String => Some(val),
            _ => {
                // Try to figure out from the LLVM type
                if val.is_int_value() {
                    let bit_width = val.into_int_value().get_type().get_bit_width();
                    if bit_width == 64 {
                        let conv_fn = self.module.get_function("forge_int_to_string").unwrap();
                        let result = self.builder.build_call(conv_fn, &[val.into()], "to_str").unwrap();
                        result.try_as_basic_value().left()
                    } else if bit_width == 8 || bit_width == 1 {
                        let conv_fn = self.module.get_function("forge_bool_to_string").unwrap();
                        let result = self.builder.build_call(conv_fn, &[val.into()], "to_str").unwrap();
                        result.try_as_basic_value().left()
                    } else {
                        None
                    }
                } else if val.is_float_value() {
                    let conv_fn = self.module.get_function("forge_float_to_string").unwrap();
                    let result = self.builder.build_call(conv_fn, &[val.into()], "to_str").unwrap();
                    result.try_as_basic_value().left()
                } else if val.is_struct_value() {
                    // Already a string?
                    Some(val)
                } else {
                    None
                }
            }
        }
    }
}
