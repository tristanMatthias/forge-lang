use inkwell::types::BasicMetadataTypeEnum;
use inkwell::values::BasicValueEnum;
use crate::codegen::codegen::Codegen;
use crate::parser::ast::*;
use crate::typeck::types::Type;

impl<'ctx> Codegen<'ctx> {
    /// Compile a closure expression into an anonymous function, returning a function pointer.
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
