pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;

crate::forge_feature! {
    name: "Ranges",
    id: "ranges",
    status: Stable,
    depends: [],
    enables: ["for_loops"],
    tokens: ["..", "..="],
    ast_nodes: ["Range"],
    description: "Range expressions: 0..10 (exclusive) and 0..=10 (inclusive)",
}
