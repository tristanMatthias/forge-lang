# `@query(Fam.Variant)` — the memoized-query surface

The ergonomic layer over the L6 query engine (`src/query/`), design
§3.1/§3.3 + §10.B + §12.5.

## Syntax

```avra
enum Fam { Src, TextLen }        // Src (0) = input family, TextLen (1) = this query

@query(Fam.TextLen)
fn text_len(ctx: QueryCtx<string>, arg: int) -> Result<string, QueryCycle> {
    let src = ctx.fetch(qk(Fam.Src.ordinal, arg))?   // reads record dependency edges
    Result.Ok(string(src.length))
}
```

The annotation takes exactly one argument: an **enum variant** naming the
query's family. The family's dense int (engine contract §2.1: `Db.family(tag)`
grows a dense list to `tag`, so it must be small and dense) is the variant's
declaration-order **`.ordinal`** (ps3t.8.13) — the surface renders
`Fam.TextLen.ordinal` into the generated code and codegen constant-folds it.

Because ONE `enum Fam` names every query *and* its inputs
(`qk(Fam.Src.ordinal, …)`), all families are that enum's ordinals `0..n-1` and
**cannot collide** — with each other or with inputs — by construction. That is
the win over the old hand-picked int, which put collision-avoidance on the
author.

The annotated fn must be non-generic with exactly this signature (v1: the
value type is `string` — the generated adapter's early-cutoff hash is
`content_id_for`, which is string-keyed; other value types keep the raw
hand-wrapped path).

## What it generates

Three siblings, spliced next to the original (which stays callable):

| Generated | Shape | Role |
|---|---|---|
| `text_len_family()` | `fn () -> int` | returns `Fam.TextLen.ordinal` (folded), for dispatcher arms and `qk` |
| `text_len_fetch(ctx, arg)` | same as the query | dependency-recording call-through: `ctx.fetch(qk(family, arg))` |
| `text_len_compute(ctx, q)` | engine compute-arm | runs the fn, wraps in `computed(v, content_id_for(v))` |

Single-underscore suffixes by design: the dispatcher references these by
hand, and spec Axis 28 reserves `__` for compiler-generated dispatch
symbols users never type.

The **program-level dispatcher is generated too** (ps3t.8.12): the
whole-program walk emits one `avra_query_dispatch` routing `q.family` to each
site's `_compute`, with a loud `panic` on an unregistered family. Drivers write
`db_new(avra_query_dispatch)` — no hand-written router.

The generated code references the engine fully qualified
(`@std::avrac::query::…`), so it resolves regardless of the driver's
imports — nothing is injected, and a driver's own same-named symbol
(a local `computed`, say) can never capture a generated reference. The
driver's own `Fam` is referenced unqualified: the generated decls splice into
the driver's module, where `Fam` is in scope exactly as the annotation saw it.

## Errors (all F4013)

- `@query` bare, an int (`@query(1)` — the old form is gone), or any
  non-enum-variant argument
- several arguments (exactly one `Fam.Variant`)
- two `@query` sites in one program claiming the same variant
- two `@query` sites drawing from DIFFERENT enums (the single-enum
  invariant — one enum keeps every family in one dense ordinal space)
- generic fn, wrong parameter shape, or non-`string` value type

A failed `@query` keeps the declaration and strips the annotation —
the diagnostic reports once, the fixpoint never respins.

## Pipeline

Runs in the same `derive_program` pass as `@derive`/`@expand`
(post-resolve, pre-typecheck); generated decls are re-resolved and
re-typechecked like any macro output. Generation is native (rendered
source re-parsed via `parse_program_source_shared`) — no interpreter
round-trip — and cycle-free by construction (generated decls carry no
annotations). The `.ordinal` in the generated family expression is
resolved and folded by the subsequent typecheck + codegen, so the surface
needs no view of the enum declaration.
