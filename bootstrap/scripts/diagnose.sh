#!/usr/bin/env bash
# Bootstrap diagnostic system — single entry point for all dev tooling.
#
# Add new modes by adding a `mode_<name>` function and a case branch in
# main(). Every mode should have a one-liner in print_help() so future
# agents can discover it from `--help` alone.
#
# Design rule: this script is the ONLY place dev tooling lives. If you
# find yourself writing a one-off bash command more than twice, add a
# mode here instead.

set -uo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
BOOTSTRAP_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
REPO_DIR=$(CDPATH= cd -- "$BOOTSTRAP_DIR/.." && pwd)
FORGE_DIR="$REPO_DIR/avra"
BUILD_DIR="$BOOTSTRAP_DIR/build"
SEED_LL="$BOOTSTRAP_DIR/seed/seed.ll"
SEED_LOCK="$BOOTSTRAP_DIR/seed/seed.lock"
SEED_FETCH_CACHE="$BUILD_DIR/cache/seed"
SEED_REPO_SLUG="${AVRA_SEED_REPO:-tristanmatthias/forge-lang}"
SEED_BIN="$BUILD_DIR/seed"
RUNTIME_C="$BOOTSTRAP_DIR/runtime.c"
RUNTIME_O="$BUILD_DIR/runtime.o"
RUNTIME_ASAN_O="$BUILD_DIR/runtime_asan.o"
BS2="$BUILD_DIR/bs2"
BS2_O0="$BUILD_DIR/bs2_O0"
BS2_ASAN="$BUILD_DIR/bs2_asan"
BS2_DEBUG="$BUILD_DIR/bs2_debug"
BS3="$BUILD_DIR/bs3"
# `bs2` is built from the cli package (binary entry); the lib it
# imports lives at LIB_SRC_DIR. source_newer_than watches both so
# any change in either layer rebuilds the seed.
CLI_SRC_DIR="$BOOTSTRAP_DIR/packages/cli/src"
LIB_SRC_DIR="$BOOTSTRAP_DIR/packages/std-avrac/src"
SRC_DIR="$CLI_SRC_DIR"

# Pinned LLVM major. The compiler emits LLVM 19+ IR (`getelementptr inbounds
# nuw …`), so the toolchain must be >= 19; LLVM 21's -O2 miscompiles certain
# ARM64 functions — so 20 exactly. Kept in sync with scripts/bootstrap.sh.
LLVM_MAJOR=20

# Major version an `llvm-config` reports (e.g. "20"), or empty on failure.
_llvm_major_of() { "$1" --version 2>/dev/null | cut -d. -f1; }

# Echo a prefix whose toolchain reports the pinned major, or empty on miss.
# Mirrors scripts/bootstrap.sh's find_llvm_prefix so `make` resolves the right
# LLVM on Linux WITHOUT a manual LLVM_PREFIX export — otherwise the unversioned
# `llvm-config`/`llc` (often llvm-18: runtime-only, no headers; rejects nuw GEP)
# is picked and a cold build fails (missing llvm-c/Core.h, or llc "expected type").
_find_llvm20_prefix() {
  for cfg in "llvm-config-$LLVM_MAJOR" "llvm-config$LLVM_MAJOR"; do
    if command -v "$cfg" >/dev/null 2>&1; then "$cfg" --prefix; return; fi
  done
  for pfx in \
    "/usr/lib/llvm-$LLVM_MAJOR" "/usr/lib64/llvm$LLVM_MAJOR" \
    "/usr/local/llvm-$LLVM_MAJOR" "/opt/llvm-$LLVM_MAJOR" \
    "/opt/homebrew/opt/llvm@$LLVM_MAJOR" "/usr/local/opt/llvm@$LLVM_MAJOR"; do
    if [ -x "$pfx/bin/llvm-config" ] && [ "$(_llvm_major_of "$pfx/bin/llvm-config")" = "$LLVM_MAJOR" ]; then
      echo "$pfx"; return
    fi
  done
}
_llvm20_prefix="$(_find_llvm20_prefix)"

# Platform-portable LLVM discovery (headers + libLLVM). On macOS the Homebrew
# prefix is the default; otherwise prefer a pinned-major install, then fall
# back to whatever `llvm-config` reports so the bootstrap builds without manual
# env setup.
_default_llvm_prefix="/opt/homebrew/opt/llvm"
if [ ! -d "$_default_llvm_prefix" ]; then
  if [ -n "$_llvm20_prefix" ]; then
    _default_llvm_prefix="$_llvm20_prefix"
  elif command -v llvm-config >/dev/null 2>&1; then
    _default_llvm_prefix="$(llvm-config --prefix)"
  fi
fi
LLVM_PREFIX="${LLVM_PREFIX:-$_default_llvm_prefix}"
LLVM_CONFIG="$LLVM_PREFIX/bin/llvm-config"

# Use LLVM 20's llc for code generation (see LLVM_MAJOR above). The runtime
# still links against the default LLVM's libLLVM. Prefer the macOS pinned
# Cellar llc, then a probed pinned-major toolchain, then a version-suffixed
# `llc-20` on PATH, then the llc beside LLVM_PREFIX, then bare `llc`.
LLC_PREFIX="${LLC_PREFIX:-/opt/homebrew/Cellar/llvm/20.1.5}"
if [ -x "$LLC_PREFIX/bin/llc" ]; then
  LLC="${LLC:-$LLC_PREFIX/bin/llc}"
elif [ -n "$_llvm20_prefix" ] && [ -x "$_llvm20_prefix/bin/llc" ]; then
  LLC="${LLC:-$_llvm20_prefix/bin/llc}"
elif command -v "llc-$LLVM_MAJOR" >/dev/null 2>&1; then
  LLC="${LLC:-$(command -v "llc-$LLVM_MAJOR")}"
elif [ -x "$LLVM_PREFIX/bin/llc" ]; then
  LLC="${LLC:-$LLVM_PREFIX/bin/llc}"
else
  LLC="${LLC:-$(command -v llc 2>/dev/null || echo llc)}"
fi

# C++ runtime libLLVM was built against: libc++ on macOS, libstdc++ on a
# typical Linux LLVM packaging. Used wherever the bootstrap links libLLVM.
if [ "$(uname -s)" = "Darwin" ]; then
  CXXLIB="${CXXLIB:--lc++}"
else
  CXXLIB="${CXXLIB:--lstdc++}"
fi

# Main-thread stack size. The bootstrap compiler recurses deeply
# (recursive-descent parser, AST renderers). macOS pins a 32 MiB main
# stack at link time via the ld64 `-stack_size` flag; on Linux the
# main-thread stack derives from RLIMIT_STACK instead, so the flag is
# macOS-only and we raise the soft limit for this process (and every
# binary it spawns) here instead.
if [ "$(uname -s)" = "Darwin" ]; then
  STACK_LDFLAGS="${STACK_LDFLAGS:--Wl,-stack_size,0x2000000}"
else
  STACK_LDFLAGS="${STACK_LDFLAGS:-}"
  ulimit -S -s 65536 2>/dev/null || true
fi

# Relocation model for llc-generated objects. macOS llc defaults to PIC;
# Linux llc defaults to the static model, whose absolute relocations
# (R_X86_64_32) are incompatible with the PIE executables modern Linux
# toolchains link by default. Emit PIC on Linux to match macOS and link
# cleanly into a PIE.
if [ "$(uname -s)" = "Darwin" ]; then
  LLC_RELOC="${LLC_RELOC:-}"
else
  LLC_RELOC="${LLC_RELOC:--relocation-model=pic}"
fi

# Portable SHA-256. macOS ships Perl's `shasum`; Linux ships coreutils'
# `sha256sum`. Both accept file arguments and stdin and print the digest
# as field 1, so one command string works in pipes and `find -exec` alike
# (kept as an unquoted word-splitting variable, not a function, precisely
# so `find … -exec $SHA256_CMD {} +` resolves to a real executable).
if command -v sha256sum >/dev/null 2>&1; then
  SHA256_CMD="sha256sum"
else
  SHA256_CMD="shasum -a 256"
fi

# Linker selection. The bootstrap mangles symbols with a leading `@`
# (e.g. `@std::avrac::core::Foo__bar`). GNU ld reads `@` as the
# symbol-versioning separator and rejects the whole object
# ("multiple definition of `no symbol'"); LLD treats `@` in defined
# symbols literally. So on Linux link with LLD when it's available.
# macOS uses its default ld64 (which has no such `@` semantics).
if [ "$(uname -s)" = "Darwin" ]; then
  LD_SELECT="${LD_SELECT:-}"
elif command -v ld.lld >/dev/null 2>&1; then
  LD_SELECT="${LD_SELECT:--fuse-ld=lld}"
else
  LD_SELECT="${LD_SELECT:-}"
fi

# Export the dynamic symbol table on every binary we link. The compiler hosts an
# in-process MCJIT (the @comptime JIT fold, ps3t.5.2.1); a JIT'd body reaches back
# into the host for any runtime symbol its codegen emits (e.g. a float literal
# lowers to `avra_float_parse`), and MCJIT resolves those through
# dlsym(RTLD_DEFAULT, …) against the host's dynamic symbol table. Without
# `-rdynamic` that table is empty, the reference resolves to null, and the JIT'd
# code segfaults on the first call. clang and gcc both accept `-rdynamic` (Linux
# → `--export-dynamic`, macOS → `-export_dynamic`). Applied uniformly so no
# compiler binary — however it's built — can miss it; the extra symbols on a
# plain fixture binary are harmless.
EXPORT_DYNAMIC="${EXPORT_DYNAMIC:--rdynamic}"

LLVM_WRAPPER_O="$BUILD_DIR/llvm_wrapper.o"

# The integration branch the seed train runs on. Feature
# branches never cycle the seed; --check-bootstrap-window verifies a
# branch against this branch's pristine seed. Override per-repo or
# per-invocation with AVRA_INTEGRATION_BRANCH.
INTEGRATION_BRANCH="${AVRA_INTEGRATION_BRANCH:-feat/crafting-intepreters}"

