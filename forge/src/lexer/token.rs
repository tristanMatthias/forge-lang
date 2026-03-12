#[derive(Debug, Clone, PartialEq)]
pub enum TokenKind {
    // Literals
    IntLiteral(i64),
    FloatLiteral(f64),
    StringLiteral(String),
    TemplateLiteral(Vec<TemplatePart>),
    DollarString(Vec<TemplatePart>), // $"..." or $`...` — shell command
    BoolLiteral(bool),
    NullLiteral,

    // Identifiers
    Ident(String),

    // Keywords
    Let,
    Mut,
    Const,
    Fn,
    Return,
    If,
    Else,
    Match,
    For,
    In,
    While,
    Loop,
    Break,
    Continue,
    Enum,
    Type,
    Use,
    As,
    Export,
    Emit,
    On,
    Trait,
    Impl,
    Defer,
    Errdefer,
    Spawn,
    Parallel,
    With,
    Catch,
    Select,
    Component,
    Null,
    Ok_,
    Err_,

    // Operators
    Plus,
    Minus,
    Star,
    Slash,
    Percent,
    Eq,
    EqEq,
    NotEq,
    Lt,
    LtEq,
    Gt,
    GtEq,
    And,
    Or,
    Not,
    Pipe,
    Arrow,
    LeftArrow,  // <-
    Question,
    QuestionDot,
    DoubleQuestion,
    DotDot,
    DotDotEq,
    Ampersand,

    // Delimiters
    LParen,
    RParen,
    LBrace,
    RBrace,
    LBracket,
    RBracket,

    // Punctuation
    Comma,
    Dot,
    Colon,
    Semicolon,
    At,
    Hash,
    Underscore,
    Spread,

    // Special
    Newline,
    Eof,
}

#[derive(Debug, Clone, PartialEq)]
pub enum TemplatePart {
    Literal(String),
    Expr(String), // raw expression text to be parsed later
}

#[derive(Debug, Clone, Copy, PartialEq, serde::Serialize)]
pub struct Span {
    pub start: usize,
    pub end: usize,
    pub line: u32,
    pub col: u32,
}

impl Span {
    pub fn new(start: usize, end: usize, line: u32, col: u32) -> Self {
        Self {
            start,
            end,
            line,
            col,
        }
    }

    pub fn dummy() -> Self {
        Self {
            start: 0,
            end: 0,
            line: 0,
            col: 0,
        }
    }
}

#[derive(Debug, Clone)]
pub struct Token {
    pub kind: TokenKind,
    pub span: Span,
}

impl Token {
    pub fn new(kind: TokenKind, span: Span) -> Self {
        Self { kind, span }
    }
}
