# is operator (type-narrowing test)

## Syntax

```
is_check = postfix_expr "is" variant_pattern
variant_pattern = "." IDENT
```

## Semantics

`expr is .Variant` evaluates to `true` when `expr`'s enum tag
matches `Variant`. In a flow-sensitive context (the `then`
branch of an `if`, the body of a `match` arm), the type-checker
also narrows `expr`'s type to `NarrowedEnum(enum, variant)` so
payload field accesses don't need an explicit destructure.

`is` works on:

- Concrete enums declared with `enum Foo { ... }`.
- Union-aliased shapes (`type Json = string | int | bool`)
  where the "variant" is the type tag.

## Examples

Tag check:

```avra
enum Status { Pending, Active(user: string), Failed(reason: string) }

let s = Status.Active("alice")
if s is .Active {
    // s is narrowed to NarrowedEnum(Status, "Active")
    println("user: ${s.user}")
}
```

Without the narrowing the same shape would require a match
arm; `is`-flow is the lightweight form for one-variant checks.

Union narrowing:

```avra
type Json = string | int | bool

fn render(j: Json) -> string {
    if j is .string { return j }
    if j is .int { return string(j) }
    if j is .bool { return if j { "true" } else { "false" } }
    ""  // unreachable per exhaustive-match lint
}
```

## Codegen layout

`Expr.IsCheck(subject, variant)` lowers to a tag-compare:

1. Evaluate `subject` to its enum pointer.
2. Load the i64 tag at offset 0 of the enum's `{tag, payload}`
   layout.
3. Compare against the variant's djb2 hash (the stable id used
   throughout codegen for variant dispatch).
4. ZExt the i1 result to i64-stored bool.

Union-tag `is` checks compare against the i64 type-tag in the
union's tagged-union runtime shape.

## Pipeline placement

- Parser produces `Expr.IsCheck(subject, variant_name)`.
- Resolve walks the subject.
- Type-check narrows: in flow-sensitive positions, the
  positive branch sees `subject` as
  `ValueType.NarrowedEnum(enum_name, variant_name, id)`.
- Codegen emits the tag-compare in
  `features/is_keyword/codegen.av`.

## Spec reference

Axis 11.2 (flow-sensitive type narrowing).
