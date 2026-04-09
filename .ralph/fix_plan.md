# Fix Plan

## Priority: Polish (tasks 1-9)

- [x] 1. Capture more regression tests (enum match, struct mutation, while+break, nested if-else, multi-arg call, substring)
- [x] 2. Remove [BC] debug print from std-llvm (gate behind env var)
- [x] 3. Audit std-llvm silent fallbacks (replace LLVMConstInt/LLVMGetUndef with eprintln+null)
- [x] 4. Add example.fg + expected.out to all feature directories
- [x] 5. Short-circuit && / || lowering (cond_br + phi instead of eager mul/add)
- [x] 6. emit_stmt_as_value coverage audit
- [x] 7. Exhaustive match audit (grep for _ -> {} and _ -> ok_stmt)
- [x] 8. Remove [char_at] stderr debug noise from runtime.c
- [x] 9. Clean up TECH_DEBT.md (collapse fixed items, update stale ones)

## Priority: Phase A features (tasks 10-15)

For each feature: create features/<name>/ dir, add parser.fg + codegen.fg + example.fg + expected.out, then REFACTOR bootstrap source to USE the new feature. Verify with `make -C bootstrap test`.

- [x] 10. `for` loops + ranges (for i in 0..n { })
- [x] 11. String templates (`hello ${name}`)
- [x] 12. Pipe operator (expr |> fn)
- [x] 13. `const` bindings
- [x] 14. Hex/bin/oct numeric literals (0xFF, 0b1010, 0o755)
- [x] 15. `and`/`or`/`not` keyword operators

## Priority: More std-llvm hardening (tasks 16-18)

- [x] 16. forge_llvm_build_call arg-count / arg-type validation (check args match fn_type params, refuse loudly on mismatch)
- [x] 17. forge_llvm_build_load type compatibility (warn when load ty differs from LLVMGetAllocatedType for alloca destinations)
- [x] 18. Match expression type unification (emit_match_expr_arms should verify all arms produce the same type, not just use the first)

## When all tasks are done

Set EXIT_SIGNAL: true in your RALPH_STATUS block.
