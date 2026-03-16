use crate::parser::ast::*;
use crate::parser::parser::Parser;

use super::types::SpawnData;

impl Parser {
    /// Parse a `spawn { ... }` block expression.
    ///
    /// Consumes the `spawn` keyword and parses the following block.
    /// Returns a `Statement::Expr(feature_expr(...))`.
    pub(crate) fn parse_spawn(&mut self) -> Option<Statement> {
        let start = self.advance()?.span; // consume 'spawn'
        self.skip_newlines();
        let body = self.parse_block()?;
        Some(Statement::Expr(feature_expr(
            "spawn",
            "SpawnBlock",
            Box::new(SpawnData { body }),
            start,
        )))
    }
}
