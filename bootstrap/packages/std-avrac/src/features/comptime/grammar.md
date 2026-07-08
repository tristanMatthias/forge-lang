# @comptime + @expand (compile-time evaluation + macro expansion)

## Syntax

```
comptime_attr  = "@comptime"
expand_attr    = "@expand" "(" expression ")"

comptime_fn    = comptime_attr fn_decl
expand_target  = expand_attr decl
```

`@comptime` annotates a function declaration; `@expand`
annotates any declaration whose AST should be replaced at
compile time by the result of evaluating the named macro
function.

## Semantics

### @comptime functions

A function annotated `@comptime` becomes evaluable at compile
time. When the compiler sees a call to such a function with
fully-known arguments (literals or other comptime values), it
evaluates the call via the bundled tree-walking interpreter
and substitutes the result into the AST. No runtime call
survives.

```avra
@comptime
fn double(n: int) -> int { n * 2 }

let four = double(2)  // codegen sees `let four = 4`
```

### @expand macros

A function annotated `@comptime fn` that returns an AST value
(via `quote { … }`) can serve as a macro. Apply it to a
declaration with `@expand(name)`:

```avra
@comptime
fn derive_show(stmt: Stmt) -> Stmt {
    quote stmt {
        impl ~type_name(stmt) {
            fn show(self) -> string { ... }
        }
    }
}

@expand(derive_show)
type User = { id: int, name: string }
```

The `@expand` pass walks the AST and replaces every annotated
declaration with the macro's evaluated output.

## Pipeline placement

`@expand` and `@comptime` are separate passes. The full
pipeline order is (per docs/2026_05_25_EXPAND_PIPELINE_HANDOFF.md
step 4 — Option C):

```
parse → resolve_module_files → expand_components → derive_marshal
     → expand_macros_collect              (pre-resolve target scan)
     → resolve_names_pre_expand           (register_decls + rewrite_uses)
     → expand_macros_eval(plan, state)    (fixpoint; tags spliced stmts)
     → register_macro_decls               (additive into existing state)
     → rewrite_uses_macro_only            (partial re-resolve)
     → validate_scopes_after_expand       (scope check on the merged AST)
     → run_comptime
     → typecheck
     → monomorphize
     → codegen
```

- **expand_macros_collect** runs pre-resolve. It scans for
  `@expand` annotations and records `(source_file, source_line,
  source_col, macro_name)` tuples — addressing is by source
  position, not list index, so a later pass that rewrites stmts
  in place doesn't invalidate the plan.
- **resolve_names_pre_expand** runs unchanged. Macro bodies see
  resolved names because eval needs the registry to invoke
  helper fns inside the macro.
- **expand_macros_eval** evaluates each captured macro, splices
  results, and tags every spliced statement with `from_macro`
  provenance (recorded in the arena side-table, keyed by `StmtId`).
  Runs to fixpoint (cap 16 iters) so a macro emitting another
  `@expand(...)` site expands transitively. Hitting the cap
  `exit(1)`s with a clean diagnostic.
- **register_macro_decls** additively augments the existing
  `ResolverState.graph` + `global_index` with the
  macro-introduced top-level decls. No fresh tree/alias rebuild,
  so pre-existing import diagnostics don't double-bag.
- **rewrite_uses_macro_only** walks only `from_macro == true`
  entries (recursing into Module bodies). Hand-written stmts
  keep their pre-expand rewrites.
- **run_comptime** runs next. It folds every call to a
  `@comptime` fn with comptime-known arguments into the
  evaluated literal. Fast-path: programs with zero `@comptime`
  fns short-circuit without walking the AST.

The `expand_macros` (legacy single-pass) surface remains as a
thin wrapper — `expand_macros_collect` then `expand_macros_eval`
— for call sites that don't have a `ResolverState` handy. The
state-less variant skips the per-iter resolver-data re-population,
which means 2-arg macros that call `ctx_qualify_ident` /
`ctx_lookup_type` on names introduced by an earlier iteration
won't see them; the state-aware `expand_macros_eval_with_state`
is the main pipeline's path.

Both passes pre-typecheck so the typechecker sees the
post-evaluation AST — no comptime nodes survive into the type
system or codegen.

## Why two passes

- `@expand` replaces a *declaration* with a different AST
  shape. It runs early so subsequent passes (resolver,
  typecheck) see the expanded form.
- `@comptime` folds *call sites* into literals. It runs after
  `@expand` because expanded code may itself contain
  comptime-call sites that should fold.

## Quoting + splicing

Macro bodies build their output via `quote { … }` (capture an
AST as a runtime value) and `~name` (splice a runtime AST
value into a quote body). See
`features/quote_expr/grammar.md` for the full quoting surface.

## Performance shape

- `collect_comptime_fns` walks the program once and registers
  every `@comptime` fn in a `CompTimeRegistry` (Map-indexed
  for O(1) lookup at call sites).
- `prepare_runtime` pre-loads the registry's fns into the
  shared evaluator Runtime — folding reuses one Runtime
  instance across every call site.
- The presence-scan fast-path in `expand_macros` /
  `run_comptime` skips the entire walk when no relevant
  annotations exist in the program.

## Examples

Pure compile-time constant fold:

```avra
@comptime
fn fact(n: int) -> int {
    if n <= 1 { 1 } else { n * fact(n - 1) }
}

let f5 = fact(5)  // codegen sees `let f5 = 120`
```

Macro-driven impl generation (real use today is
`features/marshal/derive.av`, which is implemented as a
hand-rolled pre-resolve pass rather than @comptime+@expand,
but the surface for user-level macros is the same):

```avra
@expand(derive_marshal)
type User = { id: int, name: string }
// expand_macros produces:
//   type User = { id: int, name: string }
//   impl User { fn to_bytes(self) -> bytes { ... } }
//   fn from_bytes_User(b: bytes) -> User { ... }
```

## Spec reference

Components V2 design doc: `docs/2026_05_08_COMPONENTS_V2_DESIGN.md`
sections 3.1 (comptime fold), 3.2 (quote/splice), 3.6 (expand).
