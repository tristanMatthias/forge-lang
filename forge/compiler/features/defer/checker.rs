use crate::feature::FeatureStmt;
use crate::feature_stmt;
use crate::parser::ast::Expr;
use crate::typeck::checker::TypeChecker;

use super::types::DeferData;

impl TypeChecker {
    /// Type-check a `defer` statement by checking its body expression.
    pub(crate) fn check_defer_feature(&mut self, fe: &FeatureStmt) {
        feature_stmt!(self, fe, DeferData, |data| self.check_expr(&data.body));
    }

    /// Type-check a defer statement's body expression.
    pub(crate) fn check_defer_stmt(&mut self, body: &Expr) {
        self.check_expr(body);
    }
}
