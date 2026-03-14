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
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
