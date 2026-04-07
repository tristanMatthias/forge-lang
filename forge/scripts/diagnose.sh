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
    --stage3)  MODE="stage3" ;;
    --pipeline) MODE="pipeline" ;;
    --kind-ids) MODE="kind-ids" ;;
    --source)  MODE="source" ;;
    --diff|--diff-fn)
        MODE="diff"; DIFF_FN="${2:-}";
        DIFF_A="${3:-/tmp/stage1.ll}"
        DIFF_B="${4:-/tmp/stage2.ll}"
        ;;
    --rank-diff)
        # Rank functions by IR diff size between stage1 and stage2
        MODE="rank-diff"
        DIFF_A="${2:-/tmp/stage1.ll}"
        DIFF_B="${3:-/tmp/stage2.ll}"
        ;;
    --cfg-summary)
        # #4 — CFG summary for one function in two .ll files. Prints
        # (num_blocks, num_orphans, num_phi, num_calls, num_returns,
        #  max_pred_count) side-by-side. Two-line semantic comparison
        # that surfaces structural divergences immediately.
        MODE="cfg-summary"
        DIFF_FN="${2:-}"
        DIFF_A="${3:-/tmp/stage1.ll}"
        DIFF_B="${4:-/tmp/stage2.ll}"
        ;;
    --orphans)
        # Print all functions that have orphan blocks, ranked.
        MODE="orphans"
        IR="${2:-/tmp/stage2.ll}"
        ;;
    --cfg)
        # #7 — Generate CFG dot+png for one function. Wraps
        # `opt -passes=dot-cfg`. Output: /tmp/cfg/<fn>.dot and .png.
        MODE="cfg"
        DIFF_FN="${2:-}"
        IR="${3:-/tmp/stage2.ll}"
        ;;
    --ir-sanity) MODE="ir-sanity"; IR="${2:-/tmp/output.ll}" ;;
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

    # Root cause metrics — undef arguments are the upstream cause of most issues
    undef_args=$(grep -c 'undef)' "$IR" || true)
    undef_length=$(grep -c 'forge_string_length(%ForgeString undef)' "$IR" || true)

    total_functions=$(grep -c -E '^define ' "$IR" || true)
    empty_functions=$(awk '
/^define / { in_fn=1; lines=0; has_ret=0; next }
in_fn && /^}/ { if (lines <= 2 && has_ret) empty++; in_fn=0; next }
in_fn { lines++; if ($0 ~ /ret .* 0$/ || $0 ~ /ret .* undef/ || $0 ~ /ret void/ || $0 ~ /ret .* zeroinitializer/) has_ret=1 }
END { print empty+0 }
' "$IR")

    score=$(( br_i1_false * 3 + null_operands * 10 + struct_as_i64 * 5 + call_type_mismatch * 1 + load_type_mismatch * 1 + undef_args * 1 ))

    printf "br_i1_false:       %4d\n" "${br_i1_false:-0}"
    printf "null_operands:     %4d\n" "${null_operands:-0}"
    printf "ret_undef:         %4d\n" "${ret_undef:-0}"
    printf "struct_as_i64:     %4d\n" "${struct_as_i64:-0}"
    printf "call_type_mismatch:%4d\n" "${call_type_mismatch:-0}"
    printf "load_type_mismatch:%4d\n" "${load_type_mismatch:-0}"
    printf "undef_args:        %4d\n" "${undef_args:-0}"
    printf "undef_length:      %4d\n" "${undef_length:-0}"
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
        echo "  /opt/homebrew/opt/llvm@19/bin/llc -O2 -filetype=obj output.ll -o /tmp/stage2.o"
        echo "  cc -o /tmp/stage2 /tmp/stage2.o build/runtime.o -lm -Wl,-stack_size,0x10000000 \\"
        echo "    packages/std-llvm/target/release/libforge_llvm.a \\"
        echo "    -L/opt/homebrew/Cellar/llvm@19/19.1.7/lib -lLLVM-19 -lstdc++ -lz -lcurses"
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

    # ─── 11. Undef Arguments ──────────────────────────────────
    echo ""
    echo "── 11. Undef Arguments ──"
    UNDEF_ARGS=$(grep -c "call.*undef" "$IR" 2>/dev/null || echo 0)
    if [ "$UNDEF_ARGS" -gt 0 ]; then
        err "$UNDEF_ARGS calls pass undef arguments (will crash at runtime)"
        # Show which functions have the most
        echo "    Top functions with undef args:"
        python3 -c "
