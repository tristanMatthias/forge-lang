# Forge Compiler — Phase 1 Implementation Spec

**Goal:** Build a working compiler that takes Forge source files (`.fg`) and produces native binaries via LLVM. Phase 1 covers the core language only — no packages, no models, no servers. Just the foundation that everything else builds on.

**Success criteria:** The test programs at the end of this document all compile and run correctly.

---

## 1. Architecture Overview

```
source.fg
    │
    ▼
┌──────────┐
│  Lexer   │  src/lexer/
│          │  Produces token stream
└────┬─────┘
     │
     ▼
┌──────────┐
│  Parser  │  src/parser/
│          │  Produces AST
└────┬─────┘
     │
     ▼
┌──────────┐
│  Type    │  src/typeck/
│  Checker │  Validates types, infers types, resolves names
└────┬─────┘
     │
     ▼
┌──────────┐
│  Codegen │  src/codegen/
│          │  Lowers AST to LLVM IR via inkwell
└────┬─────┘
     │
     ▼
┌──────────┐
│  Driver  │  src/driver/
│          │  Orchestrates pipeline, calls linker, produces binary
└──────────┘
```

## 2. Project Structure

```
forge/
├── Cargo.toml
├── Cargo.lock
├── src/
│   ├── main.rs              # CLI entry point (clap)
│   ├── lib.rs               # Library root, re-exports modules
│   ├── lexer/
│   │   ├── mod.rs           # Lexer module root
│   │   ├── token.rs         # Token types enum
│   │   └── lexer.rs         # Lexer implementation
│   ├── parser/
│   │   ├── mod.rs           # Parser module root
│   │   ├── ast.rs           # AST node types
│   │   └── parser.rs        # Recursive descent parser
│   ├── typeck/
│   │   ├── mod.rs           # Type checker module root
│   │   ├── types.rs         # Forge type representations
│   │   ├── env.rs           # Type environment / symbol table
│   │   └── checker.rs       # Type checking / inference logic
│   ├── codegen/
│   │   ├── mod.rs           # Codegen module root
│   │   └── codegen.rs       # LLVM IR generation via inkwell
│   ├── driver/
│   │   ├── mod.rs           # Driver module root
│   │   └── driver.rs        # Pipeline orchestration
│   └── errors/
│       ├── mod.rs           # Error module root
│       └── diagnostic.rs    # Error types, formatting, source spans
├── tests/
│   ├── lexer_tests.rs       # Unit tests for lexer
│   ├── parser_tests.rs      # Unit tests for parser
│   ├── typeck_tests.rs      # Unit tests for type checker
│   ├── codegen_tests.rs     # Integration tests: source -> binary -> run
│   └── programs/            # Test Forge programs (.fg files)
│       ├── hello.fg
│       ├── arithmetic.fg
│       ├── functions.fg
│       ├── control_flow.fg
│       ├── strings.fg
│       ├── closures.fg
│       ├── pattern_matching.fg
│       ├── structs.fg
│       ├── enums.fg
│       ├── generics.fg
│       ├── error_handling.fg
│       ├── nullability.fg
│       ├── immutability.fg
│       ├── destructuring.fg
│       ├── pipes.fg
│       └── ranges.fg
└── stdlib/
    └── runtime.c            # Minimal C runtime (print, string alloc, refcount)
```

## 3. Dependencies (Cargo.toml)

```toml
[package]
name = "forge"
version = "0.1.0"
edition = "2021"
description = "The Forge programming language compiler"

[dependencies]
# LLVM bindings — use the version matching your system LLVM
# Run `llvm-config --version` to check. For LLVM 18:
inkwell = { version = "0.8", features = ["llvm18-1"] }

# CLI argument parsing
clap = { version = "4", features = ["derive"] }

# Better error formatting
ariadne = "0.4"          # Fancy error messages with source spans

# Colored terminal output
colored = "2"

# String interning for identifiers
lasso = "0.7"

# Index types for AST node IDs
index_vec = "0.1"

[dev-dependencies]
assert_cmd = "2"          # Test CLI binary
predicates = "3"          # Assertions for command output
tempfile = "3"            # Temporary test files
```

## 4. Token Types

