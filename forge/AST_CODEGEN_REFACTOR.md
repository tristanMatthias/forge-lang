# Self-Hosting Status & Next Steps (2026-04-06)

## Current State

- **Stage 2 IR:** 388 functions, ~45K lines, score 132/1000
- **Stage 2 binary:** Compiles, links, runs. **Completes end-to-end** — reads 40 files, tokenizes, parses, emits IR, writes `a.out`. No crashes, no hangs.
- **Stage 2 finds 0 functions** — `expect_ident()` returns "" for function names because Token.kind_id reads as 0 at certain parser positions.
- **Build:** `make stage1-rust` → `./build/stage1_rust build packages/forgec/src/main.fg` → `output.ll`

## THE BLOCKER: Systemic Type Guessing

**Every bug this session was the same root cause.** The self-hosted codegen doesn't track types — it guesses using 5 different methods (`llvm.type_of`, `resolve_type_to_llvm`, `expr_type_name`, `forge_value_type_kind`, hardcoded `CG_I64`). Different callsites use different methods, producing wrong types for allocas, PHIs, stores, and returns.

### The Fix: Use `llvm.type_of(value)` Everywhere

`llvm.type_of(value)` calls `LLVMTypeOf` which returns the LLVM type of any value. It's always correct. It already exists and works. The fix is a single systematic audit:

**Find every place in `codegen/mod.fg` that determines an LLVM type and replace the guessing with `llvm.type_of(value)`.**

### Specific Sites to Fix (audit checklist)

Search `codegen/mod.fg` for these patterns:

1. **`build_alloca(CG_B, CG_I64, ...)`** — should use `llvm.type_of(value)` for the value being stored
2. **`build_phi(CG_B, CG_I64, ...)`** — should use `llvm.type_of(first_arm_value)`
3. **`resolve_type_to_llvm(...)` fallback to CG_I64** — line 499, the default return. Should return null and let caller decide
4. **`mut elem_ty = CG_I64`** — list element type defaults. Should use `llvm.type_of(first_element)` if available
5. **`expr_type_name` for type decisions** — returns strings like "int", "string". Should not be used for LLVM type determination
6. **`forge_value_type_kind` for type selection** — returns kind integers. Use `llvm.type_of` directly instead

### How to Verify

After each change:
```bash
rm -f build/stage1_rust && make stage1-rust
./build/stage1_rust build packages/forgec/src/main.fg
bash scripts/diagnose.sh --score output.ll
# Build + test Stage 2:
cp output.ll /tmp/stage1_output.ll
/opt/homebrew/opt/llvm@18/bin/llc -O2 -filetype=obj /tmp/stage1_output.ll -o /tmp/stage2.o
cc -o /tmp/stage2 /tmp/stage2.o build/runtime.o -lm -Wl,-stack_size,0x10000000 \
  packages/std-llvm/target/release/libforge_llvm.a \
  -L/opt/homebrew/Cellar/llvm@18/18.1.8/lib -lLLVM-18 -lstdc++ -lz -lcurses
/tmp/stage2 build packages/forgec/src/main.fg  # must NOT overwrite output.ll
```

**Key metric:** Stage 2 should find >0 functions (`scanned N files, M fns` where M > 0).

## What's Already Working

These are in place and must not be broken:

1. Token kind_ids are correct (`forge_ftok_push` receives right values)
2. `core/kind_ids.fg` with `KID_*` constants, parser uses them
3. `scripts/diagnose.sh` with `--score`, `--stage2`, `--kind-ids`
4. Nullable unwrap in `emit_binary` for comparisons
5. `forge_value_is_string` distinguishes ForgeString from nullable
6. Statement.If uses `emit_if_expr` (returns value, typed PHI)
7. Struct literals use `forge_struct_field_index` for correct GEP indices
8. Global initializers bake integer values into LLVM globals
9. Global allocas default to ForgeString for non-scalar types

## File Map

| File | Role |
|------|------|
| `packages/forgec/src/codegen/mod.fg` | Self-hosted codegen (~150K bytes) — **THIS IS THE FILE TO AUDIT** |
| `packages/forgec/src/core/kind_ids.fg` | Token kind_id constants (single source of truth) |
| `packages/forgec/src/features/functions/mod.fg` | Function declaration + body emission |
| `packages/forgec/src/parser/mod.fg` | Parser with KID_* dispatch |
| `packages/forgec/src/parser/expressions.fg` | Expression parser |
| `stdlib/runtime.c` | C runtime + registries |
| `stdlib/debug.c` | Debug utilities (included by runtime.c) |
| `scripts/diagnose.sh` | All diagnostics (`--score`, `--stage2`, `--kind-ids`) |
