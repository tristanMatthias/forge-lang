// The `it` parameter is handled entirely at parse time: when `expr_contains_it` detects
// a reference to `it` in a call argument, the parser wraps the expression in a closure
// `(it) -> <expr>`. By the time type checking runs, `it` is just a normal closure parameter.
// No additional type-checking logic is needed here.
