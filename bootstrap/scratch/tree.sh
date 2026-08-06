#!/usr/bin/env bash
# t-myz7 tree probe: hand vs native RECOVERY TREE for one source snippet.
# The diagnostics can agree while the tree does not — that is the `fn`/`let`
# blocker, which is about how many `(error)` rows the recovery leaves behind.
# Usage: tree.sh 'source text'   (or: tree.sh -f file.av)
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1

HAND="AVRA_PARSER_DECL_FLIP=0 AVRA_PARSER_DECL_STATIC=1 AVRA_NO_STATIC_FALLBACK=0 AVRA_PARSER_EXPR_STATIC=0 AVRA_PARSER_EXPR_FLIP=0"
EMIT="AVRA_PARSER_DECL_FLIP=1 AVRA_PARSER_DECL_STATIC=1 AVRA_NO_STATIC_FALLBACK=1 AVRA_PARSER_EXPR_STATIC=1 AVRA_PARSER_EXPR_FLIP=0"
EXEC="AVRA_PARSER_DECL_FLIP=1 AVRA_PARSER_DECL_STATIC=0 AVRA_NO_STATIC_FALLBACK=0 AVRA_PARSER_EXPR_STATIC=0 AVRA_PARSER_EXPR_FLIP=1"

if [ "${1:-}" = "-f" ]; then FIX="$2"; else FIX=/tmp/avra_tree.av; printf '%s\n' "$1" > "$FIX"; fi

run() { env $1 ./build/bs2 program "$FIX" 2>&1 | sed 's/.\[[0-9;]*m//g'; }
errs() { printf '%s' "$1" | grep -oc '(error)' || true; }

H=$(run "$HAND"); E=$(run "$EMIT"); X=$(run "$EXEC")
printf 'src : %s\n' "$(tr '\n' ' ' < "$FIX")"
printf 'hand [%s err rows]: %s\n' "$(errs "$H")" "$(printf '%s' "$H" | tr '\n' ' ')"
printf 'emit [%s err rows]: %s\n' "$(errs "$E")" "$(printf '%s' "$E" | tr '\n' ' ')"
printf 'exec [%s err rows]: %s\n' "$(errs "$X")" "$(printf '%s' "$X" | tr '\n' ' ')"
