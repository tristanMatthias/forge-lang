# `@expand` infrastructure prework — handoff

**Status:** open · **Beads:** `forge-crafting-intepreters-qa6i`

---

## Scope of THIS work

Build the macro-system infrastructure so that, after this lands, a follow-up session can write `@comptime` macros that introspect the surrounding scope and emit new top-level declarations.

**Recommended order** (each step ends with a commit that leaves the build green):

1. **Encoder/decoder gaps in the quote roundtrip** (~half day). The current encoder misses `EnumDecl`; the ValueType decoder only handles primitive variants. Without these, macros that emit or receive enum decls / non-primitive types in signatures silently lose data. Fix before anything else — every later test depends on this.
2. **Quote-surface probes 1–5** (~half day each, max 2.5 days if all fail). Probe what works, fix what doesn't, commit per gap.
3. **`resolve_names` refactor** (~1 day): split into `register_decls` + `rewrite_uses`. Land as its own commit; existing suite must still pass.
4. **Pipeline-order fix (Option C)** (~1 day): `expand_macros_collect` + `expand_macros_eval` + the `from_macro` SStmt tag + partial re-resolve. Land with the seven pipeline-fix tests.
5. **`ResolverCtx` infrastructure** (~1 day): opaque-handle + extern-fn vtable approach. Land with the four ResolverCtx tests.
6. **Final verification + push.**

**In scope:**
- Steps 1–6 above.
- Every test listed in "Test plan". Each must pass.
- Selfhost fixed point holds (`make update-seed` succeeds and `bs2` ≡ `bs3`).

**Out of scope:**
- Writing any actual macro that uses this infrastructure. Don't.
- Touching any walker / desugar / resolver / mono source files (`features/generics/mono.av`, `codegen/escape.av`, `features/closures/codegen.av`, `desugar/mod.av`, `features/comptime/rewrite.av`, `resolve/names.av:rewrite_expr` arms, etc.). The infrastructure must be testable on its own — these will be touched in a later session by a different agent.
- Converting `features/marshal/derive.av` from its existing pre-resolve compiler-pass pattern to use `@expand`. Marshal stays as-is for this work.
- Performance optimisation. Make it correct first; perf can be tuned later by someone with the empirical data.

**Done signal:** all the verification probes in this doc compile, run, and produce the expected output. The bootstrap test suite passes (current baseline 2462+; this work adds ~15 new tests, so post-work suite should be 2477+). The selfhost fixed point holds.

### Bootstrap workflow reminders

- Read `bootstrap/CLAUDE.md` before touching any source. Key rules: never `--no-verify`, never destructive git, always commit incrementally.
- Build cycle: edit source → `make build` (rebuilds bs2 from seed + verifies bs2 self-compiles) → tests → `make update-seed` once stable.
- **Adding the `from_macro: bool` field on `SStmt` requires seed patching.** Per `CLAUDE.md`: "Adding fields to existing variants also needs this treatment. Run `make seed-patch-traps` before `make build`. Then `make update-seed` after the build succeeds."
- Tests live in `features/<name>/tests/*.av`. Use `spec/given/then` blocks. Existing examples to model on: `features/comptime/tests/expand_macro_test.av` (single-stmt return), `features/comptime/tests/expand_macro_multi_stmt_test.av` (list return — same shape your new tests will use).
- Pre-commit hook auto-runs the test suite + fixed-point check. Don't bypass it.

---

## TL;DR of the bug

`@expand` macros that return decl-introducing `Stmt`s (`Function`, `TypeDecl`, `EnumDecl`, `Impl`) succeed at the macro layer but silently never reach codegen as usable declarations. Root cause: `expand_macros` runs *after* `resolve_names` in the bootstrap pipeline, so any new top-level decl a macro emits is never name-registered.

