pub mod codegen;

crate::forge_feature! {
    name: "Operators",
    id: "operators",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: ["Binary", "Unary"],
    description: "Binary and unary operators (arithmetic, comparison, logical). Core structural types — AST variants remain in core.",
    syntax: ["a + b", "a == b", "a and b", "not a"],
    short: "arithmetic, comparison, and logical operators",
    symbols: [],
    long_description: "\
Forge provides the standard set of arithmetic operators (`+`, `-`, `*`, `/`, `%`), comparison \
operators (`==`, `!=`, `<`, `>`, `<=`, `>=`), and logical operators (`and`, `or`, `not`). \
Arithmetic operators work on `int` and `float` types, with automatic promotion when mixing them.

String concatenation uses `+`, so `\"hello\" + \" world\"` produces `\"hello world\"`. Comparison \
operators work on numbers and strings (lexicographic comparison). Logical operators use words \
rather than symbols (`and` instead of `&&`, `or` instead of `||`) for readability.

The `%` modulo operator returns the remainder of integer division. Division between two integers \
performs integer division; use a float operand if you need decimal results. All operators have \
the precedence you would expect from mathematics: multiplication and division bind tighter than \
addition and subtraction, and comparison operators bind tighter than logical operators.

Forge deliberately omits bitwise operators from the core language, since they are rarely needed \
in application-level code. This keeps the operator set small and the precedence rules simple.",
}
