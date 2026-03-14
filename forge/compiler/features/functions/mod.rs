crate::forge_feature! {
    name: "Functions",
    id: "functions",
    status: Stable,
    depends: [],
    enables: [],
    tokens: ["fn", "return"],
    ast_nodes: ["FnDecl", "Return"],
    description: "Function declarations with parameters, return types, and return statements",
}

pub mod types;
pub mod parser;
pub mod checker;
pub mod codegen;
