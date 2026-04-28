# if — grammar fragment

```ebnf
IfStmt ::= 'if' Expr Block ('else' Stmt)?
IfExpr ::= 'if' Expr Block ('else' (IfExpr | Block | Expr))?
```
