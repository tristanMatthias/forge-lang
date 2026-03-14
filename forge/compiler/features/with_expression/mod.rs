crate::forge_feature! {
    name: "With Expression",
    id: "with_expression",
    status: Stable,
    depends: [],
    enables: [],
    tokens: ["with"],
    ast_nodes: ["With"],
    description: "Struct update syntax: expr with { field: value } creates a copy with updated fields",
    syntax: ["expr with { field: value }"],
    short: "expr with { field: val } — immutable copy with overrides",
    symbols: [],
    long_description: "\
The `with` expression creates a modified copy of an immutable struct. Given \
`let p = Point { x: 1, y: 2 }`, writing `let q = p with { x: 10 }` creates a new Point where \
`x` is 10 and `y` is copied from `p`. The original `p` is unchanged.

This is the idiomatic way to \"update\" immutable data in Forge. Rather than mutating fields in \
place, you express transformations as new values derived from old ones. This makes data flow \
explicit and eliminates bugs caused by unexpected mutation of shared references.

The `with` expression copies all fields from the original, then applies the overrides. Only the \
fields you specify are different; everything else is preserved. This is concise even for structs \
with many fields, since you only mention what changes.

This feature is equivalent to the spread/rest operator for objects in JavaScript \
(`{ ...obj, field: newValue }`), Kotlin's `copy()` method on data classes, or Rust's struct \
update syntax (`Point { x: 10, ..p }`). Forge's `with` keyword reads naturally in English, \
making the intent immediately clear.",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