The same bug also blocks macros from receiving type-aware context (because there's no surface for them to query the resolver), and blocks them from building non-trivial AST output (because the quote surface is missing a few capabilities for splicing into match-arm position and similar spots).

This doc spells out the fix for all three concerns, with verification probes for each.

---

## Empirical proof of the pipeline bug

Probe — paste into `/tmp/probe_pipeline.av`, run `build/bs2 compile /tmp/probe_pipeline.av`:

```av
use @std.avrac.core.{Stmt, SStmt, ParamEntry, TypeParamEntry, ValueType}

@comptime
fn build_simple_fn() -> Stmt {
    let empty_body: List<SStmt> = []
    let empty_params: List<ParamEntry> = []
    let empty_tp: List<TypeParamEntry> = []
    Stmt.Function("_gen", empty_tp, empty_params, ValueType.Unknown, empty_body)
}

@expand(build_simple_fn)
fn placeholder() {}

fn main() {
    _gen()   // <- compile fails: "undefined variable _gen"
}
```

Symptoms today:
- The `@expand` pass runs (no error from `invoke_macro`).
- The macro's return decodes via `value_to_stmt`.
- The string `"_gen"` appears in the IR only as a literal constant (from the encoded payload).
- **No `define i64 @_gen()` block is emitted.**
- The `_gen()` call site fails with `resolve error: undefined variable _gen`.

Same bug for any decl-introducing Stmt variant (Function, TypeDecl, EnumDecl, Impl). Body-only Stmt variants (Block, Expr, Return) work because they don't introduce names.

---

## Why it doesn't work today

Pipeline order in `bootstrap/packages/cli/src/main.av` (search for `derive_marshal`, ~line 3317):

```
parse
  → resolve_module_files
  → inject_intrinsics
  → expand_components
  → derive_marshal           ← compiler-internal derive (pre-resolve, works)
  → resolve_names            ← name registry frozen here
  → expand_macros            ← user macros run AFTER name resolution
  → run_comptime
  → typecheck
  → mono
  → codegen
```

`resolve_names` walks the AST building the name table. Once it finishes, `expand_macros` runs. By then the registry is closed. New decls emitted by `expand_macros` are visible in the AST but invisible to the resolver, typechecker, and codegen.

### Why `expand_macros` is positioned where it is today

From `features/comptime/grammar.md`:

> The two pieces are separate passes in the compile pipeline:
> `resolve_names → expand_macros → run_comptime → typecheck`

`expand_macros` runs after `resolve_names` because the macro's *body* (a `@comptime fn`) needs the eval runtime, and the runtime needs resolved names to invoke helper fns inside the macro body. Without resolution, `quote stmt { my_helper(x) }` inside a macro body can't find `my_helper`.

### Why the marshal pattern is unaffected

`features/marshal/derive.av` runs as `derive_marshal` BEFORE `resolve_names`. It's a plain Avra `fn(stmts: List<SStmt>) -> List<SStmt>` — not a `@comptime fn`. It directly inspects AST nodes, constructs new ones programmatically, and inserts them as siblings in the stmt list. The resolver runs *after* and treats the synthesised decls identically to hand-written ones.

This pattern is correct and proven. **Do not change it.** The bug is specifically about user-level `@expand` macros being unable to do the same.

---

## Three architectural options

### Option A — Re-run `resolve_names` after `expand_macros`

```
parse → ... → resolve_names → expand_macros → resolve_names (again) → ...
```

**Pros:** Simplest to describe.

**Cons:** Cascades. `resolve_names` mutates a `type_registry`, populates aliases, qualifies idents — these aren't all idempotent. Type registry would double-register; QualifiedIdent re-rewriting needs an "is already qualified, skip" path that doesn't exist; module-resolution / `use` handling has side effects that may emit duplicate diagnostics.

**Risk:** Medium-high. Subtle non-idempotency surfaces as obscure downstream failures.

### Option B — Move `expand_macros` BEFORE `resolve_names`

```
parse → ... → expand_macros → resolve_names → ...
```

**Pros:** No double-pass.

**Cons:** The macro body now runs without resolved names. `comptime_lookup` is keyed on resolved qualified names; `collect_comptime_fns` populates the registry from already-resolved decls. Body eval breaks.

**Risk:** Medium. The macro-body-resolution dance is the tricky part.

### Option C — Split into pre- and post-resolve phases (RECOMMENDED)

```
parse → ... → expand_macros_collect → resolve_names → expand_macros_eval → partial re-resolve → ...
```

- **`expand_macros_collect`**: pre-resolve walk. Captures `(target_stmt_position, macro_name)` pairs into an `ExpandPlan`. Doesn't evaluate.
- **`resolve_names`**: runs as today.
- **`expand_macros_eval`**: post-resolve. Evaluates each captured macro with the now-resolved registry. Splices results into the stmt list. Tags inserted SStmts so the next pass knows which ones are new.
- **Partial re-resolve**: walks only the tagged stmts and resolves them. Bounded scope; cheap; safe.

**Pros:** Macro bodies see resolved names (eval works). Generated decls go through name resolution (so call sites resolve). The split makes the dependency explicit instead of hidden in pipeline order.

**Cons:** Two phases instead of one (small code complexity bump). The splicer must tag inserted stmts so the partial re-resolve knows what to walk.

**Risk:** Low. Each phase is independently testable.

---

## Recommended path: Option C

Reasoning:
1. Doesn't break the macro-body-eval dependency (B's hardest problem).
2. Doesn't require full resolver idempotency (A's hardest problem).
3. The "phase 1: collect; phase 2: eval+splice; phase 3: partial re-resolve" decomposition mirrors how compilers handle generic instantiation and other deferred-resolution patterns.
4. Each phase can be tested in isolation.

---

## Encoder/decoder gaps to fix FIRST (step 1 of the recommended order)

Before any other work, fix two known holes in the quote roundtrip. Both already block tests we'd want to write.

### Gap 1.A: `construct_stmt` doesn't handle `EnumDecl`

**File:** `bootstrap/packages/std-avrac/src/features/quote_expr/lower.av`, function `construct_stmt` (around line 671).

