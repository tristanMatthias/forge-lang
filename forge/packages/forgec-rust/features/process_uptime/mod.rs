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
    long_description: "\
Process uptime tracking provides the `process_uptime()` function, which returns the number of \
milliseconds since the current Forge process started. This is useful for performance monitoring, \
logging elapsed time, and implementing timeouts.

The uptime is measured from process start, not from when the function is first called. This \
gives consistent, comparable timestamps throughout the program's execution. Combined with \
duration literals, you can write expressive timing checks: `if process_uptime() > 30s { ... }`.

The implementation uses the operating system's monotonic clock, so the value always increases \
and is not affected by system clock adjustments. This makes it reliable for measuring intervals \
even if the system time is changed during execution.",
    category: "Special",
}

crate::builtin_fn! { name: "process_uptime", feature: "process_uptime", params: [], ret: Int, variadic: false }

// Runtime function declarations
crate::runtime_fn! { name: "forge_process_uptime", feature: "process_uptime", params: [], ret: I64 }

pub mod codegen;
