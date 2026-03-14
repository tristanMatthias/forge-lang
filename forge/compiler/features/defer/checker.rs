use crate::feature::FeatureStmt;
use crate::feature_data;
use crate::typeck::checker::TypeChecker;

use super::types::DeferData;

impl TypeChecker {
    /// Type-check a `defer` statement by checking its body expression.
    pub(crate) fn check_defer_feature(&mut self, fe: &FeatureStmt) {
        if let Some(data) = feature_data!(fe, DeferData) {
            self.check_expr(&data.body);
        }
    }
}
