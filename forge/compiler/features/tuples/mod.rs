crate::forge_feature! {
    name: "Tuples",
    id: "tuples",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: ["TupleLit"],
    description: "Tuple literal expressions with heterogeneous element types",
}

pub mod types;
pub mod codegen;
pub mod checker;