C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[0;33m'
C_BLUE='\033[0;34m'
C_DIM='\033[2m'
C_RESET='\033[0m'

log()  { printf "${C_BLUE}[diag]${C_RESET} %s\n" "$*" >&2; }
ok()   { printf "${C_GREEN}[ok]${C_RESET}   %s\n" "$*" >&2; }
warn() { printf "${C_YELLOW}[warn]${C_RESET} %s\n" "$*" >&2; }
err()  { printf "${C_RED}[err]${C_RESET}  %s\n" "$*" >&2; }
die()  { err "$*"; exit 1; }

# Check if any .av source file is newer-or-equal-mtime to a target binary.
# Returns 0 (true) if rebuild is needed, 1 (false) if up to date.
#
# `find -newer` uses STRICT-greater mtime comparison, which silently
# missed APFS second-granularity races: a source edit that happens in
# the same second as the previous bs2 build produced equal mtimes,
# `find -newer` returned empty, and the next `make build` skipped
# rebuilding even though the source had genuinely changed. Compare
# explicit mtimes with `-ge` instead so same-second ties are treated
# as "source might be newer" and trigger a conservative rebuild.
#
# Cost of the false-positive case (no source change but mtimes equal,
# e.g. after `touch -r`): one extra rebuild. Vastly preferable to a
# silent stale-binary bug.
# 6cks: portable epoch-mtime stat. GNU coreutils spells it `stat -c %Y`;
# BSD/macOS spells it `stat -f %m`. The BSD spelling was hardcoded, so on
# Linux the probe misbehaved by coreutils version — either `stat -f`
# errored (freshness degraded to "always stale": every ensure-bs2 paid an
# unconditional ~40s rebuild) or printed a MOUNT POINT (the `-ge` compare
# then failed non-numerically: "never stale", silently serving a stale
# binary). Probe the GNU spelling once against `.`; consumers word-split
# $STAT_MTIME deliberately.
if stat -c %Y . >/dev/null 2>&1; then
  STAT_MTIME="stat -c %Y"
else
  STAT_MTIME="stat -f %m"
fi

source_newer_than() {
  local target="$1"
  [ ! -x "$target" ] && return 0
  local target_mtime
  target_mtime=$($STAT_MTIME "$target" 2>/dev/null) || return 0
  local newest_src
  newest_src=$(find "$CLI_SRC_DIR" "$LIB_SRC_DIR" -name '*.av' -exec $STAT_MTIME {} + 2>/dev/null | sort -rn | head -1)
  [ -z "$newest_src" ] && return 1   # no sources found — pathological
  [ "$newest_src" -ge "$target_mtime" ]
}

print_help() {
  cat <<'EOF'
bootstrap/scripts/diagnose.sh — single entry point for bootstrap dev tooling

USAGE
  diagnose.sh <mode> [args]

BUILD MODES
  --build              Rebuild stage1 (host → stage1 binary) + run all stage1 tests.
  --build-runtime      Compile avra/stdlib/runtime.c → build/runtime.o.
  --build-bs2          Compile packages/cli/src/main.av with stage1 → build/bs2.
  --ensure-bs2         Build bs2 if source changed; SKIP self-compile verify.
                       Inner-loop convenience — use --build-bs2 before commits.
  --build-O0           Build bs2 at -O0 (no optimization) for debuggability.
                       Makes lldb usable with breakpoints and variable inspection.
                       Output: build/bs2_O0.
  --build-debug        Build bs2 with --debug-null (null argument detection).
                       Emits null checks at every function entry for ptr/struct/enum
                       parameters. Catches null propagation at the source.
                       Output: build/bs2_debug.
  --build-bs2-asan     Same as --build-bs2 but link with -fsanitize=address.
  --build-bs3          Compile packages/cli/src/main.av with bs2 → build/bs3.
                       (The fixed-point self-host check.)
  --check-fixedpoint   Verify bs2 and bs3 emit byte-identical IR for
                       packages/cli/src/main.av. The single most important
                       self-hosting invariant — if this fails, a recent
                       commit broke the bootstrap chain. Wired into the
                       pre-commit hook when packages/cli/src/ or
                       packages/std-avrac/src/ is touched.

RUN MODES
  --run    <file.av>   Compile <file.av> with bs2, link, run. Prints stdout.
  --rc-strict-suite [f] Run the spec suite under AVRA_RC_STRICT=1 (rcsf.3):
                       poison-on-free + reuse quarantine + abort on release of
                       already-freed RC memory. Validates the compiler's own
                       RC discipline AND every test program's. Optional filter.
  --link-run <file.ll> Link a pre-emitted .ll into a binary and run it (no
                       recompile). Prints stdout. Used to execute the EXACT
                       artifact a prior `bs2 compile` produced.
  --run-stage1 <file.av>
                       Same but with stage1 (the host-built bootstrapc).
  --check  <file.av>   Run bs2's parse+resolve only — no codegen, no link.
  --ll     <file.av>   Emit LLVM IR via bs2 to stdout (don't link or run).
  --ll-stage1 <file.av>
                       Same with stage1.

DIFF & ANALYSIS
  --diff   <file.av>   Compile <file.av> with both stage1 and bs2, diff
                       the resulting .ll files. Highlights divergence.
  --diff-fn <file.av> <fn>
                       Same as --diff but only shows the body of one
                       function.
  --diff-test [--base <ref>] [--new <ref>] [--new-prebuilt] [--run-equiv]
                       Differential test (HRN): build the
                       compiler at OLD (oracle, default integration branch)
                       and NEW (default HEAD) and assert byte-identical IR
                       over the selfhost source + curated standalone corpus
                       (tests/difftest_corpus/*.av). The two selfhost compiles
                       run concurrently; the corpus fans out in parallel. The
                       go-hard safety net. --new-prebuilt reuses build/bs2 as
                       NEW (skip the cold rebuild; LOCAL, non-hermetic).
                       DIFF_TEST_CORPUS=<glob> overrides the corpus;
                       DIFF_TEST_JOBS=<n> the fan-out width.
  --cache-fuzz [N] [SEED]
                       The canonical "is the cache lying to me" check
                       (pdme.9). N seeded edit/damage iterations against a
                       sandbox package; every iteration asserts the CACHED
                       compile's IR is byte-identical to a cache-bypassed
                       recompute, and a final revert must restore the
                       golden IR. Default N=20, SEED=42; seconds to run.
  --sweep [--fresh] [dir ...]
                       OOM-safe full-suite runner: one sequential
                       `bs2 test <dir>` per test directory (default:
                       tests/ + packages/**/tests) with per-dir logs and
                       .ok resume markers under build/sweep. Stops LOUDLY
                       at the first red dir; a re-run resumes there.
                       --fresh drops the markers. This is the sanctioned
                       way to run the full suite on a ≤16GB box.
  --score  [file.ll]   Score an emitted IR file. Counts ret-undef, orphan
                       blocks, missing terminators, wide-store-into-
                       narrow-malloc bugs, and similar quality smells.
                       Lower is better. Wide-store hits are fatal (the
                       heap-corruption bug class) and exit non-zero.
                       Defaults to the most recently emitted .ll.
  --rank   <file.av>   Rank functions in <file.av>'s emitted IR by line
                       count — useful for spotting bloat.

HEAP / MEMORY DEBUGGING
  --asan   <file.av>   Run bs2_asan on <file.av>. AddressSanitizer
                       reports the exact alloc/use-after-free site.
                       Builds bs2_asan if missing.
  --malloc-trace <file.av>
                       Run bs2 under MallocStackLogging + DYLD malloc
                       guard. Crash dumps include the alloc backtrace.
  --bisect-lines <file.av>
                       Binary-search the line count of <file.av> to find
                       the smallest prefix that still makes bs2 crash.
                       Useful for isolating heap-corruption triggers.

SEED MANAGEMENT
  --seed-status          Compare seed vs current source: show new, removed,
                         and changed functions. First thing to check when a
                         build fails.
  --seed-diff [fn]       Show IR diff between seed and fresh compile. With a
                         function name, shows just that function's diff.
  --build-seed           Build the seed binary from seed/seed.ll.
  --update-seed          Copy current bs2 output to seed/seed.ll with
                         provenance metadata (commit, timestamp, source hash).
  --verify-seed          Verify bootstrap chain integrity WITHOUT auto-cycle.
                         Builds seed → bs2 → verifies bs2 can self-compile →
                         verifies the resulting binary can also self-compile.
                         Prints OK or specific failure point. Use this to
                         check seed health before committing.
  --seed-patch           Incremental seed update. Compiles main.av with
                         bs2, diffs against seed/seed.ll per-function, copies
                         the new IR to seed, and reports exactly which
                         functions changed. Much faster feedback loop than
                         a full 'make update-seed' because it skips the
                         verify-seed rebuild. Use when iterating on source.
  --seed-sigs            Compare function signatures (parameter counts)
                         between seed/seed.ll and the bootstrap source
                         (packages/cli/src and packages/std-avrac/src). Reports
                         mismatches, new functions, and removed functions.
                         Catches the most common seed staleness issue:
                         parameter count changes that cause silent corruption.
  --check-bootstrap-window [ref]
                         Enforce the seed-train rule. Gate 1: no commit on
                         this branch (since the merge-base with the
                         integration branch) CHANGES the pinned seed content
                         (seed.lock bumps; seed.ll commits on pre-lock
                         history). Gate 2: HEAD's compiler source (what a
                         push ships — untracked/uncommitted files don't
                         count) builds from the integration branch's CURRENT
                         pristine seed in an isolated tree (cold unit cache)
                         and the produced compiler passes a smoke run.
                         [ref] defaults to origin/$AVRA_INTEGRATION_BRANCH
                         (feat/crafting-intepreters). Result is cached in
                         build/window/.window_verified keyed on the
                         integration seed + compiler sources; bypass with
                         AVRA_FORCE_WINDOW=1. Wired into the pre-push hook
                         and the bootstrap-window CI workflow.
  --seed-merge [--base ours|theirs|<ref>]
                         One-command seed-merge staging. For a merge where
                         the seed pin conflicted (seed.lock, or seed.ll on
                         pre-lock history): picks a base seed (default:
                         tries ours, then theirs), patches match traps,
                         builds stage1, compiles the merged source, links
                         bs2, self-compile verifies, then regenerates the
                         seed (--update-seed) and verifies the fixed point.
                         On a stage failure it reports the failure class —
                         parse / extern-guard / corruption — with next-step
                         hints, and falls through to the next candidate.
                         Recipe + taxonomy: docs/SEED_MERGES.md.
  --seed-merge-classify <rc> <logfile>
                         INTERNAL (spec-tested): print the --seed-merge
                         failure class for a stage-compile exit code + log.
  --seed-fetch           Materialize seed/seed.ll from seed/seed.lock
                         (pin-don't-vendor): download the pinned
                         GitHub Releases artifact, verify its sha256,
                         install it. No-op when seed.ll already exists —
                         a locally cycled seed is never clobbered.
  --seed-publish         Publish the local seed/seed.ll as a GitHub
                         Releases artifact (tag seed/v<N>) and bump
                         seed/seed.lock to pin it. Needs GH_TOKEN with
                         Contents:write. Lock bumps belong on the
                         integration branch (the seed train) —
                         gate 1 rejects them elsewhere at push time.
  --seed-fetch-from <lock> <dest>
                         INTERNAL (spec-tested): materialize+verify a
                         seed from an arbitrary lock file (file:// URLs
                         work, which is how the spec stays hermetic).
  --write-seed-lock <lock> <version> <sha256> <url>
                         INTERNAL (spec-tested): write a lock in the
                         exact format --seed-publish produces, so the
                         writer/parser round-trip is pinned by spec.
  --seed-train           The automated train advance: build from the
                         pin (no auto-cycle), verify the fixed point,
                         run the spec suite, then publish + bump the
                         lock ONLY when the compiler's output diverged
                         from the pinned artifact (provenance aside).
                         Run by .github/workflows/seed-train.yml on
                         every integration push; `make seed-train`
                         for manual advances.
  --seed-train-verify    The PR-side seed-train gate (read-only): run the
                         train's verify phase — build from the pin, check
                         the fixed point, run the spec suite — but STOP
                         before publish. Run by seed-train-verify.yml on
                         every PR into the integration branch so a merge
                         cannot land something that reds the train
                         post-merge. `make seed-train-verify` runs it
                         locally.
  --seed-verify-fp       Echo the (integration-seed × compiler-source)
                         fingerprint that keys the seed-train suite-skip
                         cache. seed-train-verify writes a PASS marker
                         under it; seed-train skips its redundant suite
                         re-run when the marker is present (build + fixed
                         point + publish still run). Same content hash on
                         a PR's merge ref and the squash commit, so the
                         pre-merge verify covers the post-merge train.
  --seed-canonical-sha <file>
                         INTERNAL (spec-tested): sha256 of a seed IR
                         with provenance comment lines stripped — the
                         train's "did the compiler change" identity.
  --seed-inputs-hash <seed.ll> [runtime.c] [llvm_wrapper.c]
                         INTERNAL (spec-tested): the path-independent
                         seed-binary input fingerprint (seed IR + C
                         link inputs) that keys build/seed and the
                         window's reuse fast path.
  --seed-self-contained <seed.ll>
                         INTERNAL (spec-tested): exit 0 iff the IR
                         defines every Avra-package symbol it uses (no
                         mangled extern declares) — the train's guard
                         that a pin can bootstrap a fresh clone with no
                         other objects.
  --slot-exec <cmd...>   Run <cmd> while holding one of AVRA_FIXTURE_JOBS
                         (default 2) cross-process compile slots — the
                         OOM guard bounding concurrent bs2 fixture
                         compiles during parallel test runs. --run takes
                         a slot automatically; use this to wrap direct
                         `bs2 compile` shell-outs.

  NOTE: 'make build' now AUTO-CYCLES the seed when self-compile fails.
  You rarely need to run 'make update-seed' manually anymore.

ENVIRONMENT
  LLVM_PREFIX  Override the LLVM install prefix.
  AVRA_VERIFY_RC=1  Machine-check the alloca zero-init invariant (zm77
               guard) on every compiled module; violations fail the build
               naming fn+slot. Always on during --build-bs2's self-compile
               integrity check.
  AVRA_RC_STRICT=1  Runtime sibling of AVRA_VERIFY_RC (rcsf.3): poison freed
               RC payloads (0xDD), quarantine them from reuse, and ABORT with
               a backtrace when a release path receives a pointer to already-
               freed RC memory (the zm77 phantom-release signature). Turns a
               silent corruption into a loud, first-offense abort. Exercised
               by --rc-strict-suite.
               Default: /opt/homebrew/opt/llvm

EXAMPLES
  diagnose.sh --build               # rebuild stage1 from rust + run tests
  diagnose.sh --build-bs2           # build the self-compiled bs2
  diagnose.sh --run /tmp/hello.av   # run a .av file with bs2
  diagnose.sh --diff /tmp/hello.av  # see how stage1 and bs2 diverge
  diagnose.sh --asan /tmp/big.av    # find heap corruption with ASan
  diagnose.sh --seed-patch            # incremental seed update with diff report
EOF
}

# ─────────────────────────────────────────────────────────────────────
# Build helpers
# ─────────────────────────────────────────────────────────────────────

ensure_runtime() {
  local cur_hash; cur_hash=$(md5sum "$RUNTIME_C" 2>/dev/null || md5 -q "$RUNTIME_C" 2>/dev/null)
  local hash_file="$BUILD_DIR/.runtime_hash"
  local old_hash; old_hash=$(cat "$hash_file" 2>/dev/null)
  if [ ! -f "$RUNTIME_O" ] || [ "$cur_hash" != "$old_hash" ]; then
    mkdir -p "$BUILD_DIR"
    log "compiling runtime → $RUNTIME_O"
    cc -c -O0 -g -o "$RUNTIME_O" "$RUNTIME_C" || die "runtime build failed"
    echo "$cur_hash" > "$hash_file"
  fi
}

ensure_runtime_asan() {
  # Mirror ensure_runtime's hash-comparison invalidation — mtime
  # comparison (`-nt`) is vulnerable to the same APFS second-
  # granularity race source_newer_than was fixed for.
  local cur_hash; cur_hash=$(md5sum "$RUNTIME_C" 2>/dev/null || md5 -q "$RUNTIME_C" 2>/dev/null)
  local hash_file="$BUILD_DIR/.runtime_asan_hash"
  local old_hash; old_hash=$(cat "$hash_file" 2>/dev/null)
  if [ ! -f "$RUNTIME_ASAN_O" ] || [ "$cur_hash" != "$old_hash" ]; then
    mkdir -p "$BUILD_DIR"
    log "compiling runtime (ASan) → $RUNTIME_ASAN_O"
    cc -c -O0 -g -fsanitize=address -o "$RUNTIME_ASAN_O" "$RUNTIME_C" \
      || die "runtime ASan build failed"
    echo "$cur_hash" > "$hash_file"
  fi
}

ensure_llvm_wrapper() {
  local wrapper_src="$BOOTSTRAP_DIR/llvm_wrapper.c"
  local wrapper_hash="$BUILD_DIR/.llvm_wrapper_hash"
  local cur_hash; cur_hash=$(md5sum "$wrapper_src" 2>/dev/null || md5 -q "$wrapper_src" 2>/dev/null)
  local old_hash; old_hash=$(cat "$wrapper_hash" 2>/dev/null)
  if [ ! -f "$LLVM_WRAPPER_O" ] || [ "$cur_hash" != "$old_hash" ]; then
    log "compiling LLVM wrapper → $LLVM_WRAPPER_O"
    mkdir -p "$BUILD_DIR"
    cc -c -O2 -I"$LLVM_PREFIX/include" -o "$LLVM_WRAPPER_O" "$wrapper_src" \
      || die "LLVM wrapper build failed"
    echo "$cur_hash" > "$wrapper_hash"
  fi
}

# ── Seed lock: pin-don't-vendor ──
#
# The seed artifact is PINNED, not vendored (Rust stage0 model):
# seed/seed.lock (tracked, a few lines) names a version, the sha256 of
# the uncompressed seed IR, and a GitHub Releases download URL.
# seed/seed.ll itself is a gitignored local materialization — fetched
# on demand, or written locally by `make update-seed` during dev
# iteration. The lock advances only on the integration branch (the
# seed train), published via --seed-publish.

# Read one `key = value` field from a lock file ($1=file, $2=key).
seed_lock_field() {
  sed -n "s/^[[:space:]]*$2[[:space:]]*=[[:space:]]*//p" "$1" 2>/dev/null | head -1
}

# Materialize a seed .ll from a lock file: $1=lockfile, $2=dest.ll.
# Downloads the gz artifact (content-cached by sha under
# build/cache/seed/), verifies the UNCOMPRESSED sha256, installs
# atomically. An existing dest with the right hash short-circuits.
#
# Every failure RETURNS non-zero (with the reason on stderr) instead
# of die-ing: callers decide severity — the build path aborts, while
# --seed-merge falls through to its next candidate seed.
fetch_seed_from_lock() {
  [ $# -eq 2 ] || die "usage: fetch_seed_from_lock <lockfile> <dest.ll>"
  local lock="$1" dest="$2"
  [ -f "$lock" ] || { err "no seed lock at $lock"; return 1; }
  # An unresolved merge leaves conflict markers in the lock, and the
  # field parser would silently serve the FIRST (ours) side as if the
  # merge were resolved. Refuse: the resolution is taking the HIGHER
  # version line, and it must be deliberate.
  if grep -qE '^(<<<<<<< |=======$|>>>>>>> )' "$lock"; then
    err "seed lock $lock contains merge-conflict markers — resolve the merge first"
    err "(artifacts are immutable: take the HIGHER version line; docs/SEED_MERGES.md)"
    return 1
  fi
  local want_sha url version
  want_sha=$(seed_lock_field "$lock" sha256)
  url=$(seed_lock_field "$lock" url)
  version=$(seed_lock_field "$lock" version)
  [ -n "$want_sha" ] && [ -n "$url" ] \
    || { err "malformed seed lock $lock (need sha256 + url)"; return 1; }

  if [ -f "$dest" ] \
     && [ "$($SHA256_CMD "$dest" | awk '{print $1}')" = "$want_sha" ]; then
    return 0
  fi

  mkdir -p "$SEED_FETCH_CACHE"
  # The cache is content-addressed by the PINNED sha, but trust nothing:
  # re-verify on the hit path too, so a truncated or tampered cache
  # entry is dropped and refetched instead of installed. (A mutation
  # test that disabled download-side verification poisoned this cache
  # and the hit path happily served the poison — hence this check.)
  local cached="$SEED_FETCH_CACHE/$want_sha.ll"
  if [ -f "$cached" ] \
     && [ "$($SHA256_CMD "$cached" | awk '{print $1}')" != "$want_sha" ]; then
    warn "dropping corrupt seed cache entry $cached (content does not match its name)"
    rm -f "$cached"
  fi
  if [ ! -f "$cached" ]; then
    log "fetching seed v${version:-?} from $url"
    local gz="$SEED_FETCH_CACHE/$want_sha.ll.gz.tmp.$$"
    # Deliberately NO Authorization header: the URL comes from the lock
    # file, and shipping a credential to an attacker-controlled host is
    # how tokens leak. Release assets on this (public) repo download
    # anonymously; integrity comes from the sha256 pin, not the channel.
    if ! curl -fsSL --retry 3 --connect-timeout 15 --max-time 600 -o "$gz" "$url"; then
      rm -f "$gz"
      err "seed fetch failed: $url"
      err "Offline? A previously materialized seed/seed.ll keeps working; otherwise"
      err "obtain the artifact for lock v${version:-?} (sha256 $want_sha) and place it"
      err "at $dest."
      return 1
    fi
    # Cap the decompressed size: the hash pin stops SUBSTITUTION but
    # not EXPANSION — a small gzip of endless zeros would fill the
    # disk before verification ever ran. head truncates at the cap;
    # a truncated legitimate artifact then fails the hash check.
    # (AVRA_SEED_MAX_BYTES exists so the spec can exercise the cap
    # without writing gigabytes.)
    local max_bytes="${AVRA_SEED_MAX_BYTES:-2147483648}"
    if ! gunzip -c "$gz" | head -c "$max_bytes" > "$cached.tmp.$$"; then
      rm -f "$gz" "$cached.tmp.$$"
      err "seed artifact gunzip failed (truncated download, or larger than $max_bytes bytes)"
      return 1
    fi
    rm -f "$gz"
    local got_sha
    got_sha=$($SHA256_CMD "$cached.tmp.$$" | awk '{print $1}')
    if [ "$got_sha" != "$want_sha" ]; then
      rm -f "$cached.tmp.$$"
      err "seed artifact hash mismatch: lock pins $want_sha, artifact is $got_sha — refusing"
      return 1
    fi
    mv "$cached.tmp.$$" "$cached"
  fi
  mkdir -p "$(dirname "$dest")"
  if ! cp "$cached" "$dest.tmp.$$" || ! mv "$dest.tmp.$$" "$dest"; then
    rm -f "$dest.tmp.$$"
    err "failed to install materialized seed at $dest (cp/mv failed)"
    return 1
  fi
  log "seed v${version:-?} materialized at $dest (sha256 verified)"
}

# Write a seed lock pinning one artifact: $1=lock path, $2=version,
# $3=sha256 of the uncompressed IR, $4=download URL. The single
# producer of the lock format seed_lock_field parses — spec-tested as
# a round-trip so the two can never drift apart silently.
write_seed_lock() {
  local lock="$1" version="$2" sha="$3" url="$4"
  cat > "$lock" <<EOF
# Avra bootstrap seed lock — pin-don't-vendor.
# seed/seed.ll is NOT in git: the build fetches this pinned artifact and
# verifies the sha256 of the uncompressed IR. The lock advances only on
# the integration branch (the seed train) via:
#   bash scripts/diagnose.sh --seed-publish
# Merge conflict on this file = two train advances raced; take the
# HIGHER version line (artifacts are immutable). docs/SEED_MERGES.md.
version = $version
sha256 = $sha
url = $url
EOF
}

# Ensure seed/seed.ll exists locally: present = use as-is (it may
# legitimately be AHEAD of the lock during dev iteration — never
# clobber); missing = fetch per the lock (the fresh-clone path).
ensure_seed_materialized() {
  [ -f "$SEED_LL" ] && return 0
  [ -f "$SEED_LOCK" ] || die "neither seed/seed.ll nor seed/seed.lock exists — repo is corrupt"
  fetch_seed_from_lock "$SEED_LOCK" "$SEED_LL" \
    || die "could not materialize the pinned seed (reasons above)"
}

mode_seed_fetch() {
  ensure_seed_materialized
  ok "$SEED_LL"
}

# The sha256 of a ref's EFFECTIVE seed content: the tracked seed.ll
# blob hashed directly (pre-lock history), or the lock's pinned sha256
# (lock-era). Empty when the ref has neither. Lets gate 1 compare seed
# SEMANTICS across the vendored→pinned transition instead of file
# paths — the vendored→pinned migration commit touches both files without
# changing the seed.
ref_seed_sha256() {
  local r="$1"
  if git -C "$REPO_DIR" rev-parse --verify --quiet "$r:bootstrap/seed/seed.ll" >/dev/null; then
    git -C "$REPO_DIR" cat-file blob "$r:bootstrap/seed/seed.ll" | $SHA256_CMD | awk '{print $1}'
  elif git -C "$REPO_DIR" rev-parse --verify --quiet "$r:bootstrap/seed/seed.lock" >/dev/null; then
    local tmp; tmp=$(mktemp)
    git -C "$REPO_DIR" cat-file blob "$r:bootstrap/seed/seed.lock" > "$tmp"
    seed_lock_field "$tmp" sha256
    rm -f "$tmp"
  fi
}

# Publish the CURRENT local seed/seed.ll as a release artifact and
# bump seed/seed.lock to pin it. Seed-train discipline: lock bumps
# belong on the integration branch only (gate 1 of the bootstrap
# window rejects them elsewhere at push time).
mode_seed_publish() {
  [ -f "$SEED_LL" ] || die "no local seed at $SEED_LL — build one first (make update-seed)"
  [ -n "${GH_TOKEN:-}" ] || die "--seed-publish needs GH_TOKEN (Contents:write on $SEED_REPO_SLUG)"
  command -v python3 >/dev/null || die "--seed-publish needs python3 (JSON handling)"

  local cur_branch
  cur_branch=$(git -C "$REPO_DIR" rev-parse --abbrev-ref HEAD)
  if [ "$cur_branch" != "$INTEGRATION_BRANCH" ]; then
    warn "publishing from '$cur_branch' (the lock normally advances on '$INTEGRATION_BRANCH' only)"
  fi

  local version=1
  if [ -f "$SEED_LOCK" ]; then
    local prev; prev=$(seed_lock_field "$SEED_LOCK" version)
    if [ -n "$prev" ]; then
      case "$prev" in
        *[!0-9]*) die "seed lock version '$prev' is not a number — fix seed/seed.lock first" ;;
      esac
      version=$((prev + 1))
    fi
  fi
  local sha tag
  sha=$($SHA256_CMD "$SEED_LL" | awk '{print $1}')
  tag="seed/v$version"

  local staging="$BUILD_DIR/seed_publish"
  mkdir -p "$staging"

  # A corrupt pin bricks every fresh clone until the next train
  # advance, so prove the artifact is a working compiler before it
  # becomes the pin: build a stage binary from it and smoke-run a
  # compile. ~60-90s on a rare operation; AVRA_SKIP_PUBLISH_VERIFY=1
  # for genuine emergencies only.
  if [ "${AVRA_SKIP_PUBLISH_VERIFY:-0}" != "1" ]; then
    ensure_runtime
    ensure_llvm_wrapper
    log "verifying the seed before publishing (stage build + smoke)"
    llc_link_bin "$SEED_LL" "$staging/verify.o" "$staging/verify_bin" "$staging/verify.build.log"       || { cat "$staging/verify.build.log" >&2; die "seed fails to build — refusing to publish a broken artifact"; }
    smoke_test_compiler "$staging" "$staging/verify_bin"       || die "seed binary fails the smoke run — refusing to publish a broken artifact"
  fi

  log "compressing seed.ll for upload"
  gzip -9 -c "$SEED_LL" > "$staging/seed.ll.gz" || die "gzip failed"

  local commit api="https://api.github.com/repos/$SEED_REPO_SLUG"
  commit=$(git -C "$REPO_DIR" rev-parse HEAD)
  log "creating release $tag on $SEED_REPO_SLUG (target $commit)"
  local rel_json rel_id
  rel_json=$(curl -fsS --connect-timeout 15 --max-time 180 --retry 3 -X POST -H "Authorization: Bearer $GH_TOKEN" \
    -H "Content-Type: application/json" "$api/releases" \
    -d "{\"tag_name\":\"$tag\",\"target_commitish\":\"$commit\",\"name\":\"bootstrap seed v$version\",\"body\":\"Avra bootstrap seed artifact, pinned by bootstrap/seed/seed.lock.\\nsha256 (uncompressed): $sha\",\"prerelease\":true}") \
    || die "release create failed for $tag (already exists? bump again or delete it)"
  rel_id=$(printf '%s' "$rel_json" | python3 -c 'import json,sys; print(json.load(sys.stdin)["id"])') \
    || die "could not parse release id"
  log "uploading seed.ll.gz ($(du -h "$staging/seed.ll.gz" | cut -f1 | tr -d ' '))"
  curl -fsS --connect-timeout 15 --max-time 300 --retry 3 -X POST -H "Authorization: Bearer $GH_TOKEN" \
    -H "Content-Type: application/gzip" \
    --data-binary @"$staging/seed.ll.gz" \
    "https://uploads.github.com/repos/$SEED_REPO_SLUG/releases/$rel_id/assets?name=seed.ll.gz" \
    >/dev/null || {
      # Drop the asset-less release so a retry can recreate the same
      # tag instead of dying on "already exists".
      curl -fsS --connect-timeout 15 --max-time 60 -X DELETE -H "Authorization: Bearer $GH_TOKEN" \
        "$api/releases/$rel_id" >/dev/null 2>&1 || :
      die "asset upload failed (release $tag rolled back — safe to retry)"
    }

  write_seed_lock "$SEED_LOCK" "$version" "$sha" \
    "https://github.com/$SEED_REPO_SLUG/releases/download/$tag/seed.ll.gz"
  rm -f "$staging/seed.ll.gz"
  ok "published $tag and pinned it in seed/seed.lock"
  log "next: git add bootstrap/seed/seed.lock && commit (a 'chore(seed): cycle' train commit)"
}

# Advance the seed train: after a merge lands on the integration
# branch, decide whether the pinned seed is stale relative to the
# merged compiler source and publish + pin the regenerated seed when
# it is. Run by .github/workflows/seed-train.yml after every
# integration push (or manually via `make seed-train`). With the
# train automated, the full loop is: feature branches never cycle
# (gate-enforced) → merge → CI advances the pin → everyone dogfoods
# on rebase.
mode_seed_train() {
  # Verify exactly what the PR gate verifies — shared code path, so parity is
  # by construction — then publish. seed_train_verify sets NO_AUTOCYCLE, so the
  # train never papers over a pin that can't build the merged source.
  seed_train_verify "seed train"

  # The published seed MUST be self-contained: a fresh clone bootstraps
  # it via seed.ll -> llc + cc -> seed binary with no other objects. The
  # build above may have used the metadata fast-path (AVRA_USE_METADATA
  # + AVRA_LIB_OBJS), which leaves @std symbols as EXTERN DECLARATIONS in
  # main.av.ll rather than definitions — fine for an incremental link,
  # fatal for a pin (the 2026-06-13 first-train failure: such a seed
  # bricks every fresh clone with undefined @std symbols). Recompile
  # hermetically (metadata fast-path stripped) so the candidate defines
  # every symbol it references; this also makes the divergence compare
  # below apples-to-apples against the (self-contained) pinned artifact.
  log "seed train: regenerating a self-contained seed IR (hermetic compile)"
  ( cd "$BOOTSTRAP_DIR" && hermetic_compile_env "$BS2" compile "$SRC_DIR/main.av" ) \
    >"$BUILD_DIR/seed_train.hermetic.log" 2>&1 \
    || { cat "$BUILD_DIR/seed_train.hermetic.log" >&2; die "hermetic recompile failed — cannot produce a self-contained seed"; }

  # Publish only when the compiler's OUTPUT changed: compare the
  # generation-2 IR against the pinned artifact, provenance aside.
  # Doc-only / test-only merges advance nothing.
  local candidate="$SRC_DIR/main.av.ll"
  [ -f "$candidate" ] || die "no generated IR at $candidate after the hermetic recompile"
  # Self-containment is enforced at the seed-writing chokepoint
  # (mode_update_seed), so it holds for `make update-seed` too — not
  # only this path.
  local pinned="$BUILD_DIR/seed_train.pinned.ll"
  fetch_seed_from_lock "$SEED_LOCK" "$pinned" \
    || die "cannot fetch the pinned artifact (the train needs network to publish anyway)"
  if [ "$(seed_canonical_sha "$pinned")" = "$(seed_canonical_sha "$candidate")" ]; then
    ok "seed train: the pin already matches the compiler's output — nothing to publish"
    return 0
  fi

  log "seed train: compiler output diverged from the pin — advancing"
  mode_update_seed
  mode_seed_publish
  ok "seed train advanced — commit bootstrap/seed/seed.lock to complete the cycle"
}

# The fingerprint that keys the seed-train suite-skip cache: the integration
# seed identity × every compiler-source blob at HEAD (window_fingerprint, the
# same content hash the bootstrap-window verify cache uses). It is IDENTICAL
# whenever a PR's seed-train-verify already ran the full suite on the same seed
# and same compiler source as the merged HEAD — a squash merge preserves the
# source blobs, so the merge ref the PR tested and the squash commit on the
# integration branch hash to the same value. seed-train-verify publishes a PASS
# marker under this fingerprint on success; seed-train skips its redundant suite
# re-run when the marker is present. A concurrent merge that changed the seed or
# the compiler source yields a DIFFERENT fingerprint → no marker → the suite
# runs, so the 4szi.1 "untested combination" safety net stays intact.
seed_verify_fingerprint() {
  local head; head=$(git -C "$REPO_DIR" rev-parse HEAD) || die "cannot resolve HEAD"
  local seed_id; seed_id=$(ref_seed_sha256 HEAD) \
    || die "HEAD pins no seed (no seed.ll or seed.lock)"
  window_fingerprint "$seed_id" "$head"
}
mode_seed_verify_fp() { seed_verify_fingerprint; }

# The verify phase shared by `--seed-train` (which then publishes) and
# `--seed-train-verify` (the PR gate, which stops here). Build the compiler from
# the CURRENT pin (NO_AUTOCYCLE — a pin that can't build the merged source is a
# window-gate failure a human must see, never something to auto-cycle around),
# check the selfhost fixed point, then run the full spec suite. This is EXACTLY
# what the train runs before it publishes, so a green PR gate guarantees the
# post-merge train cannot fail on build / fixed-point / suite. $1 = context
# label woven into the diagnostics.
seed_train_verify() {
  local ctx="${1:-seed train}"
  export NO_AUTOCYCLE=1

  log "$ctx: building from the current pin"
  mode_build_bs2
  mode_check_fixedpoint || die "$ctx: fixed point broken — bs2 and bs3 disagree"

  # The train sets AVRA_SEED_TRAIN_SKIP_SUITE=1 ONLY after restoring a PASS
  # marker its PR-side seed-train-verify wrote for THIS exact seed×source
  # fingerprint — so the full suite already ran green on identical inputs and
  # re-running it is pure redundancy (~the train's longest phase). Build + fixed
  # point still run above (the train needs a built bs2 for the hermetic
  # recompile). The PR gate is the marker's PRODUCER and never sets this, so it
  # always runs the suite. A bug anywhere in the marker plumbing can only fail
  # to find a marker → the suite runs (today's behaviour); it can never skip a
  # suite that did not already pass, because the marker is written only on a
  # fully green verify (the workflow's `if: success()`).
  if [ "${AVRA_SEED_TRAIN_SKIP_SUITE:-}" = "1" ]; then
    ok "$ctx: spec suite skipped — PASS marker matches this seed+source fingerprint (already verified pre-merge)"
    return 0
  fi

  log "$ctx: running the spec suite"
  ( cd "$BOOTSTRAP_DIR" && "$BS2" test ) || die "$ctx: spec suite red"
}

# The PR-side seed-train gate (read-only): the train's verify phase, stopping
# before publish. Wired into .github/workflows/seed-train-verify.yml on every PR
# into the integration branch so a merge can't land something that reds the
# train post-merge — the gap that let the 4szi.1 flake (and #538/#539) sail
# through diff-test + bootstrap-window and only fail the train AFTER merging.
# No token, no writes; the publish half (lock bump) is the train's alone.
mode_seed_train_verify() {
  seed_train_verify "seed-train verify"
  ok "seed-train verify holds — build + fixed point + spec suite all green from the pin"
}

# A seed IR MUST be self-contained: a fresh clone bootstraps it via
# seed.ll -> llc + cc -> seed binary with no other objects, so every
# Avra-package symbol it uses has to be DEFINED in the IR, never left
# as an extern `declare` (the metadata fast-path emits externs and
# resolves them from separate .o files — fine for an incremental build,
# fatal for a pin). Mangled package symbols carry the `$40` prefix
# (`@` escaped, e.g. `$40std$3A$3A...`); C externs like @avra_alloc are
# unmangled and don't match, so a `declare` of any `$40`-mangled symbol
# is exactly an unresolved package reference. True (0) iff the IR
# declares no such externs. $1 = IR path.
seed_is_self_contained() {
  # An I/O failure must never read as "self-contained" — distinguish a
  # clean no-extern result (0) from a missing/unreadable IR or a grep
  # error (2), rather than collapsing every non-zero into success.
  [ $# -eq 1 ] || die "usage: --seed-self-contained <seed.ll>"
  [ -r "$1" ] || { err "cannot read IR: $1"; return 2; }
  grep -qE '^declare .*\$40' "$1"
  case $? in
    0) return 1 ;;  # a mangled package extern remains — NOT self-contained
    1) return 0 ;;  # no mangled package externs — self-contained
    *) err "failed to inspect IR: $1"; return 2 ;;
  esac
}

