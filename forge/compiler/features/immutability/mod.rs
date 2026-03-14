crate::forge_feature! {
    name: "Immutability",
    id: "immutability",
    status: Stable,
    depends: [],
    enables: [],
    tokens: ["let", "mut", "const"],
    ast_nodes: ["Let", "Mut", "Const", "LetDestructure"],
    description: "Variable bindings with let (immutable), mut (mutable), and const (compile-time constant)",
    syntax: ["let x = 1", "mut y = 2", "const Z = 3"],
    short: "immutable by default — let (frozen), mut (mutable), const (compile-time)",
    symbols: [],
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
