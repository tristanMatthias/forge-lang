# `@expand` pipeline ordering — handoff

**Status:** open · **Beads:** ticket from audit on 2026-05-25 · **Blocks:** `@walker` derive prototype.

---

## TL;DR

`@expand` macros that return decl-introducing `Stmt`s (Function, TypeDecl, EnumDecl, Impl) succeed at the macro layer but silently never reach codegen as usable declarations. Root cause: `expand_macros` runs *after* `resolve_names` in the bootstrap pipeline, so any new top-level decl a macro emits is never name-registered.

This document specifies what "perfect-world fix" looks like, how to verify it, and what NOT to touch.

---

## Empirical proof of the bug

Probe (paste into `/tmp/probe.av`, run `build/bs2 compile /tmp/probe.av`):

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
    println("ok")
}
```

Symptoms:
- The `@expand` pass runs (no warning, no error from invoke_macro).
- The macro return decodes successfully via `value_to_stmt`.
- The string `"_gen"` appears in the IR as a literal constant (from the encoded payload).
- **No `define i64 @_gen()` block is emitted.**
- The `_gen()` call site fails with `resolve error: undefined variable _gen` (line 16).

Same bug for any decl-introducing Stmt variant. `Stmt.Block`/`Stmt.Expr`/`Stmt.Return` work because they don't introduce names. `Stmt.Function`/`Stmt.TypeDecl`/`Stmt.EnumDecl`/`Stmt.Impl` all fail.

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

`resolve_names` walks the AST building the name table (functions/types/etc.). Once it finishes, `expand_macros` runs. By then the registry is closed. New decls emitted by `expand_macros` are visible in the AST but invisible to:
- The resolver (registry already built)
- The typechecker (consumes resolved names)
- The codegen (codegen looks up fns by qualified name)

So the macro output is a tree with a Function node in it that no other pass acknowledges.

### Why `expand_macros` is positioned where it is

From `features/comptime/grammar.md`:

> The two pieces are separate passes in the compile pipeline:
>   `resolve_names → expand_macros → run_comptime → typecheck`
> - **expand_macros** runs first. It walks for `@expand` declarations, evaluates each macro fn against its decl argument, and splices the resulting AST node in place.
> - **run_comptime** runs next. It folds every call to a `@comptime` fn with comptime-known arguments into the evaluated literal.

`expand_macros` runs after `resolve_names` because the macro's *body* (a `@comptime fn`) needs the eval runtime, and the runtime needs resolved names to invoke helper fns inside the macro body. Without resolution, `quote stmt { my_helper(x) }` inside a macro body can't find `my_helper`.

### Why the marshal pattern works

`features/marshal/derive.av` runs as `derive_marshal` BEFORE `resolve_names`. It's a plain Avra `fn(stmts: List<SStmt>) -> List<SStmt>` — not a `@comptime fn`. It directly inspects AST nodes, constructs new ones programmatically (`Stmt.Function(...)`, `Stmt.Impl(...)`, etc.), and inserts them as siblings in the stmt list. The resolver runs *after* and treats the synthesised decls identically to hand-written ones.

This is the proven, working pattern for compiler-internal derives. **It is not the bug.** Marshal is correct.

The bug is specifically about user-level `@expand` macros being unable to do the same.

---

## What "perfect-world fix" looks like

User code like the probe above should compile and run cleanly:

```av
@comptime
fn build_simple_fn() -> Stmt {
    Stmt.Function("_gen", ..., ..., ValueType.Unknown, [...body...])
}

@expand(build_simple_fn)
fn placeholder() {}