# sha256 of a seed IR with comment lines stripped. update-seed stamps
# provenance comments (commit, timestamp) into the artifact, so two
# pins of byte-identical compiler OUTPUT differ textually; bs2's own
# emitter never writes comment lines, so stripping `;` lines yields a
# stable identity for "did the compiler actually change".
seed_canonical_sha() {
  grep -v '^;' "$1" | $SHA256_CMD | awk '{print $1}'
}

# Content fingerprint for a seed binary's full input set: the seed IR
# plus the C link inputs (runtime.c, llvm_wrapper.c) — build/seed
# links runtime.o + llvm_wrapper.o, so editing either C file must
# relink it. Path-independent (hashes of content only), so the same
# seed content fingerprints identically from seed/seed.ll and from a
# window-extracted copy. Before the C inputs were keyed, a stale seed
# kept the OLD C behaviour and its failures got misattributed
# downstream (ensure_bs2's -O2-miscompile fallback fired for what was
# really an out-of-date wrapper).
seed_inputs_hash() {
  # $2/$3 override the C inputs (the window gate fingerprints HEAD's
  # copies); default to the dev tree's.
  { $SHA256_CMD "$1" "${2:-$RUNTIME_C}" "${3:-$BOOTSTRAP_DIR/llvm_wrapper.c}" 2>/dev/null; } \
    | awk '{print $1}' | $SHA256_CMD | awk '{print $1}'
}

ensure_seed() {
  ensure_llvm_wrapper
  ensure_runtime
  ensure_seed_materialized
  # Use hash comparison (race-free) instead of `-nt` mtime check —
  # consistent with ensure_runtime / ensure_llvm_wrapper and immune
  # to the APFS second-granularity race source_newer_than was fixed
  # for. A change to seed/seed.ll (typically from `make update-seed`
  # in the same shell session as a previous build) — or to the C link
  # inputs — reliably invalidates.
  local seed_hash; seed_hash=$(seed_inputs_hash "$SEED_LL")
  local seed_hash_file="$BUILD_DIR/.seed_hash"
  local old_seed_hash; old_seed_hash=$(cat "$seed_hash_file" 2>/dev/null)
  if [ "${1:-}" = "force" ] || [ ! -x "$SEED_BIN" ] || [ "$seed_hash" != "$old_seed_hash" ]; then
    [ -f "$SEED_LL" ] || die "seed IR not found at $SEED_LL — repo is corrupt"
    log "building seed compiler from seed/seed.ll"
    mkdir -p "$BUILD_DIR"
    "$LLC" -O2 $LLC_RELOC -filetype=obj "$SEED_LL" -o "$BUILD_DIR/seed.o" \
      || die "seed llc failed"
    cc -o "${SEED_BIN}.tmp" "$BUILD_DIR/seed.o" "$RUNTIME_O" "$LLVM_WRAPPER_O" \
      $STACK_LDFLAGS \
      $EXPORT_DYNAMIC $LD_SELECT -L"$LLVM_PREFIX/lib" -lLLVM $CXXLIB 2>"$BUILD_DIR/seed.link.log" \
      || { rm -f "${SEED_BIN}.tmp"; cat "$BUILD_DIR/seed.link.log" >&2; die "seed link failed"; }
    mv "${SEED_BIN}.tmp" "$SEED_BIN"
    echo "$seed_hash" > "$seed_hash_file"
  fi
}

# Link an LLVM IR file into an executable.
# rqwh: shared-inputs fingerprint for the link cache. Hashing
# runtime.o/llvm_wrapper.o per fixture would cost ~30ms × N fixtures
# on every run. Cache the combined hash, invalidate via mtime: if the
# cache file is newer than every input, reuse; otherwise recompute.
# Stable across sequential link_ll calls in the same test session.
# (bs2 itself is deliberately NOT an input — see link_shared_fp.)
#
# 0qmm: link-binary cache lives inside the project's build/cache/
# (under a `link/` sub-namespace alongside `meta/`), so every cached
# artifact lives in one tree — no parallel ~/.cache/avra-* directories.
# `bs2 cache clean` and `make clean --all` reach this slot uniformly.
LINK_CACHE_DIR="$BUILD_DIR/cache/link"
LINK_SHARED_FP_FILE="$LINK_CACHE_DIR/.shared-fp"

link_shared_fp() {
  # fxwn: include AVRA_LIB_OBJS in the fingerprint so the link cache
  # invalidates when the @std producer objects change. uzs9.3: hash the
  # objects' CONTENT, not the path string — producer paths embed the
  # unit fingerprint, which embeds the bs2 hash, so path-hashing missed
  # on every compiler rebuild even when the objects were byte-identical.
  # Content hashing is strictly more precise (a body change still
  # changes the hash) and survives fp-slot renames. Bypasses the mtime
  # memo when LIB_OBJS is set since the sidecar doesn't capture it.
  local libobjs_h=""
  if [ -n "${AVRA_LIB_OBJS:-}" ]; then
    libobjs_h=$(printf '%s' "$AVRA_LIB_OBJS" | tr ':' '\n' \
      | xargs $SHA256_CMD 2>/dev/null | cut -d' ' -f1 \
      | $SHA256_CMD | cut -d' ' -f1)
  fi
  if [ -z "$libobjs_h" ] \
     && [ -f "$LINK_SHARED_FP_FILE" ] \
     && [ "$LINK_SHARED_FP_FILE" -nt "$RUNTIME_O" ] \
     && [ "$LINK_SHARED_FP_FILE" -nt "$LLVM_WRAPPER_O" ]; then
    cat "$LINK_SHARED_FP_FILE"
    return
  fi
  mkdir -p "$LINK_CACHE_DIR"
  local runtime_h wrapper_h composed
  # uzs9.3: bs2 is NOT a link input — the linked binary is a function of
  # (the .ll bytes, runtime.o, llvm_wrapper.o, lib objs, flags), and the
  # per-link key in link_ll already hashes the .ll content, which captures
  # the compiler's entire contribution exactly. Hashing the bs2 binary
  # here only over-invalidated: any bs2 rebuild (even a help-string edit)
  # evicted every cached link of byte-identical IR.
  runtime_h=$($SHA256_CMD "$RUNTIME_O" | cut -d' ' -f1)
  wrapper_h=$($SHA256_CMD "$LLVM_WRAPPER_O" | cut -d' ' -f1)
  composed=$(printf '%s:%s:%s' "$runtime_h" "$wrapper_h" "$libobjs_h" \
    | $SHA256_CMD | cut -d' ' -f1)
  # Don't persist when libobjs_h is set — it's per-invocation state,
  # and persisting would make the next call without LIB_OBJS hit
  # the stale cached value.
  if [ -z "$libobjs_h" ]; then
    printf '%s' "$composed" > "$LINK_SHARED_FP_FILE"
  fi
  printf '%s' "$composed"
}

link_ll() {
  local ll="$1" out="$2" logfile="$3" coverage="${4:-}"

  # rqwh: link-step content cache. Skip cache for coverage builds —
  # they pull in clang_rt.profile_osx which has its own version axes
  # not tracked here, AND emit profraw files keyed on the binary
  # itself, so cache hits would short-circuit the instrumentation
  # this path exists to add.
  local cached_bin=""
  if [ -z "$coverage" ] && [ -f "$ll" ]; then
    local shared_fp ll_h fp
    shared_fp=$(link_shared_fp)
    ll_h=$($SHA256_CMD "$ll" | cut -d' ' -f1)
    fp=$(printf '%s:%s' "$shared_fp" "$ll_h" | $SHA256_CMD | cut -d' ' -f1 | head -c 16)
    cached_bin="$LINK_CACHE_DIR/$fp.bin"
    if [ -f "$cached_bin" ]; then
      cp "$cached_bin" "$out"
      return
    fi
  fi

  local obj_ll="$ll"
  # Coverage: lower instrprof intrinsics before llc
  if [ "$coverage" = "coverage" ]; then
    local lowered="${ll%.ll}.cov.ll"
    "$LLVM_PREFIX/bin/opt" -passes=instrprof -o "$lowered" -S "$ll" \
      --mtriple=arm64-apple-macosx \
      || die "opt instrprof lowering failed for $ll"
    obj_ll="$lowered"
  fi
  "$LLC" -O2 $LLC_RELOC -filetype=obj "$obj_ll" -o "${out}.o" \
    || die "llc failed for $ll"
  local extra_libs=""
  if [ "$coverage" = "coverage" ]; then
    # Link against LLVM's profiling runtime for .profraw output
    local clang_rt_dir="$LLVM_PREFIX/lib/clang/$(ls "$LLVM_PREFIX/lib/clang/" | head -1)/lib/darwin"
    extra_libs="-L$clang_rt_dir -lclang_rt.profile_osx"
  fi
  # fxwn: when AVRA_USE_METADATA is set, the .ll has extern decls for
  # @std/* fns whose bodies live in pre-built producer .o files. Pull
  # them in via AVRA_LIB_OBJS (colon-separated, mirrors PATH). Without
  # this the link step fails with "undefined symbols" for every @std fn.
  local lib_objs=""
  if [ -n "${AVRA_LIB_OBJS:-}" ]; then
    lib_objs=$(printf '%s' "$AVRA_LIB_OBJS" | tr ':' ' ')
  fi
  # Atomic + race-safe link: cc writes to a PID-scoped .tmp sibling,
  # then rename. The .tmp suffix carries `$$` so concurrent shards
  # racing on the same fixture binary path (e.g. cbg3-era continuous
  # dispatch under jdgo) can't clobber each other's intermediate file
  # and trigger spurious `mv: rename ... : No such file or directory`
  # errors that contaminate cached fixture stdout. If cc is killed
  # mid-write (jetsam under memory pressure has done this 3x this
  # iteration alone), the previous $out remains intact instead of
  # being corrupted into a 2.2MB Mach-O that SIGKILLs on dyld load.
  local tmp_out="${out}.tmp.$$"
  cc -o "$tmp_out" "${out}.o" "$RUNTIME_O" "$LLVM_WRAPPER_O" $lib_objs \
    $STACK_LDFLAGS \
    $EXPORT_DYNAMIC $LD_SELECT -L"$LLVM_PREFIX/lib" -lLLVM $CXXLIB $extra_libs 2>"$logfile" \
    || { rm -f "$tmp_out"; cat "$logfile" >&2; die "link failed for $out"; }
  mv "$tmp_out" "$out"

  # rqwh: publish to cache on success. Atomic write via .tmp + mv so
  # parallel shards racing on the same cache slot can't observe a
  # partial bin. Suspected root cause of the 4 cold-rebuild flakies:
  # shard A's cp interrupted mid-write; shard B reads partial bin
  # → broken binary → wrong/missing stdout → test assertion fails.
  if [ -n "$cached_bin" ] && [ -f "$out" ]; then
    cp "$out" "${cached_bin}.tmp.$$" \
      && mv "${cached_bin}.tmp.$$" "$cached_bin" \
      || rm -f "${cached_bin}.tmp.$$" 2>/dev/null
  fi
}

# Compile <fg> with bs2, producing <fg>.ll.
emit_ll_bs2() {
  local fg="$1"
  ensure_bs2
  local out
  if ! out=$("$BS2" compile "$fg" 2>&1); then
    err "$out"
    die "bs2 codegen failed for $fg"
  fi
  echo "$fg.ll"
}

ensure_bs2() {
  # AVRA_SKIP_ENSURE_BS2=1 is the test runner's signal that bs2 is
  # already current — see run_per_file_test_command's env block.
  # Touching @std/avrac/src/* makes `source_newer_than $BS2` return
  # true (any .av is newer than the bs2 binary's mtime). Without this
  # short-circuit, every one of the ~10 diagnose.sh-based tests
  # ALSO running in parallel test shards would each kick off a fresh
  # bs2 rebuild — 10 concurrent llc + cc invocations holding 1-2GB
  # RSS each → jetsam mass-kill → flaky test failures with messages
  # like "scripts/diagnose.sh: line N: PID Killed: 9 bs2 compile".
  # The test runner has already ensured bs2 is current before
  # dispatching shards; shards must not redo that work.
  if [ -n "${AVRA_SKIP_ENSURE_BS2:-}" ]; then
    [ -x "$BS2" ] || die "AVRA_SKIP_ENSURE_BS2 set but $BS2 missing"
    return
  fi
  ensure_seed "${1:-}"
  if [ "${1:-}" = "force" ] || source_newer_than "$BS2" \
     || [ "$SEED_LL" -nt "$BS2" ]; then
    log "compiling packages/cli/src/main.av with seed compiler"
    # The SEED performs this compile, and the pinned seed can predate
    # the dep-aware compile-cache key (pdme.1): an older seed keys the
    # unit on the ENTRY file only, so after a NON-entry edit (the very
    # situation source_newer_than just detected) it would HIT its stale
    # slot and silently re-link the previous bs2. We only reach this
    # branch when a source genuinely changed, so a fresh compile is
    # owed regardless — drop the unit cache so no seed vintage can
    # serve stale here.
    rm -rf "$CLI_SRC_DIR/build/cache"
    if "$SEED_BIN" compile "$SRC_DIR/main.av" >"$BUILD_DIR/bs2.codegen.log" 2>&1; then
      log "linking $BS2"
      link_ll "$SRC_DIR/main.av.ll" "$BS2" "$BUILD_DIR/bs2.link.log"
      ok "built $BS2"
    else
      # Seed crashed. Check if it's an LLVM -O2 miscompilation by
      # rebuilding the seed at -O0 and retrying.
      warn "seed crashed at -O2 — testing for LLVM optimization bug"
      "$LLC" -O0 $LLC_RELOC -filetype=obj "$SEED_LL" -o "$BUILD_DIR/seed_o0.o" \
        || die "seed llc -O0 failed"
      cc -o "$BUILD_DIR/seed_o0.tmp" "$BUILD_DIR/seed_o0.o" "$RUNTIME_O" "$LLVM_WRAPPER_O" \
        $STACK_LDFLAGS \
        $EXPORT_DYNAMIC $LD_SELECT -L"$LLVM_PREFIX/lib" -lLLVM $CXXLIB 2>/dev/null \
        || { rm -f "$BUILD_DIR/seed_o0.tmp"; die "seed -O0 link failed"; }
      mv "$BUILD_DIR/seed_o0.tmp" "$BUILD_DIR/seed_o0"
      if "$BUILD_DIR/seed_o0" compile "$SRC_DIR/main.av" >"$BUILD_DIR/bs2.codegen.log" 2>&1; then
        warn "LLVM OPTIMIZATION BUG: seed works at -O0 but crashes at -O2"
        warn "This is an llc -O2 miscompilation on $(uname -m), not a Avra bug."
        warn "Fix: run 'make update-seed' to regenerate the seed IR, which"
        warn "      typically produces a different IR pattern that avoids the bug."
        warn ""
        warn "Continuing build with -O0 seed..."
        # Use the -O0 seed to complete the build
        cp "$BUILD_DIR/seed_o0" "$SEED_BIN"
        log "linking $BS2"
        link_ll "$SRC_DIR/main.av.ll" "$BS2" "$BUILD_DIR/bs2.link.log"
        ok "built $BS2 (via -O0 seed fallback)"
      else
        cat "$BUILD_DIR/bs2.codegen.log" >&2
        die "bs2 codegen failed (crashes at both -O2 and -O0)"
      fi
    fi
  fi
}

# Link an LLVM IR file into an executable at -O0 (for debuggability).
link_ll_O0() {
  local ll="$1" out="$2" logfile="$3"
  "$LLC" -O0 $LLC_RELOC -filetype=obj "$ll" -o "${out}.o" \
    || die "llc -O0 failed for $ll"
  # Atomic + race-safe link via PID-scoped staging path (see link_ll).
  local tmp_out="${out}.tmp.$$"
  cc -g -o "$tmp_out" "${out}.o" "$RUNTIME_O" "$LLVM_WRAPPER_O" \
    $STACK_LDFLAGS \
    $EXPORT_DYNAMIC $LD_SELECT -L"$LLVM_PREFIX/lib" -lLLVM $CXXLIB 2>"$logfile" \
    || { rm -f "$tmp_out"; cat "$logfile" >&2; die "link failed for $out"; }
  mv "$tmp_out" "$out"
}

# Build bs2 at -O0 for debuggability (lldb + breakpoints).
ensure_bs2_O0() {
  ensure_seed
  if source_newer_than "$BS2_O0" \
     || [ "$SEED_LL" -nt "$BS2_O0" ]; then
    log "compiling packages/cli/src/main.av with seed compiler (for -O0 build)"
    if ! "$SEED_BIN" compile "$SRC_DIR/main.av" >"$BUILD_DIR/bs2_O0.codegen.log" 2>&1; then
      cat "$BUILD_DIR/bs2_O0.codegen.log" >&2
      die "bs2_O0 codegen failed"
    fi
    log "linking $BS2_O0 at -O0"
    link_ll_O0 "$SRC_DIR/main.av.ll" "$BS2_O0" "$BUILD_DIR/bs2_O0.link.log"
    ok "built $BS2_O0 (lldb-friendly, -O0)"
  fi
}

ensure_bs2_debug() {
  ensure_seed
  if source_newer_than "$BS2_DEBUG" \
     || [ "$SEED_LL" -nt "$BS2_DEBUG" ]; then
    log "compiling packages/cli/src/main.av with seed compiler (--debug-null)"
    if ! "$SEED_BIN" compile --debug-null "$SRC_DIR/main.av" >"$BUILD_DIR/bs2_debug.codegen.log" 2>&1; then
      cat "$BUILD_DIR/bs2_debug.codegen.log" >&2
      die "bs2_debug codegen failed"
    fi
    log "linking $BS2_DEBUG at -O0"
    link_ll_O0 "$SRC_DIR/main.av.ll" "$BS2_DEBUG" "$BUILD_DIR/bs2_debug.link.log"
    ok "built $BS2_DEBUG (null checks enabled, -O0)"
  fi
}

ensure_bs2_asan() {
  ensure_seed
  ensure_runtime_asan
  if [ ! -x "$BS2_ASAN" ] || [ "$BS2" -nt "$BS2_ASAN" ]; then
    log "compiling packages/cli/src/main.av with seed (for ASan)"
    "$SEED_BIN" compile "$SRC_DIR/main.av" >"$BUILD_DIR/bs2_asan.codegen.log" 2>&1 \
      || { cat "$BUILD_DIR/bs2_asan.codegen.log" >&2; die "bs2_asan codegen failed"; }
    log "linking $BS2_ASAN with -fsanitize=address"
    cc -fsanitize=address -g -o "$BS2_ASAN" \
       "$SRC_DIR/main.av.ll" "$RUNTIME_ASAN_O" "$LLVM_WRAPPER_O" \
       $EXPORT_DYNAMIC $LD_SELECT -L"$LLVM_PREFIX/lib" -lLLVM $CXXLIB 2>"$BUILD_DIR/bs2_asan.link.log" \
      || { cat "$BUILD_DIR/bs2_asan.link.log" >&2; die "bs2_asan link failed"; }
    ok "built $BS2_ASAN"
  fi
}

ensure_bs3() {
  ensure_bs2
  # Skip the 90-second bs3 rebuild when bs3 is already newer than
  # both bs2 (which compiled it) and the cli/main.av source. Same
  # mtime-based freshness rule make uses internally.
  if [ -f "$BS3" ] && [ "$BS3" -nt "$BS2" ] && [ "$BS3" -nt "$SRC_DIR/main.av" ]; then
    return
  fi
  log "compiling packages/cli/src/main.av with bs2 → $BS3"
  if ! "$BS2" compile "$SRC_DIR/main.av" >"$BUILD_DIR/bs3.codegen.log" 2>&1; then
    cat "$BUILD_DIR/bs3.codegen.log" >&2
    die "bs3 codegen failed (bs2 cannot self-compile)"
  fi
  link_ll "$SRC_DIR/main.av.ll" "$BS3" "$BUILD_DIR/bs3.link.log"
  ok "built $BS3"
}

# ─────────────────────────────────────────────────────────────────────
# Modes
# ─────────────────────────────────────────────────────────────────────

mode_build() {
  ensure_bs2
}

