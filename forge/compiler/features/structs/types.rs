use crate::parser::ast::{Expr, TypeExpr, TypeParam};

/// AST data for a type declaration statement.
#[derive(Debug, Clone)]
pub struct TypeDeclData {
    pub name: String,
    pub type_params: Vec<TypeParam>,
    pub value: TypeExpr,
    pub exported: bool,
}

impl crate::feature::FeatureNode for TypeDeclData {
    fn as_any(&self) -> &dyn std::any::Any { self }
    fn clone_box(&self) -> Box<dyn crate::feature::FeatureNode> { Box::new(self.clone()) }
    fn substitute_exprs(&self, fns: &crate::feature::SubFns) -> Box<dyn crate::feature::FeatureNode> {
        Box::new(TypeDeclData {
            name: (fns.sub_ident)(&self.name),
            type_params: self.type_params.clone(),
            value: (fns.sub_type_expr)(&self.value),
            exported: self.exported,
        })
    }
}

/// AST data for a struct literal expression.
#[derive(Debug, Clone)]
pub struct StructLitData {
    pub name: Option<String>,
    pub fields: Vec<(String, Expr)>,
    pub span: crate::lexer::Span,
}

impl crate::feature::FeatureNode for StructLitData {
    fn as_any(&self) -> &dyn std::any::Any { self }
    fn clone_box(&self) -> Box<dyn crate::feature::FeatureNode> { Box::new(self.clone()) }
    fn substitute_exprs(&self, fns: &crate::feature::SubFns) -> Box<dyn crate::feature::FeatureNode> {
        Box::new(StructLitData {
            name: self.name.as_ref().map(|n| (fns.sub_ident)(n)),
            fields: self.fields.iter().map(|(k, v)| (k.clone(), (fns.sub_expr)(v))).collect(),
            span: self.span,
        })
    }
}
