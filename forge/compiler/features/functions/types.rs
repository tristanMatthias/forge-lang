use crate::parser::ast::{Block, Expr, Param, TypeExpr, TypeParam};

/// AST data for a function declaration statement.
#[derive(Debug, Clone)]
pub struct FnDeclData {
    pub name: String,
    pub type_params: Vec<TypeParam>,
    pub params: Vec<Param>,
    pub return_type: Option<TypeExpr>,
    pub body: Block,
    pub exported: bool,
}

crate::impl_feature_node!(FnDeclData);

/// AST data for a return statement.
#[derive(Debug, Clone)]
pub struct ReturnData {
    pub value: Option<Expr>,
}

crate::impl_feature_node!(ReturnData);
