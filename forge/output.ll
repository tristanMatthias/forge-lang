; ModuleID = 'test_hello.fg'
source_filename = "test_hello.fg"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-darwin25.2.0"

@str = private unnamed_addr constant [10 x i8] c"Map test:\00", align 1
@str.1 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@str.2 = private unnamed_addr constant [6 x i8] c"done!\00", align 1

declare void @forge_println_string({ ptr, i64 })

declare { ptr, i64 } @forge_int_to_string(i64)

declare { ptr, i64 } @forge_string_new(ptr, i64)

declare { ptr, i64 } @forge_string_concat({ ptr, i64 }, { ptr, i64 })

declare { ptr, i64 } @forge_string_char_at({ ptr, i64 }, i64)

declare i64 @forge_string_length({ ptr, i64 })

declare i8 @forge_string_eq({ ptr, i64 }, { ptr, i64 })

declare { ptr, i64 } @forge_string_substring({ ptr, i64 }, i64, i64)

declare i64 @forge_string_index_of({ ptr, i64 }, { ptr, i64 })

declare ptr @forge_alloc(i64)

declare void @forge_memcpy(ptr, ptr, i64)

declare ptr @forge_map_new()

declare i8 @forge_map_has(ptr, { ptr, i64 })

declare i64 @forge_map_get(ptr, { ptr, i64 })

declare void @forge_map_set(ptr, { ptr, i64 }, i64)

define i32 @main() {
entry:
  %str = call { ptr, i64 } @forge_string_new(ptr @str, i64 9)
  call void @forge_println_string({ ptr, i64 } %str)
  %map_new = call ptr @forge_map_new()
  %__map1 = alloca i64, align 8
  store ptr %map_new, ptr %__map1, align 8
  %m = alloca i64, align 8
  store ptr %map_new, ptr %m, align 8
  %m1 = load i64, ptr %m, align 4
  %str2 = call { ptr, i64 } @forge_string_new(ptr @str.1, i64 5)
  %has = call i8 @forge_map_has(i64 %m1, { ptr, i64 } %str2)
  %has_ext = zext i8 %has to i64
  %__pt2 = alloca i64, align 8
  store i64 %has_ext, ptr %__pt2, align 4
  %__pt23 = load i64, ptr %__pt2, align 4
  %ts = call { ptr, i64 } @forge_int_to_string(i64 %__pt23)
  call void @forge_println_string({ ptr, i64 } %ts)
  %str4 = call { ptr, i64 } @forge_string_new(ptr @str.2, i64 5)
  call void @forge_println_string({ ptr, i64 } %str4)
  ret i32 0
}
