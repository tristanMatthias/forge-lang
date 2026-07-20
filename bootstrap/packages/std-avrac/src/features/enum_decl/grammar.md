# enum — grammar fragment

```ebnf
EnumDecl    ::= 'enum' Ident '{' VariantList '}'
VariantList ::= (Variant (',' | <newline>) Variant)*
Variant     ::= Ident ('(' VariantFields ')')?
VariantFields ::= (Field (',' Field)*)?
```

## Variant ordinal accessor

```ebnf
OrdinalAccess ::= EnumName '.' Variant '.' 'ordinal'
```

`Color.Red.ordinal` yields the variant's **0-based declaration-order index**
as an `Int` — `Red` is `0`, the next variant `1`, and so on. The ordinal is a
compile-time property of a *literal* variant reference: it is resolved against
the enum's declaration and **constant-folded** to an integer literal, so it
costs nothing at run time and can index a dense array directly.

The ordinal is **distinct from the variant's tag**. Tags are `djb2` hashes of
the variant name (stable across reordering, used for `match` dispatch);
ordinals track *declaration order* and therefore change if you reorder the
variants — which is exactly what a dense index (e.g. an L6 query family) needs.

Because an ordinal is fixed at compile time, `.ordinal` is only valid on a
static variant reference. Applying it to a *runtime* enum value — a variable,
a parameter, a call result — whose variant isn't known until it runs is a
compile error (**F1207**); `match` on the value instead. A struct field
happening to be named `ordinal` is unaffected: `.ordinal` only means the
accessor when the receiver is an enum variant.
