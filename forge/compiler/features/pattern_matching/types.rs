use crate::codegen::codegen::Codegen;
use crate::parser::ast::*;
use crate::typeck::types::Type;

impl<'ctx> Codegen<'ctx> {
    /// Infer the type of a match expression from its first arm.
    pub(crate) fn infer_match_type(&self, arms: &[MatchArm]) -> Type {
        if let Some(first) = arms.first() {
            self.infer_type(&first.body)
        } else {
            Type::Unknown
        }
    }
}
