; ModuleID = 'forgec_output'
source_filename = "forgec_output"

%ForgeString = type { ptr, i64 }

@str = private unnamed_addr constant [5 x i8] c"blue\00", align 1

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

define %ForgeString @name(i64 %0) {
entry:
  %c = alloca i64, align 8
  store i64 %0, ptr %c, align 4
  %str = call %ForgeString @forge_string_new(ptr @str, i64 4)
  ret %ForgeString %str
}

define i32 @main() {
entry:
  %call = call %ForgeString @name(i64 1)
  call void @forge_println_string(%ForgeString %call)
  ret i32 0
}
