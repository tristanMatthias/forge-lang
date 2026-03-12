pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;

crate::forge_feature! {
    name: "Spawn",
    id: "spawn",
    status: Stable,
    depends: [],
    enables: ["channels"],
    tokens: ["spawn"],
    ast_nodes: ["SpawnBlock"],
    description: "Concurrent execution with spawn { ... } blocks",
}
