use crate::errors::Diagnostic;
use crate::lexer::token::{Span, TemplatePart, Token, TokenKind};

pub struct Lexer<'a> {
    _source: &'a str,
    chars: Vec<char>,
    pos: usize,
    line: u32,
    col: u32,
    /// Byte offset added to all generated span positions.
    /// Used for sub-parsing template expressions so spans map back to the original source.
    pos_offset: usize,
    diagnostics: Vec<Diagnostic>,
}

impl<'a> Lexer<'a> {
    pub fn new(source: &'a str) -> Self {
        Self {
            _source: source,
            chars: source.chars().collect(),
            pos: 0,
            line: 1,
            col: 1,
            pos_offset: 0,
            diagnostics: Vec::new(),
        }
    }

    /// Create a lexer that starts counting positions from a given offset.
    /// Used for sub-parsing template interpolation expressions so their
    /// spans map back to the original source file.
    pub fn new_with_offset(source: &'a str, pos_offset: usize, line: u32, col: u32) -> Self {
        Self {
            _source: source,
            chars: source.chars().collect(),
            pos: 0,
            line,
            col,
            pos_offset,
            diagnostics: Vec::new(),
        }
    }

    pub fn tokenize(&mut self) -> Vec<Token> {
        let mut tokens = Vec::new();

        loop {
            self.skip_whitespace_except_newline();
            self.skip_comments();

            if self.is_at_end() {
                tokens.push(Token::new(
                    TokenKind::Eof,
                    Span::new(self.pos, self.pos, self.line, self.col),
                ));
                break;
            }

            if let Some(tok) = self.next_token() {
                tokens.push(tok);
            }
        }

        // Apply position offset for sub-parsed expressions (template interpolations).
        // The lexer works with local positions internally; this shifts all span byte
        // offsets so they map back to the original source file.
        if self.pos_offset > 0 {
            for tok in &mut tokens {
                tok.span.start += self.pos_offset;
                tok.span.end += self.pos_offset;
            }
        }

        tokens
    }

    pub fn diagnostics(&self) -> &[Diagnostic] {
        &self.diagnostics
    }

