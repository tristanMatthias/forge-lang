use super::*;

impl<'ctx> Codegen<'ctx> {
    pub(crate) fn compile_if(
        &mut self,
        condition: &Expr,
        then_branch: &Block,
        else_branch: Option<&Block>,
    ) -> Option<BasicValueEnum<'ctx>> {
        let cond_val = self.compile_expr(condition)?;

        // Convert to i1 bool
        let cond_bool = if cond_val.is_int_value() {
            let int_val = cond_val.into_int_value();
            if int_val.get_type().get_bit_width() == 1 {
                int_val
            } else {
                self.builder
                    .build_int_compare(
                        IntPredicate::NE,
                        int_val,
                        int_val.get_type().const_zero(),
                        "cond",
                    )
                    .unwrap()
            }
        } else {
            return None;
        };

        let function = self.current_function();

        let then_bb = self.context.append_basic_block(function, "then");
        let else_bb = self.context.append_basic_block(function, "else");
        let merge_bb = self.context.append_basic_block(function, "merge");

        self.builder.build_conditional_branch(cond_bool, then_bb, else_bb).unwrap();

        // Detect smart narrowing: if condition is `name != null`, narrow name in then-branch
        let narrowing_info = self.detect_null_check(condition);

        // Then branch
        self.builder.position_at_end(then_bb);
        self.push_scope();

        // Apply smart narrowing in then-branch
        if let Some((ref var_name, ref inner_type)) = narrowing_info {
            if let Some((ptr, ty)) = self.lookup_var(var_name) {
                if ty.is_nullable() {
                    // Load the nullable struct, extract the inner value, rebind
                    let llvm_ty = self.type_to_llvm_basic(&ty);
                    let nullable_val = self.builder.build_load(llvm_ty, ptr, "narrow_load").unwrap();
                    if nullable_val.is_struct_value() {
                        let inner_val = self.builder.build_extract_value(nullable_val.into_struct_value(), 1, "narrowed").ok();
                        if let Some(iv) = inner_val {
                            let narrow_alloca = self.create_entry_block_alloca(inner_type, var_name);
                            self.builder.build_store(narrow_alloca, iv).unwrap();
                            self.define_var(var_name.clone(), narrow_alloca, inner_type.clone());
                        }
                    }
                }
            }
        }

        let then_val = self.compile_block_for_value(then_branch);
        self.pop_scope();
        let then_end_bb = self.builder.get_insert_block().unwrap();
        if then_end_bb.get_terminator().is_none() {
            self.builder.build_unconditional_branch(merge_bb).unwrap();
        }

        // Else branch
        self.builder.position_at_end(else_bb);
        let mut else_val = None;
        if let Some(else_b) = else_branch {
            self.push_scope();
            else_val = self.compile_block_for_value(else_b);
            self.pop_scope();
        }
        let else_end_bb = self.builder.get_insert_block().unwrap();
        if else_end_bb.get_terminator().is_none() {
            self.builder.build_unconditional_branch(merge_bb).unwrap();
        }

        self.builder.position_at_end(merge_bb);

        // If both branches produce values, create a phi node
        if let (Some(tv), Some(ev)) = (&then_val, &else_val) {
            if tv.get_type() == ev.get_type() {
                let phi = self.builder.build_phi(tv.get_type(), "if_result").unwrap();
                phi.add_incoming(&[(tv, then_end_bb), (ev, else_end_bb)]);
                return Some(phi.as_basic_value());
            }

            // Check if we need to wrap values into a nullable type
            // This handles cases like: if cond { "alice" } else { null }
            // where one branch is a value and the other is a nullable (null)
            let then_type = self.infer_if_branch_type(then_branch);
            let else_type = else_branch.map(|eb| self.infer_if_branch_type(eb)).unwrap_or(Type::Void);

            let is_then_null = matches!(then_type, Type::Nullable(_));
            let is_else_null = matches!(else_type, Type::Nullable(_));

            if is_then_null || is_else_null {
                // Determine the nullable result type
                let nullable_ty = if let Some(ref ret_ty) = self.current_fn_return_type {
                    if matches!(ret_ty, Type::Nullable(_)) {
                        ret_ty.clone()
                    } else {
                        // Infer from whichever branch is non-null
                        let inner = if !is_then_null { then_type.clone() } else if let Type::Nullable(inner) = &else_type { *inner.clone() } else { else_type.clone() };
                        Type::Nullable(Box::new(inner))
                    }
                } else {
                    let inner = if !is_then_null { then_type.clone() } else if let Type::Nullable(inner) = &else_type { *inner.clone() } else { else_type.clone() };
                    Type::Nullable(Box::new(inner))
                };

                let nullable_llvm_ty = self.type_to_llvm_basic(&nullable_ty);

                // Wrap each branch value into the nullable struct via alloca
                // Then branch
                self.builder.position_at_end(then_end_bb);
                // Remove the existing terminator (branch to merge) so we can insert before it
                if let Some(term) = then_end_bb.get_terminator() {
                    term.erase_from_basic_block();
                }
                let then_wrapped = if is_then_null {
                    // Already a nullable (null), but may need type coercion
                    self.coerce_value(*tv, nullable_llvm_ty)
                } else {
                    // Wrap value: create {i8=1, value}
                    self.wrap_in_nullable(*tv, &nullable_ty)
                };
                let then_end_bb2 = self.builder.get_insert_block().unwrap();
                self.builder.build_unconditional_branch(merge_bb).unwrap();

                // Else branch
                self.builder.position_at_end(else_end_bb);
                if let Some(term) = else_end_bb.get_terminator() {
                    term.erase_from_basic_block();
                }
                let else_wrapped = if is_else_null {
                    self.coerce_value(*ev, nullable_llvm_ty)
                } else {
                    self.wrap_in_nullable(*ev, &nullable_ty)
                };
                let else_end_bb2 = self.builder.get_insert_block().unwrap();
                self.builder.build_unconditional_branch(merge_bb).unwrap();

                self.builder.position_at_end(merge_bb);
                let phi = self.builder.build_phi(nullable_llvm_ty, "if_nullable_result").unwrap();
                phi.add_incoming(&[(&then_wrapped, then_end_bb2), (&else_wrapped, else_end_bb2)]);
                return Some(phi.as_basic_value());
            }
        }

        then_val.or(else_val)
    }
    /// Compile all statements in a block, tracking the last expression value.
    /// Returns the value of the last expression statement, or None if the block
    /// ends with a non-expression statement.
    pub(crate) fn compile_block_for_value(&mut self, block: &Block) -> Option<BasicValueEnum<'ctx>> {
        let mut last_val = None;
        for stmt in &block.statements {
            match stmt {
                Statement::Expr(expr) => {
                    last_val = self.compile_expr(expr);
                }
                _ => {
                    self.compile_statement(stmt);
                    last_val = None;
                }
            }
        }
        last_val
    }

    // compile_for: extracted to features/
    // compile_while: extracted to features/
    // compile_loop: extracted to features/
    // compile_break: extracted to features/
}
