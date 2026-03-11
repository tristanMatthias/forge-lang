use super::*;

impl<'ctx> Codegen<'ctx> {
    pub(crate) fn compile_error_propagate(
        &mut self,
        operand: &Expr,
    ) -> Option<BasicValueEnum<'ctx>> {
        let val = self.compile_expr(operand)?;

        // Result is {i8, i64[, i64]}. Tag 0 = Ok, 1 = Err
        if val.is_struct_value() {
            let struct_val = val.into_struct_value();
            let tag = self.builder.build_extract_value(struct_val, 0, "result_tag").ok()?;
            let is_err = self.builder.build_int_compare(
                IntPredicate::NE,
                tag.into_int_value(),
                self.context.i8_type().const_zero(),
                "is_err",
            ).unwrap();

            let function = self.builder.get_insert_block().unwrap().get_parent().unwrap();
            let ok_bb = self.context.append_basic_block(function, "result_ok");
            let err_bb = self.context.append_basic_block(function, "result_err");

            self.builder.build_conditional_branch(is_err, err_bb, ok_bb).unwrap();

            // Error path: early return the whole Result value
            self.builder.position_at_end(err_bb);
            self.builder.build_return(Some(&val)).unwrap();

            // Ok path: extract value through memory reinterpret
            self.builder.position_at_end(ok_bb);
            let operand_type = self.infer_type(operand);
            let ok_type = match &operand_type {
                Type::Result(ok, _) => self.type_to_llvm_basic(ok),
                _ => return Some(self.builder.build_extract_value(struct_val, 1, "ok_val").ok()?.into()),
            };

            // Store the result struct, then load the payload as the ok type
            let result_alloca = self.builder.build_alloca(struct_val.get_type(), "result_tmp").unwrap();
            self.builder.build_store(result_alloca, struct_val).unwrap();
            let result_llvm_ty = struct_val.get_type();
            let payload_ptr = self.builder.build_struct_gep(result_llvm_ty, result_alloca, 1, "payload_ptr").unwrap();
            let val_ptr = self.builder.build_bit_cast(payload_ptr, self.context.ptr_type(AddressSpace::default()), "val_ptr").unwrap();
            let ok_val = self.builder.build_load(ok_type, val_ptr.into_pointer_value(), "ok_val").unwrap();
            return Some(ok_val);
        }

