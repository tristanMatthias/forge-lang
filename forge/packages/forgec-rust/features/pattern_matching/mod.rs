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
    description: "Exhaustive pattern matching with destructuring, guards, nested patterns, and or-patterns",
    syntax: ["match expr { pattern -> body, ... }", "match expr { pattern if guard -> body }", ".Variant(.Inner(x), y) -> expr"],
    short: "match expr { pattern -> body } — exhaustive pattern matching with guards and nested patterns",
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

Nested patterns allow deep destructuring of enum variants. Instead of matching an outer variant \
and then separately matching its fields, you can match the entire structure in one pattern: \
`.Add(.Lit(a), .Lit(b)) -> a + b`. Nesting works to arbitrary depth for non-boxed fields and \
supports wildcards (`_`), variable bindings, and literal values at any level. For recursive \
(boxed) enum fields, nested pattern checks are deferred to the arm body to avoid unsafe pointer \
dereferences before the tag check branches.

Syntax: `.OuterVariant(.InnerVariant(binding), other_binding) -> body`. \
Sub-patterns in enum variant fields can be: variable bindings (`x`), wildcards (`_`), \
literal values (`0`, `\"hello\"`), or nested enum patterns (`.Variant(...)`, `.Variant`). \
Example with a recursive AST enum: \
`enum Expr { Lit(value: int), Add(left: Expr, right: Expr) }` — \
`match e { .Add(.Lit(a), .Lit(b)) -> a + b, .Add(l, .Lit(0)) -> eval(l), _ -> 0 }`.

Match works especially well with enums, where each variant becomes a pattern. The compiler ensures \
every variant is handled, so adding a new variant to an enum immediately highlights every match \
expression that needs updating. This is the same exhaustiveness guarantee that makes Rust's and \
Haskell's pattern matching so reliable.",
    grammar: "<match_expr>  ::= \"match\" <expr> \"{\" (<pattern> \"->\" <expr>)* \"}\"",
    category: "Pattern Matching",
    category_order: Primary,
}
