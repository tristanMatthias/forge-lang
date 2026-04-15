# Compiler TODO

Consolidated from ASSESSMENT.md, FEATURE_PARITY.md, FEATURE_TYPE_SYSTEM.md,
PLAN.md, PLUGGABLE_FEATURES.md, POST_MORTEM.md, TECH_DEBT.md on April 12, 2026.

---

## Critical — Compiler Maturity

These are the issues that prevent this from being a proper, production-quality
compiler. They must be addressed before any new language features. A language
engineer reviewing this codebase would flag every one of these.

### ~~1. Everything-is-i64 value model~~ DONE
**status:** done (MONOMORPHIZATION_PLAN.md)

Function signatures use real LLVM types (ptr, i64, i1, double). Typed
allocas, loads, stores. Bool is i1, float is double. `forge_llvm_cast_to_type`
handles all conversions. See MONOMORPHIZATION_PLAN.md for full status.

**Remaining debt:** ptrtoint/inttoptr still used for enum payloads and
tuple access (flat i64 buffers). Per-variant GEP would eliminate these
but is blocked by an LLVM 20 -O2 miscompilation bug on ARM64.

### ~~2. Types are strings in the AST~~ DONE
**status:** done (MONOMORPHIZATION_PLAN.md #9)

ParamList.Node and FieldList.Node carry `resolved: ValueType` alongside
the original `ty: string`. All codegen reads `resolved` instead of
re-parsing type strings. Declaration passes populate `resolved` via
`resolve_field_list`/`resolve_param_list`. Feature codegen uses
`ctx.resolve_params()`/`ctx.resolve_fields()` at function/lambda entry.

**Remaining debt:** `ty: string` field retained for backward compat
(Stmt.Let/Mut/Function still carry string annotations, resolver and
typechecker use strings). `translate_param_type` still exists for the
declaration passes and let_stmt/trait_decl. Full removal requires
changing Stmt variants to carry ValueType — a future cleanup.

### 3. Type checker is advisory only
**type:** architecture
**priority:** critical
**status:** not started

The type checker emits warnings but never rejects a program. Ill-typed
code compiles and runs (or crashes at runtime). This means:
- Type errors are silent — users discover them as segfaults
- The type checker can't be trusted, so codegen does its own type dispatch
- There's no foundation for type-directed codegen (the codegen can't assume
  types are correct because they were never enforced)

**Fix:** Make type errors block compilation. Start with the highest-value
checks: return type mismatches, argument type mismatches, undefined
variable access. Graduate from warnings to errors incrementally — each
check that's promoted must not break existing valid code.

### 4. No intermediate representation
**type:** architecture
**priority:** critical
**status:** not started

The compiler goes directly from AST to LLVM IR. Every real compiler has
at least one IR between parsing and codegen:
- Rust: AST → HIR → MIR → LLVM IR
- Go: AST → SSA → machine code
- Swift: AST → SIL → LLVM IR
- C: AST → IR → machine code (in most implementations)

Why it matters:
- Optimizations that are easy on an IR are hard on an AST (constant folding,
  dead code elimination, inlining decisions)
- The AST is designed for parsing fidelity, not for analysis
- Monomorphization, closure capture analysis, and borrow checking all
  need a lowered representation where control flow is explicit
- The codegen is doing too many jobs: type resolution, name mangling,
  closure conversion, AND LLVM emission

**Fix:** Introduce a typed IR between type checking and codegen. The IR
has explicit types on every value, explicit control flow (no implicit
fallthrough), and no syntactic sugar. The codegen becomes a simple
translation from IR to LLVM. This is the biggest single change and
should be done AFTER items 1-3.

### ~~5. Generic type params are discarded~~ DONE
**type:** architecture
**priority:** critical
**status:** done (April 14, 2026)

TypeParamList added to Function, TypeDecl, EnumDecl variants. Parser keeps
type params via `parse_type_params()` in `features/generics/parser.fg`.
Resolver scopes type param names. Type checker infers type args at call sites.
Monomorphization pass in `features/generics/mono.fg` generates concrete
specializations with mangled names (e.g., `identity__int`) and rewrites call
sites. 246 tests pass including 4 generics-specific tests.

