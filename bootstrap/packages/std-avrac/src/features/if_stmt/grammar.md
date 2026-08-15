# if — grammar fragment

```ebnf
IfStmt ::= 'if' Expr Block ('else' Stmt)?
IfExpr ::= 'if' Expr Block ('else' (IfExpr | Block | Expr))?
```

The condition parses with struct literals disabled; the THEN branch must
be a `{ }` block (F0010), while the else branch is an unrestricted
statement (so `else if` and bare `else <stmt>` both work). The statement
production lives in `mod.av` (`if_lang`'s gram — the source of truth);
the expression production stays in the spine's expression grammar.
