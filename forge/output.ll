; ModuleID = 'test_hello.fg'
source_filename = "test_hello.fg"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-darwin25.2.0"

@str = private unnamed_addr constant [28 x i8] c"=== Forge Compiler v0.3 ===\00", align 1
@str.1 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@tpl_s = private unnamed_addr constant [11 x i8] c"kind_id = \00", align 1
@str.2 = private unnamed_addr constant [6 x i8] c"Forge\00", align 1
@tpl_s.3 = private unnamed_addr constant [7 x i8] c"sum = \00", align 1
@str.4 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@str.5 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@tpl_s.6 = private unnamed_addr constant [7 x i8] c"fib = \00", align 1
@str.7 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@str.8 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@str.9 = private unnamed_addr constant [6 x i8] c"world\00", align 1
@str.10 = private unnamed_addr constant [13 x i8] c"a == b: true\00", align 1
@str.11 = private unnamed_addr constant [13 x i8] c"a == c: true\00", align 1
@str.12 = private unnamed_addr constant [13 x i8] c"a != c: true\00", align 1
@str.13 = private unnamed_addr constant [6 x i8] c"done!\00", align 1

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

define { i64, i64 } @make_token(i64 %0, { ptr, i64 } %1) {
entry:
  %kid = alloca i64, align 8
  store i64 %0, ptr %kid, align 4
  %txt = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %1, ptr %txt, align 8
  %kid1 = load i64, ptr %kid, align 4
  %txt2 = load { ptr, i64 }, ptr %txt, align 8
  %sf = insertvalue { i64, { ptr, i64 } } undef, i64 %kid1, 0
  %sf3 = insertvalue { i64, { ptr, i64 } } %sf, { ptr, i64 } %txt2, 1
  %__struct1 = alloca { i64, { ptr, i64 } }, align 8
  store { i64, { ptr, i64 } } %sf3, ptr %__struct1, align 8
  ret { i64, { ptr, i64 } } %sf3
}

define i64 @fib(i64 %0) {
entry:
  %n = alloca { i64, { ptr, i64 } }, align 8
  store i64 %0, ptr %n, align 4
  %n1 = load i64, ptr %n, align 4
  %le = icmp sle i64 %n1, 1
  %cmpext = zext i1 %le to i64
  %__bt2 = alloca { i64, { ptr, i64 } }, align 8
  store i64 %cmpext, ptr %__bt2, align 4
  %__bt22 = load i64, ptr %__bt2, align 4
  %ifcond = trunc i64 %__bt22 to i1
  %n3 = load i64, ptr %n, align 4
  br i1 %ifcond, label %common.ret, label %ifcont

common.ret:                                       ; preds = %entry, %ifcont
  %common.ret.op = phi i64 [ %__bt510, %ifcont ], [ %n3, %entry ]
  ret i64 %common.ret.op

ifcont:                                           ; preds = %entry
  %sub = sub i64 %n3, 1
  %__bt3 = alloca { i64, { ptr, i64 } }, align 8
  store i64 %sub, ptr %__bt3, align 4
  %n5 = load i64, ptr %n, align 4
  %sub6 = sub i64 %n5, 2
  %__bt4 = alloca { i64, { ptr, i64 } }, align 8
  store i64 %sub6, ptr %__bt4, align 4
  %__bt37 = load i64, ptr %__bt3, align 4
  %call = call i64 @fib(i64 %__bt37)
  %__bt48 = load i64, ptr %__bt4, align 4
  %call9 = call i64 @fib(i64 %__bt48)
  %add = add i64 %call, %call9
  %__bt5 = alloca { i64, { ptr, i64 } }, align 8
  store i64 %add, ptr %__bt5, align 4
  %__bt510 = load i64, ptr %__bt5, align 4
  br label %common.ret
}

