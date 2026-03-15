// Immutability type checking lives in core/typeck/checker.rs.
//
// Key checking logic:
// - Statement::Let — defines variable with mutable=false
// - Statement::Mut — defines variable with mutable=true
// - Statement::Const — defines variable with mutable=false
// - Statement::Assign — checks target is mutable via env.get(name).mutable
//
// The mutability flag is tracked in TypeEnv entries and enforced at assignment time.
// Attempting to assign to a `let` binding produces a diagnostic error.
