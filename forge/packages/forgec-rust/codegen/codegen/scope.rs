use super::*;
use inkwell::basic_block::BasicBlock;

impl<'ctx> Codegen<'ctx> {
    /// Get the current function being compiled.
    pub(crate) fn current_function(&self) -> inkwell::values::FunctionValue<'ctx> {
        self.builder.get_insert_block().unwrap().get_parent().unwrap()
    }

    pub(crate) fn push_scope(&mut self) {
        self.variables.push(HashMap::new());
        self.scope_vars.push(Vec::new());
    }

    pub(crate) fn pop_scope(&mut self) {
        self.variables.pop();
        self.scope_vars.pop();
    }

    /// Pop scope with Drop trait calls for variables declared in this scope
    pub(crate) fn pop_scope_with_drops(&mut self) {
        // Get variables from this scope in reverse declaration order
        let scope_vars = self.scope_vars.last().cloned().unwrap_or_default();
        // Call drop in reverse order
        for (var_name, var_type) in scope_vars.iter().rev() {
            if let Some(type_name) = self.get_type_name(var_type) {
                // Check if this type has a Drop impl
                if self.has_drop_impl(&type_name) {
                    let mangled = format!("{}_drop", type_name);
                    if let Some(func) = self.functions.get(&mangled).copied() {
                        if let Some((ptr, ty)) = self.lookup_var(var_name) {
                            let llvm_ty = self.type_to_llvm_basic(&ty);
                            let val = self.builder.build_load(llvm_ty, ptr, &format!("drop_{}", var_name)).unwrap();
                            self.builder.build_call(func, &[val.into()], "drop_call").unwrap();
                        }
                    }
                }
            }
        }
        self.variables.pop();
        self.scope_vars.pop();
    }

    /// Check if a type has a Drop impl
    pub(crate) fn has_drop_impl(&self, type_name: &str) -> bool {
        for impl_info in &self.impls {
            if impl_info.type_name == type_name {
                if let Some(ref tn) = impl_info.trait_name {
                    if tn == "Drop" {
                        return true;
                    }
                }
            }
        }
        false
    }

    pub(crate) fn define_var(&mut self, name: String, ptr: PointerValue<'ctx>, ty: Type) {
        if let Some(scope) = self.variables.last_mut() {
            scope.insert(name.clone(), (ptr, ty.clone()));
        }
        if let Some(scope_vars) = self.scope_vars.last_mut() {
            scope_vars.push((name, ty));
        }
    }

    pub(crate) fn lookup_var(&self, name: &str) -> Option<(PointerValue<'ctx>, Type)> {
        for scope in self.variables.iter().rev() {
            if let Some((ptr, ty)) = scope.get(name) {
                return Some((*ptr, ty.clone()));
            }
        }
        // Check imported globals
        if let Some((mangled_name, ty)) = self.imported_globals.get(name) {
            if let Some(global) = self.module.get_global(mangled_name) {
                return Some((global.as_pointer_value(), ty.clone()));
            }
        }
        // Check global mutables
        if let Some(ty) = self.global_mutables.get(name) {
            if let Some(global) = self.module.get_global(name) {
                return Some((global.as_pointer_value(), ty.clone()));
            }
        }
        None
    }

    /// Capture all variables from current scope into LLVM globals.
    /// Returns Vec of (local_name, global_name, type) for the spawn function to load.
    pub(crate) fn capture_scope_vars_to_globals(&mut self, prefix: &str) -> Vec<(String, String, Type)> {
        let mut captured = Vec::new();
        // Collect all variables from all scopes
        let all_vars: Vec<(String, PointerValue<'ctx>, Type)> = self.variables.iter()
            .flat_map(|scope| scope.iter().map(|(name, (ptr, ty))| (name.clone(), *ptr, ty.clone())))
            .collect();

        for (name, ptr, ty) in all_vars {
            let global_name = format!("{}_{}", prefix, name);
            let llvm_ty = self.type_to_llvm_basic(&ty);

            // Create global if it doesn't exist
            if self.module.get_global(&global_name).is_none() {
                let global = self.module.add_global(llvm_ty, None, &global_name);
                global.set_initializer(&llvm_ty.const_zero());
            }

            // Store current value to global
            let val = self.builder.build_load(llvm_ty, ptr, &format!("cap_{}", name)).unwrap();
            let global = self.module.get_global(&global_name).unwrap();
            self.builder.build_store(global.as_pointer_value(), val).unwrap();

            captured.push((name, global_name, ty));
        }
        captured
    }

    /// Call a runtime function by name, returning its result.
    /// Returns None if the function is not found or has no return value.
    pub(crate) fn call_runtime(
        &mut self,
        fn_name: &str,
        args: &[inkwell::values::BasicMetadataValueEnum<'ctx>],
        label: &str,
    ) -> Option<inkwell::values::BasicValueEnum<'ctx>> {
        let func = self.module.get_function(fn_name)?;
        self.builder.build_call(func, args, label)
            .ok()?
            .try_as_basic_value()
            .left()
    }

    /// Call a runtime function by name, expecting it to exist (panics if not found).
    /// Returns the result value if the function has one.
    pub(crate) fn call_runtime_expect(
        &mut self,
        fn_name: &str,
        args: &[inkwell::values::BasicMetadataValueEnum<'ctx>],
        label: &str,
        msg: &str,
    ) -> Option<inkwell::values::BasicValueEnum<'ctx>> {
        let func = self.module.get_function(fn_name)
            .unwrap_or_else(|| panic!("{}", msg));
        self.builder.build_call(func, args, label)
            .unwrap()
            .try_as_basic_value()
            .left()
    }

    /// Call a runtime function for its side effect (ignore return value).
    /// Silently does nothing if the function is not found.
    pub(crate) fn call_runtime_void(
        &mut self,
        fn_name: &str,
        args: &[inkwell::values::BasicMetadataValueEnum<'ctx>],
    ) {
        if let Some(func) = self.module.get_function(fn_name) {
            self.builder.build_call(func, args, "").unwrap();
        }
    }

    pub(crate) fn create_entry_block_alloca(
        &self,
        ty: &Type,
        name: &str,
    ) -> PointerValue<'ctx> {
        let llvm_ty = self.type_to_llvm_basic(ty);
        let function = self.current_function();
        let entry = function.get_first_basic_block().unwrap();

        let tmp_builder = self.context.create_builder();
        if let Some(first_instr) = entry.get_first_instruction() {
            tmp_builder.position_before(&first_instr);
        } else {
            tmp_builder.position_at_end(entry);
        }

        tmp_builder.build_alloca(llvm_ty, name).unwrap()
    }

    /// Wrap a raw C string pointer as a ForgeString by calling strlen + forge_string_new.
    /// This is the standard pattern for converting `ptr` → `{ptr, len}` ForgeString.
    pub(crate) fn wrap_ptr_as_string(
        &mut self,
        ptr_val: PointerValue<'ctx>,
    ) -> Option<BasicValueEnum<'ctx>> {
        let len = self.call_runtime("strlen", &[ptr_val.into()], "slen")?;
        self.call_runtime("forge_string_new", &[ptr_val.into(), len.into()], "fstr")
    }

    /// Extract (data_ptr, len) from a list struct value.
    /// Lists are represented as `{ptr, i64}` structs.
    pub(crate) fn extract_list_fields(
        &self,
        list_val: &BasicValueEnum<'ctx>,
    ) -> Option<(PointerValue<'ctx>, IntValue<'ctx>)> {
        let struct_val = list_val.into_struct_value();
        let data_ptr = self.builder.build_extract_value(struct_val, 0, "data_ptr").ok()?.into_pointer_value();
        let list_len = self.builder.build_extract_value(struct_val, 1, "len").ok()?.into_int_value();
        Some((data_ptr, list_len))
    }

    /// Build a list struct `{ptr, i64}` from a data pointer and length.
    pub(crate) fn build_list_struct(
        &self,
        elem_type: &Type,
        data_ptr: PointerValue<'ctx>,
        len: impl Into<BasicValueEnum<'ctx>>,
    ) -> inkwell::values::StructValue<'ctx> {
        let list_type = self.type_to_llvm_basic(&Type::List(Box::new(elem_type.clone())));
        let list_struct_type = list_type.into_struct_type();
        let mut result = list_struct_type.get_undef();
        result = self.builder.build_insert_value(result, data_ptr, 0, "list_data").unwrap().into_struct_value();
        result = self.builder.build_insert_value(result, len.into(), 1, "list_len").unwrap().into_struct_value();
        result
    }

    /// Create loop/body/end basic blocks, branch unconditionally to loop, and position at loop.
    /// Returns (loop_bb, body_bb, end_bb).
    pub(crate) fn setup_loop_blocks(
        &self,
        prefix: &str,
    ) -> (BasicBlock<'ctx>, BasicBlock<'ctx>, BasicBlock<'ctx>) {
        let function = self.current_function();
        let loop_bb = self.context.append_basic_block(function, &format!("{}_loop", prefix));
        let body_bb = self.context.append_basic_block(function, &format!("{}_body", prefix));
        let end_bb = self.context.append_basic_block(function, &format!("{}_end", prefix));
        self.builder.build_unconditional_branch(loop_bb).unwrap();
        self.builder.position_at_end(loop_bb);
        (loop_bb, body_bb, end_bb)
    }

    /// Load from an i64 alloca, add `delta`, store back.
    pub(crate) fn increment_i64(
        &self,
        alloca: PointerValue<'ctx>,
        delta: u64,
    ) -> IntValue<'ctx> {
        let current = self.builder.build_load(self.context.i64_type(), alloca, "cur").unwrap().into_int_value();
        let next = self.builder.build_int_add(current, self.context.i64_type().const_int(delta, false), "next").unwrap();
        self.builder.build_store(alloca, next).unwrap();
        next
    }

    /// Build a tagged struct value `{i8, payload}` for Result/Nullable types.
    /// `struct_type` is the LLVM struct type, `tag` is the tag byte, `payload` is the value.
    /// Uses alloca+GEP+bitcast to correctly handle different payload sizes.
    pub(crate) fn build_tagged_value(
        &self,
        struct_type: inkwell::types::StructType<'ctx>,
        tag: u8,
        payload: BasicValueEnum<'ctx>,
        label: &str,
    ) -> BasicValueEnum<'ctx> {
        let alloca = self.builder.build_alloca(struct_type, &format!("{}_tmp", label)).unwrap();

        // Store tag
        let tag_ptr = self.builder.build_struct_gep(struct_type, alloca, 0, "tag_ptr").unwrap();
        self.builder.build_store(tag_ptr, self.context.i8_type().const_int(tag as u64, false)).unwrap();

        // Store payload via bitcast to handle type size differences
        let payload_ptr = self.builder.build_struct_gep(struct_type, alloca, 1, "payload_ptr").unwrap();
        let val_ptr = self.builder.build_bit_cast(
            payload_ptr,
            self.context.ptr_type(inkwell::AddressSpace::default()),
            "val_ptr",
        ).unwrap();
        self.builder.build_store(val_ptr.into_pointer_value(), payload).unwrap();

        // Load the full struct back
        self.builder.build_load(struct_type, alloca, &format!("{}_loaded", label)).unwrap()
    }
}
