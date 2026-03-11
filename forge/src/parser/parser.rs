use crate::errors::Diagnostic;
use crate::lexer::token::{TemplatePart as LexTemplatePart, TokenKind};
use crate::lexer::{Lexer, Span, Token};
use crate::parser::ast::*;

pub struct Parser {
    tokens: Vec<Token>,
    pos: usize,
    diagnostics: Vec<Diagnostic>,
}

impl Parser {
    pub fn new(tokens: Vec<Token>) -> Self {
        Self {
            tokens,
            pos: 0,
            diagnostics: Vec::new(),
        }
    }

    pub fn diagnostics(&self) -> &[Diagnostic] {
        &self.diagnostics
    }

    pub fn parse_program(&mut self) -> Program {
        let mut statements = Vec::new();
        self.skip_newlines();
        while !self.is_at_end() {
            if let Some(stmt) = self.parse_statement() {
                statements.push(stmt);
            }
            self.skip_newlines();
        }
        Program { statements }
    }

    fn parse_statement(&mut self) -> Option<Statement> {
        self.skip_newlines();
        let tok = self.peek()?;
        match &tok.kind {
            TokenKind::Let => self.parse_let(),
            TokenKind::Mut => self.parse_mut(),
            TokenKind::Const => self.parse_const(),
            TokenKind::Fn => self.parse_fn_decl(false),
            TokenKind::Export => self.parse_export(),
            TokenKind::Enum => self.parse_enum_decl(false),
            TokenKind::Type => self.parse_type_decl(false),
            TokenKind::Use => self.parse_use(),
            TokenKind::Trait => self.parse_trait_decl(false),
            TokenKind::Impl => self.parse_impl_block(),
            TokenKind::Return => self.parse_return(),
            TokenKind::For => self.parse_for(),
            TokenKind::While => self.parse_while(),
            TokenKind::Loop => self.parse_loop(),
            TokenKind::Break => self.parse_break(),
            TokenKind::Continue => self.parse_continue(),
            TokenKind::Defer => self.parse_defer(),
            TokenKind::Ident(name) => {
                match name.as_str() {
                    "extern" => self.parse_extern_fn(),
                    "model" => self.parse_model_decl(),
                    "service" => self.parse_service_decl(),
                    "server" => self.parse_server_block(),
                    "assert" => self.parse_assert(),
                    _ => self.parse_expr_statement(),
                }
            }
            _ => self.parse_expr_statement(),
        }
    }

    fn parse_let_with_export(&mut self, exported: bool) -> Option<Statement> {
        let start = self.advance()?.span; // consume 'let'
        self.skip_newlines();

        // Check for destructuring patterns
        if self.check(&TokenKind::LParen) {
            return self.parse_tuple_destructure(start, false);
        }
        if self.check(&TokenKind::LBrace) {
            return self.parse_struct_destructure(start, false);
        }
        if self.check(&TokenKind::LBracket) {
            return self.parse_list_destructure(start, false);
        }

        let name = self.expect_ident()?;
        let type_ann = if self.check(&TokenKind::Colon) {
            self.advance();
            self.skip_newlines();
            Some(self.parse_type_expr()?)
        } else {
            None
        };
        self.skip_newlines();
        self.expect(&TokenKind::Eq)?;
        self.skip_newlines();
        let value = self.parse_expr()?;
        Some(Statement::Let {
            name,
            type_ann,
            value,
            exported,
            span: start,
        })
    }

    fn parse_let(&mut self) -> Option<Statement> {
        self.parse_let_with_export(false)
    }

    fn parse_tuple_destructure(
        &mut self,
        start: Span,
        _mutable: bool,
    ) -> Option<Statement> {
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

        Some(Statement::LetDestructure {
            pattern: Pattern::Tuple(patterns, start),
            value,
            span: start,
        })
    }

