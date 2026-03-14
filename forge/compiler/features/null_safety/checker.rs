use crate::feature::FeatureExpr;
use crate::feature_check;
use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

use super::types::{NullCoalesceData, NullPropagateData};

impl TypeChecker {
    /// Type-check a null coalesce expression via Feature dispatch.
    pub(crate) fn check_null_coalesce_feature(&mut self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, NullCoalesceData, |data| self.check_null_coalesce(&data.left, &data.right))
    }

    /// Type-check a null coalesce expression: `left ?? right`
    ///
    /// If `left` is `Nullable(T)`, the result is `T`.
    /// Otherwise falls back to the type of `right`.
    pub(crate) fn check_null_coalesce(&mut self, left: &Expr, right: &Expr) -> Type {
        let left_type = self.check_expr(left);
        let right_type = self.check_expr(right);
        match &left_type {
            Type::Nullable(inner) => *inner.clone(),
            _ => right_type,
        }
    }

    /// Type-check a null propagate expression via Feature dispatch.
    pub(crate) fn check_null_propagate_feature(&mut self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, NullPropagateData, |data| self.check_null_propagate(&data.object, &data.field))
    }

    /// Type-check a null propagate expression: `object?.field`
    ///
    /// Unwraps `Nullable(T)` from the object, accesses the field on `T`,
    /// and wraps the result in `Nullable`.
    pub(crate) fn check_null_propagate(&mut self, object: &Expr, field: &str) -> Type {
        let obj_type = self.check_expr(object);
        let inner = match &obj_type {
            Type::Nullable(inner) => inner.as_ref(),
            _ => &obj_type,
        };
        let field_type = match inner {
            Type::Struct { fields, .. } => {
                fields
                    .iter()
                    .find(|(name, _)| name == field)
                    .map(|(_, ty)| ty.clone())
                    .unwrap_or(Type::Unknown)
            }
            Type::String => match field {
                "length" => Type::Int,
                _ => Type::Unknown,
            },
            _ => Type::Unknown,
        };
        Type::Nullable(Box::new(field_type))
    }
}
