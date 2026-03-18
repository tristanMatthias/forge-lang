; ModuleID = 'test_hello.fg'
source_filename = "test_hello.fg"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-darwin25.2.0"

@str = private unnamed_addr constant [35 x i8] c"=== Forge Self-Hosted Compiler ===\00", align 1
@str.1 = private unnamed_addr constant [6 x i8] c"Forge\00", align 1
@str.2 = private unnamed_addr constant [18 x i8] c"All tests passed!\00", align 1

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
  %str = call { ptr, i64 } @forge_string_new(ptr @str, i64 34)
  call void @forge_println_string({ ptr, i64 } %str)
  %call = call i64 @fib(i64 15)
  %ts = call { ptr, i64 } @forge_int_to_string(i64 %call)
  call void @forge_println_string({ ptr, i64 } %ts)
  %str1 = call { ptr, i64 } @forge_string_new(ptr @str.1, i64 5)
  %name = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %str1, ptr %name, align 8
  %name2 = load { ptr, i64 }, ptr %name, align 8
  %len = call i64 @forge_string_length({ ptr, i64 } %name2)
  %__pt5 = alloca i64, align 8
  store i64 %len, ptr %__pt5, align 4
  %__pt53 = load i64, ptr %__pt5, align 4
  %ts4 = call { ptr, i64 } @forge_int_to_string(i64 %__pt53)
  call void @forge_println_string({ ptr, i64 } %ts4)
  %name5 = load { ptr, i64 }, ptr %name, align 8
  %charat = call { ptr, i64 } @forge_string_char_at({ ptr, i64 } %name5, i64 0)
  %__pt6 = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %charat, ptr %__pt6, align 8
  %__pt66 = load { ptr, i64 }, ptr %__pt6, align 8
  call void @forge_println_string({ ptr, i64 } %__pt66)
  %list_data = call ptr @forge_alloc(i64 80)
  %ep44 = bitcast ptr %list_data to ptr
  store i64 2, ptr %ep44, align 4
  %ep7 = getelementptr i64, ptr %list_data, i64 1
  store i64 3, ptr %ep7, align 4
  %ep8 = getelementptr i64, ptr %list_data, i64 2
  store i64 5, ptr %ep8, align 4
  %ep9 = getelementptr i64, ptr %list_data, i64 3
  store i64 7, ptr %ep9, align 4
  %ep10 = getelementptr i64, ptr %list_data, i64 4
  store i64 11, ptr %ep10, align 4
  %ep11 = getelementptr i64, ptr %list_data, i64 5
  store i64 13, ptr %ep11, align 4
  %ep12 = getelementptr i64, ptr %list_data, i64 6
  store i64 17, ptr %ep12, align 4
  %ep13 = getelementptr i64, ptr %list_data, i64 7
  store i64 19, ptr %ep13, align 4
  %ep14 = getelementptr i64, ptr %list_data, i64 8
  store i64 23, ptr %ep14, align 4
  %ep15 = getelementptr i64, ptr %list_data, i64 9
  store i64 29, ptr %ep15, align 4
  %ls1 = insertvalue { ptr, i64 } undef, ptr %list_data, 0
  %ls2 = insertvalue { ptr, i64 } %ls1, i64 10, 1
  %__list7 = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %ls2, ptr %__list7, align 8
  %primes = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %ls2, ptr %primes, align 8
  %sum = alloca i64, align 8
  store i64 0, ptr %sum, align 4
  %primes16 = load { ptr, i64 }, ptr %primes, align 8
  %__for_i = alloca i64, align 8
  store i64 0, ptr %__for_i, align 4
  %list_len = call i64 @forge_string_length({ ptr, i64 } %primes16)
  br label %for.cond

