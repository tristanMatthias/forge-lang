# Avra Bootstrap Grammar

Assembled from `src/features/*/grammar.md`. Each feature owns its
grammar fragment; this file is the assembled canonical spec.

See also: `parse/mod.av` for the expression grammar (operators,
calls, field access, indexing, literals) which isn't feature-organized.

---

## Program structure

```ebnf
Program      ::= Declaration*
Declaration  ::= 'export'? (FnDecl | TypeDecl | EnumDecl | ImplDecl
               | ExternFnDecl | LetStmt | MutStmt | 'use' ... | 'mod' ...)
Statement    ::= IfStmt | WhileStmt | ReturnStmt | MatchStmt
               | 'break' | 'continue' | Block | ExprStmt
Block        ::= '{' Statement* '}'
ExprStmt     ::= Expr
```

## Expressions (not feature-organized — lives in parse/mod.av)

```ebnf
Expr         ::= Assignment
Assignment   ::= Or ('=' Assignment)?
Or           ::= And ('||' And)*
And          ::= Equality ('&&' Equality)*
Equality     ::= Comparison (('==' | '!=') Comparison)*
Comparison   ::= Term (('<' | '<=' | '>' | '>=') Term)*
Term         ::= Factor (('+' | '-') Factor)*
Factor       ::= Unary (('*' | '/') Unary)*
Unary        ::= ('!' | '-') Unary | Postfix
Postfix      ::= Primary ('(' Args ')' | '.' Ident | '[' Expr ']' | '!')*
Primary      ::= Number | String | Bool | 'null' | Ident
               | '(' Expr ')' | IfExpr | MatchExpr | Block
```


---

# enum — grammar fragment

```ebnf
EnumDecl    ::= 'enum' Ident '{' VariantList '}'
VariantList ::= (Variant (',' | <newline>) Variant)*
Variant     ::= Ident ('(' VariantFields ')')?
VariantFields ::= (Field (',' Field)*)?
```

---

# extern — grammar fragment

```ebnf
ExternFnDecl ::= 'extern' 'fn' Ident '(' Params ')' ('->' Type)?
```

---

# fn — grammar fragment

```ebnf
FnDecl    ::= 'fn' Ident '(' Params ')' ('->' Type)? Block
Params    ::= (Param (',' Param)*)?
Param     ::= Ident (':' Type)?
```

---

# if — grammar fragment

```ebnf
IfStmt ::= 'if' Expr Block ('else' Stmt)?
IfExpr ::= 'if' Expr Block ('else' (IfExpr | Block | Expr))?
```

---

# impl — grammar fragment

```ebnf
ImplDecl       ::= 'impl' Ident '{' ImplMethods '}'
ImplMethods    ::= ImplMethod*
ImplMethod     ::= 'fn' Ident '(' MethodParams ')' ('->' Type)? Block
MethodParams   ::= 'self' (':' Type)? (',' Params)?
                 | Params
```

---

# let / mut — grammar fragment

```ebnf
LetStmt ::= 'let' 'mut'? Ident (':' Type)? '=' Expr
MutStmt ::= 'mut' Ident (':' Type)? '=' Expr
```

---

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

---

# return — grammar fragment

```ebnf
ReturnStmt ::= 'return' Expr?
```

The expression is optional; an empty `return` becomes `RetEmpty`
in the AST and emits a zero value of the function's return type.

---

# struct (type) — grammar fragment

```ebnf
TypeDecl    ::= 'type' Ident '=' '{' FieldList '}'
FieldList   ::= (Field (',' Field)*)?
Field       ::= 'mut'? Ident ':' Type

StructLit   ::= Ident '{' FieldInitList '}'
FieldInits  ::= (FieldInit (',' FieldInit)*)?
FieldInit   ::= Ident (':' Expr)?            (* shorthand: just `name` ≡ `name: name` *)
```

---

# while — grammar fragment

```ebnf
WhileStmt ::= 'while' Expr Block
```
