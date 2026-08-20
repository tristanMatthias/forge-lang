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

Enforced by `diagnose.sh --check-feature-layout` — a file not on this list is an
error, not a convention.

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

The contract above is the TARGET. `parser.av` is GONE from every feature —
five were dead islands, and the one live file (the `it`-pronoun desugar) moved
to `closures/lowering/it_pronoun.av`, where it belongs: it is parse-time
lowering, not parsing.

Still not true of the tree:

- 13 features keep a separate `grammar.av` reached via `gram = composed([...])`
  instead of declaring `gram = grammar { ... }` inline.
- Pass hooks are split inconsistently — `codegen.av` (26 features) and
  `typeck.av` (8) get their own files, while resolve and eval hooks still hide
  inside `mod.av`.
- 12 features still carry a per-feature `WHY.md`.
- `lowering/` is a directory holding one `mod.av` rather than a file, pending
  file-modules in the resolver (see the design record, section 11 — a bare
  `lowering.av` would flatten into `features.X.*` and widen the generated
  parser's import closure past grammar+core).

A note on what is NOT drift: two directories that looked like test-only orphans
(`desugar/`, `float_lit/`) held REAL tracked tests, and those moved to the
module that owns the behaviour rather than being deleted. Two others
(`defer_stmt/`, `match_expr/`) were genuinely empty — renamed away in
`33293cfee`, leaving only untracked cache sidecars that made them look alive.
