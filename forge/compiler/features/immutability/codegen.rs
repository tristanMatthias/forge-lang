// Immutability codegen: let/mut/const variable compilation.
//
// The compilation of variable bindings lives in core/codegen/codegen/statements.rs:
//
// - Statement::Let — creates an alloca, stores the value, defines in scope
// - Statement::Mut — same as Let but marks the variable as mutable
// - Statement::Const — same as Let (compile-time const enforcement is in checker)
// - Statement::Assign — loads target alloca, stores new value
//
// These remain in core/statements.rs because variable binding compilation
// is a fundamental building block used by nearly every other feature.
