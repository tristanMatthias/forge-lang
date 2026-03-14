crate::forge_feature! {
    name: "If/Else",
    id: "if_else",
    status: Stable,
    depends: [],
    enables: [],
    tokens: ["if", "else"],
    ast_nodes: ["If"],
    description: "Conditional expressions with if/else and else-if chaining",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
