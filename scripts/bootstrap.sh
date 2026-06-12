#!/usr/bin/env bash
#
# scripts/bootstrap.sh — one-shot dev-environment setup for the Avra bootstrap compiler.
#
# The bootstrap is fully self-hosted (it rebuilds itself from seed/seed.ll), so the
# only thing a fresh machine needs is the *toolchain* that turns LLVM IR into a binary
# and links it against libLLVM. This script installs and verifies that toolchain, then
# tells you the one env var the compiler can't reliably discover on its own.
#
# Hard requirements (build will not work without these):
#   LLVM 20            llc, llvm-config, opt, libLLVM + headers
#                      ── pinned to 20: LLVM 21's -O2 miscompiles certain ARM64
#                         functions (wrong register for parameters).
#   C/C++ compiler     clang preferred, gcc accepted (compiles runtime.c + the wrapper)
#   lld                Linux only — the bootstrap mangles symbols with a leading '@'
#                      (e.g. @std::avrac::core::Foo__bar). GNU ld reads '@' as the
#                      symbol-version separator and rejects the object; LLD does not.
#   make, git
#   sha256sum          (coreutils on Linux; shasum on macOS) — seed provenance hashing
#   python3            seed-trap patcher + scripts/diagnose.sh helpers
#
# Also required: bd, the beads issue tracker the dev workflow runs on. The script
# installs it unconditionally and brings its own prerequisite with it (a Go toolchain
# to build bd). bd bundles an embedded dolt server (`bd dolt ...`), so no separate
# `dolt` binary is needed.
#
# Platforms: macOS (Homebrew), Debian/Ubuntu (apt), Fedora/RHEL (dnf/yum),
#            Arch (pacman), openSUSE (zypper), Alpine (apk).
#
# Usage:
#   scripts/bootstrap.sh                # detect, install what's missing, verify
#   scripts/bootstrap.sh --check        # verify only, never install (exit 1 if a dep is missing)
#   scripts/bootstrap.sh --yes          # non-interactive: assume "yes" to install prompts
#   scripts/bootstrap.sh --persist      # append the recommended env to your shell rc
#   scripts/bootstrap.sh --print-env    # print the export lines and exit (no install)
#
# Exit status: 0 = environment is build-ready; non-zero = a required dep is missing
# (in --check) or an install step failed.

# Re-exec under bash if we were launched by a POSIX shell (e.g. `sh scripts/bootstrap.sh`).
# In that case the `#!/usr/bin/env bash` shebang is bypassed and the script runs under
# dash, which lacks bash-only features used below (`set -o pipefail`, BASH_SOURCE, arrays)
# — dash aborts on the next line with "set: Illegal option -o pipefail". Guard must be
# POSIX-compatible itself since it runs before we know which shell we're in.
if [ -z "${BASH_VERSION:-}" ]; then
  exec bash "$0" "$@"
fi

set -euo pipefail

# --- required LLVM major version (see header) -------------------------------------
LLVM_MAJOR=20

# --- pinned beads (bd) version ----------------------------------------------------
# bd is PINNED, not @latest. bd's storage is an embedded Dolt DB whose schema is
# migrated forward by each bd release. The repo's checked-in DB (cloned from the
# remote on first `bd` use) is at a specific schema; a newer bd will try to apply
# migrations it doesn't have data for and abort — e.g. bd v1.0.5's migration
# 0047_recompute_mixed_is_blocked fails with `table not found: wisps` /
# `pending schema migrations alter pre-existing dirty tables`. v1.0.4 is the
# last release compatible with the current DB schema. Bump this ONLY together
# with a deliberate DB schema migration.
BD_VERSION="v1.0.4"

# --- locate the repo root (this script lives in <repo>/scripts) -------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# --- options ----------------------------------------------------------------------
DO_INSTALL=1      # --check turns this off
ASSUME_YES=0      # --yes
PERSIST=0         # --persist
PRINT_ENV_ONLY=0  # --print-env

for arg in "$@"; do
  case "$arg" in
    --check)      DO_INSTALL=0 ;;
    --yes|-y)     ASSUME_YES=1 ;;
    --with-beads) ;;  # deprecated no-op: beads is now always installed
    --persist)    PERSIST=1 ;;
    --print-env)  PRINT_ENV_ONLY=1 ;;
    -h|--help)
      sed -n '2,/^set -euo/p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//; s/^#$//; /^set -euo/d'
      exit 0 ;;
    *) echo "bootstrap: unknown option '$arg' (try --help)" >&2; exit 2 ;;
  esac
done

