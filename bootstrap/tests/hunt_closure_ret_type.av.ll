; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@names = global i64 0
@greetings = global i64 0
@upper_fn = global i64 0
@greeter = global i64 0
@.str = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"Alice\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"Bob\00", align 1
@.str.3 = private unnamed_addr constant [8 x i8] c"Charlie\00", align 1
@.str.4 = private unnamed_addr constant [7 x i8] c"Hello \00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"!\00", align 1
@.str.6 = private unnamed_addr constant [5 x i8] c"test\00", align 1
@.str.7 = private unnamed_addr constant [3 x i8] c"Hi\00", align 1
@.str.8 = private unnamed_addr constant [5 x i8] c"Dave\00", align 1

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

define ptr @make_prefix(ptr %0) {
entry:
  %prefix = alloca ptr, align 8
  store ptr %0, ptr %prefix, align 8
  %1 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %1, i64 -559038737)
  call void @avra_array_push(ptr %1, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cap_val = load i64, ptr %prefix, align 8
  call void @avra_array_push(ptr %1, i64 %cap_val)
  %cast = ptrtoint ptr %1 to i64
  %cast1 = inttoptr i64 %cast to ptr
  ret ptr %cast1
}

define i64 @main() {
entry:
  %0 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %0, i64 ptrtoint (ptr @.str.1 to i64))
  call void @avra_array_push(ptr %0, i64 ptrtoint (ptr @.str.2 to i64))
  call void @avra_array_push(ptr %0, i64 ptrtoint (ptr @.str.3 to i64))
  store ptr %0, ptr @names, align 8
  %names = load ptr, ptr @names, align 8
  %1 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %1, i64 -559038737)
  call void @avra_array_push(ptr %1, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cast = ptrtoint ptr %1 to i64
  %2 = call ptr @avra_array_map(ptr %names, i64 %cast)
  store ptr %2, ptr @greetings, align 8
  %greetings = load ptr, ptr @greetings, align 8
  %3 = call i64 @avra_array_get(ptr %greetings, i64 0)
  %cast1 = inttoptr i64 %3 to ptr
  %4 = call i32 @puts(ptr %cast1)
  %widen = sext i32 %4 to i64
  %greetings2 = load ptr, ptr @greetings, align 8
  %5 = call i64 @avra_array_get(ptr %greetings2, i64 1)
  %cast3 = inttoptr i64 %5 to ptr
  %6 = call i32 @puts(ptr %cast3)
  %widen4 = sext i32 %6 to i64
  %greetings5 = load ptr, ptr @greetings, align 8
  %7 = call i64 @avra_array_get(ptr %greetings5, i64 2)
  %cast6 = inttoptr i64 %7 to ptr
  %8 = call i32 @puts(ptr %cast6)
  %widen7 = sext i32 %8 to i64
  %9 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %9, i64 -559038737)
  call void @avra_array_push(ptr %9, i64 ptrtoint (ptr @__lambda_2 to i64))
  %cast8 = ptrtoint ptr %9 to i64
  store i64 %cast8, ptr @upper_fn, align 8
  %upper_fn = load i64, ptr @upper_fn, align 8
  %cast9 = inttoptr i64 %upper_fn to ptr
  %10 = call i64 @avra_array_get(ptr %cast9, i64 1)
  %fn_ptr = inttoptr i64 %10 to ptr
  %closure_call = call i64 %fn_ptr(ptr @.str.6)
  %cast10 = inttoptr i64 %closure_call to ptr
  %11 = call i32 @puts(ptr %cast10)
  %widen11 = sext i32 %11 to i64
  %12 = call ptr @make_prefix(ptr @.str.7)
  store ptr %12, ptr @greeter, align 8
  %greeter = load i64, ptr @greeter, align 8
  %13 = call i64 @avra_closure_call_1(i64 %greeter, i64 ptrtoint (ptr @.str.8 to i64))
  %cast12 = inttoptr i64 %13 to ptr
  %14 = call i32 @puts(ptr %cast12)
  %widen13 = sext i32 %14 to i64
  %15 = call i32 @avra_test_summary()
  %widen14 = sext i32 %15 to i64
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__lambda_0(i64 %0, i64 %1) {
entry:
  %prefix = alloca ptr, align 8
  %name = alloca i64, align 8
  store i64 %0, ptr %name, align 8
  %cast = inttoptr i64 %1 to ptr
  store ptr %cast, ptr %prefix, align 8
  %prefix1 = load ptr, ptr %prefix, align 8
  %2 = call i64 @strlen(ptr %prefix1)
  %3 = call i64 @strlen(ptr @.str)
  %concat_total = add i64 %2, %3
  %concat_size = add i64 %concat_total, 1
  %4 = call ptr @avra_rc_alloc(i64 %concat_size)
  %5 = call ptr @memcpy(ptr %4, ptr %prefix1, i64 %2)
  %cast2 = ptrtoint ptr %4 to i64
  %dst2_int = add i64 %cast2, %2
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %3, 1
  %6 = call ptr @memcpy(ptr %cast3, ptr @.str, i64 %rhs_len_p1)
  %name4 = load i64, ptr %name, align 8
  %rhs_ptr = inttoptr i64 %name4 to ptr
  %7 = call i64 @strlen(ptr %4)
  %8 = call i64 @strlen(ptr %rhs_ptr)
  %concat_total5 = add i64 %7, %8
  %concat_size6 = add i64 %concat_total5, 1
  %9 = call ptr @avra_rc_alloc(i64 %concat_size6)
  %10 = call ptr @memcpy(ptr %9, ptr %4, i64 %7)
  %cast7 = ptrtoint ptr %9 to i64
  %dst2_int8 = add i64 %cast7, %7
  %cast9 = inttoptr i64 %dst2_int8 to ptr
  %rhs_len_p110 = add i64 %8, 1
  %11 = call ptr @memcpy(ptr %cast9, ptr %rhs_ptr, i64 %rhs_len_p110)
  %cast11 = ptrtoint ptr %9 to i64
  ret i64 %cast11
}

