# TODO: Next Session Handoff

## What Was Done This Session

6 commits shipped. All pushed to `feat/crafting-intepreters`. 260 tests pass, fixed-point holds.

### Features Implemented
- **Union types (`A | B`)** — full implementation:
  - `ValueType.Union(types: TypeList)` variant added
  - Parser: `parse_type_expr` bridge produces `"A|B"` strings, both `translate_type` (typeck) and `translate_param_type` (codegen) handle `|` splitting
  - Codegen: same `{i64 tag, ptr payload}` discriminated layout as enums, shared `__union` LLVM struct type
  - Implicit wrapping at `let`/`mut` assignments and function call argument sites
  - `Pattern.TypePattern(type_name, binding)` for `int(n)`, `string(s)` match syntax
  - Resolver/typeck: TypePattern bindings properly scoped and typed
  - Supports multi-type unions (`int | string | bool | float`), struct unions, passthrough, nested matching

### Bugs Fixed
- **Diagnostic render truncated errors behind warnings** — errors now always render first, warnings capped at 10
- **Bool literal type was Int** — now correctly emits `.Bool` type. LitBool match comparison uses `truthy()` for i1/i64 compatibility
- **`vtype_to_string` missing Union variant** in generics/mono.fg

## Known Limitations / Gaps

### No hacks in committed code. These are structural limitations:

1. **`arm_type_skip` treats `Int` as "unknown"** — The type checker defaults unresolved expressions to `Int`. When one match arm is `Int`, it skips the type comparison. This means real `Int` vs `String` mismatches in match arms go undetected. Root cause: no `ValueType.Unknown` variant.

2. **Registry lambda parameter types are `int` not proper types** — Feature init lambdas use `(r: int, stmt: Stmt)` instead of `(r: Resolver, stmt: Stmt)`. The `Feature` struct already declares the correct types. Fixing requires a seed cycle because it changes LLVM parameter types.

3. **Mutating method calls on `let` bindings not blocked** — Spec says `user.posts.push(p)` should error on `let` bindings. Currently only `FieldAssign` is checked, not mutating method calls like `.push()`. Needs `mut self` tracking in the trait system.

4. **`catch (e: Type)` typed binding not implemented** — Spec shows `catch (e: NetworkError)` for union error narrowing. Parser only accepts `catch (name)`. Depends on union types (now implemented — this can be done).

5. **`catch` body type not checked against Ok type** — `parse_int("x") catch { "string" }` compiles even though Ok is `int` and catch body is `string`. Needs generic Result type resolution in typeck.

6. **`string(bool_val)` shows 0/1 not true/false** — The `string()` builtin doesn't distinguish Bool from Int at runtime.

## Beads Tickets

Key remaining P1 items:
- `forge-crafting-intepreters-bsm` — P1-4: Newtype wrappers
- `forge-crafting-intepreters-lk7` — P1-3: Associated types on traits
- `forge-crafting-intepreters-mtu` — P2-1: Union error types with auto-widening (builds on union types)
- `forge-crafting-intepreters-1hm` — P3-1: Reference counting runtime
- `forge-crafting-intepreters-bkn` — P3-6: Drop trait + LIFO ordering
- `forge-crafting-intepreters-bj7` — P4-1: Green-thread scheduler

Run `bd ready` for available work.

## Critical Things To Know

### Build Pipeline
```bash
cd bootstrap/
make build    # seed → bs2 (self-check included)
make test     # 260 regression tests + fixed-point (bs2 == bs3)
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
- `bootstrap/src/core/ast.fg` — ValueType.Union, Pattern.TypePattern, union helpers, render_pattern, vtype_display
- `bootstrap/src/codegen/types.fg` — translate_param_type pipe handling, cg_find_pipe, llvm_type_for_full/llvm_type_for Union
- `bootstrap/src/codegen/setup.fg` — __union LLVM struct type creation
- `bootstrap/src/codegen/mod.fg` — Bool literal type fix (.Bool instead of .Int)
- `bootstrap/src/codegen/helpers.fg` — union wrapping in fill_arg_array_boxing
- `bootstrap/src/typeck/mod.fg` — translate_type pipe handling, tc_find_pipe
- `bootstrap/src/parse/mod.fg` — peek_after_ident_is_paren helper
- `bootstrap/src/features/union_type/` — new feature: codegen.fg, mod.fg, example.fg, grammar.md
- `bootstrap/src/features/match_expr/parser.fg` — TypePattern parsing in parse_pattern
- `bootstrap/src/features/match_expr/codegen.fg` — emit_union_match_expr/arms, LitBool i1 fix
- `bootstrap/src/features/match_expr/resolver.fg` — declare_pattern_bindings TypePattern
- `bootstrap/src/features/match_expr/typeck.fg` — tc_bind_pattern TypePattern, pattern_variant_names
- `bootstrap/src/features/let_stmt/codegen.fg` — union wrapping in emit_var_decl
- `bootstrap/src/features/mod.fg` — mod union_type
- `bootstrap/src/features/generics/mono.fg` — vtype_to_string Union variant
- `bootstrap/src/resolve/names.fg` — bind_pattern_ctx TypePattern
- `bootstrap/src/diagnostics/render.fg` — errors-first rendering, warnings capped
