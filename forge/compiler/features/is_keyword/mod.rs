pub mod parser;
pub mod codegen;
pub mod checker;
pub mod types;

crate::forge_feature! {
    name: "Is Keyword",
    id: "is_keyword",
    status: Stable,
    depends: ["pattern_matching"],
    enables: [],
    tokens: ["is"],
    ast_nodes: ["Is"],
    description: "Inline pattern check: value is Pattern → bool",
}
