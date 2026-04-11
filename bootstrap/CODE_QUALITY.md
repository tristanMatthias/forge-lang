# Bootstrap Code Quality

The constitution. Read this before adding code. Everything here is
load-bearing — every rule has been paid for at least once with a
session of debugging.

## Directory layout

```
bootstrap/src/
  main.fg                 ← entry point, argv handling, command dispatch
  core/                   ← stable infrastructure (ast, cursor, diagnostic, cg, resolver)
  parse/                  ← shared parser building blocks + statement dispatcher
  emit/                   ← shared codegen building blocks + statement dispatcher
  features/               ← one directory per language feature
    <name>/
      WHY.md              ← one paragraph
      grammar.md          ← EBNF fragment
      parser.fg           ← parses just this construct
      codegen.fg          ← emits IR for just this construct
      example.fg          ← canonical usage
      expected.out        ← expected stdout
```

## What goes where

> **A "feature" is anything keyword-introduced that is a top-level
> statement form.** Everything else is core or a phase building block.

Features (each gets its own `features/<name>/` directory):
`if`, `while`, `for`, `match`, `let`, `mut`, `fn`, `struct`, `enum`,
`impl`, `extern`, `return`, `break`, `continue`.

Not features (live in `parse/expr.fg`, `parse/pattern.fg`,
`parse/type_expr.fg`):
- Operators (`+`, `*`, `==`, etc) — they participate in precedence
- Literals (numbers, strings, bools, null)
- Postfix forms: calls `()`, indexing `[]`, field access `.x`
- Type annotations
- Patterns

The line is bright: **does it have a keyword that introduces it as a
top-level statement?** If yes, feature. If no, building block.

## Dependency rules

The dependency arrow always points TOWARD core, never away from it.

```
features/X/  →  parse/expr.fg, parse/pattern.fg, core/, etc.
              ↑
              never the reverse
```

- A feature MAY import from `core/` and from any phase building block.
- A feature MAY NOT import from another feature.
- If two features need shared code, that code moves to `core/` or a
  phase building block.
- `core/` and phase building blocks may not import from `features/`.
  The dispatchers in `parse/stmt.fg` and `emit/stmt.fg` are the
  ONLY files that import from features, and they import only the
  per-feature parser/codegen entry points.

## Hard rules (enforced by code review or pre-commit)

These exist because each was paid for with at least one bug.

### No fake successes
A function that can't perform the requested operation MUST return
null + an error, never a fake-success constant. This is the rule
that llvm_wrapper.c enforces. Project-wide.

### No silent value loss in tail position
Empty `_ -> {}` arms in codegen are forbidden. Every Stmt and Expr
variant must be exhaustively handled in every emit/check function.
Until forge's exhaustive-match warning lands here, this is enforced
by code review and periodic grep.

### No mutable globals
Every piece of compile state lives in the `Compiler` context struct
(or its sub-structs) and is threaded explicitly. No `mut CG_FOO` at
module scope. Globals are spooky action at a distance.

### No circular module imports
Module dependencies must form a DAG. If `a` uses `b`, then `b` must
not transitively use `a`. Forge's host compiler may technically
allow cycles, but we forbid them as policy because:

  - Go, Swift, Elm, OCaml all forbid them by language design
  - Cycles are usually a sign that two modules should be one, OR
    that there's a missing third module both should depend on
  - Cycles make refactoring fragile and reading order ambiguous
  - "It works" is not the same as "it's correct"

When you need a cycle, **extract the shared concept into a
parent module that both sides depend on.** The dispatcher pattern
is the canonical example: if `codegen.fg` and `features/match/codegen.fg`
need to share types, those types live in `core/cg.fg` and both
sides depend on `core/cg.fg` one-way.

This rule exists because the obvious-feeling shortcut during the
feature migration (Phase 4b) was to make codegen.fg and
features/match/codegen.fg circular. The correct answer was a
shared `core/cg.fg`. The principle costs an extra file but earns
a clean DAG forever.

### One construct per file
A `features/<name>/parser.fg` parses ONE construct (or one tightly
related family — e.g. a `match` parser owns both the statement
form and the expression form because they share an arm-list and
pattern grammar). If a file starts handling unrelated constructs,
split it.

There is **no hard line-count limit**. A file should be as long as
the one concept it owns naturally requires. Some constructs (a
fully-developed pattern matcher, the precedence climber for
expressions) are legitimately long. Others (a `return` parser) are
tiny. The rule is about *cohesion*, not size.

The signal that a file is too big is not "it has more than N
lines" — it's "I keep scrolling past unrelated code to find the
thing I want." When that happens, look for a missing concept and
extract it. When it doesn't, the file is fine at any length.

