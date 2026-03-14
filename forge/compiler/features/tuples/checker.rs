use crate::feature::FeatureExpr;
use crate::feature_check;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

use super::types::TupleLitData;

impl TypeChecker {
    /// Type-check a tuple literal expression via the Feature dispatch system.
    pub(crate) fn check_tuple_lit_feature(&mut self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, TupleLitData, |data| {
            let types: Vec<Type> = data.elements.iter().map(|e| self.check_expr(e)).collect();
            Type::Tuple(types)
        })
    }
}
