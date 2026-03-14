pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;

crate::forge_feature! {
    name: "Ranges",
    id: "ranges",
    status: Stable,
    depends: [],
    enables: ["for_loops"],
    tokens: ["..", "..="],
    ast_nodes: ["Range"],
    description: "Range expressions: 0..10 (exclusive) and 0..=10 (inclusive)",
    syntax: ["start..end", "start..=end"],
    short: "start..end (exclusive), start..=end (inclusive) — range expressions",
    symbols: ["..", "..="],
    long_description: "\
Ranges represent a sequence of consecutive values, written with the `..` operator. An exclusive \
range `0..5` includes 0, 1, 2, 3, 4. An inclusive range `0..=5` also includes 5. Ranges are most \
commonly used in `for` loops: `for i in 0..n { ... }`.

Ranges are first-class values that can be stored in variables and passed to functions. They support \
the `contains` method for membership testing: `(1..10).contains(5)` returns true. This makes ranges \
useful for validation and bounds checking beyond just iteration.

The exclusive range `..` is the default because it aligns with zero-based indexing. When you write \
`for i in 0..list.length() { ... }`, there is no off-by-one risk. Use the inclusive form `..=` \
when you specifically need the endpoint, such as `for day in 1..=31 { ... }`.",
    grammar: "<range_expr>  ::= <expr> \"..\" <expr> | <expr> \"..=\" <expr>",
}
