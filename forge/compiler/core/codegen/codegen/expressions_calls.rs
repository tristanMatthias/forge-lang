use super::*;

impl<'ctx> Codegen<'ctx> {
    pub(crate) fn compile_call(
        &mut self,
        callee: &Expr,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        // Handle special built-in functions
        if let Expr::Ident(name, _) = callee {
            match name.as_str() {
                "println" => return self.compile_println(args),
                "print" => return self.compile_print(args),
                "string" => return self.compile_string_conversion(args),
                "assert" => return self.compile_assert(args),
                _ => {}
            }

            // Handle enum constructors: EnumName.variant(args)
            // Handle regular function calls
            if let Some(func) = self.functions.get(name).copied() {
                let compiled_args = self.compile_call_args(args, func)?;
                let result = self.builder.build_call(func, &compiled_args, "call").unwrap();
                return result.try_as_basic_value().left();
            }

            // Check if this is a generic function that needs monomorphization
            if self.generic_fns.contains_key(name.as_str()) {
                if let Some(type_args) = self.infer_type_args(name, args) {
                    let type_args_refs: Vec<(&str, Type)> = type_args.iter().map(|(n, t)| (n.as_str(), t.clone())).collect();
                    if let Some(mangled) = self.monomorphize_fn(name, &type_args_refs) {
                        if let Some(func) = self.functions.get(&mangled).copied() {
                            let compiled_args = self.compile_call_args(args, func)?;
                            let result = self.builder.build_call(func, &compiled_args, "call").unwrap();
                            return result.try_as_basic_value().left();
                        }
                    }
                }
                return None;
            }

            // Maybe it's a variable holding a function pointer
            if let Some((ptr, ty)) = self.lookup_var(name) {
                if let Type::Function { params: _, return_type: _ } = &ty {
                    // Load the function pointer and call it indirectly
                    let llvm_ty = self.type_to_llvm_basic(&ty);
                    let fn_ptr = self.builder.build_load(llvm_ty, ptr, "fn_ptr").unwrap();
                    // Indirect call is complex; skip for now
                    let _ = fn_ptr;
                }
            }

            return None;
        }

        // Handle method calls: object.method(args) becomes method(object, args)
        if let Expr::MemberAccess { object, field, .. } = callee {
            return self.compile_method_call(object, field, args);
        }

        None
    }

    pub(crate) fn compile_call_args(
        &mut self,
        args: &[CallArg],
        function: FunctionValue<'ctx>,
    ) -> Option<Vec<BasicMetadataValueEnum<'ctx>>> {
        let param_count = function.count_params() as usize;
        let mut compiled = Vec::new();

        for (i, arg) in args.iter().enumerate() {
            if let Some(val) = self.compile_expr(&arg.value) {
                // Type-match: if param expects different type, convert
                if i < param_count {
                    let param_type = function.get_nth_param(i as u32).unwrap().get_type();
                    let val = self.coerce_value(val, param_type);
                    compiled.push(val.into());
                } else {
                    compiled.push(val.into());
                }
            } else {
                return None;
            }
        }

