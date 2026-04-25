# Avra v1.0 — Technical Requirements Document

> Maps the FULL_SPEC.md v1.0 scope against the current Forge bootstrap compiler.
> Every section ends with numbered tickets for the beads (`bd`) tracker.

---

## Executive Summary

The Forge bootstrap compiler is a **fully self-hosted compiler** with working: lexer, parser, resolver, type checker, LLVM IR codegen, monomorphizer, and a C runtime. It compiles itself (seed → bs2 → bs3 fixed-point).

The spec describes **Avra** — a renamed, expanded version of Forge. Many v1.0 features already exist in some form. This TRD identifies **what's missing, what's incomplete, and what needs to change** to ship Avra v1.0, organized into iterative phases.

### What v1.0 IS (from spec Axis 9 versioning):
- App-level only (RC + cycle detection + arenas)
- Single-threaded green-thread runtime (I/O concurrency, no CPU parallelism)
- Full type system: generics, traits, shapes, enums, unions, pattern matching
- Error handling: Result<T,E>, ?, catch, union errors, Error trait
- Module system: file=module, export/use, packages, orphan rules
- Concurrency: spawn, channels, select, streams, structured concurrency
- Tooling: formatter, LSP, autofix, JSON diagnostics

### What v1.0 is NOT:
- No systems/bare/hardware levels
- No borrow checker or lifetimes
- No FFI (extern reserved)
- No deploy blocks
- No provider system (@derive, keyword registration)
- No const generics, GATs, refinement types, contracts
- No CPU-parallel spawn

---

## Current Bootstrap Inventory

### Implemented AST Nodes

**Expr (35 variants):** Number, String, Bool, Null, Ident, Assign, Grouping, Unary, Binary, Logical, Call, GenericCall, StructLit, FieldAccess, EnumCtor, Index, Block, MatchExpr, FieldAssign, IfExpr, NullCoalesce, OptionalChain, Try, Tuple, TupleIndex, With, ListLit, Lambda, MapLit, Slice, FloatLit, IsCheck, InCheck, ListComp, QualifiedIdent, When

**Stmt (30 variants):** Let, Mut, Expr, Block, If, While, For, ForIn, Function, Return, ReturnEmpty, TypeDecl, EnumDecl, Match, Impl, NoOp, ExternFn, Break, Continue, TraitDecl, LetDestructure, Defer, Annotated, SpecBlock, GivenBlock, ThenBlock, Select, Parallel, Module, Use

**Pattern (8 variants):** Wildcard, Variant, LitString, LitInt, LitBool, LitFloat, NestedVariant, Or

### Implemented Keywords (KID_*)
let, mut, const, fn, return, if, else, match, for, in, while, loop, break, continue, enum, type, use, mod, as, export, trait, impl, is, table, underscore

### Implemented Features (by directory)
| Feature | Parser | Codegen | Typeck | Resolver | Tests |
|---------|--------|---------|--------|----------|-------|
| closures | ✓ | ✓ | | | ✓ |
| defer_stmt | ✓ | ✓ | | | |
| enum_decl | ✓ | ✓ | | | ✓ |
| error_propagation | | ✓ (Result type) | | | |
| eval | | ✓ | | | |
| extern_decl | ✓ | | | | |
| float_lit | | ✓ | | | |
| fn_decl | ✓ | ✓ | | | ✓ |
| for_stmt | ✓ | ✓ | | | ✓ |
| generics | ✓ | ✓ (mono) | | | ✓ |
| if_stmt | ✓ | ✓ | | | ✓ |
| impl_decl | ✓ | ✓ | | | ✓ |
| in_operator | | ✓ | | | ✓ |
| is_keyword | | ✓ | | | |
| let_stmt | ✓ | ✓ | ✓ | | ✓ |
| list_lit | ✓ | ✓ | ✓ | | ✓ |
| map_lit | ✓ | ✓ | ✓ | | ✓ |
| match_expr | ✓ | ✓ | ✓ | ✓ | ✓ |
| modules | ✓ | | | ✓ | |
| null_safety | | ✓ | | | ✓ |
| parallel_stmt | ✓ | ✓ | | | |
| return_stmt | ✓ | | | | |
| select_stmt | ✓ | ✓ | | ✓ | |
| spec_test | ✓ | ✓ | | | |
| struct_decl | ✓ | ✓ | ✓ | | ✓ |
| trait_decl | ✓ | ✓ | ✓ | | ✓ |
| tuples | | ✓ | | | ✓ |
| while_stmt | ✓ | ✓ | | | ✓ |
| with_expr | | ✓ | | | |

### Runtime (C-side)
- Bump arena allocator
- String operations (concat, compare, interpolate, etc.)
- LLVM wrapper functions
- Thread creation/join (pthread)
- Channel (send/recv/close)
- Select (multi-channel wait)
- Parallel run (thread pool)
- Spec test framework
- Diagnostic/trace tools

### Regression Tests
44 regression test files covering: annotations, closures, concurrency, contextual enums, datetime, durations, dyn dispatch, enum compare, exhaustive match, floats, JSON, nested patterns, parallel, ptr ops, select, semver, shell exec, spec test, string interpolation, tables, tagged templates, TOML, traits, try/result, type operators, typed lambdas, uptime, validation, etc.

---

## Phase 0: Foundation & Rename

> Goal: Rename Forge → Avra, establish .av extension, update tooling surface.
> This is OPTIONAL for v1.0 — can ship as "Forge" first and rename later.
> Included for completeness but lowest priority.

### P0-1: File extension migration (.fg → .av)
- Compiler accepts both .fg and .av
- .fg emits deprecation warning
- Update all source files to .av
- **Spec ref:** Axis 28.6

### P0-2: CLI rename (forge → avra)
- CLI command becomes `avra build`, `avra run`, etc.
- Keep `forge` as alias during transition
- **Spec ref:** Axis 28.6

