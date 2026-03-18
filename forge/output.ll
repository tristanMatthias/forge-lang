; ModuleID = 'test_hello.fg'
source_filename = "test_hello.fg"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-darwin25.2.0"

@tpl_s = private unnamed_addr constant [3 x i8] c"x=\00", align 1
@tpl_s.1 = private unnamed_addr constant [4 x i8] c" y=\00", align 1
@tpl_s.2 = private unnamed_addr constant [5 x i8] c"sum=\00", align 1
@tpl_s.3 = private unnamed_addr constant [7 x i8] c"total=\00", align 1
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

define i64 @add_points({ i64, i64 } %0, { i64, i64 } %1) {
entry:
  %a = alloca { i64, i64 }, align 8
  store { i64, i64 } %0, ptr %a, align 4
  %b = alloca { i64, i64 }, align 8
  store { i64, i64 } %1, ptr %b, align 4
  %a1 = load { i64, i64 }, ptr %a, align 4
  %x = extractvalue { i64, i64 } %a1, 0
  %__pt1 = alloca i64, align 8
  store i64 %x, ptr %__pt1, align 4
  %b2 = load { i64, i64 }, ptr %b, align 4
  %x3 = extractvalue { i64, i64 } %b2, 0
  %__pt2 = alloca i64, align 8
  store i64 %x3, ptr %__pt2, align 4
  %__pt14 = load i64, ptr %__pt1, align 4
  %__pt25 = load i64, ptr %__pt2, align 4
  %add = add i64 %__pt14, %__pt25
  %a6 = load { i64, i64 }, ptr %a, align 4
  %y = extractvalue { i64, i64 } %a6, 1
  %__pt3 = alloca i64, align 8
  store i64 %y, ptr %__pt3, align 4
  %__pt37 = load i64, ptr %__pt3, align 4
  %add8 = add i64 %add, %__pt37
  %b9 = load { i64, i64 }, ptr %b, align 4
  %y10 = extractvalue { i64, i64 } %b9, 1
  %__pt4 = alloca i64, align 8
  store i64 %y10, ptr %__pt4, align 4
  %__pt411 = load i64, ptr %__pt4, align 4
  %add12 = add i64 %add8, %__pt411
  %__bt5 = alloca i64, align 8
  store i64 %add12, ptr %__bt5, align 4
  %__bt513 = load i64, ptr %__bt5, align 4
  ret i64 %__bt513
}

define i64 @describe({ i64, i64 } %0) {
entry:
  %p = alloca { i64, i64 }, align 8
  store { i64, i64 } %0, ptr %p, align 4
  %p1 = load { i64, i64 }, ptr %p, align 4
  %x = extractvalue { i64, i64 } %p1, 0
  %__pt6 = alloca i64, align 8
  store i64 %x, ptr %__pt6, align 4
  %__pt62 = load i64, ptr %__pt6, align 4
  %px = alloca i64, align 8
  store i64 %__pt62, ptr %px, align 4
  %p3 = load { i64, i64 }, ptr %p, align 4
  %y = extractvalue { i64, i64 } %p3, 1
  %__pt7 = alloca i64, align 8
  store i64 %y, ptr %__pt7, align 4
  %__pt74 = load i64, ptr %__pt7, align 4
  %py = alloca i64, align 8
  store i64 %__pt74, ptr %py, align 4
  %tpl_snew = call { ptr, i64 } @forge_string_new(ptr @tpl_s, i64 2)
  %px5 = load i64, ptr %px, align 4
  %tpl_i2s = call { ptr, i64 } @forge_int_to_string(i64 %px5)
  %tpl_cat = call { ptr, i64 } @forge_string_concat({ ptr, i64 } %tpl_snew, { ptr, i64 } %tpl_i2s)
  %tpl_snew6 = call { ptr, i64 } @forge_string_new(ptr @tpl_s.1, i64 3)
  %tpl_cat7 = call { ptr, i64 } @forge_string_concat({ ptr, i64 } %tpl_cat, { ptr, i64 } %tpl_snew6)
  %py8 = load i64, ptr %py, align 4
  %tpl_i2s9 = call { ptr, i64 } @forge_int_to_string(i64 %py8)
  %tpl_cat10 = call { ptr, i64 } @forge_string_concat({ ptr, i64 } %tpl_cat7, { ptr, i64 } %tpl_i2s9)
  %__tpl8 = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %tpl_cat10, ptr %__tpl8, align 8
  %__tpl811 = load { ptr, i64 }, ptr %__tpl8, align 8
  call void @forge_println_string({ ptr, i64 } %__tpl811)
  ret i64 0
}

