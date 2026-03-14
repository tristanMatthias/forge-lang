crate::forge_feature! {
    name: "While Loops",
    id: "while_loops",
    status: Stable,
    depends: [],
    enables: [],
    tokens: ["while", "loop", "break", "continue"],
    ast_nodes: ["While", "Loop", "Break", "Continue"],
    description: "While loops, infinite loops, break with value, and continue",
    syntax: ["while condition { body }"],
    short: "while cond { } — conditional loop",
    symbols: [],
    long_description: "\
While loops repeat a block as long as a condition remains true. The syntax is straightforward: \
`while condition { body }`. This is the right choice when the number of iterations is not known \
in advance and depends on some runtime condition.

A common pattern is `while true { ... }` for infinite loops that terminate via `break`. This is \
useful for event loops, REPL implementations, and retry logic. The `break` keyword exits the \
loop immediately, and `continue` skips to the next iteration.

While loops are generally less common in idiomatic Forge than `for...in` loops, since most \
iteration involves collections or ranges. Prefer `for` when you know what you are iterating over, \
and reserve `while` for conditions that depend on external state or complex termination logic.",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
