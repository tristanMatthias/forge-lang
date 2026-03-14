crate::forge_feature! {
    name: "Defer",
    id: "defer",
    status: Stable,
    depends: [],
    enables: [],
    tokens: ["defer"],
    ast_nodes: ["Defer"],
    description: "Deferred execution of expressions before function return, executed in reverse order",
    syntax: ["defer expr"],
    short: "defer expr — execute when scope exits, LIFO order",
    symbols: [],
    long_description: "\
The `defer` statement schedules an expression to execute when the enclosing scope exits, \
regardless of whether the exit is normal or due to an error. This is the primary mechanism \
for resource cleanup in Forge: `let f = open(path); defer close(f)`. No matter how the \
function returns, the file will be closed.

Deferred expressions execute in LIFO (last-in, first-out) order. If you defer A then defer B, \
B executes first, then A. This matches the natural pattern of resource acquisition: resources \
acquired later should be released first.

Defer eliminates the need for finally blocks, destructors, or RAII patterns for resource management. \
It keeps the cleanup code next to the acquisition code, rather than at the bottom of a try/finally \
block potentially hundreds of lines away. This locality makes it easy to verify that every resource \
is properly cleaned up.

The concept comes from Go, where `defer` is used extensively. Forge's implementation works the \
same way, executing deferred expressions before every return point in the function, including \
early returns and error propagation with `?`.",
    grammar: "<defer_stmt>  ::= \"defer\" <expr>",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
