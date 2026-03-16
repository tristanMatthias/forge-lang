use crate::parser::ast::{Expr, Pattern};

/// AST data for an `is` expression: `value is Pattern` or `value is not Pattern`.
#[derive(Debug, Clone)]
pub struct IsData {
    pub value: Box<Expr>,
    pub pattern: Pattern,
    pub negated: bool,
}

impl crate::feature::FeatureNode for IsData {
    fn as_any(&self) -> &dyn std::any::Any { self }
    fn clone_box(&self) -> Box<dyn crate::feature::FeatureNode> { Box::new(self.clone()) }
    fn substitute_exprs(&self, fns: &crate::feature::SubFns) -> Box<dyn crate::feature::FeatureNode> {
        Box::new(IsData {
            value: Box::new((fns.sub_expr)(&self.value)),
            pattern: self.pattern.clone(),
            negated: self.negated,
        })
    }
}
