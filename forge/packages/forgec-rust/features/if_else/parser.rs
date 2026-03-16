use crate::lexer::token::TokenKind;
use crate::parser::ast::*;
use crate::parser::parser::Parser;

use super::types::IfData;

impl Parser {
    pub(crate) fn parse_if_expr(&mut self) -> Option<Expr> {
        let span = self.advance()?.span; // if
        self.skip_newlines();
        let condition = self.parse_expr()?;
        self.skip_newlines();
        let then_branch = self.parse_block()?;
        self.skip_newlines();
        let else_branch = if self.check(&TokenKind::Else) {
            self.advance();
            self.skip_newlines();
            if self.check(&TokenKind::If) {
                // else if -> wrap in a block containing the if
                let inner_if = self.parse_if_expr()?;
                let block_span = inner_if.span();
                Some(Block {
                    statements: vec![Statement::Expr(inner_if)],
                    span: block_span,
                })
            } else {
                Some(self.parse_block()?)
            }
        } else {
            None
        };

        Some(feature_expr(
            "if_else",
            "If",
            Box::new(IfData {
                condition: Box::new(condition),
                then_branch,
                else_branch,
            }),
            span,
        ))
    }
}
