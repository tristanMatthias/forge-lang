#!/bin/bash
# Build Stage 2 binary from Stage 1
# Usage: ./scripts/build_stage2.sh
set -e

LLVM_PREFIX=/opt/homebrew/opt/llvm@18
LLC=$LLVM_PREFIX/bin/llc
STD_LLVM_LIB=packages/std-llvm/target/release/libforge_llvm.a
RUNTIME_O=/tmp/mini_runtime.o

echo "=== Step 1: Compile runtime ==="
cc -c -O0 stdlib/runtime.c -o $RUNTIME_O

echo "=== Step 2: Build mini → Stage 1 IR ==="
LLVM_SYS_180_PREFIX=$LLVM_PREFIX ./target/release/forgec run packages/forgec/src/mini/main.fg -- build packages/forgec/src/main.fg 2>&1 | tail -3

echo "=== Step 3: Compile Stage 1 IR ==="
$LLC -O2 -filetype=obj /tmp/mini_output.ll -o /tmp/stage1.o

echo "=== Step 4: Link Stage 1 ==="
cc -o /tmp/stage1 /tmp/stage1.o $RUNTIME_O -lm -Wl,-stack_size,0x10000000 \
    $STD_LLVM_LIB $LLVM_PREFIX/lib/libLLVM-18.dylib -lstdc++ -lz -lcurses 2>&1 | grep -v "^ld: warning"

echo "=== Step 5: Stage 1 builds Stage 2 IR ==="
/tmp/stage1 build packages/forgec/src/main.fg 2>&1 | grep 'ac_stats'

echo "=== Audit ==="
bash scripts/audit_stage2.sh output.ll

echo "=== Step 6: Patch Stage 2 IR ==="
python3 scripts/patch_stage2.py output.ll /tmp/s2patched.ll
echo "Patched"

echo "=== Step 7: Compile Stage 2 ==="
$LLC -O2 -filetype=obj /tmp/s2patched.ll -o /tmp/stage2.o

echo "=== Step 8: Link Stage 2 ==="
cc -o /tmp/stage2 /tmp/stage2.o $RUNTIME_O -lm -Wl,-stack_size,0x10000000 \
    $STD_LLVM_LIB $LLVM_PREFIX/lib/libLLVM-18.dylib -lstdc++ -lz -lcurses 2>&1 | grep -v "^ld: warning"

echo ""
echo "Stage 2 binary: /tmp/stage2"
file /tmp/stage2
