# enum — grammar fragment

```ebnf
EnumDecl    ::= 'enum' Ident '{' VariantList '}'
VariantList ::= (Variant (',' | <newline>) Variant)*
Variant     ::= Ident ('(' VariantFields ')')?
VariantFields ::= (Field (',' Field)*)?
```
