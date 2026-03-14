crate::forge_feature! {
    name: "JSON Builtins",
    id: "json_builtins",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: [],
    description: "Built-in json.parse(), json.stringify(), and json.parse_list() intrinsics",
    syntax: ["json.parse(str)", "json.stringify(val)"],
    short: "json.parse/stringify — JSON serialization/deserialization",
    symbols: [],
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
