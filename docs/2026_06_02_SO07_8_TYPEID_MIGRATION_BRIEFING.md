# Briefing: Migrate Value.enum_type and Expr.EnumCtor.type_name to TypeId

## Context

**Status of so07.8 (this epic's last open child):**
- Phase A landed (`b523c979`): Value struct extended with `stmt_payload: Stmt?` / `expr_payload: Expr?` / `value_type_payload: ValueType?` slots + constructors `value_for_stmt` / `value_for_expr` / `value_for_value_type`. `value_to_stmt` short-circuits on `kind="stmt"`. Purely additive — back-compat preserved.
- Phase B attempted (stashed in `so07-phaseB-wip-string-match`): added native boxing in `eval_enum_ctor` via string FQN match (`if type_name == "@std::avrac::core::Stmt"`). Rejected as doubling down on the wrong pattern — CLAUDE.md rule 16 ("never build on top of bad architecture"). Also relocated the ~880-line decoder block to `features/eval/ast_decode.av`; that part is good and worth recovering — see Phase B0.

**The wrong pattern this fixes:** every dispatch site that asks "is this Value's enum type Stmt/Expr/ValueType?" today does `v.enum_type == "@std::avrac::core::Stmt"`. Same for `Expr.EnumCtor.type_name`. T6 (so07.7) gave us interned `TypeId` for the type system; it never got threaded through the eval/Value layer.

## What mature compilers do

Five reference points — all converge on the same shape:

**rustc — interned `Symbol` + `DefId`, owned by `TyCtxt`.** Names get interned once; every downstream comparison is `Symbol::eq` (u32 compare). `TyCtxt` is the god-object threaded through every pass, owning the interner. Type identity = pointer equality on `Ty<'tcx>` (interned `TyKind`). Miri (const-eval) operates on already-interned `Ty` handles — no string lookups in the hot path.

**Swift — `NominalTypeDecl*` pointers.** AST nodes carry pointers to canonical type declarations. Type equality = pointer compare. `ASTContext` owns the canonicalization tables, threaded through.

**Roslyn — `INamedTypeSymbol` semantic refs.** Source code dispatches via symbol handles; `TypeEqualityComparer` uses symbol identity. The compilation object owns the symbol table.

**Go (`go/types`) — `*Named` pointers per declared type.** One allocation per type per package; type identity = pointer compare. `Package` owns the table.

**OCaml — stamped `Ident.t`.** Each Ident gets a serial number on creation. Paths are compositions of stamped idents. Type equality compares stamps, not names. `Env.t` owns the stamping.

**The five common patterns:**

1. **Interning is one operation** — `intern(name) → token`. The name string becomes irrelevant after.
2. **Owning context, threaded explicitly** — TyCtxt/ASTContext/Package/Env passed through every pass that needs the interner. No process-wide mutable globals.
3. **AST carries handles, not names** — post-resolve, every name reference is the interned handle. The string survives only on the source token for diagnostics.
4. **Diagnostics rehydrate** — when printing an error, the handle is looked up to produce a display name. The hot path doesn't touch strings.
5. **Lazy population is OK** — registries can grow as needed during compilation. Equality holds because intern returns the existing token for known names.

## What's in Avra today (and the gap)

We have ✓ from the list:
- `TypeRegistry` (core/type_registry.av) — the interner, with `type_registry_id_for(name) → TypeId(int)`
- `ValueType` carrying `TypeId` for nominal slots (post-T6) — pointer-equality-equivalent comparison via `id1 == id2`

We're missing ✗:
- Threading: `TypeRegistry` isn't on `Runtime` (eval's context)
- AST: `Expr.EnumCtor.type_name: string` — needs companion `type_id: int`, populated by resolve_names
- Runtime value: `Value.enum_type: string` — needs companion `type_id: int`, propagated from EnumCtor at eval time
- Decoder predicates: every `if v.enum_type != "@std::avrac::core::Stmt"` is a string compare — should be `if v.type_id != reg.stmt_type_id`

## Architecture decision

**Option α (process-wide singleton)** — C-side mutable global TypeRegistry. Rejected: CLAUDE.md rule 17 ("NEVER create mutable globals"). Also breaks the model when we eventually want parallel compilation contexts.

**Option β (threaded TypeRegistry)** — clean, matches every mature compiler above (TyCtxt/ASTContext/Package/Env all threaded). Invasive in line count (every `runtime_new()` site updated, every decoder fn carries a registry arg) but explicit dependencies, testable, future-proof.

**Recommendation: Option β.** Same shape as rustc/Swift/Roslyn/Go/OCaml. The line-count cost is the cost of doing it right.

