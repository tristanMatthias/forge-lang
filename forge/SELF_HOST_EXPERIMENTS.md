# Self-Hosting Experiments Log

**RULE: Before trying ANY new approach, search this file first. Log EVERY experiment with results.**

## Format
```
### EXP-NNN: Short title
**Date:** YYYY-MM-DD
**Milestone:** M1/M2/etc
**Hypothesis:** What we expected
**Change:** What was changed (files, lines)
**Score:** before → after
**Result:** ✅ IMPROVEMENT / ❌ REGRESSION / ⚪ NO CHANGE
**Kept/Reverted:** kept/reverted
**Verify:** How to reproduce (rebuild commands + what to check)
**Lesson:** What we learned
```

## How to verify any experiment
```bash
# 1. Apply the change to the source files
# 2. Rebuild full pipeline:
cd forge/
cc -c -O0 stdlib/runtime.c -o /tmp/mini_runtime.o
LLVM_SYS_180_PREFIX=/opt/homebrew/opt/llvm@18 ./target/release/forgec run packages/forgec/src/mini/main.fg -- build packages/forgec/src/main.fg
/opt/homebrew/opt/llvm@18/bin/llc -O2 -filetype=obj /tmp/mini_output.ll -o /tmp/stage1.o
cc -o /tmp/stage1 /tmp/stage1.o /tmp/mini_runtime.o -lm -Wl,-stack_size,0x10000000 packages/std-llvm/target/release/libforge_llvm.a /opt/homebrew/opt/llvm@18/lib/libLLVM-18.dylib -lstdc++ -lz -lcurses
/tmp/stage1 build packages/forgec/src/main.fg
# 3. Run audit:
bash scripts/audit_stage2.sh output.ll
# 4. Compare SCORE with baseline
```

---

### EXP-001: get_allocated_type as PRIMARY source in emit_ident
**Date:** 2026-03-29
**Milestone:** M1
**Hypothesis:** Using LLVMGetAllocatedType as the primary load type (instead of flag-guessing) would fix all load mismatches
**Change:** emit_ident fast path: `mut load_ty = llvm.get_allocated_type(cached_ptr)` instead of `CG_I64`
**Score:** 6912 → 8498
**Result:** ❌ REGRESSION (+1586)
**Kept/Reverted:** Reverted
**Lesson:** Overriding flag-based string detection breaks string variable loading. Many allocas are typed as i64 but the FLAG system correctly identifies them as string. The alloca type is LESS accurate than flags for string/list detection.

### EXP-002: define_var uses LLVMTypeOf(value) for alloca type
**Date:** 2026-03-29
**Milestone:** M1
**Hypothesis:** When flag-based type defaults to i64, check the actual LLVM type of the value being stored
**Change:** codegen/mod.fg define_var: check LLVMTypeOf kind==12 (ptr) or kind==13 (struct)
**Score:** 7076 → 6912
**Result:** ✅ IMPROVEMENT (-164)
**Kept/Reverted:** Kept
**Lesson:** This catches ptr and struct values that flags miss. Safe because it only fires when flags default to i64.

### EXP-003: Struct alloca overrides in emit_ident (kind==13)
**Date:** 2026-03-29
**Milestone:** M1
**Hypothesis:** When alloca is a struct type, load as that struct type instead of i64
**Change:** emit_ident: `if alloca_kind == 13 { load_ty = llvm.get_allocated_type(cached_ptr) }`
**Score:** N/A (llc error)
**Result:** ❌ REGRESSION (forward reference errors — PHI nodes expect ForgeString but get %Expr)
**Kept/Reverted:** Reverted
**Lesson:** Struct type overrides break PHI nodes because the codegen mixes types. The same variable is used as ForgeString in some branches and %Expr in others. Can't change load types for structs without fixing ALL downstream uses.

### EXP-004: Globals-as-ptr (non-string globals use CG_PTR type)
**Date:** 2026-03-30
**Milestone:** M1
**Hypothesis:** Non-string globals (CG_I64, CG_MOD, etc.) should be ptr-typed, not ForgeString
**Change:** create_globals_typed: use CG_PTR for non-string globals based on str_mask bitmask
**Score:** 6912 → 6920
**Result:** ❌ REGRESSION (+8)
**Kept/Reverted:** Reverted
**Lesson:** Code depends on ALL globals being ForgeString. Changing breaks things. The ForgeString-for-everything is a deliberate design choice.

