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
}
