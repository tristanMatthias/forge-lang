# `@expand` pipeline ordering — handoff

**Status:** open · **Beads:** `forge-crafting-intepreters-qa6i` · **Blocks:** `@walker` derive prototype.

---

## TL;DR

`@expand` macros that return decl-introducing `Stmt`s (Function, TypeDecl, EnumDecl, Impl) succeed at the macro layer but silently never reach codegen as usable declarations. Root cause: `expand_macros` runs *after* `resolve_names` in the bootstrap pipeline, so any new top-level decl a macro emits is never name-registered.

This document specifies what "perfect-world fix" looks like, how to verify it, and what NOT to touch.

The end-state target is **derive_walker** — a macro that auto-generates `children/fold/map/visit/find/any` methods on any AST enum, replacing ~1500 lines of hand-rolled, bug-prone walker recursion across the bootstrap with one ~80-line macro plus 6 method invocations.

---

## Target end-state (what success looks like)

After this work lands, the entire walker-bug class is solved by:

```av
@expand(derive_walker)
enum Expr {
    Number(value: string)
    Binary(left: Expr, op: BinOp, right: Expr)
    Call(callee: Expr, args: List<SExpr>)
    StructLit(name: string, inits: List<FieldInit>)
    // ...30 more variants...
}
```

That single annotation generates `impl Expr { fn children, fn fold, fn map, fn visit, fn find, fn any }` with provably-correct recursion. Every walker in the bootstrap (mono x3, escape, find_captures, desugar, comptime, resolver, etc.) collapses to a 6-line use of `.fold()` / `.map()` / `.visit()`. Adding a new `Expr` variant tomorrow just re-runs `derive_walker`; no walker source file needs edits.

The same pattern applies to `Stmt`, `Pattern`, `ValueType`, and any future AST enums.

**Key design: implicit `ResolverCtx` — zero ceremony at the use site.** Every `@expand` macro receives an implicit `ctx: ResolverCtx` scoped to the surrounding decl's resolution context. The user never declares `@requires_scope(...)` or similar. The compiler infers macro dependencies automatically from which `ctx` methods the macro calls during expansion.

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

## Implicit `ResolverCtx` (no `@requires_scope` ceremony)

The end-state design has **zero ceremony at the use site**. The user writes only `@expand(derive_walker)` — never `@requires_scope(...)` or anything similar. The macro receives an implicit `ctx: ResolverCtx` whose scope is the surrounding decl's resolution context.

The compiler builds a dependency DAG between macros automatically by inspecting which `ctx` methods each macro calls during expansion. Macros that don't query the resolver run first; macros that do run after their dependencies are resolved. Cycles error with a clear "macro X queries scope that includes macro Y's output which queries X" diagnostic.

This is part of Phase 2 (the derive_walker step), NOT part of the pipeline fix. The pipeline fix (Option C above) gives us the *capability* to run macros and re-resolve their output; the implicit-ctx design layers on top.

---

## Phase 2: derive_walker design (the thing this fix unblocks)

Once the pipeline fix is in, write `derive_walker` as a `@comptime fn` that takes the implicit ctx. The full macro is ~80 LOC.

### Target macro file: `bootstrap/packages/std-avrac/src/features/walker/derive.av`

