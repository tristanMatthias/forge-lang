# Spec: Fully Modular Compiler Architecture

> Status: Draft
> Author: Tristan + Claude
> Date: 2025-03-13

## Problem

The Forge compiler has a half-finished modular architecture. Features exist as directories in `compiler/features/` and register metadata via `forge_feature!`, but the actual compiler core still contains most of the logic. Features merely add helper methods via `impl Parser` / `impl Codegen` blocks that core must manually call.

**Current state (by the numbers):**
| Location | LOC | What's there |
|---|---|---|
| `core/parser/parser.rs` | 1,831 | All parsing logic, manual dispatch |
| `core/parser/ast.rs` | 665 | Monolithic AST enums (all variants) |
| `core/codegen/expressions.rs` | 1,106 | 200-line match block dispatching every Expr variant |
| `core/codegen/statements.rs` | 531 | Match block dispatching every Statement variant |
| `core/codegen/collections.rs` | 1,507 | List/map/struct/tuple codegen |
| `core/codegen/json.rs` | 1,585 | JSON intrinsics |
| `core/codegen/types.rs` | 680 | type_to_llvm for all types |
| `core/typeck/checker.rs` | 1,348 | All type checking logic |
| `core/lexer/token.rs` | 150 | Monolithic TokenKind enum (55 keywords) |
| **Total core** | **~12,000** | |
| **Total features** | **~13,500** | Helper methods only |

**What's wrong:**
1. **AST is closed.** Adding a new expression/statement means editing `core/parser/ast.rs`. Every feature's AST nodes are defined centrally.
2. **Dispatch is manual.** `compile_expr()` is a 200-line match. Adding `Expr::Pipe` means adding an arm in core. Same for parser, checker.
3. **Tokens are closed.** All keywords hardcoded in `TokenKind`. Adding `defer` means editing the lexer.
4. **No self-containment.** A feature like `defer` has its codegen in `features/defer/codegen.rs` but its AST variant in `core/ast.rs`, its token in `core/token.rs`, its parse dispatch in `core/parser.rs`, its codegen dispatch in `core/expressions.rs`.
5. **Core isn't thin.** It contains feature-specific logic (JSON, collections, control flow, etc).

## Goal

Every language feature is **fully self-contained**: its tokens, AST nodes, parsing, type-checking, codegen, tests, and documentation all live in one directory. Core is a thin orchestration layer (~2,000 LOC) that:

1. Runs the pipeline: lex → parse → check → codegen → link
2. Provides shared infrastructure (LLVM context, scope management, error system)
3. Dispatches to features via a trait-based registry

Adding a new feature means creating a directory. No edits to core. No edits to other features.

---

## Design

### The Feature Trait

Each feature implements a single trait that the core compiler dispatches to:

```rust
/// Every language feature implements this trait.
/// Core iterates registered features and calls these methods.
pub trait LanguageFeature: Send + Sync {
    /// Metadata for `forge features` CLI
    fn metadata(&self) -> &FeatureMetadata;

    // ─── Lexer ───────────────────────────────────────────
    /// Keywords this feature adds to the language.
    /// Returned as (keyword_string, token_kind_id).
    /// The lexer checks these when it encounters an identifier.
    fn keywords(&self) -> &[(&'static str, TokenId)] { &[] }

    // ─── Parser ──────────────────────────────────────────
    /// Try to parse a statement starting at current token.
    /// Return Some(Statement) if this feature handles it, None to pass.
    fn try_parse_statement(&self, p: &mut ParseContext) -> Option<Stmt> { None }

    /// Try to parse an expression atom (prefix position).
    /// Called when core doesn't recognize the token.
    fn try_parse_prefix(&self, p: &mut ParseContext) -> Option<Expr> { None }

    /// Try to parse a postfix/infix extension (e.g., `|>`, `?`, `?.`).
    /// Called after a primary expression is parsed.
    fn try_parse_postfix(&self, p: &mut ParseContext, left: Expr) -> Option<Expr> { None }

    // ─── Type Checker ────────────────────────────────────
    /// Type-check a statement this feature owns.
    fn check_statement(&self, tc: &mut CheckContext, stmt: &Stmt) -> bool { false }

    /// Type-check an expression this feature owns.
    fn check_expr(&self, tc: &mut CheckContext, expr: &Expr) -> Option<Type> { None }

    // ─── Codegen ─────────────────────────────────────────
    /// Compile a statement this feature owns.
    fn compile_statement(&self, cg: &mut CodegenContext, stmt: &Stmt) -> bool { false }

    /// Compile an expression this feature owns.
    fn compile_expr(&self, cg: &mut CodegenContext, expr: &Expr) -> Option<Value> { None }

    // ─── Intrinsics ──────────────────────────────────────
    /// Register built-in functions/methods this feature provides.
    /// Called once during compiler init.
    fn register_intrinsics(&self, reg: &mut IntrinsicRegistry) {}
}
```

