pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;

crate::forge_feature! {
    name: "Tagged Templates",
    id: "tagged_templates",
    status: Stable,
    depends: ["string_templates"],
    enables: [],
    tokens: ["tag`...`"],
    ast_nodes: ["TaggedTemplate"],
    description: "Tagged template literals: tag`template ${expr}` desugars to calling tag with separated parts and values as JSON",
}
