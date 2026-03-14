use crate::feature::FeatureStmt;
use crate::lexer::token::TokenKind;
use crate::parser::ast::*;
use crate::parser::parser::Parser;

use super::types::{FnDeclData, ReturnData};

impl Parser {
    pub(crate) fn parse_fn_decl_feature(&mut self, exported: bool) -> Option<Statement> {
        let start = self.advance()?.span; // consume 'fn'
        self.skip_newlines();
        let name = self.expect_ident()?;
        self.skip_newlines();

        // Parse optional type parameters: fn name<T, U: Clone>(...)
        let type_params = if self.check(&TokenKind::Lt) {
            self.parse_type_params()?
        } else {
            Vec::new()
        };
        self.skip_newlines();

        self.expect(&TokenKind::LParen)?;
        let params = self.parse_params()?;
        self.skip_newlines();

        let return_type = if self.check(&TokenKind::Arrow) {
            self.advance();
            self.skip_newlines();
            Some(self.parse_type_expr()?)
        } else {
            None
        };
        self.skip_newlines();
        let body = self.parse_block()?;

        Some(Statement::Feature(FeatureStmt {
            feature_id: "functions",
            kind: "FnDecl",
            data: Box::new(FnDeclData {
                name,
                type_params,
                params,
                return_type,
                body,
                exported,
            }),
            span: start,
        }))
    }

    pub(crate) fn parse_return_feature(&mut self) -> Option<Statement> {
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
            feature_id: "functions",
            kind: "Return",
            data: Box::new(ReturnData { value }),
            span: start,
        }))
    }
}
