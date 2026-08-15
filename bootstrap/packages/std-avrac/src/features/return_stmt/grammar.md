# return — grammar fragment

```ebnf
ReturnStmt ::= 'return' Expr?
```

The expression is optional and must start on the same line as the
keyword; an empty `return` becomes `Stmt.ReturnEmpty` in the AST and
emits the function's default value. The production rule lives in
`mod.av` (`return_lang`'s gram — the source of truth).
