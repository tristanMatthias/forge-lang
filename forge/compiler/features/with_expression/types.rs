use crate::codegen::codegen::Codegen;
use crate::parser::ast::*;
use crate::typeck::types::Type;

impl<'ctx> Codegen<'ctx> {
    /// Infer the type of a `with` expression — returns the same type as the base.
    pub(crate) fn infer_with_type(&self, base: &Expr) -> Type {
        self.infer_type(base)
    }
}
