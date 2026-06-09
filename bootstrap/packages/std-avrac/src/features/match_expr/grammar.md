# match — grammar fragment

```ebnf
MatchStmt    ::= 'match' Expr '{' MatchArm* '}'
MatchExpr    ::= 'match' Expr '{' MatchArm* '}'    (* in expression position *)

MatchArm     ::= Pattern '->' Expr ','?

Pattern      ::= '_'                               (* wildcard *)
               | 'let' Ident                       (* optional present-bind -> .Some(Ident) *)
               | 'none'                             (* optional absence       -> .None *)
               | '.' Ident                         (* nullary variant *)
               | '.' Ident '(' Bindings ')'        (* variant with payload bindings *)

Bindings     ::= Ident (',' Ident)*
               | '_'                               (* don't-bind placeholder *)
```

## Matching an optional (`T?`)

`T?` is the dual niche/tagged optional — it carries no enum tag — so a
`match` over it cannot go through the enum dispatch. The present-bind
surface (spec Axis 10.4) gives it one rule shared with `if let`:

```
match x {            // x : T?
    let v -> use(v)  // present: v : T   (lowers to the present arm `.Some(v)`)
    none  -> absent  // absence          (lowers to `.None`)
}
```

A `_` wildcard covers the absent (or otherwise-unmatched) case. The
dedicated 2-way codegen reuses the same present-test and unwrap the `?`
and `??` operators emit, so it stays consistent with the rest of the
null-safety surface.

The arm body is parsed as an expression, but the parser temporarily
disables `.field` postfix consumption inside the arm body so the
next sibling pattern (`.Variant(...)`) on the following line isn't
gobbled into the previous body.
