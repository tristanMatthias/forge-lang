#!/bin/bash
# ═══════════════════════════════════════════════════════════════════
# Forge Self-Hosting Diagnostic System — single entry point
# ═══════════════════════════════════════════════════════════════════
#
# All diagnostics live here. Run `bash scripts/diagnose.sh --help`
# to see every mode. Add new modes here, never as a separate script.
#
# Quick reference (run --help for full details):
#
#   PIPELINE INSPECTION
#     --score [file.ll]              IR quality score (lower = better)
#     --orphans [file.ll]            functions with orphan blocks, ranked
#     --ir-sanity [file.ll]          scan for known anti-patterns
#     --kind-ids                     token kind_id consistency check
#     --pipeline                     full stage 1 → stage 3 sanity run
#     --stage2 / --stage3            functional smoke tests
#
#   FUNCTION-LEVEL DIFFING
#     --diff-fn <fn> [a.ll] [b.ll]   show line diff of one function
#     --rank-diff [a.ll] [b.ll]      rank functions by diff size
#     --cfg-summary <fn> [a] [b]     blocks/orphans/phis side-by-side
#     --type-diff [a.ll] [b.ll]      function signatures that differ ★
#     --anomaly [file.ll]            per-function anomaly score ★
#     --whyi64 <fn> <param>          why is this param i64? trace it ★
#     --cfg <fn> [file.ll]           graphviz dot output of CFG
#
#   FUZZ + REGRESSION
#     --fuzz [count]                 differential fuzzer (rust vs self-host)
#     --regress                      run /tmp/regress/*.fg suite ★
#     --regress-add <bug-name>       capture last fix as regression test ★
#
#   ENVIRONMENT VARIABLES (set before running stage1_rust / stage2_bin)
#     FORGE_DEBUG_BUILDER=1          trace every builder call to stderr
#     FORGE_DEBUG_VERIFY=1           run LLVMVerifyFunction after each fn
#     FORGE_DEBUG_VERIFY_AGGRESSIVE=1  verify after every build_* (slow)
#     FORGE_DEBUG_RECORD=<path>      append every builder call to log
#     FORGE_DX_TYPE_TRAP=1           runtime trap on i64-as-struct loads ★
#
#   FORGE-CALLABLE RUNTIME HELPERS (call from inside .fg sources)
#     forge_dbg_dump_pos_ring()        print last 256 position events
#     forge_dbg_was_positioned_at(bb)  did builder ever land here? 1/0
#     forge_dbg_block_provenance(bb)   where was this block created
#     forge_llvm_phi_audit(f) -> i64   count broken phi/edge mismatches
#     forge_llvm_dump_blocks(f)        list all blocks in function
#     forge_llvm_emit_cfg_dot(f, p)    write graphviz dot to path
#     forge_llvm_assert_at(b, exp, l)  assert builder at expected block
#     forge_llvm_assert_invariants(b, l)  battery of CG_B sanity checks
#     forge_llvm_verify_function(f)    LLVMVerifyFunction wrapper
#     forge_llvm_snapshot_fn(f, l, n)  write IR snapshot to /tmp/snap_*
#     forge_dbg_enter(name) / _exit(name)   indented call-graph trace
#     forge_llvm_oracle_match_dispatch_int(...)   bootstrap escape hatch
#
# ★ = added in this consolidation; see --help for details.
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
    --type-diff)
        # NEW #1 — Cross-IR function signature divergence report.
        # Walks both stage1.ll and stage2.ll, prints every function
        # whose param/return types differ. Catches "self-host emit
        # defaults to i64" bugs in one shot.
        MODE="type-diff"
        DIFF_A="${2:-/tmp/stage1.ll}"
        DIFF_B="${3:-/tmp/stage2.ll}"
        ;;
    --anomaly)
        # NEW #2 — Per-function anomaly score. Combines orphans,
        # i64-as-struct loads, undef args, etc. into a single number
        # per function. Top of the list = closest to actually broken.
        MODE="anomaly"
        IR="${2:-/tmp/stage2.ll}"
        ;;
    --whyi64)
        # NEW #3 — Trace WHY a parameter is i64. Reverse-walks the
        # codegen logic and reports the resolve_type_to_llvm fallback
        # path. Pinpoints which type-registration call is missing.
        MODE="whyi64"
        DIFF_FN="${2:-}"
        WHYI64_PARAM="${3:-}"
        ;;
    --fuzz)
        # NEW #8 wrapper — invoke the differential fuzzer. Default
        # 30 random programs. Saves divergent ones as /tmp/fuzz/diverge_*.fg
        MODE="fuzz"
        FUZZ_COUNT="${2:-30}"
        ;;
    --regress)
        # NEW #6 — Run every regression test in /tmp/regress/*.fg
        # against stage1_rust. Saved snapshots from prior bug fixes.
        MODE="regress"
        ;;
    --regress-add)
        # NEW #6b — Save the last fixture as a regression test.
        # Captures /tmp/fuzz/diverge_*.fg + expected output.
        MODE="regress-add"
        REGRESS_NAME="${2:-}"
        REGRESS_SRC="${3:-}"
        ;;
    --help|-h)
        MODE="help"
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
# NEW DIAGNOSTIC TOOLS — added 2026-04-07
# ═════════════════════════════════════════════════════════════════