## Prerequisites (resolve before starting B1)

These are the open questions the original brief glossed. Land answers before opening any code editor.

**P1. When does the TypeRegistry contain `@std::avrac::core::Stmt`?** `Stmt` is itself a user-space enum decl that the resolver processes. During the FIRST pass of compiling `core/ast.av`, the registry doesn't yet contain "Stmt" — it's being populated. If any code path needs Stmt's TypeId BEFORE that registration completes, `type_registry_id_for(reg, "Stmt")` returns 0 and dispatch silently no-ops. **Answer needed before B3**: confirm that `comptime/mod.av`'s runtime construction happens AFTER `resolve/names.av`'s `register_decls_into_type_registry` pass. If not, the threading needs to be re-ordered. Verify via `bd ready -n 10` for the resolve-order tickets, or by reading `cli/main.av`'s pipeline orchestration.

**P2. TypeIds aren't stable across compilations.** Allocated incrementally by the registry. bs2 might assign Stmt=47, bs3 might assign Stmt=51. Within one process they're consistent — but Values must never serialize raw TypeIds, OR the serializer must include the registry's full name↔id table for the receiver to remap. **Answer needed before B5**: audit every site that serializes Values across process boundaries. Concretely:
- Fixture stdout cache (`build/cache/fixture_stdout/*.out`) — these are TEXT, not binary Values. Safe.
- metadata.bin (`@marshal-binary` system) — could contain nested Stmts. Verify what cross-shard data flows through it.
- Test-runner results JSON — text-only. Safe.

**P3. Where does the parser write `Expr.EnumCtor`'s type_id slot?** At parse time, the parser doesn't have a resolved registry. So pre-resolve, `type_id = 0` is the only valid value. The resolver MUST do a post-parse walk that fills type_id from the canonicalized type_name. **Answer needed before B2**: confirm that the resolver visits EVERY EnumCtor — including those buried inside quote_expr/lower.av's lowering output. The lowering pass emits EnumCtor at parse time; the resolver runs after. Verify by grep for `Expr.EnumCtor(` constructions and trace which ones reach the resolver.

**P4. The encoder (`construct_stmt`, `construct_expr` in `quote_expr/lower.av`) runs at parse time and emits EnumCtor with stringly-typed `type_name`.** After B5 if `type_name` is removed, the encoder needs the registry to look up TypeIds. But there is NO registry at parse time. **Answer needed before B5**: choose one of (a) keep `type_name` in EnumCtor for display + back-compat with the encoder, dispatching on `type_id` only at eval time; (b) defer encoder output to a post-resolve pass that fills type_ids. Recommendation: (a) — matches T6's pattern (kept `.Enum(name, id)` both fields, compared by id).

## Audit checklist (run before each phase)

Each migration step has fragile assumptions. Run these checks at phase boundaries — failing any of them = STOP and re-plan.

**At B0 boundary (decoder relocated):**
- `make build-quick` clean.
- `./build/bs2 test packages/std-avrac/src/features/eval/tests/enum_value_test.av` — 10/10 pass.
- `./build/bs2 test packages/std-avrac/src/features/eval/tests/so07_8_phaseA_value_for_stmt_test.av` — 10/10 pass.
- Walker shard sample (`walker_basic_test.av`) — passes.

**At B1 boundary (fields added, dormant):**
- All above.
- Selfhost fixed point: `make build` + manual `make update-seed` to confirm bs2 ≡ bs3.
- `grep -r 'Expr.EnumCtor(' packages/std-avrac/src packages/cli/src --include='*.av' | wc -l` — count BEFORE and after; deltas indicate construction-site changes the seed couldn't auto-handle.

**At B2 boundary (resolver populates type_id):**
- All above.
- New invariant: every EnumCtor reaching typeck whose `type_name` is a registered type has `type_id > 0`. The brief recommends a typeck-entry assertion as F9999. Failure here = resolver didn't visit some lowering output (P3 violation).

**At B3 boundary (Value carries type_id from EnumCtor):**
- All above.
- Tests that ASSERT on legacy kind: `grep -rn 'v.kind == "enum"' packages/std-avrac/src/features/eval/tests/` — these tests need updating OR the legacy path needs preservation. `enum_value_test.av` line 28 is the canonical case.
- Walker tests (the slow ones): `walker_valuetype_test.av`, `walker_map_test.av`, `walker_basic_test.av`, etc. — ALL pass. Any failure here = native boxing isn't reaching a variant the legacy path handled.