```rust
// src/lexer/token.rs

#[derive(Debug, Clone, PartialEq)]
pub enum TokenKind {
    // Literals
    IntLiteral(i64),
    FloatLiteral(f64),
    StringLiteral(String),       // "hello"
    TemplateLiteral(String),     // `hello ${name}` (raw, parsed later)
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

    // Operators
    Plus,           // +
    Minus,          // -
    Star,           // *
    Slash,          // /
    Percent,        // %
    Eq,             // =
    EqEq,           // ==
    NotEq,          // !=
    Lt,             // <
    LtEq,           // <=
    Gt,             // >
    GtEq,           // >=
    And,            // &&
    Or,             // ||
    Not,            // !
    Pipe,           // |>
    Arrow,          // ->
    Question,       // ?
    QuestionDot,    // ?.
    DoubleQuestion, // ??
    DotDot,         // ..
    DotDotEq,       // ..=
    Ampersand,      // &

    // Delimiters
    LParen,         // (
    RParen,         // )
    LBrace,         // {
    RBrace,         // }
    LBracket,       // [
    RBracket,       // ]

    // Punctuation
    Comma,          // ,
    Dot,            // .
    Colon,          // :
    Semicolon,      // ; (not used in syntax, but reserved)
    At,             // @
    Hash,           // #
    Underscore,     // _
    Spread,         // ...

    // Special
    Newline,        // significant in some contexts
    Eof,
}

#[derive(Debug, Clone)]
pub struct Token {
    pub kind: TokenKind,
    pub span: Span,
}

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Span {
    pub start: usize,    // byte offset in source
    pub end: usize,      // byte offset in source
    pub line: u32,
    pub col: u32,
}
```

## 5. AST Node Types

