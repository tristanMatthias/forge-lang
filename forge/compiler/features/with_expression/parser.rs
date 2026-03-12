use crate::lexer::token::TokenKind;
use crate::parser::ast::*;
use crate::parser::parser::Parser;

impl Parser {
    /// Parse the `with` suffix: `expr with { field: value, ... }`
    pub(crate) fn parse_with_suffix(&mut self, base: Expr) -> Option<Expr> {
        let wspan = self.advance()?.span;
        self.skip_newlines();
        self.expect(&TokenKind::LBrace)?;
        self.skip_newlines();
        let mut updates = Vec::new();
        loop {
            self.skip_newlines();
            if self.check(&TokenKind::RBrace) {
                break;
            }
            let field = self.expect_ident()?;
            self.skip_newlines();
            self.expect(&TokenKind::Colon)?;
            self.skip_newlines();
            let value = self.parse_expr()?;
            updates.push((field, value));
            self.skip_newlines();
            if self.check(&TokenKind::Comma) {
                self.advance();
            }
        }
        self.expect(&TokenKind::RBrace)?;
        Some(Expr::With {
            base: Box::new(base),
            updates,
            span: wspan,
        })
    }
}
