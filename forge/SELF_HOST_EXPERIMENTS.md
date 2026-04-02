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

### EXP-016: Mini scan_fn_sig param parsing + declared param type infrastructure
**Date:** 2026-03-31
**Milestone:** M2 (call arg types) — infrastructure
**Hypothesis:** Parsing param types in pass 1 (scan_fn_sig) and storing in FN_PARAM_TYPES enables future declared-type lookups at call sites.
**Change:**
  - state.fg: scan_fn_sig now parses params via scan_params() helper, builds CSV of LLVM types
  - state.fg: Added csv_get(), find_fn_param_type(), scan_params() helpers
  - codegen.fg: impl method scanning also uses scan_params()
  - Call-site fallback attempted but REVERTED — values have wrong types (i64 not %ForgeString), so relabeling causes LLVM verification errors
**Score:** 6920 → 6920 (no change — infrastructure only)
**Result:** ⚪ NO CHANGE (infrastructure for future use)
**Kept/Reverted:** Kept (scan_params and FN_PARAM_TYPES population). Call-site fallbacks reverted.
**Verify:** Full rebuild pipeline + audit
**Lesson:** Can't fix call types by relabeling at call sites — values must have the correct LLVM type from loads. Declared param types are useful AFTER loads are fixed. CG_VAR_TYPES approach (+21 regression) fails because extra List.push operations add new type mismatches.

### EXP-017: ForgeString-only alloca type override in emit_ident
**Date:** 2026-03-31
**Milestone:** M1 (load types)
**Hypothesis:** In fallback path, use LLVMGetAllocatedType to detect ForgeString allocas (kind==13) and load as CG_STR instead of CG_I64. Also restrict fast path kind==13 to ForgeString-only (safer than generic struct override).
**Change:** codegen/mod.fg emit_ident: fallback path adds ForgeString-specific kind==13 check. Fast path kind==13 restricted to CG_STR comparison.
**Score:** 6920 → 6919
**Result:** ✅ IMPROVEMENT (-1, load_type_mismatch 1792→1791)
**Kept/Reverted:** Kept
**Verify:** Full rebuild pipeline + audit
**Lesson:** ForgeString override is safe but only catches 1 case in fallback path. The 763 ForgeString mismatches are in the fast path (alloca cache), meaning forge_alloca_cache_get_type already returns ForgeString for most of them. The remaining mismatches have a different root cause — likely the type was never stored in the cache.

### EXP-018: Fix audit script — per-function register tracking + accurate call mismatch
**Date:** 2026-03-31
**Milestone:** All milestones — measurement fix
**Hypothesis:** The audit script's load_type_mismatch is inflated because it tracks register names globally across functions (e.g., %1 in fn A is ForgeString, %1 in fn B is i64 — counted as mismatch). Similarly, call_type_mismatch counts ALL calls to struct-param functions, not just those with actual type mismatches.
**Change:**
  - audit_stage2.sh: Added `delete vars` when entering a new `define` (per-function tracking)
  - audit_stage2.sh: Replaced call_type_mismatch with Python script that checks actual arg types vs declared param types
  - runtime.c: forge_alloca_cache_set_type now checks fn scope (matching get_type behavior)
**Score:** 6919 → 1924 (not a real improvement — measurement correction)
**Result:** ✅ CRITICAL — reveals true baseline. load_type_mismatch was 1792 false positives → real: 0. call_type_mismatch was 3449 → real: 245.
**Kept/Reverted:** Kept
**Verify:** `bash scripts/audit_stage2.sh output.ll`
**Lesson:** M1 (load types) was ALREADY COMPLETE — zero actual load mismatches within any function. The 1792 count was entirely cross-function register name collisions. Always validate metrics before optimizing them. Real remaining work: 245 call mismatches, 103 br_i1_false, 170 ret_undef.

### EXP-019: Verify LLVM type before routing Eq/NotEq through forge_string_compare
**Date:** 2026-03-31
**Milestone:** M2 (call arg types)
**Hypothesis:** CG_LAST_IS_STR is spuriously set for non-string values (e.g., Token structs containing string fields). Checking `llvm.type_of(lhs) == CG_STR` before routing through string_compare would prevent 143 Token/integer comparisons from being misrouted.
**Change:** codegen/mod.fg: .Eq and .NotEq handlers check actual LLVM type of lhs/rhs against CG_STR before using forge_string_compare. Falls through to icmp if neither value is ForgeString.
**Score:** 1924 → 1903 (-21)
**Result:** ✅ IMPROVEMENT
**Kept/Reverted:** Kept
**Verify:** Full rebuild pipeline + audit
**Lesson:** Only caught 21 of expected 143 — the remaining misrouted comparisons may have values that ARE ForgeString type (loaded from string-typed allocas) but shouldn't be compared as strings. The type check only helps when the LLVM type is visibly wrong (Token, i64). When a variable is typed as ForgeString but contains an integer semantically, the type check can't distinguish.

