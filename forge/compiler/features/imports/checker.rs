use crate::feature::FeatureStmt;
use crate::typeck::checker::TypeChecker;

impl TypeChecker {
    /// Type-check a use statement via the Feature dispatch system.
    pub(crate) fn check_imports_feature(&mut self, _fe: &FeatureStmt) {
        // Use statements are handled by the driver, not the type checker
    }
}