mode_build_runtime() { ensure_runtime; ok "$RUNTIME_O"; }
# Fast inner-loop build: rebuild bs2 if source changed, but SKIP the
# self-compile verify (that step is bootstrap-chain integrity, not
# correctness). Use this when iterating on changes you want to test
# against a fresh bs2 but don't need the bootstrap-fixed-point check
# on every save. Run --build-bs2 (or `make build`) before committing.
mode_ensure_bs2() {
  ensure_bs2
  ok "$BS2"
}
mode_build_bs2() {
  ensure_bs2
  # Verify bs2 can compile itself (bootstrap chain integrity).
  log "verifying bs2 can self-compile (bootstrap safety check)"
  # rcsf.2: run the RC zero-init verifier during the integrity check so
  # every commit-grade build machine-checks the zm77 guard on the
  # compiler's own module (a violation fails the build with a named
  # fn+slot diagnostic instead of shipping layout-sensitive UB).
  if AVRA_VERIFY_RC=1 "$BS2" compile "$SRC_DIR/main.av" >"$BUILD_DIR/bs2_selfcheck.log" 2>&1; then
    ok "$BS2"
    return
  fi

  # Self-compile failed. Before giving up, try an AUTO-CYCLE:
  # The seed may be stale (missing new functions/types). We can
  # fix this automatically by updating the seed from bs2's output
  # (which the seed DID compile successfully) and rebuilding.
  if [ "${NO_AUTOCYCLE:-0}" = "1" ]; then
    die "bs2 self-compile failed (auto-cycle disabled by NO_AUTOCYCLE=1)"
  fi
  warn "bs2 self-compile failed — attempting auto-cycle to update seed"
  warn "(the seed may be stale — this is normal when adding new code)"

  # bs2 was compiled by the seed successfully (ensure_bs2 passed).
  # Its IR is the best candidate for a new seed.
  local bs2_ll="$SRC_DIR/main.av.ll"
  if [ ! -f "$bs2_ll" ]; then
    err "no IR file found at $bs2_ll — cannot auto-cycle"
    head -30 "$BUILD_DIR/bs2_selfcheck.log" >&2
    die "manual seed update required"
  fi

  # Save the current seed as backup
  cp "$SEED_LL" "$BUILD_DIR/seed_backup.ll"
  log "backed up seed to $BUILD_DIR/seed_backup.ll"

  # Update seed with bs2's IR
  cp "$bs2_ll" "$SEED_LL"
  rm -f "$SEED_BIN" "$BUILD_DIR/seed.o"
  log "seed updated from bs2 output — rebuilding from new seed"

  # Rebuild everything from the new seed
  rm -f "$BS2" "$BS3"
  ensure_seed
  ensure_bs2

  # Try self-compile again
  log "retrying self-compile with updated seed"
  if "$BS2" compile "$SRC_DIR/main.av" >"$BUILD_DIR/bs2_selfcheck.log" 2>&1; then
    ok "auto-cycle succeeded — bs2 self-compiles after seed update"
    ok "$BS2"

    # Verify fixed point: bs2 and bs3 should agree
    log "verifying fixed point after auto-cycle"
    local bs2_ir="$BUILD_DIR/fp_autocycle_bs2.ll"
    cp "$SRC_DIR/main.av.ll" "$bs2_ir"
    if "$BS2" compile "$SRC_DIR/main.av" >/dev/null 2>&1; then
      if diff -q "$bs2_ir" "$SRC_DIR/main.av.ll" >/dev/null 2>&1; then
        ok "fixed point holds after auto-cycle"
      else
        warn "fixed point does NOT hold after auto-cycle — run 'make update-seed' to stabilize"
      fi
    fi
    return
  fi

  # Auto-cycle didn't help. Before giving up, check if it's an LLVM
  # -O2 miscompilation: rebuild bs2 at -O0 and test self-compile.
  warn "auto-cycle failed — checking for LLVM -O2 miscompilation"
  "$LLC" -O0 $LLC_RELOC -filetype=obj "$SRC_DIR/main.av.ll" -o "$BUILD_DIR/bs2_o0.o" 2>/dev/null
  if cc -o "$BUILD_DIR/bs2_o0" "$BUILD_DIR/bs2_o0.o" "$RUNTIME_O" "$LLVM_WRAPPER_O" \
       $STACK_LDFLAGS \
       $EXPORT_DYNAMIC $LD_SELECT -L"$LLVM_PREFIX/lib" -lLLVM $CXXLIB 2>/dev/null; then
    if "$BUILD_DIR/bs2_o0" compile "$SRC_DIR/main.av" >/dev/null 2>&1; then
      err ""
      err "LLVM OPTIMIZATION BUG DETECTED"
      err "bs2 works at -O0 but crashes at -O2."
      err "This is an llc -O2 miscompilation on $(uname -m), not a Avra bug."
      err ""
      err "Fix: run 'make update-seed' to regenerate the seed IR."
      err "The new IR pattern typically avoids the LLVM bug."
      # Restore backup and continue with -O0 bs2
      cp "$BUILD_DIR/seed_backup.ll" "$SEED_LL"
      rm -f "$SEED_BIN" "$BUILD_DIR/seed.o"
      die "rebuild with: make update-seed"
    fi
  fi

  # Not an -O2 issue. Restore backup and show diagnostics.
  err "auto-cycle FAILED — self-compile broken at all optimization levels"
  cp "$BUILD_DIR/seed_backup.ll" "$SEED_LL"
  rm -f "$SEED_BIN" "$BUILD_DIR/seed.o"
  err ""
  err "Self-compile error log:"
  head -30 "$BUILD_DIR/bs2_selfcheck.log" >&2
  err ""

  # Diagnose: diff the seed vs bs2 IR to show which functions diverge
  mode_diagnose_selfcompile_failure

  die "bootstrap chain is broken — see diagnostics above"
}

# When self-compile fails, show which functions in the seed vs bs2 IR
# are different. This pinpoints the codegen bug immediately instead of
# requiring manual investigation.
mode_diagnose_selfcompile_failure() {
  local seed_ir="$SEED_LL"
  local bs2_ir="$SRC_DIR/main.av.ll"
  [ -f "$bs2_ir" ] || return

  # Extract function names from both
  local seed_fns bs2_fns
  seed_fns=$(grep '^define ' "$seed_ir" | sed 's/define [^ ]* @//' | sed 's/(.*//' | sort)
  bs2_fns=$(grep '^define ' "$bs2_ir" | sed 's/define [^ ]* @//' | sed 's/(.*//' | sort)

  # Functions in bs2 but not in seed (newly added)
  local new_fns
  new_fns=$(comm -13 <(echo "$seed_fns") <(echo "$bs2_fns"))
  if [ -n "$new_fns" ]; then
    local count
    count=$(echo "$new_fns" | wc -l | tr -d ' ')
    warn "$count functions in bs2 that are NOT in the seed:"
    echo "$new_fns" | head -20 | while read -r fn; do
      printf "  ${C_YELLOW}+ %s${C_RESET}\n" "$fn" >&2
    done
    if [ "$count" -gt 20 ]; then
      warn "  ... and $((count - 20)) more"
    fi
    warn ""
    warn "These functions were compiled by the OLD seed which didn't"
    warn "have them. The seed needs updating. Run: make update-seed"
  fi

  # Functions that exist in both but have different IR
  local common_fns diverged=0
  common_fns=$(comm -12 <(echo "$seed_fns") <(echo "$bs2_fns"))
  for fn in $common_fns; do
    local seed_body bs2_body
    seed_body=$(sed -n "/^define.*@${fn}(/,/^}/p" "$seed_ir" 2>/dev/null | wc -l | tr -d ' ')
    bs2_body=$(sed -n "/^define.*@${fn}(/,/^}/p" "$bs2_ir" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$seed_body" != "$bs2_body" ]; then
      if [ "$diverged" -eq 0 ]; then
        warn "Functions with different IR between seed and bs2:"
      fi
      printf "  ${C_RED}~ %s${C_RESET} (seed: %s lines, bs2: %s lines)\n" "$fn" "$seed_body" "$bs2_body" >&2
      diverged=$((diverged + 1))
      if [ "$diverged" -ge 15 ]; then
        warn "  ... stopping at 15 divergences"
        break
      fi
    fi
  done
}
mode_build_O0()       { ensure_bs2_O0;   ok "$BS2_O0"; }
mode_build_debug()    { ensure_bs2_debug; ok "$BS2_DEBUG"; }
mode_build_bs2_asan() { ensure_bs2_asan; ok "$BS2_ASAN"; }
mode_build_bs3()      { ensure_bs3;      ok "$BS3"; }

# Verify bootstrap reaches its self-host fixed point: bs2 and bs3 must
# emit byte-identical IR for the same input (packages/cli/src/main.av).
# If this fails, self-hosting is broken — the bug is somewhere between
# bs2 and bs3 (one generation diverged from the previous).
mode_check_fixedpoint() {
  ensure_bs2
  ensure_bs3
  # Skip the 3-minute verify when neither bs2/bs3 nor any compiler
  # source has changed since the last passing verify. Hashes both
  # binaries + every compiler-source .av file to a single fingerprint
  # and short-circuits when the prior cached value matches. First commit
  # pays the cost; subsequent commits with no compiler-side changes
  # skip it. Bypass with `AVRA_FORCE_FP=1` if you suspect drift.
  #
  # Source-tree hash (in addition to bs2/bs3 binary hashes) closes the
  # false-positive gap where per-module compile-cache hits left bs2
  # bit-identical despite source changes: any .av edit shifts fp_input,
  # forcing a real diff. Without this the codegen bug behind the bs3
  # crash this comment was added for could land via cache hit alone.
  local fp_marker="$BUILD_DIR/.fp_verified"
  local fp_input
  fp_input=$(
    { $SHA256_CMD "$BS2" "$BS3" 2>/dev/null
      find "$CLI_SRC_DIR" "$LIB_SRC_DIR" -name '*.av' -type f -exec $SHA256_CMD {} +
    } | awk '{print $1}' | sort | $SHA256_CMD | awk '{print $1}'
  )
  if [ "${AVRA_FORCE_FP:-0}" != "1" ] && [ -f "$fp_marker" ] \
     && [ "$(cat "$fp_marker" 2>/dev/null)" = "$fp_input" ]; then
    ok "fixed point cached — bs2 + bs3 + source unchanged since last verify"
    return 0
  fi
  log "compiling packages/cli/src/main.av with bs2"
  "$BS2" compile "$SRC_DIR/main.av" >/dev/null 2>&1 \
    || die "bs2 failed to compile bootstrap source"
  cp "$SRC_DIR/main.av.ll" "$BUILD_DIR/fp_bs2.ll"
  log "compiling packages/cli/src/main.av with bs3"
  "$BS3" compile "$SRC_DIR/main.av" >/dev/null 2>&1 \
    || die "bs3 failed to compile bootstrap source"
  cp "$SRC_DIR/main.av.ll" "$BUILD_DIR/fp_bs3.ll"
  if diff -q "$BUILD_DIR/fp_bs2.ll" "$BUILD_DIR/fp_bs3.ll" >/dev/null; then
    local lines; lines=$(wc -l <"$BUILD_DIR/fp_bs2.ll" | tr -d ' ')
    ok "fixed point holds — bs2 and bs3 emit byte-identical $lines-line IR"
    echo "$fp_input" > "$fp_marker"
  else
    # Strict callers (the seed train sets NO_AUTOCYCLE=1) must NOT have
    # divergence papered over by an auto-cycle: a heal-then-pass here
    # would publish a seed the pinned compiler couldn't reproduce. Fail
    # loud and let a human look.
    if [ "${NO_AUTOCYCLE:-0}" = "1" ]; then
      err "FIXED POINT BROKEN — auto-cycle disabled (NO_AUTOCYCLE=1)"
      err "  bs2 IR: $BUILD_DIR/fp_bs2.ll"
      err "  bs3 IR: $BUILD_DIR/fp_bs3.ll"
      return 1
    fi
    # Auto-converge: cycle the seed up to 3 times to reach equilibrium.
    # This handles cases where adding new functions shifts allocator state.
    local max_cycles=3
    for cycle in $(seq 1 $max_cycles); do
      log "fixed point diverged — auto-cycling seed (attempt $cycle/$max_cycles)"
      cp "$BUILD_DIR/fp_bs2.ll" "$BOOTSTRAP_DIR/seed/seed.ll"
      # Rebuild bs2 from new seed
      ensure_seed force
      ensure_bs2 force
      ensure_bs3
      # Re-check
      "$BS2" compile "$SRC_DIR/main.av" >/dev/null 2>&1 \
        || die "bs2 failed during auto-cycle $cycle"
      cp "$SRC_DIR/main.av.ll" "$BUILD_DIR/fp_bs2.ll"
      "$BS3" compile "$SRC_DIR/main.av" >/dev/null 2>&1 \
        || die "bs3 failed during auto-cycle $cycle"
      cp "$SRC_DIR/main.av.ll" "$BUILD_DIR/fp_bs3.ll"
      if diff -q "$BUILD_DIR/fp_bs2.ll" "$BUILD_DIR/fp_bs3.ll" >/dev/null; then
        # Converged! Update the seed to the stable version.
        cp "$BUILD_DIR/fp_bs2.ll" "$BOOTSTRAP_DIR/seed/seed.ll"
        local lines; lines=$(wc -l <"$BUILD_DIR/fp_bs2.ll" | tr -d ' ')
        ok "fixed point holds — bs2 and bs3 emit byte-identical $lines-line IR (after $cycle auto-cycle(s))"
        # Recompute fingerprint after cycle (bs2 was rebuilt) and cache.
        # Mirror the upstream input shape — binaries + every .av — so
        # the next run's compare matches.
        local fp_post
        fp_post=$(
          { $SHA256_CMD "$BS2" "$BS3" 2>/dev/null
            find "$CLI_SRC_DIR" "$LIB_SRC_DIR" -name '*.av' -type f -exec $SHA256_CMD {} +
          } | awk '{print $1}' | sort | $SHA256_CMD | awk '{print $1}'
        )
        echo "$fp_post" > "$fp_marker"
        return 0
      fi
    done
    err "FIXED POINT BROKEN — failed to converge after $max_cycles auto-cycles"
    err "diff: $(diff "$BUILD_DIR/fp_bs2.ll" "$BUILD_DIR/fp_bs3.ll" | wc -l | tr -d ' ') lines"
    err "  bs2 IR: $BUILD_DIR/fp_bs2.ll"
    err "  bs3 IR: $BUILD_DIR/fp_bs3.ll"
    return 1
  fi
}

# ── Fixture-compile throttle ──
#
# A bs2 compile peaks 1-2GB RSS. The per_file test suite fans out
# shard binaries × AVRA_TEST_JOBS threads, and any unit can shell out
# a fixture compile — uncapped, the burst OOM-killed bs2 mid-suite
# (Linux 16GB/4-core; same class as the documented macOS jetsam
# mass-kill). Bound the SHELL-SPAWNED compiles with a cross-process
# counting semaphore: N slot directories under build/, mkdir as the
# atomic test-and-set (portable — macOS ships no flock(1)), a pid
# file per slot so crashed holders get reaped instead of leaking the
# slot forever.
COMPILE_SLOT_DIR=""

acquire_compile_slot() {
  # AVRA_SLOT_DIR overrides the namespace — spec tests use a private
  # one so they never contend with (or corrupt) a real suite's slots.
  local n="${AVRA_FIXTURE_JOBS:-2}" base="${AVRA_SLOT_DIR:-$BUILD_DIR/compile_slots}" dir owner i
  mkdir -p "$base"
  while :; do
    i=0
    while [ "$i" -lt "$n" ]; do
      dir="$base/slot.$i"
      if mkdir "$dir" 2>/dev/null; then
        echo $$ > "$dir/pid"
        COMPILE_SLOT_DIR="$dir"
        return 0
      fi
      # Reap a slot whose owner died without releasing. The pid file
      # is written right after mkdir; an empty read means the owner is
      # mid-acquire — leave it alone.
      owner=$(cat "$dir/pid" 2>/dev/null)
      if [ -n "$owner" ] && ! kill -0 "$owner" 2>/dev/null; then
        rm -rf "$dir" 2>/dev/null || :
      fi
      i=$((i + 1))
    done
    sleep 0.2
  done
}

release_compile_slot() {
  [ -n "$COMPILE_SLOT_DIR" ] && rm -rf "$COMPILE_SLOT_DIR" 2>/dev/null
  COMPILE_SLOT_DIR=""
}

# Run an arbitrary command while holding a compile slot. The shell-out
# surface for callers that can't share this script's functions (the
# test runner's cached-fixture commands). The EXIT trap releases on
# every path, including die/kill.
mode_slot_exec() {
  [ $# -ge 1 ] || die "--slot-exec needs a command to run"
  acquire_compile_slot
  trap release_compile_slot EXIT
  "$@"
}

# Compile + link + run a .av with bs2 (or stage1).
run_fg() {
  local fg="$1"
  [ -f "$fg" ] || die "no such file: $fg"
  ensure_bs2
  local ll bin
  ll="$fg.ll"
  bin="${fg%.av}.bin"
  # Skip recompile when the fixture's bin is up-to-date relative to
  # both its source and the bs2 compiler — every test run was
  # otherwise re-spending ~90s per fixture (forge-crafting-intepreters-kkgf).
  # `make test` aggregates 6+ fixtures, so the cache savings is on the
  # order of minutes per `make test`. The freshness check is the same
  # rule make would apply: bin must exist and be newer than every
  # input it depends on.
  if [ -f "$bin" ] && [ "$bin" -nt "$fg" ] && [ "$bin" -nt "$BS2" ]; then
    "$bin"
    return
  fi
  # jdgo: PID-scope the per-shard logs. Concurrent shards under
  # continuous dispatch share BUILD_DIR; a non-PID-scoped log means
  # shard A's bs2-compile output overwrites shard B's, so when B's
  # compile fails and reads the log it surfaces A's content (or
  # nothing) — contaminating the cached fixture stdout with the
  # wrong error message. The $$ suffix isolates per-shard.
  local run_log="$BUILD_DIR/last_run.log.$$"
  local link_log="$BUILD_DIR/last_link.log.$$"
  # Slot-bounded: this is the per-unit fixture-compile path the test
  # suite fans out — the OOM source on 4-core/16GB machines.
  acquire_compile_slot
  trap release_compile_slot EXIT
  if ! "$BS2" compile "$fg" >"$run_log" 2>&1; then
    cat "$run_log" >&2
    rm -f "$run_log"
    die "bs2 codegen failed"
  fi
  release_compile_slot
  link_ll "$ll" "$bin" "$link_log"
  rm -f "$run_log" "$link_log"
  "$bin"
}

mode_run() { run_fg "$1"; }

# rcsf.3: run the spec suite under AVRA_RC_STRICT=1. Strict mode lives in
# runtime.c, so BOTH bs2 (as it compiles + runs each test binary) AND the
# test programs themselves execute under it — a release of a stale pointer to
# reclaimed RC memory (the zm77 phantom-release class) aborts loudly with a
# backtrace instead of silently corrupting memory. A clean run proves the
# compiler's own RC discipline plus every test program's is misuse-free (the
# "full suite green, no false positives" acceptance). Optional arg: a filename
# substring filter, same as `bs2 test -f`.
mode_rc_strict_suite() {
  ensure_bs2
  log "running the spec suite under AVRA_RC_STRICT=1 (poison-on-free + reuse quarantine + foreign-release abort)"
  # `bs2 test` discovers test files and resolves @std relative to CWD, so it
  # MUST run from the bootstrap dir — CI invokes this script from the repo
  # root. Same `( cd "$BOOTSTRAP_DIR" && "$BS2" test )` form the seed-train's
  # spec-suite check uses; without it every shard fails to resolve the test
  # runner (`undefined variable run_test_suite`).
  if [ -n "${1:-}" ]; then
    ( cd "$BOOTSTRAP_DIR" && AVRA_RC_STRICT=1 "$BS2" test -f "$1" )
  else
    ( cd "$BOOTSTRAP_DIR" && AVRA_RC_STRICT=1 "$BS2" test )
  fi
}

# Link a pre-emitted .ll into a binary and run it — WITHOUT recompiling
# from source. Unlike --run (which always re-invokes `bs2 compile`), this
# executes the EXACT artifact a prior `bs2 compile` already wrote, so a
# caller can verify that one specific .ll links and runs correctly. The
# runtime + LLVM-wrapper objects are the same link inputs link_ll uses.
link_run_ll() {
  local ll="$1"
  [ -f "$ll" ] || die "no such file: $ll"
  ensure_runtime
  ensure_llvm_wrapper
  local bin="${ll%.ll}.bin"
  link_ll "$ll" "$bin" "$BUILD_DIR/link_run.log.$$"
  rm -f "$BUILD_DIR/link_run.log.$$"
  "$bin"
}

mode_link_run() { link_run_ll "$1"; }

mode_check() {
  local fg="$1"; [ -f "$fg" ] || die "no such file: $fg"
  ensure_bs2
  "$BS2" check "$fg"
}

mode_ll() {
  local fg="$1"; [ -f "$fg" ] || die "no such file: $fg"
  ensure_bs2
  "$BS2" compile "$fg" >/dev/null
  cat "$fg.ll"
}

mode_diff() {
  local fg="$1"; [ -f "$fg" ] || die "no such file: $fg"
  ensure_bs2; ensure_bs3
  local b2_ll="$BUILD_DIR/$(basename "$fg").bs2.ll"
  local b3_ll="$BUILD_DIR/$(basename "$fg").bs3.ll"
  "$BS2" compile "$fg" >/dev/null 2>&1 || die "bs2 codegen failed"
  cp "$fg.ll" "$b2_ll"
  "$BS3" compile "$fg" >/dev/null 2>&1 || die "bs3 codegen failed"
  cp "$fg.ll" "$b3_ll"
  log "bs2: $b2_ll"
  log "bs3: $b3_ll"
  if diff -u "$b2_ll" "$b3_ll" >/dev/null; then
    ok "IR is byte-identical"
  else
    diff -u "$b2_ll" "$b3_ll" | head -200
  fi
}

mode_diff_fn() {
  local fg="$1" fn="$2"
  [ -f "$fg" ] || die "no such file: $fg"
  [ -n "$fn" ] || die "--diff-fn requires <file.av> <fn-name>"
  ensure_bs2; ensure_bs3
  local b2_ll="$BUILD_DIR/$(basename "$fg").bs2.ll"
  local b3_ll="$BUILD_DIR/$(basename "$fg").bs3.ll"
  "$BS2" compile "$fg" >/dev/null 2>&1 || die "bs2 codegen failed"
  cp "$fg.ll" "$b2_ll"
  "$BS3" compile "$fg" >/dev/null 2>&1 || die "bs3 codegen failed"
  cp "$fg.ll" "$b3_ll"
  extract_fn() {
    awk -v fn="$1" '
      $0 ~ "define .*@"fn"\\(" { in_fn=1 }
      in_fn { print }
      in_fn && /^}/ { in_fn=0 }
    ' "$2"
  }
  diff -u <(extract_fn "$fn" "$s1_ll") <(extract_fn "$fn" "$b2_ll")
}

mode_score() {
  local ll="${1:-}"
  if [ -z "$ll" ]; then
    ll=$(ls -t "$BUILD_DIR"/*.ll "$SRC_DIR"/*.ll 2>/dev/null | head -1)
    [ -n "$ll" ] || die "no .ll files found; pass one explicitly or build something first"
  fi
  [ -f "$ll" ] || die "no such file: $ll"
  log "scoring $ll"
  local total
  total=$(wc -l <"$ll" | tr -d ' ')
  local fns ret_undef br_const_false orphan_blocks unreachable phi_undef \
        i64_for_ptr empty_blocks
  count() { local n; n=$(grep -c "$1" "$2" 2>/dev/null || true); echo "${n:-0}"; }
  fns=$(count '^define ' "$ll")
  ret_undef=$(count 'ret .* undef' "$ll")
  br_const_false=$(count 'br i1 false' "$ll")
  unreachable=$(count '^  unreachable$' "$ll")
  phi_undef=$(count 'phi .* undef' "$ll")
  empty_blocks=$(awk '
    /^[a-zA-Z0-9_.]+:/ { last_label=NR; bodies=0; next }
    last_label && /^[ \t]*[a-zA-Z]/ { bodies++ }
    /^}/ { if (last_label && bodies==0) c++; last_label=0 }
    END { print c+0 }
  ' "$ll")
  # Count blocks that have no incoming branch and aren't entry. Quick
  # approximation: any "label:" line not referenced by a br/switch.
  # Count basic-block labels not referenced by any `label %name`. We
  # iterate the line and pull only operands immediately after `label`.
  orphan_blocks=$(awk '
    /^[a-zA-Z0-9_.]+:/ {
      lbl = $0
      sub(/:.*/, "", lbl)
      labels[lbl] = 1
      next
    }
    {
      s = $0
      while (match(s, /label %[a-zA-Z0-9_.]+/)) {
        ref = substr(s, RSTART+7, RLENGTH-7)
        refs[ref] = 1
        s = substr(s, RSTART + RLENGTH)
      }
    }
    END {
      for (l in labels) if (!(l in refs) && l != "entry") c++
      print c+0
    }
  ' "$ll")

  # Wide-store-into-narrow-malloc detector. Catches the bug class we
  # spent half a session chasing in 3814cce: a `store iN` whose
  # destination came from a `call ptr @malloc(i64 K)` with K*8 < N.
  # Tracks ptr provenance through ptrtoint/inttoptr/add aliases since
  # bootstrap-emitted IR routes everything through i64 round-trips.
  # Each hit is a definite heap overflow — these are bugs, not smells.
  wide_stores=$(awk '
    function bytes(width) { return int(width/8) }
    function ssa_lhs(line,    s) {
      s = line; sub(/^[ \t]+/, "", s); sub(/ *=.*/, "", s); return s
    }
    # Reset state at function boundaries — SSA names are local to each
    # function and reusing %1, %2 across functions would otherwise cause
    # phantom hits from earlier malloc sizes leaking forward.
    /^define / { delete malloc_size; next }
    /= call ptr @malloc\(i64 [0-9]+\)/ {
      lhs = ssa_lhs($0)
      match($0, /malloc\(i64 [0-9]+\)/)
      # "malloc(i64 " is 11 chars, trailing ")" is 1 char.
      sz = substr($0, RSTART+11, RLENGTH-12)
      malloc_size[lhs] = sz + 0
      next
    }
    /= ptrtoint ptr %[A-Za-z0-9_.]+/ {
      lhs = ssa_lhs($0)
      match($0, /ptr %[A-Za-z0-9_.]+/)
      # "ptr " is 4 chars; keep the leading "%" so the key matches.
      src = substr($0, RSTART+4, RLENGTH-4)
      if (src in malloc_size) malloc_size[lhs] = malloc_size[src]
      next
    }
    /= inttoptr i64 %[A-Za-z0-9_.]+/ {
      lhs = ssa_lhs($0)
      match($0, /i64 %[A-Za-z0-9_.]+/)
      src = substr($0, RSTART+4, RLENGTH-4)
      if (src in malloc_size) malloc_size[lhs] = malloc_size[src]
      next
    }
    /= add i64 %[A-Za-z0-9_.]+, [0-9]+/ {
      lhs = ssa_lhs($0)
      # Match the operand AFTER "add i64 " — not the LHS, which is also a %.
      match($0, /add i64 %[A-Za-z0-9_.]+/)
      src = substr($0, RSTART+8, RLENGTH-8)
      if (src in malloc_size) malloc_size[lhs] = malloc_size[src]
      next
    }
    /^[ \t]*store i[0-9]+ .*, ptr %[A-Za-z0-9_.]+/ {
      match($0, /store i[0-9]+/)
      width = substr($0, RSTART+7, RLENGTH-7) + 0
      match($0, /ptr %[A-Za-z0-9_.]+/)
      dst = substr($0, RSTART+4, RLENGTH-4)
      if (dst in malloc_size && bytes(width) > malloc_size[dst]) {
        printf("  %s: store i%d into malloc(%d) at NR=%d\n", dst, width, malloc_size[dst], NR) > "/dev/stderr"
        c++
      }
    }
    END { print c+0 }
  ' "$ll")

  printf "%-22s %s\n" "file"            "$ll"
  printf "%-22s %s\n" "lines"           "$total"
  printf "%-22s %s\n" "functions"       "$fns"
  printf "%-22s %s\n" "ret undef"       "$ret_undef"
  printf "%-22s %s\n" "br i1 false"     "$br_const_false"
  printf "%-22s %s\n" "phi undef"       "$phi_undef"
  printf "%-22s %s\n" "unreachable"     "$unreachable"
  printf "%-22s %s\n" "empty blocks"    "$empty_blocks"
  printf "%-22s %s\n" "orphan blocks"   "$orphan_blocks"
  printf "%-22s ${C_RED}%s${C_RESET}\n" "wide stores (BUG)" "$wide_stores"
  local score=$((ret_undef*10 + br_const_false*5 + phi_undef*5 + empty_blocks*2 + orphan_blocks*3 + wide_stores*100))
  printf "%-22s ${C_YELLOW}%s${C_RESET}\n" "SCORE (lower=better)" "$score"
  if [ "$wide_stores" -gt 0 ]; then
    err "wide-store-into-narrow-malloc detected — this is the heap-overflow bug class"
    return 1
  fi
}

mode_rank() {
  local arg="$1"; [ -f "$arg" ] || die "no such file: $arg"
  local ll
  case "$arg" in
    *.ll) ll="$arg" ;;
    *.av)
      ensure_bs2
      "$BS2" compile "$arg" >/dev/null 2>&1 || die "bs2 codegen failed"
      ll="$arg.ll"
      ;;
    *) die "--rank: pass a .av or .ll file" ;;
  esac
  awk '
    /^define / {
      match($0, /@[A-Za-z0-9_.]+/)
      name=substr($0, RSTART+1, RLENGTH-1)
      in_fn=1; lines=0; next
    }
    in_fn { lines++ }
    in_fn && /^}/ { print lines, name; in_fn=0 }
  ' "$ll" | sort -rn | head -40
}