import re
with open('$IR') as f:
    lines = f.readlines()
fn = ''
counts = {}
for line in lines:
    m = re.match(r'define .* @(\w+)', line)
    if m: fn = m.group(1)
    if 'call ' in line and 'undef' in line and 'zeroinitializer' not in line:
        counts[fn] = counts.get(fn, 0) + 1
for f, c in sorted(counts.items(), key=lambda x: -x[1])[:5]:
    print(f'      {c:3d}  {f}')
" 2>/dev/null
    else
        ok "No undef arguments in calls"
    fi

    # ─── 12. Kind ID Consistency ──────────────────────────────
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
# SOURCE MODE — static analysis of .fg source files
# ═════════════════════════════════════════════════════════════════
run_source() {
    echo "═══════════════════════════════════════════════"
    echo " Source-Level Checks"
    echo "═══════════════════════════════════════════════"

    # 1. Empty match arms in codegen (silent no-ops)
    echo ""
    echo "── Empty Match Arms (codegen/mod.fg) ──"
    EMPTY_ARMS=$(grep -cE '\-> \{[ ]*\}' "$CODEGEN" 2>/dev/null || echo 0)
    if [ "${EMPTY_ARMS:-0}" -gt 0 ]; then
        warn "$EMPTY_ARMS empty match arms found:"
        grep -nE '-> \{\s*\}' "$CODEGEN" 2>/dev/null | head -10 | sed 's/^/      /'
    else
        ok "No empty match arms"
    fi

    # 2. Magic numbers in parser files (should use KID_* constants)
    echo ""
    echo "── Magic Numbers in Parser ──"
    MAGIC=0
    for PFILE in "$FORGE_SRC"/parser/*.fg; do
        [ -f "$PFILE" ] || continue
        # kind_id == <number> where number > 8 (small numbers are valid enum tags)
        HITS=$(grep -cE 'kind_id == [0-9]{2,}' "$PFILE" 2>/dev/null || true)
        if [ "$HITS" -gt 0 ]; then
            warn "$(basename "$PFILE"): $HITS magic number comparisons"
            grep -nE 'kind_id == [0-9]{2,}' "$PFILE" 2>/dev/null | head -5 | sed 's/^/      /'
            MAGIC=$((MAGIC + HITS))
        fi
    done
    [ "$MAGIC" -eq 0 ] && ok "No magic numbers in parser"

    # 3. Undef argument breakdown by callee (shows WHERE types are lost)
    echo ""
    echo "── Undef Argument Breakdown ──"
    if [ -f "output.ll" ]; then IR="output.ll"; fi
    if [ -f "$IR" ]; then
        grep 'undef)' "$IR" | sed 's/.*@/@/' | sed 's/(.*//' | sort | uniq -c | sort -rn | head -10 | sed 's/^/    /'
        TOTAL=$(grep -c 'undef)' "$IR" || true)
        echo "    ────"
        echo "    Total: $TOTAL calls passing undef"
    else
        warn "No IR file to analyze"
    fi

    # 4. ret undef breakdown by return type
    echo ""
    echo "── Ret Undef Breakdown ──"
    if [ -f "$IR" ]; then
        grep 'ret.*undef' "$IR" | sed 's/.*ret //' | sort | uniq -c | sort -rn | head -10 | sed 's/^/    /'
    fi

    # 5. Missing enum variant field types (match bindings that fall through to default)
    echo ""
    echo "── Match Binding Coverage ──"
    # Check which Expr/Statement variants have hardcoded field types
    COVERED=$(grep -cE 'vn2 == "' "$CODEGEN" 2>/dev/null || true)
    echo "    $COVERED variant field types hardcoded in match handler"
    # List Expr variants from AST
    echo "    Expr variants in AST:"
    grep -E '^\s+\w+\(' "$FORGE_SRC/core/ast.fg" 2>/dev/null | sed 's/(.*//; s/^[[:space:]]*/      /' | head -20

    echo ""
}

