crate::forge_feature! {
    name: "Expression Blocks",
    id: "expression_blocks",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: [],
    description: "Expression-oriented blocks, implicit return, no semicolons",
    syntax: [
        "// No semicolons — newlines separate statements",
        "// Last expression in a block is the return value",
        "let x = if cond { a } else { b }   — blocks are expressions",
    ],
    short: "expression-oriented: last value in a block is the return value, no semicolons",
    symbols: [],
    long_description: "\
Forge is expression-oriented. Every block `{ ... }` evaluates to the value of its last \
expression. This means `if/else`, `match`, and function bodies all produce values without \
needing an explicit `return` keyword.

Statements are separated by newlines, not semicolons. There are no semicolons in Forge. \
This keeps the syntax clean and reduces visual noise. If you need multiple statements on \
one line, use separate lines instead.

Because blocks are expressions, you can write `let x = if cond { a } else { b }` or \
`let label = match status { .active -> \"on\" .idle -> \"off\" }`. This eliminates the \
need for ternary operators or temporary variables.

The `return` keyword exists for early return from functions, but idiomatic Forge prefers \
the implicit return of the last expression. This encourages small, focused functions \
where the result flows naturally from the logic.",
    grammar: "<block> ::= \"{\" <stmt>* <expr>? \"}\"",
    category: "Basics",
    category_order: Core,
}
