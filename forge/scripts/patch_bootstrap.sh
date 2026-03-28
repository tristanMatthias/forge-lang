#!/bin/bash
set -e
F="${1:-output.ll}"
echo "Patching $F..."

# 1. Add forge_string_byte_at declaration (not in old bootstrap's cg_init_runtime)
LC_ALL=C sed -i '' '/declare i64 @forge_string_index_of/a\
declare i64 @forge_string_byte_at(%ForgeString, i64)
' "$F"

# 2. Fix %Severity leaks (NOT in severity_to_string which correctly uses it)
LC_ALL=C sed -i '' '/define.*@severity_to_string/,/^define/!{
  s/load %Severity, ptr/load %ForgeString, ptr/g
  s/call i64 @forge_string_length(%Severity/call i64 @forge_string_length(%ForgeString/g
  s/alloca %Severity, align/alloca i64, align/g
}' "$F"

# 3. Fix MODULE_PATHS_CSV store in collect_module_paths
LC_ALL=C sed -i '' '/define.*@collect_module_paths/,/^define/{
  s/store %ForgeString %27, ptr %2, align 8/store %ForgeString %27, ptr @MODULE_PATHS_CSV, align 8/
}' "$F"

# 4. Fix try_load_mod string vars stored as i64
S=$(grep -n "define.*@try_load_mod" "$F" | head -1 | cut -d: -f1)
LC_ALL=C sed -i '' "${S},$((S+50)){
  /store %ForgeString %8, ptr %9/{
    N
  }
  /store %ForgeString %13, ptr %14/{
    N
  }
}" "$F"
# Fix the alloca and load types
LC_ALL=C sed -i '' "/define.*@try_load_mod/,/^define/{
  s/%9 = alloca i64, align 8/%9 = alloca %ForgeString, align 8/
  s/%14 = alloca i64, align 8/%14 = alloca %ForgeString, align 8/
  s/load i64, ptr %9, align 4/load %ForgeString, ptr %9, align 8/g
  s/load i64, ptr %14, align 4/load %ForgeString, ptr %14, align 8/g
  s/forge_selfhost_fs_read(i64/forge_selfhost_fs_read(%ForgeString/g
  s/collect_module_paths(i64/collect_module_paths(%ForgeString/g
}" "$F"

# 5. Replace find_nmod with correct implementation
NS=$(grep -n "^define.*@find_nmod" "$F" | head -1 | cut -d: -f1)
NE=$(awk "NR>$NS && /^define/{print NR; exit}" "$F")
NE=$((NE - 1))
head -n $((NS - 1)) "$F" > /tmp/_patch.ll
cat >> /tmp/_patch.ll << 'NMOD'
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
  %sv1 = load %ForgeString, ptr %s, align 8
  %b0 = call i64 @forge_string_byte_at(%ForgeString %sv1, i64 %i)
  %is_nl = icmp eq i64 %b0, 10
  br i1 %is_nl, label %check_m, label %no_match
check_m:
  %i1 = add i64 %i, 1
  %sv2 = load %ForgeString, ptr %s, align 8
  %b1 = call i64 @forge_string_byte_at(%ForgeString %sv2, i64 %i1)
  %is_m = icmp eq i64 %b1, 109
  br i1 %is_m, label %check_o, label %no_match
check_o:
  %i2 = add i64 %i, 2
  %sv3 = load %ForgeString, ptr %s, align 8
  %b2 = call i64 @forge_string_byte_at(%ForgeString %sv3, i64 %i2)
  %is_o = icmp eq i64 %b2, 111
  br i1 %is_o, label %check_d, label %no_match
check_d:
  %i3 = add i64 %i, 3
  %sv4 = load %ForgeString, ptr %s, align 8
  %b3 = call i64 @forge_string_byte_at(%ForgeString %sv4, i64 %i3)
  %is_d = icmp eq i64 %b3, 100
  br i1 %is_d, label %check_sp, label %no_match
check_sp:
  %i4 = add i64 %i, 4
  %sv5 = load %ForgeString, ptr %s, align 8
  %b4 = call i64 @forge_string_byte_at(%ForgeString %sv5, i64 %i4)
  %is_sp = icmp eq i64 %b4, 32
  br i1 %is_sp, label %found, label %no_match
found:
  ret i64 %i
no_match:
  %i_next = add i64 %i, 1
  br label %loop
}
NMOD
tail -n +$((NE + 1)) "$F" >> /tmp/_patch.ll
mv /tmp/_patch.ll "$F"

# 6. Replace find_byte with correct implementation
BS=$(grep -n "^define.*@find_byte" "$F" | head -1 | cut -d: -f1)
BE=$(awk "NR>$BS && /^define/{print NR; exit}" "$F")
BE=$((BE - 1))
head -n $((BS - 1)) "$F" > /tmp/_patch.ll
cat >> /tmp/_patch.ll << 'FBYTE'
define i64 @find_byte(%ForgeString %0, i64 %1) {
  %s = alloca %ForgeString, align 8
  store %ForgeString %0, ptr %s, align 8
  %bv = alloca i64, align 8
  store i64 %1, ptr %bv, align 4
  %sval = load %ForgeString, ptr %s, align 8
  %len = call i64 @forge_string_length(%ForgeString %sval)
  %target = load i64, ptr %bv, align 4
  br label %loop
loop:
  %i = phi i64 [ 0, %2 ], [ %i_next, %no_match ]
  %done = icmp sge i64 %i, %len
  br i1 %done, label %ret_neg, label %check
check:
  %sv = load %ForgeString, ptr %s, align 8
  %b = call i64 @forge_string_byte_at(%ForgeString %sv, i64 %i)
  %eq = icmp eq i64 %b, %target
  br i1 %eq, label %found, label %no_match
found:
  ret i64 %i
no_match:
  %i_next = add i64 %i, 1
  br label %loop
ret_neg:
  ret i64 -1
}
FBYTE
tail -n +$((BE + 1)) "$F" >> /tmp/_patch.ll
mv /tmp/_patch.ll "$F"

echo "Patched. Verifying..."
/opt/homebrew/opt/llvm@18/bin/llc -O2 -filetype=obj "$F" -o /dev/null 2>&1 | head -1
echo "Done."
