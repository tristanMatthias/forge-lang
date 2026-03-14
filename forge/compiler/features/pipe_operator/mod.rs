crate::forge_feature! {
    name: "Pipe Operator",
    id: "pipe_operator",
    status: Stable,
    depends: [],
    enables: [],
    tokens: ["|>"],
    ast_nodes: ["Pipe"],
    description: "Pipe operator for function chaining: a |> f(args) becomes a.f(args), a |> f becomes f(a)",
    syntax: ["expr |> fn", "expr |> .method(args)"],
    short: "expr |> fn — left-to-right function/method chaining",
    symbols: ["|>"],
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
