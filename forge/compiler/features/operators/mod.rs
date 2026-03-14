pub mod codegen;

crate::forge_feature! {
    name: "Operators",
    id: "operators",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: ["Binary", "Unary"],
    description: "Binary and unary operators (arithmetic, comparison, logical). Core structural types — AST variants remain in core.",
    syntax: ["a + b", "a == b", "a and b", "not a"],
    short: "arithmetic, comparison, and logical operators",
    symbols: [],
}
