crate::forge_feature! {
    name: "Functions",
    id: "functions",
    status: Stable,
    depends: [],
    enables: [],
    tokens: ["fn", "return"],
    ast_nodes: ["FnDecl", "Return"],
    description: "Function declarations with parameters, return types, and return statements",
    syntax: ["fn name(params) -> type { body }", "fn name(params) { body }"],
    short: "fn declarations with type inference and implicit return",
    symbols: ["fn"],
}

pub mod types;
pub mod parser;
pub mod checker;
pub mod codegen;
