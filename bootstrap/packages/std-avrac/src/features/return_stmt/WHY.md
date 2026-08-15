# return

Yields a value from the enclosing function. Two forms:
- `return expr`  — yields `expr`
- `return`       — yields the function's default value

Parsed as `Stmt.Return(expr)` or `Stmt.ReturnEmpty` by the feature-owned
`return_stmt` rule + `build_return` lowering in `mod.av` (t-47hc.8 flip).
Codegen (return-slot stores, defer unwinding, RC releases) stays with the
central emitters.
