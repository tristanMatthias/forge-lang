pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;

crate::forge_feature! {
    name: "Pattern Matching",
    id: "pattern_matching",
    status: Stable,
    depends: [],
    enables: ["null_safety"],
    tokens: ["match", "->", "_"],
    ast_nodes: ["Match", "MatchArm", "Pattern"],
    description: "Exhaustive pattern matching with destructuring, guards, and or-patterns",
    syntax: ["match expr { pattern -> body, ... }", "match expr { pattern if guard -> body }"],
    short: "match expr { pattern -> body } — exhaustive pattern matching with guards",
    symbols: [],
    long_description: "\
Pattern matching with `match` is one of the most powerful features in Forge. A match expression \
takes a value and compares it against a series of patterns, executing the arm that matches first. \
Unlike chains of `if`/`else if`, match is exhaustive: the compiler verifies that every possible \
case is covered, preventing subtle bugs.

Patterns can match literal values (`1`, `\"hello\"`), bind variables (`x`), destructure data \
structures, and use guards for additional conditions. For example: \
`match status { \"ok\" -> handle_ok(), \"error\" -> handle_err(), _ -> handle_unknown() }`. \
The underscore `_` is the wildcard pattern that matches anything.

Guards add conditions to patterns with `if`: `match score { n if n > 90 -> \"A\", n if n > 80 -> \"B\", _ -> \"C\" }`. \
This combines the clarity of pattern matching with the flexibility of arbitrary boolean conditions. \
Guards are checked after the pattern matches, so you can use bound variables in the guard expression.

Match works especially well with enums, where each variant becomes a pattern. The compiler ensures \
every variant is handled, so adding a new variant to an enum immediately highlights every match \
expression that needs updating. This is the same exhaustiveness guarantee that makes Rust's and \
Haskell's pattern matching so reliable.",
    grammar: "<match_expr>  ::= \"match\" <expr> \"{\" (<pattern> \"->\" <expr>)* \"}\"",
    category: "Pattern Matching",
    category_order: Primary,
}
