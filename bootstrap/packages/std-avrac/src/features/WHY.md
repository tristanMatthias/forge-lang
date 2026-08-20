# features/

One directory per language feature. A feature describes itself in ONE place —
its `LanguageFeature` definition — and the compiler assembles itself from those
definitions. Anything derivable from a definition (keywords, highlighting,
docs, the grammar) is DERIVED, never declared twice.

Design record + rationale: `bootstrap/docs/2026_08_19_STANDARDIZATION.md`.

## The canonical file set — this list is exhaustive

```
features/<name>/
  mod.av        REQUIRED       the <name>_lang() definition(s). The CONTAINER:
                               identity, gram, and which fn implements each pass.
                               No pass logic lives here.
  lowering/     if it lowers   builders: grammar text -> AST nodes.
  resolve.av    if it resolves
  typeck.av     if it checks
  codegen.av    if it emits
  eval.av       if it evals    the @comptime tree-walk hook.
  tests/        REQUIRED       *_test.av spec/given/then.
  grammar.md    if it owns syntax
```

**One file per pass.** `mod.av` is the container; a pass hook lives in the file
named for its pass, even when it is eight lines. Uniform beats short: you can
answer "does this feature type-check anything?" by looking at the directory.

**Not enforced yet.** `diagnose.sh --check-feature-layout` is P4 of the
standardization program; until it lands this list is a contract on paper, and
the Status section below records exactly how far the tree is from it. Do not
read "exhaustive" as "already true".

## Not on the list, and why

- **`parser.av`** — features do not parse. Text -> AST is the grammar plus a
  lowering. A helper that walks an AST is a lowering, not a parser.
- **`grammar.av`** — the gram is part of what a feature IS: declare it inline as
  `gram = grammar { ... }` in `mod.av`. `composed([...])` survives only where
  several `*_lang()` in one feature share a fragment.
- **`WHY.md` per feature** — the definition's `title` / `docs` fields are the
  feature's documentation, and they are the ones `avra explain` renders. A
  second prose copy on disk drifts.
- **A test-only directory.** Tests live with the feature they exercise.

## Rules

- Core is infrastructure. Never put feature-specific code in `core/`.
- Never put package-specific or `@std`-specific code in `core/` or `features/`.
- No brittle heuristics. No string-matching to detect behaviour. Use
  annotations, type-system checks, or structural analysis.
- A feature MAY NOT import another feature. Shared code moves to `core/` or to
  the grammar engine (`src/grammar/`).
- **`lowering/` imports ONLY `features.grammar` + `core`.** Not style: the
  generated parser imports these modules directly, and its import closure must
  stay grammar+core or the package double-expands (F4012). A `mod.av` pulls
  resolve/typeck/codegen, which is exactly what must not reach the parse closure.

## Status

Counts below are measured, not estimated (`ls */codegen.av | wc -l` and friends).

`parser.av` is gone from every FEATURE. Five were dead islands; the one live
file (the `it`-pronoun desugar) moved to `closures/lowering/it_pronoun.av`,
where it belongs — it is parse-time lowering, not parsing. The grammar ENGINE
still has `grammar/parser.av` and `grammar/seed_parser.av`; those move out with
the engine in P6 (design record section 10), so the tree is correct, but the
contract above is not yet true of `features/grammar/`.

Still not true of the tree:

- **13** features declare `gram` in a separate `grammar.av` reached via
  `gram = composed([...])` instead of inline in `mod.av`.
- Pass hooks are split inconsistently: **25** features have `codegen.av` and
  **7** have `typeck.av`, while resolve and eval hooks still live inside
  `mod.av`.
- **15** features still carry a per-feature `WHY.md`.
- **26** further top-level `.av` files in feature dirs are on none of the
  canonical names — `component_decl/expand.av`, `generics/mono.av`,
  `spec_test/{reporter,runner}.av`, the six `comptime/*.av`, the six
  `derive/*.av`, `modules/{dir_module,graph_build,package,unit_filter}.av`,
  two `resolver.av`, two `derive.av`, `quote_expr/lower.av` — plus 16 more
  inside `features/grammar/` (the engine, which P6 moves out entirely).
  Deciding each one's home is part of P4, not a rename to do blind.
- `lowering/` is a directory holding one `mod.av` rather than a file, pending
  file-modules in the resolver (design record section 11 — a bare `lowering.av`
  would flatten into `features.X.*` and widen the generated parser's import
  closure past grammar+core).
- `error_messages/` is now an EMPTY directory: its four `expect-error` examples
  became real compile-error specs under `bootstrap/tests/err_*`, and nothing
  replaced the `mod.av` / `tests/` the contract requires. It should be removed
  outright once nothing references the path.

A note on what is NOT drift: two directories that looked like test-only orphans
(`desugar/`, `float_lit/`) held REAL tracked tests. `desugar/`'s moved to the
module that owns the behaviour (`src/desugar/tests/`); `float_lit`'s moved to
`bootstrap/tests/`, the top-level end-to-end fixture directory, because no
`features/float_lit` implementation exists — float literals are grammar- and
lexer-owned. Two others (`defer_stmt/`, `match_expr/`) were genuinely empty,
renamed away in `33293cfee`, leaving only untracked cache sidecars that made
them look alive.