**At B4 boundary (eval dispatches on TypeId):**
- All above.
- Full suite (`make test` or `./build/bs2 test`). 2631/2631.
- Any decoder returning null where it previously returned a Stmt = audit needed. Run with output captured; diff against pre-B4 baseline.

**At B5 boundary (legacy slots dropped):**
- All above.
- Selfhost fixed point holds.
- No `"@std::avrac::core::Stmt"` literal in source outside `type_registry_register` initialization and display/diagnostic rendering. Grep:
  ```
  grep -rn '"@std::avrac::core::\(Stmt\|Expr\|ValueType\)"' packages/std-avrac/src packages/cli/src --include='*.av' \
    | grep -v 'type_registry_register\|render_\|diag_\|format'
  ```
  Empty = success.

## STOP triggers

These conditions mean STOP and reassess — don't push through.

- **Full suite pass rate < 100% after any phase boundary.** The migration's hardest failure mode is silent decoder mismatch on rarely-used variants. Halt and diff against the prior phase's pass set.
- **Seed cycle fails seed-patch-traps + update-seed combination.** Adding/removing a variant field can break constructor calls in seed.ll that seed-patch-traps doesn't auto-handle. Don't force-build; investigate root cause.
- **Phase A spec test (`so07_8_phaseA_value_for_stmt_test.av`) fails at ANY phase boundary.** It's the load-bearing tripwire. If it goes red, the Value struct field additions broke the basic constructor contract — earlier than the test catches.
- **Pre-commit suite exceeds 5 min wall.** With jdgo (`d933802d`) at AVRA_JOBS=8, cold pre-commit is ~2 min. If it blows past 5 min, something's pathological — investigate before each subsequent commit, don't just accept the slowdown.
- **Discovery of an unaudited Value-crossing boundary.** If grep turns up a serialize/deserialize site not covered in P2, freeze migration. Decide encoding strategy before continuing.

## Implementation plan

Six phases (renumbered to include B0), each shippable as a separate commit with build-and-test verification at the end. Mid-phase failures revert the single phase, not the chain.

### Phase B0 — Recover the decoder relocation

The stash `so07-phaseB-wip-string-match` contains a clean ~880-line relocation of the decoder block from `features/comptime/eval.av` to `features/eval/ast_decode.av`. Pure refactor — no behavior change. Do this FIRST so subsequent phases can have `eval_enum_ctor` call decoders without cycles.

**Concrete actions:**
- `git stash apply so07-phaseB-wip-string-match` and discard the eval_enum_ctor string-match edits.
- Keep: `features/eval/ast_decode.av` (new file), the moved-decoder + export annotations.
- Keep: import updates in `comptime/eval.av`, `comptime/expand_macro.av`, the two test files.
- Keep: `export fn construct_value_type` annotation in `quote_expr/lower.av`.
- Discard: every edit inside `eval_enum_ctor` (in `features/eval/mod.av`).
- Discard: every edit inside `value_to_expr` / `value_to_construct_expr` (in `features/comptime/eval.av`).
- Verify imports are clean — `comptime/eval.av` no longer needs `construct_expr` / `construct_value_type` from quote_expr (those were for the string-match path).

**Build checkpoint:** B0 audit checklist passes.

### Phase B1 — Add fields, keep them dormant

- Add `type_id: int` field to `Expr.EnumCtor` variant (`src/core/ast.av`).
- Add `type_id: int` field to `Value` struct (`features/eval/mod.av`).
- Add cached `stmt_type_id: int`, `expr_type_id: int`, `value_type_type_id: int` to `Runtime`.
- Add `type_registry: TypeRegistry` to `Runtime`.
- All construction sites zero-initialize the new fields (`type_id: 0`, IDs cached as 0).
- `runtime_new()` retained as alias for `runtime_new_empty()` that sets registry to an empty new instance + IDs to 0.

**Seed cycle required**: adding a field to `Expr.EnumCtor` variant per CLAUDE.md ("Adding fields to existing variants also needs [seed] treatment"). Run `make seed-patch-traps` before `make build`. Run `make update-seed` after build succeeds. **Watch for**: seed-patch-traps converts match arms, but adding a field changes EnumCtor's CONSTRUCTOR call shape (4 args instead of 3). The seed's hardcoded constructor calls might not match. If build fails after seed-patching at constructor-arity errors, you've hit the gap; rebuild seed from scratch via `make clean && make` (3-min cost).

**Build checkpoint:** B1 audit checklist passes.

### Phase B2 — Resolver populates `Expr.EnumCtor.type_id`

