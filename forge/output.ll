; ModuleID = 'forgec_output'
source_filename = "forgec_output"

%ForgeString = type { ptr, i64 }
%Outer = type { %Inner, %ForgeString }
%Inner = type { i64, i64 }

@str = private unnamed_addr constant [5 x i8] c"test\00", align 1

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

define i64 @get_x(%Outer %0) {
entry:
  %o = alloca %Outer, align 8
  store %Outer %0, ptr %o, align 8
  %o1 = load %Outer, ptr %o, align 8
  %cf = extractvalue %Outer %o1, 0
  %cf2 = extractvalue %Inner %cf, 0
  %_p1 = alloca i64, align 8
  store i64 %cf2, ptr %_p1, align 4
  %_p13 = load i64, ptr %_p1, align 4
  ret i64 %_p13
}

define i32 @main() {
entry:
  %_s2 = alloca %Inner, align 8
  store %Inner zeroinitializer, ptr %_s2, align 4
  %sp = getelementptr inbounds %Inner, ptr %_s2, i32 0, i32 0
  store i64 42, ptr %sp, align 4
  %sp1 = getelementptr inbounds %Inner, ptr %_s2, i32 0, i32 1
  store i64 10, ptr %sp1, align 4
  %sv = load %Inner, ptr %_s2, align 4
  %str = call %ForgeString @forge_string_new(ptr @str, i64 4)
  %_s3 = alloca %Outer, align 8
  store %Outer zeroinitializer, ptr %_s3, align 8
  %sp2 = getelementptr inbounds %Outer, ptr %_s3, i32 0, i32 0
  store %Inner %sv, ptr %sp2, align 4
  %sp3 = getelementptr inbounds %Outer, ptr %_s3, i32 0, i32 1
  store %ForgeString %str, ptr %sp3, align 8
  %sv4 = load %Outer, ptr %_s3, align 8
  %o = alloca %Outer, align 8
  store %Outer %sv4, ptr %o, align 8
  %o5 = load %Outer, ptr %o, align 8
  %call = call i64 @get_x(%Outer %o5)
  %i2s = call %ForgeString @forge_int_to_string(i64 %call)
  call void @forge_println_string(%ForgeString %i2s)
  ret i32 0
}
