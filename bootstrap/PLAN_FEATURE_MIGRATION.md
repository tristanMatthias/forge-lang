# Feature Migration Plan

Move the bootstrap compiler from a flat-file layout
(`src/parser.fg`, `src/codegen.fg`, etc.) to a feature-organized
layout where each language feature owns its parser, codegen,
example, grammar, and docs in a single directory.

This document is the canonical migration plan. Every commit in the
migration references the phase number from this file.

## Why

The current bootstrap has 8 files in `src/`. Two of them (`parser.fg`
at ~1500 lines, `codegen.fg` at ~2200 lines) contain every language
feature interleaved. Adding a feature touches both files in scattered
places. Removing a feature is impossible without grep archaeology.
Reading the implementation of `match` requires reading 200+ lines
across two files.

After the migration, adding a feature is "create
`features/<name>/parser.fg` and `features/<name>/codegen.fg` and add
two lines to the dispatchers". Removing a feature is `rm -r
features/<name>/` plus removing two lines. Reading a feature is
opening one directory.

## Target layout

```
bootstrap/src/
  main.fg                    ← entry point: argv handling, command dispatch

  core/                      ← stable infrastructure
    cursor.fg                ← scanner state, check/consume/advance helpers
    ast.fg                   ← AST node definitions (data only, no logic)
    diagnostic.fg            ← Result, Diagnostic, source spans
    cg.fg                    ← Cg fluent helper layer (the boilerplate killer)
    resolver.fg              ← name resolution (still core for now)

  parse/                     ← shared parsing infrastructure + dispatchers
    expr.fg                  ← parse_expression (Pratt/precedence climber)
    pattern.fg               ← parse_pattern
    type_expr.fg             ← parse_type, field lists
    stmt.fg                  ← THIN DISPATCHER: routes by token kind

  emit/                      ← shared codegen infrastructure + dispatchers
    expr.fg                  ← emit_expression dispatcher
    stmt.fg                  ← emit_statement dispatcher
    program.fg               ← compile_program top-level

  features/                  ← one directory per language feature
    if/
      WHY.md                 ← one paragraph: what is `if`?
      grammar.md             ← EBNF fragment
      parser.fg              ← parse_if (imports parse_expression from parse/expr.fg)
      codegen.fg             ← emit_if (imports Cg helpers from core/cg.fg)
      example.fg             ← canonical usage
      example.out            ← expected output (regression test)
    while/
      WHY.md
      grammar.md
      parser.fg
      codegen.fg
      example.fg
      example.out
    match/
      WHY.md
      grammar.md
      parser.fg
      codegen.fg
      example.fg
      example.out
    let/
      ...
    fn_decl/
      ...
    struct/
      ...
    enum/
      ...
    impl/
      ...
    extern/
      ...
    return/
      ...
