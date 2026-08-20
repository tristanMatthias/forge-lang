# Generics

Generic type parameters (`<T>`) on functions, types, and enums.
Generics MONOMORPHIZE (4-pass); they are not erased. The old note here
claimed "in the bootstrap's everything-is-i64 model … `T` maps to `i64`
like all other types", and that model was ELIMINATED — codegen uses proper
LLVM types now, and an unbound `T` lays out as the erased wide i64 ONLY
inside an `@mono_erased` generic base body. The syntax
is supported so bootstrap source can express generic abstractions
that the host compiler type-checks.
