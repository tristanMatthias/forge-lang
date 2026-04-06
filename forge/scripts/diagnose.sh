#!/bin/bash
# ═══════════════════════════════════════════════════════════════════
# Forge Self-Hosting Diagnostic System
# ═══════════════════════════════════════════════════════════════════
# ONE script that checks everything. Run after EVERY change.
#
# Usage:
#   bash scripts/diagnose.sh [output.ll]     — full diagnostics
#   bash scripts/diagnose.sh --score         — just the IR score
#   bash scripts/diagnose.sh --stage2        — Stage 2 functional tests
#   bash scripts/diagnose.sh --kind-ids      — kind_id consistency only
#
# Add new checks here whenever you discover a new class of issue.
# ═══════════════════════════════════════════════════════════════════

set -o pipefail

# ─── Config ───────────────────────────────────────────────────────
IR="${1:-output.ll}"
MODE="full"
case "${1:-}" in
    --score)   MODE="score"; IR="${2:-output.ll}" ;;
    --stage2)  MODE="stage2" ;;
    --kind-ids) MODE="kind-ids" ;;
esac

FORGE_SRC="packages/forgec/src"
RUST_FEATURES="packages/forgec-rust/features"
CODEGEN="packages/forgec/src/codegen/mod.fg"
RUNTIME="stdlib/runtime.c"
KIND_IDS="packages/forgec/src/core/kind_ids.fg"
ERRORS=0
WARNINGS=0

red()    { printf "\033[31m%s\033[0m\n" "$1"; }
yellow() { printf "\033[33m%s\033[0m\n" "$1"; }
green()  { printf "\033[32m%s\033[0m\n" "$1"; }
err()    { red "  ✗ $1"; ERRORS=$((ERRORS + 1)); }
warn()   { yellow "  ⚠ $1"; WARNINGS=$((WARNINGS + 1)); }
ok()     { green "  ✓ $1"; }

