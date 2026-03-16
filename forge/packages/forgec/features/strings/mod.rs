crate::forge_feature! {
    name: "Strings",
    id: "strings",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: [],
    description: "String methods: length, upper, lower, trim, contains, split, starts_with, ends_with, replace, parse_int, repeat, char_at, byte_at, bytes, chars, char_code",
    syntax: ["\"hello\"", "s.length()", "s.split(sep)", "s.char_at(i)", "char_code(s)"],
    short: "UTF-8 strings with built-in methods",
    symbols: [],
    long_description: "\
Strings in Forge are UTF-8 encoded, immutable sequences of characters. String literals use double \
quotes: `\"hello world\"`. Template literals with `${}` interpolation provide the primary way to \
build strings dynamically: `\"Hello, ${name}! You are ${age} years old.\"`.

Strings support a comprehensive set of methods: `length()`, `contains(sub)`, `starts_with(prefix)`, \
`ends_with(suffix)`, `to_upper()`, `to_lower()`, `trim()`, `split(separator)`, `replace(old, new)`, \
`substring(start, end)`, and more. These methods return new strings rather than mutating in place, \
consistent with Forge's immutability-first design.

String comparison uses `==` for value equality, not reference equality. Strings can be concatenated \
with `+`, though template literals are preferred for building complex strings since they are more \
readable and less error-prone than chained concatenation.

Multi-line strings are supported naturally. Forge does not have a separate character type; single \
characters are simply strings of length one.",
    category: "Strings",
    category_order: Primary,
}

crate::builtin_namespace_method! { namespace: "string", method: "from_ptr", feature: "strings", ret: String }
crate::builtin_fn! { name: "char_code", feature: "strings", params: [String], ret: Int, variadic: false }

// Runtime function declarations
crate::runtime_fn! { name: "forge_string_new", feature: "strings", params: [Ptr, I64], ret: ForgeString }
crate::runtime_fn! { name: "forge_string_concat", feature: "strings", params: [ForgeString, ForgeString], ret: ForgeString }
crate::runtime_fn! { name: "forge_int_to_string", feature: "strings", params: [I64], ret: ForgeString }
crate::runtime_fn! { name: "forge_float_to_string", feature: "strings", params: [F64], ret: ForgeString }
crate::runtime_fn! { name: "forge_bool_to_string", feature: "strings", params: [I8], ret: ForgeString }
crate::runtime_fn! { name: "forge_string_length", feature: "strings", params: [ForgeString], ret: I64 }
crate::runtime_fn! { name: "forge_string_upper", feature: "strings", params: [ForgeString], ret: ForgeString }
crate::runtime_fn! { name: "forge_string_lower", feature: "strings", params: [ForgeString], ret: ForgeString }
crate::runtime_fn! { name: "forge_string_trim", feature: "strings", params: [ForgeString], ret: ForgeString }
crate::runtime_fn! { name: "forge_string_contains", feature: "strings", params: [ForgeString, ForgeString], ret: I8 }
crate::runtime_fn! { name: "forge_string_starts_with", feature: "strings", params: [ForgeString, ForgeString], ret: I8 }
crate::runtime_fn! { name: "forge_string_ends_with", feature: "strings", params: [ForgeString, ForgeString], ret: I8 }
crate::runtime_fn! { name: "forge_string_replace", feature: "strings", params: [ForgeString, ForgeString, ForgeString], ret: ForgeString }
crate::runtime_fn! { name: "forge_string_parse_int", feature: "strings", params: [ForgeString], ret: I64 }
crate::runtime_fn! { name: "forge_string_parse_float", feature: "strings", params: [ForgeString], ret: F64 }
crate::runtime_fn! { name: "forge_string_repeat", feature: "strings", params: [ForgeString, I64], ret: ForgeString }
crate::runtime_fn! { name: "forge_string_substring", feature: "strings", params: [ForgeString, I64, I64], ret: ForgeString }
crate::runtime_fn! { name: "forge_string_eq", feature: "strings", params: [ForgeString, ForgeString], ret: I8 }
crate::runtime_fn! { name: "forge_string_char_at", feature: "strings", params: [ForgeString, I64], ret: ForgeString }
crate::runtime_fn! { name: "forge_string_byte_at", feature: "strings", params: [ForgeString, I64], ret: I64 }
crate::runtime_fn! { name: "forge_string_bytes", feature: "strings", params: [ForgeString, Ptr], ret: I64 }
crate::runtime_fn! { name: "forge_string_chars", feature: "strings", params: [ForgeString, Ptr], ret: I64 }
crate::runtime_fn! { name: "forge_char_code", feature: "strings", params: [ForgeString], ret: I64 }
crate::runtime_fn! { name: "strlen", feature: "strings", params: [Ptr], ret: I64, conditional: true }

pub mod checker;
pub mod codegen;
