# Forge Type System — Product Requirements Document

## Problem Statement

The bootstrap compiler has no type checking pass. The pipeline is Parse → Resolve (names only) → Codegen. All type logic lives in codegen, scattered across 15 feature files with 21+ ad-hoc `vtype_is_str`/`vtype_is_list` checks. Every new feature must handle every type it might encounter, and every existing feature must handle every new type. This creates a combinatorial explosion of edge-case bugs that grows quadratically with the number of features.

**Current metrics:**
- 50 match arms across emit_expr (29) and emit_stmt (21)
- 21 ad-hoc type dispatch calls scattered across codegen files
- 15 separate feature codegen modules all doing their own type guessing
- 0 lines of type checking code

**Evidence of the problem:**
- if-expressions returned `Int` instead of `Str` — type not propagated
- `list.map(fn)` lost the return type — codegen used input element type
- `string(x)` didn't know `x` was already a string — no type info from if-expr
- `it` parameter wrapped at wrong scope — type context not available to parser
- Every fix required touching codegen in multiple feature files

## Vision: Proof-Carrying Types

Every expression in Forge carries not just a type but a **type derivation** — a chain of reasoning that explains WHY it has that type. When types conflict, the compiler traces both chains back to their source and shows exactly where they diverge.

### Core Principles

**1. Bidirectional flow.** Types propagate forward (from values to consumers) AND backward (from expected results to inputs). `let x: string = some_fn()` constrains what `some_fn` returns. `.map` returning `List<T>` propagates T backward from usage.

**2. Flow-sensitive narrowing.** After `if x != null`, `x` is `T`, not `T?`. After `match x { .Some(v) -> ... }`, `v` has the inner type. The type of a variable changes based on what the code has proven about it.

**3. One pass, all errors.** The type checker never stops at the first error. It assigns `Error` type to broken expressions and continues. You see all 7 problems in one compile, not one at a time across 7 compiles.

**4. The checker is the single source of truth.** Codegen never asks "is this a string?" It reads the type from the checked AST. Zero type logic in codegen. This eliminates the combinatorial explosion — type interactions are resolved ONCE, centrally.

**5. Suggestions with confidence.** Every error comes with ranked fix suggestions. High-confidence fixes (> 0.9) can be auto-applied. Levenshtein distance for typos. Context-aware suggestions.

---

## Vision: Futuristic Error System

The diagnostic infrastructure is architected for what's coming, not just what's needed today. Phase 0 builds the foundation; these capabilities are unlocked by the architecture without redesign.

### Capability Tiers

**Tier 1 (Phase 0 — build now):**
- Error codes, spans, multi-label source context
- "Did you mean?" via Levenshtein distance
- Help text with actionable guidance
- DiagnosticBag collects all errors, renders at end
- `forge fix` auto-applies high-confidence suggestions

**Tier 2 (Phase 1 — unlocked by type checker):**
- Type derivation chains — "this is Int because X, which is Int because Y"
- Bidirectional blame — "expected Str here because the function signature says so"
- Exhaustiveness warnings — "match doesn't cover variant .Error"
- Unused variable/import warnings (the resolver already tracks definitions)
- Unreachable code detection (after `return`, `break`, `continue`)

**Tier 3 (future — unlocked by architecture):**
- **Interactive errors** — the compiler asks clarifying questions when ambiguous, remembers answers
- **Error tutorials** — `forge explain F0012` opens a rich explanation with examples, common causes, and fix patterns
- **Fix preview** — `forge fix --preview` shows a diff of all auto-fixes before applying
- **Error history** — track which errors a developer hits most often, surface relevant docs proactively
- **Cross-file blame** — "this type mismatch originates in module X, which exports the wrong type"
- **Regression detection** — "this error was fixed in commit abc123 but reintroduced here"

### Architectural Decisions That Enable This

**1. Diagnostics are data, not strings.** A `Diagnostic` is a structured record with typed fields (code, severity, span, labels, suggestions), not a formatted string. This means:
- JSON output for tooling (`forge check --json`)
- LSP integration (diagnostics map directly to LSP `Diagnostic` protocol)
- Filtering/sorting (show only errors, only warnings, only from specific files)
- Machine-readable for CI/CD (parse error codes, track regressions)

