crate::forge_feature! {
    name: "Datetime",
    id: "datetime",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: [],
    description: "Datetime helpers: datetime_now(), datetime_format(), datetime_parse() — epoch milliseconds",
}

pub mod codegen;
