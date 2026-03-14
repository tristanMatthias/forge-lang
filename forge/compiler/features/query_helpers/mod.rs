crate::forge_feature! {
    name: "Query Helpers",
    id: "query_helpers",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: [],
    description: "Query comparison helpers: query_gt(), query_gte(), query_lt(), query_lte(), query_between(), query_like() — produce JSON filter strings for model queries",
}

pub mod codegen;
