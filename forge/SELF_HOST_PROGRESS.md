# Self-Hosting Progress

**Status: Stage 2 binary exists, crashes when compiling itself**

Last updated: 2026-03-25

## Pipeline

```
Bootstrap (Rust) ──→ Stage 1 binary ──→ Stage 2 binary ──→ Stage 3 (self-hosting)
       ✅                  ✅              ✅ (runs)         ❌ (crashes)
```

## What Works Right Now

1. **Bootstrap (Rust compiler)** compiles forgec source → self-hosted compiler runs in-process
2. **stage1_bootstrap** binary (`./stage1_bootstrap`, saved from `/tmp/fh119`) — finds all 38 modules, tokenizes correctly (385 fns), declares and emits all functions, produces valid IR, links to working binary
3. **Stage 2** binary exists, prints usage, accepts commands
4. **Stage 2 crashes** at `collect_module_paths` → `forge_string_compare` when trying to compile itself

## The One Bug Blocking Self-Hosting

**Stage 2's `collect_module_paths` crashes at `forge_string_compare + 96`.**

Root cause chain:
1. `stage1_bootstrap` was compiled by the Rust bootstrap from commit ~90b642b source
2. The Rust bootstrap has 68 pre-existing type errors (`ptr` vs `int` mismatches) but "continues despite errors"
3. The generated self-hosted compiler codegen has bugs from this error continuation
4. Specifically: `emit_assign` overwrites `CG_LAST_VAR_PTR` (the RHS evaluation clobbers the target pointer) — causes `last_slash = ci` to store to wrong variable
5. Also: `CG_LAST_IS_STR` not reset after function calls with string args — causes `let found = forge_string_index_of(...)` to create a ForgeString variable instead of int
6. These two bugs corrupt `collect_module_paths` in any binary produced by `stage1_bootstrap`

## Why We Can't Just Fix It

**Bootstrap fragility:** The Rust bootstrap compiles the forgec source with 68 type errors. It "continues despite errors" and generates code. ANY change to the codegen source — even adding a single `if` statement — shifts which code paths get corrupted. This means:

- Adding `CG_LAST_IS_STR = 0` in `emit_fn_call_direct` → breaks Lexer (385 → 18 fns)
- Adding `self` resolution in `emit_call` MemberAccess → causes infinite loops
- Adding Break handler → prevents bootstrap from producing IR

The codegen fixes are CORRECT but can't be deployed through the bootstrap path.

## What We Tried This Session (and what happened)

| Approach | Result |
|----------|--------|
| Fix emit_assign target_ptr | ✅ Safe, doesn't break bootstrap |
| Fix BoolLit constant | ✅ Safe, doesn't break bootstrap |
| Fix CG_LAST_IS_STR in emit_ident | ✅ Safe, doesn't break bootstrap |
| Fix CG_LAST_IS_STR reset in emit_fn_call_direct | ❌ Breaks bootstrap (385→18 fns) |
| Fix self.method() → Type__method | ❌ Causes infinite loop when applied to all vars |
| Fix self.method() for "self" only | ✅ Safe alone but combined with above → 18 fns |
| Fix Break handler | ❌ Breaks bootstrap (no IR produced) |
| Fix chained member access | ✅ Safe alone |
| Pass self by pointer | ❌ Breaks tokenizer (385→18 fns) |
| Rewrite main.fg with direct function calls | ❌ Rust bootstrap doesn't know about forge_string_* |
| CSV-based build_compile_separate | ✅ Works, avoids List<string> push bug |
| Let-handler CG_LAST_IS_STR correction | ✅ Fixes crash without breaking bootstrap |

## Recreating Stage 1

`stage1_bootstrap` is NOT a standalone binary — it's the full Rust compiler (`target/release/forgec`, 2.2MB). It runs the self-hosted compiler in-process via `forgec run`. The Rust runtime handles list push, string ops, etc. correctly.

