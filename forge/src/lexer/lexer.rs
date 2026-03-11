use crate::errors::Diagnostic;
use crate::lexer::token::{Span, TemplatePart, Token, TokenKind};

pub struct Lexer<'a> {
    source: &'a str,
    chars: Vec<char>,
    pos: usize,
    line: u32,
    col: u32,
    diagnostics: Vec<Diagnostic>,
}

impl<'a> Lexer<'a> {
    pub fn new(source: &'a str) -> Self {
        Self {
            source,
            chars: source.chars().collect(),
            pos: 0,
            line: 1,
            col: 1,
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
                self.advance();
                TokenKind::Slash
            }
            '@' => {
                self.advance();
                TokenKind::At
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
                    "E0001",
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
                        "E0002",
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
                        "E0003",
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
                    parts.push(TemplatePart::Expr(expr));
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
                        "E0006",
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
                Ok(v) => Token::new(
                    TokenKind::IntLiteral(v),
                    Span::new(start, self.pos, line, col),
                ),
                Err(_) => {
                    self.diagnostics.push(Diagnostic::error(
                        "E0006",
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
            "catch" => TokenKind::Catch,
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
