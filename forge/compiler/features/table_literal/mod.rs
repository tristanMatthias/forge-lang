pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;

crate::forge_feature! {
    name: "Table Literal",
    id: "table_literal",
    status: Stable,
    depends: ["types_core"],
    enables: [],
    tokens: ["table"],
    ast_nodes: [],
    description: "Inline table literals that desugar to List<struct>",
    syntax: ["table { col1 | col2; val1 | val2 }"],
    short: "table { cols | rows } — tabular data literals",
    symbols: [],
}
