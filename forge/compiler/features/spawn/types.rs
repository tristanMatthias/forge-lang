use crate::parser::ast::Block;

/// AST data for a `spawn { ... }` block expression.
#[derive(Debug, Clone)]
pub struct SpawnData {
    pub body: Block,
}

crate::impl_feature_node!(SpawnData);
