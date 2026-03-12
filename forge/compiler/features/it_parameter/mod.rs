crate::forge_feature! {
    name: "It Parameter",
    id: "it_parameter",
    status: Stable,
    depends: ["closures"],
    enables: [],
    tokens: ["it"],
    ast_nodes: [],
    description: "Implicit `it` parameter in single-argument closures: list.map(it * 2)",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
