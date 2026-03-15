use crate::feature::FeatureExpr;
use crate::feature_check;
use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

use super::types::RangeData;

impl TypeChecker {
    /// Type-check a range expression via the Feature dispatch system.
    pub(crate) fn check_range_feature(&mut self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, RangeData, |data| self.check_range(&data.start))
    }

    /// Type-check a range expression. The range type is Range<T> where T is the start type.
    pub(crate) fn check_range(&mut self, start: &Expr) -> Type {
        let start_type = self.check_expr(start);
        Type::Range(Box::new(start_type))
    }
}
