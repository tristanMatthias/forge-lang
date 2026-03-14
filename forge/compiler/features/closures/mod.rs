crate::forge_feature! {
    name: "Closures",
    id: "closures",
    status: Stable,
    depends: [],
    enables: ["it_parameter"],
    tokens: ["=>", "->"],
    ast_nodes: ["Closure"],
    description: "First-class anonymous functions with captured environment",
    syntax: ["(params) -> expr", "(params) -> { body }"],
    short: "(params) -> body — first-class closures with scope capture",
    symbols: ["->"],
    long_description: "\
Closures are anonymous functions created with the arrow syntax: `(x) -> x * 2`. They capture \
variables from their surrounding scope and can be passed as arguments, stored in variables, or \
returned from functions. Closures are the primary way to pass behavior in Forge, used heavily \
with collection methods like `map`, `filter`, and `each`.

The syntax is deliberately minimal. A single-parameter closure needs no parentheses around the \
parameter list: `x -> x + 1`. Multi-parameter closures use parentheses: `(a, b) -> a + b`. \
For closures with a single parameter, Forge also supports the `it` implicit parameter, so \
`list.map(it * 2)` is equivalent to `list.map((x) -> x * 2)`.

Closures infer their parameter and return types from context. When you write \
`numbers.map((n) -> n.to_string())`, the compiler knows `n` is an `int` because `numbers` is \
a `list<int>`, and knows the closure returns `string` because `to_string()` does.

Compared to other languages, Forge closures are closest to Kotlin's lambdas or Swift's \
closures. The `->` syntax was chosen over `=>` (JavaScript) to avoid ambiguity with comparison \
operators and to visually distinguish closures from match arms.",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
