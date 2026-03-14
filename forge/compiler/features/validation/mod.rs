crate::forge_feature! {
    name: "Validation",
    id: "validation",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: [],
    description: "validate() intrinsic with annotation-based field validation, defaults, transforms, and named validators",
}

pub mod checker;
pub mod codegen;
