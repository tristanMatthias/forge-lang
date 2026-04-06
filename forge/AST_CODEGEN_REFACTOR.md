# Self-Hosting Status & Next Steps (2026-04-05)

## Current State

- **Stage 2 IR:** 388 functions, ~40K lines, score 135/1000, **0 empty functions**
- **Stage 2 binary:** Compiles, links, runs. Reads 39 files. Resolves modules. Creates lexer. Tokenizes. **Crashes in `forge_string_compare` inside `Lexer_next_token`.**
- **Build:** `make stage1-rust` → `./build/stage1_rust build packages/forgec/src/main.fg` → `output.ll`
- **Fixes applied this session:**
  1. Param alloca uses `llvm.type_of(param_val)` — score 226→135
  2. Nullable `return null` convention fixed (`maybe_wrap_nullable`)
  3. Expression parser kind_id mismatch fixed (LParen 104→100, LBracket 126→104)

## The Blocker: Stage 2 crashes in Lexer_next_token

Stage 2 now gets much further: reads all files, resolves modules, creates a lexer, calls `Lexer_tokenize`, enters the while loop, calls `Lexer_next_token`, then crashes in `forge_string_compare`.

**Backtrace:**
```
forge_string_compare + 592
Lexer_next_token + 152
Lexer_tokenize + 76
scan_one_file + 116
```

### Previous Blocker (FIXED): All Statement tags were 0
`Lexer_tokenize` had empty IR because `parse_expr` couldn't parse `[]` (list literal). The expression parser used kind_id 126 for LBracket but the tokenizer uses 104. Fix: corrected kind_id constants in `parser/expressions.fg`.

## Bug Chain 0: Stage 2 crashes in forge_string_compare (ACTIVE)

**Symptom:** Stage 2 crashes with SIGSEGV in `forge_string_compare` called from `Lexer_next_token`.
**Location:** `Lexer_next_token` compares the current character against keyword strings.
**Likely cause:** The character comparison loads a ForgeString from `self.peek_ch()` or similar, but the ForgeString pointer or length is corrupt in the Stage 2 compiled code.
**Investigation needed:** Check `Lexer_next_token` IR in output.ll — does it load ForgeString correctly? Does the char comparison use the right type?

## Bug Chain 1: ALL Statement tags were 0 (FIXED)

### Key Discovery: Statement is 112 bytes, NOT 16 bytes

**CRITICAL:** The Rust compiler represents Statement as `{i8, i64×13}` = 112 bytes, NOT `{i8, ptr}` = 16 bytes. Earlier investigation used 16-byte stride which gave garbled data. With correct 112-byte stride, the tag at byte 0 IS genuinely 0 for all statements.

```
Rust compiler actual types:
  %Statement    = anonymous { i8, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64 } = 112 bytes
  %Token        = { {i8, i64×6}, %Span, %ForgeString, i64 } = 112 bytes (SAME size!)
  %Nullable_Statement = { i8, Statement } = 120 bytes
  %Block        = { {ptr, i64}, %Span }
```

### Bug 1A: `parse_statement` returns Statements with tag=0 for ALL body statements
**Symptom:** Every function body parsed by Stage 1 has ALL statements with tag=0 (`.Expr`). `Lexer_tokenize` has 4 statements: should be Let, Expr, While, Expr. All are tag=0.
**Evidence:** `forge_dump_stmt_list` with 112-byte stride:
```
stmt[0] tag=0 first_i64=0x3001e2840
stmt[1] tag=0 first_i64=0x3001e2920
stmt[2] tag=0 first_i64=0x3001e2a00
stmt[3] tag=0 first_i64=0x3001e2a70
```
**Impact:** `emit_statement` match dispatch treats ALL statements as `.Expr` → function bodies produce wrong/empty code → `Lexer_tokenize` body is empty → tokenizer doesn't work → scanner finds only 18 functions.

### Bug 1B: Suspected cause — `tok.kind_id` reads 0 from body tokens
**Hypothesis:** `parse_statement` dispatches on `tok.kind_id`. If kind_id is 0 for all body tokens, all statements fall through to the expression parser fallback, which creates `Statement.Expr(...)` with tag=0.
**Investigation needed:** Check if `Parser.peek()` correctly loads Token structs from the body token list. The Token stride is 112 bytes; the kind_id field is at offset 104. If the list indexing uses wrong stride, kind_id reads garbage.

### Bug 1C: Rust compiler nullable wrapping may be inverted
**Evidence:** In `parse_statement`'s `return null` path (when `is_at_end()`):
```llvm
store i8 1, ptr %tag_ptr   ; nullable tag = 1 (but should be 0 for null!)
; ... zeroinitialize inner Statement
```
The nullable convention uses 0=null, !=0=has_value. But `return null` sets tag to 1 (has value) and zeroes the inner Statement. This creates a "valid" Statement with tag=0 (`.Expr`).
**Impact:** May cause null returns to be treated as valid Expr statements.

### Bug 1D: Some Statement pushes DO have correct tags
**Evidence:** Overall push statistics show tags 3(Let)=1631, 5(Match)=4135, 2(Return)=4834, 10(Feature)=1173 occurring. So `parse_statement` DOES create correct tags for SOME code paths. The bug is specific to certain contexts (body parsing? re-tokenized source?).

## Bug Chain 2: ForgeString parameter alloca size (FIXED)

### Bug 2A: `emit_fn_body_from_source` used `resolve_type_to_llvm` for param allocas
**Status:** FIXED — now uses `llvm.type_of(param_val)`.
**Impact:** Score dropped 226→135.
**What it fixed:** Stage 2 IR now has correct `%ForgeString` allocas for function parameters. Stage 2 code can correctly handle string operations.

### Bug 2B: `cg_var_enum_type` returns "" for nullable types
**Status:** Partial — stores "Statement?" (with ?) for nullable parameters. `forge_enum_type_exists("Statement?")` returns false.
**Fix needed:** Strip trailing "?" before checking `forge_enum_type_exists`.

## Bug Chain 3: Qualified enum tag lookup (WORKING)

### Bug 3A: Tag lookup with qualified names IS correct
**Status:** VERIFIED — all Statement variants resolve to correct tags.
```
Statement.Expr=0, Statement.Assign=1, Statement.Return=2, Statement.Let=3,
Statement.If=4, Statement.Match=5, Statement.While=6, Statement.For=7,
Statement.Break=8, Statement.Continue=9, Statement.Feature=10
```

### Bug 3B: Tag constants in Stage 2 IR ARE correct
**Status:** VERIFIED — `Codegen_emit_statement` compares against 0,1,2,3,4,5,6.
**But:** This doesn't help if Statement tag byte is always 0 (Bug Chain 1).

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
bash scripts/diagnose.sh --score output.ll

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
| `scripts/diagnose.sh` | All diagnostics (--score, --stage2, --kind-ids) |
| `scripts/diagnose.sh` | Comprehensive diagnostic |
