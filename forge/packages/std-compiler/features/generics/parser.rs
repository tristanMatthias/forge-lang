use crate::lexer::token::TokenKind;
use crate::parser::ast::*;
use crate::parser::parser::Parser;

impl Parser {
    /// Parse type parameters: `<T, U: Clone + Display>`
    pub(crate) fn parse_type_params(&mut self) -> Option<Vec<TypeParam>> {
        self.advance(); // consume '<'
        self.skip_newlines();
        let mut params = Vec::new();
        loop {
            self.skip_newlines();
            if self.check(&TokenKind::Gt) {
                break;
            }
            let name = self.expect_ident()?;
            self.skip_newlines();
            let mut bounds = Vec::new();
            if self.check(&TokenKind::Colon) {
                self.advance();
                self.skip_newlines();
                // Parse bounds: T: Clone + Display
                let bound = self.expect_ident()?;
                bounds.push(bound);
                while self.check(&TokenKind::Plus) {
                    self.advance();
                    self.skip_newlines();
                    let bound = self.expect_ident()?;
                    bounds.push(bound);
                }
            }
            params.push(TypeParam { name, bounds });
            self.skip_newlines();
            if self.check(&TokenKind::Comma) {
                self.advance();
            }
        }
        self.expect(&TokenKind::Gt)?;
        Some(params)
    }
}
