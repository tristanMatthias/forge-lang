crate::forge_feature! {
    name: "If/Else",
    id: "if_else",
    status: Stable,
    depends: [],
    enables: [],
    tokens: ["if", "else"],
    ast_nodes: ["If"],
    description: "Conditional expressions with if/else and else-if chaining",
    syntax: ["if cond { } else { }", "if cond { } else if cond { } else { }"],
    short: "if/else — conditional expressions with implicit return",
    symbols: [],
    long_description: "\
In Forge, `if`/`else` are expressions, not statements. This means they produce a value and can \
be used anywhere an expression is expected. For example: `let status = if score > 90 { \"A\" } \
else { \"B\" }`. The last expression in each branch becomes the value of the entire `if` expression.

Conditions do not require parentheses. Write `if x > 0 { ... }` rather than `if (x > 0) { ... }`. \
The `else if` chain works as expected for multiple conditions: \
`if x > 0 { \"positive\" } else if x < 0 { \"negative\" } else { \"zero\" }`.

Because `if` is an expression, there is no need for a ternary operator. The expression form is \
both more readable and more flexible than C-style ternaries. When used as a statement (ignoring \
the return value), `if` works exactly as you would expect from any other language.

Type checking ensures that both branches of an `if`/`else` return the same type when the result \
is used as a value. If you write `let x = if cond { 1 } else { \"two\" }`, the compiler will \
report a type mismatch.",
    grammar: "<if_stmt>     ::= \"if\" <expr> <block> [\"else\" (<if_stmt> | <block>)]",
    category: "Control Flow",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