# ═════════════════════════════════════════════════════════════════
# SCORE MODE — just the IR quality score
# ═════════════════════════════════════════════════════════════════
run_score() {
    if [ ! -f "$IR" ]; then echo "ERROR: $IR not found" >&2; exit 1; fi

    echo "=== Stage 2 IR Audit ==="

    br_i1_false=$(grep -c 'br i1 false' "$IR" || true)
    null_operands=$(grep -c '<null operand!>' "$IR" || true)
    ret_undef=$(grep -c -E 'ret .* undef' "$IR" || true)

    struct_as_i64=$(python3 -c "
import re, sys
BIG5 = {'%Statement', '%Expr', '%Token', '%Type', '%ForgeString'}
fn_params = {}
with open(sys.argv[1]) as f:
    for line in f:
        m = re.match(r'define \S+ @(\w+)\(([^)]*)\)', line)
        if m:
            name = m.group(1)
            params = m.group(2)
            types = re.findall(r'(%[A-Z]\w*|\{ [^}]+ \}|ptr|i64|i32|i8|i1|double|void)', params)
            if any(t in BIG5 for t in types):
                fn_params[name] = types
def parse_arg_types(args_text):
    types = []; depth = 0; i = 0
    while i < len(args_text):
        c = args_text[i]
        if c == '{': depth += 1
        elif c == '}': depth -= 1
        elif depth == 0 and c == ',': i += 1; continue
        if depth == 0:
            rest = args_text[i:]
            m = re.match(r'(%[A-Z]\w*|\{ [^}]+ \}|ptr|i64|i32|i8|i1|double)\s', rest)
            if m:
                types.append(m.group(1))
                while i < len(args_text) and args_text[i] != ',':
                    if args_text[i] == '{':
                        d = 1; i += 1
                        while i < len(args_text) and d > 0:
                            if args_text[i] == '{': d += 1
                            elif args_text[i] == '}': d -= 1
                            i += 1
                        continue
                    i += 1
                continue
        i += 1
    return types
count = 0
with open(sys.argv[1]) as f:
    for line in f:
        if 'call ' not in line: continue
        m = re.search(r'@(\w+)\(([^)]*)\)', line)
        if m and m.group(1) in fn_params:
            declared = fn_params[m.group(1)]
            args = parse_arg_types(m.group(2))
            for i2, (arg_ty, decl_ty) in enumerate(zip(args, declared)):
                if arg_ty == 'i64' and decl_ty in BIG5:
                    count += 1; break
print(count)
" "$IR" 2>/dev/null || echo 0)

    call_type_mismatch=$(python3 -c "
import re, sys
def parse_arg_types(args_text):
    types = []; depth = 0; i = 0
    while i < len(args_text):
        c = args_text[i]
        if c == '{': depth += 1
        elif c == '}': depth -= 1
        elif depth == 0 and c == ',': i += 1; continue
        if depth == 0:
            rest = args_text[i:]
            m = re.match(r'(%[A-Z]\w*|\{ [^}]+ \}|ptr|i64|i32|i8|i1|double)\s', rest)
            if m:
                types.append(m.group(1))
                while i < len(args_text) and args_text[i] != ',':
                    if args_text[i] == '{':
                        d2 = 1; i += 1
                        while i < len(args_text) and d2 > 0:
                            if args_text[i] == '{': d2 += 1
                            elif args_text[i] == '}': d2 -= 1
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
                    count += 1; break
print(count)
" "$IR" 2>/dev/null || echo 0)

    load_type_mismatch=$(awk '
/^define / { delete vars }
/= alloca ptr/ { sub(/^[[:space:]]+/, ""); split($0, a, " "); gsub(/%/, "", a[1]); vars[a[1]] = 1 }
/= alloca %/ { sub(/^[[:space:]]+/, ""); split($0, a, " "); gsub(/%/, "", a[1]); vars[a[1]] = 1 }
/load i64, ptr %/ { idx = index($0, "load i64, ptr %"); rest = substr($0, idx + 15); gsub(/[^a-zA-Z0-9_.].*/, "", rest); if (rest in vars) count++ }
END { print count+0 }
' "$IR")

    total_functions=$(grep -c -E '^define ' "$IR" || true)
    empty_functions=$(awk '
/^define / { in_fn=1; lines=0; has_ret=0; next }
in_fn && /^}/ { if (lines <= 2 && has_ret) empty++; in_fn=0; next }
in_fn { lines++; if ($0 ~ /ret .* 0$/ || $0 ~ /ret .* undef/ || $0 ~ /ret void/ || $0 ~ /ret .* zeroinitializer/) has_ret=1 }
END { print empty+0 }
' "$IR")

    score=$(( br_i1_false * 3 + null_operands * 10 + struct_as_i64 * 5 + call_type_mismatch * 1 + load_type_mismatch * 1 ))

    printf "br_i1_false:       %4d\n" "${br_i1_false:-0}"
    printf "null_operands:     %4d\n" "${null_operands:-0}"
    printf "ret_undef:         %4d\n" "${ret_undef:-0}"
    printf "struct_as_i64:     %4d\n" "${struct_as_i64:-0}"
    printf "call_type_mismatch:%4d\n" "${call_type_mismatch:-0}"
    printf "load_type_mismatch:%4d\n" "${load_type_mismatch:-0}"
    printf "total_functions:   %4d\n" "${total_functions:-0}"
    printf "empty_functions:   %4d\n" "${empty_functions:-0}"
    printf "SCORE: %d/1000  (lower is better)\n" "$score"
}

# ═════════════════════════════════════════════════════════════════
# KIND-IDS MODE — consistency check
# ═════════════════════════════════════════════════════════════════
run_kind_ids() {
    echo "═══════════════════════════════════════════════"
    echo " Kind ID Consistency Check"
    echo "═══════════════════════════════════════════════"

    if [ ! -f "$KIND_IDS" ]; then
        err "kind_ids.fg not found at $KIND_IDS"
        return
    fi

    # Extract all KID definitions
    TMPFILE=$(mktemp)
    grep "export mut KID_" "$KIND_IDS" | sed 's/.*KID_\([A-Z_]*\) *= *\([0-9]*\).*/\1 \2/' > "$TMPFILE"
    COUNT=$(wc -l < "$TMPFILE" | tr -d ' ')
    echo "    Found $COUNT kind_id definitions"

    # Check runtime.c keyword table
    echo ""
    echo "── Keywords vs runtime.c ──"
    declare -A KID_TO_KW
    KID_TO_KW[LET]="let" KID_TO_KW[MUT]="mut" KID_TO_KW[CONST]="const"
    KID_TO_KW[FN]="fn" KID_TO_KW[RETURN]="return" KID_TO_KW[IF]="if"
    KID_TO_KW[ELSE]="else" KID_TO_KW[MATCH]="match" KID_TO_KW[FOR]="for"
    KID_TO_KW[IN]="in" KID_TO_KW[WHILE]="while" KID_TO_KW[BREAK]="break"
    KID_TO_KW[CONTINUE]="continue" KID_TO_KW[ENUM]="enum" KID_TO_KW[TYPE]="type"
    KID_TO_KW[USE]="use" KID_TO_KW[MOD]="mod" KID_TO_KW[EXPORT]="export"
    KID_TO_KW[IMPL]="impl" KID_TO_KW[TRAIT]="trait" KID_TO_KW[IS]="is"
    KID_TO_KW[TABLE]="table"
    KW_MISS=0
    while read -r NAME VALUE; do
        KW="${KID_TO_KW[$NAME]:-}"
        [ -z "$KW" ] && continue
        if ! grep -q "KW(\"$KW\", $VALUE)" "$RUNTIME" 2>/dev/null; then
            err "KID_$NAME=$VALUE: keyword '$KW' not in runtime.c with ID $VALUE"
            KW_MISS=$((KW_MISS + 1))
        fi
    done < "$TMPFILE"
    [ "$KW_MISS" -eq 0 ] && ok "All keyword IDs match runtime.c"

    # Check lexer punctuation
    echo ""
    echo "── Punctuation vs lexer ──"
    declare -A KID_TO_CHAR
    KID_TO_CHAR[LPAREN]='(' KID_TO_CHAR[RPAREN]=')' KID_TO_CHAR[LBRACE]='{'
    KID_TO_CHAR[RBRACE]='}' KID_TO_CHAR[LBRACKET]='[' KID_TO_CHAR[RBRACKET]=']'
    KID_TO_CHAR[COMMA]=',' KID_TO_CHAR[COLON]=':' KID_TO_CHAR[SEMICOLON]=';'
    LEX_MISS=0
    while read -r NAME VALUE; do
        [ -z "${KID_TO_CHAR[$NAME]:-}" ] && continue
        if ! grep -q "kind_id: $VALUE" "packages/forgec/src/lexer/mod.fg" 2>/dev/null; then
            err "KID_$NAME=$VALUE: lexer doesn't assign kind_id $VALUE"
            LEX_MISS=$((LEX_MISS + 1))
        fi
    done < "$TMPFILE"
    [ "$LEX_MISS" -eq 0 ] && ok "All punctuation IDs match lexer"

    # Check for unknown kind_ids in parser
    echo ""
    echo "── Parser consistency ──"
    UNKNOWN=0
    for PFILE in "packages/forgec/src/parser/expressions.fg" "packages/forgec/src/parser/mod.fg"; do
        for ID in $(grep -oE "(kind_id|kid) == [0-9]+" "$PFILE" 2>/dev/null | grep -oE "[0-9]+$" | sort -un); do
            [ "$ID" -le 8 ] && continue
            if ! grep -q "= $ID\b" "$KIND_IDS" 2>/dev/null; then
                err "$PFILE uses kind_id $ID which is NOT defined in kind_ids.fg"
                UNKNOWN=$((UNKNOWN + 1))
            fi
        done
    done
    [ "$UNKNOWN" -eq 0 ] && ok "All parser kind_ids defined in kind_ids.fg"

    rm -f "$TMPFILE"
}

# ═════════════════════════════════════════════════════════════════
# STAGE2 MODE — functional tests
# ═════════════════════════════════════════════════════════════════
run_stage2() {
    STAGE2=build/stage2
    if [ ! -f "/tmp/stage2" ] && [ ! -f "$STAGE2" ]; then
        echo "No Stage 2 binary found. Build with:"
        echo "  /opt/homebrew/opt/llvm@18/bin/llc -O2 -filetype=obj output.ll -o /tmp/stage2.o"
        echo "  cc -o /tmp/stage2 /tmp/stage2.o build/runtime.o -lm -Wl,-stack_size,0x10000000 \\"
        echo "    packages/std-llvm/target/release/libforge_llvm.a \\"
        echo "    -L/opt/homebrew/Cellar/llvm@18/18.1.8/lib -lLLVM-18 -lstdc++ -lz -lcurses"
        return
    fi
    [ -f "/tmp/stage2" ] && STAGE2="/tmp/stage2"

    echo "═══════════════════════════════════════════════"
    echo " Stage 2 Functional Tests"
    echo "═══════════════════════════════════════════════"

    pass() { printf "  [\033[32m✓\033[0m] %s\n" "$1"; }
    fail() { printf "  [\033[31m✗\033[0m] %s — %s\n" "$1" "$2"; }

    echo ""
    echo "── Self-compile test ──"
    OUTPUT=$($STAGE2 build packages/forgec/src/main.fg 2>&1 || true)

    echo "$OUTPUT" | grep -q "M:cmd=" && pass "Args parsed" || fail "Args parsed" "no M:cmd="
    echo "$OUTPUT" | grep -q "read.*bytes" && pass "Files read" || fail "Files read" "no read output"
    echo "$OUTPUT" | grep -q "lexer_new src_len=" && pass "Lexer created" || fail "Lexer created" "no lexer"

    FNS=$(echo "$OUTPUT" | grep "scanned.*fns" | grep -o '[0-9]* fns' | head -1)
    FN_COUNT=$(echo "${FNS:-0 fns}" | grep -o '^[0-9]*')
    [ "${FN_COUNT:-0}" -gt 0 ] && pass "Scanned $FNS" || fail "Function scanning" "${FNS:-no scan output}"

    echo "$OUTPUT" | grep -q "declared.*fns\|declare_all" && pass "Functions declared" || fail "Functions declared" "no declarations"
    echo "$OUTPUT" | grep -q "emit done\|compiled" && pass "Compilation done" || fail "Compilation done" "incomplete"

    if echo "$OUTPUT" | grep -q "segmentation fault"; then
        CRASH=$(echo "$OUTPUT" | grep -A3 "segmentation fault" | grep "stage2\|0x" | head -3)
        fail "No crash" "segfault"
        echo "    Backtrace:"
        echo "$CRASH" | sed 's/^/      /'
    elif echo "$OUTPUT" | grep -q "error:"; then
        ERR=$(echo "$OUTPUT" | grep "error:" | head -1)
        fail "No errors" "$ERR"
    fi
}

# ═════════════════════════════════════════════════════════════════
# RUNTIME FN CHECK — functions used in .fg but not registered
# ═════════════════════════════════════════════════════════════════
run_runtime_fns() {
    echo ""
    echo "── Runtime Function Registration ──"
    MISSING=0
    for fn in $(grep -roh 'forge_[a-z_]*(' "$FORGE_SRC" 2>/dev/null | sed 's/($//' | sort -u); do
        case "$fn" in
            forge_llvm_*|forge_parser_*|forge_set_token_list|forge_peek_kind_id|forge_extract_body_source) continue ;;
            forge_mini_*|forge_free|forge_set_args) continue ;;
            forge_string_len|forge_string_method|forge_fs_write_string|forge_write_lines|forge_join_lines) continue ;;
        esac
        if ! grep -rq "\"$fn\"" "$RUST_FEATURES" 2>/dev/null; then
            err "forge fn not registered in Rust compiler: $fn"
            MISSING=$((MISSING + 1))
        fi
    done
    [ "$MISSING" -eq 0 ] && ok "All forge_* functions registered"
}

