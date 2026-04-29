# return

Yields a value from the enclosing function. Two forms:
- `return expr`  — yields `expr`
- `return`       — yields the function's default zero value

Parsed as `Stmt.Ret(expr)` or `Stmt.RetEmpty`. Codegen still
lives in `codegen.av` until the codegen extraction lands.