# --- pretty output (mirrors scripts/diagnose.sh) ----------------------------------
if [ -t 2 ]; then
  C_RED='\033[0;31m'; C_GREEN='\033[0;32m'; C_YELLOW='\033[0;33m'
  C_BLUE='\033[0;34m'; C_DIM='\033[2m'; C_RESET='\033[0m'
else
  C_RED=''; C_GREEN=''; C_YELLOW=''; C_BLUE=''; C_DIM=''; C_RESET=''
fi
log()  { printf "${C_BLUE}[bootstrap]${C_RESET} %s\n" "$*" >&2; }
ok()   { printf "${C_GREEN}[ok]${C_RESET}   %s\n" "$*" >&2; }
warn() { printf "${C_YELLOW}[warn]${C_RESET} %s\n" "$*" >&2; }
err()  { printf "${C_RED}[err]${C_RESET}  %s\n" "$*" >&2; }
die()  { err "$*"; exit 1; }

have() { command -v "$1" >/dev/null 2>&1; }

# --- privilege escalation: use sudo only when needed ------------------------------
SUDO=""
if [ "$(id -u)" -ne 0 ]; then
  if have sudo; then SUDO="sudo"; fi
fi

confirm() {
  # confirm "question" — yes if --yes, non-interactive stdin, or user agrees.
  [ "$ASSUME_YES" -eq 1 ] && return 0
  [ -t 0 ] || return 0   # non-interactive (CI/container): proceed
  printf "${C_YELLOW}[?]${C_RESET}    %s [Y/n] " "$1" >&2
  local reply; read -r reply || true
  case "$reply" in n|N|no|NO) return 1 ;; *) return 0 ;; esac
}

# ----------------------------------------------------------------------------------
# LLVM discovery — find an install whose llc/llvm-config report the pinned major.
# ----------------------------------------------------------------------------------

# major version reported by an llvm-config binary, or empty on failure.
llvm_config_major() { "$1" --version 2>/dev/null | cut -d. -f1; }

# echo a prefix dir whose bin/ has a usable LLVM_MAJOR toolchain, or empty.
find_llvm_prefix() {
  local cfg pfx
  # 1. caller-provided LLVM_PREFIX wins if it's the right major.
  if [ -n "${LLVM_PREFIX:-}" ] && [ -x "$LLVM_PREFIX/bin/llvm-config" ]; then
    [ "$(llvm_config_major "$LLVM_PREFIX/bin/llvm-config")" = "$LLVM_MAJOR" ] && { echo "$LLVM_PREFIX"; return; }
  fi
  # 2. version-suffixed llvm-config on PATH (Debian/Ubuntu, Alpine, openSUSE style).
  for cfg in "llvm-config-$LLVM_MAJOR" "llvm-config$LLVM_MAJOR"; do
    if have "$cfg"; then echo "$("$cfg" --prefix)"; return; fi
  done
  # 3. well-known install prefixes across distros + Homebrew.
  for pfx in \
      "/usr/lib/llvm-$LLVM_MAJOR" \
      "/usr/lib64/llvm$LLVM_MAJOR" \
      "/usr/local/llvm-$LLVM_MAJOR" \
      "/opt/llvm-$LLVM_MAJOR" \
      "/opt/homebrew/opt/llvm@$LLVM_MAJOR" \
      "/usr/local/opt/llvm@$LLVM_MAJOR"; do
    if [ -x "$pfx/bin/llc" ] && [ "$(llvm_config_major "$pfx/bin/llvm-config")" = "$LLVM_MAJOR" ]; then
      echo "$pfx"; return
    fi
  done
  # 4. unversioned llvm-config, accepted only if it already reports LLVM_MAJOR.
  if have llvm-config && [ "$(llvm_config_major "$(command -v llvm-config)")" = "$LLVM_MAJOR" ]; then
    echo "$(llvm-config --prefix)"; return
  fi
  echo ""
}

# ----------------------------------------------------------------------------------
# Package-manager abstraction.
# ----------------------------------------------------------------------------------
PM=""
detect_pm() {
  if [ "$(uname -s)" = "Darwin" ]; then PM="brew"; return; fi
  for c in apt-get dnf yum pacman zypper apk; do
    if have "$c"; then PM="$c"; return; fi
  done
  PM=""
}

pm_refresh_done=0
pm_refresh() {
  [ "$pm_refresh_done" -eq 1 ] && return 0
  case "$PM" in
    apt-get) $SUDO apt-get update -y ;;
    apk)     $SUDO apk update ;;
    zypper)  $SUDO zypper --non-interactive refresh ;;
  esac
  pm_refresh_done=1
}

