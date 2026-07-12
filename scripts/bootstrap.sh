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
# Task tracking is handled by the Agent Tasks MCP (mcp__Agent_Tasks__*), not by
# anything this script installs.
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
