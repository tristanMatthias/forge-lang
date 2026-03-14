crate::forge_feature! {
    name: "Datetime",
    id: "datetime",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: [],
    description: "Datetime helpers: datetime_now(), datetime_format(), datetime_parse() — epoch milliseconds",
    syntax: ["datetime_now()", "datetime_format(ts, fmt)", "datetime_parse(s, fmt)"],
    short: "datetime_now/format/parse — epoch millisecond timestamps",
    symbols: [],
}

pub mod codegen;
