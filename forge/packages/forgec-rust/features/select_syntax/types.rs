use crate::parser::ast::SelectArm;

/// AST data for a `select { ... }` statement.
#[derive(Debug, Clone)]
pub struct SelectData {
    pub arms: Vec<SelectArm>,
}

crate::impl_feature_node!(SelectData);
