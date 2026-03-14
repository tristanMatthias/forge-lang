crate::forge_feature! {
    name: "Variables",
    id: "variables",
    status: Stable,
    depends: [],
    enables: [],
    tokens: ["let", "mut", "const"],
    ast_nodes: ["Let", "Mut", "Const", "LetDestructure"],
    description: "Variable declarations with let, mut, const, and destructuring patterns",
    syntax: ["let x = expr", "mut x = expr", "const X = expr"],
    short: "let/mut/const — immutable-by-default bindings with type inference",
    symbols: [],
    long_description: "\
Variables in Forge are declared with `let` for immutable bindings, `mut` for mutable ones, \
and `const` for compile-time constants. Immutability is the default, which means `let x = 10` \
creates a binding that can never be reassigned. This design choice catches an entire class of \
bugs at compile time and makes code easier to reason about, since you always know a `let` \
binding holds the value it was initialized with.

Type inference means you rarely need to annotate types. The compiler figures out that \
`let name = \"Alice\"` is a `string` and `let count = 42` is an `int`. When you do want \
to be explicit, annotations go after the name: `let ratio: float = 3.14`. Mutable variables \
use `mut`: `mut counter = 0` followed by `counter = counter + 1`.

Constants declared with `const` must have values known at compile time. Unlike `let` bindings, \
constants are inlined everywhere they are used, so they carry zero runtime cost. Use constants \
for magic numbers, configuration values, and anything that should never change across the \
lifetime of the program.

If you are coming from JavaScript or Python, the key difference is that Forge variables are \
immutable by default. If you are coming from Rust, the model is similar but without lifetime \
annotations. If you are coming from Go, think of `let` as a stricter `:=` that forbids reassignment.",
    grammar: "<let_stmt>    ::= \"let\" <ident> [\":\" <type>] \"=\" <expr>\\n<const_stmt>  ::= \"const\" <ident> \"=\" <expr>",
}

pub mod types;
pub mod parser;
pub mod checker;
pub mod codegen;
