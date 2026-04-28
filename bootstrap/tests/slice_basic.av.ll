; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@nums = global i64 0
@mid = global i64 0
@first2 = global i64 0
@last2 = global i64 0
@empty = global i64 0
@copy = global i64 0
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.9 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.10 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

declare i32 @puts(ptr)

declare void @avra_eprintln(ptr)

declare i64 @strlen(ptr)

declare ptr @malloc(i64)

declare ptr @avra_rc_alloc(i64)

declare void @avra_rc_retain(ptr)

declare void @avra_rc_release(ptr)

declare i64 @avra_rc_should_free(ptr)

declare void @avra_rc_free(ptr)

declare void @avra_rc_suspect(ptr)

declare void @avra_rc_collect()

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @strcmp(ptr, ptr)

declare i32 @snprintf(ptr, i64, ptr, ...)

declare i32 @atoi(ptr)

declare i64 @avra_parse_int(ptr)

declare void @exit(i32)

declare void @avra_null_arg_check(ptr, i64, ptr, i64, i64)

declare void @avra_null_deref_trap(ptr, i64, ptr, i64, i64, ptr, i64, i64)

declare void @avra_div_by_zero_trap(i64, ptr, i64, i64)

declare ptr @avra_array_new()

declare void @avra_array_push(ptr, i64)

declare i64 @avra_array_get(ptr, i64)

declare i64 @avra_array_len(ptr)

declare void @avra_array_set(ptr, i64, i64)

declare i64 @avra_array_pop(ptr)

declare ptr @avra_array_slice(ptr, i64, i64)

declare i64 @avra_closure_get_fn(i64)

declare i64 @avra_closure_num_captures(i64)

declare i64 @avra_closure_get_capture(ptr, i64)

declare i64 @avra_closure_call_0(i64)

declare i64 @avra_closure_call_1(i64, i64)

declare i64 @avra_closure_call_2(i64, i64, i64)

declare i64 @avra_closure_call_3(i64, i64, i64, i64)

declare i64 @avra_closure_call_4(i64, i64, i64, i64, i64)

declare i64 @avra_closure_call_5(i64, i64, i64, i64, i64, i64)

declare ptr @avra_array_map(ptr, i64)

declare ptr @avra_array_filter(ptr, i64)

declare void @avra_array_foreach(ptr, i64)

declare i64 @avra_array_reduce(ptr, i64, i64)

declare i64 @avra_array_contains(ptr, i64)

declare i64 @avra_array_index_of(ptr, i64)

declare ptr @avra_array_reverse(ptr)

declare i64 @avra_str_contains(ptr, ptr)

declare i64 @avra_str_starts_with(ptr, ptr)

declare i64 @avra_str_ends_with(ptr, ptr)

declare i64 @avra_str_index_of(ptr, ptr)

declare ptr @avra_str_split(ptr, ptr)

declare ptr @avra_str_replace(ptr, ptr, ptr)

declare ptr @avra_str_trim(ptr)

declare ptr @avra_str_to_upper(ptr)

declare ptr @avra_str_to_lower(ptr)

declare ptr @avra_str_join(ptr, ptr)

declare ptr @avra_str_char_at(ptr, i64)

declare ptr @avra_str_substring(ptr, i64, i64)

declare ptr @avra_str_repeat(ptr, i64)

declare ptr @avra_str_reverse(ptr)

declare ptr @avra_map_new_cstr()

declare void @avra_map_set_cstr(ptr, ptr, i64)

declare i64 @avra_map_get_cstr(ptr, ptr)

declare i64 @avra_map_has_cstr(ptr, ptr)

declare i64 @avra_map_len_cstr(ptr)

declare ptr @avra_map_keys_cstr(ptr)

declare ptr @avra_map_values_cstr(ptr)

declare i64 @avra_map_remove_cstr(ptr, ptr)

declare ptr @avra_file_read(ptr)

declare i64 @avra_file_write(ptr, ptr)

declare i64 @avra_file_exists(ptr)

declare ptr @avra_intmap_new()

declare void @avra_intmap_set(ptr, i64, i64)

declare i64 @avra_intmap_get(ptr, i64)

declare i64 @avra_intmap_has(ptr, i64)

declare i64 @avra_float_parse(ptr)

declare i64 @avra_float_to_string(i64)

declare ptr @avra_format_float(i64, ptr)

declare ptr @avra_format_int(i64, ptr)

declare void @avra_ptr_store_byte(ptr, i64, i64)

declare i64 @avra_string_from_ptr(ptr, i64)

declare i64 @avra_trait_object_new(ptr, i64)

declare i64 @avra_trait_object_value(ptr)

declare ptr @avra_trait_object_vtable(ptr)

declare i64 @avra_datetime_now()

declare i64 @avra_datetime_format(ptr, i64)

declare i64 @avra_datetime_year(ptr)

declare i64 @avra_datetime_month(ptr)

declare i64 @avra_datetime_day(ptr)

