# select statement (channel multiplexing)

## Syntax

```
select_stmt   = "select" "{" select_arm ("," select_arm)* "}"
select_arm    = IDENT "<-" expression "->" "{" statement_list "}"
```

Each arm names a binding (`IDENT`), a channel expression (the
value to the left of `<-`), and a body. The first channel to
receive a value fires its arm with the received value bound to
its binding.

## Semantics

`select { ... }` blocks until any of its arms' channels has a
value ready, then runs that arm's body with the received value
bound. If multiple channels are ready simultaneously, one is
chosen non-deterministically — same semantics as Go's `select`.

The statement returns once the chosen arm's body completes.
There's no default-arm form yet; every `select` blocks until at
least one channel has data.

## Examples

```avra
let ch_a = channel<int>()
let ch_b = channel<string>()

spawn { ch_a.send(42) }
spawn { ch_b.send("hello") }

select {
    n <- ch_a -> { println("got int: ${n}") }
    s <- ch_b -> { println("got string: ${s}") }
}
```

Mixed channel element types are allowed — each arm's binding
takes the receiving channel's element type.

## Runtime layout

Codegen evaluates each arm's channel expression into a flat
array, calls `avra_select(channels, count)` (which blocks until
one channel has data), then reads `avra_select_index(result)`
to dispatch to the matching arm and `avra_select_value(result)`
to bind the received value.

The dispatch is an if-cascade on the index — each arm checks
whether `idx == N` and, if so, binds `val` to its named local
(under the arm's typed cast) and runs the body.

## Pipeline placement

- Parser produces `Stmt.Select(arms: List<SelectArm>)`. Each
  entry carries `binding`, `channel`, `body`.
- Resolve walks each channel expression in the enclosing scope,
  then each body with the arm's binding in scope.
- Type-check accepts any channel-typed expressions; arm
  bindings get the channel's element type.
- Codegen lowers in `features/select_stmt/codegen.av`:
  channel-array build → avra_select call → index-dispatch
  if-cascade.

## Spec reference

Axis 18 (Concurrency). `select` complements `spawn` and channel
primitives — multi-channel receive with non-deterministic fair
choice when multiple are ready.