**2. Spans are attached everywhere.** Every AST node carries a Span. Every type derivation step records which span triggered it. This means error messages can always point at source code — even for errors discovered deep in the type checker or codegen.

**3. Labels are ordered and typed.** Primary labels mark the error location. Secondary labels mark contributing locations. This means errors can show the full story: "the conflict is HERE (primary), caused by THIS declaration (secondary) and THIS usage (secondary)."

**4. Suggestions are structured edits.** A suggestion is `(span, replacement)` pairs with a confidence score, not a prose description. This means `forge fix` can apply them mechanically, and IDEs can offer quick-fix actions.

**5. The bag pattern.** All passes report into a shared DiagnosticBag. No pass aborts on the first error. This means:
- Users see all errors at once
- Later passes can add context to earlier errors (type checker annotates parser errors with type info)
- Error count limits prevent flooding (`--max-errors 10`)

### Error Code Space

Reserve error code ranges for each subsystem:

| Range | Subsystem | Examples |
|-------|-----------|----------|
| F0001-F0099 | Syntax/Lexer | unterminated string, unexpected token |
| F0100-F0199 | Name resolution | undefined variable, duplicate definition |
| F0200-F0299 | Type checking | type mismatch, wrong arg count, missing field |
| F0300-F0399 | Refinement types | can't prove predicate, refinement violated |
| F0400-F0499 | Codegen | unsupported feature, LLVM error |
| F0800-F0899 | Warnings | unused variable, unreachable code |
| F0900-F0999 | Internal | ICE, assertion failure |

Each error code maps to a documentation page. `forge explain F0012` shows the full explanation with examples.

---

## Feature 1: Type Checker Pass

### Architecture

```
Source
  |
Lexer -> Tokens
  |
Parser -> AST (untyped)
  |
Resolver -> AST (names resolved)
  |
TypeChecker -> TypedAST + Diagnostics    <-- NEW
  |
  |-- if errors -> render diagnostics, stop
  |
Codegen -> LLVM IR (mechanical, no type logic)
```

### Sub-Passes

```
Pass 1: Declare     -- register all type/enum/fn declarations with signatures
Pass 2: Infer       -- walk every expression bottom-up, compute types
Pass 3: Unify       -- resolve constraints (if-branches agree, match arms agree)
```

### Type Environment

```forge
type TypeEnv = {
    vars: VarTypeMap,       // variable -> type, with scope nesting
    fns: FnTypeMap,         // function -> (param types, return type)
    structs: StructTypeMap, // struct -> field types
    enums: EnumTypeMap,     // enum -> variant types
    diagnostics: DiagnosticList,
}
```

### What the Type Checker Resolves

For every expression node in the AST, the type checker computes and attaches a `ValueType`. Specifically:

**Literals:** Trivial — `42` is `Int`, `"hello"` is `Str`, `true` is `Bool`, `null` is `Void`.

**Variables:** Looked up in the type environment. If the variable has a type annotation, use it. Otherwise, infer from the initializer.

**Binary operations:**
- Arithmetic (`+`, `-`, `*`, `/`, `%`): both operands must be `Int` (or `Str` for `+` concat). Result type is `Int` or `Str`.
- Comparison (`==`, `!=`, `<`, `>`, `<=`, `>=`): both operands must be same type. Result is `Bool`.
- Logical (`&&`, `||`): both operands must be `Bool`. Result is `Bool`.

**Function calls:** Look up the function's declared return type. If calling a closure, use the closure's return type from `ValueType.Fn(ret)`.

**Field access:** Look up the struct type, find the field's declared type.

**If-expressions:** Both branches must produce the same type. If they disagree, report an error with both derivation chains.

**Match expressions:** All arms must produce the same type. If they disagree, report which arms conflict.

**List literals:** Infer element type from the first element. Verify all elements match. Result is `List(elem_type)`.

**Map literals:** Keys are `Str`, values inferred from first entry.

**Lambda:** Infer param types from context (e.g., `.map` provides the element type). Infer return type from body.

**Null coalescing (`??`):** Left side must be `T?`. Right side must be `T`. Result is `T`.