define i32 @main() {
entry:
  %str = call { ptr, i64 } @forge_string_new(ptr @str, i64 27)
  call void @forge_println_string({ ptr, i64 } %str)
  %str1 = call { ptr, i64 } @forge_string_new(ptr @str.1, i64 5)
  %call = call { i64, { ptr, i64 } } @make_token(i64 1, { ptr, i64 } %str1)
  %tok = alloca { i64, { ptr, i64 } }, align 8
  store { i64, { ptr, i64 } } %call, ptr %tok, align 8
  %tok2 = load { i64, { ptr, i64 } }, ptr %tok, align 8
  %kind_id = extractvalue { i64, { ptr, i64 } } %tok2, 0
  %__pt6 = alloca i64, align 8
  store i64 %kind_id, ptr %__pt6, align 4
  %__pt63 = load i64, ptr %__pt6, align 4
  %kid = alloca i64, align 8
  store i64 %__pt63, ptr %kid, align 4
  %tpl_snew = call { ptr, i64 } @forge_string_new(ptr @tpl_s, i64 10)
  %kid4 = load i64, ptr %kid, align 4
  %tpl_i2s = call { ptr, i64 } @forge_int_to_string(i64 %kid4)
  %tpl_cat = call { ptr, i64 } @forge_string_concat({ ptr, i64 } %tpl_snew, { ptr, i64 } %tpl_i2s)
  %__tpl7 = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %tpl_cat, ptr %__tpl7, align 8
  %__tpl75 = load { ptr, i64 }, ptr %__tpl7, align 8
  call void @forge_println_string({ ptr, i64 } %__tpl75)
  %str6 = call { ptr, i64 } @forge_string_new(ptr @str.2, i64 5)
  %name = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %str6, ptr %name, align 8
  %name7 = load { ptr, i64 }, ptr %name, align 8
  %len = call i64 @forge_string_length({ ptr, i64 } %name7)
  %__pt8 = alloca i64, align 8
  store i64 %len, ptr %__pt8, align 4
  %__pt88 = load i64, ptr %__pt8, align 4
  %ts = call { ptr, i64 } @forge_int_to_string(i64 %__pt88)
  call void @forge_println_string({ ptr, i64 } %ts)
  %list_data = call ptr @forge_alloc(i64 40)
  %ep56 = bitcast ptr %list_data to ptr
  store i64 10, ptr %ep56, align 4
  %ep9 = getelementptr i64, ptr %list_data, i64 1
  store i64 20, ptr %ep9, align 4
  %ep10 = getelementptr i64, ptr %list_data, i64 2
  store i64 30, ptr %ep10, align 4
  %ep11 = getelementptr i64, ptr %list_data, i64 3
  store i64 40, ptr %ep11, align 4
  %ep12 = getelementptr i64, ptr %list_data, i64 4
  store i64 50, ptr %ep12, align 4
  %ls1 = insertvalue { ptr, i64 } undef, ptr %list_data, 0
  %ls2 = insertvalue { ptr, i64 } %ls1, i64 5, 1
  %__list9 = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %ls2, ptr %__list9, align 8
  %nums = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %ls2, ptr %nums, align 8
  %sum = alloca i64, align 8
  store i64 0, ptr %sum, align 4
  %nums13 = load { ptr, i64 }, ptr %nums, align 8
  %__for_i = alloca i64, align 8
  store i64 0, ptr %__for_i, align 4
  %list_len = call i64 @forge_string_length({ ptr, i64 } %nums13)
  br label %for.cond

for.cond:                                         ; preds = %for.body, %entry
  %for_i = load i64, ptr %__for_i, align 4
  %forcond = icmp slt i64 %for_i, %list_len
  br i1 %forcond, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %for_i_body = load i64, ptr %__for_i, align 4
  %list_data14 = extractvalue { ptr, i64 } %nums13, 0
  %elem_ptr = getelementptr i64, ptr %list_data14, i64 %for_i_body
  %n = load i64, ptr %elem_ptr, align 4
  %n15 = alloca i64, align 8
  store i64 %n, ptr %n15, align 4
  %sum16 = load i64, ptr %sum, align 4
  %n17 = load i64, ptr %n15, align 4
  %add = add i64 %sum16, %n17
  %__bt10 = alloca i64, align 8
  store i64 %add, ptr %__bt10, align 4
  %__bt1018 = load i64, ptr %__bt10, align 4
  store i64 %__bt1018, ptr %sum, align 4
  %for_i_cur = load i64, ptr %__for_i, align 4
  %for_i_next = add i64 %for_i_cur, 1
  store i64 %for_i_next, ptr %__for_i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %tpl_snew19 = call { ptr, i64 } @forge_string_new(ptr @tpl_s.3, i64 6)
  %sum20 = load i64, ptr %sum, align 4
  %tpl_i2s21 = call { ptr, i64 } @forge_int_to_string(i64 %sum20)
  %tpl_cat22 = call { ptr, i64 } @forge_string_concat({ ptr, i64 } %tpl_snew19, { ptr, i64 } %tpl_i2s21)
  %__tpl11 = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %tpl_cat22, ptr %__tpl11, align 8
  %__tpl1123 = load { ptr, i64 }, ptr %__tpl11, align 8
  call void @forge_println_string({ ptr, i64 } %__tpl1123)
  %map_new = call ptr @forge_map_new()
  %__map12 = alloca i64, align 8
  store ptr %map_new, ptr %__map12, align 8
  %env = alloca i64, align 8
  store ptr %map_new, ptr %env, align 8
  %env24 = load i64, ptr %env, align 4
  %str25 = call { ptr, i64 } @forge_string_new(ptr @str.4, i64 1)
  %map_get = call i64 @forge_map_get(i64 %env24, { ptr, i64 } %str25)
  %__pt13 = alloca i64, align 8
  store i64 %map_get, ptr %__pt13, align 4
  call void @forge_map_set(i64 %env24, { ptr, i64 } %str25, i64 42)
  %env26 = load i64, ptr %env, align 4
  %str27 = call { ptr, i64 } @forge_string_new(ptr @str.5, i64 1)
  %map_get28 = call i64 @forge_map_get(i64 %env26, { ptr, i64 } %str27)
  %__pt14 = alloca i64, align 8
  store i64 %map_get28, ptr %__pt14, align 4
  %__pt1429 = load i64, ptr %__pt14, align 4
  %ts30 = call { ptr, i64 } @forge_int_to_string(i64 %__pt1429)
  call void @forge_println_string({ ptr, i64 } %ts30)
  %call31 = call i64 @fib(i64 15)
  %f = alloca i64, align 8
  store i64 %call31, ptr %f, align 4
  %tpl_snew32 = call { ptr, i64 } @forge_string_new(ptr @tpl_s.6, i64 6)
  %f33 = load i64, ptr %f, align 4
  %tpl_i2s34 = call { ptr, i64 } @forge_int_to_string(i64 %f33)
  %tpl_cat35 = call { ptr, i64 } @forge_string_concat({ ptr, i64 } %tpl_snew32, { ptr, i64 } %tpl_i2s34)
  %__tpl15 = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %tpl_cat35, ptr %__tpl15, align 8
  %__tpl1536 = load { ptr, i64 }, ptr %__tpl15, align 8
  call void @forge_println_string({ ptr, i64 } %__tpl1536)
  %str37 = call { ptr, i64 } @forge_string_new(ptr @str.7, i64 5)
  %a = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %str37, ptr %a, align 8
  %str38 = call { ptr, i64 } @forge_string_new(ptr @str.8, i64 5)
  %b = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %str38, ptr %b, align 8
  %str39 = call { ptr, i64 } @forge_string_new(ptr @str.9, i64 5)
  %c = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %str39, ptr %c, align 8
  %a40 = load { ptr, i64 }, ptr %a, align 8
  %b41 = load { ptr, i64 }, ptr %b, align 8
  %str_eq = call i8 @forge_string_eq({ ptr, i64 } %a40, { ptr, i64 } %b41)
  %eq_ext = zext i8 %str_eq to i64
  %__bt16 = alloca i64, align 8
  store i64 %eq_ext, ptr %__bt16, align 4
  %__bt1642 = load i64, ptr %__bt16, align 4
  %ifcond = trunc i64 %__bt1642 to i1
  br i1 %ifcond, label %then, label %ifcont

then:                                             ; preds = %for.end
  %str43 = call { ptr, i64 } @forge_string_new(ptr @str.10, i64 12)
  call void @forge_println_string({ ptr, i64 } %str43)
  br label %ifcont

ifcont:                                           ; preds = %for.end, %then
  %a44 = load { ptr, i64 }, ptr %a, align 8
  %c45 = load { ptr, i64 }, ptr %c, align 8
  %str_eq46 = call i8 @forge_string_eq({ ptr, i64 } %a44, { ptr, i64 } %c45)
  %eq_ext47 = zext i8 %str_eq46 to i64
  %__bt17 = alloca i64, align 8
  store i64 %eq_ext47, ptr %__bt17, align 4
  %__bt1748 = load i64, ptr %__bt17, align 4
  %ifcond49 = trunc i64 %__bt1748 to i1
  %str.11.str.12 = select i1 %ifcond49, ptr @str.11, ptr @str.12
  %str54 = call { ptr, i64 } @forge_string_new(ptr %str.11.str.12, i64 12)
  call void @forge_println_string({ ptr, i64 } %str54)
  %str55 = call { ptr, i64 } @forge_string_new(ptr @str.13, i64 5)
  call void @forge_println_string({ ptr, i64 } %str55)
  ret i32 0
}
