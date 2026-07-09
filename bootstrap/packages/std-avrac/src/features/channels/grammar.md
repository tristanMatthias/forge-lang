# typed channels

## Syntax

```
channel_expr = "channel" "<" type ">" "(" [expression] ")"
```

`Channel<T>` is also a type — usable in annotations, params, fields:

```avra
let results: Channel<int> = channel<int>(8)
fn worker(work: Channel<string>) { ... }
```

## Capacity semantics (spec Axis 18)

| form              | semantics                                              |
|-------------------|--------------------------------------------------------|
| `channel<T>()`    | unbounded — send never blocks; the buffer grows        |
| `channel<T>(0)`   | rendezvous — send blocks until a receiver takes the value |
| `channel<T>(n)`   | bounded — send blocks while `n` values are in flight   |
| `channel<T>(n<0)` | unbounded — negative selects the no-arg form's sentinel |

## Methods

- `ch.send(v)` — deliver one value. Blocks per the capacity
  semantics. Sending on a closed channel is a runtime error.
- `ch.recv() -> T?` — take the oldest value, blocking while the
  channel is empty and open. Returns `null` exactly when the channel
  is **closed and drained** — the natural shutdown signal:

  ```avra
  while true {
      let job = work.recv()
      if job == null { break }
      run(job!)
  }
  ```

- `ch.try_recv() -> T?` — non-blocking poll: a value when one is
  available NOW, else `null` immediately — whether the channel is
  merely empty or closed (block with `recv()` when the distinction
  matters). Powers polling shapes like the test runner's ticker
  shutdown, where blocking would defeat the point.
- `ch.close()` — mark the channel closed and wake all waiters.
  Idempotent. Buffered values remain receivable after close; only
  the "no more values will arrive" promise is made.

## Element-type rules

- `T` must be non-nullable: `recv()` uses `null` for the
  closed-and-drained signal, which a nullable element would shadow
  (typecheck error F1000).
- `send` arguments must match `T` exactly (F1000).
- `T` must be a fully-applied type. A bare generic element —
  `channel<GenOpt>(1)` where `enum GenOpt<T>` — determines no layout,
  so it is rejected before codegen (F1004, the totality rule) rather
  than picking one instantiation by first-match. An in-scope type
  parameter (`channel<T>()` inside `fn f<T>()`) is fully applied at
  each instantiation and stays exempt.
- Every word-repr `T` works: int, bool, float, string, structs,
  enums, lists — ptr-backed elements are retained on send and owned
  by the receiver's scope.

## select integration

`select` arms bind the receiving channel's element type:

```avra
let nums = channel<int>(4)
let words = channel<string>(4)
select {
    n <- nums  -> { println("int ${n}") }
    s <- words -> { println(s) }
}
```

When every channel a `select` waits on is closed and drained, the
runtime traps (`select: all channels closed and drained`) instead of
blocking forever.

## Runtime layout

One ring-buffer implementation in runtime.c (`AvraChannel`):
mutex + two condvars, ring grows when unbounded. `close` sets a
flag and broadcasts — it never frees. The handle is rc-allocated;
`avra_channel_release` (wired via `emit_rc_release_typed`) frees the
ring when the last reference drops. `select` is poll-free: a
process-wide activity condvar is signalled after every send/close.

## Pipeline placement

- Parser: `features/channels/parser.av` → `Expr.ChannelNew(elem, cap?)`,
  keyword `channel` (Tk.KwChannel).
- Type position: `Channel<T>` lowers in `type_expr_to_vtype`.
- Resolve: capacity expression only (`features/channels/mod.av`).
- Typecheck: `features/channels/typeck.av` — construction +
  method surface; select arm bindings get the element type in
  `features/select_stmt`.
- Codegen: `features/channels/codegen.av` — `avra_channel_new_cap`,
  `avra_channel_send` (with rc retain for ptr elements),
  `avra_channel_recv_opt` → `T?` (branch + phi), `avra_channel_close`.

## Spec reference

Axis 18 (Concurrency): channels bounded/unbounded/synchronous,
`select` multi-channel wait, used by `spawn`-based workers.