```rust
// src/parser/ast.rs

/// A complete Forge source file
pub struct Program {
    pub statements: Vec<Statement>,
}

/// Top-level and block-level statements
pub enum Statement {
    Let {
        name: String,
        type_ann: Option<TypeExpr>,
        value: Expr,
        span: Span,
    },
    Mut {
        name: String,
        type_ann: Option<TypeExpr>,
        value: Expr,
        span: Span,
    },
    Const {
        name: String,
        type_ann: Option<TypeExpr>,
        value: Expr,
        span: Span,
    },
    Assign {
        target: Expr,
        value: Expr,
        span: Span,
    },
    FnDecl {
        name: String,
        params: Vec<Param>,
        return_type: Option<TypeExpr>,
        body: Block,
        exported: bool,
        span: Span,
    },
    EnumDecl {
        name: String,
        variants: Vec<EnumVariant>,
        exported: bool,
        span: Span,
    },
    TypeDecl {
        name: String,
        value: TypeExpr,
        exported: bool,
        span: Span,
    },
    TraitDecl {
        name: String,
        type_params: Vec<String>,
        methods: Vec<TraitMethod>,
        exported: bool,
        span: Span,
    },
    ImplDecl {
        trait_name: String,
        for_type: String,
        methods: Vec<Statement>,    // FnDecl items
        span: Span,
    },
    Expr(Expr),                      // expression statement
    Return {
        value: Option<Expr>,
        span: Span,
    },
    Defer {
        body: Expr,
        span: Span,
    },
    Errdefer {
        body: Expr,
        span: Span,
    },
    Use {
        path: Vec<String>,          // ["@std", "http", "server"]
        items: Option<Vec<UseItem>>, // None = wildcard import
        span: Span,
    },
    For {
        pattern: Pattern,
        iterable: Expr,
        body: Block,
        span: Span,
    },
    While {
        condition: Expr,
        body: Block,
        span: Span,
    },
    Loop {
        body: Block,
        label: Option<String>,
        span: Span,
    },
    Break {
        value: Option<Expr>,
        label: Option<String>,
        span: Span,
    },
    Continue {
        label: Option<String>,
        span: Span,
    },
}

pub struct Param {
    pub name: String,
    pub type_ann: TypeExpr,
    pub default: Option<Expr>,
    pub span: Span,
}

pub struct UseItem {
    pub name: String,
    pub alias: Option<String>,
}

pub struct Block {
    pub statements: Vec<Statement>,
    pub span: Span,
}

/// Expressions — everything that produces a value
pub enum Expr {
    // Literals
    IntLit(i64, Span),
    FloatLit(f64, Span),
    StringLit(String, Span),
    TemplateLit {
        parts: Vec<TemplatePart>,
        span: Span,
    },
    BoolLit(bool, Span),
    NullLit(Span),

    // Identifiers
    Ident(String, Span),
    It(Span),                     // implicit closure parameter

    // Compound literals
    ListLit {
        elements: Vec<Expr>,
        span: Span,
    },
    MapLit {
        entries: Vec<(Expr, Expr)>,
        span: Span,
    },
    StructLit {
        fields: Vec<(String, Expr)>,
        span: Span,
    },
    TupleLit {
        elements: Vec<Expr>,
        span: Span,
    },

    // Operations
    Binary {
        left: Box<Expr>,
        op: BinaryOp,
        right: Box<Expr>,
        span: Span,
    },
    Unary {
        op: UnaryOp,
        operand: Box<Expr>,
        span: Span,
    },
    Call {
        callee: Box<Expr>,
        args: Vec<CallArg>,
        span: Span,
    },
    MemberAccess {
        object: Box<Expr>,
        field: String,
        span: Span,
    },
    Index {
        object: Box<Expr>,
        index: Box<Expr>,
        span: Span,
    },
    Pipe {
        left: Box<Expr>,
        right: Box<Expr>,
        span: Span,
    },

    // Closures
    Closure {
        params: Vec<Param>,
        body: Box<Expr>,           // single expression or block
        span: Span,
    },

    // Control flow (as expressions)
    If {
        condition: Box<Expr>,
        then_branch: Block,
        else_branch: Option<Block>,
        span: Span,
    },
    Match {
        subject: Box<Expr>,
        arms: Vec<MatchArm>,
        span: Span,
    },
    Block(Block),

    // Nullable operations
    NullCoalesce {
        left: Box<Expr>,
        right: Box<Expr>,
        span: Span,
    },
    NullPropagate {
        object: Box<Expr>,
        field: String,
        span: Span,
    },
    ErrorPropagate {
        operand: Box<Expr>,
        span: Span,
    },

    // With expression (immutable update)
    With {
        base: Box<Expr>,
        updates: Vec<(String, Expr)>,  // field paths and new values
        span: Span,
    },

    // Range
    Range {
        start: Box<Expr>,
        end: Box<Expr>,
        inclusive: bool,
        step: Option<Box<Expr>>,
        span: Span,
    },

    // Let-else (unwrap or diverge)
    LetElse {
        pattern: Pattern,
        value: Box<Expr>,
        else_block: Block,
        span: Span,
    },

    // Parallel block
    Parallel {
        exprs: Vec<Expr>,
        timeout: Option<Box<Expr>>,
        span: Span,
    },

    // Type operations
    TypeCheck {
        value: Box<Expr>,
        type_expr: TypeExpr,
        span: Span,
    },
    TypeCast {
        value: Box<Expr>,
        type_expr: TypeExpr,
        safe: bool,               // as? (safe) vs as! (assertion)
        span: Span,
    },
}

pub struct CallArg {
    pub name: Option<String>,      // for named arguments
    pub value: Expr,
}

pub struct MatchArm {
    pub pattern: Pattern,
    pub guard: Option<Expr>,
    pub body: Expr,
    pub span: Span,
}

pub enum Pattern {
    Wildcard(Span),                            // _
    Ident(String, Span),                       // binds a variable
    Literal(Expr),                             // matches a literal value
    Struct {
        fields: Vec<(String, Pattern)>,
        rest: bool,                            // .. for partial match
        span: Span,
    },
    Tuple(Vec<Pattern>, Span),
    List {
        elements: Vec<Pattern>,
        rest: Option<String>,                  // ...rest binding
        span: Span,
    },
    Enum {
        variant: String,
        fields: Vec<Pattern>,
        span: Span,
    },
    Or(Vec<Pattern>, Span),                    // pattern1 | pattern2
}

pub enum BinaryOp {
    Add, Sub, Mul, Div, Mod,
    Eq, NotEq, Lt, LtEq, Gt, GtEq,
    And, Or,
}

pub enum UnaryOp {
    Neg, Not,
}

pub enum TemplatePart {
    Literal(String),
    Expr(Expr),
    FormattedExpr {
        expr: Expr,
        format_spec: String,
    },
}

/// Type expressions in annotations
pub enum TypeExpr {
    Named(String),                             // int, string, User
    Generic {
        name: String,
        args: Vec<TypeExpr>,
    },                                         // List<int>, Map<string, User>
    Nullable(Box<TypeExpr>),                   // string?
    Union(Vec<TypeExpr>),                      // string | int
    Intersection(Vec<TypeExpr>),               // HasName & HasEmail
    Tuple(Vec<TypeExpr>),                      // (string, int)
    Function {
        params: Vec<TypeExpr>,
        return_type: Box<TypeExpr>,
    },                                         // (int, int) -> int
    Struct {
        fields: Vec<(String, TypeExpr)>,
    },                                         // { name: string, age: int }
    InlineEnum(Vec<String>),                   // enum(pending, active, done)
}

pub struct EnumVariant {
    pub name: String,
    pub fields: Vec<Param>,                    // empty for simple variants
    pub span: Span,
}

pub struct TraitMethod {
    pub name: String,
    pub params: Vec<Param>,                    // first param is self
    pub return_type: Option<TypeExpr>,
    pub default_body: Option<Block>,
    pub span: Span,
}
```

