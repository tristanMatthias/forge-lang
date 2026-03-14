crate::forge_feature! {
    name: "Tuples",
    id: "tuples",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: ["TupleLit"],
    description: "Tuple literal expressions with heterogeneous element types",
    syntax: ["(a, b, c)", "let (x, y) = tuple"],
    short: "(a, b) — fixed-size heterogeneous collections with destructuring",
    symbols: [],
    long_description: "\
Tuples are fixed-size heterogeneous collections that group values of potentially different types. \
A tuple is written as `(value1, value2, ...)` and its type is `(Type1, Type2, ...)`. For example, \
`let pair = (\"Alice\", 30)` creates a tuple of type `(string, int)`.

Elements are accessed by position using dot notation with an index: `pair.0` returns `\"Alice\"` \
and `pair.1` returns `30`. Tuples are most useful for returning multiple values from functions \
without defining a named struct: `fn divide(a: int, b: int) -> (int, int) { (a / b, a % b) }`.

Tuples can be destructured in `let` bindings: `let (quotient, remainder) = divide(10, 3)`. This \
makes working with multi-return functions feel natural. Pattern matching also supports tuple \
patterns for more complex destructuring scenarios.

Compared to other languages, Forge tuples are closest to Python or Rust tuples. Use tuples for \
quick grouping of a few values. When you find yourself using tuples with more than three or four \
elements, consider switching to a named struct for clarity.",
}

pub mod types;
pub mod codegen;
pub mod checker;
