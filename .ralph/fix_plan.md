# Fix Plan

## Priority: Polish (tasks 1-9)

- [ ] 1. Capture more regression tests (enum match, struct mutation, while+break, nested if-else, multi-arg call, substring)
- [ ] 2. Remove [BC] debug print from std-llvm (gate behind env var)
- [ ] 3. Audit std-llvm silent fallbacks (replace LLVMConstInt/LLVMGetUndef with eprintln+null)
- [ ] 4. Add example.fg + expected.out to all feature directories
- [ ] 5. Short-circuit && / || lowering (cond_br + phi instead of eager mul/add)
- [ ] 6. emit_stmt_as_value coverage audit
- [ ] 7. Exhaustive match audit (grep for _ -> {} and _ -> ok_stmt)
- [ ] 8. Remove [char_at] stderr debug noise from runtime.c
- [ ] 9. Clean up TECH_DEBT.md (collapse fixed items, update stale ones)

## Priority: Phase A features (tasks 10-15)

For each feature: create features/<name>/ dir, add parser.fg + codegen.fg + example.fg + expected.out, then REFACTOR bootstrap source to USE the new feature. Verify with `make -C bootstrap test`.

- [ ] 10. `for` loops + ranges (for i in 0..n { })
- [ ] 11. String templates (`hello ${name}`)
- [ ] 12. Pipe operator (expr |> fn)
- [ ] 13. `const` bindings
- [ ] 14. Hex/bin/oct numeric literals (0xFF, 0b1010, 0o755)
- [ ] 15. `and`/`or`/`not` keyword operators

## When all tasks are done

Set EXIT_SIGNAL: true in your RALPH_STATUS block.
