# Result<T, E> + `?` propagation

## Syntax

```
result_ctor = "Result" "." "Ok" "(" expression ")"
            | "Result" "." "Err" "(" expression ")"

try_expr    = postfix_expr "?"
```

## Semantics

`Result<T, E>` is the canonical fallible-value enum surfaced
across the language and stdlib. It has two variants:

- `Ok(value: T)` — successful result.
- `Err(error: E)` — failure carrying an `E`-typed reason.

The `?` operator on an expression of `Result<T, E>` type:

- If the value is `Ok(v)`, unwraps to `v` (the expression's
  result is `v: T`).
- If the value is `Err(e)`, returns `Err(e)` from the enclosing
  function — every `errdefer` on the way out fires (Axis 12.7).

The enclosing function's return type must itself be `Result<_, F>`
for some `F` assignable from `E` (auto-widening through union
error types — Axis 12.5).

## Examples

Direct unwrap-or-propagate:

```avra
fn read_user(id: int) -> Result<User, IoError> {
    let raw = fetch_row(id)?     // unwraps Ok, returns Err
    let parsed = parse_user(raw)?
    Result.Ok(parsed)
}
```

Pattern-match consumption:

```avra
match read_user(42) {
    .Ok(u)  -> println("got ${u.name}")
    .Err(e) -> println("failed: ${e}")
}
```

`catch` recovery (Axis 12.6):

```avra
let user = read_user(42) catch (e) { default_user() }
```

## Result on tuple Ok types

`Result<(T, U), E>` works end-to-end including `?` propagation
into a let-destructure:

```avra
fn step() -> Result<(int, BytesReader), MarshalError> { ... }

fn consume() -> Result<int, MarshalError> {
    let r = bytes_reader(b)
    let (n, r) = r.try_read_int()?
    let (m, _) = r.try_read_int()?
    Result.Ok(n + m)
}
```

The `?` extracts the tuple, the let-destructure binds each
element. Codegen routes the Ok payload type through
`resolve_ok_type_with(name, type_args)` which prefers the
type_args-supplied substitution over the enum registry's
generic payload form. nce6.3 plumbing.

## Auto-widening at `?`

When the inner Result's error type is a strict subset of the
enclosing function's error type, `?` auto-widens:

```avra
fn parse() -> Result<int, ParseError> { ... }
fn fetch() -> Result<bytes, IoError> { ... }

fn run() -> Result<int, ParseError | IoError> {
    let raw = fetch()?     // IoError widens into the union
    parse()                // ParseError widens into the union
}
```

Union widening is implemented in `features/null_safety/codegen.av`
via `emit_union_wrap`.

## Where `?` does NOT propagate

- A function whose return type is NOT a Result (and NOT
  nullable `T?`). `?` triggers a type-check error.
- Inside a closure if the closure's return type isn't a Result
  — `?` inside `xs.map((x) -> compute(x)?)` would fail because
  the lambda's return type is `T`, not `Result<T, _>`.

## Spec reference

Axis 12 (Error handling). Result is one of the language's
small set of universal types that every user is expected to
know — like `int`, `string`, `bool`.
