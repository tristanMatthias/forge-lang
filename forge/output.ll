; ModuleID = 'test_hello.fg'
source_filename = "test_hello.fg"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-darwin25.2.0"

@str = private unnamed_addr constant [3 x i8] c"fn\00", align 1
@str.1 = private unnamed_addr constant [4 x i8] c"let\00", align 1
@str.2 = private unnamed_addr constant [3 x i8] c"if\00", align 1
@str.3 = private unnamed_addr constant [3 x i8] c"fn\00", align 1
@str.4 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@str.5 = private unnamed_addr constant [4 x i8] c"let\00", align 1
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

common.ret:                                       ; preds = %ifcont11, %ifcont, %entry
  %common.ret.op = phi i64 [ 1, %entry ], [ 1, %ifcont ], [ %spec.select, %ifcont11 ]
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
  br i1 %ifcond8, label %common.ret, label %ifcont11

ifcont11:                                         ; preds = %ifcont
  %text12 = load { ptr, i64 }, ptr %text, align 8
  %str13 = call { ptr, i64 } @forge_string_new(ptr @str.2, i64 2)
  %str_eq14 = call i8 @forge_string_eq({ ptr, i64 } %text12, { ptr, i64 } %str13)
  %eq_ext15 = zext i8 %str_eq14 to i64
  %__bt3 = alloca i64, align 8
  store i64 %eq_ext15, ptr %__bt3, align 4
  %__bt316 = load i64, ptr %__bt3, align 4
  %ifcond17 = trunc i64 %__bt316 to i1
  %spec.select = select i1 %ifcond17, i64 1, i64 0
  br label %common.ret
}

define i32 @main() {
entry:
  %str = call { ptr, i64 } @forge_string_new(ptr @str.3, i64 2)
  %call = call i64 @is_keyword({ ptr, i64 } %str)
  %ts = call { ptr, i64 } @forge_int_to_string(i64 %call)
  call void @forge_println_string({ ptr, i64 } %ts)
  %str1 = call { ptr, i64 } @forge_string_new(ptr @str.4, i64 5)
  %call2 = call i64 @is_keyword({ ptr, i64 } %str1)
  %ts3 = call { ptr, i64 } @forge_int_to_string(i64 %call2)
  call void @forge_println_string({ ptr, i64 } %ts3)
  %str4 = call { ptr, i64 } @forge_string_new(ptr @str.5, i64 3)
  %call5 = call i64 @is_keyword({ ptr, i64 } %str4)
  %ts6 = call { ptr, i64 } @forge_int_to_string(i64 %call5)
  call void @forge_println_string({ ptr, i64 } %ts6)
  %str7 = call { ptr, i64 } @forge_string_new(ptr @str.6, i64 5)
  call void @forge_println_string({ ptr, i64 } %str7)
  ret i32 0
}
