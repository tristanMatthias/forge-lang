; ModuleID = 'test_hello.fg'
source_filename = "test_hello.fg"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-darwin25.2.0"

@str = private unnamed_addr constant [12 x i8] c"hello world\00", align 1
@str.1 = private unnamed_addr constant [6 x i8] c"world\00", align 1

declare void @forge_println_string({ ptr, i64 })

declare { ptr, i64 } @forge_int_to_string(i64)

declare { ptr, i64 } @forge_string_new(ptr, i64)

declare { ptr, i64 } @forge_string_concat({ ptr, i64 }, { ptr, i64 })

declare { ptr, i64 } @forge_string_char_at({ ptr, i64 }, i64)

declare i64 @forge_string_length({ ptr, i64 })

declare i8 @forge_string_eq({ ptr, i64 }, { ptr, i64 })

declare { ptr, i64 } @forge_string_substring({ ptr, i64 }, i64, i64)

declare i64 @forge_string_index_of({ ptr, i64 }, { ptr, i64 })

define i32 @main() {
entry:
  %str = call { ptr, i64 } @forge_string_new(ptr @str, i64 11)
  %s = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %str, ptr %s, align 8
  %s1 = load { ptr, i64 }, ptr %s, align 8
  %len = call i64 @forge_string_length({ ptr, i64 } %s1)
  %__pt1 = alloca i64, align 8
  store i64 %len, ptr %__pt1, align 4
  %__pt12 = load i64, ptr %__pt1, align 4
  %ts = call { ptr, i64 } @forge_int_to_string(i64 %__pt12)
  call void @forge_println_string({ ptr, i64 } %ts)
  %s3 = load { ptr, i64 }, ptr %s, align 8
  %charat = call { ptr, i64 } @forge_string_char_at({ ptr, i64 } %s3, i64 0)
  %__pt2 = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %charat, ptr %__pt2, align 8
  %__pt24 = load { ptr, i64 }, ptr %__pt2, align 8
  call void @forge_println_string({ ptr, i64 } %__pt24)
  %s5 = load { ptr, i64 }, ptr %s, align 8
  %charat6 = call { ptr, i64 } @forge_string_char_at({ ptr, i64 } %s5, i64 6)
  %__pt3 = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %charat6, ptr %__pt3, align 8
  %__pt37 = load { ptr, i64 }, ptr %__pt3, align 8
  call void @forge_println_string({ ptr, i64 } %__pt37)
  %s8 = load { ptr, i64 }, ptr %s, align 8
  %substr = call { ptr, i64 } @forge_string_substring({ ptr, i64 } %s8, i64 0, i64 5)
  %__pt4 = alloca i64, align 8
  store { ptr, i64 } %substr, ptr %__pt4, align 8
  %__pt49 = load i64, ptr %__pt4, align 4
  %sub = alloca i64, align 8
  store i64 %__pt49, ptr %sub, align 4
  %sub10 = load i64, ptr %sub, align 4
  %ts11 = call { ptr, i64 } @forge_int_to_string(i64 %sub10)
  call void @forge_println_string({ ptr, i64 } %ts11)
  %s12 = load { ptr, i64 }, ptr %s, align 8
  %str13 = call { ptr, i64 } @forge_string_new(ptr @str.1, i64 5)
  %indexof = call i64 @forge_string_index_of({ ptr, i64 } %s12, { ptr, i64 } %str13)
  %__pt5 = alloca i64, align 8
  store i64 %indexof, ptr %__pt5, align 4
  %__pt514 = load i64, ptr %__pt5, align 4
  %ts15 = call { ptr, i64 } @forge_int_to_string(i64 %__pt514)
  call void @forge_println_string({ ptr, i64 } %ts15)
  ret i32 0
}
