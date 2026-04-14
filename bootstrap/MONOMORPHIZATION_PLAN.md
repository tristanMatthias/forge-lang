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

### 5. ~~Enum payloads use flat i64 buffers~~ DONE
**status:** done (commit 66a58175)

Enum payload writes use `ctx.store_field(val, ptr, field_ty)` with the
correct ValueType per field. Reads use `ctx.load_typed(field_ty, ptr, name)`.
Match binding allocas use `ctx.alloca_typed(field_ty, name)`.

The flat 8-byte-per-field buffer layout is preserved for ABI compatibility.
Per-variant LLVM struct types are declared but not yet used for GEP
(future optimization — would eliminate pointer arithmetic).
The `fill_enum_payload_typed` function is written and ready.

### 6. ~~Result slots use alloca i64~~ PARTIALLY DONE
**status:** partially done

`emit_if_expr` now uses phi nodes with typed values instead of
alloca i64 + cast. Match/when/block-as-value still use alloca i64
because their recursive arm emission can include early returns
(the arm has a terminator), which makes phi incoming edges invalid.
The alloca approach handles this naturally via `store_br_if_open`.
LLVM's mem2reg pass converts these to phis anyway.

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

### 10. ~~Comparison results are i64, not i1~~ DONE
**status:** done (commit f41a2186)

All comparisons (==, !=, <, <=, >, >=), float comparisons, string
comparisons, enum tag comparisons, `is` checks, and logical operators
now return EmitResult with `.Bool` type. Variables assigned from
comparisons get i1 allocas. Values are still i64 (zext'd) for
compatibility with result slots and C function calls.
