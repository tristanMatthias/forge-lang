crate::forge_feature! {
    name: "Closures",
    id: "closures",
    status: Stable,
    depends: [],
    enables: ["it_parameter"],
    tokens: ["=>", "->"],
    ast_nodes: ["Closure"],
    description: "First-class anonymous functions with captured environment",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
