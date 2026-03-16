crate::forge_feature! {
    name: "Null Throw",
    id: "null_throw",
    status: Testing,
    depends: ["null_safety"],
    enables: [],
    tokens: [],
    ast_nodes: ["NullThrow"],
    description: "Convert null values to panics with ?? throw .error",
    syntax: ["expr ?? throw .error"],
    short: "x ?? throw .err (null-to-panic)",
    symbols: ["?? throw"],
    long_description: "\
The null throw operator `?? throw` converts a null value into a runtime panic. Unlike `??` which \
provides a fallback value, `?? throw` aborts execution with an error when a nullable value is null. \
This is useful when null represents an unexpected condition that should halt the program.\n\
\n\
Example: `let user = find_user(id) ?? throw .not_found` will unwrap the user if present, or \
panic with \"not_found\" if null.",
    grammar: "<null_throw> ::= <expr> \"??\" \"throw\" <expr>",
    category: "Null Safety",
}

pub mod types;
pub mod checker;
pub mod codegen;
