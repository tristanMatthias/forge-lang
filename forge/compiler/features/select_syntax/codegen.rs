use inkwell::IntPredicate;

use crate::codegen::codegen::Codegen;
use crate::feature::FeatureStmt;
use crate::feature_data;
use crate::parser::ast::*;
use crate::typeck::types::Type;

use super::types::SelectData;

impl<'ctx> Codegen<'ctx> {
    /// Compile a select statement via the Feature dispatch system.
    pub(crate) fn compile_select_feature(&mut self, fe: &FeatureStmt) {
        if let Some(data) = feature_data!(fe, SelectData) {
            self.compile_select(&data.arms);
        }
    }

    /// Compile a `select { ... }` statement.
    ///
    /// Uses a polling approach: loops over arms, calls `forge_channel_try_receive`
    /// on each channel, and executes the first arm that receives a value.
    /// If no arm matches, loops back to retry.
    pub(crate) fn compile_select(&mut self, arms: &[SelectArm]) {
        // Polling approach: loop over arms, try_receive on each, execute first one that succeeds
        let function = self.builder.get_insert_block().unwrap().get_parent().unwrap();
        let select_loop = self.context.append_basic_block(function, "select_loop");
        let select_end = self.context.append_basic_block(function, "select_end");

        self.builder.build_unconditional_branch(select_loop).unwrap();
        self.builder.position_at_end(select_loop);

        for (i, arm) in arms.iter().enumerate() {
            let ch_val = self.compile_expr(&arm.channel);
            if let Some(ch_val) = ch_val {
                let ch_id = ch_val.into_int_value();

                // Call forge_channel_try_receive(id, timeout_ms) for non-blocking check
                let try_recv = self.module.get_function("forge_channel_try_receive")
                    .expect("forge_channel_try_receive not declared");
                let timeout = self.context.i64_type().const_int(10, false); // 10ms poll
                let result = self.builder.build_call(try_recv, &[ch_id.into(), timeout.into()], "try_recv").unwrap();
                let raw_ptr = result.try_as_basic_value().left().unwrap();

                // Check if result starts with \0 (sentinel for TIMEOUT/CLOSED)
                let first_byte_ptr = raw_ptr.into_pointer_value();
                let first_byte = self.builder.build_load(self.context.i8_type(), first_byte_ptr, "first_byte").unwrap().into_int_value();
                let is_null = self.builder.build_int_compare(
                    IntPredicate::EQ, first_byte, self.context.i8_type().const_zero(), "is_sentinel"
                ).unwrap();

                let arm_name = format!("select_arm_{}", i);
                let next_name = format!("select_next_{}", i);
                let arm_bb = self.context.append_basic_block(function, &arm_name);
                let next_bb = self.context.append_basic_block(function, &next_name);

                self.builder.build_conditional_branch(is_null, next_bb, arm_bb).unwrap();

                // Arm body: received a value
                self.builder.position_at_end(arm_bb);
                self.push_scope();

                // Convert ptr to ForgeString and bind to pattern
                let strlen_fn = self.module.get_function("strlen").unwrap();
                let len = self.builder.build_call(strlen_fn, &[raw_ptr.into()], "len").unwrap()
                    .try_as_basic_value().left().unwrap().into_int_value();
                let string_new = self.module.get_function("forge_string_new").unwrap();
                let forge_str = self.builder.build_call(string_new, &[raw_ptr.into(), len.into()], "str").unwrap()
                    .try_as_basic_value().left().unwrap();

                // Bind pattern
                if let Pattern::Ident(name, _) = &arm.binding {
                    let alloca = self.create_entry_block_alloca(&Type::String, name);
                    self.builder.build_store(alloca, forge_str).unwrap();
                    self.define_var(name.clone(), alloca, Type::String);
                }

                // Compile body
                for stmt in &arm.body.statements {
                    self.compile_statement(stmt);
                }
                self.pop_scope();

                if self.builder.get_insert_block().unwrap().get_terminator().is_none() {
                    self.builder.build_unconditional_branch(select_end).unwrap();
                }

                self.builder.position_at_end(next_bb);
            }
        }

        // If no arm matched, loop back
        self.builder.build_unconditional_branch(select_loop).unwrap();

        self.builder.position_at_end(select_end);
    }
}