### Forbidden vocabulary
These words are banned in identifiers and filenames:
`Manager`, `Helper`, `Util`, `Misc`, `Common`, `Handler`, `Service`,
`Wrapper`, `Shim`. They are dumping grounds. Use specific names.

### File header conventions
Every `.fg` file starts with:
```
// WHY: <one sentence saying what this file owns>
```

Optionally, a more detailed `// AGENT:` block telling future agents
when to read this file and where related concepts live.

### `// INVARIANT:` on every mut
Every `mut` field in a struct and every mutable global gets an
`// INVARIANT: ...` comment saying what's always true. If you can't
write the invariant, you don't understand the state well enough to
mutate it.

## Self-hosting invariants (defended by pre-commit)

These have NAMES because invariants with names are defended:

### Fixed-Point Invariant
bs2 and bs3 emit byte-identical IR for `bootstrap/src/main.fg`.
Enforced by `make selfhost` and the pre-commit hook.

### Cross-Compiler Invariant
stage1 and bs2 produce identical stdout for every regression test.
Enforced by `make regress` and the pre-commit hook.

### Score Invariant
`make score` reports zero wide-store-into-narrow-malloc bugs (the
heap-corruption guard). Enforced by `make score`.

### Phase Isolation Invariant
No phase reaches into a previous phase's input. Parser doesn't
re-tokenize. Codegen doesn't re-parse. Enforced by code review.

If a commit breaks any of these, **revert immediately** and
reconsider. We do not ship "we'll fix it next commit" workarounds.

## Adding a feature

Steps for adding a new language feature, in order:

1. Create `bootstrap/src/features/<name>/`.
2. Write `WHY.md` (one paragraph) and `grammar.md` (EBNF fragment).
3. Write `parser.fg` with a `parse_<name>` function.
4. Add one line to `parse/stmt.fg`'s dispatcher importing and
   routing to `parse_<name>`.
5. Write `codegen.fg` with an `emit_<name>` function.
6. Add one line to `emit/stmt.fg`'s dispatcher likewise.
7. Write `example.fg` and `expected.out` (canonical usage).
8. Add the example as a regression test via
   `bash scripts/diagnose.sh --regress-add <name> <example.fg>`.
9. Write **combination tests** that exercise the new feature
   interacting with every existing feature it could touch.
   Add each as a regression test. See "Testing rules" below.
10. Run `make test`. If it passes, commit.
11. Run `make selfhost`. If it passes, commit.
12. Dogfood: refactor bootstrap source to USE the new feature
    (see FEATURE_PARITY.md § Dogfooding Rule).
13. Verify the feature appears in the assembled `GRAMMAR.md` after
    `make grammar`.

## Testing rules

Every feature needs **three layers** of test coverage:

### 1. Per-feature example (`features/<name>/example.fg`)
The canonical happy-path usage. Covers the basic syntax and
one or two variations.

### 2. Edge-case regression tests (`regress/<name>_*.fg`)
Boundary conditions, empty inputs, deeply nested usage,
error paths. One `.fg` + `.out` pair per scenario.

### 3. Combination matrix tests (`regress/combo_*.fg`)
**When you add feature X, write a test combining X with every
other feature it could interact with.** The goal is to catch
bugs at feature boundaries — the places where two features'
codegen, type tracking, or control flow intersect.

The combination matrix for a new feature X should cover AT LEAST:
- X + structs (field access, mutation)
- X + enums + match (pattern matching)
- X + for/while loops (control flow nesting)
- X + functions (as argument, return value, in body)
- X + string templates (interpolation)
- X + null safety (`??`, `?.`)
- X + if-expressions (as value)
- X + pipe operator (`|>`)

Not every combination will be meaningful — use judgment. But the
default is to TEST IT. We've found bugs at every feature boundary
we've tested (template + sub-parser, `??` + string types,
for + break + continue). The ones we don't test are where the
next bug hides.

Tests that trigger known stage1 codegen divergences get a
`.bs2only` sidecar file (see `regress/template_expr.bs2only`).

Removing a feature is `rm -r features/<name>/` plus removing the
two dispatcher lines plus a `make test`.

## Anti-patterns (red flags in code review)

- A file that mixes unrelated concepts (split it by concept, not by size)
- A file named `*_helpers.fg`, `*_utils.fg`, etc. (be specific)
- A `_ -> {}` match arm in codegen or check (silent value loss)
- A function returning a hardcoded constant on failure (fake success)
- A `mut` global without an `// INVARIANT:` comment
- An import edge from one feature to another (use core)
- A new keyword construct that isn't in `features/` (move it)
- A `// TODO:` in code (move to PLAN.md backlog)
