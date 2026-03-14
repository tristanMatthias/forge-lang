crate::forge_feature! {
    name: "Strings",
    id: "strings",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: [],
    description: "String methods: length, upper, lower, trim, contains, split, starts_with, ends_with, replace, parse_int, repeat",
    syntax: ["\"hello\"", "s.length()", "s.split(sep)"],
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
}

pub mod checker;
pub mod codegen;
