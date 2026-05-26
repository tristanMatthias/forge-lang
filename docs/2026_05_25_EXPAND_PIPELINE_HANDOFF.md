# `@expand` infrastructure prework — handoff

**Status:** open · **Beads:** `forge-crafting-intepreters-qa6i`

---

## Scope of THIS work

Build the macro-system infrastructure so that, after this lands, a follow-up session can write `@comptime` macros that introspect the surrounding scope and emit new top-level declarations.

**In scope:**
1. Fix the pipeline-order bug below (Option C).
2. Add the `ResolverCtx` / `AnnotatedDecl` / `ResolvedDecls` types and wire them through `invoke_macro`.
3. Add the missing quote-surface bits listed in section "Required quote-surface additions".
4. All tests below must pass; selfhost fixed point holds.
5. Commit + push.

**Out of scope:**
- Writing any actual macro that uses this infrastructure. Don't.
- Touching any walker / desugar / resolver / mono source files (`features/generics/mono.av`, `codegen/escape.av`, `features/closures/codegen.av`, `desugar/mod.av`, `features/comptime/rewrite.av`, `resolve/names.av` rewrite_expr arms, etc.). The infrastructure must be testable on its own — these will be touched in a later session by a different agent.
- Converting `features/marshal/derive.av` from its existing pre-resolve compiler-pass pattern to use `@expand`. Marshal stays as-is for this work.
- Performance optimisation. Make it correct first; perf can be tuned later by someone with the empirical data.

**Done signal:** all the verification probes in this doc compile, run, and produce the expected output. The bootstrap test suite passes. The selfhost fixed point holds (`make update-seed` succeeds and `bs2` ≡ `bs3`).

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

## Implementation plan: Option C pipeline fix

### Files that will change

- `bootstrap/packages/std-avrac/src/features/comptime/expand_macro.av` — split into collect + eval phases.
- `bootstrap/packages/cli/src/main.av` — update pipeline order at every site that runs the four-pass sequence (`derive_marshal` → `resolve_names` → `expand_macros`). Four call sites: lines ~3317, ~3400, ~3430, ~3695.
- `bootstrap/packages/std-avrac/src/resolve/names.av` — refactor `resolve_names` into `register_decls` + `rewrite_uses` so the partial re-resolve can call `register_decls` with the existing registry and `rewrite_uses` over just the newly-spliced stmts.
- `bootstrap/packages/std-avrac/src/features/comptime/grammar.md` — update pipeline section.
- `bootstrap/packages/std-avrac/src/core/ast.av` — add `from_macro: bool` field on `SStmt` (or maintain a side-channel `Set<SStmt-id>` returned from the splicer — pick one, doc the choice).

### Step-by-step

1. **Audit `resolve_names`** for what's per-stmt vs per-program. Document the side effects of each step.

2. **Refactor `resolve_names` into two halves:**
   - `register_decls(stmts, registry) -> registry` — pure decl scan, populates the registry.
   - `rewrite_uses(stmts, registry) -> stmts` — rewrites Idents to QualifiedIdent given a fixed registry.

   Current `resolve_names` becomes `let r = register_decls(stmts, new_registry()); rewrite_uses(stmts, r)`. Existing tests must still pass after this refactor *alone* — land the refactor as its own commit before moving on.

3. **Split `expand_macros`** into:
   - `expand_macros_collect(stmts) -> ExpandPlan` — walks stmts collecting (target_stmt_position, macro_name) pairs. Returns the plan; stmts unchanged.
   - `expand_macros_eval(stmts, plan, reg) -> List<SStmt>` — evaluates each macro and splices results. Tags inserted SStmts.

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

```av
// WHY: sealed read-only handle macros use to query the resolver
// from inside @comptime evaluation. Implemented as an opaque
// pointer + a dispatch table of extern fns — same shape as how
// Runtime is passed through eval today.

use @std.avrac.core.{TypeKind, ValueType}

/// Sealed handle to a specific resolution scope. Macros receive one
/// per invocation, scoped to where the annotated decl lives. All
/// operations are pure queries — the macro CANNOT mutate the
/// resolver, only ask questions of it.
export type ResolverCtx = {
    /// Module the annotated decl lives in (e.g. "@std::avrac::core").
    current_module: string,

    /// Look up a type by source-level name, qualifying through the
    /// active scope's imports. Returns the canonical resolved type
    /// or null if unknown.
    lookup_type: fn(name: string) -> ResolvedType?,

    /// Resolve an identifier the same way Expr.Ident would resolve
    /// at this scope. Returns the QualifiedIdent path or null.
    qualify_ident: fn(name: string) -> string?,

    /// Synthesise a fresh identifier guaranteed not to collide with
    /// any name visible in this scope. Hygiene baked in.
    fresh_ident: fn(hint: string) -> string,

    /// Returns the field-access chain to dig from a wrapper type
    /// down to a target type. E.g. if `t` is a struct `Wrapper { x: Target }`
    /// then unwrap_path_to(t, "Target") returns ["x"]. If `t` is
    /// `Wrapper { y: Inner { z: Target } }` returns ["y", "z"].
    /// Returns [] when no path exists or t IS target.
    /// BFS over the field graph of `t` looking for `target`.
    unwrap_path_to: fn(t: ResolvedType, target: string) -> List<string>,
}

/// A resolved type — name + kind + structure already canonicalised.
export type ResolvedType = {
    canonical_name: string,
    kind: TypeKind,
    /// Populated for struct types.
    fields: List<ResolvedField>?,
    /// Populated for enum types.
    variants: List<ResolvedVariant>?,
}

export type ResolvedField = { name: string, ty: ResolvedType }
export type ResolvedVariant = { name: string, fields: List<ResolvedField> }
```

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