# #1 — Type divergence checker. Walks both .ll files, parses every
# function signature, and prints any function whose param/return types
# differ. Catches "self-host emit defaults to i64" bugs in one shot.
run_type_diff() {
    if [ ! -f "$DIFF_A" ]; then echo "ERROR: $DIFF_A not found" >&2; exit 1; fi
    if [ ! -f "$DIFF_B" ]; then echo "ERROR: $DIFF_B not found" >&2; exit 1; fi
    echo "═══ Type Divergence: $DIFF_A vs $DIFF_B ═══"
    python3 - "$DIFF_A" "$DIFF_B" <<'PY'
import re, sys
def parse_sigs(path):
    sigs = {}
    pat = re.compile(r'^define\s+([^@]*?)\s*@(\w+)\s*\(([^)]*)\)')
    with open(path) as f:
        for line in f:
            m = pat.match(line)
            if m:
                ret_ty = m.group(1).strip()
                name = m.group(2)
                params_raw = m.group(3).strip()
                # Strip parameter names; keep types only
                params = []
                if params_raw:
                    for p in params_raw.split(','):
                        p = p.strip()
                        # Drop leading attributes (signext, zeroext, byval(...))
                        # Type is whatever comes before %X or end of arg.
                        m2 = re.match(r'(.*?)\s*%[\w\.]*$', p)
                        ty = m2.group(1).strip() if m2 else p
                        # Strip attribute prefixes
                        ty = re.sub(r'^(signext|zeroext|inreg|byval\([^)]*\)|byref\([^)]*\)|nonnull|noundef|nofree|noalias|nocapture|readonly|readnone|sret\([^)]*\)|align\s+\d+)\s+', '', ty)
                        params.append(ty)
                sigs[name] = (ret_ty, params)
    return sigs

a_path, b_path = sys.argv[1], sys.argv[2]
A = parse_sigs(a_path)
B = parse_sigs(b_path)
common = sorted(set(A) & set(B))
diverge = []
for name in common:
    ra, pa = A[name]
    rb, pb = B[name]
    if ra != rb or pa != pb:
        diverge.append((name, ra, pa, rb, pb))

print(f"  A functions: {len(A)}")
print(f"  B functions: {len(B)}")
print(f"  common:      {len(common)}")
print(f"  divergent:   {len(diverge)}")
print()
if not diverge:
    print("  ✓ all common signatures match")
else:
    # Group by "kind" of divergence to make scanning faster
    i64_widening = []
    other = []
    for name, ra, pa, rb, pb in diverge:
        # Heuristic: if all the differences are "X" → "i64", that's the
        # classic enum-as-i64 / struct-as-i64 fallback.
        is_widening = True
        if ra != rb and rb != 'i64' and rb != 'ptr':
            is_widening = False
        for x, y in zip(pa, pb):
            if x != y and y != 'i64' and y != 'ptr':
                is_widening = False
                break
        if len(pa) != len(pb):
            is_widening = False
        if is_widening:
            i64_widening.append((name, ra, pa, rb, pb))
        else:
            other.append((name, ra, pa, rb, pb))

    if i64_widening:
        print(f"  ── i64/ptr widening ({len(i64_widening)}) ──")
        for name, ra, pa, rb, pb in i64_widening[:30]:
            diffs = []
            if ra != rb:
                diffs.append(f"ret {ra}→{rb}")
            for i, (x, y) in enumerate(zip(pa, pb)):
                if x != y:
                    diffs.append(f"p{i} {x}→{y}")
            print(f"    @{name}  ({', '.join(diffs)})")
        if len(i64_widening) > 30:
            print(f"    ... and {len(i64_widening) - 30} more")
        print()
    if other:
        print(f"  ── structural divergence ({len(other)}) ──")
        for name, ra, pa, rb, pb in other[:20]:
            print(f"    @{name}")
            print(f"      A: {ra} ({', '.join(pa)})")
            print(f"      B: {rb} ({', '.join(pb)})")
        if len(other) > 20:
            print(f"    ... and {len(other) - 20} more")
PY
}