define i64 @__lambda_1(ptr %0) {
entry:
  %name = alloca ptr, align 8
  store ptr %0, ptr %name, align 8
  %name1 = load ptr, ptr %name, align 8
  %1 = call i64 @strlen(ptr @.str.4)
  %2 = call i64 @strlen(ptr %name1)
  %concat_total = add i64 %1, %2
  %concat_size = add i64 %concat_total, 1
  %3 = call ptr @avra_rc_alloc(i64 %concat_size)
  %4 = call ptr @memcpy(ptr %3, ptr @.str.4, i64 %1)
  %cast = ptrtoint ptr %3 to i64
  %dst2_int = add i64 %cast, %1
  %cast2 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %2, 1
  %5 = call ptr @memcpy(ptr %cast2, ptr %name1, i64 %rhs_len_p1)
  %cast3 = ptrtoint ptr %3 to i64
  ret i64 %cast3
}

define i64 @__lambda_2(i64 %0) {
entry:
  %s = alloca i64, align 8
  store i64 %0, ptr %s, align 8
  %s1 = load i64, ptr %s, align 8
  %lhs_ptr = inttoptr i64 %s1 to ptr
  %1 = call i64 @strlen(ptr %lhs_ptr)
  %2 = call i64 @strlen(ptr @.str.5)
  %concat_total = add i64 %1, %2
  %concat_size = add i64 %concat_total, 1
  %3 = call ptr @avra_rc_alloc(i64 %concat_size)
  %4 = call ptr @memcpy(ptr %3, ptr %lhs_ptr, i64 %1)
  %cast = ptrtoint ptr %3 to i64
  %dst2_int = add i64 %cast, %1
  %cast2 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %2, 1
  %5 = call ptr @memcpy(ptr %cast2, ptr @.str.5, i64 %rhs_len_p1)
  %cast3 = ptrtoint ptr %3 to i64
  ret i64 %cast3
}
