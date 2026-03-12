use crate::codegen::codegen::Codegen;
use crate::parser::ast::*;
use crate::typeck::types::Type;

impl<'ctx> Codegen<'ctx> {
    /// Infer the type of `ok(value)` — returns `Result<T, String>`.
    pub(crate) fn infer_ok_expr_type(&self, value: &Expr) -> Type {
        Type::Result(Box::new(self.infer_type(value)), Box::new(Type::String))
    }

    /// Infer the type of `err(value)` — returns `Result<Unknown, T>`.
    pub(crate) fn infer_err_expr_type(&self, value: &Expr) -> Type {
        Type::Result(Box::new(Type::Unknown), Box::new(self.infer_type(value)))
    }

    /// Infer the type of `expr catch { handler }`.
    ///
    /// If `expr` is `Result<Ok, Err>`, returns the `Ok` type.
    /// Otherwise returns the expr type unchanged.
    pub(crate) fn infer_catch_type(&self, expr: &Expr) -> Type {
        let et = self.infer_type(expr);
        match &et {
            Type::Result(ok, _) => *ok.clone(),
            _ => et,
        }
    }

    /// Infer the type of `expr?` — error propagation.
    ///
    /// If the operand is `Result<Ok, Err>`, returns the `Ok` type.
    /// Otherwise returns the operand type unchanged.
    pub(crate) fn infer_error_propagate_type(&self, operand: &Expr) -> Type {
        let ot = self.infer_type(operand);
        match &ot {
            Type::Result(ok, _) => *ok.clone(),
            _ => ot,
        }
    }
}
