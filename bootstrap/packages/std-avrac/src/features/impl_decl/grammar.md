# impl — grammar fragment

```ebnf
ImplDecl       ::= 'impl' Ident '{' ImplMethods '}'
ImplMethods    ::= ImplMethod*
ImplMethod     ::= 'fn' Ident '(' MethodParams ')' ('->' Type)? Block
MethodParams   ::= 'self' (':' Type)? (',' Params)?
                 | Params
```