### Open AST via Tagged Nodes

The central problem: Rust enums are closed. We can't add variants from other modules. Two viable options:

#### Option A: Feature-Tagged Nodes (Recommended)

Replace the monolithic `Expr`/`Statement` enums with a small core set + an extension mechanism:

```rust
/// Core expressions that every feature may need to compose with.
/// These are the ~10 fundamental building blocks.
pub enum Expr {
    // Primitives (always present)
    IntLit(i64, Span),
    FloatLit(f64, Span),
    BoolLit(bool, Span),
    StringLit(String, Span),
    NullLit(Span),
    Ident(String, Span),

    // Structural (always present)
    Binary { left: Box<Expr>, op: BinaryOp, right: Box<Expr>, span: Span },
    Unary { op: UnaryOp, operand: Box<Expr>, span: Span },
    Call { callee: Box<Expr>, args: Vec<CallArg>, type_args: Vec<TypeExpr>, span: Span },
    MemberAccess { object: Box<Expr>, field: String, span: Span },
    Index { object: Box<Expr>, index: Box<Expr>, span: Span },
    If { condition: Box<Expr>, then_branch: Block, else_branch: Option<Block>, span: Span },
    Block(Block),

    // Feature-owned expression (the extension point)
    Feature(FeatureExpr),
}

/// A feature-owned AST node. The feature that created it knows how to
/// downcast `data` back to its concrete type.
pub struct FeatureExpr {
    pub feature_id: &'static str,  // "closures", "pipe_operator", etc.
    pub kind: &'static str,        // "Closure", "Pipe", etc.
    pub data: Box<dyn FeatureNode>,
    pub span: Span,
}

/// Trait that all feature AST node data implements.
pub trait FeatureNode: std::any::Any + std::fmt::Debug + CloneFeatureNode {
    fn as_any(&self) -> &dyn std::any::Any;
}
```

**How features use this:**

```rust
// In features/closures/types.rs
#[derive(Debug, Clone)]
pub struct ClosureData {
    pub params: Vec<Param>,
    pub body: Box<Expr>,
}
impl FeatureNode for ClosureData { ... }

// In features/closures/parser.rs
impl ClosuresFeature {
    fn try_parse_prefix(&self, p: &mut ParseContext) -> Option<Expr> {
        if !p.check(Token::LParen) || !self.looks_like_closure(p) {
            return None;
        }
        let data = self.parse_closure(p)?;
        Some(Expr::Feature(FeatureExpr {
            feature_id: "closures",
            kind: "Closure",
            data: Box::new(data),
            span,
        }))
    }
}

// In features/closures/codegen.rs
impl ClosuresFeature {
    fn compile_expr(&self, cg: &mut CodegenContext, expr: &Expr) -> Option<Value> {
        let fe = match expr { Expr::Feature(fe) if fe.feature_id == "closures" => fe, _ => return None };
        let data = fe.data.as_any().downcast_ref::<ClosureData>()?;
        // ... compile closure ...
    }
}
```

Same pattern for `Statement`:
```rust
pub enum Stmt {
    Let { ... },
    Mut { ... },
    FnDecl { ... },
    Assign { ... },
    Expr(Expr),
    Return { ... },
    Feature(FeatureStmt),  // extension point
}
```

