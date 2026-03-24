; ModuleID = 'forgec_output'
source_filename = "forgec_output"

%ForgeString = type { ptr, i64 }
%Point = type { i64, i64 }

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
  %sl = alloca %Point, align 8
  store %Point zeroinitializer, ptr %sl, align 4
  %sf = getelementptr inbounds %Point, ptr %sl, i32 0, i32 0
  store i64 42, ptr %sf, align 4
  %sf1 = getelementptr inbounds %Point, ptr %sl, i32 0, i32 1
  store i64 10, ptr %sf1, align 4
  %sv = load %Point, ptr %sl, align 4
  %p = alloca %Point, align 8
  store %Point %sv, ptr %p, align 4
  %p2 = load %Point, ptr %p, align 4
  %x = extractvalue %Point %p2, 0
  %i2s = call %ForgeString @forge_int_to_string(i64 %x)
  call void @forge_println_string(%ForgeString %i2s)
  ret i32 0
}
