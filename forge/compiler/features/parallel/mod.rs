crate::forge_feature! {
    name: "Parallel",
    id: "parallel",
    status: Stable,
    depends: ["spawn"],
    enables: [],
    tokens: ["parallel"],
    ast_nodes: [],
    description: "Parallel execution blocks for structured concurrency",
    syntax: [],
    short: "parallel execution primitives",
    symbols: [],
    long_description: "\
Parallel execution primitives in Forge enable concurrent processing of independent tasks. The \
parallel infrastructure works with the spawn and channel systems to distribute work across \
available cores.

Parallel operations are built on top of Forge's lightweight task system. Multiple spawned tasks \
can execute truly in parallel, and channels provide the synchronization points where results \
are collected. This model scales naturally with available hardware.

The parallel system handles the underlying thread management, work distribution, and result \
collection. User code simply spawns tasks and communicates through channels, without needing to \
manage threads, locks, or condition variables directly.",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
