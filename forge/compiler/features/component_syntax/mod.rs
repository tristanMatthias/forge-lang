crate::forge_feature! {
    name: "Component Syntax",
    id: "component_syntax",
    status: Stable,
    depends: ["components"],
    enables: [],
    tokens: ["@"],
    ast_nodes: ["SyntaxFnDef", "SyntaxPatternDef"],
    description: "@syntax decorators for pattern-based sugar in component templates",
    syntax: ["@syntax(\"pattern\") fn name(...)"],
    short: "@syntax — pattern-based sugar for component DSLs",
    symbols: [],
    long_description: "\
The `@syntax` decorator lets component templates define custom syntactic patterns. For example, \
`@syntax(\"{method} {path} -> {handler}\")` on a function in a server template enables users \
to write `GET /users -> list_users` inside the component block. The compiler matches user code \
against registered patterns and desugars matches into function calls.

Syntax patterns consist of literal segments and `{placeholder}` captures. Literals must match \
exactly, and placeholders capture the corresponding user input. The pattern engine handles \
identifier, string, and brace-balanced expression captures, making it flexible enough for \
diverse DSLs.

This mechanism is how Forge supports domain-specific syntax without hardcoding any domain into \
the compiler. The server's route syntax, the model's field declarations, and the queue's message \
patterns are all defined through `@syntax` in their respective provider templates.

Compared to macros in Rust or Lisp, `@syntax` patterns are more constrained but also more \
predictable. They match a fixed pattern shape rather than arbitrary token trees, which keeps \
error messages clear and prevents the readability problems that plague macro-heavy codebases.",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
