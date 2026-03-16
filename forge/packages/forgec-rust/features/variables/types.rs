use crate::parser::ast::{Expr, Pattern, TypeExpr};
use crate::lexer::Span;

/// Variable declaration kind
#[derive(Debug, Clone)]
pub enum VarKind {
    Let,
    Mut,
    Const,
}

/// AST data for a variable declaration (let/mut/const).
#[derive(Debug, Clone)]
pub struct VarDeclData {
    pub kind: VarKind,
    pub name: String,
    pub type_ann: Option<TypeExpr>,
    pub type_ann_span: Option<Span>,
    pub value: Expr,
    pub exported: bool,
}

impl crate::feature::FeatureNode for VarDeclData {
    fn as_any(&self) -> &dyn std::any::Any { self }
    fn clone_box(&self) -> Box<dyn crate::feature::FeatureNode> { Box::new(self.clone()) }
    fn substitute_exprs(&self, fns: &crate::feature::SubFns) -> Box<dyn crate::feature::FeatureNode> {
        Box::new(VarDeclData {
            kind: self.kind.clone(),
            name: (fns.sub_ident)(&self.name),
            type_ann: self.type_ann.as_ref().map(|t| (fns.sub_type_expr)(t)),
            type_ann_span: self.type_ann_span,
            value: (fns.sub_expr)(&self.value),
            exported: self.exported,
        })
    }
}

/// AST data for a let-destructure statement.
#[derive(Debug, Clone)]
pub struct LetDestructureData {
    pub pattern: Pattern,
    pub value: Expr,
}

impl crate::feature::FeatureNode for LetDestructureData {
    fn as_any(&self) -> &dyn std::any::Any { self }
    fn clone_box(&self) -> Box<dyn crate::feature::FeatureNode> { Box::new(self.clone()) }
    fn substitute_exprs(&self, fns: &crate::feature::SubFns) -> Box<dyn crate::feature::FeatureNode> {
        Box::new(LetDestructureData {
            pattern: self.pattern.clone(),
            value: (fns.sub_expr)(&self.value),
        })
    }
}
