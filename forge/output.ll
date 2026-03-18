; ModuleID = 'test_hello.fg'
source_filename = "test_hello.fg"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-darwin25.2.0"

@str = private unnamed_addr constant [35 x i8] c"=== Forge Self-Hosted Compiler ===\00", align 1
@str.1 = private unnamed_addr constant [9 x i8] c"fib(20):\00", align 1
@str.2 = private unnamed_addr constant [18 x i8] c"primes under 100:\00", align 1
@str.3 = private unnamed_addr constant [6 x i8] c"done!\00", align 1

declare void @forge_println_string({ ptr, i64 })

declare { ptr, i64 } @forge_int_to_string(i64)

declare { ptr, i64 } @forge_string_new(ptr, i64)

define i64 @fib(i64 %0) {
entry:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 4
  %n1 = load i64, ptr %n, align 4
  %le = icmp sle i64 %n1, 1
  %n2 = load i64, ptr %n, align 4
  br i1 %le, label %common.ret, label %ifcont

common.ret:                                       ; preds = %entry, %ifcont
  %common.ret.op = phi i64 [ %add, %ifcont ], [ %n2, %entry ]
  ret i64 %common.ret.op

ifcont:                                           ; preds = %entry
  %sub = sub i64 %n2, 1
  %call = call i64 @fib(i64 %sub)
  %n4 = load i64, ptr %n, align 4
  %sub5 = sub i64 %n4, 2
  %call6 = call i64 @fib(i64 %sub5)
  %add = add i64 %call, %call6
  br label %common.ret
}

define i64 @is_prime(i64 %0) {
entry:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 4
  %n1 = load i64, ptr %n, align 4
  %lt = icmp slt i64 %n1, 2
  br i1 %lt, label %common.ret, label %ifcont

common.ret:                                       ; preds = %while.body, %while.cond, %entry
  %common.ret.op = phi i64 [ 0, %entry ], [ 0, %while.body ], [ 1, %while.cond ]
  ret i64 %common.ret.op

ifcont:                                           ; preds = %entry
  %i = alloca i64, align 8
  store i64 2, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %ifcont12, %ifcont
  %i2 = load i64, ptr %i, align 4
  %i3 = load i64, ptr %i, align 4
  %mul = mul i64 %i2, %i3
  %n4 = load i64, ptr %n, align 4
  %le = icmp sle i64 %mul, %n4
  br i1 %le, label %while.body, label %common.ret

while.body:                                       ; preds = %while.cond
  %n5 = load i64, ptr %n, align 4
  %i6 = load i64, ptr %i, align 4
  %div = sdiv i64 %n5, %i6
  %i7 = load i64, ptr %i, align 4
  %mul8 = mul i64 %div, %i7
  %n9 = load i64, ptr %n, align 4
  %eq = icmp eq i64 %mul8, %n9
  br i1 %eq, label %common.ret, label %ifcont12

ifcont12:                                         ; preds = %while.body
  %i13 = load i64, ptr %i, align 4
  %add = add i64 %i13, 1
  store i64 %add, ptr %i, align 4
  br label %while.cond
}

define i64 @count_primes(i64 %0) {
entry:
  %limit = alloca i64, align 8
  store i64 %0, ptr %limit, align 4
  %count = alloca i64, align 8
  store i64 0, ptr %count, align 4
  %n = alloca i64, align 8
  store i64 2, ptr %n, align 4
  br label %while.cond

while.cond:                                       ; preds = %ifcont, %entry
  %n1 = load i64, ptr %n, align 4
  %limit2 = load i64, ptr %limit, align 4
  %le = icmp sle i64 %n1, %limit2
  br i1 %le, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %n3 = load i64, ptr %n, align 4
  %call = call i64 @is_prime(i64 %n3)
  %eq = icmp eq i64 %call, 1
  br i1 %eq, label %then, label %ifcont

while.end:                                        ; preds = %while.cond
  %count7 = load i64, ptr %count, align 4
  ret i64 %count7

then:                                             ; preds = %while.body
  %count4 = load i64, ptr %count, align 4
  %add = add i64 %count4, 1
  store i64 %add, ptr %count, align 4
  br label %ifcont

ifcont:                                           ; preds = %while.body, %then
  %n5 = load i64, ptr %n, align 4
  %add6 = add i64 %n5, 1
  store i64 %add6, ptr %n, align 4
  br label %while.cond
}

define i32 @main() {
entry:
  %str = call { ptr, i64 } @forge_string_new(ptr @str, i64 34)
  call void @forge_println_string({ ptr, i64 } %str)
  %str1 = call { ptr, i64 } @forge_string_new(ptr @str.1, i64 8)
  call void @forge_println_string({ ptr, i64 } %str1)
  %call = call i64 @fib(i64 20)
  %ts = call { ptr, i64 } @forge_int_to_string(i64 %call)
  call void @forge_println_string({ ptr, i64 } %ts)
  %str2 = call { ptr, i64 } @forge_string_new(ptr @str.2, i64 17)
  call void @forge_println_string({ ptr, i64 } %str2)
  %call3 = call i64 @count_primes(i64 100)
  %ts4 = call { ptr, i64 } @forge_int_to_string(i64 %call3)
  call void @forge_println_string({ ptr, i64 } %ts4)
  %str5 = call { ptr, i64 } @forge_string_new(ptr @str.3, i64 5)
  call void @forge_println_string({ ptr, i64 } %str5)
  ret i32 0
}
