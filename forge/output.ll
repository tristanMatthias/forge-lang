; ModuleID = 'test_hello.fg'
source_filename = "test_hello.fg"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-darwin25.2.0"

@str = private unnamed_addr constant [6 x i8] c"done!\00", align 1

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
  %__struct1 = alloca { i64, i64 }, align 8
  store { i64, i64 } { i64 10, i64 20 }, ptr %__struct1, align 4
  %p = alloca { i64, i64 }, align 8
  store { i64, i64 } { i64 10, i64 20 }, ptr %p, align 4
  %p1 = load { i64, i64 }, ptr %p, align 4
  %x = extractvalue { i64, i64 } %p1, 0
  %__pt2 = alloca i64, align 8
  store i64 %x, ptr %__pt2, align 4
  %__pt22 = load i64, ptr %__pt2, align 4
  %ts = call { ptr, i64 } @forge_int_to_string(i64 %__pt22)
  call void @forge_println_string({ ptr, i64 } %ts)
  %p3 = load { i64, i64 }, ptr %p, align 4
  %y = extractvalue { i64, i64 } %p3, 1
  %__pt3 = alloca i64, align 8
  store i64 %y, ptr %__pt3, align 4
  %__pt34 = load i64, ptr %__pt3, align 4
  %ts5 = call { ptr, i64 } @forge_int_to_string(i64 %__pt34)
  call void @forge_println_string({ ptr, i64 } %ts5)
  %p6 = load { i64, i64 }, ptr %p, align 4
  %x7 = extractvalue { i64, i64 } %p6, 0
  %__pt4 = alloca i64, align 8
  store i64 %x7, ptr %__pt4, align 4
  %p8 = load { i64, i64 }, ptr %p, align 4
  %y9 = extractvalue { i64, i64 } %p8, 1
  %__pt5 = alloca i64, align 8
  store i64 %y9, ptr %__pt5, align 4
  %__pt410 = load i64, ptr %__pt4, align 4
  %__pt511 = load i64, ptr %__pt5, align 4
  %add = add i64 %__pt410, %__pt511
  %__bt6 = alloca i64, align 8
  store i64 %add, ptr %__bt6, align 4
  %__bt612 = load i64, ptr %__bt6, align 4
  %ts13 = call { ptr, i64 } @forge_int_to_string(i64 %__bt612)
  call void @forge_println_string({ ptr, i64 } %ts13)
  %str = call { ptr, i64 } @forge_string_new(ptr @str, i64 5)
  call void @forge_println_string({ ptr, i64 } %str)
  ret i32 0
}
