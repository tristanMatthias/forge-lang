use crate::lexer::token::TokenKind;
use crate::parser::ast::*;
use crate::parser::parser::Parser;

use super::types::{BreakData, ContinueData, LoopData, WhileData};

impl Parser {
    pub(crate) fn parse_while(&mut self) -> Option<Statement> {
        let start = self.advance()?.span;
        self.skip_newlines();
        let condition = self.parse_expr()?;
        self.skip_newlines();
        let body = self.parse_block()?;
        Some(feature_stmt(
            "while_loops",
            "While",
            Box::new(WhileData { condition, body }),
            start,
        ))
    }

    pub(crate) fn parse_loop(&mut self) -> Option<Statement> {
        let start = self.advance()?.span;
        self.skip_newlines();
        let body = self.parse_block()?;
        Some(feature_stmt(
            "while_loops",
            "Loop",
            Box::new(LoopData {
                body,
                label: None,
            }),
            start,
        ))
    }

    pub(crate) fn parse_break(&mut self) -> Option<Statement> {
        let start = self.advance()?.span;
        let value = if self.is_at_end()
            || self.check(&TokenKind::Newline)
            || self.check(&TokenKind::RBrace)
        {
            None
        } else {
            Some(self.parse_expr()?)
        };
        Some(feature_stmt(
            "while_loops",
            "Break",
            Box::new(BreakData {
                value,
                label: None,
            }),
            start,
        ))
    }

    pub(crate) fn parse_continue(&mut self) -> Option<Statement> {
        let start = self.advance()?.span;
        Some(feature_stmt(
            "while_loops",
            "Continue",
            Box::new(ContinueData { label: None }),
            start,
        ))
    }
}