- In `resolve/names.av` (or wherever EnumCtor type_name gets canonicalized), call `type_registry_id_for(reg, canonical_type_name)` and write into the new `type_id` slot.
- Sites constructing EnumCtor pre-resolve (parser, `quote_expr/lower.av`) keep passing `0` as the sentinel — resolver fills.
- Add an assertion at typeck entry: every post-resolve EnumCtor whose `type_name` is a registered nominal type has `type_id > 0`. Surfaces leaks as F9999.
- **Check P3**: does the resolver visit EnumCtors emitted by quote_expr/lower.av? Quote lowering happens at parse time; resolver runs after. If lowered EnumCtors don't reach the resolver, their type_id stays 0 forever. Recommended: add a dedicated post-lower walk in the resolver that fills type_id from canonical type_name on every EnumCtor.

**Build checkpoint:** B2 audit checklist passes.

### Phase B3 — Eval propagates `type_id` to Value, populates Runtime AST IDs

- `eval_enum_ctor` reads `expr.type_id` and threads into the Value via `value_enum_with_id(name, id, variant, payload)` (new constructor).
- `runtime_new(reg: TypeRegistry)` accepts a real TypeRegistry, caches the three AST TypeIds via `type_registry_id_for(reg, "@std::avrac::core::Stmt")` etc. at construction.
- Update production `runtime_new()` call sites (3 in `features/comptime/mod.av`) to thread the resolver's TypeRegistry through. Verify per P1 that these sites have access to a fully-populated registry.
- Test sites use `runtime_new_empty()` (cached IDs = 0, dispatch falls through to legacy path).

**Tests asserting on legacy `kind == "enum"`**: `enum_value_test.av` line 28 is the canonical case. Decide per-test whether to (a) update the test to assert on the new kind, or (b) keep the test pinned to legacy by constructing via `value_enum` directly (no eval interception). Recommendation: (a) — tests should reflect the new architecture. Update the assertion to `v.kind == "stmt"` for Stmt EnumCtors.

**Build checkpoint:** B3 audit checklist passes.

### Phase B4 — `eval_enum_ctor` dispatches on TypeId for native boxing

- Replace any nascent string match with:
  ```
  if expr.type_id != 0 && expr.type_id == runtime.stmt_type_id {
      let s = enum_value_to_stmt(variant, evaluated.values, runtime.type_registry)
      if s != null { return ok_result(..., value_for_stmt(s!)) }
  }
  // ... same for Expr / ValueType
  ```
- No `type_name == "@std::avrac::core::..."` anywhere in eval_enum_ctor.
- Decoder fns receive the TypeRegistry as parameter. **Threading cascade**: `enum_value_to_stmt` calls `enum_value_to_expr` calls `list_value_to_expr_list` calls `list_value_to_expr_list_at` calls `enum_value_to_expr` again. EVERY recursive call updates. Approximately 21 fns, ~60 call sites. Plan one editing pass per file; build after each fn group to catch cascading signature errors early.
- **Refactor the synthesize-then-decode pattern**: today's brief draft showed `synthetic = value_enum(...)` then `enum_value_to_stmt(synthetic)`. That's a vestige. Clean shape: refactor decoders to take `(variant: string, payload: List<Value>, reg: TypeRegistry)` directly — no intermediate Value. The decoder's first predicate becomes `if reg.stmt_type_id == 0 { return null }` (skip when registry is empty) + dispatch on variant.

**Build checkpoint:** B4 audit checklist passes. Macro tests (walker, comptime) ALL green. Diff Value-shape assertions vs B3 baseline.

### Phase B5 — Drop dispatch on legacy string slots (keep slots for display)

**T6 pattern**: `ValueType.Enum(name, id)` kept BOTH fields, compared by id. We do the same for Value and EnumCtor:

- **Keep** `Value.enum_type: string` and `Expr.EnumCtor.type_name: string`. They're used for display (`render_value`, diagnostic strings, error messages, debug output). Removing them forces every consumer to call `type_registry_name_for(reg, id)` — which would need the registry threaded EVERYWHERE including renderers. T6 didn't do that; neither should we.
- **Migrate dispatch sites** to use `type_id` only:
  - `enum_value_to_stmt`, `enum_value_to_expr`, `enum_value_to_value_type`: replace `if v.enum_type != "..."` with `if v.type_id != reg.stmt_type_id` (etc.).
  - `value_to_resolved_decls` (in expand_macro.av): same.
  - Any helper that reads `enum_type` for dispatch logic: same.
