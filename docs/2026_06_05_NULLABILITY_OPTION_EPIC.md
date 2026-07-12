# Nullability / Option Epic — Implementation Handoff

**Status:** design ratified, implementation not started.
**Tracking:** epic **`forge-crafting-intepreters-xm2g`**, children `xm2g.1`–`xm2g.7` (one per phase, dependency-chained — `mcp__Agent_Tasks__show forge-crafting-intepreters-xm2g`). Claim a phase with `mcp__Agent_Tasks__update` (`claim: true`); close only when its acceptance criteria are fully met (`mcp__Agent_Tasks__close`).
**Audience:** an agent with **no prior context**. Read this top to bottom; it is self-contained.
**Source of truth:** the language spec `docs/2026_04_18_FULL_SPEC.md` **Axis 10** (lines ~1793–1954) and **Axis 12** (error handling). Where this doc and the spec disagree, this doc *amends* the spec — see §1.4 — and you must update Axis 10 to match as part of the final phase.

---

## 0. TL;DR

The language advertises null-safety (`T?`, `?.`, `??`, `?`) but the implementation is the **unsafe** version: `T?` is erased at type-resolution, nothing tracks or enforces nullability, and `null` is represented as the integer/pointer `0`. This is the "billion-dollar mistake" wearing safe syntax.

This epic makes the implementation match a **safe, Option-backed, non-null-by-default** model (Swift/Kotlin surface, Rust/Zig semantics), with these ratified decisions:

1. **Representation:** `T?` is `Option<T>`. Use a **dual representation, done correctly from day one** — null-pointer niche for pointer-backed inner types (already how the codebase stores it), tagged `{present, value}` for value types (`int`/`bool`/`float`/sized ints). One bounded classification helper decides which. (Decision §1.1.)
2. **Absence literal keyword:** **`none`** (lowercase keyword-literal, like `true`/`false`). `null` kept as a temporary alias, removed in the final phase. (Decision §1.2.)
3. **Propagation operator split (Zig-style, NOT Rust-style):** `?` means **error-propagation only** (on `Result`). Absence is handled with `?.`, `??`, or `match` — there is **no `?`-means-absent**. (Decision §1.3.)
4. **Flow narrowing:** keep it as ergonomic sugar (`if x != none { x.use() }`), but it is **never load-bearing for safety** — an un-narrowed use of a `T?` must still be a hard compile error. (Decision §1.4.)
5. **Rollout:** **staged** — land the representation + type tracking *permissively* first (build stays green), then flip on non-null-by-default enforcement and fix all violations. (Decision §1.5.)
6. **Diagnostics:** a first-class **"diagnostics contract"** — every error carries a stable F-code, a precise span, and the *exact fix*. Null-safety errors are the showcase. This is an Avra selling point, not polish. (Decision §1.6.)

**Why these (the LLM-first lens):** Avra's primary user is an LLM. The expensive failure modes for an LLM are *silent incorrectness*, *non-local coupling*, and *meaning that can't be read from local tokens*. Every decision above optimizes against those (gating > permissive; one token = one meaning; conventional high-prior syntax; the compiler always tells you the fix). The one human value we explicitly drop is **terseness** — tokens are free for an LLM, ambiguity is not.

---

## 1. Ratified design decisions (with rationale)

### 1.1 Representation — dual/niche, correct from the start
`T?` ≡ `Option<T>`. The runtime layout depends on the inner type, chosen by **one** classification helper (see §3, `optional_repr`):

- **Pointer-backed inner** (`Str`, `Bytes`, `Ptr`, `Struct`, `Enum`, `List`, `Map`, `Fn`, `Closure`, `Trait`, `Task`, and `Newtype` wrapping any of these): **null-pointer niche** — `none` = null pointer (`0`), present = the pointer. *This is already how the codebase stores nullable pointers today, so this half is mostly status quo, now type-tracked.*
- **Value inner** (`Int`, `U8/U16/U32/U64`, `I8/I16/I32`, `Bool`, `Float`): **tagged struct** `{ i1 present, <inner> value }`. `none` = `{0, undef}`, present = `{1, value}`. Required because `0` is a valid value (the current `null == 0` model silently conflates `Some(0)` and `none` — the core bug).