### EXP-005: Mini codegen_let: prefer ptr alloca over ptrtoint coercion
**Date:** 2026-03-30
**Milestone:** M1
**Hypothesis:** When value is ptr but type defaults to i64, change alloca to ptr (instead of coercing ptr→i64)
**Change:** mini/codegen.fg codegen_let: `if store_rt == "ptr" && ty == "i64" { ty = "ptr" }` instead of ptrtoint
**Score:** 6912 → 6912
**Result:** ⚪ NO CHANGE
**Kept/Reverted:** Kept (harmless, correct behavior)
**Lesson:** The mini's register type fallback (line 1721) already catches ptr types before the coercion. The coercion was dead code in practice.

### EXP-006: Mini auto-declare uses ptr return for forge_llvm_*
**Date:** 2026-03-30
**Milestone:** M1
**Hypothesis:** Auto-declared forge_llvm_* functions should have ptr return type (matching Rust wrappers)
**Change:** mini/codegen.fg: `ir_raw("declare ptr @" + ad_name + "(...)")` for forge_llvm_* prefix
**Score:** 6912 → 6912
**Result:** ⚪ NO CHANGE (but fixes a declaration type mismatch — correct behavior)
**Kept/Reverted:** Kept
**Lesson:** The call sites already used ptr return (from FN_RETTYPES). The declaration mismatch was tolerated by LLVM but now fixed.

### EXP-007: emit_ident ptr-only alloca override via get_type_kind
**Date:** 2026-03-30
**Milestone:** M1
**Hypothesis:** For allocas typed as ptr (kind==12), override load to CG_PTR. Uses integer comparison to avoid circular ptr dependency.
**Change:** emit_ident: `if llvm.get_type_kind(llvm.get_allocated_type(cached_ptr)) == 12 { load_ty = CG_PTR }`
**Score:** 6912 → 6913
**Result:** ⚪ NO CHANGE (within variance)
**Kept/Reverted:** Kept (safe, correct behavior)
**Lesson:** The ptr override works but only catches allocas that are ALREADY typed as ptr. Most of the 1801 mismatches are from allocas that were created as i64 (because the value stored was i64 at define_var time). Circular dependency.

### EXP-008: forge_alloca_cache_get_type as PRIMARY load type
**Date:** 2026-03-30
**Milestone:** M1
**Hypothesis:** Store alloca type in cache alongside ptr, use it directly in emit_ident
**Change:** New cache field `alloca_type`, `forge_alloca_cache_set_type/get_type`, emit_ident uses stored type as primary
**Score:** 6913 → 7302
**Result:** ❌ REGRESSION (+389, null_operands: 0→30)
**Kept/Reverted:** Reverted to fallback-only mode
**Lesson:** Using stored type as PRIMARY breaks when `get_type` returns null (comparison `load_ty == null` is a ptr comparison subject to circular dependency). Must use as FALLBACK only, with get_type_kind for null-safe checking.

### EXP-009: forge_alloca_cache_get_type as FALLBACK with get_type_kind
**Date:** 2026-03-30
**Milestone:** M1
**Hypothesis:** Same as EXP-008 but only override when flags default to i64, using integer type kind check
**Change:** emit_ident: stored_kind = get_type_kind(get_type(name)); if kind==12 use PTR, kind==13 use stored type. Also store type in param setup and let-fallback.
**Score:** 6913 → 6910
**Result:** ✅ IMPROVEMENT (-3, load_type_mismatch -17, null_operands 0)
**Kept/Reverted:** Kept
**Lesson:** The stored type cache works as a FALLBACK when flags default to i64. Using get_type_kind for null-safe checking avoids circular ptr dependency. Only corrects 17 loads because most allocas were created as i64 (the stored type IS i64). The remaining 1785 need the alloca to be created with the correct type in the first place.

### EXP-010: Fix break/continue in while loops (3 bugs)
**Date:** 2026-03-30
**Milestone:** M3 (br_i1_false) / bootstrap
**Hypothesis:** break statements inside while loops are no-ops, causing infinite loops in tokenizer
**Change:** 3 fixes in codegen/mod.fg + parser/mod.fg:
  1. Parser returns Statement.Break/Continue (was Statement.Expr(IntLit(0)))
  2. emit_statement .Break/.Continue emit build_br to loop targets
  3. .While handler sets WHILE_END_BB/WHILE_COND_BB globals
  Also: emit_fn_body_from_source dispatches break(32)/continue(33)
