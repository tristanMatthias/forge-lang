# parallel statement

## Syntax

```
parallel_stmt = "parallel" "{" statement_list "}"
```

## Semantics

`parallel { s1; s2; s3 }` runs each top-level statement of the
body concurrently (one green thread per statement) and waits
for all to complete before returning. The statements share the
parent's lexical scope — captures work the same way as `spawn`
or `isolated`.

Avra's parallel is the structured-concurrency primitive: the
block doesn't exit until every spawned task has joined.
Compared to manual `spawn` + `join` pairs, parallel guarantees
no orphan tasks survive the block exit.

## Examples

```avra
parallel {
    fetch_alpha()
    fetch_beta()
    fetch_gamma()
}
// every fetch_* has completed by the time control reaches here
```

Captures from outer scope (by-value, like all closures):

```avra
let url_base = "https://example.com"
parallel {
    fetch("${url_base}/a")
    fetch("${url_base}/b")
}
```

Each statement is its own task — mixing different operations is
fine:

```avra
parallel {
    save_to_disk(results)
    upload_to_s3(results)
    log_metrics(results)
}
```

## Runtime layout

Codegen wraps each statement in a zero-arg closure (matching the
`avra_parallel_run` ABI), pushes every closure onto an array,
and emits a single call to `avra_parallel_run(closures)`. The
runtime spawns each as a green thread, blocks the caller until
every thread has joined, then frees the closure array.

Today (v1.0): tasks run on OS pthreads — the green-thread
runtime mentioned in spec Axis 18 is future work.

## Error semantics

If any spawned statement panics or returns an error, the parent
sees the failure after the block exits (the parent doesn't
short-circuit on the first failure — every statement still
runs). The detailed error-propagation rules are an open spec
item; today panics in a parallel statement are caught and
re-raised at the join point.

## Pipeline placement

- Parser produces `Stmt.Parallel(body: StmtList)`.
- Resolve walks each body statement in the enclosing scope.
- Type-check accepts any statement-typed body.
- Codegen lowers in `features/parallel_stmt/codegen.av` — one
  closure per body statement, batched into `avra_parallel_run`.
