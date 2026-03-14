use inkwell::AddressSpace;
use inkwell::IntPredicate;
use inkwell::values::BasicValueEnum;

use crate::codegen::codegen::Codegen;
use crate::parser::ast::CallArg;
use crate::typeck::types::Type;

impl<'ctx> Codegen<'ctx> {
    /// Dispatch string method calls. Called from compile_method_call in core.
    pub(crate) fn compile_string_method(
        &mut self,
        obj_val: BasicValueEnum<'ctx>,
        method: &str,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        match method {
            "length" => self.call_runtime("forge_string_length", &[obj_val.into()], "len"),
            "upper" => self.call_runtime("forge_string_upper", &[obj_val.into()], "upper"),
            "lower" => self.call_runtime("forge_string_lower", &[obj_val.into()], "lower"),
            "trim" => self.call_runtime("forge_string_trim", &[obj_val.into()], "trim"),
            "contains" => {
                let arg_val = self.compile_expr(&args.first()?.value)?;
                self.call_runtime("forge_string_contains", &[obj_val.into(), arg_val.into()], "contains")
            }
            "split" => {
                self.compile_string_split(&obj_val, args)
            }
            "starts_with" => {
                let arg_val = self.compile_expr(&args.first()?.value)?;
                self.call_runtime("forge_string_starts_with", &[obj_val.into(), arg_val.into()], "starts_with")
            }
            "ends_with" => {
                let arg_val = self.compile_expr(&args.first()?.value)?;
                self.call_runtime("forge_string_ends_with", &[obj_val.into(), arg_val.into()], "ends_with")
            }
            "replace" => {
                let find_val = self.compile_expr(&args.get(0)?.value)?;
                let replace_val = self.compile_expr(&args.get(1)?.value)?;
                self.call_runtime("forge_string_replace", &[obj_val.into(), find_val.into(), replace_val.into()], "replace")
            }
            "parse_int" => self.call_runtime("forge_string_parse_int", &[obj_val.into()], "parse_int"),
            "repeat" => {
                let count_val = self.compile_expr(&args.first()?.value)?;
                self.call_runtime("forge_string_repeat", &[obj_val.into(), count_val.into()], "repeat")
            }
            _ => None,
        }
    }

    /// string.split(separator) -> list<string>
    pub(crate) fn compile_string_split(
        &mut self,
        obj_val: &BasicValueEnum<'ctx>,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        let sep_val = self.compile_expr(&args.first()?.value)?;
        let string_type = self.string_type();
        let ptr_type = self.context.ptr_type(AddressSpace::default());
        let i64_type = self.context.i64_type();

        let split_fn = self.module.get_function("forge_string_split").unwrap_or_else(|| {
            let ft = i64_type.fn_type(
                &[string_type.into(), string_type.into(), ptr_type.into()],
                false,
            );
            self.module.add_function("forge_string_split", ft, None)
        });

        // Allocate output pointer on stack
        let out_ptr = self.builder.build_alloca(ptr_type, "split_out").unwrap();

        // Call split: returns count, writes data ptr to out_ptr
        let count = self.builder
            .build_call(split_fn, &[(*obj_val).into(), sep_val.into(), out_ptr.into()], "split_count")
            .unwrap()
            .try_as_basic_value()
            .left()?
            .into_int_value();

        let data_ptr = self.builder
            .build_load(ptr_type, out_ptr, "split_data")
            .unwrap()
            .into_pointer_value();

        // Build list struct { ptr, i64 }
        let list_type = self.type_to_llvm_basic(&Type::List(Box::new(Type::String)));
        let list_struct_type = list_type.into_struct_type();
        let mut result_list = list_struct_type.get_undef();
        result_list = self.builder.build_insert_value(result_list, data_ptr, 0, "sp").unwrap().into_struct_value();
        result_list = self.builder.build_insert_value(result_list, count, 1, "sl").unwrap().into_struct_value();
        Some(result_list.into())
    }

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
            Type::Int => self.call_runtime("forge_int_to_string", &[val.into()], "to_str"),
            Type::Float => self.call_runtime("forge_float_to_string", &[val.into()], "to_str"),
            Type::Bool => self.call_runtime("forge_bool_to_string", &[val.into()], "to_str"),
            Type::Nullable(inner) => {
                self.compile_nullable_to_string(val, inner)
            }
            _ => {
                // Try based on LLVM type
                if val.is_int_value() {
                    let bit_width = val.into_int_value().get_type().get_bit_width();
                    if bit_width == 64 {
                        self.call_runtime("forge_int_to_string", &[val.into()], "to_str")
                    } else {
                        self.call_runtime("forge_bool_to_string", &[val.into()], "to_str")
                    }
                } else if val.is_float_value() {
                    self.call_runtime("forge_float_to_string", &[val.into()], "to_str")
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
            Type::Int => self.call_runtime("forge_int_to_string", &[val.into()], "to_str"),
            Type::Float => self.call_runtime("forge_float_to_string", &[val.into()], "to_str"),
            Type::Bool => self.call_runtime("forge_bool_to_string", &[val.into()], "to_str"),
            Type::String => Some(val),
            Type::Nullable(ref inner) => {
                self.compile_nullable_to_string(val, inner)
            }
            _ => {
                // Try to figure out from the LLVM type
                if val.is_int_value() {
                    let bit_width = val.into_int_value().get_type().get_bit_width();
                    if bit_width == 64 {
                        self.call_runtime("forge_int_to_string", &[val.into()], "to_str")
                    } else if bit_width == 8 || bit_width == 1 {
                        self.call_runtime("forge_bool_to_string", &[val.into()], "to_str")
                    } else {
                        None
                    }
                } else if val.is_float_value() {
                    self.call_runtime("forge_float_to_string", &[val.into()], "to_str")
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

        let function = self.current_function();
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