- **Handle the `enum_value_to_value_type` bare-type branch** (currently accepts `enum_type == ""`). After B2 the resolver should fill type_id on positional bare args too. Verify by running the suite; if walker tests fail with ValueType decode misses, the resolver isn't visiting nested EnumCtors — patch the resolver pass before continuing.
- **Encoder strategy** (per P4): `construct_stmt` etc. continue to emit `Expr.EnumCtor(type_name="@std::avrac::core::Stmt", type_id=0, variant, args)`. The resolver fills type_id post-encode. Encoder doesn't need TypeRegistry access.

**Build checkpoint:** B5 audit checklist passes. The grep for FQN literals returns ONLY display/diagnostic/registration sites.

## Where it will break (specific predictions)

Catalog of the failure modes the brief should preemptively warn about.

1. **Pre-resolve eval paths (`bs2 expr`, `bs2 eval`)** — these run the evaluator on parse output directly, no resolve. type_id=0 everywhere. The native-boxing dispatch correctly no-ops (id mismatch). The legacy-string path inside the decoder STILL works because B5 kept the strings. Verify both CLI paths produce the same output before and after.

2. **Quote macros inside @comptime fns that run during expand** — `quote stmt { foo }` is lowered at parse, populated by resolve, but the macro runs later. If the monomorphizer rewrites EnumCtor between resolve and expand, the populated type_ids might be stale. Audit: grep `Expr.EnumCtor(` in the monomorphizer; verify it preserves the type_id slot.

3. **`enum_value_to_value_type`'s "bare type" branch** — pitfall P3 mentions this. Today's check accepts `enum_type == ""`. The migration's resolver fix should fill type_id on bare positional args. If it doesn't, the dispatch silently misses ValueType variants. STOP trigger: walker tests fail with `null` returns from ValueType decoding.

4. **The seed cycle on B1 might fail at "patch traps" stage.** seed-patch-traps converts match arms — but Expr.EnumCtor is CONSTRUCTED via positional args throughout the codebase. Adding a field changes the constructor call shape. If build fails after seed-patching at constructor-arity errors, fall back to a fresh seed: `make clean && make` (3-min cost). Don't push through.

5. **Cross-shard test fixture cache (post-cbg3.1)** — caches stdout from fixtures. If a fixture's output depends on the eval interpreter's dispatch choices (kind="stmt" vs kind="enum"), the cache key (toolchain_fp via bs2 hash) handles invalidation. BUT tests asserting on `v.kind == "enum"` will break in B3. enum_value_test.av is the known case; grep for others.

6. **render_value / spec-test output** — when a test prints a Value, the output includes `enum_type`. After migration, the output is unchanged (B5 keeps the string). But if any test asserts on the rendered form, verify it matches.

7. **`stmt_to_value` (in `comptime/eval.av`)** wraps a native Stmt as a Value by going through construct_stmt → eval_expr. After B4, eval would box natively. But `stmt_to_value`'s caller expects the Value to roundtrip correctly through value_to_stmt. Verify: write a spec that asserts `value_to_stmt(stmt_to_value(rt, Stmt.NoOp)!) == Stmt.NoOp`. If it fails, `stmt_to_value` needs to short-circuit to `value_for_stmt(s)` directly.

8. **metadata.bin / @marshal-binary** — if comptime macro return values flow through marshal, the Value's `type_id` field gets serialized. Per P2, the receiver may not share the producer's registry. Verify the marshaler either (a) doesn't carry Value across processes (likely safe — comptime is intra-process), or (b) carries the canonical name alongside the id for safe rehydration.

## Pitfalls and operational notes

1. **`stmt_payload: Stmt?` + Phase A short-circuits stay.** Phase A is a strict prerequisite — `value_to_stmt`'s `if v.kind == "stmt"` branch is what makes Phase B's native boxing observable. Don't revert Phase A files.

2. **Seed cycles cost ~3 min each.** Phase B1 needs one (AST variant field add). Run `make seed-patch-traps` BEFORE `make build`. Run `make update-seed` after build succeeds. If build fails after seed-patching: stop, answer the four diagnostic questions in `CLAUDE.md`, don't re-throw the seed.

3. **Pre-commit currently runs full suite — ~2 min cold with jdgo's continuous dispatch.** Use `AVRA_JOBS=4` when committing if heat/RAM is a concern. The user has previously reported a machine crash from full-parallel cold suites under heavy memory pressure.

4. **Don't try to do B1+B2+B3 in one commit.** Each is genuinely independent, has its own build checkpoint, and isolates regression. The temptation to bundle is strong — resist.

