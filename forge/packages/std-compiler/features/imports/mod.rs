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
    short: "use statements for package imports",
    symbols: [],
    long_description: "\
The `use` statement brings names from other modules and packages into scope. External packages \
are imported with the `@` prefix: `use @std.http` makes the HTTP package's functions and \
components available. Local module imports follow the same pattern without the prefix.

Package imports are the primary mechanism for extending Forge's capabilities. Each package \
contributes types, functions, and component templates. The `use` statement triggers package \
loading at compile time, making all package exports available for the rest of the file.

Multiple imports can be grouped, and the compiler resolves dependencies between packages \
automatically. Circular dependencies between user modules are detected and reported as errors.",
    grammar: "<import_stmt> ::= \"use\" \"@\" <namespace> \".\" <name> \"{\" <symbols> \"}\"",
    category: "Special",
}

pub mod types;
pub mod parser;
pub mod checker;
pub mod codegen;