for.cond:                                         ; preds = %for.body, %entry
  %for_i = load i64, ptr %__for_i, align 4
  %forcond = icmp slt i64 %for_i, %list_len
  br i1 %forcond, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %for_i_body = load i64, ptr %__for_i, align 4
  %list_data17 = extractvalue { ptr, i64 } %primes16, 0
  %elem_ptr = getelementptr i64, ptr %list_data17, i64 %for_i_body
  %p = load i64, ptr %elem_ptr, align 4
  %p18 = alloca i64, align 8
  store i64 %p, ptr %p18, align 4
  %sum19 = load i64, ptr %sum, align 4
  %p20 = load i64, ptr %p18, align 4
  %add = add i64 %sum19, %p20
  %__bt8 = alloca i64, align 8
  store i64 %add, ptr %__bt8, align 4
  %__bt821 = load i64, ptr %__bt8, align 4
  store i64 %__bt821, ptr %sum, align 4
  %for_i_cur = load i64, ptr %__for_i, align 4
  %for_i_next = add i64 %for_i_cur, 1
  store i64 %for_i_next, ptr %__for_i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %sum22 = load i64, ptr %sum, align 4
  %ts23 = call { ptr, i64 } @forge_int_to_string(i64 %sum22)
  call void @forge_println_string({ ptr, i64 } %ts23)
  %primes24 = load { ptr, i64 }, ptr %primes, align 8
  %len25 = call i64 @forge_string_length({ ptr, i64 } %primes24)
  %__pt9 = alloca i64, align 8
  store i64 %len25, ptr %__pt9, align 4
  %__pt926 = load i64, ptr %__pt9, align 4
  %ts27 = call { ptr, i64 } @forge_int_to_string(i64 %__pt926)
  call void @forge_println_string({ ptr, i64 } %ts27)
  %count = alloca i64, align 8
  store i64 0, ptr %count, align 4
  %i = alloca i64, align 8
  store i64 1, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %ifcont, %for.end
  %i28 = load i64, ptr %i, align 4
  %le = icmp sle i64 %i28, 20
  %cmpext = zext i1 %le to i64
  %__bt10 = alloca i64, align 8
  store i64 %cmpext, ptr %__bt10, align 4
  %__bt1029 = load i64, ptr %__bt10, align 4
  %whilecond = trunc i64 %__bt1029 to i1
  br i1 %whilecond, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %i30 = load i64, ptr %i, align 4
  %div = sdiv i64 %i30, 3
  %mul = mul i64 %div, 3
  %__bt11 = alloca i64, align 8
  store i64 %mul, ptr %__bt11, align 4
  %__bt1131 = load i64, ptr %__bt11, align 4
  %i32 = load i64, ptr %i, align 4
  %eq = icmp eq i64 %__bt1131, %i32
  %cmpext33 = zext i1 %eq to i64
  %__bt12 = alloca i64, align 8
  store i64 %cmpext33, ptr %__bt12, align 4
  %__bt1234 = load i64, ptr %__bt12, align 4
  %ifcond = trunc i64 %__bt1234 to i1
  br i1 %ifcond, label %then, label %ifcont

while.end:                                        ; preds = %while.cond
  %count41 = load i64, ptr %count, align 4
  %ts42 = call { ptr, i64 } @forge_int_to_string(i64 %count41)
  call void @forge_println_string({ ptr, i64 } %ts42)
  %str43 = call { ptr, i64 } @forge_string_new(ptr @str.2, i64 17)
  call void @forge_println_string({ ptr, i64 } %str43)
  ret i32 0

then:                                             ; preds = %while.body
  %count35 = load i64, ptr %count, align 4
  %add36 = add i64 %count35, 1
  %__bt13 = alloca i64, align 8
  store i64 %add36, ptr %__bt13, align 4
  %__bt1337 = load i64, ptr %__bt13, align 4
  store i64 %__bt1337, ptr %count, align 4
  br label %ifcont

ifcont:                                           ; preds = %while.body, %then
  %i38 = load i64, ptr %i, align 4
  %add39 = add i64 %i38, 1
  %__bt14 = alloca i64, align 8
  store i64 %add39, ptr %__bt14, align 4
  %__bt1440 = load i64, ptr %__bt14, align 4
  store i64 %__bt1440, ptr %i, align 4
  br label %while.cond
}