#### Option B: Generated Enums (Alternative)

A proc macro scans feature directories at compile time and generates the full enums:

```rust
// This macro reads features/*/types.rs and generates the Expr enum
forge_ast! {
    // Core variants are listed here
    pub enum Expr {
        IntLit(i64, Span),
        // ...
    }
    // Feature variants are auto-appended from features/*/types.rs
}
```

**Trade-offs:**

| | Option A (Tagged Nodes) | Option B (Generated Enums) |
|---|---|---|
| **Simplicity** | Simple, standard Rust | Requires proc macro |
| **Performance** | Dynamic dispatch + downcast per feature node | Zero-cost, native enum |
| **Ergonomics** | `downcast_ref` boilerplate | Clean pattern matching |
| **Extensibility** | Runtime-extensible (plugins possible) | Compile-time only |
| **Debugging** | Harder (opaque data) | Easy (all variants visible) |
| **Risk** | Low (standard patterns) | Medium (proc macro complexity) |

**Recommendation:** Start with Option A. It's simpler, battle-tested (rustc uses a similar pattern for `TokenKind::Interpolated`), and enables future plugin support. Option B can be built later as an optimization if downcasting becomes a bottleneck (unlikely — AST traversal is not the hot path).

### Open Token System

Replace the hardcoded `TokenKind` keyword list with a registry:

```rust
pub enum TokenKind {
    // Literals (always present)
    IntLiteral(i64),
    FloatLiteral(f64),
    StringLiteral(String),
    TemplateLiteral(Vec<TemplatePart>),
    BoolLiteral(bool),
    Ident(String),

    // Operators (always present)
    Plus, Minus, Star, Slash, Percent,
    Eq, EqEq, NotEq, Lt, LtEq, Gt, GtEq,
    And, Or, Not,
    // ... structural tokens ...

    // Delimiters
    LParen, RParen, LBrace, RBrace, LBracket, RBracket,
    Comma, Dot, Colon, Semicolon, At, Hash,

    // Feature-registered keyword
    Keyword(KeywordId),

    Newline, Eof,
}

/// Lightweight ID for feature-registered keywords.
/// The registry maps these to feature handlers.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct KeywordId(pub u16);
```

The lexer does a HashMap lookup when it encounters an identifier:
```rust
fn lex_ident(&mut self, text: &str) -> TokenKind {
    // Check core keywords first (if, else, etc.)
    match text {
        "true" => TokenKind::BoolLiteral(true),
        "false" => TokenKind::BoolLiteral(false),
        "null" => TokenKind::Ident("null".into()),  // null is a feature too
        _ => {
            // Check feature-registered keywords
            if let Some(id) = self.keyword_registry.get(text) {
                TokenKind::Keyword(*id)
            } else {
                TokenKind::Ident(text.to_string())
            }
        }
    }
}
```

### Core Dispatch Loop

Core's dispatch becomes a simple loop over registered features:

```rust
// In core/parser — parse_statement()
fn parse_statement(&mut self) -> Option<Stmt> {
    // Try core statements first (let, mut, fn, etc.)
    if let Some(stmt) = self.try_core_statement() {
        return Some(stmt);
    }

    // Ask each feature to try parsing
    for feature in self.registry.features() {
        if let Some(stmt) = feature.try_parse_statement(&mut self.ctx()) {
            return Some(stmt);
        }
    }

    // Fallback: expression statement
    self.parse_expr_statement()
}

// In core/codegen — compile_expr()
fn compile_expr(&mut self, expr: &Expr) -> Option<Value> {
    match expr {
        // Core handles core variants
        Expr::IntLit(n, _) => { ... },
        Expr::Binary { .. } => { ... },
        // ...

        // Feature expressions dispatched to their owner
        Expr::Feature(fe) => {
            let feature = self.registry.get(fe.feature_id)?;
            feature.compile_expr(&mut self.ctx(), expr)
        }
    }
}
```

### Context Objects (Not Raw Structs)

