# features/

One directory per language feature. A "feature" is anything
keyword-introduced that produces a top-level statement form
(if, while, for, match, let, fn, struct, enum, impl, extern,
return, break, continue).

Each feature directory contains:
  parser.av     ← parses just this construct
  codegen.av    ← emits LLVM IR for just this construct
  example.av    ← canonical usage (also a regression test)
  expected.out  ← expected stdout
  WHY.md        ← one paragraph: what is this feature?
  grammar.md    ← EBNF fragment (assembled into GRAMMAR.md)

A feature MAY import from `core/` and from the stable building
blocks in `parse/expr.av`, `parse/pattern.av`, `parse/type_expr.av`,
and the `Cg` helpers. A feature MAY NOT import from another
feature directly — if two features need to share code, that code
moves to `core/` or to a phase building block.
