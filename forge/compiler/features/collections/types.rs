use crate::parser::ast::Expr;

/// AST data for a list literal expression.
#[derive(Debug, Clone)]
pub struct ListLitData {
    pub elements: Vec<Expr>,
}

crate::impl_feature_node!(ListLitData);

/// AST data for a map literal expression.
#[derive(Debug, Clone)]
pub struct MapLitData {
    pub entries: Vec<(Expr, Expr)>,
}

crate::impl_feature_node!(MapLitData);
