# match

Pattern-matches an enum value against its variants. Each arm has a
pattern (`.Variant(bindings)` or `_`) and a body expression. The
arm whose pattern matches is executed; bindings are introduced into
the arm's scope from the variant's payload.

Match exists in two forms:

- **Statement form**: `match expr { ... }` — used for side effects.
- **Expression form**: `match expr { ... }` in expression position —
  yields the value of the matching arm's body.

Both forms share the arm-list and pattern parsers; they differ only
in how the result is consumed.

## Files

- `parser.av` — parses both forms plus the pattern grammar
- `codegen.av` — emits LLVM IR for both forms (Phase 4b)
- `example.av` — canonical usage
- `expected.out` — expected stdout
- `grammar.md` — EBNF fragment