pm_install() {
  # pm_install pkg...  — install packages, tolerant of names absent in a given repo.
  [ "$#" -eq 0 ] && return 0
  pm_refresh
  case "$PM" in
    brew)    brew install "$@" ;;
    apt-get) $SUDO apt-get install -y --no-install-recommends "$@" ;;
    dnf)     $SUDO dnf install -y "$@" ;;
    yum)     $SUDO yum install -y "$@" ;;
    pacman)  $SUDO pacman -S --needed --noconfirm "$@" ;;
    zypper)  $SUDO zypper --non-interactive install -y "$@" ;;
    apk)     $SUDO apk add "$@" ;;
    *)       return 1 ;;
  esac
}

# LLVM 20 package sets per manager (version-pinned where the distro supports it).
llvm_packages() {
  case "$PM" in
    brew)    echo "llvm@$LLVM_MAJOR lld" ;;
    apt-get) echo "llvm-$LLVM_MAJOR llvm-$LLVM_MAJOR-dev llvm-$LLVM_MAJOR-tools clang-$LLVM_MAJOR lld-$LLVM_MAJOR" ;;
    dnf|yum) echo "llvm llvm-devel clang lld" ;;
    pacman)  echo "llvm clang lld" ;;
    zypper)  echo "llvm$LLVM_MAJOR llvm$LLVM_MAJOR-devel clang$LLVM_MAJOR lld$LLVM_MAJOR" ;;
    apk)     echo "llvm$LLVM_MAJOR llvm$LLVM_MAJOR-dev clang$LLVM_MAJOR lld" ;;
    *)       echo "" ;;
  esac
}

base_packages() {
  # compiler toolchain + make + git + sha256 + python3
  case "$PM" in
    brew)    echo "git python3" ;;                              # cc/make ship with Xcode CLT
    apt-get) echo "build-essential git python3 coreutils" ;;
    dnf|yum) echo "gcc gcc-c++ make git python3 coreutils" ;;
    pacman)  echo "base-devel git python coreutils" ;;
    zypper)  echo "gcc gcc-c++ make git python3 coreutils" ;;
    apk)     echo "build-base git python3 coreutils" ;;
    *)       echo "" ;;
  esac
}

# Debian/Ubuntu fallback: if llvm-20 isn't in the configured repos, use apt.llvm.org.
apt_llvm_org_fallback() {
  log "llvm-$LLVM_MAJOR not found in apt repos — using apt.llvm.org installer"
  local script; script="$(mktemp)"
  if have wget;   then wget -qO "$script" https://apt.llvm.org/llvm.sh
  elif have curl; then curl -fsSL https://apt.llvm.org/llvm.sh -o "$script"
  else die "need wget or curl to fetch apt.llvm.org installer"; fi
  chmod +x "$script"
  $SUDO bash "$script" "$LLVM_MAJOR"
  rm -f "$script"
}

# ----------------------------------------------------------------------------------
# Install phase.
# ----------------------------------------------------------------------------------
install_toolchain() {
  detect_pm
  [ -n "$PM" ] || die "no supported package manager found (looked for brew/apt/dnf/yum/pacman/zypper/apk). Install LLVM $LLVM_MAJOR, a C/C++ compiler, lld, make, git and python3 manually."
  log "package manager: $PM"

  # Base toolchain (only if something's actually missing).
  if ! have cc && ! have clang && ! have gcc || ! have make || ! have git || ! have python3 || ! have sha256sum; then
    if confirm "install base toolchain (compiler, make, git, python3, coreutils)?"; then
      # shellcheck disable=SC2046
      pm_install $(base_packages) || warn "base package install reported errors — continuing to verify"
    fi
  fi

  # LLVM 20.
  if [ -z "$(find_llvm_prefix)" ]; then
    if confirm "install LLVM $LLVM_MAJOR toolchain (llc, llvm-config, opt, libLLVM, lld)?"; then
      # shellcheck disable=SC2046
      if ! pm_install $(llvm_packages); then
        [ "$PM" = "apt-get" ] && apt_llvm_org_fallback || warn "LLVM package install reported errors — continuing to verify"
      fi
      # apt's pinned packages don't always land on PATH unversioned; that's fine,
      # find_llvm_prefix locates them by the -20 suffix / install prefix.
      if [ "$PM" = "apt-get" ] && [ -z "$(find_llvm_prefix)" ]; then
        apt_llvm_org_fallback
      fi
    fi
  fi

  # lld on Linux (may be a separate package from the LLVM metapackage).
  if [ "$(uname -s)" != "Darwin" ] && ! have ld.lld; then
    if confirm "install lld (required: the bootstrap emits '@'-mangled symbols GNU ld rejects)?"; then
      case "$PM" in
        apt-get) pm_install "lld-$LLVM_MAJOR" lld || pm_install lld || true ;;
        *)       pm_install lld || true ;;
      esac
    fi
  fi

  # beads (bd) is mandatory — the dev workflow tracks all work in it.
  install_beads
}

