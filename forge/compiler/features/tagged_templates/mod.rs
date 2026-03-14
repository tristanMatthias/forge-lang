pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;

crate::forge_feature! {
    name: "Tagged Templates",
    id: "tagged_templates",
    status: Stable,
    depends: ["string_templates"],
    enables: [],
    tokens: ["tag`...`"],
    ast_nodes: ["TaggedTemplate"],
    description: "Tagged template literals: tag`template ${expr}` desugars to calling tag with separated parts and values as JSON",
    syntax: ["tag\"template ${expr}\"", "tag`template`"],
    short: "tag\"...\" — tagged template literal processing",
    symbols: [],
    long_description: "\
Tagged templates let you process template literals through a function before they are assembled \
into a string. A tagged template is a function call followed by a template literal: \
`sql\"SELECT * FROM ${table} WHERE id = ${id}\"`. The tag function receives the string parts \
and interpolated values separately, enabling safe, structured processing.

The primary use case is safe SQL query construction, where interpolated values must be \
parameterized to prevent injection attacks. The `sql` tag can build a parameterized query \
with `$1`, `$2` placeholders and a separate values array. HTML escaping, URL encoding, and \
regex construction are other natural applications.

Tag functions receive an array of string fragments and an array of interpolated values, \
giving them full control over how the pieces are assembled. This is strictly more powerful \
than simple string interpolation, since the tag can validate, transform, or reject the \
interpolated values.

Tagged templates originate in JavaScript (ES2015) and work similarly in Forge. The key \
difference is that Forge's version is fully typed: the compiler knows the return type of \
the tag function and type-checks the interpolated expressions.",
}
