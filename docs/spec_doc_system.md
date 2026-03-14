# Spec: Self-Documenting Language System

> Status: Draft
> Author: Tristan + Claude
> Date: 2025-03-14

## Principle

**If it exists in the language, there is a canonical source in the codebase that documents it — and that source is tested.**

No separate doc-writing pass. No markdown that drifts from reality. The compiler, examples, and annotations ARE the documentation. Two commands, one system:

- **`forge lang`** — Language documentation. Always shows Forge language features, types, syntax, errors. Works anywhere, no project needed.
- **`forge docs`** — Project documentation. Shows docs for the user's own code. Falls through to `forge lang` when no project symbol matches.

The same `///` annotation format powers both. The doc system isn't just for the language — it's a **language feature** that every Forge project gets for free.

---

## Documentation Sources

Six layers, all extracted automatically:

### Layer 1: Feature Metadata (from `LanguageFeature` trait)

Every feature already declares:

```rust
fn metadata(&self) -> &FeatureMetadata;
```

We extend with documentation fields:

```rust
pub trait LanguageFeature {
    fn metadata(&self) -> &FeatureMetadata;

    /// One-line syntax summary: "defer <expr>"
    /// Used in LLM compact format and CLI --short output.
    fn syntax(&self) -> &[&'static str] { &[] }

    /// One-line description for compact listings.
    /// If not provided, falls back to metadata().description.
    fn short(&self) -> &'static str { self.metadata().description }

    /// Symbol(s) this feature introduces: "|>", "?.", "<-"
    /// Enables symbol lookup: `forge docs "?."` → null_safety
    fn symbols(&self) -> &[&'static str] { &[] }

    // ... existing methods ...
}
```

This gives us the **feature index**, **symbol lookup table**, and **compact spec** for free.

### Layer 2: Annotated Examples (from `examples/*.fg`)

Example files are already tests. We add a structured annotation format:

```forge
/// @title: Basic closure syntax
/// @section: syntax
/// @tags: functions, first-class
/// @see: pipe_operator, it_parameter
/// @since: 0.2.0

/// Closures are first-class values. Declare them with
/// `(params) -> body` syntax.
let add = (a, b) -> a + b
print(add(1, 2))
/// expect: 3

/// Single-param closures don't need parentheses around the param.
let double = (x) -> x * 2
print(double(5))
/// expect: 10
```

#### Annotation Reference

**File-level annotations** (must appear before any code):

| Annotation | Required | Purpose |
|---|---|---|
| `/// @title: ...` | Yes | Page/section heading |
| `/// @section: ...` | No | Groups examples into doc sections. Default: `examples` |
| `/// @tags: a, b, c` | No | Searchable tags |
| `/// @see: feature_id, ...` | No | Cross-references (also auto-derived from deps) |
| `/// @since: x.y.z` | No | Version introduced |
| `/// @level: beginner\|intermediate\|advanced` | No | Complexity level for filtering |

**Inline annotations** (on any code line):

| Annotation | Purpose |
|---|---|
| `/// @note: ...` | Callout for non-obvious behavior. Rendered as tip/warning in docs. |
| `/// @returns: type` | Documents return type when not obvious from context |
| `/// @syntax: pattern` | Marks this line as a syntax example (highlighted in docs) |
| `/// expect: ...` | Expected output (existing, doubles as doc output) |
| `/// expect-error: F0012` | Expected error (existing, documents error conditions) |

**Prose comments** (no `@` prefix) become descriptive text:

```forge
/// Closures capture variables from their enclosing scope.
/// This means they can read and modify variables defined
/// outside their body.
let x = 10
let add_x = (n) -> n + x
```

The `///` comments without `@` become paragraph text in the rendered docs, placed before the code block that follows them.

### Layer 3: Type Signatures (from `IntrinsicRegistry`)

The compiler knows every type, method, and function. During doc generation, we walk the `IntrinsicRegistry` and extract:

```
string.length() -> int
string.split(sep: string) -> list<string>
string.trim() -> string
string.contains(sub: string) -> bool
list<T>.map(fn: (T) -> U) -> list<U>
list<T>.filter(fn: (T) -> bool) -> list<T>
list<T>.length() -> int
list<T>.sorted() -> list<T>
channel<T>.close() -> void
```

Each intrinsic method can carry a doc string:

