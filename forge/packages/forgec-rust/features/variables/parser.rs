use crate::lexer::token::TokenKind;
use crate::parser::ast::*;
use crate::parser::parser::Parser;

use super::types::{LetDestructureData, VarDeclData, VarKind};

impl Parser {
    pub(crate) fn parse_let_feature(&mut self) -> Option<Statement> {
        self.parse_let_feature_with_export(false)
    }

    pub(crate) fn parse_let_feature_with_export(&mut self, exported: bool) -> Option<Statement> {
        let start = self.advance()?.span; // consume 'let'
        self.skip_newlines();

        // Check for destructuring patterns
        if self.check(&TokenKind::LParen) {
            return self.parse_tuple_destructure_feature(start);
        }
        if self.check(&TokenKind::LBrace) {
            return self.parse_struct_destructure_feature(start);
        }
        if self.check(&TokenKind::LBracket) {
            return self.parse_list_destructure_feature(start);
        }

        let name = self.expect_ident()?;
        let (type_ann, type_ann_span) = if self.check(&TokenKind::Colon) {
            let colon_pos = self.tokens[self.pos].span.start;
            self.advance();
            self.skip_newlines();
            let ty = self.parse_type_expr()?;
            let end_pos = self.tokens[self.pos.saturating_sub(1)].span.end;
            (Some(ty), Some(crate::lexer::Span::new(colon_pos, end_pos, 0, 0)))
        } else {
            (None, None)
        };
        self.skip_newlines();
        self.expect(&TokenKind::Eq)?;
        self.skip_newlines();
        let value = self.parse_expr()?;
        Some(feature_stmt(
            "variables",
            "Let",
            Box::new(VarDeclData {
                kind: VarKind::Let,
                name,
                type_ann,
                type_ann_span,
                value,
                exported,
            }),
            start,
        ))
    }

    pub(crate) fn parse_mut_feature(&mut self) -> Option<Statement> {
        self.parse_mut_feature_with_export(false)
    }

    pub(crate) fn parse_mut_feature_with_export(&mut self, exported: bool) -> Option<Statement> {
        let start = self.advance()?.span;
        self.skip_newlines();
        let name = self.expect_ident()?;
        let (type_ann, type_ann_span) = if self.check(&TokenKind::Colon) {
            let colon_pos = self.tokens[self.pos].span.start;
            self.advance();
            self.skip_newlines();
            let ty = self.parse_type_expr()?;
            let end_pos = self.tokens[self.pos.saturating_sub(1)].span.end;
            (Some(ty), Some(crate::lexer::Span::new(colon_pos, end_pos, 0, 0)))
        } else {
            (None, None)
        };
        self.skip_newlines();
        self.expect(&TokenKind::Eq)?;
        self.skip_newlines();
        let value = self.parse_expr()?;
        Some(feature_stmt(
            "variables",
            "Mut",
            Box::new(VarDeclData {
                kind: VarKind::Mut,
                name,
                type_ann,
                type_ann_span,
                value,
                exported,
            }),
            start,
        ))
    }

    pub(crate) fn parse_const_feature(&mut self) -> Option<Statement> {
        self.parse_const_feature_with_export(false)
    }

    pub(crate) fn parse_const_feature_with_export(&mut self, exported: bool) -> Option<Statement> {
        let start = self.advance()?.span;
        self.skip_newlines();
        let name = self.expect_ident()?;
        let (type_ann, type_ann_span) = if self.check(&TokenKind::Colon) {
            let colon_pos = self.tokens[self.pos].span.start;
            self.advance();
            self.skip_newlines();
            let ty = self.parse_type_expr()?;
            let end_pos = self.tokens[self.pos.saturating_sub(1)].span.end;
            (Some(ty), Some(crate::lexer::Span::new(colon_pos, end_pos, 0, 0)))
        } else {
            (None, None)
        };
        self.skip_newlines();
        self.expect(&TokenKind::Eq)?;
        self.skip_newlines();
        let value = self.parse_expr()?;
        Some(feature_stmt(
            "variables",
            "Const",
            Box::new(VarDeclData {
                kind: VarKind::Const,
                name,
                type_ann,
                type_ann_span,
                value,
                exported,
            }),
            start,
        ))
    }

