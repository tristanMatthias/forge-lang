crate::forge_feature! {
    name: "Functions",
    id: "functions",
    status: Stable,
    depends: [],
    enables: [],
    tokens: ["fn", "return"],
    ast_nodes: ["FnDecl", "Return"],
    description: "Function declarations with parameters, return types, and return statements",
    syntax: ["fn name(params) -> type { body }", "fn name(params) { body }"],
    short: "fn declarations with type inference and implicit return",
    symbols: ["fn"],
    long_description: "\
Functions are declared with `fn`, followed by the function name, parameters in parentheses, \
and an optional return type. The body is a block expression, and the last expression in the \
block is the implicit return value. For example: `fn double(x: int) -> int { x * 2 }`.

Parameter types are required, but return types can usually be inferred. If a function returns \
nothing, the return type is `void`. Functions are first-class values: you can pass them as \
arguments, store them in variables, and return them from other functions.

Forge functions support early return with the `return` keyword, but idiomatic Forge prefers \
implicit returns via the last expression. This keeps functions concise and encourages a \
functional style. Functions can call themselves recursively, and the compiler handles tail \
calls efficiently where possible.

Unlike languages that distinguish between functions and methods at the syntax level, Forge \
treats all callables uniformly. Methods on types are just functions that receive the type as \
their first argument, accessed through dot notation.",
    grammar: "<fn_decl>     ::= \"fn\" <ident> \"(\" <params> \")\" [\"->\" <type>] <block>",
    category: "Functions",
    category_order: Primary,
}

crate::builtin_fn! { name: "assert", feature: "functions", params: [Bool], ret: Void, variadic: true }
crate::builtin_fn! { name: "sleep", feature: "functions", params: [Int], ret: Void, variadic: false }

// Runtime function declarations
crate::runtime_fn! { name: "forge_alloc", feature: "functions", params: [I64], ret: Ptr }
crate::runtime_fn! { name: "forge_spawn", feature: "functions", params: [Ptr], ret: Void }
crate::runtime_fn! { name: "forge_sleep_ms", feature: "functions", params: [I64], ret: Void }
crate::runtime_fn! { name: "forge_rc_retain", feature: "functions", params: [Ptr], ret: Void }
crate::runtime_fn! { name: "forge_rc_release", feature: "functions", params: [Ptr], ret: Void }
crate::runtime_fn! { name: "forge_panic", feature: "functions", params: [Ptr, I64], ret: Void }
crate::runtime_fn! { name: "forge_assert", feature: "functions", params: [I8, Ptr, I64, Ptr, I64, I64, I64], ret: Void, conditional: true }
crate::runtime_fn! { name: "snprintf", feature: "functions", params: [Ptr, I64, Ptr], ret: I32, conditional: true }
crate::runtime_fn! { name: "forge_write_cstring", feature: "functions", params: [Ptr, I64, Ptr, I64], ret: Void, conditional: true }
crate::runtime_fn! { name: "atoll", feature: "functions", params: [Ptr], ret: I64, conditional: true }

pub mod types;
pub mod parser;
pub mod checker;
pub mod codegen;