**Pipe (`|>`):** Type of left flows into the function on the right.

### Typed AST Representation

Rather than modifying the existing `Expr` enum (which would break every match), we use a **type table** — a side structure that maps expression identities to their computed types.

```forge
// Each expression gets a unique ID during parsing
type ExprId = int

// The type checker populates this table
type TypeTable = {
    types: Map<ExprId, ValueType>,
    diagnostics: DiagnosticList,
}
```

Alternative (simpler for bootstrap): add a `ty: ValueType` field to `EmitResult` — which we already have — and ensure the type checker fills it in BEFORE codegen. The type checker walks the AST and produces a `TypedProgram` where every expression node is annotated.

### What Codegen Becomes

**Before (current — type logic in codegen):**
```forge
.Binary(left, op, right) -> {
    let l = emit_expr(ctx, env, left)
    let r = emit_expr(ctx, env, right)
    if vtype_is_str(l.ty) || vtype_is_str(r.ty) {  // <-- TYPE LOGIC
        emit_concat(ctx, l.value, r.value)
    } else {
        ok_emit(forge_llvm_build_add(...))
    }
}
```

**After (type checker decides, codegen is mechanical):**
```forge
.Binary(left, op, right, ty) -> {
    let l = emit_expr(ctx, env, left)
    let r = emit_expr(ctx, env, right)
    match op {
        .Add -> match ty {
            .Str -> emit_concat(ctx, l.value, r.value)
            _    -> ok_emit(forge_llvm_build_add(...))
        }
    }
    // No guessing. The type checker already validated
    // that both sides are compatible.
}
```

The difference: codegen trusts the types. It never validates, never checks, never guesses. The type checker already did all that work.

### Error Examples

**Type mismatch in if-expression:**
```
error[F0012]: branches of if-expression produce different types

  let result = if x > 0 { "positive" } else { 42 }
                           ^^^^^^^^^^          ^^
                           Str                 Int

  then-branch is Str because:
    -> string literal "positive" : Str

  else-branch is Int because:
    -> integer literal 42 : Int

  help: both branches must produce the same type
  suggestion: wrap the integer: string(42)
```

**Wrong argument type:**
```
error[F0014]: argument type mismatch

  fn greet(name: string) -> string { ... }
  greet(42)
        ^^
        Int

  parameter `name` expects string, but got Int

  help: convert with string(42)
```

**Undefined field:**
```
error[F0020]: no field `nme` on type User

  let x = user.nme
               ^^^

  User has fields: name, age, email

  help: did you mean `name`?
```

### Scope of Phase 1

Phase 1 focuses on getting the architecture right with the most common type checks:

1. All literal types (int, string, bool, null)
2. Variable declaration and lookup
3. Binary/unary/logical operator type rules
4. Function call return types
5. Field access types
6. If-expression branch unification
7. Match arm unification
8. List element type inference
9. Null coalescing type merging
10. Lambda parameter and return type inference

Phase 1 does NOT include:
- Refinement types (Phase 2)
- Effect tracking (later)
- Comptime (later)
- Structural subtyping (later)

---

## Feature 2: Refinement Types

### Overview

Refinement types extend the base type system with **where clauses** — logical predicates that constrain values beyond their base type. The compiler proves these predicates at compile time when possible, and inserts runtime assertions when not.

```forge
type Positive = int where it > 0
type NonEmpty<T> = List<T> where it.length > 0
type ValidPort = int where it >= 1 && it <= 65535
type NonBlank = string where it.length > 0
```

### How It Works

**Step 1: Declaration.** The `where` clause creates a named refinement type. Internally this is `Refinement(base: ValueType, predicate: Expr)`.

**Step 2: Proving.** When a value is used where a refinement type is expected, the type checker tries to PROVE the predicate holds:

```forge
fn sqrt(n: Positive) -> float { ... }

let x = 5
sqrt(x)       // OK: literal 5 > 0, provable at compile time

let y = int(input())
sqrt(y)       // ERROR: can't prove y > 0

if y > 0 {
    sqrt(y)   // OK: the if-guard proves y > 0 (flow narrowing)
}
```

