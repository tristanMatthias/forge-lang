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
that std-llvm now enforces. Project-wide.

### No silent value loss in tail position
Empty `_ -> {}` arms in codegen are forbidden. Every Stmt and Expr
variant must be exhaustively handled in every emit/check function.
Until forge's exhaustive-match warning lands here, this is enforced
by code review and periodic grep.

### No mutable globals
Every piece of compile state lives in the `Compiler` context struct
(or its sub-structs) and is threaded explicitly. No `mut CG_FOO` at
module scope. Globals are spooky action at a distance.

### Every file under 200 lines
Hard limit. If a file is longer, split it. The threshold is
intentionally aggressive because small files are the whole point of
the layout.

### One construct per file
A `features/<name>/parser.fg` parses ONE construct. If it grows
multiple constructs, split into more files. Same for codegen.

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
8. Run `make test`. If it passes, commit.
9. Run `make selfhost`. If it passes, commit.
10. Verify the feature appears in the assembled `GRAMMAR.md` after
    `make grammar`.

Removing a feature is `rm -r features/<name>/` plus removing the
two dispatcher lines plus a `make test`.

## Anti-patterns (red flags in code review)

- A file longer than 200 lines (split it)
- A file named `*_helpers.fg`, `*_utils.fg`, etc. (be specific)
- A `_ -> {}` match arm in codegen or check (silent value loss)
- A function returning a hardcoded constant on failure (fake success)
- A `mut` global without an `// INVARIANT:` comment
- An import edge from one feature to another (use core)
- A new keyword construct that isn't in `features/` (move it)
- A `// TODO:` in code (move to PLAN.md backlog)
