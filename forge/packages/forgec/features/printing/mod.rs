crate::forge_feature! {
    name: "Printing",
    id: "printing",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: [],
    description: "Output with println() and print()",
    syntax: [
        "println(value)           — print value with newline",
        "print(value)             — print value without newline",
        "println(`hello ${name}`) — print with string interpolation",
    ],
    short: "println(value), print(value) — console output",
    symbols: [],
    long_description: "\
`println()` prints a value followed by a newline. `print()` prints without a trailing newline. \
Both accept any type — strings are printed directly, other types are automatically converted \
to their string representation.

For formatted output, use template strings: `println(`Hello ${name}, you are ${string(age)}`)`. \
Template strings use backticks and `${}` for interpolation (see string_templates feature).

`println()` is the primary debugging and output tool. There is no `printf`-style formatting — \
use template strings and `string()` conversion instead. This keeps the API surface small and \
consistent.",
    grammar: "<print_call> ::= (\"println\" | \"print\") \"(\" <expr> \")\"",
    category: "Basics",
    category_order: Core,
}

crate::builtin_fn! { name: "println", feature: "printing", params: [String], ret: Void, variadic: true }
crate::builtin_fn! { name: "print", feature: "printing", params: [String], ret: Void, variadic: true }

// Runtime function declarations
crate::runtime_fn! { name: "forge_println_string", feature: "printing", params: [ForgeString], ret: Void }
crate::runtime_fn! { name: "forge_println_int", feature: "printing", params: [I64], ret: Void }
crate::runtime_fn! { name: "forge_println_float", feature: "printing", params: [F64], ret: Void }
crate::runtime_fn! { name: "forge_println_bool", feature: "printing", params: [I8], ret: Void }
crate::runtime_fn! { name: "forge_print_string", feature: "printing", params: [ForgeString], ret: Void }
crate::runtime_fn! { name: "forge_print_int", feature: "printing", params: [I64], ret: Void }
crate::runtime_fn! { name: "forge_print_float", feature: "printing", params: [F64], ret: Void }
crate::runtime_fn! { name: "forge_print_bool", feature: "printing", params: [I8], ret: Void }
