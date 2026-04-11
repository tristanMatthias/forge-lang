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
FORGE_DIR="$REPO_DIR/forge"
BUILD_DIR="$BOOTSTRAP_DIR/build"
REGRESS_DIR="$BOOTSTRAP_DIR/regress"
SEED_LL="$BOOTSTRAP_DIR/seed/seed.ll"
SEED_BIN="$BUILD_DIR/seed"
RUNTIME_C="$BOOTSTRAP_DIR/runtime.c"
RUNTIME_O="$BUILD_DIR/runtime.o"
RUNTIME_ASAN_O="$BUILD_DIR/runtime_asan.o"
BS2="$BUILD_DIR/bs2"
BS2_ASAN="$BUILD_DIR/bs2_asan"
BS3="$BUILD_DIR/bs3"

LLVM_PREFIX="${LLVM_PREFIX:-/opt/homebrew/opt/llvm}"
LLVM_CONFIG="$LLVM_PREFIX/bin/llvm-config"
LLC="$LLVM_PREFIX/bin/llc"
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

print_help() {
  cat <<'EOF'
bootstrap/scripts/diagnose.sh — single entry point for bootstrap dev tooling

USAGE
  diagnose.sh <mode> [args]

BUILD MODES
  --build              Rebuild stage1 (host → stage1 binary) + run all stage1 tests.
                       Same as scripts/test.sh but goes through this script.
  --build-runtime      Compile forge/stdlib/runtime.c → build/runtime.o.
  --build-bs2          Compile bootstrap/src/main.fg with stage1 → build/bs2.
  --build-bs2-asan     Same as --build-bs2 but link with -fsanitize=address.
  --build-bs3          Compile bootstrap/src/main.fg with bs2 → build/bs3.
                       (The fixed-point self-host check.)
  --check-fixedpoint   Verify bs2 and bs3 emit byte-identical IR for
                       bootstrap/src/main.fg. The single most important
                       self-hosting invariant — if this fails, a recent
                       commit broke the bootstrap chain. Wired into the
                       pre-commit hook when bootstrap/src/ is touched.

RUN MODES
  --run    <file.fg>   Compile <file.fg> with bs2, link, run. Prints stdout.
  --run-stage1 <file.fg>
                       Same but with stage1 (the host-built bootstrapc).
  --check  <file.fg>   Run bs2's parse+resolve only — no codegen, no link.
  --ll     <file.fg>   Emit LLVM IR via bs2 to stdout (don't link or run).
  --ll-stage1 <file.fg>
                       Same with stage1.

DIFF & ANALYSIS
  --diff   <file.fg>   Compile <file.fg> with both stage1 and bs2, diff
                       the resulting .ll files. Highlights divergence.
  --diff-fn <file.fg> <fn>
                       Same as --diff but only shows the body of one
                       function.
  --score  [file.ll]   Score an emitted IR file. Counts ret-undef, orphan
                       blocks, missing terminators, wide-store-into-
                       narrow-malloc bugs, and similar quality smells.
                       Lower is better. Wide-store hits are fatal (the
                       heap-corruption bug class) and exit non-zero.
                       Defaults to the most recently emitted .ll.
  --rank   <file.fg>   Rank functions in <file.fg>'s emitted IR by line
                       count — useful for spotting bloat.

REGRESSION SUITE
  --regress            Compile + run every regress/*.fg with bs2 and
                       compare stdout against the matching .out file.
                       Exit non-zero on any mismatch. Run before commit.
  --regress-add <name> <file.fg>
                       Capture <file.fg> as a regression test under
                       regress/<name>.fg, with bs2's current stdout
                       saved as regress/<name>.out.
  --regress-list       List all captured regression tests.

HEAP / MEMORY DEBUGGING
  --asan   <file.fg>   Run bs2_asan on <file.fg>. AddressSanitizer
                       reports the exact alloc/use-after-free site.
                       Builds bs2_asan if missing.
  --malloc-trace <file.fg>
                       Run bs2 under MallocStackLogging + DYLD malloc
                       guard. Crash dumps include the alloc backtrace.
  --bisect-lines <file.fg>
                       Binary-search the line count of <file.fg> to find
                       the smallest prefix that still makes bs2 crash.
                       Useful for isolating heap-corruption triggers.

ENVIRONMENT
  LLVM_PREFIX  Override the LLVM 19 install prefix.
               Default: /opt/homebrew/opt/llvm@19

EXAMPLES
  diagnose.sh --build               # rebuild stage1 from rust + run tests
  diagnose.sh --build-bs2           # build the self-compiled bs2
  diagnose.sh --run /tmp/hello.fg   # run a .fg file with bs2
  diagnose.sh --diff /tmp/hello.fg  # see how stage1 and bs2 diverge
  diagnose.sh --asan /tmp/big.fg    # find heap corruption with ASan
  diagnose.sh --regress             # run regression suite
  diagnose.sh --regress-add hello /tmp/hello.fg
EOF
}

# ─────────────────────────────────────────────────────────────────────
# Build helpers
# ─────────────────────────────────────────────────────────────────────

ensure_runtime() {
  if [ ! -f "$RUNTIME_O" ] || [ "$RUNTIME_C" -nt "$RUNTIME_O" ]; then
    mkdir -p "$BUILD_DIR"
    log "compiling runtime → $RUNTIME_O"
    cc -c -O0 -g -o "$RUNTIME_O" "$RUNTIME_C" || die "runtime build failed"
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
  if [ ! -f "$LLVM_WRAPPER_O" ] || [ "$wrapper_src" -nt "$LLVM_WRAPPER_O" ]; then
    log "compiling LLVM wrapper → $LLVM_WRAPPER_O"
    mkdir -p "$BUILD_DIR"
    cc -c -O2 -I"$LLVM_PREFIX/include" -o "$LLVM_WRAPPER_O" "$wrapper_src" \
      || die "LLVM wrapper build failed"
  fi
}

# Build the seed binary from seed/seed.ll (no Rust compiler needed).
# The seed IR is checked into the repo and is the bootstrap's lifeline.
ensure_seed() {
  ensure_llvm_wrapper
  ensure_runtime
  if [ ! -x "$SEED_BIN" ] || [ "$SEED_LL" -nt "$SEED_BIN" ]; then
    [ -f "$SEED_LL" ] || die "seed IR not found at $SEED_LL — repo is corrupt"
    log "building seed compiler from seed/seed.ll"
    mkdir -p "$BUILD_DIR"
    "$LLC" -O2 -filetype=obj "$SEED_LL" -o "$BUILD_DIR/seed.o" \
      || die "seed llc failed"
    cc -o "$SEED_BIN" "$BUILD_DIR/seed.o" "$RUNTIME_O" "$LLVM_WRAPPER_O" \
      -L"$LLVM_PREFIX/lib" -lLLVM -lc++ 2>"$BUILD_DIR/seed.link.log" \
      || { cat "$BUILD_DIR/seed.link.log" >&2; die "seed link failed"; }
  fi
}

# Link an LLVM IR file into an executable.
link_ll() {
  local ll="$1" out="$2" logfile="$3"
  "$LLC" -O2 -filetype=obj "$ll" -o "${out}.o" \
    || die "llc failed for $ll"
  cc -o "$out" "${out}.o" "$RUNTIME_O" "$LLVM_WRAPPER_O" \
    -L"$LLVM_PREFIX/lib" -lLLVM -lc++ 2>"$logfile" \
    || { cat "$logfile" >&2; die "link failed for $out"; }
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
  ensure_seed
  if [ ! -x "$BS2" ] \
     || [ "$BOOTSTRAP_DIR/src/main.fg" -nt "$BS2" ] \
     || [ "$SEED_LL" -nt "$BS2" ]; then
    log "compiling bootstrap/src/main.fg with seed compiler"
    "$SEED_BIN" compile "$BOOTSTRAP_DIR/src/main.fg" >"$BUILD_DIR/bs2.codegen.log" 2>&1 \
      || { cat "$BUILD_DIR/bs2.codegen.log" >&2; die "bs2 codegen failed"; }
    log "linking $BS2"
    link_ll "$BOOTSTRAP_DIR/src/main.fg.ll" "$BS2" "$BUILD_DIR/bs2.link.log"
    ok "built $BS2"
  fi
}

ensure_bs2_asan() {
  ensure_seed
  ensure_runtime_asan
  if [ ! -x "$BS2_ASAN" ] || [ "$BS2" -nt "$BS2_ASAN" ]; then
    log "compiling bootstrap/src/main.fg with seed (for ASan)"
    "$SEED_BIN" compile "$BOOTSTRAP_DIR/src/main.fg" >"$BUILD_DIR/bs2_asan.codegen.log" 2>&1 \
      || { cat "$BUILD_DIR/bs2_asan.codegen.log" >&2; die "bs2_asan codegen failed"; }
    log "linking $BS2_ASAN with -fsanitize=address"
    cc -fsanitize=address -g -o "$BS2_ASAN" \
       "$BOOTSTRAP_DIR/src/main.fg.ll" "$RUNTIME_ASAN_O" "$LLVM_WRAPPER_O" \
       -L"$LLVM_PREFIX/lib" -lLLVM -lc++ 2>"$BUILD_DIR/bs2_asan.link.log" \
      || { cat "$BUILD_DIR/bs2_asan.link.log" >&2; die "bs2_asan link failed"; }
    ok "built $BS2_ASAN"
  fi
}

ensure_bs3() {
  ensure_bs2
  log "compiling bootstrap/src/main.fg with bs2 → $BS3"
  if ! "$BS2" compile "$BOOTSTRAP_DIR/src/main.fg" >"$BUILD_DIR/bs3.codegen.log" 2>&1; then
    cat "$BUILD_DIR/bs3.codegen.log" >&2
    die "bs3 codegen failed (bs2 cannot self-compile)"
  fi
  link_ll "$BOOTSTRAP_DIR/src/main.fg.ll" "$BS3" "$BUILD_DIR/bs3.link.log"
  ok "built $BS3"
}

# ─────────────────────────────────────────────────────────────────────
# Modes
# ─────────────────────────────────────────────────────────────────────

mode_build() {
  ensure_bs2
}

mode_build_runtime() { ensure_runtime; ok "$RUNTIME_O"; }
mode_build_bs2() {
  ensure_bs2
  # ALWAYS verify bs2 can compile itself. This catches bootstrap
  # chicken-and-egg bugs at build time instead of hours later when
  # you try to update the seed. If this fails, your changes broke
  # the self-hosting chain — fix before proceeding.
  log "verifying bs2 can self-compile (bootstrap safety check)"
  if ! "$BS2" compile "$BOOTSTRAP_DIR/src/main.fg" >"$BUILD_DIR/bs2_selfcheck.log" 2>&1; then
    err "bs2 CANNOT compile itself — bootstrap chain is broken!"
    err "This means the seed binary compiled your code, but the"
    err "resulting bs2 cannot parse/compile the same source."
    err ""
    err "Common causes:"
    err "  - New syntax that the seed-compiled parser doesn't handle"
    err "  - New enum variant that shifts tags in the seed-compiled binary"
    err "  - Two-phase bootstrap needed (add types first, update seed, then use them)"
    err ""
    err "Log: $BUILD_DIR/bs2_selfcheck.log"
    head -30 "$BUILD_DIR/bs2_selfcheck.log" >&2
    die "fix the self-compile error before proceeding"
  fi
  ok "$BS2"
}
mode_build_bs2_asan() { ensure_bs2_asan; ok "$BS2_ASAN"; }
mode_build_bs3()      { ensure_bs3;      ok "$BS3"; }

# Verify bootstrap reaches its self-host fixed point: bs2 and bs3 must
# emit byte-identical IR for the same input (bootstrap/src/main.fg).
# If this fails, self-hosting is broken — the bug is somewhere between
# bs2 and bs3 (one generation diverged from the previous).
mode_check_fixedpoint() {
  ensure_bs2
  ensure_bs3
  log "compiling bootstrap/src/main.fg with bs2"
  "$BS2" compile "$BOOTSTRAP_DIR/src/main.fg" >/dev/null 2>&1 \
    || die "bs2 failed to compile bootstrap source"
  cp "$BOOTSTRAP_DIR/src/main.fg.ll" "$BUILD_DIR/fp_bs2.ll"
  log "compiling bootstrap/src/main.fg with bs3"
  "$BS3" compile "$BOOTSTRAP_DIR/src/main.fg" >/dev/null 2>&1 \
    || die "bs3 failed to compile bootstrap source"
  cp "$BOOTSTRAP_DIR/src/main.fg.ll" "$BUILD_DIR/fp_bs3.ll"
  if diff -q "$BUILD_DIR/fp_bs2.ll" "$BUILD_DIR/fp_bs3.ll" >/dev/null; then
    local lines; lines=$(wc -l <"$BUILD_DIR/fp_bs2.ll" | tr -d ' ')
    ok "fixed point holds — bs2 and bs3 emit byte-identical $lines-line IR"
  else
    err "FIXED POINT BROKEN — bs2 and bs3 emit different IR for bootstrap/src/main.fg"
    err "diff: $(diff "$BUILD_DIR/fp_bs2.ll" "$BUILD_DIR/fp_bs3.ll" | wc -l | tr -d ' ') lines"
    err "  bs2 IR: $BUILD_DIR/fp_bs2.ll"
    err "  bs3 IR: $BUILD_DIR/fp_bs3.ll"
    return 1
  fi
}

# Compile + link + run a .fg with bs2 (or stage1).
run_fg() {
  local fg="$1"
  [ -f "$fg" ] || die "no such file: $fg"
  ensure_bs2
  local ll bin
  ll="$fg.ll"
  bin="${fg%.fg}.bin"
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
  [ -n "$fn" ] || die "--diff-fn requires <file.fg> <fn-name>"
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
    ll=$(ls -t "$BUILD_DIR"/*.ll "$BOOTSTRAP_DIR"/src/*.ll 2>/dev/null | head -1)
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
    *.fg)
      ensure_bs2
      "$BS2" compile "$arg" >/dev/null 2>&1 || die "bs2 codegen failed"
      ll="$arg.ll"
      ;;
    *) die "--rank: pass a .fg or .ll file" ;;
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
# Regression suite
# ─────────────────────────────────────────────────────────────────────

mode_regress() {
  ensure_bs2
  shopt -s nullglob

  # Build the test list
  local test_specs=()
  for fg in "$BOOTSTRAP_DIR"/src/features/*/tests/*.fg; do
    test_specs+=("$fg")
  done
  for fg in "$BOOTSTRAP_DIR"/src/features/*/example.fg; do
    [ -f "$(dirname "$fg")/expected.out" ] && test_specs+=("$fg")
  done
  for fg in "$BOOTSTRAP_DIR"/tests/*.fg; do
    test_specs+=("$fg")
  done
  for fg in "$REGRESS_DIR"/*.fg; do
    test_specs+=("$fg")
  done
  for d in "$REGRESS_DIR"/*/; do
    if [ -f "${d}main.fg" ]; then
      test_specs+=("${d}main.fg")
    fi
  done

  # Phase 1: Compile all tests with bs2 (sequential — fast, <1ms each)
  local names=() expecteds=() fgs=() bins=() slugs=()
  for fg in "${test_specs[@]}"; do
    local name expected slug
    if [[ "$fg" == */main.fg ]]; then
      local expected_dir; expected_dir=$(dirname "$fg")
      name=$(basename "$expected_dir")
      expected="$expected_dir/expected.out"
    elif [[ "$fg" == */example.fg ]]; then
      local feat_dir; feat_dir=$(dirname "$fg")
      name=$(basename "$feat_dir")
      expected="$feat_dir/expected.out"
    else
      name=$(basename "$fg" .fg)
      expected="$(dirname "$fg")/$name.out"
    fi
    [ -f "$expected" ] || continue
    slug=$(echo "$fg" | sed 's|[/.]|_|g')
    names+=("$name")
    expecteds+=("$expected")
    fgs+=("$fg")
    bins+=("$BUILD_DIR/regress_${slug}.bin")
    slugs+=("$slug")
  done

  # Compile all .fg → .ll (sequential — bs2 is fast)
  local compile_ok=()
  for i in "${!fgs[@]}"; do
    if "$BS2" compile "${fgs[$i]}" >"$BUILD_DIR/regress_${slugs[$i]}.codegen.log" 2>&1; then
      compile_ok+=("1")
    else
      compile_ok+=("0")
    fi
  done

  # Phase 2: Link + run in parallel (this is the slow part)
  local results_dir="$BUILD_DIR/_regress_results"
  rm -rf "$results_dir"
  mkdir -p "$results_dir"

  link_and_run() {
    local fg="$1" bin="$2" expected="$3" slug="$4" compiled="$5" results_dir="$6"
    if [ "$compiled" != "1" ]; then
      echo "FAIL codegen failed" > "$results_dir/$slug"; return
    fi
    if ! link_ll "$fg.ll" "$bin" "$BUILD_DIR/regress_${slug}.link.log" 2>/dev/null; then
      echo "FAIL link failed" > "$results_dir/$slug"; return
    fi
    local actual
    actual=$("$bin" 2>&1) || true
    if [ "$actual" = "$(cat "$expected")" ]; then
      echo "PASS" > "$results_dir/$slug"
    else
      echo "FAIL output mismatch" > "$results_dir/$slug"
    fi
  }
  export -f link_and_run link_ll
  export BUILD_DIR LLC RUNTIME_O LLVM_WRAPPER_O LLVM_PREFIX

  local njobs
  njobs=$(sysctl -n hw.logicalcpu 2>/dev/null || nproc 2>/dev/null || echo 4)

  # Link + run ALL tests in parallel (let OS handle scheduling)
  for i in "${!fgs[@]}"; do
    link_and_run "${fgs[$i]}" "${bins[$i]}" "${expecteds[$i]}" "${slugs[$i]}" "${compile_ok[$i]}" "${results_dir}" &
  done
  wait

  # Phase 3: Collect results
  local pass=0 fail=0 idx=0
  for i in "${!slugs[@]}"; do
    local result_file="$results_dir/${slugs[$i]}"
    if [ ! -f "$result_file" ]; then
      err "${names[$i]}: no result"
      fail=$((fail+1))
      continue
    fi
    local result
    result=$(cat "$result_file")
    case "$result" in
      PASS) ok "${names[$i]}"; pass=$((pass+1)) ;;
      FAIL*) err "${names[$i]}: ${result#FAIL }"; fail=$((fail+1)) ;;
    esac
  done
  rm -rf "$results_dir"
  echo
  printf "regress: ${C_GREEN}%d passed${C_RESET}, ${C_RED}%d failed${C_RESET}\n" "$pass" "$fail"
  [ "$fail" -eq 0 ]
}