**Why not "uniform tag everything"?** It would *replace* the working pointer path with a tagged struct (more churn, slower) and is not the end-state. **Why not "uniform first, niche later"?** In a self-hosting compiler, changing the in-memory representation of every optional later forces a seed cycle and risks ABI mismatch — worse than building the bounded dual dispatch once. Rust and Zig both ship this dual layout under a uniform surface; we do the same. The dual path is a *single typed branch in one helper* (like the existing `llvm_type_for_full`), not scattered duplication.

### 1.2 Absence literal — `none`
Canonical keyword-literal **`none`** (lowercase). Rationale: in LLM training data the token `null` co-occurs with *unsafe* null code, while `none`/`None` co-occurs with *safe optional* code — so `none` primes the correct patterns. It also matches the internal `.None` already used in the codebase. `null` remains a parser-level alias (same AST node) through Phases 1–4 to keep the build green during migration, and is **removed in Phase 5**.

### 1.3 Propagation — `?` is errors-only (the Zig split)
- `?` (postfix) is valid **only** on `Result<T, E>` — unwrap `Ok`, early-return `Err`. One meaning, locally readable.
- Absence (`T?`) is handled by: `?.` (optional chaining — short-circuits to `none`), `??` (default), or `match`/flow-narrowing. The "early-return-`none`" use of `?` is **removed**.
- Rationale: the absent-propagation case is the optional-chain pattern, already covered *more locally* by `?.` (an expression, no enclosing-return-type coupling). Overloading `?` across absence and error means the same token has two type-dependent meanings — the exact non-local ambiguity LLMs get wrong. Zig deliberately splits (`orelse`/`try`); we follow Zig, not Rust.
- **Migration impact:** any compiler/stdlib source currently using `?` on a `T?` must be rewritten to `??`/`?.`/`match` (see Phase 2). Using `?` on a `T?` after this change is a compile error (F-code in §6).

### 1.4 Flow narrowing — sugar only, never load-bearing
Implement narrowing: after `if x != none { … }`, `if x == none { return … }`, and matching, treat `x` as `T` (not `T?`) within the proven-non-none scope. **But** safety comes from gating (§1.5/Phase 4), not from narrowing: a use of an un-narrowed `T?` where `T` is required must be a hard compile error regardless. Narrowing only removes ceremony in the cases the compiler can prove; it must never be the only thing standing between a bug and a green build.

### 1.5 Rollout — staged, non-gating → gating
Land in order so every step is green, reviewable, and bisectable:
1. Representation + `Option` type + `none` keyword, with typeck **permissive** (`T?` interchangeable with `T`). Build stays green. *This phase alone unblocks the spans epic's `If.else_branch`.*
2. Real value-type codegen + operators correct + `?`-split migration.
3. Flow narrowing.
4. **Flip to gating** (non-null by default); fix every surfaced violation until selfhost is green.
5. Finalize `?` semantics, remove `null` alias, update the spec.
6. Diagnostics contract (cross-cutting; null-safety is its reference implementation).

Enforcing first would mean one gigantic non-compiling PR; staging defers true safety to the end but keeps the tree green throughout — the right trade for a self-hosting compiler.

### 1.6 Diagnostics contract — first-class
For an LLM-first language the compiler's error output **is** the primary interface (the loop is write→compile→read-error→fix). Every diagnostic must carry: stable F-code, precise span (start+end), human message, and **the exact remedy**. Provide a structured machine-readable mode and `avra explain <code>`. Report root causes, suppress cascades. Null-safety errors are the showcase the rest of the compiler copies.

---

## 2. Current state — map of the code (so you don't rediscover it)

All paths under `bootstrap/`. Run env setup first (see §7).