fn main() {
    _gen()         // resolves, type-checks, codegens, runs
}
```

And the same for `Stmt.TypeDecl`, `Stmt.EnumDecl`, `Stmt.Impl`. Plus multi-stmt returns from `quote stmts { ... }` (already landed in commit `98e32334`) — a single `@expand` site should be able to introduce many decls.

---

## Three architectural options

### Option A: Re-run `resolve_names` after `expand_macros`

```
parse → ... → resolve_names → expand_macros → resolve_names (again) → run_comptime → typecheck → ...
```

**Pros:** Simplest to describe. No new abstractions. The second resolve pass picks up any newly-emitted decls.

**Cons:** Cascades. `resolve_names` mutates a `type_registry`, populates aliases, qualifies idents — all of these now run twice. Some of that work is idempotent; some isn't. Specifically:
- The type registry (`TypeRegistry` in `core/ast.av`) accumulates entries. Second run may double-register types declared in the original source.
- Qualified-name rewriting: an `Ident("foo")` that became `QualifiedIdent("@pkg::mod::foo")` in pass 1 shouldn't be re-rewritten in pass 2. The resolver doesn't have a "skip already-qualified" path today.
- Module-resolution / `use` handling has side effects on the module graph; running twice may emit duplicate diagnostics or hit cached state inconsistently.

**Effort estimate:** Significant. Requires either making `resolve_names` fully idempotent (large audit) or splitting it into "scan-decls" and "rewrite-uses" phases so only the scan-decls part re-runs.

**Risk:** Medium-high. Any subtle non-idempotency surfaces as obscure typeck/codegen failures.

### Option B: Move `expand_macros` BEFORE `resolve_names`

```
parse → ... → expand_macros → resolve_names → run_comptime → typecheck → ...
```

**Pros:** No double-pass. Generated decls flow through resolve_names like hand-written ones (the marshal pattern, but for user macros).

**Cons:** The macro *body* now runs without resolved names. `quote stmt { my_helper(x) }` inside a macro body would have `my_helper` as a bare `Ident` instead of a `QualifiedIdent`. The eval runtime in `run_comptime`/`expand_macros` looks up `@comptime` fns by qualified name today — it would have to fall back to unqualified lookup, or some other resolution-light scheme would need to run.

Specifically, `comptime_lookup` in `features/comptime/registry.av` is keyed on the resolved qualified name. `collect_comptime_fns` populates the registry from already-resolved decls.

**Effort estimate:** Medium. Requires either:
- Pre-resolving JUST the `@comptime` fn names (so the registry lookup works) before expand_macros, leaving the macro body's idents unresolved until the main resolver runs. The body would then have to be re-walked when it ends up in the spliced output.
- Or running expand_macros twice: once before resolve_names for the trivial cases, once after for body-eval-dependent cases. Confusing.

**Risk:** Medium. The macro-body-resolution dance is the tricky part.

### Option C: Split into pre- and post-resolve phases (RECOMMENDED)

```
parse → ... → expand_macros_collect → resolve_names → expand_macros_eval → ...
```

`expand_macros_collect`: pre-resolve. Walks for `@expand` annotations, captures the (target_stmt, macro_name) pairs, but DOES NOT yet evaluate. Optionally drops placeholder bodies (since the user wrote `fn placeholder() {}` as a syntactic anchor that's about to be replaced).

`resolve_names`: runs as today.

`expand_macros_eval`: post-resolve. Evaluates each captured macro with its now-resolved registry. Splices the result back into the stmt list. Then **a partial re-resolve runs over just the spliced output** — which is tractable because the spliced output is a small, identifiable subset of the AST.

**Pros:**
- Macro bodies see resolved names (eval works).
- Generated decls go through name resolution (so `_gen()` call sites resolve).
- The split makes the dependency explicit instead of hidden in pipeline order.

**Cons:**
- Two passes for `expand_macros` (small code complexity bump).
- The "partial re-resolve over spliced output" needs a clear boundary — the splicer must tag the inserted SStmt nodes so the re-resolve knows what to walk.

**Effort estimate:** Medium. Each phase is small; the new piece is the partial re-resolve which is bounded.

**Risk:** Low. Each phase is independently testable. Failure modes are localised.

---

## Recommended path: Option C

Reasoning:
1. Doesn't break the macro-body-eval dependency (B's hardest problem).
2. Doesn't require full resolver idempotency (A's hardest problem).
3. The "phase 1: collect; phase 2: eval+splice; phase 3: partial re-resolve" decomposition mirrors how compilers handle generic instantiation and other deferred-resolution patterns.
4. Each phase can be tested in isolation.

---

## Detailed implementation plan (Option C)

### Files that will change

- `bootstrap/packages/std-avrac/src/features/comptime/expand_macro.av` — split into collect + eval phases. Currently does both in one walk.
- `bootstrap/packages/cli/src/main.av` — update pipeline order at every `derive_marshal` + `resolve_names` + `expand_macros` site (4 call sites, ~lines 3317, 3400, 3430, 3695).
- `bootstrap/packages/std-avrac/src/resolve/names.av` — add a `resolve_names_incremental(stmts: List<SStmt>, existing_registry: TypeRegistry) -> ResolveResult` entry point that re-resolves only the new stmts without re-registering already-known names. Or extract a `register_decls(stmts, registry)` sub-step that can be called twice.
- `bootstrap/packages/std-avrac/src/features/comptime/grammar.md` — update pipeline section.

### Step-by-step

1. **Audit `resolve_names`** for what's per-stmt vs per-program. Sketch which steps could re-run safely. Output: a tagged list (e.g. "type registry: accumulate-safe", "alias resolution: per-module, re-run safe", "QualifiedIdent rewriting: per-Ident, idempotent if already qualified").

2. **Refactor `resolve_names` into two halves:**
   - `register_decls(stmts, registry) -> registry` — pure decl scan, populates the registry.
   - `rewrite_uses(stmts, registry) -> stmts` — rewrites Idents to QualifiedIdent given a fixed registry.
   The current `resolve_names` becomes `let r = register_decls(stmts, new_registry()); rewrite_uses(stmts, r)`.

3. **Split `expand_macros`** into:
   - `expand_macros_collect(stmts) -> ExpandPlan` — walks stmts collecting (target_stmt_position, macro_name) pairs. Returns the plan; stmts unchanged.
   - `expand_macros_eval(stmts, plan, reg) -> List<SStmt>` — evaluates each macro and splices results. Tags inserted SStmts via a new field or a side-channel set.

4. **Wire pipeline:**
   ```
   parse → ... → derive_marshal
        → (expand_macros_collect)    // gather targets, don't evaluate
        → resolve_names              // unchanged
        → expand_macros_eval(plan)   // now has resolved names + macro fns
        → register_decls(spliced_only, existing_registry)
        → rewrite_uses(spliced_only, registry)
        → run_comptime → typecheck → ...
   ```

5. **Tag spliced SStmts.** Add a boolean flag on SStmt (e.g. `from_macro: bool`) OR maintain a `Set<SStmt-id>` set returned alongside the spliced output. The post-expand resolver walks only flagged stmts. The flag/set is stripped before downstream passes that don't care.

6. **Verify nested @expand.** A macro that returns code containing another `@expand` should expand recursively. Today this works because all expansion runs in one pass; with the split, the second expand_macros_eval pass needs to either iterate to fixpoint or explicitly forbid nested @expand.

### Test plan

**New tests** in `bootstrap/packages/std-avrac/src/features/comptime/tests/`:

1. `expand_decl_introducing_test.av` — the probe from above (macro returning `Stmt.Function`). Asserts `_gen()` is callable from main, returns expected value, runs at runtime.

2. `expand_introduces_type_test.av` — macro returning `Stmt.TypeDecl`. Asserts the synthesised type can be used in a `let` binding.

3. `expand_introduces_enum_test.av` — macro returning `Stmt.EnumDecl`. Asserts variants are matchable.

4. `expand_multi_decl_test.av` — macro returning `List<SStmt>` containing a type AND an impl. Asserts both are registered.

5. `expand_nested_test.av` — macro that returns code containing another `@expand` site. Asserts the inner expansion fires.

6. `expand_body_eval_still_works_test.av` — macro whose `@comptime` body calls a `use`-imported helper fn. Regression test that body-eval still has resolved names available.

**Existing tests that must still pass:**
- All of `bootstrap/packages/std-avrac/src/features/comptime/tests/*.av` (currently passing).
- `bootstrap/packages/std-avrac/src/features/marshal/tests/*.av` (marshal pattern unaffected).
- Full bootstrap test suite (2462+/2462+).

### Verification

After the fix:

```bash
cd bootstrap
make build               # passes
make update-seed         # passes
build/bs2 compile /tmp/probe.av     # exits 0
cc /tmp/probe.av.ll build/runtime.o -o /tmp/probe
/tmp/probe               # prints "ok"
build/bs2 test           # 2462+/2462+
```

The probe at the top of this doc should compile and run cleanly. That's the deterministic "done" signal.

---

## What NOT to touch

- **`features/marshal/derive.av`** — works correctly via the pre-resolve compiler-pass pattern. Don't try to convert it to use `@expand` as part of this work. The two patterns are legitimately separate use cases (compiler-internal vs user-level).

- **`expand_macros_multi_stmt`** (commit `98e32334`) — separately landed, works correctly. Don't revert. The multi-stmt return support is orthogonal to the pipeline-order fix.

- **`@comptime` fold logic** (`features/comptime/eval.av` `try_fold_call`, `run_comptime`) — only `expand_macros` ordering changes. `run_comptime`'s position relative to typecheck stays.

- **The marshal-style compiler-internal derive pattern as a whole.** Any future compiler-internal derive (walker, hash, eq, etc.) should also use the marshal pattern, not `@expand`. The `@expand` fix is to make user-level macros viable, not to replace the compiler-internal pattern.

---

## After this lands, the picking-up agent should:

1. Verify the probe in this doc compiles and runs.
2. Switch to a fresh branch.
3. Implement `derive_walker` as a `@comptime fn` + `@expand` pattern (the original target). The walker will inspect an enum's variants and emit children/fold/map/visit methods.
4. Mark `Expr` / `Stmt` / `Pattern` / `ValueType` with `@expand(derive_walker)` (or whatever the chosen marker is).
5. Refactor the ~12 hand-rolled walkers across the codebase to use the generated `.fold()` / `.map()` / `.visit()` methods.

Until this lands, `derive_walker` would have to use the marshal-style pre-resolve pass — which works, but doesn't validate the `@expand` surface as the long-term answer for derives.

---

## Related commits in the same session

- `98e32334` — `feat(comptime): @expand macros can return List<SStmt>` — independent improvement to expand_macro.av, no overlap with the pipeline fix.

## Related beads tickets

- The ticket filed concurrently with this doc — references this doc for full context.

---

## Glossary for context-fresh agent

- **`@comptime fn`** — fn that runs at compile time, evaluated by the bundled tree-walking interpreter (`features/eval/`).
- **`@expand(name)`** — annotation that applies a `@comptime` fn to a decl, replacing that decl with the macro's output.
- **`quote stmt { ... }`** / **`quote stmts { ... }`** / **`quote { ... }`** — syntactic capture of AST as a runtime value (Stmt / List<SStmt> / Expr).
- **`~expr`** — splice: insert a runtime value into a quoted body.
- **Pre-resolve pass** — a compiler pass that runs before `resolve_names`. Has plain AST access, no eval, no resolved names yet. Marshal lives here.
- **`construct_stmt(s) -> Expr`** in `features/quote_expr/lower.av` — encodes a Stmt as an Expr that, when evaluated, rebuilds the original. Used to box Stmt args into Values for macro invocation.
- **`value_to_stmt(v) -> Stmt?`** in `features/comptime/eval.av` — decodes a Value (produced by macro eval) back into a real Stmt.