Features currently get `impl Parser` access to all of Parser's internals. Instead, features receive **context objects** with a controlled API:

```rust
/// What features see during parsing.
/// Wraps Parser but exposes only safe operations.
pub struct ParseContext<'a> {
    parser: &'a mut Parser,
}

impl<'a> ParseContext<'a> {
    // Token inspection
    pub fn peek(&self) -> Option<&Token> { ... }
    pub fn peek_kind(&self) -> Option<&TokenKind> { ... }
    pub fn check(&self, kind: &TokenKind) -> bool { ... }
    pub fn advance(&mut self) -> Option<Token> { ... }
    pub fn expect(&mut self, kind: &TokenKind) -> Option<Token> { ... }
    pub fn skip_newlines(&mut self) { ... }

    // Shared parsing helpers (call back into core parser)
    pub fn parse_expr(&mut self) -> Option<Expr> { ... }
    pub fn parse_block(&mut self) -> Option<Block> { ... }
    pub fn parse_type_expr(&mut self) -> Option<TypeExpr> { ... }
    pub fn parse_params(&mut self) -> Option<Vec<Param>> { ... }
    pub fn expect_ident(&mut self) -> Option<String> { ... }

    // Diagnostics
    pub fn error(&mut self, msg: &str, span: Span) { ... }
}

/// What features see during codegen.
pub struct CodegenContext<'a, 'ctx> {
    codegen: &'a mut Codegen<'ctx>,
}

impl<'a, 'ctx> CodegenContext<'a, 'ctx> {
    // LLVM helpers
    pub fn compile_expr(&mut self, expr: &Expr) -> Option<BasicValueEnum<'ctx>> { ... }
    pub fn compile_statement(&mut self, stmt: &Stmt) { ... }
    pub fn build_string_literal(&mut self, s: &str) -> BasicValueEnum<'ctx> { ... }
    pub fn type_to_llvm(&self, ty: &Type) -> BasicTypeEnum<'ctx> { ... }

    // Scope management
    pub fn push_scope(&mut self) { ... }
    pub fn pop_scope(&mut self) { ... }
    pub fn define_var(&mut self, name: String, ptr: PointerValue<'ctx>, ty: Type) { ... }
    pub fn lookup_var(&self, name: &str) -> Option<(PointerValue<'ctx>, Type)> { ... }

    // Function creation
    pub fn add_function(&mut self, name: &str, fn_type: FunctionType<'ctx>) -> FunctionValue<'ctx> { ... }
    pub fn get_function(&self, name: &str) -> Option<FunctionValue<'ctx>> { ... }

    // Builder access
    pub fn context(&self) -> &'ctx Context { ... }
    pub fn builder(&self) -> &Builder<'ctx> { ... }
}
```

### Intrinsic Registry

Built-in methods like `string.length()`, `list.map()`, `json.parse()` are currently hardcoded in core. Instead, features register them:

```rust
pub struct IntrinsicRegistry {
    /// method_name → (receiver_type, handler)
    methods: HashMap<(Type, String), IntrinsicHandler>,
    /// function_name → handler
    functions: HashMap<String, IntrinsicHandler>,
}

// In features/string_methods/mod.rs
impl LanguageFeature for StringMethodsFeature {
    fn register_intrinsics(&self, reg: &mut IntrinsicRegistry) {
        reg.register_method(Type::String, "length", |cg, receiver, args| { ... });
        reg.register_method(Type::String, "split", |cg, receiver, args| { ... });
        reg.register_method(Type::String, "trim", |cg, receiver, args| { ... });
        reg.register_method(Type::String, "contains", |cg, receiver, args| { ... });
    }
}

// In features/list_methods/mod.rs
impl LanguageFeature for ListMethodsFeature {
    fn register_intrinsics(&self, reg: &mut IntrinsicRegistry) {
        reg.register_method(Type::List(Box::new(Type::Any)), "map", |cg, receiver, args| { ... });
        reg.register_method(Type::List(Box::new(Type::Any)), "filter", |cg, receiver, args| { ... });
        reg.register_method(Type::List(Box::new(Type::Any)), "length", |cg, receiver, args| { ... });
    }
}
```

