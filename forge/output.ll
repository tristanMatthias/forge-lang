; ModuleID = 'test_hello.fg'
source_filename = "test_hello.fg"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-darwin25.2.0"

@str = private unnamed_addr constant [2 x i8] c"x\00", align 1
@str.1 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@str.2 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@str.3 = private unnamed_addr constant [2 x i8] c"z\00", align 1
@str.4 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@str.5 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@str.6 = private unnamed_addr constant [6 x i8] c"done!\00", align 1

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
  %map_new = call ptr @forge_map_new()
  %__map1 = alloca i64, align 8
  store ptr %map_new, ptr %__map1, align 8
  %m = alloca i64, align 8
  store ptr %map_new, ptr %m, align 8
  %m1 = load i64, ptr %m, align 4
  %str = call { ptr, i64 } @forge_string_new(ptr @str, i64 1)
  %map_get = call i64 @forge_map_get(i64 %m1, { ptr, i64 } %str)
  %__pt2 = alloca i64, align 8
  store i64 %map_get, ptr %__pt2, align 4
  call void @forge_map_set(i64 %m1, { ptr, i64 } %str, i64 42)
  %m2 = load i64, ptr %m, align 4
  %str3 = call { ptr, i64 } @forge_string_new(ptr @str.1, i64 1)
  %map_get4 = call i64 @forge_map_get(i64 %m2, { ptr, i64 } %str3)
  %__pt3 = alloca i64, align 8
  store i64 %map_get4, ptr %__pt3, align 4
  call void @forge_map_set(i64 %m2, { ptr, i64 } %str3, i64 99)
  %m5 = load i64, ptr %m, align 4
  %str6 = call { ptr, i64 } @forge_string_new(ptr @str.2, i64 1)
  %has = call i8 @forge_map_has(i64 %m5, { ptr, i64 } %str6)
  %has_ext = zext i8 %has to i64
  %__pt4 = alloca i64, align 8
  store i64 %has_ext, ptr %__pt4, align 4
  %__pt47 = load i64, ptr %__pt4, align 4
  %ts = call { ptr, i64 } @forge_int_to_string(i64 %__pt47)
  call void @forge_println_string({ ptr, i64 } %ts)
  %m8 = load i64, ptr %m, align 4
  %str9 = call { ptr, i64 } @forge_string_new(ptr @str.3, i64 1)
  %has10 = call i8 @forge_map_has(i64 %m8, { ptr, i64 } %str9)
  %has_ext11 = zext i8 %has10 to i64
  %__pt5 = alloca i64, align 8
  store i64 %has_ext11, ptr %__pt5, align 4
  %__pt512 = load i64, ptr %__pt5, align 4
  %ts13 = call { ptr, i64 } @forge_int_to_string(i64 %__pt512)
  call void @forge_println_string({ ptr, i64 } %ts13)
  %m14 = load i64, ptr %m, align 4
  %str15 = call { ptr, i64 } @forge_string_new(ptr @str.4, i64 1)
  %map_get16 = call i64 @forge_map_get(i64 %m14, { ptr, i64 } %str15)
  %__pt6 = alloca i64, align 8
  store i64 %map_get16, ptr %__pt6, align 4
  %__pt617 = load i64, ptr %__pt6, align 4
  %ts18 = call { ptr, i64 } @forge_int_to_string(i64 %__pt617)
  call void @forge_println_string({ ptr, i64 } %ts18)
  %m19 = load i64, ptr %m, align 4
  %str20 = call { ptr, i64 } @forge_string_new(ptr @str.5, i64 1)
  %map_get21 = call i64 @forge_map_get(i64 %m19, { ptr, i64 } %str20)
  %__pt7 = alloca i64, align 8
  store i64 %map_get21, ptr %__pt7, align 4
  %__pt722 = load i64, ptr %__pt7, align 4
  %ts23 = call { ptr, i64 } @forge_int_to_string(i64 %__pt722)
  call void @forge_println_string({ ptr, i64 } %ts23)
  %str24 = call { ptr, i64 } @forge_string_new(ptr @str.6, i64 5)
  call void @forge_println_string({ ptr, i64 } %str24)
  ret i32 0
}
