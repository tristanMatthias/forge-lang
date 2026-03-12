crate::forge_feature! {
    name: "Pipe Operator",
    id: "pipe_operator",
    status: Stable,
    depends: [],
    enables: [],
    tokens: ["|>"],
    ast_nodes: ["Pipe"],
    description: "Pipe operator for function chaining: a |> f(args) becomes a.f(args), a |> f becomes f(a)",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
