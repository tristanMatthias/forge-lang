#!/usr/bin/env bash
# Compiler self-coverage: instruments bs2 itself and runs the test suite through it.
# Produces a per-module coverage summary and optional LCOV output.
#
# Usage: scripts/compiler-coverage.sh [--lcov output.lcov]
set -euo pipefail

LLVM_PREFIX="${LLVM_PREFIX:-/opt/homebrew/opt/llvm}"
LLC="${LLVM_PREFIX}/bin/llc"
OPT="${LLVM_PREFIX}/bin/opt"
PROFDATA="${LLVM_PREFIX}/bin/llvm-profdata"
CLANG_RT_DIR="$LLVM_PREFIX/lib/clang/$(ls "$LLVM_PREFIX/lib/clang/" | head -1)/lib/darwin"

BS2=build/bs2
COV_DIR=build/coverage
COV_BS2="$COV_DIR/bs2_cov"
SRC_DIR=packages/avrac/src
COVMAP=$SRC_DIR/main.av.covmap.json

LCOV_OUT=""
if [ "${1:-}" = "--lcov" ] && [ -n "${2:-}" ]; then
    LCOV_OUT="$2"
fi

log() { printf '\033[0;34m[cov]\033[0m %s\n' "$1"; }
ok()  { printf '\033[0;32m[ok]\033[0m  %s\n' "$1"; }
die() { printf '\033[0;31m[err]\033[0m %s\n' "$1" >&2; exit 1; }

# Step 1: Ensure bs2 exists
[ -f "$BS2" ] || die "bs2 not found — run 'make build' first"

mkdir -p "$COV_DIR/profiles"

# Step 2: Compile the compiler with --coverage
log "compiling $SRC_DIR/main.av with --coverage"
"$BS2" compile --coverage "$SRC_DIR/main.av" >"$COV_DIR/codegen.log" 2>&1 \
    || die "bs2 compile --coverage failed (see $COV_DIR/codegen.log)"

# Step 3: Lower instrprof intrinsics
log "lowering instrprof intrinsics"
"$OPT" -passes=instrprof -o "$COV_DIR/main.cov.ll" -S "$SRC_DIR/main.av.ll" \
    --mtriple=arm64-apple-macosx \
    || die "opt instrprof lowering failed"

# Step 4: Compile to object + link
log "compiling + linking instrumented binary"
"$LLC" -O2 -filetype=obj "$COV_DIR/main.cov.ll" -o "$COV_DIR/bs2_cov.o" \
    || die "llc failed"
cc -o "$COV_BS2" "$COV_DIR/bs2_cov.o" build/runtime.o build/llvm_wrapper.o \
    -Wl,-stack_size,0x2000000 \
    -L"$LLVM_PREFIX/lib" -lLLVM -lc++ \
    -L"$CLANG_RT_DIR" -lclang_rt.profile_osx 2>/dev/null \
    || die "link failed"
ok "instrumented compiler at $COV_BS2"

# Step 5: Run all tests through the instrumented compiler
# Try compile first (exercises codegen), fall back to check (exercises parse+typeck).
log "running test suite through instrumented compiler"
rm -f "$COV_DIR/profiles/"*.profraw
passed=0; failed=0; total=0
for fg in $(find tests -name '*.av' | sort; find "$SRC_DIR/features" -path '*/tests/*.av' | sort; find "$SRC_DIR/features" -name 'example*.av' | sort); do
    total=$((total + 1))
    name=$(echo "$fg" | tr '/.' '_')
    prf="$COV_DIR/profiles/${name}.profraw"
    if LLVM_PROFILE_FILE="$prf" "$COV_BS2" compile "$fg" >/dev/null 2>&1; then
        passed=$((passed + 1))
    elif LLVM_PROFILE_FILE="$prf" "$COV_BS2" check "$fg" >/dev/null 2>&1; then
        passed=$((passed + 1))
    else
        failed=$((failed + 1))
    fi
done
ok "$passed/$total tests profiled ($failed failed)"

# Step 6: Merge profiles (filter corrupt/empty ones)
log "merging profiles"
valid_files=""
valid_count=0
for f in "$COV_DIR/profiles/"*.profraw; do
    [ -s "$f" ] || continue
    if "$PROFDATA" show "$f" >/dev/null 2>&1; then
        valid_files="$valid_files $f"
        valid_count=$((valid_count + 1))
    fi
done
[ "$valid_count" -gt 0 ] || die "no valid profiles collected"
log "$valid_count valid profiles found"
# shellcheck disable=SC2086
"$PROFDATA" merge -sparse $valid_files -o "$COV_DIR/merged.profdata" \
    || die "profdata merge failed (try: rm -rf build/coverage/profiles && make coverage)"
"$PROFDATA" show --all-functions --counts "$COV_DIR/merged.profdata" \
    >"$COV_DIR/profdata_dump.txt" 2>/dev/null
ok "$valid_count valid profiles merged"

# Step 7: Analyze with Python
log "generating coverage report"
python3 scripts/compiler-coverage-report.py \
    "$COVMAP" "$COV_DIR/profdata_dump.txt" "$LCOV_OUT"
