# Avra as a Systems Language — Program Design

**Status:** design / exploration (worked through 2026-07-17)
**Builds on:** `docs/idea_scoped_abstraction_levels.md` (the levels proposal),
spec Axis 9 + its Architectural Summary (`docs/2026_04_18_FULL_SPEC.md:1070-1798`),
Axis 11/13/15/18/25/26/31, `docs/TRD_V1.md`, and the ps3t spine
(`docs/2026_06_14_AST_SOURCE_OF_TRUTH_EPIC.md`).
**Question answered:** what — philosophically and practically — does it take for
Avra to be a systems language a crusty Hacker News commenter grudgingly calls
"legit", while staying the one language that spans GPIO to cross-platform UI?

---

## 0. TL;DR (the six answers)

1. **The pieces are mostly already decided, not designed-in-detail.** Spec Axis 9
   locked the four levels, the boundary rule ("app is refcounted, systems is
   owned, the boundary is a borrow"), sized ints, `bare` as the only unsafe
   escape, tiered FFI, and ten architectural commitments. What's missing is the
   *systems-language substrate* around them: a layered runtime (`core`/`alloc`/
   `std` split), cross-compilation, freestanding targets, layout control, and —
   most urgently — **honesty**: raw pointer ops are live and ungated *today*, so
   Avra currently has C's unsafety with none of the gating we advertise.
2. **The HN test is passed with artifacts, not claims.** The milestone that
   converts skeptics is a blinky + serial echo on an RP2040, compiled by
   `avra build --target thumbv6m`, with `avra size` showing no RC runtime in the
   binary and readable disassembly. Everything in this doc sequences toward
   that artifact.
3. **No, we do not rewrite the compiler for memory safety — we rewrite the
   *runtime*.** The compiler is already self-hosted Avra running on real RC
   (audited below). The unsafe kernel is `runtime.c` (~1900 lines of C) +
   `llvm_wrapper.c`. The end-state is those becoming `systems`/`bare`-level
   Avra — the systems level's flagship dogfood — not a borrow-checked compiler.
4. **ps3t is an ally, not a casualty.** Arena + typed-id ASTs (`ExprId` into a
   store) are *exactly* the pattern that makes low-level code safe without
   borrow checking — indices can't dangle into a live arena. ps3t makes the
   compiler *more* systems-ready. The couplings are narrow and listed in §6.
5. **Yes, borrow checking + app-level RC can genuinely coexist** — Swift, Nim,
   Koka, and Lobster each ship half of it; the spec's boundary-is-a-borrow rule
   is sound. Avra's opportunity to *simplify rather than clone Rust*: a
   **second-class borrow model over deep immutability** (§5.3) — borrows live
   only in parameters and locals, never in fields or returns beyond their
   scope, and immutability-by-default means the checker only reasons about
   `mut`. No lifetime annotations, ever, in v1.x. That is the collapsed
   paradox: Rust-grade guarantees where they matter, Python-grade ceremony.
6. **Beyond memory**, the systems checklist is: layered stdlib, C FFI in both
   directions, cross-compilation + freestanding entry, explicit layout
   (`@packed`/`@align`/`@repr(c)`), volatile MMIO, const generics, allocator
   parameterization, panic strategy, atomics without the green-thread runtime,
   and toolchain credibility (DWARF, sanitizers, `avra size`/`avra asm`). §7.

---

## 1. Where we actually are (audited 2026-07-17, not aspirational)

The gap analysis below is the doc's foundation. "Spec" = decided in the full
spec; "Real" = verified in the working tree.

| Piece | Spec says | Reality today |
|---|---|---|
| RC runtime | Axis 9.1: app level = RC + arenas + cycle detection | **Real.** `avra_rc_alloc/retain/release` with 8-byte headers, frees at zero, trial-deletion cycle collector (`runtime.c:381-591`). Escape-guided: retains at aliasing points (`with`, match bindings, channel send), releases via escape analysis (`codegen/escape.av`) + unified defer/errdefer/release LIFO stack |
| Arenas | Axis 9.6: compiler-detected + provider scopes | Bump arena exists (`runtime.c:597-680`), not yet scope-aware (TRD P3-3 PARTIAL) |
| Cycle detection | 9.5 targeted mark-and-sweep, drop-site-precise | Exit-time suspect-list drain only; drop-site scheduling not implemented (P3-2) |
| Drop trait | 9.10/9.11 LIFO, interleaved with defer | `defer`/`errdefer` fully live; `Drop` trait missing (P3-6 PARTIAL) |
| Copy | 9.12 auto-derive | Implemented (P3-7) |
| Escape analysis | 9.9 stack-unless-escapes | Implemented, 440 lines (P3-5) — currently drives RC elision, not stack promotion |
| Sized ints | Axis 31.1: `i8..u128` at systems level, reserved in v1.0 | **Ahead of spec:** `U8/U16/U32/U64/I8/I16/I32` are live `ValueType` variants with real narrow LLVM layouts (`codegen/types.av:852-921`, k5al migration) |
| Raw pointers | spec_pointer_operations.md: gated to `systems`, null-checked | **Live and UNGATED.** `ptr + int`, `ptr - ptr`, `ptr[i]`, `extern malloc/free` work in plain app code; the spec'd null-guard on `ptr[i]` is not emitted. UAF/double-free expressible in ordinary code today |
| Level keywords | Commitment 10: reserve all | `systems/bare/hardware/owned/borrow/move/unsafe/ref/async/await` reserved (`Tk.KwReserved`). `level` not even reserved. No `&T` syntax anywhere |
| Borrow machinery | 9.8 phased: inferred → NLL → full | Zero implementation (correctly — v1.x scope) |
| FFI | Axis 15 tiered; C ABI v1.x | `extern fn` parses; used pervasively for the C runtime; no ownership annotations, no header emission |
| Cross-compilation | Axis 25.4 "LLVM gives multi-target" | Not mentioned in the TRD at all. Host-only today |
| Value model | typed, layout-total | **Done and load-bearing:** `resolve_layout` total constructor, `EmitValue{value, ty}`, layout-boundary lint (ps3t.4.5) |

Two takeaways:

- **The app level is real.** Avra is not "arena-leak-everything pretending to be
  RC." The memory model the spec promises for the 95% case substantially exists.
- **The bare level is real too — by accident, without the fence.** We built the
  sharp tools (pointer arithmetic, extern malloc/free, byte loads) and never
  built the `bare {}` gate the spec demands. This inverts our safety story:
  today Avra is *less* safe than advertised, and fixing that is Phase S0 (§8) —
  cheap, high-integrity, and the precondition for ever saying "safe by default"
  on HN.

---

## 2. Philosophy: what a "level" actually is

The levels doc frames levels as memory strategies. That's true but incomplete,
and the incompleteness is where boundary questions get hand-wavy. A level is
three orthogonal things bundled:

1. **A capability set** — which operations the type checker admits.
   Pointer arithmetic, `@transmute`, volatile access, inline asm are *denied*
   at app level, not "unavailable." Levels are best defined by what they
   **deny**, because denial is what the compiler can enforce and what safety
   claims rest on.
2. **A memory strategy** — who inserts retain/release/drop/free, already
   specified per level in Axis 9.
3. **A runtime dependency contract** — what the emitted code is allowed to
   *link against*. App level requires the RC runtime + green-thread scheduler.
   Systems level requires an allocator but no scheduler. Bare requires nothing.
   Hardware requires nothing *and* forbids ambient allocation.

The third axis is the one nobody has written down, and it is the one that
decides bare-metal viability. "Can this compile for an RP2040?" is not a memory
question — it's "does any code on this path require `avra_rc_alloc`, green
threads, or libc?" That is a **linkage/effect property propagated through the
call graph**, exactly like `@pure` (Axis 13.3) — and we should implement it
with the same machinery:

> **Levels are effect-like properties of items.** Every `fn` has an inferred
> (or declared) level. Calling a lower-level fn from a higher level is fine
> (app can call systems); *requiring* a higher level's runtime from a lower
> level is a compile error surfaced at the call site. `systems fn` in a
> signature is a contract, same as a declared error union (ps3t L6 decided
> signatures-are-contracts — level slots into the signature fingerprint).

This resolves several open questions from the levels doc in one move:

- **Level inference (open Q1):** infer bottom-up like `@pure`; annotations are
  contracts at public boundaries (consistent with L6's "explicit signatures at
  item boundaries").
- **Library fragmentation (HN objection 6):** a package's public API level is
  just its signatures' levels; the "app-level API, systems guts" pattern is
  automatic, not a convention.
- **Deployment targets:** a target declares its *available runtime*
  (`no scheduler`, `no allocator`); the level-effect propagation is the whole
  enforcement mechanism for "app level unavailable on bare-metal target"
  (levels doc's F0260). No separate machinery.

### The naming spectrum, restated with deny-lists

| Level | Denies (vs. level above) | Runtime required | Memory |
|---|---|---|---|
| `app` (default) | nothing new — full language | RC + scheduler (+libc) | RC + arenas + cycles |
| `systems` | implicit RC; unbounded implicit allocation in `rt` scopes | allocator only | ownership + borrows, compiler-inserted drops |
| `bare` | nothing is denied; everything is *manual* | none | manual; `@transmute`, ptr arith, asm, SIMD |
| `hardware` | reordering (volatile default), ambient alloc in ISRs | none | static + MMIO; register maps validated |

One correction to the levels doc worth locking: **`bare` is not "below"
`systems` in the deny lattice — it is the escape hatch orthogonal to it**,
exactly like Rust's `unsafe` sits beside safe code rather than below it. The
spec change-log already says this ("`bare { }` is the only escape hatch...
no `unsafe`, no `as`"). Practical consequence: `bare` blocks should be legal
*inside any level* (an app-level fn may contain a 3-line `bare` block for an
FFI call), while `systems` is a genuine semantic regime. The four-level
*marketing* story survives; the *checker* sees three regimes (app / systems /
hardware) plus one escape hatch (bare).

---

## 3. The crusty-HN checklist

What makes the graybeard say "legit." Each row maps to a phase in §8.

| # | Requirement | Why it's on the list | Status → plan |
|---|---|---|---|
| 1 | **No mandatory runtime** — a freestanding target where RC/scheduler/libc never link | "If I can't ship a 4KB binary it's not a systems language" | Missing → S4 runtime split |
| 2 | **Deterministic memory, zero hidden ops** at systems level | The Rust bar: what you write is what runs | Spec'd (9.8) → S1-S2 |
| 3 | **Sized ints + explicit layout** — `u8..u128`, `@packed`, `@align`, `@repr(c)`, bitfields | Binary protocols, drivers, wire formats | Ints DONE; layout annotations missing → S1 |
| 4 | **Raw pointers behind an explicit fence** | Both halves matter: having them, and gating them | Pointers live, fence missing → **S0** |
| 5 | **C FFI, both directions** — call C; *be* a C library (`avra build --lib c` emitting `.a` + header) | Systems code lives in a C world; also the UI story's spine (§9) | Partial → S3 |
| 6 | **Cross-compilation as a first-class flag** — `--target`, per-target std availability | Rust's `--target thumbv6m-none-eabi` set the bar | Missing entirely → S4 |
| 7 | **Freestanding entry** — no `main`-with-OS assumption, linker scripts, `@interrupt`, panic-as-abort/handler | Bare metal 101 | Missing → S4 |
| 8 | **const generics** — `Buffer<u8, 4096>` | Fixed-size buffers without heap; spec 5.5 already reserves it | Reserved → S1 |
| 9 | **Volatile MMIO + register maps** | The hardware level's substrate; import SVD, don't invent | Missing → S4 |
| 10 | **SIMD + inline asm + `@transmute`** | The bare level's payload | Missing → S3 |
| 11 | **Atomics/concurrency without the scheduler** | Axis 18's `@std/sync` assumes the runtime; MCUs need bare atomics | Missing → S4 |
| 12 | **Toolchain honesty** — `avra size`, `avra asm <fn>`, DWARF, ASan/TSan pass-through | Systems people read disassembly before believing benchmarks | Missing → S3/S4 |
| 13 | **An artifact, not a manifesto** — blinky on real silicon, measured boundary costs, published perf envelope | The levels doc promised "profile and publish. Don't handwave" | The S4 exit criterion |

Worth stating the counterfactual: none of these require inventing anything.
Every row is proven engineering with a shipped precedent (Rust, Zig, C). The
*invention* budget is spent in exactly one place — §5's borrow model — which is
also the place the spec gives us room to be simpler than Rust rather than
fancier.

---

## 4. Do we need to rewrite the compiler in safe/memory-checked code?

**No — and the question inverts.** Three facts from the audit:

1. The compiler's *logic* is already self-hosted Avra running on the app-level
   RC model. It is exactly as safe as the app level is — guarded by
   `AVRA_VERIFY_RC` (every ptr alloca null-initialized, machine-checked) and
   `AVRA_RC_STRICT` (poison-on-free, quarantine, foreign-release abort) with CI
   gates. The historical corruption class (zm77 phantom releases) is closed.
2. The remaining unsafe surface is the **C kernel**: `runtime.c` (~1900 lines)
   and `llvm_wrapper.c`. That's where allocator, string ops, channels, and
   threads live, and where a memory bug can still originate.
3. A compiler is the canonical *arena workload* — parse, build, traverse,
   discard. ps3t L1 moves the entire AST into typed-id arenas
   (`ExprId`/`StmtId` indices into append-only stores). **Index-based arenas
   are the systems-safety pattern that doesn't need a borrow checker at all** —
   an `ExprId` can't dangle while its arena lives, can't double-free, can't
   alias mutably. This is how rustc itself, Zig's compiler, and every serious
   ECS engine sidestep ownership pain.

So the meaningful version of "move the compiler to safe memory" is:

- **Short term (now):** nothing to move. Keep hardening the RC substrate
  (rcsf.4 phase arenas, rcsf.5 definite-init) and let ps3t L1 land — it
  *reduces* the compiler's exposure by replacing pointer-shaped AST plumbing
  with ids.
- **Medium term (systems level ships):** the compiler dogfoods `systems` in
  narrow, measured hot paths only — lexer inner loop, fingerprint hashing,
  SoA columnar passes. Not a rewrite; surgical blocks, exactly the incremental
  adoption story we sell users.
- **End state (the flagship dogfood):** **rewrite `runtime.c` in Avra** —
  the RC allocator, string ops, and channel machinery become `systems`/`bare`
  Avra compiled with `--no-runtime` (they *are* the runtime, so they can't
  depend on it — the same rule as Rust's `core`). The day `avra_rc_release` is
  Avra code, the "is it really a systems language" question answers itself.
  This is tracked as the S5 exit criterion, and it's also the honest test that
  the level design works: if we can't write our own allocator in it, neither
  can users.

### Effects on ps3t (the couplings, exhaustively)

ps3t is explicitly scoped to *how the compiler represents code*, not language
semantics ("the language's runtime memory model... Axis 9" is called OUT of
ps3t's boundary, §1 of the spine). The couplings are real but narrow:

1. **Levels enter typed identity (L3/L6).** A fn's level is part of its
   signature fingerprint (like the declared error union) — a level change must
   invalidate callers' type-check queries. One field in the fingerprint
   schema; decide it in `ps3t.8.1`'s fingerprint design *now* so the cache
   format doesn't churn later.
2. **Boundary instructions belong in the IR (Axis 9 Commitment 7).** Every
   call/return carries `boundary_out`/`boundary_in` (trivial same-level in
   v1.0). The deferred MIR epic (`1n1v`) must carry these as first-class
   instructions. Codegen's per-fn content-addressed caching then keys boundary
   shape for free.
3. **Strategy-dispatched memory ops (Commitment 5).** Codegen already emits
   retain/release through helpers; the requirement is that they stay
   *chokepointed* (rcsf.1's `register_rc_cleanup` discipline) so `strategy =
   systems` can slot in without a codegen rewrite. A lint ("no raw
   `avra_rc_retain` emission outside the chokepoint") is the cheap guard, in
   the same spirit as `--check-layout-boundary`.
4. **The JIT sandbox (L2) and `bare` share a policy surface.** Compiled
   comptime code must never contain `bare` operations (a comptime fn doing
   pointer arithmetic inside the compiler process is an attack surface, not a
   feature). Rule: **comptime is app-level only**, enforced by the same purity
   check that bans IO. One sentence in the L2 design; painful to retrofit.
5. **Level-aware exhaustiveness is free.** L5's no-drift + L4's derive
   framework mean the level-checker's per-node dispatch (which exprs are legal
   at which level) is derived, not hand-written — the levels work gets cheaper
   *after* L4 lands. Sequencing in §8 exploits this.
6. **Non-coupling worth stating:** the borrow checker (S1/S2) consumes typed
   AST + side tables and is naturally a *query* ("borrows of item X valid?")
   — it plugs into L6's engine as another memoized pass. No conflict; one more
   consumer.

Net: ps3t proceeds unchanged; the systems program owes it two early inputs
(fingerprint field, MIR boundary instructions) and inherits a cheaper
implementation the later it starts. That's the sequencing argument in §8.

---

## 5. The memory design: RC at app level + checked ownership at systems level

### 5.1 Can they actually coexist? (the noob-friendly answer)

Yes — this is the best-precedented part of the whole program, and the spec's
one-line rule is sound:

> App level is refcounted. Systems level is owned. **The boundary is a borrow.**

Why that works, mechanically: a borrow is a promise that a value outlives a
scope. An RC'd value's lifetime is guaranteed by its refcount — so the
enclosing app scope *holding one reference* is itself the proof the borrow
needs. Passing `&users` into a `systems` block costs zero (no retain, no copy):
the compiler pins the app-side reference for the block's extent, and the
borrow checker (which only reasons *inside* systems code) treats it like any
other borrow. Going the other way, an owned systems value escaping to app
level gets a refcount header stamped on at the boundary — a one-time cost the
spec already prices (5-20ns).

Prior art, so nobody thinks this is exotic:

- **Swift** ships ARC + ownership features (`borrowing`/`consuming` parameter
  conventions, `~Copyable` move-only types) in one language today.
- **Koka's Perceus** and **Lobster** prove RC that *becomes* ownership when the
  compiler can see uniqueness — which is what our escape analysis already does
  in embryo (it decides statically who releases).
- **Nim** (ARC + `view` types) and **C# (`Span<T>`)** prove scope-bounded
  borrows into managed memory.

Nobody has shipped the *scoped* combination — that's Avra's genuine novelty,
and it's an integration novelty, not a research bet (the spec's own honest
framing).

### 5.2 The one hard problem: aliased mutation across the boundary

The soundness hole every reviewer will probe: systems code borrows an RC list;
app code *also* still sees that list; app code mutates or drops its reference
mid-borrow. Single-threaded v1.x makes the drop case easy (the pinned
reference can't be released before the block ends — scope discipline), but
mutation-while-borrowed is the real design point. Three options:

- (a) **Freeze rule:** while any systems borrow of value V is live, app-level
  mutation through *any* alias of V is a compile error. Requires app-level
  alias analysis — expensive, Rust-shaped, exactly what we promised app users
  they'd never meet.
- (b) **Copy-in:** mutable app values must be `.to_owned()`-copied into systems
  scope. Sound, simple, boundary cost the levels doc already fears.
- (c) **Immutability carries the weight:** app-level values are deeply
  immutable by default (Axis 11.1/11.5 — already locked). An immutable value
  can be borrowed by anyone, mutated by no one — **the borrow is trivially
  sound with zero analysis.** Only `mut` values need rule (b)'s copy-in (or an
  explicit exclusive handoff).

**Decision proposal: (c) with (b) as the `mut` fallback.** This is the
paradox-collapse move: Avra already made the immutable-by-default bet for LLM
correctness; here it pays a second dividend by deleting the hardest part of
the boundary checker. The rule is teachable in one sentence: *immutable data
crosses level boundaries freely; mutable data must be handed off explicitly.*

### 5.3 Inside systems level: second-class borrows over deep immutability

Spec 9.8 commits to "inferred lifetimes, escape to explicit `'a` when
ambiguous (v2.0)." I want to push one step further and propose we may never
need the v2.0 escape — by adopting **second-class references** (the
Hylo/Val lineage; also Graydon Hoare's stated preference for what Rust could
have been):

- Borrows (`&T`, `&mut T`) may appear in **parameter and local positions
  only**. They may not be stored in struct fields, captured by escaping
  closures, returned beyond their evidence, or put in collections.
- Consequence: every borrow's lifetime is *syntactically* the enclosing call
  or scope. There is nothing to annotate because there is nothing to infer —
  the "two inputs, which one does the return borrow from?" question that
  forces Rust's `'a` **cannot be asked**.
- Returns that would borrow instead use: (1) owned moves, (2) RC handoff back
  to app level, or (3) **typed-id arenas** — the ps3t pattern promoted to a
  first-class stdlib idiom (`Arena<T>` + `Id<T>`), which is how real systems
  code (compilers, games, kernels with object tables) already structures
  long-lived graphs.
- `mut` borrows follow aliasing-XOR-mutation (Axis 11.4, already decided),
  checked per-scope — a dataflow pass an afternoon-sized fraction of Rust's
  NLL because paths can't escape.

What this buys, concretely:

| | Rust | Avra systems (proposed) |
|---|---|---|
| Lifetime annotations | pervasive in APIs | **none, by construction** |
| Self-referential structs | covered (with pain) | out of scope — use `Arena<T>`/`Id<T>` |
| Iterator borrows | first-class | parameters/locals only — covers internal iteration (`for`, `.map` with non-escaping closures) |
| Checker complexity | NLL + polonius territory | scope-local dataflow |
| What you give up | — | borrow-in-field patterns (rare; arena idiom replaces them) |

This is the honest "invent a new way" answer to the design question: not a
sixth memory primitive (the spec correctly says there are only five), but a
**deliberately weaker borrow discipline whose weakness is invisible for the
workloads systems blocks exist for** (buffers, parsers, DSP loops, drivers) —
because the escape-shaped workloads it can't express are exactly the ones the
app level and the arena idiom already own. If real usage later proves the
ceiling too low, spec 9.8's phased path to full lifetimes remains open — we
lose nothing by starting second-class; Rust-style is a superset we can grow
into, whereas starting with Rust-style is a complexity ratchet we can never
walk back.

### 5.4 What `systems` code looks like (target ergonomics)

```avra
// Whole fn at systems level — contract visible in the signature
systems fn sobel(src: &Buffer<u8>, dst: &mut Buffer<u8>, w: int, h: int) {
  for y in 1..h-1 {
    for x in 1..w-1 {
      let gx = conv3(src, x, y, KX)      // src reborrowed per call — fine
      let gy = conv3(src, x, y, KY)
      dst[y*w + x] = clamp8(isqrt(gx*gx + gy*gy))
    }
  }
}

// App-level caller: immutable image crosses free; owned buffer comes back
fn edges(img: Image) -> Image {
  systems {
    let out = Buffer<u8>.alloc(img.len)   // owned; dropped or moved, no RC
    sobel(img.pixels.borrow(), &mut out, img.w, img.h)
    Image.from_buffer(out, img.w, img.h)  // ownership → RC at the boundary
  }
}
```

No lifetimes, no `.clone()` ceremony, no `unsafe`. The RC pin on `img`, the
drop of `out` on early exit, and the boundary re-wrap are all compiler-inserted
and *visible in `--explain-boundaries` output* (the cost-model tooling the
levels doc's objection 7 demands).

---

## 6. The runtime split: `core` / `alloc` / `std` (the piece nobody spec'd)

The single biggest *missing decision* for systems credibility. Rust's layering
is the proven model; Avra adopts it as **runtime capability tiers** that the
level-effect system (§2) enforces:

- **`@core`** — no allocator, no OS, no unwinding. Sized ints, bool/float,
  Option/Result, slices, iterators (non-allocating), atomics, volatile,
  formatting into caller buffers. *Everything at every level can use core.*
- **`@alloc`** — adds an allocator interface + owned containers
  (`Buffer<T>`, `List<T>`, `string`) parameterized over allocator. Systems
  level's home. On app level these are the same types with the RC strategy —
  Commitment 2 (strategy-independent layouts) is what makes one type
  definition serve both, and it's already locked.
- **`@std`** — adds the RC runtime, green threads, channels, fs/net/process.
  App level's home. Servers, agents, UI.

Then targets declare tiers: `x86_64-linux` = std; `wasm32` = alloc (+wasi
std subset); `thumbv6m-none` = core (+alloc with a user-provided allocator).
The "app level unavailable on bare metal" error falls out of tier propagation;
nothing bespoke.

Consequences worth calling out:

- `runtime.c`'s eventual Avra rewrite (§4) is *exactly* the `@core`+`@alloc`
  implementation compiled without `@std` — the layering is what makes the
  self-hosting non-circular.
- The stdlib duplication fear (levels doc, "Holes") dissolves: **one** `List<T>`
  in `@alloc`, generic over allocation strategy via the traversal-protocol
  commitment; monomorphization specializes per level (Commitment 8, locked).
- Green threads/channels (Axis 18) are honestly `@std`-tier. Bare-metal
  concurrency is interrupts + atomics + (later) an embassy-style executor as a
  *package*, not a runtime — the component system is the delivery vehicle.

---

## 7. The rest of the checklist, briefly specified

- **FFI (Axis 15, v1.x)** — implement as spec'd (extern + ownership
  annotations + opaque types + trampolines), with one addition the spec
  undersells: **`avra build --lib c`** emitting a `.a`/`.so` + generated
  header. Being *consumable from* C/Swift/Kotlin is how the UI story ships
  before native codegen (§9) and how embedded teams wrap us into existing
  RTOS builds (levels doc objection 4 — meet them where they are). All FFI
  calls are `bare`-colored; the `@borrows`/`@takes_ownership` annotations are
  what let a *safe* wrapper fn absorb the bare block.
- **Layout control** — `@repr(c)`, `@packed`, `@align(n)`, explicit-discriminant
  enums, and bitfield syntax on `@repr` structs. Prereq for FFI structs,
  network protocols, and register maps alike. Small, self-contained, S1.
- **const generics (spec 5.5, integers-only)** — `Buffer<u8, N>` for stack
  buffers and register-block strides. The monomorphizer already exists; this
  is a type-system extension, not a codegen one.
- **Volatile + MMIO** — `Volatile<T>` core type with `read/write` (never
  reordered/elided), plus `register_map` as a *component* (§9) that lowers to
  volatile ops. Import ARM SVD files at comptime (a `@comptime` fn reading a
  data file — the JIT's allowlisted-read design already permits exactly this).
- **SIMD** — portable vector types first (`f32x4` etc., LLVM vectors), arch
  intrinsics later; inline asm last (highest maintenance, lowest demand until
  drivers).
- **Panic strategy** — per-target: app = unwind-to-task-boundary (Axis 12,
  decided); systems/bare-metal = `abort` or user `@panic_handler`. Must be in
  the target definition from day one; retrofitting no-unwind is miserable.
- **Overflow (Axis 31.4, decided)** — debug-panic/release-wrap +
  `checked_*`/`wrapping_*` family. Ship it with sized-int completion; HN
  *will* test `255u8 + 1` in the playground.
- **Tooling honesty** — `avra size` (section-level, per-symbol), `avra asm
  <fn>`, DWARF through LLVM (free-ish), `--sanitize=address,thread`
  pass-through. Cheap wins that buy disproportionate credibility.

---

## 8. Sequencing — phases with exit-criterion artifacts

Ordered to respect ps3t (L4/L5 make level-dispatch cheap; L6 wants the
fingerprint field early) and to front-load integrity.

**S0 — Honesty (now; small, ships independently).**
Gate the already-live sharp tools: pointer ops/`extern malloc`-class calls
require an enclosing `bare {}` (or `@bare_ok` module opt-in for the compiler's
own source during migration); emit the spec'd null-guard on `ptr[i]` (or a
proper F-code where statically null); new F02xx codes for level violations;
reserve `level`. Also: land the two ps3t inputs (fingerprint field enum +
MIR boundary-instruction note in `1n1v`). *Exit artifact:* a program doing
`free(p); p[0]` fails to compile outside `bare`, with a beautiful error.

**S1 — Systems core (v1.x phase 1, per spec 9.8).**
`systems` blocks/fns as a checked regime: immutable second-class borrows
(§5.3), owned `Buffer<T>`/`OwnedString` in `@alloc`, `Drop` trait completion
(P3-6) + LIFO interleave, layout annotations, const generics, sized-int
literal suffixes (`200u8`). Boundary machinery per §5.2(c). *Exit artifact:* the
Sobel example (§5.4) compiles, benchmarks within 1.1× of the C equivalent, and
`--explain-boundaries` prints every inserted boundary op.

**S2 — Mutable borrows (v1.x phase 2).**
`&mut` with scope-local aliasing-XOR-mutation. Escape-analysis synergy: the
existing RC elision learns from borrow facts (a borrowed param provably needs
no retain — Perceus direction, spec 9.7 v1.x). *Exit artifact:* in-place
buffer transforms + a systems-level arena allocator written in Avra.

**S3 — Bare + FFI (early v2.0 surface).**
`bare` blocks (now with content: `@transmute`, full ptr read/write lvalues,
SIMD portable vectors), FFI tier 1 with ownership annotations + opaque types,
`avra build --lib c` + header emission, `avra asm`/`avra size`. *Exit
artifact:* wrap SQLite and libpng with safe app-level APIs; call an Avra
`.a` from a C program.

**S4 — Freestanding + hardware (v2.0).**
`--target` cross-compilation, `@core`/`@alloc`/`@std` tiers enforced by
level-effects, custom entry/linker scripts, `@interrupt`, panic handlers,
`Volatile<T>`, `register_map` component + SVD import, bare-metal atomics.
*Exit artifact — the HN artifact:* blinky + UART echo on RP2040 (thumbv6m),
binary < 16KB, `avra size` shows zero RC/scheduler symbols, disassembly
published in the announcement post.

**S5 — The dogfood singularity.**
Rewrite `runtime.c` in `@core`/`@alloc`-tier Avra (allocator, RC ops, string
ops; channels/scheduler last). `rt_loop` real-time verification. The robot-arm
demo from the levels doc, for real. *Exit artifact:* `runtime.c` deleted;
`make selfhost` fixed point holds with the Avra runtime.

Each phase is independently shippable and independently *credible* — S0 makes
the safety story true, S1 makes the performance story true, S4 makes the
embedded story true. No phase requires overselling the next.

---

## 9. GPIO to UI: why one component system carries both ends

The vision's bookends — `led.high()` and a cross-platform button — are the
same language feature. Components V2 (already designed, partially shipped)
gives packages: a registered block keyword, a `config`/`children` schema, a
trait implemented per instance, and a `@comptime` macro that lowers to plain
structs + impls. Nothing about it is UI- or hardware-specific, which is the
whole point:

```avra
// @hw/board — hardware end
board pico {
  led    status { pin 25 }
  uart   console { tx 0, rx 1, baud 115200 }
}
// lowers to: type Board_pico { ... } + impl Device — pin numbers validated
// at comptime against the rp2040 SVD; volatile writes inside systems fns.

// @ui/view — app end (Axis 23, when its design session happens)
view Dashboard {
  state temp: float
  column {
    text "Reactor: {temp}°C"
    button "Vent" { on_tap { vent_channel.send(.Open) } }
  }
}
// lowers to: type Dashboard + impl Renderable; `state` fields become the
// reactive slots (Axis 23's `mut`-in-view placeholder); render targets are
// backends behind the same trait.
```

Both are: keyword → schema-checked children → trait impl → comptime lowering.
The GPIO one bottoms out in `hardware`-level volatile writes; the UI one
bottoms out in a render backend. **The declarative layer is level-agnostic —
levels are about what's underneath the trait impl, never about the surface.**
A user reads both files with one mental model; an LLM writes both in one
context window. That's the collapsing paradox as architecture, not slogan.

Two grounded notes so this stays honest:

- Axis 23 is *deferred by design* — the UI end needs its own design session
  (reactivity, render backends, the bindings-first mobile phasing). This doc
  deliberately doesn't pre-empt it; it only establishes that the substrate
  (components + FFI-out + WASM target) is shared with the systems program, so
  neither end blocks the other.
- The realistic first UI ship is **Avra-as-a-C-library** (S3) driving native
  shells (Swift/Kotlin/WASM-DOM) — the spec's own "bindings first, native
  codegen later" phasing — not an Avra-native renderer.

---

## 10. What we will get attacked on, and our actual answers

Sharpened from the levels doc's list, with this program's receipts:

1. *"Four memory models in one compiler is vaporware."* — v1.0 ships one (done,
   audited §1). S1's checker is scope-local dataflow, not NLL (§5.3). Each
   phase has a falsifiable exit artifact. We never claim an unshipped level.
2. *"The boundary will leak/cost."* — Immutability carries the common case
   (§5.2c); costs are one-time and printed by `--explain-boundaries`; the
   perf envelope is published with S1's benchmark, per the spec's own numbers
   (2-5% app-level tax, 5-20ns crossings).
3. *"It's Rust's unsafe with extra steps."* — Inverted: our *default* is easier
   than Rust's safe mode (no ownership at app level), and our *checked* mode is
   simpler than Rust's (no lifetime annotations, ever, in v1.x). The extra
   steps are deletions.
4. *"Nobody will rewrite firmware in your language."* — We don't ask them to:
   SVD import, C-ABI both directions, RTOS interop via FFI-first (S3 before
   S4). The target user is the team that today glues Python + C.
5. *"Show me the binary."* — S4's exit artifact **is** the answer: sub-16KB
   blinky, zero runtime symbols, published disassembly.

---

## 11. Anti-goals (locked, so scope can't creep)

- **No universal borrow checker.** App level never grows ownership rules.
  (Axis 9's "Why not Rust's model" — five reasons, locked.)
- **No sixth memory primitive.** We integrate five proven ones; novelty is the
  scoping + the second-class discipline. (Spec's meta-learning, kept.)
- **No lifetime annotation syntax in v1.x.** If S1/S2 usage proves the
  second-class ceiling too low, spec 9.8's v2.0 path reopens *with data*.
- **No `unsafe` keyword.** `bare` is the one escape hatch (spec change-log
  2.2); S0 makes it real instead of aspirational.
- **No comptime pointer tricks.** The JIT sandbox stays app-level/pure (§4.4).
- **No forked stdlib.** One type per container, layered by tier, specialized
  by strategy (Commitments 2/8).

---

## 12. Open questions (deliberately unresolved here)

1. **Second-class borrow ergonomics under closures** — non-escaping closures
   borrowing locals are fine; the checker needs an "escaping?" bit per closure
   (escape analysis already computes it). Does `it`-pronoun method-call sugar
   ever force an escape? Needs a worked corpus before S1 freezes.
2. **`systems` + green threads** — spec says systems code manages threads
   manually; but can a `systems fn` *be called from* a fiber? (Proposal: yes —
   levels are about capabilities, fibers are an app-runtime detail; the
   fn can't tell. Needs confirmation against stack-growth interaction:
   growable fiber stacks + big systems stack frames.)
3. **Allocator parameterization surface** — Zig-style explicit parameter vs.
   scope-implicit (arena blocks) vs. both. Leaning: implicit per-scope default
   with explicit override, consistent with convention-over-configuration.
4. **`hardware` as a level vs. a package** — with `register_map` as a
   component and volatile in `@core`, does `hardware {}` remain a checker
   regime (ISR restrictions, no-alloc enforcement) or collapse into
   "`systems` + target + components"? Current lean: keep the keyword, implement
   as systems + a deny-set (alloc, blocking) + volatile-default — i.e. a
   *profile*, which is also cheaper.
5. **Atomic RC inference (Axis 9.4 v1.x)** interaction with borrows: a borrow
   crossing `spawn cpu` is already banned (9.14/Case 3); does the Sendable-like
   analysis need to see systems types at all, or are owned-moves the only
   crossing? (Lean: owned/RC only — simpler, matches Case 3.)

---

## 13. Immediate next steps

1. File the program epic + S0 tickets (bare-gating of pointer ops, `ptr[i]`
   null guard, `level` reservation, fingerprint/MIR notes into ps3t.8.1/1n1v).
2. Socialize §5.3 (second-class borrows) — it's the one *decision* this doc
   adds over the spec; it deserves a red-team session like Axis 9 got.
3. Schedule the Axis 23 UI design session independently; only the S3
   `--lib c` dependency is shared.
4. Baseline the boundary-cost benchmark harness alongside S1 so the perf
   envelope is measured from the first commit, not retrofitted.
