crate::forge_feature! {
    name: "If/Else",
    id: "if_else",
    status: Stable,
    depends: [],
    enables: [],
    tokens: ["if", "else"],
    ast_nodes: ["If"],
    description: "Conditional expressions with if/else and else-if chaining",
    syntax: ["if cond { } else { }", "if cond { } else if cond { } else { }"],
    short: "if/else — conditional expressions with implicit return",
    symbols: [],
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
