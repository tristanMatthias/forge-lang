pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;

crate::forge_feature! {
    name: "Pattern Matching",
    id: "pattern_matching",
    status: Stable,
    depends: [],
    enables: ["null_safety"],
    tokens: ["match", "->", "_"],
    ast_nodes: ["Match", "MatchArm", "Pattern"],
    description: "Exhaustive pattern matching with destructuring, guards, and or-patterns",
    syntax: ["match expr { pattern -> body, ... }", "match expr { pattern if guard -> body }"],
    short: "match expr { pattern -> body } — exhaustive pattern matching with guards",
    symbols: [],
}
