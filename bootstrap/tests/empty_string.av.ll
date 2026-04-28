; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@empty = global i64 0
@result = global i64 0
@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.1 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.3 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.5 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.6 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.7 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.8 = private unnamed_addr constant [7 x i8] c" world\00", align 1
@.str.9 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
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
  store ptr @.str, ptr @empty, align 8
  %empty = load ptr, ptr @empty, align 8
  %0 = call i64 @strlen(ptr %empty)
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %0)
  %widen = sext i32 %2 to i64
  %3 = call i32 @puts(ptr %1)
  %widen1 = sext i32 %3 to i64
  %empty2 = load ptr, ptr @empty, align 8
  %4 = call i32 @strcmp(ptr %empty2, ptr @.str.1)
  %widen3 = sext i32 %4 to i64
  %streq_cmp = icmp eq i64 %widen3, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %5 = call ptr @avra_rc_alloc(i64 32)
  %6 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %5, i64 32, ptr @.i2s_fmt.2, i64 %streq_ext)
  %widen4 = sext i32 %6 to i64
  %7 = call i32 @puts(ptr %5)
  %widen5 = sext i32 %7 to i64
  %empty6 = load ptr, ptr @empty, align 8
  %8 = call i32 @strcmp(ptr %empty6, ptr @.str.3)
  %widen7 = sext i32 %8 to i64
  %streq_cmp8 = icmp ne i64 %widen7, 0
  %streq_ext9 = zext i1 %streq_cmp8 to i64
  %9 = call ptr @avra_rc_alloc(i64 32)
  %10 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %9, i64 32, ptr @.i2s_fmt.4, i64 %streq_ext9)
  %widen10 = sext i32 %10 to i64
  %11 = call i32 @puts(ptr %9)
  %widen11 = sext i32 %11 to i64
  %12 = call i64 @strlen(ptr @.str.5)
  %13 = call i64 @strlen(ptr @.str.6)
  %concat_total = add i64 %12, %13
  %concat_size = add i64 %concat_total, 1
  %14 = call ptr @avra_rc_alloc(i64 %concat_size)
  %15 = call ptr @memcpy(ptr %14, ptr @.str.5, i64 %12)
  %cast = ptrtoint ptr %14 to i64
  %dst2_int = add i64 %cast, %12
  %cast12 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %13, 1
  %16 = call ptr @memcpy(ptr %cast12, ptr @.str.6, i64 %rhs_len_p1)
  %17 = call i64 @strlen(ptr %14)
  %18 = call i64 @strlen(ptr @.str.7)
  %concat_total13 = add i64 %17, %18
  %concat_size14 = add i64 %concat_total13, 1
  %19 = call ptr @avra_rc_alloc(i64 %concat_size14)
  %20 = call ptr @memcpy(ptr %19, ptr %14, i64 %17)
  %cast15 = ptrtoint ptr %19 to i64
  %dst2_int16 = add i64 %cast15, %17
  %cast17 = inttoptr i64 %dst2_int16 to ptr
  %rhs_len_p118 = add i64 %18, 1
  %21 = call ptr @memcpy(ptr %cast17, ptr @.str.7, i64 %rhs_len_p118)
  %22 = call i64 @strlen(ptr %19)
  %23 = call i64 @strlen(ptr @.str.8)
  %concat_total19 = add i64 %22, %23
  %concat_size20 = add i64 %concat_total19, 1
  %24 = call ptr @avra_rc_alloc(i64 %concat_size20)
  %25 = call ptr @memcpy(ptr %24, ptr %19, i64 %22)
  %cast21 = ptrtoint ptr %24 to i64
  %dst2_int22 = add i64 %cast21, %22
  %cast23 = inttoptr i64 %dst2_int22 to ptr
  %rhs_len_p124 = add i64 %23, 1
  %26 = call ptr @memcpy(ptr %cast23, ptr @.str.8, i64 %rhs_len_p124)
  %27 = call i64 @strlen(ptr %24)
  %28 = call i64 @strlen(ptr @.str.9)
  %concat_total25 = add i64 %27, %28
  %concat_size26 = add i64 %concat_total25, 1
  %29 = call ptr @avra_rc_alloc(i64 %concat_size26)
  %30 = call ptr @memcpy(ptr %29, ptr %24, i64 %27)
  %cast27 = ptrtoint ptr %29 to i64
  %dst2_int28 = add i64 %cast27, %27
  %cast29 = inttoptr i64 %dst2_int28 to ptr
  %rhs_len_p130 = add i64 %28, 1
  %31 = call ptr @memcpy(ptr %cast29, ptr @.str.9, i64 %rhs_len_p130)
  store ptr %29, ptr @result, align 8
  %result = load ptr, ptr @result, align 8
  %32 = call i32 @puts(ptr %result)
  %widen31 = sext i32 %32 to i64
  %result32 = load ptr, ptr @result, align 8
  %33 = call i64 @strlen(ptr %result32)
  %34 = call ptr @avra_rc_alloc(i64 32)
  %35 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %34, i64 32, ptr @.i2s_fmt.10, i64 %33)
  %widen33 = sext i32 %35 to i64
  %36 = call i32 @puts(ptr %34)
  %widen34 = sext i32 %36 to i64
  %37 = call i32 @avra_test_summary()
  %widen35 = sext i32 %37 to i64
  call void @avra_rc_collect()
  ret i64 0
}
