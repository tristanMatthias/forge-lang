# if

Conditional execution. Both statement form (`if cond { ... } else { ... }`)
and expression form (`let x = if cond { a } else { b }`). The
expression form supports `else if` chains and a single-expression
`else`.

The STATEMENT rules (`if_stmt`, `iflet_stmt`) and the bind-fresh
EXPRESSION rule (`iflet_expr`) are feature-owned in `mod.av`, with their
lowerings in `lowering/` — `build_if` on a `spanned` manifest row (the
engine stamps the statement's SrcPos at the `if` keyword; t-47hc.8) and
the if-let pair span-free (t-kd4y.3.2.1: each desugar core ends in a leaf
constructor that records no span — `intern_expr_leaf` for the expression
form, `add_stmt_leaf` for the statement one — so neither has a span to
thread). Only the plain
`if_expr` stays in the spine's expression ladder, and it reaches the
bind-fresh form through a `@peek(if_let)`-gated reference. Codegen lives
in the sibling `codegen.av` (`emit_if` / `emit_if_expr`).
