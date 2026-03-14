use crate::feature::FeatureExpr;
use crate::lexer::token::TokenKind;
use crate::parser::ast::*;
use crate::parser::parser::Parser;

use super::types::NullCoalesceData;

impl Parser {
    /// Parse null coalesce expressions: `expr ?? fallback`
    ///
    /// This handles the `??` operator in the precedence chain.
    /// Called by `parse_pipe`, delegates to `parse_or` for the next level.
    pub(crate) fn parse_null_coalesce(&mut self) -> Option<Expr> {
        let mut left = self.parse_or()?;

        while self.check(&TokenKind::DoubleQuestion) {
            let span = self.advance()?.span;
            self.skip_newlines();
            let right = self.parse_or()?;
            left = Expr::Feature(FeatureExpr {
                feature_id: "null_safety",
                kind: "NullCoalesce",
                data: Box::new(NullCoalesceData {
                    left: Box::new(left),
                    right: Box::new(right),
                }),
                span,
            });
        }
        Some(left)
    }
}
