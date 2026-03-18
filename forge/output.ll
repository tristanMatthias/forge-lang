; ModuleID = 'test_hello.fg'
source_filename = "test_hello.fg"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-darwin25.2.0"

@str = private unnamed_addr constant [35 x i8] c"=== Forge Self-Hosted Compiler ===\00", align 1
@str.1 = private unnamed_addr constant [12 x i8] c"hello world\00", align 1
@str.2 = private unnamed_addr constant [6 x i8] c"world\00", align 1
@str.3 = private unnamed_addr constant [9 x i8] c"FizzBuzz\00", align 1
@str.4 = private unnamed_addr constant [5 x i8] c"Fizz\00", align 1
@str.5 = private unnamed_addr constant [5 x i8] c"Buzz\00", align 1
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
  %str1 = call { ptr, i64 } @forge_string_new(ptr @str.1, i64 11)
  %greeting = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %str1, ptr %greeting, align 8
  %greeting2 = load { ptr, i64 }, ptr %greeting, align 8
  %len = call i64 @forge_string_length({ ptr, i64 } %greeting2)
  %__pt5 = alloca i64, align 8
  store i64 %len, ptr %__pt5, align 4
  %__pt53 = load i64, ptr %__pt5, align 4
  %ts = call { ptr, i64 } @forge_int_to_string(i64 %__pt53)
  call void @forge_println_string({ ptr, i64 } %ts)
  %greeting4 = load { ptr, i64 }, ptr %greeting, align 8
  %charat = call { ptr, i64 } @forge_string_char_at({ ptr, i64 } %greeting4, i64 0)
  %__pt6 = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %charat, ptr %__pt6, align 8
  %__pt65 = load { ptr, i64 }, ptr %__pt6, align 8
  call void @forge_println_string({ ptr, i64 } %__pt65)
  %greeting6 = load { ptr, i64 }, ptr %greeting, align 8
  %charat7 = call { ptr, i64 } @forge_string_char_at({ ptr, i64 } %greeting6, i64 6)
  %__pt7 = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %charat7, ptr %__pt7, align 8
  %__pt78 = load { ptr, i64 }, ptr %__pt7, align 8
  call void @forge_println_string({ ptr, i64 } %__pt78)
  %greeting9 = load { ptr, i64 }, ptr %greeting, align 8
  %str10 = call { ptr, i64 } @forge_string_new(ptr @str.2, i64 5)
  %indexof = call i64 @forge_string_index_of({ ptr, i64 } %greeting9, { ptr, i64 } %str10)
  %__pt8 = alloca i64, align 8
  store i64 %indexof, ptr %__pt8, align 4
  %__pt811 = load i64, ptr %__pt8, align 4
  %ts12 = call { ptr, i64 } @forge_int_to_string(i64 %__pt811)
  call void @forge_println_string({ ptr, i64 } %ts12)
  %call = call i64 @fib(i64 20)
  %ts13 = call { ptr, i64 } @forge_int_to_string(i64 %call)
  call void @forge_println_string({ ptr, i64 } %ts13)
  %sum = alloca i64, align 8
  store i64 0, ptr %sum, align 4
  %i = alloca i64, align 8
  store i64 1, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %i14 = load i64, ptr %i, align 4
  %le = icmp sle i64 %i14, 10
  %cmpext = zext i1 %le to i64
  %__bt9 = alloca i64, align 8
  store i64 %cmpext, ptr %__bt9, align 4
  %__bt915 = load i64, ptr %__bt9, align 4
  %whilecond = trunc i64 %__bt915 to i1
  %sum16 = load i64, ptr %sum, align 4
  br i1 %whilecond, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %i17 = load i64, ptr %i, align 4
  %add = add i64 %sum16, %i17
  %__bt10 = alloca i64, align 8
  store i64 %add, ptr %__bt10, align 4
  %__bt1018 = load i64, ptr %__bt10, align 4
  store i64 %__bt1018, ptr %sum, align 4
  %i19 = load i64, ptr %i, align 4
  %add20 = add i64 %i19, 1
  %__bt11 = alloca i64, align 8
  store i64 %add20, ptr %__bt11, align 4
  %__bt1121 = load i64, ptr %__bt11, align 4
  store i64 %__bt1121, ptr %i, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %ts23 = call { ptr, i64 } @forge_int_to_string(i64 %sum16)
  call void @forge_println_string({ ptr, i64 } %ts23)
  store i64 1, ptr %i, align 4
  br label %while.cond24

