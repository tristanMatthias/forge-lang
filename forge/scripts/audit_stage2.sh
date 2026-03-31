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

# 5. call_type_mismatch: calls to struct-param functions that pass i64 where struct expected.
#    Only counts calls with actual type mismatches, not all calls to struct-param functions.
call_type_mismatch=$(python3 -c "
import re, sys

def parse_arg_types(args_text):
    '''Extract top-level argument types, ignoring types inside struct literal values.'''
    types = []
    depth = 0
    i = 0
    while i < len(args_text):
        c = args_text[i]
        if c == '{': depth += 1
        elif c == '}': depth -= 1
        elif depth == 0 and c == ',':
            # At a top-level comma — skip to next arg
            i += 1
            continue
        # At depth 0, try to match a type token at current position
        if depth == 0:
            rest = args_text[i:]
            m = re.match(r'(%[A-Z]\w*|\{ [^}]+ \}|ptr|i64|i32|i8|i1|double)\s', rest)
            if m:
                types.append(m.group(1))
                # Skip past this arg entirely (to next comma)
                while i < len(args_text) and args_text[i] != ',' and not (args_text[i] == ')'):
                    if args_text[i] == '{':
                        depth2 = 1
                        i += 1
                        while i < len(args_text) and depth2 > 0:
                            if args_text[i] == '{': depth2 += 1
                            elif args_text[i] == '}': depth2 -= 1
                            i += 1
                        continue
                    i += 1
                continue
        i += 1
    return types

fn_params = {}
with open(sys.argv[1]) as f:
    for line in f:
        m = re.match(r'(?:define|declare) \S+ @(\w+)\(([^)]*)\)', line)
        if m:
            name = m.group(1)
            params = m.group(2)
            types = re.findall(r'(%[A-Z]\w*|\{ [^}]+ \}|ptr|i64|i32|i8|i1|double|void)', params)
            if any(t.startswith('%') or t.startswith('{') for t in types):
                fn_params[name] = types

count = 0
with open(sys.argv[1]) as f:
    for line in f:
        if 'call ' not in line: continue
        m = re.search(r'@(\w+)\(([^)]*)\)', line)
        if m and m.group(1) in fn_params:
            declared = fn_params[m.group(1)]
            args = parse_arg_types(m.group(2))
            for i, (arg_ty, decl_ty) in enumerate(zip(args, declared)):
                if arg_ty == 'i64' and (decl_ty.startswith('%') or decl_ty.startswith('{')):
                    count += 1
                    break
print(count)
" "$IR" 2>/dev/null || echo 0)

# 6. load_type_mismatch: load i64 from alloca ptr or alloca %StructType
#    Use awk to track alloca types and find mismatched loads.
load_type_mismatch=$(awk '
/^define / {
    # Reset per-function tracking
    delete vars
}
/= alloca ptr/ {
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
    idx = index($0, "load i64, ptr %")
    rest = substr($0, idx + 15)
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