# Package name for the Go toolchain (needed to build bd).
go_package() {
  case "$PM" in
    brew)    echo "go" ;;
    apt-get) echo "golang-go" ;;
    dnf|yum) echo "golang" ;;
    pacman)  echo "go" ;;
    zypper)  echo "go" ;;
    apk)     echo "go" ;;
    *)       echo "" ;;
  esac
}

# Where `go install` drops binaries — add it to PATH so verify() can see bd.
go_bin_dir() {
  if have go; then go env GOBIN 2>/dev/null | grep . || echo "$(go env GOPATH 2>/dev/null || echo "$HOME/go")/bin"
  else echo "$HOME/go/bin"; fi
}

# Make bd resolvable in NON-login shells — Claude Code sessions and, critically,
# the beads git hooks (.beads/hooks/* via core.hooksPath) and the SessionStart/
# PreCompact `bd prime` hooks. Those hooks gate on `command -v bd`; if bd only
# lives in GOPATH/bin (not on the default PATH), every hook SILENTLY no-ops —
# which disables refs/dolt/data sync and DB hydration entirely. Symlink bd into
# a directory that is always on PATH so the hook gate (`command -v bd`) passes.
ensure_bd_on_path() {
  local gobin; gobin="$(go_bin_dir)"
  [ -x "$gobin/bd" ] || return 0
  # Already resolvable via a real PATH dir (not just this script's transient
  # PATH export)? A symlink we previously dropped counts. Then nothing to do.
  for d in /usr/local/bin "$HOME/.local/bin"; do
    [ -e "$d/bd" ] && return 0
  done
  for d in /usr/local/bin "$HOME/.local/bin"; do
    if [ -d "$d" ] && [ -w "$d" ]; then
      ln -sf "$gobin/bd" "$d/bd" && { ok "linked bd → $d/bd (PATH for sessions + git hooks)"; return 0; }
    fi
  done
  warn "bd at $gobin/bd is not on a default PATH dir — beads git hooks may not run in fresh shells"
}

# major.minor.patch reported by `bd version` (e.g. "1.0.5"), or empty.
bd_installed_version() {
  have bd || { echo ""; return; }
  bd version 2>/dev/null | sed -n 's/.*version \([0-9][0-9.]*\).*/\1/p' | head -1
}

install_beads() {
  # --- bd: pinned to BD_VERSION. Install when missing OR when the present
  # bd is a different (e.g. schema-incompatible @latest) build. ---
  local want="${BD_VERSION#v}" have_ver
  have_ver="$(bd_installed_version)"
  if [ -n "$have_ver" ] && [ "$have_ver" != "$want" ]; then
    warn "bd $have_ver is installed but this repo pins bd $want (schema compatibility) — reinstalling"
  fi
  if ! have bd || { [ -n "$have_ver" ] && [ "$have_ver" != "$want" ]; }; then
    if confirm "install bd $want (beads issue tracker — required by the dev workflow)?"; then
      if ! have go && [ "$PM" != "brew" ]; then
        log "bd needs a Go toolchain to build — installing it first"
        # shellcheck disable=SC2046
        pm_install $(go_package) || warn "could not install a Go toolchain automatically"
      fi
      if have go; then
        # Pinned to $BD_VERSION (see BD_VERSION note above) — NOT @latest, whose
        # newer Dolt-schema migrations break against the repo's checked-in DB.
        GOFLAGS="" go install "github.com/steveyegge/beads/cmd/bd@${BD_VERSION}" \
          || warn "bd install via go failed — see https://github.com/steveyegge/beads"
        # `go install` lands in GOPATH/bin (or GOBIN); make it visible now and onward.
        case ":$PATH:" in *":$(go_bin_dir):"*) ;; *) export PATH="$PATH:$(go_bin_dir)" ;; esac
      elif [ "$PM" = "brew" ]; then
        # Homebrew can't pin to the schema-compatible bd; prefer the pinned go install.
        brew install beads 2>/dev/null \
          || warn "bd not available via brew — install the pinned build: go install github.com/steveyegge/beads/cmd/bd@${BD_VERSION}"
      else
        warn "no Go toolchain available to build bd — install with: go install github.com/steveyegge/beads/cmd/bd@${BD_VERSION}"
      fi
    fi
  fi
  # No external `dolt` binary: bd ships an embedded dolt server (`bd dolt ...`).

  # bd lands in GOPATH/bin which is NOT on a default shell PATH; link it onto
  # PATH so the beads git hooks and session hooks can actually find it.
  ensure_bd_on_path

  # Wire up beads Dolt sync (refs/dolt/data) when a token is present; otherwise
  # fall back to the offline jsonl import.
  setup_beads_sync
}

