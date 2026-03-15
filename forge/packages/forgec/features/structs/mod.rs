crate::forge_feature! {
    name: "Structs",
    id: "structs",
    status: Stable,
    depends: [],
    enables: [],
    tokens: ["type"],
    ast_nodes: ["TypeDecl", "StructLit"],
    description: "Type declarations (structs and aliases) and struct literal expressions",
    syntax: ["struct Name { field: type }", "let x = Name { field: value }"],
    short: "struct declarations, literals, and field access",
    symbols: [],
    long_description: "\
Structs define structural types with named fields. They are the primary way to group related data \
in Forge. Declaration syntax is: `type Point { x: int, y: int }`. Instances are created with \
literal syntax: `let p = Point { x: 10, y: 20 }`. Fields are accessed with dot notation: `p.x`.

Forge structs are immutable by default. To create a modified copy, use the `with` expression: \
`let q = p with { x: 30 }`. This creates a new struct with the specified fields changed and all \
others copied from the original. This approach encourages immutable data flow and makes it clear \
exactly which fields differ between two values.

Structs support shorthand field initialization when the variable name matches the field name: \
`let x = 10; let y = 20; Point { x, y }`. This reduces boilerplate when constructing structs \
from local variables with matching names.

Unlike classes in object-oriented languages, Forge structs carry no methods or inheritance. \
Behavior is attached through trait implementations, keeping data and behavior cleanly separated. \
This design scales better for large codebases and avoids the deep inheritance hierarchies that \
plague OOP systems.",
    grammar: "<struct_decl> ::= \"type\" <ident> \"{\" (<ident> \":\" <type>)* \"}\"",
    category: "Collections",
}

pub mod types;
pub mod parser;
pub mod checker;
pub mod codegen;
