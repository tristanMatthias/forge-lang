use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

impl TypeChecker {
    /// Type-check a spawn block by checking its body.
    /// Spawn blocks return `Type::Unknown` (they execute concurrently).
    pub(crate) fn check_spawn_block(&mut self, body: &Block) -> Type {
        self.check_block(body);
        Type::Unknown
    }
}