mode_regress_add() {
  local name="$1" fg="$2" dest_dir="${3:-$BOOTSTRAP_DIR/tests}"
  [ -n "$name" ] || die "--regress-add requires <name> <file.fg> [dest_dir]"
  [ -f "$fg" ] || die "no such file: $fg"
  ensure_bs2
  mkdir -p "$dest_dir"
  local stage="$BUILD_DIR/_capture_$name.fg"
  cp "$fg" "$stage"
  log "compiling with bs2 to capture expected output"
  if ! "$BS2" compile "$stage" >/dev/null 2>&1; then
    rm -f "$stage" "$stage.ll"
    die "bs2 codegen failed — fix the codegen first"
  fi
  local bin="$BUILD_DIR/regress_$name.bin"
  if ! link_ll "$stage.ll" "$bin" "$BUILD_DIR/_capture.link.log" 2>/dev/null; then
    rm -f "$stage" "$stage.ll"
    die "link failed"
  fi
  local out
  out=$("$bin" 2>&1) || true
  cp "$fg" "$dest_dir/$name.fg"
  printf '%s\n' "$out" >"$dest_dir/$name.out"
  rm -f "$stage" "$stage.ll" "$bin"
  ok "captured: $dest_dir/$name.fg + $dest_dir/$name.out"
  echo "expected output:"
  sed 's/^/    /' "$dest_dir/$name.out"
}

