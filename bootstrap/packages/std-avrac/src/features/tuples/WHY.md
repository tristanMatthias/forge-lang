# Tuples

Tuple literals `(a, b, c)`, tuple indexing `t.0`, and destructuring
`let (x, y) = expr`. Tuples are heap-allocated with compile-time known
arity. The old note here said "buffers of i64 values" under "the
bootstrap's i64 model" — that model was ELIMINATED; elements carry their
own LLVM types via `resolve_layout`.