| Concern | Location | Current behavior |
|---|---|---|
| `ValueType` enum | `packages/std-avrac/src/core/ast.av:252` | **No nullable/optional variant.** |
| `TypeExpr` enum | `…/core/ast.av:330`; `Optional(inner)` at `:338` | Parse-time nullable exists here. |
| Erasure site #1 | `…/core/ast.av:368–370` (`vtype_from_name`) | Strips a trailing `?` and returns inner. |
| Erasure site #2 | `…/core/ast.av:416` (`type_expr_to_vtype`) | `.Optional(inner) -> type_expr_to_vtype(inner)` — drops it. |
| `FieldEntry` | `…/core/ast.av:131` = `{ name, resolved: ValueType }` | Carries only `ValueType`; once `ValueType` tracks Optional, fields inherit it automatically — **no `FieldEntry` flag needed.** |
| Absence literal | `Expr.Null` (AST); codegen `…/codegen/mod.av:354` → `ctx.i64(0)`; `…/codegen/helpers.av:100` `is_null_literal` | `null == 0` (the bug). |
| Null-safety typeck | `…/features/null_safety/typeck.av` (`check_try`, `check_null_coalesce`) | **Permissive pass-through** — does not track/enforce nullability. |
| Null-safety codegen | `…/features/null_safety/codegen.av` (`emit_null_coalesce`, optional-chain, `try`) | Branches on `value == 0/zero-ptr`. Comment literally says *"null == 0"*. |
| Canonical LLVM type map | `…/codegen/types.av:700` `llvm_type_for_full` (+ `:741` `_sized`) | Where Optional's LLVM layout must be added. |
| Monomorphizer subst | `…/features/generics/mono.av:1405` `substitute_vtype` | Must recurse into Optional. |
| Typeck subst | `…/typeck/mod.av:2089` `tc_subst_vtype` | Must recurse into Optional (mirror of above). |
| derive_walker classify | `…/features/walker/derive.av:194` `classify_field_kind`; `self_type_name` at `:170` | No nullable awareness; can't see `else_branch: Stmt?` is optional. |
| `Option` enum | — | **Does not exist anywhere.** Must be created. |
| Error F-codes | see `CLAUDE.md` "Error System"; typeck range **F1000–1999** | New null F-codes live here. |

**Spans-epic interaction:** `Stmt.If.else_branch: Stmt?` (`ast.av:1388`) is blocked on this epic — the walker can't migrate it to `SStmt?` until Optional is tracked (Phase 1). The three non-null loop bodies (`While.body`, `For.body`, `ForIn.body`) are independent and may be migrated separately at any time.

---

## 3. Target design — semantics & representation

**Type model**
- `ValueType` gains `Optional(inner: ValueType)`. `T?` lowers to `Optional(T)` (stop erasing at `ast.av:368-370` and `:416`). Nesting allowed in principle but `T??` should be normalized to `T?` (no double-optional).
- `Option<T>` is defined in the prelude as the canonical type `T?` desugars to. Programmers write `T?` and `none`; they never write `.Some`/`.None` (spec 10.1, line 1844). Internally the two-variant form may be referenced.

**Representation helper (single source of truth)**
```
enum OptionalRepr { NullPointerNiche, Tagged }
fn optional_repr(inner: ValueType) -> OptionalRepr   // pointer-backed -> Niche; value -> Tagged
```
Every build/read/none-check/unwrap of an optional consults `optional_repr(inner)`. Add primitives:
- `emit_none(inner)` → the `none` value for that repr.
- `emit_some(inner, v)` → wrap a present value.
- `emit_is_none(inner, opt)` → `i1`.
- `emit_unwrap(inner, opt)` → the inner value (callers must have proven non-none; in gating mode the typeck guarantees it; a defensive runtime trap is acceptable for force-unwrap paths).

**Operators**
- `?.` (optional chain): short-circuit to `none` if receiver is `none`; result type `U?`.
- `??`: `left ?? right` → `left` unwrapped if present, else `right`. Result type is non-optional `T` (the guaranteed-present fallback).
- `?` (try): **Result only.** On `T?` it is a compile error (F-code, remedy: use `??`/`?.`/`match`).
- `match`/flow-narrowing: narrow `T?` → `T`.

**Non-null-by-default (Phase 4)**
- A non-`?` type cannot hold `none`. `let x: int = none` → error (spec 1843).
- A `T?` cannot be used where `T` is required (field access, method call, arithmetic, passed as non-optional arg, returned as non-optional) without unwrap/narrowing → error with remedy.
- `T?` auto-widens *from* `T` (assigning a present `T` into a `T?` slot is fine — spec 1842).

---

## 4. Implementation plan (phased, file-level)

> Each phase ends with: `make build` green → `make test` green → selfhost fixed point (`bs2` == `bs3`) → `make update-seed` if a seed-processed type changed → commit + push. See §7 for the seed/keyword/variant mechanics and §8 acceptance criteria.

