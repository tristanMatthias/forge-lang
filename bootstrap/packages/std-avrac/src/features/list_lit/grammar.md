# list literal

## Syntax

```
list_lit = "[" (expression ("," expression)*)? "]"
```

## Semantics

`[a, b, c]` evaluates each element left-to-right and pushes
into a freshly allocated `List<T>`. The element type `T` is
pinned by the first element's type; subsequent elements must be
assignable to it.

Empty literal `[]` evaluates to a `List<Unknown>` whose element
type is fixed by the first inferring use (e.g.
`let xs: List<int> = []` pins `T = int`).

## Examples

```avra
let nums = [1, 2, 3]                       // List<int>
let names = ["alice", "bob", "carol"]      // List<string>
let nested = [[1, 2], [3, 4]]              // List<List<int>>
let empty: List<int> = []                  // List<int>, zero-length
```

Expressions inside literals are evaluated in source order:

```avra
mut i = 0
let xs = [{ i = i + 1; i }, { i = i + 1; i }]
// xs == [1, 2]
```

Lists are immutable by value-binding but their methods produce
new lists. `push` returns the list with one more element rather
than mutating in place:

```avra
let xs = [1, 2]
let ys = xs.push(3)
// xs == [1, 2], ys == [1, 2, 3]
```

## Runtime layout

A `List<T>` is a pointer to `avra_array_*`-managed memory. Each
literal site emits an `avra_array_new` call followed by an
`avra_array_push` per element. Element values are stored
inline (i64 for primitives, ptr for heap-allocated types).

## Pipeline placement

- Parser produces `Expr.ListLit(elements: List<ExprId>)`.
- Resolve walks every element expression.
- Type-check unifies element types — first non-Unknown element
  pins `T`; subsequent elements must be assignable to `T`.
- Codegen emits the array-build sequence in `list_lit/codegen.av`.

## Higher-order methods

List literals interop with the language's HOF surface — `map`,
`filter`, `fold`, `push`, `length`, indexing — implemented in
the runtime against the same array primitives. The element-type
inference + the implicit `it` lambda pronoun (see
`features/closures/grammar.md`) let common patterns stay terse:

```avra
let doubled = [1, 2, 3].map(it * 2)
let evens = [1, 2, 3, 4].filter(it % 2 == 0)
let sum = [1, 2, 3].fold(0, (acc, x) -> acc + x)
```
