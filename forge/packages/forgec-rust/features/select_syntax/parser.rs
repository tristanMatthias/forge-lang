use crate::lexer::token::TokenKind;
use crate::parser::ast::*;
use crate::parser::parser::Parser;

use super::types::SelectData;

impl Parser {
    /// Parse a `select { ... }` statement for channel multiplexing.
    ///
    /// Syntax:
    /// ```text
    /// select {
    ///     binding <- channel [if guard] -> body
    ///     ...
    /// }
    /// ```
    ///
    /// Each arm has a binding pattern, a channel expression, an optional guard,
    /// and a body (block or single statement).
    pub(crate) fn parse_select(&mut self) -> Option<Statement> {
        let start = self.advance()?.span; // consume 'select'
        self.skip_newlines();
        self.expect(&TokenKind::LBrace)?;
        self.skip_newlines();

        let mut arms = Vec::new();
        while !self.check(&TokenKind::RBrace) && !self.is_at_end() {
            self.skip_newlines();
            if self.check(&TokenKind::RBrace) {
                break;
            }
            let arm_span = self.current_span();

            // Parse binding pattern: identifier or _ (wildcard)
            let binding = self.parse_simple_pattern()?;
            self.skip_newlines();

            // Expect <- (LeftArrow)
            self.expect(&TokenKind::LeftArrow)?;
            self.skip_newlines();

            // Parse channel expression as a simple identifier or member access
            // (NOT parse_postfix/parse_expr which would consume -> as closure syntax)
            let channel = {
                let ident = self.expect_ident()?;
                let span = self.current_span();
                let mut expr = Expr::Ident(ident, span);
                // Allow member access: ch.field
                while self.check(&TokenKind::Dot) {
                    let dot_span = self.advance()?.span;
                    let field = self.expect_field_name()?;
                    expr = Expr::MemberAccess {
                        object: Box::new(expr),
                        field,
                        span: dot_span,
                    };
                }
                expr
            };
            self.skip_newlines();

            // Optional guard: if condition
            let guard = if self.check(&TokenKind::If) {
                self.advance();
                self.skip_newlines();
                // Parse guard up to ->
                Some(self.parse_comparison()?)
            } else {
                None
            };
            self.skip_newlines();

            // Expect -> (Arrow)
            self.expect(&TokenKind::Arrow)?;
            self.skip_newlines();

            // Parse body: either a block { ... } or wrap a single statement in a block
            let body = self.parse_block_or_stmt()?;

            arms.push(SelectArm {
                binding,
                channel,
                guard,
                body,
                span: arm_span,
            });
            self.skip_newlines();
        }
        self.expect(&TokenKind::RBrace)?;

        Some(feature_stmt(
            "select_syntax",
            "Select",
            Box::new(SelectData { arms }),
            start,
        ))
    }
}
