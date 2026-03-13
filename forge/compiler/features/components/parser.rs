use crate::lexer::token::TokenKind;
use crate::parser::ast::*;
use crate::parser::parser::{ComponentMeta, Parser};

impl Parser {
    /// Parse a component block from user source code.
    ///
    /// Handles patterns like:
    /// - `model Task { ... }`
    /// - `server :3000 { ... }`
    /// - `service TaskService for User { ... }`
    ///
    /// The body can contain:
    /// - Schema fields: `name: type @annotations`
    /// - Config entries: `key value`
    /// - Function declarations: `fn method() { ... }`
    /// - Event handlers: `on event(param) { ... }` (see component_events)
    /// - Hooks: `before/after operation(param) { ... }` (see component_events)
    /// - Run blocks: `run { ... }`
    /// - @syntax pattern matches (see component_syntax)
    pub(crate) fn parse_component_block(&mut self, meta: &ComponentMeta) -> Option<Statement> {
        let component = meta.name.clone();
        let start = self.advance()?.span; // consume the component name
        self.skip_newlines();

        let mut args = Vec::new();

        // Parse arguments before the opening brace
        // Handle patterns like: model Task, server :3000, service TaskService for User
        while !self.check(&TokenKind::LBrace) && !self.is_at_end() {
            match &self.peek()?.kind {
                TokenKind::Colon => {
                    // :literal pattern (e.g., server :3000)
                    self.advance();
                    match &self.peek()?.kind {
                        TokenKind::IntLiteral(n) => {
                            let val = *n;
                            let span = self.advance()?.span;
                            args.push(ComponentArg::Named(
                                "port".to_string(),
                                Expr::IntLit(val, span),
                                span,
                            ));
                        }
                        _ => {
                            self.error("expected value after ':'");
                            break;
                        }
                    }
                }
                TokenKind::For => {
                    // for Model pattern
                    self.advance();
                    self.skip_newlines();
                    if let Some(tok) = self.peek() {
                        if let TokenKind::Ident(ref_name) = &tok.kind {
                            let ref_name = ref_name.clone();
                            let span = self.advance()?.span;
                            args.push(ComponentArg::ForRef(ref_name, span));
                        }
                    }
                }
                TokenKind::Ident(name) => {
                    let name = name.clone();
                    let span = self.advance()?.span;
                    args.push(ComponentArg::Ident(name, span));
                }
                TokenKind::Newline => {
                    self.advance();
                }
                _ => break,
            }
            self.skip_newlines();
        }

        self.expect(&TokenKind::LBrace)?;
        self.skip_newlines();

        let mut component_annotations = Vec::new();
        let mut config = Vec::new();
        let mut schema = Vec::new();
        let mut blocks = Vec::new();
        let mut pending_annotations: Vec<Annotation> = Vec::new();

        while !self.check(&TokenKind::RBrace) {
            self.skip_newlines();
            if self.check(&TokenKind::RBrace) {
                break;
            }

            // Parse annotations: @name or @name(args)
            if self.check(&TokenKind::At) {
                let ann = self.parse_component_annotation();
                if let Some(ann) = ann {
                    pending_annotations.push(ann);
                }
                continue;
            }

            // If we have pending annotations and no schema/syntax follows,
            // they're component-level annotations
            // (route-level annotations will be consumed by syntax matches below)

            // Try to classify each item in the body:
            // 1. Known keywords (fn, on, run, before/after, route/mount)
            // 2. @syntax pattern matches (with pending annotations)
            // 3. Schema field (ident: type @annotations)
            // 4. Config (ident value)

            // Check for block keywords that should take precedence over syntax patterns
            // (under, middleware, crud)
            let is_block_keyword = match &self.peek()?.kind {
                TokenKind::Ident(n) if n == "under" || n == "middleware" || n == "crud" => true,
                _ => false,
            };

            if !is_block_keyword && !meta.syntax_patterns.is_empty() {
                if let Some(stmt) = self.try_syntax_match(meta) {
                    // Attach pending annotations as a preceding annotation statement
                    if !pending_annotations.is_empty() {
                        // Store annotations in the block as a special annotated wrapper
                        // For now, annotations on routes are passed through the JSON schema
                        pending_annotations.clear();
                    }
                    blocks.push(stmt);
                    self.skip_newlines();
                    continue;
                }
            }

            // If we still have pending annotations and reach a non-syntax item,
            // they're component-level annotations (e.g., @table on model)
            if !pending_annotations.is_empty() {
                component_annotations.append(&mut pending_annotations);
            }

            match &self.peek()?.kind {
                TokenKind::Fn => {
                    if let Some(stmt) = self.parse_fn_decl(false) {
                        blocks.push(stmt);
                    }
                }
                TokenKind::On => {
                    // on event(param) { body } → FnDecl("on_EVENT")
                    let sp = self.advance()?.span; // consume 'on'
                    self.skip_newlines();
                    let event_name = match &self.peek()?.kind {
                        TokenKind::Ident(n) => n.clone(),
                        _ => { self.error("expected event name after 'on'"); continue; }
                    };
                    self.advance();
                    let user_params = if self.check(&TokenKind::LParen) {
                        self.advance(); // consume '('
                        let p = self.parse_params().unwrap_or_default();
                        self.expect(&TokenKind::RParen);
                        p
                    } else {
                        vec![]
                    };
                    self.skip_newlines();
                    let mut body = self.parse_block()?;

                    // For each untyped param, treat as ptr from C callback
                    // and inject conversion: let param: string = forge_string_new(__raw_param, strlen(__raw_param))
                    let mut fn_params = Vec::new();
                    let mut prologue = Vec::new();
                    for p in &user_params {
                        if p.type_ann.is_none() {
                            let raw_name = format!("__raw_{}", p.name);
                            fn_params.push(Param {
                                name: raw_name.clone(),
                                type_ann: Some(TypeExpr::Named("ptr".into())),
                                default: None,
                                span: p.span,
                            });
                            prologue.push(Statement::Let {
                                name: p.name.clone(),
                                type_ann: Some(TypeExpr::Named("string".into())),
                                type_ann_span: None,
                                value: Expr::Call {
                                    callee: Box::new(Expr::Ident("forge_string_new".into(), sp)),
                                    args: vec![
                                        CallArg { name: None, value: Expr::Ident(raw_name.clone(), sp) },
                                        CallArg { name: None, value: Expr::Call {
                                            callee: Box::new(Expr::Ident("strlen".into(), sp)),
                                            args: vec![CallArg { name: None, value: Expr::Ident(raw_name, sp) }],
                                            type_args: vec![],
                                            span: sp,
                                        }},
                                    ],
                                    type_args: vec![],
                                    span: sp,
                                },
                                exported: false,
                                span: sp,
                            });
                        } else {
                            fn_params.push(p.clone());
                        }
                    }
                    // Prepend prologue to body
                    prologue.append(&mut body.statements);
                    body.statements = prologue;

                    blocks.push(Statement::FnDecl {
                        name: format!("on_{}", event_name),
                        type_params: vec![],
                        params: fn_params,
                        return_type: None,
                        body,
                        exported: false,
                        span: sp,
                    });
                }
                TokenKind::Ident(name) if name == "run" && self.peek_at(1).map_or(false, |t| matches!(t.kind, TokenKind::LBrace)) => {
                    // run { body } → FnDecl("__run")
                    let sp = self.advance()?.span; // consume 'run'
                    self.skip_newlines();
                    let mut body = self.parse_block()?;
                    // Append return 0 so fn ptr signature is () -> int
                    body.statements.push(Statement::Expr(Expr::IntLit(0, sp)));
                    blocks.push(Statement::FnDecl {
                        name: "__run".into(),
                        type_params: vec![],
                        params: vec![],
                        return_type: Some(TypeExpr::Named("int".into())),
                        body,
                        exported: false,
                        span: sp,
                    });
                }
                TokenKind::Ident(name) if name == "before" || name == "after" => {
                    // Hook: before/after operation(param) { body }
                    if let Some(stmt) = self.parse_component_hook() {
                        blocks.push(stmt);
                    }
                }
                TokenKind::Ident(name) if name == "under" => {
                    // `under /prefix { ... }` → push_prefix, inner stmts, pop_prefix
                    let sp = self.advance()?.span; // consume 'under'
                    self.skip_newlines();
                    // Parse prefix: string literal or /path tokens
                    let prefix = if matches!(&self.peek()?.kind, TokenKind::StringLiteral(_)) {
                        match &self.peek()?.kind {
                            TokenKind::StringLiteral(s) => { let s = s.clone(); self.advance(); s }
                            _ => String::new(),
                        }
                    } else {
                        // Collect path tokens until '{' (e.g., /api/v1)
                        let mut path = String::new();
                        while !self.check(&TokenKind::LBrace) && !self.check(&TokenKind::Newline) && !self.is_at_end() {
                            let tok = self.advance()?;
                            match &tok.kind {
                                TokenKind::Slash => path.push('/'),
                                TokenKind::Ident(s) => path.push_str(s),
                                TokenKind::IntLiteral(n) => path.push_str(&n.to_string()),
                                _ => break,
                            }
                        }
                        path
                    };
                    self.skip_newlines();
                    // Generate push_prefix call
                    blocks.push(Statement::Expr(Expr::Call {
                        callee: Box::new(Expr::Ident("__component_under_start".into(), sp)),
                        args: vec![CallArg { name: Some("prefix".into()), value: Expr::StringLit(prefix, sp) }],
                        type_args: vec![],
                        span: sp,
                    }));
                    // Parse inner block as component body items (recursive)
                    if self.check(&TokenKind::LBrace) {
                        self.advance(); // consume '{'
                        self.skip_newlines();
                        self.parse_under_body(meta, &mut blocks);
                        if self.check(&TokenKind::RBrace) {
                            self.advance(); // consume '}'
                        }
                    }
                    // Generate pop_prefix call
                    blocks.push(Statement::Expr(Expr::Call {
                        callee: Box::new(Expr::Ident("__component_under_end".into(), sp)),
                        args: vec![],
                        type_args: vec![],
                        span: sp,
                    }));
                }
                TokenKind::Ident(name) if name == "middleware" => {
                    // `middleware name { on request(req) {...} on response(req, res, elapsed) {...} }`
                    let sp = self.advance()?.span; // consume 'middleware'
                    self.skip_newlines();
                    let mw_name = match &self.peek()?.kind {
                        TokenKind::Ident(n) => n.clone(),
                        _ => { self.error("expected middleware name"); continue; }
                    };
                    self.advance(); // consume name
                    self.skip_newlines();
                    // Parse block with on request/response handlers
                    if self.check(&TokenKind::LBrace) {
                        self.advance(); // consume '{'
                        self.skip_newlines();
                        while !self.check(&TokenKind::RBrace) && !self.is_at_end() {
                            self.skip_newlines();
                            if self.check(&TokenKind::RBrace) { break; }
                            if matches!(&self.peek()?.kind, TokenKind::On) {
                                let on_sp = self.advance()?.span; // consume 'on'
                                self.skip_newlines();
                                let event = match &self.peek()?.kind {
                                    TokenKind::Ident(n) => n.clone(),
                                    _ => { self.advance(); continue; }
                                };
                                self.advance(); // consume event name
                                // Parse params
                                let params = if self.check(&TokenKind::LParen) {
                                    self.advance();
                                    let p = self.parse_params().unwrap_or_default();
                                    self.expect(&TokenKind::RParen);
                                    p
                                } else {
                                    vec![]
                                };
                                self.skip_newlines();
                                let mut body = self.parse_block()?;
                                // Generate middleware handler fn
                                let fn_name = format!("__mw_{}_{}", mw_name, event);
                                // Inject let bindings to map internal ptr params to user-named params
                                // User params: (method, path, body, headers) -> __m, __p, __b, __h via forge_http_ptr_to_str
                                let internal_names = ["__m", "__p", "__b", "__h"];
                                let mut injected: Vec<Statement> = Vec::new();
                                for (i, param) in params.iter().enumerate() {
                                    if i < internal_names.len() {
                                        injected.push(Statement::Let {
                                            name: param.name.clone(),
                                            type_ann: None,
                                            type_ann_span: None,
                                            value: Expr::Call {
                                                callee: Box::new(Expr::Ident("forge_http_ptr_to_str".into(), on_sp)),
                                                args: vec![CallArg { name: None, value: Expr::Ident(internal_names[i].into(), on_sp) }],
                                                type_args: vec![],
                                                span: on_sp,
                                            },
                                            exported: false,
                                            span: on_sp,
                                        });
                                    }
                                }
                                injected.append(&mut body.statements);
                                body.statements = injected;
                                // Create fn with handler signature matching MiddlewareFn
                                let handler_fn = Statement::FnDecl {
                                    name: fn_name.clone(),
                                    type_params: vec![],
                                    params: vec![
                                        Param { name: "__m".into(), type_ann: Some(TypeExpr::Named("ptr".into())), default: None, span: on_sp },
                                        Param { name: "__p".into(), type_ann: Some(TypeExpr::Named("ptr".into())), default: None, span: on_sp },
                                        Param { name: "__b".into(), type_ann: Some(TypeExpr::Named("ptr".into())), default: None, span: on_sp },
                                        Param { name: "__h".into(), type_ann: Some(TypeExpr::Named("ptr".into())), default: None, span: on_sp },
                                        Param { name: "__response_buf".into(), type_ann: Some(TypeExpr::Named("ptr".into())), default: None, span: on_sp },
                                        Param { name: "__response_buf_len".into(), type_ann: Some(TypeExpr::Named("int".into())), default: None, span: on_sp },
                                    ],
                                    return_type: Some(TypeExpr::Named("int".into())),
                                    body,
                                    exported: false,
                                    span: on_sp,
                                };
                                blocks.push(handler_fn);
                                // Register middleware
                                let register_fn = if event == "request" {
                                    "__component_use_mw"
                                } else {
                                    "__component_use_mw_after"
                                };
                                blocks.push(Statement::Expr(Expr::Call {
                                    callee: Box::new(Expr::Ident(register_fn.into(), on_sp)),
                                    args: vec![
                                        CallArg { name: Some("name".into()), value: Expr::StringLit(mw_name.clone(), on_sp) },
                                        CallArg { name: Some("handler".into()), value: Expr::Ident(fn_name, on_sp) },
                                    ],
                                    type_args: vec![],
                                    span: on_sp,
                                }));
                            } else {
                                self.advance(); // skip unknown tokens
                            }
                            self.skip_newlines();
                        }
                        if self.check(&TokenKind::RBrace) {
                            self.advance(); // consume '}'
                        }
                    }
                }
                TokenKind::Ident(name) if name == "crud" => {
                    // `crud Model1, Model2` → mount_crud_auto for each model
                    let sp = self.advance()?.span; // consume 'crud'
                    self.skip_newlines();
                    loop {
                        let model_name = match &self.peek()?.kind {
                            TokenKind::Ident(n) => n.clone(),
                            _ => break,
                        };
                        self.advance(); // consume model name
                        blocks.push(Statement::Expr(Expr::Call {
                            callee: Box::new(Expr::Ident("__component_crud_mount".into(), sp)),
                            args: vec![CallArg { name: Some("model".into()), value: Expr::StringLit(model_name, sp) }],
                            type_args: vec![],
                            span: sp,
                        }));
                        self.skip_newlines();
                        if self.check(&TokenKind::Comma) {
                            self.advance(); // consume ','
                            self.skip_newlines();
                        } else {
                            break;
                        }
                    }
                }
                TokenKind::Ident(_) => {
                    // Could be schema field (ident: type) or config (ident value)
                    // Look ahead to distinguish
                    let field_name = match &self.peek()?.kind {
                        TokenKind::Ident(n) => n.clone(),
                        _ => { self.advance(); continue; }
                    };
                    let field_span = self.advance()?.span;

                    if self.check(&TokenKind::Colon) {
                        // Schema field: name: type @annotations
                        self.advance();
                        self.skip_newlines();
                        let type_ann = self.parse_type_expr()?;

                        let mut annotations = Vec::new();
                        while self.check(&TokenKind::At) {
                            let ann_start = self.advance()?.span;
                            let ann_name = match &self.peek()?.kind {
                                TokenKind::Ident(n) => n.clone(),
                                TokenKind::Table => "table".to_string(),
                                TokenKind::Type => "type".to_string(),
                                _ => { self.error("expected annotation name"); break; }
                            };
                            self.advance();

                            let mut ann_args = Vec::new();
                            if self.check(&TokenKind::LParen) {
                                self.advance();
                                if !self.check(&TokenKind::RParen) {
                                    if let Some(arg) = self.parse_expr() {
                                        ann_args.push(arg);
                                    }
                                }
                                self.expect(&TokenKind::RParen);
                            }

                            annotations.push(Annotation {
                                name: ann_name,
                                args: ann_args,
                                span: ann_start,
                            });
                        }

                        schema.push(ComponentSchemaField {
                            name: field_name,
                            type_ann,
                            annotations,
                            span: field_span,
                        });
                    } else {
                        // Config: name value
                        if let Some(value) = self.parse_expr() {
                            config.push(ComponentConfig {
                                key: field_name,
                                value,
                                span: field_span,
                            });
                        } else {
                            // Just an identifier with no value — treat as config with bool true
                            config.push(ComponentConfig {
                                key: field_name.clone(),
                                value: Expr::BoolLit(true, field_span),
                                span: field_span,
                            });
                        }
                    }
                }
                _ => {
                    self.error("unexpected token in component block");
                    self.advance();
                }
            }
            self.skip_newlines();
        }

        self.expect(&TokenKind::RBrace)?;

        // Any remaining pending annotations are component-level
        if !pending_annotations.is_empty() {
            component_annotations.append(&mut pending_annotations);
        }

        Some(Statement::ComponentBlock(ComponentBlockDecl {
            component,
            args,
            body: ComponentBlockBody {
                annotations: component_annotations,
                config,
                schema,
                blocks,
            },
            span: start,
        }))
    }

