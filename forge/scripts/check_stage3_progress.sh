#!/usr/bin/env bash
# Stage 3 regression guard.
#
# Runs the full pipeline and compares score / fn count / build / run
# against forge/scripts/stage3_baseline.txt. Fails if any metric got
# worse. Auto-tightens the baseline (and re-stages it for the commit
# in pre-commit context) if any metric improved.
#
# Usage:
#   bash forge/scripts/check_stage3_progress.sh           # check only
#   bash forge/scripts/check_stage3_progress.sh --update  # force update
#
# Pre-commit hook calls this with no args; --no-verify on git commit
# bypasses entirely if you ever need to land a temporary regression.

set -e
cd "$(dirname "$0")/.."  # → forge/

BASELINE=scripts/stage3_baseline.txt
if [ ! -f "$BASELINE" ]; then
    echo "stage3_baseline.txt missing — refusing to run guard." >&2
    exit 1
fi

# shellcheck disable=SC1090
. "$BASELINE"
B_SCORE=$SCORE; B_FNS=$FNS; B_BUILDS=$BUILDS; B_RUNS=$RUNS

echo "── stage3 progress guard ──"
echo "  baseline: score=$B_SCORE fns=$B_FNS builds=$B_BUILDS runs=$B_RUNS"

LOG=$(mktemp)
trap 'rm -f "$LOG"' EXIT

if ! bash scripts/diagnose.sh --pipeline >"$LOG" 2>&1; then
    echo "  ✗ pipeline crashed; see $LOG" >&2
    tail -20 "$LOG" >&2
    exit 1
fi

# Parse current metrics out of the pipeline output.
NEW_SCORE=$(grep -E "Stage 3 IR Quality" -A 8 "$LOG" | grep -oE "SCORE: *[0-9]+" | awk '{print $2}' | head -1)
NEW_FNS=$(grep -oE "Stage 3 IR has [0-9]+ functions" "$LOG" | sed -E 's/.*has ([0-9]+).*/\1/' | head -1)
NEW_BUILDS=0
grep -q "cc → /tmp/stage3 executable" "$LOG" && NEW_BUILDS=1
NEW_RUNS=0
grep -q "Stage 3 exits 0" "$LOG" && NEW_RUNS=1

if [ -z "$NEW_SCORE" ] || [ -z "$NEW_FNS" ]; then
    echo "  ✗ couldn't parse pipeline output (score/fns missing)" >&2
    tail -30 "$LOG" >&2
    exit 1
fi

echo "  current:  score=$NEW_SCORE fns=$NEW_FNS builds=$NEW_BUILDS runs=$NEW_RUNS"

REGRESSED=0
if [ "$NEW_BUILDS" -lt "$B_BUILDS" ]; then
    echo "  ✗ stage 3 BUILD regressed ($B_BUILDS → $NEW_BUILDS)" >&2; REGRESSED=1
fi
if [ "$NEW_RUNS" -lt "$B_RUNS" ]; then
    echo "  ✗ stage 3 RUN regressed ($B_RUNS → $NEW_RUNS)" >&2; REGRESSED=1
fi
if [ "$NEW_SCORE" -gt "$B_SCORE" ]; then
    echo "  ✗ stage 3 SCORE got worse ($B_SCORE → $NEW_SCORE, lower is better)" >&2; REGRESSED=1
fi
if [ "$NEW_FNS" -lt "$B_FNS" ]; then
    echo "  ✗ stage 3 FN COUNT dropped ($B_FNS → $NEW_FNS)" >&2; REGRESSED=1
fi

if [ "$REGRESSED" -eq 1 ]; then
    echo "" >&2
    echo "  Stage 3 regressed. Fix the regression, or commit with" >&2
    echo "  --no-verify if this is intentional and you have a reason." >&2
    exit 1
fi

# Auto-tighten on improvement.
IMPROVED=0
if [ "$NEW_SCORE" -lt "$B_SCORE" ] || [ "$NEW_FNS" -gt "$B_FNS" ] \
   || [ "$NEW_BUILDS" -gt "$B_BUILDS" ] || [ "$NEW_RUNS" -gt "$B_RUNS" ]; then
    IMPROVED=1
fi

if [ "$IMPROVED" -eq 1 ] || [ "${1:-}" = "--update" ]; then
    cat > "$BASELINE" <<EOF
SCORE=$NEW_SCORE
FNS=$NEW_FNS
BUILDS=$NEW_BUILDS
RUNS=$NEW_RUNS
EOF
    echo "  ✓ baseline tightened → score=$NEW_SCORE fns=$NEW_FNS builds=$NEW_BUILDS runs=$NEW_RUNS"
    # If we're inside a pre-commit hook, re-stage the baseline so the
    # tightened version lands in the same commit as the improvement.
    if [ -n "${GIT_INDEX_FILE:-}" ] || git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        git add "$BASELINE" 2>/dev/null || true
    fi
else
    echo "  ✓ no regression"
fi
