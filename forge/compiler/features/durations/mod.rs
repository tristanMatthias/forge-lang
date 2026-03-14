crate::forge_feature! {
    name: "Duration Literals",
    id: "durations",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: [],
    description: "Duration literal suffixes: 7d, 24h, 5m, 1s compile to millisecond integers",
    syntax: ["7d", "24h", "5m", "10s", "500ms"],
    short: "7d, 24h, 5m, 10s — duration literal suffixes",
    symbols: [],
}
