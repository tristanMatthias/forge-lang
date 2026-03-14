crate::forge_feature! {
    name: "Process Uptime",
    id: "process_uptime",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: [],
    description: "process_uptime() — returns milliseconds since program start",
}

pub mod codegen;
