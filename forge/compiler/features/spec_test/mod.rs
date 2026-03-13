pub mod parser;
pub mod checker;
pub mod codegen;

crate::forge_feature! {
    name: "Spec Test",
    id: "spec_test",
    status: Stable,
    depends: ["is_keyword", "table_literal"],
    enables: [],
    tokens: [],
    ast_nodes: ["SpecBlock", "GivenBlock", "ThenBlock", "ThenShouldFail", "ThenShouldFailWith", "ThenWhere", "SkipBlock", "TodoStmt"],
    description: "Test framework: spec, given, then, should_fail, where table, skip, todo (requires use @std.test)",
}
