# Bootstrap compiler — friendly Makefile.
#
# The bootstrap is FULLY SELF-HOSTED. No Rust compiler needed.
# It builds from a PINNED LLVM IR seed: seed/seed.lock names the
# artifact; the build fetches + verifies it into seed/seed.ll.
#
# Pipeline:
#   seed/seed.ll → llc + cc → seed binary → compiles packages/cli/src/main.av → bs2
#   bs2 → compiles packages/cli/src/main.av → bs3 (must match bs2 = fixed point)
#
# `cli` is the binary entry; it imports `@std.avrac` (the compiler
# library) and wires it to argv via `@std.cli`. LIB_SRC_DIR
# (packages/std-avrac/src) is hashed into the seed alongside the
# cli sources so the seed records both layers' provenance.
#
# Quick reference:
#   make              build the bootstrap compiler
#   make test         run the full safety net (spec tests + fixed point)
#   make run FILE=x   compile and run a Avra program
#   make update-seed  rebuild seed IR from current source (after dogfooding)
#   make clean        remove all build artifacts
#   make help         show this list

.DEFAULT_GOAL := build
.PHONY: build build-O0 build-debug build-quick test quick run selfhost diff-test clean help install-hooks score update-seed verify-seed seed-sigs seed-patch-traps seed-publish seed-train seed-train-verify coverage coverage-lcov sweep cache-gc clean-cache cache-stats

# `bs2` is built from the cli package (the binary entry). The
# library it consumes (@std.avrac) lives at LIB_SRC_DIR — used for
# lint scans, source-hash provenance in the seed, and the per-file
# IR cleanup glob in `make clean`.
CLI_SRC_DIR := packages/cli/src
LIB_SRC_DIR := packages/std-avrac/src
SRC_DIR := $(CLI_SRC_DIR)
BS2 := build/bs2
DIAG := NO_AUTOCYCLE=1 bash scripts/diagnose.sh

help:
	@echo "Bootstrap compiler — common targets:"
	@echo ""
	@echo "  make build         Build the bootstrap compiler (default)."
	@echo "  make build-quick   Rebuild bs2 if source changed, skip self-compile verify (~16s saved)."
	@echo "  make build-O0      Build at -O0 for lldb debugging (build/bs2_O0)."
	@echo "  make test          Run spec tests + self-host fixed-point check."
	@echo "                     Options: FILTER=<substr>, SKIP_SELFHOST=1."
	@echo "  make quick         Inner-loop: rebuild bs2 + tests, skip selfhost. FILTER= supported."
	@echo "  make sweep         OOM-safe full suite: sequential per-dir runs with resume"
	@echo "                     markers (build/sweep/). FRESH=1 drops the markers. The"
	@echo "                     sanctioned full-suite runner on a <=16GB box."
	@echo "  make run FILE=x.av Compile and run a Avra program."
	@echo "  make selfhost      Verify bs2 and bs3 emit byte-identical IR."
	@echo "  make diff-test     HRN: build OLD (base) + NEW (HEAD) compilers, assert"
	@echo "                     byte-identical IR over selfhost + curated corpus"
	@echo "                     (tests/difftest_corpus/). Options: BASE=, NEW=, CORPUS=,"
	@echo "                     JOBS=, PREBUILT=1 (reuse build/bs2 as NEW; local, fast)."
	@echo "  make update-seed   Rebuild seed/seed.ll from current source. Add FAST=1"
	@echo "                     for the inner-loop variant (per-fn diff, no verify)."
	@echo "  make verify-seed   Verify bootstrap chain (no auto-cycle on failure)."
	@echo "  make seed-sigs     Compare function signatures between seed and source."
	@echo "  make seed-patch-traps  Patch seed match-traps when adding enum variants"
	@echo "                         (run BEFORE 'make build' for new ValueType/Stmt/Expr)."
	@echo "  make seed-publish  Publish seed.ll as a release artifact + bump seed.lock"
	@echo "                     (integration-branch seed-train operation; needs GH_TOKEN)."
	@echo "  make seed-train    Automated train advance: build from pin + fixed point +"
	@echo "                     suite, publish only if the compiler output diverged."
	@echo "  make seed-train-verify  PR gate: the train's verify phase (build from pin +"
	@echo "                     fixed point + suite) WITHOUT publish. Run before a PR."
	@echo "  make coverage      Run compiler self-coverage (line + branch report)."
	@echo "  make cache-gc      Prune COLD cache entries repo-wide (mtime == last use;"
	@echo "                     hits refresh it). DAYS= overrides the 30-day default."
	@echo "  make clean-cache   Wipe EVERY cache (per-package + top-level build/cache)."
	@echo "                     Guarded: never touches src/. Next build is cold."
	@echo "  make clean         Remove all build artifacts."
	@echo "  make install-hooks Install the pre-commit hook."
	@echo ""
	@echo "Anything not listed: bash scripts/diagnose.sh --help"

