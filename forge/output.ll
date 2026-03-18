; ModuleID = 'test_hello.fg'
source_filename = "test_hello.fg"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-darwin25.2.0"

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

define i64 @count_to(i64 %0) {
entry:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 4
  %count = alloca i64, align 8
  store i64 0, ptr %count, align 4
  %i = alloca i64, align 8
  store i64 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %i1 = load i64, ptr %i, align 4
  %n2 = load i64, ptr %n, align 4
  %lt = icmp slt i64 %i1, %n2
  %cmpext = zext i1 %lt to i64
  %__bt1 = alloca i64, align 8
  store i64 %cmpext, ptr %__bt1, align 4
  %__bt13 = load i64, ptr %__bt1, align 4
  %whilecond = trunc i64 %__bt13 to i1
  %count4 = load i64, ptr %count, align 4
  br i1 %whilecond, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %add = add i64 %count4, 1
  %__bt2 = alloca i64, align 8
  store i64 %add, ptr %__bt2, align 4
  %__bt25 = load i64, ptr %__bt2, align 4
  store i64 %__bt25, ptr %count, align 4
  %i6 = load i64, ptr %i, align 4
  %add7 = add i64 %i6, 1
  %__bt3 = alloca i64, align 8
  store i64 %add7, ptr %__bt3, align 4
  %__bt38 = load i64, ptr %__bt3, align 4
  store i64 %__bt38, ptr %i, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  ret i64 %count4
}

define i32 @main() {
entry:
  %call = call i64 @count_to(i64 5)
  %result = alloca i64, align 8
  store i64 %call, ptr %result, align 4
  %result1 = load i64, ptr %result, align 4
  %ts = call { ptr, i64 } @forge_int_to_string(i64 %result1)
  call void @forge_println_string({ ptr, i64 } %ts)
  %str = call { ptr, i64 } @forge_string_new(ptr @str, i64 5)
  call void @forge_println_string({ ptr, i64 } %str)
  ret i32 0
}
