use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;

impl TypeChecker {
    /// Type-check a trait declaration.
    ///
    /// Currently trait declarations are registered but not deeply checked;
    /// the checker treats `TraitDecl` and `ImplBlock` as declaration-only
    /// statements (see `check_statement` match arm).
    pub(crate) fn check_trait_decl(&mut self, _stmt: &Statement) {
        // Trait declarations are currently handled as no-ops in the checker.
        // Future work: validate method signatures, check super-trait bounds, etc.
    }

    /// Type-check an impl block.
    pub(crate) fn check_impl_block(&mut self, _stmt: &Statement) {
        // Impl blocks are currently handled as no-ops in the checker.
        // Future work: verify all required trait methods are implemented,
        // check method signatures match trait definition, etc.
    }
}
