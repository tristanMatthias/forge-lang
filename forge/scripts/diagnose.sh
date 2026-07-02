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
#     --build-stage2 [ir] [bin]      link a runnable compiler from IR ★
#     --pipeline                     full stage 1 → stage 3 sanity run
#     --stage2 / --stage3            functional smoke tests
#
#   FUNCTION-LEVEL DIFFING
#     --diff-fn <fn> [a.ll] [b.ll]   show line diff of one function
#     --rank-diff [a.ll] [b.ll]      rank functions by diff size
#     --cfg-summary <fn> [a] [b]     blocks/orphans/phis side-by-side
#     --type-diff [a.ll] [b.ll]      function signatures that differ ★
#     --storage-audit [file.ll]      rank direct alloca/store ABI mismatches ★
#     --anomaly [file.ll]            per-function anomaly score ★
#     --llvm-decls                   audit missing self-host LLVM decls ★
#     --body-reparse <src.fg>        trace body-src → tokens → stmt counts ★
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
    --build-stage2)
        MODE="build-stage2"
        IR="${2:-build/stage2.ll}"
        STAGE_BIN_OUT="${3:-build/stage2}"
        ;;
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
    --storage-audit)
        # Direct alloca/store ABI mismatch audit. Ranks functions where a
        # stack slot is allocated as one type but written with another
        # (e.g. `alloca i8` + `store i64`). This catches the typed-local
        # coercion bugs that stage 2 crashes tend to come from.
        MODE="storage-audit"
        IR="${2:-/tmp/stage2.ll}"
        ;;
    --anomaly)
        # NEW #2 — Per-function anomaly score. Combines orphans,
        # i64-as-struct loads, undef args, etc. into a single number
        # per function. Top of the list = closest to actually broken.
        MODE="anomaly"
        IR="${2:-/tmp/stage2.ll}"
        ;;
    --llvm-decls)
        # Audit llvm.* wrappers used by the self-host codegen against
        # the forge_llvm_* declarations registered in codegen_init_runtime.
        MODE="llvm-decls"
        ;;
    --body-reparse)
        # Compile a source file through the current stage2 compiler and
        # print the body extraction / re-lex / re-parse trace only.
        MODE="body-reparse"
        BODY_REPARSE_SRC="${2:-}"
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
    --bugs)
        # Unified bug enumeration. Runs every detection method and
        # produces one ranked list. Use this to answer "what's broken
        # right now?" without having to remember which sub-tool to run.
        MODE="bugs"
        ;;
    --help|-h)
        MODE="help"
        ;;
    --ir-sanity) MODE="ir-sanity"; IR="${2:-/tmp/output.ll}" ;;
    --ret-undef)
        # List every function whose body contains `ret <T> undef`,
        # grouped by return type. These mark places where build_ret was
        # called with a value whose type didn't match the function's
        # declared return — usually missing int↔ptr coercion. Catches
        # the LLVMBuildRet undef-fallback that crashes Stage 3 with
        # bogus type ptrs into LLVMAddGlobal.
        MODE="ret-undef"
        IR="${2:-/tmp/stage2.ll}"
        ;;
    --container-abi)
        # Audit source-declared List<T>/Map<K,V> params and returns
        # against emitted IR signatures. Flags container signatures
        # that still lower to %ForgeString.
        MODE="container-abi"
        IR="${2:-/tmp/stage2.ll}"
        ;;
    --fn-ir)
        # Print one function's IR from a given .ll file. Replaces ad-hoc
        # `awk '/define.*@FN/,/^}/' file.ll` invocations.
        MODE="fn-ir"
        DIFF_FN="${2:-}"
        IR="${3:-output.ll}"
        ;;
    --show-fn)
        # Print one function's IR from BOTH output.ll (stage 2 IR, what
        # stage 2 binary executes) and /tmp/output.ll (stage 3 IR, what
        # stage 2 binary emits). Side-by-side line counts plus full
        # bodies. Use this any time a function looks like a stub in
        # stage 3 IR — diff vs the rust-compiled version pinpoints the
        # miscompile fast.
        MODE="show-fn"
        DIFF_FN="${2:-}"
        ;;
    --binop-test)
        # Compile a fixed set of binary-op test programs (+, ==, &&, etc)
        # through stage1_rust and /tmp/stage2 and check the runtime
        # output. Stage 1 is the oracle. Any binop where stage 2 produces
        # different output is a miscompile site, printed with the wrong
        # value next to the expected one. Catches the entire class of
        # "stage 2 binary emits stub bodies" bugs in <2 seconds.
        MODE="binop-test"
        ;;
    --capture)
        # Snapshot the current output.ll under a label so it can be diffed
        # later. Use this BEFORE making a codegen change so you can compare
        # the IR before/after with --diff-builds. Snapshots live in
        # /tmp/forge_snapshots/<label>.ll.
        MODE="capture"
        CAPTURE_LABEL="${2:-}"
        IR="${3:-output.ll}"
        ;;
    --diff-builds)
        # Compare two captured snapshots (or .ll files) with @NNNN, %NN,
        # and bbNN names normalized so the diff shows real semantic
        # differences instead of register renumbering noise. Optional
        # third arg restricts the diff to one function.
        MODE="diff-builds"
        DIFF_A="${2:-}"
        DIFF_B="${3:-}"
        DIFF_FN="${4:-}"
        ;;
    --probe-cmp)
        # Post-process output.ll to instrument every `icmp eq/ne` in <fn>
        # with a runtime trace call. Recompile (llc + cc), run on the given
        # input, and grep traces. Use this when you suspect == is broken
        # for some operand shape but you can't tell which call is wrong.
        MODE="probe-cmp"
        DIFF_FN="${2:-}"
        PROBE_INPUT="${3:-/tmp/_probe_input.fg}"
        ;;
    --snip)
        # Compile and run a one-line Forge expression through both
        # stage1_rust and the stage 2 binary, diff the outputs. Wraps
        # the expression in `fn main() { ... ; println("ok") }`. The
        # fastest way to ask "does the self-host binary handle THIS?"
        MODE="snip"
        SNIP_CODE="${2:-}"
        ;;
    --repro)
        # Look up a minimal repro for a known stage 3 symptom and write
        # it to /tmp/_repro_<symptom>.fg. Use --repro list to see all
        # registered symptoms.
        MODE="repro"
        REPRO_NAME="${2:-list}"
        ;;
    --shadow-check)
        # Static lint over packages/forgec/src/*.fg looking for user
        # `let/mut <name>` declarations whose name collides with an
        # internal LLVM SSA name emitted by build_alloca elsewhere in
        # codegen (the for-loop counter, while-loop blocks, etc.).
        # Either side of the collision becomes the other's silent bug
        # via the auto-cache by direct name. Caught the first stage-3
        # bug after the fact; should have caught it in advance.
        MODE="shadow-check"
        ;;
    --dump-bisect)
        # Run stage1_rust with FORGE_DEBUG_DUMP=<fn> set, then walk
        # /tmp/forge_dump/*.ll in sequence and diff each consecutive
        # pair. Each diff shows EXACTLY what one codegen step did.
        # Use this to find which call introduces a divergence: when
        # the diff is empty for a step, that step was a no-op; when
        # the diff is unexpected (instructions in wrong block, wrong
        # value type, etc.), that step is the bug.
        MODE="dump-bisect"
        DIFF_FN="${2:-Parser_parse_statement}"
        ;;
    --crash-asm)
        # Disassemble a binary at <fn>+<offset> ±20 instructions to see
        # the actual machine instruction that crashed. The OS reports
        # crashes by nearest-symbol, which is often misleading — the PC
        # might be inside a different function or in a stack-probe
        # helper. This shows the truth.
        MODE="crash-asm"
        DIFF_FN="${2:-Codegen_emit_statement}"
        CRASH_OFF="${3:-88}"
        CRASH_BIN="${4:-./a.out}"
        ;;
    --find-stubs)
        # Compare two snapshots/.ll files. List every function where the
        # second is < 25% the size of the first AND has the classic match-
        # stub signature (extract tag + zext + br + phi + ret default).
        # These are the functions whose codegen is silently broken.
        MODE="find-stubs"
        DIFF_A="${2:-s2}"
        DIFF_B="${3:-s3}"
        ;;
    --cmp-broken)
        # 5-second smoke battery: a fixed set of "can stage 2 binary
        # do basic things" tests. Each is a tiny Forge program with a
        # known expected output. Compile via stage 2 binary, run, diff.
        # First failing test name is your next bug.
        MODE="cmp-broken"
        ;;
    --progress)
        # Quantified "how close are we to stage 3 self-compiling"
        # report. Combines:
        #   1. Function count parity (stage 3 IR vs stage 2 IR)
        #   2. Per-function body parity (byte-equal? close? stub?)
        #   3. Stage 3 binary functional smoke tests
        #   4. Stage 3 binop fixture pass rate
        # And prints one composite "% complete" number.
        MODE="progress"
        ;;
esac

FORGE_SRC="packages/forgec/src"
RUST_FEATURES="packages/forgec-rust/features"
CODEGEN="packages/forgec/src/codegen/mod.fg"
RUNTIME="stdlib/runtime.c"
KIND_IDS="packages/forgec/src/core/kind_ids.fg"
LLVM_PREFIX="${LLVM_PREFIX:-/opt/homebrew/opt/llvm@19}"
LLC_BIN="${LLC_BIN:-$LLVM_PREFIX/bin/llc}"
LLVM_CONFIG_BIN="${LLVM_CONFIG_BIN:-$LLVM_PREFIX/bin/llvm-config}"
STD_LLVM_LIB="packages/std-llvm/target/release/libforge_llvm.a"
RUNTIME_O="build/runtime.o"
DEFAULT_STAGE2_LL="build/stage2.ll"
DEFAULT_STAGE2_BIN="build/stage2"
ERRORS=0
WARNINGS=0

red()    { printf "\033[31m%s\033[0m\n" "$1"; }
yellow() { printf "\033[33m%s\033[0m\n" "$1"; }
green()  { printf "\033[32m%s\033[0m\n" "$1"; }
err()    { red "  ✗ $1"; ERRORS=$((ERRORS + 1)); }
warn()   { yellow "  ⚠ $1"; WARNINGS=$((WARNINGS + 1)); }
ok()     { green "  ✓ $1"; }

build_compiler_from_ir() {
    local ir="$1"
    local out_bin="$2"
    local out_obj="$3"
    local llc_log="$4"
    local link_log="$5"

    if [ ! -f "$ir" ]; then
        echo "ERROR: IR not found: $ir" >&2
        return 1
    fi
    if [ ! -f "$RUNTIME_O" ]; then
        echo "ERROR: runtime object missing: $RUNTIME_O (run make runtime or make stage1-rust)" >&2
        return 1
    fi
    if [ ! -f "$STD_LLVM_LIB" ]; then
        echo "ERROR: std-llvm archive missing: $STD_LLVM_LIB" >&2
        return 1
    fi
    if [ ! -x "$LLC_BIN" ] || [ ! -x "$LLVM_CONFIG_BIN" ]; then
        echo "ERROR: LLVM tools missing under $LLVM_PREFIX" >&2
        return 1
    fi

    mkdir -p "$(dirname "$out_bin")"
    rm -f "$out_obj" "$out_bin"

    "$LLC_BIN" -O2 -filetype=obj "$ir" -o "$out_obj" >"$llc_log" 2>&1 || return 1

    local llvm_libs
    llvm_libs="$("$LLVM_CONFIG_BIN" --ldflags --libs core analysis bitwriter)"
    cc -o "$out_bin" "$out_obj" "$RUNTIME_O" -lm -Wl,-stack_size,0x10000000 \
        "$STD_LLVM_LIB" $llvm_libs -lstdc++ -lz -lcurses >"$link_log" 2>&1 || return 1

    [ -x "$out_bin" ]
}

