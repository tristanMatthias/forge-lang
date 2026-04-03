#!/bin/bash
# Stage 2 Functional Progress Tracker
# Tests Stage 2 binary on hello world, then on itself
set -o pipefail

STAGE2=build/stage2
HELLO=/tmp/stage2_hello.fg
SOURCE=packages/forgec/src/main.fg
LLC=/opt/homebrew/opt/llvm@18/bin/llc

echo 'fn main() { println("hello from stage 2!") }' > "$HELLO"

pass() { printf "  [\033[32m✓\033[0m] %s\n" "$1"; }
fail() { printf "  [\033[31m✗\033[0m] %s — %s\n" "$1" "$2"; }
skip() { printf "  [ ] %s\n" "$1"; }

echo "=== Stage 2 → Hello World ==="
hw_score=0

# 1. Binary runs
if [ ! -f "$STAGE2" ]; then fail "1. Binary exists" "not found"; exit 1; fi
out=$($STAGE2 2>&1 | head -1)
if echo "$out" | grep -q "forgec\|Usage"; then
    pass "1. Binary runs"; hw_score=$((hw_score+1))
else
    fail "1. Binary runs" "no output";
fi

# 2-11: Compile hello world
hw_out=$($STAGE2 build "$HELLO" 2>&1)
hw_exit=$?

# 2. Reads file
if echo "$hw_out" | grep -q "read [1-9]"; then
    pass "2. Reads input file"; hw_score=$((hw_score+1))
else fail "2. Reads input file" "fs.read failed"; fi

# 3. Tokenizes
if echo "$hw_out" | grep -q "lexer_new src_len"; then
    pass "3. Tokenizes"; hw_score=$((hw_score+1))
else fail "3. Tokenizes" "no lexer output"; fi

# 4. Scans functions
fns=$(echo "$hw_out" | grep -o "scanned.*[0-9]* fns" | grep -o "[0-9]* fns" | head -1)
fn_count=$(echo "$fns" | grep -o "^[0-9]*")
if [ -n "$fn_count" ] && [ "$fn_count" -gt 0 ] 2>/dev/null; then
    pass "4. Scans functions ($fns)"; hw_score=$((hw_score+1))
else fail "4. Scans functions" "${fns:-no scan output}"; fi

# 5. LLVM init
if echo "$hw_out" | grep -q "codegen_init\|declare.*fns\|\[P2:1\]"; then
    pass "5. LLVM init"; hw_score=$((hw_score+1))
else fail "5. LLVM init" "crashed before init"; fi

# 6. Declares functions
decl=$(echo "$hw_out" | grep "declared.*fns")
if [ -n "$decl" ]; then
    pass "6. Declares functions ($decl)"; hw_score=$((hw_score+1))
else fail "6. Declares functions" "no declaration output"; fi

# 7. Emits bodies
if echo "$hw_out" | grep -q "emit done\|>> [0-9]"; then
    pass "7. Emits function bodies"; hw_score=$((hw_score+1))
else fail "7. Emits function bodies" "no emit output"; fi

# 8. Writes IR
if echo "$hw_out" | grep -q "compiled:"; then
    pass "8. Writes output"; hw_score=$((hw_score+1))
else fail "8. Writes output" "no compiled output"; fi

# 9. llc compiles
if [ -f output.ll ] && $LLC -O0 -filetype=obj output.ll -o /tmp/stage3_hello.o 2>/dev/null; then
    pass "9. llc compiles output"; hw_score=$((hw_score+1))
else fail "9. llc compiles output" "llc failed or no output.ll"; fi

# 10. Links
if [ -f /tmp/stage3_hello.o ] && cc -o /tmp/stage3_hello /tmp/stage3_hello.o build/runtime.o -lm 2>/dev/null; then
    pass "10. Links"; hw_score=$((hw_score+1))
else fail "10. Links" "link failed"; fi

# 11. Runs correctly
if [ -f /tmp/stage3_hello ]; then
    hello_out=$(/tmp/stage3_hello 2>&1)
    if echo "$hello_out" | grep -q "hello from stage 2"; then
        pass "11. Prints hello!"; hw_score=$((hw_score+1))
    else fail "11. Prints hello" "wrong output: $hello_out"; fi
else skip "11. Prints hello"; fi

echo ""
echo "Hello world: $hw_score/11"

# Cleanup
rm -f /tmp/stage3_hello /tmp/stage3_hello.o "$HELLO"

echo ""
echo "=== Audit Score ==="
if [ -f build/stage2.ll ]; then
    bash scripts/audit_stage2.sh build/stage2.ll 2>&1 | tail -12
elif [ -f output.ll ] && grep -q "^define" output.ll; then
    bash scripts/audit_stage2.sh output.ll 2>&1 | tail -12
else
    echo "(no Stage 2 IR to audit)"
fi
