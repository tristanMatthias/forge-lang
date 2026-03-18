; ModuleID = 'test_hello.fg'
source_filename = "test_hello.fg"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-darwin25.2.0"

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
  %list_data = call ptr @forge_alloc(i64 24)
  %ep10 = bitcast ptr %list_data to ptr
  store i64 10, ptr %ep10, align 4
  %ep1 = getelementptr i64, ptr %list_data, i64 1
  store i64 20, ptr %ep1, align 4
  %ep2 = getelementptr i64, ptr %list_data, i64 2
  store i64 30, ptr %ep2, align 4
  %ls1 = insertvalue { ptr, i64 } undef, ptr %list_data, 0
  %ls2 = insertvalue { ptr, i64 } %ls1, i64 3, 1
  %__list1 = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %ls2, ptr %__list1, align 8
  %nums = alloca { ptr, i64 }, align 8
  store { ptr, i64 } %ls2, ptr %nums, align 8
  %sum = alloca i64, align 8
  store i64 0, ptr %sum, align 4
  %nums3 = load { ptr, i64 }, ptr %nums, align 8
  %__for_i = alloca i64, align 8
  store i64 0, ptr %__for_i, align 4
  %list_len = call i64 @forge_string_length({ ptr, i64 } %nums3)
  br label %for.cond

for.cond:                                         ; preds = %for.body, %entry
  %for_i = load i64, ptr %__for_i, align 4
  %forcond = icmp slt i64 %for_i, %list_len
  br i1 %forcond, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %for_i_body = load i64, ptr %__for_i, align 4
  %list_data4 = extractvalue { ptr, i64 } %nums3, 0
  %elem_ptr = getelementptr i64, ptr %list_data4, i64 %for_i_body
  %n = load i64, ptr %elem_ptr, align 4
  %n5 = alloca i64, align 8
  store i64 %n, ptr %n5, align 4
  %sum6 = load i64, ptr %sum, align 4
  %n7 = load i64, ptr %n5, align 4
  %add = add i64 %sum6, %n7
  %__bt2 = alloca i64, align 8
  store i64 %add, ptr %__bt2, align 4
  %__bt28 = load i64, ptr %__bt2, align 4
  store i64 %__bt28, ptr %sum, align 4
  %for_i_cur = load i64, ptr %__for_i, align 4
  %for_i_next = add i64 %for_i_cur, 1
  store i64 %for_i_next, ptr %__for_i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %sum9 = load i64, ptr %sum, align 4
  %ts = call { ptr, i64 } @forge_int_to_string(i64 %sum9)
  call void @forge_println_string({ ptr, i64 } %ts)
  ret i32 0
}