**Remaining:** type inference is basic (infers from ParamList.resolved which
defaults to ValueType.Int). Real type-aware inference requires the type
checker to propagate argument types through generic call sites. Dogfooding
(replacing 30+ linked-list types with generic List<T>) is a separate step.

### 6. No ownership or lifetime model
**type:** architecture
**priority:** critical
**status:** not started

All heap allocations use a monotonic bump allocator (512MB arena, never
frees). There is no concept of ownership, borrowing, or lifetimes.
Every struct/enum allocation leaks.

For a compiler binary this is acceptable (one-shot process, OS reclaims).
For user programs compiled by this compiler, it's not — programs that
run for more than a few seconds will exhaust memory.

**Fix (long-term roadmap):**
1. Reference counting (simplest, covers 90% of cases)
2. Ownership tracking (move semantics, prevents double-free)
3. Lifetime analysis (borrow checker, prevents use-after-free)
4. Eventually: optional manual allocation for performance-critical code

### 7. No const evaluation
**type:** architecture
**priority:** high
**status:** not started

Expressions like `1 + 2`, `"hello" + " world"`, `true && false` are
emitted as runtime LLVM instructions instead of being folded to constants
at compile time. This produces unnecessarily verbose IR and prevents
compile-time assertions, const generics, and array size expressions.

**Fix:** Add a const-eval pass that evaluates pure expressions at compile
time. Start with literals and arithmetic, extend to const functions later.

### 8. No proper error recovery in parser
**type:** architecture
**priority:** high
**status:** not started

The parser stops at the first error (returns null, sets `had_error`).
A real compiler reports multiple errors per compilation, recovering at
statement boundaries to continue parsing after an error.

**Fix:** Implement synchronization — when an error is hit, skip tokens
until a statement boundary (`;`, `}`, `fn`, `let`, etc.) and resume
parsing. Collect all errors into the DiagnosticBag and report them all.

### 9. Codegen duplicates type dispatch logic
**type:** architecture
**priority:** high
**status:** not started

The codegen has 27 `vtype_is_*` calls that re-derive type information
the type checker already computed. Operations like `+` check at codegen
time whether operands are strings, floats, or ints — but this should be
resolved by the type checker. The codegen should receive typed AST nodes
and emit the correct operation without re-checking.

This is a symptom of #3 (advisory type checker) and #4 (no IR). When
types are enforced and an IR exists, codegen becomes a straightforward
translation.

### 10. Implicit returns are not type-checked
**type:** bug
**priority:** critical
**status:** not started

Functions with a declared return type only have explicit `return` statements
checked. The implicit return (last expression in a block) is not verified:
```forge
fn foo() -> string {
    42  // returns int, declared string — no error
}
```
This caused a real bug: `peek_char` returned `Tk.Identifier` (enum) instead
of `""` (string) for months, causing 44M allocations and arena exhaustion.

**Fix:** Check the type of the last expression in every function body
against the declared return type. This is part of #3 but important enough
to call out separately.

---

## Features

### Refinement types
**type:** feature
**priority:** low
**source:** FEATURE_TYPE_SYSTEM.md Phase 2

`where` clauses on type declarations constrain values beyond base type.
The compiler proves predicates at compile time and inserts runtime assertions when it can't.

```forge
type Positive = int where it > 0
type ValidPort = int where it >= 1 && it <= 65535
```

Requires Phase 1 type checker (done). Scope: `where` syntax, `Refinement` ValueType variant,
literal proving, guard-based narrowing, arithmetic propagation, `as RefinementType` runtime assertions.

### Non-exhaustive match compiler error
**type:** feature
**priority:** high
**source:** POST_MORTEM.md

If a match doesn't cover all variants and has no `_ ->` catch-all, emit a compile error:
```
error: non-exhaustive match on `ParamList` — missing variant `.Node`
```
The enum registry already tracks all variants — compare matched tags against the full variant list.
Additionally: the match fallthrough should call `forge_match_unreachable(fn, tag)` instead of
silently returning 0, as a runtime safety net.

