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
HOST_COMPILER="$FORGE_DIR/target/release/forgec"
RUNTIME_C="$FORGE_DIR/stdlib/runtime.c"
RUNTIME_O="$BUILD_DIR/runtime.o"
RUNTIME_ASAN_O="$BUILD_DIR/runtime_asan.o"
STAGE1="$BUILD_DIR/bootstrapc"
BS2="$BUILD_DIR/bs2"
BS2_ASAN="$BUILD_DIR/bs2_asan"
BS3="$BUILD_DIR/bs3"

LLVM_PREFIX="${LLVM_PREFIX:-/opt/homebrew/opt/llvm@19}"
LLVM_LIBS_LDFLAGS=$("$LLVM_PREFIX/bin/llvm-config" --ldflags --libs --system-libs core 2>/dev/null || true)
STDLLVM_A="$FORGE_DIR/packages/std-llvm/target/release/libforge_llvm.a"
STDPROC_A="$FORGE_DIR/packages/std-process/target/release/libforge_process.a"

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
                       blocks, missing terminators, and similar quality
                       smells. Lower is better. Defaults to the most
                       recently emitted .ll under build/.
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

ensure_host_compiler() {
  if [ ! -x "$HOST_COMPILER" ]; then
    log "host compiler missing — building forgec"
    (cd "$FORGE_DIR" && LLVM_SYS_191_PREFIX="$LLVM_PREFIX" cargo build --release) >&2 \
      || die "failed to build host compiler"
  fi
}

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

ensure_stdlibs() {
  if [ ! -f "$STDLLVM_A" ]; then
    log "building libforge_llvm"
    (cd "$FORGE_DIR/packages/std-llvm" && LLVM_SYS_191_PREFIX="$LLVM_PREFIX" cargo build --release) >&2 \
      || die "libforge_llvm build failed"
  fi
  if [ ! -f "$STDPROC_A" ]; then
    log "building libforge_process"
    (cd "$FORGE_DIR/packages/std-process" && cargo build --release) >&2 \
      || die "libforge_process build failed"
  fi
}

ensure_stage1() {
  ensure_host_compiler
  ensure_stdlibs
  if [ ! -x "$STAGE1" ] || [ "$BOOTSTRAP_DIR/src/main.fg" -nt "$STAGE1" ]; then
    log "building stage1 (bootstrapc) via host compiler"
    mkdir -p "$BUILD_DIR"
    if ! "$HOST_COMPILER" build "$BOOTSTRAP_DIR" --dev -o "$STAGE1" >"$BUILD_DIR/stage1.build.log" 2>&1; then
      cat "$BUILD_DIR/stage1.build.log" >&2
      die "stage1 build failed (see $BUILD_DIR/stage1.build.log)"
    fi
  fi
}

# Compile <fg> with stage1, producing <fg>.ll. Echoes the .ll path.
emit_ll_stage1() {
  local fg="$1"
  ensure_stage1
  "$STAGE1" compile "$fg" >/dev/null || die "stage1 codegen failed for $fg"
  echo "$fg.ll"
}

# Compile <fg> with bs2, producing <fg>.ll. Echoes the .ll path.
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
  ensure_stage1
  ensure_runtime
  if [ ! -x "$BS2" ] \
     || [ "$BOOTSTRAP_DIR/src/main.fg" -nt "$BS2" ] \
     || [ "$BOOTSTRAP_DIR/src/codegen.fg" -nt "$BS2" ] \
     || [ "$BOOTSTRAP_DIR/src/parser.fg" -nt "$BS2" ]; then
    log "compiling bootstrap/src/main.fg with stage1"
    "$STAGE1" compile "$BOOTSTRAP_DIR/src/main.fg" >"$BUILD_DIR/bs2.codegen.log" 2>&1 \
      || { cat "$BUILD_DIR/bs2.codegen.log" >&2; die "bs2 codegen failed"; }
    log "linking $BS2"
    cc -o "$BS2" "$BOOTSTRAP_DIR/src/main.fg.ll" "$RUNTIME_O" \
       "$STDLLVM_A" "$STDPROC_A" $LLVM_LIBS_LDFLAGS 2>"$BUILD_DIR/bs2.link.log" \
      || { cat "$BUILD_DIR/bs2.link.log" >&2; die "bs2 link failed"; }
    ok "built $BS2"
  fi
}

ensure_bs2_asan() {
  ensure_stage1
  ensure_runtime_asan
  if [ ! -x "$BS2_ASAN" ] || [ "$BS2" -nt "$BS2_ASAN" ]; then
    log "compiling bootstrap/src/main.fg with stage1 (for ASan)"
    "$STAGE1" compile "$BOOTSTRAP_DIR/src/main.fg" >"$BUILD_DIR/bs2_asan.codegen.log" 2>&1 \
      || { cat "$BUILD_DIR/bs2_asan.codegen.log" >&2; die "bs2_asan codegen failed"; }
    log "linking $BS2_ASAN with -fsanitize=address"
    cc -fsanitize=address -g -o "$BS2_ASAN" \
       "$BOOTSTRAP_DIR/src/main.fg.ll" "$RUNTIME_ASAN_O" \
       "$STDLLVM_A" "$STDPROC_A" $LLVM_LIBS_LDFLAGS 2>"$BUILD_DIR/bs2_asan.link.log" \
      || { cat "$BUILD_DIR/bs2_asan.link.log" >&2; die "bs2_asan link failed"; }
    ok "built $BS2_ASAN"
  fi
}

