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

        let function = self.builder.get_insert_block().unwrap().get_parent().unwrap();

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

        let mut then_val = None;
        for stmt in &then_branch.statements {
            match stmt {
                Statement::Expr(expr) => {
                    then_val = self.compile_expr(expr);
                }
                _ => {
                    self.compile_statement(stmt);
                    then_val = None;
                }
            }
        }
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
            for stmt in &else_b.statements {
                match stmt {
                    Statement::Expr(expr) => {
                        else_val = self.compile_expr(expr);
                    }
                    _ => {
                        self.compile_statement(stmt);
                        else_val = None;
                    }
                }
            }
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
            let else_type = else_branch.map(|eb| self.infer_if_branch_type_block(eb)).unwrap_or(Type::Void);

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

    pub(crate) fn compile_for(&mut self, pattern: &Pattern, iterable: &Expr, body: &Block) {
        // Handle range iteration: for i in start..end
        if let Expr::Range { start, end, inclusive, .. } = iterable {
            let start_val = self.compile_expr(start).unwrap();
            let end_val = self.compile_expr(end).unwrap();

            let function = self.builder.get_insert_block().unwrap().get_parent().unwrap();
            let loop_var_name = match pattern {
                Pattern::Ident(name, _) => name.clone(),
                _ => "__loop_var".to_string(),
            };

            // Alloca for loop variable
            let alloca = self.create_entry_block_alloca(&Type::Int, &loop_var_name);
            self.builder.build_store(alloca, start_val).unwrap();

            let loop_bb = self.context.append_basic_block(function, "for_loop");
            let body_bb = self.context.append_basic_block(function, "for_body");
            let end_bb = self.context.append_basic_block(function, "for_end");

            self.builder.build_unconditional_branch(loop_bb).unwrap();
            self.builder.position_at_end(loop_bb);

            let current = self.builder
                .build_load(self.context.i64_type(), alloca, "current")
                .unwrap()
                .into_int_value();

            let cond = if *inclusive {
                self.builder
                    .build_int_compare(IntPredicate::SLE, current, end_val.into_int_value(), "for_cond")
                    .unwrap()
            } else {
                self.builder
                    .build_int_compare(IntPredicate::SLT, current, end_val.into_int_value(), "for_cond")
                    .unwrap()
            };

            self.builder.build_conditional_branch(cond, body_bb, end_bb).unwrap();

            self.builder.position_at_end(body_bb);
            self.push_scope();
            self.define_var(loop_var_name.clone(), alloca, Type::Int);

            for stmt in &body.statements {
                self.compile_statement(stmt);
            }
            self.pop_scope();

            // Increment
            let current = self.builder
                .build_load(self.context.i64_type(), alloca, "current")
                .unwrap()
                .into_int_value();
            let next = self.builder
                .build_int_add(current, self.context.i64_type().const_int(1, false), "next")
                .unwrap();
            self.builder.build_store(alloca, next).unwrap();
            self.builder.build_unconditional_branch(loop_bb).unwrap();

            self.builder.position_at_end(end_bb);
            return;
        }

        // Handle list iteration: for item in list or for (i, item) in list.enumerate()
        let iter_type = self.infer_type(iterable);
        if let Type::List(elem_type) = &iter_type {
            let list_val = self.compile_expr(iterable).unwrap();
            let struct_val = list_val.into_struct_value();
            let data_ptr = self.builder.build_extract_value(struct_val, 0, "list_data").unwrap().into_pointer_value();
            let list_len = self.builder.build_extract_value(struct_val, 1, "list_len").unwrap().into_int_value();

            let function = self.builder.get_insert_block().unwrap().get_parent().unwrap();

            // Alloca for index
            let idx_alloca = self.create_entry_block_alloca(&Type::Int, "__for_idx");
            self.builder.build_store(idx_alloca, self.context.i64_type().const_zero()).unwrap();

            let loop_bb = self.context.append_basic_block(function, "for_loop");
            let body_bb = self.context.append_basic_block(function, "for_body");
            let end_bb = self.context.append_basic_block(function, "for_end");

            self.builder.build_unconditional_branch(loop_bb).unwrap();
            self.builder.position_at_end(loop_bb);

            let current_idx = self.builder
                .build_load(self.context.i64_type(), idx_alloca, "idx")
                .unwrap()
                .into_int_value();

            let cond = self.builder
                .build_int_compare(IntPredicate::SLT, current_idx, list_len, "for_cond")
                .unwrap();
            self.builder.build_conditional_branch(cond, body_bb, end_bb).unwrap();

            self.builder.position_at_end(body_bb);
            self.push_scope();

            // Load current element
            let actual_elem_type = elem_type.as_ref();
            let elem_llvm_ty = self.type_to_llvm_basic(actual_elem_type);
            let elem_ptr = unsafe {
                self.builder.build_gep(elem_llvm_ty, data_ptr, &[current_idx], "elem_ptr").unwrap()
            };
            let elem_val = self.builder.build_load(elem_llvm_ty, elem_ptr, "elem").unwrap();

            // Bind pattern
            match pattern {
                Pattern::Ident(name, _) => {
                    let alloca = self.create_entry_block_alloca(actual_elem_type, name);
                    self.builder.build_store(alloca, elem_val).unwrap();
                    self.define_var(name.clone(), alloca, actual_elem_type.clone());
                }
                Pattern::Tuple(elems, _) => {
                    // Destructure tuple - elem_val should be a struct (tuple)
                    if let Type::Tuple(tuple_types) = actual_elem_type {
                        if elem_val.is_struct_value() {
                            let tuple_val = elem_val.into_struct_value();
                            for (i, pat) in elems.iter().enumerate() {
                                if let Pattern::Ident(name, _) = pat {
                                    let field_ty = tuple_types.get(i).cloned().unwrap_or(Type::Int);
                                    let field_val = self.builder
                                        .build_extract_value(tuple_val, i as u32, name)
                                        .unwrap();
                                    let alloca = self.create_entry_block_alloca(&field_ty, name);
                                    self.builder.build_store(alloca, field_val).unwrap();
                                    self.define_var(name.clone(), alloca, field_ty);
                                }
                            }
                        }
                    }
                }
                _ => {}
            }

            for stmt in &body.statements {
                self.compile_statement(stmt);
            }
            self.pop_scope();

            // Increment index
            let current_idx = self.builder
                .build_load(self.context.i64_type(), idx_alloca, "idx")
                .unwrap()
                .into_int_value();
            let next_idx = self.builder
                .build_int_add(current_idx, self.context.i64_type().const_int(1, false), "next_idx")
                .unwrap();
            self.builder.build_store(idx_alloca, next_idx).unwrap();
            if self.builder.get_insert_block().unwrap().get_terminator().is_none() {
                self.builder.build_unconditional_branch(loop_bb).unwrap();
            }

            self.builder.position_at_end(end_bb);
        }
    }

    pub(crate) fn compile_while(&mut self, condition: &Expr, body: &Block) {
        let function = self.builder.get_insert_block().unwrap().get_parent().unwrap();

        let cond_bb = self.context.append_basic_block(function, "while_cond");
        let body_bb = self.context.append_basic_block(function, "while_body");
        let end_bb = self.context.append_basic_block(function, "while_end");

        self.builder.build_unconditional_branch(cond_bb).unwrap();
        self.builder.position_at_end(cond_bb);

        let cond_val = self.compile_expr(condition).unwrap();
        let cond_bool = self.to_i1(cond_val);
        self.builder.build_conditional_branch(cond_bool, body_bb, end_bb).unwrap();

        self.builder.position_at_end(body_bb);
        self.push_scope();
        for stmt in &body.statements {
            self.compile_statement(stmt);
        }
        self.pop_scope();

        if self.builder.get_insert_block().unwrap().get_terminator().is_none() {
            self.builder.build_unconditional_branch(cond_bb).unwrap();
        }

        self.builder.position_at_end(end_bb);
    }

    pub(crate) fn compile_loop(&mut self, body: &Block) {
        let function = self.builder.get_insert_block().unwrap().get_parent().unwrap();

        let body_bb = self.context.append_basic_block(function, "loop_body");
        let end_bb = self.context.append_basic_block(function, "loop_end");

        // Create alloca for break value
        let break_alloca = self.builder.build_alloca(self.context.i64_type(), "loop_break_val").unwrap();

        self.loop_exit_blocks.push((end_bb, Some(break_alloca)));

        self.builder.build_unconditional_branch(body_bb).unwrap();
        self.builder.position_at_end(body_bb);

        self.push_scope();
        for stmt in &body.statements {
            self.compile_statement(stmt);
        }
        self.pop_scope();

        if self.builder.get_insert_block().unwrap().get_terminator().is_none() {
            self.builder.build_unconditional_branch(body_bb).unwrap();
        }

        self.builder.position_at_end(end_bb);

        self.loop_exit_blocks.pop();
    }

    pub(crate) fn compile_break(&mut self, value: Option<&Expr>) {
        if let Some((exit_bb, break_alloca)) = self.loop_exit_blocks.last().copied() {
            if let Some(val_expr) = value {
                if let Some(val) = self.compile_expr(val_expr) {
                    if let Some(alloca) = break_alloca {
                        self.builder.build_store(alloca, val).unwrap();
                    }
                }
            }
            self.builder.build_unconditional_branch(exit_bb).unwrap();
        }
    }
}
