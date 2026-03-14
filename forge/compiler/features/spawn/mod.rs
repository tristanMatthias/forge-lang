pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;

crate::forge_feature! {
    name: "Spawn",
    id: "spawn",
    status: Stable,
    depends: [],
    enables: ["channels"],
    tokens: ["spawn"],
    ast_nodes: ["SpawnBlock"],
    description: "Concurrent execution with spawn { ... } blocks",
    syntax: ["spawn { body }"],
    short: "spawn { } — lightweight concurrent task execution",
    symbols: [],
    long_description: "\
The `spawn` keyword launches a concurrent task that executes independently from the spawning \
code. `spawn { expensive_computation() }` starts the computation and immediately continues \
with the next line. Tasks run concurrently, and their results can be communicated back through \
channels.

Spawn is the primary concurrency primitive in Forge. Rather than managing threads directly, you \
spawn lightweight tasks and communicate between them using channels. This follows the CSP \
(Communicating Sequential Processes) model, where shared state is replaced by message passing.

Spawned tasks share no mutable state with the spawning code. Any data needed by the task is \
captured at spawn time. This eliminates data races by construction, since there is no shared \
mutable memory to race on.

The model is similar to Go's goroutines and Erlang's processes. Tasks are lightweight enough to \
spawn thousands without performance concerns. Combined with channels and select, spawn provides \
a complete concurrent programming toolkit.",
}
