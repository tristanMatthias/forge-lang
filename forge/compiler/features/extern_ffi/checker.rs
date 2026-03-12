use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;

impl TypeChecker {
    /// Type-check an extern function declaration.
    ///
    /// Extern functions are declaration-only (no body to check).
    /// The checker treats `ExternFn` as a no-op statement -- the function
    /// signature is trusted and its return type is registered at codegen time.
    pub(crate) fn check_extern_fn(&mut self, _stmt: &Statement) {
        // Extern fn declarations have no body to type-check.
        // The return type is registered in codegen via compile_extern_fn.
    }
}
