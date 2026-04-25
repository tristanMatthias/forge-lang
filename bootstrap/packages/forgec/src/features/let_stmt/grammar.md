# let / mut — grammar fragment

```ebnf
LetStmt ::= 'let' 'mut'? Ident (':' Type)? '=' Expr
MutStmt ::= 'mut' Ident (':' Type)? '=' Expr
```
