# Self-Hosting Status & Next Steps (2026-04-05)

## Current State

- **Stage 2 IR:** 388 functions, ~40K lines, score 226/1000
- **Stage 2 binary:** Compiles, links, runs. Reads 39 files. Finds 18 functions (should be ~400).
- **Build:** `make stage1-rust` → `./build/stage1_rust build packages/forgec/src/main.fg` → `output.ll`

## The Blocker: Why Stage 2 only finds 18 functions

`Lexer_tokenize` produces empty IR (`ret zeroinitializer`). Without the tokenizer, the scanner can't tokenize source files, the parser gets no tokens, and no functions are found.

`Lexer_tokenize`'s body has 4 statements. `emit_block` iterates them and calls `emit_statement` for each. But ALL 4 statements dispatch as `.Expr` (tag 0) instead of their actual types (`.Let`=3, `.Expr`=0, `.While`=6, `.Expr`=0).

## The Bug Chain (in order of causation)

### Bug 1: `emit_statement` match uses wrong tags
**Symptom:** ALL Statement values match `.Expr` (tag 0), even `.Let` and `.While`.
**Location:** `codegen/mod.fg` line ~2615, the `match stmt { ... }` compiled by the self-hosted codegen.
**Mechanism:** The match handler calls `match_enum_tag("Let")` at parse time to get the tag for comparison. This returns 0 instead of 3.

### Bug 2: `match_enum_tag("Let")` returns wrong tag (0 instead of 3)
**Symptom:** Unqualified name "Let" resolves to VarKind.Let (tag=0) instead of Statement.Let (tag=3).
**Location:** `forge_enum_variant_tag_get` in `runtime.c` — does reverse search, last registered wins.
**Root cause:** VarKind is defined in `features/variables/mod.fg` which is scanned AFTER `core/ast.fg`. VarKind.Let (count=177) shadows Statement.Let (count=139).
**Fix available:** Use QUALIFIED name "Statement.Let" → tag 3. The qualified lookup works.

### Bug 3: Qualified name not used because `cg_var_enum_type("stmt")` returns ""
**Symptom:** `enum_type` is empty, so `qname = ".Let"` instead of `"Statement.Let"`.
**Location:** `parse_match_expr` in `parser/expressions.fg` line ~620.
**Mechanism:** `cg_var_enum_type(scrutinee_var)` calls `forge_alloca_cache_get_var_type("stmt")`. Should return "Statement". But returns "" because the ForgeString parameter loses its length.

### Bug 4: ForgeString parameters lose length in self-hosted compiled functions
**Symptom:** ForgeString `{ptr, i64}` stored in i64 alloca (8 bytes). Length field (second i64) is lost. All strings appear as length=0.
**Location:** `emit_fn_body_from_source` in `features/functions/mod.fg` line ~442, parameter alloca creation.
**Root cause:** Parameter allocas use `resolve_type_to_llvm(param_type_name)`. If `param_type_name` is "string", this returns `CG_STR` ({ptr, i64}). BUT `param_type_name` itself is a ForgeString loaded from C-side (`forge_param_type_get`), and `resolve_type_to_llvm` is self-hosted compiled code that receives it via a ForgeString parameter — which also has the same truncation.

### Bug 5: `resolve_type_to_llvm` receives truncated ForgeString
**Symptom:** The function parameter `type_name: string` gets stored in an i64 alloca. `type_name == "string"` comparison fails (length=0).
**Location:** `codegen/mod.fg` line ~451, `resolve_type_to_llvm` function.
**Root cause:** `resolve_type_to_llvm` IS a self-hosted compiled function. Its parameter alloca is created by `emit_fn_body_from_source`. The alloca type comes from `resolve_type_to_llvm(param_type_name)` — circular dependency.

## The Root Root Cause

**Function parameters in `emit_fn_body_from_source` get i64 allocas regardless of their actual type.** This is because:

1. `emit_fn_body_from_source` at line ~442 calls `resolve_type_to_llvm(param_type_name)` to get the alloca type
2. `param_type_name` comes from `forge_param_type_get(idx)` (C-side, returns correct ForgeString)
3. BUT `resolve_type_to_llvm` is itself a self-hosted function, and it receives `param_type_name` as a parameter
4. That parameter's alloca is ALSO created by step 1 — so the first function compiled this way gets an i64 alloca for its string params
5. From then on, ALL self-hosted functions have broken string parameters

## The Fix

**In `emit_fn_body_from_source`, use `llvm.type_of(param_val)` for parameter alloca types instead of `resolve_type_to_llvm(param_type_name)`.**

The function parameter LLVM value (`llvm.get_param(fn_val, pi)`) has the correct LLVM type — it was declared by `declare_all_fns` with the proper type. `llvm.type_of(param_val)` returns this type. Use it for the alloca.

```forge
// CURRENT (broken):
mut p_ty = resolve_type_to_llvm(param_type_name)
if p_ty == null { p_ty = CG_I64 }
let alloca = llvm.build_alloca(CG_B, p_ty, pname)

// FIX:
let p_ty = llvm.type_of(param_val)
let alloca = llvm.build_alloca(CG_B, p_ty, pname)
```

This one change fixes the ENTIRE chain:
- Parameter allocas match the declared type (ForgeString gets 16-byte alloca)
- `resolve_type_to_llvm` receives ForgeString with correct length
- `cg_var_enum_type("stmt")` returns "Statement"
- `match_enum_tag("Statement.Let")` returns 3
- `emit_statement` dispatches correctly
- `Lexer_tokenize` body produces code
- Scanner finds all ~400 functions
- Stage 2 compiles itself

