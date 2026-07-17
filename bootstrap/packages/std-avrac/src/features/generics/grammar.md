## Generics

```
<type_params>  ::= "<" IDENTIFIER ( "," IDENTIFIER )* ">"
<fn_decl>      ::= "fn" IDENTIFIER <type_params>? "(" <params> ")" ( "->" <type> )? "{" <body> "}"
<type_decl>    ::= "type" IDENTIFIER <type_params>? "=" "{" <fields> "}"
<enum_decl>    ::= "enum" IDENTIFIER <type_params>? "{" <variants> "}"
<type_ref>     ::= IDENTIFIER ( "<" <type_ref> ( "," <type_ref> )* ">" )? "?"?
<call>         ::= IDENTIFIER ( "<" <type_name> ( "," <type_name> )* ">" )? "(" <args> ")"
<type_name>    ::= IDENTIFIER
```

### Explicit type arguments (turbofish)

A generic call may pin its type arguments explicitly: `id<int>(x)`,
`pick<string>(a, b, first)`. The turbofish list carries structural
`ValueType`s on `Expr.GenericCall.type_args` (5idg — no longer name-strings).
Syntactically each argument is a bare type NAME (`parse_type_name_list`), so a
nested application like `id<List<int>>(x)` is not turbofish syntax — pass such a
value by inference instead (`id(x)` with `x: List<int>`).

- Each turbofish type-argument must be a fully-applied type. A bare generic —
  `wrap<GenOpt>(x)` where `enum GenOpt<T>` — determines no layout, so it is
  rejected before codegen (F1004, the totality rule) rather than picking one
  instantiation by first-match; this is the expression-position sibling of the
  `channel<T>` element gate, checked through the same `tc_gate_expr_type_arg`
  helper (ps3t.4.6). Because turbofish arguments are bare names, any GENERIC
  type named there is inherently under-applied and always F1004.
- An in-scope type parameter (`wrap<T>(x)` inside `fn f<T>()`) is fully applied
  at each instantiation and stays exempt — even when it shadows a declared
  generic `type T<U>`, via the enclosing scope's type params.
- Concrete scalars, non-generic named types, and in-scope params compile; the
  gate fires only on a bare declared generic.
