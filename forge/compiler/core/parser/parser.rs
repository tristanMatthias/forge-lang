use crate::errors::Diagnostic;
use crate::lexer::token::{TemplatePart as LexTemplatePart, TokenKind};
use crate::lexer::{Lexer, Span, Token};
use crate::parser::ast::*;
use std::collections::HashMap;

#[derive(Debug, Clone)]
pub enum ComponentKind {
    Block,
    Function,
}

#[derive(Debug, Clone)]
pub struct SyntaxPatternDef {
    pub pattern: String,
    pub fn_name: String,
}

#[derive(Debug, Clone)]
pub struct ComponentMeta {
    pub name: String,
    pub kind: ComponentKind,
    pub context: String,
    pub syntax: Option<String>,
    pub syntax_patterns: Vec<SyntaxPatternDef>,
}

pub struct Parser {
    pub(crate) tokens: Vec<Token>,
    pub(crate) pos: usize,
    pub(crate) diagnostics: Vec<Diagnostic>,
    pub(crate) registered_components: HashMap<String, ComponentMeta>,
}

impl Parser {
    pub fn new(tokens: Vec<Token>) -> Self {
        Self {
            tokens,
            pos: 0,
            diagnostics: Vec::new(),
            registered_components: HashMap::new(),
        }
    }