### Phase 0 — `none` keyword + `Option` prelude type (types only, no behavior change) — `xm2g.1`
New keyword ⇒ **two-phase bootstrap** + seed cycle (CLAUDE.md "Adding a Feature").
1. `Tk` enum (`core/ast.av`): add `none` token kind.
2. `p_keyword_kind` (`parse/mod.av`): map `"none"` → the token.
3. `avra_kind_id_for_keyword()` (`runtime.c`): register `"none"`.
4. Parser: `none` produces the absence-literal AST node. **Rename `Expr.Null` → `Expr.None`** for spec/internal consistency (Expr variant change ⇒ `make seed-patch-traps` first). Keep `null` as a parser alias producing the same `Expr.None`.
5. Define `enum Option<T> { Some(T), None }` in the prelude (locate the prelude/builtin-types module; search for where `Result` is declared and co-locate). It need not be user-facing yet.
6. Update `render_expr` and any `Expr.Null` match sites to `Expr.None`.
7. Seed: `make seed-patch-traps` → `make build` → fix sites → `make update-seed`.

*No semantic change yet — `none` behaves exactly like today's `null` (still `0`).*

### Phase 1 — Track `Optional` in `ValueType` (permissive) — `xm2g.2`
New `ValueType` variant ⇒ `make seed-patch-traps` first.
1. `ValueType` (`ast.av:252`): add `Optional(inner: ValueType)`.
2. Stop erasing: `ast.av:368-370` and `:416` now produce `ValueType.Optional(inner)` (normalize `T??`→`T?`).
3. Helpers in `core/ast.av`: `vtype_is_optional`, `vtype_strip_optional`, `vtype_wrap_optional`.
4. Update **every** `ValueType` match to handle `.Optional` (the trap-patch shows you the sites). Minimum set: `codegen/types.av` (`llvm_type_for_full` + `_sized` — add the dual layout via `optional_repr`), `mono.av:1405` `substitute_vtype` (recurse), `typeck/mod.av:2089` `tc_subst_vtype` (recurse), resolver (`resolve/`), eval (`features/eval/mod.av`), `render`, `diagnostics/`, `features/marshal/derive.av`, `codegen/escape.av`, union/equality helpers.
5. **Keep typeck permissive:** `Optional(T)` unifies with `T` both directions for now (so existing code still builds).
6. Codegen the dual representation (§3 primitives) and rewire `none` literal + `null_safety/codegen.av` to use `optional_repr` instead of bare `== 0`.
7. **Walker unblock** (`features/walker/derive.av`): teach `classify_field_kind` to recognise `Optional(Self)` and `Optional(Wrapper-of-Self)`; emit **none-guarded** children (omit the child when `none`) and none-guarded `map` (return `none` unchanged; else descend). This is what lets the spans epic migrate `If.else_branch` to `SStmt?`.
8. Seed-patch → build → fix → `make update-seed`.

### Phase 2 — Real value-type codegen + operators + `?`-split — `xm2g.3`
1. Verify `int?`/`bool?`/`float?` round-trip: `none` ≠ `Some(0)` / `Some(false)` / `Some(0.0)`. Add tests (§5).
2. Type `?.` and `??` against the representation (result types per §3).
3. **Split `?`:** `?` on a `T?` becomes a compile error with remedy; `?` on `Result` unchanged. Audit compiler+stdlib for `?`-on-optional and migrate to `??`/`?.`/`match` **before** turning the error on (grep for `Try` usages and inspect operand types).
4. Build → test → seed if needed.

### Phase 3 — Flow narrowing (sugar) — `xm2g.4`
1. Typeck: narrow `T?`→`T` after `!= none` guards, `== none { return/break/continue }` early exits, and within match arms that bind the present case.
2. Keep it conservative and *additive only* — it must never *suppress* an error that gating would raise; it only avoids requiring an explicit unwrap where presence is proven.
3. Tests for narrow/!narrow boundaries.

### Phase 4 — Flip to gating (non-null by default) — the grind — `xm2g.5`
1. Typeck enforces the §3 "non-null-by-default" rules; emit the F-codes in §6 with remedies.
2. Iterate: `make build`/`make test`, fix each surfaced violation across compiler + stdlib, until selfhost is byte-identical green. Expect many sites.
3. Do **not** weaken a rule to make the build pass — fix the source (CLAUDE.md rules 1–4, 16).

### Phase 5 — Finalize & cleanup — `xm2g.6`
1. Remove the `null` alias (Phase 0 step 4) — `none` only. Migrate remaining `null` occurrences.
2. Finalize `?` (Result-only) typing per spec 10.5/12.x, minus the Option-propagation clause.
3. **Update spec Axis 10** to reflect: `none` keyword, `?`-split (no `?`-means-absent), dual representation note, flow-narrowing-as-sugar.

