crate::forge_feature! {
    name: "String Templates",
    id: "string_templates",
    status: Stable,
    depends: [],
    enables: [],
    tokens: ["`"],
    ast_nodes: ["TemplateLit"],
    description: "Backtick string interpolation with ${expr} embedded expressions",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
