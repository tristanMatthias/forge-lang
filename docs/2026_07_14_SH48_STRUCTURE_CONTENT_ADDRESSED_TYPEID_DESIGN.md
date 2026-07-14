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

```text
// id -> stable 64-bit hash of the type's STRUCTURE (fields/variants/inner),
// with the FQN mixed in as the nominal discriminator. Changes iff the type's
// structure (or name) changes. Cycle-safe canonical graph hash (§4.2).
export fn type_structure_fingerprint(reg: TypeRegistry, id: int) -> int
```

**Value semantics.** Like `content_id_for`, the result is a *signed* i64
(FNV-1a-64 truncated — frequently NEGATIVE; never test it with `> 0`). `0` is a
LEGAL fingerprint value, so consumers MUST NOT overload it as an "uninitialised"
sentinel or use positivity as a "computed" check — track computed-vs-absent
separately (the map's has-key probe, a presence bit), exactly as the registry
already tests "stamped" as `id != 0` only because it reserves 0, which this
primitive does NOT.

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
cycle-free (a `Stmt` field of type `Expr` renders as "Expr"). Substituting a
child's *hash* for its name is what makes it a true structure hash — and what
introduces the recursion over mutually-recursive graphs like `Stmt ↔ Expr`.
§4.2 makes that substitution cycle-safe.

### 4.2 Cycle-safe canonical graph hashing (NOT fixed-point iteration)

`Stmt` contains `Expr` contains `Stmt` — a cycle. The tempting "iterate
`hash'[id] = F(hash)` until `hash' == hash`" scheme is **wrong**: a hash
recurrence has no fixed-point guarantee — even a one-node self-reference
`h' = fnv(F(h))` need never satisfy `h' == h`, and a cap of *N* rounds does not
bound convergence (it can enter a non-fixed cycle, or leave a valid recursive
type with an arbitrary capped value). Do NOT iterate to a fixed point.

Instead, hash the **type-reference graph canonically**, the way recursive
structures are content-addressed in practice (Tarjan SCC + canonical
within-cycle ordering — a total function of the graph, no iteration):

1. **Build the reference graph**: node = registered type; edge `A → B` when a
   field/variant/inner `ValueType` of `A` references type `B` (by id). This is
   the graph whose cycles §4.1's child-hash substitution must survive.
2. **Condense to SCCs** (Tarjan): each strongly-connected component is either a
   single acyclic type or a maximal cycle (e.g. `{Stmt, Expr}`). The condensation
   is a DAG.
3. **Hash the SCC-DAG bottom-up** in reverse-topological order. For an edge that
   leaves the current SCC (a reference to an *already-hashed* SCC), substitute
   the **referenced SCC's digest** for the type name (the real Merkle step —
   acyclic, so the child digest is available).
4. **Within an SCC, break the cycle by canonical position, not by hash.** Order
   the SCC's members deterministically (sort by FQN). A reference to a *fellow
   SCC member* serialises as its **SCC-local index** (`#0`, `#1`, …) — a value
   that exists without hashing the not-yet-hashed member. Concatenate every
   member's §4.1 serialization (in FQN order, intra-SCC refs encoded as local
   indices, cross-SCC refs as child SCC digests) into ONE canonical byte string;
   `scc_digest = fnv(that string)`.
5. **Distribute** each member's fingerprint from the whole-SCC hash + its local
   index: `fingerprint[member] = fnv(scc_digest ++ local_index ++ FQN)`. The FQN
   suffix keeps the nominal distinctness of §2 even for two members of the same
   cycle; the `scc_digest` makes the fingerprint depend on the *entire* cyclic
   structure (so a field change anywhere in the cycle moves every member — the
   acceptance "changing fields changes the id" holds, conservatively, across a
   whole SCC).

