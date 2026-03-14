crate::forge_feature! {
    name: "Type Operators",
    id: "type_operators",
    status: Stable,
    depends: [],
    enables: [],
    tokens: ["without", "only", "partial"],
    ast_nodes: ["Without", "TypeWith", "Only", "AsPartial"],
    description: "Type-level operators: without, with, only, as partial for deriving types from existing types",
    syntax: ["Type without field", "Type only [fields]", "partial Type"],
    short: "without/only/partial — type-level field transformations",
    symbols: [],
}
