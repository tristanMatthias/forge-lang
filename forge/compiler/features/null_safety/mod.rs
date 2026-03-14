crate::forge_feature! {
    name: "Null Safety",
    id: "null_safety",
    status: Stable,
    depends: ["pattern_matching"],
    enables: ["error_propagation"],
    tokens: ["?", "?.", "??", "!"],
    ast_nodes: ["NullCoalesce", "NullPropagate", "Nullable"],
    description: "Optional types with ?, safe access ?., null coalesce ??, and smart narrowing",
    syntax: ["expr?", "expr?.field", "expr ?? default"],
    short: "x? (unwrap), x?.field (chain), x ?? default (coalesce)",
    symbols: ["?", "?.", "??"],
    long_description: "\
Forge eliminates null pointer exceptions through its type system. A type like `string` can never \
be null. To represent the absence of a value, you use a nullable type: `string?`. The compiler \
tracks nullability through every operation and refuses to compile code that could dereference a \
null value without checking first.

The optional chaining operator `?.` safely accesses fields and methods on nullable values. \
`user?.name` returns the name if `user` is not null, or null otherwise. This chains beautifully: \
`user?.address?.city` navigates a nullable chain without any of the defensive `if` checks that \
litter null-unsafe code.

The null coalescing operator `??` provides a default value when something is null: \
`user?.name ?? \"anonymous\"` returns the name if available, or `\"anonymous\"` if not. Combined \
with `?.`, this handles the vast majority of null-handling scenarios in a single expression.

The `?` suffix on function return types indicates the function might return null: \
`fn find_user(id: int) -> User?`. Callers must handle the null case, either with `?.`, `??`, \
or an explicit null check. This makes null a deliberate, visible choice rather than a hidden \
landmine.",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
