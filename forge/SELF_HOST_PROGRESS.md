# Self-Hosting Progress

**Status: FULL COMPILER SELF-COMPILES. Stage 2 binary produced. Working toward Stage 2 = Stage 3 fixed point.**

Last updated: 2026-03-26

## Pipeline

```
Rust bootstrap ──→ mini (self-hosting) ──→ full compiler (Stage 1) ──→ Stage 2 binary
       ✅               ✅                        ✅                       ✅
```

## Mini Compiler — FULLY SELF-HOSTED

The mini compiler (`packages/forgec/src/mini/`) is a 5700-line self-hosted Forge compiler:
- Fixed point: Stage 2 = Stage 3 (byte-identical IR)
- 189 functions, 27K lines of IR
- Compiles the full 410-function compiler in ~1.5s

## Full Compiler Self-Compiles

```
Mini ──→ Stage 1 (full compiler, 410 fns) ──→ Stage 2 (self-compiled binary)
  ✅                   ✅                              ✅ (runs, needs runtime fixes)
```

Stage 1 (compiled by mini):
- Scans all 38 source files ✅
- Declares all 405 functions ✅
- Emits all 410 functions ✅
- IR passes LLVM verification (no --disable-verify) ✅
- Produces working binary ✅
- Compiles simple programs (hello, fib, while, if-else, lists) ✅

Stage 2 (compiled by Stage 1):
- Binary produced and runs ✅
- main() receives argc/argv via forge_set_args ✅
- Runtime codegen needs same fixes to cascade (in progress)

## Key Fixes (chronological)

| Fix | Impact |
|-----|--------|
| Backtick template strings | Enum variant tag registration works |
| kind_id dispatch system | Parser bypasses broken TokenKind matching |
| build_ret struct bitcast | Named vs anonymous struct return types |
| Map null guards | 34 → 85 functions (+51) |
| Bool/null text fallbacks | Parser no longer hangs on false/null |
| List stride fixes | int/string list push+index consistent |
| Alloca domination fix | Removed --disable-verify |
| Shorthand enum variant search | **85 → 410 functions** (THE fix) |
| main argc/argv | Stage 2 can receive command-line args |

## How to Build

```bash
cd forge/
# Build Rust bootstrap
LLVM_SYS_180_PREFIX=/opt/homebrew/opt/llvm@18 cargo build --release

# Build mini
target/release/forgec build packages/forgec/src/mini/main.fg --dev -o /tmp/mini_s1
/tmp/mini_s1 build packages/forgec/src/mini/main.fg /tmp/mini_s2

# Build full compiler (Stage 1) via mini
/tmp/mini_s2 build packages/forgec/src/main.fg /tmp/stage1

# Self-compile (Stage 2)
/tmp/stage1 build packages/forgec/src/main.fg
# → produces a.out (Stage 2)
```

## Next Steps

1. **Stage 2 runtime** — make Stage 2 binary compile programs correctly
2. **Stage 3** — Stage 2 compiles itself → Stage 3
3. **Fixed point** — Stage 2 = Stage 3
4. **Delete mini** — mini is no longer needed

## Key Files

| File | Role |
|------|------|
| `packages/forgec/src/main.fg` | CLI entry, module resolution, build pipeline |
| `packages/forgec/src/codegen/mod.fg` | LLVM IR codegen (3000+ lines) |
| `packages/forgec/src/features/functions/mod.fg` | Function scanning, declaration, body emission |
| `packages/forgec/src/features/for_loops/mod.fg` | For-in loop codegen |
| `packages/forgec/src/features/pattern_matching/mod.fg` | Match expression codegen |
| `packages/forgec/src/parser/mod.fg` | Statement parser with kind_id dispatch |
| `packages/forgec/src/parser/expressions.fg` | Expression parser with kind_id dispatch |
| `packages/forgec/src/core/token.fg` | Token types + kind_id_for_keyword |
| `packages/forgec/src/lexer/mod.fg` | Tokenizer (all tokens have kind_id) |
| `packages/forgec/src/mini/` | Mini compiler (bootstrap, to be deleted) |
| `stdlib/runtime.c` | C runtime (strings, lists, maps, process, fs) |
| `packages/std-llvm/src/lib.rs` | LLVM C API wrappers with type guards |
