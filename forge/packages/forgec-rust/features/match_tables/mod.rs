pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;

crate::forge_feature! {
    name: "Match Tables",
    id: "match_tables",
    status: Testing,
    depends: ["pattern_matching"],
    enables: [],
    tokens: ["table"],
    ast_nodes: ["MatchTable"],
    description: "Match expressions with table syntax for multi-column pattern results",
    syntax: ["match expr table { pattern | col1 | col2 ... }"],
    short: "match expr table { pattern | col1 | col2 } — tabular match returning structs",
    symbols: ["|"],
    long_description: "\
Match tables combine pattern matching with table syntax. The first column contains patterns, \
and remaining columns are named values. The match expression returns a struct with the column \
names as fields.\n\
\n\
Example:\n\
```\n\
match status table {\n\
  pattern  | label      | emoji\n\
  .active  | \"active\"   | \"checkmark\"\n\
  .pending | \"pending\"  | \"circle\"\n\
}\n\
```\n\
\n\
This returns a struct `{ label: string, emoji: string }` based on which pattern matches. \
It is syntactic sugar for a match expression where each arm returns a struct literal.",
    grammar: "<match_table> ::= \"match\" <expr> \"table\" \"{\" <header_row> <data_row>* \"}\"",
    category: "Pattern Matching",
}