# ─────────────────────────────────────────────────────────────────────
# Heap / memory debugging
# ─────────────────────────────────────────────────────────────────────

mode_asan() {
  local fg="$1"; [ -f "$fg" ] || die "no such file: $fg"
  ensure_bs2_asan
  log "running bs2_asan compile $fg"
  ASAN_OPTIONS="abort_on_error=0:halt_on_error=0:print_stacktrace=1:detect_leaks=0" \
    "$BS2_ASAN" compile "$fg"
}

mode_malloc_trace() {
  local fg="$1"; [ -f "$fg" ] || die "no such file: $fg"
  ensure_bs2
  log "running bs2 with MallocStackLogging + guard"
  MallocStackLogging=1 \
  MallocGuardEdges=1 \
  MallocScribble=1 \
  MallocCheckHeapStart=1 \
  MallocCheckHeapEach=1000 \
    "$BS2" compile "$fg"
}

mode_bisect_lines() {
  local fg="$1"; [ -f "$fg" ] || die "no such file: $fg"
  ensure_bs2
  local total
  total=$(wc -l <"$fg" | tr -d ' ')
  log "bisecting $fg ($total lines)"
  local lo=1 hi=$total mid tmp="$BUILD_DIR/_bisect.av"
  # Verify the full file actually crashes; otherwise bisection is meaningless.
  if "$BS2" compile "$fg" >/dev/null 2>&1; then
    ok "full file compiles cleanly — nothing to bisect"
    return 0
  fi
  # Run each prefix N times — heap corruption is often nondeterministic.
  # A prefix counts as "crashing" if it crashes on ANY of N trials.
  local trials="${BISECT_TRIALS:-5}"
  test_prefix() {
    local n="$1" i
    for ((i=0; i<trials; i++)); do
      if ! "$BS2" compile "$tmp" >/dev/null 2>&1; then return 1; fi
    done
    return 0
  }
  while [ "$lo" -lt "$hi" ]; do
    mid=$(( (lo + hi) / 2 ))
    head -n "$mid" "$fg" >"$tmp"
    if test_prefix "$mid"; then
      lo=$((mid + 1))
    else
      hi=$mid
    fi
    log "  lo=$lo hi=$hi (trials=$trials)"
  done
  log "smallest crashing prefix: first $lo lines"
  echo "─── lines $((lo-3))..$lo ───"
  sed -n "$((lo-3)),${lo}p" "$fg"
  echo "─────────────────────────"
  cp "$tmp" "$BUILD_DIR/bisect_${$}.av"
  log "saved minimal crash repro: $BUILD_DIR/bisect_${$}.av"
}

# ─────────────────────────────────────────────────────────────────────
# Dispatch
# ─────────────────────────────────────────────────────────────────────

# pdme.9: the canonical "is the cache lying to me" check. Fuzzes the
# build-cache correctness invariant against a sandbox package whose
# ENTRY stays fixed while a NON-ENTRY sibling mutates — exactly the
# lkze.9 staleness shape (an edit the entry-keyed cache historically
# didn't see). Each iteration applies one seeded mutation, then
# compiles the probe twice:
#
#   A = the normal, cache-eligible compile
#   B = the same compile with the cache BYPASSED (AVRA_TIMINGS=1 is an
#       existing eligibility gate — timings expect per-invocation
#       stderr, so the compile cache never engages)
#
# and requires A == B byte-for-byte: whatever the cache served must be
# indistinguishable from recomputing. Mutation kinds:
#   0  no-op comment appended to the sibling (hash changes, IR must not lie)
#   1  semantic change to the sibling (IR legitimately changes; A must track)
#   2  newest cache slot's unit.ll truncated to 0 bytes (slot_complete must reject)
#   3  newest cache slot's metadata.bin deleted (incomplete slot must miss)
# After every iteration an identical rerun must be a cache HIT — the
# liveness invariant (catches publish-death: a cache that silently
# stops publishing keeps recomputing, so A == B alone can't see it).
# Finally the sibling is restored to its ORIGINAL bytes and the probe
# must byte-match the very first golden compile — the revert-restores
# invariant (a sticky-fingerprint regression like the pre-fix
# whole-second sidecar mtimes fails here).
#
# Usage: --cache-fuzz [N] [SEED]   (default 20 iterations, seed 42)
mode_cache_fuzz() {
  local n="${1:-20}" seed="${2:-42}"
  ensure_bs2
  local fuzz_root="$BUILD_DIR/cache-fuzz"
  rm -rf "$fuzz_root"
  # Sandbox lives under a literal `packages/` segment so the resolver's
  # find_packages_dir locates it and `use @fuzz.q` resolves — the
  # mutation target is a CROSS-PACKAGE dependency of a fixed entry,
  # the genuine lkze.9 axis (fp_full keys it since pdme.1).
  mkdir -p "$fuzz_root/packages/fuzz-p/src" "$fuzz_root/packages/fuzz-q/src"
  cat > "$fuzz_root/packages/fuzz-p/avra.toml" <<'MANIFEST'
[package]
name = "@fuzz/p"
version = "0.1.0"

[dependencies]
"@fuzz/q" = { path = "../fuzz-q" }
MANIFEST
  cat > "$fuzz_root/packages/fuzz-q/avra.toml" <<'MANIFEST'
[package]
name = "@fuzz/q"
version = "0.1.0"
MANIFEST
  local entry="$fuzz_root/packages/fuzz-p/src/main.av"
  local sib="$fuzz_root/packages/fuzz-q/src/q.av"
  printf 'use @fuzz.q.{fuzz_value}\n\nfn main() { println(string(fuzz_value())) }\n' > "$entry"
  printf 'export fn fuzz_value() -> int { 1 }\n' > "$sib"
  local sib_orig
  sib_orig=$(cat "$sib")
  local cache_dir="$fuzz_root/packages/fuzz-p/src/build/cache"

  # Both compile flavours strip the shard env (metadata/lib-objs flip
  # eligibility and resolve behaviour); B additionally sets the
  # cache-bypass gate.
  fuzz_compile_cached() {
    env -u AVRA_USE_METADATA -u AVRA_LIB_OBJS -u AVRA_LIB_PKG_ROOT -u AVRA_TIMINGS \
      "$BS2" compile "$entry" >/dev/null 2>&1
  }
  fuzz_compile_bypass() {
    env -u AVRA_USE_METADATA -u AVRA_LIB_OBJS -u AVRA_LIB_PKG_ROOT AVRA_TIMINGS=1 \
      "$BS2" compile "$entry" >/dev/null 2>&1
  }

  fuzz_compile_cached || die "cache-fuzz: golden compile failed"
  cp "$entry.ll" "$fuzz_root/golden.ll"

  local r="$seed" iter=1 kind
  while [ "$iter" -le "$n" ]; do
    r=$(( (r * 1103515245 + 12345) % 2147483648 ))
    # Kind comes from the LCG's HIGH bits — the low bits of a mod-2^31
    # LCG cycle with tiny period (r % 4 degenerates to a fixed
    # 3,0,1,2,… wheel), which is how the net's first defect hid: a
    # damage kind always ran before the first semantic edit.
    kind=$(( (r / 65536) % 4 ))
    case "$kind" in
      0) printf '// fuzz noop %s\n' "$r" >> "$sib" ;;
      1) printf 'export fn fuzz_value() -> int { %s }\n' "$(( r % 97 ))" > "$sib" ;;
      2) local slot_ll
         slot_ll=$(ls -t "$cache_dir"/*/unit.ll 2>/dev/null | head -1)
         [ -n "$slot_ll" ] && : > "$slot_ll" ;;
      3) local slot_meta
         slot_meta=$(ls -t "$cache_dir"/*/metadata.bin 2>/dev/null | head -1)
         [ -n "$slot_meta" ] && rm -f "$slot_meta" ;;
    esac
    fuzz_compile_cached || die "cache-fuzz iter $iter (kind $kind): cached compile failed"
    mv "$entry.ll" "$fuzz_root/a.ll"
    fuzz_compile_bypass || die "cache-fuzz iter $iter (kind $kind): bypass compile failed"
    mv "$entry.ll" "$fuzz_root/b.ll"
    cmp -s "$fuzz_root/a.ll" "$fuzz_root/b.ll" \
      || die "cache-fuzz FAIL iter $iter (kind $kind): cached IR diverges from recompute — the cache lied"
    # Liveness: an immediate identical rerun must be a cache HIT.
    # Catches publish-death (the pdme.9-found half-slot poison: after
    # slot damage, every republish failed forever and the cache
    # silently died — recompute-always keeps A == B, so only this
    # assertion sees it). The hit line is on stderr.
    env -u AVRA_USE_METADATA -u AVRA_LIB_OBJS -u AVRA_LIB_PKG_ROOT -u AVRA_TIMINGS \
        "$BS2" compile "$entry" 2>&1 >/dev/null | grep -q 'compile-cache\] hit' \
      || die "cache-fuzz FAIL iter $iter (kind $kind): rerun did not HIT — publish is dead (cache disabled)"
    iter=$(( iter + 1 ))
  done

  # Revert-restores: back to the original sibling bytes, the probe must
  # byte-match the first golden compile through the cached path.
  printf '%s' "$sib_orig" > "$sib"
  fuzz_compile_cached || die "cache-fuzz: post-revert compile failed"
  cmp -s "$entry.ll" "$fuzz_root/golden.ll" \
    || die "cache-fuzz FAIL: revert did not restore the golden IR (sticky fingerprint)"

  rm -rf "$fuzz_root"
  ok "cache-fuzz PASS — $n iterations (seed $seed): cached IR == recomputed IR, revert restores golden"
}

