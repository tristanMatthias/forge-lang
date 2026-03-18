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

define i32 @main() {
entry:
  %list_data = call ptr @forge_alloc(i64 40)
  %ep41 = bitcast ptr %list_data to ptr
  store i64 10, ptr %ep41, align 4
  %ep1 = getelementptr i64, ptr %list_data, i64 1
  store i64 20, ptr %ep1, align 4
  %ep2 = getelementptr i64, ptr %list_data, i64 2
  store i64 30, ptr %ep2, align 4
  %ep3 = getelementptr i64, ptr %list_data, i64 3
  store i64 40, ptr %ep3, align 4
  %ep4 = getelementptr i64, ptr %list_data, i64 4
  store i64 50, ptr %ep4, align 4
  %ls1 = insertvalue { ptr, i64 } undef, ptr %list_data, 0
  %ls2 = insertvalue { ptr, i64 } %ls1, i64 5, 1
  %__list1 = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %ls2, ptr %__list1, align 8
  %nums = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %ls2, ptr %nums, align 8
  %nums5 = load { ptr, i64 }, ptr %nums, align 8
  %len = call i64 @forge_string_length({ ptr, i64 } %nums5)
  %__pt2 = alloca i64, align 8
  store i64 %len, ptr %__pt2, align 4
  %__pt26 = load i64, ptr %__pt2, align 4
  %ts = call { ptr, i64 } @forge_int_to_string(i64 %__pt26)
  call void @forge_println_string({ ptr, i64 } %ts)
  %nums7 = load { ptr, i64 }, ptr %nums, align 8
  %list_data8 = extractvalue { ptr, i64 } %nums7, 0
  %elem_ptr42 = bitcast ptr %list_data8 to ptr
  %elem = load i64, ptr %elem_ptr42, align 4
  %__pt3 = alloca i64, align 8
  store i64 %elem, ptr %__pt3, align 4
  %__pt39 = load i64, ptr %__pt3, align 4
  %ts10 = call { ptr, i64 } @forge_int_to_string(i64 %__pt39)
  call void @forge_println_string({ ptr, i64 } %ts10)
  %nums11 = load { ptr, i64 }, ptr %nums, align 8
  %list_data12 = extractvalue { ptr, i64 } %nums11, 0
  %elem_ptr13 = getelementptr i64, ptr %list_data12, i64 2
  %elem14 = load i64, ptr %elem_ptr13, align 4
  %__pt4 = alloca i64, align 8
  store i64 %elem14, ptr %__pt4, align 4
  %__pt415 = load i64, ptr %__pt4, align 4
  %ts16 = call { ptr, i64 } @forge_int_to_string(i64 %__pt415)
  call void @forge_println_string({ ptr, i64 } %ts16)
  %nums17 = load { ptr, i64 }, ptr %nums, align 8
  %list_data18 = extractvalue { ptr, i64 } %nums17, 0
  %elem_ptr19 = getelementptr i64, ptr %list_data18, i64 4
  %elem20 = load i64, ptr %elem_ptr19, align 4
  %__pt5 = alloca i64, align 8
  store i64 %elem20, ptr %__pt5, align 4
  %__pt521 = load i64, ptr %__pt5, align 4
  %ts22 = call { ptr, i64 } @forge_int_to_string(i64 %__pt521)
  call void @forge_println_string({ ptr, i64 } %ts22)
  %sum = alloca i64, align 8
  store i64 0, ptr %sum, align 4
  %i = alloca i64, align 8
  store i64 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %nums23 = load { ptr, i64 }, ptr %nums, align 8
  %len24 = call i64 @forge_string_length({ ptr, i64 } %nums23)
  %__pt6 = alloca i64, align 8
  store i64 %len24, ptr %__pt6, align 4
  %i25 = load i64, ptr %i, align 4
  %__pt626 = load i64, ptr %__pt6, align 4
  %lt = icmp slt i64 %i25, %__pt626
  %cmpext = zext i1 %lt to i64
  %__bt7 = alloca i64, align 8
  store i64 %cmpext, ptr %__bt7, align 4
  %__bt727 = load i64, ptr %__bt7, align 4
  %whilecond = trunc i64 %__bt727 to i1
  br i1 %whilecond, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %nums28 = load { ptr, i64 }, ptr %nums, align 8
  %i29 = load i64, ptr %i, align 4
  %list_data30 = extractvalue { ptr, i64 } %nums28, 0
  %elem_ptr31 = getelementptr i64, ptr %list_data30, i64 %i29
  %elem32 = load i64, ptr %elem_ptr31, align 4
  %__pt8 = alloca i64, align 8
  store i64 %elem32, ptr %__pt8, align 4
  %sum33 = load i64, ptr %sum, align 4
  %__pt834 = load i64, ptr %__pt8, align 4
  %add = add i64 %sum33, %__pt834
  %__bt9 = alloca i64, align 8
  store i64 %add, ptr %__bt9, align 4
  %__bt935 = load i64, ptr %__bt9, align 4
  store i64 %__bt935, ptr %sum, align 4
  %i36 = load i64, ptr %i, align 4
  %add37 = add i64 %i36, 1
  %__bt10 = alloca i64, align 8
  store i64 %add37, ptr %__bt10, align 4
  %__bt1038 = load i64, ptr %__bt10, align 4
  store i64 %__bt1038, ptr %i, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %sum39 = load i64, ptr %sum, align 4
  %ts40 = call { ptr, i64 } @forge_int_to_string(i64 %sum39)
  call void @forge_println_string({ ptr, i64 } %ts40)
  %str = call { ptr, i64 } @forge_string_new(ptr @str, i64 5)
  call void @forge_println_string({ ptr, i64 } %str)
  ret i32 0
}
