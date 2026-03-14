pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;

crate::forge_feature! {
    name: "Channels",
    id: "channels",
    status: Stable,
    depends: ["spawn"],
    enables: ["select_syntax"],
    tokens: ["<-"],
    ast_nodes: ["ChannelSend", "ChannelReceive"],
    description: "Channel-based communication with send (<-), receive (<-), and iteration",
    syntax: ["ch <- value", "<- ch", "for msg in ch { }"],
    short: "ch <- val (send), <- ch (recv) — typed channel communication",
    symbols: ["<-"],
    long_description: "\
Channels are typed conduits for communication between concurrent tasks. Create a channel with \
`channel.new()`, send values with `ch <- value`, and receive with `<- ch`. Channels are the \
safe, structured way to pass data between spawned tasks without shared mutable state.

Channels are generic: `channel.new<int>()` creates a channel that carries integers. The type \
system ensures you never accidentally send a string through an int channel. Both the send and \
receive operations are type-checked at compile time.

Channels can be iterated with `for msg in ch { ... }`, which receives messages in a loop until \
the channel is closed with `channel.close(ch)`. This pattern is the idiomatic way to process a \
stream of values from a producer task. Timed channels created with `channel.tick(ms)` send a \
value at regular intervals, useful for periodic tasks.

Forge channels follow the same model as Go channels. They are unbuffered by default, meaning a \
send blocks until a receiver is ready. This synchronization property makes channel-based programs \
easier to reason about than lock-based alternatives.",
}
