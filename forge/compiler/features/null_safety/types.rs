use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::feature_data;
use crate::parser::ast::*;
use crate::typeck::types::Type;

/// AST data for null coalesce: `left ?? right`
#[derive(Debug, Clone)]
pub struct NullCoalesceData {
    pub left: Box<Expr>,
    pub right: Box<Expr>,
}

crate::impl_feature_node!(NullCoalesceData);

/// AST data for null propagate: `object?.field`
#[derive(Debug, Clone)]
pub struct NullPropagateData {
    pub object: Box<Expr>,
    pub field: String,
}

crate::impl_feature_node!(NullPropagateData);

/// AST data for force unwrap: `expr!`
#[derive(Debug, Clone)]
pub struct ForceUnwrapData {
    pub operand: Box<Expr>,
}

crate::impl_feature_node!(ForceUnwrapData);

impl<'ctx> Codegen<'ctx> {
    /// Infer the type of `NullLit` — returns `Nullable(Unknown)`.
    pub(crate) fn infer_null_lit_type(&self) -> Type {
        Type::Nullable(Box::new(Type::Unknown))
    }

    /// Infer the type of a null coalesce expression via Feature dispatch.
    pub(crate) fn infer_null_coalesce_feature_type(&self, fe: &FeatureExpr) -> Type {
        if let Some(data) = feature_data!(fe, NullCoalesceData) {
            self.infer_type(&data.right)
        } else {
            Type::Unknown
        }
    }

    /// Infer the type of a null coalesce expression: `left ?? right`
    pub(crate) fn infer_null_coalesce_type(&self, right: &Expr) -> Type {
        self.infer_type(right)
    }

    /// Infer the type of a null propagate expression via Feature dispatch.
    pub(crate) fn infer_null_propagate_feature_type(&self, fe: &FeatureExpr) -> Type {
        if let Some(data) = feature_data!(fe, NullPropagateData) {
            self.infer_null_propagate_type_inner(&data.object, &data.field)
        } else {
            Type::Unknown
        }
    }

    /// Infer the type of a force unwrap expression: `expr!`
    pub(crate) fn infer_force_unwrap_feature_type(&self, fe: &FeatureExpr) -> Type {
        if let Some(data) = feature_data!(fe, ForceUnwrapData) {
            let inner_type = self.infer_type(&data.operand);
            match inner_type {
                Type::Nullable(inner) => *inner,
                other => other,
            }
        } else {
            Type::Unknown
        }
    }

    /// Infer the type of a null propagate expression: `object?.field`
    pub(crate) fn infer_null_propagate_type_inner(&self, object: &Expr, field: &str) -> Type {
        let ot = self.infer_type(object);
        let inner = match &ot {
            Type::Nullable(inner) => inner.as_ref(),
            _ => &ot,
        };
        match inner {
            Type::Struct { fields, .. } => {
                fields.iter().find(|(n, _)| n == field)
                    .map(|(_, ty)| Type::Nullable(Box::new(ty.clone())))
                    .unwrap_or(Type::Unknown)
            }
            Type::String => match field {
                "length" | "parse_int" => Type::Nullable(Box::new(Type::Int)),
                "upper" | "lower" | "trim" | "replace" => Type::Nullable(Box::new(Type::String)),
                "contains" | "starts_with" | "ends_with" => Type::Nullable(Box::new(Type::Bool)),
                _ => Type::Unknown,
            },
            _ => Type::Unknown,
        }
    }
}