declare i64 @avra_datetime_hour(ptr)

declare i64 @avra_datetime_minute(ptr)

declare i64 @avra_datetime_second(ptr)

declare ptr @avra_json_stringify_int(ptr)

declare ptr @avra_json_stringify_string(ptr)

declare ptr @avra_json_stringify_bool(ptr)

declare i64 @avra_json_get_int(ptr, i64)

declare i64 @avra_json_get_string(ptr, i64)

declare i64 @avra_json_get_bool(ptr, i64)

declare i64 @avra_semver_major(ptr)

declare i64 @avra_semver_minor(ptr)

declare i64 @avra_semver_patch(ptr)

declare i64 @avra_semver_compare(ptr, i64)

declare i64 @avra_validate_not_null(ptr, i64)

declare i64 @avra_validate_positive(ptr, i64)

declare i64 @avra_validate_not_empty(ptr, i64)

declare i64 @avra_toml_get_string(ptr, i64)

declare i64 @avra_toml_get_int(ptr, i64)

declare i64 @avra_toml_get_bool(ptr, i64)

declare i64 @avra_toml_get_section_string(ptr, i64, i64)

declare i64 @avra_toml_has_section(ptr, i64)

declare i64 @avra_spawn(ptr)

declare i64 @avra_task_await(ptr)

declare i32 @avra_thread_join(ptr)

declare void @avra_yield()

declare void @avra_scheduler_run()

declare ptr @avra_task_group_new()

declare void @avra_task_group_add(ptr, ptr)

declare void @avra_task_group_await_all(ptr)

declare ptr @avra_channel_new()

declare void @avra_channel_send(ptr, i64)

declare i64 @avra_channel_recv(ptr)

declare i32 @avra_channel_close(ptr)

declare i32 @avra_parallel_run(ptr)

declare i64 @avra_select(ptr, i64)

declare i64 @avra_select_index(ptr)

declare i64 @avra_select_value(ptr)

declare i32 @avra_test_start_spec(ptr)

declare i32 @avra_test_end_spec(ptr)

declare i32 @avra_test_start_given(ptr)

declare i32 @avra_test_end_given(ptr)

declare i64 @avra_test_run_then(ptr, i64)

declare i32 @avra_test_skip(ptr)

declare i32 @avra_test_todo(ptr)

declare i32 @avra_test_summary()

declare void @avra_test_flush()

declare ptr @avra_arena_new()

declare ptr @avra_arena_alloc(ptr, i64)

declare void @avra_arena_destroy(ptr)

declare void @avra_match_unreachable(ptr, i64, ptr, i64)

declare i32 @avra_llvm_is_ptr_value(ptr)

declare ptr @avra_llvm_typeof(ptr)

declare ptr @avra_llvm_cast_to_type(ptr, ptr, ptr)

declare i32 @avra_llvm_is_void_value(ptr)

declare void @avra_llvm_build_store_cast(ptr, ptr, ptr)

declare i32 @avra_llvm_verify_function(ptr)

declare i64 @avra_llvm_type_kind(ptr)

declare i64 @avra_llvm_int_type_width(ptr)

declare ptr @avra_llvm_build_call_coerce(ptr, ptr, ptr, ptr, i64, ptr)

declare i64 @avra_test_roughly(double, double, double)

