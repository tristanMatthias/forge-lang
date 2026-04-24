#!/bin/bash
# Usage: coverage-report.sh <source.fg> <profdata>
# Produces a line-by-line coverage annotation of the source file.

set -euo pipefail

SOURCE="$1"
PROFDATA="$2"
LLVM_PREFIX="${LLVM_PREFIX:-/opt/homebrew/opt/llvm}"

if [ ! -f "$SOURCE" ]; then echo "error: source file not found: $SOURCE" >&2; exit 1; fi
if [ ! -f "$PROFDATA" ]; then echo "error: profdata not found: $PROFDATA" >&2; exit 1; fi

# Extract counter data — format: "Block counts: [N, N, N, ...]"
COUNTS=$("$LLVM_PREFIX/bin/llvm-profdata" show --all-functions --counts "$PROFDATA" 2>/dev/null \
  | grep "Block counts:" | head -1 | sed 's/.*\[//;s/\]//')

if [ -z "$COUNTS" ]; then
  echo "error: no counter data found in $PROFDATA" >&2
  exit 1
fi

# Parse counts into an array
IFS=',' read -ra COUNT_ARR <<< "$COUNTS"

# Annotate source
LINE_NUM=1
TOTAL_LINES=0
COVERED_LINES=0
UNCOVERED_LINES=0

while IFS= read -r line; do
  # Counter index = line number (1-based, but array is 0-based)
  idx=$((LINE_NUM))
  count=0
  if [ "$idx" -lt "${#COUNT_ARR[@]}" ]; then
    count=$(echo "${COUNT_ARR[$idx]}" | tr -d ' ')
  fi
  
  # Skip empty lines and comments for coverage stats
  stripped=$(echo "$line" | sed 's/^[[:space:]]*//')
  is_code=true
  if [ -z "$stripped" ] || [[ "$stripped" == //* ]] || [[ "$stripped" == "///"* ]]; then
    is_code=false
  fi
  
  if [ "$is_code" = true ]; then
    TOTAL_LINES=$((TOTAL_LINES + 1))
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

echo ""
if [ "$TOTAL_LINES" -gt 0 ]; then
  PCT=$((COVERED_LINES * 100 / TOTAL_LINES))
  echo "Coverage: ${COVERED_LINES}/${TOTAL_LINES} lines (${PCT}%)"
  if [ "$UNCOVERED_LINES" -gt 0 ]; then
    echo "Uncovered: ${UNCOVERED_LINES} lines"
  fi
else
  echo "No code lines found."
fi
