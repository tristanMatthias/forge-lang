crate::forge_feature! {
    name: "Error Propagation",
    id: "error_propagation",
    status: Stable,
    depends: ["null_safety"],
    enables: [],
    tokens: ["?", "ok", "err", "catch"],
    ast_nodes: ["ErrorPropagate", "OkExpr", "ErrExpr", "Catch"],
    description: "Result types with Ok/Err constructors, ? propagation, and catch blocks",
    syntax: ["expr?", "catch { body }"],
    short: "Result types with ? propagation and catch blocks",
    symbols: [],
    long_description: "\
Error propagation in Forge uses the `?` operator to bubble errors up the call stack. When a \
function returns a Result type, appending `?` to the call either unwraps the success value or \
immediately returns the error to the caller. This eliminates the verbose `if err != nil` checks \
found in Go and the sprawling try/catch blocks of Java.

The `?` operator can only be used inside functions that themselves return a Result type. The \
compiler enforces this rule, so you always know whether a function can fail by looking at its \
return type. There are no hidden error paths.

For functions that need to handle errors rather than propagate them, the `catch` pattern provides \
structured error handling. This gives you the control of try/catch when you need it, while the \
`?` operator handles the common case of simply passing errors upward.

This design is directly inspired by Rust's `?` operator and Result type. It provides the same \
safety guarantees — every error must be explicitly handled or propagated — while keeping the \
syntax lightweight. Compared to exceptions, it makes error paths visible in type signatures and \
prevents the \"exception from nowhere\" problem.",
    grammar: "<propagate>   ::= <expr> \"?\"",
    category: "Null Safety",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
