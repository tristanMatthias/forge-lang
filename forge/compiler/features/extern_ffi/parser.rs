use crate::lexer::token::TokenKind;
use crate::parser::ast::*;
use crate::parser::parser::Parser;

impl Parser {
    /// Parse an extern function declaration: `extern fn name(params) -> ReturnType`
    pub(crate) fn parse_extern_fn(&mut self) -> Option<Statement> {
        let start = self.advance()?.span; // consume 'extern'
        self.skip_newlines();

        // Expect 'fn' keyword
        if !self.check(&TokenKind::Fn) {
            self.error("expected 'fn' after 'extern'");
            return None;
        }
        self.advance(); // consume 'fn'
        self.skip_newlines();

        let name = self.expect_ident()?;
        self.skip_newlines();

        self.expect(&TokenKind::LParen)?;
        let params = self.parse_params()?;
        self.expect(&TokenKind::RParen)?;
        self.skip_newlines();

        let return_type = if self.check(&TokenKind::Arrow) {
            self.advance();
            self.skip_newlines();
            Some(self.parse_type_expr()?)
        } else {
            None
        };

        Some(Statement::ExternFn {
            name,
            params,
            return_type,
            span: start,
        })
    }
}
