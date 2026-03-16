crate::forge_feature! {
    name: "Stderr Printing",
    id: "stderr",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: [],
    description: "Error output with eprintln() and eprint()",
    syntax: [
        "eprintln(value)           — print value to stderr with newline",
        "eprint(value)             — print value to stderr without newline",
        "eprintln(`error: ${msg}`) — print to stderr with string interpolation",
    ],
    short: "eprintln(value), eprint(value) — stderr output",
    symbols: [],
    long_description: "\
`eprintln()` prints a value to stderr followed by a newline. `eprint()` prints to stderr without \
a trailing newline. Both accept any type — strings are printed directly, other types are \
automatically converted to their string representation.

These are the stderr counterparts of `println()` and `print()`. Use them for error messages, \
warnings, and diagnostic output that should not be mixed with normal program output on stdout.

For formatted output, use template strings: `eprintln(`error at line ${string(line)}`)`. \
Template strings use backticks and `${}` for interpolation (see string_templates feature).",
    grammar: "<eprint_call> ::= (\"eprintln\" | \"eprint\") \"(\" <expr> \")\"",
    category: "Basics",
    category_order: Core,
}

crate::builtin_fn! { name: "eprintln", feature: "stderr", params: [String], ret: Void, variadic: true }
crate::builtin_fn! { name: "eprint", feature: "stderr", params: [String], ret: Void, variadic: true }

// Runtime function declarations
crate::runtime_fn! { name: "forge_eprintln_string", feature: "stderr", params: [ForgeString], ret: Void }
crate::runtime_fn! { name: "forge_eprintln_int", feature: "stderr", params: [I64], ret: Void }
crate::runtime_fn! { name: "forge_eprintln_float", feature: "stderr", params: [F64], ret: Void }
crate::runtime_fn! { name: "forge_eprintln_bool", feature: "stderr", params: [I8], ret: Void }
crate::runtime_fn! { name: "forge_eprint_string", feature: "stderr", params: [ForgeString], ret: Void }
crate::runtime_fn! { name: "forge_eprint_int", feature: "stderr", params: [I64], ret: Void }
crate::runtime_fn! { name: "forge_eprint_float", feature: "stderr", params: [F64], ret: Void }
crate::runtime_fn! { name: "forge_eprint_bool", feature: "stderr", params: [I8], ret: Void }
