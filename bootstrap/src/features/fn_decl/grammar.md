# fn — grammar fragment

```ebnf
FnDecl    ::= 'fn' Ident '(' Params ')' ('->' Type)? Block
Params    ::= (Param (',' Param)*)?
Param     ::= Ident (':' Type)?
```
