# map literal

## Syntax

```
map_lit   = "{" (map_entry ("," map_entry)*)? "}"
map_entry = expression ":" expression
```

The opening `{` is disambiguated from a block by context — only
positions that accept an expression of map type parse a literal
this way.

## Semantics

`{ k1: v1, k2: v2 }` evaluates each key and value left-to-right
and inserts into a freshly allocated `Map<K, V>`. Avra's v1.0
map is string-keyed; non-string keys aren't supported (open
sub-ticket).

Empty literal `{}` parses as a Map only in contexts where Map
is the expected type — otherwise it's a block.

## Examples

```avra
let counts = { "alice": 3, "bob": 5, "carol": 7 }
let empty: Map = {}
```

Combined with `with` for functional update isn't supported on
maps yet; use the builder pattern instead:

```avra
mut m = { "a": 1 }
m = m.set("b", 2)
m = m.set("c", 3)
```

## Runtime layout

A `Map` is a pointer to `avra_map_*` C-runtime storage —
hashed string keys, i64/ptr values. Each literal site emits an
`avra_map_new` plus one `avra_map_set` per entry. Key
expressions must evaluate to a string at runtime.

## Pipeline placement

- Parser produces `Expr.MapLit(entries: List<ExprId>)` where
  entries alternates key, value, key, value, … (flat list, not
  paired — keeps the AST shape uniform with `Expr.ListLit`).
- Resolve walks each entry expression.
- Type-check pins V from the first value entry (or annotated
  context), validates keys are strings, and rejects a value whose
  layout conflicts with an annotated `Map<K, V>` value type
  (e.g. `Map<string, Box<string>> = {"k": Box{val: 9}}` — F1000).
- Codegen emits the map-build sequence in
  `features/map_lit/codegen.av`.

## v1.0 limitations

- String keys only — `Map<int, V>` etc. are tracked as a separate
  spec item.
- No literal-position `{}` outside an expected-Map type slot;
  use `Map.new()` or an annotated `let m: Map = {}` for
  empty-map construction.
