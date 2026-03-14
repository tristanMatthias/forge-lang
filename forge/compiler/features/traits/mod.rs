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
    long_description: "\
Traits define shared interfaces that types can implement. A trait declares a set of method \
signatures that implementing types must provide: `trait Printable { fn to_display() -> string }`. \
Types implement traits with `impl` blocks: `impl Printable for Point { fn to_display() -> string { ... } }`.

Traits enable polymorphism without inheritance. A function that accepts `impl Printable` can work \
with any type that implements the trait, regardless of the type's other characteristics. This is \
more flexible than class-based inheritance because a type can implement any number of traits.

Trait bounds on generic type parameters constrain what operations are available: \
`fn print_all<T: Printable>(items: list<T>)` ensures every item can be displayed. This catches \
errors at compile time and provides clear documentation about what a function requires.

If you are coming from Go, Forge traits are similar to interfaces. From Rust, they work the same \
way. From Java or C#, think of them as interfaces with no default methods. From TypeScript, they \
are like structural interfaces but explicitly declared.",
    category: "Components",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
