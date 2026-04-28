# spawn expression

## Syntax

```
spawn_expr = "spawn" "{" statement_list "}"
```

## Semantics

`spawn { body }` wraps the body in a zero-argument closure and spawns it
as a new task. Returns an integer handle that can be passed to
`forge_thread_join(handle)` to wait for completion.

v1.0: tasks run on OS threads via pthreads. Future versions will use
cooperative green-thread scheduling per spec Axis 18.

## Examples

```avra
let h = spawn {
    println("hello from task")
}
forge_thread_join(h)
```

Captures from the enclosing scope work:

```avra
let msg = "world"
let h = spawn {
    println(msg)
}
forge_thread_join(h)
```