    fn next_token(&mut self) -> Option<Token> {
        let start = self.pos;
        let line = self.line;
        let col = self.col;
        let ch = self.peek()?;

        let kind = match ch {
            '\n' => {
                self.advance();
                TokenKind::Newline
            }
            '(' => {
                self.advance();
                TokenKind::LParen
            }
            ')' => {
                self.advance();
                TokenKind::RParen
            }
            '{' => {
                self.advance();
                TokenKind::LBrace
            }
            '}' => {
                self.advance();
                TokenKind::RBrace
            }
            '[' => {
                self.advance();
                TokenKind::LBracket
            }
            ']' => {
                self.advance();
                TokenKind::RBracket
            }
            ',' => {
                self.advance();
                TokenKind::Comma
            }
            ':' => {
                self.advance();
                TokenKind::Colon
            }
            ';' => {
                self.advance();
                TokenKind::Semicolon
            }
            '@' => {
                self.advance();
                TokenKind::At
            }
            '#' => {
                self.advance();
                TokenKind::Hash
            }
            '+' => {
                self.advance();
                TokenKind::Plus
            }
            '*' => {
                self.advance();
                TokenKind::Star
            }
            '%' => {
                self.advance();
                TokenKind::Percent
            }
            '&' => {
                self.advance();
                if self.peek() == Some('&') {
                    self.advance();
                    TokenKind::And
                } else {
                    TokenKind::Ampersand
                }
            }
            '|' => {
                self.advance();
                if self.peek() == Some('>') {
                    self.advance();
                    TokenKind::Pipe
                } else if self.peek() == Some('|') {
                    self.advance();
                    TokenKind::Or
                } else {
                    // standalone | used in patterns and union types
                    TokenKind::Ampersand // reuse for now — we'll handle in parser
                }
            }
            '-' => {
                self.advance();
                if self.peek() == Some('>') {
                    self.advance();
                    TokenKind::Arrow
                } else {
                    TokenKind::Minus
                }
            }
            '=' => {
                self.advance();
                if self.peek() == Some('=') {
                    self.advance();
                    TokenKind::EqEq
                } else {
                    TokenKind::Eq
                }
            }
            '!' => {
                self.advance();
                if self.peek() == Some('=') {
                    self.advance();
                    TokenKind::NotEq
                } else {
                    TokenKind::Not
                }
            }
            '<' => {
                self.advance();
                if self.peek() == Some('=') {
                    self.advance();
                    TokenKind::LtEq
                } else if self.peek() == Some('-') {
                    self.advance();
                    TokenKind::LeftArrow
                } else {
                    TokenKind::Lt
                }
            }
            '>' => {
                self.advance();
                if self.peek() == Some('=') {
                    self.advance();
                    TokenKind::GtEq
                } else {
                    TokenKind::Gt
                }
            }
            '?' => {
                self.advance();
                if self.peek() == Some('.') {
                    self.advance();
                    TokenKind::QuestionDot
                } else if self.peek() == Some('?') {
                    self.advance();
                    TokenKind::DoubleQuestion
                } else {
                    TokenKind::Question
                }
            }
            '.' => {
                self.advance();
                if self.peek() == Some('.') {
                    self.advance();
                    if self.peek() == Some('=') {
                        self.advance();
                        TokenKind::DotDotEq
                    } else if self.peek() == Some('.') {
                        self.advance();
                        TokenKind::Spread
                    } else {
                        TokenKind::DotDot
                    }
                } else {
                    TokenKind::Dot
                }
            }
            '/' => {
                // Check for doc comment: /// (but not ////)
                if self.peek_at(1) == Some('/') && self.peek_at(2) == Some('/') && self.peek_at(3) != Some('/') {
                    self.advance(); // /
                    self.advance(); // /
                    self.advance(); // /
                    // Skip optional single leading space
                    if self.peek() == Some(' ') {
                        self.advance();
                    }
                    let mut text = String::new();
                    while let Some(c) = self.peek() {
                        if c == '\n' {
                            break;
                        }
                        text.push(c);
                        self.advance();
                    }
                    TokenKind::DocComment(text)
                } else {
                    self.advance();
                    TokenKind::Slash
                }
            }
            '$' => {
                self.advance();
                if self.peek() == Some('"') {
                    return Some(self.lex_dollar_string(start, line, col));
                } else if self.peek() == Some('`') {
                    return Some(self.lex_dollar_template(start, line, col));
                }
                // Standalone $ - not currently used, treat as error
                self.diagnostics.push(Diagnostic::error(
                    "F0001",
                    "unexpected character: '$'",
                    Span::new(start, self.pos, line, col),
                ));
                return None;
            }
            '"' => return Some(self.lex_string(start, line, col)),
            '`' => return Some(self.lex_template(start, line, col)),
            _ if ch.is_ascii_digit() => return Some(self.lex_number(start, line, col)),
            _ if ch.is_alphabetic() || ch == '_' => {
                return Some(self.lex_ident_or_keyword(start, line, col))
            }
            _ => {
                self.advance();
                self.diagnostics.push(Diagnostic::error(
                    "F0001",
                    format!("unexpected character: '{}'", ch),
                    Span::new(start, self.pos, line, col),
                ));
                return None;
            }
        };

        Some(Token::new(kind, Span::new(start, self.pos, line, col)))
    }

    fn lex_string(&mut self, start: usize, line: u32, col: u32) -> Token {
        self.advance(); // skip opening "
        let mut s = String::new();
        loop {
            match self.peek() {
                None => {
                    self.diagnostics.push(Diagnostic::error(
                        "F0002",
                        "unterminated string literal",
                        Span::new(start, self.pos, line, col),
                    ));
                    break;
                }
                Some('\\') => {
                    self.advance();
                    match self.peek() {
                        Some('n') => {
                            self.advance();
                            s.push('\n');
                        }
                        Some('t') => {
                            self.advance();
                            s.push('\t');
                        }
                        Some('\\') => {
                            self.advance();
                            s.push('\\');
                        }
                        Some('"') => {
                            self.advance();
                            s.push('"');
                        }
                        Some(c) => {
                            self.advance();
                            s.push(c);
                        }
                        None => {}
                    }
                }
                Some('"') => {
                    self.advance();
                    break;
                }
                Some(c) => {
                    self.advance();
                    s.push(c);
                }
            }
        }
        Token::new(
            TokenKind::StringLiteral(s),
            Span::new(start, self.pos, line, col),
        )
    }

