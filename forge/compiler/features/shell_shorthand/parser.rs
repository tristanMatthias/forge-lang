use crate::feature::FeatureExpr;
use crate::lexer::token::TemplatePart as LexTemplatePart;
use crate::lexer::{Lexer, Span};
use crate::parser::ast::*;
use crate::parser::parser::Parser;

use super::types::DollarExecData;

impl Parser {
    /// Parse a dollar-exec expression: `$"echo hello ${name}"` or `$\`echo ${name}\``
    ///
    /// Takes the pre-lexed template parts and span from the lexer token,
    /// parses any interpolated expressions within `${}`, and produces
    /// an `Expr::Feature` with `DollarExecData`.
    pub(crate) fn parse_dollar_exec(&mut self, lex_parts: Vec<LexTemplatePart>, span: Span) -> Option<Expr> {
        let mut parts = Vec::new();
        for part in lex_parts {
            match part {
                LexTemplatePart::Literal(s) => {
                    parts.push(TemplatePart::Literal(s));
                }
                LexTemplatePart::Expr(expr_text, expr_span) => {
                    let mut lexer = Lexer::new_with_offset(&expr_text, expr_span.start, expr_span.line, expr_span.col);
                    let tokens = lexer.tokenize();
                    let mut parser = Parser::new(tokens);
                    if let Some(expr) = parser.parse_expr() {
                        parts.push(TemplatePart::Expr(Box::new(expr)));
                    }
                    self.diagnostics.extend(parser.diagnostics.into_iter());
                }
            }
        }
        Some(Expr::Feature(FeatureExpr {
            feature_id: "shell_shorthand",
            kind: "DollarExec",
            data: Box::new(DollarExecData { parts }),
            span,
        }))
    }
}
