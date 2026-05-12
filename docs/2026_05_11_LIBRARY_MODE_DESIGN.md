# Library-mode compilation — design doc

## Why

`bs2 compile` today is a whole-program compiler: given `foo.av`, it parses
foo.av AND every transitively-imported source file, resolves and codegens
the lot. Output: one `.ll` containing every symbol in the closure.

That's fine for ad-hoc scripts. It's wrong for everything else:

1. **Per-package caching is a lie.** Today's `bs2 build --lib <pkg>`
   produces a "library" that actually contains every transitively-imported
   stdlib symbol baked in. Linking N such "libraries" together gives
   thousands of duplicate-symbol errors (we just demonstrated this with 1vkf).
2. **Test runner can't parallelize compile.** Each `_test.av` would have
   to re-parse `@std/*` (~30k lines) from source. The 1vkf path tried to
   sidestep this with metadata stubs + multi-object linking and immediately
   hit (1) above.
3. **The build cache invalidates too coarsely.** Any change anywhere in a
   transitive dep invalidates everything.

Mature compilers (Rust, OCaml, Haskell, Cargo's whole model) solve this with
**separate compilation**: each package compiles to a library object
containing ONLY its own symbol definitions, with externs for everything
imported. Consumers link the library objects together.

This doc nails the contract Avra's library mode honours so the
implementation phases don't drift.

---

## The contract

### Symbol naming (ABI)

Avra's existing fully-qualified mangling stays. Every defined symbol's
linker name is `@"<scope>::<pkg>::<mod_path>::<fn_or_type_name>"`. Example:
`@"@std::avrac::diagnostics::bag_has_code"`.

This is already what codegen emits. Library mode requires no new mangling
rules; it just requires that EVERY codegen path agrees on this rule (no
local shadows, no anonymous symbols that depend on whole-program context).

**Generic instantiations** mangle the type args into the name:
`@"@std::avrac::list::map<int,string>"`. Identical instantiations across
consumers produce identical mangled names — the linker dedups via
`linkonce_odr` (see Generics below).

### Type layout (ABI)

- **Structs** lay out fields in *source order*, packed (no implicit
  padding beyond LLVM's natural alignment for the target triple).
  Adding a field at the END is backward-compatible at the type-layout level
  (existing code keeps reading the same offsets); adding/reordering in the
  middle is a breaking change.
- **Enums** lay out as `{ i64 tag; ptr payload }` (already the case;
  payloads heap-allocated). Tag values are djb2 hashes of variant names,
  stable across reorderings.
- **Lists / Maps / Strings** are opaque pointers to runtime-managed
  heap blobs. Consumers never look inside; they call runtime fns. The
  *runtime* defines the layout, not the lib.

### Calling conventions

Standard LLVM call ABI for the host target (`arm64-apple-darwin`).
- Scalars by value, structs/enums/lists/maps by pointer (already true).
- Return values follow the same.
- No custom regparm tricks, no fastcall, nothing platform-specific.

### Generics — the Rust path

This is the load-bearing decision. We're doing the Rust-style approach:

**Generic function bodies live in metadata.** When `@std/avrac` exports
`fn map<T>(list: List<T>, f: fn(T) -> T) -> List<T>`, its `.meta.bin`
carries the FULL AST body for `map`, not just the signature.

**Monomorphization happens in the consumer.** When `@std/cli` calls
`map::<string>(...)`, `@std/cli`'s compile pass:
1. Looks up `map`'s body in `@std/avrac`'s metadata.
2. Substitutes `T = string` in the body.
3. Codegens the specialised `map<string>` function into `@std/cli`'s `.o`.

**Linker dedup via `linkonce_odr`.** Multiple consumers may each
monomorphize `map<string>` and emit it into their own `.o`. LLVM's
`linkonce_odr` linkage tells the linker "all definitions are identical;
pick one and discard the rest, no error." Standard pattern, well-supported
on Mach-O and ELF.

**What the lib itself does with its own generic fns:** the lib emits
monomorphizations of any generic call IT itself makes (e.g. if `@std/avrac`
internally calls `map<int>` somewhere). It does NOT pre-emit speculative
monomorphizations for consumers; those happen in the consumer.

**Non-exported generics** stay inside the lib (private, never written to
metadata). Only `export fn foo<T>(...)` gets its body serialized.

### Metadata format

`.meta.bin` currently encodes the package's surface (types, enums, fns,
consts) as SIGNATURES only. Library mode requires it to ALSO encode:

- **Generic function bodies** — the full AST of every `export fn` with at
  least one type parameter. The serializer already round-trips StmtList,
  Expr, etc. (the synthesizer uses these); the surface just needs to
  include them.
- **Trait method bodies** that participate in monomorphization (default
  impls, since they may need specialization in consumers).
- **Inline-eligible non-generic fns** — optional; useful for tiny helpers
  the consumer can inline at codegen time. v1 can skip this and emit
  every non-generic as a normal extern reference.

The metadata format gains one new section: `GenericBodies`, indexed by
qualified fn name. Backward-compat: old `.meta.bin` files without this
section are still readable; the consumer falls back to "import as extern"
behaviour for generic fns (which won't link — but old metas don't claim
to support library mode anyway).

### What `bs2 compile --lib <entry>` emits

After this design:

1. `<pkg>/build/cache/<fp>/unit.ll` — LLVM IR containing:
   - `define` for every non-generic fn defined in this package.
   - `define linkonce_odr` for every generic instantiation needed by this
     package's own code.
   - `declare` for every imported symbol from another package. No bodies.
   - Module-level data (consts, type definitions) defined by this package.
2. `<pkg>/build/cache/<fp>/unit.o` — `llc -filetype=obj` of `unit.ll`. A
   real Mach-O object file, ready to link.
3. `<pkg>/build/cache/<fp>/metadata.bin` — the package's surface +
   GenericBodies section.

### What `bs2 build` of a consumer does

1. Loads `avra.toml`, reads `[dependencies]`.
2. Topologically builds each declared dep:
   - For each dep package, run `bs2 compile --lib` recursively (deps of
     deps first).
   - Output: `<dep>/build/cache/<dep_fp>/{unit.o, metadata.bin}`.
3. Compiles THIS package's source under library mode + `AVRA_USE_METADATA=1`
   pointing at each dep's `metadata.bin`. Resolver substitutes stubs for
   imported symbols. Codegen emits `declare` for them.
4. Links: this package's `unit.o` + each dep's `unit.o` + runtime + llvm
   wrapper → final binary.

### Cache keying

A package's library cache slot is keyed on:

```
package_fp = sha256(
    sha256(every .av under <pkg>/src/) ++
    sorted(each direct-dep's library_fp) ++
    compiler_hash ++
    profile_key ++
    target_triple
)
```

This chains transitively: if `@std/avrac` changes, `@std/avrac`'s `package_fp`
changes, every downstream package's `package_fp` changes (it includes
`@std/avrac`'s fp). Cargo's standard pattern. Stale hits impossible.

---

## What stays unchanged

- The `@std.avrac.build.Cache` content-addressed cache layer.
- The `.meta.bin` codec (just extended with GenericBodies).
- `build_binary` as the shared compile pipeline (still composes parse →
  resolve → ... → codegen). Library mode is a flag on codegen behaviour,
  not a new pipeline.
- `assemble_test_program` for the test runner.
- Symbol mangling rules.

## What's new

1. **Codegen lib-mode**: emit `declare` for any symbol whose qualified
   name doesn't start with this package's root, instead of inlining the
   body. The cleanest cut: in `emit_function`, check whether the fn was
   defined in THIS package (via `SStmt.file` path → `package_root_for_file`);
   if yes, emit `define`; if no, emit `declare` and SKIP the body.
2. **Metadata producer**: serialize generic fn bodies into the new
   GenericBodies section.
3. **Metadata consumer (monomorphization sites)**: when monomorphizing a
   call to an imported generic, fetch the body from metadata instead of
   the in-memory AST.
4. **Build-driver topo-sort**: walk `avra.toml [dependencies]`, build in
   dep-order, parallelize across independent packages.
5. **Real `.o` in cache**: `bs2 build` runs `llc` to produce a Mach-O
   object after codegen (the cache already has a slot for `unit.o` —
   we just need to actually write a real object there).

## What gets retired

- Whole-program is no longer the default. `bs2 compile <file>` becomes
  "library-mode compile" when the file lives in a package (avra.toml at
  some ancestor dir); otherwise it stays whole-program for ad-hoc scripts.
- A `--whole-program` flag exists for users who explicitly want the old
  behaviour.

---

## Generics: what's actually new and tricky

The Rust path puts the cost in two places:

**Serialization cost (producer side).** `metadata_synthesize.av` and
`metadata_extract.av` need to walk every `export fn` with type params and
emit its full body. The body is a StmtList of arbitrary depth. Today the
metadata codec handles signatures; bodies require the same codec extended
to cover every Stmt and Expr variant.

The good news: we already serialize this AST in `synthesize_unit_body`
(consumer's view of imports). The codec is round-trip-proven. We're
extending it from "signatures + stubs" to "signatures + stubs + bodies for
generics".

**Monomorphization site (consumer side).** Today `monomorphize` walks
the program and for each generic call instantiates from the in-memory AST.
With library mode, when the called fn is from an imported package, the
AST isn't in memory — it lives in metadata. The monomorphizer must look
up the imported metadata, deserialize the body, substitute type params,
emit the instantiation with `linkonce_odr`.

This is a real change to `monomorphize`. It gains a "metadata cache"
parameter: a map from qualified-fn-name to deserialized AST body. The
resolver populates this cache as it processes `use @pkg.X` statements.

## Trap: trait methods

A trait method with a default body is implicitly generic over `Self`.
Same rules apply: serialize the body in metadata; monomorphize in the
consumer for each impl.

Trait method *signatures* are always in metadata (already true). Default
*bodies* need to be added. Trait impl bodies are already monomorphized
during consumer's codegen — they remain so.

---

## What the implementation phases look like

Restating with the Rust generics path:

| Phase | Deliverable | Effort |
|---|---|---|
| P0 | This doc. | done |
| P1 | `bs2 build --lib` runs `llc` so `unit.o` is real Mach-O. Whole-program still inside; no codegen changes yet. Confirms ABI mangling links cleanly at the toolchain level. | 2-3h |
| P2 | Codegen lib-mode flag. `emit_function` emits `declare` for non-this-package symbols. Verify via `nm` that `unit.o` contains only this package's exports. | 8-14h (the big one — generic bodies in metadata is part of this) |
| P3 | Metadata codec extension for `GenericBodies`. Producer writes; round-trip tested. | 4-6h |
| P4 | Monomorphize fetches generic bodies from metadata cache. Emit instantiations with `linkonce_odr`. | 6-10h |
| P5 | Build driver topo-sort over `avra.toml [dependencies]`. Parallel where independent. | 4-6h |
| P6 | Test runner adopts library mode: each `_test.av` is its own micro-package, links against transitively-declared deps. | 4-6h |
| P7 | Retire whole-program as default. `bs2 compile <file>` is library mode when in a package; `--whole-program` opt-in. | 2-3h |

**Total: 30-50 hours.** Multi-day. Each phase lands independently.

The key insight: P1 is the SAFE first step (no codegen behavior change,
just real `.o` files). After P1, multi-object linking of @std/avrac.o +
@std/cli.o still gives duplicate-symbol errors (because each is still
whole-program). P2 is what fixes that by making each .o contain only its
own package's symbols. P3-P4 are the generics work. P5-P7 are the build-
driver + test runner consequences.

---

## Decisions logged

| Decision | Choice | Why |
|---|---|---|
| Generic strategy | Rust-style: bodies in metadata, monomorphize in consumer, `linkonce_odr` dedup | Maximum expressiveness. Industry standard. |
| Default compile mode | Library when in a package; whole-program for ad-hoc | Mature default + escape hatch |
| Cache key includes deps | Yes — transitive `package_fp` chain | Cargo pattern; correctness by construction |
| `.meta.bin` backward-compat | Old metas without GenericBodies still readable | No flag day for downstream packages |
| Multi-object linking | At the build driver level, using each dep's `unit.o` from its cache | Aligns with current Cache API |
| Build driver source of truth for deps | `avra.toml [dependencies]` | Already parsed for path deps; just extend |

Anything not in this table is undecided and will be re-opened if it bites
during implementation.
