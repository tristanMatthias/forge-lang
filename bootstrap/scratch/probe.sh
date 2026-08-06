#!/usr/bin/env bash
# t-myz7 probe: hand vs native diagnostics for one source snippet.
# Usage: probe.sh 'source text'   (or: probe.sh -f file.av)
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1

HAND="AVRA_PARSER_DECL_FLIP=0 AVRA_PARSER_DECL_STATIC=1 AVRA_NO_STATIC_FALLBACK=0 AVRA_PARSER_EXPR_STATIC=0 AVRA_PARSER_EXPR_FLIP=0"
EMIT="AVRA_PARSER_DECL_FLIP=1 AVRA_PARSER_DECL_STATIC=1 AVRA_NO_STATIC_FALLBACK=1 AVRA_PARSER_EXPR_STATIC=1 AVRA_PARSER_EXPR_FLIP=0"
PROD="AVRA_PARSER_DECL_FLIP=1 AVRA_PARSER_DECL_STATIC=1 AVRA_NO_STATIC_FALLBACK=0 AVRA_PARSER_EXPR_STATIC=1 AVRA_PARSER_EXPR_FLIP=0"
EXEC="AVRA_PARSER_DECL_FLIP=1 AVRA_PARSER_DECL_STATIC=0 AVRA_NO_STATIC_FALLBACK=0 AVRA_PARSER_EXPR_STATIC=0 AVRA_PARSER_EXPR_FLIP=1"

if [ "${1:-}" = "-f" ]; then FIX="$2"; else FIX=/tmp/avra_probe.av; printf '%s\n' "$1" > "$FIX"; fi

run() { env $1 ./build/bs2 check "$FIX" 2>&1 | sed 's/.\[[0-9;]*m//g' | grep -oE 'error.F[0-9]+.: .*' | tr '\n' '|'; }

printf 'src : %s\n' "$(tr '\n' ' ' < "$FIX")"
printf 'hand: %s\n' "$(run "$HAND")"
printf 'emit: %s\n' "$(run "$EMIT")"
printf 'prod: %s\n' "$(run "$PROD")"
printf 'exec: %s\n' "$(run "$EXEC")"
