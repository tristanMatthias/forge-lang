; ModuleID = 'test_hello.fg'
source_filename = "test_hello.fg"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-darwin25.2.0"

@tpl_s = private unnamed_addr constant [9 x i8] c"unwrap: \00", align 1
@tpl_s.1 = private unnamed_addr constant [4 x i8] c" + \00", align 1
@tpl_s.2 = private unnamed_addr constant [4 x i8] c" = \00", align 1
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
  %x = alloca i64, align 8
  store i64 42, ptr %x, align 4
  %x1 = load i64, ptr %x, align 4
  %y = alloca i64, align 8
  store i64 %x1, ptr %y, align 4
  %tpl_snew = call { ptr, i64 } @forge_string_new(ptr @tpl_s, i64 8)
  %y2 = load i64, ptr %y, align 4
  %tpl_i2s = call { ptr, i64 } @forge_int_to_string(i64 %y2)
  %tpl_cat = call { ptr, i64 } @forge_string_concat({ ptr, i64 } %tpl_snew, { ptr, i64 } %tpl_i2s)
  %__tpl1 = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %tpl_cat, ptr %__tpl1, align 8
  %__tpl13 = load { ptr, i64 }, ptr %__tpl1, align 8
  call void @forge_println_string({ ptr, i64 } %__tpl13)
  %a = alloca i64, align 8
  store i64 10, ptr %a, align 4
  %b = alloca i64, align 8
  store i64 20, ptr %b, align 4
  %a4 = load i64, ptr %a, align 4
  %b5 = load i64, ptr %b, align 4
  %add = add i64 %a4, %b5
  %__bt2 = alloca i64, align 8
  store i64 %add, ptr %__bt2, align 4
  %__bt26 = load i64, ptr %__bt2, align 4
  %sum = alloca i64, align 8
  store i64 %__bt26, ptr %sum, align 4
  %a7 = load i64, ptr %a, align 4
  %tpl_i2s8 = call { ptr, i64 } @forge_int_to_string(i64 %a7)
  %tpl_snew9 = call { ptr, i64 } @forge_string_new(ptr @tpl_s.1, i64 3)
  %tpl_cat10 = call { ptr, i64 } @forge_string_concat({ ptr, i64 } %tpl_i2s8, { ptr, i64 } %tpl_snew9)
  %b11 = load i64, ptr %b, align 4
  %tpl_i2s12 = call { ptr, i64 } @forge_int_to_string(i64 %b11)
  %tpl_cat13 = call { ptr, i64 } @forge_string_concat({ ptr, i64 } %tpl_cat10, { ptr, i64 } %tpl_i2s12)
  %tpl_snew14 = call { ptr, i64 } @forge_string_new(ptr @tpl_s.2, i64 3)
  %tpl_cat15 = call { ptr, i64 } @forge_string_concat({ ptr, i64 } %tpl_cat13, { ptr, i64 } %tpl_snew14)
  %sum16 = load i64, ptr %sum, align 4
  %tpl_i2s17 = call { ptr, i64 } @forge_int_to_string(i64 %sum16)
  %tpl_cat18 = call { ptr, i64 } @forge_string_concat({ ptr, i64 } %tpl_cat15, { ptr, i64 } %tpl_i2s17)
  %__tpl3 = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %tpl_cat18, ptr %__tpl3, align 8
  %__tpl319 = load { ptr, i64 }, ptr %__tpl3, align 8
  call void @forge_println_string({ ptr, i64 } %__tpl319)
  %str = call { ptr, i64 } @forge_string_new(ptr @str, i64 5)
  call void @forge_println_string({ ptr, i64 } %str)
  ret i32 0
}
