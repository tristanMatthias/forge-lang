use crate::feature::FeatureExpr;
use crate::feature_data;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

use super::types::IsData;

impl TypeChecker {
    /// Type-check an `is` expression via the Feature dispatch system.
    /// Returns Type::Bool since `is` always produces a boolean.
    pub(crate) fn check_is_feature(&mut self, fe: &FeatureExpr) -> Type {
        if let Some(data) = feature_data!(fe, IsData) {
            self.check_expr(&data.value);
        }
        Type::Bool
    }
}
