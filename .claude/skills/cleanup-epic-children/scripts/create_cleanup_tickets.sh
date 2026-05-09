#!/bin/bash
# Create 3 cleanup sub-tickets per OPEN child of a given epic:
# - .cleanupA: aggressive perf review
# - .cleanupB: DRY + use language features
# - .cleanupC: red-team + edge cases
#
# Usage: create_cleanup_tickets.sh <epic-id>
#   e.g. create_cleanup_tickets.sh forge-crafting-intepreters-vez6
#
# Closed children are skipped (they already shipped without cleanup —
# add a retro-cleanup ticket manually if you really want to revisit).
#
# Description bodies are read from the skill's cleanup_pass_*.md files
# (relative path resolved from this script's location).

set -u

if [ $# -ne 1 ]; then
    echo "usage: $0 <epic-id>" >&2
    exit 1
fi

EPIC_ID="$1"

# Locate the skill directory regardless of where the script is invoked from.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"

PASS_A_DESC="$(cat "$SKILL_DIR/cleanup_pass_1.md")"
PASS_B_DESC="$(cat "$SKILL_DIR/cleanup_pass_2.md")"
PASS_C_DESC="$(cat "$SKILL_DIR/cleanup_pass_3.md")"

# Discover open children of the epic. bd's `show <id>` lists children with
# a status glyph (○ open, ◐ in_progress, ● blocked, ✓ closed, ❄ deferred).
# Open + in_progress qualify; closed/blocked/deferred we skip.
mapfile -t CHILDREN < <(
    bd --sandbox show "$EPIC_ID" 2>/dev/null \
        | grep -E "^\s*↳ [○◐]" \
        | sed -E 's/^\s*↳ [○◐] (forge-crafting-intepreters-[a-z0-9.]+):.*/\1/'
)

if [ ${#CHILDREN[@]} -eq 0 ]; then
    echo "no open children found for epic $EPIC_ID" >&2
    exit 1
fi

echo "Epic: $EPIC_ID"
echo "Open children: ${#CHILDREN[@]}"
echo ""

create_one() {
    local child_id="$1"
    local pass="$2"
    local desc_text=""
    local suffix=""

    case $pass in
        A) suffix="Aggressive perf pass"
           desc_text="$PASS_A_DESC" ;;
        B) suffix="DRY + language-feature pass"
           desc_text="$PASS_B_DESC" ;;
        C) suffix="Red-team + edge-case pass"
           desc_text="$PASS_C_DESC" ;;
    esac

    # Use the child's short ID (after final dash) in the title to keep
    # it readable: e.g. "vez6.3.cleanupA: ..." rather than the full id.
    local short_id="${child_id##*-}"
    local title="${short_id}.cleanup${pass}: ${suffix}"

    out=$(bd --sandbox create \
        --title "$title" \
        --type=task \
        --priority=1 \
        --parent="$child_id" \
        --description "$desc_text" \
        2>&1)

    new_id=$(echo "$out" | grep -E "Created issue:" | awk '{print $4}')
    if [ -z "$new_id" ]; then
        echo "  ✗ FAILED $child_id pass=$pass: $out"
        return 1
    fi
    echo "  ✓ $new_id"
}

for child in "${CHILDREN[@]}"; do
    echo "=== $child ==="
    create_one "$child" "A"
    create_one "$child" "B"
    create_one "$child" "C"
    echo ""
done

echo "Done. Verify with:"
echo "  bd --sandbox show $EPIC_ID"