while.cond24:                                     ; preds = %ifcont, %while.end
  %i27 = load i64, ptr %i, align 4
  %le28 = icmp sle i64 %i27, 15
  %cmpext29 = zext i1 %le28 to i64
  %__bt12 = alloca i64, align 8
  store i64 %cmpext29, ptr %__bt12, align 4
  %__bt1230 = load i64, ptr %__bt12, align 4
  %whilecond31 = trunc i64 %__bt1230 to i1
  br i1 %whilecond31, label %while.body25, label %while.end26

while.body25:                                     ; preds = %while.cond24
  %i32 = load i64, ptr %i, align 4
  %div = sdiv i64 %i32, 15
  %mul = mul i64 %div, 15
  %__bt13 = alloca i64, align 8
  store i64 %mul, ptr %__bt13, align 4
  %__bt1333 = load i64, ptr %__bt13, align 4
  %i34 = load i64, ptr %i, align 4
  %eq = icmp eq i64 %__bt1333, %i34
  %cmpext35 = zext i1 %eq to i64
  %__bt14 = alloca i64, align 8
  store i64 %cmpext35, ptr %__bt14, align 4
  %__bt1436 = load i64, ptr %__bt14, align 4
  %ifcond = trunc i64 %__bt1436 to i1
  br i1 %ifcond, label %then, label %else

while.end26:                                      ; preds = %while.cond24
  %str69 = call { ptr, i64 } @forge_string_new(ptr @str.6, i64 5)
  call void @forge_println_string({ ptr, i64 } %str69)
  ret i32 0

then:                                             ; preds = %while.body25
  %str37 = call { ptr, i64 } @forge_string_new(ptr @str.3, i64 8)
  br label %ifcont

else:                                             ; preds = %while.body25
  %i38 = load i64, ptr %i, align 4
  %div39 = sdiv i64 %i38, 3
  %mul40 = mul i64 %div39, 3
  %__bt15 = alloca i64, align 8
  store i64 %mul40, ptr %__bt15, align 4
  %__bt1541 = load i64, ptr %__bt15, align 4
  %i42 = load i64, ptr %i, align 4
  %eq43 = icmp eq i64 %__bt1541, %i42
  %cmpext44 = zext i1 %eq43 to i64
  %__bt16 = alloca i64, align 8
  store i64 %cmpext44, ptr %__bt16, align 4
  %__bt1645 = load i64, ptr %__bt16, align 4
  %ifcond46 = trunc i64 %__bt1645 to i1
  br i1 %ifcond46, label %then47, label %else48

ifcont:                                           ; preds = %then60, %else61, %then47, %then
  %str50.sink = phi { ptr, i64 } [ %str50, %then47 ], [ %str37, %then ], [ %ts65, %else61 ], [ %str63, %then60 ]
  call void @forge_println_string({ ptr, i64 } %str50.sink)
  %i66 = load i64, ptr %i, align 4
  %add67 = add i64 %i66, 1
  %__bt19 = alloca i64, align 8
  store i64 %add67, ptr %__bt19, align 4
  %__bt1968 = load i64, ptr %__bt19, align 4
  store i64 %__bt1968, ptr %i, align 4
  br label %while.cond24

then47:                                           ; preds = %else
  %str50 = call { ptr, i64 } @forge_string_new(ptr @str.4, i64 4)
  br label %ifcont

else48:                                           ; preds = %else
  %i51 = load i64, ptr %i, align 4
  %div52 = sdiv i64 %i51, 5
  %mul53 = mul i64 %div52, 5
  %__bt17 = alloca i64, align 8
  store i64 %mul53, ptr %__bt17, align 4
  %__bt1754 = load i64, ptr %__bt17, align 4
  %i55 = load i64, ptr %i, align 4
  %eq56 = icmp eq i64 %__bt1754, %i55
  %cmpext57 = zext i1 %eq56 to i64
  %__bt18 = alloca i64, align 8
  store i64 %cmpext57, ptr %__bt18, align 4
  %__bt1858 = load i64, ptr %__bt18, align 4
  %ifcond59 = trunc i64 %__bt1858 to i1
  br i1 %ifcond59, label %then60, label %else61

then60:                                           ; preds = %else48
  %str63 = call { ptr, i64 } @forge_string_new(ptr @str.5, i64 4)
  br label %ifcont

else61:                                           ; preds = %else48
  %i64 = load i64, ptr %i, align 4
  %ts65 = call { ptr, i64 } @forge_int_to_string(i64 %i64)
  br label %ifcont
}
