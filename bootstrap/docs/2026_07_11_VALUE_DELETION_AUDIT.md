# Value-deletion audit (ps3t.5.6)

**Question (acceptance):** identify all std/user exposure of the interpreter
`Value` type; ensure none remains on public surfaces before `g18a` deletes
`Value`; document.

**Answer:** there is **no** std/user public exposure. The interpreter `Value`
type is entirely internal to the `std-avrac` compiler package. `g18a` can delete
it with impact confined to the interpreter subsystem — no public-surface
migration is required first. The remaining blocker is *functional* (the JIT fold
path + macro expansion must fully replace the tree-walk evaluator), not exposure.

## What `Value` is

`export type Value` is defined in `features/eval/mod.av:119` — the boxed,
dynamically-tagged value the tree-walk interpreter operates on (the "everything
is a boxed Value" model that the compiled/JIT path and arena AST are replacing).

## Exposure surface — measured

Method: `grep -rnE '\bValue\b'` over every package's `src` (tests excluded),
then filter comment word-matches (`ValueType`, `EmitValue`, and prose mentions
like "runtime Value", "Value types", "Value-backed") from real code references.

- **Packages referencing `Value` at all: 1** — `std-avrac` (the compiler
  itself). **Zero** references in any other `@std` package or user-facing
  surface. So there is nothing to migrate at the package boundary.
- **Not on the package public API:** `Value` is not referenced by the package
  root / lib surface (`avrac.av`), so external consumers cannot import it even
  though the `type` carries `export` (that `export` is consumed only within
  `std-avrac`'s own module graph).
- **Real cross-module importers (the deletion surface): 5 modules**, all
  interpreter internals, each via `use features.eval.{… Value …}`:
  1. `features/eval/mod.av` — defines `Value`; the interpreter core.
  2. `features/match_expr/mod.av` — value-space `match` evaluation.
  3. `features/tuples/mod.av` — value-space tuple evaluation.
  4. `features/comptime/eval.av` — the `@comptime` constant-fold path
     (interpreter fallback; the JIT path in `try_jit_fold` already bypasses
     `Value` for scalar returns — ps3t.5.2.x).
  5. `features/comptime/expand_macro.av` — `@expand`/`@derive` macro expansion,
     which runs macro bodies in "Value space" (`features/comptime/synth.av`
     documents this: every AST node is a boxed `Value` during expansion).
- **Comment-only mentions (NOT code dependencies):** `codegen/{mod,operators,
  optional_repr,types}.av`, `core/{ast,llvm}.av`, `diagnostics/mod.av`,
  `build/metadata.av`, `features/{let_stmt,null_safety,quote_expr}.av` — every
  `\bValue\b` hit there is prose in a comment, not a use of the interpreter type.
  In particular `build/metadata.av`'s "Value payloads" refers to const-initializer
  literal encoding, and does **not** import or serialize the interpreter `Value`.

## User-facing macro API

Users author `@comptime`/`@expand`/`@derive` macros as ordinary Avra fns that
take and return AST nodes (`Stmt`/`Expr`). The `Value` boxing is an internal
representation of the tree-walk evaluator that runs those bodies; it never
appears in a user's type annotations or the macro's public signature. So even
the macro system — the most "meta" user surface — does not expose `Value`.

## Consequence for g18a (delete interpreter + Value)

Deleting `Value` is a **compiler-internal** change scoped to the 5 modules above
plus their helpers. It is gated on replacing what they do, not on any public
migration:

- comptime fold (`comptime/eval.av`) → the JIT fold path (ps3t.5.2) must cover
  every case the interpreter fallback still handles (AST-returning + non-scalar
  args remain on the interpreter today).
- macro expansion (`comptime/expand_macro.av`, `synth.av`) → must move off
  Value-space onto the arena AST (the L1/L4 derive work) before `Value` can go.
- `match`/`tuple` value-space eval → subsumed by the same interpreter removal.

There is **no** public/std/user surface to clear first. This audit's guard test
(`features/comptime/tests/value_internal_audit_test.av`) pins the invariant:
`Value` stays confined to `std-avrac` and off the package public root, so a
future change that leaks it onto a public surface fails CI.
