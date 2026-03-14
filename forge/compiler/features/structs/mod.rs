crate::forge_feature! {
    name: "Structs",
    id: "structs",
    status: Stable,
    depends: [],
    enables: [],
    tokens: ["type"],
    ast_nodes: ["TypeDecl", "StructLit"],
    description: "Type declarations (structs and aliases) and struct literal expressions",
}

pub mod types;
pub mod parser;
pub mod checker;
pub mod codegen;