# ═════════════════════════════════════════════════════════════════
# STAGE3 MODE — build and test stage 3 binary
# ═════════════════════════════════════════════════════════════════
run_stage3() {
    if [ ! -f "/tmp/stage2" ]; then
        echo "No /tmp/stage2 binary found. Run --stage2 or --pipeline first."
        return
    fi

    echo "═══════════════════════════════════════════════"
    echo " Stage 3 Build & Test"
    echo "═══════════════════════════════════════════════"

    pass() { printf "  [\033[32m✓\033[0m] %s\n" "$1"; }
    fail() { printf "  [\033[31m✗\033[0m] %s — %s\n" "$1" "$2"; }
    warn() { printf "  [\033[33m⚠\033[0m] %s — %s\n" "$1" "$2"; }

    echo ""
    echo "── Stage 2 → Stage 3 IR ──"
    ABS_SRC="$(pwd -P)/$FORGE_SRC/main.fg"
    pushd /tmp > /dev/null
    rm -f /tmp/output.ll
    /tmp/stage2 build "$ABS_SRC" >/tmp/_s3_out.log 2>&1 || true
    popd > /dev/null

    if [ ! -f /tmp/output.ll ]; then
        fail "Stage 3 IR produced" "no /tmp/output.ll"
        return
    fi

    SCANNED=$(grep "scanned.*fns" /tmp/_s3_out.log | head -1 | sed 's/^ *//')
    [ -n "$SCANNED" ] && pass "$SCANNED" || warn "Files scanned" "no scan output"

    if echo "$SCANNED" | grep -qE "[0-9]{2,} files"; then
        pass "Multi-file scan (≥10 files)"
    else
        warn "Multi-file scan" "single file scanned only"
    fi

    grep -q "emit done\|compiled" /tmp/_s3_out.log && pass "Stage 2 emit done" || fail "Stage 2 emit done" "missing"

    S3_FNS=$(grep -c '^define' /tmp/output.ll)
    pass "Stage 3 IR has $S3_FNS functions"

    echo ""
    echo "── Stage 3 IR Quality ──"
    bash "$0" --score /tmp/output.ll 2>&1 | grep -E "br_i1|undef|ret_undef|empty_functions|SCORE" | sed 's/^/    /'

    echo ""
    echo "── Stage 3 Binary Build ──"
    # MUST rm stale artifacts. Without this, a previous successful llc run
    # leaves /tmp/stage3.o behind and we falsely report "llc passed" while
    # actually using last week's object file.
    rm -f /tmp/stage3.o /tmp/stage3
    /opt/homebrew/opt/llvm@19/bin/llc -O2 -filetype=obj /tmp/output.ll -o /tmp/stage3.o 2>/tmp/_s3_llc.log
    if [ -s /tmp/stage3.o ] && ! grep -q "error:" /tmp/_s3_llc.log; then
        pass "llc → object file"
    else
        fail "llc → object file" "$(head -1 /tmp/_s3_llc.log)"
        return
    fi

    cc -o /tmp/stage3 /tmp/stage3.o build/runtime.o -lm -Wl,-stack_size,0x10000000 \
        packages/std-llvm/target/release/libforge_llvm.a \
        -L/opt/homebrew/Cellar/llvm@19/19.1.7/lib -lLLVM-19 -lstdc++ -lz -lcurses 2>/tmp/_s3_link.log
    if [ -x /tmp/stage3 ] && ! grep -q "error:" /tmp/_s3_link.log; then
        pass "cc → /tmp/stage3 executable"
    else
        fail "Linker" "$(head -1 /tmp/_s3_link.log)"
        return
    fi

    echo ""
    echo "── Stage 3 Run ──"
    /tmp/stage3 build "$FORGE_SRC/main.fg" >/tmp/_s3_runlog 2>&1
    EXIT=$?
    if [ "$EXIT" -eq 0 ]; then
        pass "Stage 3 exits 0"
    else
        fail "Stage 3 exits 0" "exit $EXIT"
    fi

    LINES=$(wc -l < /tmp/_s3_runlog | tr -d ' ')
    if [ "${LINES:-0}" -gt 5 ]; then
        pass "Stage 3 produced output ($LINES lines)"
    else
        warn "Stage 3 output" "only $LINES lines (likely empty stubs)"
    fi
}

