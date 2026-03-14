use crate::parser::ast::{Block, Expr};

/// AST data for a `while` loop statement.
#[derive(Debug, Clone)]
pub struct WhileData {
    pub condition: Expr,
    pub body: Block,
}

crate::impl_feature_node!(WhileData);

/// AST data for an infinite `loop` statement.
#[derive(Debug, Clone)]
pub struct LoopData {
    pub body: Block,
    pub label: Option<String>,
}

crate::impl_feature_node!(LoopData);

/// AST data for a `break` statement.
#[derive(Debug, Clone)]
pub struct BreakData {
    pub value: Option<Expr>,
    pub label: Option<String>,
}

crate::impl_feature_node!(BreakData);

/// AST data for a `continue` statement.
#[derive(Debug, Clone)]
pub struct ContinueData {
    pub label: Option<String>,
}

crate::impl_feature_node!(ContinueData);
