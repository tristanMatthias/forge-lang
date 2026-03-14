use crate::lexer::token::TokenKind;
use crate::parser::ast::*;
use crate::parser::parser::Parser;

use super::types::TypeDeclData;

impl Parser {
    pub(crate) fn parse_type_decl_feature(&mut self, exported: bool) -> Option<Statement> {
        let start = self.advance()?.span; // consume 'type'
        self.skip_newlines();
        let name = self.expect_ident()?;
        self.skip_newlines();

        // Parse optional type parameters: type Pair<A, B> = ...
        let type_params = self.parse_optional_type_params()?;
        self.skip_newlines();

        self.expect(&TokenKind::Eq)?;
        self.skip_newlines();
        let value = self.parse_type_expr()?;

        Some(feature_stmt(
            "structs",
            "TypeDecl",
            Box::new(TypeDeclData {
                name,
                type_params,
                value,
                exported,
            }),
            start,
        ))
    }

}
