; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@spec_str = private unnamed_addr constant [15 x i8] c"\22stress lists\22\00", align 1
@spec_str.1 = private unnamed_addr constant [18 x i8] c"\22big list length\22\00", align 1
@spec_str.2 = private unnamed_addr constant [17 x i8] c"\22big list first\22\00", align 1
@spec_str.3 = private unnamed_addr constant [16 x i8] c"\22big list last\22\00", align 1
@spec_str.4 = private unnamed_addr constant [28 x i8] c"\22chained map filter reduce\22\00", align 1
@spec_str.5 = private unnamed_addr constant [22 x i8] c"\22nested list flatten\22\00", align 1
@spec_str.6 = private unnamed_addr constant [27 x i8] c"\22nested list middle value\22\00", align 1
@spec_str.7 = private unnamed_addr constant [17 x i8] c"\22slice of slice\22\00", align 1
@spec_str.8 = private unnamed_addr constant [20 x i8] c"\22empty list length\22\00", align 1
@spec_str.9 = private unnamed_addr constant [19 x i8] c"\22empty map length\22\00", align 1
@spec_str.10 = private unnamed_addr constant [22 x i8] c"\22empty filter length\22\00", align 1
@spec_str.11 = private unnamed_addr constant [23 x i8] c"\22empty reduce default\22\00", align 1

declare i32 @puts(ptr)

declare void @forge_eprintln(ptr)

declare i64 @strlen(ptr)

declare ptr @malloc(i64)

declare ptr @forge_rc_alloc(i64)

declare void @forge_rc_retain(ptr)

declare void @forge_rc_release(ptr)

declare i64 @forge_rc_should_free(ptr)

declare void @forge_rc_free(ptr)

declare void @forge_rc_suspect(ptr)

declare void @forge_rc_collect()

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @strcmp(ptr, ptr)

declare i32 @snprintf(ptr, i64, ptr, ...)

declare i32 @atoi(ptr)

declare void @exit(i32)

declare void @forge_null_arg_check(ptr, i64, ptr, i64, i64)

declare void @forge_null_deref_trap(ptr, i64, ptr, i64, i64, ptr, i64, i64)

declare void @forge_div_by_zero_trap(i64, ptr, i64, i64)

declare ptr @forge_array_new()

declare void @forge_array_push(ptr, i64)

declare i64 @forge_array_get(ptr, i64)

declare i64 @forge_array_len(ptr)

declare void @forge_array_set(ptr, i64, i64)

declare i64 @forge_array_pop(ptr)

declare ptr @forge_array_slice(ptr, i64, i64)

declare i64 @forge_closure_get_fn(i64)

declare i64 @forge_closure_num_captures(i64)

declare i64 @forge_closure_get_capture(ptr, i64)

declare i64 @forge_closure_call_0(i64)

declare i64 @forge_closure_call_1(i64, i64)

declare i64 @forge_closure_call_2(i64, i64, i64)

declare i64 @forge_closure_call_3(i64, i64, i64, i64)

declare i64 @forge_closure_call_4(i64, i64, i64, i64, i64)

declare i64 @forge_closure_call_5(i64, i64, i64, i64, i64, i64)

declare ptr @forge_array_map(ptr, i64)

declare ptr @forge_array_filter(ptr, i64)

declare void @forge_array_foreach(ptr, i64)

declare i64 @forge_array_reduce(ptr, i64, i64)

declare i64 @forge_array_contains(ptr, i64)

declare i64 @forge_array_index_of(ptr, i64)

declare ptr @forge_array_reverse(ptr)

declare i64 @forge_str_contains(ptr, ptr)

declare i64 @forge_str_starts_with(ptr, ptr)

declare i64 @forge_str_ends_with(ptr, ptr)

declare i64 @forge_str_index_of(ptr, ptr)

declare ptr @forge_str_split(ptr, ptr)

declare ptr @forge_str_replace(ptr, ptr, ptr)

declare ptr @forge_str_trim(ptr)

declare ptr @forge_str_to_upper(ptr)

declare ptr @forge_str_to_lower(ptr)

declare ptr @forge_str_join(ptr, ptr)

