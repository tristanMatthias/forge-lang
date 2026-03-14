use crate::feature::FeatureExpr;
use crate::lexer::token::TokenKind;
use crate::parser::ast::*;
use crate::parser::parser::Parser;

use super::types::PipeData;

impl Parser {
    /// Parse pipe expressions: `expr |> fn` or `expr |> fn(args)`
    ///
    /// This handles the `|>` operator in the precedence chain.
    /// Called by `parse_expr`, delegates to `parse_null_coalesce` for the next level.
    pub(crate) fn parse_pipe(&mut self) -> Option<Expr> {
        let mut left = self.parse_null_coalesce()?;

        while self.check(&TokenKind::Pipe) || self.next_meaningful_is(&TokenKind::Pipe) {
            self.skip_newlines();
            let span = self.advance()?.span;
            self.skip_newlines();
            let right = self.parse_null_coalesce()?;
            left = Expr::Feature(FeatureExpr {
                feature_id: "pipe_operator",
                kind: "Pipe",
                data: Box::new(PipeData {
                    left: Box::new(left),
                    right: Box::new(right),
                }),
                span,
            });
        }

        // Check for `catch` (error_propagation feature)
        if self.check(&TokenKind::Catch) {
            left = self.parse_catch_suffix(left)?;
        }

        // Check for `with` (with_expression feature)
        if self.check(&TokenKind::With) {
            left = self.parse_with_suffix(left)?;
        }

        Some(left)
    }
}
