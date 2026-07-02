# struct (type) — grammar fragment

```ebnf
TypeDecl    ::= 'type' Ident '=' '{' FieldList '}'
FieldList   ::= (Field (',' Field)*)?
Field       ::= 'mut'? Ident ':' Type

StructLit   ::= Ident '{' FieldInitList '}'
FieldInits  ::= (FieldInit (',' FieldInit)*)?
FieldInit   ::= Ident (':' Expr)?            (* shorthand: just `name` ≡ `name: name` *)
```