# Lint: catch common bootstrap mistakes before building.
# Runs automatically before every build. Does NOT block — warnings only.
lint:
	@# Check for ValueType.Int in Stmt constructors outside parsers.
	@# This catches the bug where pipeline stages (desugar, resolver, mono)
	@# discard parser-resolved ValueType fields by writing ValueType.Int.
	@HITS=$$(grep -rn 'ValueType\.Int' $(LIB_SRC_DIR)/ --include='*.av' \
		| grep -E '\.(Let|Mut|Const|Function|ExternFn)\(' \
		| grep -v 'parser\.' | grep -v '// '); \
	if [ -n "$$HITS" ]; then \
		echo "\033[1;33m[lint]\033[0m ValueType.Int in Stmt constructors (may discard resolved types):"; \
		echo "$$HITS" | head -10; \
		echo ""; \
	fi
	@# Remind about pipeline tracing when typeck/codegen changed.
	@if git diff --name-only HEAD 2>/dev/null | grep -qE 'typeck/|codegen/|desugar/|resolve/|mono\.av'; then \
		echo "\033[1;33m[lint]\033[0m Pipeline stage modified. If tests fail, trace values through:"; \
		echo "       parse → desugar → resolve_names → typecheck → monomorphize → codegen"; \
		echo "       Use 'check' before 'compile' to isolate typeck vs codegen."; \
		echo ""; \
	fi

# Build the bootstrap compiler. Produces build/bs2.
build: lint
	@$(DIAG) --build-bs2

# Inner-loop build: rebuild bs2 if source changed, skip self-compile verify.
# Saves ~16s vs `make build` when bs2 is fresh. Run `make build` before commits.
build-quick:
	@$(DIAG) --ensure-bs2

# Build at -O0 for lldb debugging. Produces build/bs2_O0.
build-O0:
	@$(DIAG) --build-O0

# Build with --debug-null for null argument detection. Produces build/bs2_debug.
build-debug:
	@$(DIAG) --build-debug

# Spec test suite. Default = full bundle + selfhost fixed-point check.
#
#   make test                      # all tests + selfhost (commit-grade)
#   make test FILTER=<substr>      # only tests whose filename matches
#   make test SKIP_SELFHOST=1      # skip the bs2/bs3 byte-identical check
#                                  # (~4s saved; pre-commit hook still runs it)
#   make test FILTER=x SKIP_SELFHOST=1   # inner-loop combo
#
# FILTER narrows BOTH which tests run AND which files get bundled into
# the compile — substring-matched against test filename. Use when
# iterating on a specific feature.
#
# Runner environment knobs (every assembled test binary reads these):
#   AVRA_TEST_JOBS=N       worker threads per test binary running its
#                          test-file units in parallel. 1 = sequential
#                          (debugging / exact coverage). Default: cores.
#   AVRA_TEST_STALL_MS=N   INTERNAL — shrinks the stall-detector window
#                          (default 60000) so the detector itself is
#                          testable. The detector names in-flight units
#                          on stderr when nothing completes in-window.
test:
	@$(BS2) test $(if $(FILTER),-f $(FILTER))
	@$(if $(SKIP_SELFHOST),,$(DIAG) --check-fixedpoint)

# Inner-loop combo: rebuild bs2 + run tests (with optional FILTER).
# Skips selfhost by default — run `make test` before committing.
#
#   make quick                    # rebuild + all tests
#   make quick FILTER=parse       # rebuild + parse-related tests only
quick:
	@$(DIAG) --ensure-bs2
	@$(BS2) test $(if $(FILTER),-f $(FILTER))

# OOM-safe full suite: one sequential `bs2 test <dir>` per test dir, with
# per-dir logs + resume markers under build/sweep/ (kill-safe: a re-run
# resumes at the failing dir). FRESH=1 drops the markers first.
sweep:
	@$(DIAG) --sweep $(if $(FRESH),--fresh)

# Repo-wide cache GC: prune cold entries (mtime == last use; hits refresh
# it) from the bootstrap root AND every package cache. DAYS= overrides the
# 30-day default. Builds also auto-GC once a day via a stamp file.
cache-gc:
	@$(DIAG) --cache-gc $(if $(DAYS),$(DAYS))

# Full cache wipe (the documented escape hatch): every
# packages/*/build/cache plus the top-level build/cache — and NOTHING
# else. Guarded so it can never touch a src/ tree (the
# packages/<pkg>/src/build/ SOURCE dirs share the name 'build'; ad-hoc
# find one-liners have eaten them before). Next build is cold.
clean-cache:
	@$(DIAG) --clean-cache

