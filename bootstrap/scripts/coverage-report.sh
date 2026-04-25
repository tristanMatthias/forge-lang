#!/bin/bash
# Usage: coverage-report.sh <source.fg> <profdata> [--lcov <output.lcov>]
# Produces line-by-line coverage annotation and optionally LCOV export.

set -euo pipefail

SOURCE="$1"
PROFDATA="$2"
LCOV_OUT=""
if [ "${3:-}" = "--lcov" ] && [ -n "${4:-}" ]; then
  LCOV_OUT="$4"
fi

LLVM_PREFIX="${LLVM_PREFIX:-/opt/homebrew/opt/llvm}"

if [ ! -f "$SOURCE" ]; then echo "error: source file not found: $SOURCE" >&2; exit 1; fi
if [ ! -f "$PROFDATA" ]; then echo "error: profdata not found: $PROFDATA" >&2; exit 1; fi

# Extract counter data
COUNTS=$("$LLVM_PREFIX/bin/llvm-profdata" show --all-functions --counts "$PROFDATA" 2>/dev/null \
  | grep "Block counts:" | head -1 | sed 's/.*\[//;s/\]//')

if [ -z "$COUNTS" ]; then
  echo "error: no counter data found in $PROFDATA" >&2
  exit 1
fi

IFS=',' read -ra COUNT_ARR <<< "$COUNTS"

# Start LCOV output if requested
if [ -n "$LCOV_OUT" ]; then
  echo "TN:" > "$LCOV_OUT"
  echo "SF:$(cd "$(dirname "$SOURCE")" && pwd)/$(basename "$SOURCE")" >> "$LCOV_OUT"
fi

LINE_NUM=1
TOTAL_LINES=0
COVERED_LINES=0
UNCOVERED_LINES=0

while IFS= read -r line; do
  idx=$((LINE_NUM))
  count=0
  if [ "$idx" -lt "${#COUNT_ARR[@]}" ]; then
    count=$(echo "${COUNT_ARR[$idx]}" | tr -d ' ')
  fi

  stripped=$(echo "$line" | sed 's/^[[:space:]]*//')
  is_code=true
  if [ -z "$stripped" ] || [[ "$stripped" == //* ]] || [[ "$stripped" == "///"* ]]; then
    is_code=false
  fi

  if [ "$is_code" = true ]; then
    TOTAL_LINES=$((TOTAL_LINES + 1))
    # Emit LCOV DA line
    if [ -n "$LCOV_OUT" ]; then
      echo "DA:${LINE_NUM},${count}" >> "$LCOV_OUT"
    fi
    if [ "$count" -gt 0 ]; then
      COVERED_LINES=$((COVERED_LINES + 1))
      printf "\033[32m%5dx\033[0m | %s\n" "$count" "$line"
    else
      UNCOVERED_LINES=$((UNCOVERED_LINES + 1))
      printf "\033[31m%5s \033[0m | %s\n" "✗" "$line"
    fi
  else
    printf "%6s | %s\n" "" "$line"
  fi

  LINE_NUM=$((LINE_NUM + 1))
done < "$SOURCE"

# Finalize LCOV
if [ -n "$LCOV_OUT" ]; then
  echo "LH:${COVERED_LINES}" >> "$LCOV_OUT"
  echo "LF:${TOTAL_LINES}" >> "$LCOV_OUT"
  echo "end_of_record" >> "$LCOV_OUT"
  echo ""
  echo "LCOV written to: $LCOV_OUT"
fi

echo ""
if [ "$TOTAL_LINES" -gt 0 ]; then
  PCT=$((COVERED_LINES * 100 / TOTAL_LINES))
  echo "Coverage: ${COVERED_LINES}/${TOTAL_LINES} lines (${PCT}%)"
  if [ "$UNCOVERED_LINES" -gt 0 ]; then
    echo "Uncovered: ${UNCOVERED_LINES} lines"
  fi
fi
