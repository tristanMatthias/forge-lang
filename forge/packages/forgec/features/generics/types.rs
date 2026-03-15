// Generics type-level resolution.
//
// Type parameter substitution during monomorphization is handled in codegen.rs
// (substitute_type_expr, unify_type_expr, infer_type_args).
//
// The type checker resolves generic type expressions (List<T>, Map<K,V>, Result<T,E>)
// in TypeChecker::resolve_type_expr (core/typeck/checker.rs).
//
// Future work: constraint solving, higher-kinded types, where clauses.
