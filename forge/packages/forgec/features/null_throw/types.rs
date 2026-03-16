use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::feature_check;
use crate::parser::ast::*;
use crate::typeck::types::Type;

/// AST data for null throw: `expr ?? throw .error`
#[derive(Debug, Clone)]
pub struct NullThrowData {
    pub value: Box<Expr>,
    pub error: Box<Expr>,
}

impl crate::feature::FeatureNode for NullThrowData {
    fn as_any(&self) -> &dyn std::any::Any { self }
    fn clone_box(&self) -> Box<dyn crate::feature::FeatureNode> { Box::new(self.clone()) }
    fn substitute_exprs(&self, fns: &crate::feature::SubFns) -> Box<dyn crate::feature::FeatureNode> {
        Box::new(NullThrowData {
            value: Box::new((fns.sub_expr)(&self.value)),
            error: Box::new((fns.sub_expr)(&self.error)),
        })
    }
}

impl<'ctx> Codegen<'ctx> {
    /// Infer the type of a null throw expression via Feature dispatch.
    /// If value is Nullable(T), result is T (unwrapped).
    pub(crate) fn infer_null_throw_feature_type(&self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, NullThrowData, |data| {
            let val_type = self.infer_type(&data.value);
            match val_type {
                Type::Nullable(inner) => *inner,
                other => other,
            }
        })
    }
}
