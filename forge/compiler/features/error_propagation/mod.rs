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
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