## 6. Type System Internals

```rust
// src/typeck/types.rs

/// Internal type representation (resolved, not syntactic)
pub enum Type {
    Int,
    Float,
    Bool,
    String,
    Char,
    Void,
    Never,

    Nullable(Box<Type>),
    List(Box<Type>),
    Map(Box<Type>, Box<Type>),
    Set(Box<Type>),
    Tuple(Vec<Type>),

    Struct {
        fields: Vec<(String, Type)>,
    },
    Enum {
        name: String,
        variants: Vec<EnumVariantType>,
    },
    Function {
        params: Vec<Type>,
        return_type: Box<Type>,
    },

    // For generics — a type variable to be resolved
    TypeVar(u32),

    // Named type reference (resolved to a concrete type)
    Named(String, Box<Type>),

    // Result type
    Result(Box<Type>, Box<Type>),

    // Range/iterator
    Range(Box<Type>),
    Stream(Box<Type>),

    // Unknown (for inference, must be resolved by end of checking)
    Unknown,

    // Error sentinel (allows type checking to continue past errors)
    Error,
}

pub struct EnumVariantType {
    pub name: String,
    pub fields: Vec<(String, Type)>,
}
```

## 7. Codegen Strategy

The codegen module translates the type-checked AST to LLVM IR using inkwell. Key design decisions:

### 7.1 Value Representation

| Forge Type | LLVM Type | Notes |
|---|---|---|
| `int` | `i64` | Always 64-bit |
| `float` | `f64` | Always 64-bit |
| `bool` | `i1` | |
| `string` | `{ i8*, i64 }` | Pointer + length. Strings are ref-counted heap allocations |
| `List<T>` | `{ T*, i64, i64 }` | Pointer + length + capacity. Ref-counted |
| `T?` | `{ i1, T }` | Tag + value. Tag 0 = null, 1 = present |
| structs | LLVM struct | Fields laid out in declaration order |
| enums | Tagged union | `{ i8, <largest variant> }` |
| closures | `{ fn_ptr, env_ptr }` | Function pointer + captured environment |
| `Result<T,E>` | `{ i8, <max(T,E)> }` | Tag 0 = Ok, 1 = Err |

### 7.2 Reference Counting

For Phase 1, use a simple reference counting scheme:

- Every heap-allocated value (strings, lists, maps, structs with heap fields) has a hidden `rc: i64` field at offset 0
- Assignment increments the new target's rc, decrements the old
- Scope exit decrements all live variables' rc
- When rc reaches 0, call the type's drop function (free memory)
- NO cycle detection in Phase 1 — add in Phase 2

The codegen inserts `forge_rc_retain(ptr)` and `forge_rc_release(ptr)` calls. These are defined in the C runtime (`stdlib/runtime.c`).

### 7.3 C Runtime

A small C file provides the runtime functions that compiled Forge programs link against:

