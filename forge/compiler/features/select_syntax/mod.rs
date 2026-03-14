pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;

crate::forge_feature! {
    name: "Select Syntax",
    id: "select_syntax",
    status: Stable,
    depends: ["channels"],
    enables: [],
    tokens: ["select"],
    ast_nodes: ["Select", "SelectArm"],
    description: "Channel multiplexing with select { binding <- ch -> body } and guards",
    syntax: ["select { binding <- ch -> body }"],
    short: "select { x <- ch -> body } — multiplex channel receives",
    symbols: [],
    long_description: "\
The `select` expression multiplexes receives from multiple channels, executing the arm for \
whichever channel has data ready first. This is essential for concurrent programs that need to \
respond to events from multiple sources without dedicating a task to each.

Syntax: `select { msg <- ch1 -> handle(msg), data <- ch2 -> process(data) }`. Each arm binds \
the received value and executes its body. If multiple channels are ready simultaneously, one is \
chosen at random to prevent starvation. Select blocks until at least one channel is ready.

Select arms support guards with `if condition`, enabling conditional receives. A guard is checked \
before attempting the receive, so `data <- ch if enabled -> handle(data)` only receives from `ch` \
when `enabled` is true. This provides fine-grained control over which channels are active.

The select statement is modeled after Go's select and mirrors its semantics. Combined with spawn \
and channels, it completes Forge's CSP concurrency model, enabling patterns like fan-in, fan-out, \
timeouts, and graceful shutdown.",
    grammar: "<select_stmt> ::= \"select\" \"{\" (<ident> \"<-\" <expr> \"->\" <block>)* \"}\"",
    category: "Concurrency",
}
