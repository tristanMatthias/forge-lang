# let / mut

Variable bindings. `let` is immutable, `mut` is mutable. `let mut`
is sugar for `mut`. The optional type annotation defaults to `i64`.

Both forms produce a `Stmt.Let` or `Stmt.Mut` AST node.
