use crate::codegen::codegen::Codegen;
use crate::parser::ast::*;
use crate::typeck::types::Type;

impl<'ctx> Codegen<'ctx> {
    /// Infer the type of a dollar-exec expression.
    /// Always returns `Type::String` since it captures stdout output.
    pub(crate) fn infer_dollar_exec_type(&self) -> Type {
        Type::String
    }
}
