#!/bin/bash
# Check for C-side functions called from Forge source but not declared in Rust compiler
# Usage: bash scripts/check_undeclared.sh

set -e
cd "$(dirname "$0")/.."

echo "=== Undeclared C-side Function Checker ==="

# Extract all forge_* function calls from .fg source files
CALLED=$(grep -roh 'forge_[a-z_]*(' packages/forgec/src/ --include="*.fg" | sed 's/($//' | sort -u)

# Extract all declared functions from Rust compiler registry
DECLARED=$(grep 'runtime_fn!.*name:' packages/forgec-rust/features/strings/mod.rs | sed 's/.*name: "//; s/".*//' | sort -u)

# Also add functions declared in other feature files
DECLARED2=$(grep -roh 'runtime_fn!.*name: "[^"]*"' packages/forgec-rust/ --include="*.rs" | sed 's/.*name: "//; s/".*//' | sort -u)

ALL_DECLARED=$(echo "$DECLARED"; echo "$DECLARED2" | sort -u)

echo ""
echo "Called from .fg source (forge_* functions):"
MISSING=0
for fn in $CALLED; do
    if ! echo "$ALL_DECLARED" | grep -qx "$fn"; then
        # Check if it exists in runtime.c
        if grep -q "^[a-zA-Z].*$fn(" stdlib/runtime.c 2>/dev/null; then
            echo "  MISSING: $fn (exists in runtime.c but not declared in Rust compiler)"
            MISSING=$((MISSING + 1))
        fi
    fi
done

if [ $MISSING -eq 0 ]; then
    echo "  All forge_* functions are properly declared!"
else
    echo ""
    echo "  $MISSING function(s) missing declarations"
    echo "  Add them to packages/forgec-rust/features/strings/mod.rs"
fi

# Also check for llvm_* functions (non-forge prefix)
echo ""
echo "Non-forge C functions called from .fg:"
LLVM_CALLED=$(grep -roh 'llvm_[a-z_]*(' packages/forgec/src/ --include="*.fg" | sed 's/($//' | sort -u)
LLVM_MISSING=0
for fn in $LLVM_CALLED; do
    if ! echo "$ALL_DECLARED" | grep -qx "$fn"; then
        # Check std-llvm
        if grep -q "fn $fn\|fn forge_$fn" packages/std-llvm/src/lib.rs 2>/dev/null; then
            : # exists as forge_ prefixed — OK
        elif grep -q "$fn" packages/std-llvm/src/lib.rs 2>/dev/null; then
            : # exists somehow — OK
        else
            echo "  MISSING: $fn"
            LLVM_MISSING=$((LLVM_MISSING + 1))
        fi
    fi
done

if [ $LLVM_MISSING -eq 0 ]; then
    echo "  All llvm_* functions found in std-llvm!"
fi

echo ""
echo "=== Done ==="