declare ptr @forge_str_char_at(ptr, i64)

declare ptr @forge_str_substring(ptr, i64, i64)

declare ptr @forge_str_repeat(ptr, i64)

declare ptr @forge_str_reverse(ptr)

declare ptr @forge_map_new_cstr()

declare void @forge_map_set_cstr(ptr, ptr, i64)

declare i64 @forge_map_get_cstr(ptr, ptr)

declare i64 @forge_map_has_cstr(ptr, ptr)

declare i64 @forge_map_len_cstr(ptr)

declare ptr @forge_map_keys_cstr(ptr)

declare ptr @forge_map_values_cstr(ptr)

declare i64 @forge_map_remove_cstr(ptr, ptr)

declare ptr @forge_file_read(ptr)

declare i64 @forge_file_write(ptr, ptr)

declare i64 @forge_file_exists(ptr)

declare ptr @forge_intmap_new()

declare void @forge_intmap_set(ptr, i64, i64)

declare i64 @forge_intmap_get(ptr, i64)

declare i64 @forge_intmap_has(ptr, i64)

declare i64 @forge_float_parse(ptr)

declare i64 @forge_float_to_string(i64)

declare ptr @forge_format_float(i64, ptr)

declare ptr @forge_format_int(i64, ptr)

declare void @forge_ptr_store_byte(ptr, i64, i64)

declare i64 @forge_string_from_ptr(ptr, i64)

declare i64 @forge_trait_object_new(ptr, i64)

declare i64 @forge_trait_object_value(ptr)

declare ptr @forge_trait_object_vtable(ptr)

declare i64 @forge_datetime_now()

declare i64 @forge_datetime_format(ptr, i64)

declare i64 @forge_datetime_year(ptr)

declare i64 @forge_datetime_month(ptr)

declare i64 @forge_datetime_day(ptr)

declare i64 @forge_datetime_hour(ptr)

declare i64 @forge_datetime_minute(ptr)

declare i64 @forge_datetime_second(ptr)

declare ptr @forge_json_stringify_int(ptr)

declare ptr @forge_json_stringify_string(ptr)

declare ptr @forge_json_stringify_bool(ptr)

declare i64 @forge_json_get_int(ptr, i64)

declare i64 @forge_json_get_string(ptr, i64)

declare i64 @forge_json_get_bool(ptr, i64)

declare i64 @forge_semver_major(ptr)

declare i64 @forge_semver_minor(ptr)

declare i64 @forge_semver_patch(ptr)

declare i64 @forge_semver_compare(ptr, i64)

declare i64 @forge_validate_not_null(ptr, i64)

declare i64 @forge_validate_positive(ptr, i64)

declare i64 @forge_validate_not_empty(ptr, i64)

declare i64 @forge_toml_get_string(ptr, i64)

declare i64 @forge_toml_get_int(ptr, i64)

declare i64 @forge_toml_get_bool(ptr, i64)

declare i64 @forge_toml_get_section_string(ptr, i64, i64)

declare i64 @forge_toml_has_section(ptr, i64)

declare i64 @forge_spawn(ptr)

declare i64 @forge_task_await(ptr)

declare i32 @forge_thread_join(ptr)

declare void @forge_yield()

declare void @forge_scheduler_run()

declare ptr @forge_task_group_new()

declare void @forge_task_group_add(ptr, ptr)

declare void @forge_task_group_await_all(ptr)

declare ptr @forge_channel_new()

declare void @forge_channel_send(ptr, i64)

declare i64 @forge_channel_recv(ptr)

declare i32 @forge_channel_close(ptr)

declare i32 @forge_parallel_run(ptr)

declare i64 @forge_select(ptr, i64)

declare i64 @forge_select_index(ptr)

declare i64 @forge_select_value(ptr)

declare i32 @forge_test_start_spec(ptr)

declare i32 @forge_test_end_spec(ptr)

declare i32 @forge_test_start_given(ptr)

declare i32 @forge_test_end_given(ptr)

declare i64 @forge_test_run_then(ptr, i64)

declare i32 @forge_test_skip(ptr)

declare i32 @forge_test_todo(ptr)

declare i32 @forge_test_summary()

declare void @forge_test_flush()

