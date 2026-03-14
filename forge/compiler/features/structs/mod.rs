crate::forge_feature! {
    name: "Structs",
    id: "structs",
    status: Stable,
    depends: [],
    enables: [],
    tokens: ["type"],
    ast_nodes: ["TypeDecl", "StructLit"],
    description: "Type declarations (structs and aliases) and struct literal expressions",
    syntax: ["struct Name { field: type }", "let x = Name { field: value }"],
    short: "struct declarations, literals, and field access",
    symbols: [],
}

pub mod types;
pub mod parser;
pub mod checker;
pub mod codegen;
