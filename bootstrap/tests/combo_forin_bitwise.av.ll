; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@flags = global i64 0
@combined = global i64 0
@test_val = global i64 0
@set_flags = global i64 0
@big_nums = global i64 0
@sum = global i64 0
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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
  %f = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %0 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %0, i64 1)
  call void @avra_array_push(ptr %0, i64 2)
  call void @avra_array_push(ptr %0, i64 4)
  call void @avra_array_push(ptr %0, i64 8)
  store ptr %0, ptr @flags, align 8
  store i64 0, ptr @combined, align 8
  %flags = load ptr, ptr @flags, align 8
  %1 = call i64 @avra_array_len(ptr %flags)
  store i64 %1, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %entry
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %2 = call i64 @avra_array_get(ptr %flags, i64 %forin_i_val)
  store i64 %2, ptr %f, align 8
  %combined = load i64, ptr @combined, align 8
  %f1 = load i64, ptr %f, align 8
  %bor = or i64 %combined, %f1
  store i64 %bor, ptr @combined, align 8
  br label %forin.incr

forin.incr:                                       ; preds = %forin.body
  %forin_i_old = load i64, ptr %forin_i, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  %combined2 = load i64, ptr @combined, align 8
  %3 = call ptr @avra_rc_alloc(i64 32)
  %4 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %3, i64 32, ptr @.i2s_fmt, i64 %combined2)
  %widen = sext i32 %4 to i64
  %5 = call i32 @puts(ptr %3)
  %widen3 = sext i32 %5 to i64
  store i64 5, ptr @test_val, align 8
  %flags4 = load ptr, ptr @flags, align 8
  %6 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %6, i64 -559038737)
  call void @avra_array_push(ptr %6, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast = ptrtoint ptr %6 to i64
  %7 = call ptr @avra_array_filter(ptr %flags4, i64 %cast)
  store ptr %7, ptr @set_flags, align 8
  %set_flags = load ptr, ptr @set_flags, align 8
  %8 = call i64 @avra_array_len(ptr %set_flags)
  %9 = call ptr @avra_rc_alloc(i64 32)
  %10 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %9, i64 32, ptr @.i2s_fmt.1, i64 %8)
  %widen5 = sext i32 %10 to i64
  %11 = call i32 @puts(ptr %9)
  %widen6 = sext i32 %11 to i64
  %set_flags7 = load ptr, ptr @set_flags, align 8
  %12 = call i64 @avra_array_get(ptr %set_flags7, i64 0)
  %13 = call ptr @avra_rc_alloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @.i2s_fmt.2, i64 %12)
  %widen8 = sext i32 %14 to i64
  %15 = call i32 @puts(ptr %13)
  %widen9 = sext i32 %15 to i64
  %set_flags10 = load ptr, ptr @set_flags, align 8
  %16 = call i64 @avra_array_get(ptr %set_flags10, i64 1)
  %17 = call ptr @avra_rc_alloc(i64 32)
  %18 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %17, i64 32, ptr @.i2s_fmt.3, i64 %16)
  %widen11 = sext i32 %18 to i64
  %19 = call i32 @puts(ptr %17)
  %widen12 = sext i32 %19 to i64
  %20 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %20, i64 1000)
  call void @avra_array_push(ptr %20, i64 2000)
  call void @avra_array_push(ptr %20, i64 3000)
  store ptr %20, ptr @big_nums, align 8
  %big_nums = load ptr, ptr @big_nums, align 8
  %21 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %21, i64 -559038737)
  call void @avra_array_push(ptr %21, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cast13 = ptrtoint ptr %21 to i64
  %22 = call i64 @avra_array_reduce(ptr %big_nums, i64 0, i64 %cast13)
  store i64 %22, ptr @sum, align 8
  %sum = load i64, ptr @sum, align 8
  %23 = call ptr @avra_rc_alloc(i64 32)
  %24 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %23, i64 32, ptr @.i2s_fmt.4, i64 %sum)
  %widen14 = sext i32 %24 to i64
  %25 = call i32 @puts(ptr %23)
  %widen15 = sext i32 %25 to i64
  %26 = call i32 @avra_test_summary()
  %widen16 = sext i32 %26 to i64
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__lambda_0(i64 %0) {
entry:
  %f = alloca i64, align 8
  store i64 %0, ptr %f, align 8
  %test_val = load i64, ptr @test_val, align 8
  %f1 = load i64, ptr %f, align 8
  %band = and i64 %test_val, %f1
  %ne = icmp ne i64 %band, 0
  %ne_ext = zext i1 %ne to i64
  ret i64 %ne_ext
}

define i64 @__lambda_1(i64 %0, i64 %1) {
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
