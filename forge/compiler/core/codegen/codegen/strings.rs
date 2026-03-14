use super::*;

impl<'ctx> Codegen<'ctx> {
    // compile_template: extracted to features/

    /// Check if an LLVM struct type matches the ForgeString layout: {ptr, i64}
    fn is_forge_string_struct(&self, st: inkwell::types::StructType<'ctx>) -> bool {
        if st.count_fields() != 2 {
            return false;
        }
        let ptr_type = self.context.ptr_type(inkwell::AddressSpace::default());
        let i64_type = self.context.i64_type();
        st.get_field_type_at_index(0) == Some(ptr_type.into())
            && st.get_field_type_at_index(1) == Some(i64_type.into())
    }

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
            Type::Nullable(inner) => {
                self.compile_nullable_to_string(val, inner)
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
                    let st = val.into_struct_value().get_type();
                    if self.is_forge_string_struct(st) {
                        Some(val)
                    } else {
                        None
                    }
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
            Type::Nullable(ref inner) => {
                self.compile_nullable_to_string(val, inner)
            }
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
                    let st = val.into_struct_value().get_type();
                    if self.is_forge_string_struct(st) {
                        Some(val)
                    } else {
                        None
                    }
                } else {
                    None
                }
            }
        }
    }

    /// Convert a nullable value to string: "null" if null, or the inner value's string representation.
    fn compile_nullable_to_string(
        &mut self,
        val: BasicValueEnum<'ctx>,
        inner_type: &Type,
    ) -> Option<BasicValueEnum<'ctx>> {
        if !val.is_struct_value() {
            return None;
        }
        let struct_val = val.into_struct_value();

        // Extract the null tag (index 0, i8: 0=null, 1=has value)
        let tag = self.builder.build_extract_value(struct_val, 0, "null_tag").unwrap().into_int_value();
        let is_non_null = self.builder.build_int_compare(
            IntPredicate::NE,
            tag,
            self.context.i8_type().const_zero(),
            "is_non_null",
        ).unwrap();

        let function = self.builder.get_insert_block().unwrap().get_parent().unwrap();
        let then_bb = self.context.append_basic_block(function, "nullable_has_val");
        let else_bb = self.context.append_basic_block(function, "nullable_is_null");
        let merge_bb = self.context.append_basic_block(function, "nullable_merge");

        self.builder.build_conditional_branch(is_non_null, then_bb, else_bb).unwrap();

        // Then: extract inner value and convert to string
        self.builder.position_at_end(then_bb);
        let inner_val = self.builder.build_extract_value(struct_val, 1, "inner_val").unwrap();
        let inner_str = self.value_to_string(inner_val, inner_type)
            .unwrap_or_else(|| self.build_string_literal("unknown"));
        self.builder.build_unconditional_branch(merge_bb).unwrap();
        let then_end = self.builder.get_insert_block().unwrap();

        // Else: return "null"
        self.builder.position_at_end(else_bb);
        let null_str = self.build_string_literal("null");
        self.builder.build_unconditional_branch(merge_bb).unwrap();
        let else_end = self.builder.get_insert_block().unwrap();

        // Merge
        self.builder.position_at_end(merge_bb);
        let string_type = self.string_type();
        let phi = self.builder.build_phi(string_type, "nullable_str").unwrap();
        phi.add_incoming(&[(&inner_str, then_end), (&null_str, else_end)]);

        Some(phi.as_basic_value())
    }
}
