crate::forge_feature! {
    name: "Pipe Operator",
    id: "pipe_operator",
    status: Stable,
    depends: [],
    enables: [],
    tokens: ["|>"],
    ast_nodes: ["Pipe"],
    description: "Pipe operator for function chaining: a |> f(args) becomes a.f(args), a |> f becomes f(a)",
    syntax: ["expr |> fn", "expr |> .method(args)"],
    short: "expr |> fn — left-to-right function/method chaining",
    symbols: ["|>"],
    long_description: "\
The pipe operator `|>` passes the result of the left expression as the first argument to the \
right function. It transforms nested function calls into a readable left-to-right chain. Instead \
of `to_upper(trim(read_file(\"input.txt\")))`, you write: \
`read_file(\"input.txt\") |> trim() |> to_upper()`.

Pipes also work with method calls. `data |> process(config)` is equivalent to `process(data, config)`, \
and `text |> .trim()` calls the method on the piped value. This makes long transformation \
pipelines read like a recipe: each step takes the previous result and transforms it further.

Multi-line pipes are supported for complex chains. The `|>` operator can appear at the start of \
a continuation line, so you can format pipelines vertically for readability.

The pipe operator is inspired by Elixir and F#, where it is fundamental to the language's style. \
In Forge, it pairs especially well with closures and collection methods, enabling a fluent, \
functional programming style without sacrificing type safety.",
    grammar: "<pipe_expr>   ::= <expr> \"|>\" <expr>",
    category: "Operators",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
