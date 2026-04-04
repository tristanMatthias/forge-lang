#!/bin/bash
# ═══════════════════════════════════════════════════════════════════
# Forge Self-Hosting Diagnostic System
# ═══════════════════════════════════════════════════════════════════
# Run: bash scripts/diagnose.sh [output.ll]
# Checks EVERYTHING that could prevent Stage 2 from compiling.
# Add new checks here whenever you discover a new class of issue.
# ═══════════════════════════════════════════════════════════════════

set -o pipefail
IR="${1:-output.ll}"
FORGE_SRC="packages/forgec/src"
RUST_FEATURES="packages/forgec-rust/features"
CODEGEN="packages/forgec/src/codegen/mod.fg"
RUNTIME="stdlib/runtime.c"
ERRORS=0
WARNINGS=0

red() { printf "\033[31m%s\033[0m\n" "$1"; }
yellow() { printf "\033[33m%s\033[0m\n" "$1"; }
green() { printf "\033[32m%s\033[0m\n" "$1"; }
err() { red "  ✗ $1"; ERRORS=$((ERRORS + 1)); }
warn() { yellow "  ⚠ $1"; WARNINGS=$((WARNINGS + 1)); }
ok() { green "  ✓ $1"; }

echo "═══════════════════════════════════════════════════════"
echo " Forge Self-Hosting Diagnostics"
echo "═══════════════════════════════════════════════════════"

# ─── 1. IR EXISTS AND HAS CONTENT ────────────────────────────────
echo ""
echo "── 1. IR File ──"
if [ ! -f "$IR" ]; then
    err "IR file not found: $IR"
    echo ""
    echo "TOTAL: $ERRORS errors, $WARNINGS warnings"
    exit 1
fi
LINES=$(wc -l < "$IR")
FUNS=$(grep -c '^define' "$IR")
if [ "$FUNS" -lt 100 ]; then
    err "Only $FUNS functions (expected 380+) — compilation likely failed"
else
    ok "$FUNS functions, $LINES lines"
fi

# ─── 2. IR QUALITY (audit) ───────────────────────────────────────
echo ""
echo "── 2. IR Quality ──"
BR_FALSE=$(grep -c "br i1 false" "$IR" 2>/dev/null || echo 0)
NULL_OPS=$(grep -c "null operand" "$IR" 2>/dev/null || echo 0)
RET_UNDEF=$(grep -c "ret.*undef" "$IR" 2>/dev/null || echo 0)

[ "$BR_FALSE" -gt 0 ] && err "br_i1_false: $BR_FALSE (broken null checks or comparisons)" || ok "br_i1_false: 0"
[ "${NULL_OPS:-0}" -gt 0 ] && err "null_operands: $NULL_OPS (missing values in calls)" || ok "null_operands: 0"
[ "$RET_UNDEF" -gt 0 ] && warn "ret_undef: $RET_UNDEF (missing return values)" || ok "ret_undef: 0"

# Which functions have the most br_i1_false?
if [ "$BR_FALSE" -gt 0 ]; then
    echo "    Top br_i1_false functions:"
    python3 -c "
import re
with open('$IR') as f:
    lines = f.readlines()
fn = ''
counts = {}
for line in lines:
    m = re.match(r'define .* @(\w+)', line)
    if m: fn = m.group(1)
    if 'br i1 false' in line: counts[fn] = counts.get(fn, 0) + 1
for f, c in sorted(counts.items(), key=lambda x: -x[1])[:5]:
    print(f'      {c:3d}  {f}')
" 2>/dev/null
fi

# ─── 3. STRUCT TYPE CONSISTENCY ──────────────────────────────────
echo ""
echo "── 3. Struct Types ──"

# Check that key structs have correct field counts
check_struct() {
    local name="$1"
    local expected_min="$2"
    local ty=$(grep "^%${name} = type" "$IR" 2>/dev/null)
    if [ -z "$ty" ]; then
        warn "%${name} not defined as named type"
        return
    fi
    # Count fields (commas + 1, roughly)
    local fields=$(echo "$ty" | tr -cd ',' | wc -c)
    fields=$((fields + 1))
    if [ "$fields" -lt "$expected_min" ]; then
        err "%${name} has $fields fields (expected $expected_min+): $ty"
    else
        ok "%${name}: $fields fields"
    fi
}

check_struct "Lexer" 6
check_struct "Parser" 4
check_struct "Span" 4
check_struct "Token" 6    # kind(enum) + span(4) + text(2) + kind_id(1) = at least 6 slots
check_struct "Codegen" 3
check_struct "ForgeString" 2

