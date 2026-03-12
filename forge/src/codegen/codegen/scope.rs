use super::*;

impl<'ctx> Codegen<'ctx> {
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

    pub(crate) fn create_entry_block_alloca(
        &self,
        ty: &Type,
        name: &str,
    ) -> PointerValue<'ctx> {
        let llvm_ty = self.type_to_llvm_basic(ty);
        let current_block = self.builder.get_insert_block().unwrap();
        let function = current_block.get_parent().unwrap();
        let entry = function.get_first_basic_block().unwrap();

        let tmp_builder = self.context.create_builder();
        if let Some(first_instr) = entry.get_first_instruction() {
            tmp_builder.position_before(&first_instr);
        } else {
            tmp_builder.position_at_end(entry);
        }

        tmp_builder.build_alloca(llvm_ty, name).unwrap()
    }
}
