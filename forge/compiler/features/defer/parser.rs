use crate::feature::FeatureStmt;
use crate::parser::ast::*;
use crate::parser::parser::Parser;

use super::types::DeferData;

impl Parser {
    /// Parse a `defer` statement: `defer <expr>`
    ///
    /// The deferred expression will be executed in reverse order
    /// before the enclosing function returns.
    pub(crate) fn parse_defer(&mut self) -> Option<Statement> {
        let start = self.advance()?.span;
        self.skip_newlines();
        let body = self.parse_expr()?;
        Some(Statement::Feature(FeatureStmt {
            feature_id: "defer",
            kind: "Defer",
            data: Box::new(DeferData { body }),
            span: start,
        }))
    }
}
