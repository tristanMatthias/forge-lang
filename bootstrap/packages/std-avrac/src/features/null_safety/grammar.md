## Null Safety

```
<null_coalesce> ::= <or_expr> ( "??" <or_expr> )*
<optional_chain> ::= <postfix_expr> "?." IDENTIFIER
```

## Comparing optionals

Equality (`==` / `!=`) is permitted and well-defined on optionals: `none ==
none`, `Some(x) == Some(y)` iff `x == y`, and `none != Some(_)`. Present
values compare by their inner kind (strings by content, enums by tag, floats
by value), so two equal present values are equal even though they live in
distinct boxes.

Ordering (`<` `<=` `>` `>=`) on an optional operand is a compile error
(**F1204**): a `none` has no position in an ordering, so answering would be
arbitrary. Make absence explicit first:

```
if a! < b! { … }              // unwrap (you assert both are present)
if (a ?? 0) < (b ?? 0) { … }  // default the gap
match (a, b) { … }            // handle every presence combination
```

Value arithmetic (`+ - * / %`, bitwise `& | ^`, shifts `<< >>`) on an
optional operand is likewise a compile error (**F1205**): a `none` has no
value to compute with. Unwrap, default, or handle absence first — the same
three remedies as ordering. (Inside an `if let` / `match` present arm the
bound value is the non-optional inner, so it computes normally.)