Core's `compile_member_access` becomes:
```rust
fn compile_method_call(&mut self, receiver: Value, method: &str, args: &[Expr]) -> Option<Value> {
    let receiver_type = self.infer_type_of(receiver);
    if let Some(handler) = self.intrinsics.get_method(&receiver_type, method) {
        handler(self, receiver, args)
    } else {
        self.error(format!("no method '{}' on type '{}'", method, receiver_type));
        None
    }
}
```

---

## Feature Directory Structure

Every feature follows this exact structure:

```
compiler/features/<feature_id>/
├── mod.rs          # Feature declaration + LanguageFeature impl
├── types.rs        # AST node data types (FeatureNode impls)
├── parser.rs       # try_parse_statement / try_parse_prefix / try_parse_postfix
├── checker.rs      # check_statement / check_expr
├── codegen.rs      # compile_statement / compile_expr
├── intrinsics.rs   # register_intrinsics (optional, for built-in methods)
└── examples/       # Test files with /// expect: comments
    ├── basic.fg
    ├── edge_case.fg
    └── ...
```

**mod.rs example:**
```rust
use crate::registry::*;
use crate::feature::*;

pub mod types;
pub mod parser;
pub mod checker;
pub mod codegen;

pub struct DeferFeature;

impl LanguageFeature for DeferFeature {
    fn metadata(&self) -> &FeatureMetadata {
        static META: FeatureMetadata = FeatureMetadata {
            name: "Defer",
            id: "defer",
            status: FeatureStatus::Stable,
            depends: &[],
            enables: &[],
            description: "Deferred execution before function return",
        };
        &META
    }

    fn keywords(&self) -> &[(&'static str, TokenId)] {
        &[("defer", token_ids::DEFER)]
    }

    fn try_parse_statement(&self, p: &mut ParseContext) -> Option<Stmt> {
        parser::try_parse(p)
    }

    fn compile_statement(&self, cg: &mut CodegenContext, stmt: &Stmt) -> bool {
        codegen::compile(cg, stmt)
    }
}

// Auto-register at link time
inventory::submit! {
    FeatureEntry::new(Box::new(DeferFeature))
}
```

---

## What Goes Where: Core vs Feature

### Core (~2,000 LOC target)

Core is **infrastructure only**. It knows nothing about specific language constructs.

| Module | Responsibility |
|---|---|
| `lexer/` | Tokenize source. Literals, operators, delimiters. Keywords via registry lookup. |
| `parser/dispatch.rs` | `parse_program()`, `parse_statement()` (loop over features), `parse_expr()` (Pratt parser core). |
| `parser/ast.rs` | Core `Expr`/`Stmt` enums (primitives + `Feature` variant). `Block`, `Param`, `TypeExpr`, `Pattern`. |
| `parser/helpers.rs` | `expect()`, `advance()`, `skip_newlines()`, `parse_type_expr()`, `parse_params()`. |
| `typeck/` | Type env, scope stack, `check_program()` dispatch loop. |
| `codegen/` | LLVM context setup, `compile_program()` dispatch, scope management, `type_to_llvm()`, linker. |
| `errors/` | `CompileError` variants, `render()`, diagnostic system. |
| `driver.rs` | Pipeline orchestration: lex → parse → check → codegen → link. |
| `registry.rs` | `FeatureRegistry`, `IntrinsicRegistry`, keyword registry. |
| `test_runner.rs` | Run `examples/*.fg` test files. |

### Features (everything else)

Every construct that can be described as "X is a language feature" becomes a feature:

