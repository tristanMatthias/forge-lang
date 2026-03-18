; ModuleID = 'test_hello.fg'
source_filename = "test_hello.fg"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-darwin25.2.0"

@str = private unnamed_addr constant [28 x i8] c"=== Forge Compiler v0.2 ===\00", align 1
@tpl_s = private unnamed_addr constant [9 x i8] c"value = \00", align 1
@tpl_s.1 = private unnamed_addr constant [7 x i8] c"sum = \00", align 1
@tpl_s.2 = private unnamed_addr constant [11 x i8] c"fib(15) = \00", align 1
@str.3 = private unnamed_addr constant [4 x i8] c"key\00", align 1
@str.4 = private unnamed_addr constant [4 x i8] c"key\00", align 1
@str.5 = private unnamed_addr constant [22 x i8] c"All features working!\00", align 1

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

define i64 @fib(i64 %0) {
entry:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 4
  %n1 = load i64, ptr %n, align 4
  %le = icmp sle i64 %n1, 1
  %cmpext = zext i1 %le to i64
  %__bt1 = alloca i64, align 8
  store i64 %cmpext, ptr %__bt1, align 4
  %__bt12 = load i64, ptr %__bt1, align 4
  %ifcond = trunc i64 %__bt12 to i1
  %n3 = load i64, ptr %n, align 4
  br i1 %ifcond, label %common.ret, label %ifcont

common.ret:                                       ; preds = %entry, %ifcont
  %common.ret.op = phi i64 [ %__bt410, %ifcont ], [ %n3, %entry ]
  ret i64 %common.ret.op

ifcont:                                           ; preds = %entry
  %sub = sub i64 %n3, 1
  %__bt2 = alloca i64, align 8
  store i64 %sub, ptr %__bt2, align 4
  %n5 = load i64, ptr %n, align 4
  %sub6 = sub i64 %n5, 2
  %__bt3 = alloca i64, align 8
  store i64 %sub6, ptr %__bt3, align 4
  %__bt27 = load i64, ptr %__bt2, align 4
  %call = call i64 @fib(i64 %__bt27)
  %__bt38 = load i64, ptr %__bt3, align 4
  %call9 = call i64 @fib(i64 %__bt38)
  %add = add i64 %call, %call9
  %__bt4 = alloca i64, align 8
  store i64 %add, ptr %__bt4, align 4
  %__bt410 = load i64, ptr %__bt4, align 4
  br label %common.ret
}