declare ptr @forge_arena_new()

declare ptr @forge_arena_alloc(ptr, i64)

declare void @forge_arena_destroy(ptr)

declare void @forge_match_unreachable(ptr, i64, ptr, i64)

declare i32 @forge_llvm_is_ptr_value(ptr)

declare ptr @forge_llvm_typeof(ptr)

declare ptr @forge_llvm_cast_to_type(ptr, ptr, ptr)

declare i32 @forge_llvm_is_void_value(ptr)

declare void @forge_llvm_build_store_cast(ptr, ptr, ptr)

declare i32 @forge_llvm_verify_function(ptr)

declare i64 @forge_llvm_type_kind(ptr)

declare i64 @forge_llvm_int_type_width(ptr)

declare ptr @forge_llvm_build_call_coerce(ptr, ptr, ptr, ptr, i64, ptr)

declare i64 @forge_test_roughly(double, double, double)

define i64 @stl_build_big() {
entry:
  %for_end = alloca i64, align 8
  %i = alloca i64, align 8
  %big = alloca ptr, align 8
  %0 = call ptr @forge_array_new()
  store ptr %0, ptr %big, align 8
  store i64 0, ptr %i, align 8
  store i64 100, ptr %for_end, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.incr, %entry
  %i1 = load i64, ptr %i, align 8
  %for_end_val = load i64, ptr %for_end, align 8
  %for_cmp = icmp slt i64 %i1, %for_end_val
  br i1 %for_cmp, label %for.body, label %for.exit

for.body:                                         ; preds = %for.cond
  %big2 = load ptr, ptr %big, align 8
  %i3 = load i64, ptr %i, align 8
  call void @forge_array_push(ptr %big2, i64 %i3)
  br label %for.incr

for.incr:                                         ; preds = %for.body
  %i4 = load i64, ptr %i, align 8
  %for_next = add i64 %i4, 1
  store i64 %for_next, ptr %i, align 8
  br label %for.cond

for.exit:                                         ; preds = %for.cond
  %big5 = load ptr, ptr %big, align 8
  %1 = call i64 @forge_array_len(ptr %big5)
  ret i64 %1
}

define i64 @stl_big_first() {
entry:
  %for_end = alloca i64, align 8
  %i = alloca i64, align 8
  %big = alloca ptr, align 8
  %0 = call ptr @forge_array_new()
  store ptr %0, ptr %big, align 8
  store i64 0, ptr %i, align 8
  store i64 100, ptr %for_end, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.incr, %entry
  %i1 = load i64, ptr %i, align 8
  %for_end_val = load i64, ptr %for_end, align 8
  %for_cmp = icmp slt i64 %i1, %for_end_val
  br i1 %for_cmp, label %for.body, label %for.exit

for.body:                                         ; preds = %for.cond
  %big2 = load ptr, ptr %big, align 8
  %i3 = load i64, ptr %i, align 8
  call void @forge_array_push(ptr %big2, i64 %i3)
  br label %for.incr

for.incr:                                         ; preds = %for.body
  %i4 = load i64, ptr %i, align 8
  %for_next = add i64 %i4, 1
  store i64 %for_next, ptr %i, align 8
  br label %for.cond

for.exit:                                         ; preds = %for.cond
  %big5 = load ptr, ptr %big, align 8
  %1 = call i64 @forge_array_get(ptr %big5, i64 0)
  ret i64 %1
}

define i64 @stl_big_last() {
entry:
  %for_end = alloca i64, align 8
  %i = alloca i64, align 8
  %big = alloca ptr, align 8
  %0 = call ptr @forge_array_new()
  store ptr %0, ptr %big, align 8
  store i64 0, ptr %i, align 8
  store i64 100, ptr %for_end, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.incr, %entry
  %i1 = load i64, ptr %i, align 8
  %for_end_val = load i64, ptr %for_end, align 8
  %for_cmp = icmp slt i64 %i1, %for_end_val
  br i1 %for_cmp, label %for.body, label %for.exit

for.body:                                         ; preds = %for.cond
  %big2 = load ptr, ptr %big, align 8
  %i3 = load i64, ptr %i, align 8
  call void @forge_array_push(ptr %big2, i64 %i3)
  br label %for.incr

for.incr:                                         ; preds = %for.body
  %i4 = load i64, ptr %i, align 8
  %for_next = add i64 %i4, 1
  store i64 %for_next, ptr %i, align 8
  br label %for.cond

for.exit:                                         ; preds = %for.cond
  %big5 = load ptr, ptr %big, align 8
  %1 = call i64 @forge_array_get(ptr %big5, i64 99)
  ret i64 %1
}