    fn lex_template(&mut self, start: usize, line: u32, col: u32) -> Token {
        self.advance(); // skip opening `
        let mut parts = Vec::new();
        let mut current = String::new();

        loop {
            match self.peek() {
                None => {
                    self.diagnostics.push(Diagnostic::error(
                        "F0003",
                        "unterminated template literal",
                        Span::new(start, self.pos, line, col),
                    ));
                    break;
                }
                Some('`') => {
                    self.advance();
                    if !current.is_empty() {
                        parts.push(TemplatePart::Literal(current));
                    }
                    break;
                }
                Some('$') if self.peek_at(1) == Some('{') => {
                    if !current.is_empty() {
                        parts.push(TemplatePart::Literal(current.clone()));
                        current.clear();
                    }
                    self.advance(); // $
                    self.advance(); // {
                    let expr_start = self.pos;
                    let expr_line = self.line;
                    let expr_col = self.col;
                    let mut expr = String::new();
                    let mut depth = 1;
                    while depth > 0 {
                        match self.peek() {
                            Some('{') => {
                                depth += 1;
                                expr.push('{');
                                self.advance();
                            }
                            Some('}') => {
                                depth -= 1;
                                if depth > 0 {
                                    expr.push('}');
                                }
                                self.advance();
                            }
                            Some(c) => {
                                expr.push(c);
                                self.advance();
                            }
                            None => break,
                        }
                    }
                    parts.push(TemplatePart::Expr(expr, Span::new(expr_start, self.pos, expr_line, expr_col)));
                }
                Some('\\') => {
                    self.advance();
                    match self.peek() {
                        Some('n') => {
                            self.advance();
                            current.push('\n');
                        }
                        Some('`') => {
                            self.advance();
                            current.push('`');
                        }
                        Some(c) => {
                            self.advance();
                            current.push(c);
                        }
                        None => {}
                    }
                }
                Some(c) => {
                    self.advance();
                    current.push(c);
                }
            }
        }

        Token::new(
            TokenKind::TemplateLiteral(parts),
            Span::new(start, self.pos, line, col),
        )
    }

    /// Lex $"..." — shell command with no interpolation
    fn lex_dollar_string(&mut self, start: usize, line: u32, col: u32) -> Token {
        self.advance(); // skip opening "
        let mut parts = Vec::new();
        let mut current = String::new();
        loop {
            match self.peek() {
                None => {
                    self.diagnostics.push(Diagnostic::error(
                        "F0002",
                        "unterminated dollar-string literal",
                        Span::new(start, self.pos, line, col),
                    ));
                    break;
                }
                Some('\\') => {
                    self.advance();
                    match self.peek() {
                        Some('"') => { self.advance(); current.push('"'); }
                        Some('\\') => { self.advance(); current.push('\\'); }
                        Some(c) => { self.advance(); current.push('\\'); current.push(c); }
                        None => {}
                    }
                }
                Some('$') if self.peek_at(1) == Some('{') => {
                    if !current.is_empty() {
                        parts.push(TemplatePart::Literal(current.clone()));
                        current.clear();
                    }
                    self.advance(); // $
                    self.advance(); // {
                    let expr_start = self.pos;
                    let expr_line = self.line;
                    let expr_col = self.col;
                    let mut expr = String::new();
                    let mut depth = 1;
                    while depth > 0 {
                        match self.peek() {
                            Some('{') => { depth += 1; expr.push('{'); self.advance(); }
                            Some('}') => { depth -= 1; if depth > 0 { expr.push('}'); } self.advance(); }
                            Some(c) => { expr.push(c); self.advance(); }
                            None => break,
                        }
                    }
                    parts.push(TemplatePart::Expr(expr, Span::new(expr_start, self.pos, expr_line, expr_col)));
                }
                Some('"') => {
                    self.advance();
                    if !current.is_empty() {
                        parts.push(TemplatePart::Literal(current));
                    }
                    break;
                }
                Some(c) => {
                    self.advance();
                    current.push(c);
                }
            }
        }
        Token::new(
            TokenKind::DollarString(parts),
            Span::new(start, self.pos, line, col),
        )
    }