    /// Parse the body of an `under /prefix { ... }` block recursively.
    /// Handles syntax patterns, nested under blocks, middleware, on/fn declarations, and mount.
    fn parse_under_body(&mut self, meta: &ComponentMeta, blocks: &mut Vec<Statement>) {
        while !self.check(&TokenKind::RBrace) && !self.is_at_end() {
            self.skip_newlines();
            if self.check(&TokenKind::RBrace) { break; }

            // Check for block keywords first
            let is_block_keyword = match &self.peek() {
                Some(t) => match &t.kind {
                    TokenKind::Ident(n) if n == "under" || n == "middleware" || n == "crud" => true,
                    TokenKind::On | TokenKind::Fn => true,
                    _ => false,
                },
                None => false,
            };

            // Try syntax patterns (routes, mount, etc.)
            if !is_block_keyword && !meta.syntax_patterns.is_empty() {
                if let Some(stmt) = self.try_syntax_match(meta) {
                    blocks.push(stmt);
                    self.skip_newlines();
                    continue;
                }
            }

            match &self.peek() {
                Some(t) => match &t.kind {
                    TokenKind::Ident(name) if name == "under" => {
                        // Nested under block — recurse
                        let sp = self.advance().unwrap().span;
                        self.skip_newlines();
                        let prefix = if matches!(self.peek().map(|t| &t.kind), Some(TokenKind::StringLiteral(_))) {
                            match &self.peek().unwrap().kind {
                                TokenKind::StringLiteral(s) => { let s = s.clone(); self.advance(); s }
                                _ => String::new(),
                            }
                        } else {
                            let mut path = String::new();
                            while !self.check(&TokenKind::LBrace) && !self.check(&TokenKind::Newline) && !self.is_at_end() {
                                let tok = self.advance().unwrap();
                                match &tok.kind {
                                    TokenKind::Slash => path.push('/'),
                                    TokenKind::Ident(s) => path.push_str(s),
                                    TokenKind::IntLiteral(n) => path.push_str(&n.to_string()),
                                    _ => break,
                                }
                            }
                            path
                        };
                        self.skip_newlines();
                        blocks.push(Statement::Expr(Expr::Call {
                            callee: Box::new(Expr::Ident("__component_under_start".into(), sp)),
                            args: vec![CallArg { name: Some("prefix".into()), value: Expr::StringLit(prefix, sp) }],
                            type_args: vec![],
                            span: sp,
                        }));
                        if self.check(&TokenKind::LBrace) {
                            self.advance();
                            self.skip_newlines();
                            self.parse_under_body(meta, blocks); // recurse
                            if self.check(&TokenKind::RBrace) {
                                self.advance();
                            }
                        }
                        blocks.push(Statement::Expr(Expr::Call {
                            callee: Box::new(Expr::Ident("__component_under_end".into(), sp)),
                            args: vec![],
                            type_args: vec![],
                            span: sp,
                        }));
                    }
                    TokenKind::Ident(name) if name == "middleware" => {
                        // Middleware inside under block — same logic as outer
                        let sp = self.advance().unwrap().span;
                        self.skip_newlines();
                        let mw_name = match self.peek().map(|t| t.kind.clone()) {
                            Some(TokenKind::Ident(n)) => n,
                            _ => { self.advance(); continue; }
                        };
                        self.advance(); // consume name
                        self.skip_newlines();
                        if self.check(&TokenKind::LBrace) {
                            self.advance();
                            self.skip_newlines();
                            while !self.check(&TokenKind::RBrace) && !self.is_at_end() {
                                self.skip_newlines();
                                if self.check(&TokenKind::RBrace) { break; }
                                if matches!(self.peek().map(|t| &t.kind), Some(&TokenKind::On)) {
                                    let on_sp = self.advance().unwrap().span;
                                    self.skip_newlines();
                                    let event = match self.peek().map(|t| t.kind.clone()) {
                                        Some(TokenKind::Ident(n)) => n,
                                        _ => { self.advance(); continue; }
                                    };
                                    self.advance();
                                    let params = if self.check(&TokenKind::LParen) {
                                        self.advance();
                                        let p = self.parse_params().unwrap_or_default();
                                        self.expect(&TokenKind::RParen);
                                        p
                                    } else {
                                        vec![]
                                    };
                                    self.skip_newlines();
                                    if let Some(mut body) = self.parse_block() {
                                        let fn_name = format!("__mw_{}_{}", mw_name, event);
                                        let internal_names = ["__m", "__p", "__b", "__h"];
                                        let mut injected: Vec<Statement> = Vec::new();
                                        for (i, param) in params.iter().enumerate() {
                                            if i < internal_names.len() {
                                                injected.push(Statement::Let {
                                                    name: param.name.clone(),
                                                    type_ann: None,
                                                    type_ann_span: None,
                                                    value: Expr::Call {
                                                        callee: Box::new(Expr::Ident("forge_http_ptr_to_str".into(), on_sp)),
                                                        args: vec![CallArg { name: None, value: Expr::Ident(internal_names[i].into(), on_sp) }],
                                                        type_args: vec![],
                                                        span: on_sp,
                                                    },
                                                    exported: false,
                                                    span: on_sp,
                                                });
                                            }
                                        }
                                        injected.append(&mut body.statements);
                                        body.statements = injected;
                                        blocks.push(Statement::FnDecl {
                                            name: fn_name.clone(),
                                            type_params: vec![],
                                            params: vec![
                                                Param { name: "__m".into(), type_ann: Some(TypeExpr::Named("ptr".into())), default: None, span: on_sp },
                                                Param { name: "__p".into(), type_ann: Some(TypeExpr::Named("ptr".into())), default: None, span: on_sp },
                                                Param { name: "__b".into(), type_ann: Some(TypeExpr::Named("ptr".into())), default: None, span: on_sp },
                                                Param { name: "__h".into(), type_ann: Some(TypeExpr::Named("ptr".into())), default: None, span: on_sp },
                                                Param { name: "__response_buf".into(), type_ann: Some(TypeExpr::Named("ptr".into())), default: None, span: on_sp },
                                                Param { name: "__response_buf_len".into(), type_ann: Some(TypeExpr::Named("int".into())), default: None, span: on_sp },
                                            ],
                                            return_type: Some(TypeExpr::Named("int".into())),
                                            body,
                                            exported: false,
                                            span: on_sp,
                                        });
                                        let register_fn = if event == "request" {
                                            "__component_use_mw"
                                        } else {
                                            "__component_use_mw_after"
                                        };
                                        blocks.push(Statement::Expr(Expr::Call {
                                            callee: Box::new(Expr::Ident(register_fn.into(), on_sp)),
                                            args: vec![
                                                CallArg { name: Some("name".into()), value: Expr::StringLit(mw_name.clone(), on_sp) },
                                                CallArg { name: Some("handler".into()), value: Expr::Ident(fn_name, on_sp) },
                                            ],
                                            type_args: vec![],
                                            span: on_sp,
                                        }));
                                    }
                                } else {
                                    self.advance();
                                }
                            }
                            if self.check(&TokenKind::RBrace) { self.advance(); }
                        }
                    }
                    TokenKind::Ident(name) if name == "crud" => {
                        // crud Model1, Model2 inside under block
                        let sp = self.advance().unwrap().span;
                        self.skip_newlines();
                        loop {
                            let model_name = match self.peek().map(|t| t.kind.clone()) {
                                Some(TokenKind::Ident(n)) => n,
                                _ => break,
                            };
                            self.advance();
                            blocks.push(Statement::Expr(Expr::Call {
                                callee: Box::new(Expr::Ident("__component_crud_mount".into(), sp)),
                                args: vec![CallArg { name: Some("model".into()), value: Expr::StringLit(model_name, sp) }],
                                type_args: vec![],
                                span: sp,
                            }));
                            self.skip_newlines();
                            if self.check(&TokenKind::Comma) {
                                self.advance();
                                self.skip_newlines();
                            } else {
                                break;
                            }
                        }
                    }
                    TokenKind::On => {
                        // on handler inside under block
                        if let Some(stmt) = self.parse_fn_decl(false) {
                            blocks.push(stmt);
                        } else {
                            self.advance();
                        }
                    }
                    TokenKind::Fn => {
                        if let Some(stmt) = self.parse_fn_decl(false) {
                            blocks.push(stmt);
                        } else {
                            self.advance();
                        }
                    }
                    _ => {
                        // Skip unknown tokens
                        self.advance();
                    }
                },
                None => break,
            }
        }
    }

