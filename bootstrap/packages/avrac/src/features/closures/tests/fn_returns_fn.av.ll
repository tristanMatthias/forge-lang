; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@make = global ptr null
@add5 = global i64 0
@triple = global i64 0
@inc = global i64 0
@dbl = global i64 0
@pipeline = global i64 0
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define ptr @make_multiplier(i64 %0) {
entry:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  %1 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %1, i64 -559038737)
  call void @avra_array_push(ptr %1, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cap_val = load i64, ptr %n, align 8
  call void @avra_array_push(ptr %1, i64 %cap_val)
  %cast = ptrtoint ptr %1 to i64
  %cast1 = inttoptr i64 %cast to ptr
  ret ptr %cast1
}

define ptr @compose(ptr %0, ptr %1) {
entry:
  %g = alloca ptr, align 8
  %f = alloca ptr, align 8
  store ptr %0, ptr %f, align 8
  store ptr %1, ptr %g, align 8
  %2 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %2, i64 -559038737)
  call void @avra_array_push(ptr %2, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cap_val = load i64, ptr %g, align 8
  call void @avra_array_push(ptr %2, i64 %cap_val)
  %cap_val1 = load i64, ptr %f, align 8
  call void @avra_array_push(ptr %2, i64 %cap_val1)
  %cast = ptrtoint ptr %2 to i64
  %cast2 = inttoptr i64 %cast to ptr
  ret ptr %cast2
}

define i64 @main() {
entry:
  %0 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %0, i64 -559038737)
  call void @avra_array_push(ptr %0, i64 ptrtoint (ptr @__lambda_2 to i64))
  %cast = ptrtoint ptr %0 to i64
  store i64 %cast, ptr @make, align 8
  %make = load i64, ptr @make, align 8
  %cast1 = inttoptr i64 %make to ptr
  %1 = call i64 @avra_array_get(ptr %cast1, i64 1)
  %fn_ptr = inttoptr i64 %1 to ptr
  %closure_call = call i64 %fn_ptr(i64 5)
  store i64 %closure_call, ptr @add5, align 8
  %add5 = load i64, ptr @add5, align 8
  %cast2 = inttoptr i64 %add5 to ptr
  %2 = call i64 @avra_array_get(ptr %cast2, i64 1)
  %fn_ptr3 = inttoptr i64 %2 to ptr
  %3 = call i64 @avra_array_get(ptr %cast2, i64 2)
  %closure_call4 = call i64 %fn_ptr3(i64 10, i64 %3)
  %4 = call ptr @avra_rc_alloc(i64 32)
  %5 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %4, i64 32, ptr @.i2s_fmt, i64 %closure_call4)
  %widen = sext i32 %5 to i64
  %6 = call i32 @puts(ptr %4)
  %widen5 = sext i32 %6 to i64
  %add56 = load i64, ptr @add5, align 8
  %cast7 = inttoptr i64 %add56 to ptr
  %7 = call i64 @avra_array_get(ptr %cast7, i64 1)
  %fn_ptr8 = inttoptr i64 %7 to ptr
  %8 = call i64 @avra_array_get(ptr %cast7, i64 2)
  %closure_call9 = call i64 %fn_ptr8(i64 20, i64 %8)
  %9 = call ptr @avra_rc_alloc(i64 32)
  %10 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %9, i64 32, ptr @.i2s_fmt.1, i64 %closure_call9)
  %widen10 = sext i32 %10 to i64
  %11 = call i32 @puts(ptr %9)
  %widen11 = sext i32 %11 to i64
  %12 = call ptr @make_multiplier(i64 3)
  store ptr %12, ptr @triple, align 8
  %triple = load i64, ptr @triple, align 8
  %13 = call i64 @avra_closure_call_1(i64 %triple, i64 7)
  %14 = call ptr @avra_rc_alloc(i64 32)
  %15 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %14, i64 32, ptr @.i2s_fmt.2, i64 %13)
  %widen12 = sext i32 %15 to i64
  %16 = call i32 @puts(ptr %14)
  %widen13 = sext i32 %16 to i64
  %17 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %17, i64 -559038737)
  call void @avra_array_push(ptr %17, i64 ptrtoint (ptr @__lambda_4 to i64))
  %cast14 = ptrtoint ptr %17 to i64
  store i64 %cast14, ptr @inc, align 8
  %18 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %18, i64 -559038737)
  call void @avra_array_push(ptr %18, i64 ptrtoint (ptr @__lambda_5 to i64))
  %cast15 = ptrtoint ptr %18 to i64
  store i64 %cast15, ptr @dbl, align 8
  %dbl = load ptr, ptr @dbl, align 8
  %inc = load ptr, ptr @inc, align 8
  %19 = call ptr @compose(ptr %dbl, ptr %inc)
  store ptr %19, ptr @pipeline, align 8
  %pipeline = load i64, ptr @pipeline, align 8
  %20 = call i64 @avra_closure_call_1(i64 %pipeline, i64 5)
  %21 = call ptr @avra_rc_alloc(i64 32)
  %22 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %21, i64 32, ptr @.i2s_fmt.3, i64 %20)
  %widen16 = sext i32 %22 to i64
  %23 = call i32 @puts(ptr %21)
  %widen17 = sext i32 %23 to i64
  %24 = call i32 @avra_test_summary()
  %widen18 = sext i32 %24 to i64
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__lambda_0(i64 %0, i64 %1) {
entry:
  %n = alloca i64, align 8
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  store i64 %1, ptr %n, align 8
  %x1 = load i64, ptr %x, align 8
  %n2 = load i64, ptr %n, align 8
  %mul = mul i64 %x1, %n2
  ret i64 %mul
}

define i64 @__lambda_1(i64 %0, i64 %1, i64 %2) {
entry:
  %f = alloca ptr, align 8
  %g = alloca ptr, align 8
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %cast = inttoptr i64 %1 to ptr
  store ptr %cast, ptr %g, align 8
  %cast1 = inttoptr i64 %2 to ptr
  store ptr %cast1, ptr %f, align 8
  %f2 = load i64, ptr %f, align 8
  %g3 = load i64, ptr %g, align 8
  %x4 = load i64, ptr %x, align 8
  %3 = call i64 @avra_closure_call_1(i64 %g3, i64 %x4)
  %4 = call i64 @avra_closure_call_1(i64 %f2, i64 %3)
  ret i64 %4
}

define i64 @__lambda_2(i64 %0) {
entry:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  %1 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %1, i64 -559038737)
  call void @avra_array_push(ptr %1, i64 ptrtoint (ptr @__lambda_3 to i64))
  %cap_val = load i64, ptr %n, align 8
  call void @avra_array_push(ptr %1, i64 %cap_val)
  %cast = ptrtoint ptr %1 to i64
  ret i64 %cast
}

define i64 @__lambda_3(i64 %0, i64 %1) {
entry:
  %n = alloca i64, align 8
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  store i64 %1, ptr %n, align 8
  %x1 = load i64, ptr %x, align 8
  %n2 = load i64, ptr %n, align 8
  %add = add i64 %x1, %n2
  ret i64 %add
}

define i64 @__lambda_4(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %add = add i64 %x1, 1
  ret i64 %add
}

define i64 @__lambda_5(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %mul = mul i64 %x1, 2
  ret i64 %mul
}