    /// Lex $`...` — shell command with ${...} interpolation
    fn lex_dollar_template(&mut self, start: usize, line: u32, col: u32) -> Token {
        self.advance(); // skip opening `
        let mut parts = Vec::new();
        let mut current = String::new();

        loop {
            match self.peek() {
                None => {
                    self.diagnostics.push(Diagnostic::error(
                        "F0003",
                        "unterminated dollar-template literal",
                        Span::new(start, self.pos, line, col),
                    ));
                    break;
                }
                Some('`') => {
                    self.advance();
                    if !current.is_empty() {
                        parts.push(TemplatePart::Literal(current));
                    }
                    break;
                }
                Some('$') if self.peek_at(1) == Some('{') => {
                    if !current.is_empty() {
                        parts.push(TemplatePart::Literal(current.clone()));
                        current.clear();
                    }
                    self.advance(); // $
                    self.advance(); // {
                    let expr_start = self.pos;
                    let expr_line = self.line;
                    let expr_col = self.col;
                    let mut expr = String::new();
                    let mut depth = 1;
                    while depth > 0 {
                        match self.peek() {
                            Some('{') => { depth += 1; expr.push('{'); self.advance(); }
                            Some('}') => { depth -= 1; if depth > 0 { expr.push('}'); } self.advance(); }
                            Some(c) => { expr.push(c); self.advance(); }
                            None => break,
                        }
                    }
                    parts.push(TemplatePart::Expr(expr, Span::new(expr_start, self.pos, expr_line, expr_col)));
                }
                Some(c) => {
                    self.advance();
                    current.push(c);
                }
            }
        }

        Token::new(
            TokenKind::DollarString(parts),
            Span::new(start, self.pos, line, col),
        )
    }

    /// Lex tag`...` — tagged template literal with ${...} interpolation
    fn lex_tagged_template(&mut self, tag: String, start: usize, line: u32, col: u32) -> Token {
        self.advance(); // skip opening `
        let mut parts = Vec::new();
        let mut current = String::new();

        loop {
            match self.peek() {
                None => {
                    self.diagnostics.push(Diagnostic::error(
                        "F0003",
                        "unterminated tagged template literal",
                        Span::new(start, self.pos, line, col),
                    ));
                    break;
                }
                Some('`') => {
                    self.advance();
                    if !current.is_empty() {
                        parts.push(TemplatePart::Literal(current));
                    }
                    break;
                }
                Some('\\') => {
                    self.advance();
                    match self.peek() {
                        Some('`') => { self.advance(); current.push('`'); }
                        Some('\\') => { self.advance(); current.push('\\'); }
                        Some('$') => { self.advance(); current.push('$'); }
                        Some('n') => { self.advance(); current.push('\n'); }
                        Some('t') => { self.advance(); current.push('\t'); }
                        Some(c) => { self.advance(); current.push('\\'); current.push(c); }
                        None => {}
                    }
                }
                Some('$') if self.peek_at(1) == Some('{') => {
                    if !current.is_empty() {
                        parts.push(TemplatePart::Literal(current.clone()));
                        current.clear();
                    }
                    self.advance(); // $
                    self.advance(); // {
                    let expr_start = self.pos;
                    let expr_line = self.line;
                    let expr_col = self.col;
                    let mut expr = String::new();
                    let mut depth = 1;
                    while depth > 0 {
                        match self.peek() {
                            Some('{') => { depth += 1; expr.push('{'); self.advance(); }
                            Some('}') => { depth -= 1; if depth > 0 { expr.push('}'); } self.advance(); }
                            Some(c) => { expr.push(c); self.advance(); }
                            None => break,
                        }
                    }
                    parts.push(TemplatePart::Expr(expr, Span::new(expr_start, self.pos, expr_line, expr_col)));
                }
                Some(c) => {
                    self.advance();
                    current.push(c);
                }
            }
        }

        Token::new(
            TokenKind::TaggedTemplate(tag, parts, None),
            Span::new(start, self.pos, line, col),
        )
    }

