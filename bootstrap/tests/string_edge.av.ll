; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@ch = global i64 0
@s = global i64 0
@.str = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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
  store ptr @.str, ptr @ch, align 8
  %ch = load ptr, ptr @ch, align 8
  %0 = call i64 @strlen(ptr %ch)
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %0)
  %widen = sext i32 %2 to i64
  %3 = call i32 @puts(ptr %1)
  %widen1 = sext i32 %3 to i64
  %ch2 = load ptr, ptr @ch, align 8
  %4 = call i32 @puts(ptr %ch2)
  %widen3 = sext i32 %4 to i64
  store ptr @.str.1, ptr @s, align 8
  %s = load ptr, ptr @s, align 8
  %cast = ptrtoint ptr %s to i64
  %idx_off_int = add i64 %cast, 0
  %cast4 = inttoptr i64 %idx_off_int to ptr
  %idx_byte = load i8, ptr %cast4, align 8
  %5 = call ptr @avra_rc_alloc(i64 2)
  store i8 %idx_byte, ptr %5, align 8
  %cast5 = ptrtoint ptr %5 to i64
  %idx_nul_int = add i64 %cast5, 1
  %cast6 = inttoptr i64 %idx_nul_int to ptr
  store i8 0, ptr %cast6, align 8
  %6 = call i32 @puts(ptr %5)
  %widen7 = sext i32 %6 to i64
  %s8 = load ptr, ptr @s, align 8
  %cast9 = ptrtoint ptr %s8 to i64
  %idx_off_int10 = add i64 %cast9, 4
  %cast11 = inttoptr i64 %idx_off_int10 to ptr
  %idx_byte12 = load i8, ptr %cast11, align 8
  %7 = call ptr @avra_rc_alloc(i64 2)
  store i8 %idx_byte12, ptr %7, align 8
  %cast13 = ptrtoint ptr %7 to i64
  %idx_nul_int14 = add i64 %cast13, 1
  %cast15 = inttoptr i64 %idx_nul_int14 to ptr
  store i8 0, ptr %cast15, align 8
  %8 = call i32 @puts(ptr %7)
  %widen16 = sext i32 %8 to i64
  %s17 = load ptr, ptr @s, align 8
  %9 = call ptr @avra_rc_alloc(i64 1)
  %cast18 = ptrtoint ptr %s17 to i64
  %sub_off_int = add i64 %cast18, 0
  %cast19 = inttoptr i64 %sub_off_int to ptr
  %10 = call ptr @memcpy(ptr %9, ptr %cast19, i64 0)
  %cast20 = ptrtoint ptr %9 to i64
  %sub_nul_int = add i64 %cast20, 0
  %cast21 = inttoptr i64 %sub_nul_int to ptr
  store i8 0, ptr %cast21, align 8
  %11 = call i32 @puts(ptr %9)
  %widen22 = sext i32 %11 to i64
  %s23 = load ptr, ptr @s, align 8
  %12 = call ptr @avra_rc_alloc(i64 6)
  %cast24 = ptrtoint ptr %s23 to i64
  %sub_off_int25 = add i64 %cast24, 0
  %cast26 = inttoptr i64 %sub_off_int25 to ptr
  %13 = call ptr @memcpy(ptr %12, ptr %cast26, i64 5)
  %cast27 = ptrtoint ptr %12 to i64
  %sub_nul_int28 = add i64 %cast27, 5
  %cast29 = inttoptr i64 %sub_nul_int28 to ptr
  store i8 0, ptr %cast29, align 8
  %14 = call i32 @puts(ptr %12)
  %widen30 = sext i32 %14 to i64
  %s31 = load ptr, ptr @s, align 8
  %15 = call ptr @avra_rc_alloc(i64 1)
  %cast32 = ptrtoint ptr %s31 to i64
  %sub_off_int33 = add i64 %cast32, 2
  %cast34 = inttoptr i64 %sub_off_int33 to ptr
  %16 = call ptr @memcpy(ptr %15, ptr %cast34, i64 0)
  %cast35 = ptrtoint ptr %15 to i64
  %sub_nul_int36 = add i64 %cast35, 0
  %cast37 = inttoptr i64 %sub_nul_int36 to ptr
  store i8 0, ptr %cast37, align 8
  %17 = call i32 @puts(ptr %15)
  %widen38 = sext i32 %17 to i64
  %s39 = load ptr, ptr @s, align 8
  %18 = call ptr @avra_rc_alloc(i64 6)
  %cast40 = ptrtoint ptr %s39 to i64
  %sub_off_int41 = add i64 %cast40, 0
  %cast42 = inttoptr i64 %sub_off_int41 to ptr
  %19 = call ptr @memcpy(ptr %18, ptr %cast42, i64 5)
  %cast43 = ptrtoint ptr %18 to i64
  %sub_nul_int44 = add i64 %cast43, 5
  %cast45 = inttoptr i64 %sub_nul_int44 to ptr
  store i8 0, ptr %cast45, align 8
  %20 = call i64 @strlen(ptr %18)
  %21 = call ptr @avra_rc_alloc(i64 32)
  %22 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %21, i64 32, ptr @.i2s_fmt.2, i64 %20)
  %widen46 = sext i32 %22 to i64
  %23 = call i32 @puts(ptr %21)
  %widen47 = sext i32 %23 to i64
  %24 = call i32 @avra_test_summary()
  %widen48 = sext i32 %24 to i64
  call void @avra_rc_collect()
  ret i64 0
}
