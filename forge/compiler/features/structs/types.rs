use crate::parser::ast::{Expr, TypeExpr, TypeParam};

/// AST data for a type declaration statement.
#[derive(Debug, Clone)]
pub struct TypeDeclData {
    pub name: String,
    pub type_params: Vec<TypeParam>,
    pub value: TypeExpr,
    pub exported: bool,
}

crate::impl_feature_node!(TypeDeclData);

/// AST data for a struct literal expression.
#[derive(Debug, Clone)]
pub struct StructLitData {
    pub name: Option<String>,
    pub fields: Vec<(String, Expr)>,
}

crate::impl_feature_node!(StructLitData);
