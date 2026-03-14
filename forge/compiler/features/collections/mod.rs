crate::forge_feature! {
    name: "Collections",
    id: "collections",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: ["ListLit", "MapLit"],
    description: "List and map literal expressions with type inference",
    syntax: ["[1, 2, 3]", "{ key: value }"],
    short: "list and map literals with type-safe operations",
    symbols: [],
}

pub mod types;
pub mod codegen;
pub mod checker;