define i64 @main() {
entry:
  %x = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %0 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %0, i64 10)
  call void @avra_array_push(ptr %0, i64 20)
  call void @avra_array_push(ptr %0, i64 30)
  call void @avra_array_push(ptr %0, i64 40)
  call void @avra_array_push(ptr %0, i64 50)
  store ptr %0, ptr @nums, align 8
  %nums = load ptr, ptr @nums, align 8
  %1 = call ptr @avra_array_slice(ptr %nums, i64 1, i64 4)
  store ptr %1, ptr @mid, align 8
  %mid = load ptr, ptr @mid, align 8
  %2 = call i64 @avra_array_len(ptr %mid)
  %3 = call ptr @avra_rc_alloc(i64 32)
  %4 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %3, i64 32, ptr @.i2s_fmt, i64 %2)
  %widen = sext i32 %4 to i64
  %5 = call i32 @puts(ptr %3)
  %widen1 = sext i32 %5 to i64
  %mid2 = load ptr, ptr @mid, align 8
  %6 = call i64 @avra_array_get(ptr %mid2, i64 0)
  %7 = call ptr @avra_rc_alloc(i64 32)
  %8 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %7, i64 32, ptr @.i2s_fmt.1, i64 %6)
  %widen3 = sext i32 %8 to i64
  %9 = call i32 @puts(ptr %7)
  %widen4 = sext i32 %9 to i64
  %mid5 = load ptr, ptr @mid, align 8
  %10 = call i64 @avra_array_get(ptr %mid5, i64 1)
  %11 = call ptr @avra_rc_alloc(i64 32)
  %12 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %11, i64 32, ptr @.i2s_fmt.2, i64 %10)
  %widen6 = sext i32 %12 to i64
  %13 = call i32 @puts(ptr %11)
  %widen7 = sext i32 %13 to i64
  %mid8 = load ptr, ptr @mid, align 8
  %14 = call i64 @avra_array_get(ptr %mid8, i64 2)
  %15 = call ptr @avra_rc_alloc(i64 32)
  %16 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %15, i64 32, ptr @.i2s_fmt.3, i64 %14)
  %widen9 = sext i32 %16 to i64
  %17 = call i32 @puts(ptr %15)
  %widen10 = sext i32 %17 to i64
  %nums11 = load ptr, ptr @nums, align 8
  %18 = call ptr @avra_array_slice(ptr %nums11, i64 0, i64 2)
  store ptr %18, ptr @first2, align 8
  %first2 = load ptr, ptr @first2, align 8
  %19 = call i64 @avra_array_len(ptr %first2)
  %20 = call ptr @avra_rc_alloc(i64 32)
  %21 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %20, i64 32, ptr @.i2s_fmt.4, i64 %19)
  %widen12 = sext i32 %21 to i64
  %22 = call i32 @puts(ptr %20)
  %widen13 = sext i32 %22 to i64
  %first214 = load ptr, ptr @first2, align 8
  %23 = call i64 @avra_array_get(ptr %first214, i64 0)
  %24 = call ptr @avra_rc_alloc(i64 32)
  %25 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %24, i64 32, ptr @.i2s_fmt.5, i64 %23)
  %widen15 = sext i32 %25 to i64
  %26 = call i32 @puts(ptr %24)
  %widen16 = sext i32 %26 to i64
  %nums17 = load ptr, ptr @nums, align 8
  %27 = call ptr @avra_array_slice(ptr %nums17, i64 3, i64 5)
  store ptr %27, ptr @last2, align 8
  %last2 = load ptr, ptr @last2, align 8
  %28 = call i64 @avra_array_len(ptr %last2)
  %29 = call ptr @avra_rc_alloc(i64 32)
  %30 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %29, i64 32, ptr @.i2s_fmt.6, i64 %28)
  %widen18 = sext i32 %30 to i64
  %31 = call i32 @puts(ptr %29)
  %widen19 = sext i32 %31 to i64
  %last220 = load ptr, ptr @last2, align 8
  %32 = call i64 @avra_array_get(ptr %last220, i64 0)
  %33 = call ptr @avra_rc_alloc(i64 32)
  %34 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %33, i64 32, ptr @.i2s_fmt.7, i64 %32)
  %widen21 = sext i32 %34 to i64
  %35 = call i32 @puts(ptr %33)
  %widen22 = sext i32 %35 to i64
  %nums23 = load ptr, ptr @nums, align 8
  %36 = call ptr @avra_array_slice(ptr %nums23, i64 2, i64 2)
  store ptr %36, ptr @empty, align 8
  %empty = load ptr, ptr @empty, align 8
  %37 = call i64 @avra_array_len(ptr %empty)
  %38 = call ptr @avra_rc_alloc(i64 32)
  %39 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %38, i64 32, ptr @.i2s_fmt.8, i64 %37)
  %widen24 = sext i32 %39 to i64
  %40 = call i32 @puts(ptr %38)
  %widen25 = sext i32 %40 to i64
  %nums26 = load ptr, ptr @nums, align 8
  %41 = call ptr @avra_array_slice(ptr %nums26, i64 0, i64 5)
  store ptr %41, ptr @copy, align 8
  %copy = load ptr, ptr @copy, align 8
  %42 = call i64 @avra_array_len(ptr %copy)
  %43 = call ptr @avra_rc_alloc(i64 32)
  %44 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %43, i64 32, ptr @.i2s_fmt.9, i64 %42)
  %widen27 = sext i32 %44 to i64
  %45 = call i32 @puts(ptr %43)
  %widen28 = sext i32 %45 to i64
  %nums29 = load ptr, ptr @nums, align 8
  %46 = call ptr @avra_array_slice(ptr %nums29, i64 1, i64 4)
  %47 = call i64 @avra_array_len(ptr %46)
  store i64 %47, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %entry
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %48 = call i64 @avra_array_get(ptr %46, i64 %forin_i_val)
  store i64 %48, ptr %x, align 8
  %x30 = load i64, ptr %x, align 8
  %49 = call ptr @avra_rc_alloc(i64 32)
  %50 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %49, i64 32, ptr @.i2s_fmt.10, i64 %x30)
  %widen31 = sext i32 %50 to i64
  %51 = call i32 @puts(ptr %49)
  %widen32 = sext i32 %51 to i64
  br label %forin.incr

forin.incr:                                       ; preds = %forin.body
  %forin_i_old = load i64, ptr %forin_i, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  %52 = call i32 @avra_test_summary()
  %widen33 = sext i32 %52 to i64
  call void @avra_rc_collect()
  ret i64 0
}
