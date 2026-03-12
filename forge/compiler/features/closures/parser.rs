use crate::lexer::token::TokenKind;
use crate::lexer::Span;
use crate::parser::ast::*;
use crate::parser::parser::Parser;

impl Parser {
    /// Parse `(params) -> body` or `(params) { body }` closure when detected inside paren expr.
    /// Called from `parse_paren_expr` after `looks_like_closure_params` returns true.
    pub(crate) fn looks_like_closure_params(&self) -> bool {
        // Look ahead to see if this is (name: type, ...) -> or (name) {
        let mut i = self.pos;
        let mut depth = 1;
        while i < self.tokens.len() && depth > 0 {
            match &self.tokens[i].kind {
                TokenKind::LParen => depth += 1,
                TokenKind::RParen => {
                    depth -= 1;
                    if depth == 0 {
                        // Check if followed by -> or {
                        let mut next = i + 1;
                        // Skip newlines
                        while next < self.tokens.len() && self.tokens[next].kind == TokenKind::Newline {
                            next += 1;
                        }
                        if next < self.tokens.len() {
                            return self.tokens[next].kind == TokenKind::Arrow
                                || self.tokens[next].kind == TokenKind::LBrace;
                        }
                    }
                }
                _ => {}
            }
            i += 1;
        }
        false
    }

    pub(crate) fn parse_closure(&mut self, span: Span) -> Option<Expr> {
        // We're past the opening '(' already
        let params = self.parse_params()?;
        self.expect(&TokenKind::RParen)?;
        self.skip_newlines();
        // Support both (params) -> body and (params) { body }
        if self.check(&TokenKind::Arrow) {
            self.advance();
            self.skip_newlines();
            let body = self.parse_expr()?;
            Some(Expr::Closure {
                params,
                body: Box::new(body),
                span,
            })
        } else {
            // (params) { body } form
            let body = self.parse_expr()?;
            Some(Expr::Closure {
                params,
                body: Box::new(body),
                span,
            })
        }
    }
}
