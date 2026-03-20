# Self-Hosting Progress

**Status: 8% (3/37 files compile in Stage 2)**

> **ZERO LLVM verification errors** in self-hosted compiler IR!
> `if bool { mut = val }` pattern NOW WORKS in compiled binary
> Phase 1 scan: DONE (2s for all 37 files, 386 functions)
> Phase 2 compile: 3/37 files produce valid .o files (token.fg, ast.fg, types.fg)
> Current blocker: error.fg global list push crashes (inline emit issue)
> Current blocker: error.fg list global type detection fails because `check(TokenKind.Colon)` can't detect `:` for type annotations (Token text corrupted from list storage)
> AST-based codegen blocked by Token text corruption in List<Token>

Last updated: 2026-03-19

## Pipeline

```
Bootstrap (Rust) ──→ Stage 1 binary ──→ Stage 2 binary ──→ Stage 2' (fixed point)
       ✅                  ✅              IN PROGRESS           ❌
```

## Stage 2 File Compilation (3/37)

Phase 1 (scan all 37 files): **DONE** (2s)
Phase 2 (compile each file to .o):

| # | File | Status | Blocker |
|---|------|--------|---------|
| 0 | core/token.fg | ✅ | |
| 1 | core/ast.fg | ✅ | |
| 2 | core/types.fg | ✅ | |
| 3 | core/error.fg | ❌ CRASH | extractvalue on Severity enum in Diagnostic struct literal |
| 4 | core/registry.fg | ⏳ blocked | waiting on #3 |
| 5 | core/mod.fg | ⏳ blocked | waiting on #3 |
| 6 | lexer/mod.fg | ⏳ blocked | LLVM DAGTypeLegalizer crash (type mismatch in IR) |
| 7 | parser/expressions.fg | ⏳ blocked | |
| 8 | parser/mod.fg | ⏳ blocked | |
| 9 | checker/env.fg | ⏳ blocked | |
| 10 | checker/mod.fg | ⏳ blocked | |
| 11 | codegen/mod.fg | ⏳ blocked | |
| 12-35 | features/*.fg | ⏳ blocked | |
| 36 | main.fg | ⏳ blocked | |

Phase 3 (link all .o + runtime): ❌ not reached
Phase 4 (run Stage 2 binary): ❌ not reached

## Root Cause Blocking Most Files

**Bootstrap match destructuring of nested enums is broken.**

When the Rust bootstrap compiles `match stmt { .Expr(expr) -> { ... } }`, the extracted `expr` (a nested Expr enum inside Statement) has a corrupted variant tag. This means:

1. The AST-based codegen path (Option B) can't work — emit_expr receives garbage
2. The inline-emit path works around this by emitting LLVM IR during parsing (no extraction needed)
3. But inline emit has its own bugs (stale CG_LAST_VAL, etc.) that cause crashes in complex files

**Partially fixed:** Bootstrap `type_to_llvm_basic` now updates stale cached enum types.
The Expr type correctly shows 10 LLVM fields during extraction.

**Remaining issue:** The inline-emit crash in error.fg is NOT from the bootstrap match
extraction — it's from the self-hosted compiler's inline struct literal codegen. When
building `Diagnostic { ..., span: span, ... }`, the `span` parameter's LLVM type
doesn't match the Diagnostic's field type because the struct type deduplication changes
indices between scan and codegen phases.

## Completed Work

### Bootstrap Fixes
- [x] `&&`/`||` short-circuit evaluation (was evaluating both sides)
- [x] O2 optimization in write_object_file (was O0, making self-hosted binary 6000x slower)
- [x] LLVM data layout set from target machine (fixes ARM64 ABI for large struct returns)

### Self-Hosted Compiler Codegen
- [x] Match expression codegen (tag extraction, variant dispatch, field binding, phi merge)
- [x] Implicit function returns (call expressions as last statement)
- [x] Return inside if blocks (CG_HAS_LAST_VAL reset)
- [x] Inline call emission with CALL_DEPTH tracking
- [x] CG_LAST_VAL tracking in parse_postfix_expr
- [x] Stale value prevention in variable bindings
- [x] Nested struct member access (a.b.c)
- [x] Struct literal shorthand syntax ({ field } = { field: field })
- [x] List return type fix (resolve_type_to_llvm for "List")
- [x] Unit enum min 1 slot registration
- [x] render_diagnostic restored in error.fg

### Separate Compilation
- [x] Two-pass struct type materialization (opaque first, then bodies)
- [x] Struct type deduplication (scan phase registers duplicates)
- [x] Enum type cache cleared per module
- [x] Function declarations with correct param/return types
- [x] Brace-balancing scan (skip function body parsing during scan phase)

### Runtime Performance
- [x] Static ASCII char table in forge_string_char_at (no malloc per char)
- [x] forge_string_eq fast path for single-char comparisons
- [x] forge_string_concat fast path for empty strings
- [x] forge_string_byte_at added (int return, no allocation)
- [x] Lexer: eliminate O(n²) string_to_chars — use source[pos] directly

### LLVM Bindings
- [x] LLVMTypeOf wrapper
- [x] Null guards in build_extract_value, build_store, build_insert_value
- [x] Bounds check in build_insert_value
- [x] emit_object_file sets data layout from target machine

### Attempted but Reverted
- [x] AST-based codegen (Option B) — blocked by bootstrap match bug
- [x] Match arm body re-parsing via CSV — blocked by global persistence
- [x] Various CG_LAST_VAL persistence workarounds

## What Works (Programs compiled by self-hosted compiler)
- Fibonacci, factorial, FizzBuzz
- Enum match with field extraction (int, string fields)
- Struct construction, field access, nested access (a.b.c)
- List<Struct> operations
- Multi-file separate compilation
- Mini lexer (enums + structs + match + lists + function constructors)
- Token type with 36+ enum variants

## Known Limitations
- Match arms returning bool produce 0 (BoolLit value corrupted in List<MatchArm>)
- Tokens with unique Span values per element get corrupted in some cases
- Large file lexing is slow (~10s for 113KB) even with O2

## ACTUAL Root Cause (Discovered 2026-03-19)

**The bootstrap's match codegen for large (100+) variant enums is broken.**

TokenKind has ~120 variants. When the bootstrap compiles `kind_to_key(kind)` or
`check(TokenKind.Gt)`, the match on TokenKind doesn't correctly find high variant
indices. All variants after some threshold (~90?) fall through to the default arm.

This breaks:
- `parse_type_args`: can't find `>` to close `List<int>` → consumes past `=` and `[]`
- `check(TokenKind.LBracket)`: fails → list globals not detected
- `kind_to_key`: returns `""` for many token kinds → string comparisons fail

**Impact**: Type annotations like `List<int>` aren't parsed correctly. Global
variables with list types aren't detected. The parser overconsumes tokens.
This cascades into ALL compilation of files that use list/map globals.

**Fix needed**: In the bootstrap's pattern matching codegen, the variant index
comparison for large enums must work for ALL variant indices, not just low ones.
The issue is likely in how the i8 tag is compared — the tag value might overflow
or the comparison constants might be truncated.

## Next Steps (Priority Order)
1. **Fix bootstrap match for large enums** — THE critical blocker
2. **Fix error.fg crash** — Severity enum + Diagnostic struct literal
3. **Get remaining 34 files compiling** — most share the same root causes
4. **Link Stage 2 binary** — link all .o files + runtime
5. **Test Stage 2** — run the Stage 2 binary on simple programs
6. **Fixed point** — Stage 2 compiles itself to identical Stage 2'
