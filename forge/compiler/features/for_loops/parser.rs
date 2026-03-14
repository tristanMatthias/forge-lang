use crate::lexer::token::TokenKind;
use crate::parser::ast::*;
use crate::parser::parser::Parser;

use super::types::ForData;

impl Parser {
    pub(crate) fn parse_for(&mut self) -> Option<Statement> {
        let start = self.advance()?.span; // consume 'for'
        self.skip_newlines();
        let pattern = self.parse_simple_pattern()?;
        self.skip_newlines();
        self.expect(&TokenKind::In)?;
        self.skip_newlines();
        let iterable = self.parse_expr()?;
        self.skip_newlines();
        let body = self.parse_block()?;
        Some(feature_stmt(
            "for_loops",
            "For",
            Box::new(ForData {
                pattern,
                iterable,
                body,
            }),
            start,
        ))
    }
}