    fn parse_struct_destructure(
        &mut self,
        start: Span,
        _mutable: bool,
    ) -> Option<Statement> {
        self.advance(); // {
        self.skip_newlines();
        let mut fields = Vec::new();
        loop {
            self.skip_newlines();
            if self.check(&TokenKind::RBrace) {
                break;
            }
            let name = self.expect_ident()?;
            let span = self.tokens[self.pos.saturating_sub(1)].span;
            // Shorthand: { x } means { x: x }
            fields.push((name.clone(), Pattern::Ident(name, span)));
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

        Some(Statement::LetDestructure {
            pattern: Pattern::Struct {
                fields,
                rest: false,
                span: start,
            },
            value,
            span: start,
        })
    }

    fn parse_list_destructure(
        &mut self,
        start: Span,
        _mutable: bool,
    ) -> Option<Statement> {
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

        Some(Statement::LetDestructure {
            pattern: Pattern::List {
                elements,
                rest: rest_name,
                span: start,
            },
            value,
            span: start,
        })
    }

    fn parse_mut_with_export(&mut self, exported: bool) -> Option<Statement> {
        let start = self.advance()?.span;
        self.skip_newlines();
        let name = self.expect_ident()?;
        let type_ann = if self.check(&TokenKind::Colon) {
            self.advance();
            self.skip_newlines();
            Some(self.parse_type_expr()?)
        } else {
            None
        };
        self.skip_newlines();
        self.expect(&TokenKind::Eq)?;
        self.skip_newlines();
        let value = self.parse_expr()?;
        Some(Statement::Mut {
            name,
            type_ann,
            value,
            exported,
            span: start,
        })
    }

    fn parse_mut(&mut self) -> Option<Statement> {
        self.parse_mut_with_export(false)
    }

    fn parse_const_with_export(&mut self, exported: bool) -> Option<Statement> {
        let start = self.advance()?.span;
        self.skip_newlines();
        let name = self.expect_ident()?;
        let type_ann = if self.check(&TokenKind::Colon) {
            self.advance();
            self.skip_newlines();
            Some(self.parse_type_expr()?)
        } else {
            None
        };
        self.skip_newlines();
        self.expect(&TokenKind::Eq)?;
        self.skip_newlines();
        let value = self.parse_expr()?;
        Some(Statement::Const {
            name,
            type_ann,
            value,
            exported,
            span: start,
        })
    }

    fn parse_const(&mut self) -> Option<Statement> {
        self.parse_const_with_export(false)
    }

    fn parse_fn_decl(&mut self, exported: bool) -> Option<Statement> {
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
        let body = self.parse_block()?;

        Some(Statement::FnDecl {
            name,
            type_params,
            params,
            return_type,
            body,
            exported,
            span: start,
        })
    }

    fn parse_extern_fn(&mut self) -> Option<Statement> {
        let start = self.advance()?.span; // consume 'extern'
        self.skip_newlines();

        // Expect 'fn' keyword
        if !self.check(&TokenKind::Fn) {
            self.error("expected 'fn' after 'extern'");
            return None;
        }
        self.advance(); // consume 'fn'
        self.skip_newlines();

        let name = self.expect_ident()?;
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

        Some(Statement::ExternFn {
            name,
            params,
            return_type,
            span: start,
        })
    }

    fn parse_export(&mut self) -> Option<Statement> {
        self.advance(); // consume 'export'
        self.skip_newlines();
        let tok = self.peek()?;
        match &tok.kind {
            TokenKind::Fn => self.parse_fn_decl(true),
            TokenKind::Enum => self.parse_enum_decl(true),
            TokenKind::Type => self.parse_type_decl(true),
            TokenKind::Let => self.parse_let_with_export(true),
            TokenKind::Mut => self.parse_mut_with_export(true),
            TokenKind::Const => self.parse_const_with_export(true),
            TokenKind::Trait => self.parse_trait_decl(true),
            _ => {
                self.error("expected fn, enum, type, let, mut, const, or trait after export");
                None
            }
        }
    }

    fn parse_enum_decl(&mut self, exported: bool) -> Option<Statement> {
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

        Some(Statement::EnumDecl {
            name,
            variants,
            exported,
            span: start,
        })
    }

    fn parse_type_decl(&mut self, exported: bool) -> Option<Statement> {
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

        Some(Statement::TypeDecl {
            name,
            type_params,
            value,
            exported,
            span: start,
        })
    }

    fn parse_return(&mut self) -> Option<Statement> {
        let start = self.advance()?.span;
        let value = if self.is_at_end()
            || self.check(&TokenKind::Newline)
            || self.check(&TokenKind::RBrace)
        {
            None
        } else {
            Some(self.parse_expr()?)
        };
        Some(Statement::Return { value, span: start })
    }

    fn parse_for(&mut self) -> Option<Statement> {
        let start = self.advance()?.span; // consume 'for'
        self.skip_newlines();
        let pattern = self.parse_simple_pattern()?;
        self.skip_newlines();
        self.expect(&TokenKind::In)?;
        self.skip_newlines();
        let iterable = self.parse_expr()?;
        self.skip_newlines();
        let body = self.parse_block()?;
        Some(Statement::For {
            pattern,
            iterable,
            body,
            span: start,
        })
    }

    fn parse_while(&mut self) -> Option<Statement> {
        let start = self.advance()?.span;
        self.skip_newlines();
        let condition = self.parse_expr()?;
        self.skip_newlines();
        let body = self.parse_block()?;
        Some(Statement::While {
            condition,
            body,
            span: start,
        })
    }

    fn parse_loop(&mut self) -> Option<Statement> {
        let start = self.advance()?.span;
        self.skip_newlines();
        let body = self.parse_block()?;
        Some(Statement::Loop {
            body,
            label: None,
            span: start,
        })
    }

    fn parse_break(&mut self) -> Option<Statement> {
        let start = self.advance()?.span;
        let value = if self.is_at_end()
            || self.check(&TokenKind::Newline)
            || self.check(&TokenKind::RBrace)
        {
            None
        } else {
            Some(self.parse_expr()?)
        };
        Some(Statement::Break {
            value,
            label: None,
            span: start,
        })
    }

    fn parse_continue(&mut self) -> Option<Statement> {
        let start = self.advance()?.span;
        Some(Statement::Continue {
            label: None,
            span: start,
        })
    }

    fn parse_defer(&mut self) -> Option<Statement> {
        let start = self.advance()?.span;
        self.skip_newlines();
        let body = self.parse_expr()?;
        Some(Statement::Defer {
            body,
            span: start,
        })
    }

    fn parse_use(&mut self) -> Option<Statement> {
        let start = self.advance()?.span; // consume 'use'
        self.skip_newlines();

        // Parse dotted path: use math.add or use math.{add, multiply}
        // Also handle @std.model.{...} where @ prefixes a built-in scope
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

            // Check for { item, item } import list
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

            // Otherwise it's a path segment
            let segment = self.expect_ident()?;
            path.push(segment);
        }

        Some(Statement::Use {
            path,
            items,
            span: start,
        })
    }

    fn parse_type_params(&mut self) -> Option<Vec<TypeParam>> {
        self.advance(); // consume '<'
        self.skip_newlines();
        let mut params = Vec::new();
        loop {
            self.skip_newlines();
            if self.check(&TokenKind::Gt) {
                break;
            }
            let name = self.expect_ident()?;
            self.skip_newlines();
            let mut bounds = Vec::new();
            if self.check(&TokenKind::Colon) {
                self.advance();
                self.skip_newlines();
                // Parse bounds: T: Clone + Display
                let bound = self.expect_ident()?;
                bounds.push(bound);
                while self.check(&TokenKind::Plus) {
                    self.advance();
                    self.skip_newlines();
                    let bound = self.expect_ident()?;
                    bounds.push(bound);
                }
            }
            params.push(TypeParam { name, bounds });
            self.skip_newlines();
            if self.check(&TokenKind::Comma) {
                self.advance();
            }
        }
        self.expect(&TokenKind::Gt)?;
        Some(params)
    }

