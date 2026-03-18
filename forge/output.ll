; ModuleID = 'test_hello.fg'
source_filename = "test_hello.fg"

declare void @forge_println_string({ ptr, i64 })

declare { ptr, i64 } @forge_int_to_string(i64)

declare { ptr, i64 } @forge_string_new(ptr, i64)

define i64 @fib(i64 %0) {
entry:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 4
  %n1 = load i64, ptr %n, align 4
  %le = icmp sle i64 %n1, 1
  br i1 %le, label %then, label %else

then:                                             ; preds = %entry
  %n2 = load i64, ptr %n, align 4
  ret i64 %n2
  br label %ifcont

else:                                             ; preds = %entry
  br label %ifcont

ifcont:                                           ; preds = %else, %then
  %n3 = load i64, ptr %n, align 4
  %sub = sub i64 %n3, 1
  %call = call i64 @fib(i64 %sub)
  %n4 = load i64, ptr %n, align 4
  %sub5 = sub i64 %n4, 2
  %call6 = call i64 @fib(i64 %sub5)
  %add = add i64 %call, %call6
  ret i64 %add
  ret i64 0
}

define i64 @factorial(i64 %0) {
entry:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 4
  %n1 = load i64, ptr %n, align 4
  %le = icmp sle i64 %n1, 1
  br i1 %le, label %then, label %else

then:                                             ; preds = %entry
  ret i64 1
  br label %ifcont

else:                                             ; preds = %entry
  br label %ifcont

ifcont:                                           ; preds = %else, %then
  %n2 = load i64, ptr %n, align 4
  %n3 = load i64, ptr %n, align 4
  %sub = sub i64 %n3, 1
  %call = call i64 @factorial(i64 %sub)
  %mul = mul i64 %n2, %call
  ret i64 %mul
  ret i64 0
}

define i64 @gcd(i64 %0, i64 %1) {
entry:
  %a = alloca i64, align 8
  store i64 %0, ptr %a, align 4
  %b = alloca i64, align 8
  store i64 %1, ptr %b, align 4
  %b1 = load i64, ptr %b, align 4
  %eq = icmp eq i64 %b1, 0
  br i1 %eq, label %then, label %else

then:                                             ; preds = %entry
  %a2 = load i64, ptr %a, align 4
  ret i64 %a2
  br label %ifcont

else:                                             ; preds = %entry
  br label %ifcont

ifcont:                                           ; preds = %else, %then
  %b3 = load i64, ptr %b, align 4
  %a4 = load i64, ptr %a, align 4
  %a5 = load i64, ptr %a, align 4
  %b6 = load i64, ptr %b, align 4
  %div = sdiv i64 %a5, %b6
  %b7 = load i64, ptr %b, align 4
  %mul = mul i64 %div, %b7
  %sub = sub i64 %a4, %mul
  %call = call i64 @gcd(i64 %b3, i64 %sub)
  ret i64 %call
  ret i64 0
}

define i64 @pow(i64 %0, i64 %1) {
entry:
  %base = alloca i64, align 8
  store i64 %0, ptr %base, align 4
  %exp = alloca i64, align 8
  store i64 %1, ptr %exp, align 4
  %exp1 = load i64, ptr %exp, align 4
  %eq = icmp eq i64 %exp1, 0
  br i1 %eq, label %then, label %else

then:                                             ; preds = %entry
  ret i64 1
  br label %ifcont

else:                                             ; preds = %entry
  br label %ifcont

ifcont:                                           ; preds = %else, %then
  %base2 = load i64, ptr %base, align 4
  %base3 = load i64, ptr %base, align 4
  %exp4 = load i64, ptr %exp, align 4
  %sub = sub i64 %exp4, 1
  %call = call i64 @pow(i64 %base3, i64 %sub)
  %mul = mul i64 %base2, %call
  ret i64 %mul
  ret i64 0
}