**To recreate (always works):**
```bash
cd forge/
git checkout 90b642b -- packages/forgec/src/
LLVM_SYS_180_PREFIX=/opt/homebrew/opt/llvm@18 cargo build --release
target/release/forgec run packages/forgec/src/main.fg -- build packages/forgec/src/main.fg /tmp/stage1_output
git checkout HEAD -- packages/forgec/src/
# /tmp/stage1_output → llc → link → standalone Stage 1 binary
```

The standalone 280KB binaries (produced by llc+link) have `@span` global conflicts with runtime.c's `span()` function. Fix: make `@span` internal in IR before llc, or remove `span()` from runtime.

## Concrete Plan to Full Self-Hosting

### Step 1: Make stage1_bootstrap reproducible
- [ ] Fix the `@span` global vs `span()` function conflict
- [ ] Document exact command to recreate from clean checkout
- [ ] Verify recreated binary matches ./stage1_bootstrap behavior (385 fns)

### Step 2: Fix collect_module_paths crash in Stage 2
Stage 2 was compiled by stage1_bootstrap. Its `collect_module_paths` has the emit_assign bug. Options:
- [ ] Option A: Rewrite collect_module_paths to avoid assignments inside if blocks (work around the bug)
- [ ] Option B: Use resolve_modules path for build command (it uses per-char scanning that works)
- [ ] Option C: Fix the 68 Rust bootstrap type errors so the bootstrap can compile fixed codegen

### Step 3: Stage 2 compiles Stage 3
- [ ] Stage 2 finds all 38 modules
- [ ] Stage 2 tokenizes correctly (385 fns)
- [ ] Stage 2 declares and emits all functions
- [ ] Stage 2 produces valid IR
- [ ] Stage 3 binary links and runs

### Step 4: Stage 3 = Stage 2 (fixed point)
- [ ] Stage 3 produces identical IR to Stage 2
- [ ] Delete Rust bootstrap

## Key Files

| File | Role |
|------|------|
| `./stage1_bootstrap` | Saved working Stage 1 binary (from /tmp/fh119) |
| `packages/forgec/src/main.fg` | CLI entry, module resolution, build pipeline |
| `packages/forgec/src/codegen/mod.fg` | LLVM IR codegen (2500+ lines, most critical) |
| `packages/forgec/src/features/functions/mod.fg` | Function scanning, declaration, body emission |
| `packages/forgec/src/parser/expressions.fg` | Expression parser with inline codegen |
| `packages/forgec/src/lexer/mod.fg` | Tokenizer |
| `stdlib/runtime.c` | C runtime (string ops, list ops, process, fs) |
| `packages/std-llvm/src/lib.rs` | LLVM C API wrappers with type guards |

## Codegen Fixes Applied (committed, safe for bootstrap)

1. **BoolLit**: `if value { return const_int(1) }` instead of `emit_ident("value")`
2. **emit_assign**: `let target_ptr = CG_LAST_VAR_PTR` saved before `emit_expr(value)`
3. **emit_ident**: `CG_LAST_IS_STR = 1` when found in `CG_STR_VAR_NAMES`
4. **Let handler**: Clear `CG_LAST_IS_STR` for known i64-returning extern functions
5. **Parser desugaring**: `source.index_of(x)` → `Call(Ident("forge_string_index_of"), [source, x])`

## Codegen Fixes Identified But NOT Applied (break bootstrap)

1. **CG_LAST_IS_STR reset in emit_fn_call_direct** — any code change to this function breaks tokenizer
2. **self.method() → Type__method resolution** — works for "self" only but combined with other fixes → 18 fns
3. **Break handler** — `llvm.build_br(CG_B, WHILE_END_BB)` prevents bootstrap IR output
4. **While BB save/restore** — safe alone, needed for Break handler
5. **Chained member access** — safe alone, needed for `self.source.length`
6. **Self by pointer** — breaks tokenizer (ForgeString vs ptr mismatch)