# Just the fixed-point check.
selfhost:
	@$(DIAG) --check-fixedpoint

# Differential test (HRN): build the compiler at the base
# (oracle) and at HEAD, then assert byte-identical IR over the selfhost
# source + the curated standalone corpus (tests/difftest_corpus/*.av — small
# single-file programs giving isolated per-feature IR comparisons). The go-hard
# safety net — a behaviour-preserving change keeps every output identical; a
# divergence fails with a readable diff.
#
#   make diff-test                 # base = integration branch, new = HEAD
#   make diff-test BASE=<ref>      # override the oracle ref
#   make diff-test NEW=<ref>       # override the candidate ref
#   make diff-test PREBUILT=1      # reuse the warm build/bs2 as NEW (skip the
#                                  # cold ~5-7 min rebuild) — LOCAL only, non-
#                                  # hermetic; CI always uses the default build
#   make diff-test CORPUS='path/*.av'   # override the corpus glob
#   make diff-test JOBS=N          # corpus fan-out width (default: ~nproc-1)
diff-test:
	@$(if $(CORPUS),DIFF_TEST_CORPUS='$(CORPUS)' )$(if $(JOBS),DIFF_TEST_JOBS=$(JOBS) )$(DIAG) --diff-test $(if $(BASE),--base $(BASE)) $(if $(NEW),--new $(NEW)) $(if $(PREBUILT),--new-prebuilt)

# Compile and run a single Avra file with the bootstrap compiler.
run:
ifndef FILE
	@echo "usage: make run FILE=path/to/program.av" >&2
	@exit 1
endif
	@$(DIAG) --run $(FILE)

# Compiler self-coverage: build the test binary with --coverage, run it
# through the spec-test harness, render a per-module table.
# Outputs: terminal report + build/coverage/* intermediates.
coverage:
	@$(BS2) test --coverage

# Same, plus LCOV export (consumed by codecov, lcov, etc.).
coverage-lcov:
	@$(BS2) test --lcov build/coverage/compiler.lcov

# Update the seed IR from the current self-hosted compiler.
# Run this after dogfooding new syntax into bootstrap source OR after
# editing a @comptime macro (derive_walker etc) — bs2's compiled macro
# output is baked into seed.ll, so the seed has to be refreshed before
# the new macro expansion takes effect at compile time.
#
#   make update-seed           Safe / committable: verifies bs2 == bs3,
#                              patches seed, full clean rebuild + re-verify.
#                              Use before a commit.
#   make update-seed FAST=1    Inner loop: per-fn diff report against the
#                              old seed, patch, incremental rebuild (no
#                              clean, no fixed-point verify). ~50% faster.
#                              Trade-off: skipped verify catches bs2
#                              corruption later (selfhost at commit time
#                              still gates it).
#
# Only one workflow target — so future agents have ONE answer to "I
# edited a @comptime fn, what now?". The structural fix (live-mode
# bs2 that reads macro source directly, no seed cycle) is filed as
# so07.7.21 and retires this command for the inner loop entirely.
update-seed:
ifeq ($(FAST),1)
	@$(DIAG) --seed-patch
	@$(DIAG) --ensure-bs2
	@echo "seed patched (FAST mode) + bs2 rebuilt — run 'make update-seed' (no FAST) before commit"
else
	@$(DIAG) --build-bs2
	@$(DIAG) --check-fixedpoint
	@cp $(CLI_SRC_DIR)/main.av.ll seed/seed.ll
	@# Prepend provenance comment (commit hash, timestamp, source hash).
	@# Hash both the cli entry and the lib it compiles against so the
	@# seed records exactly what produced it.
	@COMMIT=$$(git rev-parse --short HEAD); \
	 TIMESTAMP=$$(date -u +%Y-%m-%dT%H:%M:%SZ); \
	 SHA256=$$(command -v sha256sum >/dev/null 2>&1 && echo sha256sum || echo "shasum -a 256"); \
	 SRC_HASH=$$(find $(CLI_SRC_DIR)/ $(LIB_SRC_DIR)/ -name '*.av' -exec $$SHA256 {} + | $$SHA256 | cut -d' ' -f1); \
	 { printf '; seed built from commit %s at %s\n; source hash: %s\n' "$$COMMIT" "$$TIMESTAMP" "$$SRC_HASH"; cat seed/seed.ll; } > seed/seed.ll.tmp && \
	 mv seed/seed.ll.tmp seed/seed.ll
	@rm -rf build
	@$(DIAG) --build-bs2
	@echo "seed/seed.ll updated ($$(wc -l < seed/seed.ll | tr -d ' ') lines)"
	@echo "clean rebuild from new seed: OK"