### EXP-020: And/Or i1 conversion + cg_to_i1 helper for all branch conditions
**Date:** 2026-03-31
**Milestone:** M3 (br_i1_false)
**Hypothesis:** `br i1 false` comes from two sources: (1) && operator uses build_and on i64 values → produces i64, truncated to i1 = false. (2) if/while conditions with ptr/struct values → trunc to i1 = false.
**Change:**
  - And/Or handlers: convert operands to i1 via icmp ne 0 before build_and/build_or
  - New cg_to_i1() helper: converts any value (i64, ptr, struct) to i1 properly
  - Replaced all build_trunc(val, i1) calls in emit_if/emit_while with cg_to_i1()
**Score:** 799 → 565 (two commits: 799→676→565)
**Result:** ✅ IMPROVEMENT (-234 total, br_i1_false 103→25)
**Kept/Reverted:** Kept
**Verify:** Full rebuild pipeline + audit
**Lesson:** Most br_i1_false came from type conversion failures: i64→i1 trunc loses info, ptr→i1 trunc is invalid, struct→i1 trunc is invalid. Using icmp/ptrtoint correctly converts all types. Remaining 25 are dead code paths.

### EXP-022: CSV-based per-variable type tracking (CG_VAR_TYPE_CSV)
**Date:** 2026-03-31
**Milestone:** M2 (call arg types)
**Hypothesis:** Using CSV strings for per-variable type tracking avoids List.push calling convention issues. As PRIMARY type source in emit_ident, it should fix the 56 forge_string_compare mismatches where variables are semantically integers but typed as ForgeString.
**Change:**
  - Added CG_VAR_TYPE_CSV: ",name:type," format CSV string
  - Populated in define_var and param setup, cleared per-function
  - var_type_from_csv() lookup function
  - Tried as fallback (no effect — flags fire first)
  - Tried as PRIMARY (overriding flags) → null_operands 0→30, massive regression
**Score:** 494 → 823 as primary (REVERTED), 494 → 494 as fallback (no change)
**Result:** ❌ REGRESSION (as primary) / ⚪ NO CHANGE (as fallback)
**Kept/Reverted:** REVERTED
**Verify:** Full rebuild + audit
**Lesson:** The CSV type overrides CORRECT flag detection in some edge cases (producing null operands). The flag system, despite being imperfect, is tuned to avoid null operands. Replacing it with CSV breaks that tuning. The remaining call mismatches require fixing the type system at the mini level (calling convention for struct params) rather than workaround tracking at the self-hosted level.

### EXP-021: Proper global typing — i64 for integer globals, ForgeString for string globals
**Date:** 2026-03-31
**Milestone:** M2 (call arg types) — root cause fix
**Hypothesis:** create_globals_typed uses CG_STR for ALL globals. Loading an integer global returns ForgeString, causing CG_LAST_IS_STR to be spuriously set. By using i64 for non-string globals (based on str_mask), loads will return i64 and comparisons won't be misrouted through forge_string_compare. This should fix the 122 forge_string_compare mismatches.
**Change:**
  - create_globals_typed: use CG_I64 for non-string globals, CG_STR for string globals
  - emit_ident globals path: load non-string globals as i64 instead of ForgeString
  - forge_alloca_cache_set_type: store correct type per global
**Score:** 565 → ???
**Result:** ???
**Kept/Reverted:** ???

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

### EXP-023: Chained member access on non-Ident expressions
**Date:** 2026-03-31
**Milestone:** M2/M3
**Hypothesis:** emit_member_access returns full struct for non-Ident objects (e.g., self.peek().kind_id returns Token, not the kind_id field). Using CG_LAST_STRUCT_TYPE + struct_field_index should extract the correct field.
**Change:** codegen/mod.fg emit_member_access: in `_ ->` branch, check CG_LAST_STRUCT_TYPE and extract field via struct_field_index before returning obj_val.
**Score:** 565 → 513 (-52)
**Result:** ✅ IMPROVEMENT (call_type_mismatch -34, br_i1_false -6)
**Kept/Reverted:** Kept