# ═════════════════════════════════════════════════════════════════
# PIPELINE MODE — full Stage 1 → 2 → 3 build and test
# ═════════════════════════════════════════════════════════════════
run_pipeline() {
    echo "═══════════════════════════════════════════════"
    echo " Full Pipeline: Stage 1 → 2 → 3"
    echo "═══════════════════════════════════════════════"

    pass() { printf "  [\033[32m✓\033[0m] %s\n" "$1"; }
    fail() { printf "  [\033[31m✗\033[0m] %s — %s\n" "$1" "$2"; }

    echo ""
    echo "── Stage 1 build (Rust → stage1_rust) ──"
    rm -f build/stage1_rust
    LLVM_SYS_191_PREFIX=/opt/homebrew/opt/llvm@19 ./target/release/forgec build "$FORGE_SRC/main.fg" --dev -o build/stage1_rust >/tmp/_p1.log 2>&1
    if [ -x build/stage1_rust ]; then
        pass "Stage 1 binary built"
    else
        fail "Stage 1 build" "$(tail -3 /tmp/_p1.log | tr '\n' ' ')"
        return
    fi

    echo ""
    echo "── Stage 1 → Stage 2 IR ──"
    ./build/stage1_rust build "$FORGE_SRC/main.fg" >/tmp/_p2.log 2>&1
    if [ -f output.ll ]; then
        S2_FNS=$(grep -c '^define' output.ll)
        pass "Stage 2 IR generated ($S2_FNS functions)"
    else
        fail "Stage 2 IR" "no output.ll"
        return
    fi
    bash "$0" --score output.ll 2>&1 | grep -E "br_i1|undef|ret_undef|empty_functions|SCORE" | sed 's/^/    /'

    echo ""
    echo "── Stage 2 binary build ──"
    cp output.ll /tmp/stage1_output.ll
    /opt/homebrew/opt/llvm@19/bin/llc -O2 -filetype=obj /tmp/stage1_output.ll -o /tmp/stage2.o 2>/tmp/_p2llc.log
    cc -o /tmp/stage2 /tmp/stage2.o build/runtime.o -lm -Wl,-stack_size,0x10000000 \
        packages/std-llvm/target/release/libforge_llvm.a \
        -L/opt/homebrew/Cellar/llvm@19/19.1.7/lib -lLLVM-19 -lstdc++ -lz -lcurses 2>/tmp/_p2link.log
    if [ -x /tmp/stage2 ]; then
        pass "Stage 2 binary built"
    else
        fail "Stage 2 build" "$(tail -3 /tmp/_p2link.log | tr '\n' ' ')"
        return
    fi

    echo ""
    run_stage3
}

# ═════════════════════════════════════════════════════════════════
# DIFF MODE — compare one function's IR between two .ll files
# ═════════════════════════════════════════════════════════════════
# Usage: diagnose.sh --diff <fn_name> [file_a.ll] [file_b.ll]
# Defaults: file_a=build/stage2_input.ll, file_b=/tmp/output.ll
# Use case: identify where self-hosted codegen drifts from rust codegen
# for the same source function.
# Extract one LLVM function definition by name into stdout. Uses proper
# brace counting so it doesn't bail early if the body has comments or
# strings that contain }. Awk-only so it works without python.
extract_llvm_fn() {
    local file="$1"
    local fn="$2"
    awk -v fn="$fn" '
        BEGIN { in_fn=0 }
        $0 ~ "^define .*@"fn"\\(" { in_fn=1; print; next }
        in_fn {
            print
            if ($0 ~ /^}[[:space:]]*$/) { exit }
        }
    ' "$file"
}

