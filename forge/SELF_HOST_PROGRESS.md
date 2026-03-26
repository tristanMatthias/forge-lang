# Self-Hosting Progress

**Status: SELF-HOSTING ACHIEVED (mini compiler). Fixed point reached — Stage 2 = Stage 3.**

Last updated: 2026-03-26

## Mini Compiler — FULLY SELF-HOSTED

```
Rust bootstrap ──→ mini Stage 1 ──→ mini Stage 2 ──→ mini Stage 3
       ✅               ✅               ✅               ✅ (= Stage 2)
```

The mini compiler (`packages/forgec/src/mini/`) is a 5700-line self-hosted Forge compiler that:
- Tokenizes, parses to AST, and emits LLVM IR text
- Supports: structs, enums, match, functions, lists, maps, strings, closures, for-in, while, if/else
- Compiles itself to identical IR at Stage 2 and Stage 3 (fixed point)
- 185 functions, 26K lines of IR, ~1.1MB IR output

### How to Build (mini)

```bash
cd forge/
# Option 1: Use saved Stage 1 binary
./mini_stage1 build packages/forgec/src/mini/main.fg /tmp/mini_stage2

# Option 2: Bootstrap from Rust
LLVM_SYS_180_PREFIX=/opt/homebrew/opt/llvm@18 cargo build --release
target/release/forgec build packages/forgec/src/mini/main.fg --dev -o /tmp/mini_stage1
/tmp/mini_stage1 build packages/forgec/src/mini/main.fg /tmp/mini_stage2
```

## Full Compiler (packages/forgec/src/main.fg) — IN PROGRESS

## Pipeline

```
Bootstrap (Rust) ──→ Stage 2 IR ──→ Stage 2 binary ──→ Stage 3
       ✅              ✅              ⚠️ (IR text fix)    ❌
```

## How to Build

```bash
cd forge/
LLVM_SYS_180_PREFIX=/opt/homebrew/opt/llvm@18 cargo build --release
target/release/forgec run packages/forgec/src/main.fg -- build packages/forgec/src/main.fg /tmp/s2

# Post-process IR
sed -i '' 's/@\(span[0-9]*\) = global/@\1 = internal global/g' /tmp/forgec_out.ll
sed -i '' 's/<null operand!>/ptr null/g' /tmp/forgec_out.ll
/opt/homebrew/opt/llvm@18/bin/llc /tmp/forgec_out.ll -filetype=obj -o /tmp/s2.o --disable-verify
cc -c stdlib/runtime.c -o /tmp/runtime.o
cc /tmp/s2.o /tmp/runtime.o -L packages/std-llvm/target/release -lforge_llvm -L /opt/homebrew/opt/llvm@18/lib -lLLVM -L /opt/homebrew/opt/bdw-gc/lib -lgc -o /tmp/s2
```

## Current Blockers

### 1. `<null operand!>` in IR text (124 occurrences)
List push on empty lists generates `forge_memcpy(new_ptr, <null>, 0)`. The null pointer constant can't be serialized. Fix: inline the push logic in the emit handler instead of calling `emit_list_push` as a separate function.

### 2. emit_list_push parameter type mismatch
The `emit_list_push` function takes `ptr` params (compiled as i64) but does `extractvalue %ForgeString`. Fix: same as above — inline instead of function call.

## Breakthrough: Enum Boxing (commit b024f50)

**Root cause found:** Enum fields (Expr inside Statement, BinOp inside Expr) were stored inline (many i64 slots) but the Forge codegen expected them boxed as 1-slot heap pointers. This caused:
- Tag corruption when extracting nested enums
- Match arms failing silently (returning 0)
- `process.args()` returning null
- All expression evaluation broken for AST-then-emit path

**Fix:** Box ALL non-primitive, non-collection, non-Span fields in enum variants. Resolve stub types during unboxing. Use field_type (not subject_type) for loads.

## Proper Fixes (committed)