| Feature ID | What it owns |
|---|---|
| `literals` | `IntLit`, `FloatLit`, `BoolLit`, `NullLit`, `StringLit`, `TemplateLit` codegen |
| `variables` | `let`, `mut`, `const` parsing + checking + codegen |
| `functions` | `fn` declarations, calls, return statements |
| `if_else` | `if`/`else` parsing + codegen |
| `binary_ops` | `+`, `-`, `*`, `/`, `%`, comparisons, `and`, `or` |
| `unary_ops` | `-`, `not` |
| `closures` | `(x) -> body` syntax |
| `pipe_operator` | `\|>` operator |
| `pattern_matching` | `match` expression |
| `for_loops` | `for x in collection` |
| `while_loops` | `while condition` |
| `loop_keyword` | `loop { }`, `break`, `continue` |
| `ranges` | `1..10`, `1..=10` |
| `null_safety` | `?`, `?.`, `??` operators |
| `error_propagation` | `?` on Result types, `catch` |
| `enums` | `enum` declarations + variant constructors |
| `structs` | Struct literals, type declarations, member access |
| `tuples` | Tuple literals, destructuring |
| `lists` | List literals, indexing, `list.map/filter/...` |
| `maps` | Map literals, access |
| `string_methods` | `string.length()`, `.split()`, `.trim()`, etc. |
| `string_templates` | `"hello ${name}"` |
| `json_builtins` | `json.parse()`, `json.stringify()` |
| `traits` | `trait`, `impl` blocks |
| `generics` | `<T>` type parameters |
| `type_operators` | `without`, `only`, `partial`, `with` type ops |
| `defer` | `defer` statement |
| `spawn` | `spawn { }` |
| `channels` | `<-`, channel ops, `select` |
| `shell_shorthand` | `$"..."`, `$\`...\`` |
| `components` | Component system, templates, expansion |
| `annotations` | `@min`, `@max`, etc. |
| `spec_test` | `spec`, `given`, `then`, `skip`, `todo` |
| `immutability` | Immutability checking |
| `is_keyword` | `value is Pattern` |
| `table_literal` | `table { cols \| rows }` |
| `with_expression` | `expr with { field: value }` |
| `error_messages` | Error code tests and user-facing messages |
| `imports` | `use` statements |
| `exports` | `export` keyword |
| `validate` | `validate()` intrinsic |

---

## Migration Plan

### Phase 1: The Feature Trait + Context Objects

**Goal:** Establish the new architecture without breaking anything.

1. Define `LanguageFeature` trait in `core/feature.rs`
2. Define `ParseContext`, `CheckContext`, `CodegenContext` wrappers
3. Define `FeatureExpr`, `FeatureStmt`, `FeatureNode` types
4. Add `Expr::Feature(FeatureExpr)` and `Stmt::Feature(FeatureStmt)` variants to existing enums
5. Build `FeatureDispatcher` that iterates registered features
6. Implement `IntrinsicRegistry`

**No features migrated yet.** Just the infrastructure.

### Phase 2: Migrate Simple, Self-Contained Features

Start with features that have minimal interaction with other features:

1. `defer` — one keyword, one statement, simple codegen
2. `spawn` — one keyword, one expression
3. `shell_shorthand` — `$"..."` syntax
4. `ranges` — `..` and `..=` operators
5. `is_keyword` — `is` operator
6. `table_literal` — sugar that desugars
7. `with_expression` — `with { }` syntax
8. `pipe_operator` — postfix operator

For each: move AST data to `types.rs`, implement `LanguageFeature`, remove the old `Expr`/`Stmt` variant from core enum, update dispatch.

### Phase 3: Migrate Expression Features

Features that produce `Expr` nodes:

1. `closures` — prefix parsing, codegen
2. `null_safety` — `?`, `?.`, `??` postfix operators
3. `error_propagation` — `?` postfix + `catch`
4. `pattern_matching` — `match` expression
5. `channels` — `<-` send/receive, `select`

### Phase 4: Migrate Core-Looking Features

Features that feel "core" but are actually self-contained:

1. `literals` — int/float/bool/null/string codegen (becomes a feature that handles core Expr variants)
2. `variables` — let/mut/const
3. `functions` — fn declarations
4. `if_else` — if/else
5. `binary_ops` + `unary_ops`
6. `for_loops`, `while_loops`, `loop_keyword`
7. `structs`, `tuples`, `lists`, `maps`
8. `enums`
9. `traits`, `generics`