### Enum variant tag references
**type:** feature
**priority:** low
**source:** TECH_DEBT.md #29

`Expr.IsCheck` without args should evaluate to the tag number (int).
Currently features register with `register_expr(reg, Expr.IsCheck(Expr.Null, ""), handler)` —
constructing a throwaway value just to extract the tag byte. Parser + codegen change: when an
enum variant with fields is referenced without calling it, emit its tag as a constant.

### Result type + `?` for error propagation
**type:** feature
**priority:** high
**source:** dogfooding audit (April 13, 2026)

The `?` operator currently only works on nullable values (`T?`) — it checks `== null`
and returns null from the enclosing function. This leaves 107 instances of
`if r.had_error { return r }` boilerplate across the codegen because `EmitResult`
and `StmtResult` use `had_error: bool`, not nullability.

**The fix:** Add a `Result<T, E>` enum and extend `?` to work with it:

```forge
enum Result<T, E> { Ok(value: T), Err(error: E) }

fn emit_expr(ctx: Ctx, env: VarEnv, expr: Expr) -> Result<EmitValue, string> {
    let l = emit_expr(ctx, env, left)?   // returns Err early if error
    let r = emit_expr(ctx, env, right)?
    Ok(combine(l, r))
}
```

This eliminates the `had_error` pattern entirely. Every function that currently returns
`{ ..., had_error: bool, error_message: string }` returns `Result<T, string>` instead.

**Impact:** Would eliminate ~107 error-check lines across codegen, making the compiler
source dramatically cleaner. This is the single biggest source of visual noise.

**Scope:**
1. Add `Result` enum (or extend `?` to check a `had_error` field on any struct)
2. Extend `?` codegen to handle Result: check tag, extract Ok value or return Err
3. Refactor codegen return types from `EmitResult`/`StmtResult` to `Result<...>`
4. Dogfood across all 107 sites

### Catch expressions
**type:** feature
**priority:** medium
**source:** Rust compiler parity (features/error_propagation — 24 examples)

Dedicated `catch { body }` block that captures errors from `?` propagation within the block,
returning a Result. Currently the bootstrap only supports `??` with block expressions as a
workaround. The Rust compiler has full catch expression support with Ok/Err result wrapping.

```forge
let result = catch {
    let data = read_file(path)?
    let parsed = parse(data)?
    parsed.value
}
// result is Result type: Ok(value) or Err(error)
```

### Smart null narrowing
**type:** feature
**priority:** medium
**source:** Rust compiler parity (codegen smart_null_narrowing)

After `if x != null { ... }`, the type of `x` should narrow from `T?` to `T` inside the
branch. The Rust compiler detects `x != null` patterns in conditionals and rebinds variables
with the narrowed type. The bootstrap type checker currently does not narrow — `x` remains
`T?` even after a null check.

```forge
fn process(x: int?) {
    if x != null {
        println(x + 1)  // x should be int here, not int?
    }
}
```

### Break with value
**type:** feature
**priority:** low
**source:** Rust compiler parity (features/while_loops — 16 examples)

`break expr` returns a value from a loop. Currently the bootstrap's `Break` AST node has no
value payload — `break` is statement-only. The Rust compiler supports `break value` which
makes loops usable as expressions.

```forge
let found = while i < list.length {
    if list[i] == target { break i }
    i = i + 1
}
```

### Loop statement (infinite loop)
**type:** feature
**priority:** low
**source:** Rust compiler parity

`loop { body }` as infinite loop syntax. Currently the bootstrap only has `while true { }`.
A dedicated `loop` keyword is cleaner and pairs naturally with `break value`.

```forge
let line = loop {
    let input = read_line()
    if input != "" { break input }
}
```

### Union types
**type:** feature
**priority:** low
**source:** Rust compiler parity (parser type_expr handling)

`T | U` type syntax for values that can be one of several types. The Rust compiler's parser
handles union type expressions. The bootstrap has no union type syntax — only enum variants
provide sum types.

```forge
fn handle(input: string | int) -> string {
    match input {
        s: string -> s
        n: int -> string(n)
    }
}
```

