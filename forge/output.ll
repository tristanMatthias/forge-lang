; ModuleID = 'test_hello.fg'
source_filename = "test_hello.fg"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-darwin25.2.0"

@str = private unnamed_addr constant [3 x i8] c"fn\00", align 1
@str.1 = private unnamed_addr constant [4 x i8] c"let\00", align 1
@str.2 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@str.3 = private unnamed_addr constant [3 x i8] c"fn\00", align 1
@str.4 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@str.5 = private unnamed_addr constant [2 x i8] c"x\00", align 1
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

define i64 @is_keyword({ ptr, i64 } %0) {
entry:
  %text = alloca { i64, { ptr, i64 } }, align 8
  store { ptr, i64 } %0, ptr %text, align 8
  %text1 = load { ptr, i64 }, ptr %text, align 8
  %str = call { ptr, i64 } @forge_string_new(ptr @str, i64 2)
  %str_eq = call i8 @forge_string_eq({ ptr, i64 } %text1, { ptr, i64 } %str)
  %eq_ext = zext i8 %str_eq to i64
  %__bt2 = alloca { i64, { ptr, i64 } }, align 8
  store i64 %eq_ext, ptr %__bt2, align 4
  %__bt22 = load i64, ptr %__bt2, align 4
  %ifcond = trunc i64 %__bt22 to i1
  br i1 %ifcond, label %common.ret, label %ifcont

common.ret:                                       ; preds = %ifcont, %entry
  %common.ret.op = phi i64 [ 1, %entry ], [ %spec.select, %ifcont ]
  ret i64 %common.ret.op

ifcont:                                           ; preds = %entry
  %text3 = load { ptr, i64 }, ptr %text, align 8
  %str4 = call { ptr, i64 } @forge_string_new(ptr @str.1, i64 3)
  %str_eq5 = call i8 @forge_string_eq({ ptr, i64 } %text3, { ptr, i64 } %str4)
  %eq_ext6 = zext i8 %str_eq5 to i64
  %__bt3 = alloca { i64, { ptr, i64 } }, align 8
  store i64 %eq_ext6, ptr %__bt3, align 4
  %__bt37 = load i64, ptr %__bt3, align 4
  %ifcond8 = trunc i64 %__bt37 to i1
  %spec.select = select i1 %ifcond8, i64 1, i64 0
  br label %common.ret
}

define i64 @fib(i64 %0) {
entry:
  %n = alloca { i64, { ptr, i64 } }, align 8
  store i64 %0, ptr %n, align 4
  %n1 = load i64, ptr %n, align 4
  %le = icmp sle i64 %n1, 1
  %cmpext = zext i1 %le to i64
  %__bt4 = alloca { i64, { ptr, i64 } }, align 8
  store i64 %cmpext, ptr %__bt4, align 4
  %__bt42 = load i64, ptr %__bt4, align 4
  %ifcond = trunc i64 %__bt42 to i1
  %n3 = load i64, ptr %n, align 4
  br i1 %ifcond, label %common.ret, label %ifcont

common.ret:                                       ; preds = %entry, %ifcont
  %common.ret.op = phi i64 [ %__bt710, %ifcont ], [ %n3, %entry ]
  ret i64 %common.ret.op

ifcont:                                           ; preds = %entry
  %sub = sub i64 %n3, 1
  %__bt5 = alloca { i64, { ptr, i64 } }, align 8
  store i64 %sub, ptr %__bt5, align 4
  %n5 = load i64, ptr %n, align 4
  %sub6 = sub i64 %n5, 2
  %__bt6 = alloca { i64, { ptr, i64 } }, align 8
  store i64 %sub6, ptr %__bt6, align 4
  %__bt57 = load i64, ptr %__bt5, align 4
  %call = call i64 @fib(i64 %__bt57)
  %__bt68 = load i64, ptr %__bt6, align 4
  %call9 = call i64 @fib(i64 %__bt68)
  %add = add i64 %call, %call9
  %__bt7 = alloca { i64, { ptr, i64 } }, align 8
  store i64 %add, ptr %__bt7, align 4
  %__bt710 = load i64, ptr %__bt7, align 4
  br label %common.ret
}

