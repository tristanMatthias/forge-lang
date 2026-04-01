# Codegen Rewrite Plan (v2)

**Decision:** Clean rewrite of `codegen/mod.fg`. The incremental approach failed — 50 global flags, 15 CSV caches, and CG_ACTIVE entanglement make every fix regress something else. Score stuck at 460.

**What stays:** Mini compiler, parser, checker, AST, type system, LLVM wrappers, runtime.c, feature registration system.

**What gets rewritten:** `codegen/mod.fg` (~3700 lines → ~1500-2000 lines), emit handlers in features.

---

## Core Design: TypedValue

Every expression emission returns both a value AND its type:

```forge
type TypedValue = {
    val: ptr,          // LLVM value
    ty: ptr,           // LLVM type (CG_I64, CG_STR, %Token, etc.)
    type_name: string, // Forge type name ("int", "string", "Token", etc.)
}
```

No global flags. No guessing. The type flows through the expression tree.

### How this replaces flags

| Old (flags)                              | New (TypedValue)                    |
|------------------------------------------|-------------------------------------|
| `CG_LAST_IS_STR = 1`                    | `result.type_name == "string"`      |
| `CG_LAST_IS_PTR = 1`                    | `result.ty == CG_PTR`              |
| `CG_LAST_STRUCT_TYPE = "Token"`         | `result.type_name == "Token"`       |
| `CG_LAST_IS_LIST = 1`                   | `result.type_name.startsWith("List")` |
| `CG_LAST_IS_MAP = 1`                    | `result.type_name == "Map"`         |
| `CG_LAST_ENUM_TYPE = "BinOp"`           | `result.type_name == "BinOp"`       |
| `CG_LAST_IS_NULLABLE = 1`              | `result.type_name.endsWith("?")`    |

### How emit functions change

```forge
// OLD: returns ptr, sets global flags as side effect
fn emit_expr(self, expr: Expr) -> ptr

// NEW: returns TypedValue, no side effects
fn emit_expr(self, expr: Expr) -> TypedValue
```

### How define_var changes

```forge
// OLD: reads global flags to determine alloca type
fn define_var(self, name: string, ty: Type, value: ptr)

// NEW: reads TypedValue to determine alloca type
fn define_var(self, name: string, tv: TypedValue)
    // alloca type = tv.ty (always matches the value)
    // no flag guessing needed
```

### How emit_ident changes

```forge
// OLD: checks 5 C-side caches + stored alloca type + CSV strings
fn emit_ident(self, name: string) -> ptr

// NEW: loads with stored alloca type (set by define_var)
fn emit_ident(self, name: string) -> TypedValue
    // alloca type was set correctly by define_var (from TypedValue.ty)
    // load type = alloca type (always matches)
    // return TypedValue with the loaded value + its type
```

---

## Globals to Remove

These ~50 globals become unnecessary with TypedValue:

### Type flag globals (replaced by TypedValue.type_name)
- `CG_LAST_IS_STR`, `CG_LAST_IS_MAP`, `CG_LAST_IS_LIST`, `CG_LAST_IS_PTR`
- `CG_LAST_IS_NULLABLE`, `CG_LAST_STRUCT_TYPE`, `CG_LAST_ENUM_TYPE`
- `CG_LAST_LIST_ELEM_TYPE`, `CG_LAST_LIST_ELEM_IS_STR`
- `CG_LAST_VAR_PTR`, `CG_LAST_VAR_ALLOCA_TYPE`
- `CG_HAS_LAST_VAL`, `CG_LAST_VAL`
- `CG_IS_MAP_INDEX`, `CG_MAP_INDEX_OBJ`, `CG_MAP_INDEX_KEY`

### Variable tracking globals (replaced by alloca cache type)
- `CG_VAR_IS_STR`, `CG_VAR_IS_MAP`, `CG_VAR_TYPES`
- `CG_STR_VAR_NAMES`, `CG_MAP_VAR_NAMES`
- `CG_NULLABLE_VAR_NAMES`, `CG_NULLABLE_VAR_INNER`
- `CG_STRUCT_VAR_NAMES`, `CG_STRUCT_VAR_TYPES`, `CG_STRUCT_VAR_FIELDS`, `CG_STRUCT_VAR_CSV`

### CSV workaround strings (replaced by TypedValue)
- `CG_STR_LOCALS_CSV`, `CG_STR_GLOBALS_CSV`
- `CG_LIST_VAR_CSV`, `CG_STR_LIST_VAR_CSV`, `CG_LIST_ELEM_TYPE_CSV`
- `CG_ENUM_VAR_CSV`, `CG_ENUM_TYPE_CSV`
- `CG_GLOBAL_CSV`
- `VAR_LIST_INIT_CSV`

### C-side caches (replaced by alloca cache type field)
- `forge_str_var_add/check` → alloca type == CG_STR
- `forge_ptr_var_add/check` → alloca type == CG_PTR
- `forge_list_var_add/check` → alloca type == CG_STR + elem type tracked
- `forge_struct_var_add/get` → alloca type == %StructType

### CG_ACTIVE flag
- `CG_ACTIVE` → removed entirely. Parser ALWAYS builds AST. Codegen ALWAYS walks AST.

---

## Implementation Phases

