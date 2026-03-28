#!/bin/bash
# Patch bootstrap.ll to fix known codegen bugs from the old bootstrap compiler.
# These fixes are ONE-TIME — once a clean Stage 2 is produced, this script is unnecessary.
#
# Bugs fixed:
# 1. %Severity type leak: some functions load ForgeString params as %Severity
# 2. Global assignment: MODULE_PATHS_CSV store goes to local alloca instead of global
# 3. find_nmod: byte_at calls dropped by codegen, function body is empty loop

set -e
INPUT="${1:-output.ll}"
echo "Patching $INPUT..."

# Fix 1: %Severity leaks in string_to_chars, find_byte, find_nmod
# These functions load ForgeString params as %Severity and alloca i64 as %Severity
for pattern in \
  's/load %Severity, ptr %2, align 4/load %ForgeString, ptr %2, align 8/' \
  's/call i64 @forge_string_length(%Severity/call i64 @forge_string_length(%ForgeString/' \
  's/alloca %Severity, align 8/alloca i64, align 8/' \
  's/load %Severity, ptr %3, align 4/load %ForgeString, ptr %3, align 8/' \
; do
  # Only apply outside severity_to_string (which correctly uses %Severity)
  LC_ALL=C sed -i '' "/define.*@severity_to_string/,/^define/!{$pattern;}" "$INPUT"
done

# Fix 2: MODULE_PATHS_CSV global assignment in collect_module_paths
# The store goes to local %2 instead of @MODULE_PATHS_CSV
LC_ALL=C sed -i '' '/define.*@collect_module_paths/,/^define/{
  s/store %ForgeString %27, ptr %2, align 8/store %ForgeString %27, ptr @MODULE_PATHS_CSV, align 8/
}' "$INPUT"

# Fix 3: Replace find_nmod with correct implementation
# The old bootstrap drops forge_string_byte_at calls, leaving an empty loop
NMOD_START=$(grep -n "^define.*@find_nmod" "$INPUT" | head -1 | cut -d: -f1)
NMOD_END=$(awk "NR>$NMOD_START && /^define/{print NR; exit}" "$INPUT")
NMOD_END=$((NMOD_END - 1))

if [ -n "$NMOD_START" ] && [ -n "$NMOD_END" ]; then
  # Delete old find_nmod and insert correct version
  head -n $((NMOD_START - 1)) "$INPUT" > /tmp/patched_bootstrap.ll
  cat >> /tmp/patched_bootstrap.ll << 'FIND_NMOD'
define i64 @find_nmod(%ForgeString %0) {
  %s = alloca %ForgeString, align 8
  store %ForgeString %0, ptr %s, align 8
  %sval = load %ForgeString, ptr %s, align 8
  %len = call i64 @forge_string_length(%ForgeString %sval)
  %too_short = icmp slt i64 %len, 5
  br i1 %too_short, label %ret_neg, label %loop_init
ret_neg:
  ret i64 -1
loop_init:
  %limit = sub i64 %len, 4
  br label %loop
loop:
  %i = phi i64 [ 0, %loop_init ], [ %i_next, %no_match ]
  %done = icmp sge i64 %i, %limit
  br i1 %done, label %ret_neg, label %check_nl
check_nl:
  %sval1 = load %ForgeString, ptr %s, align 8
  %b0 = call i64 @forge_string_byte_at(%ForgeString %sval1, i64 %i)
  %is_nl = icmp eq i64 %b0, 10
  br i1 %is_nl, label %check_m, label %no_match
check_m:
  %i1 = add i64 %i, 1
  %sval2 = load %ForgeString, ptr %s, align 8
  %b1 = call i64 @forge_string_byte_at(%ForgeString %sval2, i64 %i1)
  %is_m = icmp eq i64 %b1, 109
  br i1 %is_m, label %check_o, label %no_match
check_o:
  %i2 = add i64 %i, 2
  %sval3 = load %ForgeString, ptr %s, align 8
  %b2 = call i64 @forge_string_byte_at(%ForgeString %sval3, i64 %i2)
  %is_o = icmp eq i64 %b2, 111
  br i1 %is_o, label %check_d, label %no_match
check_d:
  %i3 = add i64 %i, 3
  %sval4 = load %ForgeString, ptr %s, align 8
  %b3 = call i64 @forge_string_byte_at(%ForgeString %sval4, i64 %i3)
  %is_d = icmp eq i64 %b3, 100
  br i1 %is_d, label %check_sp, label %no_match
check_sp:
  %i4 = add i64 %i, 4
  %sval5 = load %ForgeString, ptr %s, align 8
  %b4 = call i64 @forge_string_byte_at(%ForgeString %sval5, i64 %i4)
  %is_sp = icmp eq i64 %b4, 32
  br i1 %is_sp, label %found, label %no_match
found:
  ret i64 %i
no_match:
  %i_next = add i64 %i, 1
  br label %loop
}
FIND_NMOD
  tail -n +$((NMOD_END + 1)) "$INPUT" >> /tmp/patched_bootstrap.ll
  mv /tmp/patched_bootstrap.ll "$INPUT"
fi

# Also fix find_byte and try_load_mod if needed (same pattern)
# Fix try_load_mod: alloca i64 for string vars → alloca %ForgeString
LC_ALL=C sed -i '' '/define.*@try_load_mod/,/^define/{
  s/alloca i64, align 8/alloca %ForgeString, align 8/g
  s/load i64, ptr %9, align 4/load %ForgeString, ptr %9, align 8/g
  s/load i64, ptr %14, align 4/load %ForgeString, ptr %14, align 8/g
  s/forge_selfhost_fs_read(i64/forge_selfhost_fs_read(%ForgeString/g
  s/collect_module_paths(i64/collect_module_paths(%ForgeString/g
}' "$INPUT"

echo "Patched successfully"