endif


# Patch seed to handle new enum variants.
# Run this BEFORE 'make build' when adding new ValueType/Stmt/Expr variants.
# Converts all match trap blocks to safe fallthrough so the seed doesn't
# crash on unknown enum tags. Different workflow from `update-seed`:
# this preps an existing seed for source that adds variants, before
# bs2 can build at all; `update-seed` requires a working bs2.
seed-patch-traps:
	@$(DIAG) --seed-fetch
	@python3 scripts/patch-seed-traps.py
	@rm -f build/seed build/seed.o
	@echo "seed patched — next 'make build' uses patched seed"

# Publish the local seed as a pinned release artifact + bump seed.lock.
# Integration-branch (seed train) operation — see CLAUDE.md.
seed-publish:
	@$(DIAG) --seed-publish

# The full automated train advance (build from pin, fixed point, suite,
# publish-if-diverged). CI runs this on every integration push; use the
# target for manual advances.
seed-train:
	@$(DIAG) --seed-train

# The PR-side gate: the train's verify phase (build from pin, fixed point,
# suite) WITHOUT publish. CI runs this on every PR into the integration branch
# so a merge can't red the train post-merge; run it locally before opening a PR.
seed-train-verify:
	@$(DIAG) --seed-train-verify

# Verify bootstrap chain integrity (no auto-cycle on failure).
# Builds seed → bs2 → verifies bs2 self-compiles → verifies bs3 self-compiles.
verify-seed:
	@$(DIAG) --verify-seed

# Compare function signatures between seed IR and source .av files.
# Reports parameter count mismatches, new functions, and removed functions.
seed-sigs:
	@$(DIAG) --seed-sigs

# Install the pre-commit + pre-push hooks (idempotent).
install-hooks:
	@ln -sf ../../bootstrap/scripts/pre-commit ../.git/hooks/pre-commit
	@ln -sf ../../bootstrap/scripts/pre-push ../.git/hooks/pre-push
	@echo "installed: .git/hooks/pre-commit -> bootstrap/scripts/pre-commit"
	@echo "installed: .git/hooks/pre-push   -> bootstrap/scripts/pre-push"

# Remove all build artifacts. Source and seed are preserved.
#
# Three nested build-cache locations accumulate per-package shard
# binaries + IR; without explicit removal they hit GB scale and
# trip the pre-commit hook's per_file test mode with ENOSPC:
#   - bootstrap/build/                        (top-level — primary)
#   - packages/*/build/                        (per-package outputs)
#   - packages/*/src/build/cache/              (per-source caches)
# The `find -name cache` clause catches the third — bare `build/`
# under */src/ is itself a source module (e.g. std-avrac/src/build/
# is the build-driver package), so we explicitly DO NOT delete
# directories named `build` under src/, only their cache subdirs.
clean:
	@rm -rf build
	@rm -rf packages/*/build 2>/dev/null || true
	@find packages tests -type d -name 'cache' -path '*/build/*' -prune -exec rm -rf '{}' \; 2>/dev/null || true
	@find packages tests -type d -path '*/src/build/cache' -prune -exec rm -rf '{}' \; 2>/dev/null || true
	@rm -f $(SRC_DIR)/*.av.ll $(SRC_DIR)/*.av.cov.ll $(SRC_DIR)/*.av.ll.cov.ll $(SRC_DIR)/*.av.covmap.json
	@find packages tests -type f \( -name '*.av.ll' -o -name '*.av.cov.ll' -o -name '*.av.ll.cov.ll' -o -name '*.av.covmap.json' -o -name '*.bin' -o -name '*.bin.o' -o -name '*.profraw' -o -name '*.profdata' \) -delete 2>/dev/null || true
	@echo "cleaned: build/ (top-level + nested caches) + per-file IR/coverage/binary artifacts"

# Assemble the canonical grammar from feature fragments.
grammar:
	@echo "# Avra Bootstrap Grammar" > GRAMMAR.md
	@echo "" >> GRAMMAR.md
	@echo "Assembled from \`$(LIB_SRC_DIR)/features/*/grammar.md\`." >> GRAMMAR.md
	@echo "" >> GRAMMAR.md
	@for f in $(LIB_SRC_DIR)/features/*/grammar.md; do echo "---" >> GRAMMAR.md; echo "" >> GRAMMAR.md; cat "$$f" >> GRAMMAR.md; echo "" >> GRAMMAR.md; done
	@echo "assembled GRAMMAR.md ($$(wc -l < GRAMMAR.md | tr -d ' ') lines)"
