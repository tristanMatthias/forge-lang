use crate::parser::ast::*;
use crate::parser::parser::{ComponentMeta, Parser};

impl Parser {
    /// Try to match the current position against registered @syntax patterns.
    /// If a pattern matches, consume the matched tokens and return a desugared
    /// function call statement: `__component_<fn_name>(captured_args...)`.
    /// For list captures (`{...name}`), returns multiple statements wrapped in a block.
    pub(crate) fn try_syntax_match(&mut self, meta: &ComponentMeta) -> Option<Statement> {
        use crate::features::components::expand::syntax::{SyntaxPattern, PatternSegment};

        let start_pos = self.pos;
        let span = self.peek()?.span;

        for pat_def in &meta.syntax_patterns {
            let pattern = SyntaxPattern::parse(&pat_def.pattern, &pat_def.fn_name);
            if let Some(result) = pattern.try_match(&self.tokens, self.pos) {
                // Consume the matched tokens
                self.pos = result.new_pos;

                let sentinel = format!("__component_{}", pat_def.fn_name);

                // Build base args from regular captures
                let base_args: Vec<CallArg> = pattern.segments.iter()
                    .filter_map(|seg| {
                        if let PatternSegment::Placeholder(name) = seg {
                            let captured_tokens = result.captures.get(name)?;
                            let text: String = captured_tokens.iter()
                                .map(|t| crate::features::components::expand::syntax::token_to_string(t))
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

                // If there are list captures, expand into N calls (one per list item)
                if !result.list_captures.is_empty() {
                    return self.expand_list_syntax_match(
                        &sentinel, &base_args, &pattern, &result, span,
                    );
                }

                // Regular (non-list) match: single call
                let final_args = self.refine_syntax_args(base_args, &result.captures, span);

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

    /// Expand a list capture into multiple __component_* calls.
    /// For `crud {...model}` matching `crud Post, User, Comment`,
    /// generates three separate `__component_crud_mount(model: "Post")` calls.
    fn expand_list_syntax_match(
        &mut self,
        sentinel: &str,
        base_args: &[CallArg],
        pattern: &crate::features::components::expand::syntax::SyntaxPattern,
        result: &crate::features::components::expand::syntax::SyntaxMatchResult,
        span: crate::lexer::Span,
    ) -> Option<Statement> {
        use crate::features::components::expand::syntax::PatternSegment;

        // Find the list placeholder name
        let list_name = pattern.segments.iter().find_map(|seg| {
            if let PatternSegment::ListPlaceholder(name) = seg { Some(name.clone()) } else { None }
        })?;

        let items = result.list_captures.get(&list_name)?;
        let mut stmts = Vec::new();

        for item_tokens in items {
            let text: String = item_tokens.iter()
                .map(|t| crate::features::components::expand::syntax::token_to_string(t))
                .collect::<Vec<_>>()
                .join("");

            let mut args = base_args.to_vec();
            args.push(CallArg {
                name: Some(list_name.clone()),
                value: Expr::StringLit(text, span),
            });

            stmts.push(Statement::Expr(Expr::Call {
                callee: Box::new(Expr::Ident(sentinel.to_string(), span)),
                args,
                type_args: vec![],
                span,
            }));
        }

        if stmts.len() == 1 {
            return stmts.into_iter().next();
        }

        // Wrap multiple statements in a block expression
        Some(Statement::Expr(Expr::Block(Block { statements: stmts, span })))
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
