crate::forge_feature! {
    name: "Enums",
    id: "enums",
    status: Stable,
    depends: [],
    enables: ["pattern_matching"],
    tokens: ["enum"],
    ast_nodes: ["EnumDecl"],
    description: "Algebraic data types with named variants and optional fields",
    syntax: ["enum Name { Variant, Variant(fields) }"],
    short: "enum Name { Variants } — algebraic data types with match support",
    symbols: [],
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