5. **One known flake risk:** `walker_valuetype_test` and a handful of walker tests are the slowest shards (~80s each cold). If any of them fail post-B4, the natively-boxed Value isn't matching the legacy decoder's behavior on a specific variant — diff the variant against `enum_value_to_stmt`'s arm list and check the `type_id` propagation.

6. **Phase A spec test (`so07_8_phaseA_value_for_stmt_test.av`) keeps passing through all phases** — it doesn't touch `enum_type` directly. Use it as a tripwire: if it fails, the Value field additions broke the basic constructor contract.

7. **Don't migrate the encoders (`construct_stmt`, `construct_expr` in `quote_expr/lower.av`) in this epic.** They're the symmetric counterpart — encoding native Stmt back to source-form EnumCtor for splice. Per B5's "keep type_name" decision, they continue emitting strings; the resolver fills type_id post-encode. A future epic can migrate the encoder if/when the parse-time → resolve-time threading is reworked.

## Acceptance for so07.8 close

- All six phases (B0–B5) shipped.
- `grep '"@std::avrac::core::Stmt"' packages/std-avrac/src` returns hits only in `type_registry_register` calls (initial naming), display/diagnostic rendering, and the kept Value/EnumCtor name slots. NOT in dispatch sites.
- Phase A spec + all so07-related specs pass.
- Selfhost fixed point holds.
- so07 epic can close (all 8 children closed properly per rule 19/20).

---

# Stretch architecture (what shipping the migration enables)

The five phases above are TABLE STAKES — they bring Avra to parity with rustc/Swift/Roslyn/Go/OCaml. They're the prerequisite. The stretches below are where Avra exceeds those compilers. Each stretch is independently shippable after B5 and addresses a limitation no production compiler has solved.

