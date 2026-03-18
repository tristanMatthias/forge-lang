; ModuleID = 'test_hello.fg'
source_filename = "test_hello.fg"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-darwin25.2.0"

@str = private unnamed_addr constant [3 x i8] c"fn\00", align 1
@str.1 = private unnamed_addr constant [4 x i8] c"let\00", align 1
@str.2 = private unnamed_addr constant [3 x i8] c"fn\00", align 1
@str.3 = private unnamed_addr constant [6 x i8] c"done!\00", align 1

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

define i64 @is_keyword({ ptr, i64 } %0) {
entry:
  %text = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %0, ptr %text, align 8
  %text1 = load { ptr, i64 }, ptr %text, align 8
  %str = call { ptr, i64 } @forge_string_new(ptr @str, i64 2)
  %str_eq = call i8 @forge_string_eq({ ptr, i64 } %text1, { ptr, i64 } %str)
  %eq_ext = zext i8 %str_eq to i64
  %__bt1 = alloca i64, align 8
  store i64 %eq_ext, ptr %__bt1, align 4
  %__bt12 = load i64, ptr %__bt1, align 4
  %ifcond = trunc i64 %__bt12 to i1
  br i1 %ifcond, label %common.ret, label %ifcont

common.ret:                                       ; preds = %ifcont, %entry
  %common.ret.op = phi i64 [ 1, %entry ], [ %spec.select, %ifcont ]
  ret i64 %common.ret.op

ifcont:                                           ; preds = %entry
  %text3 = load { ptr, i64 }, ptr %text, align 8
  %str4 = call { ptr, i64 } @forge_string_new(ptr @str.1, i64 3)
  %str_eq5 = call i8 @forge_string_eq({ ptr, i64 } %text3, { ptr, i64 } %str4)
  %eq_ext6 = zext i8 %str_eq5 to i64
  %__bt2 = alloca i64, align 8
  store i64 %eq_ext6, ptr %__bt2, align 4
  %__bt27 = load i64, ptr %__bt2, align 4
  %ifcond8 = trunc i64 %__bt27 to i1
  %spec.select = select i1 %ifcond8, i64 1, i64 0
  br label %common.ret
}

define i64 @fib(i64 %0) {
entry:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 4
  %n1 = load i64, ptr %n, align 4
  %le = icmp sle i64 %n1, 1
  %cmpext = zext i1 %le to i64
  %__bt3 = alloca i64, align 8
  store i64 %cmpext, ptr %__bt3, align 4
  %__bt32 = load i64, ptr %__bt3, align 4
  %ifcond = trunc i64 %__bt32 to i1
  %n3 = load i64, ptr %n, align 4
  br i1 %ifcond, label %common.ret, label %ifcont

common.ret:                                       ; preds = %entry, %ifcont
  %common.ret.op = phi i64 [ %__bt610, %ifcont ], [ %n3, %entry ]
  ret i64 %common.ret.op

ifcont:                                           ; preds = %entry
  %sub = sub i64 %n3, 1
  %__bt4 = alloca i64, align 8
  store i64 %sub, ptr %__bt4, align 4
  %n5 = load i64, ptr %n, align 4
  %sub6 = sub i64 %n5, 2
  %__bt5 = alloca i64, align 8
  store i64 %sub6, ptr %__bt5, align 4
  %__bt47 = load i64, ptr %__bt4, align 4
  %call = call i64 @fib(i64 %__bt47)
  %__bt58 = load i64, ptr %__bt5, align 4
  %call9 = call i64 @fib(i64 %__bt58)
  %add = add i64 %call, %call9
  %__bt6 = alloca i64, align 8
  store i64 %add, ptr %__bt6, align 4
  %__bt610 = load i64, ptr %__bt6, align 4
  br label %common.ret
}

define i32 @main() {
entry:
  %call = call i64 @fib(i64 15)
  %ts = call { ptr, i64 } @forge_int_to_string(i64 %call)
  call void @forge_println_string({ ptr, i64 } %ts)
  %str = call { ptr, i64 } @forge_string_new(ptr @str.2, i64 2)
  %call1 = call i64 @is_keyword({ ptr, i64 } %str)
  %ts2 = call { ptr, i64 } @forge_int_to_string(i64 %call1)
  call void @forge_println_string({ ptr, i64 } %ts2)
  %str3 = call { ptr, i64 } @forge_string_new(ptr @str.3, i64 5)
  call void @forge_println_string({ ptr, i64 } %str3)
  ret i32 0
}
