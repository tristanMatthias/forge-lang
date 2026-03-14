crate::forge_feature! {
    name: "Enums",
    id: "enums",
    status: Stable,
    depends: [],
    enables: ["pattern_matching"],
    tokens: ["enum"],
    ast_nodes: ["EnumDecl"],
    description: "Algebraic data types with named variants and optional fields",
    syntax: ["enum Name { Variant, Variant(fields) }"],
    short: "enum Name { Variants } — algebraic data types with match support",
    symbols: [],
    long_description: "\
Enums in Forge are algebraic data types that define a type with a fixed set of named variants. \
Each variant can optionally carry data of any type. This makes enums far more powerful than the \
simple integer enumerations found in C or Java. For example: \
`enum Shape { Circle(float), Rectangle(float, float), Point }`.

Enums are constructed by naming the variant: `let s = Shape.Circle(5.0)`. Pattern matching with \
`match` is the primary way to work with enums, and the compiler ensures every variant is handled. \
This exhaustiveness checking catches entire categories of bugs at compile time.

Enums are ideal for modeling state machines, command sets, message types, error categories, and \
any domain where a value is exactly one of several possibilities. The Result and Option types that \
power Forge's error handling and null safety are themselves enums under the hood.

If you are familiar with Rust enums, Swift enums with associated values, or Haskell data types, \
Forge enums work the same way. If you are coming from TypeScript, think of them as discriminated \
unions with compiler-enforced exhaustiveness.",
    grammar: "<enum_decl>   ::= \"enum\" <ident> \"{\" (<ident> [\"(\" <types> \")\"])* \"}\"",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
