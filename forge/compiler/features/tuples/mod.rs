crate::forge_feature! {
    name: "Tuples",
    id: "tuples",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: ["TupleLit"],
    description: "Tuple literal expressions with heterogeneous element types",
    syntax: ["(a, b, c)", "let (x, y) = tuple"],
    short: "(a, b) — fixed-size heterogeneous collections with destructuring",
    symbols: [],
}

pub mod types;
pub mod codegen;
pub mod checker;
