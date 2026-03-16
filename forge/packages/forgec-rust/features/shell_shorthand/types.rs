use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::parser::ast::*;
use crate::typeck::types::Type;

/// AST data for a dollar-exec expression: `$"cmd"` or `$\`cmd ${arg}\``
#[derive(Debug, Clone)]
pub struct DollarExecData {
    pub parts: Vec<TemplatePart>,
}

impl crate::feature::FeatureNode for DollarExecData {
    fn as_any(&self) -> &dyn std::any::Any { self }
    fn clone_box(&self) -> Box<dyn crate::feature::FeatureNode> { Box::new(self.clone()) }
    fn substitute_exprs(&self, fns: &crate::feature::SubFns) -> Box<dyn crate::feature::FeatureNode> {
        Box::new(DollarExecData {
            parts: self.parts.iter().map(|p| match p {
                TemplatePart::Literal(s) => TemplatePart::Literal((fns.sub_ident)(s)),
                TemplatePart::Expr(e) => TemplatePart::Expr(Box::new((fns.sub_expr)(e))),
            }).collect(),
        })
    }
}

impl<'ctx> Codegen<'ctx> {
    /// Infer type via Feature dispatch.
    pub(crate) fn infer_dollar_exec_feature_type(&self, _fe: &FeatureExpr) -> Type {
        Type::String
    }
}
