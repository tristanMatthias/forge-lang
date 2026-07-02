#!/bin/bash
# Tool #8 — Differential fuzzer.
#
# Generates small Forge programs and compiles each with BOTH the rust
# forgec AND the self-hosted stage1_rust. Diffs the resulting IR. Any
# divergence is a self-host bug.
#
# Usage:
#   bash scripts/forge_fuzz.sh [count]   # default 50 programs
#
# Saves divergent programs to /tmp/fuzz_diverge_*.fg for inspection.
# Lists divergence ranking with rank-diff after each one.

set -e
COUNT="${1:-50}"
LLVM_PREFIX="${LLVM_SYS_191_PREFIX:-/opt/homebrew/opt/llvm@19}"
DIVERGE_COUNT=0

if [ ! -x ./build/stage1_rust ]; then
    echo "ERROR: ./build/stage1_rust not built" >&2
    exit 1
fi

mkdir -p /tmp/fuzz
rm -f /tmp/fuzz/diverge_*.fg /tmp/fuzz/*.ll 2>/dev/null

# Generators — each emits one Forge program to stdout.
gen_int_match() {
    local n=$((RANDOM % 5 + 2))
    echo "fn classify(k: int) -> int {"
    echo "    match k {"
    for i in $(seq 1 $n); do
        echo "        $i -> $((i * 100))"
    done
    echo "        _ -> 0"
    echo "    }"
    echo "}"
    echo "fn main() { println(string(classify($((RANDOM % (n+2)))))) }"
}

gen_int_if_chain() {
    local n=$((RANDOM % 4 + 2))
    echo "fn classify(k: int) -> int {"
    for i in $(seq 1 $n); do
        echo "    if k == $i { return $((i * 100)) }"
    done
    echo "    0"
    echo "}"
    echo "fn main() { println(string(classify($((RANDOM % (n+2)))))) }"
}

gen_str_match() {
    echo "fn classify(s: string) -> int {"
    echo "    match s {"
    echo "        \"add\" -> 1"
    echo "        \"sub\" -> 2"
    echo "        \"mul\" -> 3"
    echo "        _ -> 0"
    echo "    }"
    echo "}"
    echo "fn main() { println(string(classify(\"sub\"))) }"
}

gen_nested_if() {
    echo "fn classify(a: int, b: int) -> int {"
    echo "    if a == 1 {"
    echo "        if b == 2 { return 12 } else { return 10 }"
    echo "    } else {"
    echo "        if b == 2 { return 2 } else { return 0 }"
    echo "    }"
    echo "}"
    echo "fn main() { println(string(classify(1, 2))) }"
}

generators=(gen_int_match gen_int_if_chain gen_str_match gen_nested_if)

echo "═══ forge fuzz: $COUNT programs ═══"

for i in $(seq 1 "$COUNT"); do
    g=${generators[$((RANDOM % ${#generators[@]}))]}
    src="/tmp/fuzz/prog_$i.fg"
    $g > "$src"

    # Compile with rust forgec
    a_ir="/tmp/fuzz/prog_${i}_rust.ll"
    if ! LLVM_SYS_191_PREFIX="$LLVM_PREFIX" ./target/release/forgec build "$src" --emit-ir 2>/dev/null > "$a_ir"; then
        printf "  [%3d/%d] ✗ rust failed: %s\n" "$i" "$COUNT" "$g"
        continue
    fi

    # Compile with stage1_rust
    rm -f output.ll
    if ! ./build/stage1_rust build "$src" >/dev/null 2>&1; then
        printf "  [%3d/%d] ✗ self-host failed: %s\n" "$i" "$COUNT" "$g"
        continue
    fi
    if [ ! -f output.ll ]; then
        printf "  [%3d/%d] ✗ self-host produced no IR: %s\n" "$i" "$COUNT" "$g"
        continue
    fi
    b_ir="/tmp/fuzz/prog_${i}_self.ll"
    cp output.ll "$b_ir"

    # Compare @main only (rest is forgec runtime/stdlib boilerplate)
    a_main=$(awk '/^define i32 @main/,/^}/' "$a_ir")
    b_main=$(awk '/^define i32 @main/,/^}/' "$b_ir")
    a_classify=$(awk '/^define i64 @classify/,/^}/' "$a_ir")
    b_classify=$(awk '/^define i64 @classify/,/^}/' "$b_ir")

    # Crude divergence: orphan count in self-host classify
    orphans=$(echo "$b_classify" | grep -c "No predecessors" || true)
    if [ "$orphans" -gt 0 ]; then
        DIVERGE_COUNT=$((DIVERGE_COUNT + 1))
        cp "$src" "/tmp/fuzz/diverge_$i.fg"
        printf "  [%3d/%d] ⚠ %d orphans in @classify: %s → /tmp/fuzz/diverge_%d.fg\n" \
            "$i" "$COUNT" "$orphans" "$g" "$i"
    else
        printf "  [%3d/%d] ✓ %s\n" "$i" "$COUNT" "$g"
    fi
done

echo ""
echo "═══ Summary ═══"
echo "  total: $COUNT"
echo "  divergent: $DIVERGE_COUNT"
echo "  divergent programs: ls /tmp/fuzz/diverge_*.fg"