define i64 @stl_flatten_matrix() {
entry:
  %val = alloca i64, align 8
  %forin_i6 = alloca i64, align 8
  %forin_len5 = alloca i64, align 8
  %row = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %flat1 = alloca ptr, align 8
  %matrix1 = alloca ptr, align 8
  %0 = call ptr @forge_array_new()
  %1 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %1, i64 1)
  call void @forge_array_push(ptr %1, i64 2)
  call void @forge_array_push(ptr %1, i64 3)
  %cast = ptrtoint ptr %1 to i64
  call void @forge_array_push(ptr %0, i64 %cast)
  %2 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %2, i64 4)
  call void @forge_array_push(ptr %2, i64 5)
  call void @forge_array_push(ptr %2, i64 6)
  %cast1 = ptrtoint ptr %2 to i64
  call void @forge_array_push(ptr %0, i64 %cast1)
  %3 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %3, i64 7)
  call void @forge_array_push(ptr %3, i64 8)
  call void @forge_array_push(ptr %3, i64 9)
  %cast2 = ptrtoint ptr %3 to i64
  call void @forge_array_push(ptr %0, i64 %cast2)
  store ptr %0, ptr %matrix1, align 8
  %4 = call ptr @forge_array_new()
  store ptr %4, ptr %flat1, align 8
  %matrix13 = load ptr, ptr %matrix1, align 8
  %5 = call i64 @forge_array_len(ptr %matrix13)
  store i64 %5, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %entry
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %6 = call i64 @forge_array_get(ptr %matrix13, i64 %forin_i_val)
  store i64 %6, ptr %row, align 8
  %row4 = load ptr, ptr %row, align 8
  %7 = call i64 @forge_array_len(ptr %row4)
  store i64 %7, ptr %forin_len5, align 8
  store i64 0, ptr %forin_i6, align 8
  br label %forin.cond7

forin.incr:                                       ; preds = %forin.exit10
  %forin_i_old16 = load i64, ptr %forin_i, align 8
  %forin_next17 = add i64 %forin_i_old16, 1
  store i64 %forin_next17, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  %flat118 = load ptr, ptr %flat1, align 8
  %8 = call i64 @forge_array_len(ptr %flat118)
  ret i64 %8

forin.cond7:                                      ; preds = %forin.incr9, %forin.body
  %forin_i_val11 = load i64, ptr %forin_i6, align 8
  %forin_len_val12 = load i64, ptr %forin_len5, align 8
  %forin_cmp13 = icmp slt i64 %forin_i_val11, %forin_len_val12
  br i1 %forin_cmp13, label %forin.body8, label %forin.exit10

forin.body8:                                      ; preds = %forin.cond7
  %9 = call i64 @forge_array_get(ptr %row4, i64 %forin_i_val11)
  store i64 %9, ptr %val, align 8
  %flat114 = load ptr, ptr %flat1, align 8
  %val15 = load i64, ptr %val, align 8
  call void @forge_array_push(ptr %flat114, i64 %val15)
  br label %forin.incr9

forin.incr9:                                      ; preds = %forin.body8
  %forin_i_old = load i64, ptr %forin_i6, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i6, align 8
  br label %forin.cond7

forin.exit10:                                     ; preds = %forin.cond7
  br label %forin.incr
}