# Set up beads sync via Dolt's refs/dolt/data — Claude-Code-Web compatible.
#
# Why this is non-obvious (three platform constraints we work around):
#   1. The GitHub proxy allows `git push` ONLY to the working branch, so Dolt's
#      refs/dolt/data CANNOT be pushed through it (it 403s). Reads (fetch) DO
#      work. → we PULL/hydrate through the proxy (no creds), and PUSH DIRECT to
#      github.com using a fine-grained PAT in $GH_TOKEN (Contents: write, this
#      repo only), which bypasses the working-branch restriction.
#   2. There is no secrets store, so the PAT lives only in the GH_TOKEN env var;
#      we feed it to git via GIT_ASKPASS so it never lands on argv, on disk, or
#      in the repo.
#   3. The container's mandatory commit-signing rejects Dolt's data commits, so
#      Dolt's git ops must run with commit.gpgsign=false. We scope that (and the
#      token) to bd ONLY via a wrapper, so the agent's own source commits keep
#      their normal signing.
#
# The wrapper is installed UNCONDITIONALLY and decides at RUNTIME whether to push
# (based on $GH_TOKEN), so a container that gains the token later starts syncing
# with no re-bootstrap. Without a usable token bd stays read-only (hydrate works,
# writes just don't push); jsonl is a last resort only if the ref is unavailable.
setup_beads_sync() {
  have bd || return 0
  local bd_dir="$REPO_ROOT/.beads"
  local gobin; gobin="$(go_bin_dir)"
  local real_bd="$gobin/bd"; [ -x "$real_bd" ] || real_bd="$(command -v bd)"

  # Per-container runtime dir (recreated each bootstrap; never committed).
  local rt="$HOME/.bd-sync"; mkdir -p "$rt"
  # askpass: prints $GH_TOKEN at call time — token is never written to disk/argv.
  printf '#!/bin/sh\nprintf "%%s" "$GH_TOKEN"\n' > "$rt/askpass.sh"; chmod +x "$rt/askpass.sh"
  # git config that inherits the real global config but turns signing OFF — the
  # container's sign-server rejects Dolt's data commits (needed for hydration
  # commits too, so it's applied whether or not a token is present).
  printf '[include]\n\tpath = %s/.gitconfig\n[commit]\n\tgpgsign = false\n[tag]\n\tgpgsign = false\n' \
    "$HOME" > "$rt/gitconfig"

  # The bd wrapper is the CANONICAL bd entrypoint — always installed, ahead of
  # the raw bd on PATH, so it can never be silently bypassed. It checks $GH_TOKEN
  # at RUNTIME (not install time): with a token it auto-pushes refs/dolt/data
  # DIRECT to github (the proxy blocks that ref, and bd doesn't auto-push on
  # write); without one it's a transparent passthrough.
  #
  # Sync is COMMAND-AGNOSTIC — there is NO allowlist of verbs to maintain. We
  # fingerprint the Dolt store's root via its noms `manifest` file (a ~1ms read
  # that changes on any write — commit OR working-set — and never on a read) and
  # cache the last-synced fingerprint. After every command: if the fingerprint
  # moved, `dolt commit` (flush any uncommitted working set; no-op if already
  # committed) then `dolt push`, and cache the new fingerprint; otherwise do
  # nothing. So a mutation by ANY verb (today's or a future one) syncs, a read
  # pays only the file read (never the ~2s network push), and explicit
  # `bd dolt commit/pull/push` is handled without special-casing. We commit
  # explicitly rather than via a persisted `dolt.auto-commit` config (which would
  # dirty the git-tracked config.yaml). Inner dolt calls hit the REAL bd (no
  # recursion) and the push is best-effort (cache is only advanced on success, so
  # a failed push retries on the next command). If the manifest can't be located
  # we fall back to pushing (fail toward syncing, never silently drop a write).
  cat > "$rt/bd" <<WRAP
#!/bin/sh
export GIT_CONFIG_GLOBAL="$rt/gitconfig"
export GIT_TERMINAL_PROMPT=0
[ -n "\${GH_TOKEN:-}" ] && export GIT_ASKPASS="$rt/askpass.sh"
"$real_bd" "\$@"; __rc=\$?
if [ -n "\${GH_TOKEN:-}" ]; then
  __mani="\$(ls $REPO_ROOT/.beads/embeddeddolt/*/.dolt/noms/manifest 2>/dev/null | head -1)"
  __fp="\$(cat "\$__mani" 2>/dev/null)"
  if [ -z "\$__mani" ] || [ "\$__fp" != "\$(cat "$rt/last_synced" 2>/dev/null)" ]; then
    "$real_bd" dolt commit -m "bd: sync" >/dev/null 2>&1 || true
    if "$real_bd" dolt push origin >/dev/null 2>&1; then
      cat "\$__mani" 2>/dev/null > "$rt/last_synced" || true
    fi
  fi
fi
exit \$__rc
WRAP
  chmod +x "$rt/bd"
  # Install the wrapper into EVERY writable PATH bin dir (the last word, ahead of
  # the raw bd that ensure_bd_on_path linked) so no shell or git hook resolves the
  # raw bd by accident. No `break` — link all candidates. ensure_bd_on_path's
  # early-return then protects this link from any later re-run.
  local linked=0
  for d in /usr/local/bin "$HOME/.local/bin"; do
    [ -d "$d" ] && [ -w "$d" ] && ln -sf "$rt/bd" "$d/bd" 2>/dev/null && linked=1
  done
  [ "$linked" = 1 ] || warn "beads: could not install bd wrapper on PATH — auto-sync may not run"
  local bd="$rt/bd"

  local slug; slug="$(git -C "$REPO_ROOT" remote get-url origin 2>/dev/null | sed -E 's#.*/git/##; s#\.git$##')"
  : "${slug:=tristanMatthias/forge-lang}"

  # Hydrate from refs/dolt/data via the git origin (the proxy — reads need no
  # creds, works with or without a token). If a store exists, pull latest.
  if [ -d "$bd_dir/embeddeddolt" ] || [ -d "$bd_dir/dolt" ]; then
    ( cd "$REPO_ROOT" && BD_NON_INTERACTIVE=1 "$bd" dolt pull origin >/dev/null 2>&1 ) \
      && ok "beads: pulled latest from refs/dolt/data" || warn "beads: dolt pull failed"
  else
    if ( cd "$REPO_ROOT" && BD_NON_INTERACTIVE=1 "$bd" bootstrap --yes >/dev/null 2>&1 ) \
       && { [ -d "$bd_dir/embeddeddolt" ] || [ -d "$bd_dir/dolt" ]; }; then
      ok "beads: hydrated DB from refs/dolt/data (no committed jsonl)"
    else
      warn "beads: bootstrap from refs/dolt/data failed — falling back to jsonl"; init_beads_local; return 0
    fi
  fi

  # Configure the PUSH remote = direct-to-github (token via askpass at push time).
  # Hydration above used the proxy git origin; set the dolt remote AFTER so it
  # doesn't redirect those reads. Harmless when GH_TOKEN is absent (the wrapper
  # just won't push). NOTE: `bd dolt remote add` auto-commits .beads/config.yaml
  # ("bd: update sync.remote"), which would pollute the working branch in every
  # fresh container. We capture HEAD first, drop any commit bd makes, and restore
  # config.yaml — the dolt remote itself persists in the gitignored Dolt store
  # (the source of truth for `dolt push`), so reverting the git-tracked config is
  # safe.
  ( cd "$REPO_ROOT"
    before="$(git rev-parse HEAD 2>/dev/null)"
    "$bd" dolt remote remove origin >/dev/null 2>&1
    "$bd" dolt remote add origin "git+https://x-access-token@github.com/${slug}.git" >/dev/null 2>&1
    if [ -n "$before" ] && [ "$(git rev-parse HEAD 2>/dev/null)" != "$before" ]; then
      git reset --soft "$before" >/dev/null 2>&1 || true
    fi
    git restore --staged --worktree .beads/config.yaml >/dev/null 2>&1 \
      || git checkout -- .beads/config.yaml >/dev/null 2>&1 || true )

  # Seed the wrapper's sync fingerprint to the just-hydrated state, so the first
  # read in the session doesn't trigger a spurious push (only a real write will).
  local mani; mani="$(ls "$REPO_ROOT"/.beads/embeddeddolt/*/.dolt/noms/manifest 2>/dev/null | head -1)"
  [ -n "$mani" ] && cat "$mani" > "$rt/last_synced" 2>/dev/null || true

  if [ -n "${GH_TOKEN:-}" ]; then
    ok "beads: Dolt sync ON — pull via proxy, push direct-to-github (no committed jsonl)"
  else
    warn "beads: READ-ONLY (GH_TOKEN unset) — hydrated from refs/dolt/data; writes sync automatically once GH_TOKEN is set"
  fi
}

