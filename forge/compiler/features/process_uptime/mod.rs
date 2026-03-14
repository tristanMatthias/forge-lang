crate::forge_feature! {
    name: "Process Uptime",
    id: "process_uptime",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: [],
    description: "process_uptime() — returns milliseconds since program start",
    syntax: ["process_uptime()"],
    short: "process_uptime() — milliseconds since process start",
    symbols: [],
}

pub mod codegen;
