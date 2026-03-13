use crate::lexer::token::TokenKind;
use crate::parser::ast::*;
use crate::parser::parser::Parser;

impl Parser {
    pub(crate) fn parse_match_expr(&mut self) -> Option<Expr> {
        let span = self.advance()?.span; // match
        self.skip_newlines();
        let subject = self.parse_expr()?;
        self.skip_newlines();
        self.expect(&TokenKind::LBrace)?;
        self.skip_newlines();

        let mut arms = Vec::new();
        while !self.check(&TokenKind::RBrace) && !self.is_at_end() {
            self.skip_newlines();
            if self.check(&TokenKind::RBrace) {
                break;
            }
            let arm = self.parse_match_arm()?;
            arms.push(arm);
            self.skip_newlines();
        }
        self.expect(&TokenKind::RBrace)?;

        Some(Expr::Match {
            subject: Box::new(subject),
            arms,
            span,
        })
    }

    pub(crate) fn parse_match_arm(&mut self) -> Option<MatchArm> {
        let span = self.current_span();
        let pattern = self.parse_pattern()?;
        self.skip_newlines();

        let guard = if self.check(&TokenKind::If) {
            self.advance();
            self.skip_newlines();
            Some(self.parse_expr()?)
        } else {
            None
        };

        self.skip_newlines();
        self.expect(&TokenKind::Arrow)?;
        self.skip_newlines();
        let body = {
            // Disable cross-newline dot chaining so that `.variant` on the
            // next line is parsed as a new match arm, not member access.
            let prev = self.no_newline_dot_chain;
            self.no_newline_dot_chain = true;
            let expr = self.parse_expr()?;
            self.no_newline_dot_chain = prev;
            // Check for assignment: expr = value (e.g., count = count + 1)
            if self.check(&TokenKind::Eq) {
                let eq_span = self.advance()?.span;
                self.skip_newlines();
                let value = self.parse_expr()?;
                Expr::Block(Block {
                    statements: vec![Statement::Assign {
                        target: expr,
                        value,
                        span: eq_span,
                    }],
                    span: eq_span,
                })
            } else {
                expr
            }
        };
        self.skip_newlines();

        // Optional newline separator
        Some(MatchArm {
            pattern,
            guard,
            body,
            span,
        })
    }

    pub(crate) fn parse_pattern(&mut self) -> Option<Pattern> {
        let tok = self.peek()?.clone();
        match &tok.kind {
            TokenKind::Underscore => {
                self.advance();
                Some(Pattern::Wildcard(tok.span))
            }
            TokenKind::Dot => {
                // .variant or .variant(bindings)
                self.advance();
                let variant = self.expect_ident()?;
                if self.check(&TokenKind::LParen) {
                    self.advance();
                    self.skip_newlines();
                    let mut fields = Vec::new();
                    while !self.check(&TokenKind::RParen) && !self.is_at_end() {
                        self.skip_newlines();
                        let p = self.parse_simple_pattern()?;
                        fields.push(p);
                        self.skip_newlines();
                        if self.check(&TokenKind::Comma) {
                            self.advance();
                        }
                    }
                    self.expect(&TokenKind::RParen)?;
                    Some(Pattern::Enum {
                        variant,
                        fields,
                        span: tok.span,
                    })
                } else {
                    Some(Pattern::Enum {
                        variant,
                        fields: vec![],
                        span: tok.span,
                    })
                }
            }
            TokenKind::IntLiteral(n) => {
                let n = *n;
                self.advance();
                Some(Pattern::Literal(Box::new(Expr::IntLit(n, tok.span))))
            }
            TokenKind::StringLiteral(s) => {
                let s = s.clone();
                self.advance();
                Some(Pattern::Literal(Box::new(Expr::StringLit(s, tok.span))))
            }
            TokenKind::BoolLiteral(b) => {
                let b = *b;
                self.advance();
                Some(Pattern::Literal(Box::new(Expr::BoolLit(b, tok.span))))
            }
            TokenKind::NullLiteral => {
                self.advance();
                Some(Pattern::Literal(Box::new(Expr::NullLit(tok.span))))
            }
            TokenKind::Ident(name) => {
                let name = name.clone();
                self.advance();
                Some(Pattern::Ident(name, tok.span))
            }
            _ => {
                self.error(&format!("expected pattern, got {:?}", tok.kind));
                None
            }
        }
    }

    pub(crate) fn parse_simple_pattern(&mut self) -> Option<Pattern> {
        let tok = self.peek()?.clone();
        match &tok.kind {
            TokenKind::Underscore => {
                self.advance();
                Some(Pattern::Wildcard(tok.span))
            }
            TokenKind::LParen => {
                // Tuple pattern: (a, b, ...)
                let span = self.advance()?.span;
                self.skip_newlines();
                let mut elems = Vec::new();
                while !self.check(&TokenKind::RParen) && !self.is_at_end() {
                    self.skip_newlines();
                    let p = self.parse_simple_pattern()?;
                    elems.push(p);
                    self.skip_newlines();
                    if self.check(&TokenKind::Comma) {
                        self.advance();
                    }
                }
                self.expect(&TokenKind::RParen)?;
                Some(Pattern::Tuple(elems, span))
            }
            TokenKind::Ident(name) => {
                let name = name.clone();
                self.advance();
                Some(Pattern::Ident(name, tok.span))
            }
            _ => {
                self.error(&format!("expected pattern, got {:?}", tok.kind));
                None
            }
        }
    }
}
