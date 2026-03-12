use crate::lexer::token::TokenKind;
use crate::parser::ast::*;
use crate::parser::parser::Parser;

impl Parser {
    /// Parse a trait declaration: `trait Name<T> : SuperTrait { fn method(...) -> Type { ... } }`
    pub(crate) fn parse_trait_decl(&mut self, exported: bool) -> Option<Statement> {
        let start = self.advance()?.span; // consume 'trait'
        self.skip_newlines();
        let name = self.expect_ident()?;
        self.skip_newlines();

        // Parse optional type parameters
        let type_params = if self.check(&TokenKind::Lt) {
            self.parse_type_params()?
        } else {
            Vec::new()
        };
        self.skip_newlines();

        // Parse optional super traits: trait Foo: Bar + Baz { ... }
        let mut super_traits = Vec::new();
        if self.check(&TokenKind::Colon) {
            self.advance();
            self.skip_newlines();
            let t = self.expect_ident()?;
            super_traits.push(t);
            while self.check(&TokenKind::Plus) {
                self.advance();
                self.skip_newlines();
                let t = self.expect_ident()?;
                super_traits.push(t);
            }
        }
        self.skip_newlines();

        self.expect(&TokenKind::LBrace)?;
        self.skip_newlines();

        let mut methods = Vec::new();
        while !self.check(&TokenKind::RBrace) && !self.is_at_end() {
            self.skip_newlines();
            if self.check(&TokenKind::RBrace) {
                break;
            }
            let mspan = self.current_span();
            self.expect(&TokenKind::Fn)?;
            self.skip_newlines();
            let mname = self.expect_ident()?;
            self.skip_newlines();
            self.expect(&TokenKind::LParen)?;
            let params = self.parse_params()?;
            self.expect(&TokenKind::RParen)?;
            self.skip_newlines();

            let return_type = if self.check(&TokenKind::Arrow) {
                self.advance();
                self.skip_newlines();
                Some(self.parse_type_expr()?)
            } else {
                None
            };
            self.skip_newlines();

            let default_body = if self.check(&TokenKind::LBrace) {
                Some(self.parse_block()?)
            } else {
                None
            };

            methods.push(TraitMethod {
                name: mname,
                params,
                return_type,
                default_body,
                span: mspan,
            });
            self.skip_newlines();
        }
        self.expect(&TokenKind::RBrace)?;

        Some(Statement::TraitDecl {
            name,
            type_params,
            super_traits,
            methods,
            exported,
            span: start,
        })
    }

    /// Parse an impl block: `impl Trait for Type { ... }` or `impl Type { ... }`
    pub(crate) fn parse_impl_block(&mut self) -> Option<Statement> {
        let start = self.advance()?.span; // consume 'impl'
        self.skip_newlines();

        // Parse: impl Trait for Type { ... } or impl Type { ... }
        let first_name = self.expect_ident()?;
        self.skip_newlines();

        // Parse optional type parameters after first name
        let type_params = if self.check(&TokenKind::Lt) {
            self.parse_type_params()?
        } else {
            Vec::new()
        };
        self.skip_newlines();

        let (trait_name, type_name) = if self.check(&TokenKind::For) {
            self.advance();
            self.skip_newlines();
            let tn = self.expect_ident()?;
            (Some(first_name), tn)
        } else {
            (None, first_name)
        };
        self.skip_newlines();

        self.expect(&TokenKind::LBrace)?;
        self.skip_newlines();

        let mut methods = Vec::new();
        let mut associated_types = Vec::new();

        while !self.check(&TokenKind::RBrace) && !self.is_at_end() {
            self.skip_newlines();
            if self.check(&TokenKind::RBrace) {
                break;
            }
            if self.check(&TokenKind::Type) {
                // Associated type: type Output = int
                self.advance();
                self.skip_newlines();
                let aname = self.expect_ident()?;
                self.skip_newlines();
                self.expect(&TokenKind::Eq)?;
                self.skip_newlines();
                let atype = self.parse_type_expr()?;
                associated_types.push((aname, atype));
            } else if self.check(&TokenKind::Fn) {
                let method = self.parse_fn_decl(false)?;
                methods.push(method);
            } else {
                self.error("expected fn or type in impl block");
                self.advance();
            }
            self.skip_newlines();
        }
        self.expect(&TokenKind::RBrace)?;

        Some(Statement::ImplBlock {
            trait_name,
            type_name,
            type_params,
            associated_types,
            methods,
            span: start,
        })
    }
}
