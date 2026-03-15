use crate::lexer::token::TokenKind;
use crate::lexer::Span;
use crate::parser::ast::*;
use crate::parser::parser::Parser;

impl Parser {
    /// Parse `spec "name" { body }` — test specification block
    pub(crate) fn parse_spec_block(&mut self) -> Option<Statement> {
        let span = self.advance()?.span; // consume 'spec'
        self.skip_newlines();

        let name = self.expect_string_lit()?;
        self.skip_newlines();
        let body = self.parse_spec_body()?;

        Some(Statement::SpecBlock {
            name,
            body,
            span,
        })
    }

    /// Parse `given "name" { body }` — test grouping block
    pub(crate) fn parse_given_block(&mut self) -> Option<Statement> {
        let span = self.advance()?.span; // consume 'given'
        self.skip_newlines();

        let name = self.expect_string_lit()?;
        self.skip_newlines();
        let body = self.parse_spec_body()?;

        Some(Statement::GivenBlock {
            name,
            body,
            span,
        })
    }

    /// Parse `then "name" [modifier] { expr }` — test assertion block
    ///
    /// Modifiers:
    ///   - `should_fail` → expects body to error
    ///   - `should_fail_with "msg"` → expects specific error message
    ///   - `where table { ... } { body }` → parameterized test
    pub(crate) fn parse_then_block(&mut self) -> Option<Statement> {
        let span = self.advance()?.span; // consume 'then'
        self.skip_newlines();

        let name = self.expect_string_lit()?;
        self.skip_newlines();

        // Check for modifiers
        if let Some(tok) = self.peek() {
            if let TokenKind::Ident(ref ident) = tok.kind {
                match ident.as_str() {
                    "should_fail_with" => {
                        self.advance(); // consume 'should_fail_with'
                        self.skip_newlines();
                        let expected = self.expect_string_lit()?;
                        self.skip_newlines();
                        let body = self.parse_spec_body()?;
                        return Some(Statement::ThenShouldFailWith {
                            name,
                            expected,
                            body,
                            span,
                        });
                    }
                    "should_fail" => {
                        self.advance(); // consume 'should_fail'
                        self.skip_newlines();
                        let body = self.parse_spec_body()?;
                        return Some(Statement::ThenShouldFail {
                            name,
                            body,
                            span,
                        });
                    }
                    "where" => {
                        self.advance(); // consume 'where'
                        self.skip_newlines();
                        // Parse the table expression
                        let table = self.parse_expr()?;
                        self.skip_newlines();
                        // Parse the assertion body
                        let body = self.parse_spec_body()?;
                        return Some(Statement::ThenWhere {
                            name,
                            table,
                            body,
                            span,
                        });
                    }
                    _ => {}
                }
            }
        }

        let body = self.parse_spec_body()?;
        Some(Statement::ThenBlock {
            name,
            body,
            span,
        })
    }

    /// Parse `skip "name" { ... }` or `skip "name"` — skipped test
    pub(crate) fn parse_skip_block(&mut self) -> Option<Statement> {
        let span = self.advance()?.span; // consume 'skip'
        self.skip_newlines();

        let name = self.expect_string_lit()?;
        self.skip_newlines();

        // Optionally consume a block body (ignored)
        if self.check(&TokenKind::LBrace) {
            self.parse_block();
        }

        Some(Statement::SkipBlock { name, span })
    }

    /// Parse `todo "name"` — placeholder test
    pub(crate) fn parse_todo_stmt(&mut self) -> Option<Statement> {
        let span = self.advance()?.span; // consume 'todo'
        self.skip_newlines();

        let name = self.expect_string_lit()?;

        Some(Statement::TodoStmt { name, span })
    }

    /// Parse the body of a spec/given/then block — a block that can contain
    /// regular statements plus spec-specific constructs (given, then, skip, todo)
    fn parse_spec_body(&mut self) -> Option<Block> {
        let start = self.expect(&TokenKind::LBrace)?.span;
        let mut statements = Vec::new();

        self.skip_newlines();
        while !self.check(&TokenKind::RBrace) && !self.is_at_end() {
            if let Some(stmt) = self.parse_statement() {
                statements.push(stmt);
            }
            self.skip_newlines();
        }
        let end = self.expect(&TokenKind::RBrace)?.span;

        Some(Block {
            statements,
            span: Span::new(start.start, end.end, start.line, start.col),
        })
    }

    /// Helper: expect a string literal token and return its value
    fn expect_string_lit(&mut self) -> Option<String> {
        let tok = self.peek()?;
        if let TokenKind::StringLiteral(s) = &tok.kind {
            let s = s.clone();
            self.advance();
            Some(s)
        } else {
            self.diagnostics.push(crate::errors::Diagnostic::error(
                "F0900",
                "expected string literal".to_string(),
                tok.span,
            ));
            None
        }
    }
}
