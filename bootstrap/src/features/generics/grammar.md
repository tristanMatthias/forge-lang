## Generics

```
<type_params>  ::= "<" IDENTIFIER ( "," IDENTIFIER )* ">"
<fn_decl>      ::= "fn" IDENTIFIER <type_params>? "(" <params> ")" ( "->" <type> )? "{" <body> "}"
<type_decl>    ::= "type" IDENTIFIER <type_params>? "=" "{" <fields> "}"
<enum_decl>    ::= "enum" IDENTIFIER <type_params>? "{" <variants> "}"
<type_ref>     ::= IDENTIFIER ( "<" <type_ref> ( "," <type_ref> )* ">" )? "?"?
```
