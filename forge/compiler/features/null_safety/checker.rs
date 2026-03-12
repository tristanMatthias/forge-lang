use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

impl TypeChecker {
    /// Type-check `NullLit` — returns `Type::Nullable(Unknown)`.
    pub(crate) fn check_null_lit(&mut self) -> Type {
        Type::Nullable(Box::new(Type::Unknown))
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
