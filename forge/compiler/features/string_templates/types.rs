use crate::codegen::codegen::Codegen;
use crate::typeck::types::Type;

impl<'ctx> Codegen<'ctx> {
    /// Infer the type of a template literal. Always `Type::String`.
    pub(crate) fn infer_template_lit_type(&self) -> Type {
        Type::String
    }
}
