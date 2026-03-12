pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;

crate::forge_feature! {
    name: "For Loops",
    id: "for_loops",
    status: Stable,
    depends: ["ranges"],
    enables: [],
    tokens: ["for", "in"],
    ast_nodes: ["For"],
    description: "For-in loops over ranges, lists, maps, and channels",
}
