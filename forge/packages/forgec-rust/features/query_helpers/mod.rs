crate::forge_feature! {
    name: "Query Helpers",
    id: "query_helpers",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: [],
    description: "Query comparison helpers: query_gt(), query_gte(), query_lt(), query_lte(), query_between(), query_like() — produce JSON filter strings for model queries",
    syntax: [],
    short: "query builder utilities for structured data",
    symbols: [],
    long_description: "\
Query helpers provide a fluent builder API for constructing structured queries. Rather than \
concatenating strings to build queries (which is error-prone and vulnerable to injection), \
the query builder lets you compose queries programmatically with methods like `where`, `order_by`, \
`limit`, and `offset`.

The query builder supports comparison operators and chaining: \
`query.where(\"age\", \">\", 18).order_by(\"name\").limit(10)` constructs a structured query \
that can be safely executed against a data source. All values are parameterized, preventing \
injection attacks.

Query helpers are used internally by component templates (especially model components) to \
generate the queries that back CRUD operations. They can also be used directly in application \
code for custom query patterns that go beyond the standard CRUD operations.

Validation errors from the query builder are structured, providing field-level error details \
rather than a single error string. This makes it easy to map validation failures to specific \
user inputs in UI applications.",
    category: "Special",
}

crate::builtin_fn! { name: "query_gt", feature: "query_helpers", params: [Int], ret: String, variadic: false }
crate::builtin_fn! { name: "query_gte", feature: "query_helpers", params: [Int], ret: String, variadic: false }
crate::builtin_fn! { name: "query_lt", feature: "query_helpers", params: [Int], ret: String, variadic: false }
crate::builtin_fn! { name: "query_lte", feature: "query_helpers", params: [Int], ret: String, variadic: false }
crate::builtin_fn! { name: "query_between", feature: "query_helpers", params: [Int, Int], ret: String, variadic: false }
crate::builtin_fn! { name: "query_like", feature: "query_helpers", params: [String], ret: String, variadic: false }

// Runtime function declarations
crate::runtime_fn! { name: "forge_query_gt", feature: "query_helpers", params: [I64], ret: ForgeString }
crate::runtime_fn! { name: "forge_query_gte", feature: "query_helpers", params: [I64], ret: ForgeString }
crate::runtime_fn! { name: "forge_query_lt", feature: "query_helpers", params: [I64], ret: ForgeString }
crate::runtime_fn! { name: "forge_query_lte", feature: "query_helpers", params: [I64], ret: ForgeString }
crate::runtime_fn! { name: "forge_query_between", feature: "query_helpers", params: [I64, I64], ret: ForgeString }
crate::runtime_fn! { name: "forge_query_like", feature: "query_helpers", params: [ForgeString], ret: ForgeString }

pub mod codegen;
