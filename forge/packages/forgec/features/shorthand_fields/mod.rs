crate::forge_feature! {
    name: "Shorthand Fields",
    id: "shorthand_fields",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: ["StructLit"],
    description: "Shorthand field syntax: { name } desugars to { name: name }",
    syntax: ["{ name }", "{ name, age }"],
    short: "{ name } instead of { name: name } — shorthand struct fields",
    symbols: [],
    long_description: "\
Shorthand field syntax allows you to write `{ name }` instead of `{ name: name }` when \
constructing a struct and the variable name matches the field name. This eliminates the \
redundancy that often occurs when building structs from local variables.

For example, if you have `let name = \"Alice\"` and `let age = 30`, you can write \
`Person { name, age }` instead of `Person { name: name, age: age }`. The compiler expands \
each shorthand field to use the variable of the same name as the value.

Shorthand fields can be mixed with regular fields: `Person { name, age: calculate_age(birth_year) }`. \
Only fields where the variable name matches get the shorthand; fields with computed values use \
the full `field: expression` syntax as usual.

This feature is borrowed from JavaScript/TypeScript ES6 object shorthand and Rust's field init \
shorthand. It is a small convenience that significantly reduces visual clutter in code that \
constructs many structs.",
    category: "Collections",
}