```

The rule for what goes in `features/`: **anything keyword-introduced
that is a top-level statement form**. Operators, literals, calls,
field access, indexing — these are owned by `parse/expr.fg` because
they participate in precedence and context-sensitivity. The line is
clear and easy to apply.

## Constraints (non-negotiable)

These invariants MUST hold after every commit in the migration:

1. **Fixed-Point Invariant**: bs2 and bs3 emit byte-identical IR for
   `bootstrap/src/main.fg`. Verified by `make selfhost`.
2. **Regression Invariant**: every captured regression test still
   passes under both stage1 and bs2. Verified by `make regress`.
3. **No functionality loss**: every feature that worked before the
   migration still works after.
4. **No test loss**: every test in `bootstrap/tests/`,
   `bootstrap/regress/`, and the stage1 unit tests still passes.
5. **Score Invariant**: `make score` reports zero wide-store-into-
   narrow-malloc bugs (the heap-corruption guard).

If any commit breaks any of these, **revert immediately** and
reconsider the approach. The migration is not allowed to "regress
temporarily and fix it next commit".

## Phase status snapshot

| Phase | Description | Status |
|---|---|---|
| 0 | Audit + baseline | ✅ done |
| 1 | preprocess_modules supports nested dirs | ✅ done |
| 2 | Skeleton + CODE_QUALITY.md | ✅ done |
| 3.1 | Move token.fg → core/ | ✅ done |
| 3.2 | Move ast.fg → core/ | ✅ done |
| 3.3 | Move scanner.fg + resolver.fg → core/ | ✅ done |
| 3.4 | Move eval.fg → core/ | ✅ done |
| 4a | Extract match PARSER into features/match/ | ✅ done |
| 4b.1 | Extract leaf shared types into core/cg.fg | ✅ done |
| 4b.2 | Extract emit/stmt.fg + emit/expr.fg dispatchers | ⏳ deferred (blocked on architectural decision) |
| 4b.3 | Move emit_match into features/match/codegen.fg | ⏳ blocked on 4b.2 + registry move |
| 5.1 | Extract return into features/return_stmt/ | ✅ done |
| 5.2 | Extract if/while/extern parsers | ✅ done |
| 5.3 | Extract let, fn, struct, enum, impl parsers | ✅ done |
| 6 | Collapse parser.fg into parse/ | ✅ done |
| 7 | Collapse codegen.fg into codegen/ | ✅ done |
| Ctx | Rename Codegen → Ctx, eliminate ALL mutable globals | ✅ done |
| 8 | Cg fluent helper layer | 🟡 in progress |
| 9 | Assembled GRAMMAR.md from feature fragments | ✅ done |
| 7 | Collapse codegen.fg into emit/ | ⏳ pending |
| 8 | Cg fluent helper layer + Compiler context refactor | ⏳ pending |
| 9 | Per-feature WHY/grammar + assembled GRAMMAR.md | ⏳ pending |

## Phases

Each phase is one or more commits. Phases are designed to be
independent enough that we can stop between phases without leaving
the project in a half-migrated state.

### Phase 0 — Audit & baseline

Goal: capture the current state so we can detect regressions.

- Run `make test` and `make selfhost`; record passing state.
- Snapshot `bootstrap/src/main.fg.ll` for later diff comparison.
- Record the line counts of `parser.fg` and `codegen.fg` so we can
  measure the shrinkage.
- Write this plan (`PLAN_FEATURE_MIGRATION.md`).

**Verification:** `make test && make selfhost` clean.

**Estimated cost:** 30 minutes. Mostly writing this plan.

### Phase 1 — Extend `preprocess_modules` for nested directories

Goal: bs2's `preprocess_modules` must support nested module paths
so that `mod features` in `main.fg` can find `src/features/mod.fg`,
which can in turn declare `mod match` and find
`src/features/match/mod.fg`, etc.

- Modify `preprocess_modules` in `main.fg` to recognize both
  `<dir>/<name>.fg` and `<dir>/<name>/mod.fg`.
- Recursively preprocess inlined files with the correct nested
  directory context.
- Add a regression test that compiles a tiny nested-mod fixture.
- Verify the bs2/bs3 fixed point still holds (this is the riskiest
  step in the whole migration — it modifies bootstrap source itself).

**Verification:** `make test && make selfhost` clean. Specifically,
the bs2 → bs3 step must produce byte-identical IR.

**Estimated cost:** 1 session. Touches bootstrap source which
participates in the fixed-point invariant.

**Rollback:** If the fixed point breaks and we can't quickly
diagnose it, revert and use a flat layout with prefixed file names
as a fallback.

### Phase 2 — Create directory skeleton

Goal: lay down the empty `core/`, `parse/`, `emit/`, `features/`
directories with `WHY.md` files. No source moved yet.

- Create empty directories.
- Add a one-line `WHY.md` to each.
- Add `bootstrap/CODE_QUALITY.md` documenting the layout rule and
  the keyword-feature criterion.
- Verify nothing broke.

**Verification:** `make test && make selfhost` clean.

**Estimated cost:** 30 minutes.

### Phase 3 — Move stable infrastructure into `core/`

Goal: move files that are clearly infrastructure (not features) into
`core/`. This is the easiest move because nothing splits.

- `ast.fg` → `core/ast.fg`
- `scanner.fg` → `core/scanner.fg` (or merge into `core/cursor.fg`)
- `token.fg` → `core/token.fg`
- `resolver.fg` → `core/resolver.fg`
- `eval.fg` → `core/eval.fg` (or remove if no longer used)
- Update `main.fg`'s `mod` statements.

**Verification:** after each move, `make test && make selfhost`.
Move ONE file per commit so a regression bisects to a single move.

**Estimated cost:** 1-2 sessions. Each move is small but the
verification cycle is real.

### Phase 4 — Proof-of-concept feature extraction: `match`

Goal: prove the feature-directory pattern works end-to-end by
extracting one feature completely. We pick `match` because it's
self-contained and exercises the most parser+codegen surface area.

#### Phase 4a — Parser extraction (DONE)

- Create `features/match/parser.fg` with an `impl Parser` block
  containing the four match-related parsing methods.
- The dispatchers in `parser.fg` (parse_statement, parse_primary)
  still call `self.parse_match_statement()` and
  `self.parse_match_expression()` — Forge resolves methods
  globally across `impl Parser` blocks, so no dispatcher edit is
  needed.
- Add `features/match/{example.fg, expected.out, WHY.md, grammar.md}`.

#### Phase 4b — Codegen extraction (revised)

The naive approach is to put `emit_match` in
`features/match/codegen.fg` and have it import from `codegen.fg`
while `codegen.fg`'s dispatcher imports back from
`features/match/codegen.fg`. **This is a circular import. We
forbid those by policy** — see CODE_QUALITY.md.

The correct approach is a three-module DAG:

```
core/cg.fg                    (shared types + helpers, no dispatcher)
   ↑                ↑
   |                |