    /// Lex tag<Type>`...` — tagged template literal with type parameter
    fn lex_typed_tagged_template(&mut self, tag: String, type_param: String, start: usize, line: u32, col: u32) -> Token {
        self.advance(); // skip opening `
        let mut parts = Vec::new();
        let mut current = String::new();

        loop {
            match self.peek() {
                None => {
                    self.diagnostics.push(Diagnostic::error(
                        "F0003",
                        "unterminated tagged template literal",
                        Span::new(start, self.pos, line, col),
                    ));
                    break;
                }
                Some('`') => {
                    self.advance();
                    if !current.is_empty() {
                        parts.push(TemplatePart::Literal(current));
                    }
                    break;
                }
                Some('\\') => {
                    self.advance();
                    match self.peek() {
                        Some('`') => { self.advance(); current.push('`'); }
                        Some('\\') => { self.advance(); current.push('\\'); }
                        Some('$') => { self.advance(); current.push('$'); }
                        Some('n') => { self.advance(); current.push('\n'); }
                        Some('t') => { self.advance(); current.push('\t'); }
                        Some(c) => { self.advance(); current.push('\\'); current.push(c); }
                        None => {}
                    }
                }
                Some('$') if self.peek_at(1) == Some('{') => {
                    if !current.is_empty() {
                        parts.push(TemplatePart::Literal(current.clone()));
                        current.clear();
                    }
                    self.advance(); // $
                    self.advance(); // {
                    let expr_start = self.pos;
                    let expr_line = self.line;
                    let expr_col = self.col;
                    let mut expr = String::new();
                    let mut depth = 1;
                    while depth > 0 {
                        match self.peek() {
                            Some('{') => { depth += 1; expr.push('{'); self.advance(); }
                            Some('}') => { depth -= 1; if depth > 0 { expr.push('}'); } self.advance(); }
                            Some(c) => { expr.push(c); self.advance(); }
                            None => {
                                self.diagnostics.push(Diagnostic::error(
                                    "F0003",
                                    "unterminated interpolation in tagged template",
                                    Span::new(expr_start, self.pos, expr_line, expr_col),
                                ));
                                break;
                            }
                        }
                    }
                    let span = Span::new(expr_start, self.pos, expr_line, expr_col);
                    parts.push(TemplatePart::Expr(expr, span));
                }
                Some(c) => {
                    current.push(c);
                    self.advance();
                }
            }
        }

        Token::new(
            TokenKind::TaggedTemplate(tag, parts, Some(type_param)),
            Span::new(start, self.pos, line, col),
        )
    }