### Phase 1: TypedValue type + helper functions
**Files:** `codegen/mod.fg`

Add TypedValue struct. Add helpers:
- `tv_int(val)` → TypedValue with ty=CG_I64
- `tv_str(val)` → TypedValue with ty=CG_STR
- `tv_ptr(val)` → TypedValue with ty=CG_PTR
- `tv_typed(val, ty, name)` → TypedValue with custom type
- `tv_is_str(tv)`, `tv_is_ptr(tv)`, `tv_is_list(tv)`, etc.

No behavior change. Just adds the new type alongside existing code.

**Risk:** Zero. Purely additive.

### Phase 2: emit_expr returns TypedValue
**Files:** `codegen/mod.fg`

Change `emit_expr` signature to return `TypedValue`. Update the match arms:
- `.IntLit` → `tv_int(const_int(...))`
- `.StringLit` → `tv_str(emit_string(...))`
- `.BoolLit` → `tv_int(const_int(...))`
- `.Ident` → `emit_ident(name)` (also returns TypedValue)
- `.Binary` → `emit_binary(...)` (returns TypedValue based on operand types)
- `.Call` → `emit_call(...)` (returns TypedValue from function return type)
- `.MemberAccess` → `emit_member_access(...)` (returns TypedValue from field type)

Each sub-function is updated one at a time. After each, test with audit.

**Compatibility:** Callers of `emit_expr` that only need the value use `emit_expr(e).val`. This makes the migration gradual.

**Risk:** Medium. Each handler must produce the correct TypedValue. But since we're using LLVMTypeOf(value) for the type, it's always correct.

### Phase 3: define_var uses TypedValue
**Files:** `codegen/mod.fg`

Change `define_var` to accept `TypedValue` instead of flags:
```forge
fn define_var(self, name: string, tv: TypedValue)
    let alloca = build_alloca(tv.ty, name)  // type from TypedValue
    build_store(tv.val, alloca)             // value matches type
    // Store tv.ty in alloca cache → emit_ident reads it back
```

No flags needed. The alloca type IS the value type.

**Risk:** Medium. The `.Let` handler in emit_statement needs updating.

### Phase 4: emit_ident uses stored alloca type
**Files:** `codegen/mod.fg`

`emit_ident` reads the stored alloca type (set by define_var) and loads with it:
```forge
fn emit_ident(self, name: string) -> TypedValue
    let alloca = cache_get(name)
    let ty = cache_get_type(name)
    let val = build_load(ty, alloca)
    return TypedValue { val, ty, type_name_from_ty(ty) }
```

No flags, no CSV checks, no C-side caches. Just: read the type that define_var stored.

**Risk:** Medium. Must handle globals (different storage path) and params.

### Phase 5: Remove CG_ACTIVE from parser
**Files:** `parser/expressions.fg`, `parser/mod.fg`, features

Remove ALL `if CG_ACTIVE` blocks from the parser. The parser ALWAYS builds AST. No inline IR emission during parsing.

This is possible because emit_statement/emit_expr now handle all cases correctly (Phase 2-4).

**Risk:** HIGH but correctness is guaranteed by Phase 2-4.

### Phase 6: Remove flag globals and C-side caches
**Files:** `codegen/mod.fg`, `stdlib/runtime.c`

Systematically remove each global listed above. For each removal:
1. Delete the global declaration
2. Fix all compilation errors (replace with TypedValue field access)
3. Audit
4. Commit

**Risk:** Medium per-global, but there are ~50 of them.

### Phase 7: Remove emit_fn_body_from_source workarounds
**Files:** `features/functions/mod.fg`

With CG_ACTIVE removed and TypedValue in place, `emit_fn_body_from_source` simplifies to:
```forge
parse body → emit_block(body)
```

No more statement-at-a-time loop. No forge_let_needs_alloca. No per-kind_id branching.

**Risk:** Low after Phases 1-6.

---

## What Doesn't Change

- **Mini compiler** (`mini/codegen.fg`, `mini/state.fg`) — untouched
- **Parser** (`parser/mod.fg`, `parser/expressions.fg`) — CG_ACTIVE blocks removed, but parsing logic stays
- **Type checker** (`checker/mod.fg`) — untouched (future: integrate more deeply)
- **AST** (`core/ast.fg`) — untouched
- **Type system** (`core/types.fg`) — untouched
- **LLVM wrappers** (`std-llvm`) — untouched
- **Runtime** (`stdlib/runtime.c`) — C-side type caches removed in Phase 6, but core runtime stays
- **Feature registration** (`core/registry.fg`) — untouched
- **Build pipeline** (`main.fg`) — minimal changes (remove CG_ACTIVE toggling)

## Success Criteria

- Score < 100 (from current 460)
- Zero CG_ type flag globals
- Zero CSV string workarounds
- Zero CG_ACTIVE checks in parser
- Stage 2 compiles hello world
- Codegen under 2000 lines (from 3700)
- Every emit function returns TypedValue

## Key Principle

**The type flows DOWN from the declaration, not UP from runtime flags.**

```
Declaration: let x: Token = parser.peek()
                 ↓
Type check:  x has type Token
                 ↓
Codegen:     alloca %Token; store %Token result; load %Token
```

Never guess. Never use flags. Read the type from the source.
