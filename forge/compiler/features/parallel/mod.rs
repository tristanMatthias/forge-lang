crate::forge_feature! {
    name: "Parallel",
    id: "parallel",
    status: Stable,
    depends: ["spawn"],
    enables: [],
    tokens: ["parallel"],
    ast_nodes: [],
    description: "Parallel execution blocks for structured concurrency",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
