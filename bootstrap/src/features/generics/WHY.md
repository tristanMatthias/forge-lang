# Generics

Generic type parameters (`<T>`) on functions, types, and enums.
In the bootstrap's everything-is-i64 model, generics are erased
at parse time — `T` maps to `i64` like all other types. The syntax
is supported so bootstrap source can express generic abstractions
that the host compiler type-checks.
