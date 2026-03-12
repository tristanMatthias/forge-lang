use crate::lexer::token::TokenKind;
use crate::parser::ast::*;
use crate::parser::parser::Parser;

impl Parser {
    /// Parse a channel send expression: `expr <- value`
    ///
    /// Called from `parse_expr_statement` when a `<-` token follows an expression.
    /// The `channel_expr` is the already-parsed left-hand side.
    pub(crate) fn parse_channel_send(&mut self, channel_expr: Expr) -> Option<Statement> {
        let span = self.advance()?.span; // consume <-
        self.skip_newlines();
        let value = self.parse_expr()?;
        Some(Statement::Expr(Expr::ChannelSend {
            channel: Box::new(channel_expr),
            value: Box::new(value),
            span,
        }))
    }

    /// Parse a channel receive expression: `<- channel`
    ///
    /// Called from `parse_unary` when a `<-` token is encountered as a prefix operator.
    pub(crate) fn parse_channel_receive(&mut self) -> Option<Expr> {
        let span = self.advance()?.span; // consume <-
        self.skip_newlines();
        let channel = self.parse_unary()?;
        Some(Expr::ChannelReceive {
            channel: Box::new(channel),
            span,
        })
    }
}