    pub fn new_with_components(tokens: Vec<Token>, components: HashMap<String, ComponentMeta>) -> Self {
        Self {
            tokens,
            pos: 0,
            diagnostics: Vec::new(),
            registered_components: components,
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

    pub(crate) fn parse_statement(&mut self) -> Option<Statement> {
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
            TokenKind::Spawn => self.parse_spawn(),
            TokenKind::Select => self.parse_select(),
            TokenKind::Component => self.parse_component_template_def(),
            TokenKind::Ident(name) => {
                if let Some(meta) = self.registered_components.get(name).cloned() {
                    return self.parse_component_block(&meta);
                }
                match name.as_str() {
                    "extern" => self.parse_extern_fn(),
                    "assert" => self.parse_assert(),
                    "spec" => self.parse_spec_block(),
                    "given" => self.parse_given_block(),
                    "then" => self.parse_then_block(),
                    "skip" => self.parse_skip_block(),
                    "todo" => self.parse_todo_stmt(),
                    _ => self.parse_expr_statement(),
                }
            }
            _ => self.parse_expr_statement(),
        }
    }

    pub(crate) fn parse_let_with_export(&mut self, exported: bool) -> Option<Statement> {
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
        let (type_ann, type_ann_span) = if self.check(&TokenKind::Colon) {
            let colon_pos = self.tokens[self.pos].span.start;
            self.advance();
            self.skip_newlines();
            let ty = self.parse_type_expr()?;
            let end_pos = self.tokens[self.pos.saturating_sub(1)].span.end;
            (Some(ty), Some(Span::new(colon_pos, end_pos, 0, 0)))
        } else {
            (None, None)
        };
        self.skip_newlines();
        self.expect(&TokenKind::Eq)?;
        self.skip_newlines();
        let value = self.parse_expr()?;
        Some(Statement::Let {
            name,
            type_ann,
            type_ann_span,
            value,
            exported,
            span: start,
        })
    }

    pub(crate) fn parse_let(&mut self) -> Option<Statement> {
        self.parse_let_with_export(false)
    }

    pub(crate) fn parse_tuple_destructure(
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

    pub(crate) fn parse_struct_destructure(
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

    pub(crate) fn parse_list_destructure(
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

    pub(crate) fn parse_mut_with_export(&mut self, exported: bool) -> Option<Statement> {
        let start = self.advance()?.span;
        self.skip_newlines();
        let name = self.expect_ident()?;
        let (type_ann, type_ann_span) = if self.check(&TokenKind::Colon) {
            let colon_pos = self.tokens[self.pos].span.start;
            self.advance();
            self.skip_newlines();
            let ty = self.parse_type_expr()?;
            let end_pos = self.tokens[self.pos.saturating_sub(1)].span.end;
            (Some(ty), Some(Span::new(colon_pos, end_pos, 0, 0)))
        } else {
            (None, None)
        };
        self.skip_newlines();
        self.expect(&TokenKind::Eq)?;
        self.skip_newlines();
        let value = self.parse_expr()?;
        Some(Statement::Mut {
            name,
            type_ann,
            type_ann_span,
            value,
            exported,
            span: start,
        })
    }

    pub(crate) fn parse_mut(&mut self) -> Option<Statement> {
        self.parse_mut_with_export(false)
    }

    pub(crate) fn parse_const_with_export(&mut self, exported: bool) -> Option<Statement> {
        let start = self.advance()?.span;
        self.skip_newlines();
        let name = self.expect_ident()?;
        let (type_ann, type_ann_span) = if self.check(&TokenKind::Colon) {
            let colon_pos = self.tokens[self.pos].span.start;
            self.advance();
            self.skip_newlines();
            let ty = self.parse_type_expr()?;
            let end_pos = self.tokens[self.pos.saturating_sub(1)].span.end;
            (Some(ty), Some(Span::new(colon_pos, end_pos, 0, 0)))
        } else {
            (None, None)
        };
        self.skip_newlines();
        self.expect(&TokenKind::Eq)?;
        self.skip_newlines();
        let value = self.parse_expr()?;
        Some(Statement::Const {
            name,
            type_ann,
            type_ann_span,
            value,
            exported,
            span: start,
        })
    }

    pub(crate) fn parse_const(&mut self) -> Option<Statement> {
        self.parse_const_with_export(false)
    }

    pub(crate) fn parse_fn_decl(&mut self, exported: bool) -> Option<Statement> {
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
    // parse_extern_fn: extracted to features/

    pub(crate) fn parse_export(&mut self) -> Option<Statement> {
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

        Some(Statement::EnumDecl {
            name,
            variants,
            exported,
            span: start,
        })
    }

    pub(crate) fn parse_type_decl(&mut self, exported: bool) -> Option<Statement> {
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

    pub(crate) fn parse_return(&mut self) -> Option<Statement> {
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
    // parse_for: extracted to features/
    // parse_while: extracted to features/
    // parse_loop: extracted to features/
    // parse_break: extracted to features/
    // parse_continue: extracted to features/
    // parse_defer: extracted to features/
    // parse_spawn: extracted to features/
    // parse_select: extracted to features/

    pub(crate) fn parse_use(&mut self) -> Option<Statement> {
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
    // parse_type_params: extracted to features/
    // parse_trait_decl: extracted to features/
    // parse_impl_block: extracted to features/

    pub(crate) fn parse_expr_statement(&mut self) -> Option<Statement> {
        let expr = self.parse_expr()?;

        // Check for channel send: expr <- value
        if self.check(&TokenKind::LeftArrow) {
            let span = self.advance()?.span; // consume <-
            self.skip_newlines();
            let value = self.parse_expr()?;
            return Some(Statement::Expr(Expr::ChannelSend {
                channel: Box::new(expr),
                value: Box::new(value),
                span,
            }));
        }

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

    pub(crate) fn parse_expr(&mut self) -> Option<Expr> {
        self.parse_pipe()
    }

    // parse_pipe: moved to features/pipe_operator/parser.rs
    // parse_null_coalesce: extracted to features/

    pub(crate) fn parse_or(&mut self) -> Option<Expr> {
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

    pub(crate) fn parse_and(&mut self) -> Option<Expr> {
        let mut left = self.parse_is_check()?;
        while self.check(&TokenKind::And) {
            let span = self.advance()?.span;
            self.skip_newlines();
            let right = self.parse_is_check()?;
            left = Expr::Binary {
                left: Box::new(left),
                op: BinaryOp::And,
                right: Box::new(right),
                span,
            };
        }
        Some(left)
    }

    pub(crate) fn parse_equality(&mut self) -> Option<Expr> {
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

    pub(crate) fn parse_comparison(&mut self) -> Option<Expr> {
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
    // parse_range: extracted to features/

    pub(crate) fn parse_addition(&mut self) -> Option<Expr> {
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

    pub(crate) fn parse_multiplication(&mut self) -> Option<Expr> {
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

    pub(crate) fn parse_unary(&mut self) -> Option<Expr> {
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
        // Channel receive: <- channel
        if self.check(&TokenKind::LeftArrow) {
            let span = self.advance()?.span; // consume <-
            self.skip_newlines();
            let channel = self.parse_unary()?;
            return Some(Expr::ChannelReceive {
                channel: Box::new(channel),
                span,
            });
        }
        self.parse_postfix()
    }

    pub(crate) fn parse_postfix(&mut self) -> Option<Expr> {
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
                let field = self.expect_field_name()?;
                expr = Expr::MemberAccess {
                    object: Box::new(expr),
                    field,
                    span,
                };
            } else if self.check(&TokenKind::QuestionDot) {
                let span = self.advance()?.span;
                let field = self.expect_field_name()?;
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

    pub(crate) fn parse_call_arg(&mut self) -> Option<CallArg> {
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
    // expr_contains_it: extracted to features/

    pub(crate) fn parse_primary(&mut self) -> Option<Expr> {
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
            TokenKind::DollarString(parts) => {
                let parts = parts.clone();
                let span = tok.span;
                self.advance();
                self.parse_dollar_exec(parts, span)
            }
            TokenKind::Ident(_) => self.parse_ident_expr(),
            TokenKind::LParen => self.parse_paren_expr(),
            TokenKind::LBrace => self.parse_brace_expr(),
            TokenKind::LBracket => self.parse_list_expr(),
            TokenKind::Table => self.parse_table_literal(),
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
    // parse_template_parts: extracted to features/
    // parse_dollar_exec: extracted to features/

    pub(crate) fn parse_ident_expr(&mut self) -> Option<Expr> {
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

    pub(crate) fn parse_paren_expr(&mut self) -> Option<Expr> {
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

    // looks_like_closure_params: extracted to features/closures/parser.rs
    // parse_closure: extracted to features/

    pub(crate) fn parse_brace_expr(&mut self) -> Option<Expr> {
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

    pub(crate) fn is_struct_literal(&self) -> bool {
        // { ident : expr } is struct literal
        if let Some(TokenKind::Ident(_)) = self.peek().map(|t| &t.kind) {
            if let Some(TokenKind::Colon) = self.peek_at(1).map(|t| &t.kind) {
                return true;
            }
        }
        false
    }

    pub(crate) fn is_map_literal(&self) -> bool {
        // { "string" : expr } is map literal
        if let Some(TokenKind::StringLiteral(_)) = self.peek().map(|t| &t.kind) {
            if let Some(TokenKind::Colon) = self.peek_at(1).map(|t| &t.kind) {
                return true;
            }
        }
        false
    }

    pub(crate) fn parse_struct_literal(&mut self, span: Span) -> Option<Expr> {
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

    pub(crate) fn parse_map_literal(&mut self, span: Span) -> Option<Expr> {
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

    pub(crate) fn parse_list_expr(&mut self) -> Option<Expr> {
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

    pub(crate) fn parse_if_expr(&mut self) -> Option<Expr> {
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
    // parse_match_expr: extracted to features/
    // parse_match_arm: extracted to features/
    // parse_pattern: extracted to features/
    // parse_simple_pattern: extracted to features/

    // ---- Type expressions ----

    pub(crate) fn parse_type_expr(&mut self) -> Option<TypeExpr> {
        let mut ty = self.parse_primary_type()?;

        // Check for nullable
        if self.check(&TokenKind::Question) {
            self.advance();
            ty = TypeExpr::Nullable(Box::new(ty));
        }

        Some(ty)
    }

    pub(crate) fn parse_primary_type(&mut self) -> Option<TypeExpr> {
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

    pub(crate) fn parse_params(&mut self) -> Option<Vec<Param>> {
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

    pub(crate) fn parse_block(&mut self) -> Option<Block> {
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

    pub(crate) fn peek(&self) -> Option<&Token> {
        self.tokens.get(self.pos)
    }

    pub(crate) fn peek_at(&self, offset: usize) -> Option<&Token> {
        self.tokens.get(self.pos + offset)
    }

    pub(crate) fn advance(&mut self) -> Option<&Token> {
        let tok = self.tokens.get(self.pos);
        self.pos += 1;
        tok
    }

    pub(crate) fn check(&self, kind: &TokenKind) -> bool {
        self.peek()
            .map(|t| std::mem::discriminant(&t.kind) == std::mem::discriminant(kind))
            .unwrap_or(false)
    }

    pub(crate) fn expect(&mut self, kind: &TokenKind) -> Option<&Token> {
        if self.check(kind) {
            self.advance()
        } else {
            let span = self.current_span();
            let found = self.peek().map(|t| format!("{:?}", t.kind)).unwrap_or("EOF".into());
            self.diagnostics.push(Diagnostic::error(
                "F0001",
                format!("expected {:?}, found {}", kind, found),
                span,
            ));
            None
        }
    }

    pub(crate) fn expect_ident(&mut self) -> Option<String> {
        let tok = self.peek()?.clone();
        let name = match &tok.kind {
            TokenKind::Ident(name) => Some(name.clone()),
            // Allow keywords that can also be used as identifiers (e.g., parameter names)
            TokenKind::Table => Some("table".to_string()),
            TokenKind::Is => Some("is".to_string()),
            TokenKind::Underscore => Some("_".to_string()),
            _ => None,
        };
        if let Some(name) = name {
            self.advance();
            Some(name)
        } else {
            self.error(&format!("expected identifier, found {:?}", tok.kind));
            None
        }
    }

    /// Like expect_ident but also accepts keywords as field names (for member access).
    /// This allows `process.spawn()`, `ch.select()`, `obj.on()` etc.
    pub(crate) fn expect_field_name(&mut self) -> Option<String> {
        let tok = self.peek()?.clone();
        let name = match &tok.kind {
            TokenKind::Ident(name) => Some(name.clone()),
            TokenKind::Spawn => Some("spawn".to_string()),
            TokenKind::Select => Some("select".to_string()),
            TokenKind::On => Some("on".to_string()),
            TokenKind::Component => Some("component".to_string()),
            TokenKind::Match => Some("match".to_string()),
            TokenKind::Use => Some("use".to_string()),
            TokenKind::Table => Some("table".to_string()),
            TokenKind::Is => Some("is".to_string()),
            _ => None,
        };
        if let Some(name) = name {
            self.advance();
            Some(name)
        } else {
            self.error(&format!("expected identifier, found {:?}", tok.kind));
            None
        }
    }

    pub(crate) fn skip_newlines(&mut self) {
        while self.check(&TokenKind::Newline) {
            self.advance();
        }
    }

    /// Check if an expression is chainable across newlines with `.`
    /// Only identifiers, calls, member accesses, indexes, and list/map literals should chain.
    pub(crate) fn is_chainable_expr(expr: &Expr) -> bool {
        matches!(expr,
            Expr::Ident(_, _) |
            Expr::Call { .. } |
            Expr::MemberAccess { .. } |
            Expr::Index { .. } |
            Expr::ListLit { .. } |
            Expr::MapLit { .. } |
            Expr::NullPropagate { .. } |
            Expr::ErrorPropagate { .. }
        )
    }

    /// Peek past newlines to see if the next meaningful token matches
    pub(crate) fn next_meaningful_is(&self, kind: &TokenKind) -> bool {
        let mut offset = 0;
        loop {
            match self.tokens.get(self.pos + offset) {
                Some(t) if t.kind == TokenKind::Newline => offset += 1,
                Some(t) => return std::mem::discriminant(&t.kind) == std::mem::discriminant(kind),
                None => return false,
            }
        }
    }

    pub(crate) fn is_at_end(&self) -> bool {
        self.peek()
            .map(|t| t.kind == TokenKind::Eof)
            .unwrap_or(true)
    }

    pub(crate) fn current_span(&self) -> Span {
        self.peek().map(|t| t.span).unwrap_or(Span::dummy())
    }

    pub(crate) fn error(&mut self, msg: &str) {
        let span = self.current_span();
        self.diagnostics.push(Diagnostic::error("F0001", msg, span));
    }

    // ---- Generic component block parsing ----
    // parse_component_block: extracted to features/
    // parse_component_hook: extracted to features/
    // parse_component_template_def: extracted to features/
    // try_syntax_match: extracted to features/
    // refine_syntax_args: extracted to features/

    /// Parse assert statement: assert expr, "message"
    pub(crate) fn parse_assert(&mut self) -> Option<Statement> {
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

}
