use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::feature_check;
use crate::parser::ast::Expr;
use crate::typeck::types::Type;

/// AST data for a range expression: `start..end` or `start..=end`.
#[derive(Debug, Clone)]
pub struct RangeData {
    pub start: Box<Expr>,
    pub end: Box<Expr>,
    pub inclusive: bool,
}

impl crate::feature::FeatureNode for RangeData {
    fn as_any(&self) -> &dyn std::any::Any { self }
    fn clone_box(&self) -> Box<dyn crate::feature::FeatureNode> { Box::new(self.clone()) }
    fn substitute_exprs(&self, fns: &crate::feature::SubFns) -> Box<dyn crate::feature::FeatureNode> {
        Box::new(RangeData {
            start: Box::new((fns.sub_expr)(&self.start)),
            end: Box::new((fns.sub_expr)(&self.end)),
            inclusive: self.inclusive,
        })
    }
}

impl<'ctx> Codegen<'ctx> {
    /// Infer the type of a range expression via the Feature dispatch system.
    pub(crate) fn infer_range_feature_type(&self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, RangeData, |data| self.infer_range_type(&data.start))
    }

    /// Infer the type of a range expression: Range<T> where T is the start type.
    pub(crate) fn infer_range_type(&self, start: &Expr) -> Type {
        Type::Range(Box::new(self.infer_type(start)))
    }
}
