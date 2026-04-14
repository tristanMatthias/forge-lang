# Type System Maturity Plan

Tracks remaining work to eliminate i64 hacks and build a proper type foundation.

---

## Done

### 1. Real LLVM types for function signatures
**status:** done (commit c46f91a1)

Function params and returns use real types: ptr for strings/structs/enums,
i64 for int. Typed allocas, typed loads, auto-coercing calls, void safety.

### 2. Bool → i1, Float → double
**status:** done (commit c8b5bf50)

Bool params/returns/allocas use i1. Float uses double. Struct fields
use real types. forge_llvm_cast_to_type handles all type combinations.

### 3. Type-safe store API
**status:** done (commit 70caa9fb)

ctx.store() auto-casts for alloca destinations. ctx.store_field() requires
explicit field type for struct field GEPs. Prevents the class of bug where
storing i64 into i1 corrupts adjacent struct fields.

### 4. Per-function LLVM verification
**status:** done (commit pending)

forge_llvm_verify_function runs after every function body. Module-level
verification is now mandatory (was advisory). Type mismatches caught at
the emitting function, not as cryptic errors later.

---

## Remaining

### 5. Enum payloads use flat i64 buffers
**type:** architecture debt
**priority:** high
**status:** Phase A done (type declarations), Phase B blocked

Phase A: Per-variant payload struct types are declared in LLVM
(`%Enum__Variant = type { field_types... }`). Done.

Phase B (blocked): Using typed GEP instead of pointer arithmetic.
The arity-aware resolution is now fixed (commit 11ae5063), but the
typed GEP write path is incompatible with the flat-buffer read path.
Both must change simultaneously: `fill_enum_payload_typed` for writes
AND `load_payload_field` for reads. The read path needs the variant
name + field types threaded through 4+ call sites in match codegen.
The `fill_enum_payload_typed` function is written and ready.

### 6. Result slots use alloca i64
**type:** architecture debt
**priority:** medium

If/match/when/block expressions use `alloca i64` for result slots, then
cast values before storing via `store_br_if_open`. The result type isn't
known until after the first branch is emitted.

**Proper fix:** Either:
- Use phi nodes (standard SSA, no alloca needed)
- Emit the first branch, determine type, create typed alloca

### 7. ~~Global variables use i64~~ DONE
**status:** done (commit 2a3d6585)

Globals now use `llvm_type_for_full` with their declared ValueType.

### 8. ~~Unused C-side functions~~ MOSTLY DONE
**status:** `to_f64` free function replaced with `ctx.to_f64()`.
`forge_llvm_is_void_value` still declared but unused (harmless).
`forge_llvm_cast_to_type` is used from Forge (not C-internal only).

### 9. Types are strings in the AST
**type:** architecture (see TODO.md #2)
**priority:** critical

Types stored as `ty: string` throughout ParamList, FieldList, Function.
`translate_param_type` parses strings like `"List(int)"` with starts_with.
Blocks proper generics, type inference, and compile-time type checking.

### 10. Comparison results are i64, not i1
**type:** architecture debt
**priority:** medium

`icmp_eq`/`icmp_ne` produce i1 then immediately `zext` to i64. This means
bool variables store i64 values (0 or 1) in i1 allocas — the smart store
handles it via trunc, but it's an unnecessary round-trip.

**Proper fix:** Comparisons return i1 with type `.Bool`. The value
pipeline handles i1 natively. Only convert to i64 when needed for
arithmetic.
