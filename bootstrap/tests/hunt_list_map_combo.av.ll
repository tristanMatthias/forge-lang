; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@users = global i64 0
@data = global i64 0
@nums = global i64 0
@doubled = global i64 0
@big = global i64 0
@.str = private unnamed_addr constant [5 x i8] c"name\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"Alice\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"age\00", align 1
@.str.3 = private unnamed_addr constant [3 x i8] c"30\00", align 1
@.str.4 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@.str.5 = private unnamed_addr constant [4 x i8] c"Bob\00", align 1
@.str.6 = private unnamed_addr constant [4 x i8] c"age\00", align 1
@.str.7 = private unnamed_addr constant [3 x i8] c"25\00", align 1
@.str.8 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@.str.9 = private unnamed_addr constant [4 x i8] c"age\00", align 1
@.str.10 = private unnamed_addr constant [8 x i8] c"numbers\00", align 1
@.str.11 = private unnamed_addr constant [6 x i8] c"1,2,3\00", align 1
@.str.12 = private unnamed_addr constant [6 x i8] c"label\00", align 1
@.str.13 = private unnamed_addr constant [5 x i8] c"test\00", align 1
@.str.14 = private unnamed_addr constant [6 x i8] c"label\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.15 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.16 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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
  %1 = call ptr @avra_map_new_cstr()
  call void @avra_map_set_cstr(ptr %1, ptr @.str, i64 ptrtoint (ptr @.str.1 to i64))
  call void @avra_map_set_cstr(ptr %1, ptr @.str.2, i64 ptrtoint (ptr @.str.3 to i64))
  %cast = ptrtoint ptr %1 to i64
  call void @avra_array_push(ptr %0, i64 %cast)
  %2 = call ptr @avra_map_new_cstr()
  call void @avra_map_set_cstr(ptr %2, ptr @.str.4, i64 ptrtoint (ptr @.str.5 to i64))
  call void @avra_map_set_cstr(ptr %2, ptr @.str.6, i64 ptrtoint (ptr @.str.7 to i64))
  %cast1 = ptrtoint ptr %2 to i64
  call void @avra_array_push(ptr %0, i64 %cast1)
  store ptr %0, ptr @users, align 8
  %users = load ptr, ptr @users, align 8
  %3 = call i64 @avra_array_get(ptr %users, i64 0)
  %cast2 = inttoptr i64 %3 to ptr
  %4 = call i64 @avra_map_get_cstr(ptr %cast2, ptr @.str.8)
  %cast3 = inttoptr i64 %4 to ptr
  %5 = call i32 @puts(ptr %cast3)
  %widen = sext i32 %5 to i64
  %users4 = load ptr, ptr @users, align 8
  %6 = call i64 @avra_array_get(ptr %users4, i64 1)
  %cast5 = inttoptr i64 %6 to ptr
  %7 = call i64 @avra_map_get_cstr(ptr %cast5, ptr @.str.9)
  %cast6 = inttoptr i64 %7 to ptr
  %8 = call i32 @puts(ptr %cast6)
  %widen7 = sext i32 %8 to i64
  %9 = call ptr @avra_map_new_cstr()
  call void @avra_map_set_cstr(ptr %9, ptr @.str.10, i64 ptrtoint (ptr @.str.11 to i64))
  call void @avra_map_set_cstr(ptr %9, ptr @.str.12, i64 ptrtoint (ptr @.str.13 to i64))
  store ptr %9, ptr @data, align 8
  %data = load ptr, ptr @data, align 8
  %10 = call i64 @avra_map_get_cstr(ptr %data, ptr @.str.14)
  %cast8 = inttoptr i64 %10 to ptr
  %11 = call i32 @puts(ptr %cast8)
  %widen9 = sext i32 %11 to i64
  %12 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %12, i64 1)
  call void @avra_array_push(ptr %12, i64 2)
  call void @avra_array_push(ptr %12, i64 3)
  call void @avra_array_push(ptr %12, i64 4)
  call void @avra_array_push(ptr %12, i64 5)
  store ptr %12, ptr @nums, align 8
  %nums = load ptr, ptr @nums, align 8
  %13 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %13, i64 -559038737)
  call void @avra_array_push(ptr %13, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast10 = ptrtoint ptr %13 to i64
  %14 = call ptr @avra_array_map(ptr %nums, i64 %cast10)
  store ptr %14, ptr @doubled, align 8
  %doubled = load ptr, ptr @doubled, align 8
  %15 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %15, i64 -559038737)
  call void @avra_array_push(ptr %15, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cast11 = ptrtoint ptr %15 to i64
  %16 = call ptr @avra_array_filter(ptr %doubled, i64 %cast11)
  store ptr %16, ptr @big, align 8
  %big = load ptr, ptr @big, align 8
  %17 = call i64 @avra_array_get(ptr %big, i64 0)
  %18 = call ptr @avra_rc_alloc(i64 32)
  %19 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %18, i64 32, ptr @.i2s_fmt, i64 %17)
  %widen12 = sext i32 %19 to i64
  %20 = call i32 @puts(ptr %18)
  %widen13 = sext i32 %20 to i64
  %big14 = load ptr, ptr @big, align 8
  %21 = call i64 @avra_array_get(ptr %big14, i64 1)
  %22 = call ptr @avra_rc_alloc(i64 32)
  %23 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %22, i64 32, ptr @.i2s_fmt.15, i64 %21)
  %widen15 = sext i32 %23 to i64
  %24 = call i32 @puts(ptr %22)
  %widen16 = sext i32 %24 to i64
  %big17 = load ptr, ptr @big, align 8
  %25 = call i64 @avra_array_get(ptr %big17, i64 2)
  %26 = call ptr @avra_rc_alloc(i64 32)
  %27 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %26, i64 32, ptr @.i2s_fmt.16, i64 %25)
  %widen18 = sext i32 %27 to i64
  %28 = call i32 @puts(ptr %26)
  %widen19 = sext i32 %28 to i64
  %29 = call i32 @avra_test_summary()
  %widen20 = sext i32 %29 to i64
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

define i64 @__lambda_1(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %sgt = icmp sgt i64 %x1, 4
  %sgt_ext = zext i1 %sgt to i64
  ret i64 %sgt_ext
}
