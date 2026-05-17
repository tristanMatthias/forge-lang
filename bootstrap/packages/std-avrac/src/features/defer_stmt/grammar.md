# defer / errdefer statement

## Syntax

```
defer_stmt    = "defer" expression
errdefer_stmt = "errdefer" expression
```

Both forms accept any expression — typically a function call
that releases a resource — and stop at end-of-line.

## Semantics

`defer expr` runs `expr` at scope exit, in **LIFO order** with
respect to other `defer` / `errdefer` statements in the same
scope. The expression's result is discarded; defers exist for
their side effects.

`errdefer expr` is identical except it only fires on **error
exit** — when the enclosing function returns via `Result.Err(_)`
propagated by `?` or via `return Result.Err(_)`. Success paths
skip the errdefer entirely.

Both are spec Axis 12.7 (defer / errdefer — LIFO ordering).

## Examples

```avra
fn read_file(path: string) -> Result<string, IoError> {
    let f = file_open(path)?
    defer file_close(f)

    let buf = alloc_buf()
    errdefer free_buf(buf)

    let content = file_read(f, buf)?
    Result.Ok(content)
    // on success: defers fire LIFO — file_close(f).
    // on error from file_read?: errdefers + defers fire LIFO —
    //   free_buf(buf) then file_close(f).
}
```

Multiple defers stack:

```avra
fn nested() {
    defer println("1")
    defer println("2")
    defer println("3")
    // prints: 3, 2, 1
}
```

## Ordering

Inside a single scope, every `defer` and `errdefer` is pushed
onto the `DeferStack` for that function. On scope exit the
codegen pops in LIFO order. On error exit (via `?` or explicit
`return Result.Err`), every `errdefer` runs in addition to every
`defer`; on success exit, only `defer` runs.

Nested blocks each get their own stack — a `defer` inside an
`if`'s then-branch fires when the if-block exits, not when the
enclosing function returns.

## Codegen layout

The `Ctx.rc_cleanup` / `DeferStack` carry per-function defer
state through codegen. Each `Stmt.Defer(body)` emission pushes a
`Frame` onto the stack; each scope-exit emit-site (return /
fall-through / break / `?` propagation) walks the stack
filtered by whether this exit is success or error, emitting the
LIFO sequence inline.

`errdefer`'s filter is the `is_error` flag passed to
`emit_stack_filtered` — error-exit emit sites set it to 1, normal
exits to 0.

## Pipeline placement

- Parser produces `Stmt.Defer(body)` / `Stmt.Errdefer(body)`.
- Resolve walks the body in the current scope.
- Type-check accepts any expression type (return value
  discarded).
- Codegen pushes onto the per-function DeferStack at the
  statement's emit site, then unwinds at every exit point.