### Phase 5: Migrate Built-in Methods to Intrinsics

1. `string_methods` — all `string.*` methods → intrinsic registry
2. `list_methods` — all `list.*` methods → intrinsic registry
3. `json_builtins` — `json.parse/stringify` → intrinsic registry
4. `validate` — `validate()` → intrinsic registry

### Phase 6: Clean Up Core

1. Remove dead code from core (empty match arms, unused helpers)
2. Core should be ~2,000 LOC
3. All `Expr`/`Stmt` variants except the ~10 structural core ones should be `Feature(...)`
4. Run full test suite, ensure everything passes
5. Update `CLAUDE.md` and memory with new architecture

---

## Key Design Decisions

### Q: Why not dynamic dispatch for all AST nodes?

Only feature-specific nodes use `Feature(FeatureExpr)`. Core primitives (`IntLit`, `Binary`, `Call`, `Ident`, etc.) stay as native enum variants because:
- They're used everywhere — downcasting overhead would be measurable
- Every feature needs to compose with them (e.g., closure bodies contain `Binary` exprs)
- They're truly "core" — a language without integers isn't a language

### Q: What about feature interdependencies?

Features can depend on other features via the `depends` field. A feature can call back into core's `compile_expr()` / `parse_expr()` which will dispatch to the appropriate feature. Features never call each other directly.

Example: `closures` doesn't call `binary_ops`. It calls `cg.compile_expr(body)`, and core dispatches the body's `Binary` node to `binary_ops`.

### Q: What about the `match` arms in `Expr::span()`?

The `span()` method moves to a trait:
```rust
impl Expr {
    pub fn span(&self) -> Span {
        match self {
            // Core variants
            Expr::IntLit(_, s) | Expr::Ident(_, s) => *s,
            // ...
            // Feature variant carries its span
            Expr::Feature(fe) => fe.span,
        }
    }
}
```

### Q: Will this slow down compilation?

No measurable impact. The hot path is LLVM optimization and linking (~100ms per test). AST dispatch is <1ms. A HashMap lookup + downcast per feature node is negligible.

### Q: Can features define new types?

Yes, via `register_intrinsics`. A feature can register a new type name and its methods. The type system stays simple (Type enum in core), but features can add behavior to types.

### Q: How does the Pratt parser work with features?

Core owns the Pratt parser loop (precedence climbing). Features participate via:
- `try_parse_prefix` — called when the current token isn't a core prefix
- `try_parse_postfix` — called after a primary expr is parsed, for infix/postfix operators
- Features return a precedence/binding power so the Pratt parser knows when to stop

```rust
pub trait LanguageFeature {
    /// If this feature handles a postfix operator, return its binding power.
    /// Called to decide whether to continue parsing infix.
    fn postfix_binding_power(&self, token: &TokenKind) -> Option<(u8, u8)> { None }
}
```

### Q: What about error codes?

Error codes stay in `core/errors/`. Features can emit diagnostics via `ParseContext::error()` / `CheckContext::error()` which add to the central diagnostic list. Feature-specific error codes are declared in the feature's mod.rs but registered centrally (same inventory pattern).

---

## Success Criteria

1. **Zero edits to core** when adding a new feature (directory + `pub mod` line only)
2. **Core ≤ 2,500 LOC** (down from ~12,000)
3. **All 283+ tests pass** after migration
4. **Each feature directory is self-contained**: AST types, parser, checker, codegen, tests
5. **`forge features`** still works, shows all features with test counts
6. **No performance regression** on `forge test` (within 5% of current)

---

## Risks & Mitigations

| Risk | Mitigation |
|---|---|
| `dyn Any` downcast ergonomics | Helper macro: `feature_data!(expr, ClosureData)` |
| Feature ordering matters for parser | Features declare priority; core sorts by priority |
| Debug printing harder with opaque nodes | `FeatureNode: Debug` required; pretty-printer walks features |
| Circular dependency between features | Banned by design — features call core, never each other |
| Migration breaks tests | Migrate one feature at a time, run full suite after each |
