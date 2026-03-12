crate::forge_feature! {
    name: "Error Propagation",
    id: "error_propagation",
    status: Stable,
    depends: ["null_safety"],
    enables: [],
    tokens: ["?", "ok", "err", "catch"],
    ast_nodes: ["ErrorPropagate", "OkExpr", "ErrExpr", "Catch"],
    description: "Result types with Ok/Err constructors, ? propagation, and catch blocks",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
