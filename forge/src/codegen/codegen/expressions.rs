use super::*;

impl<'ctx> Codegen<'ctx> {
    pub(crate) fn compile_expr(&mut self, expr: &Expr) -> Option<BasicValueEnum<'ctx>> {
        match expr {
            Expr::IntLit(n, _) => {
                Some(self.context.i64_type().const_int(*n as u64, true).into())
            }
            Expr::FloatLit(f, _) => {
                Some(self.context.f64_type().const_float(*f).into())
            }
            Expr::BoolLit(b, _) => {
                Some(self.context.i8_type().const_int(*b as u64, false).into())
            }
            Expr::NullLit(_) => {
                // Represent null as a nullable struct with tag=0
                // Use the current function's return type to determine the inner type
                let inner_ty = if let Some(Type::Nullable(inner)) = &self.current_fn_return_type {
                    self.type_to_llvm_basic(inner)
                } else {
                    self.context.i64_type().into()
                };
                let null_struct = self.context.struct_type(
                    &[self.context.i8_type().into(), inner_ty.into()],
                    false,
                );
                let val = null_struct.const_zero();
                Some(val.into())
            }
            Expr::StringLit(s, _) => Some(self.build_string_literal(s)),
            Expr::TemplateLit { parts, .. } => self.compile_template(parts),

            Expr::Ident(name, _) => {
                if let Some((ptr, ty)) = self.lookup_var(name) {
                    let llvm_ty = self.type_to_llvm_basic(&ty);
                    Some(self.builder.build_load(llvm_ty, ptr, name).unwrap())
                } else if let Some(func) = self.functions.get(name) {
                    // Return function as a value (pointer)
                    Some(func.as_global_value().as_pointer_value().into())
                } else {
                    None
                }
            }

            Expr::Binary { left, op, right, .. } => {
                let lhs = self.compile_expr(left)?;
                let rhs = self.compile_expr(right)?;
                self.compile_binary_op(lhs, *op, rhs, left, right)
            }

            Expr::Unary { op, operand, .. } => {
                let val = self.compile_expr(operand)?;
                match op {
                    UnaryOp::Neg => {
                        if val.is_int_value() {
                            Some(
                                self.builder
                                    .build_int_neg(val.into_int_value(), "neg")
                                    .unwrap()
                                    .into(),
                            )
                        } else {
                            Some(
                                self.builder
                                    .build_float_neg(val.into_float_value(), "neg")
                                    .unwrap()
                                    .into(),
                            )
                        }
                    }
                    UnaryOp::Not => {
                        let int_val = val.into_int_value();
                        let zero = self.context.i8_type().const_zero();
                        let cmp = self.builder.build_int_compare(
                            IntPredicate::EQ,
                            int_val,
                            zero,
                            "not",
                        ).unwrap();
                        Some(
                            self.builder
                                .build_int_z_extend(cmp, self.context.i8_type(), "not_ext")
                                .unwrap()
                                .into(),
                        )
                    }
                }
            }

            Expr::Call { callee, args, .. } => {
                self.compile_call(callee, args)
            }

            Expr::MemberAccess { object, field, .. } => {
                self.compile_member_access(object, field)
            }

            Expr::Index { object, index, .. } => {
                self.compile_index_access(object, index)
            }

            Expr::If {
                condition,
                then_branch,
                else_branch,
                ..
            } => self.compile_if(condition, then_branch, else_branch.as_ref()),

            Expr::Match {
                subject, arms, ..
            } => self.compile_match(subject, arms),

            Expr::Block(block) => {
                self.push_scope();
                let mut last = None;
                for stmt in &block.statements {
                    match stmt {
                        Statement::Expr(expr) => {
                            last = self.compile_expr(expr);
                        }
                        _ => {
                            self.compile_statement(stmt);
                            last = None;
                        }
                    }
                }
                self.pop_scope_with_drops();
                last
            }

            Expr::Closure { params, body, .. } => {
                self.compile_closure(params, body)
            }

            Expr::Pipe { left, right, .. } => {
                // a |> f  =>  f(a)
                let arg = self.compile_expr(left)?;
                // right should be a function identifier or expression
                if let Expr::Ident(name, _) = right.as_ref() {
                    if let Some(func) = self.functions.get(name).copied() {
                        let result = self.builder.build_call(
                            func,
                            &[arg.into()],
                            "pipe_result",
                        ).unwrap();
                        result.try_as_basic_value().left()
                    } else {
                        None
                    }
                } else {
                    None
                }
            }

            Expr::NullCoalesce { left, right, .. } => {
                self.compile_null_coalesce(left, right)
            }

            Expr::NullPropagate { object, field, .. } => {
                self.compile_null_propagate(object, field)
            }

            Expr::ErrorPropagate { operand, .. } => {
                // Simplified: compile the operand and handle Result
                self.compile_error_propagate(operand)
            }

            Expr::With { base, updates, .. } => {
                self.compile_with(base, updates)
            }

            Expr::Range { start, end, inclusive, .. } => {
                // Ranges are used in for loops, not as values typically
                // Store start and end for the for loop to pick up
                let _start_val = self.compile_expr(start)?;
                let _end_val = self.compile_expr(end)?;
                None
            }

            Expr::StructLit { fields, .. } => {
                self.compile_struct_lit(fields)
            }

            Expr::ListLit { elements, .. } => {
                self.compile_list_lit(elements)
            }

            Expr::MapLit { entries, .. } => {
                self.compile_map_lit(entries)
            }

            Expr::TupleLit { elements, .. } => {
                self.compile_tuple_lit(elements)
            }

            Expr::OkExpr { value, .. } => {
                self.compile_result_ok(value)
            }

            Expr::ErrExpr { value, .. } => {
                self.compile_result_err(value)
            }

            Expr::Catch { expr, binding, handler, .. } => {
                self.compile_catch(expr, binding.as_deref(), handler)
            }

            _ => None,
        }
    }

    pub(crate) fn compile_binary_op(
        &mut self,
        lhs: BasicValueEnum<'ctx>,
        op: BinaryOp,
        rhs: BasicValueEnum<'ctx>,
        left_expr: &Expr,
        right_expr: &Expr,
    ) -> Option<BasicValueEnum<'ctx>> {
        let left_type = self.infer_type(left_expr);
        let right_type = self.infer_type(right_expr);

        // Handle comparison with null: `name != null` or `name == null`
        let is_null_compare = matches!(right_expr, Expr::NullLit(_)) || matches!(left_expr, Expr::NullLit(_));
        if is_null_compare && matches!(op, BinaryOp::Eq | BinaryOp::NotEq) {
            // Determine which side is nullable
            let (nullable_val, nullable_type) = if matches!(right_expr, Expr::NullLit(_)) {
                (lhs, &left_type)
            } else {
                (rhs, &right_type)
            };

            if nullable_type.is_nullable() && nullable_val.is_struct_value() {
                let struct_val = nullable_val.into_struct_value();
                let tag = self.builder.build_extract_value(struct_val, 0, "null_tag").ok()?;
                let cmp = if matches!(op, BinaryOp::Eq) {
                    // == null means tag == 0
                    self.builder.build_int_compare(
                        IntPredicate::EQ,
                        tag.into_int_value(),
                        self.context.i8_type().const_zero(),
                        "is_null",
                    ).unwrap()
                } else {
                    // != null means tag != 0
                    self.builder.build_int_compare(
                        IntPredicate::NE,
                        tag.into_int_value(),
                        self.context.i8_type().const_zero(),
                        "is_not_null",
                    ).unwrap()
                };
                return Some(self.builder.build_int_z_extend(cmp, self.context.i8_type(), "null_cmp_ext").unwrap().into());
            }
        }

        // Float operations - check both inferred types AND actual LLVM values
        if left_type == Type::Float || right_type == Type::Float
            || lhs.is_float_value() || rhs.is_float_value()
        {
            let lhs_f = if lhs.is_int_value() {
                self.builder
                    .build_signed_int_to_float(lhs.into_int_value(), self.context.f64_type(), "itof")
                    .unwrap()
            } else {
                lhs.into_float_value()
            };
            let rhs_f = if rhs.is_int_value() {
                self.builder
                    .build_signed_int_to_float(rhs.into_int_value(), self.context.f64_type(), "itof")
                    .unwrap()
            } else {
                rhs.into_float_value()
            };

            return match op {
                BinaryOp::Add => Some(self.builder.build_float_add(lhs_f, rhs_f, "fadd").unwrap().into()),
                BinaryOp::Sub => Some(self.builder.build_float_sub(lhs_f, rhs_f, "fsub").unwrap().into()),
                BinaryOp::Mul => Some(self.builder.build_float_mul(lhs_f, rhs_f, "fmul").unwrap().into()),
                BinaryOp::Div => Some(self.builder.build_float_div(lhs_f, rhs_f, "fdiv").unwrap().into()),
                BinaryOp::Mod => Some(self.builder.build_float_rem(lhs_f, rhs_f, "fmod").unwrap().into()),
                BinaryOp::Eq => {
                    let cmp = self.builder.build_float_compare(inkwell::FloatPredicate::OEQ, lhs_f, rhs_f, "feq").unwrap();
                    Some(self.builder.build_int_z_extend(cmp, self.context.i8_type(), "feq_ext").unwrap().into())
                }
                BinaryOp::NotEq => {
                    let cmp = self.builder.build_float_compare(inkwell::FloatPredicate::ONE, lhs_f, rhs_f, "fne").unwrap();
                    Some(self.builder.build_int_z_extend(cmp, self.context.i8_type(), "fne_ext").unwrap().into())
                }
                BinaryOp::Lt => {
                    let cmp = self.builder.build_float_compare(inkwell::FloatPredicate::OLT, lhs_f, rhs_f, "flt").unwrap();
                    Some(self.builder.build_int_z_extend(cmp, self.context.i8_type(), "flt_ext").unwrap().into())
                }
                BinaryOp::LtEq => {
                    let cmp = self.builder.build_float_compare(inkwell::FloatPredicate::OLE, lhs_f, rhs_f, "fle").unwrap();
                    Some(self.builder.build_int_z_extend(cmp, self.context.i8_type(), "fle_ext").unwrap().into())
                }
                BinaryOp::Gt => {
                    let cmp = self.builder.build_float_compare(inkwell::FloatPredicate::OGT, lhs_f, rhs_f, "fgt").unwrap();
                    Some(self.builder.build_int_z_extend(cmp, self.context.i8_type(), "fgt_ext").unwrap().into())
                }
                BinaryOp::GtEq => {
                    let cmp = self.builder.build_float_compare(inkwell::FloatPredicate::OGE, lhs_f, rhs_f, "fge").unwrap();
                    Some(self.builder.build_int_z_extend(cmp, self.context.i8_type(), "fge_ext").unwrap().into())
                }
                _ => None,
            };
        }

        // Integer operations
        if lhs.is_int_value() && rhs.is_int_value() {
            let lhs_i = lhs.into_int_value();
            let rhs_i = rhs.into_int_value();

            // Make sure widths match (bool i8 vs int i64)
            let (lhs_i, rhs_i) = self.widen_ints(lhs_i, rhs_i);

            return match op {
                BinaryOp::Add => Some(self.builder.build_int_add(lhs_i, rhs_i, "add").unwrap().into()),
                BinaryOp::Sub => Some(self.builder.build_int_sub(lhs_i, rhs_i, "sub").unwrap().into()),
                BinaryOp::Mul => Some(self.builder.build_int_mul(lhs_i, rhs_i, "mul").unwrap().into()),
                BinaryOp::Div => Some(self.builder.build_int_signed_div(lhs_i, rhs_i, "div").unwrap().into()),
                BinaryOp::Mod => Some(self.builder.build_int_signed_rem(lhs_i, rhs_i, "mod").unwrap().into()),
                BinaryOp::Eq => {
                    let cmp = self.builder.build_int_compare(IntPredicate::EQ, lhs_i, rhs_i, "eq").unwrap();
                    Some(self.builder.build_int_z_extend(cmp, self.context.i8_type(), "eq_ext").unwrap().into())
                }
                BinaryOp::NotEq => {
                    let cmp = self.builder.build_int_compare(IntPredicate::NE, lhs_i, rhs_i, "ne").unwrap();
                    Some(self.builder.build_int_z_extend(cmp, self.context.i8_type(), "ne_ext").unwrap().into())
                }
                BinaryOp::Lt => {
                    let cmp = self.builder.build_int_compare(IntPredicate::SLT, lhs_i, rhs_i, "lt").unwrap();
                    Some(self.builder.build_int_z_extend(cmp, self.context.i8_type(), "lt_ext").unwrap().into())
                }
                BinaryOp::LtEq => {
                    let cmp = self.builder.build_int_compare(IntPredicate::SLE, lhs_i, rhs_i, "le").unwrap();
                    Some(self.builder.build_int_z_extend(cmp, self.context.i8_type(), "le_ext").unwrap().into())
                }
                BinaryOp::Gt => {
                    let cmp = self.builder.build_int_compare(IntPredicate::SGT, lhs_i, rhs_i, "gt").unwrap();
                    Some(self.builder.build_int_z_extend(cmp, self.context.i8_type(), "gt_ext").unwrap().into())
                }
                BinaryOp::GtEq => {
                    let cmp = self.builder.build_int_compare(IntPredicate::SGE, lhs_i, rhs_i, "ge").unwrap();
                    Some(self.builder.build_int_z_extend(cmp, self.context.i8_type(), "ge_ext").unwrap().into())
                }
                BinaryOp::And => {
                    let lhs_bool = self.builder.build_int_compare(IntPredicate::NE, lhs_i, lhs_i.get_type().const_zero(), "lhs_bool").unwrap();
                    let rhs_bool = self.builder.build_int_compare(IntPredicate::NE, rhs_i, rhs_i.get_type().const_zero(), "rhs_bool").unwrap();
                    let result = self.builder.build_and(lhs_bool, rhs_bool, "and").unwrap();
                    Some(self.builder.build_int_z_extend(result, self.context.i8_type(), "and_ext").unwrap().into())
                }
                BinaryOp::Or => {
                    let lhs_bool = self.builder.build_int_compare(IntPredicate::NE, lhs_i, lhs_i.get_type().const_zero(), "lhs_bool").unwrap();
                    let rhs_bool = self.builder.build_int_compare(IntPredicate::NE, rhs_i, rhs_i.get_type().const_zero(), "rhs_bool").unwrap();
                    let result = self.builder.build_or(lhs_bool, rhs_bool, "or").unwrap();
                    Some(self.builder.build_int_z_extend(result, self.context.i8_type(), "or_ext").unwrap().into())
                }
            };
        }

        // String concat
        if lhs.is_struct_value() && rhs.is_struct_value() {
            if matches!(op, BinaryOp::Add) && left_type == Type::String {
                let concat_fn = self.module.get_function("forge_string_concat").unwrap();
                let result = self.builder.build_call(
                    concat_fn,
                    &[lhs.into(), rhs.into()],
                    "concat",
                ).unwrap();
                return result.try_as_basic_value().left();
            }
        }

        // Operator overloading for user-defined types
        if let Some(type_name) = self.get_type_name(&left_type) {
            let (trait_name, method_name) = match op {
                BinaryOp::Add => ("Add", "add"),
                BinaryOp::Sub => ("Sub", "sub"),
                BinaryOp::Mul => ("Mul", "mul"),
                BinaryOp::Div => ("Div", "div"),
                BinaryOp::Eq => ("Eq", "eq"),
                BinaryOp::NotEq => ("Eq", "eq"),
                _ => ("", ""),
            };

            if !trait_name.is_empty() {
                if let Some(mangled) = self.find_operator_impl(&type_name, trait_name, method_name) {
                    if let Some(func) = self.functions.get(&mangled).copied() {
                        let result = self.builder.build_call(
                            func,
                            &[lhs.into(), rhs.into()],
                            "op_result",
                        ).unwrap();
                        let val = result.try_as_basic_value().left();

                        // For NotEq, negate the Eq result
                        if matches!(op, BinaryOp::NotEq) {
                            if let Some(v) = val {
                                if v.is_int_value() {
                                    let int_v = v.into_int_value();
                                    let zero = int_v.get_type().const_zero();
                                    let negated = self.builder.build_int_compare(
                                        IntPredicate::EQ, int_v, zero, "not_eq"
                                    ).unwrap();
                                    return Some(self.builder.build_int_z_extend(negated, self.context.i8_type(), "neq_ext").unwrap().into());
                                }
                            }
                        }
                        return val;
                    }
                }
            }
        }

        None
    }

    pub(crate) fn widen_ints(
        &self,
        a: IntValue<'ctx>,
        b: IntValue<'ctx>,
    ) -> (IntValue<'ctx>, IntValue<'ctx>) {
        let a_bits = a.get_type().get_bit_width();
        let b_bits = b.get_type().get_bit_width();
        if a_bits == b_bits {
            return (a, b);
        }
        if a_bits > b_bits {
            let b_ext = self
                .builder
                .build_int_s_extend(b, a.get_type(), "widen")
                .unwrap();
            (a, b_ext)
        } else {
            let a_ext = self
                .builder
                .build_int_s_extend(a, b.get_type(), "widen")
                .unwrap();
            (a_ext, b)
        }
    }

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

    pub(crate) fn compile_member_access(
        &mut self,
        object: &Expr,
        field: &str,
    ) -> Option<BasicValueEnum<'ctx>> {
        // Handle EnumName.variant (no-arg constructor)
        if let Expr::Ident(name, _) = object {
            if let Some(Type::Enum { variants, .. }) = self.type_checker.env.enum_types.get(name).cloned() {
                return self.compile_enum_constructor(name, field, &[], &variants);
            }
        }

        let obj_type = self.infer_type(object);

        // Handle string.length as a function call
        if obj_type == Type::String && field == "length" {
            let obj_val = self.compile_expr(object)?;
            let len_fn = self.module.get_function("forge_string_length").unwrap();
            let result = self.builder.build_call(len_fn, &[obj_val.into()], "len").unwrap();
            return result.try_as_basic_value().left();
        }

        // Handle list.length
        if let Type::List(_) = &obj_type {
            if field == "length" {
                let obj_val = self.compile_expr(object)?;
                if obj_val.is_struct_value() {
                    let struct_val = obj_val.into_struct_value();
                    // List is {ptr, len} - length is at index 1
                    return self.builder.build_extract_value(struct_val, 1, "list_length").ok();
                }
            }
        }

        // Handle tuple numeric field access (p.0, p.1, etc.)
        if let Type::Tuple(elems) = &obj_type {
            if let Ok(idx) = field.parse::<u32>() {
                if (idx as usize) < elems.len() {
                    let obj_val = self.compile_expr(object)?;
                    if obj_val.is_struct_value() {
                        let struct_val = obj_val.into_struct_value();
                        return self.builder.build_extract_value(struct_val, idx, &format!("tuple_{}", idx)).ok();
                    }
                }
            }
        }

        // Handle struct field access
        if let Type::Struct { fields, .. } = &obj_type {
            if let Some(idx) = fields.iter().position(|(name, _)| name == field) {
                let obj_val = self.compile_expr(object)?;
                if obj_val.is_struct_value() {
                    let struct_val = obj_val.into_struct_value();
                    return self.builder.build_extract_value(struct_val, idx as u32, field).ok();
                }
            }
        }

        // Handle nullable field access (simplified)
        if let Type::Nullable(inner) = &obj_type {
            if let Type::Struct { fields, .. } = inner.as_ref() {
                if let Some(idx) = fields.iter().position(|(name, _)| name == field) {
                    // For now, just try to access through the nullable
                    let obj_val = self.compile_expr(object)?;
                    if obj_val.is_struct_value() {
                        let struct_val = obj_val.into_struct_value();
                        return self.builder.build_extract_value(struct_val, idx as u32, field).ok();
                    }
                }
            }
        }

        None
    }

    pub(crate) fn compile_closure(
        &mut self,
        params: &[Param],
        body: &Expr,
    ) -> Option<BasicValueEnum<'ctx>> {
        // For simple closures, create an anonymous function
        let closure_name = format!("__closure_{}", self.functions.len());

        let param_types: Vec<Type> = params
            .iter()
            .map(|p| {
                p.type_ann
                    .as_ref()
                    .map(|t| self.type_checker.resolve_type_expr(t))
                    .unwrap_or(Type::Int) // default to int for untyped closures
            })
            .collect();

        let llvm_param_types: Vec<BasicMetadataTypeEnum<'ctx>> = param_types
            .iter()
            .map(|t| self.type_to_llvm_metadata(t))
            .collect();

        // We need to figure out the return type
        let ret_type = self.context.i64_type(); // default to i64

        let fn_type = ret_type.fn_type(&llvm_param_types, false);
        let function = self.module.add_function(&closure_name, fn_type, None);
        self.functions.insert(closure_name.clone(), function);

        // Save current state
        let saved_block = self.builder.get_insert_block();

        let entry = self.context.append_basic_block(function, "entry");
        self.builder.position_at_end(entry);

        self.push_scope();
        for (i, param) in params.iter().enumerate() {
            let param_val = function.get_nth_param(i as u32).unwrap();
            let ty = param_types[i].clone();
            let alloca = self.create_entry_block_alloca(&ty, &param.name);
            self.builder.build_store(alloca, param_val).unwrap();
            self.define_var(param.name.clone(), alloca, ty);
        }

        let ret_val = self.compile_expr(body);
        if let Some(val) = ret_val {
            self.builder.build_return(Some(&val)).unwrap();
        } else {
            self.builder.build_return(Some(&self.context.i64_type().const_zero())).unwrap();
        }
        self.pop_scope();

        // Restore position
        if let Some(block) = saved_block {
            self.builder.position_at_end(block);
        }

        Some(function.as_global_value().as_pointer_value().into())
    }
}
