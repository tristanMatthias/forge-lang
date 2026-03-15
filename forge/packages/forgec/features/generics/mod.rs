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
    long_description: "\
Generics let you write functions and types that work with any type, while still maintaining full \
type safety. A generic function is declared with type parameters in angle brackets: \
`fn identity<T>(x: T) -> T { x }`. The type parameter `T` is replaced with a concrete type at \
each call site.

Generic types work the same way: `type Wrapper<T> { value: T }` creates a type that can wrap any \
other type. You can instantiate it as `Wrapper<int> { value: 42 }` or `Wrapper<string> { value: \"hi\" }`.

Type parameters can be constrained with trait bounds to require certain capabilities. This ensures \
that generic code can only be called with types that support the operations it needs, catching type \
errors at compile time rather than runtime.

Forge's generics are similar to those in Rust, TypeScript, and Java. They use monomorphization \
at compile time, meaning generic code has zero runtime overhead: the compiler generates specialized \
versions for each concrete type used.",
    category: "Components",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