# ═════════════════════════════════════════════════════════════════
# FULL MODE — everything
# ═════════════════════════════════════════════════════════════════
run_full() {
    echo "═══════════════════════════════════════════════════════"
    echo " Forge Self-Hosting Diagnostics"
    echo "═══════════════════════════════════════════════════════"

    # ─── 1. IR file ─────────────────────────────────────────────
    echo ""
    echo "── 1. IR File ──"
    if [ ! -f "$IR" ]; then
        err "IR file not found: $IR"
        echo ""; red "ERRORS: $ERRORS"; exit 1
    fi
    FUNS=$(grep -c '^define' "$IR")
    LINES=$(wc -l < "$IR")
    [ "$FUNS" -lt 100 ] && err "Only $FUNS functions (expected 380+)" || ok "$FUNS functions, $LINES lines"

    # ─── 2. IR Quality Score ────────────────────────────────────
    echo ""
    echo "── 2. IR Quality ──"
    run_score

    # ─── 3. Struct Types ────────────────────────────────────────
    echo ""
    echo "── 3. Struct Types ──"
    check_struct() {
        local name="$1" expected="$2"
        local ty=$(grep "^%${name} = type" "$IR" 2>/dev/null)
        if [ -z "$ty" ]; then warn "%${name} not defined"; return; fi
        local fields=$(echo "$ty" | tr -cd ',' | wc -c); fields=$((fields + 1))
        [ "$fields" -lt "$expected" ] && err "%${name} has $fields fields (expected $expected+)" || ok "%${name}: $fields fields"
    }
    check_struct "Lexer" 6; check_struct "Parser" 4; check_struct "Span" 4
    check_struct "Token" 4; check_struct "Codegen" 3; check_struct "ForgeString" 2

    # ─── 4. Function Signatures ─────────────────────────────────
    echo ""
    echo "── 4. Function Signatures ──"
    SELF_BY_VALUE=$(grep "^define.*@[A-Z][a-z]*_[a-z].*(%[A-Z]" "$IR" 2>/dev/null | grep -v "(ptr" | wc -l | tr -d ' ')
    [ "$SELF_BY_VALUE" -gt 0 ] && err "$SELF_BY_VALUE methods pass self by value" || ok "All methods pass self by ptr"

    # ─── 5. Runtime Functions ───────────────────────────────────
    run_runtime_fns

    # ─── 6. Global Variables ────────────────────────────────────
    echo ""
    echo "── 6. Globals ──"
    I64_G=$(grep -c "^@.*= global i64" "$IR" 2>/dev/null || echo 0)
    STR_G=$(grep -c "^@.*= global %ForgeString" "$IR" 2>/dev/null || echo 0)
    echo "    i64: $I64_G, ForgeString: $STR_G"

    # ─── 7. Control Flow ───────────────────────────────────────
    echo ""
    echo "── 7. Control Flow ──"
    WHILE_LOOPS=$(grep -c "forge_loop_push" "$IR" 2>/dev/null || echo 0)
    BREAK_CALLS=$(grep -c "forge_loop_break" "$IR" 2>/dev/null || echo 0)
    echo "    While loops: $WHILE_LOOPS, Break calls: $BREAK_CALLS"

    # ─── 8. AST Completeness ──────────────────────────────────
    echo ""
    echo "── 8. AST Coverage ──"
    for v in IntLit FloatLit StringLit BoolLit NullLit Ident Binary Unary Call MemberAccess Index Block Feature; do
        grep -q "\.$v" "$CODEGEN" 2>/dev/null || err "Expr.$v not in codegen"
    done
    ok "Expr variants covered"

    # ─── 9. Critical Functions ─────────────────────────────────
    echo ""
    echo "── 9. Critical Functions ──"
    for fn in Lexer_tokenize Lexer_next_token Parser_parse_statement Codegen_emit_statement Codegen_emit_block Codegen_emit_expr; do
        BODY=$(grep -A5 "^define.*@${fn}(" "$IR" 2>/dev/null | head -6)
        if echo "$BODY" | grep -q "ret.*zeroinitializer"; then
            BODYLINES=$(echo "$BODY" | wc -l)
            [ "$BODYLINES" -le 4 ] && err "$fn has empty body"
        fi
    done
    TOTAL_FNS=$(grep -c "^define " "$IR" 2>/dev/null || echo 0)
    EMPTY=$(grep -B1 "ret.*zeroinitializer" "$IR" 2>/dev/null | grep "^define " | wc -l | tr -d ' ')
    echo "    Total: $TOTAL_FNS, with code: $((TOTAL_FNS - EMPTY)), empty: $EMPTY"
    [ "$EMPTY" -gt 50 ] && err "Too many empty functions ($EMPTY)"

    # ─── 10. Statement Tags ───────────────────────────────────
    echo ""
    echo "── 10. Statement Tags ──"
    TAGS=$(grep -A500 "^define.*@Codegen_emit_statement" "$IR" 2>/dev/null | grep "icmp eq.*%.*,[[:space:]]*[1-9]" | wc -l | tr -d ' ')
    [ "$TAGS" -ge 6 ] && ok "emit_statement: $TAGS tag checks" || err "emit_statement: only $TAGS tag checks (need >=6)"

    # ─── 11. Kind ID Consistency ──────────────────────────────
    run_kind_ids

    # ─── 12. Stage 2 Binary ───────────────────────────────────
    echo ""
    echo "── 12. Stage 2 Binary ──"
    if [ -f "/tmp/stage2" ] || [ -f "build/stage2" ]; then
        run_stage2
    else
        warn "No Stage 2 binary found"
    fi
}

# ═════════════════════════════════════════════════════════════════
# DISPATCH
# ═════════════════════════════════════════════════════════════════
case "$MODE" in
    score)    run_score ;;
    stage2)   run_stage2 ;;
    kind-ids) run_kind_ids ;;
    full)     run_full ;;
esac

# ─── Summary ──────────────────────────────────────────────────
if [ "$MODE" = "full" ] || [ "$MODE" = "kind-ids" ]; then
    echo ""
    echo "═══════════════════════════════════════════════════════"
    if [ "$ERRORS" -eq 0 ] && [ "$WARNINGS" -eq 0 ]; then
        green "ALL CLEAR"
    elif [ "$ERRORS" -eq 0 ]; then
        yellow "WARNINGS: $WARNINGS"
    else
        red "ERRORS: $ERRORS, WARNINGS: $WARNINGS"
    fi
    echo "═══════════════════════════════════════════════════════"
fi

exit $ERRORS