```c
// stdlib/runtime.c

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

// ---- Reference counting ----

typedef struct {
    int64_t rc;
    // payload follows
} ForgeHeapObj;

void forge_rc_retain(void* ptr) {
    if (ptr == NULL) return;
    ForgeHeapObj* obj = (ForgeHeapObj*)((char*)ptr - sizeof(int64_t));
    obj->rc++;
}

void forge_rc_release(void* ptr) {
    if (ptr == NULL) return;
    ForgeHeapObj* obj = (ForgeHeapObj*)((char*)ptr - sizeof(int64_t));
    obj->rc--;
    if (obj->rc <= 0) {
        free(obj);
    }
}

void* forge_alloc(int64_t size) {
    ForgeHeapObj* obj = (ForgeHeapObj*)malloc(sizeof(int64_t) + size);
    obj->rc = 1;
    return (void*)((char*)obj + sizeof(int64_t));
}

// ---- String operations ----

typedef struct {
    char* ptr;
    int64_t len;
} ForgeString;

ForgeString forge_string_new(const char* data, int64_t len) {
    char* buf = (char*)forge_alloc(len + 1);
    memcpy(buf, data, len);
    buf[len] = '\0';
    return (ForgeString){ .ptr = buf, .len = len };
}

ForgeString forge_string_concat(ForgeString a, ForgeString b) {
    int64_t new_len = a.len + b.len;
    char* buf = (char*)forge_alloc(new_len + 1);
    memcpy(buf, a.ptr, a.len);
    memcpy(buf + a.len, b.ptr, b.len);
    buf[new_len] = '\0';
    return (ForgeString){ .ptr = buf, .len = new_len };
}

// ---- Print functions ----

void forge_print_int(int64_t value) {
    printf("%lld", (long long)value);
}

void forge_print_float(double value) {
    printf("%g", value);
}

void forge_print_string(ForgeString s) {
    fwrite(s.ptr, 1, s.len, stdout);
}

void forge_print_bool(int8_t value) {
    printf("%s", value ? "true" : "false");
}

void forge_println_string(ForgeString s) {
    fwrite(s.ptr, 1, s.len, stdout);
    putchar('\n');
}

// ---- Conversion ----

ForgeString forge_int_to_string(int64_t value) {
    char buf[32];
    int len = snprintf(buf, sizeof(buf), "%lld", (long long)value);
    return forge_string_new(buf, len);
}

ForgeString forge_float_to_string(double value) {
    char buf[64];
    int len = snprintf(buf, sizeof(buf), "%g", value);
    return forge_string_new(buf, len);
}

ForgeString forge_bool_to_string(int8_t value) {
    return value ? forge_string_new("true", 4) : forge_string_new("false", 5);
}
```

This runtime is compiled to an object file (`runtime.o`) and linked into every Forge binary.

### 7.4 Compilation Pipeline

```
1. Compile runtime.c → runtime.o (once, cached)
2. For each .fg file:
   a. Lex → tokens
   b. Parse → AST
   c. Type check → typed AST
   d. Codegen → LLVM module
3. Link all LLVM modules together
4. Run LLVM optimization passes (O0 for dev, O2 for release)
5. Emit object file via LLVM's target machine
6. Link object file + runtime.o → native binary (via system cc)
```

## 8. CLI Interface

```
USAGE:
    forge <COMMAND>

COMMANDS:
    build       Compile the project
    run         Compile and run
    check       Type-check without compiling (fast feedback)
    version     Print version info

OPTIONS for `build`:
    --dev               Debug build (O0, fast compile)
    --release           Release build (O2, optimized) [default]
    --emit-ir           Output LLVM IR instead of binary
    --emit-ast          Output parsed AST as JSON
    --error-format      "human" (default) or "json"
    -o, --output        Output binary path

OPTIONS for `run`:
    Same as build, plus:
    -- <args>           Arguments passed to the compiled program
```

Example usage:

```bash
# Build and run a single file
forge run hello.fg

# Build a project (reads forge.toml)
forge build

# Type check only
forge check src/main.fg

# Dump LLVM IR for inspection
forge build --emit-ir hello.fg

# JSON errors for tool integration
forge build --error-format=json hello.fg
```

## 9. Error Message Format

### 9.1 Human Format

```
error[E0012]: type mismatch
  --> src/main.fg:23:14
   |
22 |  let user = get_user(id)
23 |  let name: int = user.name
   |            ^^^   ^^^^^^^^^ this is string
   |            |
   |            expected int
   |
   = help: did you mean `let name: string = user.name`?
```

Use the `ariadne` crate for this — it produces Rust-quality error messages with colored source snippets.

### 9.2 JSON Format

```json
{
  "errors": [{
    "code": "E0012",
    "severity": "error",
    "message": "type mismatch",
    "file": "src/main.fg",
    "line": 23,
    "col": 14,
    "span": { "start": 456, "end": 459 },
    "suggestions": [{
      "message": "change type annotation to string",
      "replacement": { "span": { "start": 456, "end": 459 }, "text": "string" },
      "confidence": 0.95
    }]
  }],
  "warnings": []
}
```

