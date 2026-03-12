// Trait-related type resolution.
//
// Trait type checking is currently minimal -- trait declarations and impl blocks
// are registered during compilation but no deep type-level resolution is
// performed beyond what the codegen handles (resolve_named_type, type_to_type_expr, etc.).
//
// Future work: trait bound checking, associated type resolution in the type checker.
