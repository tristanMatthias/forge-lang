; ModuleID = 'test_hello.fg'
source_filename = "test_hello.fg"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-darwin25.2.0"

@tpl_s = private unnamed_addr constant [11 x i8] c"result: x=\00", align 1
@tpl_s.1 = private unnamed_addr constant [4 x i8] c" y=\00", align 1
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

define { i64, i64 } @make_point(i64 %0, i64 %1) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 4
  %y = alloca i64, align 8
  store i64 %1, ptr %y, align 4
  %x1 = load i64, ptr %x, align 4
  %y2 = load i64, ptr %y, align 4
  %sf = insertvalue { i64, i64 } undef, i64 %x1, 0
  %sf3 = insertvalue { i64, i64 } %sf, i64 %y2, 1
  %__struct1 = alloca { i64, i64 }, align 8
  store { i64, i64 } %sf3, ptr %__struct1, align 4
  ret { i64, i64 } %sf3
}

define { i64, i64 } @add_points({ i64, i64 } %0, { i64, i64 } %1) {
entry:
  %a = alloca { i64, i64 }, align 8
  store { i64, i64 } %0, ptr %a, align 4
  %b = alloca { i64, i64 }, align 8
  store { i64, i64 } %1, ptr %b, align 4
  %a1 = load { i64, i64 }, ptr %a, align 4
  %x = extractvalue { i64, i64 } %a1, 0
  %__pt2 = alloca i64, align 8
  store i64 %x, ptr %__pt2, align 4
  %b2 = load { i64, i64 }, ptr %b, align 4
  %x3 = extractvalue { i64, i64 } %b2, 0
  %__pt3 = alloca i64, align 8
  store i64 %x3, ptr %__pt3, align 4
  %__pt24 = load i64, ptr %__pt2, align 4
  %__pt35 = load i64, ptr %__pt3, align 4
  %add = add i64 %__pt24, %__pt35
  %__bt4 = alloca i64, align 8
  store i64 %add, ptr %__bt4, align 4
  %__bt46 = load i64, ptr %__bt4, align 4
  %a7 = load { i64, i64 }, ptr %a, align 4
  %y = extractvalue { i64, i64 } %a7, 1
  %__pt5 = alloca i64, align 8
  store i64 %y, ptr %__pt5, align 4
  %b8 = load { i64, i64 }, ptr %b, align 4
  %y9 = extractvalue { i64, i64 } %b8, 1
  %__pt6 = alloca i64, align 8
  store i64 %y9, ptr %__pt6, align 4
  %__pt510 = load i64, ptr %__pt5, align 4
  %__pt611 = load i64, ptr %__pt6, align 4
  %add12 = add i64 %__pt510, %__pt611
  %__bt7 = alloca i64, align 8
  store i64 %add12, ptr %__bt7, align 4
  %__bt713 = load i64, ptr %__bt7, align 4
  %sf = insertvalue { i64, i64 } undef, i64 %__bt46, 0
  %sf14 = insertvalue { i64, i64 } %sf, i64 %__bt713, 1
  %__struct8 = alloca { i64, i64 }, align 8
  store { i64, i64 } %sf14, ptr %__struct8, align 4
  ret { i64, i64 } %sf14
}

define i32 @main() {
entry:
  %call = call { i64, i64 } @make_point(i64 10, i64 20)
  %p1 = alloca { i64, i64 }, align 8
  store { i64, i64 } %call, ptr %p1, align 4
  %call1 = call { i64, i64 } @make_point(i64 3, i64 7)
  %p2 = alloca { i64, i64 }, align 8
  store { i64, i64 } %call1, ptr %p2, align 4
  %p12 = load { i64, i64 }, ptr %p1, align 4
  %p23 = load { i64, i64 }, ptr %p2, align 4
  %call4 = call { i64, i64 } @add_points({ i64, i64 } %p12, { i64, i64 } %p23)
  %p3 = alloca { i64, i64 }, align 8
  store { i64, i64 } %call4, ptr %p3, align 4
  %p35 = load { i64, i64 }, ptr %p3, align 4
  %x = extractvalue { i64, i64 } %p35, 0
  %__pt9 = alloca i64, align 8
  store i64 %x, ptr %__pt9, align 4
  %__pt96 = load i64, ptr %__pt9, align 4
  %px = alloca i64, align 8
  store i64 %__pt96, ptr %px, align 4
  %p37 = load { i64, i64 }, ptr %p3, align 4
  %y = extractvalue { i64, i64 } %p37, 1
  %__pt10 = alloca i64, align 8
  store i64 %y, ptr %__pt10, align 4
  %__pt108 = load i64, ptr %__pt10, align 4
  %py = alloca i64, align 8
  store i64 %__pt108, ptr %py, align 4
  %tpl_snew = call { ptr, i64 } @forge_string_new(ptr @tpl_s, i64 10)
  %px9 = load i64, ptr %px, align 4
  %tpl_i2s = call { ptr, i64 } @forge_int_to_string(i64 %px9)
  %tpl_cat = call { ptr, i64 } @forge_string_concat({ ptr, i64 } %tpl_snew, { ptr, i64 } %tpl_i2s)
  %tpl_snew10 = call { ptr, i64 } @forge_string_new(ptr @tpl_s.1, i64 3)
  %tpl_cat11 = call { ptr, i64 } @forge_string_concat({ ptr, i64 } %tpl_cat, { ptr, i64 } %tpl_snew10)
  %py12 = load i64, ptr %py, align 4
  %tpl_i2s13 = call { ptr, i64 } @forge_int_to_string(i64 %py12)
  %tpl_cat14 = call { ptr, i64 } @forge_string_concat({ ptr, i64 } %tpl_cat11, { ptr, i64 } %tpl_i2s13)
  %__tpl11 = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %tpl_cat14, ptr %__tpl11, align 8
  %__tpl1115 = load { ptr, i64 }, ptr %__tpl11, align 8
  call void @forge_println_string({ ptr, i64 } %__tpl1115)
  %str = call { ptr, i64 } @forge_string_new(ptr @str, i64 5)
  call void @forge_println_string({ ptr, i64 } %str)
  ret i32 0
}
