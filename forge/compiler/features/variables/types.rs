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

crate::impl_feature_node!(VarDeclData);

/// AST data for a let-destructure statement.
#[derive(Debug, Clone)]
pub struct LetDestructureData {
    pub pattern: Pattern,
    pub value: Expr,
}

crate::impl_feature_node!(LetDestructureData);
