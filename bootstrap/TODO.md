# Bootstrap TODO

Consolidated from ASSESSMENT.md, FEATURE_PARITY.md, FEATURE_TYPE_SYSTEM.md,
PLAN.md, PLUGGABLE_FEATURES.md, POST_MORTEM.md, TECH_DEBT.md on April 12, 2026.

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

### Match expression type unification
**type:** bug
**priority:** low
**source:** PLAN.md backlog

`check_match_expr_arms` uses the first arm's type as the result type (`src/typeck/mod.fg:994`).
Real unification should check that all arms produce the same type and report mismatches.
Currently silently picks the first arm type even when arms disagree.

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