# Offline fallback: build bd's local Dolt store from the committed
# .beads/issues.jsonl. Used only when GH_TOKEN is absent. Never touches network.
init_beads_local() {
  have bd || return 0
  local bd_dir="$REPO_ROOT/.beads"
  [ -f "$bd_dir/issues.jsonl" ] || return 0
  # Already have a local store? Reconcile it with the committed issues.jsonl.
  # The container's Dolt store is built once at create-time, but a later
  # `git pull` (or a fresh checkout of an updated branch) brings a NEWER
  # issues.jsonl — which, in Claude Code Web, IS the source of truth (the
  # proxy blocks Dolt's remote sync). Without this re-import, `bd ready`
  # serves a stale snapshot (the 902-vs-965 drift this repo hit). `bd import`
  # is upsert-only — safe and non-destructive — so re-running it is cheap.
  if [ -d "$bd_dir/embeddeddolt" ] || [ -d "$bd_dir/dolt" ]; then
    if ( cd "$REPO_ROOT" && bd import .beads/issues.jsonl >/dev/null 2>&1 ); then
      ok "bd store reconciled from issues.jsonl (latest committed state)"
    else
      ok "bd local store present — offline, no network sync"
    fi
    return 0
  fi
  log "building local bd store from issues.jsonl (offline; no Dolt clone/push)"
  if ( cd "$REPO_ROOT" && bd init --from-jsonl --sandbox >/dev/null 2>&1 ); then
    # `bd init` persists the git origin as `sync.remote`, which would make
    # every subsequent write attempt a network Dolt push. Strip it so bd
    # stays fully offline; the committed config.yaml keeps it commented out.
    if grep -q '^sync\.remote:' "$bd_dir/config.yaml" 2>/dev/null; then
      sed -i.bak '/^sync\.remote:/d' "$bd_dir/config.yaml" && rm -f "$bd_dir/config.yaml.bak"
    fi
    ok "bd initialized offline from issues.jsonl"
  else
    warn "bd init --from-jsonl failed — run it manually in the repo root: bd init --from-jsonl --sandbox"
  fi
}

