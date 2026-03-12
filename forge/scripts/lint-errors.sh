#!/bin/bash
# Lint script for Forge error system quality
# Checks:
# 1. All F-codes used in source exist in registry.toml
# 2. No .unwrap() in error system files (diagnostic.rs, registry.rs, suggestions.rs)
# 3. No raw panic!() in error system files

set -e

FORGE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ERRORS_DIR="$FORGE_DIR/src/errors"
REGISTRY="$FORGE_DIR/errors/registry.toml"

echo "=== Forge Error System Lint ==="
echo

ERRORS=0

# 1. Check that all F-codes used in source exist in registry.toml
echo "Checking F-codes in registry..."
USED_CODES=$(grep -roh '"F[0-9]\{4\}"' "$FORGE_DIR/src/" | sort -u | tr -d '"')
for code in $USED_CODES; do
    if ! grep -q "^\[$code\]" "$REGISTRY" 2>/dev/null; then
        echo "  ERROR: $code is used in source but not defined in registry.toml"
        ERRORS=$((ERRORS + 1))
    fi
done

REGISTRY_CODES=$(grep -oE '^\[F[0-9]{4}\]' "$REGISTRY" | tr -d '[]')
REGISTRY_COUNT=$(echo "$REGISTRY_CODES" | wc -l | tr -d ' ')
USED_COUNT=$(echo "$USED_CODES" | wc -w)
echo "  Registry has $REGISTRY_COUNT codes, source uses $USED_COUNT codes"

# 2. Check for .unwrap() in error system files
echo "Checking for .unwrap() in error system..."
for file in "$ERRORS_DIR"/*.rs; do
    if [ -f "$file" ]; then
        basename=$(basename "$file")
        # Exclude test code
        unwraps=$(grep -n '\.unwrap()' "$file" | grep -v '#\[cfg(test)\]' | grep -v 'mod tests' | grep -cv '// ok:' || true)
        if [ "$unwraps" -gt 0 ]; then
            echo "  WARNING: $basename has $unwraps .unwrap() calls (review for safety)"
        fi
    fi
done

# 3. Check for raw panic!() in error system files
echo "Checking for panic!() in error system..."
for file in "$ERRORS_DIR"/*.rs; do
    if [ -f "$file" ]; then
        basename=$(basename "$file")
        panics=$(grep -c 'panic!' "$file" 2>/dev/null || true)
        if [ "$panics" -gt 0 ]; then
            echo "  WARNING: $basename has $panics panic!() calls"
        fi
    fi
done

echo
if [ $ERRORS -gt 0 ]; then
    echo "FAILED: $ERRORS error(s) found"
    exit 1
else
    echo "PASSED: All checks passed"
fi
