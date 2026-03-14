use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::feature_data;
use crate::parser::ast::Expr;
use crate::typeck::types::Type;

/// AST data for a `with` expression: `expr with { field: value, ... }`.
#[derive(Debug, Clone)]
pub struct WithData {
    pub base: Box<Expr>,
    pub updates: Vec<(String, Expr)>,
}

crate::impl_feature_node!(WithData);

impl<'ctx> Codegen<'ctx> {
    /// Infer the type of a `with` expression via the Feature dispatch system.
    pub(crate) fn infer_with_feature_type(&self, fe: &FeatureExpr) -> Type {
        if let Some(data) = feature_data!(fe, WithData) {
            self.infer_with_type(&data.base)
        } else {
            Type::Unknown
        }
    }

    /// Infer the type of a `with` expression — returns the same type as the base.
    pub(crate) fn infer_with_type(&self, base: &Expr) -> Type {
        self.infer_type(base)
    }
}