    /// Parse a single annotation: @name or @name(arg1, arg2)
    fn parse_component_annotation(&mut self) -> Option<Annotation> {
        let ann_start = self.advance()?.span; // consume '@'
        // Accept identifiers and keywords as annotation names
        let ann_name = match &self.peek()?.kind {
            TokenKind::Ident(n) => n.clone(),
            TokenKind::Table => "table".to_string(),
            TokenKind::Type => "type".to_string(),
            _ => {
                self.error("expected annotation name after '@'");
                return None;
            }
        };
        self.advance();

        let mut ann_args = Vec::new();
        if self.check(&TokenKind::LParen) {
            self.advance();
            self.skip_newlines();
            while !self.check(&TokenKind::RParen) && !self.is_at_end() {
                self.skip_newlines();
                if let Some(arg) = self.parse_expr() {
                    ann_args.push(arg);
                }
                self.skip_newlines();
                if self.check(&TokenKind::Comma) {
                    self.advance();
                }
            }
            self.expect(&TokenKind::RParen);
        }

        Some(Annotation {
            name: ann_name,
            args: ann_args,
            span: ann_start,
        })
    }

    /// Parse a component template definition from provider.fg:
    /// `component model(__tpl_name, schema) { ... }`
    pub(crate) fn parse_component_template_def(&mut self) -> Option<Statement> {
        let start = self.expect(&TokenKind::Component)?.span; // consume 'component'
        self.skip_newlines();

        let component_name = self.expect_ident()?;
        self.skip_newlines();

        // Parse params: (__tpl_name, for __tpl_model_ref, schema)
        self.expect(&TokenKind::LParen)?;
        let mut has_schema = false;
        let mut has_model_ref = false;

        loop {
            self.skip_newlines();
            if self.check(&TokenKind::RParen) {
                break;
            }
            match &self.peek()?.kind {
                TokenKind::For => {
                    self.advance(); // consume 'for'
                    self.skip_newlines();
                    let _ref_name = self.expect_ident()?; // __tpl_model_ref
                    has_model_ref = true;
                }
                TokenKind::Ident(name) => {
                    if name == "schema" {
                        has_schema = true;
                    }
                    self.advance();
                }
                _ => {
                    self.advance();
                }
            }
            self.skip_newlines();
            if self.check(&TokenKind::Comma) {
                self.advance();
            }
        }
        self.expect(&TokenKind::RParen)?;
        self.skip_newlines();

        // Parse body
        self.expect(&TokenKind::LBrace)?;
        self.skip_newlines();

        let mut items = Vec::new();
        let mut config_schema = Vec::new();
        let mut syntax_fns = Vec::new();
        let mut annotation_decls = Vec::new();

        while !self.check(&TokenKind::RBrace) && !self.is_at_end() {
            self.skip_newlines();
            if self.check(&TokenKind::RBrace) {
                break;
            }

            match &self.peek()?.kind {
                TokenKind::Ident(name) if name == "annotation" => {
                    // annotation <target> <name>(<params>)
                    let ann_span = self.advance()?.span; // consume 'annotation'
                    self.skip_newlines();
                    // Target can be "field", "type", "route", "component", "function"
                    // "type" is a keyword (TokenKind::Type), so handle it specially
                    let target = match &self.peek()?.kind {
                        TokenKind::Type => {
                            self.advance();
                            "type".to_string()
                        }
                        TokenKind::Fn => {
                            self.advance();
                            "function".to_string()
                        }
                        TokenKind::Component => {
                            self.advance();
                            "component".to_string()
                        }
                        _ => self.expect_ident()?,
                    };
                    self.skip_newlines();
                    let ann_name = self.expect_ident()?;
                    let ann_params = if self.check(&TokenKind::LParen) {
                        self.advance();
                        let p = self.parse_params().unwrap_or_default();
                        self.expect(&TokenKind::RParen);
                        p
                    } else {
                        vec![]
                    };
                    annotation_decls.push(AnnotationDeclItem {
                        target,
                        name: ann_name,
                        params: ann_params,
                        span: ann_span,
                    });
                }
                TokenKind::Ident(name) if name == "event" => {
                    // event name(params)
                    let ev_span = self.advance()?.span; // consume 'event'
                    self.skip_newlines();
                    let ev_name = self.expect_ident()?;
                    let ev_params = if self.check(&TokenKind::LParen) {
                        self.advance();
                        let p = self.parse_params().unwrap_or_default();
                        self.expect(&TokenKind::RParen);
                        p
                    } else {
                        vec![]
                    };
                    items.push(ComponentTemplateItem::EventDecl {
                        name: ev_name,
                        params: ev_params,
                        span: ev_span,
                    });
                }
                TokenKind::Ident(name) if name == "config" => {
                    // config { key: type = default, ... }
                    self.advance(); // consume 'config'
                    self.skip_newlines();
                    self.expect(&TokenKind::LBrace)?;
                    self.skip_newlines();
                    while !self.check(&TokenKind::RBrace) && !self.is_at_end() {
                        self.skip_newlines();
                        if self.check(&TokenKind::RBrace) { break; }
                        let entry_span = self.peek()?.span;
                        let key = self.expect_ident()?;
                        self.expect(&TokenKind::Colon)?;
                        self.skip_newlines();
                        let type_ann = self.parse_type_expr()?;
                        let default = if self.check(&TokenKind::Eq) {
                            self.advance();
                            self.skip_newlines();
                            Some(self.parse_expr()?)
                        } else {
                            None
                        };
                        config_schema.push(ConfigSchemaEntry {
                            key,
                            type_ann,
                            default,
                            span: entry_span,
                        });
                        self.skip_newlines();
                    }
                    self.expect(&TokenKind::RBrace)?;
                }
                TokenKind::Type => {
                    // `type __tpl_name = __tpl_schema` → TypeFromSchema
                    self.advance(); // consume 'type'
                    self.skip_newlines();
                    let _type_name = self.expect_ident()?; // __tpl_name
                    self.skip_newlines();
                    self.expect(&TokenKind::Eq)?;
                    self.skip_newlines();
                    let schema_name = self.expect_ident()?; // __tpl_schema or __tpl_schema_visible
                    let visible_only = schema_name == "__tpl_schema_visible";
                    items.push(ComponentTemplateItem::TypeFromSchema { visible_only });
                }
                TokenKind::Fn => {
                    // fn __tpl_name.method(...) or fn __tpl_model_ref.method(...)
                    let fn_start = self.advance()?.span; // consume 'fn'
                    self.skip_newlines();

                    let first_name = self.expect_ident()?;
                    self.skip_newlines();

                    if (first_name.starts_with("__tpl_")) && self.check(&TokenKind::Dot) {
                        // Dotted template fn: __tpl_name.method or __tpl_model_ref.method
                        self.advance(); // consume '.'
                        let method_name = self.expect_ident()?;
                        self.skip_newlines();

                        // Parse params, return type, body as normal fn
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

                        let fn_name = format!("__tpl_fn_{}", method_name);
                        let decl = Statement::FnDecl {
                            name: fn_name,
                            type_params: Vec::new(),
                            params,
                            return_type,
                            body,
                            exported: false,
                            span: fn_start,
                        };
                        items.push(ComponentTemplateItem::FnTemplate {
                            method_name,
                            decl,
                        });
                    } else {
                        // Regular fn in template (unlikely but handle)
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
                        let decl = Statement::FnDecl {
                            name: first_name,
                            type_params: Vec::new(),
                            params,
                            return_type,
                            body,
                            exported: false,
                            span: fn_start,
                        };
                        items.push(ComponentTemplateItem::FnTemplate {
                            method_name: String::new(),
                            decl,
                        });
                    }
                }
                TokenKind::Ident(name) if name == "extern" => {
                    // extern fn declaration
                    if let Some(stmt) = self.parse_extern_fn() {
                        items.push(ComponentTemplateItem::ExternFn(stmt));
                    }
                }
                TokenKind::On => {
                    // on startup { ... } or on main_end { ... }
                    self.advance(); // consume 'on'
                    self.skip_newlines();
                    let lifecycle = self.expect_ident()?;
                    self.skip_newlines();
                    let block = self.parse_block()?;

                    match lifecycle.as_str() {
                        "startup" => items.push(ComponentTemplateItem::OnStartup(block.statements)),
                        "main_end" => items.push(ComponentTemplateItem::OnMainEnd(block.statements)),
                        _ => {
                            self.error(&format!("unknown lifecycle: {}", lifecycle));
                        }
                    }
                }
                TokenKind::At => {
                    // @syntax("pattern") fn name(params) { body }
                    let at_span = self.advance()?.span; // consume '@'
                    self.skip_newlines();
                    let decorator_name = self.expect_ident()?;
                    if decorator_name != "syntax" {
                        self.error(&format!("unknown decorator: @{}", decorator_name));
                        continue;
                    }
                    self.expect(&TokenKind::LParen)?;
                    let pattern = match &self.peek()?.kind {
                        TokenKind::StringLiteral(s) => s.clone(),
                        _ => { self.error("expected string pattern for @syntax"); continue; }
                    };
                    self.advance();
                    self.expect(&TokenKind::RParen)?;
                    self.skip_newlines();

                    // Parse the fn declaration that follows
                    self.expect(&TokenKind::Fn)?;
                    self.skip_newlines();
                    let fn_name = self.expect_ident()?;
                    self.skip_newlines();
                    self.expect(&TokenKind::LParen)?;
                    let fn_params = self.parse_params().unwrap_or_default();
                    self.expect(&TokenKind::RParen)?;
                    self.skip_newlines();
                    let _return_type = if self.check(&TokenKind::Arrow) {
                        self.advance();
                        self.skip_newlines();
                        Some(self.parse_type_expr()?)
                    } else {
                        None
                    };
                    self.skip_newlines();
                    let fn_body = self.parse_block()?;

                    syntax_fns.push(SyntaxFnDef {
                        pattern,
                        fn_name: fn_name.clone(),
                        params: fn_params.clone(),
                        body: fn_body,
                        span: at_span,
                    });
                }
                _ => {
                    self.error("unexpected token in component template body");
                    self.advance();
                }
            }
            self.skip_newlines();
        }

        self.expect(&TokenKind::RBrace)?;

        Some(Statement::ComponentTemplateDef(ComponentTemplateDef {
            component_name,
            has_schema,
            has_model_ref,
            config_schema,
            syntax_fns,
            annotation_decls,
            body: items,
            span: start,
        }))
    }
}