```av
// WHY: @derive_walker — auto-generates children/fold/map/visit/find/any
// methods on any AST enum. Replaces ~1500 LOC of hand-rolled walker
// recursion across the bootstrap with one macro + 6 method invocations.
//
// The walker bug class (mono / escape / closures / desugar / resolver /
// comptime each had wildcards hiding sub-expressions) becomes impossible
// by construction — adding a new variant to Expr just re-runs this
// macro, every walker downstream picks it up automatically.

use @std.avrac.core.{Stmt, SStmt, Expr, Variant, VariantField, MatchArm, Pattern}
use @std.avrac.comptime.{AnnotatedDecl, ResolverCtx, ResolvedDecls, ResolvedType, method_symbol, trace_from}

@comptime
fn derive_walker(target: AnnotatedDecl, ctx: ResolverCtx) -> ResolvedDecls {
    let e = unwrap_enum(target.stmt)
    let T = ctx.qualify_ident(e.name)!

    let children_arms = e.variants.map(v -> children_arm(v, T, ctx))
    let map_arms      = e.variants.map(v -> map_arm(v, T, ctx))

    let impl_block = quote stmt {
        impl ~T {
            fn children(self) -> List<~T> { match self { ~children_arms } }
            fn map(self, f: fn(~T) -> ~T) -> ~T {
                let rebuilt = match self { ~map_arms }
                f(rebuilt)
            }
            fn fold<S>(self, init: S, step: fn(~T, S) -> S) -> S {
                mut acc = step(self, init)
                for c in self.children() { acc = c.fold(acc, step) }
                acc
            }
            fn visit(self, f: fn(~T)) {
                f(self)
                for c in self.children() { c.visit(f) }
            }
            fn find(self, p: fn(~T) -> bool) -> ~T? {
                if p(self) { return self }
                for c in self.children() { let r = c.find(p); if r != null { return r } }
                null
            }
            fn any(self, p: fn(~T) -> bool) -> bool {
                if p(self) { return true }
                for c in self.children() { if c.any(p) { return true } }
                false
            }
        }
    }

    ResolvedDecls {
        decls: [target.stmt, impl_block],
        introduces: ["children","map","fold","visit","find","any"]
            .map(n -> method_symbol(T, n)),
        provenance: trace_from(target, "derive_walker"),
    }
}

// ── Per-variant arm builders (the only parts that vary by enum) ──

enum ChildShape {
    None             // not a child (scalar / unrelated type)
    Direct           // field IS the enum being walked
    ListDirect       // List<Self>
    ListWrapped      // List<W> where W wraps Self (one indirection)
    ListDoubleWrapped // List<W2> where W2 wraps W wraps Self (two indirections)
}

type FieldBinding = { kind: ChildShape, binding: string, unwrap_path: List<string> }

fn classify(f: VariantField, T: string, ctx: ResolverCtx) -> FieldBinding {
    let t = ctx.lookup_type(f.type_source_name)
    if t == null { return FieldBinding { kind: .None, binding: "_", unwrap_path: [] } }
    if t!.canonical_name == T { return FieldBinding { kind: .Direct, binding: f.name, unwrap_path: [] } }
    if t!.kind is .List {
        let elem = list_elem(t!)
        if elem.canonical_name == T { return FieldBinding { kind: .ListDirect, binding: f.name, unwrap_path: [] } }
        let path = ctx.unwrap_path_to(elem, T)
        if path.length == 1 { return FieldBinding { kind: .ListWrapped, binding: f.name, unwrap_path: path } }
        if path.length == 2 { return FieldBinding { kind: .ListDoubleWrapped, binding: f.name, unwrap_path: path } }
    }
    FieldBinding { kind: .None, binding: "_", unwrap_path: [] }
}

fn children_arm(v: Variant, T: string, ctx: ResolverCtx) -> MatchArm {
    let binds = v.fields.map(f -> classify(f, T, ctx))
    let pat = pattern_for(v.name, binds)
    let body = quote { {
        mut out: List<~T> = []
        ~for b in binds {
            match b.kind {
                .Direct           -> quote { out.push(~b.binding) }
                .ListDirect       -> quote { for e in ~b.binding { out.push(e) } }
                .ListWrapped      -> quote { for e in ~b.binding { out.push(unwrap_one(e, ~b.unwrap_path)) } }
                .ListDoubleWrapped-> quote { for e in ~b.binding { out.push(unwrap_two(e, ~b.unwrap_path)) } }
                .None             -> quote { }  // empty splice
            }
        }
        out
    } }
    MatchArm { pattern: pat, guard: null, body: sexpr_dummy(body) }
}

fn map_arm(v: Variant, T: string, ctx: ResolverCtx) -> MatchArm {
    let binds = v.fields.map(f -> classify(f, T, ctx))
    let pat = pattern_for(v.name, binds)
    let args = binds.map(b -> recurse_arg(b))
    let rebuild = ctor_expr(v.name, args)
    MatchArm { pattern: pat, guard: null, body: sexpr_dummy(rebuild) }
}

fn recurse_arg(b: FieldBinding) -> Expr {
    match b.kind {
        .None              -> Expr.Ident(b.binding)
        .Direct            -> quote { ~b.binding.map(f) }
        .ListDirect        -> quote { ~b.binding.map(c -> c.map(f)) }
        .ListWrapped       -> quote { ~b.binding.map(e -> rewrap_one(e, ~b.unwrap_path, e.~(b.unwrap_path[0]).map(f))) }
        .ListDoubleWrapped -> quote { ~b.binding.map(e -> rewrap_two(e, ~b.unwrap_path, e.~(b.unwrap_path[0]).~(b.unwrap_path[1]).map(f))) }
    }
}
```

