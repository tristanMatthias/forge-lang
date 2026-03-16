use crate::lexer::token::TokenKind;
use crate::parser::ast::*;
use crate::parser::parser::Parser;

use super::types::{MatchTableData, MatchTableRow};

impl Parser {
    /// Parse a match table expression. Called from `parse_match_expr` when
    /// the `table` keyword is found after the subject expression.
    /// The subject and starting span have already been parsed.
    pub(crate) fn parse_match_table(&mut self, subject: Expr, span: crate::lexer::Span) -> Option<Expr> {
        // `table` keyword already peeked — consume it
        self.advance(); // table
        self.skip_newlines();
        self.expect(&TokenKind::LBrace)?;
        self.skip_newlines();

        // Parse header row: pattern | col1 | col2 | ...
        // First token should be the identifier "pattern"
        let first_header = self.expect_ident()?;
        if first_header != "pattern" {
            self.error(&format!("expected 'pattern' as first column header, got '{}'", first_header));
            return None;
        }

        let mut columns = Vec::new();
        while self.check(&TokenKind::Ampersand) {
            self.advance(); // |
            self.skip_newlines();
            let col_name = self.expect_ident()?;
            columns.push(col_name);
        }
        self.skip_newlines();

        if columns.is_empty() {
            self.error("match table must have at least one value column after 'pattern'");
            return None;
        }

        // Parse data rows until }
        let mut rows = Vec::new();
        while !self.check(&TokenKind::RBrace) && !self.is_at_end() {
            let pattern = self.parse_pattern()?;
            let mut values = Vec::new();
            for _ in 0..columns.len() {
                self.expect(&TokenKind::Ampersand)?;
                self.skip_newlines();
                // Parse a single expression (but not pipe, which is our delimiter)
                let val = self.parse_unary()?;
                values.push(val);
            }
            rows.push(MatchTableRow { pattern, values });
            self.skip_newlines();
        }

        self.expect(&TokenKind::RBrace)?;

        Some(feature_expr(
            "match_tables",
            "MatchTable",
            Box::new(MatchTableData {
                subject: Box::new(subject),
                columns,
                rows,
            }),
            span,
        ))
    }
}