### Associated types in traits
**type:** feature
**priority:** low
**source:** Rust compiler parity (features/traits — 27 examples)

Traits with associated type declarations. The bootstrap supports trait methods but not
associated types. The Rust compiler handles `type Item` declarations inside trait blocks.

```forge
trait Iterator {
    type Item
    fn next(self) -> Item?
}
impl Iterator for Range {
    type Item = int
    fn next(self) -> int? { ... }
}
```

### Auto-stringify for extern functions
**type:** feature
**priority:** low
**source:** Rust compiler parity (codegen extern auto-coercion)

When calling an extern fn that expects a string argument but receives a struct, the Rust
compiler automatically JSON-serializes the struct. The bootstrap requires manual
`forge_json_stringify_*` calls. This is a convenience feature for FFI ergonomics.

### Spec test: skip and todo
**type:** feature
**priority:** low
**source:** Rust compiler parity (features/spec_test — 16 examples)

`skip` and `todo` keywords in spec test blocks to mark tests as skipped or pending.
The bootstrap's spec test framework supports `spec`, `given`, and `then` but not
skip/todo markers.

```forge
spec "feature X" {
    skip "not implemented yet"
    todo "add edge case test"
    then "basic case" { assert(true) }
}
```

### Spec test: should_fail
**type:** feature
**priority:** low
**source:** Rust compiler parity (features/spec_test)

`should_fail` assertion in spec tests that expects a block to produce an error.
Useful for testing error paths.

```forge
spec "validation" {
    then "rejects negative" should_fail {
        validate_positive(-1)
    }
}
```

### Spec test: where clause (parameterized tests)
**type:** feature
**priority:** low
**source:** Rust compiler parity (features/spec_test)

`where` clause on `then` blocks for parameterized (table-driven) tests. Runs the
assertion body once per row in the table.

```forge
spec "math" {
    then "addition works" where {
        a | b | expected
        1 | 2 | 3
        0 | 0 | 0
       -1 | 1 | 0
    } {
        assert(a + b == expected)
    }
}
```

### Field mutability enforcement
**type:** feature
**priority:** low
**source:** Rust compiler parity (features/field_mutability — 6 examples, WIP)

The bootstrap parses `mut` on struct fields but doesn't enforce immutability. Fields without
`mut` should be read-only after construction. The Rust compiler has this as a WIP feature.

```forge
type Point = { x: int, mut y: int }
let p = Point { x: 1, y: 2 }
p.y = 3    // OK — y is mut
p.x = 4    // ERROR — x is immutable
```

### Query helpers
**type:** feature
**priority:** low
**source:** Rust compiler parity (features/query_helpers — 3 examples)

Query comparison helpers for structured data filtering: `query_gt`, `query_gte`, `query_lt`,
`query_lte`, `query_eq`, `query_like`, `query_between`. Used with collection filtering and
the @model package.

---

## Debt

### ~~Token kind enum (Tk)~~ DONE
Completed April 12, 2026. 79-variant Tk enum replaces string-based token dispatch.
394 replacements across 17 parser files. Also fixed enum == comparison bug (was
comparing pointer addresses, now compares tag bytes).

### ~~Separate lexer from parser~~ DONE
Completed April 12, 2026. 488 lines extracted to parse/lexer.fg.
parse/mod.fg: 1931 → 1455 lines.

### ~~Unify name resolution passes~~ DONE
Completed April 12-13, 2026. `resolve_names` now calls `resolve_program` internally,
presenting a single entry point from main.fg. Both passes live in `resolve/` —
`resolve/mod.fg` (scope validation) and `resolve/names.fg` (module tree + name
qualification). Module file loading (`features/modules/resolver.fg`) remains separate
since it does file I/O. Deeper merge (single AST walk) deferred — current approach
is clean and works.

### Remove vtype_is_* calls from codegen (Phase 1b)
**type:** debt
**priority:** medium
**source:** FEATURE_TYPE_SYSTEM.md

Codegen still has 27 `vtype_is_*` calls. These dispatch on types that codegen itself computed
correctly. The type checker catches errors BEFORE codegen; codegen still needs type dispatch
for correct IR generation. Removing vtype_is_* requires codegen to read from a shared type
table — a DRY improvement, not a correctness fix.


