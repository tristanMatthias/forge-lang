use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::parser::ast::*;
use crate::typeck::types::Type;

/// AST data for a dollar-exec expression: `$"cmd"` or `$\`cmd ${arg}\``
#[derive(Debug, Clone)]
pub struct DollarExecData {
    pub parts: Vec<TemplatePart>,
}

crate::impl_feature_node!(DollarExecData);

impl<'ctx> Codegen<'ctx> {
    /// Infer the type of a dollar-exec expression.
    /// Always returns `Type::String` since it captures stdout output.
    pub(crate) fn infer_dollar_exec_type(&self) -> Type {
        Type::String
    }

    /// Infer type via Feature dispatch.
    pub(crate) fn infer_dollar_exec_feature_type(&self, _fe: &FeatureExpr) -> Type {
        Type::String
    }
}
