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

LLVM_PREFIX="${LLVM_PREFIX:-/opt/homebrew/opt/llvm}"
LLVM_CONFIG="$LLVM_PREFIX/bin/llvm-config"
# Use LLVM 20's llc for code generation. LLVM 21's -O2 miscompiles
# certain functions on ARM64 (uses wrong register for parameters).
# The runtime still links against the default LLVM's libLLVM.
LLC_PREFIX="${LLC_PREFIX:-/opt/homebrew/Cellar/llvm/20.1.5}"
LLC="$LLC_PREFIX/bin/llc"
LLVM_WRAPPER_O="$BUILD_DIR/llvm_wrapper.o"

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

# Check if any .av source file is newer than a target binary.
# Returns 0 (true) if rebuild is needed, 1 (false) if up to date.
source_newer_than() {
  local target="$1"
  [ ! -x "$target" ] && return 0
  # Find any .av file newer than target — exits as soon as one is found.
  [ -n "$(find "$CLI_SRC_DIR" "$LIB_SRC_DIR" -name '*.av' -newer "$target" -print -quit 2>/dev/null)" ]
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

  NOTE: 'make build' now AUTO-CYCLES the seed when self-compile fails.
  You rarely need to run 'make update-seed' manually anymore.

ENVIRONMENT
  LLVM_PREFIX  Override the LLVM install prefix.
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
  if [ ! -f "$RUNTIME_ASAN_O" ] || [ "$RUNTIME_C" -nt "$RUNTIME_ASAN_O" ]; then
    mkdir -p "$BUILD_DIR"
    log "compiling runtime (ASan) → $RUNTIME_ASAN_O"
    cc -c -O0 -g -fsanitize=address -o "$RUNTIME_ASAN_O" "$RUNTIME_C" \
      || die "runtime ASan build failed"
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

# Build the seed binary from seed/seed.ll (no Rust compiler needed).
# The seed IR is checked into the repo and is the bootstrap's lifeline.
ensure_seed() {
  ensure_llvm_wrapper
  ensure_runtime
  if [ "${1:-}" = "force" ] || [ ! -x "$SEED_BIN" ] || [ "$SEED_LL" -nt "$SEED_BIN" ]; then
    [ -f "$SEED_LL" ] || die "seed IR not found at $SEED_LL — repo is corrupt"
    log "building seed compiler from seed/seed.ll"
    mkdir -p "$BUILD_DIR"
    "$LLC" -O2 -filetype=obj "$SEED_LL" -o "$BUILD_DIR/seed.o" \
      || die "seed llc failed"
    cc -o "${SEED_BIN}.tmp" "$BUILD_DIR/seed.o" "$RUNTIME_O" "$LLVM_WRAPPER_O" \
      -Wl,-stack_size,0x2000000 \
      -L"$LLVM_PREFIX/lib" -lLLVM -lc++ 2>"$BUILD_DIR/seed.link.log" \
      || { rm -f "${SEED_BIN}.tmp"; cat "$BUILD_DIR/seed.link.log" >&2; die "seed link failed"; }
    mv "${SEED_BIN}.tmp" "$SEED_BIN"
  fi
}

# Link an LLVM IR file into an executable.
# rqwh: shared-inputs fingerprint for the link cache. Hashing
# bs2/runtime.o/llvm_wrapper.o (~5MB each) per fixture would cost
# ~30ms × 4 = 120ms × 30 fixtures = 3.6s of overhead on every run.
# Cache the combined hash, invalidate via mtime: if the cache file is
# newer than every input, reuse; otherwise recompute. Stable across
# sequential link_ll calls in the same test session.
#
# 0qmm: link-binary cache lives inside the project's build/cache/
# (under a `link/` sub-namespace alongside `meta/`), so every cached
# artifact lives in one tree — no parallel ~/.cache/avra-* directories.
# `bs2 cache clean` and `make clean --all` reach this slot uniformly.
LINK_CACHE_DIR="$BUILD_DIR/cache/link"
LINK_SHARED_FP_FILE="$LINK_CACHE_DIR/.shared-fp"

link_shared_fp() {
  # fxwn: include AVRA_LIB_OBJS in the fingerprint so the link cache
  # invalidates when the @std .o-path set changes. Producer .o paths
  # are content-addressed (sha256(meta source)/realobj.o), so the
  # string proxies for content changes too — when bodies change, paths
  # change. Bypasses the mtime memo when LIB_OBJS is set since the
  # sidecar doesn't capture it.
  local libobjs_h=""
  if [ -n "${AVRA_LIB_OBJS:-}" ]; then
    libobjs_h=$(printf '%s' "$AVRA_LIB_OBJS" | shasum -a 256 | cut -d' ' -f1)
  fi
  if [ -z "$libobjs_h" ] \
     && [ -f "$LINK_SHARED_FP_FILE" ] \
     && [ "$LINK_SHARED_FP_FILE" -nt "$BS2" ] \
     && [ "$LINK_SHARED_FP_FILE" -nt "$RUNTIME_O" ] \
     && [ "$LINK_SHARED_FP_FILE" -nt "$LLVM_WRAPPER_O" ]; then
    cat "$LINK_SHARED_FP_FILE"
    return
  fi
  mkdir -p "$LINK_CACHE_DIR"
  local bs2_h runtime_h wrapper_h composed
  bs2_h=$(shasum -a 256 "$BS2" | cut -d' ' -f1)
  runtime_h=$(shasum -a 256 "$RUNTIME_O" | cut -d' ' -f1)
  wrapper_h=$(shasum -a 256 "$LLVM_WRAPPER_O" | cut -d' ' -f1)
  composed=$(printf '%s:%s:%s:%s' "$bs2_h" "$runtime_h" "$wrapper_h" "$libobjs_h" \
    | shasum -a 256 | cut -d' ' -f1)
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
    ll_h=$(shasum -a 256 "$ll" | cut -d' ' -f1)
    fp=$(printf '%s:%s' "$shared_fp" "$ll_h" | shasum -a 256 | cut -d' ' -f1 | head -c 16)
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
  "$LLC" -O2 -filetype=obj "$obj_ll" -o "${out}.o" \
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
  # Atomic link: cc writes to a .tmp sibling, then rename. If cc is
  # killed mid-write (jetsam under memory pressure has done this 3x
  # this iteration alone), the previous $out remains intact instead
  # of being corrupted into a 2.2MB Mach-O that SIGKILLs on dyld load.
  cc -o "${out}.tmp" "${out}.o" "$RUNTIME_O" "$LLVM_WRAPPER_O" $lib_objs \
    -Wl,-stack_size,0x2000000 \
    -L"$LLVM_PREFIX/lib" -lLLVM -lc++ $extra_libs 2>"$logfile" \
    || { rm -f "${out}.tmp"; cat "$logfile" >&2; die "link failed for $out"; }
  mv "${out}.tmp" "$out"

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
    if "$SEED_BIN" compile "$SRC_DIR/main.av" >"$BUILD_DIR/bs2.codegen.log" 2>&1; then
      log "linking $BS2"
      link_ll "$SRC_DIR/main.av.ll" "$BS2" "$BUILD_DIR/bs2.link.log"
      ok "built $BS2"
    else
      # Seed crashed. Check if it's an LLVM -O2 miscompilation by
      # rebuilding the seed at -O0 and retrying.
      warn "seed crashed at -O2 — testing for LLVM optimization bug"
      "$LLC" -O0 -filetype=obj "$SEED_LL" -o "$BUILD_DIR/seed_o0.o" \
        || die "seed llc -O0 failed"
      cc -o "$BUILD_DIR/seed_o0.tmp" "$BUILD_DIR/seed_o0.o" "$RUNTIME_O" "$LLVM_WRAPPER_O" \
        -Wl,-stack_size,0x2000000 \
        -L"$LLVM_PREFIX/lib" -lLLVM -lc++ 2>/dev/null \
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
  "$LLC" -O0 -filetype=obj "$ll" -o "${out}.o" \
    || die "llc -O0 failed for $ll"
  # Atomic link via staging path (see link_ll for rationale).
  cc -g -o "${out}.tmp" "${out}.o" "$RUNTIME_O" "$LLVM_WRAPPER_O" \
    -Wl,-stack_size,0x2000000 \
    -L"$LLVM_PREFIX/lib" -lLLVM -lc++ 2>"$logfile" \
    || { rm -f "${out}.tmp"; cat "$logfile" >&2; die "link failed for $out"; }
  mv "${out}.tmp" "$out"
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
       -L"$LLVM_PREFIX/lib" -lLLVM -lc++ 2>"$BUILD_DIR/bs2_asan.link.log" \
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
  if "$BS2" compile "$SRC_DIR/main.av" >"$BUILD_DIR/bs2_selfcheck.log" 2>&1; then
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
  "$LLC" -O0 -filetype=obj "$SRC_DIR/main.av.ll" -o "$BUILD_DIR/bs2_o0.o" 2>/dev/null
  if cc -o "$BUILD_DIR/bs2_o0" "$BUILD_DIR/bs2_o0.o" "$RUNTIME_O" "$LLVM_WRAPPER_O" \
       -Wl,-stack_size,0x2000000 \
       -L"$LLVM_PREFIX/lib" -lLLVM -lc++ 2>/dev/null; then
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
    { shasum -a 256 "$BS2" "$BS3" 2>/dev/null
      find "$CLI_SRC_DIR" "$LIB_SRC_DIR" -name '*.av' -type f -exec shasum -a 256 {} +
    } | awk '{print $1}' | sort | shasum -a 256 | awk '{print $1}'
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
          { shasum -a 256 "$BS2" "$BS3" 2>/dev/null
            find "$CLI_SRC_DIR" "$LIB_SRC_DIR" -name '*.av' -type f -exec shasum -a 256 {} +
          } | awk '{print $1}' | sort | shasum -a 256 | awk '{print $1}'
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
  if ! "$BS2" compile "$fg" >"$BUILD_DIR/last_run.log" 2>&1; then
    cat "$BUILD_DIR/last_run.log" >&2
    die "bs2 codegen failed"
  fi
  link_ll "$ll" "$bin" "$BUILD_DIR/last_link.log"
  "$bin"
}

mode_run() { run_fg "$1"; }

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
    --check)              mode_check "$@" ;;
    --ll)                 mode_ll "$@" ;;
    --diff)               mode_diff "$@" ;;
    --diff-fn)            mode_diff_fn "$@" ;;
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
  src_hash=$(find "$SRC_DIR" -name '*.av' -exec shasum -a 256 {} + | shasum -a 256 | cut -d' ' -f1)

  {
    printf '; seed built from commit %s at %s\n' "$commit" "$timestamp"
    printf '; source hash: %s\n' "$src_hash"
    cat "$SEED_LL"
  } > "${SEED_LL}.tmp" && mv "${SEED_LL}.tmp" "$SEED_LL"

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
  src_hash=$(find "$SRC_DIR" -name '*.av' -exec shasum -a 256 {} + | shasum -a 256 | cut -d' ' -f1)

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

main "$@"
