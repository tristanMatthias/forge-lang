use crate::parser::ast::Block;

/// AST data for a `spawn { ... }` block expression.
#[derive(Debug, Clone)]
pub struct SpawnData {
    pub body: Block,
}

impl crate::feature::FeatureNode for SpawnData {
    fn as_any(&self) -> &dyn std::any::Any { self }
    fn clone_box(&self) -> Box<dyn crate::feature::FeatureNode> { Box::new(self.clone()) }
    fn substitute_exprs(&self, fns: &crate::feature::SubFns) -> Box<dyn crate::feature::FeatureNode> {
        Box::new(SpawnData {
            body: (fns.sub_block)(&self.body),
        })
    }
}