define i64 @stl_flatten_mid_val() {
entry:
  %val = alloca i64, align 8
  %forin_i6 = alloca i64, align 8
  %forin_len5 = alloca i64, align 8
  %row = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %flat2 = alloca ptr, align 8
  %matrix2 = alloca ptr, align 8
  %0 = call ptr @forge_array_new()
  %1 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %1, i64 1)
  call void @forge_array_push(ptr %1, i64 2)
  call void @forge_array_push(ptr %1, i64 3)
  %cast = ptrtoint ptr %1 to i64
  call void @forge_array_push(ptr %0, i64 %cast)
  %2 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %2, i64 4)
  call void @forge_array_push(ptr %2, i64 5)
  call void @forge_array_push(ptr %2, i64 6)
  %cast1 = ptrtoint ptr %2 to i64
  call void @forge_array_push(ptr %0, i64 %cast1)
  %3 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %3, i64 7)
  call void @forge_array_push(ptr %3, i64 8)
  call void @forge_array_push(ptr %3, i64 9)
  %cast2 = ptrtoint ptr %3 to i64
  call void @forge_array_push(ptr %0, i64 %cast2)
  store ptr %0, ptr %matrix2, align 8
  %4 = call ptr @forge_array_new()
  store ptr %4, ptr %flat2, align 8
  %matrix23 = load ptr, ptr %matrix2, align 8
  %5 = call i64 @forge_array_len(ptr %matrix23)
  store i64 %5, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %entry
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %6 = call i64 @forge_array_get(ptr %matrix23, i64 %forin_i_val)
  store i64 %6, ptr %row, align 8
  %row4 = load ptr, ptr %row, align 8
  %7 = call i64 @forge_array_len(ptr %row4)
  store i64 %7, ptr %forin_len5, align 8
  store i64 0, ptr %forin_i6, align 8
  br label %forin.cond7

forin.incr:                                       ; preds = %forin.exit10
  %forin_i_old16 = load i64, ptr %forin_i, align 8
  %forin_next17 = add i64 %forin_i_old16, 1
  store i64 %forin_next17, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  %flat218 = load ptr, ptr %flat2, align 8
  %8 = call i64 @forge_array_get(ptr %flat218, i64 4)
  ret i64 %8

forin.cond7:                                      ; preds = %forin.incr9, %forin.body
  %forin_i_val11 = load i64, ptr %forin_i6, align 8
  %forin_len_val12 = load i64, ptr %forin_len5, align 8
  %forin_cmp13 = icmp slt i64 %forin_i_val11, %forin_len_val12
  br i1 %forin_cmp13, label %forin.body8, label %forin.exit10

forin.body8:                                      ; preds = %forin.cond7
  %9 = call i64 @forge_array_get(ptr %row4, i64 %forin_i_val11)
  store i64 %9, ptr %val, align 8
  %flat214 = load ptr, ptr %flat2, align 8
  %val15 = load i64, ptr %val, align 8
  call void @forge_array_push(ptr %flat214, i64 %val15)
  br label %forin.incr9

forin.incr9:                                      ; preds = %forin.body8
  %forin_i_old = load i64, ptr %forin_i6, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i6, align 8
  br label %forin.cond7

forin.exit10:                                     ; preds = %forin.cond7
  br label %forin.incr
}

