use crate::feature::FeatureExpr;
use crate::feature_data;
use crate::parser::ast::Expr;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

use super::types::IsData;

impl TypeChecker {
    /// Type-check an `is` expression via the Feature dispatch system.
    /// Returns Type::Bool since `is` always produces a boolean.
    pub(crate) fn check_is_feature(&mut self, fe: &FeatureExpr) -> Type {
        // Note: doesn't use feature_check! because it always returns Bool regardless
        if let Some(data) = feature_data!(fe, IsData) {
            self.check_expr(&data.value);
        }
        Type::Bool
    }

    /// Type-check an `is` expression. Always returns Bool.
    pub(crate) fn check_is_expr(&mut self, value: &Expr) -> Type {
        self.check_expr(value);
        Type::Bool
    }
}
