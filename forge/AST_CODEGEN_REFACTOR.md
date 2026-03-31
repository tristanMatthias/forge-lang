# AST Codegen Refactor Plan

**Goal:** Replace source-text re-parsing in codegen with typed AST walking.

**Why:** The self-hosted codegen re-parses function bodies from source text and guesses types from runtime flags. This causes 260 struct type mismatches, 133 call type mismatches, and blocks self-hosting progress. Real compilers (Rust, Go, Swift) walk a typed AST — the type checker annotates every node, and codegen reads those annotations.

---

## Current Architecture (Broken)

Three parallel codegen paths exist:

1. **`emit_fn_body_from_source`** (functions/mod.fg:460) — PRIMARY path. Re-lexes/re-parses body source text from C-side string store. 300+ lines of workarounds for enum payload corruption.

2. **`emit_all_fn_bodies`** (functions/mod.fg:897) — ALTERNATIVE path. Also re-parses, but calls `emit_block()` directly. Proves the target approach works.

3. **`emit_fn_body`** (functions/mod.fg:1196) — THIRD path via feature dispatch. Not used in main compilation.

**Root cause:** Function bodies stored as SOURCE TEXT strings (not AST) because `List<Statement>` is corrupted in Stage 2. But `emit_all_fn_bodies` proves freshly-parsed Block nodes work if consumed immediately.

## Target Architecture (Proper)

```
scan phase: parse -> AST -> type check -> store resolved types
codegen:    read AST + types -> emit LLVM IR (no re-parsing)
```

---

## Step 1: C-side per-function type store

**Files:** `stdlib/runtime.c`, `features/functions/mod.fg`

Add:
- `forge_fn_var_type_set(fn_idx, var_name, type_name)` — store checker's resolved type
- `forge_fn_var_type_get(fn_idx, var_name)` — retrieve during codegen

**Risk:** Low — purely additive, nothing calls it yet.

## Step 2: Run type checker during scan, store results

**Files:** `features/functions/mod.fg`, `checker/mod.fg`

After `parse_fn_decl` builds FnDeclData (which includes `body: Block`), run checker and persist TypeEnv results to Step 1's C-side store.

The checker already works on `data.body` in `check_fn` (line 167). Change: persist results where codegen can access them.

**Risk:** Medium — checker returns Unknown for some cases. Wrap in null checks.

## Step 3: Replace statement-at-a-time loop with emit_block

**Files:** `features/functions/mod.fg`

Replace the 300-line statement-at-a-time loop in `emit_fn_body_from_source` (lines 662-786) with:
```
body_parser = parser_new(body_tokens)
body = body_parser.parse_block()
last = cg.emit_block(body)
```

Keep parameter setup code (lines 494-621) and implicit return logic (lines 788-825).

**Sub-steps:**
- 3a: Add debug flag, branch between old/new paths
- 3b: Test with new path on progressively more complex programs
- 3c: Remove old path once verified

**Risk:** HIGH — the statement-at-a-time loop has real bug workarounds (CG_ACTIVE toggling, forge_let_needs_alloca fallback, etc.)

## Step 4: Codegen reads stored types instead of flags

**Files:** `codegen/mod.fg` (`define_var`, `emit_ident`, `emit_call`)

Use stored types as "first choice" with flag-based inference as fallback:
```
let stored_ty = forge_fn_var_type_get(current_fn_idx, name)
if stored_ty != "" { use stored_ty }
else { use flag-based inference }
```

**Risk:** Medium-High — the entire flag system is load-bearing.

## Step 5: Eliminate dead codegen paths

**Files:** `features/functions/mod.fg`, `codegen/mod.fg`

Remove `emit_all_fn_bodies`, `emit_fn_body`, dead source storage.

**Risk:** Low after Steps 3-4 proven.

## Step 6: Consolidate type tracking globals

**Files:** `codegen/mod.fg`

Systematically remove ~50 global type-tracking variables:
- CG_LAST_IS_STR, CG_LAST_IS_MAP, CG_LAST_IS_LIST, CG_LAST_IS_PTR
- CG_STR_VAR_NAMES, CG_STRUCT_VAR_NAMES, CG_ENUM_VAR_CSV
- All CSV-based workaround tracking

Replace with lookups to per-function type store.

**Risk:** HIGH — ~200+ usage sites, must be one variable at a time.

---

## Sequencing

```
Step 1 (C-side store)  ──────────┐
                                  ├── Step 4 (codegen reads types)
Step 2 (checker stores types) ───┘         |
                                           ├── Step 5 (eliminate dead paths)
Step 3 (emit_block replaces loop) ────────┘         |
                                                     └── Step 6 (consolidate globals)
```

Steps 1 and 3 can proceed in parallel.

## Key Risks

1. **List corruption:** If Stage 1 also has Block corruption, parse_block + emit_block fails. Mitigated by emit_all_fn_bodies already proving this works.

2. **CG_ACTIVE flag:** The statement-at-a-time loop toggles CG_ACTIVE. emit_block doesn't. Some parsers emit IR during parsing when CG_ACTIVE=true. Need careful testing.

3. **forge_let_needs_alloca:** Lines 701-728 handle alloca creation failures. This logic is lost in emit_block. Must verify emit_statement handles this.

## Success Criteria

- Score drops significantly (target: <200)
- Stage 2 can compile hello world (M5)
- No C-side workaround infrastructure needed for types
- One codegen path instead of three