resolve_stage2_bin() {
    if [ -x "$DEFAULT_STAGE2_BIN" ]; then
        echo "$DEFAULT_STAGE2_BIN"
        return 0
    fi
    if [ -x /tmp/stage2 ]; then
        echo /tmp/stage2
        return 0
    fi
    return 1
}

ensure_stage2_bin() {
    local existing
    existing=$(resolve_stage2_bin 2>/dev/null) || true
    if [ -n "$existing" ]; then
        echo "$existing"
        return 0
    fi
    if [ ! -f "$DEFAULT_STAGE2_LL" ]; then
        echo "ERROR: no stage2 compiler or IR found. Run make stage2-ir or make stage2." >&2
        return 1
    fi
    if build_compiler_from_ir "$DEFAULT_STAGE2_LL" "$DEFAULT_STAGE2_BIN" "${DEFAULT_STAGE2_BIN}.o" \
        /tmp/_stage2_llc.log /tmp/_stage2_link.log; then
        echo "$DEFAULT_STAGE2_BIN"
        return 0
    fi
    echo "ERROR: failed to build $DEFAULT_STAGE2_BIN from $DEFAULT_STAGE2_LL" >&2
    [ -s /tmp/_stage2_llc.log ] && head -20 /tmp/_stage2_llc.log >&2
    [ -s /tmp/_stage2_link.log ] && head -20 /tmp/_stage2_link.log >&2
    return 1
}

run_build_stage2() {
    local out_bin="${STAGE_BIN_OUT:-$DEFAULT_STAGE2_BIN}"
    local out_obj
    out_obj="${out_bin%.*}.o"
    if build_compiler_from_ir "$IR" "$out_bin" "$out_obj" /tmp/_build_stage2_llc.log /tmp/_build_stage2_link.log; then
        echo "built compiler: $out_bin"
        return 0
    fi
    echo "failed to build compiler from $IR" >&2
    [ -s /tmp/_build_stage2_llc.log ] && tail -20 /tmp/_build_stage2_llc.log >&2
    [ -s /tmp/_build_stage2_link.log ] && tail -20 /tmp/_build_stage2_link.log >&2
    return 1
}

# ═════════════════════════════════════════════════════════════════
# SCORE MODE — just the IR quality score
# ═════════════════════════════════════════════════════════════════
run_fn_ir() {
    if [ -z "$DIFF_FN" ]; then
        echo "Usage: diagnose.sh --fn-ir <fn_name> [file.ll]" >&2
        exit 1
    fi
    if [ ! -f "$IR" ]; then echo "ERROR: $IR not found" >&2; exit 1; fi
    extract_llvm_fn "$IR" "$DIFF_FN"
}

# ─── Snapshot capture / diff ─────────────────────────────────────
SNAP_DIR=/tmp/forge_snapshots

run_capture() {
    if [ -z "$CAPTURE_LABEL" ]; then
        echo "Usage: diagnose.sh --capture <label> [file.ll]" >&2
        echo "  Snapshots <file.ll> (default output.ll) to $SNAP_DIR/<label>.ll" >&2
        exit 1
    fi
    if [ ! -f "$IR" ]; then echo "ERROR: $IR not found" >&2; exit 1; fi
    mkdir -p "$SNAP_DIR"
    cp "$IR" "$SNAP_DIR/${CAPTURE_LABEL}.ll"
    local lines fns
    lines=$(wc -l < "$SNAP_DIR/${CAPTURE_LABEL}.ll" | tr -d ' ')
    fns=$(grep -c '^define ' "$SNAP_DIR/${CAPTURE_LABEL}.ll")
    echo "captured $IR → $SNAP_DIR/${CAPTURE_LABEL}.ll  ($fns fns, $lines lines)"
}

# Resolve a snapshot name OR a path to an actual .ll file.
resolve_snap() {
    local s="$1"
    if [ -f "$s" ]; then echo "$s"; return; fi
    if [ -f "$SNAP_DIR/${s}.ll" ]; then echo "$SNAP_DIR/${s}.ll"; return; fi
    echo "ERROR: '$s' is neither a file nor a snapshot label in $SNAP_DIR" >&2
    exit 1
}

# Strip register/block/global numbering so the diff shows only semantic
# differences. Same normalization I kept reaching for via ad-hoc sed.
normalize_ir() {
    sed -E 's/@[0-9]+/@N/g; s/%[0-9]+/%N/g; s/bb[0-9]+/bbN/g'
}

run_diff_builds() {
    if [ -z "$DIFF_A" ] || [ -z "$DIFF_B" ]; then
        echo "Usage: diagnose.sh --diff-builds <a> <b> [fn_name]" >&2
        echo "  <a>, <b> may be snapshot labels (see --capture) or .ll paths" >&2
        echo "  Optional fn_name restricts the diff to one function." >&2
        exit 1
    fi
    local a b
    a=$(resolve_snap "$DIFF_A")
    b=$(resolve_snap "$DIFF_B")
    local at bt
    at=$(mktemp); bt=$(mktemp)
    if [ -n "$DIFF_FN" ]; then
        extract_llvm_fn "$a" "$DIFF_FN" | normalize_ir > "$at"
        extract_llvm_fn "$b" "$DIFF_FN" | normalize_ir > "$bt"
    else
        normalize_ir < "$a" > "$at"
        normalize_ir < "$b" > "$bt"
    fi
    local total
    total=$(diff "$at" "$bt" | wc -l | tr -d ' ')
    echo "── normalized diff: $a vs $b ${DIFF_FN:+(fn $DIFF_FN)} ──"
    echo "  total diff lines: $total"
    if [ "$total" = "0" ]; then
        green "  (identical after normalization)"
    else
        diff "$at" "$bt"
    fi
    rm -f "$at" "$bt"
}

# ─── --snip "code" ───────────────────────────────────────────────
# Wrap a one-liner in a main function, build via stage1_rust → run,
# then build via stage 2 binary → run. Diff the two outputs. The
# fastest "is the self-host binary broken for this construct?" check.
run_snip() {
    if [ -z "$SNIP_CODE" ]; then
        echo "Usage: diagnose.sh --snip 'forge expression(s)'" >&2
        echo "  e.g. --snip 'let a = 122; if a == 122 { println(\"yes\") }'" >&2
        exit 1
    fi
    local f=/tmp/_snip.fg
    {
        echo "fn main() {"
        echo "    $SNIP_CODE"
        echo "    println(\"__snip_done__\")"
        echo "}"
    } > "$f"
    echo "── snippet ──"
    sed 's/^/  /' "$f"
    echo ""
    if [ ! -x ./build/stage1_rust ]; then
        echo "  ERROR: build/stage1_rust missing — run make stage1-rust" >&2
        exit 1
    fi
    echo "── stage1_rust → run ──"
    ./build/stage1_rust build "$f" >/tmp/_snip_s1.log 2>&1 || true
    if [ -x ./a.out ]; then
        ./a.out >/tmp/_snip_s1_run.out 2>&1
        sed 's/^/  /' /tmp/_snip_s1_run.out
        cp ./a.out /tmp/_snip_stage1_bin
    else
        echo "  build failed:"; tail -5 /tmp/_snip_s1.log | sed 's/^/    /'
        return
    fi
    echo ""
    echo "── stage2 binary → compile snippet → run ──"
    if [ ! -x ./build/stage1_rust ]; then return; fi
    # Stage 2 binary == ./a.out from compiling main.fg
    ./build/stage1_rust build packages/forgec/src/main.fg >/tmp/_snip_s2build.log 2>&1
    if [ ! -x ./a.out ]; then
        echo "  stage 2 build failed"; return
    fi
    ./a.out build "$f" >/tmp/_snip_s2.log 2>&1 || true
    if [ -x ./a.out ]; then
        ./a.out >/tmp/_snip_s2_run.out 2>&1
        sed 's/^/  /' /tmp/_snip_s2_run.out
    else
        echo "  stage 2 binary failed to compile snippet:"
        tail -5 /tmp/_snip_s2.log | sed 's/^/    /'
        return
    fi
    echo ""
    if cmp -s /tmp/_snip_s1_run.out /tmp/_snip_s2_run.out; then
        green "  identical ✓ — self-host handles this construct"
    else
        red "  DIVERGENT — stage 2 binary mis-handles this construct"
        echo "  diff:"
        diff /tmp/_snip_s1_run.out /tmp/_snip_s2_run.out | sed 's/^/    /'
    fi
}

# ─── --repro <symptom> ───────────────────────────────────────────
# Catalog of minimal repros for known stage 3 bugs. Add new entries
# here when you find them. Usage: --repro list, --repro <name>.
run_repro() {
    if [ "$REPRO_NAME" = "list" ] || [ -z "$REPRO_NAME" ]; then
        cat <<'EOF'
Known stage 3 symptoms:

  for-loop-counter-shadow
    User var named `fi` collides with emit_for's internal counter
    SSA name "fi". Auto-cache by direct name overwrites the user
    entry. Symptom: struct literals drop every-other field.
    Fixed: emit_for renamed counter to "__fi".

  match-stub
    Match expression compiles to a 13-line stub that returns the
    default value, dropping all arm dispatches. Currently the
    blocker for stage 3 self-compile.

  primitive-eq
    `let a = 122; if a == 122 { ... }` evaluates the equality
    incorrectly when one side is loaded from a struct field and
    the other from an `export mut` global. Open.

Use --repro <name> to write the repro to /tmp/_repro_<name>.fg.
EOF
        return
    fi
    local out="/tmp/_repro_${REPRO_NAME}.fg"
    case "$REPRO_NAME" in
        for-loop-counter-shadow)
            cat > "$out" <<'EOF'
fn main() {
    mut fi = 100
    let xs: List<int> = [1, 2, 3, 4]
    for x in xs {
        fi = fi + 1
    }
    println("fi=" + string(fi))
    // Expect: fi=104. Pre-fix actual: fi=102 (loop counter shadow).
}
EOF
            ;;
        match-stub)
            cat > "$out" <<'EOF'
enum K { A, B, C, D }
fn name(k: K) -> string {
    match k {
        .A -> { "a" }
        .B -> { "b" }
        .C -> { "c" }
        .D -> { "d" }
    }
}
fn main() { println(name(K.B)) }
// Expect: b. Stage 2 binary stubs the match → prints "" or default.
EOF
            ;;
        primitive-eq)
            cat > "$out" <<'EOF'
export mut THE_VAL: int = 122
type Box = { v: int }
fn main() {
    let b = Box { v: 122 }
    if b.v == THE_VAL {
        println("equal")
    } else {
        println("not equal — BUG")
    }
}
// Expect: equal. Stage 2 binary often emits "not equal".
EOF
            ;;
        *)
            echo "Unknown symptom: $REPRO_NAME (try --repro list)" >&2
            exit 1
            ;;
    esac
    echo "wrote $out"
    sed 's/^/  /' "$out"
}

