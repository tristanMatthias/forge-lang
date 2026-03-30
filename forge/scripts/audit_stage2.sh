#!/usr/bin/env bash
# audit_stage2.sh — Produce a scorecard of IR quality issues in Stage 2 output.
# Usage: ./scripts/audit_stage2.sh [path/to/output.ll]

set -euo pipefail

IR="${1:-output.ll}"

if [ ! -f "$IR" ]; then
    echo "ERROR: File not found: $IR" >&2
    exit 1
fi

echo "=== Stage 2 IR Audit ==="

# 1. br i1 false — dead branches (condition always false)
br_i1_false=$(grep -c 'br i1 false' "$IR" || true)
br_i1_false=${br_i1_false:-0}

# 2. <null operand!> — LLVM null operand errors baked into IR
null_operands=$(grep -c '<null operand!>' "$IR" || true)
null_operands=${null_operands:-0}

# 3. ret ... undef — functions returning undefined values
ret_undef=$(grep -c -E 'ret .* undef' "$IR" || true)
ret_undef=${ret_undef:-0}

# 4. struct_as_i64: calls where struct types are passed as i64.
#    Find functions defined with struct params (%Statement, %Expr, %Token, %Type, %ForgeString),
#    then count calls to those functions that pass i64.
struct_fn_file=$(mktemp)
grep -E '^define ' "$IR" | grep -E '%Statement|%Expr|%Token|%Type|%ForgeString' | \
    sed 's/.*@\([a-zA-Z0-9_]*\)(.*/\1/' > "$struct_fn_file" || true

struct_as_i64=0
if [ -s "$struct_fn_file" ]; then
    while IFS= read -r fn; do
        c=$(grep -c "call .* @${fn}(.*i64 " "$IR" || true)
        c=${c:-0}
        struct_as_i64=$((struct_as_i64 + c))
    done < "$struct_fn_file"
fi
rm -f "$struct_fn_file"

# 5. call_type_mismatch: calls to any function declared/defined with struct params.
#    Broader than struct_as_i64 — includes all struct types not just the big five.
struct_fn_all=$(mktemp)
grep -E '^(define|declare) ' "$IR" | grep -E '%[A-Z]' | \
    sed 's/.*@\([a-zA-Z0-9_.]*\)(.*/\1/' > "$struct_fn_all" || true

call_type_mismatch=0
if [ -s "$struct_fn_all" ]; then
    # Build a grep pattern from all function names
    pattern_file=$(mktemp)
    while IFS= read -r fn; do
        echo "@${fn}(" >> "$pattern_file"
    done < "$struct_fn_all"
    # Count call lines matching any of those functions
    call_type_mismatch=$(grep 'call ' "$IR" | grep -c -F -f "$pattern_file" || true)
    call_type_mismatch=${call_type_mismatch:-0}
    rm -f "$pattern_file"
fi
rm -f "$struct_fn_all"

# 6. load_type_mismatch: load i64 from alloca ptr or alloca %StructType
#    Use awk to track alloca types and find mismatched loads.
load_type_mismatch=$(awk '
/= alloca ptr/ {
    # Extract variable name
    sub(/^[[:space:]]+/, "")
    split($0, a, " ")
    gsub(/%/, "", a[1])
    vars[a[1]] = 1
}
/= alloca %/ {
    sub(/^[[:space:]]+/, "")
    split($0, a, " ")
    gsub(/%/, "", a[1])
    vars[a[1]] = 1
}
/load i64, ptr %/ {
    # Extract the variable being loaded from
    idx = index($0, "load i64, ptr %")
    rest = substr($0, idx + 15)
    # Get variable name (alphanumeric + _ + .)
    gsub(/[^a-zA-Z0-9_.].*/, "", rest)
    if (rest in vars) count++
}
END { print count+0 }
' "$IR")

# 7. Total function count
total_functions=$(grep -c -E '^define ' "$IR" || true)
total_functions=${total_functions:-0}

# 8. Functions with empty bodies (just ret 0/undef/void, no real instructions)
empty_functions=$(awk '
/^define / { in_fn=1; lines=0; has_ret_trivial=0; next }
in_fn && /^}/ {
    if (lines <= 2 && has_ret_trivial) empty++
    in_fn=0; next
}
in_fn {
    lines++
    if ($0 ~ /ret .* 0$/ || $0 ~ /ret .* undef/ || $0 ~ /ret void/) has_ret_trivial=1
}
END { print empty+0 }
' "$IR")

# Calculate score (weighted sum)
score=$(( br_i1_false * 3 + null_operands * 10 + struct_as_i64 * 5 + call_type_mismatch * 1 + load_type_mismatch * 1 ))

printf "br_i1_false:       %4d\n" "$br_i1_false"
printf "null_operands:     %4d\n" "$null_operands"
printf "ret_undef:         %4d\n" "$ret_undef"
printf "struct_as_i64:     %4d\n" "$struct_as_i64"
printf "call_type_mismatch:%4d\n" "$call_type_mismatch"
printf "load_type_mismatch:%4d\n" "$load_type_mismatch"
printf "total_functions:   %4d\n" "$total_functions"
printf "empty_functions:   %4d\n" "$empty_functions"
printf "SCORE: %d/1000  (lower is better)\n" "$score"
