use crate::lexer::token::{TemplatePart as LexTemplatePart, TokenKind};
use crate::lexer::{Lexer, Span};
use crate::parser::ast::*;
use crate::parser::parser::Parser;

impl Parser {
    /// Parse a dollar-exec expression: `$"echo hello ${name}"` or `$\`echo ${name}\``
    ///
    /// Takes the pre-lexed template parts and span from the lexer token,
    /// parses any interpolated expressions within `${}`, and produces
    /// an `Expr::DollarExec`.
    pub(crate) fn parse_dollar_exec(&mut self, lex_parts: Vec<LexTemplatePart>, span: Span) -> Option<Expr> {
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
        Some(Expr::DollarExec { parts, span })
    }
}
