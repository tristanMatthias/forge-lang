# sh48 — Structure-content-addressed TypeId (Merkle): design + consumer gate

Spine: `docs/2026_06_14_AST_SOURCE_OF_TRUTH_EPIC.md` §Layer-3 / §Layer-6.
Tickets: `sh48` (this design + eventual impl), builds on `wc5w` (name-content
addressing, DONE), consumed by `ps3t.8` (L6 compiler-as-query / codegen cache).

Predecessor briefing: `docs/2026_06_02_SO07_8_TYPEID_MIGRATION_BRIEFING.md`.

## TL;DR (the decision)

1. **Do NOT replace the nominal TypeId with a structure hash.** The nominal
   TypeId (`content_id_for(FQN)`) is a load-bearing correctness primitive, not a
   cache key. Replacing it is the highest-blast-radius change in the compiler and
   buys nothing for identity correctness (nominal identity IS name-keyed by
   design; see §2).
2. **Add the structure hash as a SEPARATE, ADDITIVE fingerprint** —
   `type_structure_fingerprint(reg, id) -> int` — computed by Merkle
   fixed-point over the type graph. It is a *cache-invalidation key*, orthogonal
   to identity.
3. **Gate the implementation on its consumer (`ps3t.8`).** The only thing the
   structure fingerprint buys over the name hash is *finer-grained cache
   invalidation*, and the cache layer that would key on it — the L6 query engine
   / per-fn codegen cache — does not exist yet. Building the fingerprint before
   that consumer exists is speculative machinery (the exact anti-pattern
   `ps3t.3.5` Inc-2 deferred against for the same reason). `sh48` stays OPEN,
   gated on `ps3t.8`, with this design as the de-risking artifact.

## 1. Where identity lives today (code-grounded)

`wc5w` shipped **name**-content-addressed identity. One primitive:

- `core/type_registry.av:38` — `content_id_for(qualified_name) -> int` =
  FNV-1a-64 of the FQN. Deterministic across processes/machines/builds.

It is load-bearing at three chokepoints, all of which require the id to be a
pure function of the **name** and to agree in-process and on-disk:

- `type_registry_register` (`type_registry.av:133`) stamps
  `id = content_id_for(name)` and hard-`panic`s on an id collision under a
  different name (nominal identity must never alias).
- `build::metadata::sym_id_for` (`metadata.av:218`) **delegates** to
  `content_id_for` — so the in-process TypeId and the on-disk symbol id are ONE
  value. Cross-unit metadata references resolve by recomputing the hash from the
  name.
- `vtype_eq` compares nominal identity by this id, kind-agnostically — the
  `24yd` fix (a resolved `Newtype("X")` and a parser-default `Struct("X")` of the
  same FQN are equal because both stamp to `content_id_for("X")`).

Guarded by `core/tests/wc5w_content_addressed_typeid_test.av`: determinism,
cross-registry stability, sparse-id round-trip, kind-agnostic nominal equality.

## 2. Why identity must stay name-keyed (not structure-keyed)

Avra is a **nominal** type system (spec Axes 1–8). `type UserId = UUID` and
`type ProductId = UUID` are DISTINCT types with identical structure. Identity
therefore must be keyed by the FQN, never by structure alone — structure-only
hashing would wrongly collide every newtype over the same inner type.

sh48's own framing agrees: structure-addressing is "NOT identity correctness and
not needed for 24yd." So the FQN remains the primary discriminator. A structure
hash that *included* the FQN would preserve nominal distinctness — but then it is
no longer "the identity"; it is a strictly-more-invalidating key that changes on
BOTH name and structure change. That is fine for a cache key and wrong for the
`vtype_eq` identity used across compilation units (see §3).

## 3. Why replacing the TypeId is unsafe now (the cross-unit trap)

If `type_registry_register` computed `id = hash(FQN + structure)` instead of
`hash(FQN)`, then **every** producer and consumer of that id would have to
reconstruct a **byte-identical** canonical serialization of the type's full
structure:

- The producer (`@std`) registers `core::Stmt` and hashes its structure.
- A consumer that imports `core::Stmt` via `metadata.bin` must recompute the
  identical structure hash — from metadata alone — or `vtype_eq` fails and
  `sym_id_for` diverges from the in-process id.
- `sym_id_for` currently hashes only the *name* (a string it always has). To
  keep in-process == on-disk it would need the full structure at every symbol
  reference, including forward/partial references during resolution.

The failure mode is **silent metadata corruption** (mismatched ids → wrong
symbol resolution / stale-metadata reads), which diff-test does NOT catch
(structure hashes, like name hashes, never reach emitted IR). This is a large,
risky migration whose payoff is a P3 Layer-6 optimization. The additive design in
§4 sidesteps it entirely: identity stays name-keyed and untouched; the structure
fingerprint is a separate value used only where finer invalidation is wanted.

## 4. The additive design: `type_structure_fingerprint`

A pure, separate primitive in `core/type_registry.av`, computed from the
`TypeRegistry` contents. Nominal identity (`content_id_for`) is unchanged.

```
// id -> stable 64-bit hash of the type's STRUCTURE (fields/variants/inner),
// with the FQN mixed in as the nominal discriminator. Changes iff the type's
// structure (or name) changes. Merkle fixed-point over the type graph.
export fn type_structure_fingerprint(reg: TypeRegistry, id: int) -> int
```

### 4.1 Canonical serialization of one type (one Merkle step)

`canonical_serialization(reg, info, child_hash: fn(int) -> int) -> bytes`:

- Prefix the **FQN** (nominal discriminator) and the **TypeKind** tag.
- **Struct/Shape**: fields **sorted by name** (order-independent — field
  reordering in source must not change the hash; the layout is name-keyed via
  named LLVM structs already). For each field: `name` + a canonical rendering of
  its `ValueType`.
- **Enum**: variants **sorted by name**; each variant: `name` + its payload field
  list (same field rule).
- **Newtype/UnionAlias**: the `inner_vt` rendering.
- A `ValueType` renders via a canonical form (extend `vtype_render_full`):
  - Scalars (`Int`, `Bool`, `Str`, …) → their fixed tag.
  - `Struct(name, type_args, id)` / `Enum(name, type_args, id)` → **the child's
    fingerprint** `child_hash(id)` (NOT its name) + recursively-rendered
    `type_args`. This substitution is what makes it a *structure* hash: `Box`'s
    fingerprint depends on the fingerprint of its element type, transitively.
  - `List`/`Map`/`Tuple`/`Fn`/`Closure` → tag + rendered children.
- Length-prefix every variable-length part (collision-safe framing — the same
  discipline `value_cache_part`/`value_cache_list` use in `comptime/eval.av`).

Note: `ValueType.Struct/Enum` reference nested types **by name+id**, not by
inlined structure (`ast.av:502`). So the *naive* serialization is already
cycle-free (a `Stmt` field of type `Expr` renders as "Expr"). The Merkle step
(substituting `child_hash(id)` for the name) is what introduces the recursion —
and hence the need for a fixed point (§4.2) over mutually-recursive graphs like
`Stmt ↔ Expr`.

### 4.2 Merkle fixed-point over recursive type graphs

