#!/bin/bash
# Capture expected output for new regression tests.
# Usage: bash scripts/capture_regress.sh

set -euo pipefail

DIR="$(cd "$(dirname "$0")/.." && pwd)"
BS2="$DIR/build/bs2"
RUNTIME="$DIR/build/runtime.o"
REGRESS="$DIR/regress"

if [ ! -x "$BS2" ]; then
  echo "ERROR: bs2 not found at $BS2" >&2
  exit 1
fi

for name in enum_match struct_mutation while_break nested_if_else multi_arg_call substring; do
  fg="$REGRESS/$name.fg"
  out="$REGRESS/$name.out"
  if [ ! -f "$fg" ]; then
    echo "SKIP: $fg not found"
    continue
  fi
  if [ -f "$out" ]; then
    echo "SKIP: $out already exists"
    continue
  fi

  echo "--- $name ---"
  if ! "$BS2" compile "$fg" 2>&1; then
    echo "FAIL: codegen for $name"
    continue
  fi

  bin="/tmp/regress_$name"
  if ! cc -o "$bin" "$fg.ll" "$RUNTIME" 2>&1; then
    echo "FAIL: link for $name"
    continue
  fi

  actual=$("$bin" 2>&1) || true
  printf '%s\n' "$actual" > "$out"
  echo "OK: captured $out"
  rm -f "$bin"
done

echo "Done."