run_diff() {
    if [ -z "$DIFF_FN" ]; then
        echo "Usage: diagnose.sh --diff-fn <fn_name> [file_a.ll] [file_b.ll]" >&2
        echo "       diagnose.sh --diff    <fn_name> [file_a.ll] [file_b.ll]   (alias)" >&2
        echo "" >&2
        echo "Defaults: file_a=/tmp/stage1.ll, file_b=/tmp/stage2.ll" >&2
        exit 1
    fi
    if [ ! -f "$DIFF_A" ]; then echo "ERROR: $DIFF_A not found" >&2; exit 1; fi
    if [ ! -f "$DIFF_B" ]; then echo "ERROR: $DIFF_B not found" >&2; exit 1; fi
    local tmp_a="/tmp/_diff_a.ll"
    local tmp_b="/tmp/_diff_b.ll"
    extract_llvm_fn "$DIFF_A" "$DIFF_FN" > "$tmp_a"
    extract_llvm_fn "$DIFF_B" "$DIFF_FN" > "$tmp_b"
    local la=$(wc -l < "$tmp_a")
    local lb=$(wc -l < "$tmp_b")
    echo "═══ IR Diff: @$DIFF_FN ═══"
    echo "  $DIFF_A: $la lines"
    echo "  $DIFF_B: $lb lines"
    if [ "$la" = "0" ]; then red "  not found in $DIFF_A"; exit 1; fi
    if [ "$lb" = "0" ]; then red "  not found in $DIFF_B"; exit 1; fi
    if cmp -s "$tmp_a" "$tmp_b"; then
        green "  byte-identical ✓"
        return 0
    fi
    echo ""
    diff -u "$tmp_a" "$tmp_b" | head -200
    echo ""
    echo "(full diff: diff -u $tmp_a $tmp_b)"
}

# Rank functions by diff size between two .ll files. Helps find the
# smallest non-trivial divergent functions first — those are usually
# the root causes (complex divergences are downstream effects).
run_rank_diff() {
    if [ ! -f "$DIFF_A" ]; then echo "ERROR: $DIFF_A not found" >&2; exit 1; fi
    if [ ! -f "$DIFF_B" ]; then echo "ERROR: $DIFF_B not found" >&2; exit 1; fi
    echo "═══ Function-level diff ranking ═══"
    echo "  A: $DIFF_A"
    echo "  B: $DIFF_B"
    echo ""
    local fns_file="/tmp/_rank_fns.txt"
    grep -oE '^define [^@]*@[A-Za-z_][A-Za-z0-9_]*' "$DIFF_A" \
        | sed 's/.*@//' | sort -u > "$fns_file"
    local total
    total=$(wc -l < "$fns_file" | tr -d ' ')
    echo "  scanning $total functions..."
    local results="/tmp/_rank_results.txt"
    : > "$results"
    while IFS= read -r fn; do
        local a_lines b_lines diff_lines
        a_lines=$(extract_llvm_fn "$DIFF_A" "$fn" | wc -l | tr -d ' ')
        b_lines=$(extract_llvm_fn "$DIFF_B" "$fn" | wc -l | tr -d ' ')
        if [ "$a_lines" = "0" ] || [ "$b_lines" = "0" ]; then continue; fi
        diff_lines=$(diff <(extract_llvm_fn "$DIFF_A" "$fn") \
                          <(extract_llvm_fn "$DIFF_B" "$fn") | wc -l | tr -d ' ')
        if [ "$diff_lines" = "0" ]; then continue; fi
        printf "%5d %5d %5d %s\n" "$diff_lines" "$a_lines" "$b_lines" "$fn" >> "$results"
    done < "$fns_file"
    echo ""
    echo "  diff a_ln b_ln  function (sorted, smallest divergence first)"
    sort -n "$results" | head -30
    echo ""
    local div_count
    div_count=$(wc -l < "$results" | tr -d ' ')
    echo "  $div_count of $total functions diverge"
    echo ""
    echo "(full ranking: sort -n $results)"
}

# Tool #4 — CFG summary for one function. Counts blocks, orphans,
# phis, calls, returns, max pred count. Two-line side-by-side.
cfg_stats_for() {
    local file="$1"
    local fn="$2"
    local tmp="/tmp/_cfg_stats.ll"
    extract_llvm_fn "$file" "$fn" > "$tmp"
    python3 <<PY
import re
text = open("$tmp").read()
if not text.strip():
    print("  not found")
    raise SystemExit(0)
blocks = re.findall(r'^([a-zA-Z_][\w\.]*):.*\$', text, re.MULTILINE)
n_blocks = len(blocks)
n_orphans = text.count('No predecessors!')
n_phi = len(re.findall(r'=\s*phi\b', text))
n_calls = len(re.findall(r'\bcall\b', text))
n_ret = len(re.findall(r'^\s*ret\b', text, re.MULTILINE))
max_preds = 0
for line in text.split('\n'):
    m = re.search(r';\s*preds\s*=\s*(.*)\$', line)
    if m:
        c = len(m.group(1).split(','))
        if c > max_preds: max_preds = c
print(f"  blocks={n_blocks:4d} orphans={n_orphans:3d} phi={n_phi:3d} calls={n_calls:3d} ret={n_ret:2d} max_preds={max_preds:2d}")
PY
}

