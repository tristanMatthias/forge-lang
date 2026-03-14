use crate::parser::ast::Expr;

/// AST data for a tuple literal expression.
#[derive(Debug, Clone)]
pub struct TupleLitData {
    pub elements: Vec<Expr>,
}

crate::impl_feature_node!(TupleLitData);