ensure_bs3() {
  ensure_bs2
  log "compiling bootstrap/src/main.fg with bs2 → $BS3"
  cp "$BOOTSTRAP_DIR/src/main.fg" "$BUILD_DIR/main_for_bs3.fg"
  # Resolve all `mod foo` lines into the input first, by symlinking
  # the src dir contents into build/. We just point bs2 at the original
  # file so its preprocess_modules walks the right directory.
  if ! "$BS2" compile "$BOOTSTRAP_DIR/src/main.fg" >"$BUILD_DIR/bs3.codegen.log" 2>&1; then
    cat "$BUILD_DIR/bs3.codegen.log" >&2
    die "bs3 codegen failed (bs2 cannot self-compile yet)"
  fi
  cc -o "$BS3" "$BOOTSTRAP_DIR/src/main.fg.ll" "$RUNTIME_O" \
     "$STDLLVM_A" "$STDPROC_A" $LLVM_LIBS_LDFLAGS 2>"$BUILD_DIR/bs3.link.log" \
    || { cat "$BUILD_DIR/bs3.link.log" >&2; die "bs3 link failed"; }
  ok "built $BS3"
}

# ─────────────────────────────────────────────────────────────────────
# Modes
# ─────────────────────────────────────────────────────────────────────

mode_build() {
  ensure_host_compiler
  ensure_stdlibs
  log "running scripts/test.sh"
  bash "$SCRIPT_DIR/test.sh"
}

mode_build_runtime() { ensure_runtime; ok "$RUNTIME_O"; }
mode_build_bs2()      { ensure_bs2;      ok "$BS2"; }
mode_build_bs2_asan() { ensure_bs2_asan; ok "$BS2_ASAN"; }
mode_build_bs3()      { ensure_bs3;      ok "$BS3"; }

# Compile + link + run a .fg with bs2 (or stage1).
run_fg() {
  local fg="$1"; local which="$2"
  [ -f "$fg" ] || die "no such file: $fg"
  local compiler ll bin
  case "$which" in
    bs2)    ensure_bs2;    compiler="$BS2" ;;
    stage1) ensure_stage1; compiler="$STAGE1" ;;
    *) die "run_fg: unknown compiler '$which'" ;;
  esac
  ensure_runtime
  ll="$fg.ll"
  bin="${fg%.fg}.bin"
  if ! "$compiler" compile "$fg" >"$BUILD_DIR/last_run.log" 2>&1; then
    cat "$BUILD_DIR/last_run.log" >&2
    die "$which codegen failed"
  fi
  cc -o "$bin" "$ll" "$RUNTIME_O" 2>"$BUILD_DIR/last_link.log" \
    || { cat "$BUILD_DIR/last_link.log" >&2; die "link failed"; }
  "$bin"
}

mode_run()        { run_fg "$1" bs2; }
mode_run_stage1() { run_fg "$1" stage1; }

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

mode_ll_stage1() {
  local fg="$1"; [ -f "$fg" ] || die "no such file: $fg"
  ensure_stage1
  "$STAGE1" compile "$fg" >/dev/null
  cat "$fg.ll"
}

mode_diff() {
  local fg="$1"; [ -f "$fg" ] || die "no such file: $fg"
  ensure_stage1; ensure_bs2
  local s1_ll="$BUILD_DIR/$(basename "$fg").stage1.ll"
  local b2_ll="$BUILD_DIR/$(basename "$fg").bs2.ll"
  cp "$fg" "$BUILD_DIR/_tmp_s1.fg"
  cp "$fg" "$BUILD_DIR/_tmp_b2.fg"
  "$STAGE1" compile "$BUILD_DIR/_tmp_s1.fg" >/dev/null \
    || die "stage1 codegen failed"
  "$BS2"    compile "$BUILD_DIR/_tmp_b2.fg" >/dev/null 2>&1 \
    || die "bs2 codegen failed (it crashed or errored on this input)"
  mv "$BUILD_DIR/_tmp_s1.fg.ll" "$s1_ll"
  mv "$BUILD_DIR/_tmp_b2.fg.ll" "$b2_ll"
  log "stage1: $s1_ll"
  log "bs2:    $b2_ll"
  if diff -u "$s1_ll" "$b2_ll" >/dev/null; then
    ok "IR is byte-identical"
  else
    diff -u "$s1_ll" "$b2_ll" | head -200
  fi
}

