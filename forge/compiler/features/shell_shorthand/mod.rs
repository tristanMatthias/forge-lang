pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;

crate::forge_feature! {
    name: "Shell Shorthand",
    id: "shell_shorthand",
    status: Stable,
    depends: [],
    enables: [],
    tokens: ["$\"", "$`"],
    ast_nodes: ["DollarExec"],
    description: "Shell command execution with $\"cmd\" and $`cmd ${arg}` returning stdout as string",
}