# ─── --shadow-check ──────────────────────────────────────────────
# Static lint: scan for user `let/mut <name> = ...` declarations
# whose <name> matches an internal SSA-name string used in any
# `build_alloca(..., "<name>")` call elsewhere in the same file.
# Such collisions are silent bugs via the auto-cache by direct
# name path in forge_llvm_build_alloca.
run_shadow_check() {
    echo "── Scanning packages/forgec/src for var/SSA-name collisions ──"
    local internal_names
    internal_names=$(grep -rhoE 'build_alloca\([^,]*,[^,]*,[[:space:]]*"[a-zA-Z_][a-zA-Z0-9_]{0,4}"' packages/forgec/src 2>/dev/null \
        | grep -oE '"[a-zA-Z_][a-zA-Z0-9_]*"$' \
        | tr -d '"' \
        | sort -u)
    if [ -z "$internal_names" ]; then
        echo "  no internal alloca names found"
        return
    fi
    local found=0
    for n in $internal_names; do
        # Find user `let|mut <n>` declarations in the same package
        local hits
        hits=$(grep -rnE "(let|mut) +${n}( |=|:)" packages/forgec/src 2>/dev/null \
            | grep -v "build_alloca" \
            | grep -v "^[^:]*\.md:")
        if [ -n "$hits" ]; then
            yellow "  ⚠ \"$n\" — used as both internal SSA name and user variable:"
            echo "$hits" | head -5 | sed 's/^/      /'
            found=$((found + 1))
        fi
    done
    if [ "$found" = "0" ]; then
        green "  no collisions found ✓"
    else
        echo ""
        echo "  $found collisions. Each is a potential silent bug. Rename"
        echo "  EITHER the user variable OR the build_alloca name string."
    fi
}

# ─── --probe-cmp <fn> [input.fg] ─────────────────────────────────
# Patch output.ll: in <fn>, before every `icmp eq/ne i64`, emit a
# call to forge_trace_i64 (id 9999) with both operands. Then re-llc
# + re-link, run on input.fg, grep traces. Use this when an `==`
# is silently false in stage 2 binary and you can't tell which one.
run_probe_cmp() {
    if [ -z "$DIFF_FN" ]; then
        echo "Usage: diagnose.sh --probe-cmp <fn_name> [input.fg]" >&2
        exit 1
    fi
    if [ ! -f output.ll ]; then
        echo "ERROR: output.ll missing — run stage1_rust first" >&2
        exit 1
    fi
    local patched=/tmp/_probe_cmp.ll
    # Use perl (always present on macOS) for portable in-fn icmp injection.
    # For each `icmp eq/ne i64 LHS, RHS` inside the target function,
    # prepend two trace calls with LHS then RHS. We don't modify the icmp.
    perl -e '
        my $fn = $ARGV[0]; shift @ARGV;
        my $marker = "\@$fn(";
        my $in_fn = 0;
        while (<STDIN>) {
            if (index($_, "define ") == 0 && index($_, $marker) >= 0) {
                $in_fn = 1; print; next;
            }
            if ($in_fn && /^\}/) { $in_fn = 0; print; next; }
            if ($in_fn && /^\s+(?:%\S+\s+=\s+)?icmp (?:eq|ne) i64 (\S+), (\S+)$/) {
                my ($lhs, $rhs) = ($1, $2);
                $lhs =~ s/,$//;
                print "  call void \@forge_trace_i64(i64 9999, i64 $lhs)\n";
                print "  call void \@forge_trace_i64(i64 9998, i64 $rhs)\n";
            }
            print;
        }
    ' "$DIFF_FN" < output.ll > "$patched"
    local ndiff
    ndiff=$(diff output.ll "$patched" | grep -c '^>')
    echo "  injected $((ndiff / 2)) probes into @$DIFF_FN"
    if [ "$ndiff" = "0" ]; then
        echo "  no i64 == / != comparisons found in @$DIFF_FN" >&2
        return
    fi
    /opt/homebrew/opt/llvm@19/bin/llc -filetype=obj "$patched" -o /tmp/_probe.o 2>/tmp/_probe_llc.log
    if [ ! -s /tmp/_probe.o ]; then
        echo "  llc failed:"; head -5 /tmp/_probe_llc.log | sed 's/^/    /'
        return
    fi
    cc -o /tmp/_probe_bin /tmp/_probe.o build/runtime.o -lm -Wl,-stack_size,0x10000000 \
        packages/std-llvm/target/release/libforge_llvm.a \
        -L/opt/homebrew/Cellar/llvm@19/19.1.7/lib -lLLVM-19 -lstdc++ -lz -lcurses 2>/tmp/_probe_link.log
    if [ ! -x /tmp/_probe_bin ]; then
        echo "  link failed:"; head -5 /tmp/_probe_link.log | sed 's/^/    /'
        return
    fi
    if [ ! -f "$PROBE_INPUT" ]; then
        echo "  no input file ($PROBE_INPUT) — skipping run; binary at /tmp/_probe_bin"
        return
    fi
    /tmp/_probe_bin build "$PROBE_INPUT" 2>/tmp/_probe_run.log
    grep -E "9999|9998" /tmp/_probe_run.log | head -40
}

# ─── --cmp-broken ────────────────────────────────────────────────
# Battery of tiny self-contained Forge programs that exercise the
# operations stage 2 binary needs in order to self-compile. Each
# test has a known expected stdout. First failing test name is
# probably your next stage-3 bug.
run_cmp_broken() {
    local stage2_bin
    stage2_bin=$(ensure_stage2_bin) || return 1
    local pass=0 fail=0
    local tests_dir=/tmp/_cb_tests
    rm -rf "$tests_dir" && mkdir -p "$tests_dir"
    cb_run() {
        local name="$1" expected="$2" code="$3"
        local f="$tests_dir/${name}.fg"
        printf 'fn main() {\n    %s\n}\n' "$code" > "$f"
        rm -f a.out output.ll
        "$stage2_bin" build "$f" >/tmp/_cb_build_run.log 2>&1 || true
        if [ ! -x ./a.out ]; then
            red "  ✗ $name — stage 2 binary failed to compile snippet"
            tail -5 /tmp/_cb_build_run.log | sed 's/^/      /'
            fail=$((fail + 1))
            return
        fi
        local actual
        actual=$(./a.out 2>&1 | tail -5)
        if [ "$actual" = "$expected" ]; then
            green "  ✓ $name"
            pass=$((pass + 1))
        else
            red "  ✗ $name"
            echo "      expected: $expected"
            echo "      actual:   $actual"
            fail=$((fail + 1))
        fi
    }
    echo "── stage 2 binary smoke battery ──"
    cb_run "int_eq_literal"   "yes"  'if 5 == 5 { println("yes") } else { println("no") }'
    cb_run "int_eq_var"       "yes"  'let a = 122; if a == 122 { println("yes") } else { println("no") }'
    cb_run "int_eq_two_vars"  "yes"  'let a = 7; let b = 7; if a == b { println("yes") } else { println("no") }'
    cb_run "string_eq"        "yes"  'if "hi" == "hi" { println("yes") } else { println("no") }'
    cb_run "for_loop_count"   "10"   'mut s = 0; let xs: List<int> = [1,2,3,4]; for x in xs { s = s + x }; println(string(s))'
    cb_run "for_with_fi_var"  "fi=104"  'mut fi = 100; let xs: List<int> = [1,2,3,4]; for x in xs { fi = fi + 1 }; println("fi=" + string(fi))'
    cb_run "struct_4_fields"  "1 2 3 4" 'let t: List<int> = [1,2,3,4]; println(string(t[0]) + " " + string(t[1]) + " " + string(t[2]) + " " + string(t[3]))'
    echo ""
    echo "  $pass passed, $fail failed"
}

# ─── --find-stubs ────────────────────────────────────────────────
# Compare two .ll files (or snapshot labels) and list every function
# where the second has < 25% the line count of the first AND looks
# like a stub (single phi entry, returns default). Output sorted by
# how much was lost — biggest stubs first. These are the functions
# whose codegen is silently broken in stage 2 binary's compilation.
run_find_stubs() {
    local a b
    a=$(resolve_snap "$DIFF_A")
    b=$(resolve_snap "$DIFF_B")
    echo "── find-stubs: $a (ref) vs $b (target) ──"
    local fns_file=/tmp/_stubs_fns.txt
    grep -oE '^define [^@]*@[A-Za-z_][A-Za-z0-9_]*' "$a" \
        | sed 's/.*@//' | sort -u > "$fns_file"
    local results=/tmp/_stubs_results.txt
    : > "$results"
    while IFS= read -r fn; do
        local al bl
        al=$(extract_llvm_fn "$a" "$fn" | wc -l | tr -d ' ')
        bl=$(extract_llvm_fn "$b" "$fn" | wc -l | tr -d ' ')
        if [ "$al" = "0" ] || [ "$bl" = "0" ]; then continue; fi
        # Stub heuristic: target < 25% of ref AND ref ≥ 30 lines AND target ≤ 25 lines
        if [ "$al" -ge 30 ] && [ "$bl" -le 25 ] && [ $((bl * 4)) -lt "$al" ]; then
            local lost=$((al - bl))
            # Bonus: confirm it has the match-stub signature
            local sig=""
            if extract_llvm_fn "$b" "$fn" | grep -q 'phi .*\[.*\]$'; then
                sig="${sig}phi"
            fi
            if extract_llvm_fn "$b" "$fn" | grep -qE 'extractvalue.*, 0$'; then
                sig="${sig:+$sig+}tag"
            fi
            printf "%5d %5d %5d %s %s\n" "$lost" "$al" "$bl" "$fn" "${sig:-?}" >> "$results"
        fi
    done < "$fns_file"
    local count
    count=$(wc -l < "$results" | tr -d ' ')
    if [ "$count" = "0" ]; then
        green "  no stubs found ✓"
        return
    fi
    echo ""
    echo "  found $count stubbed functions (sorted by lines lost):"
    echo ""
    printf "  %5s %5s %5s  %s\n" "lost" "ref" "tgt" "function"
    sort -rn "$results" | head -50 | sed 's/^/  /'
    echo ""
    echo "  signatures: phi=single phi entry, tag=extract+zext (match dispatch stub)"
    echo "  full list:  sort -rn $results"
}