# Check that Token.kind_id is at a reasonable offset
TOKEN_TYPE=$(grep "^%Token = type" "$IR" 2>/dev/null)
if echo "$TOKEN_TYPE" | grep -q "{ i64, i64, %ForgeString, i64 }"; then
    err "Token type is { i64, i64, %ForgeString, i64 } — Span field not expanded (kind_id at wrong offset)"
fi

# ─── 4. FUNCTION SIGNATURE CONSISTENCY ───────────────────────────
echo ""
echo "── 4. Function Signatures ──"

# Self params should be ptr (not struct value)
SELF_BY_VALUE=$(grep "^define.*@[A-Z][a-z]*_[a-z].*(%[A-Z]" "$IR" 2>/dev/null | grep -v "(ptr" | head -5)
if [ -n "$SELF_BY_VALUE" ]; then
    COUNT=$(grep "^define.*@[A-Z][a-z]*_[a-z].*(%[A-Z]" "$IR" 2>/dev/null | grep -v "(ptr" | wc -l)
    err "$COUNT methods pass self by value instead of ptr"
    echo "$SELF_BY_VALUE" | head -3 | while read -r line; do
        echo "      $(echo "$line" | sed 's/{$//')"
    done
else
    ok "All methods pass self by ptr"
fi

# Check for functions returning undef
UNDEF_FUNS=$(python3 -c "
import re
with open('$IR') as f:
    lines = f.readlines()
fn = ''
undef_fns = set()
for line in lines:
    m = re.match(r'define .* @(\w+)', line)
    if m: fn = m.group(1)
    if 'ret' in line and 'undef' in line: undef_fns.add(fn)
print(len(undef_fns))
" 2>/dev/null)
[ "$UNDEF_FUNS" -gt 0 ] && warn "$UNDEF_FUNS functions return undef on some path" || ok "No functions return undef"

# ─── 5. RUNTIME FUNCTION COMPLETENESS ────────────────────────────
echo ""
echo "── 5. Runtime Functions ──"

# 5a. Used in Forge source but not registered in Rust compiler
MISSING_RUST=0
for fn in $(grep -roh 'forge_[a-z_]*(' "$FORGE_SRC" 2>/dev/null | sed 's/($//' | sort -u); do
    case "$fn" in
        forge_llvm_*|forge_parser_*|forge_set_token_list|forge_peek_kind_id|forge_extract_body_source) continue ;;
        forge_mini_*|forge_free|forge_set_args) continue ;;
        forge_string_len|forge_string_method|forge_fs_write_string|forge_write_lines|forge_join_lines) continue ;;
    esac
    if ! grep -rq "\"$fn\"" "$RUST_FEATURES" 2>/dev/null; then
        err "forge fn not registered in Rust: $fn"
        MISSING_RUST=$((MISSING_RUST + 1))
    fi
done
[ "$MISSING_RUST" -eq 0 ] && ok "All forge_* functions registered in Rust compiler"

# 5b. Used in Forge source but not declared in self-hosted codegen
MISSING_CODEGEN=0
for fn in $(grep -roh 'forge_[a-z_]*(' "$FORGE_SRC" 2>/dev/null | sed 's/($//' | sort -u); do
    case "$fn" in
        forge_llvm_*|forge_parser_*|forge_set_token_list|forge_peek_kind_id|forge_extract_body_source) continue ;;
        forge_mini_*|forge_free|forge_set_args) continue ;;
        forge_string_len|forge_string_method|forge_fs_write_string|forge_write_lines|forge_join_lines) continue ;;
    esac
    if ! grep -q "\"$fn\"" "$CODEGEN" 2>/dev/null; then
        # Check if it's declared via add_function in codegen
        if ! grep -q "$fn" "$IR" 2>/dev/null; then
            err "forge fn not in Stage 2 IR: $fn"
            MISSING_CODEGEN=$((MISSING_CODEGEN + 1))
        fi
    fi
done
[ "$MISSING_CODEGEN" -eq 0 ] && ok "All forge_* functions declared in Stage 2 IR"

# ─── 6. GLOBAL VARIABLE TYPES ────────────────────────────────────
echo ""
echo "── 6. Global Variables ──"
I64_GLOBALS=$(grep "^@.*= global i64" "$IR" 2>/dev/null | wc -l)
STR_GLOBALS=$(grep "^@.*= global %ForgeString" "$IR" 2>/dev/null | wc -l)
TOTAL_GLOBALS=$((I64_GLOBALS + STR_GLOBALS))
echo "    i64 globals: $I64_GLOBALS, ForgeString globals: $STR_GLOBALS"
if [ "$STR_GLOBALS" -eq 0 ] && [ "$TOTAL_GLOBALS" -gt 10 ]; then
    err "No ForgeString globals — all string globals are i64 (bitmask overflow?)"