### P0-3: Manifest rename
- `forge.toml` stays as-is per spec (it's the build config, not the language name)
- **Spec ref:** Axis 28.6

---

## Phase 1: Core Type System Completion

> Goal: Complete the type system to match v1.0 spec.
> This is the highest priority — type system is the foundation everything else builds on.

### P1-1: `shape` keyword for structural types
**Status: NOT IMPLEMENTED**
The spec (Axis 3.1-3.7) requires both `type` (nominal) and `shape` (structural) keywords. Currently only `type`/`struct` exist.

**Work:**
- Add KID_SHAPE to kind_ids.fg
- Add `forge_kind_id_for_keyword("shape")` to runtime.c
- Add Stmt::ShapeDecl variant to AST
- Parser: parse `shape Name = { field: Type, ... }`
- Resolver: register shape types
- Type checker: structural matching (width subtyping — wider shape is subtype of narrower)
- Codegen: shapes compile to same layout as structs
- Tests: shape compatibility, width subtyping, depth subtyping on immutable fields

**Spec ref:** Axis 3.1, 3.2, 3.5, 3.6, 3.7

### P1-2: Union types
**Status: IMPLEMENTED** — `A | B` union syntax works, ValueType.Union, union_type codegen (15 files), union alias decls, match narrowing.
Spec (Axis 8.1, 8.4, 8.5) requires `string | int` ad-hoc union types alongside enums.

**Work:**
- Add Type::Union variant to type representation
- Parser: parse `Type1 | Type2` in type positions
- Type checker: union type compatibility, widening at ? sites
- Codegen: discriminated union layout (tag + largest-variant payload)
- Pattern matching: exhaustive matching on closed unions
- Structural union discrimination (non-overlapping shapes auto-discriminated)

**Spec ref:** Axis 8.1, 8.4, 8.5

### P1-3: Associated types on traits
**Status: NOT IMPLEMENTED**
Spec (Axis 7.1, 7.2) requires `type Item` inside trait declarations.

**Work:**
- Parser: parse `type Name` inside trait blocks
- Resolver: track associated types per trait
- Type checker: verify associated types in impl blocks
- Codegen: monomorphize with concrete associated types
- Syntax: `Self.Item` inside trait, `T.Item` from outside

**Spec ref:** Axis 7.1, 7.2

### P1-4: Newtype wrappers
**Status: IMPLEMENTED** — `type X = Y` creates nominal newtype, `X(value)` constructor, codegen zero-cost. CgNewtypeReg tracks newtypes. regress/newtype.fg tests.
Spec (Axis 3.8) requires `type UserId = UUID` to create a nominally distinct type.

**Work:**
- Type checker: enforce nominal distinction (UserId ≠ UUID)
- Construction: `UserId(value)` explicit conversion
- Access: `.raw()` or reverse construction
- Codegen: zero-cost (same bytes at runtime)

**Spec ref:** Axis 3.8

### P1-5: `where` clauses on generics
**Status: IMPLEMENTED** — parser, resolver, monomorphizer all handle `where T: Trait` clauses. Verified working with `fn max<T>(a: T, b: T) -> T where T: Ord`.
Spec (Axis 5.4) requires `where T: Display & Eq` for complex bounds.

**Work:**
- Parser: parse `where` clause after function/type parameter list
- Resolver: register bounds from where clauses
- Type checker: verify where clause bounds at call sites
- Monomorphizer: respect where clause constraints

**Spec ref:** Axis 5.4

### P1-6: `dyn Trait` dynamic dispatch
**Status: IMPLEMENTED** — vtable boxing, trait dispatch, `dyn Trait` type. regress/dyn_dispatch.fg tests. trait_decl/codegen.fg has box_for_trait.
Spec (Axis 5.2) requires `dyn Trait` for heterogeneous collections.

**Work:**
- Verify current dyn dispatch works for all trait method signatures
- Fat pointer layout (data ptr + vtable ptr)
- `List<dyn Display>` heterogeneous collections
- Codegen: vtable generation and dispatch

**Spec ref:** Axis 5.2

### P1-7: Exhaustive match enforcement
**Status: IMPLEMENTED** — typeck checks exhaustiveness, warns when wildcard hides >2 variants. regress/exhaustive_match.fg tests. match_expr/typeck.fg has check_match_arms + find_missing_variants.
Spec (Axis 8.4, 8.7) requires exhaustive matching with wildcard warnings.

**Work:**
- Type checker: verify all enum variants covered in match
- Wildcard lint: warn when wildcard hides > 2 variants
- Non-exhaustive enum support (@non_exhaustive annotation)
- Error message lists missing variants

**Spec ref:** Axis 8.4, 8.7, 8.8

### P1-8: Enum variant dot-shorthand
**Status: IMPLEMENTED** — `.Variant(args)` works in match arms and enum constructors when type is contextually known. regress/contextual_enums.fg tests.
Spec (Axis 8.2) requires `.circle(5.0)` when type is known from context.

**Work:**
- Parser: parse `.variant(args)` in contexts where enum type is known
- Type checker: resolve dot-shorthand against expected type
- Pattern matching: `.variant` in match arms

**Spec ref:** Axis 8.2

### P1-9: Deep immutability enforcement
**Status: PARTIAL** — let/mut exists but deep enforcement unclear.
Spec (Axis 11.5) requires `let` to enforce full value-tree immutability.

**Work:**
- Type checker: reject field mutation through let bindings (`user.name = x` error)
- Type checker: reject nested field mutation
- Type checker: reject container mutation through let (`list.push(x)` error)
- Allow mutation only through `mut` bindings

**Spec ref:** Axis 11.5

### P1-10: `const` keyword for compile-time constants
**Status: PARTIAL** — KID_CONST exists, unclear if fully implemented.
Spec (Axis 11.2) requires `const X: T = expr` with compile-time evaluation.

**Work:**
- Parser: parse `const name: Type = expr`
- Eval: evaluate const expressions at compile time
- Codegen: inline const values at use sites
- Error: reject non-constant expressions in const declarations

**Spec ref:** Axis 11.2

---

## Phase 2: Error Handling Completion

> Goal: Complete the error handling system to match v1.0 spec.
> Critical for correctness and developer experience.

### P2-1: Union error types with automatic widening
**Status: NOT IMPLEMENTED**
Spec (Axis 12.3) requires `Result<T, IoError | ParseError>` with automatic widening at `?` sites.

**Work:**
- Type system: union error types in Result's E position
- Type checker: automatic widening when ? propagates different error types
- Pattern matching: match on specific error variants from a union
- This builds on P1-2 (union types)

**Spec ref:** Axis 12.3

### P2-2: `catch` blocks
**Status: IMPLEMENTED** — regress/catch_basic.fg and regress/catch_combo.fg test it. Parser handles `expr catch { body }`. Codegen extracts Ok or runs catch block.
Spec (Axis 12.5, 12.6) requires `let x = expr() catch { default }` and `catch (e) { ... }`.

**Work:**
- Add KID_CATCH to kind_ids.fg + runtime.c
- Add Expr::Catch variant to AST
- Parser: parse `expr catch { body }` and `expr catch (binding) { body }`
- Codegen: match on Result, extract Ok value or execute catch body
- Type checker: verify catch body type matches Ok type

**Spec ref:** Axis 12.5, 12.6

### P2-3: `errdefer` keyword
**Status: IMPLEMENTED** — parser, codegen, resolver all handle errdefer. Interleaved with defer in LIFO order. regress/errdefer.fg + regress/errdefer_implicit.fg test it. Verified: errdefer runs only on error path, defer always runs.
Spec (Axis 12.7) requires `errdefer { ... }` that only runs on error exit.

**Work:**
- Add KID_ERRDEFER to kind_ids.fg + runtime.c
- Add Stmt::Errdefer variant to AST
- Parser: parse `errdefer { body }`
- Codegen: track error/success path, only execute errdefer on error path
- Interleave with defer in LIFO order

**Spec ref:** Axis 12.7

### P2-4: Error trait
**Status: NOT IMPLEMENTED**
Spec (Axis 12.10) requires all error types implement an `Error` trait with: message(), kind(), cause(), context(), call_site(), trace(), severity(), is_transient(), suggestions(), format().

**Work:**
- Define Error trait in @std/core
- Implement mandatory members: message() -> string, kind() -> string
- Implement optional members with defaults
- Auto-populate call_site() at .err() construction
- Auto-accumulate trace() at ? propagation sites
- @derive Error macro (or manual impl for bootstrap)

**Spec ref:** Axis 12.10

### P2-5: Panic containment at task boundaries
**Status: LIKELY MISSING**
Spec (Axis 12.8) requires panics in spawned tasks to become TaskPanic errors to the parent.

**Work:**
- Runtime: catch panics at task boundaries
- Convert panic to TaskPanic error
- Parent task receives Result<T, TaskPanic>
- Main task panic = program abort

**Spec ref:** Axis 12.8

### P2-6: `?` on nullable types (Option propagation)
**Status: PARTIAL** — Try expr exists but may only work on Result.
Spec (Axis 10.5) requires `?` to propagate null from functions returning `T?`.

**Work:**
- Type checker: detect `?` on T? (not just Result)
- Codegen: check for null, early-return null if absent
- Verify enclosing function returns T?

**Spec ref:** Axis 10.5

### P2-7: Flow-sensitive type narrowing
**Status: IMPLEMENTED** — `is` keyword narrows types in if-branches. narrow_env_for_is in if_stmt/codegen.fg. regress/flow_narrow.fg + regress/is_keyword.fg test it.
Spec (Axis 10.4) requires `if user != null { user.name }` to work without unwrap.

**Work:**
- Type checker: narrow T? to T after null check in if-branch
- Support `if x != null`, `if x == null { return }`, pattern match narrowing
- Track narrowed types through control flow

**Spec ref:** Axis 10.4

---

## Phase 3: Memory Model

> Goal: Upgrade from bump allocator to proper RC + cycle detection + arenas.
> This is the spec's v1.0 memory model.

### P3-1: Reference counting runtime
**Status: IMPLEMENTED** — rc_retain/rc_release/rc_alloc in runtime.c. Codegen emits retain/release calls. codegen/cycles.fg has RC graph analysis. codegen/escape.fg has escape analysis for elision. 6 files implement RC.
Spec (Axis 9.1-9.4) requires non-atomic refcounting at app level.

**Work:**
- Runtime: implement rc_alloc/rc_retain/rc_release/rc_drop
- Object headers: external to object layout (ptr - HEADER_SIZE)
- Codegen: emit retain/release calls at appropriate points
- Callee-cleans ABI: callee takes ownership on entry
- Non-atomic counters (single-threaded v1.0)

**Spec ref:** Axis 9.1, 9.4, Architectural Commitments 1-5

### P3-2: Targeted cycle detection
**Status: NOT IMPLEMENTED**
Spec (Axis 9.5) requires cycle detection only on types whose field graphs can self-reference.

**Work:**
- Compiler: static analysis to identify cycle-capable types
- Runtime: mark-and-sweep for cycle-capable types only
- Drop-site-precise scheduling: sweep when refcount decrements but doesn't reach zero
- Zero cost for non-cycle-capable types

**Spec ref:** Axis 9.5, Cycle Detection section

### P3-3: Arena allocation for short-lived scopes
**Status: PARTIAL** — bump allocator exists but not scope-aware.
Spec (Axis 9.6) requires compiler-detected arena allocation for short-lived allocations.

**Work:**
- Compiler: detect scopes that allocate many short-lived objects
- Runtime: bump allocator per arena scope (already exists)
- Copy returned values out of arena
- Free arena in O(1) at scope end

**Spec ref:** Axis 9.6

### P3-4: Basic RC elision
**Status: NOT IMPLEMENTED**
Spec (Axis 9.7) requires basic elision optimizations for v1.0.

**Work:**
- Last-use move optimization (final use hands off refcount)
- Non-aliased locals skip RC entirely
- Retain+release pairs within same scope eliminated
- Second elision pass after inlining

**Spec ref:** Axis 9.7

### P3-5: Escape analysis (stack vs heap)
**Status: NOT IMPLEMENTED**
Spec (Axis 9.9) requires escape analysis to stack-allocate non-escaping values.

**Work:**
- Compiler pass: determine which values escape their scope
- Stack-allocate non-escaping composites (LLVM alloca)
- Heap-allocate escaping values (rc_alloc)
- Primitives always stack

**Spec ref:** Axis 9.9

### P3-6: Drop trait and LIFO drop ordering
**Status: PARTIAL** — defer exists but Drop trait likely missing.
Spec (Axis 9.10, 9.11) requires Drop trait + LIFO ordering with defer/errdefer interleaving.

**Work:**
- Define Drop trait: `fn drop(mut self)`
- Codegen: call drop in reverse declaration order at scope exit
- Interleave Drop, defer, and errdefer in LIFO order

**Spec ref:** Axis 9.10, 9.11

### P3-7: Copy trait auto-derivation
**Status: IMPLEMENTED** — copy_types registry in Ctx, codegen checks is_copy_type. 4 files implement copy semantics.
Spec (Axis 9.12) requires auto-Copy for types with only Copy fields.

**Work:**
- Type checker: determine if type is Copy (all fields Copy)
- Primitives always Copy
- Structs auto-Copy transitively
- Codegen: copy semantics for Copy types, move for non-Copy

**Spec ref:** Axis 9.12

### P3-8: Closure capture inference
**Status: PARTIAL** — closures exist but capture semantics unclear.
Spec (Axis 9.13) requires inferred capture mode (by-ref for read, by-mut-ref for mutation, by-value for escaping).

**Work:**
- Analyze each captured variable's usage in closure body
- Infer capture mode: read-only ref, mut ref, or move
- `move` keyword for explicit ownership transfer
- For spawned closures: force by-value capture

**Spec ref:** Axis 9.13

### P3-9: String representation with SSO
**Status: PARTIAL** — strings exist but likely heap-only.
Spec (Axis 9.15) requires Small String Optimization (≤23 bytes inline).

**Work:**
- String layout: 24 bytes (inline if ≤23 bytes, heap pointer+len+cap otherwise)
- Runtime: string operations handle both paths
- UTF-8 always
- `string.length` = byte count (O(1))

**Spec ref:** Axis 9.15

---

## Phase 4: Concurrency Model

> Goal: Proper green-thread runtime with structured concurrency.
> Currently has basic pthreads + channels in C runtime.

### P4-1: Green-thread scheduler
**Status: NOT IMPLEMENTED** — current threads are OS threads via pthread.
Spec (Axis 18.1) requires M:N green-thread scheduler.

**Work:**
- Runtime: implement green-thread scheduler (single OS thread for v1.0)
- Cooperative yielding at I/O operations
- ~8KB initial stack per green thread, growing on demand
- Preemption at function call boundaries (safepoint insertion)

**Spec ref:** Axis 18.1

### P4-2: Task<T, E> type
**Status: NOT IMPLEMENTED**
Spec (Axis 18.2) requires Task handles with .await, .cancel(), Task.all(), Task.race(), etc.

**Work:**
- Define Task<T, E> type
- .await — block until complete, returns Result<T, E>
- .result(timeout: Duration)
- .cancel() — request cancellation
- .is_done() — non-blocking check
- Task.all([tasks]) — combine
- Task.race([tasks]) — first to complete
- Task.any([tasks]) — first success

**Spec ref:** Axis 18.2

### P4-3: Structured concurrency
**Status: NOT IMPLEMENTED**
Spec (Axis 18.7) requires scoped task lifetime — tasks must complete before scope exits.

**Work:**
- `spawn { }` is structured by default (task bound to scope)
- `spawn detached { }` for unstructured (explicit opt-out)
- Scope exit waits for all spawned tasks
- Error in any task cancels siblings
- Cancellation delivery at I/O points and safepoints

**Spec ref:** Axis 18.7

### P4-4: Channel improvements
**Status: PARTIAL** — basic channel exists in C runtime.
Spec (Axis 18.4) requires bounded, unbounded, and synchronous channels.

**Work:**
- Channel.new<T>(capacity: N) — bounded
- Channel.new<T>() — unbounded (or default capacity)
- Synchronous (capacity = 0) — rendezvous
- Closed channels drain then return null
- Type-safe generics on channels

**Spec ref:** Axis 18.4

### P4-5: Streams (lazy pipelines)
**Status: NOT IMPLEMENTED**
Spec (Axis 18.6) requires lazy Stream type alongside channels.

**Work:**
- Stream<T> type: lazy sequence on one fiber
- Stream.range(), .map(), .filter(), .take(), .skip()
- for-in loop over streams
- Conversions: Channel → Stream, Stream → Channel

**Spec ref:** Axis 18.6

### P4-6: Pipe operator `|>`
**Status: PARTIAL** — KID_PIPE exists, unclear if |> is implemented.
Spec (Axis 28.7) requires `x |> f` desugaring to `f(x)`.

**Work:**
- Parser: parse `|>` as binary operator
- Desugar: `x |> f` → `f(x)`, `x |> f(y)` → `f(x, y)`
- Explicit placement: `x |> f(_, y)` → `f(x, y)`
- Piping into lambdas: `x |> (v) -> v * 2`

**Spec ref:** Axis 28.7

---

## Phase 5: Syntax & Language Surface

> Goal: Complete all v1.0 syntax requirements from the spec.

### P5-1: `it` pronoun for single-parameter closures
**Status: IMPLEMENTED** — closures/parser.fg handles `it` as implicit parameter in method-call contexts.
Spec (Axis 28.8) requires `list.filter(it > 5)` shorthand.

**Work:**
- Parser: detect `it` in closure context as implicit parameter
- Desugar: `list.filter(it > 5)` → `list.filter((it) -> it > 5)`
- Scope: `it` binds to innermost single-parameter closure
- Error: `it` outside closure context

**Spec ref:** Axis 28.8

### P5-2: String interpolation with format specs
**Status: PARTIAL** — basic interpolation exists, format specs unclear.
Spec (Axis 28.3) requires `{expr:format_spec}` like `{price:.2}`.

**Work:**
- Parser: parse format spec after `:` in interpolation
- Codegen: call format function with spec
- Support: `{x:.2}` (decimal places), `{x:>10}` (alignment), etc.

**Spec ref:** Axis 28.3

### P5-3: Multiline strings `"""..."""`
**Status: UNKNOWN**
Spec (Axis 28.3) requires triple-quoted multiline strings with indent stripping.

**Work:**
- Lexer: recognize `"""` as multiline string delimiter
- Strip leading indentation of closing `"""`
- Support interpolation in multiline strings

**Spec ref:** Axis 28.3

### P5-4: Raw strings `r"..."`
**Status: UNKNOWN**
Spec (Axis 28.3) requires raw strings with no escape processing.

**Work:**
- Lexer: recognize `r"..."` and `r"""..."""`
- No escape processing
- No interpolation in raw strings

**Spec ref:** Axis 28.3

### P5-5: Closure syntax `(params) -> body`
**Status: IMPLEMENTED** — Lambda exists in AST.
Spec cross-cutting commitment: closures use `(params) -> body`, not `|params|`.

**Work:**
- Verify current syntax matches spec
- Single-param parens optional: `x -> x * 2`
- Zero-param: `() -> expr`
- Multi-param: `(x, y) -> expr`

**Spec ref:** Cross-Cutting Syntax Commitments

### P5-6: `@pure` annotation
**Status: NOT IMPLEMENTED**
Spec (Axis 13.3) requires `@pure fn` with compiler verification.

**Work:**
- Parser: parse `@pure` annotation on functions
- Type checker: verify no I/O, no mutation of external state, no non-pure calls
- Transitive: @pure can only call @pure

**Spec ref:** Axis 13.3

### P5-7: Character literals `'a'`
**Status: UNKNOWN**
Spec (Axis 28.3) requires `'a'` for single Unicode character (type `char`).

**Work:**
- Lexer: recognize `'c'` as character literal
- Type: char (4-byte Unicode codepoint)
- Distinct from single-element strings

**Spec ref:** Axis 28.3

### P5-8: Block comments `/* ... */` with nesting
**Status: UNKNOWN**
Spec (Axis 28.4) requires nestable block comments.

**Work:**
- Lexer: recognize `/* ... */` with nesting support
- `/* outer /* inner */ outer */` works

**Spec ref:** Axis 28.4

### P5-9: Doc comments `///` and `//!`
**Status: UNKNOWN**
Spec (Axis 28.4) requires `///` for item docs and `//!` for module docs.

**Work:**
- Lexer: recognize `///` and `//!` as doc comment tokens
- Attach to next/enclosing declaration
- Store in AST for doc generation

**Spec ref:** Axis 28.4

### P5-10: Reserved keywords for future
**Status: PARTIAL** — some exist, many likely missing.
Spec (Axis 9, Architectural Commitment 10) requires reserving: systems, bare, hardware, owned, borrow, move, level, unsafe, extern, async, spawn, await, channel, select, shape, const, where, catch, errdefer, pure, dyn.

**Work:**
- Add all reserved keywords to kind_ids.fg
- Scanner recognizes them
- Using them (where not yet implemented) produces "reserved for future use" error

**Spec ref:** Axis 9 Architectural Commitments

### P5-11: Naming convention enforcement
**Status: IMPLEMENTED** — typeck/mod.fg has check_naming_conventions, is_snake_case, is_pascal_case, is_screaming_snake. Emits warnings via naming_warn.
Spec (Axis 28.5) requires compiler warnings for non-canonical names.

**Work:**
- PascalCase for types/traits/enums
- snake_case for functions/variables/fields
- SCREAMING_SNAKE for constants
- Emit F9010 warning on violations

**Spec ref:** Axis 28.5

---

## Phase 6: Module & Package System

> Goal: Complete module system for v1.0.

### P6-1: Package manifest (forge.toml)
**Status: PARTIAL** — some support likely exists.
Spec (Axis 16.4, 16.8) requires forge.toml with dependencies, @namespace packages.

**Work:**
- Parse forge.toml: [package] name/version, [dependencies]
- @std/* namespace for stdlib
- @local/* for development
- Version resolution

**Spec ref:** Axis 16.4, 16.8

### P6-2: Orphan rule enforcement
**Status: NOT IMPLEMENTED**
Spec (Axis 16.5) requires you own either the trait or the type for impl.

**Work:**
- Type checker: verify impl blocks satisfy orphan rule
- Error message with newtype workaround suggestion

**Spec ref:** Axis 16.5

### P6-3: Re-exports (`export use`)
**Status: UNKNOWN**
Spec (Axis 16.7) requires `export use path.{item}` for re-exporting.

**Work:**
- Parser: parse `export use` statements
- Resolver: make re-exported items visible from the re-exporting module
- Re-export chains work transitively

**Spec ref:** Axis 16.7

### P6-4: Circular import handling
**Status: UNKNOWN**
Spec (Axis 16.6) requires intra-package circular imports allowed, cross-package forbidden.

**Work:**
- Resolver: two-pass resolution (collect declarations, then resolve bodies)
- Detect and error on cross-package cycles
- Clear error message listing the cycle

**Spec ref:** Axis 16.6

### P6-5: Unused import warnings
**Status: UNKNOWN**

**Work:**
- Track which imported symbols are used
- Emit warning (not error) for unused imports

**Spec ref:** Axis 16.3

---

## Phase 7: Diagnostics & Error Reporting

> Goal: World-class error messages per spec.

### P7-1: F-code error system completion
**Status: PARTIAL** — F-codes exist (F0001, F0012, etc.) but coverage incomplete.
Spec (Axis 20.1) requires comprehensive F-code registry.

**Work:**
- Assign F-codes to all compiler errors per range allocation
- F0001-F0999: lexer/parser
- F1000-F1999: type checker
- F3000-F3999: resolution
- F9000-F9998: warnings
- F9999: ICE
- Every error has both code and descriptive message

**Spec ref:** Axis 20.1

### P7-2: JSON diagnostic output
**Status: LIKELY MISSING**
Spec (Axis 20.2) requires `--format=json` for machine-readable diagnostics.

**Work:**
- Serialize all diagnostics to JSON schema
- Include: code, severity, message, primary/secondary spans, suggestions, causality
- Schema version field for stability

**Spec ref:** Axis 20.2

### P7-3: Suggestion confidence levels
**Status: NOT IMPLEMENTED**
Spec (Axis 20.3) requires high/medium/low confidence grading on suggestions.

**Work:**
- Tag each suggestion with confidence level
- High: provably correct (typo fix, missing import)
- Medium: likely correct (similar name alternatives)
- Low: hints (restructuring suggestions)

**Spec ref:** Axis 20.3

### P7-4: Autofix (`avra fix`)
**Status: NOT IMPLEMENTED**
Spec (Axis 20.4) requires CLI autofix for high-confidence suggestions.

**Work:**
- CLI: `avra fix` applies high-confidence fixes
- `avra fix --include=medium` with prompts
- `avra fix --dry-run`
- Transactional: all-or-nothing application

**Spec ref:** Axis 20.4

### P7-5: Causality chains ("because")
**Status: NOT IMPLEMENTED**
Spec (Axis 20.5) requires multi-level "because" tracing in error messages.

**Work:**
- Track type inference derivation chain
- Display 3 levels of causality by default
- `--causality-depth=N` flag
- Include in JSON output

**Spec ref:** Axis 20.5

### P7-6: ICE handling (F9999)
**Status: PARTIAL** — F9999 exists but handler may be incomplete.
Spec (Axis 20.6) requires all internal compiler errors wrapped in F9999 with bug report instructions.

**Work:**
- Catch all panics/crashes
- Wrap in F9999 diagnostic
- Include: compiler version, source hash, captured context
- Bug report URL

**Spec ref:** Axis 20.6

---

## Phase 8: Tooling

> Goal: Developer tooling for v1.0.

### P8-1: Formatter
**Status: NOT IMPLEMENTED** (no `avra fmt` command found)
Spec (Axis 27.1) requires canonical formatter.

**Work:**
- AST printer with canonical style
- Enforce indentation, brace placement, naming conventions
- `avra fmt` CLI command
- `avra fmt --check` for CI

**Spec ref:** Axis 27.1

### P8-2: LSP server
**Status: NOT IMPLEMENTED**
Spec (Axis 27.2) requires language server for IDE integration.

**Work:**
- Implement LSP protocol
- Diagnostics, hover, go-to-definition, completions
- Uses same diagnostic engine as CLI

**Spec ref:** Axis 27.2

### P8-3: Test runner
**Status: PARTIAL** — spec_test blocks exist, `forge test` exists.
Spec (Axis 24.1) requires test infrastructure.

**Work:**
- `avra test` runs all spec blocks
- `avra test [feature]` scoped testing
- Test discovery from spec/given/then blocks
- Assertion helpers in @std/test

**Spec ref:** Axis 24.1

---

## Phase 9: Standard Library (@std)

> Goal: Minimal standard library for v1.0.
> These are library-level, not compiler-level changes.

### P9-1: @std/core — fundamental types
**Work:**
- Option<T> (T? desugars to this)
- Result<T, E>
- Error trait
- Display trait
- Eq, Ord, Hash, Clone traits
- Cell<T>, Lazy<T>, OnceCell<T>
- Basic numeric traits (Add, Sub, Mul, Div)

### P9-2: @std/collections
**Work:**
- List<T> (already exists)
- Map<K, V> (already exists)
- Set<T>
- Basic operations: push, pop, get, set, contains, remove, len, is_empty
- Iteration: map, filter, reduce, find, any, all, count

### P9-3: @std/string
**Work:**
- String operations (many exist in runtime.c)
- trim, split, join, replace, contains, starts_with, ends_with
- chars() iterator, graphemes() iterator
- to_upper, to_lower
- parse<T>() for numeric conversion

### P9-4: @std/io
**Work:**
- println (already exists)
- eprintln
- File operations (read, write, open, close)
- stdin/stdout/stderr

### P9-5: @std/json
**Work:**
- JSON parse/stringify
- Integration with type system (Serializable trait)

### P9-6: @std/time
**Work:**
- Time.now(), Duration, Timestamp
- Timer.after(duration)
- Basic date/time operations

### P9-7: @std/test
**Work:**
- assert, assert_eq, assert_ne
- TestClock, TestRandom for deterministic testing
- Test runner integration

### P9-8: @std/stream
**Work:**
- Stream<T> type
- Lazy operators: map, filter, take, skip, zip
- Conversion to/from collections and channels

### P9-9: @std/channel
**Work:**
- Channel<T> type (wraps C runtime channels)
- Bounded, unbounded, synchronous modes
- send, receive, close

---

## Phasing Strategy

### Iteration 1: Type System Foundation (Phases 1 + 2)
**Priority: HIGHEST**
Without the complete type system, nothing else works correctly.

Order:
1. P1-1: shape keyword
2. P1-2: Union types
3. P1-4: Newtype wrappers
4. P1-7: Exhaustive match enforcement
5. P1-8: Enum variant dot-shorthand
6. P1-9: Deep immutability
7. P1-10: const keyword
8. P2-1: Union error types
9. P2-2: catch blocks
10. P2-3: errdefer
11. P2-6: ? on nullable
12. P2-7: Flow-sensitive narrowing

### Iteration 2: Memory Model (Phase 3)
**Priority: HIGH**
The bump allocator works for bootstrapping but isn't suitable for real programs.

Order:
1. P3-1: Reference counting runtime
2. P3-6: Drop trait + LIFO ordering
3. P3-7: Copy trait auto-derivation
4. P3-3: Arena allocation
5. P3-2: Targeted cycle detection
6. P3-4: Basic RC elision
7. P3-5: Escape analysis
8. P3-8: Closure capture inference
9. P3-9: String SSO

### Iteration 3: Concurrency (Phase 4)
**Priority: HIGH**
Current pthread-based concurrency needs to become green-thread based.

Order:
1. P4-1: Green-thread scheduler
2. P4-2: Task<T, E> type
3. P4-3: Structured concurrency
4. P4-4: Channel improvements
5. P4-5: Streams
6. P4-6: Pipe operator

### Iteration 4: Language Surface (Phase 5)
**Priority: MEDIUM**
Syntax completions and annotations.

Order:
1. P5-1: it pronoun
2. P5-2: String format specs
3. P5-3: Multiline strings
4. P5-4: Raw strings
5. P5-6: @pure annotation
6. P5-7: Character literals
7. P5-8: Block comments
8. P5-9: Doc comments
9. P5-10: Reserved keywords
10. P5-11: Naming conventions

### Iteration 5: Modules & Diagnostics (Phases 6 + 7)
**Priority: MEDIUM**

Order:
1. P6-1: Package manifest
2. P6-2: Orphan rules
3. P6-3: Re-exports
4. P7-1: F-code completion
5. P7-2: JSON diagnostics
6. P7-5: Causality chains

### Iteration 6: Tooling (Phase 8)
**Priority: MEDIUM-LOW**

Order:
1. P8-1: Formatter
2. P8-3: Test runner improvements
3. P8-2: LSP server
4. P7-4: Autofix

### Iteration 7: Standard Library (Phase 9)
**Priority: LOW (for v1.0-alpha)**
Can be built incrementally as language features stabilize.

Order:
1. P9-1: @std/core
2. P9-2: @std/collections
3. P9-3: @std/string
4. P9-4: @std/io
5. P9-7: @std/test
6. P9-6: @std/time
7. P9-8: @std/stream
8. P9-9: @std/channel
9. P9-5: @std/json

---

## Ticket Summary

Total tickets: **74**

| Phase | Count | Priority |
|-------|-------|----------|
| P0: Rename | 3 | LOW |
| P1: Type System | 10 | HIGHEST |
| P2: Error Handling | 7 | HIGHEST |
| P3: Memory Model | 9 | HIGH |
| P4: Concurrency | 6 | HIGH |
| P5: Syntax | 11 | MEDIUM |
| P6: Modules | 5 | MEDIUM |
| P7: Diagnostics | 6 | MEDIUM |
| P8: Tooling | 3 | MEDIUM-LOW |
| P9: Stdlib | 9 | LOW |

### Not In Scope (explicitly post-v1.0)
- Systems/bare/hardware abstraction levels
- Borrow checker / lifetimes
- Const generics (`<T, const N: int>`)
- GATs (generic associated types)
- Refinement types (`type Age = int where it >= 0`)
- Contract annotations (`@requires`, `@ensures`)
- Full FFI (C ABI, trampolines, opaque types)
- Deploy blocks
- Provider system (keyword registration, @derive)
- CPU-parallel spawn (`spawn cpu`)
- Atomic RC
- WASM sandbox
- Type operators (without/with/only/optional)
- Model/service/view keywords
- UI framework
- Non-determinism tracking
- SMT discharge
- Totality checking
- Agent/LLM integration APIs

---

## Appendix: Spec Axis → Ticket Mapping

| Axis | Decision | v1.0? | Ticket |
|------|----------|-------|--------|
| 1.1 | Fully static typing | ✓ | Existing |
| 1.2 | Types erased, compiler introspectable | ✓ | Existing |
| 1.3 | Unified lifted code (@lifted) | Post-v1 | — |
| 2.1 | Mostly sound with escape hatches | ✓ | Existing |
| 2.2 | No `as`, no `unsafe` blocks | ✓ | Existing |
| 2.3 | No runtime type errors in app code | ✓ | Existing |
| 3.1 | Both nominal + structural | ✓ | P1-1 |
| 3.2 | type + shape keywords | ✓ | P1-1 |
| 3.3 | Both shape and type available | ✓ | P1-1 |
| 3.4 | Nominal traits | ✓ | Existing |
| 3.5 | Width subtyping on shapes | ✓ | P1-1 |
| 3.6 | Depth subtyping on immutable | ✓ | P1-1 |
| 3.7 | Shapes are public-fields-only | ✓ | P1-1 |
| 3.8 | Newtype wrappers | ✓ | P1-4 |
| 4.1 | Local + bidirectional inference | ✓ | Existing (improve) |
| 4.2 | Required function signatures | ✓ | Existing |
| 4.3 | Closure param inference | ✓ | Existing |
| 4.4 | Empty collection error | ✓ | Improve existing |
| 4.5 | Method inference with bounds | ✓ | P1-5 |
| 5.1 | Generics + traits + shapes | ✓ | Existing + P1-1 |
| 5.2 | Mono default, dyn escape | ✓ | P1-6 |
| 5.3 | Both trait and shape bounds | ✓ | P1-1, P1-5 |
| 5.4 | where clauses | ✓ | P1-5 |
| 5.5 | Const generics | Post-v1 | — |
| 6.1 | Inferred variance | ✓ | Implicit |
| 6.2 | Covariant immutable, invariant mutable | ✓ | Implicit |
| 6.3 | Standard function variance | ✓ | Implicit |
| 7.1 | Associated types only | ✓ | P1-3 |
| 7.2 | On any trait | ✓ | P1-3 |
| 8.1 | Enums + unions | ✓ | Existing + P1-2 |
| 8.2 | Contextual dot-shorthand | ✓ | P1-8 |
| 8.3 | Named + positional variants | ✓ | Existing |
| 8.4 | Union exhaustiveness | ✓ | P1-2, P1-7 |
| 8.5 | Structural union discrimination | ✓ | P1-2 |
| 8.6 | No inline enums | ✓ | Existing |
| 8.7 | Wildcard lint > 2 variants | ✓ | P1-7 |
| 8.8 | Non-exhaustive for providers | Post-v1 | — |
| 8.9 | Auto-box recursive enums (app) | ✓ | Existing |
| 8.10 | Enum methods via impl | ✓ | Existing |
| 9.1-9.3 | Scoped memory (app only v1) | ✓ | P3-1 |
| 9.4 | Non-atomic RC | ✓ | P3-1 |
| 9.5 | Targeted cycle detection | ✓ | P3-2 |
| 9.6 | Arena allocation | ✓ | P3-3 |
| 9.7 | Basic RC elision | ✓ | P3-4 |
| 9.8 | Borrow checker | Post-v1 | — |
| 9.9 | Escape analysis | ✓ | P3-5 |
| 9.10 | Drop ordering LIFO | ✓ | P3-6 |
| 9.11 | defer + Drop interleaved | ✓ | P3-6 |
| 9.12 | Copy auto-derivation | ✓ | P3-7 |
| 9.13 | Closure capture inference | ✓ | P3-8 |
| 9.14 | Closures crossing levels | Post-v1 | — |
| 9.15 | String SSO | ✓ | P3-9 |
| 9.16 | with structural sharing | ✓ | Existing |
| 10.1 | T? = Option<T> | ✓ | Existing |
| 10.2 | Non-null by default | ✓ | Existing |
| 10.3 | ?., ??, ! operators | ✓ | Existing (verify) |
| 10.4 | Flow-sensitive narrowing | ✓ | P2-7 |
| 10.5 | ? on nullable | ✓ | P2-6 |
| 11.1 | Immutable by default | ✓ | Existing |
| 11.2 | const keyword | ✓ | P1-10 |
| 11.3 | Interior mutability (Cell) | ✓ | P9-1 |
| 11.4 | Shared aliasing (v1.0 single-threaded) | ✓ | Existing |
| 11.5 | Deep immutability | ✓ | P1-9 |
| 12.1 | Result<T, E> | ✓ | Existing |
| 12.2 | ? operator | ✓ | Existing |
| 12.3 | Union error types | ✓ | P2-1 |
| 12.4 | Nominal errors + Error trait | ✓ | P2-4 |
| 12.5 | catch blocks | ✓ | P2-2 |
| 12.6 | catch binding syntax | ✓ | P2-2 |
| 12.7 | defer + errdefer | ✓ | P2-3 |
| 12.8 | Panic at task boundary | ✓ | P2-5 |
| 12.9 | ? in closures returns from closure | ✓ | Verify existing |
| 12.10 | Error trait (rich) | ✓ | P2-4 |
| 12.11 | retry/fallback/timeout in stdlib | ✓ | P9-1 |
| 12.12 | FFI error mapping | Post-v1 | — |
| 13.1 | No general effect system | ✓ | Existing |
| 13.2 | Provider capabilities | Post-v1 | — |
| 13.3 | @pure opt-in | ✓ | P5-6 |
| 13.4 | No async coloring | ✓ | P4-1 |
| 13.5 | Non-determinism not tracked | ✓ | Existing |
| 13.6 | Deploy permissions | Post-v1 | — |
| 14.x | Refinement/contracts/dependent | Post-v1 | — |
| 15.x | FFI | Post-v1 | — |
| 16.1 | File = module | ✓ | Existing |
| 16.2 | export keyword | ✓ | Existing |
| 16.3 | use imports | ✓ | Existing |
| 16.4 | @namespace packages | ✓ | P6-1 |
| 16.5 | Orphan rules | ✓ | P6-2 |
| 16.6 | Circular imports | ✓ | P6-4 |
| 16.7 | Re-exports | ✓ | P6-3 |
| 16.8 | Package registry | ✓ | P6-1 |
| 16.9 | Version enforcement | Post-v1 | — |
| 17.x | Provider system | Post-v1 | — |
| 18.1 | Green threads | ✓ | P4-1 |
| 18.2 | spawn + Task<T, E> | ✓ | P4-2 |
| 18.3 | parallel + spawn cpu | Post-v1 | — |
| 18.4 | Channels | ✓ | P4-4 |
| 18.5 | Select | ✓ | Existing |
| 18.6 | Streams | ✓ | P4-5 |
| 18.7 | Structured concurrency | ✓ | P4-3 |
| 19.x | Deploy/infrastructure | Post-v1 | — |
| 20.1 | F-codes | ✓ | P7-1 |
| 20.2 | JSON diagnostics | ✓ | P7-2 |
| 20.3 | Suggestion confidence | ✓ | P7-3 |
| 20.4 | Autofix | ✓ | P7-4 |
| 20.5 | Causality chains | ✓ | P7-5 |
| 20.6 | ICE handling | ✓ | P7-6 |
| 21.x | LLM/Agent integration | Post-v1 | — |
| 22.x | Models/Services | Post-v1 | — |
| 23.x | UI/Mobile | Post-v1 | — |
| 24.1 | Testing | ✓ | P8-3 |
| 25.x | Bootstrap strategy | ✓ | Existing |
| 26.x | Compiler architecture | ✓ | Existing |
| 27.1 | Formatter | ✓ | P8-1 |
| 27.2 | LSP | ✓ | P8-2 |
| 28.1 | No semicolons | ✓ | Existing |
| 28.2 | Braces | ✓ | Existing |
| 28.3 | Strings (all forms) | ✓ | P5-2, P5-3, P5-4, P5-7 |
| 28.4 | Comments (all forms) | ✓ | P5-8, P5-9 |
| 28.5 | Naming conventions | ✓ | P5-11 |
| 28.6 | .av extension | ✓ | P0-1 |
| 28.7 | Pipe operator | ✓ | P4-6 |
| 28.8 | it pronoun | ✓ | P5-1 |
| 29.x | Events/Reactivity | Post-v1 | — |
| 30.x | Annotations/Metadata | Post-v1 | — |
| 31.x | Numerical types | ✓ | Verify existing |
