crate::forge_feature! {
    name: "Component Events",
    id: "component_events",
    status: Stable,
    depends: ["components"],
    enables: [],
    tokens: ["event", "on"],
    ast_nodes: ["EventDecl", "ServiceHook"],
    description: "Event declarations and user hooks in component templates (before_create, after_delete, etc.)",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
