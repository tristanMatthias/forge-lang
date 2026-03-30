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
**Lesson:** What we learned
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
