# if — grammar fragment

```ebnf
IfStmt    ::= 'if' Expr Block ('else' Stmt)?
IfLetStmt ::= 'if' 'let' IDENT '=' Expr Block ('else' Stmt)?
IfExpr    ::= 'if' Expr Block ('else' (IfExpr | Block | Expr))?
IfLetExpr ::= 'if' 'let' IDENT '=' Expr Block ('else' (IfExpr | Block | Expr))?
```

The condition parses with struct literals disabled; the THEN branch must
be a `{ }` block (F0010), while the else branch is an unrestricted
statement (so `else if` and bare `else <stmt>` both work).

`if let` binds the unwrapped value for the branch. It is a DESUGAR, not a
node: a temp binding (`@gensym(iflet)`, minted between `if` and `let` so a
nested form numbers after its parent), a `!= none` condition, and an
unwrap-bind row prepended to the then-block — built by `build_if_let_stmt`
/ `build_if_let_expr` (core/arena.av). The two positions are NOT
interchangeable: with no `else` the statement form leaves the else absent,
while the expression form must synthesise an empty (Void) block because an
if-expression needs a value.

Three feature-owned rules (`mod.av`): `if_stmt` + `iflet_stmt` in
`avra_if_stmt_grammar` (the statement family the views compose), and
`iflet_expr` in `avra_iflet_expr_grammar` — its own fragment so the
expression views can take it without the statement rules. The fourth,
`if_expr`, stays a spine rule; it reaches the bind-fresh form the way
`statement` does, through a `@peek(if_let)`-gated reference.
