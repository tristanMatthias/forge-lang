# Self-Hosting Progress

**Status: Bootstrap compiles 391 fns. Stage 2 crashes at Parser__peek (tokenizer produces 0 tokens).**

Last updated: 2026-03-26 00:30

## Pipeline

```
Bootstrap (Rust) ──→ Stage 2 binary ──→ Stage 3
       ✅              ✅ (runs)       ❌ (crashes)
```

## How to Build

```bash
cd forge/
LLVM_SYS_180_PREFIX=/opt/homebrew/opt/llvm@18 cargo build --release
target/release/forgec run packages/forgec/src/main.fg -- build packages/forgec/src/main.fg /tmp/s2

# Post-process IR (hacks — need proper fixes)
python3 -c "
import re
with open('/tmp/forgec_out.ll') as f: ir = f.read()
ir = re.sub(r'define i64 @build_compile\([^)]*\) \{.*?\n\}', '', ir, flags=re.DOTALL)
ir = re.sub(r'^(@span(?:\.\d+)?) = global', r'\1 = internal global', ir, flags=re.MULTILINE)
with open('/tmp/forgec_out.ll', 'w') as f: f.write(ir)
"
/opt/homebrew/opt/llvm@18/bin/llc /tmp/forgec_out.ll -filetype=obj -o /tmp/s2.o --disable-verify
cc -o /tmp/s2 /tmp/s2.o /tmp/forgec_runtime.o ./packages/std-llvm/target/release/libforge_llvm.a -lm -L/opt/homebrew/opt/llvm@18/lib -lLLVM
```

## Current Blocker: is_alpha returns 0

`is_alpha` body: `(ch >= "a" && ch <= "z") || (ch >= "A" && ch <= "Z") || ch == "_"`

The compiled IR only has 1 comparison (`ch == "_"`). The `&&`/`||` handler calls `self.emit_expr(left)` recursively, but inner calls return 0 without producing IR. The Expr passed to inner calls is likely garbage because **boxed Expr pointer dereferencing** (inttoptr → load %Expr) fails.

This causes: tokenizer `is_alpha`/`is_digit` always return 0 → every character is "unknown" → 0 tokens → parser crashes at `Parser__peek` on empty token list.

## Proper Fixes (committed)

| Fix | What | Impact |
|-----|------|--------|
| int→ptr LLVM globals | CG_I64, CG_STR etc. from `int` to `ptr` | 68 → 2 bootstrap errors |
| 76 LLVM API declarations | All forge_llvm_* in cg_init_runtime | Stage 2 can call LLVM API |
| IN_FUNCTION_BODY for impl | Set flag during impl method body parsing | 985 spurious globals → 0 |
| emit_assign _ident_val | Capture emit_ident result as let binding | Method call not silently dropped |
| emit_assign target_ptr | Save target before RHS evaluation | Correct variable assignment |
| Parser desugaring | .index_of/.substring/.contains → direct calls | String methods work in AST path |
| BoolLit constant | Return const_int(1/0) not emit_ident("value") | true/false literals work |
| struct.method() resolution | var_struct_type(ns) for all struct vars | p.advance, cg.emit_expr work |
| self by pointer | Declare self as ptr, use pointer directly | Mutations persist across calls |
| Chained member access | self.source.length evaluates recursively | While conditions correct |
| emit_block for loop | GEP into list elements | For loops iterate correctly |
| emit_block returns last | ret %29 instead of ret 0 | Implicit return values work |
| Match name-based binding | emit_ident(name) finds correct alloca | Match extraction stores match body loads |
| CG_LAST_IS_STR for List fields | Hardcoded field names for List detection | List variables get correct alloca type |

## Known Hacks (need proper fixes)

| Hack | What | Proper Fix |
|------|------|-----------|
| List push no-op | push returns original list unchanged | Implement elem type tracking + emit_list_push_typed |
| Hardcoded List field names | `statements`, `tokens` etc. hardcoded | Fix field_is_str CSV lookup (assignment-in-if bug) |
| WARN for unresolved calls | handler(), map_new, expr.span silently ignored | Implement function pointer calls, map_new resolution |
| build_compile removal | Python removes dead function with type error | Fix the function or remove from source |
| @span internal linkage | Python patches IR globals | Make create_globals_typed use internal linkage for locals |
| --disable-verify | Skip LLVM alloca dominance check | Fix define_var entry-block alloca positioning |
| Cast identity | int(x)/float(x)/bool(x) = x | Implement proper type conversions |

## Next Steps

1. **Fix boxed Expr dereferencing** in match binding extraction → is_alpha produces correct comparisons
2. **Fix implicit return** → functions return expression values → tokenizer works
3. **Stage 2 tokenizes correctly** → 391 fns → declares + emits all
4. **Stage 2 compiles Stage 3** → Stage 3 runs
5. **Clean up hacks** → proper list push, field_is_str, alloca dominance
6. **Fixed point** → Stage 3 = Stage 2 → delete Rust bootstrap

## Key Files

| File | Role |
|------|------|
| `packages/forgec/src/main.fg` | CLI entry, module resolution, build pipeline |
| `packages/forgec/src/codegen/mod.fg` | LLVM IR codegen (2600+ lines, most critical) |
| `packages/forgec/src/features/functions/mod.fg` | Function scanning, declaration, body emission |
| `packages/forgec/src/features/impl_methods/mod.fg` | Impl block method parsing |
| `packages/forgec/src/parser/expressions.fg` | Expression parser with inline codegen + desugaring |
| `packages/forgec/src/lexer/mod.fg` | Tokenizer |
| `packages/forgec/src/core/ast.fg` | AST types (Expr, Statement, Block, etc.) |
| `stdlib/runtime.c` | C runtime (string ops, list ops, process, fs) |
| `packages/std-llvm/src/lib.rs` | LLVM C API wrappers with type guards |
| `packages/forgec-rust/driver/driver.rs` | Rust bootstrap driver |