fi

# Check known string globals have ForgeString type
for gname in MODULE_PATHS_CSV; do
    TYPE=$(grep "^@${gname} = global" "$IR" 2>/dev/null | head -1)
    if echo "$TYPE" | grep -q "global i64"; then
        err "@$gname is i64 (should be %ForgeString)"
    fi
done

# ─── 7. BREAK/CONTINUE CORRECTNESS ──────────────────────────────
echo ""
echo "── 7. Control Flow ──"

# Check that break produces actual branches (not just fallthrough)
BREAK_CALLS=$(grep -c "forge_loop_break" "$IR" 2>/dev/null || echo 0)
WHILE_LOOPS=$(grep -c "forge_loop_push" "$IR" 2>/dev/null || echo 0)
echo "    While loops: $WHILE_LOOPS, Break calls: $BREAK_CALLS"
if [ "$WHILE_LOOPS" -gt 0 ] && [ "$BREAK_CALLS" -eq 0 ]; then
    warn "While loops exist but no break calls — break may be swallowed"
fi

# Check for empty Statement.Break/Continue handlers
EMPTY_BREAK=$(grep -c '\.Break.*-> {}' "$CODEGEN" 2>/dev/null || echo 0)
EMPTY_CONTINUE=$(grep -c '\.Continue.*-> {}' "$CODEGEN" 2>/dev/null || echo 0)
[ "${EMPTY_BREAK:-0}" -gt 0 ] && err "$EMPTY_BREAK empty Break handlers in codegen" || ok "No empty Break handlers"
[ "${EMPTY_CONTINUE:-0}" -gt 0 ] && err "$EMPTY_CONTINUE empty Continue handlers in codegen" || ok "No empty Continue handlers"

# ─── 8. AST COMPLETENESS ────────────────────────────────────────
echo ""
echo "── 8. AST Completeness ──"

# Check that all Expr variants are handled in emit_expr_inner
for variant in IntLit FloatLit StringLit BoolLit NullLit Ident Binary Unary Call MemberAccess Index Block IfExpr MatchExpr Feature; do
    if ! grep -q "\.$variant" "$CODEGEN" 2>/dev/null; then
        err "Expr.$variant not handled in codegen"
    fi
done
ok "All Expr variants referenced in codegen"

# Check that all Statement variants are handled
for variant in Expr Assign Return Let If Match While For Break Continue Feature; do
    COUNT=$(grep -c "\.$variant(" "$CODEGEN" 2>/dev/null || echo 0)
    if [ "$COUNT" -lt 2 ]; then
        warn "Statement.$variant only referenced $COUNT times (expected 2+ for dual codegen paths)"
    fi
done

# ─── 9. DUPLICATE/MISSING CODEGEN PATHS ─────────────────────────
echo ""
echo "── 9. Codegen Paths ──"
EMIT_STMT_COUNT=$(grep -c "fn emit_statement" "$CODEGEN" 2>/dev/null || echo 0)
echo "    emit_statement definitions: $EMIT_STMT_COUNT"
[ "$EMIT_STMT_COUNT" -gt 1 ] && warn "Multiple emit_statement — ensure ALL variants handled in BOTH"

# Check for empty match arms that silently swallow behavior
EMPTY_ARMS=$(grep -c '-> {}' "$CODEGEN" 2>/dev/null || echo 0)
[ "$EMPTY_ARMS" -gt 5 ] && warn "$EMPTY_ARMS empty match arms '-> {}' in codegen (potential silent bugs)"

# ─── 10. MUTABLE GLOBALS ────────────────────────────────────────
echo ""
echo "── 10. Forge Globals ──"
NON_LLVM_GLOBALS=$(grep -c '^export mut \|^mut ' "$CODEGEN" 2>/dev/null || echo 0)
LLVM_GLOBALS=$(grep '^export mut \|^mut ' "$CODEGEN" 2>/dev/null | grep -c 'CG_B\|CG_CTX\|CG_MOD\|CG_I64\|CG_I32\|CG_I8\|CG_VOID\|CG_PTR\|CG_F64\|CG_STR\|CG_LIST\|CG_RT_' || echo 0)
REAL_GLOBALS=$((NON_LLVM_GLOBALS - LLVM_GLOBALS))
echo "    Total mut globals: $NON_LLVM_GLOBALS (LLVM infra: $LLVM_GLOBALS, other: $REAL_GLOBALS)"
[ "$REAL_GLOBALS" -gt 5 ] && warn "$REAL_GLOBALS non-LLVM mutable globals in codegen"

