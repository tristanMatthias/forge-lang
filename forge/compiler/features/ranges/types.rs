use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::feature_data;
use crate::parser::ast::Expr;
use crate::typeck::types::Type;

/// AST data for a range expression: `start..end` or `start..=end`.
#[derive(Debug, Clone)]
pub struct RangeData {
    pub start: Box<Expr>,
    pub end: Box<Expr>,
    pub inclusive: bool,
}

crate::impl_feature_node!(RangeData);

impl<'ctx> Codegen<'ctx> {
    /// Infer the type of a range expression via the Feature dispatch system.
    pub(crate) fn infer_range_feature_type(&self, fe: &FeatureExpr) -> Type {
        if let Some(data) = feature_data!(fe, RangeData) {
            self.infer_range_type(&data.start)
        } else {
            Type::Unknown
        }
    }

    /// Infer the type of a range expression: Range<T> where T is the start type.
    pub(crate) fn infer_range_type(&self, start: &Expr) -> Type {
        Type::Range(Box::new(self.infer_type(start)))
    }
}
