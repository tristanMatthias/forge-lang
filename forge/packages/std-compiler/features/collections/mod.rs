crate::forge_feature! {
    name: "Collections",
    id: "collections",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: ["ListLit", "MapLit"],
    description: "List and map literal expressions with type inference",
    syntax: ["[1, 2, 3]", "{ key: value }"],
    short: "list and map literals with type-safe operations",
    symbols: [],
    long_description: "\
Forge provides two built-in collection types: `list<T>` and `map<K, V>`. Lists are ordered, \
indexed sequences created with square brackets: `let nums = [1, 2, 3]`. Maps are key-value \
stores created with curly braces: `let ages = { \"Alice\": 30, \"Bob\": 25 }`.

Lists support a rich set of methods: `push`, `pop`, `map`, `filter`, `reduce`, `each`, \
`length`, `contains`, `sorted`, `join`, and more. Chaining these methods with closures is the \
idiomatic way to transform data: `numbers.filter((n) -> n > 0).map((n) -> n * 2)`. Lists are \
generic, so `list<int>`, `list<string>`, and `list<list<int>>` are all valid types.

Maps support `get`, `set`, `keys`, `values`, `contains`, and `length`. Map access uses bracket \
notation: `ages[\"Alice\"]`. When a key might not exist, use the null-safe access `ages[\"Charlie\"]?` \
combined with `??` to provide a default.

Both collections are mutable when declared with `mut`. Immutable collections cannot have elements \
added or removed, making them safe to share across function boundaries without defensive copying.",
    category: "Collections",
}

pub mod types;
pub mod codegen;
pub mod checker;