# t-lqzr: the OOM-safe full-suite runner, promoted from the CLAUDE.md
# copy-paste snippet (rule 10: dev tooling lives here). One `bs2 test`
# per directory, strictly sequential — a ≤16GB box survives what a
# parallel whole-suite invocation has repeatedly OOM'd. Per-dir logs +
# `.ok` resume markers under $BUILD_DIR/sweep (override: AVRA_SWEEP_DIR),
# so a killed run resumes at the failing dir instead of restarting, and
# failure is LOUD (stop at the first red dir, print its tail) — no later
# dir can mask an earlier one. On a green run the per-dir tallies are
# aggregated into one suite-wide summary.
#
# Usage: --sweep [--fresh] [dir ...]
#   --fresh    drop resume markers first (full re-run)
#   dir ...    sweep only these dirs (default: tests/ + packages/**/tests)
mode_sweep() {
  local fresh=0
  if [ "${1:-}" = "--fresh" ]; then fresh=1; shift; fi
  ensure_bs2
  local sweep_dir="${AVRA_SWEEP_DIR:-$BUILD_DIR/sweep}"
  [ "$fresh" = "1" ] && rm -rf "$sweep_dir"
  mkdir -p "$sweep_dir"
  local dirs=()
  if [ $# -gt 0 ]; then
    dirs=("$@")
  else
    dirs=(tests)
    while IFS= read -r d; do dirs+=("$d"); done < <(find packages -type d -name tests | sort)
  fi
  local t_start
  t_start=$(date +%s)
  local d slug logf
  for d in "${dirs[@]}"; do
    slug=$(printf '%s' "$d" | tr '/' '_')
    logf="$sweep_dir/$slug.log"
    if [ -f "$logf.ok" ]; then
      log "[sweep] $d — already green (resume marker; --fresh re-runs)"
      continue
    fi
    if ! "$BS2" test "$d" > "$logf" 2>&1; then
      err "[sweep] FAILED: $d — full log: $logf"
      sed 's/\x1b\[[0-9;]*m//g' "$logf" | grep -E '    FAIL|failed|crashed' | head -10 >&2
      err "[sweep] markers kept — a re-run resumes at this dir"
      return 1
    fi
    touch "$logf.ok"
    log "[sweep] ok $d ($(sed 's/\x1b\[[0-9;]*m//g' "$logf" | grep -oE '[0-9]+/[0-9]+ tests passed' | tail -1))"
  done
  local total
  total=$(for f in "$sweep_dir"/*.log; do
    [ -f "$f.ok" ] || continue
    sed 's/\x1b\[[0-9;]*m//g' "$f" | grep -oE '[0-9]+/[0-9]+ tests passed' | tail -1
  done | awk -F'[/ ]' '{p+=$1; t+=$2} END {print p "/" t}')
  ok "sweep green — $total specs across ${#dirs[@]} dir(s) in $(( $(date +%s) - t_start ))s"
}

# pdme.6: repo-wide cache GC. `bs2 cache prune` is per-project-root
# (it reads $PWD), but the heavyweight slots live in the PER-PACKAGE
# caches (packages/*/build/cache — a single std-avrac producer slot is
# ~40MB). Sweep the bootstrap root plus every package root in one go.
# Usage: --cache-gc [DAYS]   (default 30)
mode_cache_gc() {
  local days="${1:-30}"
  ensure_bs2
  local root
  for root in "$BOOTSTRAP_DIR" "$BOOTSTRAP_DIR"/packages/*/; do
    [ -d "$root/build/cache" ] || continue
    log "[cache-gc] $root"
    ( cd "$root" && "$BS2" cache prune --max_age_days="$days" )
  done
  ok "cache-gc done (max age ${days}d; mtime == last use, so only cold entries went)"
}

main() {
  if [ $# -eq 0 ]; then print_help; exit 0; fi
  local mode="$1"; shift
  case "$mode" in
    --help|-h)            print_help ;;
    --build)              mode_build "$@" ;;
    --build-runtime)      mode_build_runtime "$@" ;;
    --build-bs2)          mode_build_bs2 "$@" ;;
    --ensure-bs2)         mode_ensure_bs2 "$@" ;;
    --build-O0)           mode_build_O0 "$@" ;;
    --build-debug)        mode_build_debug "$@" ;;
    --build-bs2-asan)     mode_build_bs2_asan "$@" ;;
    --build-bs3)          mode_build_bs3 "$@" ;;
    --check-fixedpoint)   mode_check_fixedpoint "$@" ;;
    --run)                mode_run "$@" ;;
    --rc-strict-suite)    mode_rc_strict_suite "$@" ;;
    --link-run)           mode_link_run "$@" ;;
    --check)              mode_check "$@" ;;
    --ll)                 mode_ll "$@" ;;
    --diff)               mode_diff "$@" ;;
    --diff-fn)            mode_diff_fn "$@" ;;
    --diff-test)          mode_diff_test "$@" ;;
    --score)              mode_score "$@" ;;
    --rank)               mode_rank "$@" ;;
    --asan)               mode_asan "$@" ;;
    --malloc-trace)       mode_malloc_trace "$@" ;;
    --bisect-lines)       mode_bisect_lines "$@" ;;
    --seed-status)        mode_seed_status "$@" ;;
    --seed-diff)          mode_seed_diff "$@" ;;
    --build-seed)         ensure_seed; ok "$SEED_BIN" ;;
    --update-seed)        mode_update_seed "$@" ;;
    --verify-seed)        mode_verify_seed "$@" ;;
    --seed-patch)         mode_seed_patch "$@" ;;
    --seed-sigs)          mode_seed_sigs "$@" ;;
    --seed-fetch)         mode_seed_fetch "$@" ;;
    --seed-fetch-from)    fetch_seed_from_lock "$@" ;;
    --write-seed-lock)    write_seed_lock "$@" ;;
    --seed-publish)       mode_seed_publish "$@" ;;
    --seed-train)         mode_seed_train "$@" ;;
    --seed-train-verify)  mode_seed_train_verify "$@" ;;
    --seed-verify-fp)     mode_seed_verify_fp "$@" ;;
    --seed-canonical-sha) seed_canonical_sha "$@" ;;
    --seed-inputs-hash)   seed_inputs_hash "$@" ;;
    --seed-self-contained) seed_is_self_contained "$@" ;;
    --check-bootstrap-window) mode_check_bootstrap_window "$@" ;;
    --seed-merge)         mode_seed_merge "$@" ;;
    --seed-merge-classify) seed_merge_classify "$@" ;;
    --slot-exec)          mode_slot_exec "$@" ;;
    --cache-fuzz)         mode_cache_fuzz "$@" ;;
    --sweep)              mode_sweep "$@" ;;
    --cache-gc)           mode_cache_gc "$@" ;;
    *) err "unknown mode: $mode"; print_help; exit 1 ;;
  esac
}

# Copy current bs2 IR output to seed/seed.ll with provenance metadata.
# Prepends a comment with commit hash, timestamp, and source directory hash.
mode_update_seed() {
  local src_ir="$SRC_DIR/main.av.ll"
  [ -f "$src_ir" ] || die "no IR found at $src_ir — run --build-bs2 first"

  cp "$src_ir" "$SEED_LL"

  # Prepend provenance comment
  local commit timestamp src_hash
  commit=$(git -C "$BOOTSTRAP_DIR" rev-parse --short HEAD 2>/dev/null || echo "unknown")
  timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  src_hash=$(find "$SRC_DIR" -name '*.av' -exec $SHA256_CMD {} + | $SHA256_CMD | cut -d' ' -f1)

  {
    printf '; seed built from commit %s at %s\n' "$commit" "$timestamp"
    printf '; source hash: %s\n' "$src_hash"
    cat "$SEED_LL"
  } > "${SEED_LL}.tmp" && mv "${SEED_LL}.tmp" "$SEED_LL"

  # The chokepoint for every seed write (train, seed-merge, manual
  # `make update-seed`): a seed that leaves package symbols as extern
  # `declare`s (a metadata fast-path build) can't bootstrap a fresh
  # clone. Refuse to write one rather than pin a brick downstream.
  seed_is_self_contained "$SEED_LL" \
    || die "refusing to write a non-self-contained seed: $SEED_LL references extern package symbols (rebuild with the metadata fast-path disabled — the seed must define every symbol it uses)"

  rm -f "$SEED_BIN" "$BUILD_DIR/seed.o"
  ok "seed/seed.ll updated ($(wc -l < "$SEED_LL" | tr -d ' ') lines)"
  log "provenance: commit=$commit time=$timestamp src_hash=${src_hash:0:16}..."
}

# Show what's in the seed vs the current source — functions added, removed,
# changed. This is the first thing to check when a build fails.
mode_seed_status() {
  [ -f "$SEED_LL" ] || die "no seed found"

  # Compile current source with the seed (without linking) to get fresh IR
  ensure_seed
  log "compiling source with seed to compare..."
  if ! "$SEED_BIN" compile "$SRC_DIR/main.av" >/dev/null 2>&1; then
    err "seed cannot compile current source — seed is too old"
    return 1
  fi

  local fresh_ir="$SRC_DIR/main.av.ll"
  [ -f "$fresh_ir" ] || die "no IR produced"

  local seed_fn_count fresh_fn_count
  seed_fn_count=$(grep -c '^define ' "$SEED_LL")
  fresh_fn_count=$(grep -c '^define ' "$fresh_ir")

  local seed_fns fresh_fns
  seed_fns=$(grep '^define ' "$SEED_LL" | sed 's/define [^ ]* @//' | sed 's/(.*//' | sort)
  fresh_fns=$(grep '^define ' "$fresh_ir" | sed 's/define [^ ]* @//' | sed 's/(.*//' | sort)

  echo "Seed: $seed_fn_count functions ($(wc -l < "$SEED_LL" | tr -d ' ') lines)"
  echo "Fresh: $fresh_fn_count functions ($(wc -l < "$fresh_ir" | tr -d ' ') lines)"
  echo ""

  # New functions (in source but not seed)
  local new_fns
  new_fns=$(comm -13 <(echo "$seed_fns") <(echo "$fresh_fns"))
  if [ -n "$new_fns" ]; then
    local count; count=$(echo "$new_fns" | wc -l | tr -d ' ')
    printf "${C_GREEN}+ %s new functions:${C_RESET}\n" "$count"
    echo "$new_fns" | while read -r fn; do
      printf "  ${C_GREEN}+ %s${C_RESET}\n" "$fn"
    done
    echo ""
  fi

  # Removed functions (in seed but not source)
  local removed_fns
  removed_fns=$(comm -23 <(echo "$seed_fns") <(echo "$fresh_fns"))
  if [ -n "$removed_fns" ]; then
    local count; count=$(echo "$removed_fns" | wc -l | tr -d ' ')
    printf "${C_RED}- %s removed functions:${C_RESET}\n" "$count"
    echo "$removed_fns" | while read -r fn; do
      printf "  ${C_RED}- %s${C_RESET}\n" "$fn"
    done
    echo ""
  fi

  # Changed functions (different line count)
  local common_fns changed=0
  common_fns=$(comm -12 <(echo "$seed_fns") <(echo "$fresh_fns"))
  local changed_list=""
  for fn in $common_fns; do
    local seed_lines fresh_lines
    seed_lines=$(sed -n "/^define.*@${fn}(/,/^}/p" "$SEED_LL" 2>/dev/null | wc -l | tr -d ' ')
    fresh_lines=$(sed -n "/^define.*@${fn}(/,/^}/p" "$fresh_ir" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$seed_lines" != "$fresh_lines" ]; then
      changed=$((changed + 1))
      changed_list="${changed_list}  ~ ${fn} (${seed_lines} → ${fresh_lines} lines)\n"
    fi
  done
  if [ "$changed" -gt 0 ]; then
    printf "${C_YELLOW}~ %s changed functions:${C_RESET}\n" "$changed"
    printf "$changed_list"
    echo ""
  fi

  if [ -z "$new_fns" ] && [ -z "$removed_fns" ] && [ "$changed" -eq 0 ]; then
    ok "seed is up to date — no differences"
  fi
}

# Show a per-function diff between seed IR and fresh-compiled IR.
mode_seed_diff() {
  local fn_name="${1:-}"
  [ -f "$SEED_LL" ] || die "no seed found"

  ensure_seed
  if ! "$SEED_BIN" compile "$SRC_DIR/main.av" >/dev/null 2>&1; then
    die "seed cannot compile current source"
  fi

  local fresh_ir="$SRC_DIR/main.av.ll"
  if [ -n "$fn_name" ]; then
    # Diff a specific function. Handles both bare names (@foo) and
    # qualified names (@"core::names::foo"). Matches any function
    # whose name ENDS with the given string.
    local seed_fn fresh_fn
    seed_fn=$(awk "/^define.*${fn_name}\"?\\(/{found=1} found{print} found&&/^\\}/{exit}" "$SEED_LL")
    fresh_fn=$(awk "/^define.*${fn_name}\"?\\(/{found=1} found{print} found&&/^\\}/{exit}" "$fresh_ir")
    if [ -z "$seed_fn" ]; then
      warn "function '$fn_name' not found in seed — it may be new"
      if [ -n "$fresh_fn" ]; then
        echo "$fresh_fn" | head -20
      fi
      return
    fi
    if [ -z "$fresh_fn" ]; then
      warn "function '$fn_name' not found in fresh IR — it was removed"
      return
    fi
    diff --color=always <(echo "$seed_fn") <(echo "$fresh_fn") || true
  else
    # Overview: just count differences
    mode_seed_status
  fi
}

# Verify the bootstrap chain integrity WITHOUT auto-cycling.
# This is a strict check: build seed → bs2, verify bs2 self-compiles,
# verify the resulting binary can also self-compile. No recovery attempts.
mode_verify_seed() {
  log "step 1/4: building seed binary from seed/seed.ll"
  ensure_seed
  ok "seed binary built"

  log "step 2/4: compiling main.av with seed → bs2"
  # Force a fresh bs2 build
  rm -f "$BS2"
  if ! "$SEED_BIN" compile "$SRC_DIR/main.av" >"$BUILD_DIR/verify_bs2.log" 2>&1; then
    cat "$BUILD_DIR/verify_bs2.log" >&2
    die "FAIL: seed cannot compile current source"
  fi
  link_ll "$SRC_DIR/main.av.ll" "$BS2" "$BUILD_DIR/verify_bs2_link.log"
  ok "bs2 built from seed"

  log "step 3/4: verifying bs2 can compile main.av"
  if ! "$BS2" compile "$SRC_DIR/main.av" >"$BUILD_DIR/verify_bs2_self.log" 2>&1; then
    cat "$BUILD_DIR/verify_bs2_self.log" >&2
    die "FAIL: bs2 cannot self-compile (seed is stale or source has breaking changes)"
  fi
  ok "bs2 self-compile succeeded"

  log "step 4/4: linking and verifying bs3 can compile main.av"
  link_ll "$SRC_DIR/main.av.ll" "$BS3" "$BUILD_DIR/verify_bs3_link.log"
  if ! "$BS3" compile "$SRC_DIR/main.av" >"$BUILD_DIR/verify_bs3_self.log" 2>&1; then
    cat "$BUILD_DIR/verify_bs3_self.log" >&2
    die "FAIL: bs3 cannot self-compile (bootstrap chain is broken at generation 3)"
  fi
  ok "bs3 self-compile succeeded"

  ok "seed verification passed — full bootstrap chain is healthy"
}

# Incremental seed update: compile source with bs2, diff per-function against
# seed, copy new IR to seed, and report exactly which functions changed.
# Faster than 'make update-seed' because it skips the verification rebuild.
mode_seed_patch() {
  ensure_bs2

  log "compiling main.av with bs2 for incremental seed update"
  if ! "$BS2" compile "$SRC_DIR/main.av" >/dev/null 2>&1; then
    die "bs2 cannot compile main.av — fix errors first"
  fi

  local new_ir="$SRC_DIR/main.av.ll"
  [ -f "$new_ir" ] || die "no IR produced at $new_ir"
  [ -f "$SEED_LL" ] || die "no seed found at $SEED_LL"

  # Use python3 to do per-function diffing (awk would be fragile for
  # multiline function bodies with metadata references).
  local result
  result=$(python3 -c "
import re, sys

def extract_functions(path):
    \"\"\"Extract function name -> body text from LLVM IR.\"\"\"
    fns = {}
    current_name = None
    current_lines = []
    with open(path) as f:
        for line in f:
            if line.startswith('define '):
                m = re.search(r'@\"?([^\"(]+)\"?\(', line)
                if m:
                    current_name = m.group(1)
                    current_lines = [line]
            elif current_name is not None:
                current_lines.append(line)
                if line.rstrip() == '}':
                    fns[current_name] = ''.join(current_lines)
                    current_name = None
                    current_lines = []
    return fns

old_fns = extract_functions('$SEED_LL')
new_fns = extract_functions('$new_ir')

added = sorted(set(new_fns) - set(old_fns))
removed = sorted(set(old_fns) - set(new_fns))
common = set(old_fns) & set(new_fns)
changed = sorted(n for n in common if old_fns[n] != new_fns[n])

total_new = len(new_fns)
total_changed = len(added) + len(removed) + len(changed)

if total_changed == 0:
    print('UNCHANGED')
    sys.exit(0)

# Print report
if added:
    print(f'ADDED:{len(added)}')
    for n in added[:20]:
        print(f'  + {n}')
    if len(added) > 20:
        print(f'  ... and {len(added)-20} more')

if removed:
    print(f'REMOVED:{len(removed)}')
    for n in removed[:20]:
        print(f'  - {n}')
    if len(removed) > 20:
        print(f'  ... and {len(removed)-20} more')

if changed:
    print(f'CHANGED:{len(changed)}')
    for n in changed[:30]:
        old_lines = old_fns[n].count('\n')
        new_lines = new_fns[n].count('\n')
        delta = new_lines - old_lines
        sign = '+' if delta > 0 else '' if delta < 0 else '='
        print(f'  ~ {n} ({old_lines} -> {new_lines} lines, {sign}{delta})')
    if len(changed) > 30:
        print(f'  ... and {len(changed)-30} more')

print(f'TOTAL:{total_changed}/{total_new}')
") || die "per-function diff failed"

  if [ "$result" = "UNCHANGED" ]; then
    ok "seed is already up to date (0 functions changed)"
    return
  fi

  # Print the diff report
  echo "$result" | while IFS= read -r line; do
    case "$line" in
      ADDED:*)   printf "${C_GREEN}%s new functions${C_RESET}\n" "${line#ADDED:}" ;;
      REMOVED:*) printf "${C_RED}%s removed functions${C_RESET}\n" "${line#REMOVED:}" ;;
      CHANGED:*) printf "${C_YELLOW}%s changed functions${C_RESET}\n" "${line#CHANGED:}" ;;
      TOTAL:*)
        local nums="${line#TOTAL:}"
        local diff_count="${nums%%/*}"
        local fn_total="${nums##*/}"
        printf "\n${C_BLUE}Summary: %s of %s functions differ${C_RESET}\n" "$diff_count" "$fn_total"
        ;;
      "  + "*)    printf "  ${C_GREEN}%s${C_RESET}\n" "${line#  }" ;;
      "  - "*)    printf "  ${C_RED}%s${C_RESET}\n" "${line#  }" ;;
      "  ~ "*)    printf "  ${C_YELLOW}%s${C_RESET}\n" "${line#  }" ;;
      "  ..."*)   printf "  ${C_DIM}%s${C_RESET}\n" "${line#  }" ;;
      *)          echo "$line" ;;
    esac
  done

  # Copy new IR to seed with provenance
  cp "$new_ir" "$SEED_LL"

  local commit timestamp src_hash
  commit=$(git -C "$BOOTSTRAP_DIR" rev-parse --short HEAD 2>/dev/null || echo "unknown")
  timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  src_hash=$(find "$SRC_DIR" -name '*.av' -exec $SHA256_CMD {} + | $SHA256_CMD | cut -d' ' -f1)

  {
    printf '; seed built from commit %s at %s\n' "$commit" "$timestamp"
    printf '; source hash: %s\n' "$src_hash"
    cat "$SEED_LL"
  } > "${SEED_LL}.tmp" && mv "${SEED_LL}.tmp" "$SEED_LL"

  # Invalidate cached seed binary so next build uses new seed
  rm -f "$SEED_BIN" "$BUILD_DIR/seed.o"

  ok "seed/seed.ll updated ($(wc -l < "$SEED_LL" | tr -d ' ') lines)"
  log "provenance: commit=$commit time=$timestamp"
}

# Compare function signatures between seed IR and source .av files.
# Catches the most common seed staleness issue: parameter count changes.
mode_seed_sigs() {
  [ -f "$SEED_LL" ] || die "no seed found at $SEED_LL"

  local tmpdir
  tmpdir=$(mktemp -d)
  trap "rm -rf $tmpdir" EXIT

  # Extract seed function signatures: "bare_name param_count full_name"
  # from define lines. Handles both @bare_name( and @"mod::name"( forms.
  # For qualified names like "core::scanner::advance", the bare_name is
  # "advance" (last segment after ::) so it can match source fn names.
  grep '^define ' "$SEED_LL" | while IFS= read -r line; do
    # Extract full function name
    local full_name bare_name
    if echo "$line" | grep -q '@"'; then
      full_name=$(echo "$line" | sed 's/.*@"\([^"]*\)".*/\1/')
    else
      full_name=$(echo "$line" | sed 's/.*@\([^(]*\)(.*/\1/')
    fi
    # Strip module prefix for matching: "core::scanner::advance" → "advance"
    bare_name=$(echo "$full_name" | sed 's/.*:://')
    # Count parameters by counting % sigils in the parameter list
    local param_str count
    param_str=$(echo "$line" | sed 's/[^(]*(\([^)]*\)).*/\1/')
    count=$(echo "$param_str" | grep -o '%' | wc -l | tr -d ' ')
    echo "$bare_name $count $full_name"
  done | sort -k1,1 > "$tmpdir/seed_sigs.txt"

  # Extract source function signatures from .av files.
  # Matches: fn name(...) and export fn name(...)
  # Counts parameters by counting commas + 1 (if non-empty param list).
  find "$SRC_DIR" -name '*.av' -print0 | xargs -0 grep -h '^\(export \)\{0,1\}fn ' | \
    sed 's/^export //' | while IFS= read -r line; do
    # Extract function name
    local name
    name=$(echo "$line" | sed 's/^fn \([a-zA-Z_][a-zA-Z0-9_]*\).*/\1/')
    # Extract parameter list (between first parens)
    local params
    params=$(echo "$line" | sed 's/[^(]*(\([^)]*\)).*/\1/' | sed 's/[[:space:]]//g')
    if [ -z "$params" ]; then
      echo "$name 0"
    else
      local count
      count=$(echo "$params" | tr ',' '\n' | wc -l | tr -d ' ')
      echo "$name $count"
    fi
  done | sort -k1,1 -u > "$tmpdir/src_sigs.txt"

  # Build lookup: bare_name → (seed_count, full_name)
  # seed_sigs.txt has: bare_name param_count full_name
  # src_sigs.txt has: name param_count
  local seed_names src_names
  seed_names=$(awk '{print $1}' "$tmpdir/seed_sigs.txt" | sort -u)
  src_names=$(awk '{print $1}' "$tmpdir/src_sigs.txt" | sort -u)

  # Functions with different parameter counts
  local mismatches=0
  local mismatch_list=""
  local common_fns
  common_fns=$(comm -12 <(echo "$seed_names") <(echo "$src_names"))
  for fn in $common_fns; do
    local seed_count src_count full_name
    seed_count=$(grep "^${fn} " "$tmpdir/seed_sigs.txt" | head -1 | awk '{print $2}')
    full_name=$(grep "^${fn} " "$tmpdir/seed_sigs.txt" | head -1 | awk '{print $3}')
    src_count=$(grep "^${fn} " "$tmpdir/src_sigs.txt" | head -1 | awk '{print $2}')
    if [ -n "$seed_count" ] && [ -n "$src_count" ] && [ "$seed_count" != "$src_count" ]; then
      mismatches=$((mismatches + 1))
      local display_name="$fn"
      # Show qualified name if different from bare name
      if [ "$full_name" != "$fn" ]; then
        display_name="$fn ($full_name)"
      fi
      mismatch_list="${mismatch_list}$(printf "  ${C_RED}! %-50s seed=%s  src=%s${C_RESET}\n" "$display_name" "$seed_count" "$src_count")\n"
    fi
  done

  # New functions (in source but not seed)
  local new_fns
  new_fns=$(comm -13 <(echo "$seed_names") <(echo "$src_names"))
  local new_count=0
  if [ -n "$new_fns" ]; then
    new_count=$(echo "$new_fns" | wc -l | tr -d ' ')
  fi

  # Removed functions (in seed but not source)
  local removed_fns
  removed_fns=$(comm -23 <(echo "$seed_names") <(echo "$src_names"))
  local removed_count=0
  if [ -n "$removed_fns" ]; then
    removed_count=$(echo "$removed_fns" | wc -l | tr -d ' ')
  fi

  # Print report
  local seed_total src_total
  seed_total=$(wc -l < "$tmpdir/seed_sigs.txt" | tr -d ' ')
  src_total=$(wc -l < "$tmpdir/src_sigs.txt" | tr -d ' ')
  echo "Seed functions: $seed_total (unique bare names: $(echo "$seed_names" | wc -l | tr -d ' '))"
  echo "Source functions: $src_total"
  echo ""

  if [ "$mismatches" -gt 0 ]; then
    printf "${C_RED}PARAMETER COUNT MISMATCHES: %s${C_RESET}\n" "$mismatches"
    printf "$mismatch_list"
    echo ""
  fi

  if [ "$new_count" -gt 0 ]; then
    printf "${C_GREEN}+ %s new functions (in source, not in seed):${C_RESET}\n" "$new_count"
    echo "$new_fns" | head -20 | while read -r fn; do
      printf "  ${C_GREEN}+ %s${C_RESET}\n" "$fn"
    done
    if [ "$new_count" -gt 20 ]; then
      printf "  ${C_DIM}... and %s more${C_RESET}\n" "$((new_count - 20))"
    fi
    echo ""
  fi

  if [ "$removed_count" -gt 0 ]; then
    printf "${C_YELLOW}- %s removed functions (in seed, not in source):${C_RESET}\n" "$removed_count"
    echo "$removed_fns" | head -20 | while read -r fn; do
      # Show the full qualified name from the seed
      local full_name
      full_name=$(grep "^${fn} " "$tmpdir/seed_sigs.txt" | head -1 | awk '{print $3}')
      if [ "$full_name" != "$fn" ]; then
        printf "  ${C_YELLOW}- %s (%s)${C_RESET}\n" "$fn" "$full_name"
      else
        printf "  ${C_YELLOW}- %s${C_RESET}\n" "$fn"
      fi
    done
    if [ "$removed_count" -gt 20 ]; then
      printf "  ${C_DIM}... and %s more${C_RESET}\n" "$((removed_count - 20))"
    fi
    echo ""
  fi

  if [ "$mismatches" -eq 0 ] && [ "$new_count" -eq 0 ] && [ "$removed_count" -eq 0 ]; then
    ok "seed signatures match source — no mismatches"
  elif [ "$mismatches" -gt 0 ]; then
    warn "parameter count mismatches may cause silent corruption — consider updating the seed"
    return 1
  else
    ok "no parameter count mismatches (new/removed functions are expected during development)"
  fi
}

# ─────────────────────────────────────────────────────────────────────
# Staging-pipeline helpers (shared by the bootstrap window + seed merge)
# ─────────────────────────────────────────────────────────────────────

# llc -O2 the IR at $1 into the object $2, link it with the C runtime
# objects into the binary $3 (atomic .tmp+mv); all tool stderr goes to
# the log $4. Returns 1 on llc failure, 2 on link failure — callers
# own the user-facing message for each.
llc_link_bin() {
  local ll="$1" obj="$2" out="$3" buildlog="$4"
  # $5/$6 override the C runtime objects — the window gate links
  # against objects compiled from HEAD's C sources, not the dev tree's.
  local runtime_o="${5:-$RUNTIME_O}" wrapper_o="${6:-$LLVM_WRAPPER_O}"
  "$LLC" -O2 $LLC_RELOC -filetype=obj "$ll" -o "$obj" 2>"$buildlog" || return 1
  cc -o "$out.tmp" "$obj" "$runtime_o" "$wrapper_o" \
    $STACK_LDFLAGS $EXPORT_DYNAMIC $LD_SELECT -L"$LLVM_PREFIX/lib" -lLLVM $CXXLIB 2>>"$buildlog" \
    || { rm -f "$out.tmp"; return 2; }
  mv "$out.tmp" "$out"
}

# Materialize the seed pinned by a git tree-ish at $2. $1 is a ref
# ("origin/main", a sha) or an index stage (":2" / ":3"); $3 is
# scratch space for an extracted lock file. Prefers a tracked seed.ll
# blob (pre-lock history), else fetches + verifies per that tree's
# seed.lock. Returns non-zero (dest removed) when the tree pins no
# seed or the fetch fails.
materialize_treeish_seed() {
  local spec="$1" dest="$2" locktmp="$3"
  if git -C "$REPO_DIR" show "$spec:bootstrap/seed/seed.ll" > "$dest" 2>/dev/null; then
    return 0
  fi
  if git -C "$REPO_DIR" show "$spec:bootstrap/seed/seed.lock" > "$locktmp" 2>/dev/null; then
    fetch_seed_from_lock "$locktmp" "$dest" && return 0
    rm -f "$dest"
    return 1
  fi
  rm -f "$dest"
  err "'$spec' has neither bootstrap/seed/seed.ll nor bootstrap/seed/seed.lock"
  return 1
}

# Run a compile with the test runner's metadata fast-path env stripped.
# The staging pipelines must see the source as a fresh clone would —
# inherited producer objects could alias the very mismatch these
# checks exist to surface.
hermetic_compile_env() {
  env -u AVRA_USE_METADATA -u AVRA_LIB_OBJS -u AVRA_LIB_PKG_ROOT \
      -u AVRA_DIR_MODULE -u AVRA_COMPILER "$@"
}

# ─────────────────────────────────────────────────────────────────────
# Bootstrap window
# ─────────────────────────────────────────────────────────────────────

# The seed-train rule: feature branches never cycle the seed — the
# integration branch advances it in dedicated `chore(seed): cycle`
# commits, serialized after merges land. Two gates enforce it:
#
#   1. seed-train — no commit on this branch (since the merge-base
#      with the integration branch) CHANGES the pinned seed content.
#   2. window     — the branch's compiler source builds from the
#      integration branch's CURRENT pristine seed, in an isolated
#      copy of the source tree with a cold unit cache, and the
#      produced compiler passes a smoke compile+run.
#
# Any two branches that pass both gates are compilable by the same
# seed BY CONSTRUCTION, so the "no seed can compile the union" merge
# state (the 2026-06-11 incident) becomes unrepresentable. See
# docs/SEED_MERGES.md and CLAUDE.md "Bootstrap window & seed train".
#
# The window build is isolated on purpose: the dev unit cache keys
# entries on (entry fingerprint + compiler hash) but not transitive
# sources, so compiling in-tree could spuriously reuse a cached
# main.av.ll and mask a real violation — and would poison the dev
# caches with stage-binary artifacts. A cold tree has neither problem.