    fn lex_number(&mut self, start: usize, line: u32, col: u32) -> Token {
        let mut is_float = false;

        while let Some(c) = self.peek() {
            if c.is_ascii_digit() {
                self.advance();
            } else if c == '.' && self.peek_at(1).map_or(false, |c2| c2.is_ascii_digit()) {
                is_float = true;
                self.advance(); // .
            } else if c == '.' && self.peek_at(1) == Some('.') {
                // This is a range like 0..5, stop before the dots
                break;
            } else {
                break;
            }
        }

        let text: String = self.chars[start..self.pos].iter().collect();

        if is_float {
            match text.parse::<f64>() {
                Ok(v) => Token::new(
                    TokenKind::FloatLiteral(v),
                    Span::new(start, self.pos, line, col),
                ),
                Err(_) => {
                    self.diagnostics.push(Diagnostic::error(
                        "F0006",
                        format!("invalid float literal: {}", text),
                        Span::new(start, self.pos, line, col),
                    ));
                    Token::new(
                        TokenKind::FloatLiteral(0.0),
                        Span::new(start, self.pos, line, col),
                    )
                }
            }
        } else {
            match text.parse::<i64>() {
                Ok(v) => {
                    // Duration suffix: d (days), h (hours), m (minutes), s (seconds)
                    // Only match if the suffix char is NOT followed by an alphanumeric or underscore
                    // (to avoid matching identifiers like `5min` or variable patterns)
                    let multiplier = match self.peek() {
                        Some('d') if !self.peek_at(1).map_or(false, |c| c.is_alphanumeric() || c == '_') => {
                            self.advance();
                            Some(86_400_000i64) // days -> ms
                        }
                        Some('h') if !self.peek_at(1).map_or(false, |c| c.is_alphanumeric() || c == '_') => {
                            self.advance();
                            Some(3_600_000i64) // hours -> ms
                        }
                        Some('m') if !self.peek_at(1).map_or(false, |c| c.is_alphanumeric() || c == '_') => {
                            self.advance();
                            Some(60_000i64) // minutes -> ms
                        }
                        Some('s') if !self.peek_at(1).map_or(false, |c| c.is_alphanumeric() || c == '_') => {
                            self.advance();
                            Some(1_000i64) // seconds -> ms
                        }
                        _ => None,
                    };
                    let value = match multiplier {
                        Some(mul) => v * mul,
                        None => v,
                    };
                    Token::new(
                        TokenKind::IntLiteral(value),
                        Span::new(start, self.pos, line, col),
                    )
                }
                Err(_) => {
                    self.diagnostics.push(Diagnostic::error(
                        "F0006",
                        format!("invalid integer literal: {}", text),
                        Span::new(start, self.pos, line, col),
                    ));
                    Token::new(
                        TokenKind::IntLiteral(0),
                        Span::new(start, self.pos, line, col),
                    )
                }
            }
        }
    }

