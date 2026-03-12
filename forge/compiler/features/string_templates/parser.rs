use crate::lexer::token::{TemplatePart as LexTemplatePart, TokenKind};
use crate::lexer::{Lexer, Span};
use crate::parser::ast::*;
use crate::parser::parser::Parser;

impl Parser {
    /// Parse template literal parts from lexer-produced `LexTemplatePart` tokens.
    ///
    /// Literal segments become `TemplatePart::Literal`, expression segments are
    /// re-lexed and re-parsed into `TemplatePart::Expr`.
    pub(crate) fn parse_template_parts(
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
}
