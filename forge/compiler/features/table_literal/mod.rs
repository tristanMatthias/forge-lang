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
    long_description: "\
Table literals provide a concise syntax for defining tabular data using pipe-delimited columns. \
Instead of a list of structs or a list of lists, you write the data as a visual table directly \
in your source code, with `|` separating columns and each row on its own line.

This syntax is especially useful for test data, configuration tables, and any scenario where \
data is naturally two-dimensional. The visual alignment of columns makes the data easy to read \
and verify at a glance, unlike nested data structures that obscure the tabular nature of the data.

Table literals produce a typed list of records. The first row defines the column names and types, \
and subsequent rows provide the values. The compiler verifies that every row has the correct \
number of columns and that values match the declared types.

This feature is unique to Forge. While languages like Haskell have QuasiQuoters and Ruby has \
heredocs for embedding structured data, Forge's table literals are first-class syntax with full \
type checking and compile-time validation.",
}
