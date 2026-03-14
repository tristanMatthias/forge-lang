crate::forge_feature! {
    name: "Generics",
    id: "generics",
    status: Stable,
    depends: ["traits"],
    enables: [],
    tokens: ["<", ">"],
    ast_nodes: ["TypeParam", "Generic"],
    description: "Generic type parameters with trait bounds and monomorphization",
    syntax: ["fn name<T>(x: T) -> T", "fn name<T: Trait>(x: T)"],
    short: "<T> type parameters with optional trait bounds",
    symbols: [],
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