run_cfg_summary() {
    if [ -z "$DIFF_FN" ]; then
        echo "Usage: diagnose.sh --cfg-summary <fn_name> [file_a.ll] [file_b.ll]" >&2
        exit 1
    fi
    if [ ! -f "$DIFF_A" ]; then echo "ERROR: $DIFF_A not found" >&2; exit 1; fi
    if [ ! -f "$DIFF_B" ]; then echo "ERROR: $DIFF_B not found" >&2; exit 1; fi
    echo "═══ CFG Summary: @$DIFF_FN ═══"
    echo "  A: $DIFF_A"
    cfg_stats_for "$DIFF_A" "$DIFF_FN"
    echo "  B: $DIFF_B"
    cfg_stats_for "$DIFF_B" "$DIFF_FN"
}

# Tool #7 — Generate CFG dot + png for one function via `opt -passes=dot-cfg`.
# Output: /tmp/cfg/<fn>.dot and /tmp/cfg/<fn>.png.
run_cfg() {
    if [ -z "$DIFF_FN" ]; then
        echo "Usage: diagnose.sh --cfg <fn_name> [file.ll]" >&2
        exit 1
    fi
    if [ ! -f "$IR" ]; then echo "ERROR: $IR not found" >&2; exit 1; fi
    local LLVM_PREFIX="${LLVM_SYS_191_PREFIX:-/opt/homebrew/opt/llvm@19}"
    local OPT="$LLVM_PREFIX/bin/opt"
    if [ ! -x "$OPT" ]; then OPT=$(command -v opt); fi
    if [ -z "$OPT" ]; then echo "ERROR: opt not found" >&2; exit 1; fi
    local DOT=$(command -v dot)
    mkdir -p /tmp/cfg
    rm -f /tmp/cfg/*.dot /tmp/cfg/*.png 2>/dev/null
    pushd /tmp/cfg >/dev/null
    "$OPT" -passes=dot-cfg "$IR" -o /dev/null >/dev/null 2>&1
    local dot_file=".${DIFF_FN}.dot"
    if [ ! -f "$dot_file" ]; then
        echo "ERROR: opt did not produce $dot_file (function may not exist in $IR)" >&2
        ls .${DIFF_FN}*.dot 2>/dev/null || true
        popd >/dev/null
        exit 1
    fi
    local out_dot="${DIFF_FN}.dot"
    mv "$dot_file" "$out_dot"
    echo "═══ CFG: @$DIFF_FN from $IR ═══"
    echo "  dot: /tmp/cfg/$out_dot"
    if [ -n "$DOT" ]; then
        "$DOT" -Tpng "$out_dot" -o "${DIFF_FN}.png" 2>/dev/null && echo "  png: /tmp/cfg/${DIFF_FN}.png"
    else
        echo "  (graphviz 'dot' not in PATH; install for png output)"
    fi
    # Quick stats
    local nodes=$(grep -c "^Node" "$out_dot" || echo 0)
    local edges=$(grep -c -- "->" "$out_dot" || echo 0)
    echo "  nodes=$nodes edges=$edges"
    popd >/dev/null
}

# Print all functions with orphan blocks, ranked by orphan count.
run_orphans() {
    if [ ! -f "$IR" ]; then echo "ERROR: $IR not found" >&2; exit 1; fi
    echo "═══ Functions with orphan blocks: $IR ═══"
    awk '
        /^define / { name=$0; sub(/^define [^@]*@/, "", name); sub(/\(.*/, "", name); count=0 }
        /No predecessors/ { count++ }
        /^}/ { if (count > 0) print count, name; count=0; name="" }
    ' "$IR" | sort -rn | head -30
    echo ""
    local total=$(awk '/No predecessors/{c++} END{print c+0}' "$IR")
    echo "  TOTAL orphan blocks: $total"
}

