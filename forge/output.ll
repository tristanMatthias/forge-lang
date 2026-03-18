; ModuleID = 'test_hello.fg'
source_filename = "test_hello.fg"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-darwin25.2.0"

@str = private unnamed_addr constant [14 x i8] c"=== Tests ===\00", align 1
@str.1 = private unnamed_addr constant [12 x i8] c"isqrt(144):\00", align 1
@str.2 = private unnamed_addr constant [14 x i8] c"isqrt(10000):\00", align 1
@str.3 = private unnamed_addr constant [6 x i8] c"done!\00", align 1

declare void @forge_println_string({ ptr, i64 })

declare { ptr, i64 } @forge_int_to_string(i64)

declare { ptr, i64 } @forge_string_new(ptr, i64)

define i64 @binary_search(i64 %0) {
entry:
  %target = alloca i64, align 8
  store i64 %0, ptr %target, align 4
  %lo = alloca i64, align 8
  store i64 0, ptr %lo, align 4
  %target1 = load i64, ptr %target, align 4
  %hi = alloca i64, align 8
  store i64 %target1, ptr %hi, align 4
  br label %while.cond

while.cond:                                       ; preds = %then24, %else25, %entry
  %lo2 = load i64, ptr %lo, align 4
  %hi3 = load i64, ptr %hi, align 4
  %le = icmp sle i64 %lo2, %hi3
  %cmpext = zext i1 %le to i64
  %__bt1 = alloca i64, align 8
  store i64 %cmpext, ptr %__bt1, align 4
  %__bt14 = load i64, ptr %__bt1, align 4
  %whilecond = trunc i64 %__bt14 to i1
  br i1 %whilecond, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %lo5 = load i64, ptr %lo, align 4
  %div = sdiv i64 %lo5, 2
  %__bt2 = alloca i64, align 8
  store i64 %div, ptr %__bt2, align 4
  %hi6 = load i64, ptr %hi, align 4
  %div7 = sdiv i64 %hi6, 2
  %__bt3 = alloca i64, align 8
  store i64 %div7, ptr %__bt3, align 4
  %__bt28 = load i64, ptr %__bt2, align 4
  %__bt39 = load i64, ptr %__bt3, align 4
  %add = add i64 %__bt28, %__bt39
  %__bt4 = alloca i64, align 8
  store i64 %add, ptr %__bt4, align 4
  %__bt410 = load i64, ptr %__bt4, align 4
  %mid = alloca i64, align 8
  store i64 %__bt410, ptr %mid, align 4
  %mid11 = load i64, ptr %mid, align 4
  %mid12 = load i64, ptr %mid, align 4
  %mul = mul i64 %mid11, %mid12
  %__bt5 = alloca i64, align 8
  store i64 %mul, ptr %__bt5, align 4
  %__bt513 = load i64, ptr %__bt5, align 4
  %sq = alloca i64, align 8
  store i64 %__bt513, ptr %sq, align 4
  %sq14 = load i64, ptr %sq, align 4
  %target15 = load i64, ptr %target, align 4
  %eq = icmp eq i64 %sq14, %target15
  %cmpext16 = zext i1 %eq to i64
  %__bt6 = alloca i64, align 8
  store i64 %cmpext16, ptr %__bt6, align 4
  %__bt617 = load i64, ptr %__bt6, align 4
  %ifcond = trunc i64 %__bt617 to i1
  br i1 %ifcond, label %then, label %else

common.ret:                                       ; preds = %then, %while.end
  %common.ret.op = phi i64 [ %hi32, %while.end ], [ %mid18, %then ]
  ret i64 %common.ret.op

while.end:                                        ; preds = %while.cond
  %hi32 = load i64, ptr %hi, align 4
  br label %common.ret

then:                                             ; preds = %while.body
  %mid18 = load i64, ptr %mid, align 4
  br label %common.ret

else:                                             ; preds = %while.body
  %sq19 = load i64, ptr %sq, align 4
  %target20 = load i64, ptr %target, align 4
  %lt = icmp slt i64 %sq19, %target20
  %cmpext21 = zext i1 %lt to i64
  %__bt7 = alloca i64, align 8
  store i64 %cmpext21, ptr %__bt7, align 4
  %__bt722 = load i64, ptr %__bt7, align 4
  %ifcond23 = trunc i64 %__bt722 to i1
  %mid27 = load i64, ptr %mid, align 4
  %__bt8 = alloca i64, align 8
  br i1 %ifcond23, label %then24, label %else25

then24:                                           ; preds = %else
  %add28 = add i64 %mid27, 1
  store i64 %add28, ptr %__bt8, align 4
  %__bt829 = load i64, ptr %__bt8, align 4
  store i64 %__bt829, ptr %lo, align 4
  br label %while.cond

else25:                                           ; preds = %else
  %sub = sub i64 %mid27, 1
  store i64 %sub, ptr %__bt8, align 4
  %__bt931 = load i64, ptr %__bt8, align 4
  store i64 %__bt931, ptr %hi, align 4
  br label %while.cond
}

define i32 @main() {
entry:
  %str = call { ptr, i64 } @forge_string_new(ptr @str, i64 13)
  call void @forge_println_string({ ptr, i64 } %str)
  %a = alloca i64, align 8
  store i64 10, ptr %a, align 4
  %b = alloca i64, align 8
  store i64 20, ptr %b, align 4
  %b1 = load i64, ptr %b, align 4
  %mul = mul i64 %b1, 2
  %__bt10 = alloca i64, align 8
  store i64 %mul, ptr %__bt10, align 4
  %a2 = load i64, ptr %a, align 4
  %__bt103 = load i64, ptr %__bt10, align 4
  %add = add i64 %a2, %__bt103
  %__bt11 = alloca i64, align 8
  store i64 %add, ptr %__bt11, align 4
  %__bt114 = load i64, ptr %__bt11, align 4
  %ts = call { ptr, i64 } @forge_int_to_string(i64 %__bt114)
  call void @forge_println_string({ ptr, i64 } %ts)
  %a5 = load i64, ptr %a, align 4
  %b6 = load i64, ptr %b, align 4
  %mul7 = mul i64 %a5, %b6
  %__bt12 = alloca i64, align 8
  store i64 %mul7, ptr %__bt12, align 4
  %__bt128 = load i64, ptr %__bt12, align 4
  %add9 = add i64 %__bt128, 30
  %__bt13 = alloca i64, align 8
  store i64 %add9, ptr %__bt13, align 4
  %__bt1310 = load i64, ptr %__bt13, align 4
  %ts11 = call { ptr, i64 } @forge_int_to_string(i64 %__bt1310)
  call void @forge_println_string({ ptr, i64 } %ts11)
  %str12 = call { ptr, i64 } @forge_string_new(ptr @str.1, i64 11)
  call void @forge_println_string({ ptr, i64 } %str12)
  %call = call i64 @binary_search(i64 144)
  %ts13 = call { ptr, i64 } @forge_int_to_string(i64 %call)
  call void @forge_println_string({ ptr, i64 } %ts13)
  %str14 = call { ptr, i64 } @forge_string_new(ptr @str.2, i64 13)
  call void @forge_println_string({ ptr, i64 } %str14)
  %call15 = call i64 @binary_search(i64 10000)
  %ts16 = call { ptr, i64 } @forge_int_to_string(i64 %call15)
  call void @forge_println_string({ ptr, i64 } %ts16)
  %str17 = call { ptr, i64 } @forge_string_new(ptr @str.3, i64 5)
  call void @forge_println_string({ ptr, i64 } %str17)
  ret i32 0
}
