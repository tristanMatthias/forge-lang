use crate::parser::ast::*;
use crate::parser::parser::{ComponentMeta, Parser};

impl Parser {
    /// Try to match the current position against registered @syntax patterns.
    /// If a pattern matches, consume the matched tokens and return a desugared
    /// function call statement: `__component_<fn_name>(captured_args...)`.
    pub(crate) fn try_syntax_match(&mut self, meta: &ComponentMeta) -> Option<Statement> {
        use crate::component_expand::syntax::SyntaxPattern;

        let start_pos = self.pos;
        let span = self.peek()?.span;

        for pat_def in &meta.syntax_patterns {
            let pattern = SyntaxPattern::parse(&pat_def.pattern, &pat_def.fn_name);
            if let Some((captures, new_pos)) = pattern.try_match(&self.tokens, self.pos) {
                // Consume the matched tokens
                self.pos = new_pos;

                // Build a __component_<fn_name>(...) call with captured values
                let sentinel = format!("__component_{}", pat_def.fn_name);
                let args: Vec<CallArg> = pattern.segments.iter()
                    .filter_map(|seg| {
                        if let crate::component_expand::syntax::PatternSegment::Placeholder(name) = seg {
                            let captured_tokens = captures.get(name)?;
                            // Convert captured tokens to a string value
                            let text: String = captured_tokens.iter()
                                .map(|t| crate::component_expand::syntax::token_to_string(t))
                                .collect::<Vec<_>>()
                                .join("");
                            Some(CallArg {
                                name: Some(name.clone()),
                                value: Expr::StringLit(text, span),
                            })
                        } else {
                            None
                        }
                    })
                    .collect();

                // Check if the last capture might be a closure/expression
                // For "handler" params, try to re-parse the captured tokens as an expression
                let final_args = self.refine_syntax_args(args, &captures, span);

                return Some(Statement::Expr(Expr::Call {
                    callee: Box::new(Expr::Ident(sentinel, span)),
                    args: final_args,
                    type_args: vec![],
                    span,
                }));
            }
        }

        // No pattern matched — restore position (should already be at start_pos)
        self.pos = start_pos;
        None
    }

    /// Refine syntax pattern capture args: if a captured param name is "handler"
    /// and the tokens look like an expression (ident, closure, etc.), parse them.
    pub(crate) fn refine_syntax_args(
        &mut self,
        args: Vec<CallArg>,
        captures: &std::collections::HashMap<String, Vec<crate::lexer::Token>>,
        _span: crate::lexer::Span,
    ) -> Vec<CallArg> {
        let mut result = Vec::new();
        for arg in args {
            let name = arg.name.clone().unwrap_or_default();
            if name == "handler" {
                // Try to parse the captured tokens as an expression
                if let Some(tokens) = captures.get("handler") {
                    let mut sub_parser = Parser::new(tokens.clone());
                    if let Some(expr) = sub_parser.parse_expr() {
                        result.push(CallArg {
                            name: Some("handler".to_string()),
                            value: expr,
                        });
                        continue;
                    }
                }
            }
            result.push(arg);
        }
        result
    }
}
