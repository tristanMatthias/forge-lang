use crate::feature::FeatureExpr;
use crate::feature_check;
use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

use super::types::WithData;

impl TypeChecker {
    /// Type-check a `with` expression via the Feature dispatch system.
    pub(crate) fn check_with_feature(&mut self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, WithData, |data| self.check_with(&data.base, &data.updates))
    }

    /// Type-check a `with` expression: `expr with { field: value }`.
    /// Returns the base type since `with` creates a copy with updated fields.
    pub(crate) fn check_with(&mut self, base: &Expr, updates: &[(String, Expr)]) -> Type {
        let base_type = self.check_expr(base);
        for (_, val) in updates {
            self.check_expr(val);
        }
        base_type
    }
}
