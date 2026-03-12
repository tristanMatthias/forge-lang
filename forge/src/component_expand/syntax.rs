use crate::lexer::token::TokenKind;
use crate::lexer::Token;
use std::collections::HashMap;

/// A parsed syntax pattern from `@syntax("...")`
#[derive(Debug, Clone)]
pub struct SyntaxPattern {
    pub segments: Vec<PatternSegment>,
    pub fn_name: String,
}

#[derive(Debug, Clone)]
pub enum PatternSegment {
    /// Fixed text that must match a token exactly (e.g., "at", "->")
    Literal(String),
    /// A placeholder that captures tokens until the next literal or end (e.g., {method})
    Placeholder(String),
}

impl SyntaxPattern {
    /// Parse a pattern string like "{method} {path} -> {handler}" into segments
    pub fn parse(pattern: &str, fn_name: &str) -> Self {
        let mut segments = Vec::new();
        let mut chars = pattern.chars().peekable();

        while chars.peek().is_some() {
            // Skip leading whitespace
            while chars.peek() == Some(&' ') {
                chars.next();
            }
            if chars.peek().is_none() {
                break;
            }

            if chars.peek() == Some(&'{') {
                // Placeholder
                chars.next(); // consume '{'
                let mut name = String::new();
                while let Some(&c) = chars.peek() {
                    if c == '}' {
                        chars.next();
                        break;
                    }
                    name.push(c);
                    chars.next();
                }
                segments.push(PatternSegment::Placeholder(name));
            } else {
                // Literal — collect until next '{' or end
                let mut lit = String::new();
                while let Some(&c) = chars.peek() {
                    if c == '{' || c == ' ' {
                        break;
                    }
                    lit.push(c);
                    chars.next();
                }
                if !lit.is_empty() {
                    segments.push(PatternSegment::Literal(lit));
                }
            }
        }

        SyntaxPattern {
            segments,
            fn_name: fn_name.to_string(),
        }
    }

    /// Try to match tokens starting at `pos` against this pattern.
    /// Returns (captured_values_as_strings, new_pos) if matched.
    /// Matching stops at newline or end of tokens.
    pub fn try_match(
        &self,
        tokens: &[Token],
        pos: usize,
    ) -> Option<(HashMap<String, Vec<Token>>, usize)> {
        let mut captures: HashMap<String, Vec<Token>> = HashMap::new();
        let mut i = pos;

        for (seg_idx, segment) in self.segments.iter().enumerate() {
            // Skip newlines between segments
            while i < tokens.len() && matches!(tokens[i].kind, TokenKind::Newline) {
                // Don't skip newlines — they're line terminators in component blocks
                break;
            }

            match segment {
                PatternSegment::Literal(lit) => {
                    if i >= tokens.len() {
                        return None;
                    }
                    let tok_text = token_text(&tokens[i]);
                    if tok_text != *lit {
                        return None;
                    }
                    i += 1;
                }
                PatternSegment::Placeholder(name) => {
                    // Find the next literal in the pattern (may skip over other placeholders)
                    let next_literal = self.segments[seg_idx + 1..].iter().find_map(|s| {
                        if let PatternSegment::Literal(l) = s {
                            Some(l.as_str())
                        } else {
                            None
                        }
                    });

                    // Check if the immediately next segment is also a placeholder
                    let next_is_placeholder = self.segments.get(seg_idx + 1)
                        .map_or(false, |s| matches!(s, PatternSegment::Placeholder(_)));

                    let mut captured = Vec::new();
                    if next_is_placeholder {
                        // When followed by another placeholder, capture exactly ONE token
                        if i < tokens.len() && !matches!(tokens[i].kind, TokenKind::Newline | TokenKind::Eof) {
                            captured.push(tokens[i].clone());
                            i += 1;
                        }
                    } else if let Some(stop_at) = next_literal {
                        // Capture tokens until we hit the stop literal or newline/eof
                        while i < tokens.len() {
                            if matches!(tokens[i].kind, TokenKind::Newline | TokenKind::Eof) {
                                break;
                            }
                            if token_text(&tokens[i]) == stop_at {
                                break;
                            }
                            captured.push(tokens[i].clone());
                            i += 1;
                        }
                    } else {
                        // Last segment — capture remaining tokens, with brace/paren balancing
                        // for multi-line expressions (e.g., closures, blocks)
                        let mut brace_depth: i32 = 0;
                        let mut paren_depth: i32 = 0;
                        let mut started_group = false;
                        while i < tokens.len() {
                            match &tokens[i].kind {
                                TokenKind::LBrace => {
                                    brace_depth += 1;
                                    started_group = true;
                                }
                                TokenKind::RBrace => {
                                    brace_depth -= 1;
                                    if started_group && brace_depth <= 0 && paren_depth <= 0 {
                                        // Capture the closing brace and stop
                                        captured.push(tokens[i].clone());
                                        i += 1;
                                        break;
                                    }
                                }
                                TokenKind::LParen => {
                                    paren_depth += 1;
                                    started_group = true;
                                }
                                TokenKind::RParen => {
                                    paren_depth -= 1;
                                }
                                TokenKind::Newline | TokenKind::Eof => {
                                    if brace_depth <= 0 && paren_depth <= 0 {
                                        break;
                                    }
                                    // Skip newlines inside balanced groups
                                    i += 1;
                                    continue;
                                }
                                _ => {}
                            }
                            captured.push(tokens[i].clone());
                            i += 1;
                        }
                    }

                    if captured.is_empty() {
                        return None;
                    }
                    captures.insert(name.clone(), captured);
                }
            }
        }

        Some((captures, i))
    }
}

