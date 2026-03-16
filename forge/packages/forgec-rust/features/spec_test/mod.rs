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
    syntax: ["spec \"name\" { given \"setup\" { } then \"test\" { } }"],
    short: "spec/given/then — BDD-style behavior-driven tests",
    symbols: [],
    long_description: "\
Forge includes a built-in BDD-style testing framework with `spec`, `given`, `then`, and `expect` \
blocks. Tests are written as structured specifications that read like documentation: \
`spec \"math\" { given \"addition\" { then \"1 + 1 = 2\" { expect(1 + 1 == 2) } } }`.

The `spec` block names the feature being tested. Inside it, `given` blocks describe preconditions \
or scenarios. `then` blocks describe expected behaviors. `expect(condition)` asserts that a \
condition is true. This three-level structure organizes tests into a readable hierarchy.

Test output shows the full path of each assertion: `math > addition > 1 + 1 = 2: PASS`. Failed \
tests show the expected and actual values with source location. The structured output makes it \
easy to identify exactly which scenario failed and why.

This approach is inspired by RSpec (Ruby), Jest's describe/it (JavaScript), and Kotest (Kotlin). \
The benefit over flat test functions is that related tests are grouped by topic, and the test \
names form readable sentences that serve as living documentation.",
    category: "Special",
}
