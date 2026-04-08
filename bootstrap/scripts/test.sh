#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
BOOTSTRAP_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
REPO_DIR=$(CDPATH= cd -- "$BOOTSTRAP_DIR/.." && pwd)
FORGE_DIR="$REPO_DIR/forge"
BUILD_DIR="$BOOTSTRAP_DIR/build"
HOST_COMPILER="$FORGE_DIR/target/release/forgec"

if [ ! -x "$HOST_COMPILER" ]; then
  (cd "$FORGE_DIR" && cargo build --release)
fi

if [ ! -f "$FORGE_DIR/packages/std-process/target/release/libforge_process.a" ]; then
  (cd "$FORGE_DIR/packages/std-process" && cargo build --release)
fi

mkdir -p "$BUILD_DIR"
"$HOST_COMPILER" build "$BOOTSTRAP_DIR" --dev -o "$BUILD_DIR/bootstrapc"

cases=0

for input in "$BOOTSTRAP_DIR"/tests/scanner/*.fg; do
  name=$(basename "$input" .fg)
  expected="$BOOTSTRAP_DIR/tests/scanner/$name.tokens"
  actual="$BUILD_DIR/$name.actual"
  stderr_log="$BUILD_DIR/$name.stderr"

  echo "scanner/$name"
  if ! "$BUILD_DIR/bootstrapc" tokens "$input" > "$actual" 2> "$stderr_log"; then
    cat "$stderr_log"
    exit 1
  fi
  diff -u "$expected" "$actual"
  cases=$((cases + 1))
done

echo "PASS $cases scanner cases"