mode_regress_list() {
  shopt -s nullglob
  echo "Feature tests:"
  for fg in "$BOOTSTRAP_DIR"/src/features/*/tests/*.fg; do
    printf "  %s/%s\n" "$(basename "$(dirname "$(dirname "$fg")")")" "$(basename "$fg" .fg)"
  done
  echo "Core tests:"
  for fg in "$BOOTSTRAP_DIR"/tests/*.fg; do
    printf "  %s\n" "$(basename "$fg" .fg)"
  done
  echo "Legacy fixtures:"
  for d in "$REGRESS_DIR"/*/; do
    [ -f "${d}main.fg" ] && printf "  %s\n" "$(basename "$d")"
  done
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
  local lo=1 hi=$total mid tmp="$BUILD_DIR/_bisect.fg"
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
  cp "$tmp" "$BUILD_DIR/bisect_${$}.fg"
  log "saved minimal crash repro: $BUILD_DIR/bisect_${$}.fg"
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
    --regress)            mode_regress "$@" ;;
    --regress-add)        mode_regress_add "$@" ;;
    --regress-list)       mode_regress_list "$@" ;;
    --asan)               mode_asan "$@" ;;
    --malloc-trace)       mode_malloc_trace "$@" ;;
    --bisect-lines)       mode_bisect_lines "$@" ;;
    *) err "unknown mode: $mode"; print_help; exit 1 ;;
  esac
}

main "$@"
