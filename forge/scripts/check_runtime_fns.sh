#!/bin/bash
# Check that all C runtime functions used in Forge source are registered
# in the Rust compiler's runtime_fn! registry.
# Run: bash scripts/check_runtime_fns.sh

FORGE_SRC="packages/forgec/src"
RUST_REG="packages/forgec-rust/features"

echo "=== Checking runtime function registration ==="
MISSING=0

# Find all forge_* function calls in Forge source (excluding comments)
for fn in $(grep -roh 'forge_[a-z_]*(' "$FORGE_SRC" | sed 's/($//' | sort -u); do
    # Skip: LLVM wrappers, mini-only, parser internals, already-handled
    case "$fn" in
        forge_llvm_*|forge_parser_*|forge_set_token_list|forge_peek_kind_id|forge_extract_body_source) continue ;;
        forge_mini_*|forge_free|forge_set_args) continue ;;  # mini-only or main-only
        forge_string_len|forge_string_method|forge_fs_write_string|forge_write_lines|forge_join_lines) continue ;;  # unused or aliased
    esac
    # Check if registered
    if ! grep -rq "\"$fn\"" "$RUST_REG" 2>/dev/null; then
        echo "  MISSING: $fn"
        MISSING=$((MISSING + 1))
    fi
done

if [ $MISSING -eq 0 ]; then
    echo "  All runtime functions registered."
else
    echo "  $MISSING unregistered function(s)!"
    exit 1
fi
