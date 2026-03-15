use crate::parser::ast::*;
use crate::parser::parser::Parser;

impl Parser {
    /// Parse a `mod foo` declaration.
    /// This tells the compiler to find and include module `foo`.
    pub(crate) fn parse_mod_decl(&mut self) -> Option<Statement> {
        let span = self.advance()?.span; // consume 'mod'
        self.skip_newlines();
        let name = self.expect_ident()?;
        Some(Statement::ModDecl { name, span })
    }
}
