crate::forge_feature! {
    name: "Type Conversion",
    id: "type_conversion",
    status: Stable,
    depends: ["primitive_types"],
    enables: [],
    tokens: [],
    ast_nodes: [],
    description: "Explicit type conversion with string(), int(), float(), bool()",
    syntax: [
        "string(value)  — convert any value to string",
        "int(value)     — parse string or truncate float to int",
        "float(value)   — parse string or widen int to float",
    ],
    short: "string(), int(), float() — explicit type conversion functions",
    symbols: [],
    long_description: "\
Forge never coerces types implicitly. To convert between types, use the type name as a \
function: `string(42)` produces `\"42\"`, `int(\"42\")` produces `42`, `float(3)` produces \
`3.0`.

The `string()` function works on any value — it is the universal converter for display and \
serialization. `int()` and `float()` parse strings and convert between numeric types. \
`bool()` performs a truthiness check: `false`, `null`, `0`, `0.0`, and `\"\"` are falsy; \
everything else is truthy.

This explicit-conversion design prevents the subtle bugs that plague languages with implicit \
coercion (like JavaScript's `\"1\" + 2 == \"12\"`). In Forge, `\"1\" + 2` is a type error. \
You must write `int(\"1\") + 2` or `\"1\" + string(2)`.",
    grammar: "<conversion> ::= (\"string\" | \"int\" | \"float\" | \"bool\") \"(\" <expr> \")\"",
    category: "Basics",
    category_order: Core,
}

crate::builtin_fn! { name: "string", feature: "type_conversion", params: [Unknown], ret: String, variadic: true }
crate::builtin_fn! { name: "int", feature: "type_conversion", params: [Unknown], ret: Int, variadic: true }
crate::builtin_fn! { name: "float", feature: "type_conversion", params: [Unknown], ret: Float, variadic: true }

pub mod codegen;
