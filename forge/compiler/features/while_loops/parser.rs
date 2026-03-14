use crate::feature::FeatureStmt;
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
        Some(Statement::Feature(FeatureStmt {
            feature_id: "while_loops",
            kind: "While",
            data: Box::new(WhileData { condition, body }),
            span: start,
        }))
    }

    pub(crate) fn parse_loop(&mut self) -> Option<Statement> {
        let start = self.advance()?.span;
        self.skip_newlines();
        let body = self.parse_block()?;
        Some(Statement::Feature(FeatureStmt {
            feature_id: "while_loops",
            kind: "Loop",
            data: Box::new(LoopData {
                body,
                label: None,
            }),
            span: start,
        }))
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
        Some(Statement::Feature(FeatureStmt {
            feature_id: "while_loops",
            kind: "Break",
            data: Box::new(BreakData {
                value,
                label: None,
            }),
            span: start,
        }))
    }

    pub(crate) fn parse_continue(&mut self) -> Option<Statement> {
        let start = self.advance()?.span;
        Some(Statement::Feature(FeatureStmt {
            feature_id: "while_loops",
            kind: "Continue",
            data: Box::new(ContinueData { label: None }),
            span: start,
        }))
    }
}
