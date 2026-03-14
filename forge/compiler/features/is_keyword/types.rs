use crate::parser::ast::{Expr, Pattern};

/// AST data for an `is` expression: `value is Pattern` or `value is not Pattern`.
#[derive(Debug, Clone)]
pub struct IsData {
    pub value: Box<Expr>,
    pub pattern: Pattern,
    pub negated: bool,
}

crate::impl_feature_node!(IsData);