### EXP-024: Null check optimization via forge_is_null_val
**Date:** 2026-03-31
**Milestone:** M2
**Hypothesis:** When comparing with null (== null, != null), extract ptr field from ForgeString and compare with null directly instead of calling forge_string_compare. Uses LLVMIsNull C wrapper.
**Change:** Added forge_is_null_val to std-llvm. Eq/NotEq handlers check is_null_check flag; if true, extract field 0 and icmp with null.
**Score:** 513 → 494 (-19)
**Result:** ✅ IMPROVEMENT (call_type_mismatch -25)
**Kept/Reverted:** Kept

### EXP-025: Global typing — i64 for non-string, remove ptr_var_add
**Date:** 2026-03-31
**Milestone:** M2/M5
**Hypothesis:** Using proper types for globals (i64 for integers, ForgeString for strings/lists) would fix type erasure. Removing forge_ptr_var_add for non-string globals prevents emit_ident from loading lists as ptr.
**Change:** create_globals_typed: i64 for non-string globals. Removed forge_ptr_var_add for non-string globals. Reverted to all-ForgeString globals. emit_ident globals path: load as i64 for non-string.
**Score:** 494 → 820 (REGRESSION) then reverted various combinations
**Result:** ❌ REGRESSION — non-string globals loaded as ForgeString breaks integer comparisons (+226 call_type_mismatch). Loading as i64 breaks list.length. The binary bitmask can't distinguish ptr from list from int.
**Kept/Reverted:** ALL REVERTED — back to original all-ForgeString globals + ptr_var_add
**Lesson:** The fundamental problem: globals need 3-way typing (int/ptr/list) but only have a binary bitmask (string-or-not). The flag system (forge_str_var_check, forge_ptr_var_check) was tuned to balance these incorrectly-typed globals. Changing one part without the other causes cascading regressions. CANNOT be fixed incrementally — needs a proper type system.

### EXP-026: C-side auto-extract for function bodies
**Date:** 2026-03-31
**Milestone:** M5
**Hypothesis:** forge_fn_store_add can auto-extract the body from source using C-side token spans when the Forge-level body extraction produces garbage (due to struct field extraction bugs).
**Change:** Added forge_extract_body_source, forge_set_scan_source, _current_scan_source. Modified forge_fn_store_add to re-extract when body is empty/corrupt. Modified forge_selfhost_fs_read to auto-store source.
**Score:** N/A (M5 functional test, not score)
**Result:** ✅ WORKS (body_len goes from garbage to correct 21) but is a HACK
**Kept/Reverted:** REVERTED — violates rule 2 (no C-side workarounds for codegen bugs)
**Lesson:** The C-side auto-extract proves the body CAN be extracted correctly with proper token span access. The fix should be in the codegen's struct field extraction, not a C-side bypass.

### EXP-027: Mini if-else result load type — use CUR_RET_TY
**Date:** 2026-03-31
**Milestone:** Stage 1 quality
**Hypothesis:** Same issue as codegen_match (EXP-020): if-else result load uses LAST_STORE_TY (from last arm, often i64 from null/default). Using CUR_RET_TY should fix the remaining 4 ptr + 25 nullable load mismatches.
**Change:** mini/codegen.fg: if-else merge result load uses CUR_RET_TY when available, LAST_STORE_TY as fallback.
**Score:** Stage 1: 38 → 9 (load_type_mismatch 29→0). Stage 2: unchanged (501)
**Result:** ✅ IMPROVEMENT — Stage 1 IR nearly perfect
**Kept/Reverted:** Kept
**Lesson:** Stage 1 IR quality doesn't automatically improve Stage 2 because Stage 2 quality depends on the self-hosted codegen's LOGIC (flag system), not on Stage 1's internal type correctness. The self-hosted codegen needs its own per-variable type table (like mini's VAR_TYPES).

### EXP-028: Per-variable type table (CG_VAR_TYPES) — proper implementation
**Date:** 2026-03-31
**Milestone:** M2 (call arg types) — foundational fix
**Hypothesis:** With Stage 1 IR at score 9 (0 load mismatches), List<string> operations should work correctly in Stage 1's runtime. Adding CG_VAR_TYPES: List<string> as the PRIMARY type source in emit_ident (replacing flag system) should fix the 143 call mismatches caused by type erasure. Previous attempt regressed because (a) old audit was broken, (b) Stage 1 had 52 load mismatches corrupting List operations.
**Change:** TBD — add CG_VAR_TYPES, populate in all CG_VAR_NAMES push sites, use as primary in emit_ident with detect_var_type pattern from mini.
**Score:** 501 → 1096 (REGRESSION: null_operands 0→30, load_type_mismatch 0→175)
**Result:** ❌ REGRESSION — same pattern as EXP-022
**Kept/Reverted:** REVERTED
**Lesson:** CG_VAR_TYPES stores the type from FLAGS at variable creation time. Flags are wrong for some variables. C-side caches compensate. Overriding C-side with wrong flag-derived types causes regression.

