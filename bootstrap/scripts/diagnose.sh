#!/usr/bin/env bash
# Bootstrap diagnostic system — single entry point for all dev tooling.
#
# Add new modes by adding a `mode_<name>` function and a case branch in
# main(). Every mode should have a one-liner in print_help() so future
# agents can discover it from `--help` alone.
#
# Design rule: this script is the ONLY place dev tooling lives. If you
# find yourself writing a one-off bash command more than twice, add a
# mode here instead.

set -uo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
BOOTSTRAP_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
REPO_DIR=$(CDPATH= cd -- "$BOOTSTRAP_DIR/.." && pwd)
FORGE_DIR="$REPO_DIR/avra"
BUILD_DIR="$BOOTSTRAP_DIR/build"
SEED_LL="$BOOTSTRAP_DIR/seed/seed.ll"
SEED_LOCK="$BOOTSTRAP_DIR/seed/seed.lock"
SEED_FETCH_CACHE="$BUILD_DIR/cache/seed"
SEED_REPO_SLUG="${AVRA_SEED_REPO:-tristanmatthias/forge-lang}"
SEED_BIN="$BUILD_DIR/seed"
RUNTIME_C="$BOOTSTRAP_DIR/runtime.c"
RUNTIME_O="$BUILD_DIR/runtime.o"
# runtime.c optimization level. It is bs2's OWN runtime (allocator, RC, sha256
# fingerprinting, arrays, string ops) AND is linked into every compiled program,
# so its speed is on the compiler's hot path. It was historically built at -O0,
# which leaves ~20%+ of compiler instructions on the floor: -O0 ignores every
# `static inline` (sha256_rotr alone was a real call 44M times / 8.8% of a
# compile) and optimizes nothing. llvm_wrapper.c already builds at -O2, so -O2 C
# in this toolchain is established-safe. -fno-strict-aliasing is REQUIRED: the
# region allocator and RC header type-pun the same memory (`*(size_t*)base`,
# `*(void**)base`, `(RcHeader*)((char*)p-8)`), which -O2 strict-aliasing would be
# free to reorder/elide. Override with AVRA_RUNTIME_OPT=-O0 for a clean-backtrace
# debug build (the LLDB debugging protocol).
RUNTIME_OPT="${AVRA_RUNTIME_OPT:--O2 -fno-strict-aliasing}"
RUNTIME_ASAN_O="$BUILD_DIR/runtime_asan.o"
BS2="$BUILD_DIR/bs2"
BS2_O0="$BUILD_DIR/bs2_O0"
BS2_ASAN="$BUILD_DIR/bs2_asan"
BS2_DEBUG="$BUILD_DIR/bs2_debug"
BS3="$BUILD_DIR/bs3"
# `bs2` is built from the cli package (binary entry); the lib it
# imports lives at LIB_SRC_DIR. source_newer_than watches both so
# any change in either layer rebuilds the seed.
CLI_SRC_DIR="$BOOTSTRAP_DIR/packages/cli/src"
LIB_SRC_DIR="$BOOTSTRAP_DIR/packages/std-avrac/src"
SRC_DIR="$CLI_SRC_DIR"

# Pinned LLVM major. The compiler emits LLVM 19+ IR (`getelementptr inbounds
# nuw …`), so the toolchain must be >= 19; LLVM 21's -O2 miscompiles certain
# ARM64 functions — so 20 exactly. Kept in sync with scripts/bootstrap.sh.
LLVM_MAJOR=20

# Major version an `llvm-config` reports (e.g. "20"), or empty on failure.
_llvm_major_of() { "$1" --version 2>/dev/null | cut -d. -f1; }

# Echo a prefix whose toolchain reports the pinned major, or empty on miss.
# Mirrors scripts/bootstrap.sh's find_llvm_prefix so `make` resolves the right
# LLVM on Linux WITHOUT a manual LLVM_PREFIX export — otherwise the unversioned
# `llvm-config`/`llc` (often llvm-18: runtime-only, no headers; rejects nuw GEP)
# is picked and a cold build fails (missing llvm-c/Core.h, or llc "expected type").
_find_llvm20_prefix() {
  for cfg in "llvm-config-$LLVM_MAJOR" "llvm-config$LLVM_MAJOR"; do
    if command -v "$cfg" >/dev/null 2>&1; then "$cfg" --prefix; return; fi
  done
  for pfx in \
    "/usr/lib/llvm-$LLVM_MAJOR" "/usr/lib64/llvm$LLVM_MAJOR" \
    "/usr/local/llvm-$LLVM_MAJOR" "/opt/llvm-$LLVM_MAJOR" \
    "/opt/homebrew/opt/llvm@$LLVM_MAJOR" "/usr/local/opt/llvm@$LLVM_MAJOR"; do
    if [ -x "$pfx/bin/llvm-config" ] && [ "$(_llvm_major_of "$pfx/bin/llvm-config")" = "$LLVM_MAJOR" ]; then
      echo "$pfx"; return
    fi
  done
}
_llvm20_prefix="$(_find_llvm20_prefix)"

# Platform-portable LLVM discovery (headers + libLLVM). On macOS the Homebrew
# prefix is the default; otherwise prefer a pinned-major install, then fall
# back to whatever `llvm-config` reports so the bootstrap builds without manual
# env setup.
_default_llvm_prefix="/opt/homebrew/opt/llvm"
if [ ! -d "$_default_llvm_prefix" ]; then
  if [ -n "$_llvm20_prefix" ]; then
    _default_llvm_prefix="$_llvm20_prefix"
  elif command -v llvm-config >/dev/null 2>&1; then
    _default_llvm_prefix="$(llvm-config --prefix)"
  fi
fi
LLVM_PREFIX="${LLVM_PREFIX:-$_default_llvm_prefix}"
LLVM_CONFIG="$LLVM_PREFIX/bin/llvm-config"

# Use LLVM 20's llc for code generation (see LLVM_MAJOR above). The runtime
# still links against the default LLVM's libLLVM. Prefer the macOS pinned
# Cellar llc, then a probed pinned-major toolchain, then a version-suffixed
# `llc-20` on PATH, then the llc beside LLVM_PREFIX, then bare `llc`.
LLC_PREFIX="${LLC_PREFIX:-/opt/homebrew/Cellar/llvm/20.1.5}"
if [ -x "$LLC_PREFIX/bin/llc" ]; then
  LLC="${LLC:-$LLC_PREFIX/bin/llc}"
elif [ -n "$_llvm20_prefix" ] && [ -x "$_llvm20_prefix/bin/llc" ]; then
  LLC="${LLC:-$_llvm20_prefix/bin/llc}"
elif command -v "llc-$LLVM_MAJOR" >/dev/null 2>&1; then
  LLC="${LLC:-$(command -v "llc-$LLVM_MAJOR")}"
elif [ -x "$LLVM_PREFIX/bin/llc" ]; then
  LLC="${LLC:-$LLVM_PREFIX/bin/llc}"
else
  LLC="${LLC:-$(command -v llc 2>/dev/null || echo llc)}"
fi

# C++ runtime libLLVM was built against: libc++ on macOS, libstdc++ on a
# typical Linux LLVM packaging. Used wherever the bootstrap links libLLVM.
if [ "$(uname -s)" = "Darwin" ]; then
  CXXLIB="${CXXLIB:--lc++}"
else
  CXXLIB="${CXXLIB:--lstdc++}"
fi

# Main-thread stack size. The bootstrap compiler recurses deeply
# (recursive-descent parser, AST renderers). macOS pins a 32 MiB main
# stack at link time via the ld64 `-stack_size` flag; on Linux the
# main-thread stack derives from RLIMIT_STACK instead, so the flag is
# macOS-only and we raise the soft limit for this process (and every
# binary it spawns) here instead.
if [ "$(uname -s)" = "Darwin" ]; then
  STACK_LDFLAGS="${STACK_LDFLAGS:--Wl,-stack_size,0x2000000}"
else
  STACK_LDFLAGS="${STACK_LDFLAGS:-}"
  ulimit -S -s 65536 2>/dev/null || true
fi

# Relocation model for llc-generated objects. macOS llc defaults to PIC;
# Linux llc defaults to the static model, whose absolute relocations
# (R_X86_64_32) are incompatible with the PIE executables modern Linux
# toolchains link by default. Emit PIC on Linux to match macOS and link
# cleanly into a PIE.
if [ "$(uname -s)" = "Darwin" ]; then
  LLC_RELOC="${LLC_RELOC:-}"
else
  LLC_RELOC="${LLC_RELOC:--relocation-model=pic}"
fi

# Portable SHA-256. macOS ships Perl's `shasum`; Linux ships coreutils'
# `sha256sum`. Both accept file arguments and stdin and print the digest
# as field 1, so one command string works in pipes and `find -exec` alike
# (kept as an unquoted word-splitting variable, not a function, precisely
# so `find … -exec $SHA256_CMD {} +` resolves to a real executable).
if command -v sha256sum >/dev/null 2>&1; then
  SHA256_CMD="sha256sum"
else
  SHA256_CMD="shasum -a 256"
fi

# Linker selection. The bootstrap mangles symbols with a leading `@`
# (e.g. `@std::avrac::core::Foo__bar`). GNU ld reads `@` as the
# symbol-versioning separator and rejects the whole object
# ("multiple definition of `no symbol'"); LLD treats `@` in defined
# symbols literally. So on Linux link with LLD when it's available.
# macOS uses its default ld64 (which has no such `@` semantics).
if [ "$(uname -s)" = "Darwin" ]; then
  LD_SELECT="${LD_SELECT:-}"
elif command -v ld.lld >/dev/null 2>&1; then
  LD_SELECT="${LD_SELECT:--fuse-ld=lld}"
else
  LD_SELECT="${LD_SELECT:-}"
fi

# Export the dynamic symbol table on every binary we link. The compiler hosts an
# in-process MCJIT (the @comptime JIT fold, ps3t.5.2.1); a JIT'd body reaches back
# into the host for any runtime symbol its codegen emits (e.g. a float literal
# lowers to `avra_float_parse`), and MCJIT resolves those through
# dlsym(RTLD_DEFAULT, …) against the host's dynamic symbol table. Without
# `-rdynamic` that table is empty, the reference resolves to null, and the JIT'd
# code segfaults on the first call. clang and gcc both accept `-rdynamic` (Linux
# → `--export-dynamic`, macOS → `-export_dynamic`). Applied uniformly so no
# compiler binary — however it's built — can miss it; the extra symbols on a
# plain fixture binary are harmless.
EXPORT_DYNAMIC="${EXPORT_DYNAMIC:--rdynamic}"

LLVM_WRAPPER_O="$BUILD_DIR/llvm_wrapper.o"

# The integration branch the seed train runs on. Feature
# branches never cycle the seed; --check-bootstrap-window verifies a
# branch against this branch's pristine seed. Override per-repo or
# per-invocation with AVRA_INTEGRATION_BRANCH.
INTEGRATION_BRANCH="${AVRA_INTEGRATION_BRANCH:-feat/crafting-intepreters}"
# GitHub fires `schedule` ONLY from the DEFAULT branch — not from the branch the
# workflow file lives on. Every gate here is push/pull_request-triggered (those
# run from the pushed branch / PR merge ref), so this asymmetry stayed invisible
# until a scheduled workflow landed on the integration branch and never ran.
DEFAULT_BRANCH="${AVRA_DEFAULT_BRANCH:-main}"

C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[0;33m'
C_BLUE='\033[0;34m'
C_DIM='\033[2m'
C_RESET='\033[0m'

log()  { printf "${C_BLUE}[diag]${C_RESET} %s\n" "$*" >&2; }
ok()   { printf "${C_GREEN}[ok]${C_RESET}   %s\n" "$*" >&2; }
warn() { printf "${C_YELLOW}[warn]${C_RESET} %s\n" "$*" >&2; }
err()  { printf "${C_RED}[err]${C_RESET}  %s\n" "$*" >&2; }
die()  { err "$*"; exit 1; }

# Check if any .av source file is newer-or-equal-mtime to a target binary.
# Returns 0 (true) if rebuild is needed, 1 (false) if up to date.
#
# `find -newer` uses STRICT-greater mtime comparison, which silently
# missed APFS second-granularity races: a source edit that happens in
# the same second as the previous bs2 build produced equal mtimes,
# `find -newer` returned empty, and the next `make build` skipped
# rebuilding even though the source had genuinely changed. Compare
# explicit mtimes with `-ge` instead so same-second ties are treated
# as "source might be newer" and trigger a conservative rebuild.
#
# Cost of the false-positive case (no source change but mtimes equal,
# e.g. after `touch -r`): one extra rebuild. Vastly preferable to a
# silent stale-binary bug.
# 6cks: portable epoch-mtime stat. GNU coreutils spells it `stat -c %Y`;
# BSD/macOS spells it `stat -f %m`. The BSD spelling was hardcoded, so on
# Linux the probe misbehaved by coreutils version — either `stat -f`
# errored (freshness degraded to "always stale": every ensure-bs2 paid an
# unconditional ~40s rebuild) or printed a MOUNT POINT (the `-ge` compare
# then failed non-numerically: "never stale", silently serving a stale
# binary). Probe the GNU spelling once against `.`; consumers word-split
# $STAT_MTIME deliberately.
if stat -c %Y . >/dev/null 2>&1; then
  STAT_MTIME="stat -c %Y"
  # A FUNCTION, not a word-split string like $STAT_MTIME above. The format is
  # two tokens (`%Y %n`), and a split string turns the second into a FILENAME
  # argument instead of part of the format — so it printed a bare mtime with
  # no path, the reporter below found an empty path and returned silently, and
  # the whole thing looked like a tree that was simply never stale.
  stat_mtime_name() { stat -c '%Y %n' "$@"; }
else
  STAT_MTIME="stat -f %m"
  stat_mtime_name() { stat -f '%m %N' "$@"; }
fi

# The C LINK INPUTS count as sources (t-drl0). Every binary this gates — bs2,
# bs2_O0, bs2_debug — links runtime.o + llvm_wrapper.o, so editing either C file
# changes the binary's behaviour just as surely as editing a `.av` file does.
# Watching only `*.av` meant a runtime.c edit rebuilt runtime.o (and the seed,
# which DOES key its C inputs via seed_inputs_hash) while silently re-serving the
# previous bs2 — the compiler you just changed, running the code you just
# replaced. Exactly the misattribution the seed_inputs_hash comment describes,
# one binary further down the chain.
source_newer_than() {
  local target="$1"
  [ ! -x "$target" ] && return 0
  local target_mtime
  target_mtime=$($STAT_MTIME "$target" 2>/dev/null) || return 0
  local newest_src
  # t-kdyj.10 fix (2): mtime is the CHEAP GATE, content is the VERDICT.
  #
  # A rebase rewrites working-tree files, so their mtimes jump to now even
  # when the resulting content is byte-identical to what `build/bs2` was
  # built from. Purely by mtime that reads as stale, and the operator-
  # visible outcome was two unrelated-looking spec failures on a tree that
  # had passed minutes earlier (this ticket's opening report). Fix (1)
  # made that legible; keying on content makes it not happen.
  #
  # The order matters for cost. mtime is one stat per source and answers
  # "nothing newer" for the overwhelmingly common case without hashing
  # anything; the content sweep runs ONLY once mtime has already flagged,
  # which is exactly when a rebuild was about to be paid for anyway. Same
  # shape as pdme.1's dep-aware compile key, one binary down the chain.
  # `*_test.av` is EXCLUDED, mirroring package_full_fingerprint (2wfp,
  # build/fingerprint.av): a test entry is not part of the compiled surface
  # — nothing imports one and the [lib] build does not emit one — so it
  # cannot make `bs2` stale. Including them made diagnose.sh CONTRADICT the
  # build's own content fingerprint, with two consequences: a test-only edit
  # reported `stale`, reddening suite_bs2_guard_test on a tree whose compiler
  # sources were untouched; and ensure_bs2 wanted to rebuild + relink bs2
  # off a test edit — which is the very mid-suite-rebuild hazard (t-gv3n)
  # that this staleness check is the second line of defence against.
  newest_src=$(newest_source_mtime)
  [ -z "$newest_src" ] && return 1   # no sources found — pathological
  if [ "$newest_src" -lt "$target_mtime" ]; then
    # Fresh by mtime. ADOPT the current content as this target's baseline if
    # it has none — otherwise the stamp only ever appears after the next
    # genuine relink, and the very first rebase on an already-built tree
    # still reports stale (measured: `make build-quick` on a fresh tree
    # skips the link, so nothing stamped and `--bs2-stale-check` said
    # `stale` after a content-preserving touch).
    #
    # Sound because mtime-newer-than-every-source IS the freshness contract
    # this script already runs on: the binary was built from these bytes.
    # Write-if-absent, never overwrite, so an existing stamp stays
    # authoritative and repeated calls cannot churn.
    adopt_compiler_srcfp_if_absent "$target"
    return 1
  fi
  # mtime says stale. Confirm against content before believing it: if the
  # sources hash to exactly what this target was stamped with, the bytes
  # that produced it are unchanged and the target is FRESH.
  compiler_sources_changed "$target"
}

# Deterministic digest of the compiler's source inputs — the same set
# `compiler_source_paths` defines, so the content check and the mtime check
# can never disagree about what a source is. Paths are SORTED (find's order
# is filesystem-dependent) and each contributes `<path>:<sha256>`, so a
# rename with identical bytes still changes the digest — it changes the
# build. Mirrors build/fingerprint.av's `package_source_fingerprint`.
# FAILS (non-zero, no output) when any input cannot be hashed. The obvious
# spelling — printf-ing whatever the hash produced — turns an unreadable or
# vanished source into `<path>:` and the OUTER hash still succeeds, yielding a
# perfectly stable fingerprint that says nothing about that file's bytes.
# Stamp and check would then agree with each other while agreeing about
# nothing, i.e. report FRESH with no evidence — the one direction that serves
# a stale compiler. The loop is fed by process substitution rather than a
# pipeline so `return 1` leaves this function instead of a subshell.
compiler_sources_fp() {
  local acc="" p h
  while IFS= read -r p; do
    h=$($SHA256_CMD "$p" 2>/dev/null | awk '{print $1}')
    [ -n "$h" ] || return 1
    acc="${acc}${p}:${h}
"
  done < <(compiler_source_paths | LC_ALL=C sort)
  [ -n "$acc" ] || return 1
  printf '%s' "$acc" | $SHA256_CMD | awk '{print $1}'
}

# Where a target records the source digest it was built from.
src_fp_stamp_path() {
  printf '%s/.%s.srcfp\n' "$BUILD_DIR" "$(basename "$1")"
}

# Record the digest for `target`. Called after a successful link of each
# binary `source_newer_than` gates. Failing to stamp is not fatal — an
# absent stamp degrades to the old mtime-only behaviour (report stale,
# rebuild), which is the safe direction.
stamp_compiler_sources() {
  stamp_compiler_sources_value "$1" "$(compiler_sources_fp)"
}

# Record an ALREADY-CAPTURED digest for `target`. Split out because the digest
# must be sampled BEFORE the compile reads the sources, not after the link: a
# source edited in between would otherwise be recorded as the baseline for a
# binary built from the previous bytes, and the next check would call that
# genuinely-stale target fresh. Every link site therefore captures first and
# writes here on success.
#
# Refuses to publish an empty value: `compiler_sources_fp` fails that way when
# an input cannot be hashed, and an empty stamp must stay absent rather than
# become a baseline.
stamp_compiler_sources_value() {
  local stamp; stamp=$(src_fp_stamp_path "$1")
  local fp="$2"
  [ -n "$fp" ] || return 0
  # Skip SILENTLY when the build dir does not exist. A failed `>` redirect is
  # reported by the shell on its ORIGINAL stderr — the trailing `2>/dev/null`
  # never gets applied, because redirections are set up left to right and the
  # first one already failed. That noise broke `bs2_stale_report_test`'s
  # "it says nothing at all" negative control, which is precisely the contract
  # it exists to hold: reporting must be silent when there is nothing to say.
  # An absent stamp reads as "changed" downstream, which is the safe
  # direction, so skipping costs correctness nothing.
  [ -d "$(dirname "$stamp")" ] || return 0
  { printf '%s\n' "$fp" > "$stamp"; } 2>/dev/null || true
}

# Bootstrap a baseline for a target that is fresh by mtime but has no VALID
# stamp — the pre-existing-binary case.
#
# Never overwrites a valid (non-empty) baseline, so a stamp always describes
# bytes the target really was built from and a genuinely stale target cannot
# launder itself fresh. An EMPTY stamp is deliberately re-adopted rather than
# preserved (`-s`, not `-e`): empty is how a torn write looks, it carries no
# evidence, and `compiler_sources_changed` already reads it as "changed" — so
# preserving it would pin the target stale until the next relink instead of
# self-healing. Re-adopting is safe because adoption only ever runs on the
# path where mtime has already proved the target newer than every source.
adopt_compiler_srcfp_if_absent() {
  local stamp; stamp=$(src_fp_stamp_path "$1")
  [ -s "$stamp" ] && return 0
  stamp_compiler_sources "$1"
}

# True (0) when the sources differ from what `target` was stamped with.
# An ABSENT or empty stamp answers "changed": a target built before this
# stamping existed has no evidence its content matches, and claiming fresh
# without evidence is the one direction that serves a stale compiler.
compiler_sources_changed() {
  local stamp; stamp=$(src_fp_stamp_path "$1")
  [ -f "$stamp" ] || return 0
  local recorded; recorded=$(cat "$stamp" 2>/dev/null)
  [ -n "$recorded" ] || return 0
  # A fingerprint we cannot COMPUTE is not a match — it is an absence of
  # evidence, and answering "unchanged" here would serve the stale target.
  local current; current=$(compiler_sources_fp) || return 0
  [ -n "$current" ] || return 0
  [ "$recorded" != "$current" ]
}

# Newest mtime across the compiler's source inputs. ONE definition, shared by
# both predicates below — a second copy of this find is how the two would
# silently start disagreeing about what counts as a source.
newest_source_mtime() {
  compiler_source_paths | tr '\n' '\0' | xargs -0 $STAT_MTIME 2>/dev/null | sort -rn | head -1
  # Same SIGPIPE-under-pipefail hazard as newest_source_entry below: `head -1`
  # stops reading after one line, so `sort` (and behind it xargs/find) can exit
  # 141 and pipefail promotes that to this function's status. Harmless today —
  # every caller assigns the output and tests it for emptiness rather than
  # checking the status — but the next caller to write `|| return` would
  # inherit the same silent-bail bug, so pin the contract here too. The VALUE
  # is unaffected: head already received its line before the producer died.
  return 0
}

# ONE definition of "what counts as a compiler source", emitted as PATHS so
# both the mtime predicates and the reporter below derive from the same set.
# The warning above about a second copy of this find is why this is a function
# and not two inlined copies: newest_source_mtime answers "is anything newer"
# and newest_source_entry answers "which file, and when" — if those ever
# disagreed about the source set, the reporter would name a file that is not
# the one that actually made the binary stale, which is worse than silence.
compiler_source_paths() {
  find "$CLI_SRC_DIR" "$LIB_SRC_DIR" -name '*.av' -not -name '*_test.av' -print 2>/dev/null
  printf '%s\n' "$RUNTIME_C" "$BOOTSTRAP_DIR/llvm_wrapper.c"
}

# `<mtime> <path>` of the newest source. Display-side sibling of
# newest_source_mtime; the STALENESS DECISION stays with the predicates, so a
# quirk here can only ever mis-name a file, never mis-classify a tree.
newest_source_entry() {
  local mt p
  mt=$(newest_source_mtime)
  [ -z "$mt" ] && return 0
  # Resolve the newest mtime back to A path carrying it. Deliberately a loop
  # rather than `xargs stat_mtime_name`: xargs execs a BINARY and cannot call a
  # shell function, so that spelling silently produced nothing. Only reached
  # once the tree is already known stale, so the extra sweep costs nothing on a
  # fresh tree — the overwhelmingly common case.
  compiler_source_paths | while IFS= read -r p; do
    if [ "$($STAT_MTIME "$p" 2>/dev/null)" = "$mt" ]; then
      printf '%s %s\n' "$mt" "$p"
      break
    fi
  done
  # t-fafu. The `break` above stops READING, so the still-writing
  # `compiler_source_paths` takes SIGPIPE and exits 141 — and this file runs
  # under `set -o pipefail` (line 12), which promotes that into the pipeline's
  # status and therefore this FUNCTION's status. The caller is
  # `entry=$(newest_source_entry) || return 0`, so the reporter then bailed
  # SILENTLY on a genuinely stale tree.
  #
  # Whether the producer has finished writing before the break is a race, which
  # is why it only showed up under load: measured 7 silent runs in 90 concurrent
  # probes (and 4/90 on the pre-t-kdyj.10 script, so this predates that work).
  # It is also what the two unexplained "no output" readings recorded on
  # t-kdyj.10 were.
  #
  # This function's contract is "print the entry, or print nothing" — it never
  # signalled failure through its status, and the caller already distinguishes
  # the two by testing for an empty string. Making that explicit is the fix; a
  # genuine producer failure still surfaces as empty output, exactly as before.
  return 0
}

# STRICT sibling of source_newer_than (`-gt`, not `-ge`): true only when a
# source is GENUINELY newer than the target, never on a same-second tie.
#
# The two answer different questions and both are wanted. For the BUILD
# decision, a tie means ordering is unknowable and rebuilding is the safe
# answer — that is source_newer_than, and ensure_bs2 keeps using it. For
# REPORTING, a tie is not the "your bs2 predates a source edit" condition;
# treating it as one made a full suite red with nothing in the diff to explain
# it (t-kdyj.7), because a container restart — or simply an incremental build
# that finishes inside the same second as its source write — produces a tie on
# any machine quick enough.
source_strictly_newer_than() {
  local target="$1"
  [ ! -x "$target" ] && return 0
  local target_mtime
  target_mtime=$($STAT_MTIME "$target" 2>/dev/null) || return 0
  local newest_src
  newest_src=$(newest_source_mtime)
  [ -z "$newest_src" ] && return 1   # no sources found — pathological
  if [ "$newest_src" -le "$target_mtime" ]; then
    adopt_compiler_srcfp_if_absent "$target"
    return 1
  fi
  # Content-keyed for the same reason as source_newer_than (t-kdyj.10 fix 2),
  # and this is the predicate the REPORTED symptom came through: the rebase
  # in that ticket reddened `suite_bs2_guard_test`, which drives
  # `--bs2-stale-check` → here. Fixing only the build-decision sibling would
  # have left the operator-visible half untouched.
  compiler_sources_changed "$target"
}

print_help() {
  cat <<'EOF'
bootstrap/scripts/diagnose.sh — single entry point for bootstrap dev tooling

USAGE
  diagnose.sh <mode> [args]

BUILD MODES
  --build              Rebuild stage1 (host → stage1 binary) + run all stage1 tests.
  --build-runtime      Compile avra/stdlib/runtime.c → build/runtime.o.
  --build-bs2          Compile packages/cli/src/main.av with stage1 → build/bs2.
  --ensure-bs2         Build bs2 if source changed; SKIP self-compile verify.
                       Inner-loop convenience — use --build-bs2 before commits.
  --build-O0           Build bs2 at -O0 (no optimization) for debuggability.
                       Makes lldb usable with breakpoints and variable inspection.
                       Output: build/bs2_O0.
  --build-debug        Build bs2 with --debug-null (null argument detection).
                       Emits null checks at every function entry for ptr/struct/enum
                       parameters. Catches null propagation at the source.
                       Output: build/bs2_debug.
  --build-bs2-asan     Same as --build-bs2 but link with -fsanitize=address.
  --build-bs3          Compile packages/cli/src/main.av with bs2 → build/bs3.
                       (The fixed-point self-host check.)
  --check-fixedpoint   Verify bs2 and bs3 emit byte-identical IR for
                       packages/cli/src/main.av. The single most important
                       self-hosting invariant — if this fails, a recent
                       commit broke the bootstrap chain. Wired into the
                       pre-commit hook when packages/cli/src/ or
                       packages/std-avrac/src/ is touched.

RUN MODES
  --run    <file.av>   Compile <file.av> with bs2, link, run. Prints stdout.
  --emit-regen-parsers t-47hc.8: regenerate the CHECKED-IN production static
                       parser (parse/gen_parser.av — every family, one file)
                       from THE grammar (Language.full()). Run after editing
                       ANY grammar (avra_grammar.av or a feature's gram);
                       commit the result (the regen guard test fails until
                       you do).
  --emit-regen-lex     t-47hc.2 Phase 1: regenerate the CHECKED-IN operator/
                       punctuation scanner (parse/gen_operator_scanner.av) from
                       operator_rules() (token_table.av). Run after editing the
                       operator table; commit the result (its guard test fails
                       until you do).
  --emit-regen-kw      t-47hc.2 Phase 1: regenerate the CHECKED-IN keyword recogniser
                       (parse/gen_keyword_scanner.av) from keyword_rules() (token_table.av).
                       Run after editing the keyword table; commit the result (its
                       guard test fails until you do).
  --emit-regen-run     t-47hc.2 Phase 1: regenerate the CHECKED-IN char-class run
                       scanners (parse/gen_run_scanner.av) from char_run_rules()
                       (token_table.av). Run after editing the run table; commit the
                       result (its guard test fails until you do).
  --lexer-bench [N]    t-47hc.2 Phase 1: callgrind the current build/bs2 compiling
                       an N-fn-pair token-dense source (default 400), reporting the
                       total instruction count + per-symbol lexer self-costs. The
                       perf rail — run before/after a lexer slice and compare.
                       Dev-only (needs valgrind + python3; run make build-quick first).
  --emit-gen-check     ps3t.6.5.11 behavioural gate: render the grammar-DSL
                       parser via emit.av, then COMPILE + RUN the generated
                       source and assert it parses byte-equivalent to the hand
                       parser over the §2 corpus (GENPASS). rc 0 = pass.
  --bs2-stale-check    Read-only: print `fresh`/`tie`/`stale` for build/bs2 vs
                       compiler sources + seed, building nothing. `stale` (rc 1)
                       means a source is GENUINELY newer; `tie` (rc 0) means one
                       shares bs2's second, so ensure_bs2 still rebuilds but the
                       binary does not predate an edit.
  --bs2-stale-report   Read-only: ONE line naming both paths and both
                       timestamps when build/bs2 predates a compiler source,
                       and nothing otherwise. Always rc 0 — it reports, it does
                       not gate. Printed by `bs2 test` at the top of a run so a
                       post-rebase suite explains itself (t-kdyj.10).
  --rc-strict-suite [f] Run the spec suite under AVRA_RC_STRICT=1 (rcsf.3):
                       poison-on-free + reuse quarantine + abort on release of
                       already-freed RC memory. Validates the compiler's own
                       RC discipline AND every test program's. Optional filter.
  --link-run <file.ll> Link a pre-emitted .ll into a binary and run it (no
                       recompile). Prints stdout. Used to execute the EXACT
                       artifact a prior `bs2 compile` produced.
  --run-stage1 <file.av>
                       Same but with stage1 (the host-built bootstrapc).
  --check  <file.av>   Run bs2's parse+resolve only — no codegen, no link.
  --ll     <file.av>   Emit LLVM IR via bs2 to stdout (don't link or run).
  --ll-stage1 <file.av>
                       Same with stage1.

DIFF & ANALYSIS
  --diff   <file.av>   Compile <file.av> with both stage1 and bs2, diff
                       the resulting .ll files. Highlights divergence.
  --diff-fn <file.av> <fn>
                       Same as --diff but only shows the body of one
                       function.
  --parser-probe '<src>' | -f <file>
                       t-47hc.5: the DIAGNOSTICS the hand / emit / production /
                       executor parsers each report for one snippet. Divergence
                       from `hand` is a recovery-parity gap.
  --parser-tree '<src>' | -f <file>
                       Same three-way probe over the RECOVERY TREE, with
                       `(error)` row counts. Messages can agree while the trees
                       do not — that is the `let a = (1) ->` blocker.
  --diff-test [--base <ref>] [--new <ref>] [--new-prebuilt] [--run-equiv]
              [--intended-strictness]
                       Differential test (HRN): build the
                       compiler at OLD (oracle, default integration branch)
                       and NEW (default HEAD) and assert byte-identical IR
                       over the selfhost source + curated standalone corpus
                       (tests/difftest_corpus/*.av). By default the two
                       selfhost compiles and corpus fan-out are scheduled from
                       the portable resource profile for the active CPU/memory
                       scope.
                       The go-hard safety net. --new-prebuilt reuses build/bs2 as
                       NEW (skip the cold rebuild; LOCAL, non-hermetic).
                       DIFF_TEST_CORPUS=<glob> overrides the corpus. Width is
                       derived from `bs2 resources`, not an environment knob.
                       Two DECLARED-INTENT modes, for the two ways a change can
                       legitimately trip the gate (t-zk6j):
                         --run-equiv            IR moved. Every corpus artifact
                                                must still RUN identically.
                         --intended-strictness  NEW REJECTS OLD's source (a new
                                                gate). Prints the rejection set,
                                                then re-runs the selfhost leg on
                                                NEW's OWN source — the input both
                                                compilers accept — and requires
                                                byte-identical IR there.
  --cache-fuzz [N] [SEED]
                       The canonical "is the cache lying to me" check
                       (pdme.9). N seeded edit/damage iterations against a
                       sandbox package; every iteration asserts the CACHED
                       compile's IR is byte-identical to a cache-bypassed
                       recompute, and a final revert must restore the
                       golden IR. Default N=20, SEED=42; seconds to run.
  --cache-fuzz-parallel [ROUNDS] [JOBS] [SEED]
                       CONCURRENCY sibling of --cache-fuzz (pdme.7). Each
                       round fans out JOBS simultaneous cached compiles of
                       the same entry (same fingerprint, same slot — the
                       shard/pre-build contention shape) while a seeded
                       chaos agent damages the live slot mid-flight.
                       Asserts: every compile exits 0 (publish-race losers
                       lose benignly), every worker's IR byte-matches a
                       bypassed reference, and the slot still HITs after
                       the melee. Default 8 rounds x 4 jobs, SEED=42.
  --cache-gc [DAYS]    Age-based cache GC across the bootstrap root AND
                       every packages/*/ root (`bs2 cache prune` is
                       per-project-root). mtime == last use (hits touch),
                       so only cold entries go. Default DAYS=30. Also
                       reclaims orphaned /tmp test scratch older than 10m.
  --prune-tmp-scratch [MIN]
                       Reclaim orphaned /tmp test scratch (/tmp/avra_* +
                       /tmp/build) that escapes the per-root cache prune —
                       the t-2qn0 leak. MIN = mtime guard in minutes (0 =
                       unconditional; spares in-flight `bs2 test` scratch
                       above 0). Folded into --cache-gc (10m) and
                       --clean-cache (0).
  --cache-stats [ROOT] [DAYS]
                       Cache observability: per-package entry counts,
                       sizes, and cold-entry counts (older than DAYS,
                       default 30 — GC candidates, since mtime == last
                       use), plus repo totals.
  --clean-cache [ROOT] FULL cache wipe (escape hatch): every
                       packages/*/build/cache + the top-level
                       build/cache under ROOT (default: the bootstrap
                       tree) — and nothing else. Guarded so it can
                       never touch a src/ tree. Next build is cold.
  --test-input-hash [ROOT]
                       Print the suite-input hash: one sha256 over bs2,
                       every .av under packages/+tests/, runtime.c,
                       llvm_wrapper.c, diagnose.sh, seed.ll, Makefile.
                       Shared by `bs2 test`'s commit-gate marker and the
                       pre-commit hook's suite cache (t-8rsg).
  --stray [--reap]     List every surviving heavy process (bs2/llc/cc1plus/
                       clang/cc1) with RSS, age and whether its TREE is
                       orphaned. Run this before trusting any memory number,
                       and after any killed run: orphans holding GBs make the
                       NEXT run trip the memory floor. Matches ps's `comm`,
                       never the command line, so it can never report itself
                       the way `pgrep -f bs2` does. --reap kills each orphaned
                       tree WHOLE — from the re-parented root down, whatever
                       the processes are called, since killing a compile whose
                       orphaned parent will just spawn another is not cleanup
                       — and leaves live parented builds alone. Reporting
                       exits 0 when nothing is resident, 1 when something is;
                       --reap exits 0 unless an orphan survived the KILL.
  --score  [file.ll]   Score an emitted IR file. Counts ret-undef, orphan
                       blocks, missing terminators, wide-store-into-
                       narrow-malloc bugs, and similar quality smells.
                       Lower is better. Wide-store hits are fatal (the
                       heap-corruption bug class) and exit non-zero.
                       Defaults to the most recently emitted .ll.
  --rank   <file.av>   Rank functions in <file.av>'s emitted IR by line
                       count — useful for spotting bloat.

HEAP / MEMORY DEBUGGING
  --asan   <file.av>   Run bs2_asan on <file.av>. AddressSanitizer
                       reports the exact alloc/use-after-free site.
                       Builds bs2_asan if missing.
  --malloc-trace <file.av>
                       Run bs2 under MallocStackLogging + DYLD malloc
                       guard. Crash dumps include the alloc backtrace.
  --bisect-lines <file.av>
                       Binary-search the line count of <file.av> to find
                       the smallest prefix that still makes bs2 crash.
                       Useful for isolating heap-corruption triggers.

SEED MANAGEMENT
  --seed-status          Compare seed vs current source: show new, removed,
                         and changed functions. First thing to check when a
                         build fails.
  --seed-diff [fn]       Show IR diff between seed and fresh compile. With a
                         function name, shows just that function's diff.
  --build-seed           Build the seed binary from seed/seed.ll.
  --update-seed          Copy current bs2 output to seed/seed.ll with
                         provenance metadata (commit, timestamp, source hash).
  --verify-seed          Verify bootstrap chain integrity WITHOUT auto-cycle.
                         Builds seed → bs2 → verifies bs2 can self-compile →
                         verifies the resulting binary can also self-compile.
                         Prints OK or specific failure point. Use this to
                         check seed health before committing.
  --seed-patch           Incremental seed update. Compiles main.av with
                         bs2, diffs against seed/seed.ll per-function, copies
                         the new IR to seed, and reports exactly which
                         functions changed. Much faster feedback loop than
                         a full 'make update-seed' because it skips the
                         verify-seed rebuild. Use when iterating on source.
  --seed-sigs            Compare function signatures (parameter counts)
                         between seed/seed.ll and the bootstrap source
                         (packages/cli/src and packages/std-avrac/src). Reports
                         mismatches, new functions, and removed functions.
                         Catches the most common seed staleness issue:
                         parameter count changes that cause silent corruption.
  --check-bootstrap-window [ref]
                         Enforce the seed-train rule. Gate 1: no commit on
                         this branch (since the merge-base with the
                         integration branch) CHANGES the pinned seed content
                         (seed.lock bumps; seed.ll commits on pre-lock
                         history). Gate 2: HEAD's compiler source (what a
                         push ships — untracked/uncommitted files don't
                         count) builds from the integration branch's CURRENT
                         pristine seed in an isolated tree (cold unit cache)
                         and the produced compiler passes a smoke run.
                         [ref] defaults to origin/$AVRA_INTEGRATION_BRANCH
                         (feat/crafting-intepreters). Result is cached in
                         build/window/.window_verified keyed on the
                         integration seed + compiler sources; bypass with
                         AVRA_FORCE_WINDOW=1. Wired into the pre-push hook
                         and the bootstrap-window CI workflow.
  --check-typeck-collect-boundary [dir|file]
                         ps3t.8.3 Step-B env-purity lint. Fail if a typeck
                         env-registry write (the *_register helpers, or a
                         trait_impls/assoc_type_defs/shapes push) appears
                         outside the collect phase (collect_decls /
                         rewrite_fn_ret_tys) — a check-phase write would
                         re-couple items order-wise and break the per-item
                         query split. [dir] defaults to the typeck tree;
                         the guard test passes a temp dir.
  --check-central-domain t-kd4y.3.1 purity-ledger lint. Fail unless the grammar
                         engine's central build surface is EXACTLY the declared
                         classification: central_build_kind's domain ==
                         (engine_core_builds ∪ unflipped_builds) minus
                         central_tableless_builds; every executor arm head is
                         classified; the lists are disjoint and dup-free.
  --check-layout-boundary [dir]
                         ps3t.4.5(d) rep-boundary lint. Fail if codegen maps an
                         under-determined `.Unknown` type straight to an LLVM
                         layout (`.Unknown -> i64t` / `self.i64_type` / …) — the
                         silent-i64-guess bug (spec §6). The total resolve_layout
                         is the sole sanctioned `.Unknown` gate (it errors/ICEs),
                         and it BYPASSES the runtime ICE, so only this source lint
                         catches a reintroduction. [dir] defaults to the codegen
                         tree; the guard test passes a temp dir.
  --check-parser-flags
                         t-bw9s dead-flag lint. Every AVRA_PARSER_* name pinned in a
                         mode string (diagnose.sh's PARSER_MODE_*, any *_test.av) must
                         be one the compiler actually reads via avra_process_env_get.
                         A pin nothing reads selects no parser, so the probe compares a
                         path against itself and still prints an authoritative-looking
                         row — how AVRA_PARSER_DECL_FLIP survived its own deletion.
  --check-ci-gates [dir]
                         t-xkcw checkless-PR lint. Every gate is filtered to PRs
                         based on the integration branch, so a STACKED PR runs no
                         check at all — and an empty checks list reads as green.
                         stacked-pr.yml is the complement that fails loudly.
                         Asserts the union of the gates' `branches:` allowlists
                         equals the guard's `branches-ignore:` list, so every PR
                         base is covered exactly once. [dir] defaults to
                         .github/workflows; the guard test passes a temp dir.
  --seed-merge [--base ours|theirs|<ref>]
                         One-command seed-merge staging. For a merge where
                         the seed pin conflicted (seed.lock, or seed.ll on
                         pre-lock history): picks a base seed (default:
                         tries ours, then theirs), patches match traps,
                         builds stage1, compiles the merged source, links
                         bs2, self-compile verifies, then regenerates the
                         seed (--update-seed) and verifies the fixed point.
                         On a stage failure it reports the failure class —
                         parse / extern-guard / corruption — with next-step
                         hints, and falls through to the next candidate.
                         Recipe + taxonomy: docs/SEED_MERGES.md.
  --seed-merge-classify <rc> <logfile>
                         INTERNAL (spec-tested): print the --seed-merge
                         failure class for a stage-compile exit code + log.
  --seed-fetch           Materialize seed/seed.ll from seed/seed.lock
                         (pin-don't-vendor): download the pinned
                         GitHub Releases artifact, verify its sha256,
                         install it. No-op when seed.ll already exists —
                         a locally cycled seed is never clobbered.
  --seed-publish         Publish the local seed/seed.ll as a GitHub
                         Releases artifact (tag seed/v<N>) and bump
                         seed/seed.lock to pin it. Needs GH_TOKEN with
                         Contents:write. Lock bumps belong on the
                         integration branch (the seed train) —
                         gate 1 rejects them elsewhere at push time.
  --seed-fetch-from <lock> <dest>
                         INTERNAL (spec-tested): materialize+verify a
                         seed from an arbitrary lock file (file:// URLs
                         work, which is how the spec stays hermetic).
  --write-seed-lock <lock> <version> <sha256> <url>
                         INTERNAL (spec-tested): write a lock in the
                         exact format --seed-publish produces, so the
                         writer/parser round-trip is pinned by spec.
  --seed-train           The automated train advance: build from the
                         pin (no auto-cycle), verify the fixed point,
                         run the spec suite, then publish + bump the
                         lock ONLY when the compiler's output diverged
                         from the pinned artifact (provenance aside).
                         Run by .github/workflows/seed-train.yml on
                         every integration push; `make seed-train`
                         for manual advances.
  --seed-train-verify    The PR-side seed-train gate (read-only): run the
                         train's verify phase — build from the pin, check
                         the fixed point, run the spec suite — but STOP
                         before publish. Run by seed-train-verify.yml on
                         every PR into the integration branch so a merge
                         cannot land something that reds the train
                         post-merge. `make seed-train-verify` runs it
                         locally.
  --seed-verify-fp       Echo the (integration-seed × compiler-source)
                         fingerprint that keys the seed-train suite-skip
                         cache. seed-train-verify writes a PASS marker
                         under it; seed-train skips its redundant suite
                         re-run when the marker is present (build + fixed
                         point + publish still run). Same content hash on
                         a PR's merge ref and the squash commit, so the
                         pre-merge verify covers the post-merge train.
  --seed-canonical-sha <file>
                         INTERNAL (spec-tested): sha256 of a seed IR
                         with provenance comment lines stripped — the
                         train's "did the compiler change" identity.
  --seed-inputs-hash <seed.ll> [runtime.c] [llvm_wrapper.c]
                         INTERNAL (spec-tested): the path-independent
                         seed-binary input fingerprint (seed IR + C
                         link inputs) that keys build/seed and the
                         window's reuse fast path.
  --seed-self-contained <seed.ll>
                         INTERNAL (spec-tested): exit 0 iff the IR
                         defines every Avra-package symbol it uses (no
                         mangled extern declares) — the train's guard
                         that a pin can bootstrap a fresh clone with no
                         other objects.
  --slot-exec <cmd...>   Run <cmd> while holding one of AVRA_FIXTURE_JOBS
                         (default 2) cross-process compile slots — the
                         OOM guard bounding concurrent bs2 fixture
                         compiles during parallel test runs. --run takes
                         a slot automatically; use this to wrap direct
                         `bs2 compile` shell-outs.

  NOTE: 'make build' now AUTO-CYCLES the seed when self-compile fails.
  You rarely need to run 'make update-seed' manually anymore.

ENVIRONMENT
  LLVM_PREFIX  Override the LLVM install prefix.
               Default: /opt/homebrew/opt/llvm
  AVRA_VERIFY_RC=1  Machine-check the alloca zero-init invariant (zm77
               guard) on every compiled module; violations fail the build
               naming fn+slot. Always on during --build-bs2's self-compile
               integrity check.
  AVRA_RC_STRICT=1  Runtime sibling of AVRA_VERIFY_RC (rcsf.3): poison freed
               RC payloads (0xDD), quarantine them from reuse, and ABORT with
               a backtrace when a release path receives a pointer to already-
               freed RC memory (the zm77 phantom-release signature). Turns a
               silent corruption into a loud, first-offense abort. Exercised
               by --rc-strict-suite.
  AVRA_HEAVY_PROCS  The process NAMES --stray reports and --stray --reap
               kills (default: "bs2 llc cc1plus clang cc1"). Point it
               at a fake binary to exercise the kill paths against something
               that is provably not a real build — how stray_reap_test.av can
               SIGKILL a tree inside the live suite.

EXAMPLES
  diagnose.sh --build               # rebuild stage1 from rust + run tests
  diagnose.sh --build-bs2           # build the self-compiled bs2
  diagnose.sh --run /tmp/hello.av   # run a .av file with bs2
  diagnose.sh --diff /tmp/hello.av  # see how stage1 and bs2 diverge
  diagnose.sh --asan /tmp/big.av    # find heap corruption with ASan
  diagnose.sh --seed-patch            # incremental seed update with diff report
EOF
}

# ─────────────────────────────────────────────────────────────────────
# Build helpers
# ─────────────────────────────────────────────────────────────────────

ensure_runtime() {
  local cur_hash; cur_hash=$(md5sum "$RUNTIME_C" 2>/dev/null || md5 -q "$RUNTIME_C" 2>/dev/null)
  local hash_file="$BUILD_DIR/.runtime_hash"
  local old_hash; old_hash=$(cat "$hash_file" 2>/dev/null)
  if [ ! -f "$RUNTIME_O" ] || [ "$cur_hash" != "$old_hash" ]; then
    mkdir -p "$BUILD_DIR"
    log "compiling runtime → $RUNTIME_O"
    cc -c $RUNTIME_OPT -g -o "$RUNTIME_O" "$RUNTIME_C" || die "runtime build failed"
    echo "$cur_hash" > "$hash_file"
  fi
}

ensure_runtime_asan() {
  # Mirror ensure_runtime's hash-comparison invalidation — mtime
  # comparison (`-nt`) is vulnerable to the same APFS second-
  # granularity race source_newer_than was fixed for.
  local cur_hash; cur_hash=$(md5sum "$RUNTIME_C" 2>/dev/null || md5 -q "$RUNTIME_C" 2>/dev/null)
  local hash_file="$BUILD_DIR/.runtime_asan_hash"
  local old_hash; old_hash=$(cat "$hash_file" 2>/dev/null)
  if [ ! -f "$RUNTIME_ASAN_O" ] || [ "$cur_hash" != "$old_hash" ]; then
    mkdir -p "$BUILD_DIR"
    log "compiling runtime (ASan) → $RUNTIME_ASAN_O"
    cc -c -O0 -g -fsanitize=address -o "$RUNTIME_ASAN_O" "$RUNTIME_C" \
      || die "runtime ASan build failed"
    echo "$cur_hash" > "$hash_file"
  fi
}

ensure_llvm_wrapper() {
  local wrapper_src="$BOOTSTRAP_DIR/llvm_wrapper.c"
  local wrapper_hash="$BUILD_DIR/.llvm_wrapper_hash"
  local cur_hash; cur_hash=$(md5sum "$wrapper_src" 2>/dev/null || md5 -q "$wrapper_src" 2>/dev/null)
  local old_hash; old_hash=$(cat "$wrapper_hash" 2>/dev/null)
  if [ ! -f "$LLVM_WRAPPER_O" ] || [ "$cur_hash" != "$old_hash" ]; then
    log "compiling LLVM wrapper → $LLVM_WRAPPER_O"
    mkdir -p "$BUILD_DIR"
    cc -c -O2 -I"$LLVM_PREFIX/include" -o "$LLVM_WRAPPER_O" "$wrapper_src" \
      || die "LLVM wrapper build failed"
    echo "$cur_hash" > "$wrapper_hash"
  fi
}

# ── Seed lock: pin-don't-vendor ──
#
# The seed artifact is PINNED, not vendored (Rust stage0 model):
# seed/seed.lock (tracked, a few lines) names a version, the sha256 of
# the uncompressed seed IR, and a GitHub Releases download URL.
# seed/seed.ll itself is a gitignored local materialization — fetched
# on demand, or written locally by `make update-seed` during dev
# iteration. The lock advances only on the integration branch (the
# seed train), published via --seed-publish.

# Read one `key = value` field from a lock file ($1=file, $2=key).
seed_lock_field() {
  sed -n "s/^[[:space:]]*$2[[:space:]]*=[[:space:]]*//p" "$1" 2>/dev/null | head -1
}

# Materialize a seed .ll from a lock file: $1=lockfile, $2=dest.ll.
# Downloads the gz artifact (content-cached by sha under
# build/cache/seed/), verifies the UNCOMPRESSED sha256, installs
# atomically. An existing dest with the right hash short-circuits.
#
# Every failure RETURNS non-zero (with the reason on stderr) instead
# of die-ing: callers decide severity — the build path aborts, while
# --seed-merge falls through to its next candidate seed.
# Retry flags for every seed fetch, as a word-split string.
#
# --retry-all-errors is curl >= 7.71. An older curl (macOS still ships 7.64)
# treats it as an unknown option and exits 2 BEFORE making a request, which
# would look exactly like a dead URL and route every fetch down the fallback.
# Probe once per process and memoize.
SEED_CURL_RETRY=""
seed_curl_retry() {
  if [ -z "$SEED_CURL_RETRY" ]; then
    if curl --help all 2>/dev/null | grep -q -- '--retry-all-errors'; then
      SEED_CURL_RETRY="--retry 5 --retry-all-errors --retry-delay 2"
    else
      SEED_CURL_RETRY="--retry 5 --retry-delay 2"
    fi
  fi
  printf '%s' "$SEED_CURL_RETRY"
}

# Secondary route to a pinned release artifact: the GitHub REST API.
#
# `releases/download/…` is served by release-assets.githubusercontent.com,
# a DIFFERENT edge from api.github.com — and it fails independently of the
# release being healthy. Measured 2026-08-12: for ~an hour every CI job died
# here on `503` then `curl (56) connection died`, while the same URL served
# 200 / 7462300 bytes from a dev box and the API handed back byte-identical
# content. A pinned toolchain that a single CDN edge can halt is not pinned.
#
# Eligibility is by URL SHAPE, so a lock pointing at any other host produces
# no request at all. The token (when present) goes ONLY to the API host this
# function builds itself — never to the lock's URL — so the "no credentials
# to lock-controlled hosts" rule at the call site is preserved. Integrity is
# unchanged: the caller still verifies the sha256 pin over whatever arrives.
#
# AVRA_SEED_API_BASE is the test seam: with it set, any */releases/download/*
# URL is eligible, which lets the spec drive this whole path from file://
# URLs and keeps the suite hermetic.
seed_fetch_via_api() {
  local url="$1" out="$2"
  command -v jq >/dev/null 2>&1 || return 1

  local api="${AVRA_SEED_API_BASE:-}"
  if [ -n "$api" ]; then
    case "$url" in */releases/download/*) ;; *) return 1 ;; esac
  else
    api="https://api.github.com"
    case "$url" in https://github.com/*/releases/download/*) ;; *) return 1 ;; esac
  fi

  # <base>/<owner>/<repo>/releases/download/<tag>/<file>. The tag itself
  # contains a slash (`seed/v534`), so the FILE is the last component and
  # everything between `download/` and it is the tag.
  local before="${url%%/releases/download/*}"
  local repo_part="${before##*/}"
  local owner_head="${before%/*}"
  local owner_part="${owner_head##*/}"
  local tail_part="${url#*/releases/download/}"
  local file="${tail_part##*/}"
  local tag="${tail_part%/*}"
  [ -n "$owner_part" ] && [ -n "$repo_part" ] && [ -n "$tag" ] && [ -n "$file" ] \
    || return 1

  local auth=()
  local tok="${GH_TOKEN:-${GITHUB_TOKEN:-}}"
  [ -n "$tok" ] && auth=(-H "Authorization: Bearer $tok")

  warn "primary seed URL failed — retrying the same artifact via the GitHub API"
  local retry=""
  case "$api" in http://*|https://*) retry=$(seed_curl_retry) ;; esac
  local meta
  # shellcheck disable=SC2086  # word-splitting the retry flags is intended
  meta=$(curl -fsSL $retry --connect-timeout 15 --max-time 60 \
              ${auth[@]+"${auth[@]}"} \
              "$api/repos/$owner_part/$repo_part/releases/tags/$tag" 2>/dev/null) \
    || return 1
  local asset
  asset=$(printf '%s' "$meta" \
            | jq -r --arg n "$file" '.assets[]? | select(.name == $n) | .url' \
            | head -1)
  [ -n "$asset" ] && [ "$asset" != "null" ] || return 1
  local asset_retry=""
  case "$asset" in http://*|https://*) asset_retry=$(seed_curl_retry) ;; esac
  # shellcheck disable=SC2086  # word-splitting the retry flags is intended
  curl -fsSL $asset_retry --connect-timeout 15 --max-time 600 \
       -H "Accept: application/octet-stream" ${auth[@]+"${auth[@]}"} \
       -o "$out" "$asset"
}

fetch_seed_from_lock() {
  [ $# -eq 2 ] || die "usage: fetch_seed_from_lock <lockfile> <dest.ll>"
  local lock="$1" dest="$2"
  [ -f "$lock" ] || { err "no seed lock at $lock"; return 1; }
  # An unresolved merge leaves conflict markers in the lock, and the
  # field parser would silently serve the FIRST (ours) side as if the
  # merge were resolved. Refuse: the resolution is taking the HIGHER
  # version line, and it must be deliberate.
  if grep -qE '^(<<<<<<< |=======$|>>>>>>> )' "$lock"; then
    err "seed lock $lock contains merge-conflict markers — resolve the merge first"
    err "(artifacts are immutable: take the HIGHER version line; docs/SEED_MERGES.md)"
    return 1
  fi
  local want_sha url version
  want_sha=$(seed_lock_field "$lock" sha256)
  url=$(seed_lock_field "$lock" url)
  version=$(seed_lock_field "$lock" version)
  [ -n "$want_sha" ] && [ -n "$url" ] \
    || { err "malformed seed lock $lock (need sha256 + url)"; return 1; }

  if [ -f "$dest" ] \
     && [ "$($SHA256_CMD "$dest" | awk '{print $1}')" = "$want_sha" ]; then
    return 0
  fi

  mkdir -p "$SEED_FETCH_CACHE"
  # The cache is content-addressed by the PINNED sha, but trust nothing:
  # re-verify on the hit path too, so a truncated or tampered cache
  # entry is dropped and refetched instead of installed. (A mutation
  # test that disabled download-side verification poisoned this cache
  # and the hit path happily served the poison — hence this check.)
  local cached="$SEED_FETCH_CACHE/$want_sha.ll"
  if [ -f "$cached" ] \
     && [ "$($SHA256_CMD "$cached" | awk '{print $1}')" != "$want_sha" ]; then
    warn "dropping corrupt seed cache entry $cached (content does not match its name)"
    rm -f "$cached"
  fi
  if [ ! -f "$cached" ]; then
    log "fetching seed v${version:-?} from $url"
    local gz="$SEED_FETCH_CACHE/$want_sha.ll.gz.tmp.$$"
    # Deliberately NO Authorization header: the URL comes from the lock
    # file, and shipping a credential to an attacker-controlled host is
    # how tokens leak. Release assets on this (public) repo download
    # anonymously; integrity comes from the sha256 pin, not the channel.
    # --retry-all-errors because the observed CDN failure alternates between
    # a 5xx (which bare --retry covers) and a dropped connection mid-transfer
    # (which it does not) — retrying only half of a flapping edge is the same
    # as not retrying it.
    # Retries are for a flapping NETWORK. A file:// path that cannot be
    # opened will not open on the fifth try, and retrying it would put ten
    # seconds into every dead-URL case in the spec.
    local retry=""
    case "$url" in http://*|https://*) retry=$(seed_curl_retry) ;; esac
    # shellcheck disable=SC2086  # word-splitting the retry flags is intended
    if ! curl -fsSL $retry \
              --connect-timeout 15 --max-time 600 -o "$gz" "$url" \
       && ! seed_fetch_via_api "$url" "$gz"; then
      rm -f "$gz"
      err "seed fetch failed: $url"
      err "Offline? A previously materialized seed/seed.ll keeps working; otherwise"
      err "obtain the artifact for lock v${version:-?} (sha256 $want_sha) and place it"
      err "at $dest."
      return 1
    fi
    # Cap the decompressed size: the hash pin stops SUBSTITUTION but
    # not EXPANSION — a small gzip of endless zeros would fill the
    # disk before verification ever ran. head truncates at the cap;
    # a truncated legitimate artifact then fails the hash check.
    # (AVRA_SEED_MAX_BYTES exists so the spec can exercise the cap
    # without writing gigabytes.)
    local max_bytes="${AVRA_SEED_MAX_BYTES:-2147483648}"
    if ! gunzip -c "$gz" | head -c "$max_bytes" > "$cached.tmp.$$"; then
      rm -f "$gz" "$cached.tmp.$$"
      err "seed artifact gunzip failed (truncated download, or larger than $max_bytes bytes)"
      return 1
    fi
    rm -f "$gz"
    local got_sha
    got_sha=$($SHA256_CMD "$cached.tmp.$$" | awk '{print $1}')
    if [ "$got_sha" != "$want_sha" ]; then
      rm -f "$cached.tmp.$$"
      err "seed artifact hash mismatch: lock pins $want_sha, artifact is $got_sha — refusing"
      return 1
    fi
    mv "$cached.tmp.$$" "$cached"
  fi
  mkdir -p "$(dirname "$dest")"
  if ! cp "$cached" "$dest.tmp.$$" || ! mv "$dest.tmp.$$" "$dest"; then
    rm -f "$dest.tmp.$$"
    err "failed to install materialized seed at $dest (cp/mv failed)"
    return 1
  fi
  log "seed v${version:-?} materialized at $dest (sha256 verified)"
}

# Write a seed lock pinning one artifact: $1=lock path, $2=version,
# $3=sha256 of the uncompressed IR, $4=download URL. The single
# producer of the lock format seed_lock_field parses — spec-tested as
# a round-trip so the two can never drift apart silently.
write_seed_lock() {
  local lock="$1" version="$2" sha="$3" url="$4"
  cat > "$lock" <<EOF
# Avra bootstrap seed lock — pin-don't-vendor.
# seed/seed.ll is NOT in git: the build fetches this pinned artifact and
# verifies the sha256 of the uncompressed IR. The lock advances only on
# the integration branch (the seed train) via:
#   bash scripts/diagnose.sh --seed-publish
# Merge conflict on this file = two train advances raced; take the
# HIGHER version line (artifacts are immutable). docs/SEED_MERGES.md.
version = $version
sha256 = $sha
url = $url
EOF
}

# Ensure seed/seed.ll exists locally: present = use as-is (it may
# legitimately be AHEAD of the lock during dev iteration — never
# clobber); missing = fetch per the lock (the fresh-clone path).
ensure_seed_materialized() {
  [ -f "$SEED_LL" ] && return 0
  [ -f "$SEED_LOCK" ] || die "neither seed/seed.ll nor seed/seed.lock exists — repo is corrupt"
  fetch_seed_from_lock "$SEED_LOCK" "$SEED_LL" \
    || die "could not materialize the pinned seed (reasons above)"
}

mode_seed_fetch() {
  ensure_seed_materialized
  ok "$SEED_LL"
}

# The sha256 of a ref's EFFECTIVE seed content: the tracked seed.ll
# blob hashed directly (pre-lock history), or the lock's pinned sha256
# (lock-era). Empty when the ref has neither. Lets gate 1 compare seed
# SEMANTICS across the vendored→pinned transition instead of file
# paths — the vendored→pinned migration commit touches both files without
# changing the seed.
ref_seed_sha256() {
  local r="$1"
  if git -C "$REPO_DIR" rev-parse --verify --quiet "$r:bootstrap/seed/seed.ll" >/dev/null; then
    git -C "$REPO_DIR" cat-file blob "$r:bootstrap/seed/seed.ll" | $SHA256_CMD | awk '{print $1}'
  elif git -C "$REPO_DIR" rev-parse --verify --quiet "$r:bootstrap/seed/seed.lock" >/dev/null; then
    local tmp; tmp=$(mktemp)
    git -C "$REPO_DIR" cat-file blob "$r:bootstrap/seed/seed.lock" > "$tmp"
    seed_lock_field "$tmp" sha256
    rm -f "$tmp"
  fi
}

# Publish the CURRENT local seed/seed.ll as a release artifact and
# bump seed/seed.lock to pin it. Seed-train discipline: lock bumps
# belong on the integration branch only (gate 1 of the bootstrap
# window rejects them elsewhere at push time).
mode_seed_publish() {
  [ -f "$SEED_LL" ] || die "no local seed at $SEED_LL — build one first (make update-seed)"
  [ -n "${GH_TOKEN:-}" ] || die "--seed-publish needs GH_TOKEN (Contents:write on $SEED_REPO_SLUG)"
  command -v python3 >/dev/null || die "--seed-publish needs python3 (JSON handling)"

  local cur_branch
  cur_branch=$(git -C "$REPO_DIR" rev-parse --abbrev-ref HEAD)
  if [ "$cur_branch" != "$INTEGRATION_BRANCH" ]; then
    warn "publishing from '$cur_branch' (the lock normally advances on '$INTEGRATION_BRANCH' only)"
  fi

  local version=1
  if [ -f "$SEED_LOCK" ]; then
    local prev; prev=$(seed_lock_field "$SEED_LOCK" version)
    if [ -n "$prev" ]; then
      case "$prev" in
        *[!0-9]*) die "seed lock version '$prev' is not a number — fix seed/seed.lock first" ;;
      esac
      version=$((prev + 1))
    fi
  fi
  local sha tag
  sha=$($SHA256_CMD "$SEED_LL" | awk '{print $1}')
  tag="seed/v$version"

  local staging="$BUILD_DIR/seed_publish"
  mkdir -p "$staging"

  # A corrupt pin bricks every fresh clone until the next train
  # advance, so prove the artifact is a working compiler before it
  # becomes the pin: build a stage binary from it and smoke-run a
  # compile. ~60-90s on a rare operation; AVRA_SKIP_PUBLISH_VERIFY=1
  # for genuine emergencies only.
  if [ "${AVRA_SKIP_PUBLISH_VERIFY:-0}" != "1" ]; then
    ensure_runtime
    ensure_llvm_wrapper
    log "verifying the seed before publishing (stage build + smoke)"
    llc_link_bin "$SEED_LL" "$staging/verify.o" "$staging/verify_bin" "$staging/verify.build.log"       || { cat "$staging/verify.build.log" >&2; die "seed fails to build — refusing to publish a broken artifact"; }
    smoke_test_compiler "$staging" "$staging/verify_bin"       || die "seed binary fails the smoke run — refusing to publish a broken artifact"
  fi

  log "compressing seed.ll for upload"
  gzip -9 -c "$SEED_LL" > "$staging/seed.ll.gz" || die "gzip failed"

  local commit api="https://api.github.com/repos/$SEED_REPO_SLUG"
  commit=$(git -C "$REPO_DIR" rev-parse HEAD)
  log "creating release $tag on $SEED_REPO_SLUG (target $commit)"
  local rel_json rel_id
  rel_json=$(curl -fsS --connect-timeout 15 --max-time 180 --retry 3 -X POST -H "Authorization: Bearer $GH_TOKEN" \
    -H "Content-Type: application/json" "$api/releases" \
    -d "{\"tag_name\":\"$tag\",\"target_commitish\":\"$commit\",\"name\":\"bootstrap seed v$version\",\"body\":\"Avra bootstrap seed artifact, pinned by bootstrap/seed/seed.lock.\\nsha256 (uncompressed): $sha\",\"prerelease\":true}") \
    || die "release create failed for $tag (already exists? bump again or delete it)"
  rel_id=$(printf '%s' "$rel_json" | python3 -c 'import json,sys; print(json.load(sys.stdin)["id"])') \
    || die "could not parse release id"
  log "uploading seed.ll.gz ($(du -h "$staging/seed.ll.gz" | cut -f1 | tr -d ' '))"
  curl -fsS --connect-timeout 15 --max-time 300 --retry 3 -X POST -H "Authorization: Bearer $GH_TOKEN" \
    -H "Content-Type: application/gzip" \
    --data-binary @"$staging/seed.ll.gz" \
    "https://uploads.github.com/repos/$SEED_REPO_SLUG/releases/$rel_id/assets?name=seed.ll.gz" \
    >/dev/null || {
      # Drop the asset-less release so a retry can recreate the same
      # tag instead of dying on "already exists".
      curl -fsS --connect-timeout 15 --max-time 60 -X DELETE -H "Authorization: Bearer $GH_TOKEN" \
        "$api/releases/$rel_id" >/dev/null 2>&1 || :
      die "asset upload failed (release $tag rolled back — safe to retry)"
    }

  write_seed_lock "$SEED_LOCK" "$version" "$sha" \
    "https://github.com/$SEED_REPO_SLUG/releases/download/$tag/seed.ll.gz"
  rm -f "$staging/seed.ll.gz"
  ok "published $tag and pinned it in seed/seed.lock"
  log "next: git add bootstrap/seed/seed.lock && commit (a 'chore(seed): cycle' train commit)"
}

# Advance the seed train: after a merge lands on the integration
# branch, decide whether the pinned seed is stale relative to the
# merged compiler source and publish + pin the regenerated seed when
# it is. Run by .github/workflows/seed-train.yml after every
# integration push (or manually via `make seed-train`). With the
# train automated, the full loop is: feature branches never cycle
# (gate-enforced) → merge → CI advances the pin → everyone dogfoods
# on rebase.
mode_seed_train() {
  # Verify exactly what the PR gate verifies — shared code path, so parity is
  # by construction — then publish. seed_train_verify sets NO_AUTOCYCLE, so the
  # train never papers over a pin that can't build the merged source.
  seed_train_verify "seed train"

  # The published seed MUST be self-contained: a fresh clone bootstraps
  # it via seed.ll -> llc + cc -> seed binary with no other objects. The
  # build above may have used the metadata fast-path (AVRA_USE_METADATA
  # + AVRA_LIB_OBJS), which leaves @std symbols as EXTERN DECLARATIONS in
  # main.av.ll rather than definitions — fine for an incremental link,
  # fatal for a pin (the 2026-06-13 first-train failure: such a seed
  # bricks every fresh clone with undefined @std symbols). Recompile
  # hermetically (metadata fast-path stripped) so the candidate defines
  # every symbol it references; this also makes the divergence compare
  # below apples-to-apples against the (self-contained) pinned artifact.
  log "seed train: regenerating a self-contained seed IR (hermetic compile)"
  ( cd "$BOOTSTRAP_DIR" && hermetic_compile_env "$BS2" compile "$SRC_DIR/main.av" ) \
    >"$BUILD_DIR/seed_train.hermetic.log" 2>&1 \
    || { cat "$BUILD_DIR/seed_train.hermetic.log" >&2; die "hermetic recompile failed — cannot produce a self-contained seed"; }

  # Publish only when the compiler's OUTPUT changed: compare the
  # generation-2 IR against the pinned artifact, provenance aside.
  # Doc-only / test-only merges advance nothing.
  local candidate="$SRC_DIR/main.av.ll"
  [ -f "$candidate" ] || die "no generated IR at $candidate after the hermetic recompile"
  # Self-containment is enforced at the seed-writing chokepoint
  # (mode_update_seed), so it holds for `make update-seed` too — not
  # only this path.
  local pinned="$BUILD_DIR/seed_train.pinned.ll"
  fetch_seed_from_lock "$SEED_LOCK" "$pinned" \
    || die "cannot fetch the pinned artifact (the train needs network to publish anyway)"
  if [ "$(seed_canonical_sha "$pinned")" = "$(seed_canonical_sha "$candidate")" ]; then
    ok "seed train: the pin already matches the compiler's output — nothing to publish"
    return 0
  fi

  log "seed train: compiler output diverged from the pin — advancing"
  mode_update_seed
  mode_seed_publish
  ok "seed train advanced — commit bootstrap/seed/seed.lock to complete the cycle"
}

# The fingerprint that keys the seed-train suite-skip cache: the integration
# seed identity × every compiler-source blob at HEAD (window_fingerprint, the
# same content hash the bootstrap-window verify cache uses). It is IDENTICAL
# whenever a PR's seed-train-verify already ran the full suite on the same seed
# and same compiler source as the merged HEAD — a squash merge preserves the
# source blobs, so the merge ref the PR tested and the squash commit on the
# integration branch hash to the same value. seed-train-verify publishes a PASS
# marker under this fingerprint on success; seed-train skips its redundant suite
# re-run when the marker is present. A concurrent merge that changed the seed or
# the compiler source yields a DIFFERENT fingerprint → no marker → the suite
# runs, so the 4szi.1 "untested combination" safety net stays intact.
seed_verify_fingerprint() {
  local head; head=$(git -C "$REPO_DIR" rev-parse HEAD) || die "cannot resolve HEAD"
  local seed_id; seed_id=$(ref_seed_sha256 HEAD) \
    || die "HEAD pins no seed (no seed.ll or seed.lock)"
  window_fingerprint "$seed_id" "$head"
}
mode_seed_verify_fp() { seed_verify_fingerprint; }

# The verify phase shared by `--seed-train` (which then publishes) and
# `--seed-train-verify` (the PR gate, which stops here). Build the compiler from
# the CURRENT pin (NO_AUTOCYCLE — a pin that can't build the merged source is a
# window-gate failure a human must see, never something to auto-cycle around),
# check the selfhost fixed point, then run the full spec suite. This is EXACTLY
# what the train runs before it publishes, so a green PR gate guarantees the
# post-merge train cannot fail on build / fixed-point / suite. $1 = context
# label woven into the diagnostics.
seed_train_verify() {
  local ctx="${1:-seed train}"
  export NO_AUTOCYCLE=1

  log "$ctx: building from the current pin"
  mode_build_bs2
  mode_check_fixedpoint || die "$ctx: fixed point broken — bs2 and bs3 disagree"

  # The train sets AVRA_SEED_TRAIN_SKIP_SUITE=1 ONLY after restoring a PASS
  # marker its PR-side seed-train-verify wrote for THIS exact seed×source
  # fingerprint — so the full suite already ran green on identical inputs and
  # re-running it is pure redundancy (~the train's longest phase). Build + fixed
  # point still run above (the train needs a built bs2 for the hermetic
  # recompile). The PR gate is the marker's PRODUCER and never sets this, so it
  # always runs the suite. A bug anywhere in the marker plumbing can only fail
  # to find a marker → the suite runs (today's behaviour); it can never skip a
  # suite that did not already pass, because the marker is written only on a
  # fully green verify (the workflow's `if: success()`).
  if [ "${AVRA_SEED_TRAIN_SKIP_SUITE:-}" = "1" ]; then
    ok "$ctx: spec suite skipped — PASS marker matches this seed+source fingerprint (already verified pre-merge)"
    return 0
  fi

  log "$ctx: running the spec suite"
  ( cd "$BOOTSTRAP_DIR" && "$BS2" test ) || die "$ctx: spec suite red"
}

# The PR-side seed-train gate (read-only): the train's verify phase, stopping
# before publish. Wired into .github/workflows/seed-train-verify.yml on every PR
# into the integration branch so a merge can't land something that reds the
# train post-merge — the gap that let the 4szi.1 flake (and #538/#539) sail
# through diff-test + bootstrap-window and only fail the train AFTER merging.
# No token, no writes; the publish half (lock bump) is the train's alone.
mode_seed_train_verify() {
  seed_train_verify "seed-train verify"
  ok "seed-train verify holds — build + fixed point + spec suite all green from the pin"
}

# A seed IR MUST be self-contained: a fresh clone bootstraps it via
# seed.ll -> llc + cc -> seed binary with no other objects, so every
# Avra-package symbol it uses has to be DEFINED in the IR, never left
# as an extern `declare` (the metadata fast-path emits externs and
# resolves them from separate .o files — fine for an incremental build,
# fatal for a pin). Mangled package symbols carry the `$40` prefix
# (`@` escaped, e.g. `$40std$3A$3A...`); C externs like @avra_alloc are
# unmangled and don't match, so a `declare` of any `$40`-mangled symbol
# is exactly an unresolved package reference. True (0) iff the IR
# declares no such externs. $1 = IR path.
seed_is_self_contained() {
  # An I/O failure must never read as "self-contained" — distinguish a
  # clean no-extern result (0) from a missing/unreadable IR or a grep
  # error (2), rather than collapsing every non-zero into success.
  [ $# -eq 1 ] || die "usage: --seed-self-contained <seed.ll>"
  [ -r "$1" ] || { err "cannot read IR: $1"; return 2; }
  grep -qE '^declare .*\$40' "$1"
  case $? in
    0) return 1 ;;  # a mangled package extern remains — NOT self-contained
    1) return 0 ;;  # no mangled package externs — self-contained
    *) err "failed to inspect IR: $1"; return 2 ;;
  esac
}

# sha256 of a seed IR with comment lines stripped. update-seed stamps
# provenance comments (commit, timestamp) into the artifact, so two
# pins of byte-identical compiler OUTPUT differ textually; bs2's own
# emitter never writes comment lines, so stripping `;` lines yields a
# stable identity for "did the compiler actually change".
seed_canonical_sha() {
  grep -v '^;' "$1" | $SHA256_CMD | awk '{print $1}'
}

# Content fingerprint for a seed binary's full input set: the seed IR
# plus the C link inputs (runtime.c, llvm_wrapper.c) — build/seed
# links runtime.o + llvm_wrapper.o, so editing either C file must
# relink it. Path-independent (hashes of content only), so the same
# seed content fingerprints identically from seed/seed.ll and from a
# window-extracted copy. Before the C inputs were keyed, a stale seed
# kept the OLD C behaviour and its failures got misattributed
# downstream (ensure_bs2's -O2-miscompile fallback fired for what was
# really an out-of-date wrapper).
seed_inputs_hash() {
  # $2/$3 override the C inputs (the window gate fingerprints HEAD's
  # copies); default to the dev tree's.
  { $SHA256_CMD "$1" "${2:-$RUNTIME_C}" "${3:-$BOOTSTRAP_DIR/llvm_wrapper.c}" 2>/dev/null; } \
    | awk '{print $1}' | $SHA256_CMD | awk '{print $1}'
}

ensure_seed() {
  ensure_llvm_wrapper
  ensure_runtime
  ensure_seed_materialized
  # Use hash comparison (race-free) instead of `-nt` mtime check —
  # consistent with ensure_runtime / ensure_llvm_wrapper and immune
  # to the APFS second-granularity race source_newer_than was fixed
  # for. A change to seed/seed.ll (typically from `make update-seed`
  # in the same shell session as a previous build) — or to the C link
  # inputs — reliably invalidates.
  local seed_hash; seed_hash=$(seed_inputs_hash "$SEED_LL")
  local seed_hash_file="$BUILD_DIR/.seed_hash"
  local old_seed_hash; old_seed_hash=$(cat "$seed_hash_file" 2>/dev/null)
  if [ "${1:-}" = "force" ] || [ ! -x "$SEED_BIN" ] || [ "$seed_hash" != "$old_seed_hash" ]; then
    [ -f "$SEED_LL" ] || die "seed IR not found at $SEED_LL — repo is corrupt"
    log "building seed compiler from seed/seed.ll"
    mkdir -p "$BUILD_DIR"
    "$LLC" -O2 $LLC_RELOC -filetype=obj "$SEED_LL" -o "$BUILD_DIR/seed.o" \
      || die "seed llc failed"
    cc -o "${SEED_BIN}.tmp" "$BUILD_DIR/seed.o" "$RUNTIME_O" "$LLVM_WRAPPER_O" \
      $STACK_LDFLAGS \
      $EXPORT_DYNAMIC $LD_SELECT -L"$LLVM_PREFIX/lib" -lLLVM $CXXLIB 2>"$BUILD_DIR/seed.link.log" \
      || { rm -f "${SEED_BIN}.tmp"; cat "$BUILD_DIR/seed.link.log" >&2; die "seed link failed"; }
    mv "${SEED_BIN}.tmp" "$SEED_BIN"
    echo "$seed_hash" > "$seed_hash_file"
  fi
}

# Link an LLVM IR file into an executable.
# rqwh: shared-inputs fingerprint for the link cache. Hashing
# runtime.o/llvm_wrapper.o per fixture would cost ~30ms × N fixtures
# on every run. Cache the combined hash, invalidate via mtime: if the
# cache file is newer than every input, reuse; otherwise recompute.
# Stable across sequential link_ll calls in the same test session.
# (bs2 itself is deliberately NOT an input — see link_shared_fp.)
#
# 0qmm: link-binary cache lives inside the project's build/cache/
# (under a `link/` sub-namespace alongside `meta/`), so every cached
# artifact lives in one tree — no parallel ~/.cache/avra-* directories.
# `bs2 cache clean` and `make clean --all` reach this slot uniformly.
LINK_CACHE_DIR="$BUILD_DIR/cache/link"
LINK_SHARED_FP_FILE="$LINK_CACHE_DIR/.shared-fp"

link_shared_fp() {
  # fxwn: include AVRA_LIB_OBJS in the fingerprint so the link cache
  # invalidates when the @std producer objects change. uzs9.3: hash the
  # objects' CONTENT, not the path string — producer paths embed the
  # unit fingerprint, which embeds the bs2 hash, so path-hashing missed
  # on every compiler rebuild even when the objects were byte-identical.
  # Content hashing is strictly more precise (a body change still
  # changes the hash) and survives fp-slot renames. Bypasses the mtime
  # memo when LIB_OBJS is set since the sidecar doesn't capture it.
  local libobjs_h=""
  if [ -n "${AVRA_LIB_OBJS:-}" ]; then
    libobjs_h=$(printf '%s' "$AVRA_LIB_OBJS" | tr ':' '\n' \
      | xargs $SHA256_CMD 2>/dev/null | cut -d' ' -f1 \
      | $SHA256_CMD | cut -d' ' -f1)
  fi
  if [ -z "$libobjs_h" ] \
     && [ -f "$LINK_SHARED_FP_FILE" ] \
     && [ "$LINK_SHARED_FP_FILE" -nt "$RUNTIME_O" ] \
     && [ "$LINK_SHARED_FP_FILE" -nt "$LLVM_WRAPPER_O" ]; then
    cat "$LINK_SHARED_FP_FILE"
    return
  fi
  mkdir -p "$LINK_CACHE_DIR"
  local runtime_h wrapper_h composed
  # uzs9.3: bs2 is NOT a link input — the linked binary is a function of
  # (the .ll bytes, runtime.o, llvm_wrapper.o, lib objs, flags), and the
  # per-link key in link_ll already hashes the .ll content, which captures
  # the compiler's entire contribution exactly. Hashing the bs2 binary
  # here only over-invalidated: any bs2 rebuild (even a help-string edit)
  # evicted every cached link of byte-identical IR.
  runtime_h=$($SHA256_CMD "$RUNTIME_O" | cut -d' ' -f1)
  wrapper_h=$($SHA256_CMD "$LLVM_WRAPPER_O" | cut -d' ' -f1)
  composed=$(printf '%s:%s:%s' "$runtime_h" "$wrapper_h" "$libobjs_h" \
    | $SHA256_CMD | cut -d' ' -f1)
  # Don't persist when libobjs_h is set — it's per-invocation state,
  # and persisting would make the next call without LIB_OBJS hit
  # the stale cached value.
  if [ -z "$libobjs_h" ]; then
    printf '%s' "$composed" > "$LINK_SHARED_FP_FILE"
  fi
  printf '%s' "$composed"
}

link_ll() {
  local ll="$1" out="$2" logfile="$3" coverage="${4:-}"

  # rqwh: link-step content cache. Skip cache for coverage builds —
  # they pull in clang_rt.profile_osx which has its own version axes
  # not tracked here, AND emit profraw files keyed on the binary
  # itself, so cache hits would short-circuit the instrumentation
  # this path exists to add.
  local cached_bin=""
  if [ -z "$coverage" ] && [ -f "$ll" ]; then
    local shared_fp ll_h fp
    shared_fp=$(link_shared_fp)
    ll_h=$($SHA256_CMD "$ll" | cut -d' ' -f1)
    fp=$(printf '%s:%s' "$shared_fp" "$ll_h" | $SHA256_CMD | cut -d' ' -f1 | head -c 16)
    cached_bin="$LINK_CACHE_DIR/$fp.bin"
    if [ -f "$cached_bin" ]; then
      # Stage + rename, never cp-in-place: cp truncates $out where it
      # stands, so a concurrent exec of $out (a live test shard when
      # $out is build/bs2) sees a half-written binary — or the cp
      # itself dies on ETXTBSY. mv swaps the inode atomically; running
      # processes keep the old image.
      cp "$cached_bin" "${out}.tmp.$$" && mv "${out}.tmp.$$" "$out" \
        || { rm -f "${out}.tmp.$$"; die "link-cache copy failed for $out"; }
      return
    fi
  fi

  local obj_ll="$ll"
  # Coverage: lower instrprof intrinsics before llc
  if [ "$coverage" = "coverage" ]; then
    local lowered="${ll%.ll}.cov.ll"
    "$LLVM_PREFIX/bin/opt" -passes=instrprof -o "$lowered" -S "$ll" \
      --mtriple=arm64-apple-macosx \
      || die "opt instrprof lowering failed for $ll"
    obj_ll="$lowered"
  fi
  # PID-scoped object: two concurrent link_ll calls on the same $out
  # (e.g. racing ensure_bs2 rebuilds) would clobber each other's
  # ${out}.o mid-llc and feed cc a torn object. Stage per-invocation,
  # publish by rename after the link succeeds.
  local tmp_obj="${out}.o.tmp.$$"
  "$LLC" -O2 $LLC_RELOC -filetype=obj "$obj_ll" -o "$tmp_obj" \
    || { rm -f "$tmp_obj"; die "llc failed for $ll"; }
  local extra_libs=""
  if [ "$coverage" = "coverage" ]; then
    # Link against LLVM's profiling runtime for .profraw output
    local clang_rt_dir="$LLVM_PREFIX/lib/clang/$(ls "$LLVM_PREFIX/lib/clang/" | head -1)/lib/darwin"
    extra_libs="-L$clang_rt_dir -lclang_rt.profile_osx"
  fi
  # fxwn: when AVRA_USE_METADATA is set, the .ll has extern decls for
  # @std/* fns whose bodies live in pre-built producer .o files. Pull
  # them in via AVRA_LIB_OBJS (colon-separated, mirrors PATH). Without
  # this the link step fails with "undefined symbols" for every @std fn.
  local lib_objs=""
  if [ -n "${AVRA_LIB_OBJS:-}" ]; then
    lib_objs=$(printf '%s' "$AVRA_LIB_OBJS" | tr ':' ' ')
  fi
  # Atomic + race-safe link: cc writes to a PID-scoped .tmp sibling,
  # then rename. The .tmp suffix carries `$$` so concurrent shards
  # racing on the same fixture binary path (e.g. cbg3-era continuous
  # dispatch under jdgo) can't clobber each other's intermediate file
  # and trigger spurious `mv: rename ... : No such file or directory`
  # errors that contaminate cached fixture stdout. If cc is killed
  # mid-write (jetsam under memory pressure has done this 3x this
  # iteration alone), the previous $out remains intact instead of
  # being corrupted into a 2.2MB Mach-O that SIGKILLs on dyld load.
  local tmp_out="${out}.tmp.$$"
  cc -o "$tmp_out" "$tmp_obj" "$RUNTIME_O" "$LLVM_WRAPPER_O" $lib_objs \
    $STACK_LDFLAGS \
    $EXPORT_DYNAMIC $LD_SELECT -L"$LLVM_PREFIX/lib" -lLLVM $CXXLIB $extra_libs 2>"$logfile" \
    || { rm -f "$tmp_out" "$tmp_obj"; cat "$logfile" >&2; die "link failed for $out"; }
  mv "$tmp_obj" "${out}.o"
  mv "$tmp_out" "$out"

  # rqwh: publish to cache on success. Atomic write via .tmp + mv so
  # parallel shards racing on the same cache slot can't observe a
  # partial bin. Suspected root cause of the 4 cold-rebuild flakies:
  # shard A's cp interrupted mid-write; shard B reads partial bin
  # → broken binary → wrong/missing stdout → test assertion fails.
  if [ -n "$cached_bin" ] && [ -f "$out" ]; then
    cp "$out" "${cached_bin}.tmp.$$" \
      && mv "${cached_bin}.tmp.$$" "$cached_bin" \
      || rm -f "${cached_bin}.tmp.$$" 2>/dev/null
  fi
}

# Compile <fg> with bs2, producing <fg>.ll.
emit_ll_bs2() {
  local fg="$1"
  ensure_bs2
  local out
  if ! out=$("$BS2" compile "$fg" 2>&1); then
    err "$out"
    die "bs2 codegen failed for $fg"
  fi
  echo "$fg.ll"
}

ensure_bs2() {
  # AVRA_SKIP_ENSURE_BS2=1 is the test orchestrator's signal that bs2
  # is already current — run_test_command stamps it (via
  # avra_process_env_set) before dispatching, so every shard and every
  # test's shell-out inherits it. The bs2 running the suite IS the
  # compiler under test, so the guard is correct by construction.
  # Without this short-circuit, a stale-looking tree would make every
  # one of the ~10 diagnose.sh-based tests running in parallel shards
  # kick off its own bs2 rebuild — concurrent seed compiles holding
  # 1-2GB RSS each (jetsam mass-kill) AND racing relinks of build/bs2
  # while live shards exec it (t-gv3n).
  if [ -n "${AVRA_SKIP_ENSURE_BS2:-}" ]; then
    [ -x "$BS2" ] || die "AVRA_SKIP_ENSURE_BS2 set but $BS2 missing"
    return
  fi
  ensure_seed "${1:-}"
  if [ "${1:-}" = "force" ] || source_newer_than "$BS2" \
     || [ "$SEED_LL" -nt "$BS2" ]; then
    log "compiling packages/cli/src/main.av with seed compiler"
    # The SEED performs this compile, and the pinned seed can predate
    # the dep-aware compile-cache key (pdme.1): an older seed keys the
    # unit on the ENTRY file only, so after a NON-entry edit (the very
    # situation source_newer_than just detected) it would HIT its stale
    # slot and silently re-link the previous bs2. We only reach this
    # branch when a source genuinely changed, so a fresh compile is
    # owed regardless — drop the unit cache so no seed vintage can
    # serve stale here. The src/build/cache path is where exactly those
    # old vintages park compile entries (newer compilers cache at the
    # package root AND key dep-aware, so they need no drop).
    rm -rf "$CLI_SRC_DIR/build/cache"
    # Sample the digest BEFORE the compile reads the sources. Stamping after
    # the link would record any edit made in between as the baseline for a
    # binary built from the previous bytes — reporting a genuinely stale
    # target as fresh.
    local pre_srcfp; pre_srcfp=$(compiler_sources_fp)
    if "$SEED_BIN" compile "$SRC_DIR/main.av" >"$BUILD_DIR/bs2.codegen.log" 2>&1; then
      log "linking $BS2"
      link_ll "$SRC_DIR/main.av.ll" "$BS2" "$BUILD_DIR/bs2.link.log"
      stamp_compiler_sources_value "$BS2" "$pre_srcfp"
      ok "built $BS2"
    else
      # Seed crashed. Check if it's an LLVM -O2 miscompilation by
      # rebuilding the seed at -O0 and retrying.
      warn "seed crashed at -O2 — testing for LLVM optimization bug"
      "$LLC" -O0 $LLC_RELOC -filetype=obj "$SEED_LL" -o "$BUILD_DIR/seed_o0.o" \
        || die "seed llc -O0 failed"
      cc -o "$BUILD_DIR/seed_o0.tmp" "$BUILD_DIR/seed_o0.o" "$RUNTIME_O" "$LLVM_WRAPPER_O" \
        $STACK_LDFLAGS \
        $EXPORT_DYNAMIC $LD_SELECT -L"$LLVM_PREFIX/lib" -lLLVM $CXXLIB 2>/dev/null \
        || { rm -f "$BUILD_DIR/seed_o0.tmp"; die "seed -O0 link failed"; }
      mv "$BUILD_DIR/seed_o0.tmp" "$BUILD_DIR/seed_o0"
      local retry_srcfp; retry_srcfp=$(compiler_sources_fp)
      if "$BUILD_DIR/seed_o0" compile "$SRC_DIR/main.av" >"$BUILD_DIR/bs2.codegen.log" 2>&1; then
        warn "LLVM OPTIMIZATION BUG: seed works at -O0 but crashes at -O2"
        warn "This is an llc -O2 miscompilation on $(uname -m), not a Avra bug."
        warn "Fix: run 'make update-seed' to regenerate the seed IR, which"
        warn "      typically produces a different IR pattern that avoids the bug."
        warn ""
        warn "Continuing build with -O0 seed..."
        # Use the -O0 seed to complete the build
        cp "$BUILD_DIR/seed_o0" "$SEED_BIN"
        log "linking $BS2"
        link_ll "$SRC_DIR/main.av.ll" "$BS2" "$BUILD_DIR/bs2.link.log"
        stamp_compiler_sources_value "$BS2" "$retry_srcfp"
        ok "built $BS2 (via -O0 seed fallback)"
      else
        cat "$BUILD_DIR/bs2.codegen.log" >&2
        die "bs2 codegen failed (crashes at both -O2 and -O0)"
      fi
    fi
  fi
}

# Link an LLVM IR file into an executable at -O0 (for debuggability).
link_ll_O0() {
  local ll="$1" out="$2" logfile="$3"
  # Atomic + race-safe link via PID-scoped staging paths (see link_ll).
  local tmp_obj="${out}.o.tmp.$$"
  "$LLC" -O0 $LLC_RELOC -filetype=obj "$ll" -o "$tmp_obj" \
    || { rm -f "$tmp_obj"; die "llc -O0 failed for $ll"; }
  local tmp_out="${out}.tmp.$$"
  cc -g -o "$tmp_out" "$tmp_obj" "$RUNTIME_O" "$LLVM_WRAPPER_O" \
    $STACK_LDFLAGS \
    $EXPORT_DYNAMIC $LD_SELECT -L"$LLVM_PREFIX/lib" -lLLVM $CXXLIB 2>"$logfile" \
    || { rm -f "$tmp_out" "$tmp_obj"; cat "$logfile" >&2; die "link failed for $out"; }
  mv "$tmp_obj" "${out}.o"
  mv "$tmp_out" "$out"
}

# Build bs2 at -O0 for debuggability (lldb + breakpoints).
ensure_bs2_O0() {
  ensure_seed
  if source_newer_than "$BS2_O0" \
     || [ "$SEED_LL" -nt "$BS2_O0" ]; then
    log "compiling packages/cli/src/main.av with seed compiler (for -O0 build)"
    local pre_srcfp; pre_srcfp=$(compiler_sources_fp)
    if ! "$SEED_BIN" compile "$SRC_DIR/main.av" >"$BUILD_DIR/bs2_O0.codegen.log" 2>&1; then
      cat "$BUILD_DIR/bs2_O0.codegen.log" >&2
      die "bs2_O0 codegen failed"
    fi
    log "linking $BS2_O0 at -O0"
    link_ll_O0 "$SRC_DIR/main.av.ll" "$BS2_O0" "$BUILD_DIR/bs2_O0.link.log"
    stamp_compiler_sources_value "$BS2_O0" "$pre_srcfp"
    ok "built $BS2_O0 (lldb-friendly, -O0)"
  fi
}

ensure_bs2_debug() {
  ensure_seed
  if source_newer_than "$BS2_DEBUG" \
     || [ "$SEED_LL" -nt "$BS2_DEBUG" ]; then
    log "compiling packages/cli/src/main.av with seed compiler (--debug-null)"
    local pre_srcfp; pre_srcfp=$(compiler_sources_fp)
    if ! "$SEED_BIN" compile --debug-null "$SRC_DIR/main.av" >"$BUILD_DIR/bs2_debug.codegen.log" 2>&1; then
      cat "$BUILD_DIR/bs2_debug.codegen.log" >&2
      die "bs2_debug codegen failed"
    fi
    log "linking $BS2_DEBUG at -O0"
    link_ll_O0 "$SRC_DIR/main.av.ll" "$BS2_DEBUG" "$BUILD_DIR/bs2_debug.link.log"
    stamp_compiler_sources_value "$BS2_DEBUG" "$pre_srcfp"
    ok "built $BS2_DEBUG (null checks enabled, -O0)"
  fi
}

ensure_bs2_asan() {
  ensure_seed
  ensure_runtime_asan
  if [ ! -x "$BS2_ASAN" ] || [ "$BS2" -nt "$BS2_ASAN" ]; then
    log "compiling packages/cli/src/main.av with seed (for ASan)"
    "$SEED_BIN" compile "$SRC_DIR/main.av" >"$BUILD_DIR/bs2_asan.codegen.log" 2>&1 \
      || { cat "$BUILD_DIR/bs2_asan.codegen.log" >&2; die "bs2_asan codegen failed"; }
    log "linking $BS2_ASAN with -fsanitize=address"
    cc -fsanitize=address -g -o "$BS2_ASAN" \
       "$SRC_DIR/main.av.ll" "$RUNTIME_ASAN_O" "$LLVM_WRAPPER_O" \
       $EXPORT_DYNAMIC $LD_SELECT -L"$LLVM_PREFIX/lib" -lLLVM $CXXLIB 2>"$BUILD_DIR/bs2_asan.link.log" \
      || { cat "$BUILD_DIR/bs2_asan.link.log" >&2; die "bs2_asan link failed"; }
    ok "built $BS2_ASAN"
  fi
}

ensure_bs3() {
  ensure_bs2
  # Skip the 90-second bs3 rebuild when bs3 is already newer than
  # both bs2 (which compiled it) and the cli/main.av source. Same
  # mtime-based freshness rule make uses internally.
  if [ -f "$BS3" ] && [ "$BS3" -nt "$BS2" ] && [ "$BS3" -nt "$SRC_DIR/main.av" ]; then
    return
  fi
  log "compiling packages/cli/src/main.av with bs2 → $BS3"
  if ! "$BS2" compile "$SRC_DIR/main.av" >"$BUILD_DIR/bs3.codegen.log" 2>&1; then
    cat "$BUILD_DIR/bs3.codegen.log" >&2
    die "bs3 codegen failed (bs2 cannot self-compile)"
  fi
  link_ll "$SRC_DIR/main.av.ll" "$BS3" "$BUILD_DIR/bs3.link.log"
  ok "built $BS3"
}

# ─────────────────────────────────────────────────────────────────────
# Modes
# ─────────────────────────────────────────────────────────────────────

mode_build() {
  ensure_bs2
}

mode_build_runtime() { ensure_runtime; ok "$RUNTIME_O"; }
# Fast inner-loop build: rebuild bs2 if source changed, but SKIP the
# self-compile verify (that step is bootstrap-chain integrity, not
# correctness). Use this when iterating on changes you want to test
# against a fresh bs2 but don't need the bootstrap-fixed-point check
# on every save. Run --build-bs2 (or `make build`) before committing.
mode_ensure_bs2() {
  ensure_bs2
  ok "$BS2"
}
mode_build_bs2() {
  ensure_bs2
  # Verify bs2 can compile itself (bootstrap chain integrity).
  log "verifying bs2 can self-compile (bootstrap safety check)"
  # rcsf.2: run the RC zero-init verifier during the integrity check so
  # every commit-grade build machine-checks the zm77 guard on the
  # compiler's own module (a violation fails the build with a named
  # fn+slot diagnostic instead of shipping layout-sensitive UB).
  if AVRA_VERIFY_RC=1 "$BS2" compile "$SRC_DIR/main.av" >"$BUILD_DIR/bs2_selfcheck.log" 2>&1; then
    ok "$BS2"
    return
  fi

  # Self-compile failed. Before giving up, try an AUTO-CYCLE:
  # The seed may be stale (missing new functions/types). We can
  # fix this automatically by updating the seed from bs2's output
  # (which the seed DID compile successfully) and rebuilding.
  if [ "${NO_AUTOCYCLE:-0}" = "1" ]; then
    die "bs2 self-compile failed (auto-cycle disabled by NO_AUTOCYCLE=1)"
  fi
  warn "bs2 self-compile failed — attempting auto-cycle to update seed"
  warn "(the seed may be stale — this is normal when adding new code)"

  # bs2 was compiled by the seed successfully (ensure_bs2 passed).
  # Its IR is the best candidate for a new seed.
  local bs2_ll="$SRC_DIR/main.av.ll"
  if [ ! -f "$bs2_ll" ]; then
    err "no IR file found at $bs2_ll — cannot auto-cycle"
    head -30 "$BUILD_DIR/bs2_selfcheck.log" >&2
    die "manual seed update required"
  fi

  # Save the current seed as backup
  cp "$SEED_LL" "$BUILD_DIR/seed_backup.ll"
  log "backed up seed to $BUILD_DIR/seed_backup.ll"

  # Update seed with bs2's IR
  cp "$bs2_ll" "$SEED_LL"
  rm -f "$SEED_BIN" "$BUILD_DIR/seed.o"
  log "seed updated from bs2 output — rebuilding from new seed"

  # Rebuild everything from the new seed
  rm -f "$BS2" "$BS3"
  ensure_seed
  ensure_bs2

  # Try self-compile again
  log "retrying self-compile with updated seed"
  if "$BS2" compile "$SRC_DIR/main.av" >"$BUILD_DIR/bs2_selfcheck.log" 2>&1; then
    ok "auto-cycle succeeded — bs2 self-compiles after seed update"
    ok "$BS2"

    # Verify fixed point: bs2 and bs3 should agree
    log "verifying fixed point after auto-cycle"
    local bs2_ir="$BUILD_DIR/fp_autocycle_bs2.ll"
    cp "$SRC_DIR/main.av.ll" "$bs2_ir"
    if "$BS2" compile "$SRC_DIR/main.av" >/dev/null 2>&1; then
      if diff -q "$bs2_ir" "$SRC_DIR/main.av.ll" >/dev/null 2>&1; then
        ok "fixed point holds after auto-cycle"
      else
        warn "fixed point does NOT hold after auto-cycle — run 'make update-seed' to stabilize"
      fi
    fi
    return
  fi

  # Auto-cycle didn't help. Before giving up, check if it's an LLVM
  # -O2 miscompilation: rebuild bs2 at -O0 and test self-compile.
  warn "auto-cycle failed — checking for LLVM -O2 miscompilation"
  "$LLC" -O0 $LLC_RELOC -filetype=obj "$SRC_DIR/main.av.ll" -o "$BUILD_DIR/bs2_o0.o" 2>/dev/null
  if cc -o "$BUILD_DIR/bs2_o0" "$BUILD_DIR/bs2_o0.o" "$RUNTIME_O" "$LLVM_WRAPPER_O" \
       $STACK_LDFLAGS \
       $EXPORT_DYNAMIC $LD_SELECT -L"$LLVM_PREFIX/lib" -lLLVM $CXXLIB 2>/dev/null; then
    if "$BUILD_DIR/bs2_o0" compile "$SRC_DIR/main.av" >/dev/null 2>&1; then
      err ""
      err "LLVM OPTIMIZATION BUG DETECTED"
      err "bs2 works at -O0 but crashes at -O2."
      err "This is an llc -O2 miscompilation on $(uname -m), not a Avra bug."
      err ""
      err "Fix: run 'make update-seed' to regenerate the seed IR."
      err "The new IR pattern typically avoids the LLVM bug."
      # Restore backup and continue with -O0 bs2
      cp "$BUILD_DIR/seed_backup.ll" "$SEED_LL"
      rm -f "$SEED_BIN" "$BUILD_DIR/seed.o"
      die "rebuild with: make update-seed"
    fi
  fi

  # Not an -O2 issue. Restore backup and show diagnostics.
  err "auto-cycle FAILED — self-compile broken at all optimization levels"
  cp "$BUILD_DIR/seed_backup.ll" "$SEED_LL"
  rm -f "$SEED_BIN" "$BUILD_DIR/seed.o"
  err ""
  err "Self-compile error log:"
  head -30 "$BUILD_DIR/bs2_selfcheck.log" >&2
  err ""

  # Diagnose: diff the seed vs bs2 IR to show which functions diverge
  mode_diagnose_selfcompile_failure

  die "bootstrap chain is broken — see diagnostics above"
}

# When self-compile fails, show which functions in the seed vs bs2 IR
# are different. This pinpoints the codegen bug immediately instead of
# requiring manual investigation.
mode_diagnose_selfcompile_failure() {
  local seed_ir="$SEED_LL"
  local bs2_ir="$SRC_DIR/main.av.ll"
  [ -f "$bs2_ir" ] || return

  # Extract function names from both
  local seed_fns bs2_fns
  seed_fns=$(grep '^define ' "$seed_ir" | sed 's/define [^ ]* @//' | sed 's/(.*//' | sort)
  bs2_fns=$(grep '^define ' "$bs2_ir" | sed 's/define [^ ]* @//' | sed 's/(.*//' | sort)

  # Functions in bs2 but not in seed (newly added)
  local new_fns
  new_fns=$(comm -13 <(echo "$seed_fns") <(echo "$bs2_fns"))
  if [ -n "$new_fns" ]; then
    local count
    count=$(echo "$new_fns" | wc -l | tr -d ' ')
    warn "$count functions in bs2 that are NOT in the seed:"
    echo "$new_fns" | head -20 | while read -r fn; do
      printf "  ${C_YELLOW}+ %s${C_RESET}\n" "$fn" >&2
    done
    if [ "$count" -gt 20 ]; then
      warn "  ... and $((count - 20)) more"
    fi
    warn ""
    warn "These functions were compiled by the OLD seed which didn't"
    warn "have them. The seed needs updating. Run: make update-seed"
  fi

  # Functions that exist in both but have different IR
  local common_fns diverged=0
  common_fns=$(comm -12 <(echo "$seed_fns") <(echo "$bs2_fns"))
  for fn in $common_fns; do
    local seed_body bs2_body
    seed_body=$(sed -n "/^define.*@${fn}(/,/^}/p" "$seed_ir" 2>/dev/null | wc -l | tr -d ' ')
    bs2_body=$(sed -n "/^define.*@${fn}(/,/^}/p" "$bs2_ir" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$seed_body" != "$bs2_body" ]; then
      if [ "$diverged" -eq 0 ]; then
        warn "Functions with different IR between seed and bs2:"
      fi
      printf "  ${C_RED}~ %s${C_RESET} (seed: %s lines, bs2: %s lines)\n" "$fn" "$seed_body" "$bs2_body" >&2
      diverged=$((diverged + 1))
      if [ "$diverged" -ge 15 ]; then
        warn "  ... stopping at 15 divergences"
        break
      fi
    fi
  done
}
mode_build_O0()       { ensure_bs2_O0;   ok "$BS2_O0"; }
mode_build_debug()    { ensure_bs2_debug; ok "$BS2_DEBUG"; }
mode_build_bs2_asan() { ensure_bs2_asan; ok "$BS2_ASAN"; }
mode_build_bs3()      { ensure_bs3;      ok "$BS3"; }

# Verify bootstrap reaches its self-host fixed point: bs2 and bs3 must
# emit byte-identical IR for the same input (packages/cli/src/main.av).
# If this fails, self-hosting is broken — the bug is somewhere between
# bs2 and bs3 (one generation diverged from the previous).
mode_check_fixedpoint() {
  ensure_bs2
  ensure_bs3
  # Skip the 3-minute verify when neither bs2/bs3 nor any compiler
  # source has changed since the last passing verify. Hashes both
  # binaries + every compiler-source .av file to a single fingerprint
  # and short-circuits when the prior cached value matches. First commit
  # pays the cost; subsequent commits with no compiler-side changes
  # skip it. Bypass with `AVRA_FORCE_FP=1` if you suspect drift.
  #
  # Source-tree hash (in addition to bs2/bs3 binary hashes) closes the
  # false-positive gap where per-module compile-cache hits left bs2
  # bit-identical despite source changes: any .av edit shifts fp_input,
  # forcing a real diff. Without this the codegen bug behind the bs3
  # crash this comment was added for could land via cache hit alone.
  local fp_marker="$BUILD_DIR/.fp_verified"
  local fp_input
  fp_input=$(
    { $SHA256_CMD "$BS2" "$BS3" 2>/dev/null
      find "$CLI_SRC_DIR" "$LIB_SRC_DIR" -name '*.av' -type f -exec $SHA256_CMD {} +
    } | awk '{print $1}' | sort | $SHA256_CMD | awk '{print $1}'
  )
  if [ "${AVRA_FORCE_FP:-0}" != "1" ] && [ -f "$fp_marker" ] \
     && [ "$(cat "$fp_marker" 2>/dev/null)" = "$fp_input" ]; then
    ok "fixed point cached — bs2 + bs3 + source unchanged since last verify"
    return 0
  fi
  log "compiling packages/cli/src/main.av with bs2"
  "$BS2" compile "$SRC_DIR/main.av" >/dev/null 2>&1 \
    || die "bs2 failed to compile bootstrap source"
  cp "$SRC_DIR/main.av.ll" "$BUILD_DIR/fp_bs2.ll"
  log "compiling packages/cli/src/main.av with bs3"
  "$BS3" compile "$SRC_DIR/main.av" >/dev/null 2>&1 \
    || die "bs3 failed to compile bootstrap source"
  cp "$SRC_DIR/main.av.ll" "$BUILD_DIR/fp_bs3.ll"
  if diff -q "$BUILD_DIR/fp_bs2.ll" "$BUILD_DIR/fp_bs3.ll" >/dev/null; then
    local lines; lines=$(wc -l <"$BUILD_DIR/fp_bs2.ll" | tr -d ' ')
    ok "fixed point holds — bs2 and bs3 emit byte-identical $lines-line IR"
    echo "$fp_input" > "$fp_marker"
  else
    # Strict callers (the seed train sets NO_AUTOCYCLE=1) must NOT have
    # divergence papered over by an auto-cycle: a heal-then-pass here
    # would publish a seed the pinned compiler couldn't reproduce. Fail
    # loud and let a human look.
    if [ "${NO_AUTOCYCLE:-0}" = "1" ]; then
      err "FIXED POINT BROKEN — auto-cycle disabled (NO_AUTOCYCLE=1)"
      err "  bs2 IR: $BUILD_DIR/fp_bs2.ll"
      err "  bs3 IR: $BUILD_DIR/fp_bs3.ll"
      return 1
    fi
    # Auto-converge: cycle the seed up to 3 times to reach equilibrium.
    # This handles cases where adding new functions shifts allocator state.
    local max_cycles=3
    for cycle in $(seq 1 $max_cycles); do
      log "fixed point diverged — auto-cycling seed (attempt $cycle/$max_cycles)"
      cp "$BUILD_DIR/fp_bs2.ll" "$BOOTSTRAP_DIR/seed/seed.ll"
      # Rebuild bs2 from new seed
      ensure_seed force
      ensure_bs2 force
      ensure_bs3
      # Re-check
      "$BS2" compile "$SRC_DIR/main.av" >/dev/null 2>&1 \
        || die "bs2 failed during auto-cycle $cycle"
      cp "$SRC_DIR/main.av.ll" "$BUILD_DIR/fp_bs2.ll"
      "$BS3" compile "$SRC_DIR/main.av" >/dev/null 2>&1 \
        || die "bs3 failed during auto-cycle $cycle"
      cp "$SRC_DIR/main.av.ll" "$BUILD_DIR/fp_bs3.ll"
      if diff -q "$BUILD_DIR/fp_bs2.ll" "$BUILD_DIR/fp_bs3.ll" >/dev/null; then
        # Converged! Update the seed to the stable version.
        cp "$BUILD_DIR/fp_bs2.ll" "$BOOTSTRAP_DIR/seed/seed.ll"
        local lines; lines=$(wc -l <"$BUILD_DIR/fp_bs2.ll" | tr -d ' ')
        ok "fixed point holds — bs2 and bs3 emit byte-identical $lines-line IR (after $cycle auto-cycle(s))"
        # Recompute fingerprint after cycle (bs2 was rebuilt) and cache.
        # Mirror the upstream input shape — binaries + every .av — so
        # the next run's compare matches.
        local fp_post
        fp_post=$(
          { $SHA256_CMD "$BS2" "$BS3" 2>/dev/null
            find "$CLI_SRC_DIR" "$LIB_SRC_DIR" -name '*.av' -type f -exec $SHA256_CMD {} +
          } | awk '{print $1}' | sort | $SHA256_CMD | awk '{print $1}'
        )
        echo "$fp_post" > "$fp_marker"
        return 0
      fi
    done
    err "FIXED POINT BROKEN — failed to converge after $max_cycles auto-cycles"
    err "diff: $(diff "$BUILD_DIR/fp_bs2.ll" "$BUILD_DIR/fp_bs3.ll" | wc -l | tr -d ' ') lines"
    err "  bs2 IR: $BUILD_DIR/fp_bs2.ll"
    err "  bs3 IR: $BUILD_DIR/fp_bs3.ll"
    return 1
  fi
}

# ── Fixture-compile throttle ──
#
# A bs2 compile peaks 1-2GB RSS. The per_file test suite fans out
# shard binaries × AVRA_TEST_JOBS threads, and any unit can shell out
# a fixture compile — uncapped, the burst OOM-killed bs2 mid-suite
# (Linux 16GB/4-core; same class as the documented macOS jetsam
# mass-kill). Bound the SHELL-SPAWNED compiles with a cross-process
# counting semaphore: N slot directories under build/, mkdir as the
# atomic test-and-set (portable — macOS ships no flock(1)), a pid
# file per slot so crashed holders get reaped instead of leaking the
# slot forever.
COMPILE_SLOT_DIR=""

# Stable slot count for acquire_compile_slot's pool. Sized from MemTotal
# (NOT MemAvailable): a live-avail read shrinks to 1 mid-suite as memory
# fills, re-serialising the fixture-run phase — the exact regression this
# unblocks (uzs9.7). Fixtures come in two weight classes since #880 moved
# the bulk onto the ~1.8GB metadata fast-path; the no-metadata WHOLE-PROGRAM
# fixtures (build/cache probes, the test-runner self-test) are still ~5.5GB
# (measured). The pool size bounds concurrent LIGHT (fast-path) compiles —
# heavy compiles run EXCLUSIVELY (see acquire_compile_slot), grabbing the
# whole pool, so a ~5.5GB compile never stacks on a full light batch. ~1
# slot per 3GB past a 4GB base, capped at the core count (a fixture compile
# is CPU-bound too). Measured safe at 4 on a 16GB/4-core box (min-avail
# 4.1GB alongside the shards). Non-Linux / read failure keeps the historic
# default of 2. AVRA_FIXTURE_JOBS overrides this explicitly.
_default_compile_slots() {
  # t-kdyj.1 slice 3 — one budget authority: inside an admitted shard the
  # pool exported the TREE's allocation (AVRA_MEM_BUDGET_MB). Size the
  # fixture pool from IT, not from MemTotal, so a shard's grandchildren
  # divide the shard's admitted budget instead of each assuming they own
  # the machine (the mechanism behind both recorded container deaths:
  # N admitted trees x box-sized fixture pools).
  case "${AVRA_MEM_BUDGET_MB:-}" in
    ''|*[!0-9]*) : ;;
    *)
      if [ "$AVRA_MEM_BUDGET_MB" -gt 0 ]; then
        local bn bcores
        # 10#: the digit-only guard above admits leading zeros ("08000"),
        # which bare arithmetic would reject as bad octal.
        bn=$(( 10#${AVRA_MEM_BUDGET_MB} / 2900 ))
        bcores=$(nproc 2>/dev/null || echo 2)
        [ "$bn" -gt "$bcores" ] && bn=$bcores
        [ "$bn" -lt 1 ] && bn=1
        echo "$bn"
        return
      fi ;;
  esac
  local total
  total=$(awk '/^MemTotal:/ {print int($2/1024); exit}' /proc/meminfo 2>/dev/null)
  case "$total" in ''|*[!0-9]*) echo 2; return;; esac
  [ "$total" -le 0 ] && { echo 2; return; }
  local cores n
  cores=$(nproc 2>/dev/null || echo 2)
  n=$(( (total - 4096) / 2900 ))
  [ "$n" -gt "$cores" ] && n=$cores
  [ "$n" -lt 1 ] && n=1
  echo "$n"
}

# Cross-process fixture-compile gate with two weight classes. A LIGHT
# compile (AVRA_USE_METADATA set — the ~1.8GB metadata fast-path) holds ONE
# of N slots, so up to N run concurrently. A HEAVY compile (AVRA_USE_METADATA
# stripped — a ~5.5GB no-metadata WHOLE-PROGRAM compile) is EXCLUSIVE: it
# grabs the WHOLE pool and runs alone, so it never stacks on a full light
# batch over the OOM cliff. Writer-preference: while a live heavy is pending
# it re-asserts a `heavy_pending` flag each attempt, and new light
# acquisitions yield to it, so a heavy can't be starved by a stream of
# lights. AVRA_SLOT_DIR overrides the namespace (spec tests use a private
# pool). Dead owners (slots and the pending flag) are reaped.
acquire_compile_slot() {
  local base="${AVRA_SLOT_DIR:-$BUILD_DIR/compile_slots}"
  local n="${AVRA_FIXTURE_JOBS:-$(_default_compile_slots)}"
  local pend="$base/heavy_pending"
  local heavy=0
  [ -z "${AVRA_USE_METADATA:-}" ] && heavy=1
  mkdir -p "$base"
  COMPILE_SLOT_DIR=""
  local i dir owner got k held now born
  if [ "$heavy" -eq 1 ]; then
    while :; do
      echo $$ > "$pend"                 # (re)assert each attempt: lights yield
      got=""; k=0
      for i in $(seq 0 $((n - 1))); do
        dir="$base/slot.$i"
        if mkdir "$dir" 2>/dev/null; then
          echo $$ > "$dir/pid"; got="$got $dir"; k=$((k + 1))
        else
          owner=$(cat "$dir/pid" 2>/dev/null)
          if [ -n "$owner" ]; then
            ! kill -0 "$owner" 2>/dev/null && rm -rf "$dir" 2>/dev/null
          else
            # Empty/missing pid is legitimate only in the microsecond
            # mkdir->echo window. A slot ABANDONED there (its taker killed
            # between the two) is invisible to the owner-liveness reap and
            # WEDGES the whole pool: the heavy waits forever for all slots
            # while holding heavy_pending, and every light acquirer yields
            # to that live heavy at `sleep 0.2` — the t-kdyj.12 incident
            # (a timeout-killed regen left slot.2 pid-less; a full suite
            # run sat behind it for 20+ minutes). Reap once the dir is
            # provably older than the window.
            now=$(date +%s); born=$(stat -c %Y "$dir" 2>/dev/null || stat -f %m "$dir" 2>/dev/null || echo "$now")
            [ $((now - born)) -ge 5 ] && rm -rf "$dir" 2>/dev/null
          fi
        fi
      done
      if [ "$k" -eq "$n" ]; then
        # Hold the whole pool: no light can grab (all slots taken), so the
        # advisory flag is no longer needed and its removal can't let a
        # light in. On release every slot is freed.
        COMPILE_SLOT_DIR="$got"; rm -f "$pend" 2>/dev/null; return 0
      fi
      for held in $got; do rm -rf "$held" 2>/dev/null; done   # release partial
      sleep "0.$(( (RANDOM % 4) + 2 ))"                       # jitter → no livelock
    done
  else
    while :; do
      # Yield to a LIVE pending heavy (reap a stale flag whose owner died).
      if [ -f "$pend" ]; then
        owner=$(cat "$pend" 2>/dev/null)
        if [ -n "$owner" ] && kill -0 "$owner" 2>/dev/null; then sleep 0.2; continue; fi
        rm -f "$pend" 2>/dev/null
      fi
      for i in $(seq 0 $((n - 1))); do
        dir="$base/slot.$i"
        if mkdir "$dir" 2>/dev/null; then echo $$ > "$dir/pid"; COMPILE_SLOT_DIR="$dir"; return 0; fi
        owner=$(cat "$dir/pid" 2>/dev/null)
        if [ -n "$owner" ]; then
          ! kill -0 "$owner" 2>/dev/null && rm -rf "$dir" 2>/dev/null
        else
          # Same empty-pid reap as the heavy loop above (t-kdyj.12).
          now=$(date +%s); born=$(stat -c %Y "$dir" 2>/dev/null || stat -f %m "$dir" 2>/dev/null || echo "$now")
          [ $((now - born)) -ge 5 ] && rm -rf "$dir" 2>/dev/null
        fi
      done
      sleep 0.2
    done
  fi
}

release_compile_slot() {
  local d
  for d in $COMPILE_SLOT_DIR; do rm -rf "$d" 2>/dev/null; done
  COMPILE_SLOT_DIR=""
}

# Run an arbitrary command while holding a compile slot. The shell-out
# surface for callers that can't share this script's functions (the
# test runner's cached-fixture commands). The EXIT trap releases on
# every path, including die/kill.
mode_slot_exec() {
  [ $# -ge 1 ] || die "--slot-exec needs a command to run"
  acquire_compile_slot
  trap release_compile_slot EXIT
  "$@"
}

# Contention fuzz for the acquire/release gate (uzs9.7). Spawns mixed
# LIGHT + HEAVY workers that acquire, observe the live holder set, hold
# briefly, then release — asserting the invariants the exclusion design
# guarantees: (1) never a HEAVY holding alongside any LIGHT, (2) never a
# second HEAVY, (3) never more than N LIGHTs. A deadlock/livelock instead
# manifests as the per-round `wait` never returning → the caller's timeout
# fires. `--slot-fuzz [rounds] [jobs] [N]` (default 30 x 8, N=4).
mode_slot_fuzz() {
  local rounds="${1:-30}" jobs="${2:-8}" nslots="${3:-4}"
  local root="$BUILD_DIR/slot_fuzz" pool="$BUILD_DIR/slot_fuzz/pool"
  local obs="$BUILD_DIR/slot_fuzz/obs" viol="$BUILD_DIR/slot_fuzz/viol"
  rm -rf "$root"; mkdir -p "$pool" "$obs"; : > "$viol"
  local r j
  for r in $(seq 1 "$rounds"); do
    for j in $(seq 1 "$jobs"); do
      (
        local mode
        if [ $((RANDOM % 4)) -eq 0 ]; then unset AVRA_USE_METADATA; mode=heavy
        else export AVRA_USE_METADATA=1; mode=light; fi
        AVRA_SLOT_DIR="$pool" AVRA_FIXTURE_JOBS="$nslots" acquire_compile_slot
        # $BASHPID (this subshell's own pid), NOT $$ — $$ is the parent shell's
        # pid, identical across every background worker, so all lights would
        # write ONE obs/light.<pid> token and the nl/nh cap checks (>N lights,
        # >1 heavy) could never observe more than one holder per mode.
        local tok="$obs/$mode.$BASHPID"; : > "$tok"
        local nl nh
        nl=$(find "$obs" -name 'light.*' 2>/dev/null | wc -l)
        nh=$(find "$obs" -name 'heavy.*' 2>/dev/null | wc -l)
        [ "$mode" = heavy ] && [ "$nl" -gt 0 ] && echo "heavy holding with $nl light(s)" >> "$viol"
        [ "$mode" = light ] && [ "$nh" -gt 0 ] && echo "light holding with $nh heavy" >> "$viol"
        [ "$nl" -gt "$nslots" ] && echo "$nl lights > cap $nslots" >> "$viol"
        [ "$nh" -gt 1 ] && echo "$nh heavies concurrently" >> "$viol"
        sleep "0.$(( (RANDOM % 3) + 1 ))"
        rm -f "$tok"
        AVRA_SLOT_DIR="$pool" release_compile_slot
      ) &
    done
    wait
  done
  local nv; nv=$(wc -l < "$viol" 2>/dev/null | tr -d ' ')
  if [ "${nv:-0}" -eq 0 ]; then
    ok "slot-fuzz: ${rounds}x${jobs} workers (N=${nslots}) — 0 invariant violations, no hang"
    return 0
  fi
  err "slot-fuzz: ${nv} invariant violation(s):"; head -5 "$viol"; return 1
}

# Compile + link + run a .av with bs2 (or stage1).
run_fg() {
  local fg="$1"
  [ -f "$fg" ] || die "no such file: $fg"
  ensure_bs2
  local ll bin
  ll="$fg.ll"
  bin="${fg%.av}.bin"
  # Skip recompile when the fixture's bin is up-to-date relative to
  # both its source and the bs2 compiler — every test run was
  # otherwise re-spending ~90s per fixture (forge-crafting-intepreters-kkgf).
  # `make test` aggregates 6+ fixtures, so the cache savings is on the
  # order of minutes per `make test`. The freshness check is the same
  # rule make would apply: bin must exist and be newer than every
  # input it depends on.
  if [ -f "$bin" ] && [ "$bin" -nt "$fg" ] && [ "$bin" -nt "$BS2" ]; then
    "$bin"
    return
  fi
  # jdgo: PID-scope the per-shard logs. Concurrent shards under
  # continuous dispatch share BUILD_DIR; a non-PID-scoped log means
  # shard A's bs2-compile output overwrites shard B's, so when B's
  # compile fails and reads the log it surfaces A's content (or
  # nothing) — contaminating the cached fixture stdout with the
  # wrong error message. The $$ suffix isolates per-shard.
  local run_log="$BUILD_DIR/last_run.log.$$"
  local link_log="$BUILD_DIR/last_link.log.$$"
  # Slot-bounded: this is the per-unit fixture-compile path the test
  # suite fans out — the OOM source on 4-core/16GB machines.
  acquire_compile_slot
  trap release_compile_slot EXIT
  if ! "$BS2" compile "$fg" >"$run_log" 2>&1; then
    cat "$run_log" >&2
    rm -f "$run_log"
    die "bs2 codegen failed"
  fi
  release_compile_slot
  link_ll "$ll" "$bin" "$link_log"
  rm -f "$run_log" "$link_log"
  "$bin"
}

mode_run() { run_fg "$1"; }

# ps3t.6.5.11 — the airtight behavioural gate for the grammar-DSL emitter:
# emit.av RENDERS the generated static parser, and this proves that rendered
# source actually COMPILES and PARSES byte-equivalent to the hand parser (the
# ticket's "generated fns compile + pass the differential test"). Too heavy for
# every `bs2 test` (a full nested compile+run of an @std-importing module), so
# it lives here as an on-demand gate; the in-suite regression guard is the fast
# structural emit_generated_test.av.
#
# On a <=16GB box run_fg's whole-program fixture compile is Killed (~13.6GB;
# control-proven pre-existing) — but the gate IS locally runnable through the
# metadata fast path once the test runner's producer objects are warm:
#   AVRA_USE_METADATA=1 AVRA_LIB_OBJS="<colon-joined packages/*/build/cache/
#     <fp-from-last/<pkg>.txt>/unit.realobj.o for std-avrac, std-process,
#     std-crypto, std-json, std-lsp, std-test>" \
#     bash scripts/diagnose.sh --run build/emit_gen/generated_parser.av
# and assert GENPASS on stdout. The differential verdict is identical (only
# how @std symbols resolve differs — inline vs producer object; both are
# production paths). The gate itself stays whole-program so CI needs no
# warm cache.
#
# Flow: a DRIVER program (below) parses the canonical §2 expression grammar,
# runs emit.av over it, and writes <imports> + <emitted parse fns> + the
# differential harness + a GENPASS/GENFAIL main to a generated module. We then
# compile+run that generated module and assert GENPASS.
# t-47hc.8 — regenerate the CHECKED-IN production static parser
# (packages/std-avrac/src/parse/gen_parser.av) from THE grammar (the Language
# pipeline's full()). ONE grammar → one generated file: every parse family's
# rules, emitted once; the per-family entries (parse_declaration /
# parse_statement / parse_expression / parse_type_expr / parse_pattern_or) are
# just exported fns in the module. Run this after editing ANY grammar
# (avra_grammar.av or a feature's gram); the guard test
# parse/tests/gen_parser_regen_test.av fails until the file is regenerated
# and committed. Single source of truth: emit_parser_file (gen_parser_files.av).
mode_emit_regen_parsers() {
  cd "$BOOTSTRAP_DIR" || die "cannot cd to $BOOTSTRAP_DIR"
  local dir="$BUILD_DIR/emit_gen"
  mkdir -p "$dir"
  local driver="$dir/regen_parser_driver.av"
  cat > "$driver" <<'AVEOF'
// GENERATED by diagnose.sh --emit-regen-parsers (t-47hc.8). Writes the ONE
// production static parser (every family) from emit_parser_file().
use @std.avrac.features.grammar.{emit_parser_file}
use @std.avrac.core.{avra_selfhost_write_file}

fn main() {
    let src = emit_parser_file()
    let _ = avra_selfhost_write_file("packages/std-avrac/src/parse/gen_parser.av", src)
    println("wrote parse/gen_parser.av (${string(src.length)} bytes)")
}
AVEOF
  log "emit-regen-parsers: rendering the production static parser (every family) via emit.av"
  run_fg "$driver" || die "emit-regen-parsers: driver (emit_parser_file render) failed"
  [ -f "packages/std-avrac/src/parse/gen_parser.av" ] || die "emit-regen-parsers: driver did not write gen_parser.av"
  ok "emit-regen-parsers: parse/gen_parser.av regenerated from THE grammar"
}

# t-47hc.2 (Phase 1) — regenerate the CHECKED-IN operator/punctuation scanner
# (packages/std-avrac/src/parse/gen_operator_scanner.av) from operator_rules().
# Run this after editing the operator table (token_table.av); the guard test
# parse/tests/gen_operator_scanner_regen_test.av fails until the file is
# regenerated and committed. Single source of truth: gen_operator_scanner_file
# (emit_lex.av). Sibling of --emit-regen-expr / --emit-regen-decl, for the LEXER.
mode_emit_regen_lex() {
  cd "$BOOTSTRAP_DIR" || die "cannot cd to $BOOTSTRAP_DIR"
  local dir="$BUILD_DIR/emit_gen"
  mkdir -p "$dir"
  local driver="$dir/regen_lex_driver.av"
  cat > "$driver" <<'AVEOF'
// GENERATED by diagnose.sh --emit-regen-lex (t-47hc.2 Phase 1). Writes the
// operator/punctuation maximal-munch scanner from gen_operator_scanner_file().
use @std.avrac.parse.{gen_operator_scanner_file}
use @std.avrac.core.{avra_selfhost_write_file}

fn main() {
    let src = gen_operator_scanner_file()
    let _ = avra_selfhost_write_file("packages/std-avrac/src/parse/gen_operator_scanner.av", src)
    println("wrote parse/gen_operator_scanner.av (${string(src.length)} bytes)")
}
AVEOF
  log "emit-regen-lex: rendering the operator/punctuation scanner via emit_lex.av"
  run_fg "$driver" || die "emit-regen-lex: driver (gen_operator_scanner_file render) failed"
  [ -f "packages/std-avrac/src/parse/gen_operator_scanner.av" ] || die "emit-regen-lex: driver did not write gen_operator_scanner.av"
  ok "emit-regen-lex: parse/gen_operator_scanner.av regenerated from operator_rules()"
}

# t-47hc.2 (Phase 1) — regenerate the CHECKED-IN exact-match keyword recogniser
# (packages/std-avrac/src/parse/gen_keyword_scanner.av) from keyword_rules(). Run
# after editing the keyword table (token_table.av); the guard test
# parse/tests/gen_keyword_scanner_regen_test.av fails until regenerated + committed.
# Single source of truth: gen_keyword_scanner_file (emit_lex.av). Sibling of --emit-regen-lex.
mode_emit_regen_kw() {
  cd "$BOOTSTRAP_DIR" || die "cannot cd to $BOOTSTRAP_DIR"
  local dir="$BUILD_DIR/emit_gen"
  mkdir -p "$dir"
  local driver="$dir/regen_kw_driver.av"
  cat > "$driver" <<'AVEOF'
// GENERATED by diagnose.sh --emit-regen-kw (t-47hc.2 Phase 1). Writes the
// exact-match keyword recogniser from gen_keyword_scanner_file().
use @std.avrac.parse.{gen_keyword_scanner_file}
use @std.avrac.core.{avra_selfhost_write_file}

fn main() {
    let src = gen_keyword_scanner_file()
    let _ = avra_selfhost_write_file("packages/std-avrac/src/parse/gen_keyword_scanner.av", src)
    println("wrote parse/gen_keyword_scanner.av (${string(src.length)} bytes)")
}
AVEOF
  log "emit-regen-kw: rendering the keyword recogniser via emit_lex.av"
  run_fg "$driver" || die "emit-regen-kw: driver (gen_keyword_scanner_file render) failed"
  [ -f "packages/std-avrac/src/parse/gen_keyword_scanner.av" ] || die "emit-regen-kw: driver did not write gen_keyword_scanner.av"
  ok "emit-regen-kw: parse/gen_keyword_scanner.av regenerated from keyword_rules()"
}

# Regenerate the CHECKED-IN char-class run scanners (parse/gen_run_scanner.av) from
# char_run_rules(). Single source of truth: gen_run_scanner_file (emit_lex.av).
# Sibling of --emit-regen-lex / --emit-regen-kw.
mode_emit_regen_run() {
  cd "$BOOTSTRAP_DIR" || die "cannot cd to $BOOTSTRAP_DIR"
  local dir="$BUILD_DIR/emit_gen"
  mkdir -p "$dir"
  local driver="$dir/regen_run_driver.av"
  cat > "$driver" <<'AVEOF'
// GENERATED by diagnose.sh --emit-regen-run (t-47hc.2 Phase 1). Writes the
// char-class run scanners from gen_run_scanner_file().
use @std.avrac.parse.{gen_run_scanner_file}
use @std.avrac.core.{avra_selfhost_write_file}

fn main() {
    let src = gen_run_scanner_file()
    let _ = avra_selfhost_write_file("packages/std-avrac/src/parse/gen_run_scanner.av", src)
    println("wrote parse/gen_run_scanner.av (${string(src.length)} bytes)")
}
AVEOF
  log "emit-regen-run: rendering the char-class run scanners via emit_lex.av"
  # Drop any cached driver .bin so regeneration is ALWAYS fresh. The driver .av is
  # rewritten above (bumping its mtime, which already forces run_fg to recompile),
  # but emit_lex.av / token_table.av are NON-PRODUCTION (not in bs2's dep closure, so
  # editing them does not rebuild $BS2) — this makes "always fresh" independent of
  # run_fg's mtime cache, so a table edit can never silently commit a stale scanner.
  rm -f "${driver%.av}.bin"
  run_fg "$driver" || die "emit-regen-run: driver (gen_run_scanner_file render) failed"
  [ -f "packages/std-avrac/src/parse/gen_run_scanner.av" ] || die "emit-regen-run: driver did not write gen_run_scanner.av"
  ok "emit-regen-run: parse/gen_run_scanner.av regenerated from char_run_rules()"
}

# t-47hc.2 (Phase 1) — the LEXER PERF RAIL. callgrind the CURRENT build/bs2 compiling a
# token-dense synthetic source, reporting the total instruction count + the per-symbol
# lexer self-costs. Run it before/after a lexer slice and compare the numbers — the
# reusable version of the ad-hoc callgrind harness the operator slices used, so every
# future named-terminal slice tracks Ir as the scanner grows (rule 10: centralize, and
# the epic's "world-class perf, don't settle" directive). Dev-only: needs valgrind +
# python3; benches whatever is in build/bs2 (run `make build-quick` first). Optional
# arg = fn-pair count (default 400); more = more signal, longer callgrind.
mode_lexer_bench() {
  cd "$BOOTSTRAP_DIR" || die "cannot cd to $BOOTSTRAP_DIR"
  command -v valgrind >/dev/null 2>&1 || die "lexer-bench needs valgrind (dev-only perf tool; apt install valgrind)"
  command -v python3 >/dev/null 2>&1 || die "lexer-bench needs python3 (fixture generation)"
  [ -x "$BUILD_DIR/bs2" ] || die "lexer-bench: build/bs2 missing — run 'make build-quick' first (benches the current bs2)"
  local iters="${1:-400}"
  local dir="$BUILD_DIR/lexer_bench"
  mkdir -p "$dir"
  local src="$dir/tokens.av"
  # A token-dense standalone program: operators, keywords, int+hex numbers, strings
  # with escapes, line/block/doc comments, identifiers. All-int arithmetic + a
  # string-returning sibling so it typechecks with no @std and no unused-var warnings.
  # A per-run nonce (in a leading comment) forces a compile-cache MISS so callgrind
  # measures a FULL lex+compile every run, not a cache hit. A comment is skipped by
  # the lexer, so its Ir cost is a handful of instructions — negligible vs the total.
  local nonce="$$-${RANDOM}-${iters}"
  python3 - "$src" "$iters" "$nonce" <<'PY'
import sys
path, n, nonce = sys.argv[1], int(sys.argv[2]), sys.argv[3]
header = "// lexer-bench nonce %s (forces a cache miss)\n" % nonce
tmpl = '''/// doc comment for f{i}
fn f{i}(a: int, b: int) -> int {{
    mut x = a + b - 1 * 2 / 3 % 4
    x = x & 5 | 6 ^ 7 << 1 >> 1
    let big = 0xff + 100 + 42
    x = x + big
    if x == a && b != 0 || x < 10 {{ x = x + 1 }} else {{ x = x - 1 }}
    /* block comment */ x
}}
fn s{i}() -> string {{ "row {i}: \\t tab \\n newline \\\\ slash done" }}
'''
with open(path, "w") as f:
    f.write(header)
    for i in range(n):
        f.write(tmpl.format(i=i))
PY
  local lines
  lines=$(wc -l < "$src")
  log "lexer-bench: $iters fn-pairs / $lines lines, token-dense (ops · keywords · int+hex · strings · comments)"
  local cg="$dir/callgrind.out" vg="$dir/vg.log"
  valgrind --tool=callgrind --callgrind-out-file="$cg" --cache-sim=no \
    "$BUILD_DIR/bs2" compile "$src" --output "$dir/tokens.ll" 2>"$vg" >/dev/null \
    || die "lexer-bench: compile under callgrind failed (see $vg)"
  local total
  # Take only the number AFTER "refs:" (the `==pid==` prefix also has digits), drop commas.
  total=$(grep -m1 -E 'I +refs:' "$vg" | sed -E 's/.*refs:[[:space:]]*//; s/,//g')
  ok "lexer-bench: TOTAL I refs = ${total}   (compile of ${lines}-line token-dense source)"
  echo ""
  echo "  lexer self-costs (callgrind_annotate — compare across slices):"
  callgrind_annotate --threshold=100 "$cg" 2>/dev/null \
    | grep -iE 'char_at_len|avra_rc_alloc|scan_operator|advance_char|bytes_from_string|substring_len|scan_number_token|scan_string_token|scan_identifier_token|skip_whitespace' \
    | sed 's/^/    /' | head -20
  echo ""
  log "lexer-bench: artifacts in $dir — re-run after a lexer change and compare TOTAL + per-symbol"
}


mode_emit_gen_check() {
  cd "$BOOTSTRAP_DIR" || die "cannot cd to $BOOTSTRAP_DIR"
  local dir="$BUILD_DIR/emit_gen"
  mkdir -p "$dir"
  local driver="$dir/driver.av"
  local gen="$dir/generated_parser.av"
  cat > "$driver" <<'AVEOF'
// GENERATED by diagnose.sh --emit-gen-check (ps3t.6.5.11 / t-47hc.8). Runs
// emit.av over THE grammar — assemble_language().full(), the same composed,
// builder-stamped grammar the production parser is emitted from — ONCE, and
// writes ONE runnable module: the emitted parse fns + all five family
// differential harnesses (expression, statement, pattern, type,
// whole-program), each comparing the generated engine's tree to its oracle.
use @std.avrac.features.grammar.{Grammar, assemble_language, emit_parser_source, derived_import_lines_for}
use @std.avrac.core.{avra_selfhost_write_file}

// ONE fixed import block: the union of every family harness's needs. The
// PARSER's own import surface derives from its emitted source (assemble);
// overlap between the two is a tolerated re-import, never an error.
fn imports_block() -> string {
    "use @std.avrac.features.grammar.{Token, CapVal, PState, new_pstate, dump_expr, capval_to_stmt, capval_to_pat, capval_to_texpr, run_grammar_pat}\n" +
    "use @std.avrac.parse.{parser_new, parse_program_source}\n" +
    "use @std.avrac.features.match.{avra_pat_grammar}\n" +
    "use @std.avrac.core.{Expr, ExprId, Stmt, StmtId, Pattern, PatId, TypeExpr, ParamEntry, MatchArm, SelectArm, CompConfig, CompConfigPair, ChildrenSlot, FieldEntry, FieldInit, Variant, ValueType, Tk, NodeStore, render_stmt_id, render_stmt_ids, render_pat_id, render_type_id, type_expr_to_vtype, pattern_optional_present, pattern_optional_absent}\n\n"
}

fn harness_block() -> string {
    "fn gen_tree(src: string) -> string {\n" +
    "    let st = new_pstate(src)\n" +
    "    let root = capval_to_expr(st, parse_expression(st))\n" +
    "    dump_expr(st.store, root)\n" +
    "}\n\n" +
    "fn hand_tree(src: string) -> string {\n" +
    "    mut p = parser_new(src)\n" +
    "    // ORACLE PIN (t-47hc.8): the interpreter engine (expr_flip) — the expr\n" +
    "    // seam defaults to the checked-in generated parser, so the old probe\n" +
    "    // compared emitted against emitted. Same pin as the stmt/type oracles.\n" +
    "    p.expr_flip = true\n" +
    "    match p.parse_expression() {\n" +
    "        .Ok(id) -> dump_expr(p.store, id)\n" +
    "        .Err(_) -> \"<parse error>\"\n" +
    "    }\n" +
    "}\n\n" +
    "fn agree_expr(src: string) -> bool {\n" +
    "    let g = gen_tree(src)\n" +
    "    let h = hand_tree(src)\n" +
    "    g == h && !g.contains(\"<unmodelled-variant>\") && !h.contains(\"<unmodelled-variant>\")\n" +
    "}\n\n" +
    "fn expr_leg() -> bool {\n" +
    "    let ok = agree_expr(\"42\") && agree_expr(\"1 + 2\") && agree_expr(\"1 + 2 * 3\") && agree_expr(\"1 * 2 + 3 * 4\") &&\n" +
    "        agree_expr(\"1 - 2 - 3\") && agree_expr(\"(1 + 2) * 3\") && agree_expr(\"((1))\") &&\n" +
    "        agree_expr(\"-5\") && agree_expr(\"~5\") && agree_expr(\"!~-1\") && agree_expr(\"~a + 2\") &&\n" +
    "        agree_expr(\"1 && 2 || 3\") && agree_expr(\"1 | 2 & 3\") && agree_expr(\"1 << 4\") && agree_expr(\"7 % 3\") &&\n" +
    "        agree_expr(\"1 | 2 ^ 3 & 4 == 5 < 6 << 7 + 8 * 9 % 2\") &&\n" +
    "        agree_expr(\"x\") && agree_expr(\"foo + bar\") && agree_expr(\"\\\"hi\\\"\") &&\n" +
    "        agree_expr(\"a.b\") && agree_expr(\"a[0]\") && agree_expr(\"a.b.c\") && agree_expr(\"a[0][1]\") && agree_expr(\"-a.b\") &&\n" +
    "        agree_expr(\"f()\") && agree_expr(\"f(1)\") && agree_expr(\"f(1, 2, 3)\") && agree_expr(\"f(1)(2)\") &&\n" +
    "        agree_expr(\"a.b(c).d(e)\") && agree_expr(\"f(g(x), h(y, z))\")\n" +
    "    if !ok { println(\"expression: GENFAIL\") }\n" +
    "    ok\n" +
    "}\n"
}

fn stmt_harness_block() -> string {
    "fn gen_stmt(src: string) -> string {\n" +
    "    let st = new_pstate(src)\n" +
    "    let root = capval_to_stmt(st, parse_statement(st))\n" +
    "    if st.had_error { return \"<gen parse error>\" }\n" +
    "    render_stmt_id(st.store, root)\n" +
    "}\n\n" +
    "fn hand_stmt(src: string) -> string {\n" +
    "    mut p = parser_new(src)\n" +
    "    // ORACLE PIN (t-47hc.8): the interpreter engine, explicitly — the seam\n" +
    "    // defaults to the CHECKED-IN generated parser now, and an unpinned oracle\n" +
    "    // would compare emitted code against emitted code (a shared emitter\n" +
    "    // defect GENPASSes). Same pin as the type/expr oracles.\n" +
    "    p.stmt_static = false\n" +
    "    match p.parse_statement() {\n" +
    "        .Ok(id) -> render_stmt_id(p.store, id)\n" +
    "        .Err(_) -> \"<parse error>\"\n" +
    "    }\n" +
    "}\n\n" +
    "fn agree_stmt(src: string) -> bool {\n" +
    "    let gen = gen_stmt(src)\n" +
    "    let hand = hand_stmt(src)\n" +
    "    if gen != hand {\n" +
    "        println(\"stmt mismatch\")\n" +
    "        println(src)\n" +
    "        println(gen)\n" +
    "        println(hand)\n" +
    "    }\n" +
    "    gen == hand\n" +
    "}\n\n" +
    "fn stmt_leg() -> bool {\n" +
    "    let ok = agree_stmt(\"break\") && agree_stmt(\"continue\") &&\n" +
    "        agree_stmt(\"return 42\") && agree_stmt(\"return 1 + 2\") && agree_stmt(\"return 1 + 2 * 3\") &&\n" +
    "        agree_stmt(\"return (1 + 2) * 3\") &&\n" +
    "        agree_stmt(\"1 + 2 * 3\") && agree_stmt(\"8 / 4 / 2\") && agree_stmt(\"-2 + 3\") &&\n" +
    "        agree_stmt(\"1 < 2 == 3\") && agree_stmt(\"(1 + 2) * 3\") &&\n" +
    "        agree_stmt(\"match x { .A -> 1, .B if ok -> 2 }\") &&\n" +
    "        agree_stmt(\"match a + b { 1 -> 10, _ -> 0, }\") &&\n" +
    "        agree_stmt(\"defer cleanup()\") && agree_stmt(\"errdefer { cleanup }\")\n" +
    "    if !ok { println(\"statement: GENFAIL\") }\n" +
    "    ok\n" +
    "}\n"
}

fn pat_harness_block() -> string {
    "fn gen_pat(src: string) -> string {\n" +
    "    let st = new_pstate(src)\n" +
    "    let root = capval_to_pat(st, parse_pattern_or(st))\n" +
    "    if st.had_error { return \"<gen parse error>\" }\n" +
    "    render_pat_id(st.store, root)\n" +
    "}\n\n" +
    "fn hand_pat(src: string) -> string {\n" +
    "    let r = run_grammar_pat(avra_pat_grammar(), src)\n" +
    "    if r.had_error { return \"<parse error>\" }\n" +
    "    render_pat_id(r.store, r.root)\n" +
    "}\n\n" +
    "fn agree_pat(src: string) -> bool { gen_pat(src) == hand_pat(src) }\n\n" +
    "fn pat_leg() -> bool {\n" +
    "    let ok = agree_pat(\"_\") && agree_pat(\"rest\") && agree_pat(\"42\") && agree_pat(\"-5\") && agree_pat(\"3.14\") &&\n" +
    "        agree_pat(\"\\\"hi\\\"\") && agree_pat(\"true\") && agree_pat(\"false\") && agree_pat(\"int(n)\") &&\n" +
    "        agree_pat(\".None\") && agree_pat(\".Ok(x)\") && agree_pat(\".Ok(x, y)\") && agree_pat(\".Some(.Ok(x))\") &&\n" +
    "        agree_pat(\".Red or .Green\") && agree_pat(\".Red or .Green or .Blue\") && agree_pat(\"1 or 2 or 3\") &&\n" +
    "        agree_pat(\".Some(.Ok(x)) or .None\") &&\n" +
    "        agree_pat(\"let v\") && agree_pat(\"none\") && agree_pat(\"null\") && agree_pat(\"let x or none\")\n" +
    "    if !ok { println(\"pattern: GENFAIL\") }\n" +
    "    ok\n" +
    "}\n"
}

fn type_harness_block() -> string {
    "fn gen_type(src: string) -> string {\n" +
    "    let st = new_pstate(src)\n" +
    "    let te = capval_to_texpr(st, parse_type_expr(st))\n" +
    "    if st.had_error { return \"<gen parse error>\" }\n" +
    "    let tid = st.store.types.add_leaf(type_expr_to_vtype(te))\n" +
    "    render_type_id(st.store, tid)\n" +
    "}\n\n" +
    "fn hand_type(src: string) -> string {\n" +
    "    mut p = parser_new(src)\n" +
    "    // ORACLE PIN (t-47hc.8): the interpreter engine — the type seam has\n" +
    "    // defaulted to the checked-in generated parser since its promotion, so\n" +
    "    // this leg silently compared emitted against emitted until pinned.\n" +
    "    p.type_static = false\n" +
    "    match p.parse_type_expr(\"expected type\") {\n" +
    "        .Ok(te) -> {\n" +
    "            let tid = p.store.types.add_leaf(type_expr_to_vtype(te))\n" +
    "            render_type_id(p.store, tid)\n" +
    "        }\n" +
    "        .Err(_) -> \"<parse error>\"\n" +
    "    }\n" +
    "}\n\n" +
    "fn agree_type(src: string) -> bool { gen_type(src) == hand_type(src) }\n\n" +
    "fn type_leg() -> bool {\n" +
    "    let ok = agree_type(\"int\") && agree_type(\"string\") && agree_type(\"Foo\") && agree_type(\"MyType\") &&\n" +
    "        agree_type(\"int?\") && agree_type(\"Foo?\") && agree_type(\"Result<int, string>?\") &&\n" +
    "        agree_type(\"List<int>\") && agree_type(\"Map<string, int>\") && agree_type(\"Result<int, string>\") &&\n" +
    "        agree_type(\"Foo<A>\") && agree_type(\"Pair<A, B>\") &&\n" +
    "        agree_type(\"[int]\") && agree_type(\"[Foo]\") &&\n" +
    "        agree_type(\"(int, string)\") && agree_type(\"(int, bool, Foo)\") && agree_type(\"(int)\") &&\n" +
    "        agree_type(\"int | string\") && agree_type(\"int | string | bool\") && agree_type(\"List<int> | string\") &&\n" +
    "        agree_type(\"fn(int) -> bool\") && agree_type(\"fn(int, string) -> Foo\") && agree_type(\"fn() -> int\") &&\n" +
    "        agree_type(\"fn -> int\") && agree_type(\"fn\") && agree_type(\"fn(int) -> bool | string\") &&\n" +
    "        agree_type(\"dyn Display\") && agree_type(\"dyn Iterator\") && agree_type(\"dyn Display?\") &&\n" +
    "        agree_type(\"List<List<int>>\") && agree_type(\"Map<string, List<int>>\") &&\n" +
    "        agree_type(\"List<List<List<int>>>\") && agree_type(\"Result<List<int>, Map<string, int>>\")\n" +
    "    if !ok { println(\"type: GENFAIL\") }\n" +
    "    ok\n" +
    "}\n"
}

fn program_harness_block() -> string {
    // NOTE (t-47hc.8): unlike the four family legs above — whose oracles pin
    // the INTERPRETER engine explicitly (a genuine two-engine differential) —
    // this leg's oracle is parse_program_source, the PRODUCTION pipeline,
    // which routes to the checked-in generated parser. Its value is
    // pipeline CONSISTENCY: the freshly-emitted whole-program parser must
    // behave like the shipped one end-to-end (lex-once cache, resync, spans).
    // The engine differential for whole programs is --parser-probe/--parser-tree.
    "fn gen_prog(src: string) -> string {\n" +
    "    let st = new_pstate(src)\n" +
    "    let root = capval_to_stmt(st, parse_program(st))\n" +
    "    if st.had_error { return \"<gen parse error>\" }\n" +
    "    match st.store.stmts.get(root) {\n" +
    "        .Block(ids) -> render_stmt_ids(st.store, ids)\n" +
    "        _ -> \"<not a program block>\"\n" +
    "    }\n" +
    "}\n\n" +
    "fn hand_prog(src: string) -> string {\n" +
    "    let p = parse_program_source(src)\n" +
    "    if p.had_error != 0 { return \"<hand parse error>\" }\n" +
    "    if p.ids == null { return \"<hand no ids>\" }\n" +
    "    render_stmt_ids(p.store, p.ids!)\n" +
    "}\n\n" +
    "fn agree_prog(src: string) -> bool {\n" +
    "    let gen = gen_prog(src)\n" +
    "    let hand = hand_prog(src)\n" +
    "    if gen != hand {\n" +
    "        println(\"program mismatch\")\n" +
    "        println(src)\n" +
    "        println(gen)\n" +
    "        println(hand)\n" +
    "    }\n" +
    "    gen == hand\n" +
    "}\n\n" +
    "fn prog_leg() -> bool {\n" +
    "    let ok = agree_prog(\"fn f() {\\n}\\n\") &&\n" +
    "        agree_prog(\"type Point = { x: int, y: int }\\n\") &&\n" +
    "        agree_prog(\"enum Color { Red, Green, Blue }\\n\") &&\n" +
    "        agree_prog(\"mod inner\\n\") &&\n" +
    "        agree_prog(\"fn a() {\\n}\\nfn b() {\\n}\\n\") &&\n" +
    "        agree_prog(\"type T = { v: int }\\nenum E { A, B }\\nfn go() {\\n}\\n\") &&\n" +
    "        agree_prog(\"fn f() {\\n    return 1 + 2\\n}\\n\") &&\n" +
    "        agree_prog(\"fn f() {\\n    if a {\\n        return\\n    }\\n}\\n\") &&\n" +
    "        agree_prog(\"fn f() {\\n    while a {\\n        b()\\n    }\\n}\\n\") &&\n" +
    "        agree_prog(\"fn f() {\\n    for i in a {\\n        i\\n    }\\n}\\n\") &&\n" +
    "        agree_prog(\"fn f(x: int, y: List<int>) -> bool {\\n}\\n\") &&\n" +
    "        agree_prog(\"fn f(a: @std::core::Foo) -> @pkg::Bar {\\n}\\n\") &&\n" +
    "        agree_prog(\"trait Show {\\n    fn show() -> string\\n}\\n\") &&\n" +
    "        agree_prog(\"impl Show for Point {\\n    fn show() -> string {\\n        return x\\n    }\\n}\\n\") &&\n" +
    "        agree_prog(\"use @std.core { List, Map }\\n\") &&\n" +
    "        agree_prog(\"use @std.core.{ List, Map }\\n\") &&\n" +
    "        agree_prog(\"use @std.avrac.features.grammar.{ parse_grammar, run_grammar_stmt }\\n\") &&\n" +
    "        agree_prog(\"fn f() {\\n    ~x\\n}\\n\") &&\n" +
    "        agree_prog(\"fn f() {\\n    return ~y\\n}\\n\") &&\n" +
    "        agree_prog(\"fn f() {\\n    quote {\\n        x\\n    }\\n}\\n\") &&\n" +
    "        agree_prog(\"fn f() {\\n    let q = quote {\\n        ~x + 1\\n    }\\n    return ~q\\n}\\n\") &&\n" +
    "        agree_prog(\"fn f() {\\n    a()\\n    b()\\n    return c\\n}\\n\") &&\n" +
    "        agree_prog(\"fn f() {\\n    let x = 1\\n    let y = x + 2\\n    return y\\n}\\n\") &&\n" +
    "        agree_prog(\"fn f() {\\n    while a {\\n        if b {\\n            break\\n        }\\n    }\\n}\\n\") &&\n" +
    "        agree_prog(\"fn f() {\\n    for i in xs {\\n        while g {\\n            continue\\n        }\\n    }\\n}\\n\") &&\n" +
    "        agree_prog(\"fn f() {\\n    if a {\\n        return 1\\n    } else {\\n        return 2\\n    }\\n}\\n\") &&\n" +
    "        agree_prog(\"fn f() {\\n    if a {\\n        x()\\n    } else if b {\\n        y()\\n    }\\n}\\n\") &&\n" +
    "        agree_prog(\"fn f() {\\n    defer cleanup()\\n    errdefer cleanup()\\n}\\n\") &&\n" +
    "        agree_prog(\"fn f() {\\n    let a = 1\\n    let mut b = 2\\n    return a\\n}\\n\") &&\n" +
    "        agree_prog(\"fn f() {\\n    let v = x else {\\n        return\\n    }\\n    return v\\n}\\n\") &&\n" +
    "        agree_prog(\"fn f(a: int, b: string, c: bool) -> int {\\n    return a\\n}\\n\") &&\n" +
    "        agree_prog(\"fn f(x: A | B) -> dyn Show {\\n}\\n\") &&\n" +
    "        agree_prog(\"type Pair = { a: int, b: int }\\nenum Opt { Some(v: int), None }\\nfn use_it(p: Pair) -> int {\\n    return p\\n}\\n\")\n" +
    "    if !ok { println(\"whole-program: GENFAIL\") }\n" +
    "    ok\n" +
    "}\n"
}

// The ONE main: every family leg over the ONE emitted parser, each leg
// printing its own GENFAIL attribution; GENPASS only when all five hold.
fn combined_main_block() -> string {
    "fn main() {\n" +
    "    let e = expr_leg()\n" +
    "    let s = stmt_leg()\n" +
    "    let p = pat_leg()\n" +
    "    let t = type_leg()\n" +
    "    let g = prog_leg()\n" +
    "    if e && s && p && t && g { println(\"GENPASS\") } else { println(\"GENFAIL\") }\n" +
    "}\n"
}

fn assemble(fixed: string, g: Grammar, parser: string, harness: string) -> string {
    // GENERATOR-OWNS-IMPORTS (t-47hc.8): the parser's import surface derives
    // from its own emitted source; the fixed block carries only the HARNESS's
    // needs. Overlap between the two is a tolerated re-import, never an error.
    // The stamped grammar's manifest rows classify builder homes — the same
    // rows the emission itself read, no factory re-run.
    fixed + derived_import_lines_for(parser, g.builder_kinds, "@std.avrac.features.grammar", "@std.avrac.core") + parser + "\n" + harness
}

fn main() {
    // ONE emission of THE grammar — already builder-stamped by Language.full()
    // — shared by all five family harnesses in one module.
    let g = assemble_language().full()
    let parser = emit_parser_source(g)
    let harness = harness_block() + stmt_harness_block() + pat_harness_block() +
        type_harness_block() + program_harness_block() + combined_main_block()
    let _ = avra_selfhost_write_file("build/emit_gen/generated_parser.av", assemble(imports_block(), g, parser, harness))
    println("wrote the one full-grammar generated parser (all five family harnesses)")
}
AVEOF
  log "emit-gen-check: rendering the one full-grammar generated parser via emit.av"
  run_fg "$driver" >/dev/null || die "emit-gen-check: driver (emit.av render) failed"
  [ -f "$gen" ] || die "emit-gen-check: driver did not write $gen"
  # ONE module, five family differentials inside (t-47hc.8): a failing family
  # names itself on stdout ("<family>: GENFAIL"); GENPASS prints only when all
  # five legs hold.
  emit_gen_check_family "full-grammar (expr + stmt + pat + type + program)" "$gen"
  ok "emit-gen-check: the one generated parser compiles + all five family differentials agree (GENPASS)"
}

# Compile + run one generated-parser module and assert GENPASS.
emit_gen_check_family() {
  local label="$1" file="$2"
  log "emit-gen-check: compiling + running the GENERATED $label parser (differential vs hand parser)"
  local out
  out=$(run_fg "$file" 2>/dev/null) || die "emit-gen-check: generated $label parser failed to compile/run"
  printf '%s\n' "$out" | grep -q GENPASS || { printf '%s\n' "$out" >&2; die "emit-gen-check: generated $label parser did NOT match the hand parser (no GENPASS)"; }
}

# Read-only probe of ensure_bs2's staleness decision — prints `fresh`
# (rc 0) or `stale` (rc 1) and NEVER builds anything. Regression witness
# for t-gv3n: the BSD-only `stat -f %m` made source_newer_than report
# stale on every Linux invocation, so each of the ~10 diagnose.sh-based
# fixture tests in a suite run kicked off its own concurrent bs2
# rebuild. tests/suite_bs2_guard_test.av asserts `fresh` from inside a
# running suite (where bs2 is the binary under test, current by
# construction).
mode_bs2_stale_check() {
  [ -x "$BS2" ] || { echo "stale (no bs2 at $BS2)"; exit 1; }
  # `stale` is reserved for the condition the word actually describes: a
  # source (or the seed) is GENUINELY newer than the binary. `-nt` is already
  # strict, so the seed arm needs no change.
  if source_strictly_newer_than "$BS2" || { [ -f "$SEED_LL" ] && [ "$SEED_LL" -nt "$BS2" ]; }; then
    echo "stale"
    exit 1
  fi
  # Nothing is strictly newer, but something shares the binary's second.
  # Ordering is unknowable, so ensure_bs2 still rebuilds (it consults
  # source_newer_than, whose `-ge` is unchanged) — but this is NOT the
  # "your bs2 predates a compiler-source edit" condition, and reporting it as
  # such reds a suite for a reason no diff can explain. rc 0: not an error.
  if source_newer_than "$BS2"; then
    echo "tie"
    exit 0
  fi
  echo "fresh"
}

# t-kdyj.10: the OPERATOR-FACING half of the staleness question. Prints one
# line naming both paths and both timestamps when build/bs2 genuinely predates
# a compiler source, and NOTHING otherwise. Always rc 0 — this reports, it does
# not gate, and a reporter that can fail a caller is a reporter that callers
# learn to ignore.
#
# Deliberately a SEPARATE mode rather than extra output on --bs2-stale-check:
# that probe's contract is one word, and suite_bs2_guard_test matches it with
# `contains("tie")`, so folding a PATH into its output would make any source
# file whose name happens to contain `tie` silently satisfy the guard.
#
# Why this exists at all: a rebase rewrites working-tree mtimes even when the
# resulting content is byte-identical, so `bs2` reads as stale and the suite
# reds with two failures that name nothing about rebasing (the guard firing,
# correctly, plus a fixture that shells out to the same binary). The
# information was already in the tree; only the output lacked it.
mode_bs2_stale_report() {
  [ -x "$BS2" ] || return 0
  source_strictly_newer_than "$BS2" || return 0
  local entry newest_mt newest_path bs2_mt
  entry=$(newest_source_entry) || return 0
  [ -n "$entry" ] || return 0
  newest_mt=${entry%% *}
  newest_path=${entry#* }
  bs2_mt=$($STAT_MTIME "$BS2" 2>/dev/null) || return 0
  echo "[stale] $BS2 ($(fmt_epoch "$bs2_mt")) predates $newest_path ($(fmt_epoch "$newest_mt")) — rebuild before trusting this run"
}

# Epoch → local HH:MM:SS, falling back to the raw epoch wherever neither date
# spelling lands. A timestamp nobody can read is not worth failing over.
fmt_epoch() {
  date -d "@$1" '+%H:%M:%S' 2>/dev/null \
    || date -r "$1" '+%H:%M:%S' 2>/dev/null \
    || echo "$1"
}

# rcsf.3: run the spec suite under AVRA_RC_STRICT=1. Strict mode lives in
# runtime.c, so BOTH bs2 (as it compiles + runs each test binary) AND the
# test programs themselves execute under it — a release of a stale pointer to
# reclaimed RC memory (the zm77 phantom-release class) aborts loudly with a
# backtrace instead of silently corrupting memory. A clean run proves the
# compiler's own RC discipline plus every test program's is misuse-free (the
# "full suite green, no false positives" acceptance). Optional arg: a filename
# substring filter, same as `bs2 test -f`.
mode_rc_strict_suite() {
  ensure_bs2
  log "running the spec suite under AVRA_RC_STRICT=1 (poison-on-free + reuse quarantine + foreign-release abort)"
  # `bs2 test` discovers test files and resolves @std relative to CWD, so it
  # MUST run from the bootstrap dir — CI invokes this script from the repo
  # root. Same `( cd "$BOOTSTRAP_DIR" && "$BS2" test )` form the seed-train's
  # spec-suite check uses; without it every shard fails to resolve the test
  # runner (`undefined variable run_test_suite`).
  # The resource controller recognises RC strict as an allocation profile,
  # uses its stricter seed, and admits shards from live capacity and pressure.
  # ${AVRA_TEST_JOBS:-2} is this suite's own INTERNAL default for in-shard
  # test workers — an undocumented hook, not an operator knob. CI
  # (rc-strict.yml) pins it to match seed-train.yml so PR CI exercises the same
  # in-shard interleaving the post-merge train does (hama). RESTORED by #1131;
  # see the workflow comments for why #1127's removal was withdrawn.
  local test_jobs="${AVRA_TEST_JOBS:-2}"
  # t-u602: run the WHOLE strict tree under a box-scaled SOFT grant. A test
  # unit that reaches execution without AVRA_MEM_BUDGET_MB in its env runs on
  # the HARD box ceiling (75% of MemTotal), and the strict allocator's
  # measured overhead pushed a legitimate ~8GB in-process-build batch
  # (per_fn_cgu_cache_x8) straight through a 7871 MiB hard ceiling on a
  # ~10.5GB runner — an instant F4014 with no back-off, five consecutive
  # rc-strict reds while the SAME suite passed non-strict. The soft grant
  # routes every process onto the designed governance instead: borrow while
  # the box has slack, hold and re-sample under the pressure floor, yield
  # only on a genuine cliff (t-d91l), with the runaway backstop intact. The
  # pool's own narrower per-shard exports still rebind deeper in the tree; an
  # operator's explicit budget (or hard AVRA_MEM_LIMIT_MB) is respected.
  local strict_budget="${AVRA_MEM_BUDGET_MB:-}"
  if [ -z "$strict_budget" ] && [ -r /proc/meminfo ]; then
    strict_budget=$(awk '/^MemTotal:/ {print int($2/1024)}' /proc/meminfo)
  fi
  # `env` (not bare prefix assignments): the ${…:+…} expansion happens AFTER
  # the shell has parsed assignments, so an expanded `VAR=val` word would be
  # taken as the COMMAND. env applies expanded assignments correctly and is a
  # no-op wrapper when the budget is empty.
  if [ -n "${1:-}" ]; then
    ( cd "$BOOTSTRAP_DIR" && env AVRA_RC_STRICT=1 AVRA_TEST_JOBS="$test_jobs" ${strict_budget:+AVRA_MEM_BUDGET_MB="$strict_budget"} "$BS2" test -f "$1" )
  else
    ( cd "$BOOTSTRAP_DIR" && env AVRA_RC_STRICT=1 AVRA_TEST_JOBS="$test_jobs" ${strict_budget:+AVRA_MEM_BUDGET_MB="$strict_budget"} "$BS2" test )
  fi
}

# Link a pre-emitted .ll into a binary and run it — WITHOUT recompiling
# from source. Unlike --run (which always re-invokes `bs2 compile`), this
# executes the EXACT artifact a prior `bs2 compile` already wrote, so a
# caller can verify that one specific .ll links and runs correctly. The
# runtime + LLVM-wrapper objects are the same link inputs link_ll uses.
link_run_ll() {
  local ll="$1"
  [ -f "$ll" ] || die "no such file: $ll"
  ensure_runtime
  ensure_llvm_wrapper
  local bin="${ll%.ll}.bin"
  link_ll "$ll" "$bin" "$BUILD_DIR/link_run.log.$$"
  rm -f "$BUILD_DIR/link_run.log.$$"
  "$bin"
}

mode_link_run() { link_run_ll "$1"; }

mode_check() {
  local fg="$1"; [ -f "$fg" ] || die "no such file: $fg"
  ensure_bs2
  "$BS2" check "$fg"
}

mode_ll() {
  local fg="$1"; [ -f "$fg" ] || die "no such file: $fg"
  ensure_bs2
  "$BS2" compile "$fg" >/dev/null
  cat "$fg.ll"
}

mode_diff() {
  local fg="$1"; [ -f "$fg" ] || die "no such file: $fg"
  ensure_bs2; ensure_bs3
  local b2_ll="$BUILD_DIR/$(basename "$fg").bs2.ll"
  local b3_ll="$BUILD_DIR/$(basename "$fg").bs3.ll"
  "$BS2" compile "$fg" >/dev/null 2>&1 || die "bs2 codegen failed"
  cp "$fg.ll" "$b2_ll"
  "$BS3" compile "$fg" >/dev/null 2>&1 || die "bs3 codegen failed"
  cp "$fg.ll" "$b3_ll"
  log "bs2: $b2_ll"
  log "bs3: $b3_ll"
  if diff -u "$b2_ll" "$b3_ll" >/dev/null; then
    ok "IR is byte-identical"
  else
    diff -u "$b2_ll" "$b3_ll" | head -200
  fi
}

mode_diff_fn() {
  local fg="$1" fn="$2"
  [ -f "$fg" ] || die "no such file: $fg"
  [ -n "$fn" ] || die "--diff-fn requires <file.av> <fn-name>"
  ensure_bs2; ensure_bs3
  local b2_ll="$BUILD_DIR/$(basename "$fg").bs2.ll"
  local b3_ll="$BUILD_DIR/$(basename "$fg").bs3.ll"
  "$BS2" compile "$fg" >/dev/null 2>&1 || die "bs2 codegen failed"
  cp "$fg.ll" "$b2_ll"
  "$BS3" compile "$fg" >/dev/null 2>&1 || die "bs3 codegen failed"
  cp "$fg.ll" "$b3_ll"
  extract_fn() {
    awk -v fn="$1" '
      $0 ~ "define .*@"fn"\\(" { in_fn=1 }
      in_fn { print }
      in_fn && /^}/ { in_fn=0 }
    ' "$2"
  }
  diff -u <(extract_fn "$fn" "$s1_ll") <(extract_fn "$fn" "$b2_ll")
}

mode_score() {
  local ll="${1:-}"
  if [ -z "$ll" ]; then
    ll=$(ls -t "$BUILD_DIR"/*.ll "$SRC_DIR"/*.ll 2>/dev/null | head -1)
    [ -n "$ll" ] || die "no .ll files found; pass one explicitly or build something first"
  fi
  [ -f "$ll" ] || die "no such file: $ll"
  log "scoring $ll"
  local total
  total=$(wc -l <"$ll" | tr -d ' ')
  local fns ret_undef br_const_false orphan_blocks unreachable phi_undef \
        i64_for_ptr empty_blocks
  count() { local n; n=$(grep -c "$1" "$2" 2>/dev/null || true); echo "${n:-0}"; }
  fns=$(count '^define ' "$ll")
  ret_undef=$(count 'ret .* undef' "$ll")
  br_const_false=$(count 'br i1 false' "$ll")
  unreachable=$(count '^  unreachable$' "$ll")
  phi_undef=$(count 'phi .* undef' "$ll")
  empty_blocks=$(awk '
    /^[a-zA-Z0-9_.]+:/ { last_label=NR; bodies=0; next }
    last_label && /^[ \t]*[a-zA-Z]/ { bodies++ }
    /^}/ { if (last_label && bodies==0) c++; last_label=0 }
    END { print c+0 }
  ' "$ll")
  # Count blocks that have no incoming branch and aren't entry. Quick
  # approximation: any "label:" line not referenced by a br/switch.
  # Count basic-block labels not referenced by any `label %name`. We
  # iterate the line and pull only operands immediately after `label`.
  orphan_blocks=$(awk '
    /^[a-zA-Z0-9_.]+:/ {
      lbl = $0
      sub(/:.*/, "", lbl)
      labels[lbl] = 1
      next
    }
    {
      s = $0
      while (match(s, /label %[a-zA-Z0-9_.]+/)) {
        ref = substr(s, RSTART+7, RLENGTH-7)
        refs[ref] = 1
        s = substr(s, RSTART + RLENGTH)
      }
    }
    END {
      for (l in labels) if (!(l in refs) && l != "entry") c++
      print c+0
    }
  ' "$ll")

  # Wide-store-into-narrow-malloc detector. Catches the bug class we
  # spent half a session chasing in 3814cce: a `store iN` whose
  # destination came from a `call ptr @malloc(i64 K)` with K*8 < N.
  # Tracks ptr provenance through ptrtoint/inttoptr/add aliases since
  # bootstrap-emitted IR routes everything through i64 round-trips.
  # Each hit is a definite heap overflow — these are bugs, not smells.
  wide_stores=$(awk '
    function bytes(width) { return int(width/8) }
    function ssa_lhs(line,    s) {
      s = line; sub(/^[ \t]+/, "", s); sub(/ *=.*/, "", s); return s
    }
    # Reset state at function boundaries — SSA names are local to each
    # function and reusing %1, %2 across functions would otherwise cause
    # phantom hits from earlier malloc sizes leaking forward.
    /^define / { delete malloc_size; next }
    /= call ptr @malloc\(i64 [0-9]+\)/ {
      lhs = ssa_lhs($0)
      match($0, /malloc\(i64 [0-9]+\)/)
      # "malloc(i64 " is 11 chars, trailing ")" is 1 char.
      sz = substr($0, RSTART+11, RLENGTH-12)
      malloc_size[lhs] = sz + 0
      next
    }
    /= ptrtoint ptr %[A-Za-z0-9_.]+/ {
      lhs = ssa_lhs($0)
      match($0, /ptr %[A-Za-z0-9_.]+/)
      # "ptr " is 4 chars; keep the leading "%" so the key matches.
      src = substr($0, RSTART+4, RLENGTH-4)
      if (src in malloc_size) malloc_size[lhs] = malloc_size[src]
      next
    }
    /= inttoptr i64 %[A-Za-z0-9_.]+/ {
      lhs = ssa_lhs($0)
      match($0, /i64 %[A-Za-z0-9_.]+/)
      src = substr($0, RSTART+4, RLENGTH-4)
      if (src in malloc_size) malloc_size[lhs] = malloc_size[src]
      next
    }
    /= add i64 %[A-Za-z0-9_.]+, [0-9]+/ {
      lhs = ssa_lhs($0)
      # Match the operand AFTER "add i64 " — not the LHS, which is also a %.
      match($0, /add i64 %[A-Za-z0-9_.]+/)
      src = substr($0, RSTART+8, RLENGTH-8)
      if (src in malloc_size) malloc_size[lhs] = malloc_size[src]
      next
    }
    /^[ \t]*store i[0-9]+ .*, ptr %[A-Za-z0-9_.]+/ {
      match($0, /store i[0-9]+/)
      width = substr($0, RSTART+7, RLENGTH-7) + 0
      match($0, /ptr %[A-Za-z0-9_.]+/)
      dst = substr($0, RSTART+4, RLENGTH-4)
      if (dst in malloc_size && bytes(width) > malloc_size[dst]) {
        printf("  %s: store i%d into malloc(%d) at NR=%d\n", dst, width, malloc_size[dst], NR) > "/dev/stderr"
        c++
      }
    }
    END { print c+0 }
  ' "$ll")

  printf "%-22s %s\n" "file"            "$ll"
  printf "%-22s %s\n" "lines"           "$total"
  printf "%-22s %s\n" "functions"       "$fns"
  printf "%-22s %s\n" "ret undef"       "$ret_undef"
  printf "%-22s %s\n" "br i1 false"     "$br_const_false"
  printf "%-22s %s\n" "phi undef"       "$phi_undef"
  printf "%-22s %s\n" "unreachable"     "$unreachable"
  printf "%-22s %s\n" "empty blocks"    "$empty_blocks"
  printf "%-22s %s\n" "orphan blocks"   "$orphan_blocks"
  printf "%-22s ${C_RED}%s${C_RESET}\n" "wide stores (BUG)" "$wide_stores"
  local score=$((ret_undef*10 + br_const_false*5 + phi_undef*5 + empty_blocks*2 + orphan_blocks*3 + wide_stores*100))
  printf "%-22s ${C_YELLOW}%s${C_RESET}\n" "SCORE (lower=better)" "$score"
  if [ "$wide_stores" -gt 0 ]; then
    err "wide-store-into-narrow-malloc detected — this is the heap-overflow bug class"
    return 1
  fi
}

mode_rank() {
  local arg="$1"; [ -f "$arg" ] || die "no such file: $arg"
  local ll
  case "$arg" in
    *.ll) ll="$arg" ;;
    *.av)
      ensure_bs2
      "$BS2" compile "$arg" >/dev/null 2>&1 || die "bs2 codegen failed"
      ll="$arg.ll"
      ;;
    *) die "--rank: pass a .av or .ll file" ;;
  esac
  awk '
    /^define / {
      match($0, /@[A-Za-z0-9_.]+/)
      name=substr($0, RSTART+1, RLENGTH-1)
      in_fn=1; lines=0; next
    }
    in_fn { lines++ }
    in_fn && /^}/ { print lines, name; in_fn=0 }
  ' "$ll" | sort -rn | head -40
}


# ─────────────────────────────────────────────────────────────────────
# Heap / memory debugging
# ─────────────────────────────────────────────────────────────────────

mode_asan() {
  local fg="$1"; [ -f "$fg" ] || die "no such file: $fg"
  ensure_bs2_asan
  log "running bs2_asan compile $fg"
  ASAN_OPTIONS="abort_on_error=0:halt_on_error=0:print_stacktrace=1:detect_leaks=0" \
    "$BS2_ASAN" compile "$fg"
}

mode_malloc_trace() {
  local fg="$1"; [ -f "$fg" ] || die "no such file: $fg"
  ensure_bs2
  log "running bs2 with MallocStackLogging + guard"
  MallocStackLogging=1 \
  MallocGuardEdges=1 \
  MallocScribble=1 \
  MallocCheckHeapStart=1 \
  MallocCheckHeapEach=1000 \
    "$BS2" compile "$fg"
}

mode_bisect_lines() {
  local fg="$1"; [ -f "$fg" ] || die "no such file: $fg"
  ensure_bs2
  local total
  total=$(wc -l <"$fg" | tr -d ' ')
  log "bisecting $fg ($total lines)"
  local lo=1 hi=$total mid tmp="$BUILD_DIR/_bisect.av"
  # Verify the full file actually crashes; otherwise bisection is meaningless.
  if "$BS2" compile "$fg" >/dev/null 2>&1; then
    ok "full file compiles cleanly — nothing to bisect"
    return 0
  fi
  # Run each prefix N times — heap corruption is often nondeterministic.
  # A prefix counts as "crashing" if it crashes on ANY of N trials.
  local trials="${BISECT_TRIALS:-5}"
  test_prefix() {
    local n="$1" i
    for ((i=0; i<trials; i++)); do
      if ! "$BS2" compile "$tmp" >/dev/null 2>&1; then return 1; fi
    done
    return 0
  }
  while [ "$lo" -lt "$hi" ]; do
    mid=$(( (lo + hi) / 2 ))
    head -n "$mid" "$fg" >"$tmp"
    if test_prefix "$mid"; then
      lo=$((mid + 1))
    else
      hi=$mid
    fi
    log "  lo=$lo hi=$hi (trials=$trials)"
  done
  log "smallest crashing prefix: first $lo lines"
  echo "─── lines $((lo-3))..$lo ───"
  sed -n "$((lo-3)),${lo}p" "$fg"
  echo "─────────────────────────"
  cp "$tmp" "$BUILD_DIR/bisect_${$}.av"
  log "saved minimal crash repro: $BUILD_DIR/bisect_${$}.av"
}

# ─────────────────────────────────────────────────────────────────────
# Dispatch
# ─────────────────────────────────────────────────────────────────────

# pdme.9: the canonical "is the cache lying to me" check. Fuzzes the
# build-cache correctness invariant against a sandbox package whose
# ENTRY stays fixed while a NON-ENTRY sibling mutates — exactly the
# lkze.9 staleness shape (an edit the entry-keyed cache historically
# didn't see). Each iteration applies one seeded mutation, then
# compiles the probe twice:
#
#   A = the normal, cache-eligible compile
#   B = the same compile with the cache BYPASSED (AVRA_TIMINGS=1 is an
#       existing eligibility gate — timings expect per-invocation
#       stderr, so the compile cache never engages)
#
# and requires A == B byte-for-byte: whatever the cache served must be
# indistinguishable from recomputing. Mutation kinds:
#   0  no-op comment appended to the sibling (hash changes, IR must not lie)
#   1  semantic change to the sibling (IR legitimately changes; A must track)
#   2  newest cache slot's unit.ll truncated to 0 bytes (slot_complete must reject)
#   3  newest cache slot's metadata.bin deleted (incomplete slot must miss)
# After every iteration an identical rerun must be a cache HIT — the
# liveness invariant (catches publish-death: a cache that silently
# stops publishing keeps recomputing, so A == B alone can't see it).
# Finally the sibling is restored to its ORIGINAL bytes and the probe
# must byte-match the very first golden compile — the revert-restores
# invariant (a sticky-fingerprint regression like the pre-fix
# whole-second sidecar mtimes fails here).
#
# Usage: --cache-fuzz [N] [SEED]   (default 20 iterations, seed 42)
# Shared sandbox for the cache fuzz modes. Lives under a literal
# `packages/` segment so the resolver's find_packages_dir locates it and
# `use @fuzz.q` resolves — the mutation target is a CROSS-PACKAGE
# dependency of a fixed entry, the genuine lkze.9 axis (fp_full keys it
# since pdme.1). Sets FUZZ_ENTRY / FUZZ_SIB / FUZZ_CACHE_DIR.
cache_fuzz_mk_sandbox() {
  local fuzz_root="$1"
  rm -rf "$fuzz_root"
  mkdir -p "$fuzz_root/packages/fuzz-p/src" "$fuzz_root/packages/fuzz-q/src"
  cat > "$fuzz_root/packages/fuzz-p/avra.toml" <<'MANIFEST'
[package]
name = "@fuzz/p"
version = "0.1.0"

[dependencies]
"@fuzz/q" = { path = "../fuzz-q" }
MANIFEST
  cat > "$fuzz_root/packages/fuzz-q/avra.toml" <<'MANIFEST'
[package]
name = "@fuzz/q"
version = "0.1.0"
MANIFEST
  FUZZ_ENTRY="$fuzz_root/packages/fuzz-p/src/main.av"
  FUZZ_SIB="$fuzz_root/packages/fuzz-q/src/q.av"
  # The compile cache lives at the PACKAGE root (BuildInputs.project_root
  # = package_root_for_file), not under src/ — keep the chaos agent
  # aimed at the live slot or the damage kinds silently degrade to
  # pure-contention rounds.
  FUZZ_CACHE_DIR="$fuzz_root/packages/fuzz-p/build/cache"
  printf 'use @fuzz.q.{fuzz_value}\n\nfn main() { println(string(fuzz_value())) }\n' > "$FUZZ_ENTRY"
  printf 'export fn fuzz_value() -> int { 1 }\n' > "$FUZZ_SIB"
}

mode_cache_fuzz() {
  local n="${1:-20}" seed="${2:-42}"
  ensure_bs2
  local fuzz_root="$BUILD_DIR/cache-fuzz"
  cache_fuzz_mk_sandbox "$fuzz_root"
  local entry="$FUZZ_ENTRY" sib="$FUZZ_SIB" cache_dir="$FUZZ_CACHE_DIR"
  local sib_orig
  sib_orig=$(cat "$sib")

  # Both compile flavours strip the shard env (metadata/lib-objs flip
  # eligibility and resolve behaviour); B additionally sets the
  # cache-bypass gate.
  fuzz_compile_cached() {
    env -u AVRA_USE_METADATA -u AVRA_LIB_OBJS -u AVRA_LIB_PKG_ROOT -u AVRA_TIMINGS \
      "$BS2" compile "$entry" >/dev/null 2>&1
  }
  fuzz_compile_bypass() {
    env -u AVRA_USE_METADATA -u AVRA_LIB_OBJS -u AVRA_LIB_PKG_ROOT AVRA_TIMINGS=1 \
      "$BS2" compile "$entry" >/dev/null 2>&1
  }

  fuzz_compile_cached || die "cache-fuzz: golden compile failed"
  cp "$entry.ll" "$fuzz_root/golden.ll"

  local r="$seed" iter=1 kind
  while [ "$iter" -le "$n" ]; do
    r=$(( (r * 1103515245 + 12345) % 2147483648 ))
    # Kind comes from the LCG's HIGH bits — the low bits of a mod-2^31
    # LCG cycle with tiny period (r % 4 degenerates to a fixed
    # 3,0,1,2,… wheel), which is how the net's first defect hid: a
    # damage kind always ran before the first semantic edit.
    kind=$(( (r / 65536) % 4 ))
    case "$kind" in
      0) printf '// fuzz noop %s\n' "$r" >> "$sib" ;;
      1) printf 'export fn fuzz_value() -> int { %s }\n' "$(( r % 97 ))" > "$sib" ;;
      2) local slot_ll
         slot_ll=$(ls -t "$cache_dir"/*/unit.ll 2>/dev/null | head -1)
         [ -n "$slot_ll" ] && : > "$slot_ll" ;;
      3) local slot_meta
         slot_meta=$(ls -t "$cache_dir"/*/metadata.bin 2>/dev/null | head -1)
         [ -n "$slot_meta" ] && rm -f "$slot_meta" ;;
    esac
    fuzz_compile_cached || die "cache-fuzz iter $iter (kind $kind): cached compile failed"
    mv "$entry.ll" "$fuzz_root/a.ll"
    fuzz_compile_bypass || die "cache-fuzz iter $iter (kind $kind): bypass compile failed"
    mv "$entry.ll" "$fuzz_root/b.ll"
    cmp -s "$fuzz_root/a.ll" "$fuzz_root/b.ll" \
      || die "cache-fuzz FAIL iter $iter (kind $kind): cached IR diverges from recompute — the cache lied"
    # Liveness: an immediate identical rerun must be a cache HIT.
    # Catches publish-death (the pdme.9-found half-slot poison: after
    # slot damage, every republish failed forever and the cache
    # silently died — recompute-always keeps A == B, so only this
    # assertion sees it). The hit line is on stderr.
    env -u AVRA_USE_METADATA -u AVRA_LIB_OBJS -u AVRA_LIB_PKG_ROOT -u AVRA_TIMINGS \
        "$BS2" compile "$entry" 2>&1 >/dev/null | grep -q 'compile-cache\] hit' \
      || die "cache-fuzz FAIL iter $iter (kind $kind): rerun did not HIT — publish is dead (cache disabled)"
    iter=$(( iter + 1 ))
  done

  # Revert-restores: back to the original sibling bytes, the probe must
  # byte-match the first golden compile through the cached path.
  printf '%s' "$sib_orig" > "$sib"
  fuzz_compile_cached || die "cache-fuzz: post-revert compile failed"
  cmp -s "$entry.ll" "$fuzz_root/golden.ll" \
    || die "cache-fuzz FAIL: revert did not restore the golden IR (sticky fingerprint)"

  rm -rf "$fuzz_root"
  ok "cache-fuzz PASS — $n iterations (seed $seed): cached IR == recomputed IR, revert restores golden"
}

# ── Stray heavy processes (t-ce5t) ───────────────────────────────────────────
#
# Two hazards that compound, and they are the same subject: which heavy
# processes exist, and whose they are.
#
# (1) ORPHANS SURVIVE THE KILL. A run that dies without unwinding — SIGKILL,
#     a tool timeout — leaves its grandchildren running. Observed 2026-07-31:
#
#         26966  4.4GB  build/bs2 compile
#         26962  4.4GB  build/bs2 compile
#
#     8.8GB held by a run already declared dead. The NEXT run then starts
#     against 6GB free instead of 14GB, and every memory reading taken
#     meanwhile is wrong — the session-accumulated-pressure confusion
#     CLAUDE.md warns has cost whole sessions. (The memory sibling of
#     t-zg2s, which fixed orphaned-run ARTIFACTS poisoning verdicts.)
#
# (2) THE INSPECTION IDIOM LIES. `pgrep -f bs2` / `pkill -f <pat>` match the
#     COMMAND LINE, and the shell running them carries the pattern in its own
#     command line — so they match themselves. Knowing that is demonstrably
#     not enough to avoid it: the hazard was already documented and still
#     produced a stale-run status reported wrong three times off one reading.
#     So nothing here matches a command line. Every probe below filters on
#     ps's `comm` — the executable's basename, which no shell, awk or ps in
#     the pipeline can accidentally be — making it self-safe BY CONSTRUCTION
#     rather than by remembering a trick. (Typing one by hand anyway? The
#     bracket idiom is the escape hatch, because the literal `[b]s2` does
#     not match itself:
#         ps -A -o pid=,rss=,comm= | grep '[b]s2')

# The heavy set: the processes that actually hold the memory. ONE definition —
# --stray reports it and --stray --reap kills it, so a new heavy tool is added
# in a single place. Overridable because the specs drive the REAL cli
# end-to-end against fake binaries under a per-run name: pointing the set at
# those names is what makes a test that genuinely SIGKILLs a tree and reaps
# its survivors incapable of touching the live suite's own `bs2`.
HEAVY_PROCS="${AVRA_HEAVY_PROCS:-bs2 llc cc1plus clang cc1}"

# ONE ps snapshot behind everything below — `pid ppid pgid rss_kb age_secs comm`
# for EVERY process. macOS ps prints comm as an absolute path where Linux prints
# the basename, so the path is stripped.
all_ps() {
  ps -A -o pid=,ppid=,pgid=,rss=,etime=,comm= 2>/dev/null | awk '
    function age(s,   a, p, n, d) {
      d = 0
      if (s ~ /-/) { split(s, a, "-"); d = a[1] + 0; s = a[2] }
      n = split(s, p, ":")
      if (n == 3) return d * 86400 + p[1] * 3600 + p[2] * 60 + p[3]
      if (n == 2) return d * 86400 + p[1] * 60 + p[2]
      return d * 86400 + p[1] + 0
    }
    { comm = $6; sub(/^.*\//, "", comm)
      print $1, $2, $3, $4, age($5), comm }'
}

# The heavy ones. The `comm` filter is what makes this self-safe (see (2)
# above): it matches the executable's basename, which no shell, awk or ps in
# the pipeline can accidentally be.
heavy_ps() {
  all_ps | awk -v want="$HEAVY_PROCS" '
    BEGIN { n = split(want, w, " "); for (i = 1; i <= n; i++) heavy[w[i]] = 1 }
    $6 in heavy'
}

# heavy_ps plus STATE and the ROOT of the tree each process belongs to:
#   pid ppid pgid rss age comm state root
#
# State comes from walking to the top of the process's own tree — the ancestor
# init inherited — and asking whether that root is in OUR ancestry:
#   live         the tree is still owned by something we are part of,
#   orphan       the process itself was re-parented: its run is gone,
#   orphan-tree  an ANCESTOR of it was.
#
# That third state is not a nicety, it is the whole point. A killed sweep leaves
# an orphaned test-unit binary that keeps spawning fresh `bs2 compile` children,
# and each child has a LIVE parent — so a parent-only test calls a 4.2GB compile
# "live" while the run that owns it has been dead for minutes. Observed here on
# the real thing, which is why the tree, not the process, is the unit.
annotate_heavy() {
  local snap chain
  snap="$(all_ps)"
  chain=" $(pid_ancestry $$) "
  printf '%s\n' "$snap" | awk -v snap="$snap" -v chain="$chain" -v want="$HEAVY_PROCS" '
    BEGIN {
      n = split(snap, lines, "\n")
      for (i = 1; i <= n; i++) { split(lines[i], f, " "); if (f[1] != "") parent[f[1]] = f[2] }
      m = split(want, w, " "); for (i = 1; i <= m; i++) heavy[w[i]] = 1
    }
    !($6 in heavy) { next }
    { root = ""; p = $1; hops = 0
      while (p != "" && p != "0" && p != "1" && hops < 64) {
        if (parent[p] == "1") { root = p; break }
        p = parent[p]; hops++
      }
      state = "live"
      if (root != "" && index(chain, " " root " ") == 0) state = (root == $1) ? "orphan" : "orphan-tree"
      else root = "-"
      print $1, $2, $3, $4, $5, $6, state, root }'
}

# The pid chain from PID (default: this shell) up to init, space separated.
# Recorded at run START, because once the leader is SIGKILLed its children are
# re-parented and the chain is gone — and a reaper must never kill the tree it
# is running INSIDE (a spec test driving this tooling has a live `bs2`
# orchestrator above it).
pid_ancestry() {
  local p="${1:-$$}" chain="" hops=0 snap
  snap="$(ps -A -o pid=,ppid= 2>/dev/null)"
  while [ -n "$p" ] && [ "$p" != "0" ] && [ "$hops" -lt 64 ]; do
    chain="$chain $p"
    [ "$p" = "1" ] && break
    p="$(printf '%s\n' "$snap" | awk -v t="$p" '$1 == t { print $2; exit }')"
    hops=$(( hops + 1 ))
  done
  printf '%s' "${chain# }"
}

# Is one of our ANCESTORS a heavy process? Then we are running INSIDE another
# run (a spec test driving this tooling, a nested build), our process GROUP is
# shared with that run's other children, and a group-wide reap could kill work
# that is not ours. Callers downgrade to descendant-only reaping when true.
run_has_heavy_ancestor() {
  local snap chain
  chain=" $(pid_ancestry $$) "
  snap="$(heavy_ps)"
  [ -n "$snap" ] || return 1
  printf '%s\n' "$snap" | awk -v chain="$chain" '
    index(chain, " " $1 " ") > 0 { found = 1 } END { exit(found ? 0 : 1) }'
}

# SIGTERM the listed victims ("pid comm" per line), then SIGKILL whatever is
# still standing. TERM first so a compile can unwind and drop its temp files;
# KILL because the memory has to come back either way. Returns non-zero if
# anything outlived the KILL, so a caller can report that honestly instead of
# claiming a reap that did not happen.
#
# Every signal is gated on the pid STILL carrying the comm we selected it by.
# Pids are recycled, the list is a snapshot, and the list now includes ordinary
# processes (a run's subtree is not all `bs2`) — so without the re-check a
# recycled pid could take an unrelated signal.
# Is PID still the process we selected — same pid, same comm? The victim list is
# a SNAPSHOT: entries die between listing and signalling (the reaper's own
# pipeline, for one), and pids are recycled (`pid_max` is 32768 on this box, so
# a long build wraps it), so a stale entry must not hand its signal to whoever
# inherited the number. Reading /proc keeps that check FORK-FREE on Linux —
# the reaper does not spend a process per candidate to decide about one.
comm_is() {
  local now=""
  if [ -r "/proc/$1/comm" ]; then
    read -r now < "/proc/$1/comm" 2>/dev/null || return 1
  else
    now=$(ps -o comm= -p "$1" 2>/dev/null | sed 's|.*/||')   # BSD/macOS: no /proc
  fi
  [ -n "$now" ] && [ "$now" = "$2" ]
}

KILL_COUNT=0   # what the last kill_victims actually signalled

kill_victims() {
  local list="$1" label="$2"
  KILL_COUNT=0
  [ -n "$list" ] || return 0
  local n=0 left=0 waited=0 alive pid comm names=""
  # Count what is actually SIGNALLED, not what was listed: entries that died on
  # their own between snapshot and kill (the reaper's own plumbing, for one)
  # must not be reported as a reap that happened.
  while read -r pid comm; do
    [ -n "$pid" ] || continue
    comm_is "$pid" "$comm" || continue
    n=$(( n + 1 )); names="$names $pid($comm)"
    kill -TERM "$pid" 2>/dev/null
  done <<EOF
$list
EOF
  [ "$n" -gt 0 ] || return 0
  # Liveness polling is `kill -0` (a builtin, no fork); a recycled pid here only
  # costs a little patience. The SIGNALS are the ones that get the comm gate.
  while [ "$waited" -lt 20 ]; do
    alive=0
    for pid in $(printf '%s\n' "$list" | awk '{ print $1 }'); do
      kill -0 "$pid" 2>/dev/null && alive=1
    done
    [ "$alive" = "0" ] && break
    sleep 0.1
    waited=$(( waited + 1 ))
  done
  while read -r pid comm; do
    [ -n "$pid" ] || continue
    comm_is "$pid" "$comm" && kill -KILL "$pid" 2>/dev/null
  done <<EOF
$list
EOF
  sleep 0.1
  while read -r pid comm; do
    [ -n "$pid" ] || continue
    comm_is "$pid" "$comm" && left=$(( left + 1 ))
  done <<EOF
$list
EOF
  KILL_COUNT="$n"
  warn "[reap:$label] killed $n process(es):$names"
  [ "$left" = "0" ] || err "[reap:$label] $left survived SIGKILL (uninterruptible?) — re-check with --stray"
  [ "$left" = "0" ]
}

# EVERY process whose parent chain reaches any pid in ROOTS (space separated),
# as "pid comm" lines, minus anything in EXCLUDE (space separated, padded).
#
# Every process, NOT just the heavy ones — the lesson of the 2026-07-31 sweep
# kill. Reaping by name left the run's orphaned test-unit binary alive, and it
# went on spawning fresh 4.2GB `bs2 compile` children indefinitely: killing the
# compiles while leaving the thing that spawns them is not a reap. A run's
# subtree belongs to the run; when the run is over, all of it goes.
procs_under() {
  local roots=" $1 " exclude=" ${2:-} " snap
  snap="$(all_ps)"
  printf '%s\n' "$snap" | awk -v snap="$snap" -v roots="$roots" -v exclude="$exclude" '
    BEGIN { n = split(snap, lines, "\n")
            for (i = 1; i <= n; i++) { split(lines[i], f, " "); if (f[1] != "") parent[f[1]] = f[2] } }
    index(exclude, " " $1 " ") > 0 { next }
    { p = $2; hops = 0
      while (p != "" && p != "0" && p != "1" && hops < 64) {
        if (index(roots, " " p " ") > 0) { print $1, $6; break }
        p = parent[p]; hops++
      } }'
}

# Usage: --stray [--reap]
# Report every surviving heavy process with its RSS — the instrument to reach
# for before trusting ANY memory number, and after any killed run. Reaping is
# limited to processes in an ORPHANED TREE: one whose root was re-parented, so
# the run that owned it is gone. A heavy process whose tree is still ours
# belongs to a build that is still going, and killing it would be sabotage, not
# hygiene. Exit codes answer the question each form asks — reporting: 0 = no
# heavy process resident, 1 = some are (`--stray && echo clean` composes);
# reaping: 0 = no orphan left behind, 1 = one survived SIGKILL.
mode_stray() {
  local reap=0
  [ "${1:-}" = "--reap" ] && reap=1
  local annotated
  annotated="$(annotate_heavy)"
  if [ -z "$annotated" ]; then
    ok "[stray] none — no ${HEAVY_PROCS// //} process resident"
    return 0
  fi
  printf '%7s %7s %7s %10s %8s %-12s %s\n' PID PPID PGID RSS AGE STATE COMM >&2
  printf '%s\n' "$annotated" | awk '{ printf "%7s %7s %7s %9.1fM %7ss %-12s %s\n", $1, $2, $3, $4/1024, $5, $7, $6 }' >&2
  local n orphans total
  n=$(printf '%s\n' "$annotated" | wc -l | tr -d ' ')
  orphans=$(printf '%s\n' "$annotated" | awk '$7 != "live"' | wc -l | tr -d ' ')
  total=$(printf '%s\n' "$annotated" | awk '{ s += $4 } END { printf "%.1f", s/1024 }')
  warn "[stray] $n heavy process(es) resident ($orphans orphaned) holding ${total}M"
  if [ "$reap" = "1" ]; then
    local chain roots victims
    # Ancestors are spared throughout: a --stray --reap from inside a live
    # `bs2 test` must not kill the suite it is reporting to.
    chain=" $(pid_ancestry $$) "
    # The roots of the orphaned TREES, not the strays themselves. Killing an
    # orphaned run's `bs2 compile` while leaving the orphaned test binary above
    # it just gets you a fresh 4.2GB compile a second later — the whole dead
    # tree is the unit, top included.
    roots="$(printf '%s\n' "$annotated" | awk -v chain="$chain" \
      '$7 != "live" && index(chain, " " $8 " ") == 0 { print $8 }' | sort -un | tr '\n' ' ')"
    if [ -z "$roots" ]; then
      log "[stray] nothing to reap — every heavy process belongs to a live tree (a build that is still running)"
      return 0
    fi
    # The roots themselves plus everything under them.
    victims="$( { all_ps | awk -v r=" $roots" 'index(r, " " $1 " ") > 0 { print $1, $6 }'
                  procs_under "$roots" "$(pid_ancestry $$)"
                } | sort -un -k1,1)"
    kill_victims "$victims" "stray" || return 1
    ok "[stray] reaped $KILL_COUNT process(es) in $(printf '%s' "$roots" | wc -w | tr -d ' ') orphaned tree(s)"
    return 0
  fi
  log "[stray] \`diagnose.sh --stray --reap\` kills the orphaned trees whole (live builds are left alone)"
  return 1
}

# t-8rsg: the pre-commit hook's suite-input hash, centralized (rule 10).
# One hash over every input that can change a spec test's outcome: the bs2
# binary, every .av under packages/ + tests/, the C runtime + LLVM wrapper,
# this script (fixtures shell out to it), the seed, and the Makefile. Only
# the per-file DIGESTS feed the final hash (paths are dropped, then
# sorted), so the same tree hashes identically from any cwd — the hook's
# repo-root invocation matches `bs2 test`'s bootstrap-cwd one (t-kdyj.2:
# a green full `bs2 test` writes build/.tests_verified via this hash, so
# the hook skips its duplicate suite run). ROOT overrides the tree for
# spec tests; the default is the real bootstrap dir. ~0.3s warm.
test_input_hash() {
  local root="${1:-$BOOTSTRAP_DIR}"
  ( CDPATH= cd -- "$root" 2>/dev/null || exit 1
    { $SHA256_CMD build/bs2 2>/dev/null
      find packages tests -name '*.av' -type f -exec $SHA256_CMD {} + 2>/dev/null
      $SHA256_CMD runtime.c llvm_wrapper.c 2>/dev/null
      $SHA256_CMD scripts/diagnose.sh seed/seed.ll Makefile 2>/dev/null
    } | awk '{print $1}' | sort | $SHA256_CMD | awk '{print $1}'
  )
}

# pdme.7: CONCURRENCY fuzz — the parallel sibling of --cache-fuzz.
# Each round mutates the dep package, computes a reference IR via one
# cache-bypassed compile, then fans out J CONCURRENT cached compiles of
# the SAME entry (same fingerprint, same slot — the shard/pre-build
# contention shape) while a seeded chaos agent damages the live slot
# mid-flight (companion deletion / primary truncation). Invariants per
# round:
#   * every concurrent compile exits 0 (a loser of a publish race must
#     lose BENIGNLY),
#   * every worker's observed IR is byte-identical to the reference
#     (no torn, foreign, or stale bytes under contention),
#   * after one recovery compile, an identical rerun HITs — the slot
#     survived the melee (publish + wreck-repair work under load).
#
# Usage: --cache-fuzz-parallel [ROUNDS] [JOBS] [SEED]  (default 8 4 42)
mode_cache_fuzz_parallel() {
  local rounds="${1:-8}" jobs="${2:-4}" seed="${3:-42}"
  ensure_bs2
  local fuzz_root="$BUILD_DIR/cache-fuzz-par"
  cache_fuzz_mk_sandbox "$fuzz_root"
  local entry="$FUZZ_ENTRY" sib="$FUZZ_SIB" cache_dir="$FUZZ_CACHE_DIR"

  # Worker output goes to a per-worker log so a failure names its cause
  # (an opaque rc/divergence is undebuggable after the processes exit).
  # Each worker gets its OWN --output ($2): N workers contend on one
  # cache slot but never on each other's output file. A shared
  # <entry>.ll is itself a data race (GNU cp aborts with "replaced
  # while being copied" when a sibling's rename lands mid-copy — a
  # false FAIL this harness produced before --output became
  # cache-eligible; pdme.7).
  par_compile_cached() {
    local logf="${1:-/dev/null}" outf="${2:-}"
    env -u AVRA_USE_METADATA -u AVRA_LIB_OBJS -u AVRA_LIB_PKG_ROOT -u AVRA_TIMINGS \
      "$BS2" compile ${outf:+--output="$outf"} "$entry" >"$logf" 2>&1
  }

  local r="$seed" round=1 kind w pid fail
  while [ "$round" -le "$rounds" ]; do
    r=$(( (r * 1103515245 + 12345) % 2147483648 ))
    kind=$(( (r / 65536) % 3 ))   # 0 = pure contention, 1/2 = + slot damage
    printf 'export fn fuzz_value() -> int { %s }\n' "$(( r % 97 ))" > "$sib"
    env -u AVRA_USE_METADATA -u AVRA_LIB_OBJS -u AVRA_LIB_PKG_ROOT AVRA_TIMINGS=1 \
      "$BS2" compile --output="$fuzz_root/ref.ll" "$entry" >/dev/null 2>&1 \
      || die "cache-fuzz-parallel round $round: reference compile failed"

    local pids=()
    for w in $(seq 1 "$jobs"); do
      par_compile_cached "$fuzz_root/w$w.log" "$fuzz_root/w$w.ll" &
      pids+=($!)
    done
    if [ "$kind" -gt 0 ]; then
      # Chaos agent: hit the newest slot three times while workers fly.
      local i target
      for i in 1 2 3; do
        case "$kind" in
          1) target=$(ls -t "$cache_dir"/*/metadata.bin 2>/dev/null | head -1)
             [ -n "$target" ] && rm -f "$target" ;;
          2) target=$(ls -t "$cache_dir"/*/unit.ll 2>/dev/null | head -1)
             [ -n "$target" ] && : > "$target" ;;
        esac
        sleep 0.02
      done
    fi
    fail=0
    for pid in "${pids[@]}"; do wait "$pid" || fail=1; done
    if [ "$fail" != "0" ]; then
      for w in $(seq 1 "$jobs"); do
        err "worker $w output:"; tail -5 "$fuzz_root/w$w.log" >&2 2>/dev/null
      done
      die "cache-fuzz-parallel FAIL round $round (kind $kind): a concurrent cached compile exited non-zero"
    fi
    for w in $(seq 1 "$jobs"); do
      if ! cmp -s "$fuzz_root/w$w.ll" "$fuzz_root/ref.ll"; then
        err "worker $w output:"; tail -5 "$fuzz_root/w$w.log" >&2 2>/dev/null
        err "worker $w .ll: $(wc -c < "$fuzz_root/w$w.ll" 2>/dev/null) bytes vs ref $(wc -c < "$fuzz_root/ref.ll") bytes"
        die "cache-fuzz-parallel FAIL round $round (kind $kind): worker $w IR diverges from reference — concurrent cache corruption"
      fi
    done
    # Recovery compile (republishes if the chaos agent left a wreck),
    # then the liveness rerun must HIT.
    par_compile_cached || die "cache-fuzz-parallel round $round: recovery compile failed"
    env -u AVRA_USE_METADATA -u AVRA_LIB_OBJS -u AVRA_LIB_PKG_ROOT -u AVRA_TIMINGS \
        "$BS2" compile "$entry" 2>&1 >/dev/null | grep -q 'compile-cache\] hit' \
      || die "cache-fuzz-parallel FAIL round $round (kind $kind): post-melee rerun did not HIT — publish died under contention"
    round=$(( round + 1 ))
  done
  rm -rf "$fuzz_root"
  ok "cache-fuzz-parallel PASS — $rounds rounds x $jobs workers (seed $seed): no divergence, no benign-failure violations, slots survived"
}

# pdme.6: repo-wide cache GC. `bs2 cache prune` is per-project-root
# (it reads $PWD), but the heavyweight slots live in the PER-PACKAGE
# caches (packages/*/build/cache — a single std-avrac producer slot is
# ~40MB). Sweep the bootstrap root plus every package root in one go.
# ── t-2qn0: reclaim orphaned /tmp test scratch ──
# The build-cache spec tests (build/tests/*_test.av) stand up isolated PROJECT
# roots under /tmp — /tmp/avra_<probe>/ each with its own build/cache — to
# exercise cache behaviour OUTSIDE the repo tree (project-root detection,
# clean-project cache flows). They rm-rf their dir at START for a clean slate
# but not at END, so the last run's tree lingers and pid-suffixed probes leave a
# fresh tree EVERY run. A bare `bs2 compile /tmp/foo.av` likewise parks its cache
# at /tmp/build (project_dir == $PWD). Because all of this lives under /tmp,
# neither `bs2 cache prune` (per-project-root) nor `make clean` (drops
# bootstrap/build) ever reclaims it — it accrues until the fixed-allowance
# container ENOSPCs (t-2qn0). This sweep brings that scratch back under the
# disk-hygiene tooling. An mtime guard (minutes) spares scratch a CONCURRENT
# `bs2 test` is still writing to; 0 = unconditional (the explicit-wipe path).
prune_tmp_scratch() {
  local min_age="${1:-0}"
  local reclaimed=0 d list
  # `-H` follows the symlink given as the ARGUMENT (not ones found while
  # walking), which is exactly what /tmp needs: on macOS /tmp is a symlink to
  # private/tmp, so a bare `find /tmp -type d` matches NOTHING and this prune
  # silently reclaimed zero — the /tmp scratch leak this tooling exists to fix
  # went unfixed there (321 stale dirs on the box where this was found).
  # POSIX, and a no-op on Linux where /tmp is a real directory.
  if [ "$min_age" -gt 0 ]; then
    list=$(find -H /tmp -maxdepth 1 -type d \( -name 'avra_*' -o -name 'build' \) -mmin "+${min_age}" 2>/dev/null)
  else
    list=$(find -H /tmp -maxdepth 1 -type d \( -name 'avra_*' -o -name 'build' \) 2>/dev/null)
  fi
  while IFS= read -r d; do
    [ -n "$d" ] || continue
    rm -rf "$d" && reclaimed=$(( reclaimed + 1 ))
  done <<EOF
$list
EOF
  log "[tmp-scratch] reclaimed $reclaimed orphaned /tmp scratch dir(s) (min age ${min_age}m)"
}

# Usage: --prune-tmp-scratch [MIN_AGE_MINUTES]   (default 0 = unconditional)
# Standalone entry point for the /tmp reclaim above — invoked by the spec test
# (build/tests/tmp_scratch_gc_test.av) and available for manual disk recovery.
mode_prune_tmp_scratch() {
  prune_tmp_scratch "${1:-0}"
  ok "tmp-scratch prune done"
}

# t-kbqq: the ONE enumeration of every compile-cache root this tooling owns
# under ROOT. Prints the dir that CONTAINS `build/cache` (the cwd `bs2 cache
# prune` wants), one per line; SPARED notices go to stderr so the list stays
# clean for `while read`.
#
# WHY it is shared: --cache-gc and --clean-cache each carried their own root
# list, so a root could be reachable by one and invisible to the other. That is
# exactly what happened — `--emit-gen-check` compiles with cwd inside
# `build/emit_gen`, so bs2 parks a cache at `build/emit_gen/build/cache`, ONE
# LEVEL DEEPER than the `packages/*/` glob reaches. It grew to 11 GB unpruned
# while `make cache-gc` cheerfully reported "under the 12G size cap — nothing to
# evict", filled the disk, and made the next `--emit-gen-check` fail with a
# MISLEADING "generated pattern parser failed to compile/run" — an ENOSPC
# wearing a grammar regression's clothes. One list means the next scratch tree
# can't reopen the hole.
#
# The `src` sentinel (pdme.3) is applied HERE, so both consumers inherit it: a
# package literally named `src` would make the parent-of-build a source dir, and
# ad-hoc `find … -name build` one-liners have eaten those before.
cache_owner_dirs() {
  local root="${1:-$BOOTSTRAP_DIR}" d
  # The bootstrap/package roots, then the diagnose.sh SCRATCH trees under
  # build/<name>/ (emit_gen and any future sibling) — pure regenerable scratch,
  # one cold re-run to rebuild.
  for d in "$root" "$root"/packages/*/ "$root"/build/*/; do
    d="${d%/}"
    [ -d "$d/build/cache" ] || continue
    if [ "$(basename "$d")" = "src" ]; then
      log "[cache] SPARED $d/build/cache — owner is a src dir, refusing" >&2
      continue
    fi
    printf '%s\n' "$d"
  done
}

# Usage: --cache-gc [DAYS]   (default 30)
mode_cache_gc() {
  local days="${1:-30}"
  # ROOT is overridable (second positional) for the spec suite, mirroring
  # mode_clean_cache — the global budget is only observable across SEVERAL
  # roots, so its guard needs a sandbox tree it can stand up itself.
  local gc_root="${2:-$BOOTSTRAP_DIR}"
  [ -d "$gc_root" ] || die "cache-gc: no such root: $gc_root"
  # t-5kek: bound the compile cache by size so a seed-cycling session's dead
  # generations (fresh-mtime but never hit again → invisible to the age
  # prune) can't grow build/cache past the disk allowance. The age prune
  # runs first; the size cap then evicts oldest-first until under budget.
  # Override with AVRA_CACHE_MAX_MB=0 to disable, or any N to retune.
  #
  # t-tit7: the budget is GLOBAL — the total across every root from
  # cache_owner_dirs — not per-root. It used to be per-root, which cannot
  # bound the thing it exists to protect: the disk allowance is one shared
  # resource, so N roots each honestly "under the 12G cap" summed to 13G on
  # a container with 11G free and cache-gc freed NOTHING, reporting success
  # from all nine roots. The permitted ceiling was the PRODUCT (9 x 12G =
  # 108G), and it grew every time a package was added. Measured, not
  # theorised: `make cache-gc` byte-accounted at 0 bytes freed while the
  # disk was nearly full, twice in one session — the tell being that the
  # default never fired and the cap had to be hand-tuned to do anything.
  #
  # Roots shed PROPORTIONALLY to their size (each keeps the same fraction),
  # so the biggest root is not singled out and small roots aren't wiped to
  # rescue it. Ordering matters: the age prune runs over every root FIRST,
  # then totals are re-measured, because allotting against pre-age-prune
  # sizes would budget for bytes that are about to disappear anyway.
  local cap_mb="${AVRA_CACHE_MAX_MB:-12288}"
  # Validate BEFORE use. `[ "$cap_mb" -gt 0 ]` on a non-numeric value fails the
  # test (not just the comparison), so a typo like AVRA_CACHE_MAX_MB=12G would
  # silently skip the entire size pass and disable the very enforcement this
  # ticket exists to add — the same class of silent no-op, reintroduced through
  # the knob instead of the semantics. 0 stays legal: it means "no size cap".
  case "$cap_mb" in
    ''|*[!0-9]*) die "cache-gc: AVRA_CACHE_MAX_MB must be a non-negative integer (got '${cap_mb}')" ;;
  esac
  ensure_bs2
  local root roots=()
  while IFS= read -r root; do roots+=("$root"); done < <(cache_owner_dirs "$gc_root")

  # Pass 1 — age prune every root (size cap off; the global pass owns size).
  for root in "${roots[@]}"; do
    log "[cache-gc] $root"
    ( cd "$root" && "$BS2" cache prune --max_age_days="$days" --max_size_mb=0 )
  done

  # Pass 2 — the global size budget, over what the age prune left behind.
  if [ "$cap_mb" -gt 0 ]; then
    local total_mb=0 sz
    for root in "${roots[@]}"; do
      sz=$(du -sm "$root/build/cache" 2>/dev/null | cut -f1)
      total_mb=$(( total_mb + ${sz:-0} ))
    done
    if [ "$total_mb" -le "$cap_mb" ]; then
      log "[cache-gc] total cache ${total_mb}MB across ${#roots[@]} root(s) — under the ${cap_mb}MB budget, nothing to evict"
    else
      log "[cache-gc] total cache ${total_mb}MB across ${#roots[@]} root(s) exceeds the ${cap_mb}MB budget — evicting oldest-first, proportionally"
      local share
      for root in "${roots[@]}"; do
        sz=$(du -sm "$root/build/cache" 2>/dev/null | cut -f1)
        [ -n "$sz" ] && [ "$sz" -gt 0 ] || continue
        # This root's slice of the global budget. Integer division floors,
        # so the realised total lands at or just under budget, never over.
        share=$(( cap_mb * sz / total_mb ))
        # ...except a share that floors to ZERO must not be passed through:
        # --max_size_mb=0 is the DISABLED sentinel (pass 1 above relies on that
        # meaning), so a root allotted nothing would keep EVERYTHING — the exact
        # silent no-op this ticket removes, resurfacing on the small roots. It
        # bites at the caps an operator actually reaches for: at
        # AVRA_CACHE_MAX_MB=3000 on this tree the two smallest roots floor to 0.
        # 1MB is the smallest allocation the sentinel can express.
        [ "$share" -gt 0 ] || share=1
        ( cd "$root" && "$BS2" cache prune --max_age_days="$days" --max_size_mb="$share" )
      done
      # Re-measure and report the ACHIEVED total rather than assuming the
      # allotment landed. The 1MB floor means a budget below one MB per root
      # cannot be met exactly (it settles at #roots MB) — say so plainly instead
      # of printing a success line that the bytes on disk do not support.
      local after_mb=0
      for root in "${roots[@]}"; do
        sz=$(du -sm "$root/build/cache" 2>/dev/null | cut -f1)
        after_mb=$(( after_mb + ${sz:-0} ))
      done
      if [ "$after_mb" -le "$cap_mb" ]; then
        log "[cache-gc] total cache now ${after_mb}MB — within the ${cap_mb}MB budget"
      else
        log "[cache-gc] total cache now ${after_mb}MB — still over the ${cap_mb}MB budget (floor: 1MB x ${#roots[@]} root(s))"
      fi
    fi
  fi
  # Also reclaim the /tmp test scratch that escapes the per-root prune above.
  # Guard at 10m so an in-flight `bs2 test` (which touches its scratch every few
  # seconds) is spared while session-accumulated junk goes.
  prune_tmp_scratch 10
  ok "cache-gc done (max age ${days}d; mtime == last use, so only cold entries went)"
}

# pdme.3: the FULL cache wipe — the documented escape hatch when the
# age-based GC isn't enough (suspected cache corruption, forced-cold
# benchmarking). Wipes every packages/*/build/cache plus the top-level
# build/cache, and NOTHING else. The foot-gun this guards:
# packages/<pkg>/src/build/ is a SOURCE directory whose name also
# contains "build" — ad-hoc `find … -name build` one-liners have eaten
# it before. Defenses: (1) the fixed one-level glob can only match
# <root>/packages/<pkg>/build/cache; (2) a sentinel rejects any
# candidate whose package dir is literally named "src" (a
# packages/src/ package would make the glob's parent-of-build a src
# dir). Pure shell — no bs2 needed. ROOT is overridable for the spec
# suite; defaults to the bootstrap tree.
#
# pdme.5: cache observability — per-package entry counts, sizes and
# ages, plus repo totals and the cold-entry count (GC candidates).
# "Cold" = mtime older than DAYS (default 30): with pdme.6's
# mtime-as-last-use semantics (hits touch their entries), cold IS the
# orphan signal — a live fingerprint keeps getting touched, an
# orphaned one never is. Entries counted at the same granularity the
# pruner evicts: top-level fp slots wholesale, namespace dirs (meta/
# obj/ link/ _tmp/ fixture_stdout/) per-child; last/ is bookkeeping,
# not an entry. Pure shell — no bs2 needed.
#
# Usage: --cache-stats [ROOT] [DAYS]
mode_cache_stats() {
  local root="${1:-$BOOTSTRAP_DIR}" days="${2:-30}"
  [ -d "$root" ] || die "cache-stats: no such root: $root"
  local cache label size n cold total_n=0 total_cold=0
  echo "Per-package cache (entries / size / cold>${days}d):"
  for cache in "$root"/build/cache "$root"/packages/*/build/cache; do
    [ -d "$cache" ] || continue
    case "$cache" in
      "$root"/build/cache) label="(top-level)" ;;
      *) label=$(basename "$(dirname "$(dirname "$cache")")") ;;
    esac
    n=$(cache_stats_entries "$cache" | wc -l)
    cold=$(cache_stats_entries "$cache" | { local c=0 e; while IFS= read -r e; do
            [ -n "$(find "$e" -maxdepth 0 -mtime +"$days" 2>/dev/null)" ] && c=$((c+1)); done; echo "$c"; })
    size=$(du -sh "$cache" 2>/dev/null | cut -f1)
    printf '  %-14s %4d entries  %6s  cold: %d\n' "$label" "$n" "$size" "$cold"
    total_n=$(( total_n + n ))
    total_cold=$(( total_cold + cold ))
  done
  echo "Total: $total_n entries, $total_cold cold — 'make cache-gc' reclaims cold (mtime == last use; hits refresh it)"
}

# One entry path per line, at the pruner's granularity (see
# mode_cache_stats). Shared shape with `bs2 cache prune`'s
# collect_prune_candidates so counts and evictions can't drift apart.
cache_stats_entries() {
  local cache="$1" d
  for d in "$cache"/*; do
    [ -e "$d" ] || continue
    case "$(basename "$d")" in
      last|.last-gc) continue ;;
      meta|obj|link|_tmp|fixture_stdout)
        find "$d" -mindepth 1 -maxdepth 1 2>/dev/null ;;
      *) printf '%s\n' "$d" ;;
    esac
  done
}

# Usage: --clean-cache [ROOT]
mode_clean_cache() {
  local root="${1:-$BOOTSTRAP_DIR}"
  [ -d "$root" ] || die "clean-cache: no such root: $root"
  local d owner wiped=0
  # The bootstrap/package roots + the build/<scratch>/ trees, from the SHARED
  # enumeration cache-gc prunes (t-kbqq) — so the two can never disagree about
  # which caches exist. The `src` sentinel lives there.
  while IFS= read -r owner; do
    rm -rf "$owner/build/cache"
    log "[clean-cache] wiped $owner/build/cache"
    wiped=$(( wiped + 1 ))
  done < <(cache_owner_dirs "$root")
  # Legacy location: older compilers parked `bs2 compile` entries at
  # <pkg>/src/build/cache (the source-dir foot-gun); current compilers
  # cache at the package root, so anything here is unreachable junk.
  # The glob names the exact legacy dir — the .av sources that live
  # BESIDE it in src/build/ (e.g. std-avrac's build module) are not
  # touched.
  for d in "$root"/packages/*/src/build/cache; do
    [ -d "$d" ] || continue
    rm -rf "$d"
    log "[clean-cache] wiped $d (legacy compile-cache location)"
    wiped=$(( wiped + 1 ))
  done
  # A full wipe of the REAL bootstrap tree reclaims the /tmp test scratch too
  # (unconditional — the caller asked for everything cold). Gated on the default
  # root so a sandbox-root invocation (the cache spec tests pass a /tmp root)
  # cleans only that root and never sweeps sibling /tmp scratch. t-2qn0.
  if [ "$root" = "$BOOTSTRAP_DIR" ]; then
    prune_tmp_scratch 0
  fi
  ok "clean-cache: $wiped cache dir(s) wiped — next build is cold"
}

# ── ps3t.8.3 typeck collect-boundary lint ──
# The env-purity guard for the Step-B per-item typeck split. The split's
# soundness rests on one invariant, established by audit (ps3t.8.3): every
# typeck env registry — fns/structs/enums/newtypes/union_aliases via the
# `*_reg(istry)_register` helpers, plus the `trait_impls`/`assoc_type_defs`/
# `shapes` list fields — is written ONLY during the collect phase
# (`collect_decls` + `rewrite_fn_ret_tys`). The check phase reads the env and
# threads forward nothing but the diagnostic bag and depth-0 bindings, which
# is what makes `check_item` a pure fn of (env, preceding bindings, item).
# A registry write introduced inside the check phase would silently
# re-couple items order-wise — answers would drift only on programs the
# suite happens not to cover — so the boundary is enforced at the source
# level: any registry-write call/field-push whose enclosing top-level fn is
# not in the collect-phase allowlist fails the lint.
#
# F2 (uzs9.5.2): the `restore_*_reg` helpers (typeenv_cache.av) also write the
# registries, but they are collect-EQUIVALENT env construction — they REPLAY
# the same register calls from a snapshot at env-build time (before the check
# phase), never per-item during check — so they preserve the very invariant
# this lint guards (check_item stays pure over the env) and are allowlisted.
#
# $1 (optional) = typeck dir/file to scan (defaults to the real tree; the
# guard test points it at a temp dir with a planted violation). `tests/` is
# excluded — fixtures legitimately embed the anti-pattern as string literals.
mode_check_typeck_collect_boundary() {
  local target="${1:-$BOOTSTRAP_DIR/packages/std-avrac/src/typeck}"
  [ -e "$target" ] || die "check-typeck-collect-boundary: not found: $target"
  local hits=""
  while IFS= read -r f; do
    local h
    h=$(awk -v file="$f" '
      /^(export )?fn [A-Za-z_0-9]+[[:space:]]*[<(]/ {
        cur = $0
        sub(/^export /, "", cur); sub(/^fn /, "", cur); sub(/[<(].*/, "", cur)
      }
      /(fn_type_reg_register|struct_type_reg_register|enum_type_reg_register|trait_registry_register|newtype_reg_register|union_alias_reg_register)[[:space:]]*\(/ ||
      /(trait_impls|assoc_type_defs|shapes):[[:space:]]*list_push_copy[[:space:]]*\(/ {
        if (cur !~ /^(collect_decls|collect_impl_assoc_types|rewrite_fn_ret_tys|fn_type_reg_register|struct_type_reg_register|enum_type_reg_register|trait_registry_register|newtype_reg_register|union_alias_reg_register|restore_fn_reg|restore_struct_reg|restore_enum_reg|restore_newtype_reg|restore_union_reg|restore_trait_reg)$/) {
          printf "%s:%d: [in fn %s] %s\n", file, NR, cur, $0
        }
      }
    ' "$f")
    [ -n "$h" ] && hits="${hits}${h}
"
  done < <(find "$target" -name '*.av' -not -path '*/tests/*')
  if [ -n "$hits" ]; then
    err "check-typeck-collect-boundary: typeck env-registry write outside the collect phase — the Step-B per-item split (ps3t.8.3) requires ALL registry writes in collect_decls/rewrite_fn_ret_tys; a check-phase write re-couples items order-wise:"
    printf '%s' "$hits" >&2
    exit 1
  fi
  ok "check-typeck-collect-boundary: all typeck env-registry writes are confined to the collect phase (check_item stays pure over the env)"
}

# ── ps3t.4.5(d) layout-boundary lint ──
# The rep-boundary-fallback guard for the type→layout totality invariant. After
# d-4 + the total resolve_layout / resolve_layout_sized, the SOLE place an
# under-determined `.Unknown` type is mapped to an LLVM layout is `resolve_layout`,
# and only under the erased-template guard
# (`.Unknown -> if allow_unknown { ok_layout(i64t) } else { err_layout() }`).
# A direct `.Unknown -> <bare LLVM base-type ptr>` anywhere in codegen is the
# historical silent-i64-guess bug (spec §6: never guess a layout from an
# under-determined type). Crucially it BYPASSES the runtime ICE — which only
# fires *through* resolve_layout — so nothing else catches a reintroduction.
# This source lint flags exactly that anti-pattern.
#
# $1 (optional) = codegen dir to scan (defaults to the real tree; the guard test
# points it at a temp dir with a planted violation). The sanctioned guarded arm
# maps via ok_layout/err_layout (`-> if …`, never `-> <ptr>`) and non-layout arms
# map to `false`/`{}`/etc., so neither matches — zero false positives.
# t-kd4y.3.1 — the purity-ledger domain lint. Textual (like the layout
# lint) because a match fn's domain cannot be enumerated at runtime: the
# ledger lists and the central tables are adjacent string-literal sources,
# so set algebra over their extracted names IS the invariant check.
mode_check_central_domain() {
  local g="$BOOTSTRAP_DIR/packages/std-avrac/src/features/grammar"
  local ast="$g/ast.av" ex="$g/executor.av" em="$g/emit.av"
  [ -f "$ast" ] && [ -f "$ex" ] || die "check-central-domain: grammar sources not found under $g"
  local kinds='^(expr|stmt|arm|warm|sarm|pat|type|tok|toks|pentry|tparam|field|variant|finit|ccfg|cpair|cslot|ccfgs|cslots|ann)$'
  local scratch
  scratch=$(mktemp -d)
  # shellcheck disable=SC2064
  trap "rm -rf '$scratch'" RETURN
  awk '/^export fn central_build_kind/,/^}/' "$ast" | grep -oE '"[A-Za-z_]+"' | tr -d '"' | grep -vE "$kinds" | sort -u > "$scratch/table"
  awk '/^export fn engine_core_builds/,/^}/' "$ast" | grep -oE '"[A-Za-z_]+"' | tr -d '"' | sort -u > "$scratch/core"
  awk '/^export fn unflipped_builds/,/^}/' "$ast" | grep -oE '"[A-Za-z_]+"' | tr -d '"' | sort -u > "$scratch/unflipped"
  awk '/^export fn central_tableless_builds/,/^}/' "$ast" | grep -oE '"[A-Za-z_]+"' | tr -d '"' | sort -u > "$scratch/tableless"
  # engine-core can never be empty (the DSL mechanism itself); the unflipped
  # list CAN — that is the t-kd4y.3 endpoint (drain complete) — so for it we
  # require only that the fn exists, not that names were extracted.
  [ -s "$scratch/core" ] || die "check-central-domain: engine_core_builds missing/empty in ast.av"
  grep -q '^export fn unflipped_builds' "$ast" || die "check-central-domain: unflipped_builds fn missing in ast.av"
  sort -u "$scratch/core" "$scratch/unflipped" > "$scratch/ledger"
  # executor central arm heads — both the args-guarded and the bare shapes
  grep -oE '^[[:space:]]*"[A-Za-z_]+" (if args\.length|->)' "$ex" | grep -oE '"[A-Za-z_]+"' | tr -d '"' | sort -u > "$scratch/exec"
  local bad=0
  local overlap; overlap=$(comm -12 "$scratch/core" "$scratch/unflipped")
  if [ -n "$overlap" ]; then err "check-central-domain: engine-core ∩ unflipped must be empty:"; printf '%s\n' "$overlap" >&2; bad=1; fi
  local unledgered; unledgered=$(comm -23 "$scratch/table" "$scratch/ledger")
  if [ -n "$unledgered" ]; then err "check-central-domain: central_build_kind rows with NO classification — add each to engine_core_builds (never-spelled DSL mechanism, documented) or unflipped_builds (feature-owned, with its family ticket):"; printf '%s\n' "$unledgered" >&2; bad=1; fi
  local ghost; ghost=$(comm -13 "$scratch/table" "$scratch/ledger")
  if [ "$ghost" != "$(cat "$scratch/tableless")" ]; then
    err "check-central-domain: ledgered-but-tableless set drifted from central_tableless_builds — a flip removed a table row without updating the ledger (or vice versa). Expected exactly:"; cat "$scratch/tableless" >&2; err "got:"; printf '%s\n' "$ghost" >&2; bad=1
  fi
  local unclassified_arms; unclassified_arms=$(comm -23 "$scratch/exec" "$scratch/ledger" | comm -23 - "$scratch/table")
  if [ -n "$unclassified_arms" ]; then err "check-central-domain: executor central arms with NO ledger classification:"; printf '%s\n' "$unclassified_arms" >&2; bad=1; fi
  local n
  for n in $(cat "$scratch/tableless"); do
    grep -q "\"$n\"" "$ex" "$em" || { err "check-central-domain: tableless name '$n' has no executor/emit arm — stale ledger entry"; bad=1; }
  done
  # `return`, not `exit`: exit would bypass the RETURN trap and leak the
  # scratch dir; main's case dispatch is the script's last act, so the
  # failure status propagates to the CLI unchanged (CodeRabbit, #1263).
  [ "$bad" = 0 ] || return 1
  ok "check-central-domain: central surface exactly classified — $(wc -l < "$scratch/core") engine-core (DSL mechanism) + $(wc -l < "$scratch/unflipped") unflipped (feature-owned; 0 = the t-kd4y.3 drain is complete)"
}

mode_check_layout_boundary() {
  local cg="${1:-$BOOTSTRAP_DIR/packages/std-avrac/src/codegen}"
  [ -d "$cg" ] || die "check-layout-boundary: dir not found: $cg"
  # `--exclude-dir=tests`: the invariant governs codegen SOURCE, not fixtures.
  # Test files legitimately embed the anti-pattern as a string literal (e.g. this
  # lint's own guard test plants `.Unknown -> i64t` to prove the check fires), so
  # scanning them would flag the fixtures, not real regressions.
  local hits
  hits=$(grep -rnE --exclude-dir=tests '\.Unknown[[:space:]]*->[[:space:]]*(i64t|i1t|dt|pt|i8t|i16t|i32t|self\.(i64|i1|i8|i16|i32|double|ptr)_type)\b' "$cg" || true)
  if [ -n "$hits" ]; then
    err "check-layout-boundary: silent .Unknown→layout fallback reintroduced — route it through resolve_layout (which errors/ICEs on an under-determined type), never map .Unknown straight to an LLVM type (spec §6, ps3t.4.5(d)):"
    printf '%s\n' "$hits" >&2
    exit 1
  fi
  ok "check-layout-boundary: no silent .Unknown→layout fallback in $cg (resolve_layout is the sole under-determined-type gate)"
}

# ── t-xkcw checkless-PR lint ──
# Every gate (bootstrap-window, diff-test, rc-strict, seed-train-verify) is
# filtered to PRs based on the integration branch, so a STACKED PR — which the
# PR-slice workflow mandates — matches none of them and runs no check at all.
# An empty checks list is not "nothing failed", it is "nothing ran", and the
# standing merge authorization ("CI green AND CodeRabbit approved") reads the
# two the same way. stacked-pr.yml is the complement that turns that silence
# into a red check.
#
# The invariant: EVERY possible PR base is covered by at least one workflow.
# That holds iff the union of the gates' `branches:` allowlists is exactly the
# guard's `branches-ignore:` list — subset one way means a base the guard skips
# and no gate claims (checkless again), subset the other means a base that
# trips the guard while its real gates are also running. So the lint asserts
# set EQUALITY, which fails if the guard is deleted, if its ignore-list is
# narrowed, or if a gate is added/retargeted without updating it.
#
# $1 (optional) = workflows dir to scan (defaults to the real one; the guard
# test points it at temp dirs holding planted violations).
# ── t-bw9s: no DEAD parser routing flag may be pinned anywhere ────────────────
#
# `AVRA_PARSER_DECL_FLIP` outlived the field it switched. Nothing read it, so pinning
# it selected nothing — but it sat in four `PARSER_MODE_*` strings, in CLAUDE.md's
# parser table as "the HAND parser — the oracle", and in 14 test files building a
# `..._hand` mode out of it. Each read as a routing choice and made none, which is the
# worst kind of measurement: it succeeds, it looks authoritative, and it compares a
# path against itself.
#
# The general invariant, so the next flag to die cannot repeat it: every `AVRA_PARSER_*`
# name pinned in a mode string must be one the compiler actually reads.
mode_check_parser_flags() {
  local src="$REPO_DIR/bootstrap/packages/std-avrac/src"
  [ -d "$src" ] || src="$REPO_DIR/packages/std-avrac/src"
  [ -d "$src" ] || die "check-parser-flags: cannot locate compiler src"
  local dsh="$REPO_DIR/bootstrap/scripts/diagnose.sh"
  [ -f "$dsh" ] || dsh="$REPO_DIR/scripts/diagnose.sh"

  # The routing names this lint governs. AVRA_NO_STATIC_FALLBACK is in scope because it
  # is the same kind of switch and died the same way (t-47hc.4.3 removed the interpreter
  # re-parse fallback); scoping the lint to `AVRA_PARSER_*` alone let a second dead pin
  # sit in fn_where_clause_native_test.av untouched while the lint reported all-clear.
  # GROUPED deliberately: alternation binds looser than concatenation in BRE, so an
  # ungrouped `A\|B` used as "$pat=[01]" attaches the `=[01]` to B alone and A then
  # matches a bare mention — every prose reference to a flag got reported as a pin.
  local pat='\(AVRA_PARSER_[A-Z][A-Z_]*\|AVRA_NO_STATIC_FALLBACK\)'
  local read_names used_names dead=0 n

  # READS come from PRODUCTION sources only. Scanning *_test.av here would let a
  # test-only `avra_process_env_get("AVRA_X")` vouch for a dead `AVRA_X=0` pin in the
  # same tree — the lint would confirm a flag against itself, which is precisely the
  # circularity it exists to break. Comment lines are excluded for the same reason: a
  # commented-out read is not a read.
  # Strip from `//` to end of line BEFORE extracting, so a trailing comment cannot
  # donate a read: `fn r() {} // avra_process_env_get("AVRA_PARSER_MASKED")` used to
  # register MASKED as live and thereby vouch for a dead pin of the same name. Leading
  # `//` alone was never the whole comment surface.
  #
  # Stripping can only ever REMOVE a candidate read, so its failure direction is a flag
  # reported dead while live — loud and immediately visible — never the silent reverse.
  # Strip comments OUTSIDE string literals only. `sed 's|//.*||'` was wrong in a way
  # that matters: `let u = "http://x"` truncates at the `//` inside the literal, so a
  # live `avra_process_env_get` later on that line vanishes and its flag is reported
  # dead. Quote-aware, backslash-escape-aware, handling `//` and `#` in one pass.
  _cpf_strip_comments() {
    awk '{
      out = ""; ins = 0; i = 1; n = length($0)
      while (i <= n) {
        c = substr($0, i, 1)
        if (ins) {
          if (c == "\\") { out = out c substr($0, i + 1, 1); i += 2; continue }
          if (c == "\"") { ins = 0 }
          out = out c; i++; continue
        }
        if (c == "\"") { ins = 1; out = out c; i++; continue }
        if (c == "#") { break }
        if (c == "/" && substr($0, i + 1, 1) == "/") { break }
        out = out c; i++
      }
      print out
    }'
  }
  read_names=$(grep -rh "avra_process_env_get(\"$pat\")" "$src" --include='*.av' \
      --exclude='*_test.av' 2>/dev/null \
    | _cpf_strip_comments \
    | grep -o "avra_process_env_get(\"$pat\")" \
    | sed 's/.*("//; s/").*//' | sort -u)
  [ -n "$read_names" ] || die "check-parser-flags: found no routing env reads in production sources — the lint would pass vacuously"

  # COMMENTS are exempt: prose that explains why a flag died (or pins a known vacuity,
  # as error_recovery_differential_test.av does) is exactly what should be written down.
  # Only a live PIN — a flag set on a real command line — can mislead a measurement.
  _cpf_pins() { _cpf_strip_comments | grep -o "$pat=[01]"; }
  used_names=$( { grep -rh "$pat=[01]" "$src" --include='*_test.av' 2>/dev/null
                  grep -h "$pat=[01]" "$dsh" 2>/dev/null; } \
    | _cpf_pins | sed 's/=[01]$//' | sort -u)

  for n in $used_names; do
    if ! printf '%s\n' "$read_names" | grep -qx "$n"; then
      err "check-parser-flags: DEAD flag pinned but never read by the compiler: $n"
      { grep -rn "$n=[01]" "$src" --include='*_test.av' 2>/dev/null
        grep -n "$n=[01]" "$dsh" 2>/dev/null; } \
        | grep -v '//.*'"$n" | grep -v '#.*'"$n" | head -5 | sed 's/^/    /'
      dead=$((dead + 1))
    fi
  done

  [ "$dead" -eq 0 ] || die "check-parser-flags: $dead dead parser flag(s) pinned — a pin that selects nothing is a measurement that proves nothing"
  ok "check-parser-flags: every pinned routing flag is read by production compiler sources ($(printf '%s\n' "$read_names" | grep -c .) live name(s))"
}

# True when a workflow's `push` trigger can fire from INTEGRATION_BRANCH — the
# branch this repo's workflow files actually live on. Unfiltered push fires
# everywhere; `branches` must list a matching pattern; `branches-ignore` must NOT
# match. Patterns go through `case`, so GitHub's `*` / `**` globs work (bash `*`
# spans `/`, which is deliberately the permissive reading: this feeds a HARD
# error, and a lint that guesses wrong should err toward staying quiet).
push_fires_here() {
  local out="$1" pat allow ignore
  printf '%s\n' "$out" | grep -qx 'PUSH' || return 1
  allow=$(printf '%s\n' "$out" | sed -n 's/^PUSHALLOW //p')
  ignore=$(printf '%s\n' "$out" | sed -n 's/^PUSHIGNORE //p')
  if [ -n "$allow" ]; then
    while IFS= read -r pat; do
      [ -n "$pat" ] || continue
      # shellcheck disable=SC2254  # glob patterns are the point
      case "$INTEGRATION_BRANCH" in $pat) return 0 ;; esac
    done <<EOF
$allow
EOF
    return 1
  fi
  if [ -n "$ignore" ]; then
    while IFS= read -r pat; do
      [ -n "$pat" ] || continue
      # shellcheck disable=SC2254
      case "$INTEGRATION_BRANCH" in $pat) return 1 ;; esac
    done <<EOF
$ignore
EOF
  fi
  return 0
}

mode_check_ci_gates() {
  local wf="${1:-$REPO_DIR/.github/workflows}"
  [ -d "$wf" ] || die "check-ci-gates: dir not found: $wf"

  # Emits, per file: `PR` if a pull_request trigger exists, then `ALLOW <b>` /
  # `IGNORE <b>` per base branch in its branches / branches-ignore filter.
  # Indentation-relative (not hardcoded 2/4 spaces) so a reformat can't turn
  # the lint into a check that silently passes, and it reads both the inline
  # flow list (`[a, b]`) and the block list (`- a`) YAML spellings.
  local extract='
    function emit(k, v) {
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", v)
      # \047 (octal) not \x27: POSIX defines the octal escape, hex is a
      # gawk/mawk extension — the lint must not depend on which awk is installed.
      gsub(/^["\047]|["\047]$/, "", v)
      if (v == "") return
      # `ev` is the enclosing event (awk globals): pull_request filters keep the
      # bare ALLOW/IGNORE names the coverage proof below reads, push filters get
      # their own so a push that cannot fire here is distinguishable from one
      # that can.
      if (ev == "push") {
        if (k == "branches")        print "PUSHALLOW " v
        else if (k == "branches-ignore") print "PUSHIGNORE " v
        return
      }
      if (k == "branches")        print "ALLOW " v
      else if (k == "branches-ignore") print "IGNORE " v
    }
    function ind(s,   i) { i = match(s, /[^ ]/); return (i == 0 ? -1 : i - 1) }
    BEGIN { inon = 0; evind = -1; ev = ""; key = ""; keyind = -1 }
    {
      line = $0; sub(/\r$/, "", line)
      if (line ~ /^[[:space:]]*#/ || line ~ /^[[:space:]]*$/) next
      i = ind(line)
      if (i == 0) {
        inon = (line ~ /^("on"|on):/)
        if (inon) {
          evind = -1; ev = ""; key = ""; keyind = -1
          # Shorthand spellings: `on: pull_request` and `on: [push, pull_request]`.
          # Neither form can carry a branches filter, so a match here is an
          # UNFILTERED pull_request trigger — it fires on EVERY base. Emitting
          # bare `PR` (no ALLOW/IGNORE) drops it into the unfiltered violation
          # below, instead of the file being skipped as if it had no trigger.
          # Token-exact so `pull_request_target` does not match.
          rest = line; sub(/^[^:]*:[[:space:]]*/, "", rest)
          sub(/[[:space:]]+#.*$/, "", rest)
          gsub(/^\[|\]$/, "", rest)
          n = split(rest, parts, /,/)
          for (j = 1; j <= n; j++) {
            v = parts[j]
            gsub(/^[[:space:]]+|[[:space:]]+$/, "", v)
            gsub(/^["\047]|["\047]$/, "", v)
            if (v == "pull_request") print "PR"
            if (v == "schedule") print "SCHED"
            if (v == "push") print "PUSH"
          }
        }
        next
      }
      if (!inon) next
      if (evind < 0) evind = i
      if (i == evind) {
        ev = line; sub(/^[ ]*/, "", ev); sub(/:.*$/, "", ev)
        key = ""; keyind = -1
        if (ev == "pull_request") print "PR"
        if (ev == "schedule") print "SCHED"
        if (ev == "push") print "PUSH"
        next
      }
      if (ev != "pull_request" && ev != "push") next
      if (keyind >= 0 && i > keyind) {
        if (line ~ /^[[:space:]]*-/) { v = line; sub(/^[[:space:]]*-[[:space:]]*/, "", v); emit(key, v) }
        next
      }
      key = line; sub(/^[ ]*/, "", key); sub(/:.*$/, "", key); keyind = i
      rest = line; sub(/^[^:]*:[[:space:]]*/, "", rest); sub(/[[:space:]]+#.*$/, "", rest)
      if (rest != "") {
        sub(/^\[/, "", rest); sub(/\]$/, "", rest)
        n = split(rest, parts, /,/)
        for (j = 1; j <= n; j++) emit(key, parts[j])
      }
    }'

  local allows="" ignores="" guards=0 guard_files="" unfiltered="" scheduled="" f out a g
  for f in "$wf"/*.yml "$wf"/*.yaml; do
    [ -e "$f" ] || continue
    out=$(awk "$extract" "$f")
    # Collected before the pull_request filter below: such a workflow has NO
    # pull_request trigger by definition, which is exactly why it would
    # otherwise fall straight through this lint.
    #
    # Only workflows that CANNOT FIRE AT ALL from where they live are flagged:
    # `schedule` with no usable push and no pull_request. A dormant `schedule`
    # sitting alongside a working push trigger is legitimate (it starts
    # contributing if the file ever reaches the default branch), so flagging that
    # would be noise — and noise in a lint is how the next real one gets ignored.
    #
    # A push trigger only counts when it can actually match the branch these
    # workflows live on. `push: branches: [main]` emits PUSH but fires from a
    # branch whose tree has no workflow file, so it is exactly as inert as the
    # bare `schedule` this check exists to catch — accepting it would reopen the
    # hole one level up.
    if printf '%s\n' "$out" | grep -qx 'SCHED' \
       && ! printf '%s\n' "$out" | grep -qx 'PR' \
       && ! push_fires_here "$out"; then
      scheduled="$scheduled$(basename "$f")"$'\n'
    fi
    printf '%s\n' "$out" | grep -qx 'PR' || continue
    a=$(printf '%s\n' "$out" | sed -n 's/^ALLOW //p')
    g=$(printf '%s\n' "$out" | sed -n 's/^IGNORE //p')
    if [ -z "$a" ] && [ -z "$g" ]; then
      unfiltered="$unfiltered  $(basename "$f")"$'\n'
      continue
    fi
    [ -n "$a" ] && allows="$allows$a"$'\n'
    if [ -n "$g" ]; then
      guards=$((guards + 1))
      guard_files="$guard_files  $(basename "$f")"$'\n'
      ignores="$ignores$g"$'\n'
    fi
  done

  if [ -n "$unfiltered" ]; then
    err "check-ci-gates: pull_request workflow with no base-branch filter — its scope is implicit, so the guard's complement can't be verified (t-xkcw):"
    printf '%s' "$unfiltered" >&2
    exit 1
  fi
  if [ "$guards" -eq 0 ]; then
    err "check-ci-gates: no checkless-PR guard — every gate filters to a base allowlist, so a PR based anywhere else (a stacked slice) runs NO check and its empty checks list reads as green (t-xkcw). Restore .github/workflows/stacked-pr.yml (pull_request + branches-ignore)."
    exit 1
  fi
  if [ "$guards" -gt 1 ]; then
    err "check-ci-gates: $guards workflows use branches-ignore — the complement is ambiguous, so coverage can't be proven. Keep exactly one guard:"
    printf '%s' "$guard_files" >&2
    exit 1
  fi

  local allow_set ignore_set
  allow_set=$(printf '%s' "$allows" | sort -u)
  ignore_set=$(printf '%s' "$ignores" | sort -u)
  if [ "$allow_set" != "$ignore_set" ]; then
    err "check-ci-gates: the guard's branches-ignore is not the exact complement of the gates' branches allowlists, so some PR base is either checkless or double-covered (t-xkcw)."
    printf 'gates allow:\n%s\nguard ignores:\n%s\n' "$allow_set" "$ignore_set" >&2
    exit 1
  fi
  if ! printf '%s\n' "$allow_set" | grep -qx -- "$INTEGRATION_BRANCH"; then
    err "check-ci-gates: no gate covers the integration branch ($INTEGRATION_BRANCH) — a PR into it would be checked only by the stacked-PR guard, which always fails."
    exit 1
  fi

  # A `schedule` trigger fires ONLY from the default branch. Every workflow here
  # lives on the integration branch, so a scheduled workflow is INERT unless it
  # is also on the default branch — it never runs, reports nothing, and its
  # silence reads exactly like a passing detector (t-kdyj.4: the uzs9.2
  # interleaving detector shipped this way and accrued zero samples while its
  # ticket planned to read future quiet as evidence the flake class was dead).
  #
  # FAIL CLOSED: presence on the default branch must be positively demonstrated.
  # An unresolvable ref is NOT a pass — "I could not check" and "it is fine" are
  # the distinction this whole class of bug lives in.
  if [ -n "$scheduled" ]; then
    local dref="" cand
    for cand in "origin/$DEFAULT_BRANCH" "$DEFAULT_BRANCH"; do
      if git -C "$REPO_DIR" rev-parse --verify -q "$cand^{commit}" >/dev/null 2>&1; then dref="$cand"; break; fi
    done
    if [ -z "$dref" ]; then
      err "check-ci-gates: cannot verify scheduled workflow(s) — no ref for the default branch '$DEFAULT_BRANCH' (tried origin/$DEFAULT_BRANCH and $DEFAULT_BRANCH)."
      err "  A scheduled workflow runs ONLY from the default branch, so this cannot be assumed. Fetch it (git fetch origin $DEFAULT_BRANCH) or set AVRA_DEFAULT_BRANCH."
      printf '%s' "$scheduled" | sed 's/^/  /' >&2
      exit 1
    fi
    local missing="" wfrel base
    wfrel=${wf#"$REPO_DIR"/}
    while IFS= read -r base; do
      [ -n "$base" ] || continue
      git -C "$REPO_DIR" cat-file -e "$dref:$wfrel/$base" 2>/dev/null || missing="$missing  $base"$'\n'
    done <<EOF
$scheduled
EOF
    if [ -n "$missing" ]; then
      err "check-ci-gates: scheduled workflow(s) absent from the default branch ($dref) — their \`schedule\` trigger NEVER fires, so they gate nothing and their silence is indistinguishable from success (t-kdyj.4):"
      printf '%s' "$missing" >&2
      err "  Fix: put the workflow on the default branch (checking out the intended ref explicitly), or give it a trigger that fires from the branch it lives on (push/pull_request)."
      exit 1
    fi
  fi

  ok "check-ci-gates: every PR base is covered — gates allowlist [$(printf '%s' "$allow_set" | tr '\n' ' ')], guard covers the rest$([ -n "$scheduled" ] && printf '; %s scheduled workflow(s) present on %s' "$(printf '%s' "$scheduled" | grep -c .)" "$dref")"
}

main() {
  if [ $# -eq 0 ]; then print_help; exit 0; fi
  local mode="$1"; shift
  case "$mode" in
    --help|-h)            print_help ;;
    --build)              mode_build "$@" ;;
    --build-runtime)      mode_build_runtime "$@" ;;
    --build-bs2)          mode_build_bs2 "$@" ;;
    --ensure-bs2)         mode_ensure_bs2 "$@" ;;
    --build-O0)           mode_build_O0 "$@" ;;
    --build-debug)        mode_build_debug "$@" ;;
    --build-bs2-asan)     mode_build_bs2_asan "$@" ;;
    --build-bs3)          mode_build_bs3 "$@" ;;
    --check-fixedpoint)   mode_check_fixedpoint "$@" ;;
    --run)                mode_run "$@" ;;
    --emit-regen-parsers) mode_emit_regen_parsers "$@" ;;
    --emit-regen-lex)     mode_emit_regen_lex "$@" ;;
    --emit-regen-kw)      mode_emit_regen_kw "$@" ;;
    --emit-regen-run)     mode_emit_regen_run "$@" ;;
    --lexer-bench)        mode_lexer_bench "$@" ;;
    --emit-gen-check)     mode_emit_gen_check "$@" ;;
    --bs2-stale-check)    mode_bs2_stale_check "$@" ;;
    --bs2-stale-report)   mode_bs2_stale_report "$@" ;;
    --rc-strict-suite)    mode_rc_strict_suite "$@" ;;
    --link-run)           mode_link_run "$@" ;;
    --check)              mode_check "$@" ;;
    --ll)                 mode_ll "$@" ;;
    --diff)               mode_diff "$@" ;;
    --diff-fn)            mode_diff_fn "$@" ;;
    --diff-test)          mode_diff_test "$@" ;;
    --parser-probe)       mode_parser_probe "$@" ;;
    --parser-tree)        mode_parser_tree "$@" ;;
    --score)              mode_score "$@" ;;
    --rank)               mode_rank "$@" ;;
    --asan)               mode_asan "$@" ;;
    --malloc-trace)       mode_malloc_trace "$@" ;;
    --bisect-lines)       mode_bisect_lines "$@" ;;
    --seed-status)        mode_seed_status "$@" ;;
    --seed-diff)          mode_seed_diff "$@" ;;
    --build-seed)         ensure_seed; ok "$SEED_BIN" ;;
    --update-seed)        mode_update_seed "$@" ;;
    --verify-seed)        mode_verify_seed "$@" ;;
    --seed-patch)         mode_seed_patch "$@" ;;
    --seed-sigs)          mode_seed_sigs "$@" ;;
    --seed-fetch)         mode_seed_fetch "$@" ;;
    --seed-fetch-from)    fetch_seed_from_lock "$@" ;;
    --write-seed-lock)    write_seed_lock "$@" ;;
    --seed-publish)       mode_seed_publish "$@" ;;
    --seed-train)         mode_seed_train "$@" ;;
    --seed-train-verify)  mode_seed_train_verify "$@" ;;
    --seed-verify-fp)     mode_seed_verify_fp "$@" ;;
    --seed-canonical-sha) seed_canonical_sha "$@" ;;
    --seed-inputs-hash)   seed_inputs_hash "$@" ;;
    --seed-self-contained) seed_is_self_contained "$@" ;;
    --check-bootstrap-window) mode_check_bootstrap_window "$@" ;;
    --check-central-domain) mode_check_central_domain "$@" ;;
    --check-layout-boundary) mode_check_layout_boundary "$@" ;;
    --check-parser-flags) mode_check_parser_flags "$@" ;;
    --check-ci-gates)     mode_check_ci_gates "$@" ;;
    --check-typeck-collect-boundary) mode_check_typeck_collect_boundary "$@" ;;
    --seed-merge)         mode_seed_merge "$@" ;;
    --seed-merge-classify) seed_merge_classify "$@" ;;
    --slot-exec)          mode_slot_exec "$@" ;;
    --slot-fuzz)          mode_slot_fuzz "$@" ;;
    --cache-fuzz)         mode_cache_fuzz "$@" ;;
    --test-input-hash)    test_input_hash "$@" ;;
    --print-compile-slots) _default_compile_slots ;;
    --stray)              mode_stray "$@" ;;
    --prune-tmp-scratch)  mode_prune_tmp_scratch "$@" ;;
    --cache-gc)           mode_cache_gc "$@" ;;
    --cache-stats)        mode_cache_stats "$@" ;;
    --clean-cache)        mode_clean_cache "$@" ;;
    --cache-fuzz-parallel) mode_cache_fuzz_parallel "$@" ;;
    *) err "unknown mode: $mode"; print_help; exit 1 ;;
  esac
}

# Copy current bs2 IR output to seed/seed.ll with provenance metadata.
# Prepends a comment with commit hash, timestamp, and source directory hash.
mode_update_seed() {
  local src_ir="$SRC_DIR/main.av.ll"
  [ -f "$src_ir" ] || die "no IR found at $src_ir — run --build-bs2 first"

  cp "$src_ir" "$SEED_LL"

  # Prepend provenance comment
  local commit timestamp src_hash
  commit=$(git -C "$BOOTSTRAP_DIR" rev-parse --short HEAD 2>/dev/null || echo "unknown")
  timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  src_hash=$(find "$SRC_DIR" -name '*.av' -exec $SHA256_CMD {} + | $SHA256_CMD | cut -d' ' -f1)

  {
    printf '; seed built from commit %s at %s\n' "$commit" "$timestamp"
    printf '; source hash: %s\n' "$src_hash"
    cat "$SEED_LL"
  } > "${SEED_LL}.tmp" && mv "${SEED_LL}.tmp" "$SEED_LL"

  # The chokepoint for every seed write (train, seed-merge, manual
  # `make update-seed`): a seed that leaves package symbols as extern
  # `declare`s (a metadata fast-path build) can't bootstrap a fresh
  # clone. Refuse to write one rather than pin a brick downstream.
  seed_is_self_contained "$SEED_LL" \
    || die "refusing to write a non-self-contained seed: $SEED_LL references extern package symbols (rebuild with the metadata fast-path disabled — the seed must define every symbol it uses)"

  rm -f "$SEED_BIN" "$BUILD_DIR/seed.o"
  ok "seed/seed.ll updated ($(wc -l < "$SEED_LL" | tr -d ' ') lines)"
  log "provenance: commit=$commit time=$timestamp src_hash=${src_hash:0:16}..."
}

# Show what's in the seed vs the current source — functions added, removed,
# changed. This is the first thing to check when a build fails.
mode_seed_status() {
  [ -f "$SEED_LL" ] || die "no seed found"

  # Compile current source with the seed (without linking) to get fresh IR
  ensure_seed
  log "compiling source with seed to compare..."
  if ! "$SEED_BIN" compile "$SRC_DIR/main.av" >/dev/null 2>&1; then
    err "seed cannot compile current source — seed is too old"
    return 1
  fi

  local fresh_ir="$SRC_DIR/main.av.ll"
  [ -f "$fresh_ir" ] || die "no IR produced"

  local seed_fn_count fresh_fn_count
  seed_fn_count=$(grep -c '^define ' "$SEED_LL")
  fresh_fn_count=$(grep -c '^define ' "$fresh_ir")

  local seed_fns fresh_fns
  seed_fns=$(grep '^define ' "$SEED_LL" | sed 's/define [^ ]* @//' | sed 's/(.*//' | sort)
  fresh_fns=$(grep '^define ' "$fresh_ir" | sed 's/define [^ ]* @//' | sed 's/(.*//' | sort)

  echo "Seed: $seed_fn_count functions ($(wc -l < "$SEED_LL" | tr -d ' ') lines)"
  echo "Fresh: $fresh_fn_count functions ($(wc -l < "$fresh_ir" | tr -d ' ') lines)"
  echo ""

  # New functions (in source but not seed)
  local new_fns
  new_fns=$(comm -13 <(echo "$seed_fns") <(echo "$fresh_fns"))
  if [ -n "$new_fns" ]; then
    local count; count=$(echo "$new_fns" | wc -l | tr -d ' ')
    printf "${C_GREEN}+ %s new functions:${C_RESET}\n" "$count"
    echo "$new_fns" | while read -r fn; do
      printf "  ${C_GREEN}+ %s${C_RESET}\n" "$fn"
    done
    echo ""
  fi

  # Removed functions (in seed but not source)
  local removed_fns
  removed_fns=$(comm -23 <(echo "$seed_fns") <(echo "$fresh_fns"))
  if [ -n "$removed_fns" ]; then
    local count; count=$(echo "$removed_fns" | wc -l | tr -d ' ')
    printf "${C_RED}- %s removed functions:${C_RESET}\n" "$count"
    echo "$removed_fns" | while read -r fn; do
      printf "  ${C_RED}- %s${C_RESET}\n" "$fn"
    done
    echo ""
  fi

  # Changed functions (different line count)
  local common_fns changed=0
  common_fns=$(comm -12 <(echo "$seed_fns") <(echo "$fresh_fns"))
  local changed_list=""
  for fn in $common_fns; do
    local seed_lines fresh_lines
    seed_lines=$(sed -n "/^define.*@${fn}(/,/^}/p" "$SEED_LL" 2>/dev/null | wc -l | tr -d ' ')
    fresh_lines=$(sed -n "/^define.*@${fn}(/,/^}/p" "$fresh_ir" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$seed_lines" != "$fresh_lines" ]; then
      changed=$((changed + 1))
      changed_list="${changed_list}  ~ ${fn} (${seed_lines} → ${fresh_lines} lines)\n"
    fi
  done
  if [ "$changed" -gt 0 ]; then
    printf "${C_YELLOW}~ %s changed functions:${C_RESET}\n" "$changed"
    printf "$changed_list"
    echo ""
  fi

  if [ -z "$new_fns" ] && [ -z "$removed_fns" ] && [ "$changed" -eq 0 ]; then
    ok "seed is up to date — no differences"
  fi
}

# Show a per-function diff between seed IR and fresh-compiled IR.
mode_seed_diff() {
  local fn_name="${1:-}"
  [ -f "$SEED_LL" ] || die "no seed found"

  ensure_seed
  if ! "$SEED_BIN" compile "$SRC_DIR/main.av" >/dev/null 2>&1; then
    die "seed cannot compile current source"
  fi

  local fresh_ir="$SRC_DIR/main.av.ll"
  if [ -n "$fn_name" ]; then
    # Diff a specific function. Handles both bare names (@foo) and
    # qualified names (@"core::names::foo"). Matches any function
    # whose name ENDS with the given string.
    local seed_fn fresh_fn
    seed_fn=$(awk "/^define.*${fn_name}\"?\\(/{found=1} found{print} found&&/^\\}/{exit}" "$SEED_LL")
    fresh_fn=$(awk "/^define.*${fn_name}\"?\\(/{found=1} found{print} found&&/^\\}/{exit}" "$fresh_ir")
    if [ -z "$seed_fn" ]; then
      warn "function '$fn_name' not found in seed — it may be new"
      if [ -n "$fresh_fn" ]; then
        echo "$fresh_fn" | head -20
      fi
      return
    fi
    if [ -z "$fresh_fn" ]; then
      warn "function '$fn_name' not found in fresh IR — it was removed"
      return
    fi
    diff --color=always <(echo "$seed_fn") <(echo "$fresh_fn") || true
  else
    # Overview: just count differences
    mode_seed_status
  fi
}

# Verify the bootstrap chain integrity WITHOUT auto-cycling.
# This is a strict check: build seed → bs2, verify bs2 self-compiles,
# verify the resulting binary can also self-compile. No recovery attempts.
mode_verify_seed() {
  log "step 1/4: building seed binary from seed/seed.ll"
  ensure_seed
  ok "seed binary built"

  log "step 2/4: compiling main.av with seed → bs2"
  # Force a fresh bs2 build
  rm -f "$BS2"
  if ! "$SEED_BIN" compile "$SRC_DIR/main.av" >"$BUILD_DIR/verify_bs2.log" 2>&1; then
    cat "$BUILD_DIR/verify_bs2.log" >&2
    die "FAIL: seed cannot compile current source"
  fi
  link_ll "$SRC_DIR/main.av.ll" "$BS2" "$BUILD_DIR/verify_bs2_link.log"
  ok "bs2 built from seed"

  log "step 3/4: verifying bs2 can compile main.av"
  if ! "$BS2" compile "$SRC_DIR/main.av" >"$BUILD_DIR/verify_bs2_self.log" 2>&1; then
    cat "$BUILD_DIR/verify_bs2_self.log" >&2
    die "FAIL: bs2 cannot self-compile (seed is stale or source has breaking changes)"
  fi
  ok "bs2 self-compile succeeded"

  log "step 4/4: linking and verifying bs3 can compile main.av"
  link_ll "$SRC_DIR/main.av.ll" "$BS3" "$BUILD_DIR/verify_bs3_link.log"
  if ! "$BS3" compile "$SRC_DIR/main.av" >"$BUILD_DIR/verify_bs3_self.log" 2>&1; then
    cat "$BUILD_DIR/verify_bs3_self.log" >&2
    die "FAIL: bs3 cannot self-compile (bootstrap chain is broken at generation 3)"
  fi
  ok "bs3 self-compile succeeded"

  ok "seed verification passed — full bootstrap chain is healthy"
}

# Incremental seed update: compile source with bs2, diff per-function against
# seed, copy new IR to seed, and report exactly which functions changed.
# Faster than 'make update-seed' because it skips the verification rebuild.
mode_seed_patch() {
  ensure_bs2

  log "compiling main.av with bs2 for incremental seed update"
  if ! "$BS2" compile "$SRC_DIR/main.av" >/dev/null 2>&1; then
    die "bs2 cannot compile main.av — fix errors first"
  fi

  local new_ir="$SRC_DIR/main.av.ll"
  [ -f "$new_ir" ] || die "no IR produced at $new_ir"
  [ -f "$SEED_LL" ] || die "no seed found at $SEED_LL"

  # Use python3 to do per-function diffing (awk would be fragile for
  # multiline function bodies with metadata references).
  local result
  result=$(python3 -c "
import re, sys

def extract_functions(path):
    \"\"\"Extract function name -> body text from LLVM IR.\"\"\"
    fns = {}
    current_name = None
    current_lines = []
    with open(path) as f:
        for line in f:
            if line.startswith('define '):
                m = re.search(r'@\"?([^\"(]+)\"?\(', line)
                if m:
                    current_name = m.group(1)
                    current_lines = [line]
            elif current_name is not None:
                current_lines.append(line)
                if line.rstrip() == '}':
                    fns[current_name] = ''.join(current_lines)
                    current_name = None
                    current_lines = []
    return fns

old_fns = extract_functions('$SEED_LL')
new_fns = extract_functions('$new_ir')

added = sorted(set(new_fns) - set(old_fns))
removed = sorted(set(old_fns) - set(new_fns))
common = set(old_fns) & set(new_fns)
changed = sorted(n for n in common if old_fns[n] != new_fns[n])

total_new = len(new_fns)
total_changed = len(added) + len(removed) + len(changed)

if total_changed == 0:
    print('UNCHANGED')
    sys.exit(0)

# Print report
if added:
    print(f'ADDED:{len(added)}')
    for n in added[:20]:
        print(f'  + {n}')
    if len(added) > 20:
        print(f'  ... and {len(added)-20} more')

if removed:
    print(f'REMOVED:{len(removed)}')
    for n in removed[:20]:
        print(f'  - {n}')
    if len(removed) > 20:
        print(f'  ... and {len(removed)-20} more')

if changed:
    print(f'CHANGED:{len(changed)}')
    for n in changed[:30]:
        old_lines = old_fns[n].count('\n')
        new_lines = new_fns[n].count('\n')
        delta = new_lines - old_lines
        sign = '+' if delta > 0 else '' if delta < 0 else '='
        print(f'  ~ {n} ({old_lines} -> {new_lines} lines, {sign}{delta})')
    if len(changed) > 30:
        print(f'  ... and {len(changed)-30} more')

print(f'TOTAL:{total_changed}/{total_new}')
") || die "per-function diff failed"

  if [ "$result" = "UNCHANGED" ]; then
    ok "seed is already up to date (0 functions changed)"
    return
  fi

  # Print the diff report
  echo "$result" | while IFS= read -r line; do
    case "$line" in
      ADDED:*)   printf "${C_GREEN}%s new functions${C_RESET}\n" "${line#ADDED:}" ;;
      REMOVED:*) printf "${C_RED}%s removed functions${C_RESET}\n" "${line#REMOVED:}" ;;
      CHANGED:*) printf "${C_YELLOW}%s changed functions${C_RESET}\n" "${line#CHANGED:}" ;;
      TOTAL:*)
        local nums="${line#TOTAL:}"
        local diff_count="${nums%%/*}"
        local fn_total="${nums##*/}"
        printf "\n${C_BLUE}Summary: %s of %s functions differ${C_RESET}\n" "$diff_count" "$fn_total"
        ;;
      "  + "*)    printf "  ${C_GREEN}%s${C_RESET}\n" "${line#  }" ;;
      "  - "*)    printf "  ${C_RED}%s${C_RESET}\n" "${line#  }" ;;
      "  ~ "*)    printf "  ${C_YELLOW}%s${C_RESET}\n" "${line#  }" ;;
      "  ..."*)   printf "  ${C_DIM}%s${C_RESET}\n" "${line#  }" ;;
      *)          echo "$line" ;;
    esac
  done

  # Copy new IR to seed with provenance
  cp "$new_ir" "$SEED_LL"

  local commit timestamp src_hash
  commit=$(git -C "$BOOTSTRAP_DIR" rev-parse --short HEAD 2>/dev/null || echo "unknown")
  timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  src_hash=$(find "$SRC_DIR" -name '*.av' -exec $SHA256_CMD {} + | $SHA256_CMD | cut -d' ' -f1)

  {
    printf '; seed built from commit %s at %s\n' "$commit" "$timestamp"
    printf '; source hash: %s\n' "$src_hash"
    cat "$SEED_LL"
  } > "${SEED_LL}.tmp" && mv "${SEED_LL}.tmp" "$SEED_LL"

  # Invalidate cached seed binary so next build uses new seed
  rm -f "$SEED_BIN" "$BUILD_DIR/seed.o"

  ok "seed/seed.ll updated ($(wc -l < "$SEED_LL" | tr -d ' ') lines)"
  log "provenance: commit=$commit time=$timestamp"
}

# Compare function signatures between seed IR and source .av files.
# Catches the most common seed staleness issue: parameter count changes.
mode_seed_sigs() {
  [ -f "$SEED_LL" ] || die "no seed found at $SEED_LL"

  local tmpdir
  tmpdir=$(mktemp -d)
  trap "rm -rf $tmpdir" EXIT

  # Extract seed function signatures: "bare_name param_count full_name"
  # from define lines. Handles both @bare_name( and @"mod::name"( forms.
  # For qualified names like "core::scanner::advance", the bare_name is
  # "advance" (last segment after ::) so it can match source fn names.
  grep '^define ' "$SEED_LL" | while IFS= read -r line; do
    # Extract full function name
    local full_name bare_name
    if echo "$line" | grep -q '@"'; then
      full_name=$(echo "$line" | sed 's/.*@"\([^"]*\)".*/\1/')
    else
      full_name=$(echo "$line" | sed 's/.*@\([^(]*\)(.*/\1/')
    fi
    # Strip module prefix for matching: "core::scanner::advance" → "advance"
    bare_name=$(echo "$full_name" | sed 's/.*:://')
    # Count parameters by counting % sigils in the parameter list
    local param_str count
    param_str=$(echo "$line" | sed 's/[^(]*(\([^)]*\)).*/\1/')
    count=$(echo "$param_str" | grep -o '%' | wc -l | tr -d ' ')
    echo "$bare_name $count $full_name"
  done | sort -k1,1 > "$tmpdir/seed_sigs.txt"

  # Extract source function signatures from .av files.
  # Matches: fn name(...) and export fn name(...)
  # Counts parameters by counting commas + 1 (if non-empty param list).
  find "$SRC_DIR" -name '*.av' -print0 | xargs -0 grep -h '^\(export \)\{0,1\}fn ' | \
    sed 's/^export //' | while IFS= read -r line; do
    # Extract function name
    local name
    name=$(echo "$line" | sed 's/^fn \([a-zA-Z_][a-zA-Z0-9_]*\).*/\1/')
    # Extract parameter list (between first parens)
    local params
    params=$(echo "$line" | sed 's/[^(]*(\([^)]*\)).*/\1/' | sed 's/[[:space:]]//g')
    if [ -z "$params" ]; then
      echo "$name 0"
    else
      local count
      count=$(echo "$params" | tr ',' '\n' | wc -l | tr -d ' ')
      echo "$name $count"
    fi
  done | sort -k1,1 -u > "$tmpdir/src_sigs.txt"

  # Build lookup: bare_name → (seed_count, full_name)
  # seed_sigs.txt has: bare_name param_count full_name
  # src_sigs.txt has: name param_count
  local seed_names src_names
  seed_names=$(awk '{print $1}' "$tmpdir/seed_sigs.txt" | sort -u)
  src_names=$(awk '{print $1}' "$tmpdir/src_sigs.txt" | sort -u)

  # Functions with different parameter counts
  local mismatches=0
  local mismatch_list=""
  local common_fns
  common_fns=$(comm -12 <(echo "$seed_names") <(echo "$src_names"))
  for fn in $common_fns; do
    local seed_count src_count full_name
    seed_count=$(grep "^${fn} " "$tmpdir/seed_sigs.txt" | head -1 | awk '{print $2}')
    full_name=$(grep "^${fn} " "$tmpdir/seed_sigs.txt" | head -1 | awk '{print $3}')
    src_count=$(grep "^${fn} " "$tmpdir/src_sigs.txt" | head -1 | awk '{print $2}')
    if [ -n "$seed_count" ] && [ -n "$src_count" ] && [ "$seed_count" != "$src_count" ]; then
      mismatches=$((mismatches + 1))
      local display_name="$fn"
      # Show qualified name if different from bare name
      if [ "$full_name" != "$fn" ]; then
        display_name="$fn ($full_name)"
      fi
      mismatch_list="${mismatch_list}$(printf "  ${C_RED}! %-50s seed=%s  src=%s${C_RESET}\n" "$display_name" "$seed_count" "$src_count")\n"
    fi
  done

  # New functions (in source but not seed)
  local new_fns
  new_fns=$(comm -13 <(echo "$seed_names") <(echo "$src_names"))
  local new_count=0
  if [ -n "$new_fns" ]; then
    new_count=$(echo "$new_fns" | wc -l | tr -d ' ')
  fi

  # Removed functions (in seed but not source)
  local removed_fns
  removed_fns=$(comm -23 <(echo "$seed_names") <(echo "$src_names"))
  local removed_count=0
  if [ -n "$removed_fns" ]; then
    removed_count=$(echo "$removed_fns" | wc -l | tr -d ' ')
  fi

  # Print report
  local seed_total src_total
  seed_total=$(wc -l < "$tmpdir/seed_sigs.txt" | tr -d ' ')
  src_total=$(wc -l < "$tmpdir/src_sigs.txt" | tr -d ' ')
  echo "Seed functions: $seed_total (unique bare names: $(echo "$seed_names" | wc -l | tr -d ' '))"
  echo "Source functions: $src_total"
  echo ""

  if [ "$mismatches" -gt 0 ]; then
    printf "${C_RED}PARAMETER COUNT MISMATCHES: %s${C_RESET}\n" "$mismatches"
    printf "$mismatch_list"
    echo ""
  fi

  if [ "$new_count" -gt 0 ]; then
    printf "${C_GREEN}+ %s new functions (in source, not in seed):${C_RESET}\n" "$new_count"
    echo "$new_fns" | head -20 | while read -r fn; do
      printf "  ${C_GREEN}+ %s${C_RESET}\n" "$fn"
    done
    if [ "$new_count" -gt 20 ]; then
      printf "  ${C_DIM}... and %s more${C_RESET}\n" "$((new_count - 20))"
    fi
    echo ""
  fi

  if [ "$removed_count" -gt 0 ]; then
    printf "${C_YELLOW}- %s removed functions (in seed, not in source):${C_RESET}\n" "$removed_count"
    echo "$removed_fns" | head -20 | while read -r fn; do
      # Show the full qualified name from the seed
      local full_name
      full_name=$(grep "^${fn} " "$tmpdir/seed_sigs.txt" | head -1 | awk '{print $3}')
      if [ "$full_name" != "$fn" ]; then
        printf "  ${C_YELLOW}- %s (%s)${C_RESET}\n" "$fn" "$full_name"
      else
        printf "  ${C_YELLOW}- %s${C_RESET}\n" "$fn"
      fi
    done
    if [ "$removed_count" -gt 20 ]; then
      printf "  ${C_DIM}... and %s more${C_RESET}\n" "$((removed_count - 20))"
    fi
    echo ""
  fi

  if [ "$mismatches" -eq 0 ] && [ "$new_count" -eq 0 ] && [ "$removed_count" -eq 0 ]; then
    ok "seed signatures match source — no mismatches"
  elif [ "$mismatches" -gt 0 ]; then
    warn "parameter count mismatches may cause silent corruption — consider updating the seed"
    return 1
  else
    ok "no parameter count mismatches (new/removed functions are expected during development)"
  fi
}

# ─────────────────────────────────────────────────────────────────────
# Staging-pipeline helpers (shared by the bootstrap window + seed merge)
# ─────────────────────────────────────────────────────────────────────

# llc -O2 the IR at $1 into the object $2, link it with the C runtime
# objects into the binary $3 (atomic .tmp+mv); all tool stderr goes to
# the log $4. Returns 1 on llc failure, 2 on link failure — callers
# own the user-facing message for each.
llc_link_bin() {
  local ll="$1" obj="$2" out="$3" buildlog="$4"
  # $5/$6 override the C runtime objects — the window gate links
  # against objects compiled from HEAD's C sources, not the dev tree's.
  local runtime_o="${5:-$RUNTIME_O}" wrapper_o="${6:-$LLVM_WRAPPER_O}"
  "$LLC" -O2 $LLC_RELOC -filetype=obj "$ll" -o "$obj" 2>"$buildlog" || return 1
  cc -o "$out.tmp" "$obj" "$runtime_o" "$wrapper_o" \
    $STACK_LDFLAGS $EXPORT_DYNAMIC $LD_SELECT -L"$LLVM_PREFIX/lib" -lLLVM $CXXLIB 2>>"$buildlog" \
    || { rm -f "$out.tmp"; return 2; }
  mv "$out.tmp" "$out"
}

# Materialize the seed pinned by a git tree-ish at $2. $1 is a ref
# ("origin/main", a sha) or an index stage (":2" / ":3"); $3 is
# scratch space for an extracted lock file. Prefers a tracked seed.ll
# blob (pre-lock history), else fetches + verifies per that tree's
# seed.lock. Returns non-zero (dest removed) when the tree pins no
# seed or the fetch fails.
materialize_treeish_seed() {
  local spec="$1" dest="$2" locktmp="$3"
  if git -C "$REPO_DIR" show "$spec:bootstrap/seed/seed.ll" > "$dest" 2>/dev/null; then
    return 0
  fi
  if git -C "$REPO_DIR" show "$spec:bootstrap/seed/seed.lock" > "$locktmp" 2>/dev/null; then
    fetch_seed_from_lock "$locktmp" "$dest" && return 0
    rm -f "$dest"
    return 1
  fi
  rm -f "$dest"
  err "'$spec' has neither bootstrap/seed/seed.ll nor bootstrap/seed/seed.lock"
  return 1
}

# Run a compile with the test runner's metadata fast-path env stripped.
# The staging pipelines must see the source as a fresh clone would —
# inherited producer objects could alias the very mismatch these
# checks exist to surface.
hermetic_compile_env() {
  env -u AVRA_USE_METADATA -u AVRA_LIB_OBJS -u AVRA_LIB_PKG_ROOT \
      -u AVRA_DIR_MODULE -u AVRA_COMPILER "$@"
}

# ─────────────────────────────────────────────────────────────────────
# Bootstrap window
# ─────────────────────────────────────────────────────────────────────

# The seed-train rule: feature branches never cycle the seed — the
# integration branch advances it in dedicated `chore(seed): cycle`
# commits, serialized after merges land. Two gates enforce it:
#
#   1. seed-train — no commit on this branch (since the merge-base
#      with the integration branch) CHANGES the pinned seed content.
#   2. window     — the branch's compiler source builds from the
#      integration branch's CURRENT pristine seed, in an isolated
#      copy of the source tree with a cold unit cache, and the
#      produced compiler passes a smoke compile+run.
#
# Any two branches that pass both gates are compilable by the same
# seed BY CONSTRUCTION, so the "no seed can compile the union" merge
# state (the 2026-06-11 incident) becomes unrepresentable. See
# docs/SEED_MERGES.md and CLAUDE.md "Bootstrap window & seed train".
#
# The window build is isolated on purpose: the dev unit cache keys
# entries on (entry fingerprint + compiler hash) but not transitive
# sources, so compiling in-tree could spuriously reuse a cached
# main.av.ll and mask a real violation — and would poison the dev
# caches with stage-binary artifacts. A cold tree has neither problem.

# Echo the integration ref to verify against: refresh origin/<branch>
# (best-effort — offline falls back to the last fetched state) and
# prefer it over a local branch of the same name.
window_resolve_integration_ref() {
  git -C "$REPO_DIR" fetch --quiet origin "$INTEGRATION_BRANCH" 2>/dev/null || true
  if git -C "$REPO_DIR" rev-parse --verify --quiet "origin/$INTEGRATION_BRANCH" >/dev/null; then
    echo "origin/$INTEGRATION_BRANCH"
  elif git -C "$REPO_DIR" rev-parse --verify --quiet "$INTEGRATION_BRANCH" >/dev/null; then
    echo "$INTEGRATION_BRANCH"
  else
    die "cannot resolve integration branch '$INTEGRATION_BRANCH' (set AVRA_INTEGRATION_BRANCH or pass a ref)"
  fi
}

# Gate 1: no commit on this branch changes the pinned seed content.
# File touches alone aren't the crime — the vendored→pinned migration
# deletes seed.ll and adds a lock pinning byte-identical content, so
# the effective seed sha256 is compared across the range before
# rejecting. Returns 1 on a violation (message printed).
window_gate_seed_train() {
  local ref="$1" head_sha="$2" ref_sha="$3"
  local cur_branch
  cur_branch=$(git -C "$REPO_DIR" rev-parse --abbrev-ref HEAD)
  if [ "$cur_branch" = "$INTEGRATION_BRANCH" ] || [ "$head_sha" = "$ref_sha" ]; then
    log "on the integration branch — seed-train gate not applicable (seed cycles live here)"
    return 0
  fi
  local mb offenders
  mb=$(git -C "$REPO_DIR" merge-base "$head_sha" "$ref_sha") \
    || die "no merge-base between HEAD and $ref — wrong integration branch?"
  offenders=$(git -C "$REPO_DIR" log --format='  %h %s' "$mb..$head_sha" -- \
    bootstrap/seed/seed.ll bootstrap/seed/seed.lock)
  if [ -n "$offenders" ]; then
    local head_seed mb_seed
    head_seed=$(ref_seed_sha256 "$head_sha")
    mb_seed=$(ref_seed_sha256 "$mb")
    if [ -n "$head_seed" ] && [ "$head_seed" = "$mb_seed" ]; then
      log "seed pin commits found but the pinned content is unchanged (vendored→pinned migration)"
      offenders=""
    fi
  fi
  if [ -n "$offenders" ]; then
    err "SEED-TRAIN VIOLATION — feature branches never cycle the seed"
    err "commits changing the seed pin (seed.ll / seed.lock) since the merge-base with $ref:"
    printf '%s\n' "$offenders" >&2
    err ""
    err "Fix: drop/revert the seed change and stop dogfooding post-seed features in"
    err "compiler src — seed advancement happens on '$INTEGRATION_BRANCH' only, as"
    err "dedicated 'chore(seed): cycle' commits after merges land. To restore:"
    err "  git checkout $ref -- bootstrap/seed/seed.lock   # (seed.ll on pre-lock history)"
    err "(CLAUDE.md 'Bootstrap window & seed train'; bootstrap/docs/SEED_MERGES.md)"
    return 1
  fi
  ok "seed-train gate — no seed cycles on this branch"
  if ! git -C "$REPO_DIR" diff --quiet HEAD -- bootstrap/seed/seed.lock bootstrap/seed/seed.ll 2>/dev/null; then
    warn "working-tree seed pin differs from HEAD (auto-cycle debris?) — do NOT commit it;"
    warn "restore with: git checkout HEAD -- bootstrap/seed/"
  fi
}

# The gate verifies HEAD, not the working tree: a push ships commits,
# so an untracked scratch file must not fail it and an uncommitted fix
# must not green it (CI checks out exactly this state). One pathspec
# drives the source list, the tree copy, and the dirty-tree warning.
WINDOW_SRC_PATHS=(bootstrap/packages 'bootstrap/*.toml' bootstrap/runtime.c bootstrap/llvm_wrapper.c)

# Echo "blob-sha path" lines for the compiler-relevant sources at
# commit $1. Git already knows the blob hashes, so this is one
# subprocess instead of re-hashing ~500 files.
window_src_list() {
  git -C "$REPO_DIR" ls-tree -r "$1" --format='%(objectname) %(path)' -- \
      "${WINDOW_SRC_PATHS[@]}" \
    | LC_ALL=C sort
}

# Echo the verify-cache fingerprint for commit $2: integration seed
# identity + the blob-sha/path line of every compiler-relevant source.
# Paths stay in the hash — a rename-only change alters module
# resolution and must not reuse a stale PASS marker. Test files are
# excluded: main.av's import graph never reaches */tests/*, so
# test-only commits must not bust the cache.
window_fingerprint() {
  local seed_id="$1" commit="$2"
  { echo "seed:$seed_id"
    window_src_list "$commit" | grep -v '/tests/'
  } | $SHA256_CMD | awk '{print $1}'
}

# Copy the compiler sources AT COMMIT $2 into $1/tree so the window
# compile sees exactly what a push ships, starts from a cold unit
# cache, and writes nothing into the dev tree.
window_copy_tree() {
  local win="$1" commit="$2"
  rm -rf "$win/tree"
  mkdir -p "$win/tree"
  git -C "$REPO_DIR" archive "$commit" -- "${WINDOW_SRC_PATHS[@]}" \
    | tar -xf - -C "$win/tree" \
    || die "source-tree copy failed"
  # git archive preserves symlinks; one pointing outside the tree
  # would make the compile read content that is NOT in HEAD, breaking
  # the gate's whole claim. No legitimate compiler source is a
  # symlink — refuse outright.
  local links
  links=$(find "$win/tree" -type l | head -5)
  [ -z "$links" ] || die "symlinked compiler sources are not supported by the gate:
$links"
}

# Compile HEAD's C runtime inputs from the copied tree into
# window-local objects (flags mirror ensure_runtime /
# ensure_llvm_wrapper). The gate must link the C code that ships, not
# whatever the dev tree currently holds.
window_c_objects() {
  local win="$1"
  cc -c $RUNTIME_OPT -g -o "$win/runtime.o" "$win/tree/bootstrap/runtime.c" \
    || die "window runtime.c compile failed"
  cc -c -O2 -I"$LLVM_PREFIX/include" -o "$win/llvm_wrapper.o" "$win/tree/bootstrap/llvm_wrapper.c" \
    || die "window llvm_wrapper.c compile failed"
}

# Echo the path of a stage binary built from the integration seed at
# $2/seed.ll, linked against the window-local C objects. Reuses the
# dev build/seed when its full input fingerprint (seed IR + C inputs)
# matches; otherwise builds (and caches) a window-local one.
window_stage_binary() {
  local ref="$1" win="$2" ref_sha="$3"
  local win_seed_fp
  win_seed_fp=$(seed_inputs_hash "$win/seed.ll" \
    "$win/tree/bootstrap/runtime.c" "$win/tree/bootstrap/llvm_wrapper.c")
  if [ -x "$SEED_BIN" ] && [ "$(cat "$BUILD_DIR/.seed_hash" 2>/dev/null)" = "$win_seed_fp" ]; then
    log "integration seed is byte-identical to the local build/seed — reusing it"
    echo "$SEED_BIN"
    return 0
  fi
  local stage_bin="$win/seed_bin"
  if [ "$(cat "$win/.stage_fp" 2>/dev/null)" = "$win_seed_fp" ] && [ -x "$stage_bin" ]; then
    log "window stage binary cached for this integration seed"
    echo "$stage_bin"
    return 0
  fi
  log "building stage binary from the integration seed ($ref @ ${ref_sha:0:12})"
  case $(llc_link_bin "$win/seed.ll" "$win/seed.o" "$stage_bin" "$win/stage.build.log" \
           "$win/runtime.o" "$win/llvm_wrapper.o"; echo $?) in
    0) : ;;
    1) err "llc rejected the INTEGRATION seed itself — integration-side problem,"
       err "not a window violation. Check $ref's seed health (make verify-seed there)."
       tail -5 "$win/stage.build.log" >&2
       return 1 ;;
    *) cat "$win/stage.build.log" >&2; die "window stage link failed" ;;
  esac
  printf '%s' "$win_seed_fp" > "$win/.stage_fp"
  echo "$stage_bin"
}

# Compile + run a small program with the compiler $2 (scratch dir $1)
# and verify its output, proving the compiler is not garbage. Used by
# the window gate on the window-built compiler and by --seed-publish
# on the stage binary of the seed about to become the pin.
smoke_test_compiler() {
  local win="$1" bs2w="$2" runtime_o="${3:-}" wrapper_o="${4:-}"
  cat > "$win/smoke.av" <<'SMOKE'
type Pair = { a: int, b: int }

enum Shape {
    Dot,
    Wide(w: int),
}

fn add(a: int, b: int) -> int { a + b }

fn main() -> int {
    let xs = [1, 2, 3]
    mut sum = 0
    for x in xs { sum = sum + x }
    let tag = if sum == 6 { "ok" } else { "bad" }
    let double = (n: int) -> n * 2
    let p = Pair { a: double(sum), b: xs[1] }
    let shape_w = match Shape.Wide(p.a + p.b) {
        .Dot -> 0
        .Wide(w) -> w
    }
    println("window-smoke ${tag} ${string(add(shape_w, 4))}")
    0
}
SMOKE
  hermetic_compile_env "$bs2w" compile "$win/smoke.av" >"$win/smoke.compile.log" 2>&1 \
    || { tail -10 "$win/smoke.compile.log" >&2; die "window-built compiler failed to compile the smoke program"; }
  llc_link_bin "$win/smoke.av.ll" "$win/smoke.o" "$win/smoke.bin" "$win/smoke.build.log" \
      ${runtime_o:+"$runtime_o"} ${wrapper_o:+"$wrapper_o"} \
    || { cat "$win/smoke.build.log" >&2; die "smoke build failed"; }
  local smoke_out
  smoke_out=$("$win/smoke.bin")
  if [ "$smoke_out" != "window-smoke ok 18" ]; then
    err "window-built compiler produced a broken binary — smoke output was:"
    printf '  %s\n' "$smoke_out" >&2
    err "expected: window-smoke ok 18"
    return 1
  fi
}

mode_check_bootstrap_window() {
  local ref="${1:-}"
  [ -n "$ref" ] || ref=$(window_resolve_integration_ref) || return 1
  local head_sha ref_sha
  head_sha=$(git -C "$REPO_DIR" rev-parse HEAD) || die "not a git checkout"
  ref_sha=$(git -C "$REPO_DIR" rev-parse "$ref^{commit}") || die "cannot resolve ref '$ref'"

  window_gate_seed_train "$ref" "$head_sha" "$ref_sha" || return 1

  local win="$BUILD_DIR/window"
  mkdir -p "$win"
  local seed_id
  seed_id=$(ref_seed_sha256 "$ref")
  [ -n "$seed_id" ] || die "$ref has neither bootstrap/seed/seed.ll nor bootstrap/seed/seed.lock"

  # The gate verifies HEAD — what a push actually ships. Warn when the
  # working tree diverges so a manual run isn't mistaken for a verdict
  # on uncommitted work.
  if [ -n "$(git -C "$REPO_DIR" status --porcelain -- "${WINDOW_SRC_PATHS[@]}" 2>/dev/null | head -1)" ]; then
    warn "compiler sources in the working tree differ from HEAD — the gate verifies HEAD (commit first)"
  fi

  local fp marker="$win/.window_verified"
  fp=$(window_fingerprint "$seed_id" "$head_sha")
  if [ "${AVRA_FORCE_WINDOW:-0}" != "1" ] && [ -f "$marker" ] \
     && [ "$(cat "$marker" 2>/dev/null)" = "$fp" ]; then
    ok "bootstrap window cached — integration seed + compiler sources unchanged since last verify"
    return 0
  fi

  # One window build at a time: a pre-push hook, a manual run and a
  # local CI rehearsal share build/window/, and a concurrent rm -rf of
  # the tree mid-compile produces garbage verdicts. mkdir is the
  # atomic test-and-set (macOS ships no flock); a pid file lets a
  # crashed holder's lock be reaped instead of wedging the gate.
  local gate_lock="$win/.lock"
  while ! mkdir "$gate_lock" 2>/dev/null; do
    local owner; owner=$(cat "$gate_lock/pid" 2>/dev/null)
    if [ -n "$owner" ] && ! kill -0 "$owner" 2>/dev/null; then
      rm -rf "$gate_lock"
      continue
    fi
    log "another window verify is running (pid ${owner:-?}) — waiting"
    sleep 2
  done
  echo $$ > "$gate_lock/pid"
  trap 'rm -rf "$BUILD_DIR/window/.lock"' EXIT

  # The wait may have outlasted the other run — its green marker is
  # ours to reuse.
  if [ "${AVRA_FORCE_WINDOW:-0}" != "1" ] && [ -f "$marker" ] \
     && [ "$(cat "$marker" 2>/dev/null)" = "$fp" ]; then
    ok "bootstrap window cached — verified by a concurrent run"
    return 0
  fi

  materialize_treeish_seed "$ref" "$win/seed.ll" "$win/integration.seed.lock" \
    || die "cannot materialize the integration seed"

  log "copying HEAD's compiler sources into an isolated tree"
  window_copy_tree "$win" "$head_sha"
  local entry="$win/tree/bootstrap/packages/cli/src/main.av"
  [ -f "$entry" ] || die "copied tree is missing $entry"
  window_c_objects "$win"

  local stage_bin
  stage_bin=$(window_stage_binary "$ref" "$win" "$ref_sha") || return 1

  log "compiling HEAD's compiler source with the integration seed"
  if ! hermetic_compile_env "$stage_bin" compile "$entry" >"$win/compile.log" 2>&1; then
    err "BOOTSTRAP WINDOW VIOLATION — compiler source does not build from the integration seed"
    err "The branch dogfoods syntax/enum-variants newer than '$INTEGRATION_BRANCH''s seed"
    err "(or depends on a local seed cycle that never happened on the train)."
    err ""
    err "Fix: keep the new feature's implementation, but remove its USE from compiler"
    err "src until the feature lands and the integration seed advances past it"
    err "(CLAUDE.md Phase A/B discipline). Compile log (excerpt):"
    tail -15 "$win/compile.log" >&2
    err "full log: $win/compile.log"
    return 1
  fi

  log "linking the window-built compiler"
  llc_link_bin "$entry.ll" "$win/bs2w.o" "$win/bs2w" "$win/bs2w.build.log" \
      "$win/runtime.o" "$win/llvm_wrapper.o" \
    || { cat "$win/bs2w.build.log" >&2; die "window compiler build failed"; }

  log "smoke-testing the window-built compiler"
  smoke_test_compiler "$win" "$win/bs2w" "$win/runtime.o" "$win/llvm_wrapper.o" || return 1

  printf '%s' "$fp" > "$marker"
  ok "bootstrap window holds — HEAD's source builds + runs from $ref's pristine seed"
}

# ─────────────────────────────────────────────────────────────────────
# Differential-test harness (HRN) — old compiler is the oracle
# ─────────────────────────────────────────────────────────────────────
#
# Build the compiler at TWO refs — OLD (the oracle baseline) and NEW (the
# candidate) — and assert they emit BYTE-IDENTICAL IR for the same inputs:
# the whole compiler source (the selfhost differential) plus a corpus of
# .av programs. A behaviour-preserving change keeps every output identical;
# a divergence prints a readable per-input diff and exits non-zero. This is
# the go-hard safety net of spine doc sec 8: rip the foundation
# out and instantly catch behaviour drift, with no migration scaffolding.
#
# Both compilers build from the SAME pinned seed — the seed-train invariant
# (enforced by --check-bootstrap-window) guarantees a feature branch's seed
# equals the integration seed — so any IR difference is attributable to
# compiler SOURCE alone, never the seed. Builds are isolated (cold unit
# cache, like the window gate) and cached on a (seed + compiler-source)
# fingerprint, so a re-run with an unchanged base/HEAD is cheap.
#
# Why byte-identical IR is the oracle: the toolchain is deterministic (the
# selfhost fixed point already relies on bs2 and bs3 emitting identical IR),
# so identical IR ⇒ identical object ⇒ identical run-results by construction.
# IR equality is therefore the strict superset of the "binary / test-results"
# checks. When a future refactor changes IR *legitimately* (e.g. SSA
# renumbering) the divergence surfaces here for a human to confirm against
# results — exactly the "byte-identical IR where applicable" of sec 8.
#
# The corpus is the CURATED standalone set (bootstrap/tests/difftest_corpus/
# *.av): small, single-file, feature-diverse programs that compile with a bare
# `bs2 compile`. The selfhost pass is the comprehensive oracle; the corpus is
# the surgical complement — a divergence in (say) channel or match codegen
# surfaces against a ~20-line file instead of bisecting the ~590k-line selfhost
# IR. It is NOT the test-harness suite (tests/*.av): those need @std + the
# spec/given/then runtime, so OLD cannot compile them standalone — every one
# would be skipped after a doomed ~1s compile, leaving the corpus phase with
# ZERO real comparisons (the bug this default fixed).
#
# The selfhost profile decides whether OLD and NEW can run concurrently;
# `--output` keeps their IR files independent when it admits both. The corpus
# has its own smaller profile. The selfhost and corpus PHASES are still
# sequential, but the corpus is tiny (~13 files) so overlapping them across
# phases would save a rounding error, not the builds.
#
# Usage / knobs:
#   --base <ref>            OLD/oracle ref     (default: integration branch)
#   --new  <ref>            NEW/candidate ref  (default: HEAD)
#   --new-prebuilt          reuse the warm build/bs2 as NEW instead of building
#                           it in isolation — skips the dominant ~5-7 min cold
#                           rebuild. LOCAL convenience only: NON-HERMETIC (the
#                           binary's seed/source aren't pinned); CI never uses it.
#   DIFF_TEST_CORPUS=<glob> corpus inputs  (default: tests/difftest_corpus/*.av)
#   resource profile        derives selfhost/corpus width from `bs2 resources`
#                           and the named work's conservative first-run seed;
#                           cgroup and macOS limits share this one boundary.
#   AVRA_FORCE_DIFFTEST=1   ignore the per-ref compiler build cache
#
# Memory safety needs no knob (t-kdyj): each compile self-bounds via the
# runtime's compile slot gate under pressure. DIFF_TEST_JOBS survives only
# as an internal hook (corpus fan-out width; 1 also serializes the two
# selfhost compiles) — not needed for a normal run on any box.

DIFFTEST_DIR="$BUILD_DIR/difftest"

# Build the compiler from git ref $1 into dir $2 (isolated + cached),
# reusing the bootstrap-window primitives. Produces $2/bs2 plus $2/tree
# (the ref's compiler sources) and $2/{runtime,llvm_wrapper}.o.
dt_build_compiler() {
  local ref="$1" out="$2"
  local ref_sha; ref_sha=$(git -C "$REPO_DIR" rev-parse "$ref^{commit}") \
    || die "diff-test: cannot resolve ref '$ref'"
  local seed_id; seed_id=$(ref_seed_sha256 "$ref") \
    || die "diff-test: '$ref' pins no seed (no seed.ll or seed.lock)"
  mkdir -p "$out"
  local fp marker="$out/.dt_built"
  fp=$(window_fingerprint "$seed_id" "$ref_sha")
  if [ "${AVRA_FORCE_DIFFTEST:-0}" != "1" ] && [ -x "$out/bs2" ] \
     && [ "$(cat "$marker" 2>/dev/null)" = "$fp" ]; then
    log "diff-test: compiler @ $ref (${ref_sha:0:12}) cached"
    # Record WHICH windows were served from a marker rather than built here.
    # A divergence between a restored compiler and a freshly-built one has two
    # possible causes — the source change, or the restored window — and the
    # verdict cannot tell them apart. dt_recheck_without_cache (below) resolves
    # it by rebuilding, and needs to know there was something to rebuild.
    DT_CACHED_WINDOWS="${DT_CACHED_WINDOWS:-} $out"
    return 0
  fi
  log "diff-test: building compiler @ $ref (${ref_sha:0:12})"
  materialize_treeish_seed "$ref" "$out/seed.ll" "$out/seed.lock" \
    || die "diff-test: cannot materialize the seed pinned by $ref"
  window_copy_tree "$out" "$ref_sha"
  local entry="$out/tree/bootstrap/packages/cli/src/main.av"
  [ -f "$entry" ] || die "diff-test: $ref's tree is missing $entry"
  window_c_objects "$out"
  local stage; stage=$(window_stage_binary "$ref" "$out" "$ref_sha") || return 1
  if ! hermetic_compile_env "$stage" compile "$entry" >"$out/selfcompile.log" 2>&1; then
    err "diff-test: $ref's compiler source failed to build from its seed"
    tail -15 "$out/selfcompile.log" >&2
    return 1
  fi
  llc_link_bin "$entry.ll" "$out/bs2.o" "$out/bs2" "$out/bs2.build.log" \
      "$out/runtime.o" "$out/llvm_wrapper.o" \
    || { cat "$out/bs2.build.log" >&2; die "diff-test: $ref compiler link failed"; }
  printf '%s' "$fp" > "$marker"
}

# Re-decide a SELFHOST divergence when one side's compiler was RESTORED rather
# than built in this run — returns 0 when the divergence does NOT survive a
# rebuild (i.e. the restored window caused it), non-zero otherwise.
#
# WHY this exists. diff-test's whole claim is that an IR difference is
# attributable to compiler SOURCE alone: same seed (asserted), same input (one
# path, both compilers), same machine. Caching the OLD window breaks the last
# leg silently — the restored `bs2` was produced by an earlier run, possibly on
# a different runner image, and `window_fingerprint` covers the seed and the ref
# SHA but not the environment that linked it. The workflow comment concedes the
# point ("Correctness is the marker's (not the key's), and diff-test's own
# byte-identical IR comparison is the backstop") — but the backstop cannot
# distinguish the two causes, so when it fires the reader gets "the change is
# NOT behaviour-preserving" for what may be a stale cache entry.
#
# Observed exactly that on #1221: two identical CI failures, wholesale ORDER
# differences (identical `__init_*` module set, renumbered `.str` pool) with the
# CI log reading `compiler @ … cached` for OLD and `building` for NEW, while a
# hermetic COLD local run of the same tree was byte-identical, and CI's OLD did
# not match a fresh local build of the same commit. Rebuilding is the only thing
# that separates those, so do it automatically instead of asking a human to
# guess — and cost nothing on the common path, since this runs only after a
# divergence has already been reported.
dt_recheck_without_cache() {
  local base="$1" old="$2" self="$3" old_bs2="$4" new_bs2="$5" wd="$6" newd="$7"
  case " ${DT_CACHED_WINDOWS:-} " in
    *" $old "*) ;;
    *) return 1 ;;   # OLD was built in this run — the divergence stands.
  esac
  warn "diff-test: OLD was served from a RESTORED window, so the divergence above is"
  warn "           NOT yet attributable to this branch. Rebuilding OLD from its ref and"
  warn "           re-comparing — this is the only thing that separates the two causes."
  AVRA_FORCE_DIFFTEST=1 dt_build_compiler "$base" "$old" || {
    err "diff-test: rebuilding OLD failed — cannot adjudicate; treating the divergence as real"
    return 1
  }
  # The rebuild replaces OLD's tree, so BOTH sides must recompile against it.
  dt_compile_ir "$self" "$old_bs2" "$old"  "$wd/self.old.ll" || {
    err "diff-test: rebuilt OLD failed to compile its own source"; return 1; }
  dt_compile_ir "$self" "$new_bs2" "$newd" "$wd/self.new.ll" || {
    err "diff-test: NEW failed to compile the rebuilt OLD's source"; return 1; }
  if diff -q "$wd/self.old.ll" "$wd/self.new.ll" >/dev/null 2>&1; then
    warn "diff-test: the restored OLD window was stale — evict it. The cache key"
    warn "           (avra-difftest-…) shares entries by prefix across PRs on the"
    warn "           same seed pin, so a bad entry re-poisons every later run."
    return 0
  fi
  err "diff-test: the divergence SURVIVES a rebuilt OLD — it is attributable to this branch"
  return 1
}

# Compile $1 (an absolute .av path) with the compiler BINARY $2, writing the
# emitted IR straight to $4 via `--output`. Because --output fully redirects
# (nothing is written next to the input), two compilers can compile the SAME
# input concurrently without clobbering each other's <input>.ll — that is what
# lets the selfhost + corpus passes parallelize. Per-call log → $3/last.compile.log.
# Returns bs2's exit status.
dt_compile_ir() {
  local input="$1" bs2="$2" logdir="$3" out_ll="$4"
  hermetic_compile_env "$bs2" compile --output="$out_ll" "$input" \
    >"$logdir/last.compile.log" 2>&1
}

# Resource-derived width for the shell-owned diff-test phases. The canonical
# platform probe lives in `bs2 resources`; this shell only applies a named
# work profile's conservative seed, so Linux/macOS/cgroups never get separate
# ad-hoc implementations or environment-variable overrides.
dt_resource_jobs() {
  local bs2="$1" kind="$2" snapshot avail cpu pressure seed reserve by_mem jobs
  snapshot=$("$bs2" resources 2>/dev/null) || { printf '1'; return; }
  avail=$(printf '%s\n' "$snapshot" | sed -n 's/^available_mb=//p' | head -1)
  cpu=$(printf '%s\n' "$snapshot" | sed -n 's/^cpu_capacity=//p' | head -1)
  pressure=$(printf '%s\n' "$snapshot" | sed -n 's/^pressure=//p' | head -1)
  case "$avail" in ''|*[!0-9-]*) avail=0 ;; esac
  case "$cpu" in ''|*[!0-9-]*) cpu=1 ;; esac
  [ "$cpu" -gt 0 ] || cpu=1
  case "$kind" in
    selfhost) seed=6000; reserve=4096 ;;
    corpus)   seed=2500; reserve=4096 ;;
    *)        seed=3500; reserve=4096 ;;
  esac
  if [ "$avail" -le 0 ]; then printf '1'; return; fi
  # A shell-owned one-shot has no persistent governor loop, so a live
  # elevated/critical platform signal narrows its initial admission to the
  # serial floor. The compilers it starts retain their runtime pressure gate.
  case "$pressure" in elevated|critical) printf '1'; return ;; esac
  by_mem=$(((avail - reserve) / seed))
  [ "$by_mem" -gt 0 ] || by_mem=1
  jobs="$by_mem"
  [ "$jobs" -le "$cpu" ] || jobs="$cpu"
  [ "$jobs" -le 8 ] || jobs=8
  printf '%s' "$jobs"
}

# Collision-free per-input work-dir key: a hash of the FULL path. Same-named
# files from different directories (a multi-dir DIFF_TEST_CORPUS override) must
# not share $wd/corpus/<key> — that would race their status/.ll files and
# mis-attribute the verdict. The display name (basename) is kept separate.
dt_corpus_key() {
  printf '%s' "$1" | cksum | cut -d' ' -f1
}

# Run ONE corpus input through BOTH compilers in an isolated per-input dir
# (keyed by full path, not basename), so tasks fan out without racing. Writes a
# one-word verdict to $cwd/status (ok | diverge | newfail | skip) for the caller
# to aggregate; never fails the calling shell (a bad compile is recorded, not
# propagated up).
dt_corpus_task() {
  local input="$1" old_bs2="$2" new_bs2="$3" wd="$4"
  local cwd="$wd/corpus/$(dt_corpus_key "$input")"
  mkdir -p "$cwd"
  # OLD is the oracle: a file it can't compile standalone is out of scope.
  if ! dt_compile_ir "$input" "$old_bs2" "$cwd" "$cwd/old.ll"; then
    printf 'skip' > "$cwd/status"; return 0
  fi
  if ! dt_compile_ir "$input" "$new_bs2" "$cwd" "$cwd/new.ll"; then
    printf 'newfail' > "$cwd/status"; return 0
  fi
  if diff -q "$cwd/old.ll" "$cwd/new.ll" >/dev/null 2>&1; then
    printf 'ok' > "$cwd/status"
  else
    printf 'diverge' > "$cwd/status"
  fi
}

# ── t-zk6j: NEW REJECTS OLD's source is a DIFFERENT outcome from "IR diverged"
#
# The selfhost leg has both compilers compile the SAME source, so a PR that
# makes the compiler stricter fails on a COMPILE error, not an IR difference.
# The harness called that "regression" and printed a 15-line log tail — the
# wrong word (for a deliberate gate it is the new compiler working) and the
# wrong evidence (a tail is not the rejection SET).
#
# Report WHICH diagnostics NEW raises that OLD does not, grouped by conflict,
# via `bs2 diag_delta` — the same scanner + grouping `bs2 gate_scan` uses, so
# a strictness review reads like a gate scan and the ANSI/attribution handling
# cannot drift between two copies.
#
# Returns 0 only when the delta is a GENUINE strictness difference: a
# non-empty rejection set with no F9999 (ICE) or F4014 (memory ceiling) in it.
# Fail-closed — an unavailable reporter returns 1, so the strictness landing
# path can never be entered on evidence the harness could not read.
dt_report_strictness() {
  local bs2="$1" new_log="$2" old_log="$3" out rc
  if [ -n "$old_log" ] && [ -f "$old_log" ]; then
    out=$("$bs2" diag_delta "$new_log" "$old_log" 2>/dev/null); rc=$?
  else
    out=$("$bs2" diag_delta "$new_log" 2>/dev/null); rc=$?
  fi
  # The report's own opening words. A compiler predating this subcommand
  # exits non-zero with usage text instead, and must not be mistaken for a
  # verdict of "not strictness" that happens to be right by accident.
  case "$out" in
    "NEW raises"*) printf '%s\n' "$out" >&2; return "$rc" ;;
  esac
  warn "diff-test: this compiler has no diag_delta reporter — raw log tail instead"
  tail -15 "$new_log" >&2
  return 1
}

# The selfhost oracle for a DECLARED strictness change (--intended-strictness).
#
# The default leg compiles OLD's source with both compilers, which a
# strictness change breaks BY CONSTRUCTION: NEW rejects the very sites the
# branch fixed. Swapping the input to NEW's OWN source keeps the property that
# makes the oracle trustworthy — BOTH compilers still compile the SAME source,
# so an IR difference is still attributable to compiler source alone — while
# choosing an input both of them accept. Comparability is untouched; only the
# choice of input moves.
#
# OLD must accept it, and that is the point of the check rather than an
# assumption: a strictness change only ADDS rejections, so the laxer OLD still
# accepts the fixed source, and the bootstrap window forbids new surface syntax
# on a feature branch. OLD failing here means the change is not a strictness
# change at all.
dt_selfhost_new_source() {
  local self="$1" old_bs2="$2" new_bs2="$3" old="$4" newd="$5" wd="$6" jobs="$7"
  local rc_old rc_new p_old p_new
  if [ ! -f "$self" ]; then
    err "diff-test: NEW's compiler entry is missing at $self"
    return 1
  fi
  log "diff-test: strictness oracle — both compilers compile NEW's source (the input both accept)"
  if [ "$jobs" -le 1 ]; then
    dt_compile_ir "$self" "$old_bs2" "$old"  "$wd/selfnew.old.ll"; rc_old=$?
    dt_compile_ir "$self" "$new_bs2" "$newd" "$wd/selfnew.new.ll"; rc_new=$?
  else
    dt_compile_ir "$self" "$old_bs2" "$old"  "$wd/selfnew.old.ll" & p_old=$!
    dt_compile_ir "$self" "$new_bs2" "$newd" "$wd/selfnew.new.ll" & p_new=$!
    wait "$p_old"; rc_old=$?
    wait "$p_new"; rc_new=$?
  fi
  if [ "$rc_old" -ne 0 ]; then
    err "diff-test: OLD cannot compile NEW's source — this is NOT a strictness change"
    err "  a strictness change only ADDS rejections, so the laxer OLD must still accept the fixed"
    err "  source. OLD failing here means NEW's source needs compiler surface OLD lacks — a"
    err "  seed-cycle change (see --check-bootstrap-window), which cannot land behind this label."
    tail -15 "$old/last.compile.log" >&2
    return 1
  fi
  if [ "$rc_new" -ne 0 ]; then
    err "diff-test: NEW cannot compile its OWN source — the branch has not fixed every site its gate rejects"
    tail -15 "$newd/last.compile.log" >&2
    return 1
  fi
  if diff -q "$wd/selfnew.old.ll" "$wd/selfnew.new.ll" >/dev/null 2>&1; then
    ok "diff-test: selfhost IR byte-identical on NEW's source ($(wc -l <"$wd/selfnew.old.ll" | tr -d ' ') lines) — the gate adds rejections and changes nothing else"
    return 0
  fi
  err "diff-test: SELFHOST IR DIVERGED on NEW's OWN source — this is more than a strictness change"
  err "  the gate changed codegen for a program BOTH compilers accept, which --intended-strictness"
  err "  does not cover; use intended-ir-change (run-equivalence) if the codegen move is deliberate."
  err "  full IR: $wd/selfnew.old.ll  vs  $wd/selfnew.new.ll"
  diff -u "$wd/selfnew.old.ll" "$wd/selfnew.new.ll" | head -80 >&2
  return 1
}

# Run-equivalence check for one corpus divergence (--run-equiv): link BOTH
# already-emitted artifacts and execute them; equivalent means byte-identical
# stdout AND equal exit codes. The weaker oracle for INTENDED IR changes —
# behavior, not bytes. Bounded by a timeout so a wedged artifact fails loudly.
dt_run_equiv_check() {
  local cwd="$1" name="$2"
  [ -f "$cwd/old.ll" ] && [ -f "$cwd/new.ll" ] || return 1
  ensure_runtime; ensure_llvm_wrapper
  link_ll "$cwd/old.ll" "$cwd/old.bin" "$cwd/link.old.log" || { err "run-equiv: OLD artifact of '$name' failed to link"; return 1; }
  link_ll "$cwd/new.ll" "$cwd/new.bin" "$cwd/link.new.log" || { err "run-equiv: NEW artifact of '$name' failed to link"; return 1; }
  local rc_old=0 rc_new=0
  timeout 30 "$cwd/old.bin" >"$cwd/run.old.out" 2>&1 || rc_old=$?
  timeout 30 "$cwd/new.bin" >"$cwd/run.new.out" 2>&1 || rc_new=$?
  if [ "$rc_old" = "$rc_new" ] && diff -q "$cwd/run.old.out" "$cwd/run.new.out" >/dev/null 2>&1; then
    log "diff-test: '$name' IR diverged but RUNS identically (exit $rc_old) — intended-change equivalence holds"
    return 0
  fi
  err "run-equiv: '$name' RUNS DIFFERENTLY (exit $rc_old vs $rc_new) — outputs: $cwd/run.old.out vs $cwd/run.new.out"
  diff -u "$cwd/run.old.out" "$cwd/run.new.out" | head -40 >&2
  return 1
}

# Entry point for `--diff-test` (see the section banner above). Builds the
# OLD/oracle and NEW/candidate compilers, then asserts byte-identical IR
# over the selfhost source + corpus; prints a readable diff and returns
# non-zero on any divergence.
# ── t-47hc.5 parser-differential probes ───────────────────────────────────────
#
# TWO engines answer parsing now, and knowing which one a command exercises is the
# difference between a real measurement and a false one. Every mode below sets EVERY
# routing variable explicitly rather than only the one that distinguishes it: set just
# one and the rest stay ambient, so several modes collapse onto the same engine and the
# probe compares it against itself — the vacuity class these probes exist to detect.
#
# THE HAND ROW IS GONE (t-47hc.4.1), and this is the third variable to go the same way,
# so the pattern is worth stating once:
#
#   AVRA_NO_STATIC_FALLBACK  (t-47hc.4.3) — the interpreter re-parse fallback it
#     switched off was deleted. EMIT and PROD now name the same engine and print
#     identical rows; they are kept separate deliberately, so a reintroduced fallback
#     shows up as a divergence rather than hiding behind a collapsed row.
#   AVRA_PARSER_DECL_FLIP    (t-bw9s) — the compiler stopped reading it at all when
#     `@hand(decl_hand)` went away. It survived here and in ~15 test files, where
#     pinning it looked like selecting an oracle and selected nothing.
#   AVRA_PARSER_EXPR_STATIC  (t-47hc.4.1) — the hand expression ladder is deleted, so
#     `=0` had no parser left to choose. Removed from the compiler as a field, not
#     merely pinned ON, precisely so this row could not be resurrected.
#
# What remains is a genuine pair. EMIT is the checked-in generated static parser
# (production — every family: decl, stmt, expr, type, pat). EXEC is the grammar tree
# interpreter, the SAME grammar's second engine (production for user `grammar{}`
# blocks + quote bodies). They CAN drift — the executor's missing `cell_mode` guard
# on its binary ladder was found exactly this way, by the recovery corpus once it
# started comparing these two instead of a deleted third. Every per-family engine
# toggle is pinned in BOTH directions (t-47hc.8: STMT/TYPE joined DECL/EXPR when
# their seams gained the static default), so a probe can never measure a path
# against itself because the ambient environment leaked in.
PARSER_MODE_EMIT="AVRA_PARSER_DECL_STATIC=1 AVRA_PARSER_EXPR_FLIP=0 AVRA_PARSER_STMT_STATIC=1 AVRA_PARSER_TYPE_STATIC=1"
PARSER_MODE_PROD="AVRA_PARSER_DECL_STATIC=1 AVRA_PARSER_EXPR_FLIP=0 AVRA_PARSER_STMT_STATIC=1 AVRA_PARSER_TYPE_STATIC=1"
PARSER_MODE_EXEC="AVRA_PARSER_DECL_STATIC=0 AVRA_PARSER_EXPR_FLIP=1 AVRA_PARSER_STMT_STATIC=0 AVRA_PARSER_TYPE_STATIC=0"

# Resolve the probe's input to a file: `-f <path>` uses it directly, otherwise
# the argument IS the source text.
# Sets PARSER_PROBE_FIXTURE rather than echoing it: `die` inside a command
# substitution exits only the SUBSHELL, so a usage error there printed the
# message and then let the caller run on with an empty path — every row
# reporting "no such file" instead of the usage error it had already emitted.
parser_probe_fixture() {
  if [ "${1:-}" = "-f" ]; then
    [ -f "${2:-}" ] || die "parser probe: no such file: ${2:-<missing>}"
    PARSER_PROBE_FIXTURE="$2"
  else
    [ -n "${1:-}" ] || die "parser probe: pass source text, or -f <file>"
    PARSER_PROBE_FIXTURE="${TMPDIR:-/tmp}/avra_parser_probe.$$.av"
    printf '%s\n' "$1" > "$PARSER_PROBE_FIXTURE"
  fi
}

# --parser-probe: the DIAGNOSTICS each path reports for one snippet. Divergence
# between `hand` and the rest is a recovery-parity gap; `prod` vs `exec` isolates
# the executor, which is what answers invalid input on the default path.
mode_parser_probe() {
  cd "$BOOTSTRAP_DIR" || die "cannot cd to $BOOTSTRAP_DIR"
  [ -x "$BS2" ] || die "parser probe: no bs2 at $BS2 (run make build-quick)"
  parser_probe_fixture "$@"; local fix="$PARSER_PROBE_FIXTURE"
  # shellcheck disable=SC2086  # $1 is a `VAR=x VAR=y` list; env needs it SPLIT.
  _pp_run() { env $1 "$BS2" check "$fix" 2>&1 | sed 's/.\[[0-9;]*m//g' | grep -oE 'error.F[0-9]+.: .*' | tr '\n' '|'; }
  printf 'src : %s\n' "$(tr '\n' ' ' < "$fix")"
  printf 'emit: %s\n' "$(_pp_run "$PARSER_MODE_EMIT")"
  printf 'prod: %s\n' "$(_pp_run "$PARSER_MODE_PROD")"
  printf 'exec: %s\n' "$(_pp_run "$PARSER_MODE_EXEC")"
}

# --parser-tree: the RECOVERY TREE each path builds for one snippet, with a count
# of `(error)` rows. Distinct from --parser-probe because the diagnostics can
# AGREE while the trees do not: `let a = (1) ->` reports the same F0040 on every
# path and still comes back as `(group 1)` from the hand and `(lambda (_) (error))`
# from the native rule. A message-only probe calls that agreement.
mode_parser_tree() {
  cd "$BOOTSTRAP_DIR" || die "cannot cd to $BOOTSTRAP_DIR"
  [ -x "$BS2" ] || die "parser probe: no bs2 at $BS2 (run make build-quick)"
  parser_probe_fixture "$@"; local fix="$PARSER_PROBE_FIXTURE"
  # `--recover` is required, not cosmetic: plain `program` stops at the diagnostics,
  # so on the invalid input this mode exists for it prints errors and NO tree.
  # shellcheck disable=SC2086  # $1 is a `VAR=x VAR=y` list; env needs it SPLIT.
  _pt_run() {
    local o
    o=$(env $1 "$BS2" program --recover "$fix" 2>/dev/null) || { printf '<bs2 FAILED rc=%s>' "$?"; return 0; }
    printf '%s' "$o" | sed 's/.\[[0-9;]*m//g'
  }
  # `-c` counts matching LINES and suppresses `-o`, so the `-o` was inert; the label
  # below says "err rows", which is the line count — keep the unit, drop the dead flag.
  _pt_errs() { printf '%s' "$1" | grep -c '(error)' || true; }
  local e x
  e=$(_pt_run "$PARSER_MODE_EMIT"); x=$(_pt_run "$PARSER_MODE_EXEC")
  printf 'src : %s\n' "$(tr '\n' ' ' < "$fix")"
  printf 'emit [%s err rows]: %s\n' "$(_pt_errs "$e")" "$(printf '%s' "$e" | tr '\n' ' ')"
  printf 'exec [%s err rows]: %s\n' "$(_pt_errs "$x")" "$(printf '%s' "$x" | tr '\n' ' ')"
}


mode_diff_test() {
  local base="" new="HEAD" prebuilt=0 run_equiv=0 intended=0 strictness=0 strictness_seen=0
  while [ $# -gt 0 ]; do
    case "$1" in
      --base) base="${2:?--base needs a ref}"; shift 2 ;;
      --new)  new="${2:?--new needs a ref}";  shift 2 ;;
      --new-prebuilt) prebuilt=1; shift ;;
      --run-equiv) run_equiv=1; shift ;;
      --intended-strictness) strictness=1; shift ;;
      *) die "diff-test: unknown argument '$1' (want --base <ref> / --new <ref> / --new-prebuilt / --run-equiv / --intended-strictness)" ;;
    esac
  done
  [ -n "$base" ] || base="${AVRA_DIFFTEST_BASE:-$(window_resolve_integration_ref)}"

  # t-v91z detector: NEW is HEAD/the working tree while OLD is $base, so the
  # two sides differ by this branch's edits PLUS every base commit the branch
  # predates — and an intended-ir-change among those reads as a divergence
  # caused HERE. It has twice cost a session chasing inherited diffs; in the
  # 2026-08-01 instance a PR merged minutes before the run, moving the
  # auto-fetched oracle ahead of the branch's base. Detect the shape up
  # front: based-behind is not an error, but a FAIL under it is suspect.
  local base_tip mb behind_base=0
  base_tip=$(git -C "$REPO_DIR" rev-parse "$base^{commit}" 2>/dev/null) || true
  mb=$(git -C "$REPO_DIR" merge-base HEAD "$base_tip" 2>/dev/null) || true
  if [ -n "$base_tip" ] && [ -n "$mb" ] && [ "$mb" != "$base_tip" ]; then
    behind_base=$(git -C "$REPO_DIR" rev-list --count "$mb..$base_tip")
    warn "diff-test: this branch is based $behind_base commit(s) BEHIND the oracle ($base)"
    warn "           a divergence may be INHERITED from those commits, not caused by this branch"
    warn "           (t-v91z) — rebase onto $base before trusting a FAIL"
  fi

  # The oracle model requires OLD and NEW to build from the SAME seed, so any
  # IR difference is attributable to compiler SOURCE alone. Assert it (fail
  # fast, before the expensive builds) for the hermetic path. --new-prebuilt
  # deliberately opts out: it reuses the working-tree build/bs2 as NEW, whose
  # seed/source aren't pinned — a LOCAL convenience, never the CI oracle.
  local base_seed; base_seed=$(ref_seed_sha256 "$base") || true
  [ -n "$base_seed" ] \
    || die "diff-test: base ($base) pins no seed (no seed.ll/seed.lock)"
  if [ "$prebuilt" = "0" ]; then
    local new_seed; new_seed=$(ref_seed_sha256 "$new") || true
    [ -n "$new_seed" ] \
      || die "diff-test: new ($new) pins no seed (no seed.ll/seed.lock)"
    [ "$base_seed" = "$new_seed" ] \
      || die "diff-test: seed pin differs between OLD ($base) and NEW ($new) — a divergence would be ambiguous (seed vs source). Align the pins (feature branches must not cycle the seed; see --check-bootstrap-window)."
  fi

  local old="$DIFFTEST_DIR/old" newd="$DIFFTEST_DIR/new"
  local old_bs2 new_bs2 new_label="$new" new_self
  dt_build_compiler "$base" "$old" || return 1
  old_bs2="$old/bs2"
  if [ "$prebuilt" = "1" ]; then
    new_bs2="$BOOTSTRAP_DIR/build/bs2"
    [ -x "$new_bs2" ] \
      || die "diff-test: --new-prebuilt needs a built compiler at build/bs2 — run 'make build-quick' first"
    mkdir -p "$newd"                          # holds the NEW compile logs
    new_label="build/bs2 (prebuilt, NON-HERMETIC)"
    # --new-prebuilt's NEW *is* the working tree, so that is where NEW's
    # source lives for the strictness oracle.
    new_self="$BOOTSTRAP_DIR/packages/cli/src/main.av"
    warn "diff-test: --new-prebuilt reuses build/bs2 as NEW — fast but NON-HERMETIC (its seed/source aren't pinned). The default hermetic build is the authoritative check (CI always uses it)."
  else
    dt_build_compiler "$new" "$newd" || return 1
    new_bs2="$newd/bs2"
    new_self="$newd/tree/bootstrap/packages/cli/src/main.av"
  fi
  log "diff-test: OLD/oracle=$base   NEW/candidate=$new_label"
  [ "$strictness" = "0" ] \
    || log "diff-test: --intended-strictness — a NEW-only rejection of OLD's source is an expected outcome, not a regression"

  local wd="$DIFFTEST_DIR/work"; rm -rf "$wd"; mkdir -p "$wd"
  local fails=0 checked=0 skipped=0

  # ── Selfhost differential: compile the OLD compiler's OWN source with
  # BOTH compilers. OLD parses it by construction; a behaviour-preserving NEW
  # must emit identical IR. This single input exercises ~all codegen and is the
  # dominant post-build cost — --output keeps the two compiles from racing on
  # main.av.ll, so by default they run CONCURRENTLY and the phase costs ~one
  # compile instead of two.
  #
  # Two whole-compiler compiles peak at ~12GB together, so this phase receives
  # its own conservative resource profile and serialises automatically on a
  # tight runner rather than consulting an environment override.
  local self_jobs; self_jobs=$(dt_resource_jobs "$new_bs2" selfhost)
  local self="$old/tree/bootstrap/packages/cli/src/main.av"
  local p_old p_new rc_old rc_new
  if [ "$self_jobs" -le 1 ]; then
    log "diff-test: selfhost differential — both compilers compile the compiler (SEQUENTIAL, jobs=1)"
    dt_compile_ir "$self" "$old_bs2" "$old"  "$wd/self.old.ll"; rc_old=$?
    dt_compile_ir "$self" "$new_bs2" "$newd" "$wd/self.new.ll"; rc_new=$?
  else
    log "diff-test: selfhost differential — both compilers compile the compiler (parallel)"
    dt_compile_ir "$self" "$old_bs2" "$old"  "$wd/self.old.ll" & p_old=$!
    dt_compile_ir "$self" "$new_bs2" "$newd" "$wd/self.new.ll" & p_new=$!
    wait "$p_old"; rc_old=$?
    wait "$p_new"; rc_new=$?
  fi
  if [ "$rc_old" -ne 0 ]; then
    cat "$old/last.compile.log" >&2; die "diff-test: OLD failed its own selfhost compile (oracle broken)"
  fi
  checked=$((checked+1))
  if [ "$rc_new" -ne 0 ]; then
    # t-zk6j: NEW REJECTS OLD's source. A distinct outcome from "IR diverged",
    # and NOT a regression when the PR declares the strictness change — so
    # name it for what it is and print the rejection SET either way.
    err "diff-test: NEW REJECTS the compiler source that OLD accepts"
    local delta_rc=0
    dt_report_strictness "$new_bs2" "$newd/last.compile.log" "$old/last.compile.log" || delta_rc=$?
    if [ "$strictness" = "1" ] && [ "$delta_rc" -eq 0 ]; then
      strictness_seen=1
      warn "diff-test: INTENDED strictness change — confirm the rejections above are the expected set"
      if dt_selfhost_new_source "$new_self" "$old_bs2" "$new_bs2" "$old" "$newd" "$wd" "$self_jobs"; then
        intended=$((intended+1))
      else
        fails=$((fails+1))
      fi
    elif [ "$strictness" = "1" ]; then
      err "diff-test: --intended-strictness given, but this is not a strictness rejection (see above) — failing"
      fails=$((fails+1))
    else
      err "  if this rejection is INTENTIONAL (a new gate), label the PR intended-strictness-change:"
      err "  the oracle then compiles NEW's OWN source with both compilers — same input, both sides,"
      err "  so IR comparability is unchanged — and requires it to be byte-identical."
      fails=$((fails+1))
    fi
  elif diff -q "$wd/self.old.ll" "$wd/self.new.ll" >/dev/null 2>&1; then
    ok "diff-test: selfhost IR byte-identical ($(wc -l <"$wd/self.old.ll" | tr -d ' ') lines)"
  elif [ "$run_equiv" = "1" ]; then
    # Intended-IR-change mode: the selfhost artifacts are COMPILERS, whose
    # run-equivalence is exactly what the corpus phase below measures (each
    # corpus program is compiled by both and must RUN identically) plus the
    # full suite under NEW (CI's rc-strict job). Record, don't fail.
    intended=$((intended+1))
    warn "diff-test: selfhost IR diverged — INTENDED (run-equiv mode); corpus run-equivalence + the suite are the oracle"
  else
    err "diff-test: SELFHOST IR DIVERGED — the compiler compiles itself differently"
    err "  full IR: $wd/self.old.ll  vs  $wd/self.new.ll"
    diff -u "$wd/self.old.ll" "$wd/self.new.ll" | head -80 >&2
    # A divergence is only attributable to the SOURCE if both compilers were
    # built the same way in this run. When one side came from a restored
    # window, it is not, and the verdict above is a guess dressed as a finding.
    # Rebuild and re-compare rather than leaving the reader to infer it.
    if dt_recheck_without_cache "$base" "$old" "$self" "$old_bs2" "$new_bs2" "$wd" "$newd"; then
      ok "diff-test: selfhost IR byte-identical once OLD was REBUILT — the restored window was the divergence, not this branch"
    else
      fails=$((fails+1))
    fi
  fi

  # ── Corpus differential: the CURATED standalone corpus
  # (tests/difftest_corpus/*.av) — small, single-file, feature-diverse programs
  # that compile with a bare `bs2 compile`, giving real per-feature IR
  # comparisons that localize a divergence to a tiny file (the selfhost pass
  # stays the comprehensive oracle). NOT the test-harness suite (tests/*.av):
  # those need @std + the spec/given/then runtime, so the OLD oracle can't
  # compile them standalone — every one would be skipped, doing zero work.
  # (Always runs — it's now tiny and fast; there is no skip-the-corpus knob.)
  local glob="${DIFF_TEST_CORPUS:-$BOOTSTRAP_DIR/tests/difftest_corpus/*.av}"
  local jobs; jobs=$(dt_resource_jobs "$new_bs2" corpus)
  log "diff-test: corpus differential — $glob (jobs=$jobs)"
  local divergent=() skipped_names=() input name cwd status in_batch=0 first_div_cwd=""
  # Fan out: each input runs through both compilers in its own dir
  # (dt_corpus_task), bounded to $jobs concurrent so a large overridden
  # corpus can't OOM. --output means no two tasks share an output path.
  for input in $glob; do
    [ -f "$input" ] || continue
    dt_corpus_task "$input" "$old_bs2" "$new_bs2" "$wd" &
    in_batch=$((in_batch + 1))
    if [ "$in_batch" -ge "$jobs" ]; then wait; in_batch=0; fi
  done
  wait
  # Aggregate the per-task verdicts in deterministic glob order. OLD is the
  # oracle: a 'skip' means OLD couldn't compile the file standalone (out of
  # scope); for the curated corpus that signals a regressed file.
  for input in $glob; do
    [ -f "$input" ] || continue
    name=$(basename "$input"); cwd="$wd/corpus/$(dt_corpus_key "$input")"
    status=$(cat "$cwd/status" 2>/dev/null || printf 'missing')
    case "$status" in
      ok)      checked=$((checked+1)); rm -rf "$cwd" ;;
      skip)    skipped=$((skipped+1)); skipped_names+=("$name"); rm -rf "$cwd" ;;
      newfail) checked=$((checked+1)); fails=$((fails+1)); divergent+=("$name")
               [ -z "$first_div_cwd" ] && first_div_cwd="$cwd"
               # Also a strictness rejection, and reported as one — but it
               # still FAILS under --intended-strictness. The corpus comes
               # from the WORKING TREE (NEW's side), so a file NEW rejects is
               # one the branch's own gate rejects and the branch did not fix.
               # Letting the label wave it through would make the label a way
               # to land an unvalidated gate.
               err "diff-test: NEW REJECTS corpus input '$name' that OLD accepts — fix the file or the gate"
               dt_report_strictness "$new_bs2" "$cwd/last.compile.log" "" || true ;;
      diverge)
        checked=$((checked+1))
        if [ "$run_equiv" = "1" ] && dt_run_equiv_check "$cwd" "$name"; then
          intended=$((intended+1)); rm -rf "$cwd"
        else
          fails=$((fails+1)); divergent+=("$name")
          [ -z "$first_div_cwd" ] && first_div_cwd="$cwd"
        fi ;;
      *)       fails=$((fails+1))
               err "diff-test: corpus task for '$name' produced no verdict (harness bug)" ;;
    esac
  done
  if [ ${#divergent[@]} -gt 0 ]; then
    err "diff-test: ${#divergent[@]} corpus input(s) diverged:"
    printf '  %s\n' "${divergent[@]}" >&2
    # Show the first IR divergence — but only when both sides exist (a
    # NEW-compile failure leaves no new.ll to diff against). first_div_cwd is
    # the work dir of divergent[0] (path-keyed, not basename).
    if [ -f "$first_div_cwd/old.ll" ] && [ -f "$first_div_cwd/new.ll" ]; then
      err "first divergence (${divergent[0]}):"
      diff -u "$first_div_cwd/old.ll" "$first_div_cwd/new.ll" | head -80 >&2
    fi
  fi
  # A skip in the curated corpus is a misconfiguration, not normal scope
  # trimming — surface it so a non-standalone file gets fixed or removed
  # instead of silently buying zero coverage at the cost of a compile.
  if [ ${#skipped_names[@]} -gt 0 ]; then
    warn "diff-test: ${#skipped_names[@]} corpus input(s) skipped (OLD couldn't compile standalone — fix or remove them):"
    printf '  %s\n' "${skipped_names[@]}" >&2
  fi

  log "diff-test: compared $checked input(s), skipped $skipped (not standalone-compilable)"
  if [ "$run_equiv" = "1" ] && [ "$skipped" -gt 0 ]; then
    err "diff-test: run-equiv mode forbids corpus skips — the run oracle is weaker than byte-identity, so coverage must be total"
    fails=$((fails+1))
  fi
  if [ "$fails" -eq 0 ]; then
    if [ "$strictness_seen" = "1" ]; then
      ok "DIFF-TEST STRICTNESS PASS — NEW rejects OLD's source (intended); on NEW's own source, which both compilers accept, the IR is byte-identical"
    elif [ "$run_equiv" = "1" ] && [ "$intended" -gt 0 ]; then
      ok "DIFF-TEST RUN-EQUIV PASS — IR diverged at $intended site(s) (intended) but every corpus artifact RUNS identically; the suite (CI rc-strict) completes the oracle"
    else
      ok "DIFF-TEST PASS — OLD ($base) and NEW ($new_label) emit byte-identical IR"
      # A label that changed nothing is worth saying out loud: it usually
      # means the strictness split already happened in an earlier PR, and
      # carrying the label forward relaxes an oracle for no reason.
      [ "$strictness" = "0" ] \
        || warn "diff-test: --intended-strictness was given but NEW rejected nothing — the label is unnecessary here; drop it to keep the strict oracle"
    fi
    return 0
  fi
  err "DIFF-TEST FAIL — $fails divergence(s); the change is NOT behaviour-preserving"
  if [ "$behind_base" -gt 0 ]; then
    err "NOTE: branch is $behind_base commit(s) behind the oracle — divergences may be inherited; rebase onto $base and re-run before attributing them here (t-v91z)"
  fi
  if [ "$run_equiv" = "1" ]; then
    err "(run-equiv mode: a corpus artifact RUNS differently — the IR change is not behavior-preserving)"
  elif [ "$strictness_seen" = "1" ]; then
    err "(intended-strictness mode: the rejection set was accepted, but the oracle on NEW's own source failed — see above)"
  else
    err "(if the IR change is intentional, confirm run-results match and label the PR intended-ir-change to run the run-equivalence oracle;"
    err " if NEW REJECTING source OLD accepts is intentional, label it intended-strictness-change instead)"
  fi
  return 1
}

# ─────────────────────────────────────────────────────────────────────
# Seed-merge staging
# ─────────────────────────────────────────────────────────────────────

# Classify a failed stage-compile of the merged source. Mirrors the
# taxonomy of docs/SEED_MERGES.md "choosing a base":
#   corruption   — the stage binary died by signal / corrupted memory
#                  while compiling: the base seed predates a
#                  codegen-correctness fix present in the union (the
#                  alloca zero-init class). The side that HAS the fix
#                  should win.
#   extern-guard — the base seed's baked predeclare table conflicts
#                  with the merged source's extern signatures; the
#                  side whose refactor it is should win.
#   parse        — the base seed's parser predates surface syntax in
#                  the merged source. NOTE: new literal forms often
#                  surface as `undefined variable`, not a parse error
#                  — both classify here.
#   unknown      — none of the known signatures matched; read the log.
seed_merge_classify() {
  local rc="$1" logfile="$2"
  if [ "$rc" -ge 128 ] \
     || grep -qiE 'segmentation fault|bus error|illegal instruction|unmatched tag|signal [0-9]+' "$logfile" 2>/dev/null; then
    echo corruption; return
  fi
  if grep -q 'redeclared with a conflicting signature' "$logfile" 2>/dev/null; then
    echo extern-guard; return
  fi
  if grep -qiE 'parse error|unterminated|F0001|F3100|undefined variable' "$logfile" 2>/dev/null; then
    echo parse; return
  fi
  echo unknown
}

# Human next-step hints per failure class, with a log excerpt.
seed_merge_hint() {
  local cand="$1" cls="$2" logfile="$3"
  err "[$cand] stage-compile failed — class: $cls"
  case "$cls" in
    parse)
      err "  The '$cand' seed's parser predates syntax in the merged source (new"
      err "  literal forms often surface as 'undefined variable'). The side that"
      err "  HAS the parser for it should be the base. If BOTH sides land here,"
      err "  the union dogfoods two branches' new syntax — the state the"
      err "  bootstrap window forbids; stage via IR-level patching as a last"
      err "  resort (docs/SEED_MERGES.md)."
      ;;
    extern-guard)
      err "  The '$cand' seed's baked predeclare table conflicts with the merged"
      err "  source's extern signatures. The side whose extern refactor it is"
      err "  should be the base (its seed already matches the new signatures)."
      ;;
    corruption)
      err "  The '$cand' stage binary corrupted while compiling the merged source"
      err "  — it predates a codegen-correctness fix present in the union."
      err "  Prefer the side that HAS the fix in its machine code."
      err "  Forensics: AVRA_REDZONES=1, docs/RC_MEMORY_RUNBOOK.md."
      ;;
    *)
      err "  No known failure signature matched — read the log."
      ;;
  esac
  err "  log (tail): $logfile"
  tail -6 "$logfile" >&2 2>/dev/null || :
}

# Try one candidate base seed end-to-end short of seed regeneration:
# materialize it at seed/seed.ll, patch traps, build stage1 off to the
# side (dev caches untouched), compile the merged source, link bs2,
# self-compile verify. Returns non-zero when the candidate cannot
# stage the union (class + hints printed) so the driver can fall
# through to the next one. On success $mdir/bs2m is the verified
# compiler for the merged source.
seed_merge_attempt() {
  local cand="$1" mdir="$2"
  log "── attempt: base seed = $cand ──"
  local spec=""
  case "$cand" in
    ours)    spec=":2" ;;
    theirs)  spec=":3" ;;
    current) : ;;
    *)       spec="$cand" ;;
  esac
  if [ -n "$spec" ]; then
    materialize_treeish_seed "$spec" "$SEED_LL" "$mdir/cand.$cand.lock" \
      || { err "[$cand] could not materialize this side's pinned seed"; return 1; }
  fi

  # Tolerate the other side's new ValueType/Expr/Stmt variants.
  log "[$cand] patching seed match traps"
  (cd "$BOOTSTRAP_DIR" && python3 scripts/patch-seed-traps.py) >"$mdir/traps.$cand.log" 2>&1 \
    || warn "[$cand] trap patch failed (see $mdir/traps.$cand.log) — continuing unpatched"

  log "[$cand] building stage1 from this seed"
  case $(llc_link_bin "$SEED_LL" "$mdir/stage1.o" "$mdir/stage1" "$mdir/stage1.$cand.log"; echo $?) in
    0) : ;;
    1) err "[$cand] llc rejected the seed IR — corrupt seed artifact; log: $mdir/stage1.$cand.log"
       return 1 ;;
    *) err "[$cand] stage1 link failed; log: $mdir/stage1.$cand.log"
       return 1 ;;
  esac

  # Unlike the window gate (which verifies HEAD), merge staging
  # compiles the WORKING TREE on purpose: mid-merge there is no merged
  # commit yet — the worktree IS the union being staged.
  log "[$cand] stage1 compiling the merged source"
  local rc=0 cls
  hermetic_compile_env "$mdir/stage1" compile "$SRC_DIR/main.av" >"$mdir/compile.$cand.log" 2>&1 || rc=$?
  if [ "$rc" -ne 0 ]; then
    cls=$(seed_merge_classify "$rc" "$mdir/compile.$cand.log")
    seed_merge_hint "$cand" "$cls" "$mdir/compile.$cand.log"
    return 1
  fi

  log "[$cand] linking bs2 from the stage1-compiled source"
  case $(llc_link_bin "$SRC_DIR/main.av.ll" "$mdir/bs2m.o" "$mdir/bs2m" "$mdir/bs2m.$cand.log"; echo $?) in
    0) : ;;
    1) err "[$cand] llc rejected stage1's emitted IR (mis-codegen); log: $mdir/bs2m.$cand.log"
       return 1 ;;
    *) err "[$cand] bs2 link failed; log: $mdir/bs2m.$cand.log"
       return 1 ;;
  esac

  log "[$cand] self-compile verify (bs2 compiles its own source)"
  rc=0
  hermetic_compile_env "$mdir/bs2m" compile "$SRC_DIR/main.av" >"$mdir/selfcompile.$cand.log" 2>&1 || rc=$?
  if [ "$rc" -ne 0 ]; then
    cls=$(seed_merge_classify "$rc" "$mdir/selfcompile.$cand.log")
    seed_merge_hint "$cand" "$cls" "$mdir/selfcompile.$cand.log"
    return 1
  fi
}

# Print how to stage the resolution once the merge is green — which
# file to add depends on which pin shape actually conflicted.
seed_merge_next_steps() {
  if [ -n "$(git -C "$REPO_DIR" ls-files -u -- bootstrap/seed/seed.lock)" ]; then
    log "next: re-run 'make test', publish the regenerated seed, and resolve the lock:"
    log "  bash scripts/diagnose.sh --seed-publish && git add bootstrap/seed/seed.lock"
  elif [ -n "$(git -C "$REPO_DIR" ls-files -u -- bootstrap/seed/seed.ll)" ]; then
    log "next: re-run 'make test', then stage the resolution:"
    log "  git add bootstrap/seed/seed.ll"
  else
    log "next: re-run 'make test'; on lock-era history publish + commit the lock bump"
    log "  (bash scripts/diagnose.sh --seed-publish)"
  fi
}

# One-command seed-merge staging: encode the staging dance that
# resolving a seed-pin merge conflict requires. The seed train makes
# this rare — it's for merges INTO the integration branch, and for
# histories that predate the gate.
mode_seed_merge() {
  local base=""
  while [ $# -gt 0 ]; do
    case "$1" in
      --base)   base="${2:?--base needs ours|theirs|<ref>}"; shift 2 ;;
      --base=*) base="${1#--base=}"; shift ;;
      *) die "--seed-merge: unknown argument '$1' (expected --base ours|theirs|<ref>)" ;;
    esac
  done

  local mdir="$BUILD_DIR/seed_merge"
  mkdir -p "$mdir"

  # The conflicted artifact is seed.lock on lock-era history, seed.ll
  # on pre-lock history; seed_merge_attempt handles either shape.
  local conflicted=""
  [ -n "$(git -C "$REPO_DIR" ls-files -u -- bootstrap/seed/seed.ll bootstrap/seed/seed.lock)" ] && conflicted=1

  local candidates=()
  if [ -n "$conflicted" ]; then
    case "$base" in
      ours|theirs) candidates=("$base") ;;
      "")          candidates=(ours theirs) ;;
      *)           candidates=("$base") ;;
    esac
    log "the seed pin is merge-conflicted — candidates: ${candidates[*]}"
  else
    case "$base" in
      ours|theirs) die "--base $base needs an in-progress merge conflict on the seed pin (seed.ll / seed.lock)" ;;
      "")          log "the seed pin is not conflicted — staging from the current seed"
                   candidates=(current)
                   # "current" stages whatever seed the working tree
                   # pins; on a fresh lock-era checkout that seed may
                   # not be materialized yet.
                   ensure_seed_materialized ;;
      *)           candidates=("$base") ;;
    esac
  fi

  [ -f "$SEED_LL" ] && cp "$SEED_LL" "$mdir/seed.orig.ll"
  ensure_runtime
  ensure_llvm_wrapper

  local cand
  for cand in "${candidates[@]}"; do
    seed_merge_attempt "$cand" "$mdir" || continue

    # Candidate survived the whole chain — commit to it. main.av.ll is
    # now bs2's OWN output (generation 2); regenerate the seed from it
    # with provenance, rebuild from the new seed, verify fixed point.
    ok "[$cand] staging chain green — regenerating the seed from generation-2 IR"
    cp "$mdir/bs2m" "$BS2"
    mode_update_seed
    rm -f "$BS3"
    ensure_seed force
    ensure_bs2 force
    if ! mode_check_fixedpoint; then
      err "[$cand] fixed point failed after seed regeneration — restoring the original seed"
      [ -f "$mdir/seed.orig.ll" ] && cp "$mdir/seed.orig.ll" "$SEED_LL"
      return 1
    fi

    ok "seed merge staged: base=$cand, seed regenerated, fixed point holds"
    seed_merge_next_steps
    return 0
  done

  err "NO candidate base seed could stage the merged source (tried: ${candidates[*]})"
  err "Per-candidate classes + hints are above; logs live in $mdir/."
  err "Last resort: IR-level patching of the intermediate main.av.ll —"
  err "see docs/SEED_MERGES.md 'when NEITHER seed can compile the union'."
  if [ -f "$mdir/seed.orig.ll" ]; then
    cp "$mdir/seed.orig.ll" "$SEED_LL"
    log "restored the original working-tree seed.ll"
  fi
  return 1
}

# Function-level testing hook (6cks): `AVRA_DIAGNOSE_NO_MAIN=1 source
# scripts/diagnose.sh` loads every definition without dispatching, so
# spec tests can exercise individual helpers (source_newer_than, …)
# against sandboxed fixtures. A normal execution leaves the var unset
# and dispatches as always.
[ -n "${AVRA_DIAGNOSE_NO_MAIN:-}" ] && return 0

main "$@"
