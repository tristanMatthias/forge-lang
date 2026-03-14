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
    long_description: "\
Components are Forge's template-driven extension system. A component defines a reusable, \
domain-specific abstraction backed by a provider. For example, a `model` component creates a \
data model with CRUD operations, a `server` component sets up an HTTP server, and a `queue` \
component provides message queue functionality.

Components are defined entirely through provider template files (`provider.fg`). The compiler \
has zero knowledge of any specific component; it simply expands templates by substituting \
placeholders. This means new component types can be added without modifying the compiler.

Using a component is as simple as writing a block: `model User { name: string, email: string }`. \
The compiler finds the matching template from the loaded providers, expands it with the user's \
schema and configuration, and produces plain Forge code that calls extern functions from the \
provider's native library.

This architecture separates concerns cleanly: providers implement behavior in native code, \
templates describe how to expose that behavior to Forge users, and the compiler handles the \
mechanical work of template expansion. Adding a new domain (database, message queue, GPU compute) \
requires only a new provider, never a compiler change.",
    grammar: "<component>   ::= \"component\" <ident> \"(\" <args> \")\" <block>",
    category: "Components",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
