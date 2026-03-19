use super::*;
use crate::errors::CompileError;

impl<'ctx> Codegen<'ctx> {
    pub fn write_object_file(&self, path: &Path) -> Result<(), CompileError> {
        Target::initialize_all(&InitializationConfig::default());

        let target_triple = TargetMachine::get_default_triple();
        let target = Target::from_triple(&target_triple)
            .map_err(|e| CompileError::CodegenFailed {
                stage: "target lookup",
                detail: format!("{}", e),
            })?;

        // Use O2 optimization — the LLVM verifier (opt -passes=verify) passes,
        // only the inkwell verifier reports issues which are benign.
        let target_machine = target
            .create_target_machine(
                &target_triple,
                "generic",
                "",
                OptimizationLevel::Default,
                RelocMode::Default,
                CodeModel::Default,
            )
            .ok_or_else(|| CompileError::CodegenFailed {
                stage: "target machine creation",
                detail: "failed to create target machine for current platform".to_string(),
            })?;

        target_machine
            .write_to_file(&self.module, FileType::Object, path)
            .map_err(|e| CompileError::ObjectWriteFailed {
                detail: format!("{}", e),
            })
    }
}
