use std::collections::HashMap;

use inkwell::values::BasicValueEnum;

use crate::codegen::codegen::Codegen;
use crate::parser::ast::*;

impl<'ctx> Codegen<'ctx> {
    /// Compile a `spawn { ... }` block.
    ///
    /// Captures variables from the outer scope into globals, creates an anonymous
    /// LLVM function for the spawn body, loads captured variables inside it,
    /// and calls `forge_spawn(fn_ptr)` to run it on a new thread.
    pub(crate) fn compile_spawn_block(
        &mut self,
        body: &Block,
    ) -> Option<BasicValueEnum<'ctx>> {
        // Capture variables from outer scope into globals so the spawn
        // function (a separate LLVM function) can access them.
        let cap_prefix = format!("__spawn_cap_{}", self.functions.len());
        let captured = self.capture_scope_vars_to_globals(&cap_prefix);

        // Create an anonymous function for the spawn body
        let spawn_fn_name = format!("__spawn_{}", self.functions.len());
        let fn_type = self.context.void_type().fn_type(&[], false);
        let spawn_function = self.module.add_function(&spawn_fn_name, fn_type, None);

        // Save current state
        let saved_block = self.builder.get_insert_block();
        let saved_deferred = std::mem::take(&mut self.deferred_stmts);
        let saved_vars = std::mem::take(&mut self.variables);
        let saved_scope_vars = std::mem::take(&mut self.scope_vars);

        // Start fresh scope for spawn function
        self.variables = vec![HashMap::new()];
        self.scope_vars = vec![Vec::new()];

        let entry = self.context.append_basic_block(spawn_function, "entry");
        self.builder.position_at_end(entry);

        // Load captured variables from globals into local allocas
        for (name, global_name, ty) in &captured {
            if let Some(global) = self.module.get_global(global_name) {
                let llvm_ty = self.type_to_llvm_basic(ty);
                let val = self.builder.build_load(llvm_ty, global.as_pointer_value(), name).unwrap();
                let alloca = self.create_entry_block_alloca(ty, name);
                self.builder.build_store(alloca, val).unwrap();
                self.define_var(name.clone(), alloca, ty.clone());
            }
        }

        for stmt in &body.statements {
            self.compile_statement(stmt);
        }

        // Add return if no terminator
        if self.builder.get_insert_block().unwrap().get_terminator().is_none() {
            self.builder.build_return(None).unwrap();
        }

        // Restore state
        self.variables = saved_vars;
        self.scope_vars = saved_scope_vars;
        self.deferred_stmts = saved_deferred;

        // Restore position
        if let Some(block) = saved_block {
            self.builder.position_at_end(block);
        }

        // Call forge_spawn(fn_ptr)
        let forge_spawn = self.module.get_function("forge_spawn").unwrap();
        let fn_ptr = spawn_function.as_global_value().as_pointer_value();
        self.builder.build_call(forge_spawn, &[fn_ptr.into()], "").unwrap();
        None
    }
}
