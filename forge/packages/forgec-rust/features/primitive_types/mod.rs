crate::forge_feature! {
    name: "Primitive Types",
    id: "primitive_types",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: [],
    description: "Built-in types: int, float, string, bool, and null",
    syntax: [
        "int       — 64-bit signed integer (42, -1, 1_000_000)",
        "float     — 64-bit IEEE 754 (3.14, -0.5, 1.0e10)",
        "string    — UTF-8 text (\"hello\", `template ${x}`)",
        "bool      — true or false",
        "null      — absence of value (only valid for T? types)",
        "let x: int = 42   — explicit type annotation",
    ],
    short: "int, float, string, bool, null — with type inference",
    symbols: [],
    long_description: "\
Forge has five primitive types. `int` is a 64-bit signed integer. `float` is a 64-bit \
IEEE 754 floating point number. `string` is a UTF-8 encoded text value. `bool` is either \
`true` or `false`. `null` represents the absence of a value and can only appear in nullable \
types (`T?`).

Type annotations are written after the variable name with a colon: `let x: int = 42`. Most \
of the time you can omit the annotation — the compiler infers the type from the value. \
Annotations are required on function parameters: `fn add(a: int, b: int) -> int`.

Forge is statically typed: all types are known at compile time. There is no dynamic typing, \
`any` type, or runtime type coercion. If you need to convert between types, use explicit \
conversion functions like `string(42)` or `int(\"42\")`.

Numeric literals support underscores for readability: `1_000_000`. Float literals require a \
digit before the decimal point: `0.5` not `.5`.",
    grammar: "<type> ::= \"int\" | \"float\" | \"string\" | \"bool\" | \"void\" | <ident>",
    category: "Basics",
    category_order: Core,
}