The stretches are listed in order of independence (B6 can ship without B7-B9; B7 depends on B6's IDs being content-addressed for cache stability; etc.).

## Stretch B6 — Content-addressed TypeId (cryptographic, cross-process, cache-stable)

**Problem.** Today's TypeId is an incrementing integer. Two registries assign different IDs to the same type. bs2 might assign Stmt=47, bs3 might assign Stmt=51. IDs are meaningless across processes, across compilations, across machines.

**Solution.** `TypeId = blake3(canonical_serialization(TypeDefinition))`. Recursive types resolved via Merkle-style fixed-point hashing — same trick git uses for trees, IPFS uses for DAGs, Unison uses for code identity.

**What this beats.**
- rustc's `DefId` (crate-local, opaque, unstable across builds)
- Swift's `NominalTypeDecl*` (pointer-local, dies with process)
- OCaml's `Ident.stamp` (process-local counter)
- Go's `*Named` (pointer identity, breaks on generic instantiation)

**What you get.**
- Same type → same TypeId on every machine, every build, every day. Deterministic.
- Distributed compilation: machine A computes `decode_stmt(v)` and uploads to a remote cache; machine B looks up by TypeId hash, hits cache. Zero coordination.
- Fixture cache survives bs2 rebuilds where Stmt's structure is unchanged — today's invalidation is bs2-hash-based and re-runs walker tests for 80s; content-addressed would invalidate ONLY when Stmt's structure changes.
- Migration tooling: "find all decoders that match THIS specific historical Stmt shape" is a cache query.
- P2's concern about Values crossing processes disappears — TypeIds are universal.

**Cost.**
- Hash computation per type at registry-population (one-time, ~µs per type, negligible).
- Canonical serialization needs to be byte-stable — comment whitespace, field-declaration-order normalization. Doable but pedantic.
- Cyclic types need the Merkle fixed-point algorithm; ~200 lines of math.

**Path from B5.** TypeRegistry already exists. Replace `assign_id = ++counter` with `assign_id = blake3(canonical_form(type))`. The migration's threading + dispatch stay identical — only the ID source changes. Bazel + Nix + Unison all built whole systems on this primitive; we'd be the first compiler to use it for *type identity*.

**Acceptance.**
- TypeIds are deterministic across `make clean && make build` cycles.
- A Value's `type_id` is meaningful across processes (verifiable by writing a serialize/deserialize round-trip test using `@marshal-binary`).
- The fixture cache survives an unrelated bs2 commit (e.g., a perf tweak in `runtime.c`) without invalidating walker fixtures.

## Stretch B7 — Bidirectional codecs (encoder/decoder generated from ONE source of truth)

**Problem.** Today `construct_stmt` (encoder) and `enum_value_to_stmt` (decoder) are two ~400-line hand-written dispatchers that must mirror each other. Drift is silent. The Stmt.Let.resolved_vt-dropped bug, the missing-NoOp/Break/Continue cases, the Assign omission — these were ALL drift bugs that hit production.

**Solution.** A single `@codec` derive macro generates BOTH encoder and decoder from one Schema. Modifying the Stmt enum modifies BOTH automatically.

```
@codec
enum Stmt {
    Let(name: string, ty: ValueType, init: Expr)
    If(cond: Expr, then: Stmt, else: Stmt?)
    // ...
}
// → autogen: construct_stmt, enum_value_to_stmt, AND a compile-time
//   assertion that decode(encode(s)) == s for every variant.
```

**What this beats.**
- Rust's `serde` (still requires separate `#[derive(Serialize, Deserialize)]`, no synthesis proof)
- Haskell's Aeson (manual `FromJSON`/`ToJSON`, no roundtrip guarantee)
- Boomerang (bidirectional but research-only)
- protobuf reflection (runtime, not compile-time)
- Avra's own y9y4 `derive_walker` (one-directional — only the walker, not the codec)

**What you get.**
- Adding a Stmt variant requires zero changes to encoder/decoder. Period.
- The compiler refuses to compile if you somehow break the roundtrip. The Stmt.Let.resolved_vt-dropped bug (4-times-bitten per the so07.8 ticket history) becomes unrepresentable.
- Schema migrations: when a variant is added, OLD cached values (without the new field) decode to a sentinel; warnings surface where defaults are needed.

**Cost.**
- Compile-time generation needs Avra's macro system to be powerful enough — `@expand(derive_walker)` is the prototype, and B0's relocation of the decoder makes it easier to reason about.
- The bidirectional definition format is non-trivial syntax design — what does "and the decoder for a recursive position knows it's recursive" look like?
- Generated code needs to be debuggable. `bs2 expand-macros file.av` should show the generated codec source.

**Path from B5.** y9y4's `derive_walker` is the gateway. Add `derive_codec` as a sibling macro. The encoder + decoder become generated functions. Phase D of so07.8 ("delete the encoder + decoder") becomes literal — they were never written, just synthesized.

**Acceptance.**
- A new Stmt variant added by editing only `core/ast.av` requires no encoder/decoder edits to compile + pass tests.
- `decode(encode(s)) == s` is a compile-time assertion (an `@invariant` block) on the codec macro.
- All existing handwritten codecs deleted; their tests still pass against the generated codec.

## Stretch B8 — Dependently-typed `Value<T>` (eliminate dispatch entirely)

**Problem.** Today `Value` is type-erased; "is this a Stmt?" is a runtime question with possible failure (`Stmt?` return type, nullable). The type system doesn't help.

**Solution.** Parameterize Value by its inner type. `Value<Stmt>` is a different TYPE from `Value<Expr>`. The compiler proves at compile time which decoders apply. Decoders become infallible.

```
fn value_for_stmt(s: Stmt) -> Value<Stmt>          // INFALLIBLE
fn value_to_stmt(v: Value<Stmt>) -> Stmt           // INFALLIBLE — no Option, no null
```

The 21-function decoder collapses to ONE generic implementation:

```
trait DecodeFromValue {
    type Target
    fn decode(v: Value<Self::Target>) -> Self::Target
}
impl DecodeFromValue for Stmt { type Target = Stmt; ... }
impl DecodeFromValue for Expr { type Target = Expr; ... }
```

**What this beats.**
- rustc's `dyn Any` + `TypeId::of::<T>()` (runtime check, returns Option)
- Swift's `as?` cast (runtime check)
- Go's type-switch (runtime dispatch)
- Lean/Idris do this for proofs but not for compilers

**What you get.**
- `value_to_stmt` cannot return null. The type system makes the failure case unrepresentable.
- The eval interpreter knows AT COMPILE TIME which boxing to use. No runtime dispatch.
- The encoder/decoder symmetry is compile-checked: `value_to_stmt(value_for_stmt(s)) == s` is a typeclass law the compiler enforces.
- Generic code works: `fn round_trip<T: DecodeFromValue>(v: T) -> T` works for any AST type.
- Eliminates the `?` operator from value_to_stmt callers — every decode becomes infallible.

**Cost.**
- Requires Avra's generics to support trait-level dispatch — partly there via `dyn Trait` and `impl Trait for Type`. The remaining gap: type-level dispatch on parameter T inside trait impls.
- The Value type becomes `enum Value<T> { Stmt(T) where T: AstNode, Expr(T) where T: Expr, Primitive(PrimValue), ... }` instead of a struct — bigger refactor than Phase B itself.
- Some legitimately-untyped cases (heterogeneous lists in macro returns) need `Value<Any>` or a sum type — preserves the runtime question for that subset.

**Path from B5.** Phase B's `value_for_stmt(s) -> Value` becomes `value_for_stmt(s) -> Value<Stmt>` once Avra's generics can carry the type parameter through the constructor. This is a parser/typeck change in Avra itself, not just the eval layer.

**Acceptance.**
- `value_to_stmt`'s return type is `Stmt`, not `Stmt?`.
- A test that compiles `value_to_stmt(value_for_expr(e))` is rejected by the typechecker (mismatched type parameter).
- Generic round-trip tests pass.

## Stretch B9 — Memoized decoder + content-addressed Value identity (Salsa + Unison)

**Problem.** Decoding a Value is pure (deterministic from input). But today every decode call re-walks the variant dispatch. For deeply-nested Values (e.g., a Stmt.Block containing nested Stmts), every decode is O(size). Across compilations, identical Values get re-decoded.

**Solution.** Combine B6's content-addressed TypeIds with the qvfb-epic's demand-driven memoization. Each Value gets a content-hash. The decoder is a memoized query:

```
@query fn decode_stmt(v_hash: Hash) -> Stmt? { ... }
```

Two Values with the same content hash → same decoded result, cached. Two compilations sharing a cache → second compilation pays zero decode cost.

**What this beats.**
- rustc's incremental compilation (per-crate cache, per-build-machine)
- rust-analyzer's salsa (in-process only, doesn't persist to disk)
- Bazel remote cache (caches build outputs, not intra-compile queries)
- No production compiler memoizes intra-compile semantic queries with content-addressed keys.