`Stmt` contains `Expr` contains `Stmt` — a cycle. A single pass can't hash a
type whose children aren't hashed yet. Use the standard iterate-to-fixed-point
scheme (git's tree hashing handles DAGs; type graphs have cycles, so iterate):

1. **Init**: `hash[id] = content_id_for(FQN)` for every registered type (the
   name hash as the seed — guarantees a deterministic starting point and nominal
   distinctness even before structure converges).
2. **Iterate**: recompute `hash'[id] = fnv(canonical_serialization(reg, info,
   λ cid → hash[cid]))` for all ids, reading children from the PREVIOUS round's
   `hash`.
3. **Converge**: repeat until `hash' == hash` for all ids (a round with no
   change), or a fixed iteration cap `= number of types` (a Merkle fixed point
   over N nodes stabilises in ≤ N rounds; the cap is a determinism backstop, not
   an approximation — if it's ever hit, that's a bug to assert on, not silently
   accept).
4. Result: `type_structure_fingerprint(reg, id) = hash[id]` at convergence.

Determinism holds because: registration set is deterministic; field/variant
order is normalised (sorted by name); iteration reads the whole prior map (no
visitation-order dependence); FNV is pure. Two `make clean && make build` cycles
produce identical fingerprints (acceptance #1) by construction.

### 4.3 Complexity / when to compute

O(N²) worst case (N rounds × N types), N ≈ low hundreds for `@std::avrac::core`
— trivial, and computed ONCE per registry after all types are registered (a
`finalize` pass), not per-lookup. Cache the converged map on the registry.

## 5. Acceptance-criteria mapping

| sh48 acceptance | This design |
|---|---|
| Two `make clean && make build` → identical structure ids for Stmt/Expr/ValueType | §4.2 determinism (sorted fields, whole-map iteration, pure FNV) |
| Mutually-recursive types hash via Merkle fixed-point (no infinite loop) | §4.2 iterate-to-fixed-point with N-round cap + convergence assert |
| Nominal distinctions preserved (UserId ≠ ProductId) | §2/§4.1 FQN mixed in as primary discriminator |
| Selfhost + diff-test byte-identical | additive fingerprint never reaches IR; identity path untouched → byte-identical by construction |
| Changing a type's fields changes its id; unrelated type unchanged | §4.1 field rendering + §4.2 transitive propagation (a change flows only to dependents) |

The one criterion sh48's *sketch* stated — "id = hash(structure) **instead of**
hash(FQN)" — is deliberately NOT met: §2/§3 show replacing the nominal id is both
unneeded (identity is name-keyed) and unsafe (cross-unit reconstruction). The
fingerprint is additive. This is a scope correction of the ticket sketch, not a
shortfall — the cache-invalidation *payoff* is fully delivered by an additive
fingerprint; only a future consumer that literally wants "the TypeId is its
structure hash" would need more, and no such consumer is planned (L6 keys caches
on a fingerprint, it does not need identity to be that fingerprint).

## 6. The consumer gate (why this stays OPEN, unbuilt)

The fingerprint's sole benefit is finer cache invalidation: today's caches key on
a coarse compiler-binary / source hash (`fixture_stdout`, metadata slots), so any
compiler change invalidates everything. A per-type structure fingerprint lets a
cache invalidate only the consumers of a *changed* type.

That consumer is **`ps3t.8` [L6] — compiler-as-query / interface fingerprints /
per-fn codegen cache**, which is OPEN and unstarted. Until it exists there is
nothing to key on the fingerprint, so shipping it now is speculative machinery —
precisely the sequencing `ps3t.3.5` Inc-2 recorded and deferred against ("the
id-equality payoff needs the L6 consumer; standalone = speculative machinery").

**Sequencing**: implement `type_structure_fingerprint` (§4) as the FIRST slice of
the `ps3t.8` interface-fingerprint work, WITH the cache layer that consumes it —
one increment, one proof (a cache hit survives a compiler change that leaves the
relevant type's structure unchanged; a field edit busts exactly that type's
dependents). Not before.

## 7. Risks / open questions for the implementation slice

- **`type_args` on generic instances**: monomorphized `Box<int>` vs `Box<string>`
  — the fingerprint must distinguish them (their structures differ). §4.1 renders
  `type_args` recursively, so it does; confirm against the mono registry's naming
  when the slice lands.
- **Shapes (structural types)**: `ShapeKind` has no nominal FQN discriminator by
  design (width-subtyping). Decide whether shapes get a structure-only
  fingerprint (probably yes — they're already structural) — but keep them out of
  the nominal `content_id_for` collision-panic path.
- **Field-order normalisation vs codegen layout**: codegen uses named LLVM
  structs keyed by field name (not source order), so sorting fields for the hash
  is safe; double-check no pass depends on declaration order surviving into a
  layout the fingerprint claims is unchanged.
- **Collision bound**: i64-truncated FNV, same bound `content_id_for` already
  carries and metadata already trusts. Acceptable; document it, don't re-litigate.
