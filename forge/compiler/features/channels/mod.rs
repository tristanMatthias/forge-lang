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
}
