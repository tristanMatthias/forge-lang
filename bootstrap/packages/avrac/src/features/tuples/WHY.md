# Tuples

Tuple literals `(a, b, c)`, tuple indexing `t.0`, and destructuring
`let (x, y) = expr`. In the bootstrap's i64 model, tuples are
heap-allocated buffers of i64 values with compile-time known arity.
