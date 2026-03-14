use crate::feature::FeatureStmt;
use crate::lexer::token::TokenKind;
use crate::parser::ast::*;
use crate::parser::parser::Parser;

use super::types::EnumDeclData;

impl Parser {
    pub(crate) fn parse_enum_decl(&mut self, exported: bool) -> Option<Statement> {
        let start = self.advance()?.span; // consume 'enum'
        self.skip_newlines();
        let name = self.expect_ident()?;
        self.skip_newlines();
        self.expect(&TokenKind::LBrace)?;
        self.skip_newlines();

        let mut variants = Vec::new();
        loop {
            self.skip_newlines();
            if self.check(&TokenKind::RBrace) {
                break;
            }
            let vstart = self.current_span();
            let vname = self.expect_ident()?;
            self.skip_newlines();

            let fields = if self.check(&TokenKind::LParen) {
                self.advance();
                let params = self.parse_params()?;
                self.expect(&TokenKind::RParen)?;
                params
            } else {
                Vec::new()
            };

            variants.push(EnumVariant {
                name: vname,
                fields,
                span: vstart,
            });
            self.skip_newlines();
            // Allow optional comma or newline between variants
            if self.check(&TokenKind::Comma) {
                self.advance();
            }
        }
        self.expect(&TokenKind::RBrace)?;

        Some(Statement::Feature(FeatureStmt {
            feature_id: "enums",
            kind: "EnumDecl",
            data: Box::new(EnumDeclData {
                name,
                variants,
                exported,
            }),
            span: start,
        }))
    }
}
