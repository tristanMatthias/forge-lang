; ModuleID = 'test_hello.fg'
source_filename = "test_hello.fg"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-darwin25.2.0"

@str = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@str.1 = private unnamed_addr constant [6 x i8] c"done!\00", align 1

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

define i64 @count_chars({ ptr, i64 } %0) {
entry:
  %s = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %0, ptr %s, align 8
  %count = alloca i64, align 8
  store i64 0, ptr %count, align 4
  %i = alloca i64, align 8
  store i64 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %s1 = load { ptr, i64 }, ptr %s, align 8
  %len = call i64 @forge_string_length({ ptr, i64 } %s1)
  %__pt1 = alloca i64, align 8
  store i64 %len, ptr %__pt1, align 4
  %i2 = load i64, ptr %i, align 4
  %__pt13 = load i64, ptr %__pt1, align 4
  %lt = icmp slt i64 %i2, %__pt13
  %cmpext = zext i1 %lt to i64
  %__bt2 = alloca i64, align 8
  store i64 %cmpext, ptr %__bt2, align 4
  %__bt24 = load i64, ptr %__bt2, align 4
  %whilecond = trunc i64 %__bt24 to i1
  %count5 = load i64, ptr %count, align 4
  br i1 %whilecond, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %add = add i64 %count5, 1
  %__bt3 = alloca i64, align 8
  store i64 %add, ptr %__bt3, align 4
  %__bt36 = load i64, ptr %__bt3, align 4
  store i64 %__bt36, ptr %count, align 4
  %i7 = load i64, ptr %i, align 4
  %add8 = add i64 %i7, 1
  %__bt4 = alloca i64, align 8
  store i64 %add8, ptr %__bt4, align 4
  %__bt49 = load i64, ptr %__bt4, align 4
  store i64 %__bt49, ptr %i, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  ret i64 %count5
}

define i32 @main() {
entry:
  %str = call { ptr, i64 } @forge_string_new(ptr @str, i64 5)
  %call = call i64 @count_chars({ ptr, i64 } %str)
  %n = alloca { ptr, i64 }, align 8
  store i64 %call, ptr %n, align 4
  %n1 = load { ptr, i64 }, ptr %n, align 8
  call void @forge_println_string({ ptr, i64 } %n1)
  %str2 = call { ptr, i64 } @forge_string_new(ptr @str.1, i64 5)
  call void @forge_println_string({ ptr, i64 } %str2)
  ret i32 0
}
