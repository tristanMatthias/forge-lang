use crate::feature::FeatureExpr;
use crate::lexer::token::TokenKind;
use crate::parser::ast::*;
use crate::parser::parser::Parser;

use super::types::IsData;

impl Parser {
    /// Precedence level between && and ==
    /// parse_and -> parse_is_check -> parse_equality
    pub(crate) fn parse_is_check(&mut self) -> Option<Expr> {
        let mut left = self.parse_equality()?;

        while self.check(&TokenKind::Is) {
            let span = self.advance()?.span; // consume `is`
            self.skip_newlines();

            // Check for `is not` — "not" is lexed as Ident("not"), not TokenKind::Not (which is `!`)
            let negated = if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::Ident(s)) if s == "not") {
                self.advance();
                self.skip_newlines();
                true
            } else {
                false
            };

            let pattern = self.parse_is_pattern()?;

            left = Expr::Feature(FeatureExpr {
                feature_id: "is_keyword",
                kind: "Is",
                data: Box::new(IsData {
                    value: Box::new(left),
                    pattern,
                    negated,
                }),
                span,
            });
        }

        Some(left)
    }

    /// Parse pattern for `is` expressions.
    /// Supports: Ok, Err, null, .variant, type names, Ok(binding), Err(binding)
    fn parse_is_pattern(&mut self) -> Option<Pattern> {
        let tok = self.peek()?.clone();
        match &tok.kind {
            // Ok / Ok(binding)
            TokenKind::Ok_ => {
                self.advance();
                if self.check(&TokenKind::LParen) {
                    self.advance();
                    self.skip_newlines();
                    let inner = self.parse_simple_pattern()?;
                    self.expect(&TokenKind::RParen)?;
                    Some(Pattern::Enum {
                        variant: "Ok".to_string(),
                        fields: vec![inner],
                        span: tok.span,
                    })
                } else {
                    Some(Pattern::Enum {
                        variant: "Ok".to_string(),
                        fields: vec![],
                        span: tok.span,
                    })
                }
            }
            // Err / Err(binding)
            TokenKind::Err_ => {
                self.advance();
                if self.check(&TokenKind::LParen) {
                    self.advance();
                    self.skip_newlines();
                    let inner = self.parse_simple_pattern()?;
                    self.expect(&TokenKind::RParen)?;
                    Some(Pattern::Enum {
                        variant: "Err".to_string(),
                        fields: vec![inner],
                        span: tok.span,
                    })
                } else {
                    Some(Pattern::Enum {
                        variant: "Err".to_string(),
                        fields: vec![],
                        span: tok.span,
                    })
                }
            }
            // null
            TokenKind::NullLiteral => {
                self.advance();
                Some(Pattern::Literal(Box::new(Expr::NullLit(tok.span))))
            }
            // .variant
            TokenKind::Dot => {
                self.advance();
                let variant = self.expect_ident()?;
                Some(Pattern::Enum {
                    variant,
                    fields: vec![],
                    span: tok.span,
                })
            }
            // Type name (e.g., `string`, `int`, `Dog`)
            TokenKind::Ident(name) => {
                let name = name.clone();
                self.advance();
                if self.check(&TokenKind::LParen) {
                    // Type with binding: string(s)
                    self.advance();
                    self.skip_newlines();
                    let inner = self.parse_simple_pattern()?;
                    self.expect(&TokenKind::RParen)?;
                    Some(Pattern::Enum {
                        variant: name,
                        fields: vec![inner],
                        span: tok.span,
                    })
                } else {
                    // Plain type check
                    Some(Pattern::Ident(name, tok.span))
                }
            }
            _ => {
                self.error(&format!("expected pattern after `is`, got {:?}", tok.kind));
                None
            }
        }
    }
}
