crate::forge_feature! {
    name: "Validation",
    id: "validation",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: [],
    description: "validate() intrinsic with annotation-based field validation, defaults, transforms, and named validators",
    syntax: ["validate(value)"],
    short: "validate() — runtime value validation",
    symbols: [],
}

pub mod checker;
pub mod codegen;
