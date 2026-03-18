; ModuleID = 'test_hello.fg'
source_filename = "test_hello.fg"

declare void @forge_println_string({ ptr, i64 })

declare { ptr, i64 } @forge_int_to_string(i64)

declare { ptr, i64 } @forge_string_new(ptr, i64)

define i64 @count_down(i64 %0) {
entry:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 4
  %n1 = load i64, ptr %n, align 4
  %i = alloca i64, align 8
  store i64 %n1, ptr %i, align 4
  %n2 = load i64, ptr %n, align 4
  store i64 %n2, ptr %i, align 4
  %count = alloca i64, align 8
  store i64 0, ptr %count, align 4
  store i64 0, ptr %count, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %i3 = load i64, ptr %i, align 4
  %gt = icmp sgt i64 %i3, 0
  br i1 %gt, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %i4 = load i64, ptr %i, align 4
  %sub = sub i64 %i4, 1
  store i64 %sub, ptr %i, align 4
  %count5 = load i64, ptr %count, align 4
  %add = add i64 %count5, 1
  store i64 %add, ptr %count, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %i6 = load i64, ptr %i, align 4
  %gt7 = icmp sgt i64 %i6, 0
  %i8 = load i64, ptr %i, align 4
  %sub9 = sub i64 %i8, 1
  store i64 %sub9, ptr %i, align 4
  %count10 = load i64, ptr %count, align 4
  %add11 = add i64 %count10, 1
  store i64 %add11, ptr %count, align 4
  %count12 = load i64, ptr %count, align 4
  ret i64 %count12
  ret i64 0
}

define i32 @main() {
entry:
  %call = call i64 @count_down(i64 5)
  %ts = call { ptr, i64 } @forge_int_to_string(i64 %call)
  call void @forge_println_string({ ptr, i64 } %ts)
  ret i32 0
}
