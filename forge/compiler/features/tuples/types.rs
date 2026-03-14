use crate::parser::ast::Expr;

/// AST data for a tuple literal expression.
#[derive(Debug, Clone)]
pub struct TupleLitData {
    pub elements: Vec<Expr>,
}

impl crate::feature::FeatureNode for TupleLitData {
    fn as_any(&self) -> &dyn std::any::Any { self }
    fn clone_box(&self) -> Box<dyn crate::feature::FeatureNode> { Box::new(self.clone()) }
    fn substitute_exprs(&self, fns: &crate::feature::SubFns) -> Box<dyn crate::feature::FeatureNode> {
        Box::new(TupleLitData {
            elements: self.elements.iter().map(|e| (fns.sub_expr)(e)).collect(),
        })
    }
}
