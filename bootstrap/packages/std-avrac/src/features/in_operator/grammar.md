# in operator (membership test)

## Syntax

```
in_check = postfix_expr "in" "[" (expression ("," expression)*)? "]"
```

The right-hand side is always a bracketed list literal — `in`
is purely a literal-set membership test, not a general
container probe. Use `xs.contains(x)` for list-variable
membership.

## Semantics

`x in [a, b, c]` evaluates to `true` when `x` equals any of the
listed expressions. Lowering: the expression is desugared into
the equivalent `x == a || x == b || x == c` chain at codegen
time, so the actual equality semantics match `==` for the
operand types.

Practical use is variant-or-tag matching where listing the
options inline is clearer than a `match`:

```avra
enum Color { Red, Green, Blue, Yellow }

fn is_primary(c: Color) -> bool {
    c in [.Red, .Green, .Blue]
}
```

Numeric:

```avra
let allowed = code in [200, 201, 204]
```

String:

```avra
let is_vowel = ch in ["a", "e", "i", "o", "u"]
```

## Lowering

Each `Expr.InCheck(needle, items)` lowers to a left-associated
disjunction of `==` checks. The lowering preserves operand
order so the first equal element short-circuits the rest.

For empty `x in []`, the result is `false` — no element is
equal to `x`.

## Pipeline placement

- Parser produces `Expr.InCheck(needle, items: List<SExpr>)`.
- Resolve walks the needle and every item.
- Type-check unifies all item types with the needle's type;
  mismatches surface as the same diagnostic any `==` mismatch
  would.
- Codegen emits the equality-disjunction chain via
  `features/in_operator/codegen.av`, reusing `emit_binary(Eq)`
  for each comparison so enum-tag / string / nullable handling
  comes through automatically.

## Why not `xs.contains(x)`

`in` is intentionally restricted to literal lists so the
operand list is part of the source — readable as a set of
options the author intended. For dynamic membership (`xs` is a
variable), use the explicit method form so the call site stays
honest about what's being scanned.
