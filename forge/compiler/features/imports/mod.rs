crate::forge_feature! {
    name: "Imports",
    id: "imports",
    status: Stable,
    depends: [],
    enables: [],
    tokens: ["use", "export"],
    ast_nodes: ["Use"],
    description: "Module imports with use statements and export modifiers",
    syntax: ["use @namespace.name"],
    short: "use statements for provider imports",
    symbols: [],
}

pub mod types;
pub mod parser;
pub mod checker;
pub mod codegen;
