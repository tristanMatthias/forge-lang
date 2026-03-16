pub mod parser;
pub mod codegen;
pub mod checker;
pub mod types;

crate::forge_feature! {
    name: "Is Keyword",
    id: "is_keyword",
    status: Stable,
    depends: ["pattern_matching"],
    enables: [],
    tokens: ["is"],
    ast_nodes: ["Is"],
    description: "Inline pattern check: value is Pattern → bool",
    syntax: ["value is Pattern", "value is Type"],
    short: "value is Pattern — runtime type and pattern checks",
    symbols: [],
    long_description: "\
The `is` keyword tests whether a value matches a pattern or belongs to a type. It returns a \
boolean and is used in conditions: `if value is int { ... }` or `if shape is Circle { ... }`. \
This is the lightweight alternative to a full `match` expression when you only care about one case.

With enums, `is` checks for a specific variant: `if result is Ok { ... }`. Combined with \
`if let`-style binding, it can extract the associated data: `if result is Ok(value) { ... }`. \
This handles the common pattern of checking-and-extracting in a single, readable expression.

The `is` keyword also works with nullable types: `if x is null { ... }` checks for null, and \
`if x is string { ... }` checks that a nullable value is present and of the expected type. \
This integrates naturally with Forge's null safety system.

Compared to `instanceof` in Java or `typeof` in JavaScript, `is` is a pattern matching \
operation, not just a type check. It can match literal values, types, enum variants, and \
complex patterns, making it strictly more powerful.",
    grammar: "<is_expr>     ::= <expr> \"is\" <pattern>",
    category: "Pattern Matching",
}