mode_diff_fn() {
  local fg="$1" fn="$2"
  [ -f "$fg" ] || die "no such file: $fg"
  [ -n "$fn" ] || die "--diff-fn requires <file.fg> <fn-name>"
  ensure_stage1; ensure_bs2
  local s1_ll="$BUILD_DIR/$(basename "$fg").stage1.ll"
  local b2_ll="$BUILD_DIR/$(basename "$fg").bs2.ll"
  "$STAGE1" compile "$fg" >/dev/null
  cp "$fg.ll" "$s1_ll"
  "$BS2" compile "$fg" >/dev/null 2>&1 || die "bs2 codegen failed"
  cp "$fg.ll" "$b2_ll"
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

  printf "%-22s %s\n" "file"            "$ll"
  printf "%-22s %s\n" "lines"           "$total"
  printf "%-22s %s\n" "functions"       "$fns"
  printf "%-22s %s\n" "ret undef"       "$ret_undef"
  printf "%-22s %s\n" "br i1 false"     "$br_const_false"
  printf "%-22s %s\n" "phi undef"       "$phi_undef"
  printf "%-22s %s\n" "unreachable"     "$unreachable"
  printf "%-22s %s\n" "empty blocks"    "$empty_blocks"
  printf "%-22s %s\n" "orphan blocks"   "$orphan_blocks"
  local score=$((ret_undef*10 + br_const_false*5 + phi_undef*5 + empty_blocks*2 + orphan_blocks*3))
  printf "%-22s ${C_YELLOW}%s${C_RESET}\n" "SCORE (lower=better)" "$score"
}

mode_rank() {
  local arg="$1"; [ -f "$arg" ] || die "no such file: $arg"
  local ll
  case "$arg" in
    *.ll) ll="$arg" ;;
    *.fg)
      ensure_stage1
      "$STAGE1" compile "$arg" >/dev/null 2>&1 || die "stage1 codegen failed"
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
  mkdir -p "$REGRESS_DIR"
  local pass=0 fail=0
  shopt -s nullglob
  for fg in "$REGRESS_DIR"/*.fg; do
    local name expected actual bin
    name=$(basename "$fg" .fg)
    expected="$REGRESS_DIR/$name.out"
    [ -f "$expected" ] || { warn "$name: missing $name.out, skipping"; continue; }
    bin="$BUILD_DIR/regress_$name.bin"
    if ! "$BS2" compile "$fg" >"$BUILD_DIR/regress_$name.codegen.log" 2>&1; then
      err "$name: bs2 codegen failed"
      fail=$((fail+1))
      continue
    fi
    if ! cc -o "$bin" "$fg.ll" "$RUNTIME_O" 2>"$BUILD_DIR/regress_$name.link.log"; then
      err "$name: link failed"
      fail=$((fail+1))
      continue
    fi
    actual=$("$bin" 2>&1) || true
    if [ "$actual" = "$(cat "$expected")" ]; then
      ok "$name"
      pass=$((pass+1))
    else
      err "$name: output mismatch"
      diff -u <(echo "$actual") "$expected" | sed 's/^/    /' >&2
      fail=$((fail+1))
    fi
  done
  echo
  printf "regress: ${C_GREEN}%d passed${C_RESET}, ${C_RED}%d failed${C_RESET}\n" "$pass" "$fail"
  [ "$fail" -eq 0 ]
}

mode_regress_add() {
  local name="$1" fg="$2"
  [ -n "$name" ] || die "--regress-add requires <name> <file.fg>"
  [ -f "$fg" ] || die "no such file: $fg"
  ensure_bs2
  mkdir -p "$REGRESS_DIR"
  local stage="$BUILD_DIR/_capture_$name.fg"
  cp "$fg" "$stage"
  log "compiling with bs2 to capture expected output"
  if ! "$BS2" compile "$stage" >/dev/null 2>&1; then
    rm -f "$stage" "$stage.ll"
    die "bs2 codegen failed — fix the codegen first"
  fi
  local bin="$BUILD_DIR/regress_$name.bin"
  if ! cc -o "$bin" "$stage.ll" "$RUNTIME_O" 2>/dev/null; then
    rm -f "$stage" "$stage.ll"
    die "link failed"
  fi
  local out
  out=$("$bin" 2>&1) || true
  cp "$fg" "$REGRESS_DIR/$name.fg"
  printf '%s\n' "$out" >"$REGRESS_DIR/$name.out"
  rm -f "$stage" "$stage.ll" "$bin"
  ok "captured: regress/$name.fg + regress/$name.out"
  echo "expected output:"
  sed 's/^/    /' "$REGRESS_DIR/$name.out"
}

mode_regress_list() {
  shopt -s nullglob
  local any=0
  for fg in "$REGRESS_DIR"/*.fg; do
    any=1
    local name; name=$(basename "$fg" .fg)
    printf "  %s\n" "$name"
  done
  [ "$any" -eq 0 ] && warn "no regression tests in $REGRESS_DIR"
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
    --run)                mode_run "$@" ;;
    --run-stage1)         mode_run_stage1 "$@" ;;
    --check)              mode_check "$@" ;;
    --ll)                 mode_ll "$@" ;;
    --ll-stage1)          mode_ll_stage1 "$@" ;;
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