```rust
reg.register_method(Type::String, "split", |cg, recv, args| { ... })
   .doc("Split string by separator, returning a list of parts.");
```

One line per method. The signature is already known from the type system.

### Layer 4: Error Codes (from `CompileError`)

Already exists via `forge explain`. We unify it into the doc system:

- Each error code gets an addressable path: `forge.errors.F0012`
- `CompileError::render()` help text becomes the doc content
- Error example files (`error_messages/examples/*.fg`) become the usage examples
- Cross-referenced: features link to errors they can produce

### Layer 5: Grammar Rules (from `syntax()` on LanguageFeature)

Each feature declares its syntax patterns:

```rust
fn syntax(&self) -> &[&'static str] {
    &[
        "defer <expr>",
    ]
}
```

Or for complex features:

```rust
fn syntax(&self) -> &[&'static str] {
    &[
        "match <expr> { <pattern> -> <expr>, ... }",
        "match <expr> { <pattern> if <guard> -> <expr>, ... }",
    ]
}
```

These assemble into the **complete grammar** of the language, auto-sorted by feature registration order.

### Layer 6: Composition Docs (from `docs/*.md` in feature dirs)

For cross-feature patterns that don't belong to a single feature:

```
compiler/features/closures/
├── mod.rs
├── parser.rs
├── codegen.rs
├── examples/
│   ├── basic.fg
│   └── captures.fg
└── docs/
    ├── with_pipes.md        # "Closures + Pipe Operator"
    └── async_patterns.md    # "Closures in Spawn/Channel patterns"
```

These are the **only hand-written docs** in the system. They cover the "how do these features interact" questions. Format:

```markdown
---
title: Closures with Pipes
features: [closures, pipe_operator]
tags: [composition, functional]
level: intermediate
---

The pipe operator and closures compose naturally...

​```forge
[1, 2, 3]
  |> .map((x) -> x * 2)
  |> .filter((x) -> x > 3)
  |> print
/// expect: [4, 6]
​```
```

Code blocks with `/// expect:` in composition docs **are also tested** by the test runner.

---

## Two Commands, One System

### `forge lang` — Language Documentation

Always shows Forge language docs. Works anywhere, no project needed. Powered by the compiler's own feature registry, intrinsic registry, error system, and annotated examples.

```bash
# Feature docs
forge lang closures              # Full feature page (assembled)
forge lang closures.syntax       # Just the syntax section
forge lang closures.examples     # Just the examples
forge lang closures --short      # One-liner: (params) -> body

# Symbol lookup
forge lang "|>"                  # → pipe_operator
forge lang "?."                  # → null_safety
forge lang "defer"               # → defer
forge lang "<-"                  # → channels

# Type/method docs
forge lang string                # All string methods
forge lang string.split          # Specific method signature + examples
forge lang list                  # All list methods

# Error docs
forge lang F0012                 # Error explanation + examples
forge lang errors                # All error codes, grouped

# Search
forge lang search "iterate"      # Semantic search across all lang docs
forge lang search --tag "async"  # Filter by tag

# Index
forge lang --all                 # List everything in the language
forge lang --features            # Feature index (like `forge features`)
forge lang --types               # All types and their methods
forge lang --errors              # All error codes

# Compact formats
forge lang --llm                 # Entire lang spec, ~100 lines, <4K tokens
forge lang --llm=full            # With one example per feature, ~8K tokens
forge lang --grammar             # BNF-style grammar, assembled from all features
forge lang --cheatsheet          # Printable cheatsheet format

# Website
forge lang --site                # Generate language reference website
```

### `forge docs` — Project Documentation

Shows docs for the user's own code. Extracts from `///` annotations on functions, structs, enums, and modules in the current project.

```bash
# Project symbols
forge docs                       # Project overview (all documented symbols)
forge docs area                  # User's function
forge docs Point                 # User's struct
forge docs Color.Red             # User's enum variant
forge docs my_module             # User's module

# Project formats
forge docs --site                # Generate project doc site
forge docs --llm                 # Project API in compact LLM format
forge docs --llm --with-lang     # Project API + language spec together
forge docs --validate            # Check doc coverage for this project

# Search
forge docs search "filter"       # Search project symbols
```

### Fallthrough Behavior

`forge docs` resolves in this order:

