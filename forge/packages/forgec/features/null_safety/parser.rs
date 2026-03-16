use crate::lexer::token::TokenKind;
use crate::parser::ast::*;
use crate::parser::parser::Parser;

use super::types::NullCoalesceData;
use crate::features::null_throw::types::NullThrowData;

impl Parser {
    /// Parse null coalesce expressions: `expr ?? fallback` or `expr ?? throw .error`
    ///
    /// This handles the `??` operator in the precedence chain.
    /// Called by `parse_pipe`, delegates to `parse_or` for the next level.
    pub(crate) fn parse_null_coalesce(&mut self) -> Option<Expr> {
        let mut left = self.parse_or()?;

        while self.check(&TokenKind::DoubleQuestion) {
            let span = self.advance()?.span;
            self.skip_newlines();

            // Check for `?? throw` — null-to-panic conversion
            let is_throw = if let Some(tok) = self.peek() {
                matches!(&tok.kind, TokenKind::Ident(name) if name == "throw")
            } else {
                false
            };

            if is_throw {
                self.advance(); // consume "throw"
                self.skip_newlines();
                let error_expr = self.parse_primary()?;
                left = feature_expr(
                    "null_throw",
                    "NullThrow",
                    Box::new(NullThrowData {
                        value: Box::new(left),
                        error: Box::new(error_expr),
                    }),
                    span,
                );
            } else {
                let right = self.parse_or()?;
                left = feature_expr(
                    "null_safety",
                    "NullCoalesce",
                    Box::new(NullCoalesceData {
                        left: Box::new(left),
                        right: Box::new(right),
                    }),
                    span,
                );
            }
        }
        Some(left)
    }
}
