#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
BOOTSTRAP_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
REPO_DIR=$(CDPATH= cd -- "$BOOTSTRAP_DIR/.." && pwd)
FORGE_DIR="$REPO_DIR/avra"
BUILD_DIR="$BOOTSTRAP_DIR/build"
HOST_COMPILER="$FORGE_DIR/target/release/avrac"

if [ ! -x "$HOST_COMPILER" ]; then
  (cd "$FORGE_DIR" && cargo build --release)
fi

if [ ! -f "$FORGE_DIR/packages/std-process/target/release/libavra_process.a" ]; then
  (cd "$FORGE_DIR/packages/std-process" && cargo build --release)
fi

# libavra_llvm.a no longer needed — bootstrap uses llvm_wrapper.c directly

mkdir -p "$BUILD_DIR"
build_log="$BUILD_DIR/build.log"
if ! "$HOST_COMPILER" build "$BOOTSTRAP_DIR" --dev -o "$BUILD_DIR/bootstrapc" > "$build_log" 2>&1; then
  cat "$build_log"
  exit 1
fi

cases=0

for input in "$BOOTSTRAP_DIR"/tests/scanner/*.av; do
  name=$(basename "$input" .av)
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

for input in "$BOOTSTRAP_DIR"/tests/expr/*.av; do
  name=$(basename "$input" .av)
  expected="$BOOTSTRAP_DIR/tests/expr/$name.ast"
  actual="$BUILD_DIR/$name.actual"
  stderr_log="$BUILD_DIR/$name.stderr"

  echo "expr/$name"
  if ! "$BUILD_DIR/bootstrapc" expr "$input" > "$actual" 2> "$stderr_log"; then
    cat "$stderr_log"
    exit 1
  fi
  diff -u "$expected" "$actual"
  cases=$((cases + 1))
done

for input in "$BOOTSTRAP_DIR"/tests/program/*.av; do
  name=$(basename "$input" .av)
  expected="$BOOTSTRAP_DIR/tests/program/$name.ast"
  actual="$BUILD_DIR/$name.actual"
  stderr_log="$BUILD_DIR/$name.stderr"

  echo "program/$name"
  if ! "$BUILD_DIR/bootstrapc" program "$input" > "$actual" 2> "$stderr_log"; then
    cat "$stderr_log"
    exit 1
  fi
  diff -u "$expected" "$actual"
  cases=$((cases + 1))
done

for input in "$BOOTSTRAP_DIR"/tests/eval/*.av; do
  name=$(basename "$input" .av)
  expected="$BOOTSTRAP_DIR/tests/eval/$name.out"
  actual="$BUILD_DIR/$name.actual"
  stderr_log="$BUILD_DIR/$name.stderr"

  echo "eval/$name"
  if ! "$BUILD_DIR/bootstrapc" eval "$input" > "$actual" 2> "$stderr_log"; then
    cat "$stderr_log"
    exit 1
  fi
  diff -u "$expected" "$actual"
  cases=$((cases + 1))
done

for input in "$BOOTSTRAP_DIR"/tests/check/*.av; do
  name=$(basename "$input" .av)
  actual="$BUILD_DIR/$name.actual"
  stderr_log="$BUILD_DIR/$name.stderr"

  # Error tests have .err, success tests have .out
  if [ -f "$BOOTSTRAP_DIR/tests/check/$name.err" ]; then
    expected="$BOOTSTRAP_DIR/tests/check/$name.err"
    echo "check/$name (error)"
    if "$BUILD_DIR/bootstrapc" check "$input" > "$actual" 2> "$stderr_log"; then
      echo "FAIL: expected error but check succeeded"
      exit 1
    fi
    # Error message goes to stderr; filter runtime debug noise
    grep -v '^\[' "$stderr_log" > "$actual"
    diff -u "$expected" "$actual"
  else
    expected="$BOOTSTRAP_DIR/tests/check/$name.out"
    echo "check/$name"
    if ! "$BUILD_DIR/bootstrapc" check "$input" > "$actual" 2> "$stderr_log"; then
      cat "$stderr_log"
      exit 1
    fi
    diff -u "$expected" "$actual"
  fi
  cases=$((cases + 1))
done

for input in "$BOOTSTRAP_DIR"/tests/run/*.av; do
  name=$(basename "$input" .av)
  expected="$BOOTSTRAP_DIR/tests/run/$name.out"
  actual="$BUILD_DIR/$name.actual"
  stderr_log="$BUILD_DIR/$name.stderr"

  echo "run/$name"
  if ! "$BUILD_DIR/bootstrapc" run "$input" > "$actual" 2> "$stderr_log"; then
    cat "$stderr_log"
    exit 1
  fi
  diff -u "$expected" "$actual"
  cases=$((cases + 1))
done

for input in "$BOOTSTRAP_DIR"/tests/compile/*.av; do
  name=$(basename "$input" .av)
  expected_exit=$(cat "$BOOTSTRAP_DIR/tests/compile/$name.exit")
  ll_path="$BUILD_DIR/$name.ll"
  bin_path="$BUILD_DIR/$name.bin"
  stderr_log="$BUILD_DIR/$name.stderr"

  echo "compile/$name"
  cp "$input" "$BUILD_DIR/$name.av"
  if ! "$BUILD_DIR/bootstrapc" compile "$BUILD_DIR/$name.av" > /dev/null 2> "$stderr_log"; then
    cat "$stderr_log"
    exit 1
  fi
  mv "$BUILD_DIR/$name.av.ll" "$ll_path"
  if ! cc -o "$bin_path" "$ll_path" 2> "$stderr_log"; then
    cat "$stderr_log"
    exit 1
  fi
  stdout_log="$BUILD_DIR/$name.stdout"
  set +e
  "$bin_path" > "$stdout_log"
  actual_exit=$?
  set -e
  if [ "$actual_exit" != "$expected_exit" ]; then
    echo "FAIL: expected exit $expected_exit, got $actual_exit"
    exit 1
  fi
  if [ -f "$BOOTSTRAP_DIR/tests/compile/$name.stdout" ]; then
    diff -u "$BOOTSTRAP_DIR/tests/compile/$name.stdout" "$stdout_log"
  fi
  cases=$((cases + 1))
done

echo "PASS $cases total cases"
