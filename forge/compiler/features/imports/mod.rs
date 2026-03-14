crate::forge_feature! {
    name: "Imports",
    id: "imports",
    status: Stable,
    depends: [],
    enables: [],
    tokens: ["use", "export"],
    ast_nodes: ["Use"],
    description: "Module imports with use statements and export modifiers",
    syntax: ["use @namespace.name"],
    short: "use statements for provider imports",
    symbols: [],
    long_description: "\
The `use` statement brings names from other modules and providers into scope. External providers \
are imported with the `@` prefix: `use @std.http` makes the HTTP provider's functions and \
components available. Local module imports follow the same pattern without the prefix.

Provider imports are the primary mechanism for extending Forge's capabilities. Each provider \
contributes types, functions, and component templates. The `use` statement triggers provider \
loading at compile time, making all provider exports available for the rest of the file.

Multiple imports can be grouped, and the compiler resolves dependencies between providers \
automatically. Circular dependencies between user modules are detected and reported as errors.",
}

pub mod types;
pub mod parser;
pub mod checker;
pub mod codegen;