        Some(val)
    }

    pub(crate) fn compile_result_ok(&mut self, value: &Expr) -> Option<BasicValueEnum<'ctx>> {
        let val = self.compile_expr(value)?;

        // Get the canonical Result type from the current function's return type
        let result_llvm_ty = if let Some(ref ret_ty) = self.current_fn_return_type {
            match ret_ty {
                Type::Result(_, _) => self.type_to_llvm_basic(ret_ty).into_struct_type(),
                _ => {
                    // Infer from value: Result<typeof(val), String>
                    let inferred = Type::Result(Box::new(self.infer_type(value)), Box::new(Type::String));
                    self.type_to_llvm_basic(&inferred).into_struct_type()
                }
            }
        } else {
            let inferred = Type::Result(Box::new(self.infer_type(value)), Box::new(Type::String));
            self.type_to_llvm_basic(&inferred).into_struct_type()
        };

        // Alloca the canonical Result type, store tag and payload via memory
        let alloca = self.builder.build_alloca(result_llvm_ty, "ok_result").unwrap();

        // Store tag = 0 (Ok)
        let tag_ptr = self.builder.build_struct_gep(result_llvm_ty, alloca, 0, "tag_ptr").unwrap();
        self.builder.build_store(tag_ptr, self.context.i8_type().const_zero()).unwrap();

        // Store payload: cast the payload pointer to the value's type and store
        let payload_ptr = self.builder.build_struct_gep(result_llvm_ty, alloca, 1, "payload_ptr").unwrap();
        let val_ptr = self.builder.build_bit_cast(payload_ptr, self.context.ptr_type(AddressSpace::default()), "val_ptr").unwrap();
        self.builder.build_store(val_ptr.into_pointer_value(), val).unwrap();

        // Load the canonical struct back
        let result = self.builder.build_load(result_llvm_ty, alloca, "ok_loaded").unwrap();
        Some(result)
    }

    pub(crate) fn compile_result_err(&mut self, value: &Expr) -> Option<BasicValueEnum<'ctx>> {
        let val = self.compile_expr(value)?;

        // Get the canonical Result type from the current function's return type
        let result_llvm_ty = if let Some(ref ret_ty) = self.current_fn_return_type {
            match ret_ty {
                Type::Result(_, _) => self.type_to_llvm_basic(ret_ty).into_struct_type(),
                _ => {
                    let inferred = Type::Result(Box::new(Type::Unknown), Box::new(self.infer_type(value)));
                    self.type_to_llvm_basic(&inferred).into_struct_type()
                }
            }
        } else {
            let inferred = Type::Result(Box::new(Type::Unknown), Box::new(self.infer_type(value)));
            self.type_to_llvm_basic(&inferred).into_struct_type()
        };

        // Alloca the canonical Result type, store tag and payload via memory
        let alloca = self.builder.build_alloca(result_llvm_ty, "err_result").unwrap();

        // Store tag = 1 (Err)
        let tag_ptr = self.builder.build_struct_gep(result_llvm_ty, alloca, 0, "tag_ptr").unwrap();
        self.builder.build_store(tag_ptr, self.context.i8_type().const_int(1, false)).unwrap();

        // Store payload: cast the payload pointer to the value's type and store
        let payload_ptr = self.builder.build_struct_gep(result_llvm_ty, alloca, 1, "payload_ptr").unwrap();
        let val_ptr = self.builder.build_bit_cast(payload_ptr, self.context.ptr_type(AddressSpace::default()), "val_ptr").unwrap();
        self.builder.build_store(val_ptr.into_pointer_value(), val).unwrap();

        // Load the canonical struct back
        let result = self.builder.build_load(result_llvm_ty, alloca, "err_loaded").unwrap();
        Some(result)
    }

    pub(crate) fn compile_catch(
        &mut self,
        expr: &Expr,
        binding: Option<&str>,
        handler: &Block,
    ) -> Option<BasicValueEnum<'ctx>> {
        // Infer the Result type to know ok/err types
        let expr_type = self.infer_type(expr);
        let (ok_type, err_type) = match &expr_type {
            Type::Result(ok, err) => (self.type_to_llvm_basic(ok), self.type_to_llvm_basic(err)),
            _ => {
                // Not a Result type, just compile and return
                return self.compile_expr(expr);
            }
        };

        let val = self.compile_expr(expr)?;

        if val.is_struct_value() {
            let struct_val = val.into_struct_value();
            let tag = self.builder.build_extract_value(struct_val, 0, "result_tag").ok()?;
            let is_err = self.builder.build_int_compare(
                IntPredicate::NE,
                tag.into_int_value(),
                self.context.i8_type().const_zero(),
                "is_err",
            ).unwrap();

            let function = self.builder.get_insert_block().unwrap().get_parent().unwrap();

            // Store the result struct to memory BEFORE branching, so both paths can access it
            let result_alloca = self.builder.build_alloca(struct_val.get_type(), "catch_result_tmp").unwrap();
            self.builder.build_store(result_alloca, struct_val).unwrap();

            let ok_bb = self.context.append_basic_block(function, "catch_ok");
            let err_bb = self.context.append_basic_block(function, "catch_err");
            let merge_bb = self.context.append_basic_block(function, "catch_merge");

            self.builder.build_conditional_branch(is_err, err_bb, ok_bb).unwrap();

            // Ok path: extract ok value through memory reinterpret
            self.builder.position_at_end(ok_bb);
            let payload_ptr = self.builder.build_struct_gep(struct_val.get_type(), result_alloca, 1, "ok_payload_ptr").unwrap();
            let val_ptr = self.builder.build_bit_cast(payload_ptr, self.context.ptr_type(AddressSpace::default()), "ok_val_ptr").unwrap();
            let ok_val = self.builder.build_load(ok_type, val_ptr.into_pointer_value(), "ok_val").unwrap();
            let ok_end = self.builder.get_insert_block().unwrap();
            self.builder.build_unconditional_branch(merge_bb).unwrap();

            // Error path: extract err value through memory reinterpret, run handler
            self.builder.position_at_end(err_bb);
            self.push_scope();
            if let Some(name) = binding {
                let err_payload_ptr = self.builder.build_struct_gep(struct_val.get_type(), result_alloca, 1, "err_payload_ptr").unwrap();
                let err_val_ptr = self.builder.build_bit_cast(err_payload_ptr, self.context.ptr_type(AddressSpace::default()), "err_val_ptr").unwrap();
                let err_val = self.builder.build_load(err_type, err_val_ptr.into_pointer_value(), "err_val").unwrap();
                let ty = Type::String;
                let alloca = self.create_entry_block_alloca(&ty, name);
                self.builder.build_store(alloca, err_val).unwrap();
                self.define_var(name.to_string(), alloca, ty);
            }
            let mut handler_val = None;
            for stmt in &handler.statements {
                match stmt {
                    Statement::Expr(e) => handler_val = self.compile_expr(e),
                    _ => {
                        self.compile_statement(stmt);
                        handler_val = None;
                    }
                }
            }
            self.pop_scope();
            let err_end = self.builder.get_insert_block().unwrap();
            self.builder.build_unconditional_branch(merge_bb).unwrap();

            self.builder.position_at_end(merge_bb);

            // Phi result
            if let Some(hv) = handler_val {
                let ok_coerced = self.coerce_value(ok_val, hv.get_type());
                let phi = self.builder.build_phi(hv.get_type(), "catch_result").unwrap();
                phi.add_incoming(&[(&ok_coerced, ok_end), (&hv, err_end)]);
                return Some(phi.as_basic_value());
            }

            return Some(ok_val);
        }

        Some(val)
    }
}
