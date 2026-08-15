# while

`while cond { body }` — repeats `body` while `cond` is true.
Supports `break` and `continue` via the loop stack in codegen.

Parsed by the feature-owned `while_stmt` rule + `build_while` lowering in
`mod.av` (t-47hc.8 flip, the first `spanned` manifest row — the engine
stamps the statement's SrcPos at the `while` keyword). Codegen lives in
the sibling `codegen.av` (`emit_while`).
