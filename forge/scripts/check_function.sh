#!/bin/bash
# Usage: scripts/check_function.sh <function_name> [keyword]
# Shows the IR for a function in output.ll and checks for expected patterns
FN="${1:-Lexer_skip_whitespace}"
KW="${2:-forge_loop}"

echo "=== $FN ==="
awk "/^define.*@${FN}[ (]/,/^}/" output.ll

echo ""
echo "=== Checking for '$KW' ==="
awk "/^define.*@${FN}[ (]/,/^}/" output.ll | grep -c "$KW"
echo "occurrences"

echo ""
echo "=== br patterns ==="
awk "/^define.*@${FN}[ (]/,/^}/" output.ll | grep "br " | head -20

echo ""
echo "=== Calls ==="
awk "/^define.*@${FN}[ (]/,/^}/" output.ll | grep "call " | head -20
