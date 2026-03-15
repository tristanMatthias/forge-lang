use crate::codegen::codegen::Codegen;
use crate::feature::FeatureStmt;

impl<'ctx> Codegen<'ctx> {
    /// Compile a use statement via the Feature dispatch system.
    pub(crate) fn compile_imports_feature(&mut self, _fe: &FeatureStmt) {
        // Use statements are resolved by the driver before codegen
    }
}