| Fix | What | Impact |
|-----|------|--------|
| Enum boxing | Box all non-trivial fields in enum variants | Match arms work, expressions evaluate correctly |
| Stub type resolution | Resolve empty-variant stubs to full types | Nested match (Call→MemberAccess→Ident) works |
| Remove duplicate stubs | Delete shadowing emit_statement/write_ir | 11 match arms (was 4) |
| Struct return | Use CG_LAST_VAL not undef | Functions return actual values |
| Empty list fix | VAR_LIST_INIT_CSV per-function | `[]` gets ForgeString alloca |
| List elem GEP | resolve_type_to_llvm for struct elements | Correct stride for List<Token> etc. |
| define_var fix | Use CG_LAST_IS_STR flag directly | Variables get correct alloca type |
| String methods | index_of/substring/contains in emit_call | String ops work in AST-then-emit path |
| .length fix | Clear CG_LAST_IS_STR after length | Int variables not polluted by string ops |
| Field type table | Binary:ppp4, Unary:pp4 | All enum fields correctly boxed |
| GEP index coercion | ensure_i64 in std-llvm | Non-integer GEP indices handled |
| Conditional memcpy | Skip when empty list | No null source pointer crashes |
| Self type resolution | All self params get struct type | `self.field` access works for all methods |
| coerce_for_store | Type coercion for assignments | Narrow int → i64 widening |
| int→ptr LLVM globals | CG_I64, CG_STR etc. from `int` to `ptr` | 68 → 2 bootstrap errors |
| 76 LLVM API declarations | All forge_llvm_* in cg_init_runtime | Stage 2 can call LLVM API |
| IN_FUNCTION_BODY for impl | Set flag during impl method body parsing | 985 spurious globals → 0 |

## Known Hacks (need proper fixes)

| Hack | What | Proper Fix |
|------|------|-----------|
| List push no-op (Stage 2) | push returns original list in compiled output | Inline emit_list_push in handler |
| Hardcoded List field names | `statements`, `tokens` etc. hardcoded | Fix field_is_str CSV lookup |
| WARN for unresolved calls | handler(), map_new silently ignored | Implement function pointer calls |
| @span internal linkage | sed patches IR globals | Make create_globals_typed use internal |
| --disable-verify | Skip LLVM alloca dominance check | Fix define_var entry-block positioning |
| `<null operand!>` sed fix | sed replaces in IR text | Inline list push |
| Assignment-in-if | Assignments inside if blocks may store to wrong var | Track alloca type + coerce |

## Next Steps

1. **Inline list push** → fix null operand + type mismatch → Stage 2 compiles to binary
2. **Fix assign-in-if** → assignments in if blocks generate correct IR
3. **Stage 2 runs** → scans files, registers functions
4. **Stage 2 compiles Stage 3** → Stage 3 runs
5. **Fixed point** → Stage 3 = Stage 2 → delete Rust bootstrap

## Key Files

| File | Role |
|------|------|
| `packages/forgec/src/main.fg` | CLI entry, module resolution, build pipeline |
| `packages/forgec/src/codegen/mod.fg` | LLVM IR codegen (2900+ lines, most critical) |
| `packages/forgec/src/features/functions/mod.fg` | Function scanning, declaration, body emission |
| `packages/forgec/src/features/impl_methods/mod.fg` | Impl block method parsing |
| `packages/forgec/src/features/variables/mod.fg` | Variable declaration with list tracking |
| `packages/forgec/src/parser/expressions.fg` | Expression parser with inline codegen |
| `packages/forgec/src/lexer/mod.fg` | Tokenizer |
| `packages/forgec/src/core/ast.fg` | AST types (Expr, Statement, Block, etc.) |
| `stdlib/runtime.c` | C runtime (string ops, list ops, process, fs) |
| `packages/std-llvm/src/lib.rs` | LLVM C API wrappers with type guards |
| `packages/forgec-rust/features/enums/checker.rs` | Enum boxing logic |
| `packages/forgec-rust/features/pattern_matching/codegen.rs` | Match extraction + unboxing |