# Echo the integration ref to verify against: refresh origin/<branch>
# (best-effort — offline falls back to the last fetched state) and
# prefer it over a local branch of the same name.
window_resolve_integration_ref() {
  git -C "$REPO_DIR" fetch --quiet origin "$INTEGRATION_BRANCH" 2>/dev/null || true
  if git -C "$REPO_DIR" rev-parse --verify --quiet "origin/$INTEGRATION_BRANCH" >/dev/null; then
    echo "origin/$INTEGRATION_BRANCH"
  elif git -C "$REPO_DIR" rev-parse --verify --quiet "$INTEGRATION_BRANCH" >/dev/null; then
    echo "$INTEGRATION_BRANCH"
  else
    die "cannot resolve integration branch '$INTEGRATION_BRANCH' (set AVRA_INTEGRATION_BRANCH or pass a ref)"
  fi
}

# Gate 1: no commit on this branch changes the pinned seed content.
# File touches alone aren't the crime — the vendored→pinned migration
# deletes seed.ll and adds a lock pinning byte-identical content, so
# the effective seed sha256 is compared across the range before
# rejecting. Returns 1 on a violation (message printed).
window_gate_seed_train() {
  local ref="$1" head_sha="$2" ref_sha="$3"
  local cur_branch
  cur_branch=$(git -C "$REPO_DIR" rev-parse --abbrev-ref HEAD)
  if [ "$cur_branch" = "$INTEGRATION_BRANCH" ] || [ "$head_sha" = "$ref_sha" ]; then
    log "on the integration branch — seed-train gate not applicable (seed cycles live here)"
    return 0
  fi
  local mb offenders
  mb=$(git -C "$REPO_DIR" merge-base "$head_sha" "$ref_sha") \
    || die "no merge-base between HEAD and $ref — wrong integration branch?"
  offenders=$(git -C "$REPO_DIR" log --format='  %h %s' "$mb..$head_sha" -- \
    bootstrap/seed/seed.ll bootstrap/seed/seed.lock)
  if [ -n "$offenders" ]; then
    local head_seed mb_seed
    head_seed=$(ref_seed_sha256 "$head_sha")
    mb_seed=$(ref_seed_sha256 "$mb")
    if [ -n "$head_seed" ] && [ "$head_seed" = "$mb_seed" ]; then
      log "seed pin commits found but the pinned content is unchanged (vendored→pinned migration)"
      offenders=""
    fi
  fi
  if [ -n "$offenders" ]; then
    err "SEED-TRAIN VIOLATION — feature branches never cycle the seed"
    err "commits changing the seed pin (seed.ll / seed.lock) since the merge-base with $ref:"
    printf '%s\n' "$offenders" >&2
    err ""
    err "Fix: drop/revert the seed change and stop dogfooding post-seed features in"
    err "compiler src — seed advancement happens on '$INTEGRATION_BRANCH' only, as"
    err "dedicated 'chore(seed): cycle' commits after merges land. To restore:"
    err "  git checkout $ref -- bootstrap/seed/seed.lock   # (seed.ll on pre-lock history)"
    err "(CLAUDE.md 'Bootstrap window & seed train'; bootstrap/docs/SEED_MERGES.md)"
    return 1
  fi
  ok "seed-train gate — no seed cycles on this branch"
  if ! git -C "$REPO_DIR" diff --quiet HEAD -- bootstrap/seed/seed.lock bootstrap/seed/seed.ll 2>/dev/null; then
    warn "working-tree seed pin differs from HEAD (auto-cycle debris?) — do NOT commit it;"
    warn "restore with: git checkout HEAD -- bootstrap/seed/"
  fi
}

# The gate verifies HEAD, not the working tree: a push ships commits,
# so an untracked scratch file must not fail it and an uncommitted fix
# must not green it (CI checks out exactly this state). One pathspec
# drives the source list, the tree copy, and the dirty-tree warning.
WINDOW_SRC_PATHS=(bootstrap/packages 'bootstrap/*.toml' bootstrap/runtime.c bootstrap/llvm_wrapper.c)

# Echo "blob-sha path" lines for the compiler-relevant sources at
# commit $1. Git already knows the blob hashes, so this is one
# subprocess instead of re-hashing ~500 files.
window_src_list() {
  git -C "$REPO_DIR" ls-tree -r "$1" --format='%(objectname) %(path)' -- \
      "${WINDOW_SRC_PATHS[@]}" \
    | LC_ALL=C sort
}

# Echo the verify-cache fingerprint for commit $2: integration seed
# identity + the blob-sha/path line of every compiler-relevant source.
# Paths stay in the hash — a rename-only change alters module
# resolution and must not reuse a stale PASS marker. Test files are
# excluded: main.av's import graph never reaches */tests/*, so
# test-only commits must not bust the cache.
window_fingerprint() {
  local seed_id="$1" commit="$2"
  { echo "seed:$seed_id"
    window_src_list "$commit" | grep -v '/tests/'
  } | $SHA256_CMD | awk '{print $1}'
}

# Copy the compiler sources AT COMMIT $2 into $1/tree so the window
# compile sees exactly what a push ships, starts from a cold unit
# cache, and writes nothing into the dev tree.
window_copy_tree() {
  local win="$1" commit="$2"
  rm -rf "$win/tree"
  mkdir -p "$win/tree"
  git -C "$REPO_DIR" archive "$commit" -- "${WINDOW_SRC_PATHS[@]}" \
    | tar -xf - -C "$win/tree" \
    || die "source-tree copy failed"
  # git archive preserves symlinks; one pointing outside the tree
  # would make the compile read content that is NOT in HEAD, breaking
  # the gate's whole claim. No legitimate compiler source is a
  # symlink — refuse outright.
  local links
  links=$(find "$win/tree" -type l | head -5)
  [ -z "$links" ] || die "symlinked compiler sources are not supported by the gate:
$links"
}

# Compile HEAD's C runtime inputs from the copied tree into
# window-local objects (flags mirror ensure_runtime /
# ensure_llvm_wrapper). The gate must link the C code that ships, not
# whatever the dev tree currently holds.
window_c_objects() {
  local win="$1"
  cc -c -O0 -g -o "$win/runtime.o" "$win/tree/bootstrap/runtime.c" \
    || die "window runtime.c compile failed"
  cc -c -O2 -I"$LLVM_PREFIX/include" -o "$win/llvm_wrapper.o" "$win/tree/bootstrap/llvm_wrapper.c" \
    || die "window llvm_wrapper.c compile failed"
}

# Echo the path of a stage binary built from the integration seed at
# $2/seed.ll, linked against the window-local C objects. Reuses the
# dev build/seed when its full input fingerprint (seed IR + C inputs)
# matches; otherwise builds (and caches) a window-local one.
window_stage_binary() {
  local ref="$1" win="$2" ref_sha="$3"
  local win_seed_fp
  win_seed_fp=$(seed_inputs_hash "$win/seed.ll" \
    "$win/tree/bootstrap/runtime.c" "$win/tree/bootstrap/llvm_wrapper.c")
  if [ -x "$SEED_BIN" ] && [ "$(cat "$BUILD_DIR/.seed_hash" 2>/dev/null)" = "$win_seed_fp" ]; then
    log "integration seed is byte-identical to the local build/seed — reusing it"
    echo "$SEED_BIN"
    return 0
  fi
  local stage_bin="$win/seed_bin"
  if [ "$(cat "$win/.stage_fp" 2>/dev/null)" = "$win_seed_fp" ] && [ -x "$stage_bin" ]; then
    log "window stage binary cached for this integration seed"
    echo "$stage_bin"
    return 0
  fi
  log "building stage binary from the integration seed ($ref @ ${ref_sha:0:12})"
  case $(llc_link_bin "$win/seed.ll" "$win/seed.o" "$stage_bin" "$win/stage.build.log" \
           "$win/runtime.o" "$win/llvm_wrapper.o"; echo $?) in
    0) : ;;
    1) err "llc rejected the INTEGRATION seed itself — integration-side problem,"
       err "not a window violation. Check $ref's seed health (make verify-seed there)."
       tail -5 "$win/stage.build.log" >&2
       return 1 ;;
    *) cat "$win/stage.build.log" >&2; die "window stage link failed" ;;
  esac
  printf '%s' "$win_seed_fp" > "$win/.stage_fp"
  echo "$stage_bin"
}

# Compile + run a small program with the compiler $2 (scratch dir $1)
# and verify its output, proving the compiler is not garbage. Used by
# the window gate on the window-built compiler and by --seed-publish
# on the stage binary of the seed about to become the pin.
smoke_test_compiler() {
  local win="$1" bs2w="$2" runtime_o="${3:-}" wrapper_o="${4:-}"
  cat > "$win/smoke.av" <<'SMOKE'
type Pair = { a: int, b: int }

enum Shape {
    Dot,
    Wide(w: int),
}

fn add(a: int, b: int) -> int { a + b }

fn main() -> int {
    let xs = [1, 2, 3]
    mut sum = 0
    for x in xs { sum = sum + x }
    let tag = if sum == 6 { "ok" } else { "bad" }
    let double = (n: int) -> n * 2
    let p = Pair { a: double(sum), b: xs[1] }
    let shape_w = match Shape.Wide(p.a + p.b) {
        .Dot -> 0
        .Wide(w) -> w
    }
    println("window-smoke ${tag} ${string(add(shape_w, 4))}")
    0
}
SMOKE
  hermetic_compile_env "$bs2w" compile "$win/smoke.av" >"$win/smoke.compile.log" 2>&1 \
    || { tail -10 "$win/smoke.compile.log" >&2; die "window-built compiler failed to compile the smoke program"; }
  llc_link_bin "$win/smoke.av.ll" "$win/smoke.o" "$win/smoke.bin" "$win/smoke.build.log" \
      ${runtime_o:+"$runtime_o"} ${wrapper_o:+"$wrapper_o"} \
    || { cat "$win/smoke.build.log" >&2; die "smoke build failed"; }
  local smoke_out
  smoke_out=$("$win/smoke.bin")
  if [ "$smoke_out" != "window-smoke ok 18" ]; then
    err "window-built compiler produced a broken binary — smoke output was:"
    printf '  %s\n' "$smoke_out" >&2
    err "expected: window-smoke ok 18"
    return 1
  fi
}

mode_check_bootstrap_window() {
  local ref="${1:-}"
  [ -n "$ref" ] || ref=$(window_resolve_integration_ref) || return 1
  local head_sha ref_sha
  head_sha=$(git -C "$REPO_DIR" rev-parse HEAD) || die "not a git checkout"
  ref_sha=$(git -C "$REPO_DIR" rev-parse "$ref^{commit}") || die "cannot resolve ref '$ref'"

  window_gate_seed_train "$ref" "$head_sha" "$ref_sha" || return 1

  local win="$BUILD_DIR/window"
  mkdir -p "$win"
  local seed_id
  seed_id=$(ref_seed_sha256 "$ref")
  [ -n "$seed_id" ] || die "$ref has neither bootstrap/seed/seed.ll nor bootstrap/seed/seed.lock"

  # The gate verifies HEAD — what a push actually ships. Warn when the
  # working tree diverges so a manual run isn't mistaken for a verdict
  # on uncommitted work.
  if [ -n "$(git -C "$REPO_DIR" status --porcelain -- "${WINDOW_SRC_PATHS[@]}" 2>/dev/null | head -1)" ]; then
    warn "compiler sources in the working tree differ from HEAD — the gate verifies HEAD (commit first)"
  fi

  local fp marker="$win/.window_verified"
  fp=$(window_fingerprint "$seed_id" "$head_sha")
  if [ "${AVRA_FORCE_WINDOW:-0}" != "1" ] && [ -f "$marker" ] \
     && [ "$(cat "$marker" 2>/dev/null)" = "$fp" ]; then
    ok "bootstrap window cached — integration seed + compiler sources unchanged since last verify"
    return 0
  fi

  # One window build at a time: a pre-push hook, a manual run and a
  # local CI rehearsal share build/window/, and a concurrent rm -rf of
  # the tree mid-compile produces garbage verdicts. mkdir is the
  # atomic test-and-set (macOS ships no flock); a pid file lets a
  # crashed holder's lock be reaped instead of wedging the gate.
  local gate_lock="$win/.lock"
  while ! mkdir "$gate_lock" 2>/dev/null; do
    local owner; owner=$(cat "$gate_lock/pid" 2>/dev/null)
    if [ -n "$owner" ] && ! kill -0 "$owner" 2>/dev/null; then
      rm -rf "$gate_lock"
      continue
    fi
    log "another window verify is running (pid ${owner:-?}) — waiting"
    sleep 2
  done
  echo $$ > "$gate_lock/pid"
  trap 'rm -rf "$BUILD_DIR/window/.lock"' EXIT

  # The wait may have outlasted the other run — its green marker is
  # ours to reuse.
  if [ "${AVRA_FORCE_WINDOW:-0}" != "1" ] && [ -f "$marker" ] \
     && [ "$(cat "$marker" 2>/dev/null)" = "$fp" ]; then
    ok "bootstrap window cached — verified by a concurrent run"
    return 0
  fi

  materialize_treeish_seed "$ref" "$win/seed.ll" "$win/integration.seed.lock" \
    || die "cannot materialize the integration seed"

  log "copying HEAD's compiler sources into an isolated tree"
  window_copy_tree "$win" "$head_sha"
  local entry="$win/tree/bootstrap/packages/cli/src/main.av"
  [ -f "$entry" ] || die "copied tree is missing $entry"
  window_c_objects "$win"

  local stage_bin
  stage_bin=$(window_stage_binary "$ref" "$win" "$ref_sha") || return 1

  log "compiling HEAD's compiler source with the integration seed"
  if ! hermetic_compile_env "$stage_bin" compile "$entry" >"$win/compile.log" 2>&1; then
    err "BOOTSTRAP WINDOW VIOLATION — compiler source does not build from the integration seed"
    err "The branch dogfoods syntax/enum-variants newer than '$INTEGRATION_BRANCH''s seed"
    err "(or depends on a local seed cycle that never happened on the train)."
    err ""
    err "Fix: keep the new feature's implementation, but remove its USE from compiler"
    err "src until the feature lands and the integration seed advances past it"
    err "(CLAUDE.md Phase A/B discipline). Compile log (excerpt):"
    tail -15 "$win/compile.log" >&2
    err "full log: $win/compile.log"
    return 1
  fi

  log "linking the window-built compiler"
  llc_link_bin "$entry.ll" "$win/bs2w.o" "$win/bs2w" "$win/bs2w.build.log" \
      "$win/runtime.o" "$win/llvm_wrapper.o" \
    || { cat "$win/bs2w.build.log" >&2; die "window compiler build failed"; }

  log "smoke-testing the window-built compiler"
  smoke_test_compiler "$win" "$win/bs2w" "$win/runtime.o" "$win/llvm_wrapper.o" || return 1

  printf '%s' "$fp" > "$marker"
  ok "bootstrap window holds — HEAD's source builds + runs from $ref's pristine seed"
}

# ─────────────────────────────────────────────────────────────────────
# Differential-test harness (HRN) — old compiler is the oracle
# ─────────────────────────────────────────────────────────────────────
#
# Build the compiler at TWO refs — OLD (the oracle baseline) and NEW (the
# candidate) — and assert they emit BYTE-IDENTICAL IR for the same inputs:
# the whole compiler source (the selfhost differential) plus a corpus of
# .av programs. A behaviour-preserving change keeps every output identical;
# a divergence prints a readable per-input diff and exits non-zero. This is
# the go-hard safety net of spine doc sec 8: rip the foundation
# out and instantly catch behaviour drift, with no migration scaffolding.
#
# Both compilers build from the SAME pinned seed — the seed-train invariant
# (enforced by --check-bootstrap-window) guarantees a feature branch's seed
# equals the integration seed — so any IR difference is attributable to
# compiler SOURCE alone, never the seed. Builds are isolated (cold unit
# cache, like the window gate) and cached on a (seed + compiler-source)
# fingerprint, so a re-run with an unchanged base/HEAD is cheap.
#
# Why byte-identical IR is the oracle: the toolchain is deterministic (the
# selfhost fixed point already relies on bs2 and bs3 emitting identical IR),
# so identical IR ⇒ identical object ⇒ identical run-results by construction.
# IR equality is therefore the strict superset of the "binary / test-results"
# checks. When a future refactor changes IR *legitimately* (e.g. SSA
# renumbering) the divergence surfaces here for a human to confirm against
# results — exactly the "byte-identical IR where applicable" of sec 8.
#
# The corpus is the CURATED standalone set (bootstrap/tests/difftest_corpus/
# *.av): small, single-file, feature-diverse programs that compile with a bare
# `bs2 compile`. The selfhost pass is the comprehensive oracle; the corpus is
# the surgical complement — a divergence in (say) channel or match codegen
# surfaces against a ~20-line file instead of bisecting the ~590k-line selfhost
# IR. It is NOT the test-harness suite (tests/*.av): those need @std + the
# spec/given/then runtime, so OLD cannot compile them standalone — every one
# would be skipped after a doomed ~1s compile, leaving the corpus phase with
# ZERO real comparisons (the bug this default fixed).
#
# The two selfhost compiles (OLD and NEW) run CONCURRENTLY — `--output` stops
# them clobbering each other's IR file — so the selfhost phase, the dominant
# post-build cost, takes ~one compile's wall time, not two. The corpus files
# then fan out in parallel too (bounded by DIFF_TEST_JOBS). The selfhost and
# corpus PHASES are still sequential, but the corpus is tiny (~13 files) so
# overlapping them across phases would save a rounding error, not the builds.
#
# Usage / knobs:
#   --base <ref>            OLD/oracle ref     (default: integration branch)
#   --new  <ref>            NEW/candidate ref  (default: HEAD)
#   --new-prebuilt          reuse the warm build/bs2 as NEW instead of building
#                           it in isolation — skips the dominant ~5-7 min cold
#                           rebuild. LOCAL convenience only: NON-HERMETIC (the
#                           binary's seed/source aren't pinned); CI never uses it.
#   DIFF_TEST_CORPUS=<glob> corpus inputs  (default: tests/difftest_corpus/*.av)
#   DIFF_TEST_JOBS=<n>      corpus fan-out width (default: ~nproc-1, capped at 8)
#   AVRA_FORCE_DIFFTEST=1   ignore the per-ref compiler build cache

DIFFTEST_DIR="$BUILD_DIR/difftest"

# Build the compiler from git ref $1 into dir $2 (isolated + cached),
# reusing the bootstrap-window primitives. Produces $2/bs2 plus $2/tree
# (the ref's compiler sources) and $2/{runtime,llvm_wrapper}.o.
dt_build_compiler() {
  local ref="$1" out="$2"
  local ref_sha; ref_sha=$(git -C "$REPO_DIR" rev-parse "$ref^{commit}") \
    || die "diff-test: cannot resolve ref '$ref'"
  local seed_id; seed_id=$(ref_seed_sha256 "$ref") \
    || die "diff-test: '$ref' pins no seed (no seed.ll or seed.lock)"
  mkdir -p "$out"
  local fp marker="$out/.dt_built"
  fp=$(window_fingerprint "$seed_id" "$ref_sha")
  if [ "${AVRA_FORCE_DIFFTEST:-0}" != "1" ] && [ -x "$out/bs2" ] \
     && [ "$(cat "$marker" 2>/dev/null)" = "$fp" ]; then
    log "diff-test: compiler @ $ref (${ref_sha:0:12}) cached"
    return 0
  fi
  log "diff-test: building compiler @ $ref (${ref_sha:0:12})"
  materialize_treeish_seed "$ref" "$out/seed.ll" "$out/seed.lock" \
    || die "diff-test: cannot materialize the seed pinned by $ref"
  window_copy_tree "$out" "$ref_sha"
  local entry="$out/tree/bootstrap/packages/cli/src/main.av"
  [ -f "$entry" ] || die "diff-test: $ref's tree is missing $entry"
  window_c_objects "$out"
  local stage; stage=$(window_stage_binary "$ref" "$out" "$ref_sha") || return 1
  if ! hermetic_compile_env "$stage" compile "$entry" >"$out/selfcompile.log" 2>&1; then
    err "diff-test: $ref's compiler source failed to build from its seed"
    tail -15 "$out/selfcompile.log" >&2
    return 1
  fi
  llc_link_bin "$entry.ll" "$out/bs2.o" "$out/bs2" "$out/bs2.build.log" \
      "$out/runtime.o" "$out/llvm_wrapper.o" \
    || { cat "$out/bs2.build.log" >&2; die "diff-test: $ref compiler link failed"; }
  printf '%s' "$fp" > "$marker"
}

# Compile $1 (an absolute .av path) with the compiler BINARY $2, writing the
# emitted IR straight to $4 via `--output`. Because --output fully redirects
# (nothing is written next to the input), two compilers can compile the SAME
# input concurrently without clobbering each other's <input>.ll — that is what
# lets the selfhost + corpus passes parallelize. Per-call log → $3/last.compile.log.
# Returns bs2's exit status.
dt_compile_ir() {
  local input="$1" bs2="$2" logdir="$3" out_ll="$4"
  hermetic_compile_env "$bs2" compile --output="$out_ll" "$input" \
    >"$logdir/last.compile.log" 2>&1
}

# Bounded fan-out width for the corpus differential. Leaves a core free and
# caps the pool so a large overridden DIFF_TEST_CORPUS can't fork-bomb / OOM
# (the snw0 class on small boxes). Override with DIFF_TEST_JOBS.
dt_default_jobs() {
  local n; n=$(nproc 2>/dev/null || echo 4)
  if [ "$n" -gt 2 ]; then n=$((n - 1)); else n=1; fi   # leave a core free
  if [ "$n" -gt 8 ]; then n=8; fi                       # cap the pool
  printf '%s' "$n"
}

# Collision-free per-input work-dir key: a hash of the FULL path. Same-named
# files from different directories (a multi-dir DIFF_TEST_CORPUS override) must
# not share $wd/corpus/<key> — that would race their status/.ll files and
# mis-attribute the verdict. The display name (basename) is kept separate.
dt_corpus_key() {
  printf '%s' "$1" | cksum | cut -d' ' -f1
}

# Run ONE corpus input through BOTH compilers in an isolated per-input dir
# (keyed by full path, not basename), so tasks fan out without racing. Writes a
# one-word verdict to $cwd/status (ok | diverge | newfail | skip) for the caller
# to aggregate; never fails the calling shell (a bad compile is recorded, not
# propagated up).
dt_corpus_task() {
  local input="$1" old_bs2="$2" new_bs2="$3" wd="$4"
  local cwd="$wd/corpus/$(dt_corpus_key "$input")"
  mkdir -p "$cwd"
  # OLD is the oracle: a file it can't compile standalone is out of scope.
  if ! dt_compile_ir "$input" "$old_bs2" "$cwd" "$cwd/old.ll"; then
    printf 'skip' > "$cwd/status"; return 0
  fi
  if ! dt_compile_ir "$input" "$new_bs2" "$cwd" "$cwd/new.ll"; then
    printf 'newfail' > "$cwd/status"; return 0
  fi
  if diff -q "$cwd/old.ll" "$cwd/new.ll" >/dev/null 2>&1; then
    printf 'ok' > "$cwd/status"
  else
    printf 'diverge' > "$cwd/status"
  fi
}

