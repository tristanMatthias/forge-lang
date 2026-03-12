use crate::codegen::codegen::Codegen;
use crate::parser::ast::*;
use crate::typeck::types::Type;

impl<'ctx> Codegen<'ctx> {
    /// Infer the type of a range expression: Range<T> where T is the start type.
    pub(crate) fn infer_range_type(&self, start: &Expr) -> Type {
        Type::Range(Box::new(self.infer_type(start)))
    }
}
