use crate::parser::ast::EnumVariant;

/// AST data for an enum declaration statement.
#[derive(Debug, Clone)]
pub struct EnumDeclData {
    pub name: String,
    pub variants: Vec<EnumVariant>,
    pub exported: bool,
}

crate::impl_feature_node!(EnumDeclData);
