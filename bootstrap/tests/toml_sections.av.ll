; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@.str = private unnamed_addr constant [95 x i8] c"[package]\0Aname = \22my-app\22\0Aversion = \220.1.0\22\0A\0A[dependencies]\0A@std/io = \221.0\22\0A@std/json = \221.0\22\0A\00", align 1
@.str.3 = private unnamed_addr constant [8 x i8] c"package\00", align 1
@.str.4 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@.str.5 = private unnamed_addr constant [8 x i8] c"package\00", align 1
@.str.6 = private unnamed_addr constant [8 x i8] c"version\00", align 1
@.str.7 = private unnamed_addr constant [13 x i8] c"dependencies\00", align 1
@.str.8 = private unnamed_addr constant [8 x i8] c"@std/io\00", align 1
@.str.9 = private unnamed_addr constant [13 x i8] c"dependencies\00", align 1
@.str.10 = private unnamed_addr constant [10 x i8] c"@std/json\00", align 1
@.str.11 = private unnamed_addr constant [8 x i8] c"package\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.12 = private unnamed_addr constant [13 x i8] c"dependencies\00", align 1
@.i2s_fmt.13 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.14 = private unnamed_addr constant [8 x i8] c"missing\00", align 1
@.i2s_fmt.15 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.16 = private unnamed_addr constant [8 x i8] c"package\00", align 1
@.str.17 = private unnamed_addr constant [7 x i8] c"author\00", align 1
@.str.18 = private unnamed_addr constant [10 x i8] c"missing='\00", align 1
@.str.19 = private unnamed_addr constant [2 x i8] c"'\00", align 1

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

declare ptr @avra_toml_get_section_string.1(ptr, ptr, ptr)

declare i64 @avra_toml_has_section.2(ptr, ptr)

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %missing = alloca ptr, align 8
  %config = alloca ptr, align 8
  store ptr @.str, ptr %config, align 8
  %config1 = load ptr, ptr %config, align 8
  %1 = call i64 @avra_toml_get_section_string(ptr %config1, i64 ptrtoint (ptr @.str.3 to i64), i64 ptrtoint (ptr @.str.4 to i64))
  %cast = inttoptr i64 %1 to ptr
  %2 = call i32 @puts(ptr %cast)
  %widen = sext i32 %2 to i64
  %config2 = load ptr, ptr %config, align 8
  %3 = call i64 @avra_toml_get_section_string(ptr %config2, i64 ptrtoint (ptr @.str.5 to i64), i64 ptrtoint (ptr @.str.6 to i64))
  %cast3 = inttoptr i64 %3 to ptr
  %4 = call i32 @puts(ptr %cast3)
  %widen4 = sext i32 %4 to i64
  %config5 = load ptr, ptr %config, align 8
  %5 = call i64 @avra_toml_get_section_string(ptr %config5, i64 ptrtoint (ptr @.str.7 to i64), i64 ptrtoint (ptr @.str.8 to i64))
  %cast6 = inttoptr i64 %5 to ptr
  %6 = call i32 @puts(ptr %cast6)
  %widen7 = sext i32 %6 to i64
  %config8 = load ptr, ptr %config, align 8
  %7 = call i64 @avra_toml_get_section_string(ptr %config8, i64 ptrtoint (ptr @.str.9 to i64), i64 ptrtoint (ptr @.str.10 to i64))
  %cast9 = inttoptr i64 %7 to ptr
  %8 = call i32 @puts(ptr %cast9)
  %widen10 = sext i32 %8 to i64
  %config11 = load ptr, ptr %config, align 8
  %9 = call i64 @avra_toml_has_section(ptr %config11, i64 ptrtoint (ptr @.str.11 to i64))
  %10 = call ptr @avra_rc_alloc(i64 32)
  %11 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %10, i64 32, ptr @.i2s_fmt, i64 %9)
  %widen12 = sext i32 %11 to i64
  %12 = call i32 @puts(ptr %10)
  %widen13 = sext i32 %12 to i64
  %config14 = load ptr, ptr %config, align 8
  %13 = call i64 @avra_toml_has_section(ptr %config14, i64 ptrtoint (ptr @.str.12 to i64))
  %14 = call ptr @avra_rc_alloc(i64 32)
  %15 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %14, i64 32, ptr @.i2s_fmt.13, i64 %13)
  %widen15 = sext i32 %15 to i64
  %16 = call i32 @puts(ptr %14)
  %widen16 = sext i32 %16 to i64
  %config17 = load ptr, ptr %config, align 8
  %17 = call i64 @avra_toml_has_section(ptr %config17, i64 ptrtoint (ptr @.str.14 to i64))
  %18 = call ptr @avra_rc_alloc(i64 32)
  %19 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %18, i64 32, ptr @.i2s_fmt.15, i64 %17)
  %widen18 = sext i32 %19 to i64
  %20 = call i32 @puts(ptr %18)
  %widen19 = sext i32 %20 to i64
  %config20 = load ptr, ptr %config, align 8
  %21 = call i64 @avra_toml_get_section_string(ptr %config20, i64 ptrtoint (ptr @.str.16 to i64), i64 ptrtoint (ptr @.str.17 to i64))
  %cast21 = inttoptr i64 %21 to ptr
  store ptr %cast21, ptr %missing, align 8
  %missing22 = load ptr, ptr %missing, align 8
  %22 = call i64 @strlen(ptr @.str.18)
  %23 = call i64 @strlen(ptr %missing22)
  %concat_total = add i64 %22, %23
  %concat_size = add i64 %concat_total, 1
  %24 = call ptr @avra_rc_alloc(i64 %concat_size)
  %25 = call ptr @memcpy(ptr %24, ptr @.str.18, i64 %22)
  %cast23 = ptrtoint ptr %24 to i64
  %dst2_int = add i64 %cast23, %22
  %cast24 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %23, 1
  %26 = call ptr @memcpy(ptr %cast24, ptr %missing22, i64 %rhs_len_p1)
  %27 = call i64 @strlen(ptr %24)
  %28 = call i64 @strlen(ptr @.str.19)
  %concat_total25 = add i64 %27, %28
  %concat_size26 = add i64 %concat_total25, 1
  %29 = call ptr @avra_rc_alloc(i64 %concat_size26)
  %30 = call ptr @memcpy(ptr %29, ptr %24, i64 %27)
  %cast27 = ptrtoint ptr %29 to i64
  %dst2_int28 = add i64 %cast27, %27
  %cast29 = inttoptr i64 %dst2_int28 to ptr
  %rhs_len_p130 = add i64 %28, 1
  %31 = call ptr @memcpy(ptr %cast29, ptr @.str.19, i64 %rhs_len_p130)
  %32 = call i32 @puts(ptr %29)
  %widen31 = sext i32 %32 to i64
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}