### Resolver/typechecker dispatch through registry
**type:** debt
**priority:** medium
**source:** PLUGGABLE_FEATURES.md, TECH_DEBT.md #30

The Feature struct has `resolve_expr` and `check_expr` handlers but resolver.fg and typeck/mod.fg
still use hardcoded match statements. Catch-all dispatch arms are wired but match arms not yet
extracted from core into features. Wire `dispatch_expr_resolve` and `dispatch_expr_check` into
the catch-all arms so features provide all handlers in one Feature struct and central files
never need editing.

### Bump allocator → real memory management
**type:** debt
**priority:** low
**source:** TECH_DEBT.md #15

All struct/enum/with allocations use a monotonic bump allocator (512MB arena, no free, no reuse).
Bootstrap-only — never ships in user-facing binaries.

Roadmap: bump → ref-counting → ownership tracking → manual allocation.
Remove when Application-level ref-counting is implemented.

### bs2 leaks memory
**type:** debt
**priority:** low
**source:** PLAN.md backlog

Every compile leaks all malloc'd data. Acceptable because the compiler is one-shot and the OS
reclaims. Blocked on real memory management (above).

### ~~Enforce module visibility — remove global name fallback~~ DONE
Completed April 12, 2026. Added 187 `use` imports across 50 files + 49 `export`
annotations. Removed global index fallback (step 6) from `rewrite_ident`. Names
must now be explicitly imported via `use` or defined in the current module.
`resolve/names.fg` (moved from `features/modules/names.fg` on April 13).

### Per-module compilation
**type:** debt
**priority:** low
**source:** architecture review (April 12, 2026)

Currently all modules compile into a single LLVM module. Names are properly qualified
(`module::path::fn`), so this is correct — but it means the entire program recompiles on
every change. At 829 functions and <1s compile time, this is fine.

When the codebase grows past ~5,000 functions or LLVM passes take multiple seconds, split
to per-module compilation: each `mod` directory/file produces its own `.o`, linked at the end.
This enables incremental builds, parallel compilation, and smaller LLVM working sets.

Production compilers for reference: Rust compiles per-crate, Go per-package, C per-file,
Swift per-module. All compile units are larger than a single file. The Forge `mod` directory
is the natural boundary. Blocked on enforcing module visibility (above) — without real
imports, separate compilation can't know what to link.

---

## Bugs

### Type checker doesn't catch return type mismatches in impl methods
**type:** bug
**priority:** high
**source:** discovered April 12, 2026

`peek_char` returned `Tk.Identifier` (a Tk enum value) instead of `""` (a string) for
months without the type checker catching it. The function signature says `-> string` but
the body returned a `Tk` enum. This caused 44M allocations and bump arena exhaustion
when heap-allocated payloads were enabled.

The type checker needs to verify that return expressions match the declared return type
for ALL functions, including impl methods. Currently it only checks explicit `return`
statements in function bodies with declared return types, not implicit returns or impl
methods.

### Stmt.Defer stores Expr, not SExpr — loses source location
**type:** bug
**priority:** low
**source:** TECH_DEBT.md #26

`Stmt.Defer(body: Expr)` stores an `Expr`. The defer handler wraps it in `sexpr_dummy(body)`
which sets line:0, col:0. If a defer body has a compile error, the error points to line 0.
Fix: change `Stmt.Defer(body: Expr)` to `Stmt.Defer(body: SExpr)`. Requires two-phase bootstrap.

### Typeck diagnostic spans point to statement, not expression
**type:** bug
**priority:** medium
**source:** discovered April 14, 2026

`check_call` in `typeck/mod.fg` reports errors like F0201 (wrong arg count)
using `tc.current_line/current_col` which is set from the enclosing statement's
`SStmt` position, not the call expression's position. This causes the error
caret to point at the `let` keyword instead of the function name:

```
  2 │ let x = pair(42)
    · ┬
    · ╰── `pair` expects 2 arguments
```