### 9.3 Error Code Registry (Phase 1)

| Code | Description |
|---|---|
| E0001 | Unexpected token |
| E0002 | Unterminated string literal |
| E0003 | Unterminated template literal |
| E0004 | Expected expression |
| E0005 | Expected type annotation |
| E0006 | Invalid number literal |
| E0010 | Undefined variable |
| E0011 | Undefined function |
| E0012 | Type mismatch |
| E0013 | Cannot assign to immutable variable |
| E0014 | Wrong number of arguments |
| E0015 | Cannot infer type |
| E0016 | Duplicate definition |
| E0017 | Non-exhaustive match |
| E0018 | Unreachable pattern |
| E0019 | Return type mismatch |
| E0020 | Cannot apply operator to types |
| E0021 | Cannot call non-function |
| E0022 | Field does not exist on type |
| E0023 | Cannot use `?` outside of Result-returning function |
| E0024 | Null access on non-nullable type |
| E0025 | Cannot mutate immutable binding |

## 10. Test Programs

These programs define what Phase 1 must support. Each one should compile and produce the expected output.

### 10.1 hello.fg — Basic output
```forge
fn main() {
  println("hello, forge!")
}
// Expected output: hello, forge!
```

### 10.2 arithmetic.fg — Primitives and math
```forge
fn main() {
  let x = 10
  let y = 3
  println(string(x + y))      // 13
  println(string(x - y))      // 7
  println(string(x * y))      // 30
  println(string(x / y))      // 3 (integer division)
  println(string(x % y))      // 1

  let a = 3.14
  let b = 2.0
  println(string(a * b))      // 6.28

  let flag = true
  println(string(!flag))      // false
}
```

### 10.3 immutability.fg — let vs mut vs const
```forge
fn main() {
  let x = 42
  // x = 43              // ERROR: cannot assign to immutable binding

  mut counter = 0
  counter = counter + 1
  counter = counter + 1
  println(string(counter))   // 2

  const MAX = 100
  // MAX = 200           // ERROR: cannot assign to const
  println(string(MAX))      // 100
}
```

### 10.4 functions.fg — Functions and closures
```forge
fn add(a: int, b: int) -> int {
  a + b
}

fn greet(name: string, greeting: string = "hello") -> string {
  `${greeting}, ${name}!`
}

fn apply(x: int, f: (int) -> int) -> int {
  f(x)
}

fn main() {
  println(string(add(3, 4)))           // 7
  println(greet("alice"))              // hello, alice!
  println(greet("bob", "hey"))         // hey, bob!

  let double = (x: int) -> x * 2
  println(string(apply(5, double)))    // 10

  // Single arg, no parens
  let triple = x -> x * 3
  println(string(triple(4)))           // 12
}
```

### 10.5 strings.fg — String interpolation
```forge
fn main() {
  let name = "forge"
  let version = 1
  println(`welcome to ${name} v${version}`)
  // Expected: welcome to forge v1

  let multiline = `
    this is
    multiline
  `
  println(multiline)

  println(string("hello".length))      // 5
  println("hello".upper())             // HELLO
  println("WORLD".lower())             // world
  println(string("hello world".contains("world")))  // true
}
```

### 10.6 control_flow.fg — if/else, match, loops
```forge
fn main() {
  // If as expression
  let x = 10
  let label = if x > 5 { "big" } else { "small" }
  println(label)                // big

  // Match
  let score = 85
  let grade = match score {
    s if s >= 90 -> "A"
    s if s >= 80 -> "B"
    s if s >= 70 -> "C"
    _ -> "F"
  }
  println(grade)                // B

  // For loop
  mut sum = 0
  for i in 0..5 {
    sum = sum + i
  }
  println(string(sum))          // 10

  // While loop
  mut n = 1
  while n < 100 {
    n = n * 2
  }
  println(string(n))            // 128

  // Loop with break value
  mut i = 0
  let found = loop {
    if i * i > 50 {
      break i
    }
    i = i + 1
  }
  println(string(found))       // 8
}
```

