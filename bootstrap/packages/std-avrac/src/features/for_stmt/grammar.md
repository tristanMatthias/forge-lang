## For Statement

```ebnf
for_stmt    ::= "for" for_binding "in" iterable block
for_binding ::= IDENTIFIER | "(" IDENTIFIER ("," IDENTIFIER)* ")"
iterable    ::= expr ".." expr      // range form
              | expr                // collection / iterator form
```

### Range form

```
for i in 0..n { … }
```

The loop variable is scoped to the body, incremented by 1 each
iteration, and the range is half-open (start inclusive, end exclusive).

### Collection form

```
for x in xs { … }        // element only
```

Iterates a `List<T>` (or a string, yielding single-char strings),
binding the element to the loop variable each iteration.

### Tuple-destructure binding (ryvy)

```
for (i, x) in xs.enumerate() { … }   // index + element
for (a, b) in xs.zip(ys)     { … }   // parallel iteration
```

A parenthesised binding destructures each element. It is pure parser
sugar: `for (a, b) in coll { BODY }` lowers to

```
for __forpair_<n> in coll {
    let (a, b) = __forpair_<n>
    BODY
}
```

reusing the collection-form for-in and `let`-destructuring codegen —
no dedicated AST node. Each name is scoped to the body and typed from
the corresponding tuple position. The companion built-ins:

- `List<T>.enumerate() -> List<(int, T)>` — pairs each element with its
  zero-based index.
- `List<A>.zip(other: List<B>) -> List<(A, B)>` — parallel pairs,
  truncated to the shorter list.

Both work in compiled code and in the `@comptime` tree-walk evaluator.
