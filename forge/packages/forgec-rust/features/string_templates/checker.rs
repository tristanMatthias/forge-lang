use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

#[allow(dead_code)]
impl TypeChecker {
    /// Type-check a template literal. Always returns `Type::String`.
    pub(crate) fn check_template_lit(&mut self) -> Type {
        Type::String
    }
}