### Phase 6 — Diagnostics contract (cross-cutting; null-safety is the showcase) — `xm2g.7`
1. Define the contract (centralize in `diagnostics/`): every `Diagnostic` has code, severity, precise span (start+end), message, `help` remedy, and an optional structured `suggested_edit { span, replacement }`.
2. Add a structured output mode (e.g. `avra check --diagnostics=json`) emitting an array of those records — agents must not scrape prose.
3. `avra explain F1xxx` worked example + canonical fix for each null F-code.
4. Root-cause-only reporting (suppress downstream cascades) for null errors.
5. Make every F-code in §6 meet the contract; use these as the reference other features copy. Per CLAUDE.md "ZERO RAW ERRORS": no `eprintln` errors, everything via `CompileError::render`.

---

## 5. Testing requirements

Use the repo's `spec`/`given`/`then` format; one `*_test.av` per scenario; compile-error tests assert the exact F-code via `avra_shell_exec("./build/bs2 compile …")` (see CLAUDE.md Phase 4). Required coverage:

- **Representation:** `int?` distinguishes `none` from `Some(0)`; same for `bool?`/`false`, `float?`/`0.0`. Pointer `T?` (`string?`, struct?, list?, enum?) none vs present.
- **Operators:** `??` returns fallback on `none`, value on present, short-circuits (right side not evaluated when present). `?.` chains and short-circuits to `none`. `?` on `Result` propagates `Err`; `?` on `T?` is a **compile error** (assert F-code).
- **Auto-widen:** assigning a `T` into a `T?` slot works; `let x: int = none` is a **compile error** (assert F-code).
- **Flow narrowing:** `if x != none { x.field }` compiles; the same access *outside* the guard is a compile error (proves narrowing is sugar, gating is the backstop).
- **Walker (spans unblock):** an `@expand(derive_walker)` enum with an `Optional(Self)` field — `children()` omits the child when `none`, includes it when present; `map` leaves `none` untouched and descends when present; deep nesting; sibling preservation. (Mirror the existing `walker_wrapper_single_test.av`.)
- **Combinatorial (CLAUDE.md Phase 4.3):** optionals through closures, `match`, if-expr, structs, enums, generics/monomorphization, `with`, lists/maps, as args/returns.
- **Diagnostics:** for each null F-code, a test asserting the code *and* that the message contains the remedy; a test of the `--diagnostics=json` shape.

---

## 6. Proposed F-codes (typeck range F1000–1999)

Reserve a contiguous block and wire help text in `diag_code_help`:
- **F1200** — use of possibly-`none` value where non-optional required (field access / method / arithmetic / non-optional arg / non-optional return). *Remedy:* narrow with `if x != none`, default with `?? …`, chain with `?.`, or `match`.
- **F1201** — `none` (or `T?`) assigned/returned where non-optional `T` required (e.g. `let x: int = none`). *Remedy:* make the type `T?`, or provide a value.
- **F1202** — `?` used on an optional `T?`. *Remedy:* `?` is for `Result`; use `??`, `?.`, or `match` for absence.
- **F1203** — `?` used on a non-`Result`, non-optional value. *Remedy:* remove `?`.
- **F1204** — `?` requires the enclosing function to return `Result<…>`; it does not. *Remedy:* change the signature (name it explicitly).
- **F1205** — redundant `?`/`??`/`?.` on a value that is already non-optional. *Remedy:* remove it. (Warning severity, F9xxx if preferred.)

Final codes are the implementer's call; keep them contiguous, stable, and documented in `avra explain`.

---

## 7. Build / bootstrap mechanics (don't get stuck here)

- **Env:** `eval "$(bash ../scripts/bootstrap.sh --print-env)"` from `bootstrap/` (exports `LLVM_PREFIX`, `LLC`, `PATH`). Do this in every fresh shell.
- **New keyword (`none`)** and **new `ValueType`/`Expr` variant (`Optional`, `Expr.None` rename):** run `make seed-patch-traps` **before** `make build` to convert the seed's match traps to safe fallthrough; after the build succeeds, `make update-seed`. New surface syntax the seed's parser can't yet produce must be landed *without using it in `src/`* first, then dogfooded after the seed cycle (CLAUDE.md "Adding a Feature → Phase 1/2").
- **Stale-bs2 gotcha:** if behavior doesn't change after a rebuild, the cache may have relinked the old `bs2`. Force-rebuild: `rm -rf packages/cli/src/build/cache && rm -f build/bs2 && rm -rf packages/std-*/build/cache build/cache/fixture_stdout && make build-quick`.
- **Iterate narrow:** `make test FILTER=<substr>`; reproduce a single failure with `./build/bs2 test <file>`. Don't rerun the full suite to "see if it flaked" — isolate (CLAUDE.md "Test cycle hygiene").
- **Out of space:** `make clean` then retry (safe; rebuilds from seed).
- **Debugging crashes:** LLDB first, check `git diff seed/seed.ll`, `-O0` vs `-O2`, `AVRA_TRACK_STORES=1`, C-side `avra_trace_*` — never `eprintln` traces that need a rebuild (CLAUDE.md "Debugging Protocol").

