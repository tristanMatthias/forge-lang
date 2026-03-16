crate::forge_feature! {
    name: "Contextual Resolution",
    id: "contextual_resolution",
    status: Stable,
    depends: ["enums"],
    enables: [],
    tokens: [],
    ast_nodes: [],
    description: "Dot-prefix resolution: .variant resolves from type context in assignments, function args, etc.",
    syntax: ["let x: Enum = .variant"],
    short: ".variant resolves from type context",
    symbols: [],
    long_description: "\
Contextual resolution extends the dot-prefix shorthand (`.variant`) beyond match arms to work \
in any position where the expected type is known. When the compiler sees `.active` in a typed \
variable assignment like `let s: Status = .active`, it resolves `.active` to `Status.active` \
by looking up which registered enum type contains a variant with that name.\n\
\n\
This eliminates repetitive enum qualification in common patterns: assignments with type annotations, \
function arguments with known parameter types, and comparisons with `is`. If a variant name is \
ambiguous (exists in multiple enums), the compiler requires explicit qualification.\n\
\n\
This is inspired by Swift's implicit member expressions and Zig's enum inference. The resolution \
only applies to simple (no-argument) enum variants.",
    grammar: "<contextual_variant> ::= \".\" <ident>",
    category: "Special",
}

pub mod checker;
pub mod codegen;