/// Convert a token to its string representation (for building captured values)
pub fn token_to_string(tok: &Token) -> String {
    token_text(tok)
}

/// Extract the text representation of a token for pattern matching
fn token_text(tok: &Token) -> String {
    match &tok.kind {
        TokenKind::Ident(s) => s.clone(),
        TokenKind::StringLiteral(s) => s.clone(),
        TokenKind::IntLiteral(n) => n.to_string(),
        TokenKind::FloatLiteral(f) => f.to_string(),
        TokenKind::BoolLiteral(b) => b.to_string(),
        TokenKind::Arrow => "->".to_string(),
        TokenKind::Slash => "/".to_string(),
        TokenKind::Colon => ":".to_string(),
        TokenKind::Dot => ".".to_string(),
        TokenKind::Star => "*".to_string(),
        TokenKind::At => "@".to_string(),
        TokenKind::Plus => "+".to_string(),
        TokenKind::Minus => "-".to_string(),
        TokenKind::Eq => "=".to_string(),
        TokenKind::Lt => "<".to_string(),
        TokenKind::Gt => ">".to_string(),
        TokenKind::On => "on".to_string(),
        _ => format!("{:?}", tok.kind),
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::lexer::token::Span;

    fn tok(kind: TokenKind) -> Token {
        Token::new(kind, Span::dummy())
    }

    #[test]
    fn test_parse_simple_pattern() {
        let pat = SyntaxPattern::parse("{method} {path} -> {handler}", "route");
        assert_eq!(pat.segments.len(), 4);
        assert!(matches!(&pat.segments[0], PatternSegment::Placeholder(n) if n == "method"));
        assert!(matches!(&pat.segments[1], PatternSegment::Placeholder(n) if n == "path"));
        assert!(matches!(&pat.segments[2], PatternSegment::Literal(l) if l == "->"));
        assert!(matches!(&pat.segments[3], PatternSegment::Placeholder(n) if n == "handler"));
        assert_eq!(pat.fn_name, "route");
    }

    #[test]
    fn test_parse_mount_pattern() {
        let pat = SyntaxPattern::parse("{service} at {path}", "mount");
        assert_eq!(pat.segments.len(), 3);
        assert!(matches!(&pat.segments[0], PatternSegment::Placeholder(n) if n == "service"));
        assert!(matches!(&pat.segments[1], PatternSegment::Literal(l) if l == "at"));
        assert!(matches!(&pat.segments[2], PatternSegment::Placeholder(n) if n == "path"));
    }

    #[test]
    fn test_match_route_pattern() {
        let pat = SyntaxPattern::parse("{method} {path} -> {handler}", "route");
        // Tokens: GET /health -> my_handler
        let tokens = vec![
            tok(TokenKind::Ident("GET".into())),
            tok(TokenKind::Slash),
            tok(TokenKind::Ident("health".into())),
            tok(TokenKind::Arrow),
            tok(TokenKind::Ident("my_handler".into())),
            tok(TokenKind::Newline),
        ];

        let result = pat.try_match(&tokens, 0);
        assert!(result.is_some());
        let (captures, new_pos) = result.unwrap();
        assert_eq!(new_pos, 5); // consumed 5 tokens, stopped at newline
        assert!(captures.contains_key("method"));
        assert!(captures.contains_key("path"));
        assert!(captures.contains_key("handler"));

        // method should capture "GET"
        let method_toks = &captures["method"];
        assert_eq!(method_toks.len(), 1);
        assert!(matches!(&method_toks[0].kind, TokenKind::Ident(s) if s == "GET"));

        // handler should capture "my_handler"
        let handler_toks = &captures["handler"];
        assert_eq!(handler_toks.len(), 1);
    }

    #[test]
    fn test_match_mount_pattern() {
        let pat = SyntaxPattern::parse("{service} at {path}", "mount");
        let tokens = vec![
            tok(TokenKind::Ident("UserService".into())),
            tok(TokenKind::Ident("at".into())),
            tok(TokenKind::Slash),
            tok(TokenKind::Ident("users".into())),
            tok(TokenKind::Newline),
        ];

        let result = pat.try_match(&tokens, 0);
        assert!(result.is_some());
        let (captures, new_pos) = result.unwrap();
        assert_eq!(new_pos, 4);
        assert_eq!(captures["service"].len(), 1);
        assert_eq!(captures["path"].len(), 2); // /users = 2 tokens
    }

    #[test]
    fn test_no_match() {
        let pat = SyntaxPattern::parse("{method} {path} -> {handler}", "route");
        // Tokens that don't have ->
        let tokens = vec![
            tok(TokenKind::Ident("cors".into())),
            tok(TokenKind::BoolLiteral(true)),
            tok(TokenKind::Newline),
        ];

        let result = pat.try_match(&tokens, 0);
        assert!(result.is_none());
    }

    #[test]
    fn test_match_with_multi_token_path() {
        let pat = SyntaxPattern::parse("{method} {path} -> {handler}", "route");
        // GET /users/:id -> get_user
        let tokens = vec![
            tok(TokenKind::Ident("GET".into())),
            tok(TokenKind::Slash),
            tok(TokenKind::Ident("users".into())),
            tok(TokenKind::Slash),
            tok(TokenKind::Colon),
            tok(TokenKind::Ident("id".into())),
            tok(TokenKind::Arrow),
            tok(TokenKind::Ident("get_user".into())),
            tok(TokenKind::Newline),
        ];

        let result = pat.try_match(&tokens, 0);
        assert!(result.is_some());
        let (captures, _) = result.unwrap();
        // path should capture: / users / : id (5 tokens)
        assert_eq!(captures["path"].len(), 5);
    }
}
