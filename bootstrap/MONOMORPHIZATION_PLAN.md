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

Enum payloads are heap-allocated as `malloc(field_count * 8)` — a flat
array of 8-byte slots. Stores use raw memory writes (`inttoptr` pointer
arithmetic), loads use `load_i64`. This means:

- Bool/float enum fields are cast to i64 before storing (wrong — undoes
  the real type work)
- No type safety for payload field access
- Layout wastes memory (i1 field takes 8 bytes)

**Proper fix:** Each variant gets a typed LLVM struct:
```
%Option.Some = type { ptr }       // Some(value: string)
%Result.Ok = type { i64 }         // Ok(value: int)  
%Result.Err = type { ptr }        // Err(error: string)
```

Stores use `ctx.store_field(val, gep, field_ty)`. Loads use
`ctx.load_typed(field_ty, gep, name)`. No pointer arithmetic.

### 6. Result slots use alloca i64
**type:** architecture debt
**priority:** medium

If/match/when/block expressions use `alloca i64` for result slots, then
cast values before storing via `store_br_if_open`. The result type isn't
known until after the first branch is emitted.

**Proper fix:** Either:
- Use phi nodes (standard SSA, no alloca needed)
- Emit the first branch, determine type, create typed alloca

### 7. Global variables use i64
**type:** architecture debt
**priority:** low

`declare_globals` uses `forge_llvm_add_global(m, i64t, name)` for all
globals regardless of their declared type.

**Proper fix:** Use `llvm_type_for_full` with the global's ValueType.

### 8. Unused C-side functions
**type:** cleanup
**priority:** low

- `forge_llvm_is_void_value` — declared but unused (void handled at call level)
- `forge_llvm_cast_to_type` — exposed as extern but only used C-internally
- Old free functions `to_f64`, `f64_to_i64` — replaced by Ctx methods

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
