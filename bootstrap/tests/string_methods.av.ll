; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@s = global i64 0
@r = global i64 0
@t = global i64 0
@parts = global i64 0
@.str = private unnamed_addr constant [12 x i8] c"hello world\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"world\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.2 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.4 = private unnamed_addr constant [6 x i8] c"world\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.6 = private unnamed_addr constant [6 x i8] c"world\00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.8 = private unnamed_addr constant [6 x i8] c"world\00", align 1
@.str.9 = private unnamed_addr constant [5 x i8] c"avra\00", align 1
@.str.10 = private unnamed_addr constant [11 x i8] c"  spaces  \00", align 1
@.str.11 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.12 = private unnamed_addr constant [6 x i8] c"HELLO\00", align 1
@.str.13 = private unnamed_addr constant [6 x i8] c"a,b,c\00", align 1
@.str.14 = private unnamed_addr constant [2 x i8] c",\00", align 1
@.i2s_fmt.15 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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
  store ptr @.str, ptr @s, align 8
  %s = load ptr, ptr @s, align 8
  %0 = call i64 @avra_str_contains(ptr %s, ptr @.str.1)
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %0)
  %widen = sext i32 %2 to i64
  %3 = call i32 @puts(ptr %1)
  %widen1 = sext i32 %3 to i64
  %s2 = load ptr, ptr @s, align 8
  %4 = call i64 @avra_str_starts_with(ptr %s2, ptr @.str.2)
  %5 = call ptr @avra_rc_alloc(i64 32)
  %6 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %5, i64 32, ptr @.i2s_fmt.3, i64 %4)
  %widen3 = sext i32 %6 to i64
  %7 = call i32 @puts(ptr %5)
  %widen4 = sext i32 %7 to i64
  %s5 = load ptr, ptr @s, align 8
  %8 = call i64 @avra_str_ends_with(ptr %s5, ptr @.str.4)
  %9 = call ptr @avra_rc_alloc(i64 32)
  %10 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %9, i64 32, ptr @.i2s_fmt.5, i64 %8)
  %widen6 = sext i32 %10 to i64
  %11 = call i32 @puts(ptr %9)
  %widen7 = sext i32 %11 to i64
  %s8 = load ptr, ptr @s, align 8
  %12 = call i64 @avra_str_index_of(ptr %s8, ptr @.str.6)
  %13 = call ptr @avra_rc_alloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @.i2s_fmt.7, i64 %12)
  %widen9 = sext i32 %14 to i64
  %15 = call i32 @puts(ptr %13)
  %widen10 = sext i32 %15 to i64
  %s11 = load ptr, ptr @s, align 8
  %16 = call ptr @avra_str_replace(ptr %s11, ptr @.str.8, ptr @.str.9)
  store ptr %16, ptr @r, align 8
  %r = load ptr, ptr @r, align 8
  %17 = call i32 @puts(ptr %r)
  %widen12 = sext i32 %17 to i64
  %18 = call ptr @avra_str_trim(ptr @.str.10)
  store ptr %18, ptr @t, align 8
  %t = load ptr, ptr @t, align 8
  %19 = call i32 @puts(ptr %t)
  %widen13 = sext i32 %19 to i64
  %20 = call ptr @avra_str_to_upper(ptr @.str.11)
  %21 = call i32 @puts(ptr %20)
  %widen14 = sext i32 %21 to i64
  %22 = call ptr @avra_str_to_lower(ptr @.str.12)
  %23 = call i32 @puts(ptr %22)
  %widen15 = sext i32 %23 to i64
  %24 = call ptr @avra_str_split(ptr @.str.13, ptr @.str.14)
  store ptr %24, ptr @parts, align 8
  %parts = load ptr, ptr @parts, align 8
  %25 = call i64 @avra_array_len(ptr %parts)
  %26 = call ptr @avra_rc_alloc(i64 32)
  %27 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %26, i64 32, ptr @.i2s_fmt.15, i64 %25)
  %widen16 = sext i32 %27 to i64
  %28 = call i32 @puts(ptr %26)
  %widen17 = sext i32 %28 to i64
  %parts18 = load ptr, ptr @parts, align 8
  %29 = call i64 @avra_array_get(ptr %parts18, i64 0)
  %cast = inttoptr i64 %29 to ptr
  %30 = call i32 @puts(ptr %cast)
  %widen19 = sext i32 %30 to i64
  %parts20 = load ptr, ptr @parts, align 8
  %31 = call i64 @avra_array_get(ptr %parts20, i64 1)
  %cast21 = inttoptr i64 %31 to ptr
  %32 = call i32 @puts(ptr %cast21)
  %widen22 = sext i32 %32 to i64
  %parts23 = load ptr, ptr @parts, align 8
  %33 = call i64 @avra_array_get(ptr %parts23, i64 2)
  %cast24 = inttoptr i64 %33 to ptr
  %34 = call i32 @puts(ptr %cast24)
  %widen25 = sext i32 %34 to i64
  %35 = call i32 @avra_test_summary()
  %widen26 = sext i32 %35 to i64
  call void @avra_rc_collect()
  ret i64 0
}