        Some(compiled)
    }

    pub(crate) fn coerce_value(
        &self,
        val: BasicValueEnum<'ctx>,
        target_type: BasicTypeEnum<'ctx>,
    ) -> BasicValueEnum<'ctx> {
        // Simple coercions
        if val.get_type() == target_type {
            return val;
        }

        // i8 (bool) -> i64
        if val.is_int_value() && target_type.is_int_type() {
            let val_int = val.into_int_value();
            let target_int = target_type.into_int_type();
            if val_int.get_type().get_bit_width() < target_int.get_bit_width() {
                return self.builder.build_int_s_extend(val_int, target_int, "coerce").unwrap().into();
            } else if val_int.get_type().get_bit_width() > target_int.get_bit_width() {
                return self.builder.build_int_truncate(val_int, target_int, "coerce").unwrap().into();
            }
        }

        // int -> float
        if val.is_int_value() && target_type.is_float_type() {
            return self.builder
                .build_signed_int_to_float(val.into_int_value(), target_type.into_float_type(), "itof")
                .unwrap()
                .into();
        }

        val
    }

    pub(crate) fn compile_println(&mut self, args: &[CallArg]) -> Option<BasicValueEnum<'ctx>> {
        if args.is_empty() {
            // Just print a newline
            let newline = self.build_string_literal("\n");
            let print_fn = self.module.get_function("forge_print_string").unwrap();
            self.builder.build_call(print_fn, &[newline.into()], "").unwrap();
            return None;
        }

        let arg = &args[0];
        let val = self.compile_expr(&arg.value)?;
        let resolved = self.resolve_runtime_type(&arg.value, &val);

        match resolved {
            Type::String => {
                let print_fn = self.module.get_function("forge_println_string").unwrap();
                self.builder.build_call(print_fn, &[val.into()], "").unwrap();
            }
            Type::Int => {
                let print_fn = self.module.get_function("forge_println_int").unwrap();
                self.builder.build_call(print_fn, &[val.into()], "").unwrap();
            }
            Type::Float => {
                let print_fn = self.module.get_function("forge_println_float").unwrap();
                self.builder.build_call(print_fn, &[val.into()], "").unwrap();
            }
            Type::Bool => {
                let print_fn = self.module.get_function("forge_println_bool").unwrap();
                self.builder.build_call(print_fn, &[val.into()], "").unwrap();
            }
            _ => {
                if val.is_struct_value() {
                    let print_fn = self.module.get_function("forge_println_string").unwrap();
                    self.builder.build_call(print_fn, &[val.into()], "").unwrap();
                }
            }
        }

        None
    }

    pub(crate) fn compile_print(&mut self, args: &[CallArg]) -> Option<BasicValueEnum<'ctx>> {
        if args.is_empty() {
            return None;
        }

        let arg = &args[0];
        let val = self.compile_expr(&arg.value)?;
        let resolved = self.resolve_runtime_type(&arg.value, &val);

        match resolved {
            Type::String => {
                let print_fn = self.module.get_function("forge_print_string").unwrap();
                self.builder.build_call(print_fn, &[val.into()], "").unwrap();
            }
            Type::Int => {
                let print_fn = self.module.get_function("forge_print_int").unwrap();
                self.builder.build_call(print_fn, &[val.into()], "").unwrap();
            }
            Type::Float => {
                let print_fn = self.module.get_function("forge_print_float").unwrap();
                self.builder.build_call(print_fn, &[val.into()], "").unwrap();
            }
            _ => {
                if val.is_struct_value() {
                    let print_fn = self.module.get_function("forge_print_string").unwrap();
                    self.builder.build_call(print_fn, &[val.into()], "").unwrap();
                }
            }
        }

        None
    }

    pub(crate) fn compile_assert(&mut self, args: &[CallArg]) -> Option<BasicValueEnum<'ctx>> {
        if args.len() < 2 { return None; }
        let cond_val = self.compile_expr(&args[0].value)?;
        let msg_val = self.compile_expr(&args[1].value)?;

        // Ensure cond is i8
        let cond_i8 = if cond_val.is_int_value() {
            let iv = cond_val.into_int_value();
            if iv.get_type().get_bit_width() == 8 {
                iv
            } else if iv.get_type().get_bit_width() == 1 {
                self.builder.build_int_z_extend(iv, self.context.i8_type(), "assert_ext").unwrap()
            } else {
                // Truncate i64 comparison result
                let cmp = self.builder.build_int_compare(
                    IntPredicate::NE, iv, iv.get_type().const_zero(), "assert_cmp",
                ).unwrap();
                self.builder.build_int_z_extend(cmp, self.context.i8_type(), "assert_ext").unwrap()
            }
        } else {
            return None;
        };

        // Get string ptr and len from ForgeString
        if msg_val.is_struct_value() {
            let msg_struct = msg_val.into_struct_value();
            let msg_ptr = self.builder.build_extract_value(msg_struct, 0, "msg_ptr").unwrap();
            let msg_len = self.builder.build_extract_value(msg_struct, 1, "msg_len").unwrap();
            let assert_fn = self.module.get_function("forge_assert").unwrap_or_else(|| {
                let ft = self.context.void_type().fn_type(
                    &[self.context.i8_type().into(), self.context.ptr_type(AddressSpace::default()).into(), self.context.i64_type().into()],
                    false,
                );
                self.module.add_function("forge_assert", ft, None)
            });
            self.builder.build_call(assert_fn, &[cond_i8.into(), msg_ptr.into(), msg_len.into()], "").unwrap();
        }
        None
    }

    pub(crate) fn resolve_runtime_type(&self, expr: &Expr, val: &BasicValueEnum<'ctx>) -> Type {
        let inferred = self.infer_type(expr);
        if inferred != Type::Unknown {
            return inferred;
        }
        // Fallback: determine type from LLVM value
        if val.is_float_value() {
            Type::Float
        } else if val.is_int_value() {
            let bits = val.into_int_value().get_type().get_bit_width();
            if bits == 64 {
                Type::Int
            } else {
                Type::Bool
            }
        } else if val.is_struct_value() {
            Type::String // assume struct is ForgeString
        } else {
            Type::Unknown
        }
    }
}
