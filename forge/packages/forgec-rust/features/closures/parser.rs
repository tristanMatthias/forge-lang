use crate::lexer::token::TokenKind;
use crate::lexer::Span;
use crate::parser::ast::*;
use crate::parser::parser::Parser;

use super::types::ClosureData;

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
        self.skip_newlines();
        // Support both (params) -> body and (params) { body }
        if self.check(&TokenKind::Arrow) {
            self.advance();
            self.skip_newlines();
            // Check for return type annotation: (params) -> Type { body }
            // If we see an identifier followed by '{', it's a return type + block body
            if self.looks_like_return_type_then_block() {
                let _return_type = self.parse_type_expr(); // consume but don't use yet
                self.skip_newlines();
            }
            if self.check(&TokenKind::LBrace) {
                // Block body: parse as block (NOT as struct literal)
                let block = self.parse_block()?;
                Some(feature_expr(
                    "closures",
                    "Closure",
                    Box::new(ClosureData {
                        params,
                        body: Box::new(Expr::Block(block)),
                    }),
                    span,
                ))
            } else {
                let body = self.parse_expr()?;
                Some(feature_expr(
                    "closures",
                    "Closure",
                    Box::new(ClosureData {
                        params,
                        body: Box::new(body),
                    }),
                    span,
                ))
            }
        } else if self.check(&TokenKind::LBrace) {
            // (params) { body } form — also parse as block
            let block = self.parse_block()?;
            Some(feature_expr(
                "closures",
                "Closure",
                Box::new(ClosureData {
                    params,
                    body: Box::new(Expr::Block(block)),
                }),
                span,
            ))
        } else {
            let body = self.parse_expr()?;
            Some(feature_expr(
                "closures",
                "Closure",
                Box::new(ClosureData {
                    params,
                    body: Box::new(body),
                }),
                span,
            ))
        }
    }

    /// Check if the current position looks like `Type {` (return type followed by block body).
    /// Handles simple types (int, string, bool, float, void) and named types.
    fn looks_like_return_type_then_block(&self) -> bool {
        let mut i = self.pos;
        if i >= self.tokens.len() {
            return false;
        }
        match &self.tokens[i].kind {
            TokenKind::Ident(_) => {
                i += 1;
                // Handle nullable: Type?
                if i < self.tokens.len() && self.tokens[i].kind == TokenKind::Question {
                    i += 1;
                }
                // Skip newlines
                while i < self.tokens.len() && self.tokens[i].kind == TokenKind::Newline {
                    i += 1;
                }
                i < self.tokens.len() && self.tokens[i].kind == TokenKind::LBrace
            }
            _ => false,
        }
    }
}
