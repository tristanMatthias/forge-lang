# return — grammar fragment

```ebnf
ReturnStmt ::= 'return' Expr?
```

The expression is optional; an empty `return` becomes `RetEmpty`
in the AST and emits a zero value of the function's return type.
