use crate::codegen::codegen::Codegen;
use crate::parser::ast::*;
use crate::typeck::types::Type;

impl<'ctx> Codegen<'ctx> {
    /// Infer the type of `NullLit` — returns `Nullable(Unknown)`.
    pub(crate) fn infer_null_lit_type(&self) -> Type {
        Type::Nullable(Box::new(Type::Unknown))
    }

    /// Infer the type of a null coalesce expression: `left ?? right`
    ///
    /// The result type is the type of `right`, since `??` unwraps the nullable.
    pub(crate) fn infer_null_coalesce_type(&self, right: &Expr) -> Type {
        self.infer_type(right)
    }

    /// Infer the type of a null propagate expression: `object?.field`
    ///
    /// Unwraps `Nullable(T)` from the object, looks up the field on `T`,
    /// and wraps the result in `Nullable`.
    pub(crate) fn infer_null_propagate_type(&self, object: &Expr, field: &str) -> Type {
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
                "length" => Type::Nullable(Box::new(Type::Int)),
                "upper" | "lower" | "trim" => Type::Nullable(Box::new(Type::String)),
                _ => Type::Unknown,
            },
            _ => Type::Unknown,
        }
    }
}
