; ModuleID = 'forgec_output'
source_filename = "forgec_output"

%ForgeString = type { ptr, i64 }

declare void @forge_println_string(%ForgeString)

declare %ForgeString @forge_int_to_string(i64)

declare %ForgeString @forge_string_new(ptr, i64)

declare %ForgeString @forge_string_concat(%ForgeString, %ForgeString)

declare %ForgeString @forge_string_char_at(%ForgeString, i64)

declare i64 @forge_string_length(%ForgeString)

declare i8 @forge_string_eq(%ForgeString, %ForgeString)

declare i64 @forge_string_compare(%ForgeString, %ForgeString)

declare %ForgeString @forge_string_substring(%ForgeString, i64, i64)

declare i64 @forge_string_index_of(%ForgeString, %ForgeString)

declare ptr @forge_alloc(i64)

declare void @forge_memcpy(ptr, ptr, i64)

declare ptr @forge_map_new()

declare i8 @forge_map_has(ptr, %ForgeString)

declare i64 @forge_map_get(ptr, %ForgeString)

declare void @forge_map_set(ptr, %ForgeString, i64)

define i64 @count(%ForgeString %0) {
entry:
  %items = alloca %ForgeString, align 8
  store %ForgeString %0, ptr %items, align 8
  %n = alloca i64, align 8
  store i64 0, ptr %n, align 4
  %items1 = load %ForgeString, ptr %items, align 8
  %__for_i = alloca i64, align 8
  store i64 0, ptr %__for_i, align 4
  %list_len = call i64 @forge_string_length(%ForgeString %items1)
  br label %for.cond

for.cond:                                         ; preds = %for.incr, %entry
  %for_i = load i64, ptr %__for_i, align 4
  %forcond = icmp slt i64 %for_i, %list_len
  br i1 %forcond, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %fib = load i64, ptr %__for_i, align 4
  %dat = extractvalue %ForgeString %items1, 0
  %elp = getelementptr i64, ptr %dat, i64 %fib
  %elv = load i64, ptr %elp, align 4
  %itv = alloca i64, align 8
  store i64 %elv, ptr %itv, align 4
  %n2 = load i64, ptr %n, align 4
  %add = add i64 %n2, 1
  %__bt1 = alloca i64, align 8
  store i64 %add, ptr %__bt1, align 4
  %__bt13 = load i64, ptr %__bt1, align 4
  store i64 %__bt13, ptr %n, align 4
  %__bt14 = load i64, ptr %__bt1, align 4
  store i64 %__bt14, ptr %n, align 4
  br label %for.incr

for.incr:                                         ; preds = %for.body
  %for_i_cur = load i64, ptr %__for_i, align 4
  %for_i_next = add i64 %for_i_cur, 1
  store i64 %for_i_next, ptr %__for_i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %n5 = load i64, ptr %n, align 4
  ret i64 %add
}

define i32 @main() {
entry:
  %list_data = call ptr @forge_alloc(i64 24)
  %ep = getelementptr i64, ptr %list_data, i64 0
  store i64 10, ptr %ep, align 4
  %ep1 = getelementptr i64, ptr %list_data, i64 1
  store i64 20, ptr %ep1, align 4
  %ep2 = getelementptr i64, ptr %list_data, i64 2
  store i64 30, ptr %ep2, align 4
  %ls1 = insertvalue %ForgeString undef, ptr %list_data, 0
  %ls2 = insertvalue %ForgeString %ls1, i64 3, 1
  %__list2 = alloca %ForgeString, align 8
  store %ForgeString %ls2, ptr %__list2, align 8
  %nums = alloca %ForgeString, align 8
  store %ForgeString %ls2, ptr %nums, align 8
  %nums3 = load %ForgeString, ptr %nums, align 8
  %call = call i64 @count(%ForgeString %nums3)
  %i2s = call %ForgeString @forge_int_to_string(i64 %call)
  call void @forge_println_string(%ForgeString %i2s)
  ret i32 0
}
