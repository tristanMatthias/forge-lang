use crate::parser::ast::Expr;

/// AST data for a slice expression: `object[start..end]`, `object[start..]`, or `object[..end]`.
#[derive(Debug, Clone)]
pub struct SliceData {
    pub object: Box<Expr>,
    pub start: Option<Box<Expr>>,
    pub end: Option<Box<Expr>>,
}

impl crate::feature::FeatureNode for SliceData {
    fn as_any(&self) -> &dyn std::any::Any { self }
    fn clone_box(&self) -> Box<dyn crate::feature::FeatureNode> { Box::new(self.clone()) }
    fn substitute_exprs(&self, fns: &crate::feature::SubFns) -> Box<dyn crate::feature::FeatureNode> {
        Box::new(SliceData {
            object: Box::new((fns.sub_expr)(&self.object)),
            start: self.start.as_ref().map(|e| Box::new((fns.sub_expr)(e))),
            end: self.end.as_ref().map(|e| Box::new((fns.sub_expr)(e))),
        })
    }
}
