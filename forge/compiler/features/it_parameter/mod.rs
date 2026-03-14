crate::forge_feature! {
    name: "It Parameter",
    id: "it_parameter",
    status: Stable,
    depends: ["closures"],
    enables: [],
    tokens: ["it"],
    ast_nodes: [],
    description: "Implicit `it` parameter in single-argument closures: list.map(it * 2)",
    syntax: [".method(it * 2)"],
    short: "it — implicit single parameter in closures",
    symbols: [],
    long_description: "\
The `it` keyword is an implicit parameter available inside single-argument closures. Instead of \
writing `list.map((x) -> x * 2)`, you can write `list.map(it * 2)`. The `it` variable \
automatically refers to the single argument passed to the closure.

This syntactic sugar reduces noise in common patterns. Collection operations like `map`, `filter`, \
`each`, and `reduce` frequently take simple closures where naming the parameter adds no clarity. \
`numbers.filter(it > 0)` is clearer than `numbers.filter((n) -> n > 0)` because the intent is \
immediately obvious.

The `it` parameter is only available in single-argument closure contexts. If a closure takes \
multiple arguments, you must name them explicitly. This restriction prevents ambiguity and \
ensures `it` always has a clear, unambiguous meaning.

Kotlin popularized this pattern, and it works the same way in Forge. Groovy also uses `it` as \
an implicit closure parameter. The feature is purely syntactic sugar; every use of `it` has an \
equivalent explicit closure form.",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
