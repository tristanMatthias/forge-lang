use crate::lexer::token::TemplatePart as LexTemplatePart;
use crate::lexer::{Lexer, Span};
use crate::parser::ast::*;
use crate::parser::parser::Parser;

impl Parser {
    /// Parse a tagged template literal: `tag\`template ${expr}\``
    ///
    /// Takes the pre-lexed tag name, template parts, and span from the lexer token,
    /// parses any interpolated expressions within `${}`, and produces
    /// an `Expr::TaggedTemplate`.
    pub(crate) fn parse_tagged_template(
        &mut self,
        tag: String,
        lex_parts: Vec<LexTemplatePart>,
        span: Span,
    ) -> Option<Expr> {
        self.parse_typed_tagged_template(tag, lex_parts, None, span)
    }

    /// Parse a tagged template with an optional type parameter: `tag<Type>\`template\``
    pub(crate) fn parse_typed_tagged_template(
        &mut self,
        tag: String,
        lex_parts: Vec<LexTemplatePart>,
        type_param: Option<TypeExpr>,
        span: Span,
    ) -> Option<Expr> {
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
        Some(Expr::TaggedTemplate { tag, parts, type_param, span })
    }
}
