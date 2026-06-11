# Resolving seed.ll merge conflicts

`seed/seed.ll` is a generated artifact: the compiler's own LLVM IR,
emitted by `make update-seed`, version-locked to the source tree that
produced it. **Never merge it textually.** `.gitattributes` marks it
`merge=binary` so git presents it as pick-a-side.

## The rule

The resolution is always: pick ONE side's seed as a disposable
bootstrap stepping stone, build the merged source with it, then
regenerate:

```bash
# 1. Take one side (see "choosing a base" below)
git checkout --theirs bootstrap/seed/seed.ll   # or --ours / explicit ref
#    NOTE: if you already `git add`ed the file, --ours/--theirs silently
#    re-checkout the staged copy. Use an explicit ref to be safe:
#    git checkout <ref> -- bootstrap/seed/seed.ll

# 2. Tolerate the other side's new enum variants (ValueType/Expr/Stmt)
cd bootstrap && make seed-patch-traps

# 3. Build the merged source with the stepping-stone seed
make build            # or build-quick while iterating

# 4. Regenerate the real merged seed + verify the fixed point
make update-seed

# 5. Full gate
make test
```

## Choosing a base seed

Each side's seed can only compile source it "knows". Pick the side
whose seed is most likely to survive the union:

- **New surface syntax** (keywords, literal forms): the seed that has
  the parser for it wins — unless the other side's syntax is only in
  comments/strings (grep before assuming; doc comments don't count).
- **New enum variants** on ValueType/Expr/Stmt: either seed works
  after `make seed-patch-traps` (converts match traps to fallthrough).
- **Extern-signature refactors / decl-table changes**: the seed whose
  baked predeclare table matches the merged source's signatures wins
  (the redeclare guard aborts otherwise — see sdmg.4 for the planned
  tolerance).
- **Codegen-correctness fixes** (e.g. zm77 zero-init): the seed that
  HAS the fix in its machine code wins; a pre-fix seed may emit a
  stage binary that corrupts while self-compiling the (bigger) merged
  source.

When NEITHER seed can compile the union (both branches cycled past
their own features — the 2026-06-11 case), you must stage: build the
best stage-1 you can, and if its self-compile crashes, the intermediate
`packages/cli/src/main.av.ll` is patchable text — fix the specific
defect at the IR level, relink, and continue the cycle. This is a
last resort; sdmg.2's bootstrap-window rule exists to make this state
unrepresentable.

## Prevention (the actual fix)

Per the sdmg epic:
- Feature branches should NOT cycle the seed or dogfood new
  syntax/variants in compiler source; seed advancement happens on the
  integration branch as dedicated `chore(seed): cycle` commits
  (sdmg.2 — bootstrap window + seed train).
- **Check it mechanically: `make check-seed-window`** (or
  `diagnose.sh --check-seed-window`; baseline override:
  `SEED_WINDOW_REF=<ref>`). Builds the integration branch's seed
  (traps auto-patched, so new enum variants are within the window)
  and compiles this branch's `main.av` with it. Run before every PR;
  CI enforcement is the remaining sdmg.2 work.
- `.beads` ticket `sdmg.5` tracks automating this whole procedure as
  `diagnose.sh --seed-merge`.