**Score:** 6914 → 6914 (break doesn't affect type audit metrics)
**Result:** ✅ CRITICAL FIX — tokenizer infinite loops eliminated
**Kept/Reverted:** Kept
**Verify:** `printf 'fn main() { 1 }' > /tmp/t.fg && /tmp/stage2 build /tmp/t.fg` should produce tokens (not hang)
**Lesson:** Three separate bugs combined to make break a no-op:
  - Parser produced wrong AST node type
  - Codegen handler was empty stub (FOUND BY SEARCHING FOR EMPTY HANDLERS)  
  - While loop didn't set break target globals
  ALL THREE had to be fixed together. This is why empty/stub handlers are dangerous — they silently swallow behavior.

### EXP-011: Global load default CG_STR + GlobalGetValueType fallback
**Date:** 2026-03-30
**Milestone:** M1
**Hypothesis:** All globals are %ForgeString typed. Defaulting globals path to CG_STR should fix global loads.
**Change:** codegen/mod.fg: globals path load_ty = CG_STR (was CG_I64). Added GlobalGetValueType for globals.
**Score:** 6917 → 6916
**Result:** ⚪ NO CHANGE (-1, within variance)
**Kept/Reverted:** Kept (correct default, harmless)
**Verify:** Check `load %ForgeString, ptr @VAR_GLOBAL_NAMES` in output.ll
**Lesson:** Globals path is BYPASSED by fast path (alloca cache finds globals first).

### EXP-012: All globals registered as str vars
**Date:** 2026-03-30
**Milestone:** M1
**Hypothesis:** Register ALL globals in forge_str_var_add (not just bitmask-flagged ones)
**Change:** create_globals_typed: ALL get forge_str_var_add + CG_STR_GLOBALS_CSV
**Score:** 6917 → 7136
**Result:** ❌ REGRESSION (+219) — br_i1_false improved 102→81 but load/call regressed
**Kept/Reverted:** Reverted
**Verify:** Run audit, check br_i1_false and load_type_mismatch
**Lesson:** Non-string globals (CG_I64, CG_ACTIVE etc.) NEED i64 loads. Str-typing them breaks integer comparisons.

### EXP-013: Bitmask detection via forge_peek_kind_id
**Date:** 2026-03-30
**Milestone:** M1
**Hypothesis:** Use C-side token kind_id instead of let-stored value_tok_key for bitmask
**Change:** parse_var_binding: forge_peek_kind_id for [, {, string detection
**Score:** 6917 → 6917
**Result:** ⚪ NO CHANGE (C-side pos stale during scan-phase parse_var_binding)
**Kept/Reverted:** Kept (harmless)
**Verify:** Check VAR_GLOBAL_NAMES in str_check trace
**Lesson:** C-side position desyncs from Forge-side in parse_var_binding (by-value parser copy)

### EXP-014: Name pattern heuristics for list globals
**Date:** 2026-03-30
**Milestone:** M1
**Hypothesis:** Variables with NAMES/TYPES/PTRS/FIELDS suffixes are likely lists
**Change:** create_globals_typed: add pattern checks for common list suffixes
**Score:** 6917 → 7081
**Result:** ❌ REGRESSION (+164) — CG_STRUCT_TYPES (ptr list) wrongly loaded as str
**Kept/Reverted:** Reverted
**Verify:** Run audit
**Lesson:** Lists of pointers (like CG_STRUCT_TYPES) must load as ptr not ForgeString

### EXP-015: Stored alloca type as PRIMARY (before flags)
**Date:** 2026-03-30
**Milestone:** M1
**Hypothesis:** Use forge_alloca_cache_get_type as primary load type, flags only for downstream
**Change:** emit_ident: stored_kind check before flag checks
**Score:** 6920 → 7231
**Result:** ❌ REGRESSION (+311) — null_operands 0→30, br_i1_false 102→119
**Kept/Reverted:** Reverted
**Verify:** Run audit
**Lesson:** Stored type overrides CORRECT flag detection in some cases. Must keep as fallback only.