**What you get.**
- The decoder runs once per UNIQUE Value across ALL builds across ALL machines that share a cache.
- The "walker_valuetype_test takes 79s" problem: most of those 79s is decoding the same Stmt shapes. With content-addressed memoization, the second build pays ZERO decode cost — cache hits on identical Value hashes.
- Distributed CI: developer A's local cache contains the decoded forms; developer B's CI just downloads them.
- Memoization transitively reduces re-eval cost: a comptime fn that produces the same output for the same input is itself memoized.

**Cost.**
- Cache size grows. Need eviction (LRU by access time) — same as bs2's existing build/cache eviction infrastructure (cbg3.1).
- Hash computation is O(value size). For deeply-nested values, can be expensive. Memoization of hash itself solves this — `hash(v) = hash(tag, hash(payload[0]), hash(payload[1]), ...)` with each sub-hash cached.

**Path from B5 + B6.** The qvfb epic already commits to demand-driven memoization. B9 adds the content-addressed key axis. The decoder becomes one of qvfb's many memoized queries.

**Acceptance.**
- Walker tests run in O(unique Stmt shapes) wall time, not O(test count × shape).
- A test that re-runs immediately after the previous run takes < 100ms (cache hit on every decode).
- Cross-developer cache sharing via shared volume: developer B's first run after a registry update reads decoded Values from developer A's cache.

---

## Combining the stretches

No production compiler today has even TWO of these together. The combination unlocks emergent properties beyond any individual stretch:

- **B6 + B7 (content-addressed + bidirectional codec)** → a Stmt cached on machine A can be safely consumed on machine B without re-validation. The hash IS the validation. Generated codecs verify roundtrip at compile time AND identity at runtime.

- **B8 + B9 (dependent `Value<T>` + memoized)** → calling the decoder is a type-level guarantee of correctness AND O(1) amortized. The compile-time proof eliminates runtime checks; the cache eliminates re-computation.

- **B6 + B9 (content-addressed + memoized)** → distributed incremental compilation. CI runs in seconds. The cache becomes a shared substrate.

- **B7 + B8 + B9 (codec + dependent + memoized)** → adding a Stmt variant is one line of code that automatically updates the encoder, decoder, type parameterization, and cache schema. No drift, no runtime checks, no re-computation.

## What this would mean for Avra

Avra would be the only production compiler that combines:
- Cryptographic, deterministic type identity (B6)
- Compile-time-verified bidirectional codecs (B7)
- Dependently-typed runtime values (B8)
- Distributed, content-addressed query memoization (B9)

No language today does this. Rust has DefId-based identity (process-local), serde codecs (drift-prone), `dyn Any` (runtime checked), and crate-local incremental (build-machine-local). Swift has pointer-identity, manual `Codable`, runtime `as?`, and no caching. Roslyn has reference-identity, no roundtrip guarantee, runtime dispatch, and no incremental cache. Each combination beats them on a dimension; the FULL combination is unprecedented.

The original migration (B0–B5) is the table stakes. The stretches are how Avra makes a generational leap.
