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

define i64 @dot(i64 %0, i64 %1) {
entry:
  %a = alloca i64, align 8
  store i64 %0, ptr %a, align 4
  %b = alloca i64, align 8
  store i64 %1, ptr %b, align 4
  %a1 = load i64, ptr %a, align 4
  %b2 = load i64, ptr %b, align 4
  %__bt1 = alloca i64, align 8
  store i64 0, ptr %__bt1, align 4
  %a3 = load i64, ptr %a, align 4
  %b4 = load i64, ptr %b, align 4
  %__bt2 = alloca i64, align 8
  store i64 0, ptr %__bt2, align 4
  %__bt15 = load i64, ptr %__bt1, align 4
  %__bt26 = load i64, ptr %__bt2, align 4
  %add = add i64 %__bt15, %__bt26
  %a7 = load i64, ptr %a, align 4
  %b8 = load i64, ptr %b, align 4
  %__bt3 = alloca i64, align 8
  store i64 0, ptr %__bt3, align 4
  %__bt39 = load i64, ptr %__bt3, align 4
  %add10 = add i64 %add, %__bt39
  %__bt4 = alloca i64, align 8
  store i64 %add10, ptr %__bt4, align 4
  %__bt411 = load i64, ptr %__bt4, align 4
  ret i64 %__bt411
}

define i32 @main() {
entry:
  %__struct5 = alloca { i64, i64, i64 }, align 8
  store { i64, i64, i64 } { i64 1, i64 2, i64 3 }, ptr %__struct5, align 4
  %v1 = alloca { i64, i64, i64 }, align 8
  store { i64, i64, i64 } { i64 1, i64 2, i64 3 }, ptr %v1, align 4
  %__struct6 = alloca { i64, i64, i64 }, align 8
  store { i64, i64, i64 } { i64 4, i64 5, i64 6 }, ptr %__struct6, align 4
  %v2 = alloca { i64, i64, i64 }, align 8
  store { i64, i64, i64 } { i64 4, i64 5, i64 6 }, ptr %v2, align 4
  %v11 = load { i64, i64, i64 }, ptr %v1, align 4
  %v22 = load { i64, i64, i64 }, ptr %v2, align 4
  %call = call i64 @dot({ i64, i64, i64 } %v11, { i64, i64, i64 } %v22)
  %d = alloca i64, align 8
  store i64 %call, ptr %d, align 4
  %d3 = load i64, ptr %d, align 4
  %ts = call { ptr, i64 } @forge_int_to_string(i64 %d3)
  call void @forge_println_string({ ptr, i64 } %ts)
  %v14 = load { i64, i64, i64 }, ptr %v1, align 4
  %x = extractvalue { i64, i64, i64 } %v14, 0
  %__pt7 = alloca i64, align 8
  store i64 %x, ptr %__pt7, align 4
  %v15 = load { i64, i64, i64 }, ptr %v1, align 4
  %y = extractvalue { i64, i64, i64 } %v15, 1
  %__pt8 = alloca i64, align 8
  store i64 %y, ptr %__pt8, align 4
  %__pt76 = load i64, ptr %__pt7, align 4
  %__pt87 = load i64, ptr %__pt8, align 4
  %add = add i64 %__pt76, %__pt87
  %v18 = load { i64, i64, i64 }, ptr %v1, align 4
  %z = extractvalue { i64, i64, i64 } %v18, 2
  %__pt9 = alloca i64, align 8
  store i64 %z, ptr %__pt9, align 4
  %__pt99 = load i64, ptr %__pt9, align 4
  %add10 = add i64 %add, %__pt99
  %__bt10 = alloca i64, align 8
  store i64 %add10, ptr %__bt10, align 4
  %__bt1011 = load i64, ptr %__bt10, align 4
  %sum = alloca i64, align 8
  store i64 %__bt1011, ptr %sum, align 4
  %sum12 = load i64, ptr %sum, align 4
  %ts13 = call { ptr, i64 } @forge_int_to_string(i64 %sum12)
  call void @forge_println_string({ ptr, i64 } %ts13)
  %str = call { ptr, i64 } @forge_string_new(ptr @str, i64 5)
  call void @forge_println_string({ ptr, i64 } %str)
  ret i32 0
}
