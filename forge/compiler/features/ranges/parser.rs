use crate::lexer::token::TokenKind;
use crate::parser::ast::*;
use crate::parser::parser::Parser;

impl Parser {
    pub(crate) fn parse_range(&mut self) -> Option<Expr> {
        let left = self.parse_addition()?;

        if self.check(&TokenKind::DotDot) {
            let span = self.advance()?.span;
            self.skip_newlines();
            let right = self.parse_addition()?;
            return Some(Expr::Range {
                start: Box::new(left),
                end: Box::new(right),
                inclusive: false,
                span,
            });
        }
        if self.check(&TokenKind::DotDotEq) {
            let span = self.advance()?.span;
            self.skip_newlines();
            let right = self.parse_addition()?;
            return Some(Expr::Range {
                start: Box::new(left),
                end: Box::new(right),
                inclusive: true,
                span,
            });
        }
        Some(left)
    }
}