define i64 @main() {
entry:
  %reduced_empty = alloca i64, align 8
  %empty4 = alloca ptr, align 8
  %filtered_empty = alloca ptr, align 8
  %empty3 = alloca ptr, align 8
  %mapped_empty = alloca ptr, align 8
  %empty2 = alloca ptr, align 8
  %empty1 = alloca ptr, align 8
  %inner = alloca ptr, align 8
  %mid = alloca ptr, align 8
  %nums = alloca ptr, align 8
  %result = alloca i64, align 8
  %0 = call i32 @forge_test_start_spec(ptr @spec_str)
  %widen = sext i32 %0 to i64
  %1 = call i64 @stl_build_big()
  %eq = icmp eq i64 %1, 100
  %eq_ext = zext i1 %eq to i64
  %2 = call i64 @forge_test_run_then(ptr @spec_str.1, i64 %eq_ext)
  %3 = call i64 @stl_big_first()
  %eq1 = icmp eq i64 %3, 0
  %eq_ext2 = zext i1 %eq1 to i64
  %4 = call i64 @forge_test_run_then(ptr @spec_str.2, i64 %eq_ext2)
  %5 = call i64 @stl_big_last()
  %eq3 = icmp eq i64 %5, 99
  %eq_ext4 = zext i1 %eq3 to i64
  %6 = call i64 @forge_test_run_then(ptr @spec_str.3, i64 %eq_ext4)
  %7 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %7, i64 1)
  call void @forge_array_push(ptr %7, i64 2)
  call void @forge_array_push(ptr %7, i64 3)
  call void @forge_array_push(ptr %7, i64 4)
  call void @forge_array_push(ptr %7, i64 5)
  call void @forge_array_push(ptr %7, i64 6)
  call void @forge_array_push(ptr %7, i64 7)
  call void @forge_array_push(ptr %7, i64 8)
  call void @forge_array_push(ptr %7, i64 9)
  call void @forge_array_push(ptr %7, i64 10)
  %8 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %8, i64 -559038737)
  call void @forge_array_push(ptr %8, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast = ptrtoint ptr %8 to i64
  %9 = call ptr @forge_array_map(ptr %7, i64 %cast)
  %10 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %10, i64 -559038737)
  call void @forge_array_push(ptr %10, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cast5 = ptrtoint ptr %10 to i64
  %11 = call ptr @forge_array_filter(ptr %9, i64 %cast5)
  %12 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %12, i64 -559038737)
  call void @forge_array_push(ptr %12, i64 ptrtoint (ptr @__lambda_2 to i64))
  %cast6 = ptrtoint ptr %12 to i64
  %13 = call i64 @forge_array_reduce(ptr %11, i64 0, i64 %cast6)
  store i64 %13, ptr %result, align 8
  %result7 = load i64, ptr %result, align 8
  %eq8 = icmp eq i64 %result7, 355
  %eq_ext9 = zext i1 %eq8 to i64
  %14 = call i64 @forge_test_run_then(ptr @spec_str.4, i64 %eq_ext9)
  %15 = call i64 @stl_flatten_matrix()
  %eq10 = icmp eq i64 %15, 9
  %eq_ext11 = zext i1 %eq10 to i64
  %16 = call i64 @forge_test_run_then(ptr @spec_str.5, i64 %eq_ext11)
  %17 = call i64 @stl_flatten_mid_val()
  %eq12 = icmp eq i64 %17, 5
  %eq_ext13 = zext i1 %eq12 to i64
  %18 = call i64 @forge_test_run_then(ptr @spec_str.6, i64 %eq_ext13)
  %19 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %19, i64 10)
  call void @forge_array_push(ptr %19, i64 20)
  call void @forge_array_push(ptr %19, i64 30)
  call void @forge_array_push(ptr %19, i64 40)
  call void @forge_array_push(ptr %19, i64 50)
  call void @forge_array_push(ptr %19, i64 60)
  call void @forge_array_push(ptr %19, i64 70)
  store ptr %19, ptr %nums, align 8
  %nums14 = load ptr, ptr %nums, align 8
  %20 = call ptr @forge_array_slice(ptr %nums14, i64 2, i64 5)
  store ptr %20, ptr %mid, align 8
  %mid15 = load ptr, ptr %mid, align 8
  %21 = call ptr @forge_array_slice(ptr %mid15, i64 1, i64 2)
  store ptr %21, ptr %inner, align 8
  %inner16 = load ptr, ptr %inner, align 8
  %22 = call i64 @forge_array_get(ptr %inner16, i64 0)
  %eq17 = icmp eq i64 %22, 40
  %eq_ext18 = zext i1 %eq17 to i64
  %23 = call i64 @forge_test_run_then(ptr @spec_str.7, i64 %eq_ext18)
  %24 = call ptr @forge_array_new()
  store ptr %24, ptr %empty1, align 8
  %empty119 = load ptr, ptr %empty1, align 8
  %25 = call i64 @forge_array_len(ptr %empty119)
  %eq20 = icmp eq i64 %25, 0
  %eq_ext21 = zext i1 %eq20 to i64
  %26 = call i64 @forge_test_run_then(ptr @spec_str.8, i64 %eq_ext21)
  %27 = call ptr @forge_array_new()
  store ptr %27, ptr %empty2, align 8
  %empty222 = load ptr, ptr %empty2, align 8
  %28 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %28, i64 -559038737)
  call void @forge_array_push(ptr %28, i64 ptrtoint (ptr @__lambda_3 to i64))
  %cast23 = ptrtoint ptr %28 to i64
  %29 = call ptr @forge_array_map(ptr %empty222, i64 %cast23)
  store ptr %29, ptr %mapped_empty, align 8
  %mapped_empty24 = load ptr, ptr %mapped_empty, align 8
  %30 = call i64 @forge_array_len(ptr %mapped_empty24)
  %eq25 = icmp eq i64 %30, 0
  %eq_ext26 = zext i1 %eq25 to i64
  %31 = call i64 @forge_test_run_then(ptr @spec_str.9, i64 %eq_ext26)
  %32 = call ptr @forge_array_new()
  store ptr %32, ptr %empty3, align 8
  %empty327 = load ptr, ptr %empty3, align 8
  %33 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %33, i64 -559038737)
  call void @forge_array_push(ptr %33, i64 ptrtoint (ptr @__lambda_4 to i64))
  %cast28 = ptrtoint ptr %33 to i64
  %34 = call ptr @forge_array_filter(ptr %empty327, i64 %cast28)
  store ptr %34, ptr %filtered_empty, align 8
  %filtered_empty29 = load ptr, ptr %filtered_empty, align 8
  %35 = call i64 @forge_array_len(ptr %filtered_empty29)
  %eq30 = icmp eq i64 %35, 0
  %eq_ext31 = zext i1 %eq30 to i64
  %36 = call i64 @forge_test_run_then(ptr @spec_str.10, i64 %eq_ext31)
  %37 = call ptr @forge_array_new()
  store ptr %37, ptr %empty4, align 8
  %empty432 = load ptr, ptr %empty4, align 8
  %38 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %38, i64 -559038737)
  call void @forge_array_push(ptr %38, i64 ptrtoint (ptr @__lambda_5 to i64))
  %cast33 = ptrtoint ptr %38 to i64
  %39 = call i64 @forge_array_reduce(ptr %empty432, i64 42, i64 %cast33)
  store i64 %39, ptr %reduced_empty, align 8
  %reduced_empty34 = load i64, ptr %reduced_empty, align 8
  %eq35 = icmp eq i64 %reduced_empty34, 42
  %eq_ext36 = zext i1 %eq35 to i64
  %40 = call i64 @forge_test_run_then(ptr @spec_str.11, i64 %eq_ext36)
  %41 = call i32 @forge_test_end_spec(ptr @spec_str)
  %widen37 = sext i32 %41 to i64
  %42 = call i32 @forge_test_summary()
  %widen38 = sext i32 %42 to i64
  call void @forge_rc_collect()
  ret i64 0
}

