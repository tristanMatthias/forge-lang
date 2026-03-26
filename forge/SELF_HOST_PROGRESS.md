# Self-Hosting Progress

**Status: Stage 2 finds all 38 modules, compiles Stage 3. Tokenizer broken (18/390 fns).**

Last updated: 2026-03-25 18:00

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

## Current Blockers (in order)

### Blocker 1: list.push on untracked variables (CURRENT)
`result.push(item)` panics because `result` isn't registered in `CG_LIST_VAR_CSV`.
Root cause: `mut result: List<string> = []` — the `[]` literal returns `Expr.Block(empty)` in AST mode, which doesn't set `CG_LAST_IS_LIST`. The Let handler never registers it as a list.
Fix needed: track list variables from type annotations or from `[]` initialization.

### Blocker 2: LLVM API functions not declared in output module
Stage 2's binary has ZERO `forge_llvm_*` declarations. Every `llvm.*` call (build_and, build_icmp, build_store, etc.) silently returns 0. The tokenizer, parser, codegen — nothing works because the compiler can't call ANY LLVM functions.
Fix needed: declare all ~50 forge_llvm_* functions in the output module.
Challenge: Rule 9 says bootstrap drops new declarations from cg_init_runtime.

### Blocker 3: Tokenizer produces byte-level tokens
Even with self-by-pointer and struct resolution, Stage 2 produces 1 token per byte. Root cause is Blocker 2 — `llvm.build_and`, `llvm.build_icmp` etc. all return 0, so `is_alpha`, `is_digit` etc. always return false/undef.

## What Works Now

- [x] Bootstrap reproduces from commit 90b642b (`target/release/forgec run`)
- [x] Bootstrap → 38 files, 390 fns, valid IR, links
- [x] Stage 2 runs, prints usage
- [x] Stage 2 finds all 38 modules (collect_module_paths works)
- [x] Stage 2 scans all 38 files (csv_len=1590)
- [x] Stage 2 compiles Stage 3 (with 18 fns — incomplete)
- [x] Stage 3 binary runs
- [x] FATAL panic on unresolved calls (no more silent failures)
- [x] struct.method() resolves for ALL struct variables (not just self)
- [x] self passed by pointer (mutations persist)
- [x] Chained member access (self.source.length)
- [x] Parser desugaring for string methods
- [x] emit_assign target_ptr fix
- [x] BoolLit constant fix
- [x] Let handler CG_LAST_IS_STR correction

## Concrete Plan to Full Self-Hosting

### Step 1: Fix list.push (Blocker 1)
- [ ] Track list variables from `[]` initialization in AST mode
- [ ] Verify push works in AST codegen path

### Step 2: Declare LLVM API in output module (Blocker 2)
- [ ] Find approach that doesn't get dropped by bootstrap
- [ ] Declare all forge_llvm_* functions needed by the compiler

### Step 3: Stage 2 tokenizes correctly
- [ ] is_alpha, is_digit, etc. return correct values
- [ ] Stage 2 scans 390 fns (not 18)
- [ ] Stage 2 declares all functions

### Step 4: Stage 2 compiles Stage 3 correctly
- [ ] Stage 3 binary produces same output as Stage 2
- [ ] Fixed point achieved
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

## Session 2 End-of-Day Status (2026-03-25 19:30)

### Major breakthroughs:
- Bootstrap errors: 68 → 2 (int→ptr for LLVM type globals)
- All 76 forge_llvm_* functions declared in output module
- 391 fns scanned + declared, compilation completes
- Stage 2 links with libforge_llvm.a + libLLVM (1.8MB)
- FATAL panics on unresolved calls (no silent failures)

### Current blocker: Expr match destructuring
Stage 2 hangs because Parser__check/is_alpha return 0. Root cause:
`match expr { .Binary(left, op, right, span) -> { emit_binary(left, op, right) } }`
extracts fields to alloca slots %7,%8,%9,%10 but reads from %18,%22,%20 (wrong allocas).
Every function that matches on Expr.Binary passes garbage to emit_binary.
This is a match field→alloca mapping bug in the codegen.

### CRITICAL FIX: IN_FUNCTION_BODY for impl methods
impl methods didn't set IN_FUNCTION_BODY=1 during body parsing.
ALL local variables in methods were registered as GLOBALS (985 globals → 0).
This caused: target_ptr fix didn't work (global shared across calls),
pre_binding_offset didn't accumulate, loop vars corrupted across functions.
Fixed: add IN_FUNCTION_BODY=1/0 around parse_block in parse_impl_method_as_fn.

### Remaining: match binding alloca mapping
emit_expr's Binary dispatch still loads bindings from wrong allocas.
With the globals fix, pre_binding_offset SHOULD accumulate correctly now.
Need to verify the offset computation produces correct alloca indices.

### Session 2 Continued (late night)

**Breakthroughs:**
- emit_block for loop now correctly loads list elements via GEP
- emit_block returns actual last expression value (not 0)
- Match binding extraction and body load use same allocas (name-based search)
- CG_LAST_IS_STR set for known List struct fields
- Stage 2 crash moved from infinite loop → segfault in Parser__peek (progress)

**Current blocker:** is_alpha still returns 0
- `(ch >= "a" && ch <= "z") || ...` produces only 1 comparison for `ch == "_"`
- Inner emit_expr calls for sub-expressions return 0 (no IR produced)
- Match bindings are correct but boxed Expr dereferencing may fail
- Need to verify that boxed pointer extraction (inttoptr → load %Expr) works