# ═════════════════════════════════════════════════════════════════
# IR SANITY MODE — scan for known anti-patterns
# ═════════════════════════════════════════════════════════════════
# Usage: diagnose.sh --ir-sanity [file.ll]
# Flags common codegen bugs where LLVM types don't match.
run_ir_sanity() {
    if [ ! -f "$IR" ]; then echo "ERROR: $IR not found" >&2; exit 1; fi
    echo "═══ IR Sanity: $IR ═══"
    local issues=0

    # 1. `load T, ptr %X` where %X was declared as `alloca U` with U != T
    #    Detects the "alloca i64 but load %Expr" class of bug.
    echo ""
    echo "── Mismatched load/alloca types ──"
    python3 - "$IR" <<'PY'
import re, sys
path = sys.argv[1]
alloca_ty = {}
bad = []
fn = ""
with open(path) as f:
    for ln, line in enumerate(f, 1):
        m = re.match(r'^define .* @(\w+)\(', line)
        if m: fn = m.group(1); alloca_ty = {}; continue
        m = re.match(r'\s*(%\S+)\s*=\s*alloca\s+([^,]+)', line)
        if m: alloca_ty[m.group(1)] = m.group(2).strip(); continue
        m = re.match(r'\s*%\S+\s*=\s*load\s+([^,]+),\s*ptr\s+(%\S+)', line)
        if m:
            lt, p = m.group(1).strip(), m.group(2)
            if p in alloca_ty and alloca_ty[p] != lt:
                bad.append((fn, ln, p, alloca_ty[p], lt))
for fn, ln, p, at, lt in bad[:20]:
    print(f"  {fn}:{ln}  alloca {p}: {at}  but load as {lt}")
if len(bad) > 20:
    print(f"  ... and {len(bad)-20} more")
print(f"  TOTAL: {len(bad)}")
PY

    # 2. String methods called on List-shaped values (phi_vals[0] → string_char_at)
    echo ""
    echo "── forge_string_char_at on List-named vars ──"
    grep -nE 'forge_string_char_at.*(phi_vals|bbs|_list|items|stmts|tokens|args|params|fields|arms|elems|vars)' "$IR" | head -10

    # 3. undef args to non-variadic functions
    echo ""
    echo "── Calls with undef args ──"
    grep -nE 'call .* @\w+\(.*undef' "$IR" | grep -v '@printf\|@forge_trace' | head -10 | sed 's/^/  /'
    local undef_count=$(grep -cE 'call .* @\w+\(.*undef' "$IR" || true)
    echo "  TOTAL: $undef_count"

    # 4. Stores of wrong-sized values
    echo ""
    echo "── Store type/alloca mismatches ──"
    python3 - "$IR" <<'PY'
import re, sys
path = sys.argv[1]
alloca_ty = {}
bad = []
fn = ""
with open(path) as f:
    for ln, line in enumerate(f, 1):
        m = re.match(r'^define .* @(\w+)\(', line)
        if m: fn = m.group(1); alloca_ty = {}; continue
        m = re.match(r'\s*(%\S+)\s*=\s*alloca\s+([^,]+)', line)
        if m: alloca_ty[m.group(1)] = m.group(2).strip(); continue
        m = re.match(r'\s*store\s+([^,]+?)\s+\S+,\s*ptr\s+(%\S+)', line)
        if m:
            st, p = m.group(1).strip(), m.group(2)
            if p in alloca_ty and alloca_ty[p] != st:
                bad.append((fn, ln, p, alloca_ty[p], st))
for fn, ln, p, at, st in bad[:20]:
    print(f"  {fn}:{ln}  alloca {p}: {at}  but store {st}")
if len(bad) > 20:
    print(f"  ... and {len(bad)-20} more")
print(f"  TOTAL: {len(bad)}")
PY

    # 5. br i1 false (dead branches — usually bad null-checks)
    echo ""
    echo "── Dead conditional branches (br i1 false) ──"
    grep -c 'br i1 false' "$IR" | sed 's/^/  count: /'
}

# ═════════════════════════════════════════════════════════════════
# DISPATCH
# ═════════════════════════════════════════════════════════════════
case "$MODE" in
    score)    run_score ;;
    stage2)   run_stage2 ;;
    stage3)   run_stage3 ;;
    pipeline) run_pipeline ;;
    kind-ids) run_kind_ids ;;
    source)   run_source ;;
    diff)     run_diff ;;
    rank-diff) run_rank_diff ;;
    cfg-summary) run_cfg_summary ;;
    orphans)  run_orphans ;;
    cfg)      run_cfg ;;
    ir-sanity) run_ir_sanity ;;
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
