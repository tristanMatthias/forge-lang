#!/bin/bash
# Usage: coverage-report.sh <source.fg> <profdata> [--lcov <output.lcov>]
set -euo pipefail

SOURCE="$1"
PROFDATA="$2"
LCOV_OUT=""
if [ "${3:-}" = "--lcov" ] && [ -n "${4:-}" ]; then
  LCOV_OUT="$4"
fi

COVMAP="${SOURCE}.covmap.json"
LLVM_PREFIX="${LLVM_PREFIX:-/opt/homebrew/opt/llvm}"

[ -f "$SOURCE" ] || { echo "error: $SOURCE not found" >&2; exit 1; }
[ -f "$PROFDATA" ] || { echo "error: $PROFDATA not found" >&2; exit 1; }

exec python3 "$(dirname "$0")/coverage-report.py" "$SOURCE" "$PROFDATA" "$COVMAP" "$LCOV_OUT" "$LLVM_PREFIX"
