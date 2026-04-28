; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@double = global i64 0
@add = global i64 0
@nums = global i64 0
@doubled = global i64 0
@big = global i64 0
@sum = global i64 0
@greet = global i64 0
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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
  %0 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %0, i64 -559038737)
  call void @avra_array_push(ptr %0, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast = ptrtoint ptr %0 to i64
  store i64 %cast, ptr @double, align 8
  %double = load i64, ptr @double, align 8
  %cast1 = inttoptr i64 %double to ptr
  %1 = call i64 @avra_array_get(ptr %cast1, i64 1)
  %fn_ptr = inttoptr i64 %1 to ptr
  %closure_call = call i64 %fn_ptr(i64 5)
  %2 = call ptr @avra_rc_alloc(i64 32)
  %3 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %2, i64 32, ptr @.i2s_fmt, i64 %closure_call)
  %widen = sext i32 %3 to i64
  %4 = call i32 @puts(ptr %2)
  %widen2 = sext i32 %4 to i64
  %5 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %5, i64 -559038737)
  call void @avra_array_push(ptr %5, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cast3 = ptrtoint ptr %5 to i64
  store i64 %cast3, ptr @add, align 8
  %add = load i64, ptr @add, align 8
  %cast4 = inttoptr i64 %add to ptr
  %6 = call i64 @avra_array_get(ptr %cast4, i64 1)
  %fn_ptr5 = inttoptr i64 %6 to ptr
  %closure_call6 = call i64 %fn_ptr5(i64 3, i64 4)
  %7 = call ptr @avra_rc_alloc(i64 32)
  %8 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %7, i64 32, ptr @.i2s_fmt.1, i64 %closure_call6)
  %widen7 = sext i32 %8 to i64
  %9 = call i32 @puts(ptr %7)
  %widen8 = sext i32 %9 to i64
  %10 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %10, i64 1)
  call void @avra_array_push(ptr %10, i64 2)
  call void @avra_array_push(ptr %10, i64 3)
  call void @avra_array_push(ptr %10, i64 4)
  call void @avra_array_push(ptr %10, i64 5)
  store ptr %10, ptr @nums, align 8
  %nums = load ptr, ptr @nums, align 8
  %11 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %11, i64 -559038737)
  call void @avra_array_push(ptr %11, i64 ptrtoint (ptr @__lambda_2 to i64))
  %cast9 = ptrtoint ptr %11 to i64
  %12 = call ptr @avra_array_map(ptr %nums, i64 %cast9)
  store ptr %12, ptr @doubled, align 8
  %doubled = load ptr, ptr @doubled, align 8
  %13 = call i64 @avra_array_get(ptr %doubled, i64 0)
  %14 = call ptr @avra_rc_alloc(i64 32)
  %15 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %14, i64 32, ptr @.i2s_fmt.2, i64 %13)
  %widen10 = sext i32 %15 to i64
  %16 = call i32 @puts(ptr %14)
  %widen11 = sext i32 %16 to i64
  %doubled12 = load ptr, ptr @doubled, align 8
  %17 = call i64 @avra_array_get(ptr %doubled12, i64 4)
  %18 = call ptr @avra_rc_alloc(i64 32)
  %19 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %18, i64 32, ptr @.i2s_fmt.3, i64 %17)
  %widen13 = sext i32 %19 to i64
  %20 = call i32 @puts(ptr %18)
  %widen14 = sext i32 %20 to i64
  %nums15 = load ptr, ptr @nums, align 8
  %21 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %21, i64 -559038737)
  call void @avra_array_push(ptr %21, i64 ptrtoint (ptr @__lambda_3 to i64))
  %cast16 = ptrtoint ptr %21 to i64
  %22 = call ptr @avra_array_filter(ptr %nums15, i64 %cast16)
  store ptr %22, ptr @big, align 8
  %big = load ptr, ptr @big, align 8
  %23 = call i64 @avra_array_len(ptr %big)
  %24 = call ptr @avra_rc_alloc(i64 32)
  %25 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %24, i64 32, ptr @.i2s_fmt.4, i64 %23)
  %widen17 = sext i32 %25 to i64
  %26 = call i32 @puts(ptr %24)
  %widen18 = sext i32 %26 to i64
  %big19 = load ptr, ptr @big, align 8
  %27 = call i64 @avra_array_get(ptr %big19, i64 0)
  %28 = call ptr @avra_rc_alloc(i64 32)
  %29 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %28, i64 32, ptr @.i2s_fmt.5, i64 %27)
  %widen20 = sext i32 %29 to i64
  %30 = call i32 @puts(ptr %28)
  %widen21 = sext i32 %30 to i64
  %nums22 = load ptr, ptr @nums, align 8
  %31 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %31, i64 -559038737)
  call void @avra_array_push(ptr %31, i64 ptrtoint (ptr @__lambda_4 to i64))
  %cast23 = ptrtoint ptr %31 to i64
  %32 = call i64 @avra_array_reduce(ptr %nums22, i64 0, i64 %cast23)
  store i64 %32, ptr @sum, align 8
  %sum = load i64, ptr @sum, align 8
  %33 = call ptr @avra_rc_alloc(i64 32)
  %34 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %33, i64 32, ptr @.i2s_fmt.6, i64 %sum)
  %widen24 = sext i32 %34 to i64
  %35 = call i32 @puts(ptr %33)
  %widen25 = sext i32 %35 to i64
  %36 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %36, i64 -559038737)
  call void @avra_array_push(ptr %36, i64 ptrtoint (ptr @__lambda_5 to i64))
  %cast26 = ptrtoint ptr %36 to i64
  store i64 %cast26, ptr @greet, align 8
  %greet = load i64, ptr @greet, align 8
  %cast27 = inttoptr i64 %greet to ptr
  %37 = call i64 @avra_array_get(ptr %cast27, i64 1)
  %fn_ptr28 = inttoptr i64 %37 to ptr
  %closure_call29 = call i64 %fn_ptr28()
  %38 = call ptr @avra_rc_alloc(i64 32)
  %39 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %38, i64 32, ptr @.i2s_fmt.7, i64 %closure_call29)
  %widen30 = sext i32 %39 to i64
  %40 = call i32 @puts(ptr %38)
  %widen31 = sext i32 %40 to i64
  %41 = call i32 @avra_test_summary()
  %widen32 = sext i32 %41 to i64
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__lambda_0(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %mul = mul i64 %x1, 2
  ret i64 %mul
}

define i64 @__lambda_1(i64 %0, i64 %1) {
entry:
  %b = alloca i64, align 8
  %a = alloca i64, align 8
  store i64 %0, ptr %a, align 8
  store i64 %1, ptr %b, align 8
  %a1 = load i64, ptr %a, align 8
  %b2 = load i64, ptr %b, align 8
  %add = add i64 %a1, %b2
  ret i64 %add
}

define i64 @__lambda_2(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %mul = mul i64 %x1, 2
  ret i64 %mul
}

define i64 @__lambda_3(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %sgt = icmp sgt i64 %x1, 3
  %sgt_ext = zext i1 %sgt to i64
  ret i64 %sgt_ext
}

define i64 @__lambda_4(i64 %0, i64 %1) {
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

define i64 @__lambda_5() {
entry:
  ret i64 42
}
