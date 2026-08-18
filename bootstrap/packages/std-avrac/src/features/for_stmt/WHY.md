# for statement

Counted `for i in start..end { body }` loop. Desugars to a counter
alloca, a condition check (`i < end`), and an increment block — the
same basic-block layout as `while`, but with the iteration variable
and bounds handled automatically.

The grammar rules are feature-owned in `mod.av` (t-47hc.8 flip) and so is
every build they reference: `build_for` (the range/collection branch) plus
`MkForDestructure` / `MkForBinding` (the tuple-destructure branch,
t-kd4y.3.2.2) all live in `lowering/mod.av` as manifest rows. The two
statement builds are `spanned` — they stamp themselves at `st.build_sp`;
the binding carrier is flat, and the `let (a, b) = tmp` unpack row it
feeds is stamped at the temp token's own byte inside the destructure
build. Codegen lives in the sibling `codegen.av` (`emit_for` /
`emit_for_in`).