---

## 8. Acceptance criteria

**Global (every phase):** `make build` passes; `make test` is green (no regressions); selfhost fixed point holds (`bs2` and `bs3` produce byte-identical IR); `seed/seed.ll` updated via `make update-seed` and committed whenever a seed-processed type changed; each phase committed + pushed separately; no `--no-verify`; no raw errors (everything via the diagnostics system).

**Phase 0 (`xm2g.1`):** `none` lexes/parses; `Expr.None` replaces `Expr.Null` everywhere; `null` still works as an alias; `Option<T>` exists in the prelude; behavior unchanged (still `0`-backed). Build/test/selfhost green; seed updated.

**Phase 1 (`xm2g.2`):** `T?` resolves to `ValueType.Optional(inner)` (verified by rendering/inspecting a resolved type); the erasure sites no longer drop `?`; all `ValueType` matches handle `.Optional`; typeck still permissive (existing code builds unchanged); the dual representation exists and `none`/operators route through `optional_repr`; the derive_walker handles `Optional(Self)`/`Optional(Wrapper)`. **Concrete proof:** the spans epic can now migrate `Stmt.If.else_branch` to `SStmt?` and the walker descends it without a none-deref (write that test). Build/test/selfhost green; seed updated.

**Phase 2 (`xm2g.3`):** value-type optionals distinguish `none` from zero/false (tests pass); `?.` and `??` typed correctly; `?` on a `T?` is F1202 (test asserts the code); no `?`-on-optional remains in compiler/stdlib. Green; seed if needed.

**Phase 3 (`xm2g.4`):** narrowing tests pass; the matching un-narrowed access is still an error (proving narrowing is non-load-bearing). Green.

**Phase 4 (`xm2g.5`, the gate):** non-null-by-default fully enforced — `let x: int = none` is F1201; un-handled `T?` use is F1200; both with remedies. Every existing violation fixed; **selfhost byte-identical green** with enforcement ON. This is the phase that makes the language actually safe. No rule weakened to pass.

**Phase 5 (`xm2g.6`):** `null` alias removed (grep clean); `?` finalized as Result-only; **spec Axis 10 updated** to match (none keyword, `?`-split, dual repr, narrowing-as-sugar). Green.

**Phase 6 (`xm2g.7`):** diagnostics contract implemented and centralized; `--diagnostics=json` emits structured records (code, span start+end, message, help, optional suggested_edit); `avra explain` covers every null F-code; each null F-code's test asserts the remedy text is present; cascades suppressed for null errors. Green.

**Epic (`forge-crafting-intepreters-xm2g`) done = all seven phase children (`xm2g.1`–`xm2g.7`) closed with their criteria met, every change committed and pushed, spec updated, and selfhost green with non-null-by-default enforced.** Partial is not done (CLAUDE.md rule 19); do not close the epic until every child is genuinely closed (rule 20).

---

## 9. Out of scope / explicitly deferred
- Niche optimizations *beyond* the pointer-null niche (e.g. multi-niche packing, `Option<Option<…>>` flattening past one level) — not required.
- Changing `Result`/error handling beyond the `?`-split boundary — Axis 12 stays as-is except where it intersects `?`.
- The broader typeck foundation bug (`cpvo`, type-param/type-name conflation) is a *separate* epic; don't fold it in.

## 10. First concrete step
Claim `forge-crafting-intepreters-xm2g.1` (`mcp__Agent_Tasks__update`, `claim: true`). Phase 0, step 1–4: add the `none` keyword and rename `Expr.Null`→`Expr.None` (seed-patch-traps → build → fix → update-seed), keeping `null` as an alias. Then define `Option<T>` in the prelude. Commit, push, and proceed to Phase 1. Loop bodies of the spans epic (`While`/`For`/`ForIn`) can be migrated in parallel by another agent at any time — only `If.else_branch` depends on Phase 1.