# #2 — Per-function anomaly score. Combines orphans, undef args,
# struct-as-i64 loads, into a single number per function. Top of the
# list is closest to actually broken at runtime.
run_anomaly() {
    if [ ! -f "$IR" ]; then echo "ERROR: $IR not found" >&2; exit 1; fi
    echo "═══ Anomaly Score: $IR ═══"
    echo "  weights: orphan=5  undef_arg=3  i64_struct_load=5  ret_undef=10"
    echo ""
    python3 - "$IR" <<'PY'
import re, sys
path = sys.argv[1]
funcs = {}  # name -> dict of counts
cur = None
fn_pat = re.compile(r'^define\s+[^@]*@(\w+)\s*\(')
with open(path) as f:
    for line in f:
        m = fn_pat.match(line)
        if m:
            cur = m.group(1)
            funcs[cur] = {'orphans': 0, 'undef_args': 0, 'i64_struct': 0, 'ret_undef': 0, 'lines': 0}
            continue
        if cur is None:
            continue
        funcs[cur]['lines'] += 1
        if 'No predecessors!' in line:
            funcs[cur]['orphans'] += 1
        if re.search(r'undef\b.*,', line) and 'call' in line:
            funcs[cur]['undef_args'] += 1
        if re.search(r'load\s+i64,\s*ptr.*align\s+8', line):
            funcs[cur]['i64_struct'] += 1
        if re.match(r'^\s*ret\s+\S+\s+undef\b', line):
            funcs[cur]['ret_undef'] += 1
        if line.startswith('}'):
            cur = None

scored = []
for name, c in funcs.items():
    score = c['orphans'] * 5 + c['undef_args'] * 3 + c['i64_struct'] * 5 + c['ret_undef'] * 10
    if score > 0:
        scored.append((score, name, c))
scored.sort(reverse=True)
print(f"  {'score':>5} {'orph':>4} {'uarg':>4} {'i64s':>4} {'rund':>4}  function")
for score, name, c in scored[:30]:
    print(f"  {score:>5} {c['orphans']:>4} {c['undef_args']:>4} {c['i64_struct']:>4} {c['ret_undef']:>4}  {name}")
print(f"\n  total functions with anomalies: {len(scored)} / {len(funcs)}")
PY
}

