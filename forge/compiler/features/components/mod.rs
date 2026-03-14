crate::forge_feature! {
    name: "Components",
    id: "components",
    status: Stable,
    depends: ["closures", "extern_ffi"],
    enables: ["component_syntax", "component_events", "component_config"],
    tokens: ["component"],
    ast_nodes: ["ComponentBlock", "ComponentBlockDecl", "ComponentTemplateDef", "ComponentTemplateItem"],
    description: "Template-driven component system with provider architecture and lifecycle hooks",
    syntax: ["use @ns.name", "name(args) { config }"],
    short: "template-driven component system with provider integration",
    symbols: [],
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
