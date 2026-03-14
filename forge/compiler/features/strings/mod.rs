crate::forge_feature! {
    name: "Strings",
    id: "strings",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: [],
    description: "String methods: length, upper, lower, trim, contains, split, starts_with, ends_with, replace, parse_int, repeat",
    syntax: [],
    short: "",
    symbols: [],
}

pub mod checker;
pub mod codegen;
