crate::forge_feature! {
    name: "Variables",
    id: "variables",
    status: Stable,
    depends: [],
    enables: [],
    tokens: ["let", "mut", "const"],
    ast_nodes: ["Let", "Mut", "Const", "LetDestructure"],
    description: "Variable declarations with let, mut, const, and destructuring patterns",
    syntax: ["let x = expr", "mut x = expr", "const X = expr"],
    short: "let/mut/const — immutable-by-default bindings with type inference",
    symbols: [],
}

pub mod types;
pub mod parser;
pub mod checker;
pub mod codegen;