Should point at `pair`, not `let`. Fix: thread expression positions through
`check_expr` / `check_call`, or update `tc.current_line/col` when entering
each expression.

### ~~Enum match pattern bindings fail in inline lambda arguments~~ DONE
**status:** fixed (April 14, 2026)

Two root causes found and fixed:
1. Lambda params defaulted to `int` when no type annotation was given.
   Match codegen dispatched to primitive match (literal patterns) instead
   of enum match (variant destructuring). Fix: `fill_arg_array_boxing`
   detects Lambda args and passes the callee's expected param types from
   the function type string (e.g. `fn(Box)->int` → param type `Box`).
2. `find_captures` in closures/codegen.fg had `_ -> captures` catch-all
   that skipped 15+ Expr variants (MatchExpr, EnumCtor, NullCoalesce, etc).
   Captured variables inside these expressions were silently missed.
   Fix: added explicit arms for all sub-expression-containing variants.

### Match expression type unification
**type:** bug
**priority:** low
**source:** PLAN.md backlog

`check_match_expr_arms` uses the first arm's type as the result type (`src/typeck/mod.fg:994`).
Real unification should check that all arms produce the same type and report mismatches.
Currently silently picks the first arm type even when arms disagree.

### Diagnostic renderer crashes on out-of-range line numbers
**type:** bug
**priority:** high
**source:** discovered April 14, 2026 during generics implementation

`render_diagnostic` in `diagnostics/render.fg` crashes when a diagnostic's line
number exceeds the source file's actual line count. This happens when the type
checker produces warnings from multi-module compilation — the line number is a
global offset across all modules, but the renderer only has the entry file's source.

The crash is a null pointer dereference in `extract_line` → `substring` when the
source line is empty (not found). A guard was added (`if src_line.length == 0 { return }`)
but the proper fix is to pass per-module source text to the diagnostic renderer
or translate global line numbers to module-relative ones.

This blocked adding `features/generics/mono.fg` to the build until the seed was
updated with the guard fix. Any future large module addition may hit the same issue.

### `consume_type` does not handle tuple return types
**type:** bug
**priority:** low
**source:** discovered April 14, 2026

`consume_type` in `parse/mod.fg` cannot parse `(A, B)` as a type (e.g., in
`fn foo<A, B>(a: A, b: B) -> (A, B)`). It encounters `(` and reports
"expected return type after `->`". Tuple types in return position require the
parser to handle `(` as a type start. This is only a limitation for explicit
tuple return type annotations — returning tuples without annotations works fine.

### ~~Generic type inference defaults unresolved type params to `int`~~ DONE
**status:** fixed (April 14, 2026)

Expression-based type inference implemented in `features/generics/mono.fg`.
`infer_expr_type` examines argument AST nodes (literals → their type,
variables/calls → "int" fallback). Enum constructors merge partial inference
across variants (`Result.Ok(42)` → T=int, `Result.Err("hello")` → E=string
→ merged to `Result__int__string`). Unresolved type params emit F0400 error
via the diagnostic system. Mangling follows declaration order via
`mangle_name_ordered`.

### Name resolution uses globals instead of NameCtx parameter passing
**type:** bug
**priority:** medium
**source:** TECH_DEBT.md #37

The seed's compiled `rewrite_expr(expr: Expr)` (1 parameter) generates code that treats x1
(second register) as the primary value instead of x0. The codegen's parameter binding generates
code that accesses the wrong register for single-parameter functions — likely an off-by-one in
`bind_params_inline` or `forge_llvm_get_param` indexing. Globals-based name resolution works as
a workaround; parameter-passing is architecturally better but blocked by this.

---

## Tooling

### --trace-codegen flag
**type:** tooling
**priority:** low
**source:** PLAN.md backlog

Emit each IR line with a source-span comment. Add when hitting a divergence that can't be eyeballed.

### --dump-types flag
**type:** tooling
**priority:** low
**source:** PLAN.md backlog

Print inferred type tags per expression. Blocked on real per-alloca type tracking.

### --bisect-lines improvement
**type:** tooling
**priority:** low
**source:** PLAN.md backlog