define i32 @main() {
entry:
  %str = call { ptr, i64 } @forge_string_new(ptr @str.2, i64 5)
  %call = call { i64, { ptr, i64 } } @make_token(i64 1, { ptr, i64 } %str)
  %tok = alloca { i64, { ptr, i64 } }, align 8
  store { i64, { ptr, i64 } } %call, ptr %tok, align 8
  %tok1 = load { i64, { ptr, i64 } }, ptr %tok, align 8
  %kind_id = extractvalue { i64, { ptr, i64 } } %tok1, 0
  %__pt8 = alloca i64, align 8
  store i64 %kind_id, ptr %__pt8, align 4
  %__pt82 = load i64, ptr %__pt8, align 4
  %ts = call { ptr, i64 } @forge_int_to_string(i64 %__pt82)
  call void @forge_println_string({ ptr, i64 } %ts)
  %list_data = call ptr @forge_alloc(i64 24)
  %ep26 = bitcast ptr %list_data to ptr
  store i64 10, ptr %ep26, align 4
  %ep3 = getelementptr i64, ptr %list_data, i64 1
  store i64 20, ptr %ep3, align 4
  %ep4 = getelementptr i64, ptr %list_data, i64 2
  store i64 30, ptr %ep4, align 4
  %ls1 = insertvalue { ptr, i64 } undef, ptr %list_data, 0
  %ls2 = insertvalue { ptr, i64 } %ls1, i64 3, 1
  %__list9 = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %ls2, ptr %__list9, align 8
  %nums = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %ls2, ptr %nums, align 8
  %sum = alloca i64, align 8
  store i64 0, ptr %sum, align 4
  %nums5 = load { ptr, i64 }, ptr %nums, align 8
  %__for_i = alloca i64, align 8
  store i64 0, ptr %__for_i, align 4
  %list_len = call i64 @forge_string_length({ ptr, i64 } %nums5)
  br label %for.cond

for.cond:                                         ; preds = %for.body, %entry
  %for_i = load i64, ptr %__for_i, align 4
  %forcond = icmp slt i64 %for_i, %list_len
  br i1 %forcond, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %for_i_body = load i64, ptr %__for_i, align 4
  %list_data6 = extractvalue { ptr, i64 } %nums5, 0
  %elem_ptr = getelementptr i64, ptr %list_data6, i64 %for_i_body
  %n = load i64, ptr %elem_ptr, align 4
  %n7 = alloca i64, align 8
  store i64 %n, ptr %n7, align 4
  %sum8 = load i64, ptr %sum, align 4
  %n9 = load i64, ptr %n7, align 4
  %add = add i64 %sum8, %n9
  %__bt10 = alloca i64, align 8
  store i64 %add, ptr %__bt10, align 4
  %__bt1010 = load i64, ptr %__bt10, align 4
  store i64 %__bt1010, ptr %sum, align 4
  %for_i_cur = load i64, ptr %__for_i, align 4
  %for_i_next = add i64 %for_i_cur, 1
  store i64 %for_i_next, ptr %__for_i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %sum11 = load i64, ptr %sum, align 4
  %ts12 = call { ptr, i64 } @forge_int_to_string(i64 %sum11)
  call void @forge_println_string({ ptr, i64 } %ts12)
  %call13 = call i64 @fib(i64 15)
  %ts14 = call { ptr, i64 } @forge_int_to_string(i64 %call13)
  call void @forge_println_string({ ptr, i64 } %ts14)
  %str15 = call { ptr, i64 } @forge_string_new(ptr @str.3, i64 2)
  %call16 = call i64 @is_keyword({ ptr, i64 } %str15)
  %ts17 = call { ptr, i64 } @forge_int_to_string(i64 %call16)
  call void @forge_println_string({ ptr, i64 } %ts17)
  %map_new = call ptr @forge_map_new()
  %__map11 = alloca i64, align 8
  store ptr %map_new, ptr %__map11, align 8
  %m = alloca i64, align 8
  store ptr %map_new, ptr %m, align 8
  %m18 = load i64, ptr %m, align 4
  %str19 = call { ptr, i64 } @forge_string_new(ptr @str.4, i64 1)
  %map_get = call i64 @forge_map_get(i64 %m18, { ptr, i64 } %str19)
  %__pt12 = alloca i64, align 8
  store i64 %map_get, ptr %__pt12, align 4
  call void @forge_map_set(i64 %m18, { ptr, i64 } %str19, i64 42)
  %m20 = load i64, ptr %m, align 4
  %str21 = call { ptr, i64 } @forge_string_new(ptr @str.5, i64 1)
  %map_get22 = call i64 @forge_map_get(i64 %m20, { ptr, i64 } %str21)
  %__pt13 = alloca i64, align 8
  store i64 %map_get22, ptr %__pt13, align 4
  %__pt1323 = load i64, ptr %__pt13, align 4
  %ts24 = call { ptr, i64 } @forge_int_to_string(i64 %__pt1323)
  call void @forge_println_string({ ptr, i64 } %ts24)
  %str25 = call { ptr, i64 } @forge_string_new(ptr @str.6, i64 5)
  call void @forge_println_string({ ptr, i64 } %str25)
  ret i32 0
}
