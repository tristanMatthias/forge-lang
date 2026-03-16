use crate::parser::ast::{Block, Expr, Pattern};

/// AST data for a `for` loop statement.
#[derive(Debug, Clone)]
pub struct ForData {
    pub pattern: Pattern,
    pub iterable: Expr,
    pub body: Block,
}

crate::impl_feature_node!(ForData);
