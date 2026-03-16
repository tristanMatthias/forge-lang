crate::forge_feature! {
    name: "Comments",
    id: "comments",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: [],
    description: "Line comments with // and doc comments with ///",
    syntax: ["// line comment", "/// doc comment (attached to next item)"],
    short: "// line and /// doc comments",
    symbols: ["//", "///"],
    long_description: "\
Comments in Forge use `//` for line comments and `///` for documentation comments. \
Line comments extend to the end of the line and are ignored by the compiler. Doc comments \
attach to the next item (function, type, variable) and are used by `forge lang` to generate \
documentation.

Forge does not have block comments (`/* */`). Use multiple `//` lines instead. This is a \
deliberate choice — block comments can nest confusingly and hide code in ways that line \
comments cannot.

Doc comments on example files use a special convention: `/// expect: value` declares the \
expected output for testing, and `/// expect-error: F0012` declares an expected compiler \
error. These drive the `forge test` system.",
    grammar: "<comment>     ::= \"//\" <text-to-eol>\n<doc_comment> ::= \"///\" <text-to-eol>",
    category: "Basics",
    category_order: Core,
}
