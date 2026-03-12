pub mod parser;
pub mod checker;
pub mod codegen;

crate::forge_feature! {
    name: "Table Literal",
    id: "table_literal",
    status: Stable,
    depends: ["types_core"],
    enables: [],
    tokens: ["table"],
    ast_nodes: [],
    description: "Inline table literals that desugar to List<struct>",
}