The fn handles `Let`, `Mut`, `Const`, `Expr`, `Block`, `Return`, `Function`, `TypeDecl`, `Impl`, `TraitDecl`, etc. — but no arm for `EnumDecl`. Falls through to `stmt_passthrough` which encodes as `NoOp`. So any macro that receives an `EnumDecl` via 1-arg `@expand` (or 2-arg post this work) gets back a NoOp.

**Fix:** add the arm. Mirror `TypeDecl`'s structure:

```av
.EnumDecl(name, tp, variants) -> stmt_ctor("EnumDecl",
    three_args(name_or_splice(name),
               construct_type_param_list(tp),
               construct_variant_list(variants)))
```

And add `construct_variant_list(variants: List<Variant>) -> Expr` (mirrors `construct_field_list`). Each variant encodes as a struct literal `Variant { name, fields }` where `fields` reuses the existing `construct_field_list`.

Also add the matching decoder arm in `features/comptime/eval.av:enum_value_to_stmt` (around line 367, alongside the existing `"TypeDecl"` arm). Mirrors `TypeDecl`'s shape.

**Test:** new test `expand_introduces_enum_test.av` (listed below) covers this.

### Gap 1.B: `enum_value_to_value_type` only handles primitives

**File:** `bootstrap/packages/std-avrac/src/features/comptime/eval.av`, function `enum_value_to_value_type` (around line 563).

Currently handles: `Int`, `Bool`, `Float`, `Str`, `Bytes`, `Void`, `Ptr`, `Unknown`. Everything else (`Struct`, `Enum`, `List`, `Tuple`, `FnTyped`, `Trait`, `Union`, `Map`, `Task`, `U8/16/32/64`, `I8/16/32`, `Newtype`, `NarrowedEnum`) decodes as `null`. So a macro that emits a fn whose return type is, say, `List<int>` gets the return type silently dropped — the decoded Function has `ValueType.Unknown` as its return.

**Fix:** add decoder arms for at least the variants the tests below exercise. Minimum viable set: `List(elem)`, `Struct(name, id)`, `Enum(name, args, id)`. Mirror what the construct-side does. Pair each addition with a `construct_value_type_*` encoder on the lower.av side if one doesn't exist yet — currently only `construct_value_type_unknown` exists.

**Test:** a new test `value_type_roundtrip_test.av` — macro emits a fn with `List<int>` return, asserts decoded fn has the right return type. Add this to the suite even if not strictly needed by the other tests; it pins the encoder/decoder contract.

### `construct_field_list` discards type info — leave as-is for now

`construct_field_list` (around line 504) sets every field's `resolved` to `Unknown`. Documented comment: "Quote captures pre-resolve so every entry's `resolved` slot is encoded as `ValueType.Unknown`."

This is intentional for QUOTE (which captures pre-resolution). But it limits what 2-arg macros receive. **Don't try to fix this in this work** — the ResolverCtx surface (below) is the proper way for macros to get type info, by querying. Don't touch construct_field_list.

---

## Implementation plan: Option C pipeline fix

### Files that will change

