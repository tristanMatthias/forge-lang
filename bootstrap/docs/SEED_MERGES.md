# Resolving seed merge conflicts

Since sdmg.3 (pin-don't-vendor) the seed is PINNED, not vendored:
`seed/seed.lock` (tracked, a few lines) names {version, sha256, url} on
GitHub Releases, and `seed/seed.ll` is a gitignored local
materialization the build fetches and hash-verifies. What conflicts in
a merge depends on the history era:

- **Lock era — `seed.lock` conflicts.** Two seed-train advances raced.
  Artifacts are immutable and content-pinned, so the resolution is
  mechanical: **take the HIGHER version line**. Only when the merged
  SOURCE needs restaging (it uses features neither pinned seed knows)
  run `diagnose.sh --seed-merge`, which fetches each side's pinned
  artifact as a candidate; afterwards publish the regenerated seed
  (`make seed-publish`) and commit the fresh lock bump.
- **Pre-lock era — `seed.ll` conflicts.** The vendored-IR case the
  rest of this document describes. `.gitattributes` marks it
  `merge=binary` so git presents it as pick-a-side; **never merge it
  textually.**

## One command (sdmg.5)

With the merge in progress and the seed pin conflicted:

```bash
bash bootstrap/scripts/diagnose.sh --seed-merge            # tries ours, then theirs
bash bootstrap/scripts/diagnose.sh --seed-merge --base theirs   # pin a side
```

It runs the whole staging dance below — base seed (extracted from the
index, or fetched per that side's lock) → trap patch → stage1 →
merged-source compile → bs2 link → self-compile verify → seed
regeneration → fixed point — and on a stage failure reports the
failure class (`parse` / `extern-guard` / `corruption`) with hints
matching the "choosing a base" table, then falls through to the other
candidate. On success the regenerated `seed/seed.ll` is the merge
resolution: run `make test`, then stage it (`git add bootstrap/seed/seed.ll`
on pre-lock history; `make seed-publish` + `git add bootstrap/seed/seed.lock`
on lock history).

The manual recipe below is the same procedure, kept for when you need
to intervene mid-way (e.g. the IR-level last resort).

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

## Prevention (the actual fix — sdmg.2, ENFORCED)

Feature branches must NOT cycle the seed or dogfood new syntax/variants
in compiler source; seed advancement happens on the integration branch
as dedicated `chore(seed): cycle` commits (the seed train). This is
enforced by `diagnose.sh --check-bootstrap-window`:

- **gate 1 (seed train):** rejects branches whose commits CHANGE the
  pinned seed content (`seed.lock` bumps; `seed.ll` commits on
  pre-lock history) since the merge-base with the integration branch.
  Touches that keep the content identical — e.g. the vendored→pinned
  migration itself — pass;
- **gate 2 (window):** rebuilds the branch's compiler source from the
  integration branch's CURRENT pristine seed in an isolated tree with
  a cold unit cache, then smoke-runs the produced compiler.

Wired into the pre-push hook (`scripts/pre-push`, chained from
`.beads/hooks/pre-push` on hooksPath checkouts) and CI
(`.github/workflows/bootstrap-window.yml`, every PR into the
integration branch). Green verifies are cached in
`build/window/.window_verified`; force a re-check with
`AVRA_FORCE_WINDOW=1`. See CLAUDE.md "Bootstrap window & seed train".

For histories that predate the gate (and for merges into the
integration branch itself), the staging recovery above is automated as
`diagnose.sh --seed-merge` — see "One command" at the top.
