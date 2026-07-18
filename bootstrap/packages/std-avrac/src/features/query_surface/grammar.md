# `@query(N)` — the memoized-query surface

The ergonomic layer over the L6 query engine (`src/query/`), design
§3.1/§3.3 + §10.B.

## Syntax

```avra
@query(1)
fn text_len(ctx: QueryCtx<string>, arg: int) -> Result<string, QueryCycle> {
    let src = ctx.fetch(qk(0, arg))?      // reads record dependency edges
    Result.Ok(string(src.length))
}
```

The annotation takes exactly one argument: the query's **dense family
int** — the same small int a hand-written driver would pass to `qk`
(engine contract §2.1: families are driver-assigned dense ints; the
content-addressed scheme is the *argument* key's, not the family's).

The annotated fn must be non-generic with exactly this signature
(v1: the value type is `string` — the generated adapter's early-cutoff
hash is `content_id_for`, which is string-keyed; other value types keep
the raw hand-wrapped path).

## What it generates

Three siblings, spliced next to the original (which stays callable):

| Generated | Shape | Role |
|---|---|---|
| `text_len_family()` | `fn () -> int` | the family int, for dispatcher arms and `qk` |
| `text_len_fetch(ctx, arg)` | same as the query | dependency-recording call-through: `ctx.fetch(qk(family, arg))` |
| `text_len_compute(ctx, q)` | engine compute-arm | runs the fn, wraps in `computed(v, content_id_for(v))` |

Single-underscore suffixes by design: the dispatcher references these by
hand, and spec Axis 28 reserves `__` for compiler-generated dispatch
symbols users never type.

The **dispatcher stays hand-written** (the §10.B "hand-wrapped memo"
contract), but each arm is now a one-liner:

```avra
fn dispatch(ctx: QueryCtx<string>, q: QueryKey) -> Result<Computed<string>, QueryCycle> {
    if q.family == text_len_family() { return text_len_compute(ctx, q) }
    …
}
```

Imports the generated code needs beyond the fn's own signature
(`qk`, `computed`, `QueryKey`, `Computed`, `content_id_for`) are
injected implicitly, deduped against what the module already imports.

## Errors (all F4013)

- `@query` bare, or with a non-int-literal argument (idents don't
  resolve at expansion time)
- negative family (the memo store is dense-indexed)
- two `@query` sites in one program claiming the same family (checked
  by the expansion walk's seen-set; collisions with hand-assigned
  input families remain the driver author's contract)
- generic fn, wrong parameter shape, or non-`string` value type

A failed `@query` keeps the declaration and strips the annotation —
the diagnostic reports once, the fixpoint never respins.

## Pipeline

Runs in the same `derive_program` pass as `@derive`/`@expand`
(post-resolve, pre-typecheck); generated decls are re-resolved and
re-typechecked like any macro output. Generation is native (rendered
source re-parsed via `parse_program_source_shared`) — no interpreter
round-trip — and cycle-free by construction (generated decls carry no
annotations).
