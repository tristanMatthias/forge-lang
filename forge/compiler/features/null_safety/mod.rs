crate::forge_feature! {
    name: "Null Safety",
    id: "null_safety",
    status: Stable,
    depends: ["pattern_matching"],
    enables: ["error_propagation"],
    tokens: ["?", "?.", "??", "!"],
    ast_nodes: ["NullCoalesce", "NullPropagate", "Nullable"],
    description: "Optional types with ?, safe access ?., null coalesce ??, and smart narrowing",
    syntax: ["expr?", "expr?.field", "expr ?? default"],
    short: "x? (unwrap), x?.field (chain), x ?? default (coalesce)",
    symbols: ["?", "?.", "??"],
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