**Step 3: Flow narrowing integration.** Control flow constructs that check conditions matching the refinement predicate automatically narrow the type:

```forge
fn process(list: List<int>) {
    if list.length == 0 { return }
    // After this guard, compiler knows list : NonEmpty<int>
    let first = head(list)  // valid
}
```

**Step 4: Runtime fallback.** When the compiler can't prove a refinement statically, it can insert a runtime check:

```forge
let port = int(input()) as ValidPort   // runtime assertion: 1..65535
// If assertion fails: panic with "refinement violated: expected 1 <= value <= 65535, got -1"
```

### Proving Strategies

The type checker uses a simple SMT-like solver for common cases:

**Literal analysis:**
- `5 > 0` → trivially true
- `"hello".length > 0` → true (length is 5)

**Guard analysis:**
- After `if x > 0`, x satisfies `it > 0`
- After `if x != null`, x satisfies non-null
- After `match x { .Some(v) -> ... }`, v is the inner type

**Arithmetic propagation:**
- If `x: Positive` and `y: Positive`, then `x + y: Positive`
- If `x: Positive`, then `x * 2: Positive`
- If `x: Positive`, then `-x` does NOT satisfy Positive

**Function return analysis:**
- If `fn abs(n: int) -> Positive`, callers get a Positive back

**When the compiler CAN'T prove:** it reports what it knows and what's missing:

```
error[F0015]: can't prove refinement `Positive` for `user_input`

  sqrt(user_input)
       ^^^^^^^^^^

  Positive requires: it > 0
  Known facts about user_input:
    - type is int (from int() conversion)
    - no constraints on value

  help: add a guard:
    if user_input > 0 {
        sqrt(user_input)  // now provable
    }

  or use explicit assertion:
    sqrt(user_input as Positive)  // runtime check
```

### Syntax

```forge
// Named refinement types
type Positive = int where it > 0
type NonEmpty<T> = List<T> where it.length > 0
type Percentage = int where it >= 0 && it <= 100
type Email = string where it.contains("@") && it.length > 0

// Inline refinement on parameters
fn divide(a: int, b: int where it != 0) -> int {
    a / b
}

// Refinement on return type
fn parse_port(s: string) -> (int where it >= 1 && it <= 65535)? {
    let n = int(s)
    if n >= 1 && n <= 65535 { return n }
    null
}
```

### Interaction with Other Features

**Match exhaustiveness:** Refinement types enable the compiler to check that match arms cover all cases:

```forge
type Sign = int where it == -1 || it == 0 || it == 1

fn describe(s: Sign) -> string {
    match s {
        -1 -> "negative"
        0 -> "zero"
        1 -> "positive"
        // No wildcard needed — compiler knows these are exhaustive
    }
}
```

**Collection operations:** List operations preserve and propagate refinements:

```forge
let items: NonEmpty<int> = [1, 2, 3]
let doubled = items.map(it * 2)
// doubled : NonEmpty<int> — map preserves non-emptiness

let filtered = items.filter(it > 10)
// filtered : List<int> — filter might produce empty list, refinement lost

items.push(4)
// items still NonEmpty — push can only add elements
```

**Error propagation:**

```forge
fn get_user(id: Positive) -> User? { ... }
fn process(id: int) -> User? {
    if id <= 0 { return null }
    get_user(id)  // OK: guard proved id > 0
}
```

### Scope of Phase 2

Phase 2 implements:
1. `where` clause syntax in type declarations
2. `Refinement(base, predicate)` variant in ValueType
3. Literal proving (compile-time constant evaluation)
4. Guard-based narrowing (if-checks prove refinements)
5. Arithmetic propagation (basic rules for +, *, -)
6. `as RefinementType` for explicit runtime assertions
7. Error messages showing what's known vs what's needed

Phase 2 does NOT include:
- Full SMT solving (too complex for bootstrap)
- Cross-function refinement propagation (keep it local)
- Dependent types (refinements that depend on other variables)

---

## Implementation Roadmap

### Phase 0: Diagnostic Infrastructure

The diagnostic system is the rendering and reporting layer that every subsequent phase builds on. Without it, the type checker produces `err_emit("some string")` — no source locations, no context, no suggestions, no error codes. The Rust-based Forge compiler already has this system fully built. We port the architecture to Forge.

