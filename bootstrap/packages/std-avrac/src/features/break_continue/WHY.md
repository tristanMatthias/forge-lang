# break / continue

Loop-control statements: `break` exits the innermost enclosing loop,
`continue` skips to its next iteration test. Parsed by the feature-owned
`break_stmt` / `continue_stmt` rules + `build_break` / `build_continue`
lowerings in `mod.av` (t-47hc.8 flip — zero-arg, span-free manifest
rows). Codegen stays with the central emitters (the LoopStack branch
targets in `codegen/mod.av`); both are compile errors outside a loop.
