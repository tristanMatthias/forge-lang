crate::forge_feature! {
    name: "Collections",
    id: "collections",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: ["ListLit", "MapLit"],
    description: "List and map literal expressions with type inference",
}

pub mod types;
pub mod codegen;
pub mod checker;
