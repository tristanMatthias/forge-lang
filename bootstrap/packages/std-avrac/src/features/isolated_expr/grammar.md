# isolated expression

## Syntax

```
isolated_expr = "isolated" "{" statement_list "}"
```

## Semantics

`isolated { body }` runs `body` in a forked subprocess (POSIX
`fork(2)` + anonymous pipe). The child inherits the parent's
memory via copy-on-write — closure captures travel for free
without explicit marshaling. Only the *return value* crosses the
IPC boundary.

Today (Phase A–C of `nce6`): the keyword produces a framed
`bytes` payload. Stdlib wrappers (`isolated_int`,
`isolated_string`, `isolated_bytes`, plus per-T `isolated_<T>`
synthesised by `@marshal`) unwrap the frame into
`Result<T, IsolatedError>`.

Phase D (`nce6.2`): the keyword itself returns
`Result<T, IsolatedError>` for any T whose type carries
`@marshal` — codegen looks up T from the body's type, wraps the
body in `() -> body.to_bytes()`, and routes the framed bytes
through `from_bytes_<T>`. Not yet shipped.

## Crash semantics

A `SIGSEGV`, `abort()`, or non-zero exit in the child surfaces
to the parent as `Result.Err(IsolatedError.Crashed)` — the
parent process stays alive. `fork(2)` failure (out of pids,
ulimit) surfaces as `IsolatedError.ForkFailed`. IPC pipe failure
mid-transfer surfaces as `IsolatedError.PipeFailed`.

## Examples

### Today (bytes-payload + stdlib wrapper)

```avra
use @std.process.{isolated_int}

let r = isolated_int(() -> 1 + 1)
match r {
    .Ok(n)  -> println("got ${n}")
    .Err(_) -> println("child crashed")
}
```

### With `@marshal` (per-T wrapper synthesised)

```avra
@marshal
type Report = { total: int, errors: List<string> }

match isolated_Report(() -> run_check("/some/path")) {
    .Ok(r)  -> println("found ${r.errors.length} errors")
    .Err(_) -> println("subprocess crashed")
}
```

### Future Phase D — keyword form

```avra
@marshal
type Report = { total: int, errors: List<string> }

let r: Result<Report, IsolatedError> = isolated {
    run_check("/some/path")
}
```

## Pipeline placement

The parser hands an `Expr.Isolated(body)` node to the resolver.
Resolve walks the body in the enclosing scope (matches `spawn`
semantics). Type-check declares the result type as `Bytes`
today; codegen wraps the body in a zero-arg lambda producing
`bytes` and calls `avra_isolated_run(closure)` to get the
framed payload back.

The runtime (`avra_isolated_run` in `runtime.c`) takes the
fork + pipe + wait4 path, framing the child's return as
`[i64 status][i64 length][payload bytes]`. Status `0` is OK;
`1` is crashed; `2` is fork failed; `3` is pipe failed.

## Captures

Avra closures capture by-value. Inside `isolated { body }`, the
captured environment is the parent process snapshot at the
moment of `fork(2)` — every binding referenced by `body` sees
the same value the parent had. No marshaling step is needed
for captures because the child literally inherits the address
space. Only the return value needs to cross the pipe.
