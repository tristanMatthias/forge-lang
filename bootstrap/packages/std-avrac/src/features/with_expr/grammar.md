# with expression (functional struct update)

## Syntax

```
with_expr  = expression "with" "{" field_init_list "}"
field_init = IDENT ":" expression
```

`field_init_list` is a comma-separated list of one-or-more
`field_init` pairs. Order doesn't matter; each name must refer
to an existing field of the source struct.

## Semantics

`obj with { field: new_val, ... }` evaluates to a fresh struct
that copies every field from `obj` *except* the named fields,
which take the override values instead. `obj` is not mutated.

This is the only way to "modify" a struct in Avra — there's no
field-assignment statement on by-value struct bindings.
`mut obj` allows reassigning the whole binding to a new struct
value, typically produced by `with`.

## Examples

```avra
type Point = { x: int, y: int, label: string }

let p = Point { x: 1, y: 2, label: "origin" }
let q = p with { x: 10 }
// p still has x=1; q has x=10, y=2, label="origin"
```

Multiple overrides in one update:

```avra
let r = p with { x: 100, label: "far" }
// r = Point { x: 100, y: 2, label: "far" }
```

Override expressions can reference the original:

```avra
let shifted = p with { x: p.x + 5 }
// shifted = Point { x: 6, y: 2, label: "origin" }
```

Chained updates (each produces a new struct, no shared
mutation):

```avra
let final_p = p with { x: 1 } with { y: 99 } with { label: "z" }
```

## Type rules

The source expression must have a struct type — the typechecker
rejects `with` on enums, primitives, or unknown-typed values.
Every override name must match an existing field of the source
struct's type. Override values must be assignable to the field's
declared type.

When a field is part of a `Result<T, E>`-style union — e.g.
`val: int | string` — the override's typecheck allows widening
to the union (matches the type-check for the original field
init).

## Codegen layout

`Expr.With(obj, overrides)` lowers to:

1. Evaluate `obj` (an `EmitValue` with the struct's named LLVM
   type).
2. Allocate a fresh struct buffer (or reuse the caller's stack
   target when this `with` is in tail-init position — spec
   9.12 Copy types).
3. Memcpy every field from the source into the new buffer.
4. For each override, evaluate the new value and store it at the
   field's GEP slot, overwriting the copy.
5. Return a pointer to the new buffer.

Union-typed fields with widening overrides route through
`emit_union_wrap` before the store.

## Pipeline placement

- Parser produces `Expr.With(obj, overrides: FieldInitList)`.
- Resolve walks `obj` then each override value in the current
  scope.
- Type-check pins the result type to `obj.ty` (the struct
  type), validating each override against its field's declared
  type.
- Codegen emits the copy-and-overwrite sequence above.