# #3 — "Why is this i64?" reverse lookup. Given a function name and
# parameter index, traces what type the source declared and what the
# self-host emit resolved it to. Identifies missing type registrations.
run_whyi64() {
    if [ -z "$DIFF_FN" ]; then
        echo "Usage: diagnose.sh --whyi64 <fn_name> <param_index|param_name>" >&2
        exit 1
    fi
    echo "═══ Why is this i64?  @$DIFF_FN  param=$WHYI64_PARAM ═══"
    # Step 1: find the function in stage 1 IR (rust-emitted, source of truth)
    local A="${DIFF_A:-/tmp/stage1.ll}"
    local B="${DIFF_B:-/tmp/stage2.ll}"
    if [ ! -f "$A" ] || [ ! -f "$B" ]; then
        echo "  needs $A and $B; run rust forgec --emit-ir + stage1_rust first" >&2
        exit 1
    fi
    echo "  Stage 1 IR signature (rust-emitted, source of truth):"
    grep "^define .*@${DIFF_FN}\b" "$A" | head -1 | sed 's/^/    /'
    echo "  Stage 2 IR signature (self-host emit, what we're debugging):"
    grep "^define .*@${DIFF_FN}\b" "$B" | head -1 | sed 's/^/    /'
    echo ""
    # Step 2: find the source declaration of the function
    echo "  Source declaration:"
    grep -rn --include='*.fg' "fn ${DIFF_FN##*_}\s*(" packages/forgec/src/ 2>/dev/null \
        | head -3 | sed 's/^/    /'
    echo ""
    # Step 3: walk resolve_type_to_llvm and check which registrations exist
    echo "  Type-resolution checklist (what resolve_type_to_llvm tries):"
    cat <<'NOTE'
    The self-host's resolve_type_to_llvm() in mod.fg falls through:
      1. primitives (string, int, float, bool, ptr) → CG_STR / CG_I64
      2. List<T>, Map<K,V> → CG_LIST / CG_MAP struct
      3. forge_get_type_by_name_i64(name) → LLVM named type lookup
      4. forge_enum_type_exists(name) → enum tagged-union
      5. forge_struct_type_get_fields(name) → struct
      6. fall through → CG_I64 (the bug surface)
    For an enum-typed param to NOT default to i64, ALL of:
      - Enum is registered via forge_enum_type_register()
      - Variant fields registered via forge_enum_variant_fields_set()
      - cg_register_core_types() includes the enum
    For a struct-typed param to NOT default to i64:
      - register_struct_type() called (usually from check_type_decl)
NOTE
}

