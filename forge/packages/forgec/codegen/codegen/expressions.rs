use super::*;

impl<'ctx> Codegen<'ctx> {
    pub(crate) fn compile_expr(&mut self, expr: &Expr) -> Option<BasicValueEnum<'ctx>> {
        match expr {
            Expr::IntLit(n, _) => Some(self.context.i64_type().const_int(*n as u64, true).into()),
            Expr::FloatLit(f, _) => Some(self.context.f64_type().const_float(*f).into()),
            Expr::BoolLit(b, _) => Some(self.context.i8_type().const_int(*b as u64, false).into()),
            Expr::NullLit(_) => {
                let inner_ty = if let Some(Type::Nullable(inner)) = &self.current_fn_return_type {
                    self.type_to_llvm_basic(inner)
                } else {
                    self.context.i64_type().into()
                };
                let null_struct = self.context.struct_type(
                    &[self.context.i8_type().into(), inner_ty.into()],
                    false,
                );
                Some(null_struct.const_zero().into())
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
                } else if name.starts_with('.') {
                    self.compile_contextual_variant(name)
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
                    UnaryOp::BitNot => {
                        let int_val = val.into_int_value();
                        Some(
                            self.builder
                                .build_not(int_val, "bitnot")
                                .unwrap()
                                .into(),
                        )
                    }
                }
            }

            Expr::Call { callee, args, type_args, .. } => self.compile_call(callee, args, type_args),
            Expr::MemberAccess { object, field, .. } => self.compile_member_access(object, field),
            Expr::Index { object, index, .. } => self.compile_index_access(object, index),
            Expr::Block(block) => {
                self.push_scope();
                let mut last = None;
                let mut last_expr = None;
                for stmt in &block.statements {
                    match stmt {
                        Statement::Expr(expr) => {
                            last = self.compile_expr(expr);
                            last_expr = Some(expr);
                        }
                        _ => {
                            self.compile_statement(stmt);
                            last = None;
                            last_expr = None;
                        }
                    }
                }
                self.last_block_result_type = last_expr.map(|e| self.infer_type(e));
                self.pop_scope_with_drops();
                last
            }

            Expr::Feature(fe) => self.compile_feature_expr(fe),
        }
    }

    /// Dispatch a feature-owned expression to the appropriate feature's codegen.
    pub(crate) fn compile_feature_expr(&mut self, fe: &crate::feature::FeatureExpr) -> Option<BasicValueEnum<'ctx>> {
        crate::dispatch_feature_expr!(self, fe, {
            ("spawn", _)                       => compile_spawn_feature,
            ("ranges", _)                      => compile_range_feature,
            ("is_keyword", _)                  => compile_is_feature,
            ("with_expression", _)             => compile_with_feature,
            ("pipe_operator", _)               => compile_pipe_feature,
            ("shell_shorthand", _)             => compile_dollar_exec_feature,
            ("tagged_templates", _)            => compile_tagged_template_feature,
            ("table_literal", _)               => compile_table_lit_feature,
            ("closures", _)                    => compile_closure_feature,
            ("pattern_matching", _)            => compile_match_feature,
            ("match_tables", _)               => compile_match_table_feature,
            ("channels", _)                    => compile_channel_feature,
            ("if_else", _)                     => compile_if_feature,
            ("null_safety", "NullCoalesce")    => compile_null_coalesce_feature,
            ("null_throw", _)                  => compile_null_throw_feature,
            ("null_safety", "NullPropagate")   => compile_null_propagate_feature,
            ("null_safety", "ForceUnwrap")     => compile_force_unwrap_feature,
            ("error_propagation", "ErrorPropagate") => compile_error_propagate_feature,
            ("error_propagation", "OkExpr")    => compile_ok_expr_feature,
            ("error_propagation", "ErrExpr")   => compile_err_expr_feature,
            ("error_propagation", "Catch")     => compile_catch_feature,
            ("structs", _)                     => compile_struct_lit_feature,
            ("tuples", _)                      => compile_tuple_lit_feature,
            ("collections", "ListLit")         => compile_list_lit_feature,
            ("collections", "MapLit")          => compile_map_lit_feature,
            ("slicing", _)                     => compile_slice_feature,
        })
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
            return self.call_runtime("forge_string_length", &[obj_val.into()], "len");
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

        // Handle map.length
        if let Type::Map(_, _) = &obj_type {
            if field == "length" {
                let obj_val = self.compile_expr(object)?;
                if obj_val.is_struct_value() {
                    let struct_val = obj_val.into_struct_value();
                    // Map is {keys_ptr, values_ptr, length} - length at index 2
                    return self.builder.build_extract_value(struct_val, 2, "map_length").ok();
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

        // Handle nullable field access: Optional is {i8, inner_struct}
        // Extract inner value at index 1, then field from inner struct
        if let Type::Nullable(inner) = &obj_type {
            if let Type::Struct { fields, .. } = inner.as_ref() {
                if let Some(idx) = fields.iter().position(|(name, _)| name == field) {
                    let obj_val = self.compile_expr(object)?;
                    if obj_val.is_struct_value() {
                        let struct_val = obj_val.into_struct_value();
                        // Unwrap optional: extract inner value at index 1
                        if let Some(inner_val) = self.builder.build_extract_value(struct_val, 1, "opt_inner").ok() {
                            if inner_val.is_struct_value() {
                                return self.builder.build_extract_value(inner_val.into_struct_value(), idx as u32, field).ok();
                            }
                        }
                    }
                }
            }
        }

        // Handle channel property access (channel is represented as int)
        // ch.is_closed, ch.length, ch.capacity, ch.is_empty, ch.is_full
        if obj_type == Type::Int || obj_type == Type::Unknown || matches!(obj_type, Type::Channel(_)) {
            let channel_fn_name = match field {
                "is_closed" => Some("forge_channel_is_closed"),
                "length" => Some("forge_channel_length"),
                "capacity" => Some("forge_channel_capacity"),
                "is_empty" => Some("forge_channel_is_empty"),
                "is_full" => Some("forge_channel_is_full"),
                _ => None,
            };
            if let Some(fn_name) = channel_fn_name {
                if let Some(func) = self.module.get_function(fn_name) {
                    let obj_val = self.compile_expr(object)?;
                    let result = self.builder.build_call(func, &[obj_val.into()], field).unwrap();
                    return result.try_as_basic_value().left();
                }
            }
        }

        None
    }

    pub(crate) fn value_to_cstring_ptr(&mut self, val: BasicValueEnum<'ctx>, expr: &Expr) -> BasicValueEnum<'ctx> {
        let resolved = self.resolve_runtime_type(expr, &val);

        // Convert non-string types to ForgeString first
        let str_val = match resolved {
            Type::Int => self.call_runtime("forge_int_to_string", &[val.into()], "int_str"),
            Type::Float => self.call_runtime("forge_float_to_string", &[val.into()], "float_str"),
            Type::Bool => self.call_runtime("forge_bool_to_string", &[val.into()], "bool_str"),
            _ => None,
        };

        // Extract ptr from ForgeString (either converted or original)
        let target = str_val.unwrap_or(val);
        if target.is_struct_value() {
            self.builder.build_extract_value(target.into_struct_value(), 0, "str_ptr").unwrap().into()
        } else {
            target
        }
    }
}
