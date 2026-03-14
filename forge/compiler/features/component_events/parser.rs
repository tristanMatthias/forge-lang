use crate::lexer::token::TokenKind;
use crate::parser::ast::*;
use crate::parser::parser::Parser;

impl Parser {
    /// Parse a before/after hook inside a component block.
    ///
    /// Syntax: `before operation(param) { body }` or `after operation(param) { body }`
    ///
    /// Produces a FnDecl named `__hook_before_<operation>` or `__hook_after_<operation>`.
    pub(crate) fn parse_component_hook(&mut self) -> Option<Statement> {
        // before/after operation(param) { body }
        let timing_name = match &self.peek()?.kind {
            TokenKind::Ident(n) => n.clone(),
            _ => return None,
        };
        let _timing = if timing_name == "before" {
            HookTiming::Before
        } else {
            HookTiming::After
        };
        let hook_start = self.advance()?.span;
        self.skip_newlines();

        let operation = match &self.peek()?.kind {
            TokenKind::Ident(n) => n.clone(),
            _ => { self.error("expected operation name"); return None; }
        };
        self.advance();

        self.expect(&TokenKind::LParen)?;
        let param = match &self.peek()?.kind {
            TokenKind::Ident(n) => n.clone(),
            _ => { self.error("expected parameter name"); String::new() }
        };
        self.advance();
        self.expect(&TokenKind::RParen)?;
        self.skip_newlines();

        let body = self.parse_block()?;

        // Wrap as an ExternFn-style statement to carry the hook data
        // We'll use a special naming convention: __hook_before_create
        let hook_name = format!("__hook_{}_{}", timing_name, operation);
        Some(Statement::FnDecl {
            name: hook_name,
            type_params: vec![],
            params: vec![Param {
                name: param,
                type_ann: None,
                default: None,
                span: hook_start,
            }],
            return_type: None,
            body,
            exported: false,
            span: hook_start,
        })
    }
}
