crate::forge_feature! {
    name: "String Templates",
    id: "string_templates",
    status: Stable,
    depends: [],
    enables: [],
    tokens: ["`"],
    ast_nodes: ["TemplateLit"],
    description: "Backtick string interpolation with ${expr} embedded expressions",
    syntax: ["\"hello ${name}\""],
    short: "\"...${expr}...\" — template literal string interpolation",
    symbols: [],
    long_description: "\
String template literals use `${}` syntax to embed expressions inside strings: \
`\"Hello, ${name}!\"`. The expression inside the braces is evaluated, converted to a string, \
and inserted into the result. Any valid Forge expression can appear inside `${}`, including \
function calls, arithmetic, and method chains.

Template literals are the preferred way to construct dynamic strings in Forge. They are more \
readable than string concatenation and less error-prone than format functions with positional \
arguments. The embedded expressions are type-checked at compile time.

Nested templates are supported: `\"outer ${\"inner ${value}\"}\"`. Template interpolation works \
with all types that have a string representation, including numbers, booleans, and any type with \
a `to_string()` method.

This feature works identically to JavaScript template literals and Kotlin string templates. It \
is the foundation for tagged templates, which process the string parts and interpolated values \
through a custom function.",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
