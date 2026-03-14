crate::forge_feature! {
    name: "Imports",
    id: "imports",
    status: Stable,
    depends: [],
    enables: [],
    tokens: ["use", "export"],
    ast_nodes: ["Use"],
    description: "Module imports with use statements and export modifiers",
}

pub mod types;
pub mod parser;
pub mod checker;
pub mod codegen;