run_dump_bisect() {
    if [ -z "$DIFF_FN" ]; then
        echo "Usage: diagnose.sh --dump-bisect <fn_name>" >&2
        exit 1
    fi
    rm -rf /tmp/forge_dump && mkdir -p /tmp/forge_dump
    echo "── running stage1_rust with FORGE_DEBUG_DUMP=$DIFF_FN ──"
    FORGE_DEBUG_DUMP="$DIFF_FN" LLVM_SYS_191_PREFIX=/opt/homebrew/opt/llvm@19 \
        ./target/release/forgec build packages/forgec/src/main.fg --dev -o /tmp/_dump_test \
        > /tmp/_dump_run.log 2>&1
    local count
    count=$(ls /tmp/forge_dump/*.ll 2>/dev/null | wc -l | tr -d ' ')
    echo "  produced $count step dumps in /tmp/forge_dump/"
    if [ "$count" = "0" ]; then
        echo "  no dumps — function $DIFF_FN was never compiled" >&2
        echo "  available functions in module:" >&2
        grep -oE "^define [^@]*@[A-Za-z_][A-Za-z0-9_]*" /tmp/_dump_test 2>/dev/null \
            | sed 's/.*@//' | sort -u | head -20 | sed 's/^/    /' >&2
        return
    fi
    echo ""
    echo "── per-step diffs (only non-empty shown) ──"
    local files=( $(ls /tmp/forge_dump/*.ll | sort) )
    local prev=""
    local step=0
    for f in "${files[@]}"; do
        if [ -n "$prev" ]; then
            local n
            n=$(diff "$prev" "$f" | wc -l | tr -d ' ')
            if [ "$n" != "0" ]; then
                local label
                label=$(basename "$f" .ll | sed 's/^[0-9]*_//')
                printf "  step %3d  %5d lines  %s\n" "$step" "$n" "$label"
            fi
        fi
        prev="$f"
        step=$((step + 1))
    done
    echo ""
    echo "  inspect: diff /tmp/forge_dump/<a>.ll /tmp/forge_dump/<b>.ll"
}

run_crash_asm() {
    local bin="$CRASH_BIN"
    if [ ! -x "$bin" ]; then
        echo "ERROR: binary $bin not found or not executable" >&2
        exit 1
    fi
    # Get the function's start address from nm.
    local start
    start=$(nm "$bin" 2>/dev/null | awk -v fn="$DIFF_FN" '$3 == "_"fn || $3 == fn {print "0x"$1; exit}')
    if [ -z "$start" ]; then
        echo "ERROR: symbol $DIFF_FN not found in $bin" >&2
        echo "  candidates:" >&2
        nm "$bin" 2>/dev/null | grep -i "$DIFF_FN" | head -5 >&2
        exit 1
    fi
    local pc
    pc=$(printf "0x%x" $((start + CRASH_OFF)))
    echo "── disassembly: $DIFF_FN+$CRASH_OFF in $bin ──"
    echo "  symbol start: $start"
    echo "  crash pc:     $pc"
    echo ""
    # Use lldb to disassemble. ±20 instructions = 80 bytes.
    local lo hi
    lo=$(printf "0x%x" $((start + CRASH_OFF - 80)))
    hi=$(printf "0x%x" $((start + CRASH_OFF + 80)))
    lldb -batch -o "disassemble --start-address $lo --end-address $hi" "$bin" 2>&1 \
        | grep -E "^[ →]|0x[0-9a-f]+" \
        | awk -v pc="$pc" '
            { mark=" "; if (index($0, pc) > 0) mark=">"; print mark " " $0 }
        ' | head -50
}

run_show_fn() {
    if [ -z "$DIFF_FN" ]; then
        echo "Usage: diagnose.sh --show-fn <fn_name>" >&2
        echo "  Compares stage 2 IR with stage 3 IR for one function." >&2
        exit 1
    fi
    # Prefer the pipeline's stable copy. The cwd `output.ll` gets clobbered
    # any time someone runs stage1_rust on a small test program.
    local s2=/tmp/stage1_output.ll
    [ -f "$s2" ] || s2=output.ll
    local s3=/tmp/output.ll
    [ -f "$s2" ] || { echo "ERROR: $s2 not found — run --pipeline first" >&2; exit 1; }
    [ -f "$s3" ] || { echo "ERROR: $s3 not found — run --pipeline first" >&2; exit 1; }
    local s2_lines s3_lines
    s2_lines=$(extract_llvm_fn "$s2" "$DIFF_FN" | wc -l | tr -d ' ')
    s3_lines=$(extract_llvm_fn "$s3" "$DIFF_FN" | wc -l | tr -d ' ')
    echo "═══ $DIFF_FN ═══"
    echo "  output.ll      (stage 2 IR, rust-compiled, executed by stage 2 bin): $s2_lines lines"
    echo "  /tmp/output.ll (stage 3 IR, stage-2-bin emitted):                    $s3_lines lines"
    if [ "$s3_lines" -lt 20 ] && [ "$s2_lines" -gt 50 ]; then
        echo "  ⚠ stage 3 looks like a STUB (stage 2 has $s2_lines lines, stage 3 only $s3_lines)"
    fi
    echo ""
    echo "── stage 3 IR (/tmp/output.ll) ──"
    extract_llvm_fn "$s3" "$DIFF_FN"
    echo ""
    echo "── stage 2 IR (output.ll) — first 80 lines ──"
    extract_llvm_fn "$s2" "$DIFF_FN" | head -80
}

run_binop_test() {
    local stage2_bin
    echo "═══ Binary-op runtime check ═══"
    echo "  Compiles test programs with build/stage1_rust (oracle) and"
    echo "  the resolved stage2 compiler (suspect), runs both, compares output."
    echo ""

    if [ ! -x build/stage1_rust ]; then
        echo "  ✗ build/stage1_rust missing — run --pipeline first" >&2
        return 1
    fi
    stage2_bin=$(ensure_stage2_bin) || return 1

    local pass=0 fail=0 fixtures=/tmp/_binop_fixtures
    rm -rf "$fixtures"; mkdir -p "$fixtures"

    # Each test: name, source, expected stdout
    write_case() {
        local name="$1"; local src="$2"; local exp="$3"
        printf '%s' "$src" > "$fixtures/$name.fg"
        printf '%s' "$exp" > "$fixtures/$name.expected"
    }

    write_case "add" \
'fn f(n: int) -> int { n + 5 }
fn main() { println(string(f(10))) }
' "15"

    write_case "sub" \
'fn f(n: int) -> int { n - 3 }
fn main() { println(string(f(10))) }
' "7"

    write_case "mul" \
'fn f(n: int) -> int { n * 4 }
fn main() { println(string(f(3))) }
' "12"

    write_case "eq_true" \
'fn f(n: int) -> int { if n == 5 { 100 } else { 200 } }
fn main() { println(string(f(5))) }
' "100"

    write_case "eq_false" \
'fn f(n: int) -> int { if n == 5 { 100 } else { 200 } }
fn main() { println(string(f(7))) }
' "200"

    write_case "lt" \
'fn f(n: int) -> int { if n < 5 { 1 } else { 2 } }
fn main() { println(string(f(3))) }
' "1"

    write_case "and_tt" \
'fn f(a: int, b: int) -> int { if a == 1 && b == 2 { 9 } else { 0 } }
fn main() { println(string(f(1, 2))) }
' "9"

    write_case "and_tf" \
'fn f(a: int, b: int) -> int { if a == 1 && b == 2 { 9 } else { 0 } }
fn main() { println(string(f(1, 3))) }
' "0"

    write_case "or" \
'fn f(a: int) -> int { if a == 1 || a == 2 { 9 } else { 0 } }
fn main() { println(string(f(2))) }
' "9"

    write_case "match_enum" \
'enum Color { Red, Green, Blue }
fn name_of(c: Color) -> string { match c { .Red -> "red"  .Green -> "green"  .Blue -> "blue" } }
fn main() { println(name_of(Color.Green)) }
' "green"

    printf "  %-12s  %-10s  %-10s  %s\n" "case" "stage1" "stage2" "expected"
    printf "  %-12s  %-10s  %-10s  %s\n" "----" "------" "------" "--------"

    local oracle_log=/tmp/_binop_oracle.log
    : > "$oracle_log"
    local stage2_bin
    stage2_bin=$(ensure_stage2_bin) || return 1

    for src in "$fixtures"/*.fg; do
        local name; name=$(basename "$src" .fg)
        local exp; exp=$(cat "$fixtures/$name.expected")

        local s1_out s2_out s1_status s2_status
        rm -f a.out
        if build/stage1_rust build "$src" >/dev/null 2>&1 && [ -x a.out ]; then
            s1_out=$(./a.out 2>&1 | tr -d '\n'); s1_status=$?
        else
            s1_out="<build-fail>"; s1_status=99
        fi

        rm -f a.out output.ll
        if "$stage2_bin" build "$src" >/dev/null 2>&1 && [ -x a.out ]; then
            s2_out=$(./a.out 2>&1 | tr -d '\n'); s2_status=$?
        else
            s2_out="<build-fail>"; s2_status=99
        fi

        local mark=" "
        if [ "$s1_out" = "$exp" ] && [ "$s2_out" = "$exp" ]; then
            mark=$(printf "\033[32m✓\033[0m")
            pass=$((pass + 1))
        elif [ "$s1_out" != "$exp" ]; then
            mark=$(printf "\033[33m?\033[0m")  # oracle disagrees — bad fixture
            echo "ORACLE-FAIL: $name s1='$s1_out' exp='$exp'" >> "$oracle_log"
            fail=$((fail + 1))
        else
            mark=$(printf "\033[31m✗\033[0m")
            fail=$((fail + 1))
        fi
        printf "  %s %-12s %-10s  %-10s  %s\n" "$mark" "$name" "$s1_out" "$s2_out" "$exp"
    done

    rm -f a.out
    echo ""
    echo "  pass=$pass fail=$fail"
    if [ -s "$oracle_log" ]; then
        echo "  (oracle-fails are bad fixtures, not stage 2 bugs — see $oracle_log)"
    fi
}

run_progress() {
    echo "═══════════════════════════════════════════════════════"
    echo " Stage 3 self-compile progress"
    echo "═══════════════════════════════════════════════════════"
    local s2=/tmp/stage1_output.ll
    [ -f "$s2" ] || s2=output.ll
    local s3=/tmp/output.ll
    if [ ! -f "$s2" ] || [ ! -f "$s3" ]; then
        echo "  ✗ need both $s2 and $s3 — run --pipeline first" >&2
        return 1
    fi

    # ──────────────────────────────────────────────
    # 1. Function count parity
    # ──────────────────────────────────────────────
    local s2_fns s3_fns
    s2_fns=$(grep -c "^define" "$s2")
    s3_fns=$(grep -c "^define" "$s3")
    local fn_pct=0
    if [ "$s2_fns" -gt 0 ]; then
        fn_pct=$(( s3_fns * 100 / s2_fns ))
    fi
    echo ""
    echo "── 1. Function-count parity ──"
    printf "  stage 2 IR: %d functions\n" "$s2_fns"
    printf "  stage 3 IR: %d functions   (%d%%)\n" "$s3_fns" "$fn_pct"

    # ──────────────────────────────────────────────
    # 2. Per-function body parity
    # ──────────────────────────────────────────────
    echo ""
    echo "── 2. Per-function body parity ──"
    python3 - "$s2" "$s3" <<'PY'
import re, sys, hashlib
def parse(path):
    fns = {}
    cur, body = None, []
    with open(path) as f:
        for line in f:
            m = re.match(r'define\s+\S+\s+@(\w+)\(', line)
            if m:
                if cur:
                    fns[cur] = body
                cur = m.group(1); body = [line]
            elif cur is not None:
                body.append(line)
                if line.startswith('}'):
                    fns[cur] = body
                    cur, body = None, []
    return fns

a = parse(sys.argv[1])
b = parse(sys.argv[2])
common = sorted(set(a) & set(b))
if not common:
    print("  no common functions"); sys.exit(0)

ident = 0   # byte-identical bodies
close = 0   # within 10% line-count
stub  = 0   # stage3 < 25% of stage2 lines, suggests stub
diff_score_total = 0

stub_examples = []
for name in common:
    al, bl = len(a[name]), len(b[name])
    # normalize: drop bbN labels (auto-numbered) and SSA register numbers
    def norm(lines):
        s = ''.join(lines)
        s = re.sub(r'%\d+', '%v', s)
        s = re.sub(r'bb\d+', 'bb', s)
        s = re.sub(r'@\d+', '@N', s)  # global string indices
        return s
    if norm(a[name]) == norm(b[name]):
        ident += 1
    elif al > 0 and abs(al - bl) <= max(2, al // 10):
        close += 1
    elif al > 30 and bl < al // 4:
        stub += 1
        if len(stub_examples) < 10:
            stub_examples.append((name, al, bl))
    diff_score_total += abs(al - bl)

n = len(common)
print(f"  byte-identical:    {ident}/{n}  ({ident*100//n}%)")
print(f"  close (<=10% diff): {close}/{n}  ({close*100//n}%)")
print(f"  stub (s3<25% s2):  {stub}/{n}  ({stub*100//n}%)")
print(f"  avg line drift:    {diff_score_total/n:.1f} lines/fn")

if stub_examples:
    print("")
    print("  worst stubs (top 10 by stage2 line count):")
    stub_examples.sort(key=lambda x: -x[1])
    for name, al, bl in stub_examples:
        print(f"    {name:38s} stage2={al:5d}  stage3={bl:5d}")

# Body-parity score: identical full credit, close half credit
body_pct = (ident * 100 + close * 50) // n
print(f"")
print(f"  BODY PARITY:       {body_pct}%")
PY
    local body_pct
    body_pct=$(python3 - "$s2" "$s3" <<'PY'
import re, sys
def parse(p):
    fns={}; cur=None; body=[]
    for line in open(p):
        m=re.match(r'define\s+\S+\s+@(\w+)\(', line)
        if m:
            if cur: fns[cur]=body
            cur=m.group(1); body=[line]
        elif cur is not None:
            body.append(line)
            if line.startswith('}'): fns[cur]=body; cur=None; body=[]
    return fns
a=parse(sys.argv[1]); b=parse(sys.argv[2])
common=sorted(set(a)&set(b))
if not common: print(0); sys.exit(0)
def norm(ls):
    s=''.join(ls); s=re.sub(r'%\d+','%v',s); s=re.sub(r'bb\d+','bb',s); s=re.sub(r'@\d+','@N',s); return s
ident=close=0
for n in common:
    al,bl=len(a[n]),len(b[n])
    if norm(a[n])==norm(b[n]): ident+=1
    elif al>0 and abs(al-bl)<=max(2,al//10): close+=1
print((ident*100+close*50)//len(common))
PY
)

    # ──────────────────────────────────────────────
    # 3. Stage 3 functional smoke tests
    # ──────────────────────────────────────────────
    echo ""
    echo "── 3. Stage 3 binary functional checks ──"
    local s3_bin=/tmp/stage3
    local hello_pass=0 binop_pass=0 binop_total=0
    # Stage 3 currently has infinite-loop bugs on real input — wrap every
    # invocation in a 5-second perl alarm.
    s3run() { perl -e 'alarm 5; exec @ARGV' "$@" 2>/dev/null; }

    if [ ! -x "$s3_bin" ]; then
        echo "  ✗ /tmp/stage3 missing — run --pipeline first" >&2
    else
        # 3a. Trivial hello
        cat > /tmp/_p_hello.fg <<'FG'
fn main() { println("hi") }
FG
        rm -f a.out
        if s3run "$s3_bin" build /tmp/_p_hello.fg && [ -x a.out ]; then
            local out
            out=$(perl -e 'alarm 3; exec "./a.out"' 2>&1 | tr -d '\n')
            if [ "$out" = "hi" ]; then
                hello_pass=1
                echo "  ✓ stage 3 binary compiles and runs hello-world"
            else
                echo "  ✗ stage 3 hello-world produced: '$out' (expected 'hi')"
            fi
        else
            echo "  ✗ stage 3 binary hangs/fails on hello-world"
        fi
        rm -f a.out

        # 3b. Run binop fixtures through stage 3 (not stage 2)
        local fixtures=/tmp/_binop_fixtures
        if [ -d "$fixtures" ]; then
            for src in "$fixtures"/*.fg; do
                local exp; exp=$(cat "${src%.fg}.expected")
                rm -f a.out
                if s3run "$s3_bin" build "$src" && [ -x a.out ]; then
                    local out; out=$(perl -e 'alarm 3; exec "./a.out"' 2>&1 | tr -d '\n')
                    if [ "$out" = "$exp" ]; then
                        binop_pass=$((binop_pass + 1))
                    fi
                fi
                binop_total=$((binop_total + 1))
            done
            rm -f a.out
            local binop_pct=0
            [ "$binop_total" -gt 0 ] && binop_pct=$(( binop_pass * 100 / binop_total ))
            printf "  binop fixtures via stage 3: %d/%d (%d%%)\n" "$binop_pass" "$binop_total" "$binop_pct"
        else
            echo "  (no binop fixtures — run --binop-test once first)"
        fi
    fi

    # ──────────────────────────────────────────────
    # 4. Composite score
    # ──────────────────────────────────────────────
    echo ""
    echo "── 4. Composite progress ──"
    local binop_pct=0
    [ "${binop_total:-0}" -gt 0 ] && binop_pct=$(( binop_pass * 100 / binop_total ))
    # Weighting:
    #   fn_pct        20%   (function count parity)
    #   body_pct      40%   (function body parity, the hard part)
    #   hello_pass    10%   (binary boots and produces output)
    #   binop_pct     30%   (runtime semantics correct)
    local composite=$(( fn_pct * 20 / 100 + body_pct * 40 / 100 + hello_pass * 10 + binop_pct * 30 / 100 ))
    printf "  fn-count parity:  %3d%%   (×0.20)\n" "$fn_pct"
    printf "  body parity:      %3d%%   (×0.40)\n" "$body_pct"
    printf "  hello-world boot: %3d%%   (×0.10)\n" "$((hello_pass * 100))"
    printf "  binop runtime:    %3d%%   (×0.30)\n" "$binop_pct"
    echo  "                  ─────────"
    printf "  PROGRESS:         %3d%%\n" "$composite"
    echo ""
    if [ "$composite" -ge 90 ]; then
        green "  ★ stage 3 self-compile is within reach"
    elif [ "$composite" -ge 60 ]; then
        yellow "  → solid runway; keep fixing the worst stubs"
    elif [ "$composite" -ge 30 ]; then
        yellow "  → infrastructure is up; semantics still half-broken"
    else
        red "  → early days"
    fi
}

run_ret_undef() {
    if [ ! -f "$IR" ]; then echo "ERROR: $IR not found" >&2; exit 1; fi
    echo "═══ Functions returning undef (missing build_ret coercion) — $IR ═══"
    python3 - "$IR" <<'PY'
import re, sys, collections
fn = None
ret_ty = None
hits = collections.defaultdict(list)
with open(sys.argv[1]) as f:
    for line in f:
        m = re.match(r'define\s+(\S+)\s+@(\w+)\(', line)
        if m:
            fn = m.group(2); ret_ty = m.group(1); continue
        if fn and re.search(r'^\s*ret\s+\S+\s+undef\s*$', line):
            hits[ret_ty].append(fn)
            fn = None
total = 0
for ty, fns in sorted(hits.items(), key=lambda kv: -len(kv[1])):
    seen = []
    for n in fns:
        if n not in seen: seen.append(n)
    total += len(seen)
    print(f"  ret {ty} undef  ({len(seen)} fns)")
    for n in seen[:20]:
        print(f"    {n}")
    if len(seen) > 20:
        print(f"    ... +{len(seen)-20} more")
print(f"\nTOTAL: {total} functions emit `ret <T> undef`")
print("These usually mean self-host's emit_ret_value passed a value whose")
print("LLVM type didn't match the function's declared return. Common cause:")
print("missing inttoptr/ptrtoint coercion in forge_llvm_build_ret wrapper.")
PY
}

run_container_abi() {
    if [ ! -f "$IR" ]; then echo "ERROR: $IR not found" >&2; exit 1; fi
    echo "═══ Container ABI audit — $IR ═══"
    python3 - "$IR" <<'PY'
import pathlib, re, sys

ir_path = pathlib.Path(sys.argv[1])
src_root = pathlib.Path("packages/forgec/src")

sig_re = re.compile(r'\bfn\s+([A-Za-z_][A-Za-z0-9_]*)\s*\((.*?)\)\s*(?:->\s*([^{]+))?')
param_re = re.compile(r':\s*([^,)]+)')
decls = {}

for path in src_root.rglob("*.fg"):
    text = re.sub(r'\s+', ' ', path.read_text())
    for match in sig_re.finditer(text):
        name = match.group(1)
        params_src = match.group(2) or ""
        ret_src = (match.group(3) or "").strip()
        params = [p.strip() for p in param_re.findall(params_src)]
        has_container = any(p.startswith("List<") or p.startswith("Map<") for p in params)
        has_container = has_container or ret_src.startswith("List<") or ret_src.startswith("Map<")
        if has_container:
            decls[name] = {"path": str(path), "params": params, "ret": ret_src}

if not decls:
    print("  no List<T>/Map<K,V> source signatures found")
    sys.exit(0)

ir = ir_path.read_text()
ir_sig_re = re.compile(r'^define\s+(.+?)\s+@([A-Za-z_][A-Za-z0-9_]*)\((.*?)\)\s*\{', re.M)
issues = []
checked = 0

for ret_ty, name, params_src in ir_sig_re.findall(ir):
    if name not in decls:
        continue
    checked += 1
    src = decls[name]
    ir_params = []
    if params_src.strip():
        ir_params = [p.strip() for p in re.split(r',\s*(?![^{}]*\})', params_src)]
    if len(ir_params) != len(src["params"]):
        issues.append((name, src["path"], f"param-count source={len(src['params'])} ir={len(ir_params)}"))
        continue
    for idx, src_param in enumerate(src["params"]):
        if src_param.startswith("List<") or src_param.startswith("Map<"):
            if "%ForgeString" in ir_params[idx]:
                issues.append((name, src["path"], f"param {idx} lowered to ForgeString: {src_param} -> {ir_params[idx]}"))
    if (src["ret"].startswith("List<") or src["ret"].startswith("Map<")) and "%ForgeString" in ret_ty:
        issues.append((name, src["path"], f"return lowered to ForgeString: {src['ret']} -> {ret_ty}"))

if not checked:
    print("  no matching IR definitions found for source container signatures")
    sys.exit(0)

if not issues:
    print(f"  checked {checked} functions with container signatures")
    print("  no List<T>/Map<K,V> -> %ForgeString signature aliases found ✓")
    sys.exit(0)

for name, path, msg in issues:
    print(f"  {name:32s} {msg}")
    print(f"      source: {path}")
print()
print(f"TOTAL: {len(issues)} container ABI mismatches")
PY
}

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
    local STAGE2
    STAGE2=$(ensure_stage2_bin) || return 1

    echo "═══════════════════════════════════════════════"
    echo " Stage 2 Functional Tests"
    echo "═══════════════════════════════════════════════"
    echo " Using compiler: $STAGE2"

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
    if [ -f "/tmp/stage2" ] || [ -f "build/stage2" ] || [ -f "$DEFAULT_STAGE2_LL" ]; then
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
    local STAGE2_BIN
    STAGE2_BIN=$(ensure_stage2_bin) || return 1

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
    "$STAGE2_BIN" build "$ABS_SRC" >/tmp/_s3_out.log 2>&1 || true
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
    "$LLC_BIN" -O2 -filetype=obj /tmp/output.ll -o /tmp/stage3.o 2>/tmp/_s3_llc.log
    if [ -s /tmp/stage3.o ] && ! grep -q "error:" /tmp/_s3_llc.log; then
        pass "llc → object file"
    else
        fail "llc → object file" "$(head -1 /tmp/_s3_llc.log)"
        return
    fi

    local llvm_libs
    llvm_libs="$("$LLVM_CONFIG_BIN" --ldflags --libs core analysis bitwriter)"
    cc -o /tmp/stage3 /tmp/stage3.o "$RUNTIME_O" -lm -Wl,-stack_size,0x10000000 \
        "$STD_LLVM_LIB" $llvm_libs -lstdc++ -lz -lcurses 2>/tmp/_s3_link.log
    if [ -x /tmp/stage3 ] && ! grep -q "error:" /tmp/_s3_link.log; then
        pass "cc → /tmp/stage3 executable"
    else
        fail "Linker" "$(head -1 /tmp/_s3_link.log)"
        return
    fi

    echo ""
    echo "── Stage 3 Run (60s hard timeout) ──"
    # Stage 3 has known infinite-loop bugs on real input. ALWAYS bound it.
    # If you don't, the pipeline silently hangs forever and zombie procs
    # accumulate at 85% CPU (we've collected 6+ in a single afternoon).
    rm -f /tmp/_s3_runlog
    ( /tmp/stage3 build "$FORGE_SRC/main.fg" >/tmp/_s3_runlog 2>&1 ) &
    local s3_pid=$!
    local waited=0
    while kill -0 "$s3_pid" 2>/dev/null; do
        if [ "$waited" -ge 60 ]; then
            kill -9 "$s3_pid" 2>/dev/null
            wait "$s3_pid" 2>/dev/null
            fail "Stage 3 exits 0" "TIMEOUT after 60s — INFINITE LOOP"
            local lines=$(wc -l < /tmp/_s3_runlog 2>/dev/null | tr -d ' ')
            echo "  last $lines lines of output before timeout:"
            tail -10 /tmp/_s3_runlog 2>/dev/null | sed 's/^/    /'
            return
        fi
        sleep 1
        waited=$((waited+1))
    done
    wait "$s3_pid"
    EXIT=$?
    if [ "$EXIT" -eq 0 ]; then
        pass "Stage 3 exits 0 (after ${waited}s)"
    else
        fail "Stage 3 exits 0" "exit $EXIT after ${waited}s"
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
    cp -f output.ll "$DEFAULT_STAGE2_LL"
    if build_compiler_from_ir "$DEFAULT_STAGE2_LL" "$DEFAULT_STAGE2_BIN" "${DEFAULT_STAGE2_BIN}.o" \
        /tmp/_p2llc.log /tmp/_p2link.log; then
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

run_llvm_decls() {
    python3 - <<'PY'
import pathlib, re, sys

code = pathlib.Path("packages/forgec/src/codegen/mod.fg").read_text()
wrappers = sorted(set(re.findall(r'llvm\.([A-Za-z0-9_]+)\(', code)))
declared = set(re.findall(r'"(forge_llvm_[A-Za-z0-9_]+(?:_s)?)"', code))

missing = []
for name in wrappers:
    expected = [f"forge_llvm_{name}", f"forge_llvm_{name}_s"]
    if not any(sym in declared for sym in expected):
        missing.append((name, expected))

print("═══ LLVM Decl Audit ═══")
if not missing:
    print("  all llvm.* wrappers used by self-host codegen are declared ✓")
    sys.exit(0)

for name, expected in missing:
    print(f"  missing llvm.{name} -> one of: {', '.join(expected)}")
sys.exit(1)
PY
}

run_body_reparse() {
    if [ -z "${BODY_REPARSE_SRC:-}" ]; then
        echo "Usage: diagnose.sh --body-reparse <src.fg>" >&2
        return 2
    fi
    if [ ! -f "$BODY_REPARSE_SRC" ]; then
        echo "Source file not found: $BODY_REPARSE_SRC" >&2
        return 2
    fi

    local STAGE2
    STAGE2=$(ensure_stage2_bin) || return 1
    local TMP_BIN=/tmp/forge_body_reparse.bin

    "$STAGE2" build "$BODY_REPARSE_SRC" "$TMP_BIN" 2>&1 | \
        grep -E '^(\[STORE\]|  \[FN_ADD\]|  \[fn_store|  >> |  \[TOK\]|  \[BODY\]|  \[T\] 7777|  \[EBS\]|  \[extract_body\])' || true
}

# #3 — "Why is this i64?" reverse lookup. Given a function name and
# parameter name (or index), parses the source signature, identifies
# the source-level type, then walks resolve_type_to_llvm's actual
# decision tree against the known registrations and reports which
# rule the type hits — and whether that rule produces i64 or not.
run_whyi64() {
    if [ -z "$DIFF_FN" ]; then
        echo "Usage: diagnose.sh --whyi64 <fn_name> <param_index_or_name>" >&2
        exit 1
    fi
    echo "═══ Why is this i64?  @$DIFF_FN  param=$WHYI64_PARAM ═══"
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
    # Find the source declaration and parse the param type.
    # Forge naming: free fn → just the name; method → <Class>_<method>.
    # Try several name forms.
    local candidates=()
    candidates+=("$DIFF_FN")
    if [[ "$DIFF_FN" == *_* ]]; then
        candidates+=("${DIFF_FN#*_}")  # strip first underscore segment (class name)
    fi
    local src_line=""
    for c in "${candidates[@]}"; do
        src_line=$(grep -rn --include='*.fg' -E "^\s*(export\s+)?fn ${c}\s*\(" packages/forgec/src/ 2>/dev/null | head -1)
        if [ -n "$src_line" ]; then break; fi
    done
    if [ -z "$src_line" ]; then
        echo "  no source declaration found for fn (tried: ${candidates[@]})"
        return 1
    fi
    echo "  Source declaration:"
    echo "    $src_line"
    echo ""
    python3 - "$src_line" "$WHYI64_PARAM" "$DIFF_FN" <<'PY'
import sys, re, os
src_line = sys.argv[1]
param_query = sys.argv[2]
fn_name = sys.argv[3]
file_path, _, rest = src_line.partition(':')
line_no, _, decl = rest.partition(':')
m = re.search(r'fn\s+\w+\s*\(([^)]*)\)\s*(?:->\s*([^\s{]+))?', decl)
if not m:
    print("  could not parse fn signature")
    sys.exit(1)
params_raw = m.group(1).strip()
ret_ty = (m.group(2) or 'void').strip()
params = []
if params_raw:
    for p in params_raw.split(','):
        p = p.strip()
        if not p: continue
        nm, _, ty = p.partition(':')
        params.append((nm.strip(), ty.strip()))

print(f"  Parsed params:")
for i, (n, t) in enumerate(params):
    marker = ""
    if param_query and (param_query == n or param_query == str(i)):
        marker = "  ← querying"
    print(f"    [{i}] {n}: {t}{marker}")
print(f"  Return type: {ret_ty}")
print()

# Pick the param to trace
target = None
target_idx = -1
for i, (n, t) in enumerate(params):
    if param_query == n or param_query == str(i):
        target = t
        target_idx = i
        break
if target is None and params:
    print(f"  param '{param_query}' not found; tracing return type instead")
    target = ret_ty

if target is None:
    sys.exit(0)

# Strip nullable suffix and List<T>/Map<K,V> wrappers
print(f"  Type to resolve: '{target}'")
print()

# Walk resolve_type_to_llvm decision tree
print(f"  resolve_type_to_llvm('{target}') decision tree:")

primitive = {'string': 'CG_STR (16-byte struct)',
             'int': 'CG_I64 (8 bytes)',
             'float': 'CG_I64 (8 bytes — float fallback)',
             'bool': 'CG_I64 (8 bytes — bool fallback)',
             'ptr': 'CG_I64 (8 bytes — ptr fallback!)'}
if target in primitive:
    print(f"    1. PRIMITIVE → {primitive[target]}")
    print(f"       This is the expected path. No bug here.")
    sys.exit(0)

list_match = re.match(r'List(<.*>)?$', target) or target.startswith('List:') or target == 'List' or target == 'list'
if list_match or target.startswith('list:'):
    print(f"    2. LIST<T> → CG_LIST (16-byte {{ptr,i64}})")
    sys.exit(0)

map_match = target.startswith('Map') or target.startswith('map')
if map_match:
    print(f"    3. Map<K,V> → CG_MAP (24-byte {{ptr,ptr,i64}})")
    sys.exit(0)

# Strip the trailing ? for nullable check
inner = target.rstrip('?')

# At this point: not a primitive, not List, not Map. The source
# type is some user-defined struct or enum. Check whether it's
# registered.
print(f"    4. forge_get_type_by_name_i64('{inner}') — LLVM named type registry")
print(f"       True if cg_init_str / cg_register_core_types registered it.")
print()
print(f"    5. forge_enum_type_exists('{inner}') — C-side enum registry")
print(f"       True if forge_enum_type_register was called for this enum.")

# Search for the enum declaration in source
ast_files = []
for root, dirs, files in os.walk('packages/forgec/src'):
    for f in files:
        if f.endswith('.fg'):
            ast_files.append(os.path.join(root, f))
enum_line = None
for f in ast_files:
    try:
        with open(f) as fh:
            for ln, line in enumerate(fh, 1):
                if re.match(rf'^\s*(export\s+)?enum\s+{re.escape(inner)}\b', line):
                    enum_line = f"{f}:{ln}: {line.rstrip()}"
                    break
    except: pass
    if enum_line: break

if enum_line:
    print(f"       FOUND: {enum_line}")
    print()
    # Check if it's registered in cg_register_core_types
    cg_mod = "packages/forgec/src/codegen/mod.fg"
    if os.path.exists(cg_mod):
        with open(cg_mod) as fh:
            content = fh.read()
        reg_match = re.search(rf'forge_enum_type_register\s*\(\s*"{re.escape(inner)}"', content)
        if reg_match:
            print(f"       ✓ {inner} IS registered in mod.fg via forge_enum_type_register")
            print(f"       → resolve_type_to_llvm returns the enum LLVM type. Param should NOT be i64.")
            print(f"       → if the IR shows i64, the bug is in declare_all_fns / emit_all_fn_bodies")
            print(f"         not consulting the enum type when building the function signature.")
        else:
            print(f"       ✗ {inner} is NOT registered in mod.fg")
            print(f"       → resolve_type_to_llvm falls through to step 6 → returns CG_I64")
            print(f"       → THIS is why the param is i64. Add forge_enum_type_register('{inner}', N)")
            print(f"         to cg_register_core_types() in mod.fg.")
else:
    print(f"       (no enum {inner} found in source)")
print()
print(f"    6. forge_struct_type_get_fields('{inner}') — C-side struct registry")
print(f"       True if check_type_decl was called for the type definition.")
print()
print(f"    7. FALLTHROUGH → CG_I64 (the bug surface)")
PY
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

# --bugs — unified bug enumeration. Runs every detection method we
# have and produces a deduplicated, ranked list. This is the answer
# to "what's broken right now?" — instead of running 6 sub-tools.
#
# Detection methods:
#   1. Type divergence (--type-diff): function signatures that differ
#      between rust and self-host emit. The "i64 fallback" infection.
#   2. Anomaly score (--anomaly): per-function score from orphans,
#      undef args, ret-undef, etc. Top of list = closest to broken.
#   3. Verify failures (FORGE_DEBUG_VERIFY=1): functions that fail
#      LLVMVerifyFunction during stage1_rust execution.
#   4. Regression failures (--regress): existing minimal repros that
#      no longer pass.
#   5. Stage 2 binary smoke test: does stage2_bin compile hello world?
#   6. Stage 3 binary smoke test: does the stage 3 binary actually run?
run_bugs() {
    local A="${DIFF_A:-/tmp/stage1.ll}"
    local B="${DIFF_B:-/tmp/stage2.ll}"
    local LLVM_PREFIX="${LLVM_SYS_191_PREFIX:-/opt/homebrew/opt/llvm@19}"
    echo "═══════════════════════════════════════════════════════════"
    echo " Forge Pre-existing Bug Report"
    echo "═══════════════════════════════════════════════════════════"

    # ── Phase 1: ensure both .ll files are fresh ────────────────
    echo ""
    echo "── Setting up: rebuild stage 1 + stage 2 IR ──"
    if [ ! -x ./build/stage1_rust ]; then
        echo "  ERROR: ./build/stage1_rust not built. Run 'make stage1-rust' first." >&2
        exit 1
    fi
    LLVM_SYS_191_PREFIX="$LLVM_PREFIX" ./target/release/forgec build packages/forgec/src/main.fg --emit-ir 2>/dev/null > "$A" || {
        echo "  ✗ rust forgec failed to emit stage 1 IR" >&2; exit 1; }
    ./build/stage1_rust build packages/forgec/src/main.fg >/dev/null 2>&1 || true
    if [ ! -f output.ll ]; then
        echo "  ✗ stage1_rust did not produce output.ll" >&2; exit 1
    fi
    cp output.ll "$B"
    echo "  ✓ $A ($(wc -l < $A | tr -d ' ') lines)"
    echo "  ✓ $B ($(wc -l < $B | tr -d ' ') lines)"

    # ── Phase 2: aggregate bugs from each detection method ─────
    local report="/tmp/_bugs_report.txt"
    : > "$report"

    # Method A: type divergence
    echo ""
    echo "── A. Function signature divergences (rust vs self-host) ──"
    python3 - "$A" "$B" "$report" <<'PY'
import re, sys
A_path, B_path, report = sys.argv[1], sys.argv[2], sys.argv[3]
def parse_sigs(path):
    sigs = {}
    pat = re.compile(r'^define\s+([^@]*?)\s*@(\w+)\s*\(([^)]*)\)')
    with open(path) as f:
        for line in f:
            m = pat.match(line)
            if m:
                ret = m.group(1).strip()
                name = m.group(2)
                ps = []
                if m.group(3).strip():
                    for p in m.group(3).split(','):
                        p = p.strip()
                        m2 = re.match(r'(.*?)\s*%[\w\.]*$', p)
                        ty = (m2.group(1) if m2 else p).strip()
                        ty = re.sub(r'^(signext|zeroext|inreg|byval\([^)]*\)|byref\([^)]*\)|nonnull|noundef|nofree|noalias|nocapture|readonly|readnone|sret\([^)]*\)|align\s+\d+)\s+', '', ty)
                        ps.append(ty)
                sigs[name] = (ret, ps)
    return sigs
A = parse_sigs(A_path)
B = parse_sigs(B_path)
diverge = []
for name in sorted(set(A) & set(B)):
    if A[name] != B[name]:
        ra, pa = A[name]
        rb, pb = B[name]
        diffs = []
        if ra != rb: diffs.append(f"ret {ra}→{rb}")
        for i, (x, y) in enumerate(zip(pa, pb)):
            if x != y: diffs.append(f"p{i} {x}→{y}")
        diverge.append((name, diffs))
print(f"  total divergent: {len(diverge)} / {len(set(A) & set(B))} common")
print(f"  examples (top 5):")
for name, diffs in diverge[:5]:
    print(f"    @{name}  ({', '.join(diffs[:3])})")
with open(report, 'a') as f:
    for name, diffs in diverge:
        f.write(f"TYPE_DIFF\t{name}\t{', '.join(diffs)}\n")
PY

    # Method B: anomaly score (orphans, undef args, ret undef)
    echo ""
    echo "── B. Functions with high anomaly scores ──"
    python3 - "$B" "$report" <<'PY'
import re, sys
B_path, report = sys.argv[1], sys.argv[2]
funcs = {}
cur = None
fn_pat = re.compile(r'^define\s+[^@]*@(\w+)\s*\(')
with open(B_path) as f:
    for line in f:
        m = fn_pat.match(line)
        if m:
            cur = m.group(1)
            funcs[cur] = {'orphans': 0, 'undef_args': 0, 'i64_struct': 0, 'ret_undef': 0}
            continue
        if cur is None: continue
        if 'No predecessors!' in line: funcs[cur]['orphans'] += 1
        if re.search(r'undef\b.*,', line) and 'call' in line: funcs[cur]['undef_args'] += 1
        if re.search(r'load\s+i64,\s*ptr.*align\s+8', line): funcs[cur]['i64_struct'] += 1
        if re.match(r'^\s*ret\s+\S+\s+undef\b', line): funcs[cur]['ret_undef'] += 1
        if line.startswith('}'): cur = None
scored = [(c['orphans']*5 + c['undef_args']*3 + c['i64_struct']*5 + c['ret_undef']*10, name, c)
          for name, c in funcs.items()]
scored = [s for s in scored if s[0] > 0]
scored.sort(reverse=True)
print(f"  total functions with anomalies: {len(scored)} / {len(funcs)}")
print(f"  top 5 by score:")
for score, name, c in scored[:5]:
    print(f"    {score:>4}  @{name}  (orph={c['orphans']} undef={c['undef_args']} ret_undef={c['ret_undef']})")
with open(report, 'a') as f:
    for score, name, c in scored:
        f.write(f"ANOMALY\t{name}\tscore={score} orph={c['orphans']} undef={c['undef_args']} ret_undef={c['ret_undef']}\n")
PY

    # Method C: in-emit verifier failures
    echo ""
    echo "── C. LLVMVerifyFunction failures (mid-emit) ──"
    local verify_fails=$(FORGE_DEBUG_VERIFY=1 ./build/stage1_rust build packages/forgec/src/main.fg 2>&1 | grep "VERIFY FAIL" | head -50)
    local verify_count=$(echo "$verify_fails" | grep -c "VERIFY FAIL" || echo 0)
    echo "  total verify failures: $verify_count"
    if [ "$verify_count" != "0" ]; then
        echo "  top 5:"
        echo "$verify_fails" | head -5 | sed 's/^/    /'
    fi
    echo "$verify_fails" | sed -E 's/^.*VERIFY FAIL\] +(\S+).*/VERIFY\t\1\t/' >> "$report"

    # Method D: regression suite
    echo ""
    echo "── D. Regression suite ──"
    if [ -d "$REGRESS_DIR" ]; then
        local pass=0 fail=0
        for src in "$REGRESS_DIR"/*.fg; do
            [ -f "$src" ] || continue
            local name=$(basename "$src" .fg)
            local expected="$REGRESS_DIR/$name.expected"
            rm -f output.ll a.out 2>/dev/null
            if ! ./build/stage1_rust build "$src" >/dev/null 2>&1; then
                fail=$((fail + 1))
                echo "REGRESS\t$name\tcompile-failed" >> "$report"
                continue
            fi
            local got=$(./a.out 2>&1 || true)
            if [ -f "$expected" ]; then
                if [ "$got" = "$(cat $expected)" ]; then
                    pass=$((pass + 1))
                else
                    fail=$((fail + 1))
                    echo "REGRESS\t$name\toutput-mismatch" >> "$report"
                fi
            fi
        done
        echo "  pass: $pass  fail: $fail"
    else
        echo "  (no regression suite at $REGRESS_DIR)"
    fi

    # Method E: stage 2 binary smoke test
    echo ""
    echo "── E. Stage 2 binary smoke test ──"
    if build_compiler_from_ir "$B" /tmp/stage2_bin /tmp/stage2_bin.o /tmp/_bugs_stage2_llc.log /tmp/_bugs_stage2_link.log; then
        echo 'fn main() { println("hi") }' > /tmp/_bug_hi.fg
        rm -f output.ll a.out 2>/dev/null
        /tmp/stage2_bin build /tmp/_bug_hi.fg >/dev/null 2>&1 || true
        if [ -f a.out ] && [ "$(./a.out 2>&1)" = "hi" ]; then
            echo "  ✓ stage 2 binary compiles + runs hello world"
        else
            echo "  ✗ stage 2 binary BROKEN on hello world"
            echo "STAGE2_BIN\thello_world\thello-world-broken" >> "$report"
        fi
    else
        echo "  ✗ stage 2 binary failed to link from $B"
        echo "STAGE2_BIN\tlink\tlink-failure" >> "$report"
    fi

    # Method F: stage 3 binary smoke test (stage 2 → stage 3)
    echo ""
    echo "── F. Stage 3 binary smoke test ──"
    if [ -x /tmp/stage2_bin ]; then
        rm -f output.ll a.out 2>/dev/null
        /tmp/stage2_bin build packages/forgec/src/main.fg >/dev/null 2>&1 || true
        if [ -f output.ll ]; then
            cp output.ll /tmp/stage3.ll
            if "$LLC_BIN" -O0 -filetype=null /tmp/stage3.ll >/dev/null 2>&1; then
                echo "  ✓ stage 3 IR llc-clean ($(grep -c '^define' /tmp/stage3.ll) functions)"
            else
                echo "  ✗ stage 3 IR fails llc"
                echo "STAGE3_BIN\tllc\tllc-failure" >> "$report"
            fi
        else
            echo "  ✗ stage 2 binary did NOT produce stage 3 IR"
            echo "STAGE3_BIN\tcompile\tdid-not-emit" >> "$report"
        fi
    else
        echo "  (skipped — /tmp/stage2_bin not built)"
    fi

    # Method G: stub detection (functions truncated to ≤25% of ref)
    echo ""
    echo "── G. Stubbed functions (find-stubs) ──"
    local stubs_file=/tmp/_bugs_stubs.txt
    : > "$stubs_file"
    while IFS= read -r fn; do
        local al bl
        al=$(extract_llvm_fn "$A" "$fn" | wc -l | tr -d ' ')
        bl=$(extract_llvm_fn "$B" "$fn" | wc -l | tr -d ' ')
        if [ "$al" = "0" ] || [ "$bl" = "0" ]; then continue; fi
        if [ "$al" -ge 30 ] && [ "$bl" -le 25 ] && [ $((bl * 4)) -lt "$al" ]; then
            echo "$fn $al $bl" >> "$stubs_file"
        fi
    done < <(grep -oE '^define [^@]*@[A-Za-z_][A-Za-z0-9_]*' "$A" | sed 's/.*@//' | sort -u)
    local stub_count
    stub_count=$(wc -l < "$stubs_file" | tr -d ' ')
    echo "  total stubbed functions: $stub_count"
    if [ "$stub_count" != "0" ]; then
        echo "  top 5 (lines lost):"
        awk '{print ($2-$3) " " $1 " (" $2 "→" $3 ")"}' "$stubs_file" \
            | sort -rn | head -5 | sed 's/^/    /'
        awk '{print "STUB\t" $1 "\tref=" $2 " tgt=" $3}' "$stubs_file" >> "$report"
    fi

    # Method H: stage 2 binary smoke battery (--cmp-broken inline)
    echo ""
    echo "── H. Stage 2 binary smoke battery (cmp-broken) ──"
    local cb_pass=0 cb_fail=0
    local cb_dir=/tmp/_bugs_cb
    rm -rf "$cb_dir" && mkdir -p "$cb_dir"
    if [ -x /tmp/stage2_bin ]; then
        cb_test() {
            local n="$1" exp="$2" code="$3"
            local f="$cb_dir/$n.fg"
            printf 'fn main() {\n    %s\n}\n' "$code" > "$f"
            rm -f a.out output.ll
            /tmp/stage2_bin build "$f" >/dev/null 2>&1 || true
            if [ ! -x ./a.out ]; then
                cb_fail=$((cb_fail + 1))
                echo "SMOKE\t$n\tcompile-failed" >> "$report"
                return
            fi
            local got
            got=$(./a.out 2>&1 | tail -5)
            if [ "$got" = "$exp" ]; then
                cb_pass=$((cb_pass + 1))
            else
                cb_fail=$((cb_fail + 1))
                echo "SMOKE\t$n\texpected=$exp got=$got" >> "$report"
            fi
        }
        cb_test int_eq_literal   "yes"  'if 5 == 5 { println("yes") } else { println("no") }'
        cb_test int_eq_var       "yes"  'let a = 122; if a == 122 { println("yes") } else { println("no") }'
        cb_test for_loop_count   "10"   'mut s = 0; let xs: List<int> = [1,2,3,4]; for x in xs { s = s + x }; println(string(s))'
        cb_test list_lit_length  "4"    'let xs: List<int> = [1,2,3,4]; println(string(xs.length))'
        cb_test match_enum       "b"    'enum K { A, B }; fn main() { let r = match K.B { .A -> { "a" } .B -> { "b" } }; println(r) }'
        echo "  $cb_pass passed, $cb_fail failed"
    else
        echo "  (skipped — /tmp/stage2_bin not built)"
    fi

    # Method I: shadow-check static lint
    echo ""
    echo "── I. SSA-name / user-var collisions (shadow-check) ──"
    local internal_names
    internal_names=$(grep -rhoE 'build_alloca\([^)]*"[a-zA-Z_][a-zA-Z0-9_]{0,4}"\)' packages/forgec/src 2>/dev/null \
        | grep -oE '"[a-zA-Z_][a-zA-Z0-9_]*"' | tr -d '"' | sort -u)
    local shadow_count=0
    for n in $internal_names; do
        # Skip __-prefixed names (intentionally internal)
        case "$n" in __*) continue ;; esac
        local hits
        hits=$(grep -rnE "(let|mut) +${n}( |=|:)" packages/forgec/src 2>/dev/null \
            | grep -v "build_alloca" | grep -v "/mini" || true)
        if [ -n "$hits" ]; then
            shadow_count=$((shadow_count + 1))
            echo "SHADOW\t$n\t$(echo "$hits" | head -1)" >> "$report"
        fi
    done
    echo "  collisions found: $shadow_count"

    # ── Phase 3: deduplicate and rank ──────────────────────────
    echo ""
    echo "═══ Top bugs (deduplicated, ranked) ═══"
    python3 - "$report" <<'PY'
import sys
from collections import defaultdict
report = sys.argv[1]
# Aggregate findings per function
fn_findings = defaultdict(list)
with open(report) as f:
    for line in f:
        parts = line.strip().split('\t')
        if len(parts) < 2: continue
        method, name = parts[0], parts[1]
        detail = parts[2] if len(parts) > 2 else ""
        fn_findings[name].append((method, detail))

# Rank by number of detection methods that flagged it
ranked = sorted(fn_findings.items(), key=lambda kv: -len(kv[1]))
print(f"  {len(fn_findings)} unique buggy functions detected by ≥1 method")
print()
print(f"  Most-flagged (likely the worst):")
for name, findings in ranked[:15]:
    methods = sorted(set(m for m, _ in findings))
    print(f"    [{len(methods)} methods] @{name}")
    for method, detail in findings[:3]:
        d = detail[:80] + "..." if len(detail) > 80 else detail
        print(f"      • {method}: {d}")
print()
print(f"  Full report: {report}")
PY
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
  --build-stage2 [ir] [bin]      link a runnable compiler from IR ★
  --pipeline                     full stage 1 → stage 3 sanity run
  --stage2 / --stage3            functional smoke tests
  --source                       what's in the source layout

FUNCTION-LEVEL DIFFING
  --diff-fn <fn> [a.ll] [b.ll]   line diff of one function
  --rank-diff [a.ll] [b.ll]      rank functions by diff size
  --cfg-summary <fn> [a] [b]     blocks/orphans/phis side-by-side
  --type-diff [a.ll] [b.ll]      function signatures that differ ★
  --storage-audit [file.ll]      rank direct alloca/store ABI mismatches ★
  --anomaly [file.ll]            per-function anomaly score ★
  --llvm-decls                   audit missing self-host LLVM decls ★
  --body-reparse <src.fg>        trace body-src → tokens → stmt counts ★
  --whyi64 <fn> <param>          why is this param i64? ★
  --cfg <fn> [file.ll]           graphviz dot output of CFG
  --fn-ir <fn> [file.ll]         dump one function's IR (no awk) ★
  --capture <label> [file.ll]    snapshot output.ll for later --diff-builds ★
  --diff-builds <a> <b> [fn]     diff two snapshots, names normalized ★
  --container-abi [file.ll]      source vs IR audit for List/Map signatures ★
  --probe-cmp <fn> [in.fg]       trace every == in <fn> at runtime ★
  --snip "code"                  compile + run a one-liner via stage1+stage2 ★
  --repro <symptom>|list         emit a minimal repro for known stage 3 bugs ★
  --shadow-check                 lint user vars colliding with internal SSA names ★
  --cmp-broken                   5s smoke battery — first failing test = next bug ★
  --find-stubs [ref] [tgt]       list every fn that's stubbed in tgt vs ref ★
  --crash-asm <fn> [off] [bin]   disassemble around a crash offset ★
  --dump-bisect <fn>             per-step IR dumps + diff (FORGE_DEBUG_DUMP) ★
  --show-fn <fn>                 stage 2 IR vs stage 3 IR side-by-side ★
  --ret-undef [file.ll]          fns emitting `ret <T> undef` ★

RUNTIME BEHAVIOR
  --binop-test                   compile +/-/==/&&/etc through stage1_rust
                                 vs stage 2 bin and diff runtime output ★

FUZZ + REGRESSION
  --fuzz [count]                 differential fuzzer (rust vs self-host)
  --regress                      run forge_regress/*.fg suite ★
  --regress-add <name> <src.fg>  capture a fix as regression test ★

UNIFIED BUG REPORT
  --bugs                         run EVERY detection method, ranked list ★

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

  Catch missing llvm.* wrapper declarations early:
    bash scripts/diagnose.sh --llvm-decls

  Trace which function bodies reparse to 0 statements:
    bash scripts/diagnose.sh --body-reparse /tmp/repro.fg

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
# STORAGE-AUDIT MODE — direct alloca/store ABI mismatches
# ═════════════════════════════════════════════════════════════════
run_storage_audit() {
    if [ ! -f "$IR" ]; then echo "ERROR: $IR not found" >&2; exit 1; fi
    echo "═══ Storage Audit: $IR ═══"
    python3 - "$IR" <<'PY'
import re
import sys
from collections import defaultdict

path = sys.argv[1]
by_fn = defaultdict(list)
allocas = {}
current_fn = None

with open(path) as f:
    for ln, line in enumerate(f, 1):
        m = re.match(r'^define .* @([^(]+)\(', line)
        if m:
            current_fn = m.group(1)
            allocas = {}
            continue
        if current_fn and line.startswith('}'):
            current_fn = None
            allocas = {}
            continue
        if not current_fn:
            continue
        m = re.match(r'\s*(%\S+)\s*=\s*alloca\s+([^,]+)', line)
        if m:
            allocas[m.group(1)] = m.group(2).strip()
            continue
        m = re.match(r'\s*store\s+([^,]+?)\s+\S+,\s*ptr\s+(%\S+)', line)
        if m:
            store_ty = m.group(1).strip()
            slot = m.group(2)
            want = allocas.get(slot)
            if want and want != store_ty:
                by_fn[current_fn].append((ln, slot, want, store_ty))

ranked = sorted(by_fn.items(), key=lambda kv: (-len(kv[1]), kv[0]))
total = sum(len(items) for _, items in ranked)
for idx, (fn, items) in enumerate(ranked[:20], 1):
    print(f"{len(items):3d}  {fn}")
    for ln, slot, want, got in items:
        print(f"    line {ln:<6} {slot} : alloca {want} but store {got}")
if not ranked:
    print("No direct alloca/store mismatches found.")
print()
print(f"TOTAL mismatched direct stores: {total}")
if len(ranked) > 20:
    print(f"Showing top 20 functions only ({len(ranked)} total functions with mismatches)")
PY
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
    build-stage2) run_build_stage2 ;;
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
    storage-audit) run_storage_audit ;;
    anomaly)  run_anomaly ;;
    llvm-decls) run_llvm_decls ;;
    body-reparse) run_body_reparse ;;
    whyi64)   run_whyi64 ;;
    fuzz)     run_fuzz ;;
    regress)  run_regress ;;
    regress-add) run_regress_add ;;
    bugs)     run_bugs ;;
    help)     run_help ;;
    ir-sanity) run_ir_sanity ;;
    ret-undef) run_ret_undef ;;
    container-abi) run_container_abi ;;
    fn-ir)    run_fn_ir ;;
    show-fn)  run_show_fn ;;
    binop-test) run_binop_test ;;
    capture)  run_capture ;;
    diff-builds) run_diff_builds ;;
    probe-cmp) run_probe_cmp ;;
    snip)     run_snip ;;
    repro)    run_repro ;;
    shadow-check) run_shadow_check ;;
    cmp-broken)   run_cmp_broken ;;
    find-stubs)   run_find_stubs ;;
    crash-asm)    run_crash_asm ;;
    dump-bisect)  run_dump_bisect ;;
    progress) run_progress ;;
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
