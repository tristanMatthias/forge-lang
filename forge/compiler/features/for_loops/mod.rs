pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;

crate::forge_feature! {
    name: "For Loops",
    id: "for_loops",
    status: Stable,
    depends: ["ranges"],
    enables: [],
    tokens: ["for", "in"],
    ast_nodes: ["For"],
    description: "For-in loops over ranges, lists, maps, and channels",
    syntax: ["for x in collection { body }", "for x in start..end { body }"],
    short: "for x in collection — iterate lists, ranges, maps, channels",
    symbols: [],
    long_description: "\
For loops in Forge use the `for...in` syntax to iterate over ranges, lists, maps, and channels. \
The simplest form is `for i in 0..10 { ... }` which iterates from 0 to 9. Use `0..=10` for an \
inclusive range that includes 10.

When iterating over lists, the loop variable takes on each element: `for item in my_list { ... }`. \
For maps, you can destructure the key-value pair: `for (key, value) in my_map { ... }`. This \
uniform syntax means you learn one loop construct and use it everywhere.

For loops can also iterate over channels, which makes them a natural fit for concurrent programming \
patterns. When used with a channel, `for msg in ch { ... }` will receive and process messages until \
the channel is closed. This is the idiomatic way to consume a stream of values from a concurrent task.

Unlike C-style for loops, Forge's `for...in` cannot produce off-by-one errors because you never \
manually manage an index variable. If you need the index alongside the value, use the `enumerate` \
method on the collection.",
    grammar: "<for_stmt>    ::= \"for\" <ident> \"in\" <expr> <block>",
    category: "Control Flow",
}
