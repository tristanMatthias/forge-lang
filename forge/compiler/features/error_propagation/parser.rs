use crate::lexer::token::TokenKind;
use crate::parser::ast::*;
use crate::parser::parser::Parser;

impl Parser {
    /// Parse the `catch` suffix: `expr catch (binding) { handler }`
    pub(crate) fn parse_catch_suffix(&mut self, expr: Expr) -> Option<Expr> {
        let cspan = self.advance()?.span;
        self.skip_newlines();
        let binding = if self.check(&TokenKind::LParen) {
            self.advance();
            self.skip_newlines();
            let name = self.expect_ident()?;
            self.skip_newlines();
            self.expect(&TokenKind::RParen)?;
            self.skip_newlines();
            Some(name)
        } else {
            None
        };
        let handler = self.parse_block()?;
        Some(Expr::Catch {
            expr: Box::new(expr),
            binding,
            handler,
            span: cspan,
        })
    }
}
