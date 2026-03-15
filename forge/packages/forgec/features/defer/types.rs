use crate::parser::ast::Expr;

/// AST data for a `defer` statement.
/// The deferred expression is executed in reverse order before function return.
#[derive(Debug, Clone)]
pub struct DeferData {
    pub body: Expr,
}

crate::impl_feature_node!(DeferData);