1. **Project symbols** — functions, structs, enums, modules in the current project
2. **Language features** — falls through to `forge lang` if no project match
3. **Hint shown** when falling through:

```
$ forge docs closures

  (No project symbol "closures" — showing language docs)

  Closures                                          stable | since 0.2.0
  ─────────────────────────────────────────────────────────────────────
  ...
```

When there IS ambiguity (user symbol shadows a language feature):

```
$ forge docs filter

  Project: fn filter(items: list<int>, min: int) -> list<int>
  ─────────────────────────────────────────────────────────────
  /// Filter items above a minimum threshold.
  ...

  See also: forge lang list.filter
```

`forge lang` never looks at project code. It always shows language docs.

### LLM Format Composition

The `--llm` flag works on both commands and they compose:

```bash
forge lang --llm              # Language spec only (~4K tokens)
forge docs --llm              # Project API only
forge docs --llm --with-lang  # Both together — drop into context and an LLM
                              # knows Forge AND your project's API
```

---

## Rendering Targets

### CLI Output

#### CLI Output Formatting

```
$ forge docs closures

  Closures                                          stable | since 0.2.0
  ─────────────────────────────────────────────────────────────────────

  First-class anonymous functions that capture their enclosing scope.

  Syntax
    (params) -> body
    (params) -> { multi-line body }

  Examples

    Basic closure
    │ let add = (a, b) -> a + b
    │ add(1, 2)  // => 3

    Capture variables
    │ let x = 10
    │ let add_x = (n) -> n + x
    │ add_x(5)  // => 15

  Notes
    ⓘ  Single-expression closures don't need braces.
    ⓘ  Use `it` for implicit single parameter: .map(it * 2)

  See Also
    pipe_operator, it_parameter, for_loops

  Errors
    F0012  Type mismatch in closure return
    F0014  Wrong argument count
```

### LLM Compact Format

`forge docs --llm` generates an LLM-optimized spec. Design goals:
- Entire language in <4K tokens
- Every feature represented
- Syntax is unambiguous
- No prose filler

Format:

```
# Forge Language Spec
# Types: int, float, string, bool, null, list<T>, map<K,V>, fn<(A)->R>
# Truthy: everything except false, null, 0, ""

## Variables
let x = 1              # immutable binding
mut y = 2              # mutable binding

## Functions
fn name(p: type) -> ret { body }
fn name(p) { body }    # types optional

## Closures
(params) -> expr                # single-expression
(params) -> { stmts; expr }     # block body
.method(it * 2)                 # implicit `it` param

## Pipe Operator
expr |> fn              # fn(expr)
expr |> .method(args)   # expr.method(args)

## Pattern Matching
match expr {
  1 -> "one"
  x if x > 10 -> "big"
  _ -> "other"
}

## Null Safety
x?                      # unwrap or propagate null
x?.field                # optional chain
x ?? default            # null coalesce

## Error Propagation
let val = risky()?      # unwrap or propagate error
catch { risky() }       # catch errors

## Control Flow
if cond { } else { }
for x in collection { }
while cond { }

## Loops
for x in 1..10 { }     # range (exclusive end)
for x in 1..=10 { }    # range (inclusive end)

## Collections
let list = [1, 2, 3]
let map = { key: "value" }
let tuple = (1, "two")
list.map((x) -> x * 2)
list.filter((x) -> x > 1)
list.length()
string.split(sep)
string.trim()
string.contains(sub)

## Structs
struct Point { x: int, y: int }
let p = Point { x: 1, y: 2 }
let q = p with { x: 10 }       # copy with override

## Enums
enum Color { Red, Green, Blue }
enum Shape { Circle(r: float), Rect(w: float, h: float) }
value is Circle                 # type check

## Defer
defer cleanup()         # runs when scope exits, LIFO order

## Concurrency
spawn { body }          # spawn concurrent task
ch <- value             # send to channel
let val = <- ch         # receive from channel
select {
  msg <- ch1 -> handle(msg)
  val <- ch2 if ready -> process(val)
}

## Shell
$"echo ${name}"         # execute, return stdout as string

## Components
use @http.server
server {
  route GET /users -> list_users
}

## Table Literal
table {
  name       | age | active
  "Alice"    | 30  | true
  "Bob"      | 25  | false
}

## Spec Tests
spec "feature name" {
  given "setup" { ... }
  then "assertion" { assert(cond) }
}
```