Total: ~80 LOC. That's the entire walker derive. The `unwrap_one` / `unwrap_two` / `rewrap_one` / `rewrap_two` helpers live in a small stdlib module (~20 LOC each).

### Test plan for derive_walker (after pipeline fix)

`bootstrap/packages/std-avrac/src/features/walker/tests/`:

1. `walker_basic_test.av` — `@expand(derive_walker)` on a tiny `enum Tree { Leaf(int); Node(left: Tree, right: Tree) }`. Assert `tree.children()`, `tree.fold`, `tree.map`, `tree.visit`, `tree.find`, `tree.any` all behave correctly.

2. `walker_list_field_test.av` — variant with `List<Self>` field. Assert children() flattens correctly.

3. `walker_wrapper_test.av` — variant with `List<SExpr>` field. Assert ctx.unwrap_path detects the indirection and children() unwraps `.node`.

4. `walker_scalar_test.av` — variant with no self-typed fields. Assert children() returns `[]`.

5. `walker_recursive_visit_test.av` — depth-3 tree, visit collects all nodes in preorder.

6. `walker_map_preserves_scalars_test.av` — map should rebuild variants preserving non-self fields exactly.

7. `walker_provenance_test.av` — assert error in generated method points back at the macro definition (provenance smoke test).

---

## Phase 2 also requires: macro-surface additions

The slim `derive_walker` above assumes some `quote`/`ctx` infrastructure that may not exist yet in the bootstrap. Verify each and add what's missing:

### Quote-related (verify, may need adding)

- **`quote arm { ~pat -> ~body }`** — does a `quote` kind for match arms exist? `quote_expr/grammar.md` lists `expr | stmt | stmts | type | decl`. **Likely needs adding.** If not added, build MatchArm via `MatchArm { pattern, guard: null, body }` directly — verbose but works.

- **Splice inside a `for` loop body** within a quote: `~for b in binds { match b.kind { ... } }`. Means "execute Avra code at quote-expansion time and splice the resulting concatenated list of stmts." Different from a plain `~expr` splice. **Probably needs adding** — verify by writing a probe; if missing, build the list via explicit `mut out; for b in binds { out.push(...) }; out` outside the quote and `~splice` the final list.

- **`~T` splice for a type-position identifier** — currently splices work in expression and statement positions; verify they work as type-name spots. **Probably works** since the parser handles `~ident` uniformly, but confirm with a probe.

- **`.{v.name}(args)` dynamic variant-ctor syntax** — splicing a string as an enum variant name in `.Foo(...)` syntax. **Probably doesn't exist.** Workaround: build `Expr.EnumCtor("", v.name, args)` programmatically and splice that as a complete expression.

### Resolver-context additions (definitely needs adding)

The `ResolverCtx` interface used in the macro doesn't exist yet. Build it as a sealed read-only view over the resolver's state. Add to `bootstrap/packages/std-avrac/src/features/comptime/resolver_ctx.av`:

```av
export type ResolverCtx = {
    current_module: string,
    lookup_type: fn(name: string) -> ResolvedType?,
    qualify_ident: fn(name: string) -> string?,
    fresh_ident: fn(hint: string) -> string,
    is_recursive_with_target: fn(t: ResolvedType) -> bool,
    unwrap_path_to: fn(t: ResolvedType, target: string) -> List<string>,
        // Returns the field-access chain to dig from `t` to a value of
        // type `target`. E.g. for SExpr (which has .node: Expr) →
        // unwrap_path_to(SExpr, "Expr") = ["node"]. For FieldInit
        // (which has .value: SExpr which has .node: Expr) →
        // unwrap_path_to(FieldInit, "Expr") = ["value", "node"].
        // Returns [] when no path exists.
}

export type ResolvedType = {
    canonical_name: string,
    kind: TypeKind,
    fields: List<ResolvedField>?,
    variants: List<ResolvedVariant>?,
}
```

