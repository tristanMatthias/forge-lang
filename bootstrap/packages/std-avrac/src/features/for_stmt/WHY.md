# for statement

Counted `for i in start..end { body }` loop. Desugars to a counter
alloca, a condition check (`i < end`), and an increment block — the
same basic-block layout as `while`, but with the iteration variable
and bounds handled automatically.

The grammar rules + the range/collection lowering (`build_for`, a
`spanned` manifest row) are feature-owned in `mod.av` (t-47hc.8 flip);
the tuple-destructure branch keeps its engine-central builds
(`MkForDestructure` / `MkForBinding` — gensym-threaded desugar the typed
marshalling rows don't express yet). Codegen lives in the sibling
`codegen.av` (`emit_for` / `emit_for_in`).