define i64 @__lambda_0(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %x2 = load i64, ptr %x, align 8
  %mul = mul i64 %x1, %x2
  ret i64 %mul
}

define i64 @__lambda_1(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %sgt = icmp sgt i64 %x1, 20
  %sgt_ext = zext i1 %sgt to i64
  ret i64 %sgt_ext
}

define i64 @__lambda_2(i64 %0, i64 %1) {
entry:
  %x = alloca i64, align 8
  %acc = alloca i64, align 8
  store i64 %0, ptr %acc, align 8
  store i64 %1, ptr %x, align 8
  %acc1 = load i64, ptr %acc, align 8
  %x2 = load i64, ptr %x, align 8
  %add = add i64 %acc1, %x2
  ret i64 %add
}

define i64 @__lambda_3(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %mul = mul i64 %x1, 2
  ret i64 %mul
}

define i64 @__lambda_4(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %sgt = icmp sgt i64 %x1, 0
  %sgt_ext = zext i1 %sgt to i64
  ret i64 %sgt_ext
}

define i64 @__lambda_5(i64 %0, i64 %1) {
entry:
  %x = alloca i64, align 8
  %acc = alloca i64, align 8
  store i64 %0, ptr %acc, align 8
  store i64 %1, ptr %x, align 8
  %acc1 = load i64, ptr %acc, align 8
  %x2 = load i64, ptr %x, align 8
  %add = add i64 %acc1, %x2
  ret i64 %add
}