The implementation is thin: each method calls the existing resolver/type-registry data with appropriate sealing. `unwrap_path_to` is the only new logic — a BFS over the field graph of `t` looking for a field whose type is (or recurses through) `target`. ~30 LOC.

### `AnnotatedDecl` + `ResolvedDecls` types

Add to `bootstrap/packages/std-avrac/src/features/comptime/macro_types.av`:

```av
export type AnnotatedDecl = {
    stmt: Stmt,                 // the decl being annotated (unwrapped)
    annotation: Annotation,     // the @expand(name) annotation itself
    canonical_path: string,     // qualified path to the decl
}

export type ResolvedDecls = {
    decls: List<SStmt>,
    introduces: List<DeclSymbol>,
    provenance: MacroProvenance,
}

export type DeclSymbol = {
    name: string,
    kind: DeclKind,        // .Function / .Type / .Method(of: string)
    canonical_path: string,
}

export type MacroProvenance = {
    macro_name: string,
    target_canonical: string,
    target_source_span: Span,
}

export enum DeclKind { Function; Type; Impl; Method(of: string); Const }
```

Wire the `@expand` evaluator (`features/comptime/expand_macro.av:invoke_macro`) to:
1. Build `AnnotatedDecl` from the target stmt + the `@expand` annotation node.
2. Construct `ResolverCtx` from the active resolver state.
3. Pass both as 2-argument macro invocation.
4. Decode the `ResolvedDecls` return via a new `value_to_resolved_decls` decoder.

The encoder/decoder pair for `ResolverCtx` is special — it's not a plain Value, it's a *handle* the macro uses to call back into the compiler. Implement as an opaque pointer + a dispatch table of extern fns (similar to how `Runtime` is passed through in eval today).

---

## What NOT to touch

- **`features/marshal/derive.av`** — works correctly via the pre-resolve compiler-pass pattern. Convert it later (Phase 3) once `derive_walker` proves the `@expand` path works for compiler-internal derives. Don't touch in the pipeline-fix work.

- **`expand_macros_multi_stmt`** (commit `98e32334`) — separately landed, works correctly. Don't revert.

- **`@comptime` fold logic** (`features/comptime/eval.av` `try_fold_call`, `run_comptime`) — only `expand_macros` ordering changes. `run_comptime`'s position relative to typecheck stays.

- **Existing per-walker source files** (mono.av, escape.av, find_captures, desugar/mod.av, …). Phase 4 (refactoring to use `.fold()` etc.) is a separate later step. The pipeline fix and `derive_walker` should land first, prove out via the test suite, then walker refactoring is a mechanical cleanup that builds on a stable base.

---

## After this lands, the picking-up agent (me) should:

Sequence after qa6i lands:

1. **Verify** the probe at the top of this doc compiles and runs.
2. **Phase 2 sub-task A**: probe each item in "macro-surface additions" above to see what works vs needs adding. File one beads ticket per gap found.
3. **Phase 2 sub-task B**: add the `ResolverCtx` / `AnnotatedDecl` / `ResolvedDecls` types and wire them through `invoke_macro`.
4. **Phase 2 sub-task C**: implement `unwrap_path_to` in resolver_ctx.av (~30 LOC).
5. **Phase 2 sub-task D**: write `derive_walker` as in the spec above (~80 LOC).
6. **Phase 2 sub-task E**: write the 7 walker tests above; all must pass.
7. **Phase 3**: `@expand(derive_walker)` on `Pattern` first (smallest enum, validates end-to-end). Then `ValueType`, `Stmt`, `Expr`.
8. **Phase 4**: refactor each hand-rolled walker to use `.fold()` / `.map()` / `.visit()` — ~12 walkers, each ~5-15 LOC after refactor (down from 50-150 LOC each).
9. **Phase 5**: convert `marshal` from hand-rolled pre-resolve pass to `@expand(derive_marshal)` — proves the `@expand` path with a second derive, not just one.
10. **Phase 6**: full test suite, fixed-point check, dead-code removal of old walker source, commit + push.

Until qa6i lands, `derive_walker` could ship as a marshal-style pre-resolve compiler pass — which works, but doesn't validate the `@expand` surface as the long-term answer. The point of fixing qa6i first is making the `@expand` path the unified, working answer for both user-level and compiler-internal derives.

---

## Related commits in the same session