#### What We Port

From `forge/packages/forgec-rust/errors/diagnostic.rs`:

**Span** — source location with byte offsets, line, and column:
```forge
type Span = {
    start: int,      // byte offset into source
    end: int,        // byte offset end
    line: int,       // 1-based line number
    col: int,        // 1-based column
}
```

**Diagnostic** — a single error, warning, or hint with full context:
```forge
type Diagnostic = {
    code: string,           // "F0012", "F0020", etc.
    severity: Severity,     // Error, Warning, Info, Hint
    message: string,        // "type mismatch in if-expression"
    span: Span,             // primary source location
    help: string?,          // "both branches must produce the same type"
    labels: LabelList,      // multi-location highlighting
    suggestions: SuggestionList,  // auto-fix proposals
    tip: string?,           // additional note
}

enum Severity { Error, Warning, Info, Hint }
```

**Labels** — point at multiple source locations with messages:
```forge
type Label = {
    span: Span,
    message: string,        // "expected Str here"
    kind: LabelKind,        // Primary (red) or Secondary (blue)
}
enum LabelKind { Primary, Secondary }
```

This is what enables errors like:
```
error[F0012]: type mismatch in if-expression

   |  let result = if x > 0 { "positive" } else { 42 }
   |                           ^^^^^^^^^^          ^^
   |                           Str                 Int
   |
   = help: both branches must produce the same type
```

The primary label (red) points at the main problem. Secondary labels (blue) point at related locations — the other branch, the function signature that constrains the type, the variable declaration, etc.

**Suggestions** — proposed fixes with confidence scores:
```forge
type Suggestion = {
    message: string,        // "wrap with string()"
    edits: EditList,        // source replacements
    confidence: int,        // 0-100 (95 = auto-fixable)
}
type Edit = {
    span: Span,             // what to replace
    replacement: string,    // what to replace it with
}
```

High-confidence suggestions (>90) can be auto-applied with `forge fix`. Low-confidence suggestions are shown as "did you mean?" hints.

**DiagnosticBag** — collects diagnostics during a compilation pass:
```forge
type DiagnosticBag = {
    diagnostics: DiagnosticList,
}
```

Methods: `report(diag)`, `has_errors()`, `error_count()`, `print_all(source, filename)`.

**Suggestions helper** — Levenshtein distance for "did you mean?" on undefined variables/fields:
```forge
fn suggest_similar(name: string, candidates: List<string>) -> string? {
    // Returns the candidate with smallest edit distance, if < 3
}
```

#### How It Integrates

Every compiler pass (parser, resolver, type checker) receives a `DiagnosticBag` and reports errors into it. At the end, the bag is rendered. This replaces:

**Before:**
```forge
// Parser
self.set_error("expected `{` after if condition")
// Resolver
err_resolve("undefined variable `x`")
// Codegen
err_emit("field access on non-struct value")
```

**After:**
```forge
// Parser
bag.report(Diagnostic {
    code: "F0001",
    severity: Severity.Error,
    message: "expected `{` after if condition",
    span: self.current_span(),
    help: "if-expressions require braces around the body",
    ...
})
// Resolver
bag.report(Diagnostic {
    code: "F0020",
    severity: Severity.Error,
    message: `undefined variable \`${name}\``,
    span,
    help: suggest_similar(name, env.all_names()) ?? null,
    ...
})
// Type checker
bag.report(Diagnostic {
    code: "F0012",
    severity: Severity.Error,
    message: "type mismatch",
    span,
    labels: [
        Label { span: then_span, message: vtype_display(then_ty), kind: LabelKind.Primary },
        Label { span: else_span, message: vtype_display(else_ty), kind: LabelKind.Secondary },
    ],
    help: "both branches must produce the same type",
    ...
})
```

#### Rendering

The Rust compiler uses the `ariadne` crate for pretty-printing. We implement our own renderer in Forge — it reads the source file, extracts the relevant lines, and underlines the spans with `^` characters. Color output via ANSI escape codes (with TTY detection).

```
error[F0012]: type mismatch in if-expression
  --> app.fg:5:30
   |
 5 |  let result = if x > 0 { "positive" } else { 42 }
   |                           ^^^^^^^^^^          ^^ Int
   |                           Str
   |
   = help: both branches must produce the same type
   = suggestion: wrap the integer: string(42)
