# What shipped this week

**129 commits**, ~14,000 source insertions / ~4,250 deletions (excluding seed.ll + build artefacts). Branch: `feat/crafting-intepreters`.

## Headline numbers

- **Cold compiler build:** ~42s (was ~66s before this week's perf push, ~6× faster than before that).
- **Bootstrap source `mod` declarations:** 0 in the compile graph (was 50+). Filesystem layout IS the namespace.
- **Tests:** 2015/2015 passing throughout, bs2/bs3 fixed-point holds.

## Epics closed

### `a1el` — Build system: cargo/go-style incremental, parallel, fingerprinted builds (P1, EPIC)
All 27 child tickets closed. End-state architecture:
- `avra build` — incremental, parallel, fingerprinted at package level
- `avra build --per_module` — incremental + parallel at directory-as-module level with cargo-style TTY progress + mtime cache
- `avra build --emit_metadata` — `.meta.bin` sidecars consumers fast-path against (`AVRA_USE_METADATA`)
- Path-deps + per-mod dispatch via `pool_run`; xargs dependency removed
- Bootstrap source: zero `mod foo` decls — every package, subdir, sibling resolves through filesystem auto-discovery

### `g2eo` — Per-module compile granularity (P3, in a1el)
- **Phase A** (codegen filter): `--target_module=<dir>` flag, `@external_unit` annotation propagated through codegen + release helpers + metadata extractor
- **Phase B** (dispatcher): `bs2 build --per_module` enumerates `<pkg>/src/` subdirs, dispatches one compile per subdir via `pool_run`, llc each `.ll` → `.o` in parallel, bundles into `lib<pkg>.a`. Also emits unit-level `.meta.bin` for legacy single-unit fast-path.
- **Phase C** (UI): TTY progress bar mirrors path-deps progress (marker-file polling).
- **Phase B.4** (cache): mtime gate skips compile + llc when subdir's `.o` is newer than every reachable `.av` source.
- End-to-end on `@std/avrac` (17 subdirs): cold ~59s, warm ~12s, single-file edit ~13s.

### `g2eo.1` — Directory-as-module
- Dropped all 50+ `mod foo` declarations from the bootstrap. Every package, subdirectory, sibling resolves via filesystem auto-discovery.
- Migrations:
  - `avrac.av` — 17 mod decls dropped
  - `features/mod.av` — 32 mod decls dropped
  - `build/mod.av` — 10 mod decls dropped + use paths flattened
  - `std-cli/cli.av` — `mod ui` dropped
- Bug fixes along the way: `build/` subdir auto-discovery (g2eo.1.2.1), q3gp trait body method signature rewriting, 256-slot intmap overflow in TypeRegistry.

### `e20h` — Worker process pool
- `pool_run` + `pool_run_with_progress` exported from `@std/avrac/build/pool` as canonical sync API.
- TTY pre-build path-deps branch dropped its xargs dependency — now spawns an Avra-emitted `/bin/sh` dispatcher with portable `${pids%% *}` parameter expansion (no bash-only `wait -n`).

### `kkgf` — Compile-perf round
Every typeck/codegen registry converted from cons-list to `cstr_map`-backed (O(1) lookup):
- typeck: `FnTypeEntry` (8.8× speedup) + `StructTypeReg` + `EnumTypeReg` + `TraitRegistry` + `NewtypeReg` + `UnionAliasReg`
- codegen: `FnRetTypes` (2× speedup) + `StructReg` + `EnumReg` + `TraitDeclReg` + `CgNewtypeReg` + `CgUnionAliasReg`
- resolve: global-index lookup
- Net: 6× faster cold compile (66s → ~42s).

## Other notable work

### Per-package metadata (`iinq` + `xtvc` + `2f54` + `9ixv`)
- Binary `metadata.bin` codec — `BytesWriter` / `BytesReader`, FNV-1a-64 sym IDs, file header + section framing, ValueType / FieldList / VariantList / TypeDecl / FnDecl / Const / Trait / Impl encoders.
- Producer-consumer pipeline: `bs2 build --emit_metadata` writes; `AVRA_USE_METADATA=1` short-circuits the resolver to consume `.meta.bin` instead of re-parsing source.
- N-file linker (`k21v`).
- `bs2 metadata_show` for round-trip inspection.
- `@external_unit` annotation gates body emission for cross-unit imports.

### `lkze` — Retire bespoke list-of-X enums in favour of `List<T>`
6 of 12 subtickets closed:
- `lkze.1` — `ModStatsList` → `List<ModStats>` (coverage/mod.av)
- `lkze.2` — `IntListSet` → intmap-backed `IntSet`; `apply_line` aggregation O(L²) → O(L) (coverage/mod.av — fixed a known multi-minute hang on full test suites)
- `lkze.3` — 4 metadata Decl-list cons enums (`TypeDeclList` / `FnDeclList` / `ConstDeclList` / `ImplDeclList`) → `List<T>` with row structs
- `lkze.4` — `MetaTraitMethodList` + `ImplMethodRefList` → `List<MetaTraitMethod>` / `List<ImplMethodRef>`
- `lkze.6` — `ModuleGraphNodeList` + `GraphItemList` → `List<ModuleGraphNode>` / `List<GraphItem>` (core/module_graph.av)
- `lkze.10` — `ModGroupList` 3-variant cons-list → `List<ModGroupItem>` (resolve/names.av dedup pass)

Plus several bare list enums earlier in the week:
- `FnStatsList`, `DecisionList`, `CovEntryList`, `FnCountsList`, `FnNameList`, `IntList` in coverage/
- `ValueList`, `BindingList`, `FunctionList` in eval/

6 lkze subtickets remain open (P3): std-lsp/lsp.av enums (`.5`), ParamTypeList in codegen (`.7`), scope/resolver-internal enums (`.8`), core/ast.av list-enums needing seed cycle (`.9`).

### Deferred (re-file when needed)
- `g2eo.2` — per-module monomorphization (P3 optimization, gated on real generic-body churn pain)
- `nfkn` — pure-Avra sha256 port (blocked on perf — currently 6.6× slower than C, needs <3×)

## Known stylistic side effect

A handful of test fixtures had to bind indexed list elements to a typed `let` before field access:

```avra
let entry: TypeDeclEntry = list[0]
entry.name == "..."  // works
list[0].name == "..."  // typeck currently drops the type parameter, ICEs
```

This is an Avra typeck issue (drops generic parameter through chained field-access on a generic list element). Worked around in fixtures; not a blocker but worth filing as a typeck bug eventually.
