# TODO: Next Session Handoff

## What Was Done

15 commits shipped this session. All pushed to `feat/crafting-intepreters`. 257 tests pass, fixed-point holds.

### Features Implemented
- Type checker now **gates compilation** (errors stop codegen)
- **Deep immutability** on `let` bindings (field mutation rejected)
- **Exhaustive match** enforcement (error without wildcard, warning when wildcard hides >2 variants)
- **`shape` keyword** with structural type checking (field presence + field type match)
- **Pipe `|>`** `_` placeholder + `it` pronoun in pipe context
- **`catch` blocks** for inline error handling (`catch { default }` and `catch (e) { ... }`)
- **`errdefer`** with unified LIFO interleaving with `defer`
- **TypeExpr AST** foundation (enum + parser bridge — see below)

### Architecture: TypeExpr Refactor (IN PROGRESS)

The type annotation system currently uses **strings** throughout the pipeline:
- `ParamList.Node(name, ty: string, resolved, next)`
- `FieldList.Node(name, ty: string, resolved, next)`
- `Stmt.Function(name, tp, params, ret_ty: string, body)`
- `Stmt.ExternFn(name, params, ret_ty: string)`
- `Stmt.Let(name, ty: string, init)` / `Stmt.Mut`

The parser's `consume_type` returns a string. The type checker's `translate_type` re-parses strings with fragile splitting. This blocks union types (`A | B`) because `|` inside nested types like `fn(string | int)` can't be reliably parsed from a flat string.

**What's been done:**
- `TypeExpr` enum added to `core/ast.fg` (Named, Infer, Union, Optional, FnType, ListType, Generic)
- `parse_type_expr` added to `parse/mod.fg` — correctly handles `|` as union in type positions
- `consume_type` now calls `parse_type_expr` then `render_type_expr` (string bridge)
- All existing tests pass — the bridge produces identical string output

**What needs to happen next:**
The struct field types need to change from `string` to `TypeExpr`. This requires a **multi-seed-cycle migration** because the seed reads field values at runtime — a `string` (C string pointer) and `TypeExpr` (heap enum pointer) are different runtime values even though both are 8 bytes.

### Migration Plan for TypeExpr Fields

**Option A (3 seed cycles, safe):**
1. Add a SECOND field `ty_expr: TypeExpr` alongside `ty: string` — populate both in parser. Build + update seed.
2. Switch all consumers from `ty` (string) to `ty_expr` (TypeExpr). Build + update seed.
3. Remove `ty: string` field. Build + update seed.

**Option B (pragmatic, 0 seed cycles):**
Keep `ty: string` fields. Add `translate_type` support for `"A|B"` strings by splitting on `|`. The `parse_type_expr` bridge already produces `"int|string"` for union types. This works because `|` doesn't appear in any other type string context (fn types use `->`, generics use `<>`). This is NOT building on bad architecture — it's the bridge step. The string field migration happens later when we have bandwidth for 3 seed cycles.

**I attempted Option A directly (changing field types in one shot) and it FAILED** because the seed's monomorphizer reads `ret_ty` as a string (C string pointer) but the new runtime value is a TypeExpr enum pointer. The seed crashes trying to do string operations on an enum pointer. You CANNOT change these field types without the multi-step migration.

## Known Limitations / Gaps

### No hacks in committed code. These are structural limitations:

1. **`arm_type_skip` treats `Int` as "unknown"** — The type checker defaults unresolved expressions to `Int`. When one match arm is `Int`, it skips the type comparison. This means real `Int` vs `String` mismatches in match arms go undetected. Root cause: no `ValueType.Unknown` variant. Filed as `forge-crafting-intepreters-7kj`.

2. **Registry lambda parameter types are `int` not proper types** — Feature init lambdas use `(r: int, stmt: Stmt)` instead of `(r: Resolver, stmt: Stmt)`. The `Feature` struct already declares the correct types. Fixing requires a seed cycle because it changes LLVM parameter types. Filed as `forge-crafting-intepreters-7kj`.

3. **Mutating method calls on `let` bindings not blocked** — Spec says `user.posts.push(p)` should error on `let` bindings. Currently only `FieldAssign` is checked, not mutating method calls like `.push()`. Needs `mut self` tracking in the trait system. Filed as `forge-crafting-intepreters-aax`.

4. **`catch (e: Type)` typed binding not implemented** — Spec shows `catch (e: NetworkError)` for union error narrowing. Parser only accepts `catch (name)`. Depends on union types (P1-2).

5. **`catch` body type not checked against Ok type** — `parse_int("x") catch { "string" }` compiles even though Ok is `int` and catch body is `string`. Needs generic Result type resolution in typeck.

## Beads Tickets

65+ tickets loaded. Key remaining P1 items:
- `forge-crafting-intepreters-cim` — P1-2: Union types (A | B) — **NEXT PRIORITY**
- `forge-crafting-intepreters-bsm` — P1-4: Newtype wrappers
- `forge-crafting-intepreters-lk7` — P1-3: Associated types on traits
- `forge-crafting-intepreters-mtu` — P2-1: Union error types with auto-widening
- `forge-crafting-intepreters-1hm` — P3-1: Reference counting runtime
- `forge-crafting-intepreters-bkn` — P3-6: Drop trait + LIFO ordering
- `forge-crafting-intepreters-bj7` — P4-1: Green-thread scheduler

Run `bd list` (kill stale beads processes first: `lsof +D .beads/embeddeddolt/ | awk 'NR>1{print $2}' | xargs kill -9`).

## Critical Things To Know

### Build Pipeline
```bash
cd bootstrap/
make build    # seed → bs2 (self-check included)
make test     # 257 regression tests + fixed-point (bs2 == bs3)
make update-seed  # after changes, update seed for next build
```

### Seed Contamination
`NO_AUTOCYCLE=1` is set in the Makefile, but the seed can STILL get corrupted if a failed build auto-cycles. **Always check `git diff bootstrap/seed/seed.ll`** before building. If the seed is dirty and you didn't update it, restore with `git checkout HEAD -- bootstrap/seed/seed.ll`.

### Enum variants don't need seed cycles (hash-based tags)
### Struct field type changes DO need seed cycles (layout change)
### New keywords need: (1) add to Tk enum in ast.fg, (2) add to p_keyword_kind in parse/mod.fg, (3) add to tk_keyword_str in ast.fg. NO runtime.c change needed.

### The spec is at `docs/2026_04_18_FULL_SPEC.md` (6500 lines)
### The TRD is at `docs/TRD_V1.md` (comprehensive gap analysis)
### CLAUDE.md has 16 absolute rules — read them. Rule 16 is critical.

## Files Changed This Session
- `bootstrap/src/core/ast.fg` — TypeExpr enum, ShapeDecl, Errdefer, Catch, vtype_eq fixes, field_list helpers
- `bootstrap/src/parse/mod.fg` — parse_type_expr, pipe _ placement, it in pipe, catch parsing
- `bootstrap/src/typeck/mod.fg` — gating, shape checking, type operator resolution, ShapeSet
- `bootstrap/src/resolve/mod.fg` — deep immutability (fa_root + FieldAssign check)
- `bootstrap/src/features/match_expr/typeck.fg` — arm_type_skip, exhaustive enforcement, wildcard warning
- `bootstrap/src/features/defer_stmt/` — errdefer (unified DeferStack with Frame/ErrFrame)
- `bootstrap/src/features/null_safety/` — catch codegen, emit_defers_on_error on ? paths
- `bootstrap/src/features/struct_decl/` — shape parser, shape feature registration