This format is:
- **Complete**: every feature represented
- **Minimal**: no filler, just syntax + one-line comments
- **Unambiguous**: a human or LLM can write Forge after reading this
- **Auto-generated**: assembled from `syntax()`, `short()`, and example files

The `--llm=full` variant adds one real example per feature (pulled from the first example in each feature's `examples/` dir).

### Static Website

`forge docs --site` generates a static site to `docs/site/`:

```
docs/site/
├── index.html              # Feature grid with search
├── features/
│   ├── closures.html       # Assembled feature page
│   ├── pipe_operator.html
│   └── ...
├── types/
│   ├── string.html         # Type + all methods
│   ├── list.html
│   └── ...
├── errors/
│   ├── F0012.html
│   └── ...
├── guides/                 # From composition docs
│   ├── closures-with-pipes.html
│   └── ...
├── spec.html               # Full language spec (one page)
├── cheatsheet.html         # Printable cheatsheet
└── search-index.json       # For client-side search
```

Built with a minimal built-in template engine (no external SSG dependency). The compiler already has template expansion — we reuse that pattern.

Features on the website:
- **Client-side search** via pre-built search index
- **Syntax highlighting** for Forge code (we define the grammar)
- **Run button** on examples (links to a future playground)
- **Version selector** (when we have versions)
- **Dark/light mode**
- **Copy button** on all code blocks
- **Permalink** for every heading, example, and method

---

## Doc Comments as a Language Feature

The `///` annotation system is not internal tooling — it's a **first-class language feature** that every Forge project gets. The same annotations that document the language also document user code.

### How It Works

The parser preserves `///` comments and attaches them to the next declaration:

```forge
/// Calculate the area of a circle.
/// @param radius - The radius in meters
/// @returns The area in square meters
/// @see: circumference
/// @since: 1.0.0
fn area(radius: float) -> float {
    3.14159 * radius * radius
}

/// A 2D point in Cartesian space.
struct Point {
    x: float   /// @doc: X coordinate
    y: float   /// @doc: Y coordinate
}

/// Cardinal and intermediate directions.
enum Direction {
    North       /// @doc: 0 degrees
    East        /// @doc: 90 degrees
    South       /// @doc: 180 degrees
    West        /// @doc: 270 degrees
}
```

### Supported Declarations

Doc comments attach to:

| Declaration | What's extracted |
|---|---|
| `fn` | Name, params (with `@param`), return type (`@returns`), description |
| `struct` | Name, fields (with `/// @doc:` on each field), description |
| `enum` | Name, variants (with `/// @doc:` on each variant), description |
| `let` / `mut` / `const` | Name, type, description (for module-level bindings) |
| `component` | Name, config fields, syntax patterns, description |

### Annotation Reference (User Code)

All file-level and inline annotations from the language doc system work identically in user code:

```forge
/// @title: Authentication utilities
/// @section: auth
/// @tags: security, jwt, session
/// @see: User, Session
/// @since: 2.0.0
/// @level: intermediate

/// Create a signed JWT token for the given user.
/// @param user - The authenticated user record
/// @param ttl - Token lifetime in seconds (default: 3600)
/// @returns A signed JWT string
/// @note: Tokens are signed with HS256. Configure via AUTH_SECRET env var.
fn create_token(user: User, ttl: int) -> string {
    // ...
}
```

### What `forge docs` Extracts

For a project with the code above, `forge docs` auto-generates:

```
$ forge docs create_token

  fn create_token(user: User, ttl: int) -> string
  ────────────────────────────────────────────────

  Create a signed JWT token for the given user.

  Parameters
    user: User     The authenticated user record
    ttl: int       Token lifetime in seconds (default: 3600)

  Returns
    string         A signed JWT string

  Notes
    ⓘ  Tokens are signed with HS256. Configure via AUTH_SECRET env var.

  See Also
    User, Session

  Tags: security, jwt, session | since 2.0.0
```

### Project Doc Site

`forge docs --site` generates a static site with:
- **Auto-discovered modules** from file structure
- **All documented symbols** grouped by module/file
- **Cross-references** between types (User links to User's page)
- **Search** across all project symbols
- **Language reference** section (embedded from `forge lang`)

```
project-docs/
├── index.html              # Project overview + symbol index
├── modules/
│   ├── auth.html           # All symbols from auth module
│   └── models.html
├── functions/
│   ├── create_token.html
│   └── ...
├── types/
│   ├── User.html
│   ├── Point.html
│   └── ...
├── lang/                   # Embedded language reference
│   ├── index.html
│   └── ...
└── search-index.json
```

### Why This Matters

Most languages bolt on doc generators after the fact (JSDoc, RustDoc, GoDoc). Forge bakes it in from day one:

1. **Same comment format everywhere** — language docs and user docs use identical `///` syntax
2. **Zero config** — `forge docs` just works on any `.fg` file
3. **Tested docs** — `/// expect:` comments in doc examples are run by `forge test`
4. **LLM-ready** — `forge docs --llm` gives any AI instant context on your project
5. **Composable** — `forge docs --llm --with-lang` = complete context for AI-assisted development

---

## Address Resolution

Everything is addressable via dot-paths. The two commands have separate resolution chains:

### `forge lang` Resolution (Language)

```
closures                          → feature overview
closures.syntax                   → syntax section
closures.examples.basic           → specific example file
closures.notes                    → collected @note annotations
closures.docs.with_pipes          → composition doc

string                            → type overview + all methods
string.split                      → method signature + examples
list.map                          → method signature + examples

F0012                             → error explanation + examples

|>                                → symbol lookup → pipe_operator
?.                                → symbol lookup → null_safety
<-                                → symbol lookup → channels
defer                             → keyword lookup → defer feature

@http.server                      → package component docs
@model                            → package component docs
```

Resolution order:
1. Exact feature ID match (`closures`)
2. Symbol table lookup (`|>`, `?.`, `<-`)
3. Keyword table lookup (`defer`, `spawn`, `match`)
4. Type name match (`string`, `list`, `int`)
5. Error code match (`F0012`)
6. Package component match (`@http.server`)
7. Fuzzy search fallback

### `forge docs` Resolution (Project)

```
area                              → user's function
Point                             → user's struct
Point.x                           → struct field
Color.Red                         → enum variant
auth                              → module (from file/directory)
auth.create_token                 → function in module
```

Resolution order:
1. Exact function/struct/enum name match
2. Module name match (from file structure)
3. Qualified path (`module.symbol`)
4. **Fallthrough to `forge lang`** resolution (with hint)
5. Fuzzy search fallback

---

## Package Documentation

Packages are documented via the same system, extracted from `package.toml` + `package.fg`:

### From `package.toml`:
```toml
[package]
name = "std-http"
version = "0.1.0"
description = "HTTP server components"

[components.server]
description = "HTTP server with routing"
```

### From `package.fg`:
```forge
/// @title: HTTP Server
/// @section: components
/// The server component provides HTTP routing and serving.
component server(__tpl_name) {
    config {
        port: int = 3000    /// @doc: Port to listen on
        cors: bool = false  /// @doc: Enable CORS headers
    }

    /// @syntax: route {METHOD} {path} -> {handler}
    @syntax("route {method} {path} -> {handler}")
    fn route(method: string, path: string, handler: fn) {}

    /// @syntax: mount {service} at {path}
    @syntax("mount {service} at {path}")
    fn mount(service: string, path: string) {}
}
```

Rendered:

```
$ forge docs @http.server

  @http.server                                      std-http v0.1.0
  ─────────────────────────────────────────────────────────────────

  HTTP server with routing.

  Config
    port: int = 3000     Port to listen on
    cors: bool = false   Enable CORS headers

  Syntax
    route GET /path -> handler_fn
    mount service_name at /path

  Example
    use @http.server

    server {
      route GET /users -> list_users
      route POST /users -> create_user
      mount users_service at /api
    }
```

---

## Doc Validation

`forge docs --validate` checks completeness:

```
$ forge docs --validate

  Documentation Coverage Report
  ─────────────────────────────

  Features: 26/26 documented ✓
    ✓ closures: 4 examples, 2 sections, syntax defined
    ✓ pipe_operator: 3 examples, 1 section, syntax defined
    ⚠ channels: no @since annotation
    ✗ table_literal: missing examples/basic.fg

  Types: 5/5 documented ✓
    ✓ string: 6 methods documented
    ✓ list: 5 methods documented
    ⚠ map: 2 methods missing doc strings

  Errors: 12/12 documented ✓

  Packages: 7/7 documented ✓
    ⚠ std-channel: no component examples

  Composition Docs: 3 found
    ✓ closures/docs/with_pipes.md: code blocks tested

  Coverage: 94% (3 warnings, 1 error)
```

Runs in CI. Blocks merge if coverage drops below threshold.

---

## Implementation Plan

### Phase 1: `forge lang` — Annotation Parser + CLI Renderer
1. Build annotation parser that extracts `@title`, `@section`, `@note`, etc. from `.fg` files
2. Extend `LanguageFeature` trait with `syntax()`, `short()`, `symbols()`
3. Implement `forge lang <feature>` CLI command — assembles and renders feature pages
4. Implement `forge lang <symbol>` — symbol/keyword lookup
5. Implement `forge lang --all` — index of everything

### Phase 2: `forge lang` — Type + Intrinsic Extraction
1. Add `.doc()` builder on intrinsic registration
2. Implement `forge lang <type>` and `forge lang <type>.<method>`
3. Wire error codes into doc system: `forge lang F0012`

### Phase 3: `forge lang` — Compact Formats
1. Implement `forge lang --llm` (auto-assembled compact spec)
2. Implement `forge lang --grammar` (BNF from syntax rules)
3. Implement `forge lang --cheatsheet`
4. Implement `forge lang search`

### Phase 4: `forge docs` — User Code Documentation
1. Parser preserves `///` comments and attaches to next declaration (fn, struct, enum, let)
2. Extract `@param`, `@returns`, `@doc` annotations from user code
3. Build project symbol index from parsed AST
4. Implement `forge docs <symbol>` — project symbol lookup
5. Implement `forge docs` — project overview
6. Implement fallthrough to `forge lang` when no project match
7. Implement `forge docs --llm` and `forge docs --llm --with-lang`

### Phase 5: `forge docs --validate` + `forge lang --validate`
1. Implement `forge lang --validate` — checks language doc coverage (features, types, errors)
2. Implement `forge docs --validate` — checks project doc coverage (exported symbols)
3. Coverage threshold enforcement

### Phase 6: Website Generation
1. Build minimal HTML template engine
2. Implement `forge lang --site` — language reference website
3. Implement `forge docs --site` — project doc site (with embedded lang reference)
4. Search index generation
5. Forge syntax highlighter (for the website)

### Phase 7: Package Docs
1. Extract docs from `package.fg` annotations
2. Extract config schema docs
3. `forge lang @namespace.component` resolution

---

## Design Decisions

### Q: Why not use mdBook / Docusaurus / etc.?
The compiler already knows the entire language. External tools would require us to maintain a separate representation of the language. By generating docs from the compiler itself, we get **guaranteed accuracy** — if the feature compiles, the docs are correct.

### Q: Why annotations in comments, not a separate file?
Because the example file is already a test. Adding annotations keeps everything co-located: the code, its expected output, and its documentation are one artifact. If the example breaks, the doc breaks. You can't have stale docs.

### Q: Won't the LLM compact format get stale?
It's generated, not hand-written. `forge docs --llm` reads from the same source as everything else. It changes when features change.

### Q: How do we handle features with no examples?
`forge docs --validate` catches this. A feature without examples is undocumented, period. The status system already tracks this (Draft = no tests = no docs).

### Q: What about non-feature concepts (e.g., "how does scoping work")?
These go in composition docs (`features/<relevant>/docs/`) or a top-level `docs/concepts/` directory. They're the only hand-written docs. The bar is: if it can't be demonstrated in an example, it gets a composition doc.

### Q: Why `forge lang` and `forge docs` instead of one command?
Because they serve different audiences at different times. A user learning Forge types `forge lang closures`. A user documenting their API types `forge docs`. A user who can't remember which namespace something is in just types `forge docs thing` and gets an answer either way (thanks to fallthrough). Two commands, one system, zero confusion.

### Q: Can `forge docs` work without a project?
Yes — it just falls through to `forge lang` for everything. So `forge docs closures` outside a project is identical to `forge lang closures`. The UX is seamless.

### Q: How does `forge docs search` work?
We build a search index from:
- Feature names, descriptions, tags
- Annotation `@tags`
- Syntax patterns
- Method names and type names
- Prose text from `///` comments
- Error code descriptions

CLI search is substring/fuzzy match. Website search uses the same index with client-side JS.