define i32 @main() {
entry:
  %str = call { ptr, i64 } @forge_string_new(ptr @str, i64 27)
  call void @forge_println_string({ ptr, i64 } %str)
  %x = alloca i64, align 8
  store i64 42, ptr %x, align 4
  %tpl_snew = call { ptr, i64 } @forge_string_new(ptr @tpl_s, i64 8)
  %x1 = load i64, ptr %x, align 4
  %tpl_i2s = call { ptr, i64 } @forge_int_to_string(i64 %x1)
  %tpl_cat = call { ptr, i64 } @forge_string_concat({ ptr, i64 } %tpl_snew, { ptr, i64 } %tpl_i2s)
  %__tpl5 = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %tpl_cat, ptr %__tpl5, align 8
  %__tpl52 = load { ptr, i64 }, ptr %__tpl5, align 8
  call void @forge_println_string({ ptr, i64 } %__tpl52)
  %list_data = call ptr @forge_alloc(i64 40)
  %ep30 = bitcast ptr %list_data to ptr
  store i64 2, ptr %ep30, align 4
  %ep3 = getelementptr i64, ptr %list_data, i64 1
  store i64 3, ptr %ep3, align 4
  %ep4 = getelementptr i64, ptr %list_data, i64 2
  store i64 5, ptr %ep4, align 4
  %ep5 = getelementptr i64, ptr %list_data, i64 3
  store i64 7, ptr %ep5, align 4
  %ep6 = getelementptr i64, ptr %list_data, i64 4
  store i64 11, ptr %ep6, align 4
  %ls1 = insertvalue { ptr, i64 } undef, ptr %list_data, 0
  %ls2 = insertvalue { ptr, i64 } %ls1, i64 5, 1
  %__list6 = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %ls2, ptr %__list6, align 8
  %nums = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %ls2, ptr %nums, align 8
  %sum = alloca i64, align 8
  store i64 0, ptr %sum, align 4
  %nums7 = load { ptr, i64 }, ptr %nums, align 8
  %__for_i = alloca i64, align 8
  store i64 0, ptr %__for_i, align 4
  %list_len = call i64 @forge_string_length({ ptr, i64 } %nums7)
  br label %for.cond

for.cond:                                         ; preds = %for.body, %entry
  %for_i = load i64, ptr %__for_i, align 4
  %forcond = icmp slt i64 %for_i, %list_len
  br i1 %forcond, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %for_i_body = load i64, ptr %__for_i, align 4
  %list_data8 = extractvalue { ptr, i64 } %nums7, 0
  %elem_ptr = getelementptr i64, ptr %list_data8, i64 %for_i_body
  %n = load i64, ptr %elem_ptr, align 4
  %n9 = alloca i64, align 8
  store i64 %n, ptr %n9, align 4
  %sum10 = load i64, ptr %sum, align 4
  %n11 = load { ptr, i64 }, ptr %n9, align 8
  %add = add i64 %sum10, { ptr, i64 } %n11
  %__bt7 = alloca i64, align 8
  store i64 %add, ptr %__bt7, align 4
  %__bt712 = load i64, ptr %__bt7, align 4
  store i64 %__bt712, ptr %sum, align 4
  %for_i_cur = load i64, ptr %__for_i, align 4
  %for_i_next = add i64 %for_i_cur, 1
  store i64 %for_i_next, ptr %__for_i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %tpl_snew13 = call { ptr, i64 } @forge_string_new(ptr @tpl_s.1, i64 6)
  %sum14 = load i64, ptr %sum, align 4
  %tpl_i2s15 = call { ptr, i64 } @forge_int_to_string(i64 %sum14)
  %tpl_cat16 = call { ptr, i64 } @forge_string_concat({ ptr, i64 } %tpl_snew13, { ptr, i64 } %tpl_i2s15)
  %__tpl8 = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %tpl_cat16, ptr %__tpl8, align 8
  %__tpl817 = load { ptr, i64 }, ptr %__tpl8, align 8
  call void @forge_println_string({ ptr, i64 } %__tpl817)
  %call = call i64 @fib(i64 15)
  %f = alloca i64, align 8
  store i64 %call, ptr %f, align 4
  %tpl_snew18 = call { ptr, i64 } @forge_string_new(ptr @tpl_s.2, i64 10)
  %f19 = load i64, ptr %f, align 4
  %tpl_i2s20 = call { ptr, i64 } @forge_int_to_string(i64 %f19)
  %tpl_cat21 = call { ptr, i64 } @forge_string_concat({ ptr, i64 } %tpl_snew18, { ptr, i64 } %tpl_i2s20)
  %__tpl9 = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %tpl_cat21, ptr %__tpl9, align 8
  %__tpl922 = load { ptr, i64 }, ptr %__tpl9, align 8
  call void @forge_println_string({ ptr, i64 } %__tpl922)
  %map_new = call ptr @forge_map_new()
  %__map10 = alloca i64, align 8
  store ptr %map_new, ptr %__map10, align 8
  %m = alloca i64, align 8
  store ptr %map_new, ptr %m, align 8
  %m23 = load i64, ptr %m, align 4
  %str24 = call { ptr, i64 } @forge_string_new(ptr @str.3, i64 3)
  %map_get = call i64 @forge_map_get(i64 %m23, { ptr, i64 } %str24)
  %__pt11 = alloca i64, align 8
  store i64 %map_get, ptr %__pt11, align 4
  call void @forge_map_set(i64 %m23, { ptr, i64 } %str24, i64 999)
  %m25 = load i64, ptr %m, align 4
  %str26 = call { ptr, i64 } @forge_string_new(ptr @str.4, i64 3)
  %map_get27 = call i64 @forge_map_get(i64 %m25, { ptr, i64 } %str26)
  %__pt12 = alloca i64, align 8
  store i64 %map_get27, ptr %__pt12, align 4
  %__pt1228 = load { ptr, i64 }, ptr %__pt12, align 8
  %ts = call { ptr, i64 } @forge_int_to_string({ ptr, i64 } %__pt1228)
  call void @forge_println_string({ ptr, i64 } %ts)
  %str29 = call { ptr, i64 } @forge_string_new(ptr @str.5, i64 21)
  call void @forge_println_string({ ptr, i64 } %str29)
  ret i32 0
}