Line-aware `--bisect-lines`: bisect on declaration boundaries instead of raw line count.

### --only-module flag
**type:** tooling
**priority:** low
**source:** POST_MORTEM.md

```bash
bs2 compile --only-module=core.names src/main.fg
```
Compiles the full source but only emits codegen for one module. Useful for testing specific
functions without processing everything.

### --self-test flag
**type:** tooling
**priority:** low
**source:** POST_MORTEM.md

Instead of spawning `bs2 compile src/main.fg` as a separate process, have a `--self-test`
flag that compiles the source in-process. Eliminates process startup overhead and makes the
test ~2x faster.

---

## Limitations (accepted for now)

### Feature registry handlers require named functions
**type:** limitation
**source:** PLUGGABLE_FEATURES.md

Bootstrap can't match/call methods inside lambdas. Feature handler fields must use named
wrapper functions instead of inline lambdas. Workaround: define a named function and pass it.

---

## Cleanup (optional, cosmetic)

### VarLookup/FnLookup struct pattern
**source:** TECH_DEBT.md #4

`env_lookup` returns `VarLookup { found, alloca, ty }` instead of `ptr?`. Originally worked
around a Rust host bug. Could migrate to `?`-based returns. The struct pattern is actually readable.

### Tagged Value struct in eval.fg
**source:** TECH_DEBT.md #5

eval.fg uses `type Value = { tag, int_val, str_val, ... }` instead of an enum. Originally
worked around a Rust host bug. eval is rarely used (only for the `eval` command).

### Recursive enum lists instead of real collections
**source:** TECH_DEBT.md #6

ExprList, StmtList, ParamList, VarEnv are linked lists. Could migrate to `forge_array_*`
runtime. The recursive enums work fine for AST sizes and are idiomatic for immutable scope stacks.

### Remove `ty: string` from ParamList/FieldList
**source:** MONOMORPHIZATION_PLAN.md #9 remaining debt

ParamList.Node and FieldList.Node still carry both `ty: string` and
`resolved: ValueType`. The string field is only read by:
- setup.fg's `resolve_field_list`/`resolve_param_list` (to populate `resolved`)
- `should_null_check` in fn_decl (string pattern checks)
- `render_param_list`/`render_field_list` in ast.fg (debug printing)
- `params_to_type_list` in setup.fg (builds FnParamTypes registry)

To remove: change Stmt.Let/Mut/Function/ExternFn to carry ValueType
instead of string, update parser to resolve types at parse time (or add
a post-parse resolution pass), then delete the string field entirely.

### Remove ParamTypeList / FnParamTypes string registry
**source:** codegen cleanup (April 14, 2026)

`FnParamTypes` maps function names to `ParamTypeList` (per-param type
strings). Only used in `fill_arg_array_boxing` for trait auto-boxing
decisions. Now that ParamList carries `resolved: ValueType`, this
could read directly from the function's ParamList instead of a
separate string registry. Would eliminate the `collect_fn_params`
pass, `ParamTypeList` enum, `FnParamTypes` enum, and `param_type_at`.

### LLVM 20 -O2 miscompilation on ARM64
**source:** build system (April 14, 2026)

The seed occasionally triggers an LLVM 20 -O2 miscompilation on ARM64.
Symptoms: seed crashes at -O2, -O0 fallback produces wrong code
("undefined variable" errors). Workaround: regenerate the seed from a
working bs2 build (the new IR pattern avoids the bug). The build system
auto-detects and warns about this.

`LLC_PREFIX` in diagnose.sh is pinned to LLVM 20.1.5 for this reason.
Upgrading to LLVM 21 may fix it but introduces other -O2 issues (wrong
register for parameters on ARM64).

### mod.fg re-exports all AST symbols
**source:** codegen cleanup (April 14, 2026)

`codegen/mod.fg` imports ~40 AST symbols and ~20 codegen.types symbols
that it doesn't use directly — they're re-exported for feature codegen
files that import through the module system. This makes mod.fg's import
list enormous and impossible to clean up without breaking downstream
files. A proper fix requires the module system to support transitive
exports or `pub use` re-exports.
