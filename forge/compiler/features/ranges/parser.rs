use crate::feature::FeatureExpr;
use crate::lexer::token::TokenKind;
use crate::parser::ast::*;
use crate::parser::parser::Parser;

use super::types::RangeData;

impl Parser {
    pub(crate) fn parse_range(&mut self) -> Option<Expr> {
        let left = self.parse_addition()?;

        if self.check(&TokenKind::DotDot) {
            let span = self.advance()?.span;
            self.skip_newlines();
            let right = self.parse_addition()?;
            return Some(Expr::Feature(FeatureExpr {
                feature_id: "ranges",
                kind: "Range",
                data: Box::new(RangeData {
                    start: Box::new(left),
                    end: Box::new(right),
                    inclusive: false,
                }),
                span,
            }));
        }
        if self.check(&TokenKind::DotDotEq) {
            let span = self.advance()?.span;
            self.skip_newlines();
            let right = self.parse_addition()?;
            return Some(Expr::Feature(FeatureExpr {
                feature_id: "ranges",
                kind: "Range",
                data: Box::new(RangeData {
                    start: Box::new(left),
                    end: Box::new(right),
                    inclusive: true,
                }),
                span,
            }));
        }
        Some(left)
    }
}
