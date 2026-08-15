# while — grammar fragment

```ebnf
WhileStmt ::= 'while' Expr Block
```

The condition parses with struct literals disabled (`while foo { }` reads
`foo` as the condition); the body must be a `{ }` block (F0010 otherwise).
The production rule lives in `mod.av` (`while_lang`'s gram — the source
of truth).