### 10.7 nullability.fg — Nullable types
```forge
fn find_user(id: int) -> string? {
  if id == 1 { "alice" } else { null }
}

fn main() {
  let name = find_user(1)
  let display = name ?? "unknown"
  println(display)              // alice

  let missing = find_user(99)
  let display2 = missing ?? "unknown"
  println(display2)             // unknown

  // Safe navigation
  let len = name?.length ?? 0
  println(string(len))          // 5

  // Smart narrowing
  if name != null {
    println(name.upper())       // ALICE
  }
}
```

### 10.8 structs.fg — Structural types and with
```forge
type Point = { x: float, y: float }

fn distance(p: Point) -> float {
  // simplified — no sqrt in Phase 1
  p.x * p.x + p.y * p.y
}

fn main() {
  let origin = { x: 0.0, y: 0.0 }
  let p = { x: 3.0, y: 4.0 }

  println(string(distance(p)))     // 25 (no sqrt)

  // With expression
  let moved = p with { x: 10.0 }
  println(string(moved.x))        // 10
  println(string(moved.y))        // 4
}
```

### 10.9 enums.fg — Enums and pattern matching
```forge
enum Shape {
  circle(radius: float)
  rectangle(width: float, height: float)
  point
}

fn describe(s: Shape) -> string {
  match s {
    .circle(r) -> `circle with radius ${r}`
    .rectangle(w, h) -> `${w}x${h} rectangle`
    .point -> "a point"
  }
}

fn main() {
  let c = Shape.circle(radius: 5.0)
  let r = Shape.rectangle(width: 3.0, height: 4.0)
  let p = Shape.point

  println(describe(c))     // circle with radius 5
  println(describe(r))     // 3x4 rectangle
  println(describe(p))     // a point
}
```

### 10.10 error_handling.fg — Result, ?, catch
```forge
fn divide(a: float, b: float) -> Result<float, string> {
  if b == 0.0 {
    Err("division by zero")
  } else {
    Ok(a / b)
  }
}

fn calculate() -> Result<float, string> {
  let x = divide(10.0, 2.0)?     // Ok(5.0), unwraps to 5.0
  let y = divide(x, 0.0)?        // Err("division by zero"), returns early
  Ok(y)
}

fn main() {
  let result = calculate() catch (e) {
    println(`error: ${e}`)         // error: division by zero
    0.0
  }
  println(string(result))          // 0
}
```

### 10.11 destructuring.fg — Pattern destructuring
```forge
fn swap(pair: (int, int)) -> (int, int) {
  let (a, b) = pair
  (b, a)
}

fn main() {
  let (x, y) = swap((1, 2))
  println(string(x))               // 2
  println(string(y))               // 1

  let point = { x: 10, y: 20, z: 30 }
  let { x, z } = point
  println(string(x))               // 10
  println(string(z))               // 30

  let [first, second, ...rest] = [1, 2, 3, 4, 5]
  println(string(first))           // 1
  println(string(rest.length))     // 3
}
```

### 10.12 pipes.fg — Pipe operator and `it`
```forge
fn double(x: int) -> int { x * 2 }
fn add_one(x: int) -> int { x + 1 }

fn main() {
  // Pipe operator
  let result = 5 |> double |> add_one
  println(string(result))           // 11

  // it with closures
  let nums = [1, 2, 3, 4, 5]
  let evens = nums.filter(it % 2 == 0)
  println(string(evens.length))     // 2

  let doubled = nums.map(it * 2)
  // doubled = [2, 4, 6, 8, 10]
  println(string(doubled[0]))       // 2
  println(string(doubled[4]))       // 10
}
```

## 11. Implementation Order

Build these in order. Each step produces a working (if limited) compiler that can be tested:

### Step 1: Skeleton + Hello World (Week 1-2)
- Set up Cargo project with all dependencies
- Implement lexer for basic tokens (identifiers, numbers, strings, operators)
- Implement parser for: `fn main() { }`, function calls, string literals
- Implement codegen for: `main` function, `println` calls (via C runtime)
- Link against runtime.c
- **Test: `hello.fg` compiles and runs**

### Step 2: Variables + Arithmetic (Week 2-3)
- Add `let`, `mut`, `const` to parser
- Add integer and float literals, arithmetic operators
- Add type inference for primitive types
- Implement assignment checking (immutable vs mutable)
- Codegen for local variables (alloca), arithmetic (LLVM int/float ops)
- **Test: `arithmetic.fg` and `immutability.fg` compile and run**

