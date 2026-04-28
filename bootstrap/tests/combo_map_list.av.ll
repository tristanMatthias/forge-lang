; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@config = global i64 0
@keys = global i64 0
@lookup = global i64 0
@scores = global i64 0
@high = global i64 0
@result = global i64 0
@.str = private unnamed_addr constant [5 x i8] c"host\00", align 1
@.str.1 = private unnamed_addr constant [10 x i8] c"localhost\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"port\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"8080\00", align 1
@.str.4 = private unnamed_addr constant [6 x i8] c"debug\00", align 1
@.str.5 = private unnamed_addr constant [5 x i8] c"true\00", align 1
@.str.6 = private unnamed_addr constant [5 x i8] c"host\00", align 1
@.str.7 = private unnamed_addr constant [5 x i8] c"port\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.9 = private unnamed_addr constant [6 x i8] c"alice\00", align 1
@.str.10 = private unnamed_addr constant [4 x i8] c"100\00", align 1
@.str.11 = private unnamed_addr constant [4 x i8] c"bob\00", align 1
@.str.12 = private unnamed_addr constant [4 x i8] c"200\00", align 1
@.str.13 = private unnamed_addr constant [6 x i8] c"carol\00", align 1
@.str.14 = private unnamed_addr constant [4 x i8] c"300\00", align 1
@.str.15 = private unnamed_addr constant [4 x i8] c"bob\00", align 1
@.str.16 = private unnamed_addr constant [6 x i8] c"carol\00", align 1
@.i2s_fmt.17 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.18 = private unnamed_addr constant [5 x i8] c"dave\00", align 1
@.i2s_fmt.19 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.20 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.21 = private unnamed_addr constant [6 x i8] c"alice\00", align 1
@.str.22 = private unnamed_addr constant [4 x i8] c"999\00", align 1
@.str.23 = private unnamed_addr constant [6 x i8] c"alice\00", align 1
@.str.24 = private unnamed_addr constant [6 x i8] c"count\00", align 1
@.i2s_fmt.25 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.26 = private unnamed_addr constant [6 x i8] c"first\00", align 1
@.i2s_fmt.27 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.28 = private unnamed_addr constant [6 x i8] c"count\00", align 1
@.str.29 = private unnamed_addr constant [6 x i8] c"first\00", align 1

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
  %0 = call ptr @avra_map_new_cstr()
  call void @avra_map_set_cstr(ptr %0, ptr @.str, i64 ptrtoint (ptr @.str.1 to i64))
  call void @avra_map_set_cstr(ptr %0, ptr @.str.2, i64 ptrtoint (ptr @.str.3 to i64))
  call void @avra_map_set_cstr(ptr %0, ptr @.str.4, i64 ptrtoint (ptr @.str.5 to i64))
  store ptr %0, ptr @config, align 8
  %config = load ptr, ptr @config, align 8
  %1 = call i64 @avra_map_get_cstr(ptr %config, ptr @.str.6)
  %cast = inttoptr i64 %1 to ptr
  %2 = call i32 @puts(ptr %cast)
  %widen = sext i32 %2 to i64
  %config1 = load ptr, ptr @config, align 8
  %3 = call i64 @avra_map_get_cstr(ptr %config1, ptr @.str.7)
  %cast2 = inttoptr i64 %3 to ptr
  %4 = call i32 @puts(ptr %cast2)
  %widen3 = sext i32 %4 to i64
  %config4 = load ptr, ptr @config, align 8
  %5 = call i64 @avra_map_len_cstr(ptr %config4)
  %6 = call ptr @avra_rc_alloc(i64 32)
  %7 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %6, i64 32, ptr @.i2s_fmt, i64 %5)
  %widen5 = sext i32 %7 to i64
  %8 = call i32 @puts(ptr %6)
  %widen6 = sext i32 %8 to i64
  %config7 = load ptr, ptr @config, align 8
  %9 = call ptr @avra_map_keys_cstr(ptr %config7)
  store ptr %9, ptr @keys, align 8
  %keys = load ptr, ptr @keys, align 8
  %10 = call i64 @avra_array_len(ptr %keys)
  %11 = call ptr @avra_rc_alloc(i64 32)
  %12 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %11, i64 32, ptr @.i2s_fmt.8, i64 %10)
  %widen8 = sext i32 %12 to i64
  %13 = call i32 @puts(ptr %11)
  %widen9 = sext i32 %13 to i64
  %14 = call ptr @avra_map_new_cstr()
  store ptr %14, ptr @lookup, align 8
  %lookup = load ptr, ptr @lookup, align 8
  call void @avra_map_set_cstr(ptr %lookup, ptr @.str.9, i64 ptrtoint (ptr @.str.10 to i64))
  %lookup10 = load ptr, ptr @lookup, align 8
  call void @avra_map_set_cstr(ptr %lookup10, ptr @.str.11, i64 ptrtoint (ptr @.str.12 to i64))
  %lookup11 = load ptr, ptr @lookup, align 8
  call void @avra_map_set_cstr(ptr %lookup11, ptr @.str.13, i64 ptrtoint (ptr @.str.14 to i64))
  %lookup12 = load ptr, ptr @lookup, align 8
  %15 = call i64 @avra_map_get_cstr(ptr %lookup12, ptr @.str.15)
  %cast13 = inttoptr i64 %15 to ptr
  %16 = call i32 @puts(ptr %cast13)
  %widen14 = sext i32 %16 to i64
  %lookup15 = load ptr, ptr @lookup, align 8
  %17 = call i64 @avra_map_has_cstr(ptr %lookup15, ptr @.str.16)
  %18 = call ptr @avra_rc_alloc(i64 32)
  %19 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %18, i64 32, ptr @.i2s_fmt.17, i64 %17)
  %widen16 = sext i32 %19 to i64
  %20 = call i32 @puts(ptr %18)
  %widen17 = sext i32 %20 to i64
  %lookup18 = load ptr, ptr @lookup, align 8
  %21 = call i64 @avra_map_has_cstr(ptr %lookup18, ptr @.str.18)
  %22 = call ptr @avra_rc_alloc(i64 32)
  %23 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %22, i64 32, ptr @.i2s_fmt.19, i64 %21)
  %widen19 = sext i32 %23 to i64
  %24 = call i32 @puts(ptr %22)
  %widen20 = sext i32 %24 to i64
  %lookup21 = load ptr, ptr @lookup, align 8
  %25 = call i64 @avra_map_len_cstr(ptr %lookup21)
  %26 = call ptr @avra_rc_alloc(i64 32)
  %27 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %26, i64 32, ptr @.i2s_fmt.20, i64 %25)
  %widen22 = sext i32 %27 to i64
  %28 = call i32 @puts(ptr %26)
  %widen23 = sext i32 %28 to i64
  %lookup24 = load ptr, ptr @lookup, align 8
  call void @avra_map_set_cstr(ptr %lookup24, ptr @.str.21, i64 ptrtoint (ptr @.str.22 to i64))
  %lookup25 = load ptr, ptr @lookup, align 8
  %29 = call i64 @avra_map_get_cstr(ptr %lookup25, ptr @.str.23)
  %cast26 = inttoptr i64 %29 to ptr
  %30 = call i32 @puts(ptr %cast26)
  %widen27 = sext i32 %30 to i64
  %31 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %31, i64 90)
  call void @avra_array_push(ptr %31, i64 85)
  call void @avra_array_push(ptr %31, i64 95)
  call void @avra_array_push(ptr %31, i64 70)
  call void @avra_array_push(ptr %31, i64 88)
  store ptr %31, ptr @scores, align 8
  %scores = load ptr, ptr @scores, align 8
  %32 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %32, i64 -559038737)
  call void @avra_array_push(ptr %32, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast28 = ptrtoint ptr %32 to i64
  %33 = call ptr @avra_array_filter(ptr %scores, i64 %cast28)
  store ptr %33, ptr @high, align 8
  %34 = call ptr @avra_map_new_cstr()
  %high = load ptr, ptr @high, align 8
  %35 = call i64 @avra_array_len(ptr %high)
  %36 = call ptr @avra_rc_alloc(i64 32)
  %37 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %36, i64 32, ptr @.i2s_fmt.25, i64 %35)
  %widen29 = sext i32 %37 to i64
  %cast30 = ptrtoint ptr %36 to i64
  call void @avra_map_set_cstr(ptr %34, ptr @.str.24, i64 %cast30)
  %high31 = load ptr, ptr @high, align 8
  %38 = call i64 @avra_array_get(ptr %high31, i64 0)
  %39 = call ptr @avra_rc_alloc(i64 32)
  %40 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %39, i64 32, ptr @.i2s_fmt.27, i64 %38)
  %widen32 = sext i32 %40 to i64
  %cast33 = ptrtoint ptr %39 to i64
  call void @avra_map_set_cstr(ptr %34, ptr @.str.26, i64 %cast33)
  store ptr %34, ptr @result, align 8
  %result = load ptr, ptr @result, align 8
  %41 = call i64 @avra_map_get_cstr(ptr %result, ptr @.str.28)
  %cast34 = inttoptr i64 %41 to ptr
  %42 = call i32 @puts(ptr %cast34)
  %widen35 = sext i32 %42 to i64
  %result36 = load ptr, ptr @result, align 8
  %43 = call i64 @avra_map_get_cstr(ptr %result36, ptr @.str.29)
  %cast37 = inttoptr i64 %43 to ptr
  %44 = call i32 @puts(ptr %cast37)
  %widen38 = sext i32 %44 to i64
  %45 = call i32 @avra_test_summary()
  %widen39 = sext i32 %45 to i64
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__lambda_0(i64 %0) {
entry:
  %s = alloca i64, align 8
  store i64 %0, ptr %s, align 8
  %s1 = load i64, ptr %s, align 8
  %sge = icmp sge i64 %s1, 90
  %sge_ext = zext i1 %sge to i64
  ret i64 %sge_ext
}