define i32 @main() {
entry:
  %__struct9 = alloca { i64, i64 }, align 8
  store { i64, i64 } { i64 10, i64 20 }, ptr %__struct9, align 4
  %p1 = alloca { i64, i64 }, align 8
  store { i64, i64 } { i64 10, i64 20 }, ptr %p1, align 4
  %__struct10 = alloca { i64, i64 }, align 8
  store { i64, i64 } { i64 3, i64 7 }, ptr %__struct10, align 4
  %p2 = alloca { i64, i64 }, align 8
  store { i64, i64 } { i64 3, i64 7 }, ptr %p2, align 4
  %p11 = load { i64, i64 }, ptr %p1, align 4
  %call = call i64 @describe({ i64, i64 } %p11)
  %p22 = load { i64, i64 }, ptr %p2, align 4
  %call3 = call i64 @describe({ i64, i64 } %p22)
  %p14 = load { i64, i64 }, ptr %p1, align 4
  %p25 = load { i64, i64 }, ptr %p2, align 4
  %call6 = call i64 @add_points({ i64, i64 } %p14, { i64, i64 } %p25)
  %sum = alloca i64, align 8
  store i64 %call6, ptr %sum, align 4
  %tpl_snew = call { ptr, i64 } @forge_string_new(ptr @tpl_s.2, i64 4)
  %sum7 = load i64, ptr %sum, align 4
  %tpl_i2s = call { ptr, i64 } @forge_int_to_string(i64 %sum7)
  %tpl_cat = call { ptr, i64 } @forge_string_concat({ ptr, i64 } %tpl_snew, { ptr, i64 } %tpl_i2s)
  %__tpl11 = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %tpl_cat, ptr %__tpl11, align 8
  %__tpl118 = load { ptr, i64 }, ptr %__tpl11, align 8
  call void @forge_println_string({ ptr, i64 } %__tpl118)
  %p19 = load { i64, i64 }, ptr %p1, align 4
  %x = extractvalue { i64, i64 } %p19, 0
  %__pt12 = alloca i64, align 8
  store i64 %x, ptr %__pt12, align 4
  %p110 = load { i64, i64 }, ptr %p1, align 4
  %y = extractvalue { i64, i64 } %p110, 1
  %__pt13 = alloca i64, align 8
  store i64 %y, ptr %__pt13, align 4
  %__pt1211 = load i64, ptr %__pt12, align 4
  %__pt1312 = load i64, ptr %__pt13, align 4
  %add = add i64 %__pt1211, %__pt1312
  %p213 = load { i64, i64 }, ptr %p2, align 4
  %x14 = extractvalue { i64, i64 } %p213, 0
  %__pt14 = alloca i64, align 8
  store i64 %x14, ptr %__pt14, align 4
  %__pt1415 = load i64, ptr %__pt14, align 4
  %add16 = add i64 %add, %__pt1415
  %p217 = load { i64, i64 }, ptr %p2, align 4
  %y18 = extractvalue { i64, i64 } %p217, 1
  %__pt15 = alloca i64, align 8
  store i64 %y18, ptr %__pt15, align 4
  %__pt1519 = load i64, ptr %__pt15, align 4
  %add20 = add i64 %add16, %__pt1519
  %__bt16 = alloca i64, align 8
  store i64 %add20, ptr %__bt16, align 4
  %__bt1621 = load i64, ptr %__bt16, align 4
  %total = alloca i64, align 8
  store i64 %__bt1621, ptr %total, align 4
  %tpl_snew22 = call { ptr, i64 } @forge_string_new(ptr @tpl_s.3, i64 6)
  %total23 = load i64, ptr %total, align 4
  %tpl_i2s24 = call { ptr, i64 } @forge_int_to_string(i64 %total23)
  %tpl_cat25 = call { ptr, i64 } @forge_string_concat({ ptr, i64 } %tpl_snew22, { ptr, i64 } %tpl_i2s24)
  %__tpl17 = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %tpl_cat25, ptr %__tpl17, align 8
  %__tpl1726 = load { ptr, i64 }, ptr %__tpl17, align 8
  call void @forge_println_string({ ptr, i64 } %__tpl1726)
  %str = call { ptr, i64 } @forge_string_new(ptr @str, i64 5)
  call void @forge_println_string({ ptr, i64 } %str)
  ret i32 0
}