- `98e32334` — `feat(comptime): @expand macros can return List<SStmt>` — independent improvement to expand_macro.av, no overlap with the pipeline fix. Already lands the multi-stmt return capability `derive_walker` needs.
- `1703d913` — initial version of this handoff doc.
- (this commit) — extended doc with Phase 2 derive_walker spec, ResolverCtx design, macro-surface gap list, implicit-ctx model.

## Related beads tickets

- `forge-crafting-intepreters-qa6i` — the @expand pipeline ordering bug — references this doc for full context.

---

## Glossary for context-fresh agent

- **`@comptime fn`** — fn that runs at compile time, evaluated by the bundled tree-walking interpreter (`features/eval/`).
- **`@expand(name)`** — annotation that applies a `@comptime` fn to a decl, replacing that decl with the macro's output.
- **`quote stmt { ... }`** / **`quote stmts { ... }`** / **`quote { ... }`** — syntactic capture of AST as a runtime value (Stmt / List<SStmt> / Expr).
- **`~expr`** — splice: insert a runtime value into a quoted body. Used as `~T` to splice a type identifier, `~arms` to splice a list of MatchArms, etc.
- **Pre-resolve pass** — a compiler pass that runs before `resolve_names`. Has plain AST access, no eval, no resolved names yet. Marshal lives here today; with Option C, derive_walker will live in the @expand pipeline instead.
- **`construct_stmt(s) -> Expr`** in `features/quote_expr/lower.av` — encodes a Stmt as an Expr that, when evaluated, rebuilds the original. Used to box Stmt args into Values for macro invocation.
- **`value_to_stmt(v) -> Stmt?`** in `features/comptime/eval.av` — decodes a Value (produced by macro eval) back into a real Stmt.
- **`AnnotatedDecl`** (new, Phase 2) — what a macro receives as its first arg. Bundles the unwrapped decl, the `@expand(...)` annotation, and the decl's canonical path. Built by `invoke_macro`.
- **`ResolverCtx`** (new, Phase 2) — sealed read-only handle the macro receives as its second arg. Exposes `lookup_type`, `qualify_ident`, `fresh_ident`, `unwrap_path_to`. Implemented as an opaque pointer plus a dispatch table of extern fns (same shape as how `Runtime` is passed through eval today).
- **`ResolvedDecls`** (new, Phase 2) — what a macro returns. Carries `decls: List<SStmt>` (the post-resolve-ready output), `introduces: List<DeclSymbol>` (names registered with the parent scope), and `provenance: MacroProvenance` (trace back to the macro definition).
- **`unwrap_path_to(t, target)`** (new, Phase 2) — `ctx` method that returns the field-access chain to dig from a wrapper type to a value of `target`. Examples: `SExpr` → `["node"]`, `FieldInit` → `["value", "node"]`. Used by `derive_walker.classify` to detect wrapper-list shapes without hardcoding wrapper names.
- **Implicit ctx model** — every `@expand` macro receives a `ResolverCtx` for the surrounding decl's resolution scope automatically. The user writes only `@expand(name)`; no `@requires_scope(...)` ceremony. The dependency graph between macros is inferred from the `ctx` methods each macro actually calls during expansion.
- **ChildShape** (Phase 2, internal to derive_walker) — `.None` / `.Direct` / `.ListDirect` / `.ListWrapped` / `.ListDoubleWrapped`. How a variant field contributes to children() / map(). Computed by `classify`, dispatched in `children_arm` and `recurse_arg`.

---

## Quick reference: where everything lives after Phase 2

| Concept | File |
|---|---|
| Pipeline-fix changes | `features/comptime/expand_macro.av`, `cli/src/main.av`, `resolve/names.av` |
| `ResolverCtx` impl + extern dispatch | `features/comptime/resolver_ctx.av` (new) |
| `AnnotatedDecl` / `ResolvedDecls` / `DeclSymbol` types | `features/comptime/macro_types.av` (new) |
| `derive_walker` macro | `features/walker/derive.av` (new) |
| `unwrap_one` / `unwrap_two` / `rewrap_one` / `rewrap_two` helpers | `features/walker/helpers.av` (new) |
| walker tests | `features/walker/tests/walker_*_test.av` (new) |
| Pipeline-fix tests | `features/comptime/tests/expand_*_test.av` (new) |