```

#### Span Tracking

The parser must track source spans for every token and AST node. Currently the parser tracks `current_line` and `current_column` but not byte offsets. We add:

```forge
// In the Parser struct:
mut current_start: int,   // byte offset where current token started

// Every token records its span:
type TokenSpan = {
    start: int,
    end: int,
    line: int,
    col: int,
}
```

Every `Expr` and `Stmt` node gets a `span: Span` field so the type checker and error renderer can point at the exact source location.

#### Files to Create

- `src/core/diagnostic.fg` — Diagnostic, Severity, Label, Suggestion, Edit, DiagnosticBag types + builder functions
- `src/core/render.fg` — source-context renderer (read line from source, underline spans, ANSI colors)
- `src/core/suggest.fg` — Levenshtein distance, similar name suggestions

#### Files to Modify

- `src/parse/mod.fg` — track byte offsets, attach Span to every AST node
- `src/core/ast.fg` — add `span: Span` to Expr and Stmt (or a parallel SpanTable)
- `src/core/resolver.fg` — report via DiagnosticBag instead of returning error strings
- `src/main.fg` — create DiagnosticBag, pass through all phases, render at end

#### Prerequisites

None. This is the foundation everything else builds on.

#### Success Criteria

- All errors include error code, source location, and help text
- Multi-label errors show primary + secondary source locations
- "Did you mean?" suggestions for undefined variables/fields (Levenshtein)
- Errors render with source context and underlined spans
- DiagnosticBag collects all errors without stopping at the first one
- Existing tests still pass (error format changes but behavior doesn't)

---

### Phase 1: Type Checker

**Prerequisite:** Phase 0 (diagnostic infrastructure) must be complete. The type checker reports errors via DiagnosticBag with spans, labels, and suggestions.

**Files to create:**
- `src/core/typeck.fg` — main type checker, walks AST, infers types, reports via DiagnosticBag

**Files to modify:**
- `src/core/ast.fg` — add type annotations to expressions (ExprId or inline `ty` field)
- `src/codegen/mod.fg` — remove all `vtype_is_*` calls, read types from checker
- `src/main.fg` — insert type check pass between resolve and codegen
- All 15 feature codegen files — simplify to trust types from checker

**Estimated scope:** Large refactor. Every codegen function changes from "compute type then emit" to "read type then emit". But each individual change is mechanical.

**Success criteria:**
- All 183 existing tests pass
- Codegen has zero `vtype_is_str`/`vtype_is_list`/`vtype_is_fn` calls
- Type errors are reported with source spans and derivation chains
- New edge-case tests pass WITHOUT adding type logic to codegen

---

### Phase 2: Refinement Types

**Files to create:**
- `src/features/refinements/parser.fg` — parse `where` clauses
- `src/features/refinements/checker.fg` — prove/disprove refinements
- `src/features/refinements/codegen.fg` — emit runtime assertions for `as` casts

**Files to modify:**
- `src/core/ast.fg` — add `Refinement` to ValueType
- `src/core/typeck.fg` — integrate refinement proving into type checker
- `src/parse/mod.fg` — parse `where` in type positions

**Prerequisite:** Phase 1 must be complete. Refinement types are an extension of the base type checker.

**Success criteria:**
- `type Positive = int where it > 0` compiles
- `sqrt(5)` passes type check (literal proving)
- `sqrt(x)` after `if x > 0` passes (guard narrowing)
- `sqrt(unknown)` produces error with derivation chain
- `unknown as Positive` inserts runtime assertion

---

## Prior Art

### From the Rust Compiler (in this repo)

The Rust-based Forge compiler at `forge/packages/forgec-rust/` already implements:

- **`Type` enum with 22 variants** — Int, Float, Bool, String, Void, Never, Ptr, Nullable, List, Map, Tuple, Struct, Enum, Function, Result, Range, Channel, DynTrait, TypeVar, Unknown, Error (`typeck/types.rs`)
- **`TypeChecker` with two-pass registration** — first pass registers type stubs (forward refs), second pass resolves fields (`typeck/checker.rs`)
- **`TypeEnv`** — symbol table, type aliases, struct/enum registry (`typeck/env.rs`)
- **`Diagnostic` with multi-label spans** — primary + secondary labels, suggestions with confidence scores, builder pattern (`errors/diagnostic.rs`)
- **36 `CompileError` variants** — every error class is a typed enum with required fields and actionable help text (`errors/compile_error.rs`)
- **Suggestion system** — Levenshtein distance for "did you mean?", placeholder_for_type for example values (`errors/suggestions.rs`)
- **Autofix** — confidence-scored fixes with overlap detection (`errors/autofix.rs`)
- **Error registry** — TOML-based mapping of error codes to titles, help text, docs URLs (`errors/registry.rs`)

### From Production Compilers

- **Rust (rustc):** All interesting logic is in `rustc_typeck`. Codegen (`rustc_codegen_llvm`) is mechanical.
- **Swift:** SIL (Swift Intermediate Language) is fully typed. Codegen from SIL is trivial.
- **Go:** Type checking is a separate pass. Codegen reads typed AST.
- **Elm:** Gold standard for error messages with derivation chains.
- **Zig:** Comptime execution — any function can run at compile time.
- **Idris/F*:** Dependent/refinement types with proof obligations.
- **TypeScript:** Flow-sensitive narrowing (null checks refine types).

### From Crafting Interpreters

The key architectural insight: the grammar IS the code. Each grammar rule maps to a function. A terminal is a match(), a nonterminal is a function call, alternation is if, repetition is while. If the grammar is right, the parser is right by construction.

Applied to type checking: each TYPE RULE maps to a function. If the type rules are right, the checker is right by construction. No ad-hoc guessing.

---

## Non-Goals

- **Full dependent types** — too complex for a bootstrap compiler
- **Higher-kinded types** — not needed for Forge's design
- **Trait coherence checking** — Forge uses structural subtyping direction
- **Lifetime/borrow analysis** — Forge uses GC/manual, not ownership
- **Incremental type checking** — whole-program checking is fine for bootstrap scale
- **IDE protocol (LSP)** — future work, not blocking

---

## Current Status (April 10, 2026)

### Phase 0: DONE
- ✅ Span, Diagnostic, DiagnosticBag types
- ✅ DiagCode enum with ErrorDef single-match registry
- ✅ Beautiful renderer (ariadne box + miette symbols + gray chrome)
- ✅ Error recovery (parser synchronizes + continues)
- ✅ `\x` hex escapes in lexer (for ANSI codes)
- ✅ Levenshtein distance for suggestions
- ⚠️ Resolver bag reporting disabled (TECH_DEBT #20)
- ⚠️ render_bag removed from compile path (TECH_DEBT #21)
- ⚠️ No source spans on AST nodes (TECH_DEBT #18)

### Phase 1: IN PROGRESS
- ✅ Type checker created (`src/typeck/mod.fg`, top-level module)
- ✅ Walks ALL expression/statement forms
- ✅ Function body checking works
- ✅ If-expr branch type mismatch detection
- ✅ Wrong argument count detection
- ✅ Wired into `check` command with rendering
- ⚠️ Struct field access check doesn't trigger (TECH_DEBT #17)
- ⚠️ `bind_params` inlined as workaround (TECH_DEBT #19)
- ❌ No type annotations on AST nodes
- ❌ Codegen still has all vtype_is_* calls (0 removed)
- ❌ No source spans in type checker diagnostics
- ❌ Type checker silent during compile (only runs in check mode)

### Phase 2: NOT STARTED

## Success Metrics

After Phase 1:
- Zero `vtype_is_*` calls in codegen
- Type errors caught before codegen runs
- Error messages include source location and derivation chain
- Adding a new expression type requires: AST variant + parser + type rule + codegen arm (4 places, not 15)
- New features don't create combinatorial interactions — the type checker handles composition

After Phase 2:
- `where` clauses on type declarations
- Compile-time proving for literals and guards
- "Can't prove" errors with guidance on what guard to add
- Runtime assertions via `as` for unprovable cases
