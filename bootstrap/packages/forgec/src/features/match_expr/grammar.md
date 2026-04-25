# match — grammar fragment

```ebnf
MatchStmt    ::= 'match' Expr '{' MatchArm* '}'
MatchExpr    ::= 'match' Expr '{' MatchArm* '}'    (* in expression position *)

MatchArm     ::= Pattern '->' Expr ','?

Pattern      ::= '_'                               (* wildcard *)
               | '.' Ident                         (* nullary variant *)
               | '.' Ident '(' Bindings ')'        (* variant with payload bindings *)

Bindings     ::= Ident (',' Ident)*
               | '_'                               (* don't-bind placeholder *)
```

The arm body is parsed as an expression, but the parser temporarily
disables `.field` postfix consumption inside the arm body so the
next sibling pattern (`.Variant(...)`) on the following line isn't
gobbled into the previous body.
