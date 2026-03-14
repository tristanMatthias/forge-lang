crate::forge_feature! {
    name: "Immutability",
    id: "immutability",
    status: Stable,
    depends: [],
    enables: [],
    tokens: ["let", "mut", "const"],
    ast_nodes: ["Let", "Mut", "Const", "LetDestructure"],
    description: "Variable bindings with let (immutable), mut (mutable), and const (compile-time constant)",
    syntax: ["let x = 1", "mut y = 2", "const Z = 3"],
    short: "immutable by default — let (frozen), mut (mutable), const (compile-time)",
    symbols: [],
    long_description: "\
Forge is immutable by default. Variables declared with `let` cannot be reassigned after \
initialization. This is not a convention or a lint rule; it is enforced by the compiler. \
Attempting to assign to a `let` binding produces error F0013 with a clear message explaining \
the immutability constraint.

Mutable bindings require the explicit `mut` keyword: `mut counter = 0`. This makes every \
mutation point visible in the code. When reading a function, you can immediately see which \
values might change by scanning for `mut` declarations. This is especially valuable in larger \
codebases where understanding data flow is critical.

Constants declared with `const` are even stricter: their values must be known at compile time, \
and they are inlined at every usage site. Use `const` for configuration values, mathematical \
constants, and fixed strings.

The immutable-by-default philosophy extends beyond variables to data structures. Structs created \
with `let` have immutable fields. The `with` expression creates modified copies rather than \
mutating in place. This approach eliminates shared mutable state, the root cause of countless \
bugs in imperative programs.",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
