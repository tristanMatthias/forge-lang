use crate::lexer::token::TokenKind;
use crate::parser::ast::*;
use crate::parser::parser::Parser;

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
        Some(Statement::For {
            pattern,
            iterable,
            body,
            span: start,
        })
    }

    pub(crate) fn parse_while(&mut self) -> Option<Statement> {
        let start = self.advance()?.span;
        self.skip_newlines();
        let condition = self.parse_expr()?;
        self.skip_newlines();
        let body = self.parse_block()?;
        Some(Statement::While {
            condition,
            body,
            span: start,
        })
    }

    pub(crate) fn parse_loop(&mut self) -> Option<Statement> {
        let start = self.advance()?.span;
        self.skip_newlines();
        let body = self.parse_block()?;
        Some(Statement::Loop {
            body,
            label: None,
            span: start,
        })
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
        Some(Statement::Break {
            value,
            label: None,
            span: start,
        })
    }

    pub(crate) fn parse_continue(&mut self) -> Option<Statement> {
        let start = self.advance()?.span;
        Some(Statement::Continue {
            label: None,
            span: start,
        })
    }
}
