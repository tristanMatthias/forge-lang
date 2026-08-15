# if

Conditional execution. Both statement form (`if cond { ... } else { ... }`)
and expression form (`let x = if cond { a } else { b }`). The
expression form supports `else if` chains and a single-expression
`else`.

The STATEMENT rule + `build_if` lowering are feature-owned in `mod.av`
(t-47hc.8 flip, a `spanned` manifest row — the engine stamps the
statement's SrcPos at the `if` keyword). The EXPRESSION rule (`if_expr`,
incl. its if-let branch) stays in the spine's expression ladder. Codegen
lives in the sibling `codegen.av` (`emit_if` / `emit_if_expr`).