    fn parse_trait_decl(&mut self, exported: bool) -> Option<Statement> {
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

    fn parse_impl_block(&mut self) -> Option<Statement> {
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

    fn parse_expr_statement(&mut self) -> Option<Statement> {
        let expr = self.parse_expr()?;

        // Check for assignment
        if self.check(&TokenKind::Eq) {
            let span = self.advance()?.span;
            self.skip_newlines();
            let value = self.parse_expr()?;
            return Some(Statement::Assign {
                target: expr,
                value,
                span,
            });
        }

        Some(Statement::Expr(expr))
    }

    // ---- Expression parsing (Pratt parser) ----

    fn parse_expr(&mut self) -> Option<Expr> {
        self.parse_pipe()
    }

    fn parse_pipe(&mut self) -> Option<Expr> {
        let mut left = self.parse_null_coalesce()?;

        while self.check(&TokenKind::Pipe) {
            let span = self.advance()?.span;
            self.skip_newlines();
            let right = self.parse_null_coalesce()?;
            left = Expr::Pipe {
                left: Box::new(left),
                right: Box::new(right),
                span,
            };
        }

        // Check for `catch`
        if self.check(&TokenKind::Catch) {
            let cspan = self.advance()?.span;
            self.skip_newlines();
            let binding = if self.check(&TokenKind::LParen) {
                self.advance();
                self.skip_newlines();
                let name = self.expect_ident()?;
                self.skip_newlines();
                self.expect(&TokenKind::RParen)?;
                self.skip_newlines();
                Some(name)
            } else {
                None
            };
            let handler = self.parse_block()?;
            left = Expr::Catch {
                expr: Box::new(left),
                binding,
                handler,
                span: cspan,
            };
        }

        // Check for `with`
        if self.check(&TokenKind::With) {
            let wspan = self.advance()?.span;
            self.skip_newlines();
            self.expect(&TokenKind::LBrace)?;
            self.skip_newlines();
            let mut updates = Vec::new();
            loop {
                self.skip_newlines();
                if self.check(&TokenKind::RBrace) {
                    break;
                }
                let field = self.expect_ident()?;
                self.skip_newlines();
                self.expect(&TokenKind::Colon)?;
                self.skip_newlines();
                let value = self.parse_expr()?;
                updates.push((field, value));
                self.skip_newlines();
                if self.check(&TokenKind::Comma) {
                    self.advance();
                }
            }
            self.expect(&TokenKind::RBrace)?;
            left = Expr::With {
                base: Box::new(left),
                updates,
                span: wspan,
            };
        }

        Some(left)
    }

    fn parse_null_coalesce(&mut self) -> Option<Expr> {
        let mut left = self.parse_or()?;

        while self.check(&TokenKind::DoubleQuestion) {
            let span = self.advance()?.span;
            self.skip_newlines();
            let right = self.parse_or()?;
            left = Expr::NullCoalesce {
                left: Box::new(left),
                right: Box::new(right),
                span,
            };
        }
        Some(left)
    }

    fn parse_or(&mut self) -> Option<Expr> {
        let mut left = self.parse_and()?;
        while self.check(&TokenKind::Or) {
            let span = self.advance()?.span;
            self.skip_newlines();
            let right = self.parse_and()?;
            left = Expr::Binary {
                left: Box::new(left),
                op: BinaryOp::Or,
                right: Box::new(right),
                span,
            };
        }
        Some(left)
    }

    fn parse_and(&mut self) -> Option<Expr> {
        let mut left = self.parse_equality()?;
        while self.check(&TokenKind::And) {
            let span = self.advance()?.span;
            self.skip_newlines();
            let right = self.parse_equality()?;
            left = Expr::Binary {
                left: Box::new(left),
                op: BinaryOp::And,
                right: Box::new(right),
                span,
            };
        }
        Some(left)
    }

    fn parse_equality(&mut self) -> Option<Expr> {
        let mut left = self.parse_comparison()?;
        loop {
            let op = if self.check(&TokenKind::EqEq) {
                BinaryOp::Eq
            } else if self.check(&TokenKind::NotEq) {
                BinaryOp::NotEq
            } else {
                break;
            };
            let span = self.advance()?.span;
            self.skip_newlines();
            let right = self.parse_comparison()?;
            left = Expr::Binary {
                left: Box::new(left),
                op,
                right: Box::new(right),
                span,
            };
        }
        Some(left)
    }

    fn parse_comparison(&mut self) -> Option<Expr> {
        let mut left = self.parse_range()?;
        loop {
            let op = if self.check(&TokenKind::Lt) {
                BinaryOp::Lt
            } else if self.check(&TokenKind::LtEq) {
                BinaryOp::LtEq
            } else if self.check(&TokenKind::Gt) {
                BinaryOp::Gt
            } else if self.check(&TokenKind::GtEq) {
                BinaryOp::GtEq
            } else {
                break;
            };
            let span = self.advance()?.span;
            self.skip_newlines();
            let right = self.parse_range()?;
            left = Expr::Binary {
                left: Box::new(left),
                op,
                right: Box::new(right),
                span,
            };
        }
        Some(left)
    }

    fn parse_range(&mut self) -> Option<Expr> {
        let left = self.parse_addition()?;

        if self.check(&TokenKind::DotDot) {
            let span = self.advance()?.span;
            self.skip_newlines();
            let right = self.parse_addition()?;
            return Some(Expr::Range {
                start: Box::new(left),
                end: Box::new(right),
                inclusive: false,
                span,
            });
        }
        if self.check(&TokenKind::DotDotEq) {
            let span = self.advance()?.span;
            self.skip_newlines();
            let right = self.parse_addition()?;
            return Some(Expr::Range {
                start: Box::new(left),
                end: Box::new(right),
                inclusive: true,
                span,
            });
        }
        Some(left)
    }

    fn parse_addition(&mut self) -> Option<Expr> {
        let mut left = self.parse_multiplication()?;
        loop {
            let op = if self.check(&TokenKind::Plus) {
                BinaryOp::Add
            } else if self.check(&TokenKind::Minus) {
                BinaryOp::Sub
            } else {
                break;
            };
            let span = self.advance()?.span;
            self.skip_newlines();
            let right = self.parse_multiplication()?;
            left = Expr::Binary {
                left: Box::new(left),
                op,
                right: Box::new(right),
                span,
            };
        }
        Some(left)
    }

    fn parse_multiplication(&mut self) -> Option<Expr> {
        let mut left = self.parse_unary()?;
        loop {
            let op = if self.check(&TokenKind::Star) {
                BinaryOp::Mul
            } else if self.check(&TokenKind::Slash) {
                BinaryOp::Div
            } else if self.check(&TokenKind::Percent) {
                BinaryOp::Mod
            } else {
                break;
            };
            let span = self.advance()?.span;
            self.skip_newlines();
            let right = self.parse_unary()?;
            left = Expr::Binary {
                left: Box::new(left),
                op,
                right: Box::new(right),
                span,
            };
        }
        Some(left)
    }

    fn parse_unary(&mut self) -> Option<Expr> {
        if self.check(&TokenKind::Not) {
            let span = self.advance()?.span;
            self.skip_newlines();
            let operand = self.parse_unary()?;
            return Some(Expr::Unary {
                op: UnaryOp::Not,
                operand: Box::new(operand),
                span,
            });
        }
        if self.check(&TokenKind::Minus) {
            let span = self.advance()?.span;
            self.skip_newlines();
            let operand = self.parse_unary()?;
            return Some(Expr::Unary {
                op: UnaryOp::Neg,
                operand: Box::new(operand),
                span,
            });
        }
        self.parse_postfix()
    }

    fn parse_postfix(&mut self) -> Option<Expr> {
        let mut expr = self.parse_primary()?;

        loop {
            if self.check(&TokenKind::LParen) {
                let span = self.advance()?.span;
                self.skip_newlines();
                let mut args = Vec::new();
                while !self.check(&TokenKind::RParen) && !self.is_at_end() {
                    self.skip_newlines();
                    let arg = self.parse_call_arg()?;
                    args.push(arg);
                    self.skip_newlines();
                    if self.check(&TokenKind::Comma) {
                        self.advance();
                    }
                }
                self.expect(&TokenKind::RParen)?;
                expr = Expr::Call {
                    callee: Box::new(expr),
                    args,
                    span,
                };
            } else if self.check(&TokenKind::LBrace) {
                // Named struct literal: TypeName { field: val, ... }
                // Only if expr is a simple Ident (type name) and it looks like a struct literal
                if let Expr::Ident(ref type_name, ident_span) = expr {
                    // Peek inside the brace: if ident : then it's a named struct literal
                    if self.peek_at(1).map(|t| matches!(&t.kind, TokenKind::Ident(_))).unwrap_or(false)
                        && self.peek_at(2).map(|t| matches!(&t.kind, TokenKind::Colon)).unwrap_or(false)
                    {
                        let span = self.advance()?.span; // {
                        self.skip_newlines();
                        let mut fields = Vec::new();
                        loop {
                            self.skip_newlines();
                            if self.check(&TokenKind::RBrace) {
                                break;
                            }
                            let fname = self.expect_ident()?;
                            self.skip_newlines();
                            self.expect(&TokenKind::Colon)?;
                            self.skip_newlines();
                            let fval = self.parse_expr()?;
                            fields.push((fname, fval));
                            self.skip_newlines();
                            if self.check(&TokenKind::Comma) {
                                self.advance();
                            }
                        }
                        self.expect(&TokenKind::RBrace)?;
                        expr = Expr::StructLit {
                            name: Some(type_name.clone()),
                            fields,
                            span: ident_span,
                        };
                        continue;
                    }
                }
                break;
            } else if self.check(&TokenKind::Dot)
                || (Self::is_chainable_expr(&expr) && self.next_meaningful_is(&TokenKind::Dot))
            {
                self.skip_newlines();
                let span = self.advance()?.span; // consume '.'
                // Handle numeric tuple field access: p.0, p.1
                if let Some(tok) = self.peek() {
                    if let TokenKind::IntLiteral(n) = &tok.kind {
                        let field = n.to_string();
                        self.advance();
                        expr = Expr::MemberAccess {
                            object: Box::new(expr),
                            field,
                            span,
                        };
                        continue;
                    }
                }
                let field = self.expect_ident()?;
                expr = Expr::MemberAccess {
                    object: Box::new(expr),
                    field,
                    span,
                };
            } else if self.check(&TokenKind::QuestionDot) {
                let span = self.advance()?.span;
                let field = self.expect_ident()?;
                expr = Expr::NullPropagate {
                    object: Box::new(expr),
                    field,
                    span,
                };
            } else if self.check(&TokenKind::LBracket) {
                let span = self.advance()?.span;
                self.skip_newlines();
                let index = self.parse_expr()?;
                self.skip_newlines();
                self.expect(&TokenKind::RBracket)?;
                expr = Expr::Index {
                    object: Box::new(expr),
                    index: Box::new(index),
                    span,
                };
            } else if self.check(&TokenKind::Question) {
                // Error propagation: expr?
                let span = self.advance()?.span;
                expr = Expr::ErrorPropagate {
                    operand: Box::new(expr),
                    span,
                };
            } else {
                break;
            }
        }

        Some(expr)
    }

    fn parse_call_arg(&mut self) -> Option<CallArg> {
        // Check for named argument: `name: value`
        if let Some(TokenKind::Ident(name)) = self.peek().map(|t| &t.kind).cloned() {
            if self.peek_at(1).map(|t| &t.kind) == Some(&TokenKind::Colon) {
                let name = name.clone();
                self.advance(); // ident
                self.advance(); // :
                self.skip_newlines();
                let value = self.parse_expr()?;
                return Some(CallArg {
                    name: Some(name),
                    value,
                });
            }
        }

        let value = self.parse_expr()?;

        // If the expression references `it`, wrap it in a closure: (it) -> <expr>
        if Self::expr_contains_it(&value) {
            let span = value.span();
            let closure = Expr::Closure {
                params: vec![Param {
                    name: "it".to_string(),
                    type_ann: None,
                    default: None,
                    span,
                }],
                body: Box::new(value),
                span,
            };
            return Some(CallArg { name: None, value: closure });
        }

        Some(CallArg { name: None, value })
    }

    fn expr_contains_it(expr: &Expr) -> bool {
        match expr {
            Expr::Ident(name, _) => name == "it",
            Expr::Binary { left, right, .. } => {
                Self::expr_contains_it(left) || Self::expr_contains_it(right)
            }
            Expr::Unary { operand, .. } => Self::expr_contains_it(operand),
            Expr::Call { callee, args, .. } => {
                Self::expr_contains_it(callee)
                    || args.iter().any(|a| Self::expr_contains_it(&a.value))
            }
            Expr::MemberAccess { object, .. } => Self::expr_contains_it(object),
            Expr::Index { object, index, .. } => {
                Self::expr_contains_it(object) || Self::expr_contains_it(index)
            }
            Expr::Pipe { left, right, .. } => {
                Self::expr_contains_it(left) || Self::expr_contains_it(right)
            }
            Expr::NullCoalesce { left, right, .. } => {
                Self::expr_contains_it(left) || Self::expr_contains_it(right)
            }
            Expr::NullPropagate { object, .. } => Self::expr_contains_it(object),
            Expr::ErrorPropagate { operand, .. } => Self::expr_contains_it(operand),
            // Don't look inside closures - `it` there is already bound
            Expr::Closure { .. } => false,
            _ => false,
        }
    }

    fn parse_primary(&mut self) -> Option<Expr> {
        let tok = self.peek()?.clone();
        match &tok.kind {
            TokenKind::IntLiteral(n) => {
                let n = *n;
                self.advance();
                Some(Expr::IntLit(n, tok.span))
            }
            TokenKind::FloatLiteral(f) => {
                let f = *f;
                self.advance();
                Some(Expr::FloatLit(f, tok.span))
            }
            TokenKind::StringLiteral(s) => {
                let s = s.clone();
                self.advance();
                Some(Expr::StringLit(s, tok.span))
            }
            TokenKind::TemplateLiteral(parts) => {
                let parts = parts.clone();
                let span = tok.span;
                self.advance();
                self.parse_template_parts(parts, span)
            }
            TokenKind::BoolLiteral(b) => {
                let b = *b;
                self.advance();
                Some(Expr::BoolLit(b, tok.span))
            }
            TokenKind::NullLiteral => {
                self.advance();
                Some(Expr::NullLit(tok.span))
            }
            TokenKind::Ok_ => {
                let span = self.advance()?.span;
                self.expect(&TokenKind::LParen)?;
                self.skip_newlines();
                let value = self.parse_expr()?;
                self.skip_newlines();
                self.expect(&TokenKind::RParen)?;
                Some(Expr::OkExpr {
                    value: Box::new(value),
                    span,
                })
            }
            TokenKind::Err_ => {
                let span = self.advance()?.span;
                self.expect(&TokenKind::LParen)?;
                self.skip_newlines();
                let value = self.parse_expr()?;
                self.skip_newlines();
                self.expect(&TokenKind::RParen)?;
                Some(Expr::ErrExpr {
                    value: Box::new(value),
                    span,
                })
            }
            TokenKind::Ident(_) => self.parse_ident_expr(),
            TokenKind::LParen => self.parse_paren_expr(),
            TokenKind::LBrace => self.parse_brace_expr(),
            TokenKind::LBracket => self.parse_list_expr(),
            TokenKind::If => self.parse_if_expr(),
            TokenKind::Match => self.parse_match_expr(),
            TokenKind::Dot => {
                // Enum variant shorthand: .variant
                let span = self.advance()?.span;
                let variant = self.expect_ident()?;
                // Check for constructor args
                if self.check(&TokenKind::LParen) {
                    self.advance();
                    self.skip_newlines();
                    let mut fields = Vec::new();
                    while !self.check(&TokenKind::RParen) && !self.is_at_end() {
                        self.skip_newlines();
                        // Pattern binding in match: just names
                        let name = self.expect_ident()?;
                        fields.push(Pattern::Ident(name, span));
                        self.skip_newlines();
                        if self.check(&TokenKind::Comma) {
                            self.advance();
                        }
                    }
                    self.expect(&TokenKind::RParen)?;
                    // This is used in match arms, return as Ident for now
                    // We'll handle it specially in the match pattern parsing
                    return Some(Expr::Ident(format!(".{}", variant), span));
                }
                Some(Expr::Ident(format!(".{}", variant), span))
            }
            _ => {
                self.error(&format!("expected expression, got {:?}", tok.kind));
                self.advance();
                None
            }
        }
    }

    fn parse_template_parts(
        &mut self,
        lex_parts: Vec<LexTemplatePart>,
        span: Span,
    ) -> Option<Expr> {
        let mut parts = Vec::new();
        for part in lex_parts {
            match part {
                LexTemplatePart::Literal(s) => {
                    parts.push(TemplatePart::Literal(s));
                }
                LexTemplatePart::Expr(expr_text) => {
                    let mut lexer = Lexer::new(&expr_text);
                    let tokens = lexer.tokenize();
                    let mut parser = Parser::new(tokens);
                    if let Some(expr) = parser.parse_expr() {
                        parts.push(TemplatePart::Expr(Box::new(expr)));
                    }
                    self.diagnostics.extend(parser.diagnostics.into_iter());
                }
            }
        }
        Some(Expr::TemplateLit { parts, span })
    }

    fn parse_ident_expr(&mut self) -> Option<Expr> {
        let tok = self.advance()?;
        let name = if let TokenKind::Ident(n) = &tok.kind {
            n.clone()
        } else {
            unreachable!()
        };
        let span = tok.span;

        // Check for closure: `x -> expr` (single param, no type, no parens)
        if self.check(&TokenKind::Arrow) {
            self.advance();
            self.skip_newlines();
            let body = self.parse_expr()?;
            return Some(Expr::Closure {
                params: vec![Param {
                    name: name.clone(),
                    type_ann: None,
                    default: None,
                    span,
                }],
                body: Box::new(body),
                span,
            });
        }

        Some(Expr::Ident(name, span))
    }

    fn parse_paren_expr(&mut self) -> Option<Expr> {
        let span = self.advance()?.span; // (
        self.skip_newlines();

        // Empty parens -> unit/void
        if self.check(&TokenKind::RParen) {
            self.advance();
            return Some(Expr::TupleLit {
                elements: vec![],
                span,
            });
        }

        // Check for closure: (params) -> body
        if self.looks_like_closure_params() {
            return self.parse_closure(span);
        }

        // Parse first expression
        let first = self.parse_expr()?;
        self.skip_newlines();

        if self.check(&TokenKind::Comma) {
            // Tuple literal
            self.advance();
            self.skip_newlines();
            let mut elements = vec![first];
            while !self.check(&TokenKind::RParen) && !self.is_at_end() {
                let elem = self.parse_expr()?;
                elements.push(elem);
                self.skip_newlines();
                if self.check(&TokenKind::Comma) {
                    self.advance();
                    self.skip_newlines();
                }
            }
            self.expect(&TokenKind::RParen)?;
            Some(Expr::TupleLit {
                elements,
                span,
            })
        } else {
            self.expect(&TokenKind::RParen)?;
            Some(first) // parenthesized expression
        }
    }

    fn looks_like_closure_params(&self) -> bool {
        // Look ahead to see if this is (name: type, ...) -> or (name) {
        let mut i = self.pos;
        let mut depth = 1;
        while i < self.tokens.len() && depth > 0 {
            match &self.tokens[i].kind {
                TokenKind::LParen => depth += 1,
                TokenKind::RParen => {
                    depth -= 1;
                    if depth == 0 {
                        // Check if followed by -> or {
                        let mut next = i + 1;
                        // Skip newlines
                        while next < self.tokens.len() && self.tokens[next].kind == TokenKind::Newline {
                            next += 1;
                        }
                        if next < self.tokens.len() {
                            return self.tokens[next].kind == TokenKind::Arrow
                                || self.tokens[next].kind == TokenKind::LBrace;
                        }
                    }
                }
                _ => {}
            }
            i += 1;
        }
        false
    }

    fn parse_closure(&mut self, span: Span) -> Option<Expr> {
        // We're past the opening '(' already
        let params = self.parse_params()?;
        self.expect(&TokenKind::RParen)?;
        self.skip_newlines();
        // Support both (params) -> body and (params) { body }
        if self.check(&TokenKind::Arrow) {
            self.advance();
            self.skip_newlines();
            let body = self.parse_expr()?;
            Some(Expr::Closure {
                params,
                body: Box::new(body),
                span,
            })
        } else {
            // (params) { body } form
            let body = self.parse_expr()?;
            Some(Expr::Closure {
                params,
                body: Box::new(body),
                span,
            })
        }
    }

    fn parse_brace_expr(&mut self) -> Option<Expr> {
        let span = self.advance()?.span; // {
        self.skip_newlines();

        // Check if this is a map literal { "key": value, ... }
        if self.is_map_literal() {
            return self.parse_map_literal(span);
        }

        // Check if this is a struct literal { field: value, ... } or a block
        if self.is_struct_literal() {
            return self.parse_struct_literal(span);
        }

        // Block
        let mut statements = Vec::new();
        while !self.check(&TokenKind::RBrace) && !self.is_at_end() {
            self.skip_newlines();
            if self.check(&TokenKind::RBrace) {
                break;
            }
            if let Some(stmt) = self.parse_statement() {
                statements.push(stmt);
            }
            self.skip_newlines();
        }
        self.expect(&TokenKind::RBrace)?;
        Some(Expr::Block(Block {
            statements,
            span,
        }))
    }

    fn is_struct_literal(&self) -> bool {
        // { ident : expr } is struct literal
        if let Some(TokenKind::Ident(_)) = self.peek().map(|t| &t.kind) {
            if let Some(TokenKind::Colon) = self.peek_at(1).map(|t| &t.kind) {
                return true;
            }
        }
        false
    }

    fn is_map_literal(&self) -> bool {
        // { "string" : expr } is map literal
        if let Some(TokenKind::StringLiteral(_)) = self.peek().map(|t| &t.kind) {
            if let Some(TokenKind::Colon) = self.peek_at(1).map(|t| &t.kind) {
                return true;
            }
        }
        false
    }

    fn parse_struct_literal(&mut self, span: Span) -> Option<Expr> {
        let mut fields = Vec::new();
        loop {
            self.skip_newlines();
            if self.check(&TokenKind::RBrace) {
                break;
            }
            let name = self.expect_ident()?;
            self.skip_newlines();
            self.expect(&TokenKind::Colon)?;
            self.skip_newlines();
            let value = self.parse_expr()?;
            fields.push((name, value));
            self.skip_newlines();
            if self.check(&TokenKind::Comma) {
                self.advance();
            }
        }
        self.expect(&TokenKind::RBrace)?;
        Some(Expr::StructLit {
            name: None,
            fields,
            span,
        })
    }

    fn parse_map_literal(&mut self, span: Span) -> Option<Expr> {
        let mut entries = Vec::new();
        loop {
            self.skip_newlines();
            if self.check(&TokenKind::RBrace) {
                break;
            }
            let key = self.parse_expr()?;
            self.skip_newlines();
            self.expect(&TokenKind::Colon)?;
            self.skip_newlines();
            let value = self.parse_expr()?;
            entries.push((key, value));
            self.skip_newlines();
            if self.check(&TokenKind::Comma) {
                self.advance();
            }
        }
        self.expect(&TokenKind::RBrace)?;
        Some(Expr::MapLit {
            entries,
            span,
        })
    }

    fn parse_list_expr(&mut self) -> Option<Expr> {
        let span = self.advance()?.span; // [
        self.skip_newlines();
        let mut elements = Vec::new();
        while !self.check(&TokenKind::RBracket) && !self.is_at_end() {
            self.skip_newlines();
            let elem = self.parse_expr()?;
            elements.push(elem);
            self.skip_newlines();
            if self.check(&TokenKind::Comma) {
                self.advance();
            }
        }
        self.expect(&TokenKind::RBracket)?;
        Some(Expr::ListLit {
            elements,
            span,
        })
    }

    fn parse_if_expr(&mut self) -> Option<Expr> {
        let span = self.advance()?.span; // if
        self.skip_newlines();
        let condition = self.parse_expr()?;
        self.skip_newlines();
        let then_branch = self.parse_block()?;
        self.skip_newlines();
        let else_branch = if self.check(&TokenKind::Else) {
            self.advance();
            self.skip_newlines();
            if self.check(&TokenKind::If) {
                // else if -> wrap in a block containing the if
                let inner_if = self.parse_if_expr()?;
                let block_span = inner_if.span();
                Some(Block {
                    statements: vec![Statement::Expr(inner_if)],
                    span: block_span,
                })
            } else {
                Some(self.parse_block()?)
            }
        } else {
            None
        };

        Some(Expr::If {
            condition: Box::new(condition),
            then_branch,
            else_branch,
            span,
        })
    }

    fn parse_match_expr(&mut self) -> Option<Expr> {
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

    fn parse_match_arm(&mut self) -> Option<MatchArm> {
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
        let body = self.parse_expr()?;
        self.skip_newlines();

        // Optional newline separator
        Some(MatchArm {
            pattern,
            guard,
            body,
            span,
        })
    }

    fn parse_pattern(&mut self) -> Option<Pattern> {
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

    fn parse_simple_pattern(&mut self) -> Option<Pattern> {
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

    // ---- Type expressions ----

    fn parse_type_expr(&mut self) -> Option<TypeExpr> {
        let mut ty = self.parse_primary_type()?;

        // Check for nullable
        if self.check(&TokenKind::Question) {
            self.advance();
            ty = TypeExpr::Nullable(Box::new(ty));
        }

        Some(ty)
    }

    fn parse_primary_type(&mut self) -> Option<TypeExpr> {
        let tok = self.peek()?.clone();
        match &tok.kind {
            TokenKind::Ident(name) => {
                let name = name.clone();
                self.advance();

                // Check for generic args: Name<T, U>
                if self.check(&TokenKind::Lt) {
                    self.advance();
                    self.skip_newlines();
                    let mut args = Vec::new();
                    loop {
                        self.skip_newlines();
                        if self.check(&TokenKind::Gt) {
                            break;
                        }
                        let arg = self.parse_type_expr()?;
                        args.push(arg);
                        self.skip_newlines();
                        if self.check(&TokenKind::Comma) {
                            self.advance();
                        }
                    }
                    self.expect(&TokenKind::Gt)?;
                    Some(TypeExpr::Generic { name, args })
                } else {
                    Some(TypeExpr::Named(name))
                }
            }
            TokenKind::LParen => {
                // Tuple type or function type: (int, string) or (int, int) -> int
                self.advance();
                self.skip_newlines();
                let mut types = Vec::new();
                while !self.check(&TokenKind::RParen) && !self.is_at_end() {
                    self.skip_newlines();
                    let ty = self.parse_type_expr()?;
                    types.push(ty);
                    self.skip_newlines();
                    if self.check(&TokenKind::Comma) {
                        self.advance();
                    }
                }
                self.expect(&TokenKind::RParen)?;
                self.skip_newlines();

                if self.check(&TokenKind::Arrow) {
                    self.advance();
                    self.skip_newlines();
                    let return_type = self.parse_type_expr()?;
                    Some(TypeExpr::Function {
                        params: types,
                        return_type: Box::new(return_type),
                    })
                } else {
                    Some(TypeExpr::Tuple(types))
                }
            }
            TokenKind::LBrace => {
                // Struct type: { name: string, age: int }
                self.advance();
                self.skip_newlines();
                let mut fields = Vec::new();
                while !self.check(&TokenKind::RBrace) && !self.is_at_end() {
                    self.skip_newlines();
                    let name = self.expect_ident()?;
                    self.skip_newlines();
                    self.expect(&TokenKind::Colon)?;
                    self.skip_newlines();
                    let ty = self.parse_type_expr()?;
                    fields.push((name, ty));
                    self.skip_newlines();
                    if self.check(&TokenKind::Comma) {
                        self.advance();
                    }
                }
                self.expect(&TokenKind::RBrace)?;
                Some(TypeExpr::Struct { fields })
            }
            _ => {
                self.error(&format!("expected type, got {:?}", tok.kind));
                None
            }
        }
    }

    // ---- Params ----

    fn parse_params(&mut self) -> Option<Vec<Param>> {
        let mut params = Vec::new();
        self.skip_newlines();
        while !self.check(&TokenKind::RParen) && !self.is_at_end() {
            self.skip_newlines();
            if self.check(&TokenKind::RParen) {
                break;
            }
            let span = self.current_span();
            let name = self.expect_ident()?;
            self.skip_newlines();

            let type_ann = if self.check(&TokenKind::Colon) {
                self.advance();
                self.skip_newlines();
                Some(self.parse_type_expr()?)
            } else {
                None
            };

            let default = if self.check(&TokenKind::Eq) {
                self.advance();
                self.skip_newlines();
                Some(self.parse_expr()?)
            } else {
                None
            };

            params.push(Param {
                name,
                type_ann,
                default,
                span,
            });
            self.skip_newlines();
            if self.check(&TokenKind::Comma) {
                self.advance();
            }
        }
        Some(params)
    }

    // ---- Block ----

    fn parse_block(&mut self) -> Option<Block> {
        let span = self.current_span();
        self.expect(&TokenKind::LBrace)?;
        self.skip_newlines();
        let mut statements = Vec::new();
        while !self.check(&TokenKind::RBrace) && !self.is_at_end() {
            self.skip_newlines();
            if self.check(&TokenKind::RBrace) {
                break;
            }
            if let Some(stmt) = self.parse_statement() {
                statements.push(stmt);
            }
            self.skip_newlines();
        }
        self.expect(&TokenKind::RBrace)?;
        Some(Block { statements, span })
    }

    // ---- Helpers ----

    fn peek(&self) -> Option<&Token> {
        self.tokens.get(self.pos)
    }

    fn peek_at(&self, offset: usize) -> Option<&Token> {
        self.tokens.get(self.pos + offset)
    }

    fn advance(&mut self) -> Option<&Token> {
        let tok = self.tokens.get(self.pos);
        self.pos += 1;
        tok
    }

    fn check(&self, kind: &TokenKind) -> bool {
        self.peek()
            .map(|t| std::mem::discriminant(&t.kind) == std::mem::discriminant(kind))
            .unwrap_or(false)
    }

    fn expect(&mut self, kind: &TokenKind) -> Option<&Token> {
        if self.check(kind) {
            self.advance()
        } else {
            let span = self.current_span();
            let found = self.peek().map(|t| format!("{:?}", t.kind)).unwrap_or("EOF".into());
            self.diagnostics.push(Diagnostic::error(
                "E0001",
                format!("expected {:?}, found {}", kind, found),
                span,
            ));
            None
        }
    }

    fn expect_ident(&mut self) -> Option<String> {
        let tok = self.peek()?.clone();
        if let TokenKind::Ident(name) = &tok.kind {
            let name = name.clone();
            self.advance();
            Some(name)
        } else {
            self.error(&format!("expected identifier, found {:?}", tok.kind));
            None
        }
    }

    fn skip_newlines(&mut self) {
        while self.check(&TokenKind::Newline) {
            self.advance();
        }
    }

    /// Check if an expression is chainable across newlines with `.`
    /// Only identifiers, calls, member accesses, indexes, and list/map literals should chain.
    fn is_chainable_expr(expr: &Expr) -> bool {
        matches!(expr,
            Expr::Ident(_, _) |
            Expr::Call { .. } |
            Expr::MemberAccess { .. } |
            Expr::Index { .. } |
            Expr::ListLit { .. } |
            Expr::MapLit { .. } |
            Expr::NullPropagate { .. }
        )
    }

    /// Peek past newlines to see if the next meaningful token matches
    fn next_meaningful_is(&self, kind: &TokenKind) -> bool {
        let mut offset = 0;
        loop {
            match self.tokens.get(self.pos + offset) {
                Some(t) if t.kind == TokenKind::Newline => offset += 1,
                Some(t) => return std::mem::discriminant(&t.kind) == std::mem::discriminant(kind),
                None => return false,
            }
        }
    }

    fn is_at_end(&self) -> bool {
        self.peek()
            .map(|t| t.kind == TokenKind::Eof)
            .unwrap_or(true)
    }

    fn current_span(&self) -> Span {
        self.peek().map(|t| t.span).unwrap_or(Span::dummy())
    }

    fn error(&mut self, msg: &str) {
        let span = self.current_span();
        self.diagnostics.push(Diagnostic::error("E0001", msg, span));
    }

    // ---- Provider keyword parsing (Phase 3) ----

    fn parse_model_decl(&mut self) -> Option<Statement> {
        let start = self.advance()?.span; // consume 'model'
        self.skip_newlines();

        let name = match &self.peek()?.kind {
            TokenKind::Ident(n) => n.clone(),
            _ => { self.error("expected model name"); return None; }
        };
        self.advance();
        self.skip_newlines();

        self.expect(&TokenKind::LBrace)?;
        self.skip_newlines();

        let mut fields = Vec::new();
        while !self.check(&TokenKind::RBrace) {
            self.skip_newlines();
            if self.check(&TokenKind::RBrace) { break; }

            let field_name = match &self.peek()?.kind {
                TokenKind::Ident(n) => n.clone(),
                _ => { self.error("expected field name"); self.advance(); continue; }
            };
            let field_start = self.advance()?.span;

            self.expect(&TokenKind::Colon)?;
            let type_ann = self.parse_type_expr()?;

            // Parse annotations
            let mut annotations = Vec::new();
            while self.check(&TokenKind::At) {
                let ann_start = self.advance()?.span; // consume '@'
                let ann_name = match &self.peek()?.kind {
                    TokenKind::Ident(n) => n.clone(),
                    _ => { self.error("expected annotation name"); break; }
                };
                self.advance();

                let mut args = Vec::new();
                if self.check(&TokenKind::LParen) {
                    self.advance();
                    if !self.check(&TokenKind::RParen) {
                        if let Some(arg) = self.parse_expr() {
                            args.push(arg);
                        }
                    }
                    self.expect(&TokenKind::RParen);
                }

                annotations.push(crate::parser::ast::Annotation {
                    name: ann_name,
                    args,
                    span: ann_start,
                });
            }

            fields.push(crate::parser::ast::ModelField {
                name: field_name,
                type_ann,
                annotations,
                span: field_start,
            });

            self.skip_newlines();
        }

        self.expect(&TokenKind::RBrace)?;

        Some(Statement::ModelDecl {
            name,
            fields,
            span: start,
        })
    }

    fn parse_service_decl(&mut self) -> Option<Statement> {
        let start = self.advance()?.span; // consume 'service'
        self.skip_newlines();

        let name = match &self.peek()?.kind {
            TokenKind::Ident(n) => n.clone(),
            _ => { self.error("expected service name"); return None; }
        };
        self.advance();
        self.skip_newlines();

        // 'for' <ModelName>
        match &self.peek()?.kind {
            TokenKind::For => { self.advance(); }
            _ => { self.error("expected 'for' after service name"); return None; }
        };
        self.skip_newlines();

        let for_model = match &self.peek()?.kind {
            TokenKind::Ident(n) => n.clone(),
            _ => { self.error("expected model name"); return None; }
        };
        self.advance();
        self.skip_newlines();

        self.expect(&TokenKind::LBrace)?;
        self.skip_newlines();

        let mut hooks = Vec::new();
        let mut methods = Vec::new();

        while !self.check(&TokenKind::RBrace) {
            self.skip_newlines();
            if self.check(&TokenKind::RBrace) { break; }

            match &self.peek()?.kind {
                TokenKind::Fn => {
                    if let Some(method) = self.parse_fn_decl(false) {
                        methods.push(method);
                    }
                }
                TokenKind::Ident(name) if name == "before" || name == "after" => {
                    let timing = if name == "before" {
                        crate::parser::ast::HookTiming::Before
                    } else {
                        crate::parser::ast::HookTiming::After
                    };
                    let hook_start = self.advance()?.span;
                    self.skip_newlines();

                    let operation = match &self.peek()?.kind {
                        TokenKind::Ident(n) => n.clone(),
                        _ => { self.error("expected operation name"); continue; }
                    };
                    self.advance();

                    // parse (param)
                    self.expect(&TokenKind::LParen)?;
                    let param = match &self.peek()?.kind {
                        TokenKind::Ident(n) => n.clone(),
                        _ => { self.error("expected parameter name"); String::new() }
                    };
                    self.advance();
                    self.expect(&TokenKind::RParen)?;
                    self.skip_newlines();

                    let body = self.parse_block()?;

                    hooks.push(crate::parser::ast::ServiceHook {
                        timing,
                        operation,
                        param,
                        body,
                        span: hook_start,
                    });
                }
                _ => {
                    self.error("expected 'fn', 'before', or 'after' in service block");
                    self.advance();
                }
            }
            self.skip_newlines();
        }

        self.expect(&TokenKind::RBrace)?;

        Some(Statement::ServiceDecl {
            name,
            for_model,
            hooks,
            methods,
            span: start,
        })
    }

    fn parse_server_block(&mut self) -> Option<Statement> {
        let start = self.advance()?.span; // consume 'server'
        self.skip_newlines();

        // Parse :port
        self.expect(&TokenKind::Colon)?;
        let port = match &self.peek()?.kind {
            TokenKind::IntLiteral(n) => *n,
            _ => { self.error("expected port number"); return None; }
        };
        self.advance();
        self.skip_newlines();

        self.expect(&TokenKind::LBrace)?;
        self.skip_newlines();

        let mut children = Vec::new();

        while !self.check(&TokenKind::RBrace) {
            self.skip_newlines();
            if self.check(&TokenKind::RBrace) { break; }

            match &self.peek()?.kind {
                TokenKind::Ident(name) if name == "route" => {
                    let route_start = self.advance()?.span;
                    self.skip_newlines();

                    // HTTP method (GET, POST, PUT, DELETE)
                    let method = match &self.peek()?.kind {
                        TokenKind::Ident(m) => m.to_uppercase(),
                        _ => { self.error("expected HTTP method"); continue; }
                    };
                    self.advance();
                    self.skip_newlines();

                    // Path like /health or /hello/:name
                    let path = self.parse_url_path();
                    self.skip_newlines();

                    // -> handler
                    self.expect(&TokenKind::Arrow)?;
                    self.skip_newlines();

                    let handler = self.parse_expr()?;

                    children.push(crate::parser::ast::ServerChild::Route {
                        method,
                        path,
                        handler,
                        span: route_start,
                    });
                }
                TokenKind::Ident(name) if name == "mount" => {
                    let mount_start = self.advance()?.span;
                    self.skip_newlines();

                    let service = match &self.peek()?.kind {
                        TokenKind::Ident(n) => n.clone(),
                        _ => { self.error("expected service name"); continue; }
                    };
                    self.advance();
                    self.skip_newlines();

                    // 'at'
                    match &self.peek()?.kind {
                        TokenKind::Ident(n) if n == "at" => { self.advance(); }
                        _ => { self.error("expected 'at' after service name"); continue; }
                    };
                    self.skip_newlines();

                    let path = self.parse_url_path();

                    children.push(crate::parser::ast::ServerChild::Mount {
                        service,
                        path,
                        span: mount_start,
                    });
                }
                _ => {
                    self.error("expected 'route' or 'mount' in server block");
                    self.advance();
                }
            }
            self.skip_newlines();
        }

        self.expect(&TokenKind::RBrace)?;

        Some(Statement::ServerBlock {
            port,
            children,
            span: start,
        })
    }

    /// Parse assert statement: assert expr, "message"
    fn parse_assert(&mut self) -> Option<Statement> {
        let start = self.advance()?.span; // consume 'assert'
        self.skip_newlines();
        let condition = self.parse_expr()?;
        self.skip_newlines();

        let message = if self.check(&TokenKind::Comma) {
            self.advance();
            self.skip_newlines();
            self.parse_expr()
        } else {
            Some(Expr::StringLit("assertion failed".to_string(), start))
        };

        // Generate: assert(condition, message)
        let call = Expr::Call {
            callee: Box::new(Expr::Ident("assert".to_string(), start)),
            args: vec![
                CallArg { name: None, value: condition },
                CallArg { name: None, value: message.unwrap_or(Expr::StringLit("assertion failed".to_string(), start)) },
            ],
            span: start,
        };

        Some(Statement::Expr(call))
    }

    /// Parse a URL path like /health or /users/:id
    fn parse_url_path(&mut self) -> String {
        let mut path = String::new();
        // Expect '/' Div token or parse from tokens
        while self.check(&TokenKind::Slash) || self.check_ident() || self.check(&TokenKind::Colon) {
            match &self.peek().unwrap().kind {
                TokenKind::Slash => {
                    path.push('/');
                    self.advance();
                }
                TokenKind::Colon => {
                    path.push(':');
                    self.advance();
                }
                TokenKind::Ident(name) => {
                    path.push_str(name);
                    self.advance();
                }
                _ => break,
            }
        }
        if path.is_empty() {
            path = "/".to_string();
        }
        path
    }

    fn check_ident(&self) -> bool {
        matches!(self.peek(), Some(tok) if matches!(tok.kind, TokenKind::Ident(_)))
    }
}
