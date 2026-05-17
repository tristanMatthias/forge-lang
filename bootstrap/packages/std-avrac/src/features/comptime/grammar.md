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

The two pieces are separate passes in the compile pipeline:

```
resolve_names → expand_macros → run_comptime → typecheck
```

- **expand_macros** runs first. It walks for `@expand`
  declarations, evaluates each macro fn against its decl
  argument, and splices the resulting AST node in place. Also
  handles the component-instance dispatch case (vez6.8.5) where
  a ComponentBlock instance routes through its def's `@expand`.
- **run_comptime** runs next. It folds every call to a
  `@comptime` fn with comptime-known arguments into the
  evaluated literal. Fast-path: programs with zero `@comptime`
  fns short-circuit without walking the AST.

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