### EXP-029: CG_VAR_TYPES from alloca_ty (not flags) in define_var
**Date:** 2026-03-31
**Milestone:** M2
**Hypothesis:** EXP-028 failed because types came from flags (wrong). But define_var's alloca_ty is CORRECT (uses LLVMTypeOf fallback). Deriving the type string from alloca_ty (by comparing with CG_STR, CG_PTR, CG_I64) should give correct types. This is closer to what the mini does (VAR_TYPES = resolved alloca type, not flags).
**Change:** TBD
**Score:** 501 → 491 (-10, call_type_mismatch 143→133, no regressions)
**Result:** ✅ IMPROVEMENT — alloca-ty-derived types are safe as FALLBACK in fast path
**Kept/Reverted:** Kept
**Lesson:** Key difference from EXP-028 (which regressed): types derived from alloca_ty (correct, uses LLVMTypeOf) vs flags (wrong for some variables). Using as FALLBACK (only when all C-side checks default to i64) avoids overriding correct detection. This is the right approach — incremental, safe, no regressions.

### EXP-030: Annotation-driven define_var + emit_ident struct resolution
**Date:** 2026-03-31
**Milestone:** M2
**Hypothesis:** Using forge_var_type_get (source-level annotation) in BOTH define_var (to create correctly-typed allocas) and emit_ident (to load with correct types) should fix struct type erasure.
**Change:** define_var: if annotation available, resolve to LLVM type for alloca. emit_ident: annotation lookup for struct types before C-side checks.
**Score:** 491 → 1546 (define_var version) / 491 → 499 (emit_ident only, struct)
**Result:** ❌ REGRESSION — annotation creates struct-typed allocas but the STORED VALUE is still i64 (from flag-based emit_expr). Store i64 into %Token alloca → load %Token reads garbage.
**Kept/Reverted:** REVERTED
**Lesson:** The annotation can't be used in define_var until the VALUE also has the correct type.

### EXP-031: Guarded struct loads in emit_ident (forge_struct_var_get guard)
**Date:** 2026-03-31
**Milestone:** M2
**Hypothesis:** emit_ident's alloca cache path only loads ForgeString for kind==13 (struct). Other structs (%Token, %Expr, etc.) fall through to i64. Adding struct loads GUARDED by forge_struct_var_get(name) — only for explicitly registered struct variables — should be safe (unlike EXP-003's blanket approach).
**Change:** emit_ident kind==13 branch: if stored_type != CG_STR AND forge_struct_var_get confirms struct, use stored_type.
**Score:** 491 → 491 (guarded: no effect), 491 → 819 (primary: regression)
**Result:** ❌ With forge_struct_var_get guard: no effect (260 struct allocas not registered). With stored alloca type as primary: null_operands 0→30 (same EXP-003 pattern — some struct-typed allocas are used in contexts expecting i64/ForgeString).
**Kept/Reverted:** REVERTED (primary version)
**Lesson:** The alloca type is authoritative for LOADING, but some code paths use the loaded value in i64/ForgeString contexts (PHI nodes, conditional expressions). Using the alloca type as primary breaks these. The fix needs to propagate struct types through ALL downstream uses, not just the load. This is equivalent to a full type-flow analysis.

### EXP-032: Restore parser method call desugaring + remove debug traces
**Date:** 2026-04-01
**Milestone:** M2
**Hypothesis:** Commit 3f377bd removed parser-level method desugaring (obj.method(args) → Type__method(obj, args)), relying on codegen emit_method_or_ns_call. This crashed Stage 1 because the codegen path passes corrupted pointers (mini corruption). Restoring desugaring + removing debug traces that crashed emit_fn_body_from_source's own compilation should fix Stage 1.
**Change:** parser/expressions.fg: restored string method and impl method desugaring. functions/mod.fg: removed if-body debug trace that caused NullLit crash.
**Score:** CRASH → 143
**Result:** ✅ Stage 1 runs again (was completely broken)
**Kept/Reverted:** KEPT
**Lesson:** Parser desugaring is necessary because the mini compiler corrupts local pointer variables in the codegen's emit_method_or_ns_call path. Single-line if bodies with semicolons also crash when the debug functions (forge_vas_trace etc.) are called inside them.

