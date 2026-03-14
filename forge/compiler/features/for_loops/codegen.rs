use inkwell::IntPredicate;

use crate::codegen::codegen::Codegen;
use crate::feature::FeatureStmt;
use crate::feature_data;
use crate::parser::ast::*;
use crate::typeck::types::Type;

use super::super::ranges::types::RangeData;
use super::types::ForData;

impl<'ctx> Codegen<'ctx> {
    /// Compile a for loop via the Feature dispatch system.
    pub(crate) fn compile_for_feature(&mut self, fe: &FeatureStmt) {
        if let Some(data) = feature_data!(fe, ForData) {
            self.compile_for(&data.pattern, &data.iterable, &data.body);
        }
    }

    pub(crate) fn compile_for(&mut self, pattern: &Pattern, iterable: &Expr, body: &Block) {
        // Handle range iteration: for i in start..end (Feature variant)
        if let Expr::Feature(fe) = iterable {
            if fe.feature_id == "ranges" {
                if let Some(data) = feature_data!(fe, RangeData) {
                    self.compile_for_range(pattern, &data.start, &data.end, data.inclusive, body);
                    return;
                }
            }
        }
        // Handle range iteration: for i in start..end (legacy variant)
        if let Expr::Range { start, end, inclusive, .. } = iterable {
            self.compile_for_range(pattern, start, end, *inclusive, body);
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

            // Create an increment block for continue to jump to
            let inc_bb = self.context.append_basic_block(function, "for_inc");

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

            // Push exit and continue blocks for break/continue
            self.loop_exit_blocks.push((end_bb, None));
            self.loop_continue_blocks.push(inc_bb);

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

            self.loop_exit_blocks.pop();
            self.loop_continue_blocks.pop();

            // Branch to increment block if no terminator (break/continue already jumped)
            if self.builder.get_insert_block().unwrap().get_terminator().is_none() {
                self.builder.build_unconditional_branch(inc_bb).unwrap();
            }

            // Increment block: bump index and jump back to condition
            self.builder.position_at_end(inc_bb);
            let current_idx = self.builder
                .build_load(self.context.i64_type(), idx_alloca, "idx")
                .unwrap()
                .into_int_value();
            let next_idx = self.builder
                .build_int_add(current_idx, self.context.i64_type().const_int(1, false), "next_idx")
                .unwrap();
            self.builder.build_store(idx_alloca, next_idx).unwrap();
            self.builder.build_unconditional_branch(loop_bb).unwrap();

            self.builder.position_at_end(end_bb);
        } else if iter_type == Type::Int || matches!(iter_type, Type::Channel(_)) {
            // Treat int/channel as channel ID — iterate by calling forge_channel_receive
            // until we get the "\0CLOSED" sentinel
            let channel_id = self.compile_expr(iterable).unwrap();
            let function = self.builder.get_insert_block().unwrap().get_parent().unwrap();

            let loop_bb = self.context.append_basic_block(function, "chan_loop");
            let body_bb = self.context.append_basic_block(function, "chan_body");
            let end_bb = self.context.append_basic_block(function, "chan_end");

            // Store channel ID for break/continue
            let ch_id_alloca = self.create_entry_block_alloca(&Type::Int, "__chan_id");
            self.builder.build_store(ch_id_alloca, channel_id).unwrap();

            self.builder.build_unconditional_branch(loop_bb).unwrap();
            self.builder.position_at_end(loop_bb);

            // Call forge_channel_receive(id) -> ptr
            let ch_id = self.builder.build_load(self.context.i64_type(), ch_id_alloca, "ch_id").unwrap();
            let recv_fn = self.module.get_function("forge_channel_receive").unwrap();
            let raw_ptr = self.builder.build_call(recv_fn, &[ch_id.into()], "recv_ptr")
                .unwrap().try_as_basic_value().left().unwrap().into_pointer_value();

            // Check if result starts with \0 (sentinel for closed)
            // Load first byte and check if it's 0 (the \0 in \0CLOSED)
            let first_byte = self.builder.build_load(self.context.i8_type(), raw_ptr, "first_byte")
                .unwrap().into_int_value();
            let is_sentinel = self.builder.build_int_compare(
                IntPredicate::EQ, first_byte, self.context.i8_type().const_zero(), "is_closed"
            ).unwrap();
            self.builder.build_conditional_branch(is_sentinel, end_bb, body_bb).unwrap();

            self.builder.position_at_end(body_bb);
            self.push_scope();

            // Convert raw ptr to ForgeString for the loop variable
            let ptr_type = self.context.ptr_type(inkwell::AddressSpace::default());
            let strlen_fn = self.module.get_function("strlen").unwrap_or_else(|| {
                let ft = self.context.i64_type().fn_type(&[ptr_type.into()], false);
                self.module.add_function("strlen", ft, None)
            });
            let len = self.builder.build_call(strlen_fn, &[raw_ptr.into()], "slen")
                .unwrap().try_as_basic_value().left().unwrap();
            let str_new_fn = self.module.get_function("forge_string_new").unwrap();
            let forge_str = self.builder.build_call(
                str_new_fn, &[raw_ptr.into(), len.into()], "msg_str",
            ).unwrap().try_as_basic_value().left().unwrap();

            // Bind the pattern
            match pattern {
                Pattern::Ident(name, _) => {
                    if name != "_" {
                        let alloca = self.create_entry_block_alloca(&Type::String, name);
                        self.builder.build_store(alloca, forge_str).unwrap();
                        self.define_var(name.clone(), alloca, Type::String);
                    }
                }
                _ => {}
            }

            self.loop_exit_blocks.push((end_bb, None));

            for stmt in &body.statements {
                self.compile_statement(stmt);
            }
            self.pop_scope();

            self.loop_exit_blocks.pop();

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

        // Push exit and continue blocks for break/continue
        self.loop_exit_blocks.push((end_bb, None));
        self.loop_continue_blocks.push(cond_bb);

        for stmt in &body.statements {
            self.compile_statement(stmt);
        }
        self.pop_scope();

        self.loop_exit_blocks.pop();
        self.loop_continue_blocks.pop();

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
        self.loop_continue_blocks.push(body_bb);

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
        self.loop_continue_blocks.pop();
    }

    /// Compile a for loop over a range: `for i in start..end` or `for i in start..=end`.
    pub(crate) fn compile_for_range(
        &mut self,
        pattern: &Pattern,
        start: &Expr,
        end: &Expr,
        inclusive: bool,
        body: &Block,
    ) {
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
        let inc_bb = self.context.append_basic_block(function, "for_inc");
        let end_bb = self.context.append_basic_block(function, "for_end");

        self.builder.build_unconditional_branch(loop_bb).unwrap();
        self.builder.position_at_end(loop_bb);

        let current = self.builder
            .build_load(self.context.i64_type(), alloca, "current")
            .unwrap()
            .into_int_value();

        let cond = if inclusive {
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

        // Push exit and continue blocks for break/continue
        self.loop_exit_blocks.push((end_bb, None));
        self.loop_continue_blocks.push(inc_bb);

        for stmt in &body.statements {
            self.compile_statement(stmt);
        }
        self.pop_scope();

        self.loop_exit_blocks.pop();
        self.loop_continue_blocks.pop();

        // Branch to increment block if no terminator (break/continue already jumped)
        if self.builder.get_insert_block().unwrap().get_terminator().is_none() {
            self.builder.build_unconditional_branch(inc_bb).unwrap();
        }

        // Increment block
        self.builder.position_at_end(inc_bb);
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
    }

    pub(crate) fn compile_continue(&mut self) {
        if let Some(continue_bb) = self.loop_continue_blocks.last().copied() {
            self.builder.build_unconditional_branch(continue_bb).unwrap();
        }
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