#### Probe 5: Dynamic enum-ctor name

```av
@comptime
fn build(variant_name: string) -> Expr {
    Expr.EnumCtor("@my::Type", variant_name, [])
}
```

Building EnumCtor with a dynamic variant name should work via direct `Expr.EnumCtor` construction. Test. If it works, no quote-surface change needed; macros just use the constructor form for dynamic variants.

### Fix the gaps the probes find

For each probe that fails, add the missing capability. Each gets its own commit with its own test. Don't bundle.

---

## Test plan

All new tests live in `bootstrap/packages/std-avrac/src/features/comptime/tests/`. Each is a standalone `spec` test using the `cached_fixture_run` pattern (same shape as existing `expand_macro_*_test.av` files).

### Pipeline-fix tests (Option C)

1. **`expand_decl_introducing_test.av`** — the probe from the empirical-proof section above. Asserts `_gen()` is callable from main and runs at runtime.

2. **`expand_introduces_type_test.av`** — macro returning `Stmt.TypeDecl`. Asserts the synthesised type can be used in a `let` binding.

3. **`expand_introduces_enum_test.av`** — macro returning `Stmt.EnumDecl`. Asserts variants are matchable.

4. **`expand_introduces_impl_test.av`** — macro returning `Stmt.Impl`. Asserts methods are callable via dot-notation.

5. **`expand_multi_decl_test.av`** — macro returning `List<SStmt>` containing both a type and an impl. Asserts both are registered and the impl's methods work.

6. **`expand_nested_test.av`** — macro that returns code containing another `@expand` site. Asserts the inner expansion fires; recursion cap kicks in after 16 nested iterations with a clear error.

7. **`expand_body_eval_still_works_test.av`** — macro whose `@comptime` body calls a `use`-imported helper fn. Regression test that body-eval still has resolved names available after the split.

### `ResolverCtx` tests

8. **`resolver_ctx_lookup_type_test.av`** — macro calls `ctx.lookup_type("string")` and `ctx.lookup_type("MyLocalType")`. Asserts canonical names returned are correct.

9. **`resolver_ctx_qualify_ident_test.av`** — macro calls `ctx.qualify_ident("my_imported_fn")`. Asserts returned path matches what `Expr.Ident("my_imported_fn")` would resolve to in the same scope.

10. **`resolver_ctx_fresh_ident_test.av`** — macro requests `ctx.fresh_ident("x")` ten times. Asserts all ten are distinct and none collide with any name visible in the scope.

11. **`resolver_ctx_unwrap_path_test.av`** — exercises `unwrap_path_to`. Test cases:
    - `unwrap_path_to(SExpr, "Expr")` returns `["node"]`.
    - `unwrap_path_to(FieldInit, "Expr")` returns `["value", "node"]`.
    - `unwrap_path_to(string, "Expr")` returns `[]` (no path).
    - `unwrap_path_to(Expr, "Expr")` returns `[]` (already is target).
    - Cycle detection: type with a recursive field doesn't infinite-loop.

### Quote-surface tests

12. **`quote_arm_test.av`** — covers probe 1. Build a match arm via `quote arm` and splice it into a match.

13. **`quote_splice_arm_list_test.av`** — covers probe 2. Build a list of match arms outside the quote, splice the whole list.

14. **`quote_splice_type_ident_test.av`** — covers probe 3 if it required changes.

15. **`quote_iteration_splice_test.av`** — covers probe 4 if added.

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
fn main() { _gen(); println("ok") }
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
- **`ResolverCtx`** (NEW, build in this work) — sealed read-only handle the macro receives as its second arg. Exposes `lookup_type`, `qualify_ident`, `fresh_ident`, `unwrap_path_to`. Implemented as opaque pointer + extern-fn vtable.
- **`ResolvedDecls`** (NEW, build in this work) — macro return type. Carries `decls`, `introduces` (symbols added to parent scope), `provenance` (trace back to macro definition).
- **`unwrap_path_to(t, target)`** (NEW) — `ctx` method returning the field-access chain to dig from `t` to a value of type `target`. BFS over the field graph.
- **`from_macro` flag** (NEW) — bool field on SStmt set by the splicer; the partial re-resolve walks only stmts with this flag set.
- **`ExpandPlan`** (NEW, internal to expand_macros) — list of `(target_position, macro_name)` pairs produced by `expand_macros_collect`, consumed by `expand_macros_eval`.

---

## Quick reference: where everything lives

| Concept | File |
|---|---|
| Pipeline-fix changes | `features/comptime/expand_macro.av`, `cli/src/main.av`, `resolve/names.av`, `core/ast.av` (from_macro field) |
| `ResolverCtx` impl + extern dispatch | `features/comptime/resolver_ctx.av` (new) |
| `AnnotatedDecl` / `ResolvedDecls` / `DeclSymbol` types | `features/comptime/macro_types.av` (new) |
| Pipeline-fix tests | `features/comptime/tests/expand_*_test.av` (new — 7 tests) |
| `ResolverCtx` tests | `features/comptime/tests/resolver_ctx_*_test.av` (new — 4 tests) |
| Quote-surface tests | `features/comptime/tests/quote_*_test.av` (new — up to 4 tests) |
| Quote-surface fixes | `features/quote_expr/parser.av`, `features/quote_expr/lower.av`, `features/comptime/eval.av` codec arms |