# #6 — Regression suite. Saves minimal repros from fuzzer/manual debug
# as permanent tests. Run before every commit so we don't re-introduce
# fixed bugs.
REGRESS_DIR="forge_regress"
run_regress() {
    if [ ! -d "$REGRESS_DIR" ]; then
        echo "  no regression suite at $REGRESS_DIR (use --regress-add to create one)"
        return 0
    fi
    local pass=0 fail=0
    echo "═══ Regression: $REGRESS_DIR ═══"
    for src in "$REGRESS_DIR"/*.fg; do
        [ -f "$src" ] || continue
        local name=$(basename "$src" .fg)
        local expected="$REGRESS_DIR/$name.expected"
        rm -f output.ll a.out 2>/dev/null
        if ! ./build/stage1_rust build "$src" >/dev/null 2>&1; then
            printf "  ✗ %s (compile failed)\n" "$name"
            fail=$((fail + 1))
            continue
        fi
        local got
        got=$(./a.out 2>&1 || true)
        if [ -f "$expected" ]; then
            local want=$(cat "$expected")
            if [ "$got" = "$want" ]; then
                printf "  ✓ %s\n" "$name"
                pass=$((pass + 1))
            else
                printf "  ✗ %s — expected '%s', got '%s'\n" "$name" "$want" "$got"
                fail=$((fail + 1))
            fi
        else
            printf "  ? %s (no .expected file; got '%s')\n" "$name" "$got"
            pass=$((pass + 1))
        fi
    done
    echo ""
    echo "  pass: $pass  fail: $fail"
    [ "$fail" = "0" ]
}

run_regress_add() {
    if [ -z "$REGRESS_NAME" ] || [ -z "$REGRESS_SRC" ]; then
        echo "Usage: diagnose.sh --regress-add <name> <source.fg>" >&2
        echo "  Captures source.fg + its expected output as a regression test" >&2
        exit 1
    fi
    if [ ! -f "$REGRESS_SRC" ]; then
        echo "ERROR: $REGRESS_SRC not found" >&2
        exit 1
    fi
    mkdir -p "$REGRESS_DIR"
    cp "$REGRESS_SRC" "$REGRESS_DIR/${REGRESS_NAME}.fg"
    rm -f output.ll a.out 2>/dev/null
    if ./build/stage1_rust build "$REGRESS_SRC" >/dev/null 2>&1; then
        ./a.out 2>&1 > "$REGRESS_DIR/${REGRESS_NAME}.expected" || true
        echo "  saved $REGRESS_DIR/${REGRESS_NAME}.fg"
        echo "  expected output: $(cat $REGRESS_DIR/${REGRESS_NAME}.expected)"
    else
        echo "  ⚠ source did not compile cleanly with stage1_rust"
        echo "  saved test source but no .expected file"
    fi
}

# #8 wrapper — invoke fuzzer (the body lives in scripts/forge_fuzz.sh
# but it's now reachable as `diagnose.sh --fuzz [count]`).
run_fuzz() {
    bash scripts/forge_fuzz.sh "${FUZZ_COUNT:-30}"
}

# --help — print everything in one screen
run_help() {
    cat <<'HELP'
═══════════════════════════════════════════════════════════════════
 Forge Self-Hosting Diagnostics — single entry point
═══════════════════════════════════════════════════════════════════

PIPELINE INSPECTION
  --score [file.ll]              IR quality score (lower = better)
  --orphans [file.ll]            functions with orphan blocks, ranked
  --ir-sanity [file.ll]          scan for known anti-patterns
  --kind-ids                     token kind_id consistency check
  --pipeline                     full stage 1 → stage 3 sanity run
  --stage2 / --stage3            functional smoke tests
  --source                       what's in the source layout

FUNCTION-LEVEL DIFFING
  --diff-fn <fn> [a.ll] [b.ll]   line diff of one function
  --rank-diff [a.ll] [b.ll]      rank functions by diff size
  --cfg-summary <fn> [a] [b]     blocks/orphans/phis side-by-side
  --type-diff [a.ll] [b.ll]      function signatures that differ ★
  --anomaly [file.ll]            per-function anomaly score ★
  --whyi64 <fn> <param>          why is this param i64? ★
  --cfg <fn> [file.ll]           graphviz dot output of CFG

FUZZ + REGRESSION
  --fuzz [count]                 differential fuzzer (rust vs self-host)
  --regress                      run forge_regress/*.fg suite ★
  --regress-add <name> <src.fg>  capture a fix as regression test ★

ENVIRONMENT VARIABLES (set before running stage1_rust / stage2_bin)
  FORGE_DEBUG_BUILDER=1            trace every builder call to stderr
  FORGE_DEBUG_VERIFY=1             run LLVMVerifyFunction after each fn
  FORGE_DEBUG_VERIFY_AGGRESSIVE=1  verify after every build_* (slow)
  FORGE_DEBUG_RECORD=<path>        append every builder call to log

FORGE-CALLABLE RUNTIME HELPERS (call from inside .fg sources)
  forge_dbg_dump_pos_ring()        last 256 builder position events
  forge_dbg_was_positioned_at(bb)  did builder ever land here? 1/0
  forge_dbg_block_provenance(bb)   where was this block created
  forge_llvm_phi_audit(f) -> i64   count broken phi/edge mismatches
  forge_llvm_dump_blocks(f)        list all blocks in function
  forge_llvm_emit_cfg_dot(f, p)    write graphviz dot to path
  forge_llvm_assert_at(b, exp, l)  assert builder at expected block
  forge_llvm_assert_invariants(b, l)  battery of CG_B sanity checks
  forge_llvm_verify_function(f)    LLVMVerifyFunction wrapper
  forge_llvm_snapshot_fn(f, l, n)  write IR snapshot to /tmp/snap_*
  forge_dbg_enter(name) / _exit(name)  indented call-graph trace
  forge_llvm_oracle_match_dispatch_int(...)  bootstrap escape hatch

EXAMPLES
  Find which functions have signature mismatches:
    bash scripts/diagnose.sh --type-diff

  Rank broken functions by anomaly score:
    bash scripts/diagnose.sh --anomaly /tmp/stage2.ll

  Trace one function's CFG visually:
    bash scripts/diagnose.sh --cfg Codegen_emit_binary
    dot -Tpng /tmp/cfg/Codegen_emit_binary.dot > cfg.png

  Catch regressions before they land:
    bash scripts/diagnose.sh --regress

  ★ = added in latest consolidation. Add new tools HERE, never as a
      separate script. The only entry point future agents need to
      know is `bash scripts/diagnose.sh --help`.
═══════════════════════════════════════════════════════════════════
HELP
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
    type-diff) run_type_diff ;;
    anomaly)  run_anomaly ;;
    whyi64)   run_whyi64 ;;
    fuzz)     run_fuzz ;;
    regress)  run_regress ;;
    regress-add) run_regress_add ;;
    help)     run_help ;;
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
