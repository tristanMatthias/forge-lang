use crate::lexer::token::TokenKind;
use crate::parser::ast::*;
use crate::parser::parser::Parser;

impl Parser {
    /// Parse `table { header | ... \n row | ... \n ... }`
    /// Produces a TableLit AST node that the checker validates
    /// and codegen desugars into ListLit of StructLit.
    pub(crate) fn parse_table_literal(&mut self) -> Option<Expr> {
        let start_span = self.advance()?.span; // consume `table`
        self.expect(&TokenKind::LBrace)?;
        self.skip_newlines();

        // Parse header row: ident | ident | ident
        // Note: standalone `|` is tokenized as Ampersand
        let columns = self.parse_table_header()?;
        self.skip_newlines();

        // Parse value rows
        let mut rows: Vec<Vec<Expr>> = Vec::new();
        while !self.check(&TokenKind::RBrace) && !self.is_at_end() {
            let values = self.parse_table_row(columns.len())?;
            rows.push(values);
            self.skip_newlines();
        }

        self.expect(&TokenKind::RBrace)?;

        Some(Expr::TableLit {
            columns,
            rows,
            span: start_span,
        })
    }

    /// Parse pipe-separated identifiers: `name | age | active`
    fn parse_table_header(&mut self) -> Option<Vec<String>> {
        let mut columns = Vec::new();
        // First column
        columns.push(self.expect_ident()?);

        // Remaining columns separated by `|` (tokenized as Ampersand)
        while self.check(&TokenKind::Ampersand) {
            self.advance(); // consume `|`
            columns.push(self.expect_ident()?);
        }

        Some(columns)
    }

    /// Parse pipe-separated expressions for one row.
    fn parse_table_row(&mut self, expected_count: usize) -> Option<Vec<Expr>> {
        let mut values = Vec::new();

        // First value
        values.push(self.parse_table_cell()?);

        // Remaining values separated by `|` (tokenized as Ampersand)
        while self.check(&TokenKind::Ampersand) {
            self.advance(); // consume `|`
            values.push(self.parse_table_cell()?);
        }

        if values.len() != expected_count {
            self.error(&format!(
                "table row has {} value{}, but header has {} column{}",
                values.len(),
                if values.len() == 1 { "" } else { "s" },
                expected_count,
                if expected_count == 1 { "" } else { "s" },
            ));
            return None;
        }

        Some(values)
    }

    /// Parse a single table cell expression.
    /// parse_expr() naturally stops at `|` (Ampersand) since it's not a valid operator.
    fn parse_table_cell(&mut self) -> Option<Expr> {
        self.parse_expr()
    }
}