# Run-equivalence check for one corpus divergence (--run-equiv): link BOTH
# already-emitted artifacts and execute them; equivalent means byte-identical
# stdout AND equal exit codes. The weaker oracle for INTENDED IR changes —
# behavior, not bytes. Bounded by a timeout so a wedged artifact fails loudly.
dt_run_equiv_check() {
  local cwd="$1" name="$2"
  [ -f "$cwd/old.ll" ] && [ -f "$cwd/new.ll" ] || return 1
  ensure_runtime; ensure_llvm_wrapper
  link_ll "$cwd/old.ll" "$cwd/old.bin" "$cwd/link.old.log" || { err "run-equiv: OLD artifact of '$name' failed to link"; return 1; }
  link_ll "$cwd/new.ll" "$cwd/new.bin" "$cwd/link.new.log" || { err "run-equiv: NEW artifact of '$name' failed to link"; return 1; }
  local rc_old=0 rc_new=0
  timeout 30 "$cwd/old.bin" >"$cwd/run.old.out" 2>&1 || rc_old=$?
  timeout 30 "$cwd/new.bin" >"$cwd/run.new.out" 2>&1 || rc_new=$?
  if [ "$rc_old" = "$rc_new" ] && diff -q "$cwd/run.old.out" "$cwd/run.new.out" >/dev/null 2>&1; then
    log "diff-test: '$name' IR diverged but RUNS identically (exit $rc_old) — intended-change equivalence holds"
    return 0
  fi
  err "run-equiv: '$name' RUNS DIFFERENTLY (exit $rc_old vs $rc_new) — outputs: $cwd/run.old.out vs $cwd/run.new.out"
  diff -u "$cwd/run.old.out" "$cwd/run.new.out" | head -40 >&2
  return 1
}

# Entry point for `--diff-test` (see the section banner above). Builds the
# OLD/oracle and NEW/candidate compilers, then asserts byte-identical IR
# over the selfhost source + corpus; prints a readable diff and returns
# non-zero on any divergence.
mode_diff_test() {
  local base="" new="HEAD" prebuilt=0 run_equiv=0 intended=0
  while [ $# -gt 0 ]; do
    case "$1" in
      --base) base="${2:?--base needs a ref}"; shift 2 ;;
      --new)  new="${2:?--new needs a ref}";  shift 2 ;;
      --new-prebuilt) prebuilt=1; shift ;;
      --run-equiv) run_equiv=1; shift ;;
      *) die "diff-test: unknown argument '$1' (want --base <ref> / --new <ref> / --new-prebuilt / --run-equiv)" ;;
    esac
  done
  [ -n "$base" ] || base="${AVRA_DIFFTEST_BASE:-$(window_resolve_integration_ref)}"

  # The oracle model requires OLD and NEW to build from the SAME seed, so any
  # IR difference is attributable to compiler SOURCE alone. Assert it (fail
  # fast, before the expensive builds) for the hermetic path. --new-prebuilt
  # deliberately opts out: it reuses the working-tree build/bs2 as NEW, whose
  # seed/source aren't pinned — a LOCAL convenience, never the CI oracle.
  local base_seed; base_seed=$(ref_seed_sha256 "$base") || true
  [ -n "$base_seed" ] \
    || die "diff-test: base ($base) pins no seed (no seed.ll/seed.lock)"
  if [ "$prebuilt" = "0" ]; then
    local new_seed; new_seed=$(ref_seed_sha256 "$new") || true
    [ -n "$new_seed" ] \
      || die "diff-test: new ($new) pins no seed (no seed.ll/seed.lock)"
    [ "$base_seed" = "$new_seed" ] \
      || die "diff-test: seed pin differs between OLD ($base) and NEW ($new) — a divergence would be ambiguous (seed vs source). Align the pins (feature branches must not cycle the seed; see --check-bootstrap-window)."
  fi

  local old="$DIFFTEST_DIR/old" newd="$DIFFTEST_DIR/new"
  local old_bs2 new_bs2 new_label="$new"
  dt_build_compiler "$base" "$old" || return 1
  old_bs2="$old/bs2"
  if [ "$prebuilt" = "1" ]; then
    new_bs2="$BOOTSTRAP_DIR/build/bs2"
    [ -x "$new_bs2" ] \
      || die "diff-test: --new-prebuilt needs a built compiler at build/bs2 — run 'make build-quick' first"
    mkdir -p "$newd"                          # holds the NEW compile logs
    new_label="build/bs2 (prebuilt, NON-HERMETIC)"
    warn "diff-test: --new-prebuilt reuses build/bs2 as NEW — fast but NON-HERMETIC (its seed/source aren't pinned). The default hermetic build is the authoritative check (CI always uses it)."
  else
    dt_build_compiler "$new" "$newd" || return 1
    new_bs2="$newd/bs2"
  fi
  log "diff-test: OLD/oracle=$base   NEW/candidate=$new_label"

  local wd="$DIFFTEST_DIR/work"; rm -rf "$wd"; mkdir -p "$wd"
  local fails=0 checked=0 skipped=0

  # ── Selfhost differential: compile the OLD compiler's OWN source with
  # BOTH compilers, CONCURRENTLY. OLD parses it by construction; a
  # behaviour-preserving NEW must emit identical IR. This single input
  # exercises ~all codegen and is the dominant post-build cost — --output
  # keeps the two compiles from racing on main.av.ll, so they run in parallel.
  log "diff-test: selfhost differential — both compilers compile the compiler (parallel)"
  local self="$old/tree/bootstrap/packages/cli/src/main.av"
  local p_old p_new rc_old rc_new
  dt_compile_ir "$self" "$old_bs2" "$old"  "$wd/self.old.ll" & p_old=$!
  dt_compile_ir "$self" "$new_bs2" "$newd" "$wd/self.new.ll" & p_new=$!
  wait "$p_old"; rc_old=$?
  wait "$p_new"; rc_new=$?
  if [ "$rc_old" -ne 0 ]; then
    cat "$old/last.compile.log" >&2; die "diff-test: OLD failed its own selfhost compile (oracle broken)"
  fi
  checked=$((checked+1))
  if [ "$rc_new" -ne 0 ]; then
    err "diff-test: NEW failed to compile the compiler source that OLD compiles — regression"
    tail -15 "$newd/last.compile.log" >&2
    fails=$((fails+1))
  elif diff -q "$wd/self.old.ll" "$wd/self.new.ll" >/dev/null 2>&1; then
    ok "diff-test: selfhost IR byte-identical ($(wc -l <"$wd/self.old.ll" | tr -d ' ') lines)"
  elif [ "$run_equiv" = "1" ]; then
    # Intended-IR-change mode: the selfhost artifacts are COMPILERS, whose
    # run-equivalence is exactly what the corpus phase below measures (each
    # corpus program is compiled by both and must RUN identically) plus the
    # full suite under NEW (CI's rc-strict job). Record, don't fail.
    intended=$((intended+1))
    warn "diff-test: selfhost IR diverged — INTENDED (run-equiv mode); corpus run-equivalence + the suite are the oracle"
  else
    err "diff-test: SELFHOST IR DIVERGED — the compiler compiles itself differently"
    err "  full IR: $wd/self.old.ll  vs  $wd/self.new.ll"
    diff -u "$wd/self.old.ll" "$wd/self.new.ll" | head -80 >&2
    fails=$((fails+1))
  fi

  # ── Corpus differential: the CURATED standalone corpus
  # (tests/difftest_corpus/*.av) — small, single-file, feature-diverse programs
  # that compile with a bare `bs2 compile`, giving real per-feature IR
  # comparisons that localize a divergence to a tiny file (the selfhost pass
  # stays the comprehensive oracle). NOT the test-harness suite (tests/*.av):
  # those need @std + the spec/given/then runtime, so the OLD oracle can't
  # compile them standalone — every one would be skipped, doing zero work.
  # (Always runs — it's now tiny and fast; there is no skip-the-corpus knob.)
  local glob="${DIFF_TEST_CORPUS:-$BOOTSTRAP_DIR/tests/difftest_corpus/*.av}"
  local jobs="${DIFF_TEST_JOBS:-$(dt_default_jobs)}"
  log "diff-test: corpus differential — $glob (jobs=$jobs)"
  local divergent=() skipped_names=() input name cwd status in_batch=0 first_div_cwd=""
  # Fan out: each input runs through both compilers in its own dir
  # (dt_corpus_task), bounded to $jobs concurrent so a large overridden
  # corpus can't OOM. --output means no two tasks share an output path.
  for input in $glob; do
    [ -f "$input" ] || continue
    dt_corpus_task "$input" "$old_bs2" "$new_bs2" "$wd" &
    in_batch=$((in_batch + 1))
    if [ "$in_batch" -ge "$jobs" ]; then wait; in_batch=0; fi
  done
  wait
  # Aggregate the per-task verdicts in deterministic glob order. OLD is the
  # oracle: a 'skip' means OLD couldn't compile the file standalone (out of
  # scope); for the curated corpus that signals a regressed file.
  for input in $glob; do
    [ -f "$input" ] || continue
    name=$(basename "$input"); cwd="$wd/corpus/$(dt_corpus_key "$input")"
    status=$(cat "$cwd/status" 2>/dev/null || printf 'missing')
    case "$status" in
      ok)      checked=$((checked+1)); rm -rf "$cwd" ;;
      skip)    skipped=$((skipped+1)); skipped_names+=("$name"); rm -rf "$cwd" ;;
      newfail) checked=$((checked+1)); fails=$((fails+1)); divergent+=("$name")
               [ -z "$first_div_cwd" ] && first_div_cwd="$cwd"
               err "diff-test: NEW failed to compile '$name' that OLD compiled — regression" ;;
      diverge)
        checked=$((checked+1))
        if [ "$run_equiv" = "1" ] && dt_run_equiv_check "$cwd" "$name"; then
          intended=$((intended+1)); rm -rf "$cwd"
        else
          fails=$((fails+1)); divergent+=("$name")
          [ -z "$first_div_cwd" ] && first_div_cwd="$cwd"
        fi ;;
      *)       fails=$((fails+1))
               err "diff-test: corpus task for '$name' produced no verdict (harness bug)" ;;
    esac
  done
  if [ ${#divergent[@]} -gt 0 ]; then
    err "diff-test: ${#divergent[@]} corpus input(s) diverged:"
    printf '  %s\n' "${divergent[@]}" >&2
    # Show the first IR divergence — but only when both sides exist (a
    # NEW-compile failure leaves no new.ll to diff against). first_div_cwd is
    # the work dir of divergent[0] (path-keyed, not basename).
    if [ -f "$first_div_cwd/old.ll" ] && [ -f "$first_div_cwd/new.ll" ]; then
      err "first divergence (${divergent[0]}):"
      diff -u "$first_div_cwd/old.ll" "$first_div_cwd/new.ll" | head -80 >&2
    fi
  fi
  # A skip in the curated corpus is a misconfiguration, not normal scope
  # trimming — surface it so a non-standalone file gets fixed or removed
  # instead of silently buying zero coverage at the cost of a compile.
  if [ ${#skipped_names[@]} -gt 0 ]; then
    warn "diff-test: ${#skipped_names[@]} corpus input(s) skipped (OLD couldn't compile standalone — fix or remove them):"
    printf '  %s\n' "${skipped_names[@]}" >&2
  fi

  log "diff-test: compared $checked input(s), skipped $skipped (not standalone-compilable)"
  if [ "$run_equiv" = "1" ] && [ "$skipped" -gt 0 ]; then
    err "diff-test: run-equiv mode forbids corpus skips — the run oracle is weaker than byte-identity, so coverage must be total"
    fails=$((fails+1))
  fi
  if [ "$fails" -eq 0 ]; then
    if [ "$run_equiv" = "1" ] && [ "$intended" -gt 0 ]; then
      ok "DIFF-TEST RUN-EQUIV PASS — IR diverged at $intended site(s) (intended) but every corpus artifact RUNS identically; the suite (CI rc-strict) completes the oracle"
    else
      ok "DIFF-TEST PASS — OLD ($base) and NEW ($new_label) emit byte-identical IR"
    fi
    return 0
  fi
  err "DIFF-TEST FAIL — $fails divergence(s); the change is NOT behaviour-preserving"
  if [ "$run_equiv" = "1" ]; then
    err "(run-equiv mode: a corpus artifact RUNS differently — the IR change is not behavior-preserving)"
  else
    err "(if the IR change is intentional, confirm run-results match and label the PR intended-ir-change to run the run-equivalence oracle)"
  fi
  return 1
}

# ─────────────────────────────────────────────────────────────────────
# Seed-merge staging
# ─────────────────────────────────────────────────────────────────────

# Classify a failed stage-compile of the merged source. Mirrors the
# taxonomy of docs/SEED_MERGES.md "choosing a base":
#   corruption   — the stage binary died by signal / corrupted memory
#                  while compiling: the base seed predates a
#                  codegen-correctness fix present in the union (the
#                  alloca zero-init class). The side that HAS the fix
#                  should win.
#   extern-guard — the base seed's baked predeclare table conflicts
#                  with the merged source's extern signatures; the
#                  side whose refactor it is should win.
#   parse        — the base seed's parser predates surface syntax in
#                  the merged source. NOTE: new literal forms often
#                  surface as `undefined variable`, not a parse error
#                  — both classify here.
#   unknown      — none of the known signatures matched; read the log.
seed_merge_classify() {
  local rc="$1" logfile="$2"
  if [ "$rc" -ge 128 ] \
     || grep -qiE 'segmentation fault|bus error|illegal instruction|unmatched tag|signal [0-9]+' "$logfile" 2>/dev/null; then
    echo corruption; return
  fi
  if grep -q 'redeclared with a conflicting signature' "$logfile" 2>/dev/null; then
    echo extern-guard; return
  fi
  if grep -qiE 'parse error|unterminated|F0001|F3100|undefined variable' "$logfile" 2>/dev/null; then
    echo parse; return
  fi
  echo unknown
}

# Human next-step hints per failure class, with a log excerpt.
seed_merge_hint() {
  local cand="$1" cls="$2" logfile="$3"
  err "[$cand] stage-compile failed — class: $cls"
  case "$cls" in
    parse)
      err "  The '$cand' seed's parser predates syntax in the merged source (new"
      err "  literal forms often surface as 'undefined variable'). The side that"
      err "  HAS the parser for it should be the base. If BOTH sides land here,"
      err "  the union dogfoods two branches' new syntax — the state the"
      err "  bootstrap window forbids; stage via IR-level patching as a last"
      err "  resort (docs/SEED_MERGES.md)."
      ;;
    extern-guard)
      err "  The '$cand' seed's baked predeclare table conflicts with the merged"
      err "  source's extern signatures. The side whose extern refactor it is"
      err "  should be the base (its seed already matches the new signatures)."
      ;;
    corruption)
      err "  The '$cand' stage binary corrupted while compiling the merged source"
      err "  — it predates a codegen-correctness fix present in the union."
      err "  Prefer the side that HAS the fix in its machine code."
      err "  Forensics: AVRA_REDZONES=1, docs/RC_MEMORY_RUNBOOK.md."
      ;;
    *)
      err "  No known failure signature matched — read the log."
      ;;
  esac
  err "  log (tail): $logfile"
  tail -6 "$logfile" >&2 2>/dev/null || :
}

# Try one candidate base seed end-to-end short of seed regeneration:
# materialize it at seed/seed.ll, patch traps, build stage1 off to the
# side (dev caches untouched), compile the merged source, link bs2,
# self-compile verify. Returns non-zero when the candidate cannot
# stage the union (class + hints printed) so the driver can fall
# through to the next one. On success $mdir/bs2m is the verified
# compiler for the merged source.
seed_merge_attempt() {
  local cand="$1" mdir="$2"
  log "── attempt: base seed = $cand ──"
  local spec=""
  case "$cand" in
    ours)    spec=":2" ;;
    theirs)  spec=":3" ;;
    current) : ;;
    *)       spec="$cand" ;;
  esac
  if [ -n "$spec" ]; then
    materialize_treeish_seed "$spec" "$SEED_LL" "$mdir/cand.$cand.lock" \
      || { err "[$cand] could not materialize this side's pinned seed"; return 1; }
  fi

  # Tolerate the other side's new ValueType/Expr/Stmt variants.
  log "[$cand] patching seed match traps"
  (cd "$BOOTSTRAP_DIR" && python3 scripts/patch-seed-traps.py) >"$mdir/traps.$cand.log" 2>&1 \
    || warn "[$cand] trap patch failed (see $mdir/traps.$cand.log) — continuing unpatched"

  log "[$cand] building stage1 from this seed"
  case $(llc_link_bin "$SEED_LL" "$mdir/stage1.o" "$mdir/stage1" "$mdir/stage1.$cand.log"; echo $?) in
    0) : ;;
    1) err "[$cand] llc rejected the seed IR — corrupt seed artifact; log: $mdir/stage1.$cand.log"
       return 1 ;;
    *) err "[$cand] stage1 link failed; log: $mdir/stage1.$cand.log"
       return 1 ;;
  esac

  # Unlike the window gate (which verifies HEAD), merge staging
  # compiles the WORKING TREE on purpose: mid-merge there is no merged
  # commit yet — the worktree IS the union being staged.
  log "[$cand] stage1 compiling the merged source"
  local rc=0 cls
  hermetic_compile_env "$mdir/stage1" compile "$SRC_DIR/main.av" >"$mdir/compile.$cand.log" 2>&1 || rc=$?
  if [ "$rc" -ne 0 ]; then
    cls=$(seed_merge_classify "$rc" "$mdir/compile.$cand.log")
    seed_merge_hint "$cand" "$cls" "$mdir/compile.$cand.log"
    return 1
  fi

  log "[$cand] linking bs2 from the stage1-compiled source"
  case $(llc_link_bin "$SRC_DIR/main.av.ll" "$mdir/bs2m.o" "$mdir/bs2m" "$mdir/bs2m.$cand.log"; echo $?) in
    0) : ;;
    1) err "[$cand] llc rejected stage1's emitted IR (mis-codegen); log: $mdir/bs2m.$cand.log"
       return 1 ;;
    *) err "[$cand] bs2 link failed; log: $mdir/bs2m.$cand.log"
       return 1 ;;
  esac

  log "[$cand] self-compile verify (bs2 compiles its own source)"
  rc=0
  hermetic_compile_env "$mdir/bs2m" compile "$SRC_DIR/main.av" >"$mdir/selfcompile.$cand.log" 2>&1 || rc=$?
  if [ "$rc" -ne 0 ]; then
    cls=$(seed_merge_classify "$rc" "$mdir/selfcompile.$cand.log")
    seed_merge_hint "$cand" "$cls" "$mdir/selfcompile.$cand.log"
    return 1
  fi
}

# Print how to stage the resolution once the merge is green — which
# file to add depends on which pin shape actually conflicted.
seed_merge_next_steps() {
  if [ -n "$(git -C "$REPO_DIR" ls-files -u -- bootstrap/seed/seed.lock)" ]; then
    log "next: re-run 'make test', publish the regenerated seed, and resolve the lock:"
    log "  bash scripts/diagnose.sh --seed-publish && git add bootstrap/seed/seed.lock"
  elif [ -n "$(git -C "$REPO_DIR" ls-files -u -- bootstrap/seed/seed.ll)" ]; then
    log "next: re-run 'make test', then stage the resolution:"
    log "  git add bootstrap/seed/seed.ll"
  else
    log "next: re-run 'make test'; on lock-era history publish + commit the lock bump"
    log "  (bash scripts/diagnose.sh --seed-publish)"
  fi
}

# One-command seed-merge staging: encode the staging dance that
# resolving a seed-pin merge conflict requires. The seed train makes
# this rare — it's for merges INTO the integration branch, and for
# histories that predate the gate.
mode_seed_merge() {
  local base=""
  while [ $# -gt 0 ]; do
    case "$1" in
      --base)   base="${2:?--base needs ours|theirs|<ref>}"; shift 2 ;;
      --base=*) base="${1#--base=}"; shift ;;
      *) die "--seed-merge: unknown argument '$1' (expected --base ours|theirs|<ref>)" ;;
    esac
  done

  local mdir="$BUILD_DIR/seed_merge"
  mkdir -p "$mdir"

  # The conflicted artifact is seed.lock on lock-era history, seed.ll
  # on pre-lock history; seed_merge_attempt handles either shape.
  local conflicted=""
  [ -n "$(git -C "$REPO_DIR" ls-files -u -- bootstrap/seed/seed.ll bootstrap/seed/seed.lock)" ] && conflicted=1

  local candidates=()
  if [ -n "$conflicted" ]; then
    case "$base" in
      ours|theirs) candidates=("$base") ;;
      "")          candidates=(ours theirs) ;;
      *)           candidates=("$base") ;;
    esac
    log "the seed pin is merge-conflicted — candidates: ${candidates[*]}"
  else
    case "$base" in
      ours|theirs) die "--base $base needs an in-progress merge conflict on the seed pin (seed.ll / seed.lock)" ;;
      "")          log "the seed pin is not conflicted — staging from the current seed"
                   candidates=(current)
                   # "current" stages whatever seed the working tree
                   # pins; on a fresh lock-era checkout that seed may
                   # not be materialized yet.
                   ensure_seed_materialized ;;
      *)           candidates=("$base") ;;
    esac
  fi

  [ -f "$SEED_LL" ] && cp "$SEED_LL" "$mdir/seed.orig.ll"
  ensure_runtime
  ensure_llvm_wrapper

  local cand
  for cand in "${candidates[@]}"; do
    seed_merge_attempt "$cand" "$mdir" || continue

    # Candidate survived the whole chain — commit to it. main.av.ll is
    # now bs2's OWN output (generation 2); regenerate the seed from it
    # with provenance, rebuild from the new seed, verify fixed point.
    ok "[$cand] staging chain green — regenerating the seed from generation-2 IR"
    cp "$mdir/bs2m" "$BS2"
    mode_update_seed
    rm -f "$BS3"
    ensure_seed force
    ensure_bs2 force
    if ! mode_check_fixedpoint; then
      err "[$cand] fixed point failed after seed regeneration — restoring the original seed"
      [ -f "$mdir/seed.orig.ll" ] && cp "$mdir/seed.orig.ll" "$SEED_LL"
      return 1
    fi

    ok "seed merge staged: base=$cand, seed regenerated, fixed point holds"
    seed_merge_next_steps
    return 0
  done

  err "NO candidate base seed could stage the merged source (tried: ${candidates[*]})"
  err "Per-candidate classes + hints are above; logs live in $mdir/."
  err "Last resort: IR-level patching of the intermediate main.av.ll —"
  err "see docs/SEED_MERGES.md 'when NEITHER seed can compile the union'."
  if [ -f "$mdir/seed.orig.ll" ]; then
    cp "$mdir/seed.orig.ll" "$SEED_LL"
    log "restored the original working-tree seed.ll"
  fi
  return 1
}

# Function-level testing hook (6cks): `AVRA_DIAGNOSE_NO_MAIN=1 source
# scripts/diagnose.sh` loads every definition without dispatching, so
# spec tests can exercise individual helpers (source_newer_than, …)
# against sandboxed fixtures. A normal execution leaves the var unset
# and dispatches as always.
[ -n "${AVRA_DIAGNOSE_NO_MAIN:-}" ] && return 0

main "$@"