    fn lex_ident_or_keyword(&mut self, start: usize, line: u32, col: u32) -> Token {
        while let Some(c) = self.peek() {
            if c.is_alphanumeric() || c == '_' {
                self.advance();
            } else {
                break;
            }
        }

        let text: String = self.chars[start..self.pos].iter().collect();

        // Check for tagged template literal: ident`...`
        // If identifier is immediately followed by backtick (no whitespace), lex as tagged template
        if self.peek() == Some('`') {
            // Only treat as tagged template if it's an identifier (not a keyword)
            let is_keyword = matches!(text.as_str(),
                "let" | "mut" | "const" | "fn" | "return" | "if" | "else" | "match" |
                "for" | "in" | "while" | "loop" | "break" | "continue" | "enum" |
                "type" | "use" | "as" | "export" | "emit" | "on" | "trait" | "impl" |
                "defer" | "errdefer" | "spawn" | "parallel" | "with" | "without" |
                "only" | "partial" | "catch" | "select" | "component" | "is" |
                "table" | "true" | "false" | "null" | "Ok" | "Err" | "_"
            );
            if !is_keyword {
                return self.lex_tagged_template(text, start, line, col);
            }
        }

        // Check for typed tagged template: ident<Type>`...`
        // Look for < followed by matching > then backtick
        if self.peek() == Some('<') {
            let is_keyword = matches!(text.as_str(),
                "let" | "mut" | "const" | "fn" | "return" | "if" | "else" | "match" |
                "for" | "in" | "while" | "loop" | "break" | "continue" | "enum" |
                "type" | "use" | "as" | "export" | "emit" | "on" | "trait" | "impl" |
                "defer" | "errdefer" | "spawn" | "parallel" | "with" | "without" |
                "only" | "partial" | "catch" | "select" | "component" | "is" |
                "table" | "true" | "false" | "null" | "Ok" | "Err" | "_"
            );
            if !is_keyword {
                // Look ahead: find matching > then backtick
                let mut lookahead = 1; // skip the <
                let mut depth = 1;
                let mut found_type_param = false;
                while let Some(c) = self.peek_at(lookahead) {
                    match c {
                        '<' => { depth += 1; lookahead += 1; }
                        '>' => {
                            depth -= 1;
                            lookahead += 1;
                            if depth == 0 {
                                // Check if immediately followed by backtick
                                if self.peek_at(lookahead) == Some('`') {
                                    found_type_param = true;
                                }
                                break;
                            }
                        }
                        '\n' | '\r' => break, // type params don't span lines
                        _ => { lookahead += 1; }
                    }
                }
                if found_type_param {
                    self.advance(); // skip <
                    let mut type_str = String::new();
                    let mut depth = 1;
                    loop {
                        match self.peek() {
                            Some('<') => { depth += 1; type_str.push('<'); self.advance(); }
                            Some('>') => {
                                depth -= 1;
                                if depth == 0 { self.advance(); break; }
                                type_str.push('>');
                                self.advance();
                            }
                            Some(c) => { type_str.push(c); self.advance(); }
                            None => break,
                        }
                    }
                    // Now at backtick
                    return self.lex_typed_tagged_template(text, type_str, start, line, col);
                }
            }
        }

        let kind = match text.as_str() {
            "let" => TokenKind::Let,
            "mut" => TokenKind::Mut,
            "const" => TokenKind::Const,
            "fn" => TokenKind::Fn,
            "return" => TokenKind::Return,
            "if" => TokenKind::If,
            "else" => TokenKind::Else,
            "match" => TokenKind::Match,
            "for" => TokenKind::For,
            "in" => TokenKind::In,
            "while" => TokenKind::While,
            "loop" => TokenKind::Loop,
            "break" => TokenKind::Break,
            "continue" => TokenKind::Continue,
            "enum" => TokenKind::Enum,
            "type" => TokenKind::Type,
            "use" => TokenKind::Use,
            "as" => TokenKind::As,
            "export" => TokenKind::Export,
            "emit" => TokenKind::Emit,
            "on" => TokenKind::On,
            "trait" => TokenKind::Trait,
            "impl" => TokenKind::Impl,
            "defer" => TokenKind::Defer,
            "errdefer" => TokenKind::Errdefer,
            "spawn" => TokenKind::Spawn,
            "parallel" => TokenKind::Parallel,
            "with" => TokenKind::With,
            "without" => TokenKind::Without,
            "only" => TokenKind::Only,
            "partial" => TokenKind::Partial,
            "catch" => TokenKind::Catch,
            "select" => TokenKind::Select,
            "component" => TokenKind::Component,
            "is" => TokenKind::Is,
            "table" => TokenKind::Table,
            "true" => TokenKind::BoolLiteral(true),
            "false" => TokenKind::BoolLiteral(false),
            "null" => TokenKind::NullLiteral,
            "Ok" => TokenKind::Ok_,
            "Err" => TokenKind::Err_,
            "_" => TokenKind::Underscore,
            _ => TokenKind::Ident(text),
        };

        Token::new(kind, Span::new(start, self.pos, line, col))
    }

    fn skip_whitespace_except_newline(&mut self) {
        while let Some(c) = self.peek() {
            if c == ' ' || c == '\t' || c == '\r' {
                self.advance();
            } else {
                break;
            }
        }
    }

    fn skip_comments(&mut self) {
        if self.peek() == Some('/') && self.peek_at(1) == Some('/') {
            // Don't skip doc comments (///) — they become DocComment tokens
            if self.peek_at(2) == Some('/') && self.peek_at(3) != Some('/') {
                return;
            }
            while let Some(c) = self.peek() {
                if c == '\n' {
                    break;
                }
                self.advance();
            }
        }
    }

    fn peek(&self) -> Option<char> {
        self.chars.get(self.pos).copied()
    }

    fn peek_at(&self, offset: usize) -> Option<char> {
        self.chars.get(self.pos + offset).copied()
    }

    fn advance(&mut self) -> Option<char> {
        let ch = self.chars.get(self.pos).copied()?;
        self.pos += 1;
        if ch == '\n' {
            self.line += 1;
            self.col = 1;
        } else {
            self.col += 1;
        }
        Some(ch)
    }

    fn is_at_end(&self) -> bool {
        self.pos >= self.chars.len()
    }
}