This is a **total function of the registry** — no iteration, no convergence
question, guaranteed to terminate (SCC condensation + one bottom-up pass).
Determinism: the registration set is deterministic; SCC membership is a graph
invariant; field/variant order and SCC-member order are normalised (sorted by
name/FQN); FNV is pure. Two `make clean && make build` cycles therefore produce
identical fingerprints (acceptance #1) by construction.

### 4.3 Complexity, lifecycle, and the mutation contract

O(V + E) for Tarjan + one bottom-up hashing pass — trivial (V ≈ low hundreds for
`@std::avrac::core`). Computed ONCE, by a `type_registry_finalize(reg)` pass that
runs **after all types are registered**, and cached on the registry.

**The cache is only valid on a frozen registry.** `TypeRegistry` is mutable —
`type_registry_register` appends entries — so a fingerprint computed before a
later registration would be stale (a new type can add an edge into an existing
SCC and change its digest). The contract, therefore:

- `type_structure_fingerprint` is defined ONLY after `finalize`. `finalize` sets
  a `frozen` flag; a `type_registry_register` on a frozen registry is an ICE
  (F9999), not a silent re-open — registration and fingerprint-consumption are
  distinct phases (resolve populates; later passes read), matching how the
  compiler already sequences the registry.
- If a future caller genuinely needs post-finalize registration, the fallback is
  cache **versioning** (a monotonic registry epoch stamped into each cached
  fingerprint; a mutation bumps the epoch and invalidates), NOT in-place mutation
  of a live cache. Freeze-at-finalize is the recommended default; versioning is
  the escape hatch, spelled out so the implementer doesn't invent a third thing.

## 5. Acceptance-criteria mapping

| sh48 acceptance | This design |
|---|---|
| Two `make clean && make build` → identical structure ids for Stmt/Expr/ValueType | §4.2 determinism (deterministic registration set + SCC invariance + normalised order + pure FNV) |
| Mutually-recursive types hash via Merkle fixed-point (no infinite loop) | §4.2 cycle-safe canonical graph hash (Tarjan SCC + local-index cycle break) — a total function, terminates by construction, no iteration |
| Nominal distinctions preserved (UserId ≠ ProductId) | §2/§4.1 FQN mixed in as primary discriminator (and re-mixed per-member in §4.2 step 5) |
| Selfhost + diff-test byte-identical | additive fingerprint never reaches IR; identity path untouched → byte-identical by construction |
| Changing a type's fields changes its id; unrelated type unchanged | §4.1 field rendering + §4.2 cross-SCC digest propagation (a change flows to the type and its dependent SCCs only) — modulo the collision caveat in §7 |

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
- **Collision handling is NOT the same as nominal identity's, and this matters.**
  `content_id_for`'s i64 collision is caught and `panic`ed at registration
  (`type_registry_register`) because BOTH conflicting FQNs are present there to
  compare. A fingerprint used as a **cache key** has no such moment: two distinct
  structures colliding to the same i64 would produce a **false cache HIT** —
  serving one type's stale cached output for another — which silently violates the
  "changing fields changes the id" acceptance. So the consuming cache (ps3t.8)
  MUST NOT trust the 64-bit fingerprint alone as a hit. Required discipline (pick
  per the consumer, spelled out so the implementer doesn't skip it):
  - **Verify on hit** — store the canonical serialization (or a second,
    independent digest) alongside the cached entry; a fingerprint match is only a
    *candidate*, confirmed by structural/second-digest comparison before reuse.
    This is the same two-tier "fast bucket key + content-compare on collision"
    discipline the content-hash interning already uses (`content_hash.av`), and it
    turns a collision into a benign cache MISS, never a wrong hit.
  - **Or widen the digest** — a 128-bit digest drives collision probability below
    any realistic build's type count; combine with verify-on-hit for cache
    entries whose staleness would be a correctness bug (not just a perf loss).
  The nominal path keeps its cheap i64 + panic (a collision there is a build-time
  rename, not a silent corruption). Do not paper over this asymmetry by citing
  "metadata already trusts i64" — metadata trusts it for *identity* (panic-guarded),
  not for a *silent cache hit*.
