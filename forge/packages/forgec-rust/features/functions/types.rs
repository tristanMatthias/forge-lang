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

impl crate::feature::FeatureNode for FnDeclData {
    fn as_any(&self) -> &dyn std::any::Any { self }
    fn clone_box(&self) -> Box<dyn crate::feature::FeatureNode> { Box::new(self.clone()) }
    fn substitute_exprs(&self, fns: &crate::feature::SubFns) -> Box<dyn crate::feature::FeatureNode> {
        Box::new(FnDeclData {
            name: (fns.sub_ident)(&self.name),
            type_params: self.type_params.clone(),
            params: self.params.iter().map(|p| (fns.sub_param)(p)).collect(),
            return_type: self.return_type.as_ref().map(|t| (fns.sub_type_expr)(t)),
            body: (fns.sub_block)(&self.body),
            exported: self.exported,
        })
    }
}

/// AST data for a return statement.
#[derive(Debug, Clone)]
pub struct ReturnData {
    pub value: Option<Expr>,
}

impl crate::feature::FeatureNode for ReturnData {
    fn as_any(&self) -> &dyn std::any::Any { self }
    fn clone_box(&self) -> Box<dyn crate::feature::FeatureNode> { Box::new(self.clone()) }
    fn substitute_exprs(&self, fns: &crate::feature::SubFns) -> Box<dyn crate::feature::FeatureNode> {
        Box::new(ReturnData {
            value: self.value.as_ref().map(|v| (fns.sub_expr)(v)),
        })
    }
}
