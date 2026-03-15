// Trait-related type resolution.
//
// Trait type checking is currently minimal -- trait declarations and impl blocks
// are registered during compilation but no deep type-level resolution is
// performed beyond what the codegen handles (resolve_named_type, type_to_type_expr, etc.).
//
// Future work: trait bound checking, associated type resolution in the type checker.

use crate::parser::ast::{Statement, TraitMethod, TypeExpr, TypeParam};

/// AST data for a trait declaration statement.
#[derive(Debug, Clone)]
pub struct TraitDeclData {
    pub name: String,
    pub type_params: Vec<TypeParam>,
    pub super_traits: Vec<String>,
    pub methods: Vec<TraitMethod>,
    pub exported: bool,
}

crate::impl_feature_node!(TraitDeclData);

/// AST data for an impl block statement.
#[derive(Debug, Clone)]
pub struct ImplBlockData {
    pub trait_name: Option<String>,
    pub type_name: String,
    pub type_params: Vec<TypeParam>,
    pub associated_types: Vec<(String, TypeExpr)>,
    pub methods: Vec<Statement>,
}

crate::impl_feature_node!(ImplBlockData);
