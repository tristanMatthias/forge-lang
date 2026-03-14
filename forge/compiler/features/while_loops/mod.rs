crate::forge_feature! {
    name: "While Loops",
    id: "while_loops",
    status: Stable,
    depends: [],
    enables: [],
    tokens: ["while", "loop", "break", "continue"],
    ast_nodes: ["While", "Loop", "Break", "Continue"],
    description: "While loops, infinite loops, break with value, and continue",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
