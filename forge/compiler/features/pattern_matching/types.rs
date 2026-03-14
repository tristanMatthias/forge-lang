use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::feature_check;
use crate::parser::ast::{Expr, MatchArm};
use crate::typeck::types::Type;

/// AST data for a match expression: `match subject { arms }`.
#[derive(Debug, Clone)]
pub struct MatchData {
    pub subject: Box<Expr>,
    pub arms: Vec<MatchArm>,
}

crate::impl_feature_node!(MatchData);

impl<'ctx> Codegen<'ctx> {
    /// Infer the return type of a match expression via the Feature dispatch system.
    pub(crate) fn infer_match_feature_type(&self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, MatchData, |data| self.infer_match_type(&data.arms))
    }

    /// Infer the type of a match expression from its first arm.
    pub(crate) fn infer_match_type(&self, arms: &[MatchArm]) -> Type {
        if let Some(first) = arms.first() {
            self.infer_type(&first.body)
        } else {
            Type::Unknown
        }
    }
}