- `bootstrap/packages/std-avrac/src/features/comptime/expand_macro.av` — split into collect + eval phases.
- `bootstrap/packages/cli/src/main.av` — update pipeline order at every site that runs the four-pass sequence (`derive_marshal` → `resolve_names` → `expand_macros`). Find them with `grep -n 'derive_marshal\b' packages/cli/src/main.av`; at time of writing there are four call sites around lines 3317, 3400, 3430, 3695 (plus the import at line 80, which doesn't change).
- `bootstrap/packages/std-avrac/src/resolve/names.av` — refactor `resolve_names` into `register_decls` + `rewrite_uses` so the partial re-resolve can call `register_decls` with the existing registry and `rewrite_uses` over just the newly-spliced stmts.
- `bootstrap/packages/std-avrac/src/features/comptime/grammar.md` — update pipeline section.
- `bootstrap/packages/std-avrac/src/core/ast.av` — add `from_macro: bool` field on `SStmt`. **Requires seed patching** — `make seed-patch-traps` then `make build` then `make update-seed` (CLAUDE.md "Adding fields to existing variants" workflow).

### Step-by-step

1. **Audit `resolve_names`** for what's per-stmt vs per-program. Document the side effects of each step.

2. **Refactor `resolve_names` into two halves:**
   - `register_decls(stmts, registry) -> registry` — pure decl scan, populates the registry.
   - `rewrite_uses(stmts, registry) -> stmts` — rewrites Idents to QualifiedIdent given a fixed registry.

   Current `resolve_names` becomes `let r = register_decls(stmts, new_registry()); rewrite_uses(stmts, r)`. Existing tests must still pass after this refactor *alone* — land the refactor as its own commit before moving on.

3. **Split `expand_macros`** into:
   - `expand_macros_collect(stmts) -> ExpandPlan` — walks stmts, scans for `@expand` annotations, returns a plan. **Reference each target by its content-hash, not its position** — the stmt list doesn't change between collect and eval (resolve_names is in-place), but indexing is brittle. Use the SStmt's source span + the macro name as the lookup key. Define:
     ```av
     type ExpandTarget = { source_file: string, source_line: int, source_col: int, macro_name: string }
     type ExpandPlan = { targets: List<ExpandTarget> }
     ```
   - `expand_macros_eval(stmts, plan, reg) -> List<SStmt>` — walks the (resolved) stmt list, matches each stmt's source position against the plan, invokes the macro for each match, splices results. Tags inserted SStmts with `from_macro: true`.

   The position-as-content-hash approach also handles the case where a future change reorders stmts between phases — the plan would still resolve correctly because it doesn't rely on indices.

4. **Wire pipeline** in `cli/src/main.av` (four sites):
   ```
   parse → ... → derive_marshal
        → expand_macros_collect    // gather targets, don't evaluate
        → resolve_names            // unchanged
        → expand_macros_eval(plan) // now has resolved names + macro fns
        → register_decls(spliced_only, existing_registry)
        → rewrite_uses(spliced_only, registry)
        → run_comptime → typecheck → ...
   ```

5. **Tag spliced SStmts.** Add `from_macro: bool` on SStmt (default false). The splicer sets it true on every inserted SStmt. The partial re-resolve walks only stmts where `from_macro == true`. The flag is informational only — don't strip it; downstream passes that don't care can ignore it (it's a bool field, costs nothing).

6. **Nested @expand.** A macro that returns code containing another `@expand` site should expand recursively. After the split: `expand_macros_eval` runs to a fixpoint — it walks the result, finds any new `@expand` annotations in the spliced output, evaluates and splices those, repeats. Cap at 16 iterations with a clear "macro recursion limit" error to prevent infinite loops.

---

## Required `ResolverCtx` infrastructure

Macros need to query the surrounding scope (look up a type by name, ask "is this type the same as that one", etc.). Today there's no such surface. Add it as part of this work.

### New file: `bootstrap/packages/std-avrac/src/features/comptime/resolver_ctx.av`

**Implementation note: opaque handle, not fn-typed struct fields.** A macro is interpreted by the comptime eval runtime. To call back into the compiler, the macro needs to invoke compiler-side fns through the existing `extern fn` mechanism (which the runtime already plumbs). So:

- `ResolverCtx` itself is a struct holding ONE field: an opaque `int` handle the compiler uses to look up the actual resolver state.
- Each "method" on `ResolverCtx` is a free `export fn` in `resolver_ctx.av` that takes the ctx as first arg and dispatches via an `extern fn` to compiler-side code.
- Macros call them as `ctx_lookup_type(ctx, "Expr")` rather than `ctx.lookup_type("Expr")`. (Method-call sugar might land later; not in scope now.)
- The handle pattern mirrors how `Runtime` is passed through `features/eval/` today — same `extern fn` plumbing, same lifecycle.

```av
// WHY: sealed read-only handle macros use to query the resolver
// from inside @comptime evaluation. Mirrors how `Runtime` is
// threaded through eval — opaque handle, extern-fn dispatch.

use @std.avrac.core.{TypeKind}

/// Opaque handle. The `id` is meaningful only to the compiler-side
/// extern fns; macros treat it as an unforgeable token.
export type ResolverCtx = { id: int }

/// A resolved type — name + kind + structure already canonicalised.
export type ResolvedType = {
    canonical_name: string,
    kind: TypeKind,
    fields: List<ResolvedField>?,    // populated for struct types
    variants: List<ResolvedVariant>?, // populated for enum types
}

export type ResolvedField = { name: string, ty: ResolvedType }
export type ResolvedVariant = { name: string, fields: List<ResolvedField> }

// ── Compiler-side externs (implemented in compiler internals; declared here) ──

/// Module the annotated decl lives in (e.g. "@std::avrac::core").
extern fn ctx_current_module(ctx: ResolverCtx) -> string

/// Look up a type by source-level name, qualifying through the
/// active scope's imports. Returns the canonical resolved type or
/// null if unknown.
extern fn ctx_lookup_type(ctx: ResolverCtx, name: string) -> ResolvedType?

/// Resolve an identifier the same way Expr.Ident would resolve at
/// this scope. Returns the QualifiedIdent path or null.
extern fn ctx_qualify_ident(ctx: ResolverCtx, name: string) -> string?

/// Synthesise a fresh identifier guaranteed not to collide with any
/// name visible in this scope. Uniqueness scope: this compile.
extern fn ctx_fresh_ident(ctx: ResolverCtx, hint: string) -> string

/// Returns the field-access chain to dig from `t` to a value of type
/// `target`. Examples:
///   ctx_unwrap_path_to(SExpr, "Expr")    -> ["node"]
///   ctx_unwrap_path_to(FieldInit, "Expr") -> ["value", "node"]
///   ctx_unwrap_path_to(string, "Expr")   -> []   (no path)
///   ctx_unwrap_path_to(Expr, "Expr")     -> []   (already is target)
/// BFS over the field graph; cycle-guarded with depth cap = 8.
extern fn ctx_unwrap_path_to(ctx: ResolverCtx, t: ResolvedType, target: string) -> List<string>
```

The compiler-side implementations of these extern fns live in `features/comptime/expand_macro.av` (or a new sibling file) and read from the active resolver state. They're added to the runtime's extern table just like `avra_*` runtime calls.

### New file: `bootstrap/packages/std-avrac/src/features/comptime/macro_types.av`

```av
use @std.avrac.core.{Stmt, SStmt, Annotation, Span}

/// What a macro receives as its first arg — the decl being expanded,
/// plus its annotation metadata.
export type AnnotatedDecl = {
    stmt: Stmt,                /// the decl (unwrapped from Annotated layers)
    annotation: Annotation,    /// the @expand(...) annotation itself
    canonical_path: string,    /// qualified path to the decl (e.g. "@user::ast::Foo")
}

/// What a macro returns. Decls inside are already name-resolved
/// against the macro's ResolverCtx — the compiler doesn't re-resolve
/// them whole; it only checks the names match expectations.
export type ResolvedDecls = {
    /// The decls to splice into the parent stmt list, in order.
    decls: List<SStmt>,

    /// Names this batch of decls introduces into the parent scope.
    /// The compiler registers these after splicing.
    introduces: List<DeclSymbol>,

    /// Provenance trail. Each emitted decl knows it came from this
    /// macro with these args. Powers IDE jump-to-source.
    provenance: MacroProvenance,
}

export type DeclSymbol = {
    name: string,             /// unqualified name (e.g. "children")
    kind: DeclKind,
    canonical_path: string,   /// post-resolution name
}

export enum DeclKind { Function; Type; Impl; Method(of: string); Const }

export type MacroProvenance = {
    macro_name: string,
    target_canonical: string,
    target_source_span: Span,
}
```

### Wiring

In `features/comptime/expand_macro.av:invoke_macro`:

1. Build `AnnotatedDecl` from the target stmt + the `@expand` annotation node.
2. Construct `ResolverCtx` from the active resolver state. ResolverCtx is an opaque struct holding a pointer to the resolver + a vtable of extern fns that the eval runtime can call when the macro invokes `ctx.lookup_type(...)` etc.
3. The macro signature now matches `fn(AnnotatedDecl, ResolverCtx) -> ResolvedDecls`. Dispatch on arity:
   - 0 args (legacy): existing behaviour, returns single Stmt or List<SStmt>.
   - 1 arg (legacy): existing Stmt boxing.
   - **2 args (new)**: pass `(boxed AnnotatedDecl, boxed ResolverCtx)`. Decode return via new `value_to_resolved_decls` decoder.
4. Splice `result.decls` into the stmt list. Register `result.introduces` with the existing registry. The partial re-resolve handles the rest.

The `ResolverCtx` encoder/decoder pair is special — it's not a plain Value, it's a *handle* the macro uses to call back into the compiler. Implement as an opaque pointer + extern fns that the eval runtime dispatches via the existing `extern fn` mechanism. (Same shape as how `Runtime` is passed through eval today — pattern is proven.)

### `unwrap_path_to` implementation

Probably ~30 LOC. BFS over `t`'s fields: for each field, if its type's canonical_name equals `target`, return `[field.name]`. Otherwise recurse into the field's type, prepending the field name to the returned path. Cap depth at some reasonable limit (say 8) to prevent infinite loops on recursive types — if the BFS exhausts depth without finding target, return `[]`.

---

## Required quote-surface additions

The infrastructure above is most useful when macros can build their output via `quote` rather than constructing AST by hand. Add the missing capabilities:

### Probe these BEFORE adding anything

Write a probe for each. If the probe works without changes, mark the capability "already supported." If it fails, that capability needs to be added.

#### Probe 1: `quote arm { ~pat -> ~body }`

```av
use @std.avrac.core.{Stmt, MatchArm, Pattern, Expr}

@comptime
fn make_arm() -> MatchArm {
    quote arm { .Foo(x) -> x + 1 }
}

@comptime
fn dummy_stmt() -> Stmt {
    Stmt.NoOp
}

@expand(dummy_stmt)
fn placeholder() {}

fn main() {
    println("test")
}
```

Probably doesn't compile today (no `arm` kind in `quote_expr/grammar.md`). If missing: add an `arm` kind to the quote grammar that parses a single match arm with optional splice points in pattern + body positions. Files: `features/quote_expr/parser.av`, `features/quote_expr/lower.av`, the codec roundtrip in `features/comptime/eval.av`.

#### Probe 2: Splicing a `List<MatchArm>` into a `match` body

```av
@comptime
fn make_match_arms() -> List<MatchArm> {
    let a1 = quote arm { .A -> 1 }
    let a2 = quote arm { .B -> 2 }
    [a1, a2]
}

@comptime
fn build() -> Stmt {
    let arms = make_match_arms()
    quote stmt {
        let x = match some_enum {
            ~arms
        }
    }
}
```

The `~arms` splice in match-position is what matters. Probably doesn't work today — the splice mechanism may only support spliced-in expr or stmt positions, not arm lists. If missing: add `~list_expr` splice support in match-arm position to the quote lowering. Files same as above.

#### Probe 3: Splicing a string as a type identifier

```av
@comptime
fn build(name_arg: string) -> Stmt {
    quote stmt {
        fn helper(x: ~name_arg) -> ~name_arg { x }
    }
}
```

If splices work in type position uniformly, this should be fine. If type-position parsing has its own ident-only path, splice doesn't fit. Test, fix if broken.

#### Probe 4: Iteration-style splice in a quote body

```av
@comptime
fn build(items: List<string>) -> List<SStmt> {
    quote stmts {
        ~for item in items {
            quote stmt { println(~item) }
        }
    }
}
```

This is "execute Avra code at quote-time and splice each result as a stmt." Different from a plain `~expr` splice. **Probably doesn't exist today.** If missing: either add it, OR establish the convention that callers build the list outside the quote and splice the finished list in with `~items`. Document the chosen approach.

### Fix the gaps the probes find

For each probe that fails, add the missing capability. Each gets its own commit with its own test. Don't bundle.

For probes that work as-is, mark in your commit message which probe you confirmed; no code change required for those.

**Note on dynamic enum-ctor names:** building `Expr.EnumCtor("@my::Type", variant_name, args)` programmatically (without quote) is already the established way to construct a variant with a runtime-determined variant name. No new quote-surface support is needed for this case — use the direct constructor.

---

## Test plan

All new tests live in `bootstrap/packages/std-avrac/src/features/comptime/tests/`. Each is a standalone `spec` test using the `cached_fixture_run` pattern (same shape as existing `expand_macro_*_test.av` files).

All test files use the `cached_fixture_run` pattern — see `features/comptime/tests/expand_macro_test.av` for the canonical shape (writes source to `/tmp`, compiles + runs it, asserts on captured stdout).

### Step-1 tests (encoder/decoder gaps)

1. **`value_type_roundtrip_test.av`** — macro returns `Stmt.Function(name, [], [], ValueType.List(.Int), body)`. Decoded fn must have return-type `List<int>`, not `Unknown`. Drives gap 1.B fix.

### Pipeline-fix tests (Option C)

2. **`expand_decl_introducing_test.av`** — the probe from the empirical-proof section above. Asserts `_gen()` is callable from main and the program prints "ok" at runtime.

3. **`expand_introduces_type_test.av`** — macro returns `Stmt.TypeDecl("Foo", [], [{name: "x", resolved: .Int}])`. Caller writes `let f = Foo { x: 42 }; println("${f.x}")`. Asserts "42" appears in output.

4. **`expand_introduces_enum_test.av`** — macro returns `Stmt.EnumDecl("Color", [], [Variant{name:"Red", fields:[]}, Variant{name:"Blue", fields:[]}])`. Caller writes `let c = Color.Red; match c { .Red -> println("R"); .Blue -> println("B") }`. Asserts "R" appears. **Drives gap 1.A fix.**

5. **`expand_introduces_impl_test.av`** — macro returns `Stmt.Impl("MyType", [Stmt.Function("greet", [], [self_param], .Str, [Stmt.Return(Expr.String("hi"))])])`. Caller writes `type MyType = { x: int }` separately, then `MyType{x:1}.greet()`. Asserts "hi" appears.

6. **`expand_multi_decl_test.av`** — macro returns `List<SStmt>` containing both a `TypeDecl` and an `Impl`. Caller exercises both. Asserts they're spliced as siblings and the impl's methods are callable on the type.

7. **`expand_introduces_registration_test.av`** — macro returns `ResolvedDecls` with one fn in `decls` and a matching `DeclSymbol` in `introduces`. Test: a SECOND macro later in the file calls `ctx.qualify_ident("<introduced_fn_name>")` — must return the qualified path. Proves `introduces` is registered before downstream macros run.

8. **`expand_nested_test.av`** — macro returns code containing another `@expand` site. The inner expansion fires. Then test the recursion cap: a self-referential macro should produce a clean "macro recursion limit (16) exceeded" error, not a stack overflow.

9. **`expand_body_eval_still_works_test.av`** — macro whose `@comptime` body calls a `use`-imported helper fn (e.g. `string.length`). Regression test that body-eval still has resolved names available after the collect/eval split.

10. **`expand_resolve_names_refactor_test.av`** — single test exercising the `register_decls` + `rewrite_uses` decomposition. Compile a small program twice with `register_decls(stmts, new_registry()); rewrite_uses(stmts, r)` then via the original `resolve_names`; assert identical AST output. Pins the refactor's correctness independently of any macro work.

### `ResolverCtx` tests

11. **`resolver_ctx_lookup_type_test.av`** — set up a file with `type Foo = { x: int }` and a `@comptime fn probe(_d: AnnotatedDecl, ctx: ResolverCtx) -> ResolvedDecls` body that calls `ctx_lookup_type(ctx, "Foo")` and `ctx_lookup_type(ctx, "Nonexistent")`. Probe's macro emits a `Stmt.Const` literal whose value encodes the lookup results (e.g. `Foo's canonical_name = "@user::ast::Foo", nonexistent = null`). Assert via runtime printout.

12. **`resolver_ctx_qualify_ident_test.av`** — file imports `use @std.process.{exit}`. A `@comptime fn probe(...)` calls `ctx_qualify_ident(ctx, "exit")` and emits the result as a string constant. Assert the resolved path is `"@std::process::exit"`.

13. **`resolver_ctx_fresh_ident_test.av`** — probe calls `ctx_fresh_ident(ctx, "x")` ten times. Macro emits a stmt containing all ten ids. Assert at runtime: all distinct, none equal to any name that was visible in the source file before expansion.

14. **`resolver_ctx_unwrap_path_test.av`** — file defines `type Wrap = { node: int }` and `type DoubleWrap = { value: Wrap }`. Probe calls `ctx_unwrap_path_to(Wrap, "int")` (expects `["node"]`), `ctx_unwrap_path_to(DoubleWrap, "int")` (expects `["value", "node"]`), `ctx_unwrap_path_to(string, "int")` (expects `[]`), `ctx_unwrap_path_to(int, "int")` (expects `[]`). Plus a recursive-type case: `type Rec = { self_ref: Rec, payload: int }` — `ctx_unwrap_path_to(Rec, "int")` must terminate (returns `["payload"]`).

### Quote-surface tests

(Only land tests for probes whose capability you actually added. If a probe works as-is, no test needed — just note in the commit message.)

15. **`quote_arm_test.av`** — covers probe 1. Build a match arm via `quote arm { .Foo -> 1 }`, splice into a `quote stmt { match v { ~arm; _ -> 0 } }`. Verify at runtime the arm fires.

16. **`quote_splice_arm_list_test.av`** — covers probe 2. Build `let arms: List<MatchArm> = [arm1, arm2]`, splice with `~arms` inside a match body.

17. **`quote_splice_type_ident_test.av`** — covers probe 3. Splice a string as a type identifier and verify the generated fn typechecks.

18. **`quote_iteration_splice_test.av`** — covers probe 4. If iteration splice landed, test it. If the agreed workaround was "build the list outside and splice once", test the workaround pattern instead and document in the test header why this is the chosen idiom.

### Regression: existing tests must still pass

- All of `bootstrap/packages/std-avrac/src/features/comptime/tests/*.av` (currently passing).
- `bootstrap/packages/std-avrac/src/features/quote_expr/tests/*.av`.
- `bootstrap/packages/std-avrac/src/features/marshal/tests/*.av` (marshal pattern unaffected — confirms the pre-resolve compiler-pass path still works).
- `bootstrap/packages/std-avrac/src/resolve/tests/*.av` (resolver refactor must not break existing behaviour).
- Full bootstrap test suite (current baseline: 2462+ passing).

---

## Verification

After all the above lands:

```bash
cd bootstrap
make build               # passes
make update-seed         # passes; selfhost fixed point holds

# The pipeline-fix probe:
cat > /tmp/probe_pipeline.av <<'EOF'
use @std.avrac.core.{Stmt, SStmt, ParamEntry, TypeParamEntry, ValueType}
@comptime
fn build_simple_fn() -> Stmt {
    let empty_body: List<SStmt> = []
    let empty_params: List<ParamEntry> = []
    let empty_tp: List<TypeParamEntry> = []
    Stmt.Function("_gen", empty_tp, empty_params, ValueType.Unknown, empty_body)
}
@expand(build_simple_fn)
fn placeholder() {}

fn main() {
    _gen()
    println("ok")
}
EOF
build/bs2 compile /tmp/probe_pipeline.av    # exits 0
cc /tmp/probe_pipeline.av.ll build/runtime.o -o /tmp/probe_pipeline
/tmp/probe_pipeline                          # prints "ok"

# The full test suite:
build/bs2 test           # 2462+ tests pass, none failed
```

If the probe outputs "ok" and the test suite passes, the work is done.

---

## What NOT to touch

- **`features/marshal/derive.av`** — works correctly via the pre-resolve compiler-pass pattern. Don't try to convert it as part of this work.

- **`expand_macros_multi_stmt`** (commit `98e32334`) — separately landed, works correctly. Don't revert.

- **`@comptime` fold logic** (`features/comptime/eval.av:try_fold_call`, `run_comptime`) — only `expand_macros` ordering changes. `run_comptime`'s position relative to typecheck stays.

- **Existing walker source files** (`features/generics/mono.av`, `codegen/escape.av`, `features/closures/codegen.av`, `desugar/mod.av`, etc.). These will be touched in a future session by a different agent. Don't preemptively refactor them.

- **The hand-rolled compiler-internal derive pattern as a whole.** This work makes the `@expand` surface viable for *user-level* macros that introduce decls. Compiler-internal derives (marshal, future ones) may or may not switch later — that's a separate decision for a future session.

- **Don't write any macros that USE the new infrastructure.** The point of this session is to build the infrastructure and prove it works via tests. The first consumer-of-this-infrastructure macro will be written in a later session.

---

## Related commits

- `98e32334` — `feat(comptime): @expand macros can return List<SStmt>` — independent improvement to `expand_macro.av`, already landed. Useful context but unrelated to the pipeline fix.

## Related beads tickets

- `forge-crafting-intepreters-qa6i` — the @expand pipeline ordering bug — references this doc.

---

## Glossary for context-fresh agent

- **`@comptime fn`** — fn that runs at compile time, evaluated by the bundled tree-walking interpreter (`features/eval/`).
- **`@expand(name)`** — annotation that applies a `@comptime` fn to a decl, replacing that decl with the macro's output.
- **`quote stmt { ... }`** / **`quote stmts { ... }`** / **`quote { ... }`** / **`quote type { ... }`** / **`quote decl { ... }`** — syntactic capture of AST as a runtime value. Kinds defined in `features/quote_expr/grammar.md`.
- **`~expr`** — splice: insert a runtime value into a quoted body.
- **Pre-resolve pass** — a compiler pass that runs before `resolve_names`. Has plain AST access, no eval, no resolved names yet. Marshal lives here.
- **`construct_stmt(s) -> Expr`** in `features/quote_expr/lower.av` — encodes a Stmt as an Expr that, when evaluated, rebuilds the original. Used to box Stmt args into Values for macro invocation.
- **`value_to_stmt(v) -> Stmt?`** in `features/comptime/eval.av` — decodes a Value back into a real Stmt.
- **`value_to_stmt_list(v) -> List<SStmt>?`** — same for a list (introduced by `98e32334`).
- **`AnnotatedDecl`** (NEW, build in this work) — bundles the unwrapped decl, the `@expand` annotation, and the decl's canonical path. Passed as the first arg of 2-arg `@expand` macros.
- **`ResolverCtx`** (NEW, build in this work) — opaque handle the macro receives as its second arg. A struct holding only an opaque `id: int`. All queries are free fns (`ctx_lookup_type`, `ctx_qualify_ident`, `ctx_fresh_ident`, `ctx_unwrap_path_to`, `ctx_current_module`) dispatched through `extern fn` to compiler-side code. Same pattern as how `Runtime` is threaded through `features/eval/`.
- **`ResolvedDecls`** (NEW, build in this work) — macro return type. Carries `decls`, `introduces` (symbols added to parent scope), `provenance` (trace back to macro definition).
- **`ctx_unwrap_path_to(ctx, t, target)`** (NEW) — returns the field-access chain to dig from `t` to a value of type `target`. BFS over the field graph; depth-capped at 8 for cycle safety.
- **`from_macro` flag** (NEW) — bool field on SStmt set by the splicer; the partial re-resolve walks only stmts with this flag set. Adding it requires `make seed-patch-traps` + `make build` + `make update-seed` per the `CLAUDE.md` "fields on existing variants" workflow.
- **`ExpandPlan`** (NEW, internal to expand_macros) — `{ targets: List<ExpandTarget> }` where each `ExpandTarget` is `{source_file, source_line, source_col, macro_name}`. Produced by `expand_macros_collect`, consumed by `expand_macros_eval` via source-span matching (not list-index matching).

---

## Quick reference: where everything lives

| Concept | File |
|---|---|
| Encoder gap fix (`construct_stmt EnumDecl` arm, `construct_variant_list`) | `features/quote_expr/lower.av` |
| Decoder gap fix (`enum_value_to_stmt EnumDecl` arm, `enum_value_to_value_type` non-primitive arms) | `features/comptime/eval.av` |
| Pipeline-fix changes | `features/comptime/expand_macro.av`, `cli/src/main.av`, `resolve/names.av`, `core/ast.av` (from_macro field) |
| `ResolverCtx` opaque handle + extern decls | `features/comptime/resolver_ctx.av` (new) |
| `ResolverCtx` extern fn implementations | `features/comptime/expand_macro.av` (or sibling) + extern table wiring |
| `AnnotatedDecl` / `ResolvedDecls` / `DeclSymbol` types | `features/comptime/macro_types.av` (new) |
| Quote-surface fixes (only those that fail probes) | `features/quote_expr/parser.av`, `features/quote_expr/lower.av`, `features/comptime/eval.av` codec arms |
| All new tests | `features/comptime/tests/*.av` (≤18 new files — see Test plan) |

### Test count baseline

Current passing suite: **2462** (pre-this-work). Expect roughly +18 from this work (10 pipeline-fix + 4 ResolverCtx + up to 4 quote-surface). Post-this-work floor: **≥ 2477**. The pre-commit hook will block any net regression; if it does, fix forward — do not skip the hook.