    fn parse_tuple_destructure_feature(&mut self, start: crate::lexer::Span) -> Option<Statement> {
        self.advance(); // (
        self.skip_newlines();
        let mut patterns = Vec::new();
        loop {
            self.skip_newlines();
            if self.check(&TokenKind::RParen) {
                break;
            }
            let name = self.expect_ident()?;
            let span = self.tokens[self.pos.saturating_sub(1)].span;
            patterns.push(Pattern::Ident(name, span));
            self.skip_newlines();
            if !self.check(&TokenKind::Comma) {
                break;
            }
            self.advance();
        }
        self.expect(&TokenKind::RParen)?;
        self.skip_newlines();
        self.expect(&TokenKind::Eq)?;
        self.skip_newlines();
        let value = self.parse_expr()?;

        Some(feature_stmt(
            "variables",
            "LetDestructure",
            Box::new(LetDestructureData {
                pattern: Pattern::Tuple(patterns, start),
                value,
            }),
            start,
        ))
    }

    fn parse_struct_destructure_feature(&mut self, start: crate::lexer::Span) -> Option<Statement> {
        self.advance(); // {
        self.skip_newlines();
        let mut fields = Vec::new();
        loop {
            self.skip_newlines();
            if self.check(&TokenKind::RBrace) {
                break;
            }
            let field_name = self.expect_ident()?;
            let span = self.tokens[self.pos.saturating_sub(1)].span;
            // Check for renaming: { field_name: local_name }
            if self.check(&TokenKind::Colon) {
                self.advance(); // consume ':'
                self.skip_newlines();
                let local_name = self.expect_ident()?;
                let local_span = self.tokens[self.pos.saturating_sub(1)].span;
                fields.push((field_name, Pattern::Ident(local_name, local_span)));
            } else {
                fields.push((field_name.clone(), Pattern::Ident(field_name, span)));
            }
            self.skip_newlines();
            if !self.check(&TokenKind::Comma) {
                break;
            }
            self.advance();
        }
        self.expect(&TokenKind::RBrace)?;
        self.skip_newlines();
        self.expect(&TokenKind::Eq)?;
        self.skip_newlines();
        let value = self.parse_expr()?;

        Some(feature_stmt(
            "variables",
            "LetDestructure",
            Box::new(LetDestructureData {
                pattern: Pattern::Struct {
                    fields,
                    rest: false,
                    span: start,
                },
                value,
            }),
            start,
        ))
    }

    fn parse_list_destructure_feature(&mut self, start: crate::lexer::Span) -> Option<Statement> {
        self.advance(); // [
        self.skip_newlines();
        let mut elements = Vec::new();
        let mut rest_name = None;
        loop {
            self.skip_newlines();
            if self.check(&TokenKind::RBracket) {
                break;
            }
            if self.check(&TokenKind::Spread) {
                self.advance(); // ...
                let name = self.expect_ident()?;
                rest_name = Some(name);
                self.skip_newlines();
                break;
            }
            let name = self.expect_ident()?;
            let span = self.tokens[self.pos.saturating_sub(1)].span;
            elements.push(Pattern::Ident(name, span));
            self.skip_newlines();
            if !self.check(&TokenKind::Comma) {
                break;
            }
            self.advance();
        }
        self.expect(&TokenKind::RBracket)?;
        self.skip_newlines();
        self.expect(&TokenKind::Eq)?;
        self.skip_newlines();
        let value = self.parse_expr()?;

        Some(feature_stmt(
            "variables",
            "LetDestructure",
            Box::new(LetDestructureData {
                pattern: Pattern::List {
                    elements,
                    rest: rest_name,
                    span: start,
                },
                value,
            }),
            start,
        ))
    }
}
