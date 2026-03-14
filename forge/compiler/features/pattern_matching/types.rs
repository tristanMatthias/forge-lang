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

impl crate::feature::FeatureNode for MatchData {
    fn as_any(&self) -> &dyn std::any::Any { self }
    fn clone_box(&self) -> Box<dyn crate::feature::FeatureNode> { Box::new(self.clone()) }
    fn substitute_exprs(&self, fns: &crate::feature::SubFns) -> Box<dyn crate::feature::FeatureNode> {
        Box::new(MatchData {
            subject: Box::new((fns.sub_expr)(&self.subject)),
            arms: self.arms.iter().map(|arm| MatchArm {
                pattern: arm.pattern.clone(),
                guard: arm.guard.as_ref().map(|g| (fns.sub_expr)(g)),
                body: (fns.sub_expr)(&arm.body),
                span: arm.span,
            }).collect(),
        })
    }
}

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