### Step 3: Functions + Closures (Week 3-4)
- Parse function declarations with params, return types, defaults
- Parse closures (arrow syntax, single-arg no-parens)
- Type check function signatures, call sites, named args
- Codegen for functions (LLVM function definitions), closure capture (env struct)
- **Test: `functions.fg` compiles and runs**

### Step 4: Strings + Interpolation (Week 4-5)
- Implement template literal parsing (extract expressions from `${}`)
- String concat, length, method calls on strings
- Codegen for string operations (call into C runtime)
- Reference counting for strings (retain/release on assignment)
- **Test: `strings.fg` compiles and runs**

### Step 5: Control Flow (Week 5-6)
- Parse and type-check: if/else (as expressions), match, for/in, while, loop
- Parse range expressions (`0..10`)
- Codegen for branching (LLVM basic blocks, phi nodes for if-expressions)
- Codegen for loops (LLVM branch/conditional branch)
- Match as chained conditionals (no exhaustiveness checking yet)
- **Test: `control_flow.fg` compiles and runs**

### Step 6: Nullable Types (Week 6-7)
- Implement `T?` as `{ tag: i1, value: T }` in the type system
- Parse `?.`, `??`, `!.` operators
- Type narrowing in if-blocks (`if x != null { ... }`)
- Codegen for nullable operations
- **Test: `nullability.fg` compiles and runs**

### Step 7: Structs + With (Week 7-8)
- Parse struct type declarations, struct literals, field access
- Implement structural type checking (shape matching)
- Parse and implement `with` expression (copy + override fields)
- Codegen for struct allocation, field access, with-copy
- **Test: `structs.fg` compiles and runs**

### Step 8: Enums + Pattern Matching (Week 8-10)
- Parse enum declarations with associated data
- Implement tagged union representation
- Implement pattern matching in match expressions
- Add exhaustiveness checking (ensure all variants covered)
- Codegen for enum construction, tag checking, field extraction
- **Test: `enums.fg` compiles and runs**

### Step 9: Error Handling (Week 10-11)
- Implement `Result<T, E>` as a built-in type
- Parse and implement `?` operator (early return on Err)
- Parse and implement `catch` blocks
- Parse `defer` and `errdefer` (scope-based cleanup)
- Codegen for Result tag checking, early return, defer
- **Test: `error_handling.fg` compiles and runs**

### Step 10: Destructuring + Pipes + It (Week 11-12)
- Implement destructuring in let bindings (tuples, structs, lists)
- Implement pipe operator as desugaring (`a |> f` → `f(a)`)
- Implement `it` as implicit closure creation
- Implement basic list operations (filter, map, length, index)
- **Test: `destructuring.fg` and `pipes.fg` compile and run**

### Step 11: Error Messages + Polish (Week 12-14)
- Implement all error codes from Section 9.3
- Add human-readable and JSON error output via ariadne
- Add `forge check` command (type-check without codegen)
- Add `--emit-ir` and `--emit-ast` flags
- Write comprehensive test suite
- Fix bugs found during integration testing
- **Test: all 12 test programs compile and run correctly**

## 12. What Phase 1 Does NOT Include

These are explicitly deferred to Phase 2+:

- The `use` / module system (Phase 1 is single-file only)
- Packages and the package SDK
- Models, services, persistence
- Traits and impl blocks (partially — basic trait declarations parse but don't codegen)
- Generics (type checker supports them for built-in types like List<T> but not user-defined)
- The `export` keyword
- Cycle detection in reference counting
- Hot reload or REPL
- Multi-file compilation
- Any standard packages (@std/http, etc.)
- The `forge.toml` project system
- The `spawn`/`parallel` keywords (parsed but not codegen'd)
- Annotations (`@`)
- Events (`emit`/`on`)

Phase 1 is a single-file compiler. You give it one `.fg` file and it produces one binary. That's enough to validate the entire language design — syntax, type system, codegen, and error messages.

## 13. Definition of Done

Phase 1 is complete when:

1. All 12 test programs in Section 10 compile and produce correct output
2. Type errors produce helpful, correctly-formatted error messages (human + JSON)
3. The `forge build`, `forge run`, `forge check` commands work
4. `--emit-ir` produces valid LLVM IR
5. `--error-format=json` produces parseable JSON
6. The compiler can be built on macOS (arm64) and Linux (x86_64)
7. All Rust tests pass (`cargo test`)
8. A clean build of the compiler takes < 60 seconds
9. Compiling `hello.fg` takes < 1 second
