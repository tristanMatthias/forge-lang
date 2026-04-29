## Traits

```
<trait_decl>     ::= "trait" IDENTIFIER <type_params>? "{" <trait_methods> "}"
<trait_methods>  ::= ( "fn" IDENTIFIER "(" <params> ")" ( "->" <type> )? )*
<impl_for>       ::= "impl" IDENTIFIER "for" IDENTIFIER "{" <methods> "}"
```
