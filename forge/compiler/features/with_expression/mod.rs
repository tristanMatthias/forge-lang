crate::forge_feature! {
    name: "With Expression",
    id: "with_expression",
    status: Stable,
    depends: [],
    enables: [],
    tokens: ["with"],
    ast_nodes: ["With"],
    description: "Struct update syntax: expr with { field: value } creates a copy with updated fields",
    syntax: ["expr with { field: value }"],
    short: "expr with { field: val } — immutable copy with overrides",
    symbols: [],
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
