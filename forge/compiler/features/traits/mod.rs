crate::forge_feature! {
    name: "Traits",
    id: "traits",
    status: Stable,
    depends: [],
    enables: ["generics"],
    tokens: ["trait", "impl"],
    ast_nodes: ["TraitDecl", "ImplBlock", "TraitMethod"],
    description: "Trait declarations with default methods, impl blocks, and associated types",
    syntax: ["trait Name { fn method(self) }", "impl Trait for Type { }"],
    short: "trait/impl — interfaces and polymorphism",
    symbols: [],
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
