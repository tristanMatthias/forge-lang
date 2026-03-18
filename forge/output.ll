; ModuleID = 'test_hello.fg'
source_filename = "test_hello.fg"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-darwin25.2.0"

declare void @forge_println_string({ ptr, i64 })

declare { ptr, i64 } @forge_int_to_string(i64)

declare { ptr, i64 } @forge_string_new(ptr, i64)

define i32 @main() {
entry:
  %a = alloca i64, align 8
  store i64 10, ptr %a, align 4
  %b = alloca i64, align 8
  store i64 20, ptr %b, align 4
  %b1 = load i64, ptr %b, align 4
  %mul = mul i64 %b1, 2
  %__bt1 = alloca i64, align 8
  store i64 %mul, ptr %__bt1, align 4
  %a2 = load i64, ptr %a, align 4
  %__bt13 = load i64, ptr %__bt1, align 4
  %add = add i64 %a2, %__bt13
  %__bt2 = alloca i64, align 8
  store i64 %add, ptr %__bt2, align 4
  %__bt24 = load i64, ptr %__bt2, align 4
  %ts = call { ptr, i64 } @forge_int_to_string(i64 %__bt24)
  call void @forge_println_string({ ptr, i64 } %ts)
  %a5 = load i64, ptr %a, align 4
  %b6 = load i64, ptr %b, align 4
  %mul7 = mul i64 %a5, %b6
  %__bt3 = alloca i64, align 8
  store i64 %mul7, ptr %__bt3, align 4
  %__bt38 = load i64, ptr %__bt3, align 4
  %add9 = add i64 %__bt38, 30
  %__bt4 = alloca i64, align 8
  store i64 %add9, ptr %__bt4, align 4
  %__bt410 = load i64, ptr %__bt4, align 4
  %ts11 = call { ptr, i64 } @forge_int_to_string(i64 %__bt410)
  call void @forge_println_string({ ptr, i64 } %ts11)
  %a12 = load i64, ptr %a, align 4
  %b13 = load i64, ptr %b, align 4
  %add14 = add i64 %a12, %b13
  %__bt5 = alloca i64, align 8
  store i64 %add14, ptr %__bt5, align 4
  %div = sdiv double 2.470330e-323, i64 2
  %__bt6 = alloca i64, align 8
  store double %div, ptr %__bt6, align 8
  %__bt615 = load i64, ptr %__bt6, align 4
  %ts16 = call { ptr, i64 } @forge_int_to_string(i64 %__bt615)
  call void @forge_println_string({ ptr, i64 } %ts16)
  ret i32 0
}
