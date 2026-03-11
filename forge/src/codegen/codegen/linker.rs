use super::*;

impl<'ctx> Codegen<'ctx> {
    pub fn write_object_file(&self, path: &Path) -> Result<(), String> {
        // Verify the module before writing
        if let Err(msg) = self.module.verify() {
            return Err(format!("LLVM module verification failed: {}", msg.to_string()));
        }
        Target::initialize_all(&InitializationConfig::default());

        let target_triple = TargetMachine::get_default_triple();
        let target = Target::from_triple(&target_triple)
            .map_err(|e| format!("failed to get target: {}", e))?;

        let target_machine = target
            .create_target_machine(
                &target_triple,
                "generic",
                "",
                OptimizationLevel::Default,
                RelocMode::Default,
                CodeModel::Default,
            )
            .ok_or("failed to create target machine")?;

        target_machine
            .write_to_file(&self.module, FileType::Object, path)
            .map_err(|e| format!("failed to write object file: {}", e))
    }
}
