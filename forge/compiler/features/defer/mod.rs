crate::forge_feature! {
    name: "Defer",
    id: "defer",
    status: Stable,
    depends: [],
    enables: [],
    tokens: ["defer"],
    ast_nodes: ["Defer"],
    description: "Deferred execution of expressions before function return, executed in reverse order",
    syntax: ["defer expr"],
    short: "defer expr — execute when scope exits, LIFO order",
    symbols: [],
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