# ─── 11. BRITTLE PATTERNS ───────────────────────────────────────
echo ""
echo "── 11. Code Quality ──"

# Check for single-char string matching
CHAR_MATCH=$(grep -n '\[0\] ==' "$CODEGEN" "$FORGE_SRC/features/functions/mod.fg" 2>/dev/null | grep -v '//' | wc -l)
[ "$CHAR_MATCH" -gt 0 ] && warn "$CHAR_MATCH brittle [0]== char checks" || ok "No brittle char matching"

# Check for CSV globals
CSV_GLOBALS=$(grep -c 'mut.*CSV.*string\|CSV.*=.*""' "$CODEGEN" 2>/dev/null || echo 0)
[ "${CSV_GLOBALS:-0}" -gt 0 ] && warn "$CSV_GLOBALS CSV string globals remain" || ok "No CSV globals"

# Check for ptr != null (broken pattern)
PTR_NULL=$(grep -c '!= null' "$CODEGEN" "$FORGE_SRC/features/functions/mod.fg" 2>/dev/null || echo 0)
[ "${PTR_NULL:-0}" -gt 0 ] && warn "$PTR_NULL '!= null' checks (may produce br i1 false in Stage 2)" || ok "No != null checks"

# ─── 12. STAGE 2 BINARY TEST (if binary exists) ─────────────────
echo ""
echo "── 12. Stage 2 Binary ──"
if [ -f "build/stage2" ]; then
    echo 'fn main() { println("hello") }' > /tmp/forge_diag_test.fg
    OUTPUT=$(build/stage2 build /tmp/forge_diag_test.fg 2>&1 &
    PID=$!
    sleep 8
    if kill -0 $PID 2>/dev/null; then
        kill $PID 2>/dev/null
        wait $PID 2>/dev/null
        echo "TIMEOUT"
    else
        wait $PID 2>/dev/null
        echo "DONE"
    fi)

    if echo "$OUTPUT" | grep -q "TIMEOUT"; then
        err "Stage 2 hangs (infinite loop)"
    elif echo "$OUTPUT" | grep -q "segmentation fault"; then
        CRASH_AT=$(echo "$OUTPUT" | grep -A5 "segmentation fault" | grep "stage2" | head -1 | sed 's/.*stage2 *//' | awk '{print $1}')
        err "Stage 2 crashes at: $CRASH_AT"
    fi

    # Check milestones
    echo "$OUTPUT" | grep -q "M:cmd=" && ok "Stage 2: args parsed" || err "Stage 2: args not parsed"
    echo "$OUTPUT" | grep -q "read.*bytes" && ok "Stage 2: file read" || err "Stage 2: file not read"
    echo "$OUTPUT" | grep -q "lexer_new src_len=" && ok "Stage 2: lexer created" || warn "Stage 2: no lexer"
    echo "$OUTPUT" | grep -q "\[SCAN\] lex" && ok "Stage 2: tokenization" || warn "Stage 2: no tokenization"
    echo "$OUTPUT" | grep -q "\[SCAN\] parse" && ok "Stage 2: parsing" || warn "Stage 2: no parsing"

    FNS=$(echo "$OUTPUT" | grep "scanned.*fns" | grep -o '[0-9]* fns' | head -1)
    if [ -n "$FNS" ]; then
        NUM=$(echo "$FNS" | grep -o '^[0-9]*')
        [ "$NUM" -gt 0 ] && ok "Stage 2: $FNS scanned" || err "Stage 2: 0 fns scanned"
    fi

    echo "$OUTPUT" | grep -q "declared.*fns" && ok "Stage 2: functions declared" || warn "Stage 2: no declarations"
    echo "$OUTPUT" | grep -q "emit done\|compiled" && ok "Stage 2: compilation done" || warn "Stage 2: compilation incomplete"

    rm -f /tmp/forge_diag_test.fg
else
    warn "Stage 2 binary not found — run: make stage1-rust && build stage2"
fi

# ─── SUMMARY ────────────────────────────────────────────────────
echo ""
echo "═══════════════════════════════════════════════════════"
if [ "$ERRORS" -eq 0 ] && [ "$WARNINGS" -eq 0 ]; then
    green "ALL CLEAR — no issues found"
elif [ "$ERRORS" -eq 0 ]; then
    yellow "WARNINGS: $WARNINGS (no blocking errors)"
else
    red "ERRORS: $ERRORS, WARNINGS: $WARNINGS"
fi
echo "═══════════════════════════════════════════════════════"
exit $ERRORS