codegen.fg     features/match/codegen.fg
   ↑                ↑
   |________________|
   |
emit/stmt.fg + emit/expr.fg   (dispatchers, depend on both)
```

So Phase 4b is actually *three* commits:

1. **Extract `core/cg.fg`** containing the shared types
   (`Codegen`, `EmitResult`, `StmtResult`) and the small helpers
   (`ok_emit`, `err_emit`, `ok_stmt`, `err_stmt`, `null_ptr_val`,
   `translate_param_type`, `strip_enum_prefix`,
   `advance_field_list`, `field_type_at`). These are the "leaf"
   things that don't depend on dispatchers.

2. **Extract `emit/stmt.fg` and `emit/expr.fg`** as the
   dispatchers, importing from `core/cg.fg` and (eventually)
   `features/<X>/codegen.fg`.

3. **Create `features/match/codegen.fg`** with the moved
   `emit_match*` functions, importing only from `core/cg.fg`. The
   dispatchers in `emit/stmt.fg` and `emit/expr.fg` import the
   `emit_match` and `emit_match_expr` entry points from this file.

After this, `codegen.fg` itself shrinks dramatically (only the
remaining feature emits + `compile_program`). It becomes a
transitional module that further phases will eliminate.

**Verification after each commit:** `make test && make selfhost`.

**Estimated cost:** 1-2 sessions. Each of the three steps is
its own commit with its own verification cycle.

### Phase 5 — Extract remaining features one at a time

Goal: repeat Phase 4 for every feature. One commit per feature.

Order (smallest blast radius first):

1. `return`     — trivial
2. `break`      — trivial
3. `continue`   — trivial
4. `extern`     — small surface
5. `let`        — moderate (also covers `mut`, assignment)
6. `if`         — moderate (statement + expression form)
7. `while`      — moderate
8. `for`        — moderate (depends on iterator semantics)
9. `fn` decl    — large (parameter parsing, return types)
10. `struct`    — large (field list, struct literal)
11. `enum`      — large (variant list, enum constructor)
12. `impl`      — large (method dispatch, self handling)

After each feature is extracted, the dispatchers in `parser.fg` /
`codegen.fg` shrink by one block. Eventually they become almost
nothing.

**Verification:** `make test && make selfhost` after every commit.

**Estimated cost:** ~3 sessions. Each session extracts ~4 features.

### Phase 6 — Collapse `parser.fg` into `parse/`

Goal: at this point `parser.fg` should be mostly empty (just
dispatchers and shared building blocks). Move what remains into
`parse/`.

- Extract the precedence climber (`parse_or`, `parse_and`,
  `parse_equality`, `parse_comparison`, `parse_term`, `parse_factor`,
  `parse_unary`, `parse_call`, `parse_primary`) into `parse/expr.fg`.
- Extract `parse_pattern` into `parse/pattern.fg`.
- Extract `parse_type`, `parse_field_list` into `parse/type_expr.fg`.
- Extract `parse_statement` (the dispatcher) into `parse/stmt.fg`.
- Extract scanner state methods into `core/cursor.fg`.
- `parser.fg` is now empty. Delete it.

**Verification:** `make test && make selfhost`. The bs2 IR should
be functionally identical to the Phase 0 snapshot.

**Estimated cost:** 1 session.

### Phase 7 — Collapse `codegen.fg` into `emit/` + `core/cg.fg`

Goal: same as Phase 6 but for codegen. The dispatchers move to
`emit/`, the shared LLVM helpers move to `core/cg.fg`.

- Extract `emit_expression` dispatcher into `emit/expr.fg`.
- Extract `emit_stmt` dispatcher into `emit/stmt.fg`.
- Extract `compile_program` into `emit/program.fg`.
- Extract emit helpers (`malloc_struct_bytes`, `malloc_enum_bytes`,
  `emit_concat`, `emit_int_to_string`, etc.) into `core/cg.fg`.
- `codegen.fg` is now empty. Delete it.

**Verification:** `make test && make selfhost`.

**Estimated cost:** 1 session.

### Phase 8 — Build the `Cg` fluent helper layer

Goal: introduce the `Cg` wrapper struct with fluent methods
(`cg.malloc`, `cg.call`, `cg.gep`, `cg.alloca`, `cg.if_else`, etc.)
and refactor every `features/*/codegen.fg` to use it.

- Define `Cg` struct in `core/cg.fg` with builder methods.
- Refactor `features/match/codegen.fg` first (proof of concept).
- Refactor every other feature one commit at a time.
- Measure: each `features/*/codegen.fg` should shrink by ~50%.

**Verification:** `make test && make selfhost` after every commit.
The IR diff against the Phase 0 snapshot should be empty (semantic
equivalence) even though the Forge source is dramatically different.

**Estimated cost:** 1-2 sessions.

### Phase 9 — Per-feature documentation & assembled GRAMMAR.md

Goal: every feature directory has `WHY.md`, `grammar.md`, `example.fg`,
`example.out`. A build step assembles `features/*/grammar.md` into
a single canonical `bootstrap/GRAMMAR.md`.

- Backfill `WHY.md` for every feature.
- Backfill `grammar.md` (EBNF fragment) for every feature.
- Add `make grammar` target that concatenates fragments.
- Add a pre-commit lint that asserts each `features/<name>/` has
  the required files.

**Verification:** `make test && make selfhost && make grammar`.

**Estimated cost:** 1 session.

## Per-phase verification ritual

Every commit in this migration follows the same ritual:

1. Make the change.
2. Run `make test` (regress + fixed-point).
3. Run `make score` (no wide-store regressions).
4. Manually verify: `bs2 ↔ bs3` byte-identical via
   `make selfhost`.
5. Commit only if all pass.
6. If any fail, **revert immediately** and reconsider.

The pre-commit hook enforces #1, #4. #2 and #3 are manual until
they're added to the hook.

## Risk register

| Risk | Mitigation |
|---|---|
| Phase 1 breaks the fixed point and we can't fix it quickly | Revert; fall back to flat layout with prefixed names |
| The host compiler doesn't actually support nested mods the way we think | Tested in Phase 1; if it fails, we discover early |
| A feature has hidden dependencies on another feature's internals | Extract conservatively, use core/ as a parking lot for shared helpers |
| The dispatcher import lists become unwieldy | Auto-generate them from filesystem in a later phase |
| Refactoring breaks the score (introduces wide-store bug) | The score check in pre-commit catches it immediately |

## Backlog after migration

Once the migration is done:

- Sealed-enum lint (compile error if a match on an AST enum misses
  a variant) — this becomes much more useful with feature dirs
  because you'll know exactly which feature dir needs updating
- Per-feature spec.md, expanded from grammar.md
- Cross-feature integration tests in `tests/integration/`
- Auto-generated dispatchers (registry-driven, no manual edit)
- The MIR layer between AST and LLVM (separate plan)

## Estimated total cost

7-10 sessions, conservatively. Each session is one or two phases.
The fixed-point invariant catches regressions early so we don't pay
the "discover the bug five commits later" tax.

The first session (this one) does **Phases 0, 1, and 2**. That's
the foundation: snapshot the baseline, extend `preprocess_modules`
to support nested dirs, and lay down the empty directory skeleton.
Phases 3+ are subsequent sessions.
