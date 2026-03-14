crate::forge_feature! {
    name: "Component Events",
    id: "component_events",
    status: Stable,
    depends: ["components"],
    enables: [],
    tokens: ["event", "on"],
    ast_nodes: ["EventDecl", "ServiceHook"],
    description: "Event declarations and user hooks in component templates (before_create, after_delete, etc.)",
    syntax: ["event before_create(record)", "on before_create(data) { }"],
    short: "event/on — hookable lifecycle events in components",
    symbols: [],
    long_description: "\
Component events declare hookable extension points in templates. A template can declare \
`event before_create(record)` to let users run custom logic before a record is created. Users \
hook into events with `on before_create(data) { validate(data) }` inside the component block.

Events follow a declaration-and-hook pattern. The template declares what events exist and what \
arguments they carry. User code attaches handlers to events it cares about. Events without \
handlers get no-op stubs, so unhandled events have zero runtime cost.

This provides a clean alternative to the middleware stacks and callback chains found in frameworks \
like Express or Django. Each event has a typed signature, so the compiler verifies that hook \
handlers accept the correct argument types.

The event system enables components to be customizable without inheritance or complex plugin \
architectures. A model component might offer `before_create`, `after_create`, `before_delete` \
events, letting users add validation, logging, or side effects without modifying the component \
template.",
    category: "Components",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
