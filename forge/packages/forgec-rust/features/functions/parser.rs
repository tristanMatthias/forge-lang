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
        let type_params = self.parse_optional_type_params()?;
        self.skip_newlines();

        self.expect(&TokenKind::LParen)?;
        let params = self.parse_params()?;
        self.skip_newlines();

        let return_type = self.parse_optional_return_type()?;
        self.skip_newlines();
        let body = self.parse_block()?;

        Some(feature_stmt(
            "functions",
            "FnDecl",
            Box::new(FnDeclData {
                name,
                type_params,
                params,
                return_type,
                body,
                exported,
            }),
            start,
        ))
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
        Some(feature_stmt(
            "functions",
            "Return",
            Box::new(ReturnData { value }),
            start,
        ))
    }
}
