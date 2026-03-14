crate::forge_feature! {
    name: "Component Config",
    id: "component_config",
    status: Stable,
    depends: ["components"],
    enables: [],
    tokens: ["config"],
    ast_nodes: ["ConfigSchemaEntry", "ComponentConfig"],
    description: "Typed config blocks in component templates with default values and schema validation",
    syntax: ["config { field: type = default }"],
    short: "typed config blocks with defaults in component templates",
    symbols: [],
    long_description: "\
Component config blocks let templates declare typed configuration fields with defaults. In a \
provider's template definition, `config { port: int = 3000, cors: bool = false }` declares \
two config fields. Users override these when creating a component: `server :8080 { ... }` or \
`server { config { port: 8080 } }`.

Config resolution merges user-provided values with the template's defaults. Fields not specified \
by the user get the default value from the template. The compiler validates that provided config \
values match the declared types, catching configuration errors at compile time.

This system ensures that every component has a well-defined, documented configuration surface. \
Users can see what options are available and what their defaults are. Template authors can add \
new config fields with defaults without breaking existing code.

Config blocks replace the ad-hoc configuration approaches found in most frameworks (environment \
variables, magic strings, untyped JSON). Everything is checked at compile time, and the schema \
is defined in one place alongside the component template.",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
