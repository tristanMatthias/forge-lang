use crate::lexer::token::TokenKind;
use crate::parser::ast::*;
use crate::parser::parser::Parser;

use super::types::{StructLitData, TypeDeclData};

impl Parser {
    pub(crate) fn parse_type_decl_feature(&mut self, exported: bool) -> Option<Statement> {
        let start = self.advance()?.span; // consume 'type'
        self.skip_newlines();
        let name = self.expect_ident()?;
        self.skip_newlines();

        // Parse optional type parameters: type Pair<A, B> = ...
        let type_params = if self.check(&TokenKind::Lt) {
            self.parse_type_params()?
        } else {
            Vec::new()
        };
        self.skip_newlines();

        self.expect(&TokenKind::Eq)?;
        self.skip_newlines();
        let value = self.parse_type_expr()?;

        Some(feature_stmt(
            "structs",
            "TypeDecl",
            Box::new(TypeDeclData {
                name,
                type_params,
                value,
                exported,
            }),
            start,
        ))
    }

    pub(crate) fn parse_struct_literal_feature(&mut self, span: crate::lexer::Span) -> Option<Expr> {
        let fields = self.parse_struct_fields()?;
        self.expect(&TokenKind::RBrace)?;
        Some(feature_expr(
            "structs",
            "StructLit",
            Box::new(StructLitData {
                name: None,
                fields,
            }),
            span,
        ))
    }
}
