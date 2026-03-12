crate::forge_feature! {
    name: "Generics",
    id: "generics",
    status: Testing,
    depends: ["traits"],
    enables: [],
    tokens: ["<", ">"],
    ast_nodes: ["TypeParam", "Generic"],
    description: "Generic type parameters with trait bounds and monomorphization",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
