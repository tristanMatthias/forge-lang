crate::forge_feature! {
    name: "Field Mutability",
    id: "field_mutability",
    status: Wip,
    depends: ["structs"],
    enables: [],
    tokens: [],
    ast_nodes: ["StructFieldDef"],
    description: "Per-field mutability — fields declare their own mutability with mut keyword",
    syntax: ["type T = { mut count: int, name: string }"],
    short: "mut on struct fields — immutable by default, opt into mut",
    symbols: [],
    long_description: "\
Fields declare their own mutability. Without `mut`, a field is immutable after construction. \
With `mut`, the field can be changed by the owner, methods on self, or any function receiving \
the struct. `let`/`mut` on bindings controls reassignment only, not field mutation. The `with` \
expression always works because it creates a new value, not a mutation.",
    category: "Types",
    category_order: Primary,
}

pub mod checker;
