crate::forge_feature! {
    name: "Immutability",
    id: "immutability",
    status: Stable,
    depends: [],
    enables: [],
    tokens: ["let", "mut", "const"],
    ast_nodes: ["Let", "Mut", "Const", "LetDestructure"],
    description: "Variable bindings with let (immutable), mut (mutable), and const (compile-time constant)",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
