#!/bin/bash
# Tool #7 — `forge bisect`: ranks divergent functions between
# rust-emitted IR and self-host-emitted IR for the same source.
#
# Usage:
#   bash scripts/forge_bisect.sh [source.fg]
#
# Defaults to packages/forgec/src/main.fg.
#
# Steps:
#   1. Compile <source> with the rust forgec → /tmp/stage1.ll
#   2. Build stage1_rust if stale, run it on <source> → /tmp/stage2.ll
#   3. Run diagnose.sh --rank-diff to print ranked divergences
#
# Output: a sorted list of function names ranked by IR diff size.
# The smallest non-trivial divergences are usually root-cause bugs;
# larger divergences are downstream effects.

set -e
SOURCE="${1:-packages/forgec/src/main.fg}"
LLVM_PREFIX="${LLVM_SYS_191_PREFIX:-/opt/homebrew/opt/llvm@19}"

if [ ! -f "$SOURCE" ]; then
    echo "ERROR: $SOURCE not found" >&2
    exit 1
fi

echo "═══ forge bisect ═══"
echo "  source: $SOURCE"
echo ""

# Step 1: rust → stage1.ll
echo "[1/3] rust forgec --emit-ir → /tmp/stage1.ll"
LLVM_SYS_191_PREFIX="$LLVM_PREFIX" ./target/release/forgec build "$SOURCE" --emit-ir 2>/dev/null > /tmp/stage1.ll
echo "      $(wc -l < /tmp/stage1.ll) lines"

# Step 2: stage1_rust → stage2.ll
echo "[2/3] make stage1-rust + run on $SOURCE → /tmp/stage2.ll"
make stage1-rust 2>&1 | tail -3
./build/stage1_rust build "$SOURCE" >/dev/null 2>&1 || true
if [ ! -f output.ll ]; then
    echo "ERROR: stage1_rust did not produce output.ll" >&2
    exit 1
fi
cp output.ll /tmp/stage2.ll
echo "      $(wc -l < /tmp/stage2.ll) lines"

# Step 3: rank
echo "[3/3] ranking divergences..."
echo ""
bash scripts/diagnose.sh --rank-diff /tmp/stage1.ll /tmp/stage2.ll
