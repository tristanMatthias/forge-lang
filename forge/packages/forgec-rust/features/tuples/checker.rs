use crate::feature::FeatureExpr;
use crate::feature_check;
use crate::parser::ast::Expr;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

use super::types::TupleLitData;

impl TypeChecker {
    /// Type-check a tuple literal expression via the Feature dispatch system.
    pub(crate) fn check_tuple_lit_feature(&mut self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, TupleLitData, |data| self.check_tuple_lit(&data.elements))
    }

    /// Type-check a tuple literal.
    pub(crate) fn check_tuple_lit(&mut self, elements: &[Expr]) -> Type {
        let types: Vec<Type> = elements.iter().map(|e| self.check_expr(e)).collect();
        Type::Tuple(types)
    }
}
