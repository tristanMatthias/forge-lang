use crate::lexer::token::TokenKind;
use crate::parser::ast::*;
use crate::parser::parser::Parser;

use super::types::UseData;

impl Parser {
    pub(crate) fn parse_use_feature(&mut self) -> Option<Statement> {
        let start = self.advance()?.span; // consume 'use'
        self.skip_newlines();

        let mut path = Vec::new();
        if self.check(&TokenKind::At) {
            self.advance(); // consume '@'
            let first = self.expect_ident()?;
            path.push(format!("@{}", first));
        } else {
            let first = self.expect_ident()?;
            path.push(first);
        }

        let mut items = Vec::new();

        loop {
            if !self.check(&TokenKind::Dot) {
                break;
            }
            self.advance(); // consume '.'
            self.skip_newlines();

            if self.check(&TokenKind::LBrace) {
                self.advance(); // consume '{'
                self.skip_newlines();
                loop {
                    self.skip_newlines();
                    if self.check(&TokenKind::RBrace) {
                        break;
                    }
                    let name = self.expect_ident()?;
                    self.skip_newlines();
                    let alias = if self.check(&TokenKind::As) {
                        self.advance();
                        self.skip_newlines();
                        Some(self.expect_ident()?)
                    } else {
                        None
                    };
                    items.push(UseItem { name, alias });
                    self.skip_newlines();
                    if self.check(&TokenKind::Comma) {
                        self.advance();
                    }
                }
                self.expect(&TokenKind::RBrace)?;
                break;
            }

            let segment = self.expect_ident()?;
            path.push(segment);
        }

        Some(feature_stmt(
            "imports",
            "Use",
            Box::new(UseData { path, items }),
            start,
        ))
    }

    pub(crate) fn parse_export_feature(&mut self) -> Option<Statement> {
        self.advance(); // consume 'export'
        self.skip_newlines();

        // Check if next token is a registered component name
        if let Some(meta) = self.peek_component_meta() {
            let mut stmt = self.parse_component_block(&meta)?;
            if let Statement::ComponentBlock(ref mut decl) = stmt {
                decl.exported = true;
            }
            return Some(stmt);
        }

        let tok = self.peek()?;
        match &tok.kind {
            TokenKind::Fn => self.parse_fn_decl_feature(true),
            TokenKind::Enum => self.parse_enum_decl(true),
            TokenKind::Type => self.parse_type_decl_feature(true),
            TokenKind::Let => self.parse_let_feature_with_export(true),
            TokenKind::Mut => self.parse_mut_feature_with_export(true),
            TokenKind::Const => self.parse_const_feature_with_export(true),
            TokenKind::Trait => self.parse_trait_decl_feature(true),
            _ => {
                self.error("expected fn, enum, type, let, mut, const, trait, or component after export");
                None
            }
        }
    }

    /// Check if the next token is a registered component name, returning the meta if so.
    fn peek_component_meta(&self) -> Option<crate::parser::ComponentMeta> {
        let tok = self.peek()?;
        match &tok.kind {
            TokenKind::Ident(name) => self.registered_components.get(name).cloned(),
            _ => None,
        }
    }
}