## Already Fixed (don't re-break)

These fixes are in place and working:

1. **`forge_build_cond_br_trunc`** — C-side conditional branch with auto-trunc to i1
2. **Parser kind_id dispatch** — if(25), while(30), null(8), match(27)
3. **ForgeString ABI** — dlsym-based `_s` wrappers for all `forge_llvm_*` functions
4. **Enum variant parsing** — `parse_enum_variants` registers tags + field types
5. **C-side enum tag registry** — `forge_enum_variant_tag_set/get` with suffix matching
6. **Match arm bindings** — C-side `forge_match_binding_*` integer-indexed storage
7. **Nullable return types** — impl methods append `?`, `declare_all_fns` creates `{i8, T}` struct
8. **ForceUnwrap AST variant** — `Expr.ForceUnwrap(operand, span)` with `extractvalue` codegen
9. **`define_var_typed` uses `LLVMTypeOf`** — struct values get struct-sized allocas
10. **List push uses `LLVMTypeOf`** — element size from LLVM, not string metadata
11. **List index defaults to `CG_STR`** — most Forge lists hold ForgeStrings
12. **Two-pass type checker** — handles forward references (Block → List<Statement>)
13. **PHI node fix** — only include arms that branch to merge block
14. **Struct field type lookup** — `expr_type_name` for MemberAccess reads field types from registry
15. **Block/Token/NodeRef LLVM types** — registered with proper field layouts in `cg_register_core_types`
16. **Statement/Expr enum types** — registered with correct slot counts (13 max payload with boxing)

## Key Architectural Decisions

- **LLVM is the source of truth for types.** Use `llvm.type_of(value)` and `forge_value_type_kind(value)`, never string-based guessing.
- **C-side registries bypass ForgeString corruption.** For data that must survive self-hosted string operations, store in C-side arrays indexed by integer (e.g., `forge_match_binding_get(idx)`, `forge_param_name_get(idx)`).
- **No hardcoded type tables.** Field types come from enum variant parsing at scan time, stored via `forge_enum_variant_fields_set`.
- **Qualified enum names resolve collisions.** Always try `"Statement.Let"` before bare `"Let"`.

## Build & Test Commands

```bash
cd forge/

# Build Stage 1 (Rust compiler → Stage 1 binary):
make stage1-rust

# Stage 1 compiles self-hosted source → Stage 2 IR:
./build/stage1_rust build packages/forgec/src/main.fg

# Audit Stage 2 IR quality:
bash scripts/audit_stage2.sh output.ll

# Compile + link Stage 2 binary:
/opt/homebrew/opt/llvm@18/bin/llc -O2 -filetype=obj output.ll -o /tmp/stage2.o
cc -o /tmp/stage2 /tmp/stage2.o build/runtime.o -lm -Wl,-stack_size,0x10000000 \
  packages/std-llvm/target/release/libforge_llvm.a \
  -L/opt/homebrew/Cellar/llvm@18/18.1.8/lib -lLLVM-18 -lstdc++ -lz -lcurses

# Test Stage 2:
/tmp/stage2 build packages/forgec/src/main.fg
```

---

## Future: TypedValue Refactor

Once self-hosting works, the codegen should be refactored so every expression emission returns both a value AND its type:

```forge
type TypedValue = {
    val: ptr,          // LLVM value
    ty: ptr,           // LLVM type (CG_I64, CG_STR, %Token, etc.)
    type_name: string, // Forge type name ("int", "string", "Token", etc.)
}
```

This eliminates ALL global type flags, CSV caches, and guessing. The type flows through the expression tree.

| Old (flags)                              | New (TypedValue)                    |
|------------------------------------------|-------------------------------------|
| `CG_LAST_IS_STR = 1`                    | `result.type_name == "string"`      |
| `CG_LAST_IS_PTR = 1`                    | `result.ty == CG_PTR`              |
| `CG_LAST_STRUCT_TYPE = "Token"`         | `result.type_name == "Token"`       |

Key principle: **The type flows DOWN from the declaration, not UP from runtime flags.**

```
Declaration: let x: Token = parser.peek()
                 ↓
Type check:  x has type Token
                 ↓
Codegen:     alloca %Token; store %Token result; load %Token
```

Never guess. Never use flags. Read the type from the source.

---

## File Map

| File | Role |
|------|------|
| `packages/forgec/src/codegen/mod.fg` | Self-hosted codegen (~130K bytes) |
| `packages/forgec/src/features/functions/mod.fg` | Function declaration + body emission |
| `packages/forgec/src/features/impl_methods/mod.fg` | Impl method parsing |
| `packages/forgec/src/parser/mod.fg` | Parser with kind_id dispatch |
| `packages/forgec/src/parser/expressions.fg` | Expression parser + match_enum_tag |
| `packages/forgec/src/core/ast.fg` | AST types (Expr, Statement, Block) |
| `stdlib/runtime.c` | C runtime + all C-side registries |
| `packages/forgec-rust/` | Rust compiler (compiles Forge source) |
| `packages/std-llvm/src/package.fg` | LLVM C API Forge wrappers (_s suffix) |
| `scripts/audit_stage2.sh` | Stage 2 IR quality audit |
| `scripts/diagnose.sh` | Comprehensive diagnostic |
