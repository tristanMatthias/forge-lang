use crate::parser::ast::UseItem;

/// AST data for a use/import statement.
#[derive(Debug, Clone)]
pub struct UseData {
    pub path: Vec<String>,
    pub items: Vec<UseItem>,
}

crate::impl_feature_node!(UseData);