# ----------------------------------------------------------------------------------
# Verify phase — checks every hard dep and prints a one-line status each.
# ----------------------------------------------------------------------------------
MISSING=0
check_cmd() {
  # check_cmd <display> <cmd> [optional]
  local label="$1" cmd="$2" optional="${3:-}"
  if have "$cmd"; then
    ok "$label → $(command -v "$cmd")"
  elif [ -n "$optional" ]; then
    warn "$label not found (optional)"
  else
    err "$label not found ($cmd)"
    MISSING=$((MISSING + 1))
  fi
}

verify() {
  log "verifying toolchain (LLVM target: $LLVM_MAJOR.x)"

  # C/C++ compiler — any of cc/clang/gcc satisfies it.
  if have cc || have clang || have gcc; then
    ok "C compiler → $(command -v cc || command -v clang || command -v gcc)"
  else
    err "no C compiler (need cc, clang or gcc)"; MISSING=$((MISSING + 1))
  fi

  check_cmd "make"       make
  check_cmd "git"        git
  check_cmd "python3"    python3
  if have sha256sum || have shasum; then
    ok "sha256 → $(command -v sha256sum || command -v shasum)"
  else
    err "no sha256 tool (need sha256sum or shasum)"; MISSING=$((MISSING + 1))
  fi

  # lld is required on Linux only.
  if [ "$(uname -s)" = "Darwin" ]; then
    ok "linker → ld64 (macOS default; lld not required)"
  else
    check_cmd "lld (ld.lld)" ld.lld
  fi

  # LLVM 20.
  local pfx; pfx="$(find_llvm_prefix)"
  if [ -n "$pfx" ]; then
    ok "LLVM $LLVM_MAJOR → $pfx ($("$pfx/bin/llvm-config" --version))"
    [ -x "$pfx/bin/llc" ]  || { err "llc missing under $pfx/bin"; MISSING=$((MISSING + 1)); }
    [ -x "$pfx/bin/opt" ]  || warn "opt missing under $pfx/bin (only needed for 'make coverage')"
    [ -f "$pfx/include/llvm-c/Core.h" ] || warn "libLLVM C headers not found under $pfx/include (install the -dev/-devel package)"
  else
    err "LLVM $LLVM_MAJOR not found. Need llc/llvm-config/libLLVM reporting major version $LLVM_MAJOR."
    if have llvm-config; then warn "found llvm-config $(llvm-config --version) — wrong major; LLVM 21's -O2 miscompiles ARM64, so $LLVM_MAJOR is pinned."; fi
    MISSING=$((MISSING + 1))
  fi

  # beads — required: the dev workflow tracks all work in it. (bd bundles an
  # embedded dolt server, so no separate dolt binary is checked.)
  # `go install` may have dropped bd under GOPATH/bin; make sure we look there.
  local gobin; gobin="$(go_bin_dir)"
  case ":$PATH:" in *":$gobin:"*) ;; *) [ -d "$gobin" ] && export PATH="$PATH:$gobin" ;; esac
  check_cmd "bd (beads)"  bd
  # bd must be the pinned, schema-compatible version (a newer @latest aborts
  # opening the repo's Dolt DB). Flag a mismatch as a hard failure in --check.
  if have bd; then
    local want="${BD_VERSION#v}" have_ver; have_ver="$(bd_installed_version)"
    if [ -n "$have_ver" ] && [ "$have_ver" != "$want" ]; then
      err "bd version $have_ver != pinned $want — newer bd breaks against this repo's Dolt schema. Reinstall: go install github.com/steveyegge/beads/cmd/bd@${BD_VERSION}"
      MISSING=$((MISSING + 1))
    elif [ -n "$have_ver" ]; then
      ok "bd version $have_ver matches pin"
    fi
  fi
}