define i64 @is_prime(i64 %0) {
entry:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 4
  %n1 = load i64, ptr %n, align 4
  %lt = icmp slt i64 %n1, 2
  br i1 %lt, label %then, label %else

then:                                             ; preds = %entry
  ret i64 0
  br label %ifcont

else:                                             ; preds = %entry
  br label %ifcont

ifcont:                                           ; preds = %else, %then
  %i = alloca i64, align 8
  store i64 2, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %ifcont12, %ifcont
  %i2 = load i64, ptr %i, align 4
  %i3 = load i64, ptr %i, align 4
  %mul = mul i64 %i2, %i3
  %n4 = load i64, ptr %n, align 4
  %le = icmp sle i64 %mul, %n4
  br i1 %le, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %n5 = load i64, ptr %n, align 4
  %i6 = load i64, ptr %i, align 4
  %div = sdiv i64 %n5, %i6
  %i7 = load i64, ptr %i, align 4
  %mul8 = mul i64 %div, %i7
  %n9 = load i64, ptr %n, align 4
  %eq = icmp eq i64 %mul8, %n9
  br i1 %eq, label %then10, label %else11

while.end:                                        ; preds = %while.cond
  ret i64 1
  ret i64 0

then10:                                           ; preds = %while.body
  ret i64 0
  br label %ifcont12

else11:                                           ; preds = %while.body
  br label %ifcont12

ifcont12:                                         ; preds = %else11, %then10
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
  br i1 %eq, label %then, label %else

while.end:                                        ; preds = %while.cond
  %count7 = load i64, ptr %count, align 4
  ret i64 %count7
  ret i64 0

then:                                             ; preds = %while.body
  %count4 = load i64, ptr %count, align 4
  %add = add i64 %count4, 1
  store i64 %add, ptr %count, align 4
  br label %ifcont

else:                                             ; preds = %while.body
  br label %ifcont

ifcont:                                           ; preds = %else, %then
  %n5 = load i64, ptr %n, align 4
  %add6 = add i64 %n5, 1
  store i64 %add6, ptr %n, align 4
  br label %while.cond
}

define i64 @collatz_steps(i64 %0) {
entry:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 4
  %steps = alloca i64, align 8
  store i64 0, ptr %steps, align 4
  %n1 = load i64, ptr %n, align 4
  %current = alloca i64, align 8
  store i64 %n1, ptr %current, align 4
  br label %while.cond

while.cond:                                       ; preds = %ifcont, %entry
  %current2 = load i64, ptr %current, align 4
  %gt = icmp sgt i64 %current2, 1
  br i1 %gt, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %current3 = load i64, ptr %current, align 4
  %div = sdiv i64 %current3, 2
  %mul = mul i64 %div, 2
  %current4 = load i64, ptr %current, align 4
  %eq = icmp eq i64 %mul, %current4
  br i1 %eq, label %then, label %else

while.end:                                        ; preds = %while.cond
  %steps11 = load i64, ptr %steps, align 4
  ret i64 %steps11
  ret i64 0

then:                                             ; preds = %while.body
  %current5 = load i64, ptr %current, align 4
  %div6 = sdiv i64 %current5, 2
  store i64 %div6, ptr %current, align 4
  br label %ifcont

else:                                             ; preds = %while.body
  %current7 = load i64, ptr %current, align 4
  %mul8 = mul i64 %current7, 3
  %add = add i64 %mul8, 1
  store i64 %add, ptr %current, align 4
  br label %ifcont

ifcont:                                           ; preds = %else, %then
  %steps9 = load i64, ptr %steps, align 4
  %add10 = add i64 %steps9, 1
  store i64 %add10, ptr %steps, align 4
  br label %while.cond
}

define i32 @main() {
entry:
  %call = call i64 @fib(i64 20)
  %ts = call { ptr, i64 } @forge_int_to_string(i64 %call)
  call void @forge_println_string({ ptr, i64 } %ts)
  %call1 = call i64 @factorial(i64 12)
  %ts2 = call { ptr, i64 } @forge_int_to_string(i64 %call1)
  call void @forge_println_string({ ptr, i64 } %ts2)
  %call3 = call i64 @gcd(i64 252, i64 105)
  %ts4 = call { ptr, i64 } @forge_int_to_string(i64 %call3)
  call void @forge_println_string({ ptr, i64 } %ts4)
  %call5 = call i64 @pow(i64 2, i64 16)
  %ts6 = call { ptr, i64 } @forge_int_to_string(i64 %call5)
  call void @forge_println_string({ ptr, i64 } %ts6)
  %call7 = call i64 @is_prime(i64 97)
  %ts8 = call { ptr, i64 } @forge_int_to_string(i64 %call7)
  call void @forge_println_string({ ptr, i64 } %ts8)
  %call9 = call i64 @is_prime(i64 100)
  %ts10 = call { ptr, i64 } @forge_int_to_string(i64 %call9)
  call void @forge_println_string({ ptr, i64 } %ts10)
  %call11 = call i64 @count_primes(i64 100)
  %ts12 = call { ptr, i64 } @forge_int_to_string(i64 %call11)
  call void @forge_println_string({ ptr, i64 } %ts12)
  %call13 = call i64 @collatz_steps(i64 27)
  %ts14 = call { ptr, i64 } @forge_int_to_string(i64 %call13)
  call void @forge_println_string({ ptr, i64 } %ts14)
  ret i32 0
}
