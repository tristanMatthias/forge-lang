crate::forge_feature! {
    name: "Component Config",
    id: "component_config",
    status: Stable,
    depends: ["components"],
    enables: [],
    tokens: ["config"],
    ast_nodes: ["ConfigSchemaEntry", "ComponentConfig"],
    description: "Typed config blocks in component templates with default values and schema validation",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
