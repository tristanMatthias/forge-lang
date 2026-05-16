# @marshal derive

## Syntax

```
marshal_attr   = "@marshal"
struct_decl    = marshal_attr? "type" IDENT "=" "{" field_list "}"
enum_decl      = marshal_attr? "enum" IDENT "{" variant_list "}"
```

The `@marshal` annotation lives in the standard `AnnotationList` slot
that precedes any declaration — no new grammar production. Detection
happens in the post-resolve pass `features/marshal/derive.av`, which
walks the AST and synthesises codec functions next to every annotated
type.

## What gets synthesised

For each `@marshal type T = { f1: TY1, f2: TY2, ... }`:

```
impl T {
    fn to_bytes(self) -> bytes { ... }
}
fn from_bytes_T(b: bytes) -> T { ... }
fn isolated_T(body: fn() -> T) -> Result<T, IsolatedError> { ... }
```

For each `@marshal enum T { V0, V1(...), V2(...) }`:

```
impl T {
    fn to_bytes(self) -> bytes { match self { ... } }
}
fn from_bytes_T(b: bytes) -> T { ... }
fn isolated_T(body: fn() -> T) -> Result<T, IsolatedError> { ... }
```

`from_bytes_<T>` is a top-level function, not an `impl T` method,
because Avra has no static-method syntax — `T.from_bytes(b)` parses
as enum-variant access.

`isolated_<T>` is the per-T equivalent of a generic
`isolated<T: Marshal>(body)` — runs `body` in a forked subprocess
and ships its return value back via `to_bytes`/`from_bytes_<T>`.

## Wire format

Concatenated, little-endian, no header:

| Field type            | Bytes                                                  |
|-----------------------|--------------------------------------------------------|
| `int`                 | 8 (i64)                                                |
| `bool`                | 8 (i64; 0 or 1)                                        |
| `float`               | 8 (IEEE-754 double)                                    |
| `string`              | 8 length-prefix + UTF-8 payload                        |
| `List<int>`           | 8 count + count × 8                                    |
| `List<bool>`          | 8 count + count × 8                                    |
| `List<string>`        | 8 count + count × length-prefixed payload              |
| `List<float>`         | 8 count + count × 8                                    |
| nested `@marshal` struct | 8 length-prefix + inner `to_bytes()` payload        |
| `@marshal` enum       | 8 tag (source-order variant index) + payload-as-above  |

Enum tag ordering matches source declaration order; adding a variant
at the end stays backwards-compatible, inserting in the middle does
not.

## Supported field types

Today (this commit):

- Primitives: `int` / `bool` / `string` / `float`.
- Homogeneous lists of any supported primitive.
- Nested `@marshal` structs (recursive).
- Enum variants whose payload fields are any of the above.

Open (separate sub-tickets):

- `List<NestedMarshalStruct>` — needs an inline loop synthesis or a
  generic `write_struct_list` helper.
- `Map<K, V>` — key/value iteration; v1.0 may be intentionally
  excluded per the parent ticket.
- Nullable `T?` — blocked on `TypeExpr.Optional` being preserved in
  `ValueType` (currently lowered to `T`).

## Examples

### Struct round-trip

```avra
use @std.process.{bytes_builder, bytes_reader}

@marshal
type User = { id: int, name: string, admin: bool }

let u = User { id: 7, name: "alice", admin: true }
let b = u.to_bytes()
let u2 = from_bytes_User(b)
// u2.id == 7, u2.name == "alice", u2.admin == true
```

### Enum round-trip

```avra
@marshal
enum Status { Active, Pending(count: int), Failed(reason: string) }

let s = Status.Pending(42)
let s2 = from_bytes_Status(s.to_bytes())
// match s2 { .Pending(c) -> c == 42, ... }
```

### Across a fork boundary

```avra
@marshal
type Report = { total: int, errors: List<string> }

fn run_check(path: string) -> Report {
    // ... heavy work ...
    Report { total: 100, errors: ["bad-line:42"] }
}

match isolated_Report(() -> run_check("/some/path")) {
    .Ok(r)  -> println("found ${r.errors.length} errors")
    .Err(_) -> println("subprocess crashed")
}
```

## Pipeline placement

`derive_marshal` runs in the build pipeline as:

```
lower_quotes → desugar → inject_intrinsics → expand_components
  → derive_marshal → resolve_names → expand_macros → run_comptime
  → typecheck → monomorphize → codegen
```

Pre-resolve means the synthesised `impl T` is processed by
`resolve_names` together with the user's type declaration, so name
qualification stays consistent. The synthesised body calls
`@std::process::bytes_builder` (qualified) so consumers don't need
to `use` the byte primitives.

## Why not a trait

The ticket asked for a `trait Marshal { to_bytes; from_bytes }` with
generic `isolated<T: Marshal>(body)`. The pragmatic shortcut here is
per-T monomorphic synthesis — the user-facing DX is identical and the
language doesn't yet need trait-bound generics. Switching to a real
trait is a transparent refactor once those land.
