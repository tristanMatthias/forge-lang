; ModuleID = 'forgec_output'
source_filename = "forgec_output"

%ForgeString = type { ptr, i64 }
%Outer = type { %Inner }
%Inner = type { i64 }

@str = private unnamed_addr constant [7 x i8] c"val = \00", align 1

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
  %sl = alloca %Outer, align 8
  store %Outer zeroinitializer, ptr %sl, align 4
  %sl1 = alloca %Inner, align 8
  store %Inner zeroinitializer, ptr %sl1, align 4
  %sf = getelementptr inbounds %Inner, ptr %sl1, i32 0, i32 0
  store i64 42, ptr %sf, align 4
  %sv = load %Inner, ptr %sl1, align 4
  %sf2 = getelementptr inbounds %Outer, ptr %sl, i32 0, i32 0
  store %Inner %sv, ptr %sf2, align 4
  %sv3 = load %Outer, ptr %sl, align 4
  %o = alloca %Outer, align 8
  store %Outer %sv3, ptr %o, align 4
  %str = call %ForgeString @forge_string_new(ptr @str, i64 6)
  %i2s = call %ForgeString @forge_int_to_string(i64 0)
  %cc = call %ForgeString @forge_string_concat(%ForgeString %str, %ForgeString %i2s)
  call void @forge_println_string(%ForgeString %cc)
  ret i32 0
}
