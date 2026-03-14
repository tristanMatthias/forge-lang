crate::forge_feature! {
    name: "JSON Builtins",
    id: "json_builtins",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: [],
    description: "Built-in json.parse(), json.stringify(), and json.parse_list() intrinsics",
    syntax: ["json.parse(str)", "json.stringify(val)"],
    short: "json.parse/stringify — JSON serialization/deserialization",
    symbols: [],
    long_description: "\
Forge provides built-in JSON functions: `json.parse(str)` converts a JSON string into a Forge \
value, and `json.stringify(value)` converts a Forge value into a JSON string. These functions \
handle the full JSON specification including nested objects, arrays, numbers, strings, booleans, \
and null.

`json.parse()` returns a dynamic value that can be accessed with field notation and indexing. \
The parsed structure maps JSON objects to Forge maps, JSON arrays to lists, and JSON primitives \
to their Forge equivalents (int, float, string, bool, null).

`json.stringify()` serializes any Forge value to its JSON representation. Structs become JSON \
objects with field names as keys. Lists become JSON arrays. This round-trips cleanly with \
`json.parse()`, so `json.parse(json.stringify(value))` preserves the structure.

These built-in functions avoid the need for an external JSON library in the vast majority of use \
cases. They are implemented as intrinsics for maximum performance, with the serialization and \
deserialization happening in optimized native code.",
    category: "Special",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