### EXP-033: emit_ident uses forge_var_type_get (string-based) instead of get_allocated_type
**Date:** 2026-04-01
**Milestone:** M1
**Hypothesis:** get_allocated_type(cached_ptr) always returns kind=10 (struct) because the mini corrupts cached_ptr between forge_alloca_cache_get and the call. Using forge_var_type_get (string-based lookup, immune to pointer corruption) should fix load types.
**Change:** emit_ident: replaced get_allocated_type with forge_var_type_get string → resolve_type_to_llvm lookup
**Score:** 143 → 143 (safe types only: no change)
**Result:** ⚪ NO CHANGE — functionally equivalent to old approach for safe types
**Kept/Reverted:** KEPT (cleaner code, removes corrupted pointer paths)
**Lesson:** get_allocated_type returns kind=10 for ALL allocas due to mini pointer corruption. forge_alloca_cache_get_type also corrupted. String-based forge_var_type_get works and is immune to corruption, but functionally equivalent since forge_str_var_check/forge_ptr_var_check already covered the same cases. Kept for code clarity.

### EXP-034: Revert scan_mods to use index_of + investigate body re-parse
**Date:** 2026-04-01
**Milestone:** M5 (module resolution)
**Hypothesis:** scan_mods should use src.index_of("\nmod ") instead of find_nmod (which depends on undeclared forge_string_byte_at). The fn_store body IS correct (C-side trace confirmed). But the Stage 1 parser produces find_nmod calls from `src.index_of` body text.
**Change:** Reverted scan_mods to index_of. Removed find_nmod/find_byte. Rewrote find_byte as index_of-based.
**Score:** 143 → 143
**Result:** ⚪ NO CHANGE — parser desugaring works for other functions (14 forge_string_index_of calls exist) but NOT for scan_mods specifically. Root cause under investigation.
**Kept/Reverted:** KEPT (correct approach)
**Lesson:** fn_store body extraction IS correct (byte positions via token spans work). The bug is in the PARSER RE-PARSE during emit_fn_body_from_source — the desugaring doesn't fire for scan_mods despite identical code working for other functions. The body text IS `src.index_of("\nmod ")` but the output is `call @find_nmod`. This is either a parser state issue (stale globals) or the mini-compiled parser has a code path that skips desugaring for certain function bodies.

### EXP-035: Trace fn_store_get_name for ghost find_nmod
**Date:** 2026-04-01
**Milestone:** M5 (Stage 2 module resolution)
**Hypothesis:** `find_nmod` appears in Stage 2 output but is NOT in source or fn_store. The mini-compiled emit loop uses forge_fn_store_get_name (C-side) which should return correct names. If C-side returns correct names but the output has wrong function definitions, the corruption happens in the ForgeString return from C→Forge.
**Change:** Add C-side trace in forge_fn_store_get_name to print every name at emit time.
**Score:** N/A (diagnostic)
**Result:** C-side returns correct names (no find_nmod). Ghost function comes from mini corrupting ForgeString AFTER return from C. The string pointer in the ForgeString struct gets stale/reused memory that contains "find_nmod" from a previous allocation.

### EXP-036: C-side function name lookup (bypass ForgeString return)
**Date:** 2026-04-01
**Milestone:** M5 (Stage 2 module resolution)
**Hypothesis:** ForgeString return from C→Forge is corrupted by the mini. A C-side function that looks up the LLVM function by fn_store index (without returning a ForgeString to Forge) should work.
**Change:** Add forge_get_fn_val_by_idx(module, idx) that returns the LLVM function value directly.
**Score:** 143 → TBD
**Result:** TBD
**Lesson:** TBD

Also found: CG_LAST_STRUCT_TYPE was cleared by cg_reinit_types() before being captured by define_var. Fixed by saving before clear. Also found double-underscore vs single-underscore naming mismatch between self-hosted source and mini output (fixed: self-hosted now uses single underscore matching mini). The alloca type and the store value must match. Currently emit_expr produces i64 for struct expressions (because of flag system). Fix must be bottom-up: first fix emit_expr to produce correctly-typed values, THEN define_var can use the annotation type for the alloca. The annotation-only string/ptr types work (491 stable) because those were already handled by existing checks.
