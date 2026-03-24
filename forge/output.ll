; ModuleID = 'forgec_output'
source_filename = "forgec_output"

%ForgeString = type { ptr, i64 }

declare void @forge_println_string(%ForgeString)

declare %ForgeString @forge_int_to_string(i64)

declare %ForgeString @forge_string_new(ptr, i64)

declare %ForgeString @forge_string_concat(%ForgeString, %ForgeString)

declare %ForgeString @forge_string_char_at(%ForgeString, i64)

declare i64 @forge_string_length(%ForgeString)

declare i8 @forge_string_eq(%ForgeString, %ForgeString)

declare i64 @forge_string_compare(%ForgeString, %ForgeString)

declare %ForgeString @forge_string_substring(%ForgeString, i64, i64)

declare i64 @forge_string_index_of(%ForgeString, %ForgeString)

declare ptr @forge_alloc(i64)

declare void @forge_memcpy(ptr, ptr, i64)

declare ptr @forge_map_new()

declare i8 @forge_map_has(ptr, %ForgeString)

declare i64 @forge_map_get(ptr, %ForgeString)

declare void @forge_map_set(ptr, %ForgeString, i64)

define i32 @main() {
entry:
  %s = alloca i64, align 8
  store i64 0, ptr %s, align 4
  %i = alloca i64, align 8
  store i64 1, ptr %i, align 4
  br label %wc

wc:                                               ; preds = %wb, %entry
  %i1 = load i64, ptr %i, align 4
  %le = icmp sle i64 %i1, 5
  br i1 %le, label %wb, label %we

wb:                                               ; preds = %wc
  %s2 = load i64, ptr %s, align 4
  %i3 = load i64, ptr %i, align 4
  %add = add i64 %s2, %i3
  store i64 %add, ptr %s, align 4
  %i4 = load i64, ptr %i, align 4
  %add5 = add i64 %i4, 1
  store i64 %add5, ptr %i, align 4
  br label %wc

we:                                               ; preds = %wc
  %s6 = load i64, ptr %s, align 4
  %i2s = call %ForgeString @forge_int_to_string(i64 %s6)
  call void @forge_println_string(%ForgeString %i2s)
  ret i32 0
}
