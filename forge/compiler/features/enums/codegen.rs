use crate::codegen::codegen::Codegen;
use crate::feature::FeatureStmt;

impl<'ctx> Codegen<'ctx> {
    /// Compile an enum declaration via the Feature dispatch system.
    /// Enum declarations are handled at type-check time; no codegen needed.
    pub(crate) fn compile_enum_feature(&mut self, _fe: &FeatureStmt) {
        // Type declarations handled at type-check time
    }
}