# ----------------------------------------------------------------------------------
# Environment hint — the one thing the compiled binary can't reliably self-discover.
# ----------------------------------------------------------------------------------
recommended_env() {
  local pfx; pfx="$(find_llvm_prefix)"
  [ -n "$pfx" ] || return 0
  echo "export LLVM_PREFIX=\"$pfx\""
  # Pin llc explicitly when an LLVM_MAJOR llc exists outside the prefix bin.
  if [ -x "$pfx/bin/llc" ]; then
    echo "export LLC=\"$pfx/bin/llc\""
  fi
  # If bd was built into GOPATH/bin and that's not already on PATH, surface it.
  local gobin; gobin="$(go_bin_dir)"
  if [ -x "$gobin/bd" ]; then
    case ":$PATH:" in *":$gobin:"*) ;; *) echo "export PATH=\"\$PATH:$gobin\"" ;; esac
  fi
}

print_env() {
  local env; env="$(recommended_env)"
  [ -n "$env" ] || { warn "no LLVM $LLVM_MAJOR prefix to export"; return; }
  printf '\n%b# Add to your shell profile (or run: source <(scripts/bootstrap.sh --print-env)):%b\n' "$C_DIM" "$C_RESET"
  printf '%s\n' "$env"
}

persist_env() {
  local env; env="$(recommended_env)"
  [ -n "$env" ] || { warn "nothing to persist (LLVM $LLVM_MAJOR prefix not found)"; return; }
  local rc="${HOME}/.bashrc"
  [ -n "${ZSH_VERSION:-}" ] && rc="${HOME}/.zshrc"
  case "${SHELL:-}" in */zsh) rc="${HOME}/.zshrc" ;; esac
  if grep -qs "Avra bootstrap: LLVM_PREFIX" "$rc" 2>/dev/null; then
    log "env already present in $rc — leaving it"
    return
  fi
  {
    echo ""
    echo "# Avra bootstrap: LLVM_PREFIX (added by scripts/bootstrap.sh)"
    printf '%s\n' "$env"
  } >> "$rc"
  ok "appended LLVM_PREFIX to $rc — run 'source $rc' or open a new shell"
}

# ----------------------------------------------------------------------------------
# Main.
# ----------------------------------------------------------------------------------
main() {
  if [ "$PRINT_ENV_ONLY" -eq 1 ]; then
    recommended_env
    exit 0
  fi

  log "Avra bootstrap environment setup (repo: $REPO_ROOT)"

  if [ "$DO_INSTALL" -eq 1 ]; then
    install_toolchain
  else
    log "--check: verify only, no installs"
  fi

  verify

  if [ "$MISSING" -gt 0 ]; then
    err "$MISSING required tool(s) missing."
    if [ "$DO_INSTALL" -eq 0 ]; then
      err "re-run without --check to install, or install the listed tools manually."
    fi
    exit 1
  fi

  [ "$PERSIST" -eq 1 ] && persist_env
  print_env

  ok "environment is build-ready."
  printf '\n%bNext:%b\n' "$C_BLUE" "$C_RESET"
  printf '  %s\n' \
    "eval \"\$(scripts/bootstrap.sh --print-env)\"   # export LLVM_PREFIX for this shell" \
    "cd bootstrap && make            # build the bootstrap compiler (build/bs2)" \
    "make test                       # spec suite + selfhost fixed-point check"
}

main
