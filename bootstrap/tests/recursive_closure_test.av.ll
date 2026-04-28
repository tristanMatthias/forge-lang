; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@rcl_square = global i64 0
@rcl_cube = global i64 0
@spec_str = private unnamed_addr constant [20 x i8] c"\22recursive closure\22\00", align 1
@spec_str.1 = private unnamed_addr constant [11 x i8] c"\22square 5\22\00", align 1
@spec_str.2 = private unnamed_addr constant [9 x i8] c"\22cube 3\22\00", align 1

declare i32 @puts(ptr)

declare void @forge_eprintln(ptr)

declare i64 @strlen(ptr)

declare ptr @malloc(i64)

declare ptr @forge_rc_alloc(i64)

declare void @forge_rc_retain(ptr)

declare void @forge_rc_release(ptr)

declare i64 @forge_rc_should_free(ptr)

declare void @forge_rc_free(ptr)

declare void @forge_rc_suspect(ptr)

declare void @forge_rc_collect()

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @strcmp(ptr, ptr)

declare i32 @snprintf(ptr, i64, ptr, ...)

declare i32 @atoi(ptr)

declare void @exit(i32)

declare void @forge_null_arg_check(ptr, i64, ptr, i64, i64)

declare void @forge_null_deref_trap(ptr, i64, ptr, i64, i64, ptr, i64, i64)

declare void @forge_div_by_zero_trap(i64, ptr, i64, i64)

declare ptr @forge_array_new()

declare void @forge_array_push(ptr, i64)

declare i64 @forge_array_get(ptr, i64)

declare i64 @forge_array_len(ptr)

declare void @forge_array_set(ptr, i64, i64)

declare i64 @forge_array_pop(ptr)

declare ptr @forge_array_slice(ptr, i64, i64)

declare i64 @forge_closure_get_fn(i64)

declare i64 @forge_closure_num_captures(i64)

declare i64 @forge_closure_get_capture(ptr, i64)

declare i64 @forge_closure_call_0(i64)

declare i64 @forge_closure_call_1(i64, i64)

declare i64 @forge_closure_call_2(i64, i64, i64)

declare i64 @forge_closure_call_3(i64, i64, i64, i64)

declare i64 @forge_closure_call_4(i64, i64, i64, i64, i64)

declare i64 @forge_closure_call_5(i64, i64, i64, i64, i64, i64)

declare ptr @forge_array_map(ptr, i64)

declare ptr @forge_array_filter(ptr, i64)

declare void @forge_array_foreach(ptr, i64)

declare i64 @forge_array_reduce(ptr, i64, i64)

declare i64 @forge_array_contains(ptr, i64)

declare i64 @forge_array_index_of(ptr, i64)

declare ptr @forge_array_reverse(ptr)

declare i64 @forge_str_contains(ptr, ptr)

declare i64 @forge_str_starts_with(ptr, ptr)

declare i64 @forge_str_ends_with(ptr, ptr)

declare i64 @forge_str_index_of(ptr, ptr)

declare ptr @forge_str_split(ptr, ptr)

declare ptr @forge_str_replace(ptr, ptr, ptr)

declare ptr @forge_str_trim(ptr)

declare ptr @forge_str_to_upper(ptr)

declare ptr @forge_str_to_lower(ptr)

declare ptr @forge_str_join(ptr, ptr)

declare ptr @forge_str_char_at(ptr, i64)

declare ptr @forge_str_substring(ptr, i64, i64)

declare ptr @forge_str_repeat(ptr, i64)

declare ptr @forge_str_reverse(ptr)

declare ptr @forge_map_new_cstr()

declare void @forge_map_set_cstr(ptr, ptr, i64)

declare i64 @forge_map_get_cstr(ptr, ptr)

declare i64 @forge_map_has_cstr(ptr, ptr)

declare i64 @forge_map_len_cstr(ptr)

declare ptr @forge_map_keys_cstr(ptr)

declare ptr @forge_map_values_cstr(ptr)

declare i64 @forge_map_remove_cstr(ptr, ptr)

declare ptr @forge_file_read(ptr)

declare i64 @forge_file_write(ptr, ptr)

declare i64 @forge_file_exists(ptr)

declare ptr @forge_intmap_new()

declare void @forge_intmap_set(ptr, i64, i64)

declare i64 @forge_intmap_get(ptr, i64)

declare i64 @forge_intmap_has(ptr, i64)

declare i64 @forge_float_parse(ptr)

declare i64 @forge_float_to_string(i64)

declare ptr @forge_format_float(i64, ptr)

declare ptr @forge_format_int(i64, ptr)

declare void @forge_ptr_store_byte(ptr, i64, i64)

declare i64 @forge_string_from_ptr(ptr, i64)

declare i64 @forge_trait_object_new(ptr, i64)

declare i64 @forge_trait_object_value(ptr)

declare ptr @forge_trait_object_vtable(ptr)

declare i64 @forge_datetime_now()

declare i64 @forge_datetime_format(ptr, i64)

declare i64 @forge_datetime_year(ptr)

declare i64 @forge_datetime_month(ptr)

declare i64 @forge_datetime_day(ptr)

declare i64 @forge_datetime_hour(ptr)

declare i64 @forge_datetime_minute(ptr)

declare i64 @forge_datetime_second(ptr)

declare ptr @forge_json_stringify_int(ptr)

declare ptr @forge_json_stringify_string(ptr)

declare ptr @forge_json_stringify_bool(ptr)

declare i64 @forge_json_get_int(ptr, i64)

declare i64 @forge_json_get_string(ptr, i64)

declare i64 @forge_json_get_bool(ptr, i64)

declare i64 @forge_semver_major(ptr)

declare i64 @forge_semver_minor(ptr)

declare i64 @forge_semver_patch(ptr)

declare i64 @forge_semver_compare(ptr, i64)

declare i64 @forge_validate_not_null(ptr, i64)

declare i64 @forge_validate_positive(ptr, i64)

declare i64 @forge_validate_not_empty(ptr, i64)

declare i64 @forge_toml_get_string(ptr, i64)

declare i64 @forge_toml_get_int(ptr, i64)

declare i64 @forge_toml_get_bool(ptr, i64)

declare i64 @forge_toml_get_section_string(ptr, i64, i64)

declare i64 @forge_toml_has_section(ptr, i64)

declare i64 @forge_spawn(ptr)

declare i64 @forge_task_await(ptr)

declare i32 @forge_thread_join(ptr)

declare void @forge_yield()

declare void @forge_scheduler_run()

declare ptr @forge_task_group_new()

declare void @forge_task_group_add(ptr, ptr)

declare void @forge_task_group_await_all(ptr)

declare ptr @forge_channel_new()

declare void @forge_channel_send(ptr, i64)

declare i64 @forge_channel_recv(ptr)

declare i32 @forge_channel_close(ptr)

declare i32 @forge_parallel_run(ptr)

declare i64 @forge_select(ptr, i64)

declare i64 @forge_select_index(ptr)

declare i64 @forge_select_value(ptr)

declare i32 @forge_test_start_spec(ptr)

declare i32 @forge_test_end_spec(ptr)

declare i32 @forge_test_start_given(ptr)

declare i32 @forge_test_end_given(ptr)

declare i64 @forge_test_run_then(ptr, i64)

declare i32 @forge_test_skip(ptr)

declare i32 @forge_test_todo(ptr)

declare i32 @forge_test_summary()

declare void @forge_test_flush()

declare ptr @forge_arena_new()

declare ptr @forge_arena_alloc(ptr, i64)

declare void @forge_arena_destroy(ptr)

declare void @forge_match_unreachable(ptr, i64, ptr, i64)

declare i32 @forge_llvm_is_ptr_value(ptr)

declare ptr @forge_llvm_typeof(ptr)

declare ptr @forge_llvm_cast_to_type(ptr, ptr, ptr)

declare i32 @forge_llvm_is_void_value(ptr)

declare void @forge_llvm_build_store_cast(ptr, ptr, ptr)

declare i32 @forge_llvm_verify_function(ptr)

declare i64 @forge_llvm_type_kind(ptr)

declare i64 @forge_llvm_int_type_width(ptr)

declare ptr @forge_llvm_build_call_coerce(ptr, ptr, ptr, ptr, i64, ptr)

declare i64 @forge_test_roughly(double, double, double)

define ptr @rcl_make_power(i64 %0) {
entry:
  %sub13 = alloca ptr, align 8
  %exp = alloca i64, align 8
  store i64 %0, ptr %exp, align 8
  %exp1 = load i64, ptr %exp, align 8
  %eq = icmp eq i64 %exp1, 0
  %eq_ext = zext i1 %eq to i64
  %if_cond = icmp ne i64 %eq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %exp3 = load i64, ptr %exp, align 8
  %eq4 = icmp eq i64 %exp3, 1
  %eq_ext5 = zext i1 %eq4 to i64
  %if_cond7 = icmp ne i64 %eq_ext5, 0
  br i1 %if_cond7, label %if_then8, label %if_else9

if_then:                                          ; preds = %entry
  %1 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %1, i64 -559038737)
  call void @forge_array_push(ptr %1, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast = ptrtoint ptr %1 to i64
  %cast2 = inttoptr i64 %cast to ptr
  ret ptr %cast2

if_else:                                          ; preds = %entry
  br label %ifcont

ifcont6:                                          ; preds = %if_else9
  %exp12 = load i64, ptr %exp, align 8
  %sub = sub i64 %exp12, 1
  %2 = call ptr @rcl_make_power(i64 %sub)
  store ptr %2, ptr %sub13, align 8
  %3 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %3, i64 -559038737)
  call void @forge_array_push(ptr %3, i64 ptrtoint (ptr @__lambda_2 to i64))
  %cap_val = load i64, ptr %sub13, align 8
  call void @forge_array_push(ptr %3, i64 %cap_val)
  %cast14 = ptrtoint ptr %3 to i64
  %cast15 = inttoptr i64 %cast14 to ptr
  ret ptr %cast15

if_then8:                                         ; preds = %ifcont
  %4 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %4, i64 -559038737)
  call void @forge_array_push(ptr %4, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cast10 = ptrtoint ptr %4 to i64
  %cast11 = inttoptr i64 %cast10 to ptr
  ret ptr %cast11

if_else9:                                         ; preds = %ifcont
  br label %ifcont6
}

define i64 @main() {
entry:
  %0 = call ptr @rcl_make_power(i64 2)
  store ptr %0, ptr @rcl_square, align 8
  %1 = call ptr @rcl_make_power(i64 3)
  store ptr %1, ptr @rcl_cube, align 8
  %2 = call i32 @forge_test_start_spec(ptr @spec_str)
  %widen = sext i32 %2 to i64
  %rcl_square = load i64, ptr @rcl_square, align 8
  %3 = call i64 @forge_closure_call_1(i64 %rcl_square, i64 5)
  %eq = icmp eq i64 %3, 25
  %eq_ext = zext i1 %eq to i64
  %4 = call i64 @forge_test_run_then(ptr @spec_str.1, i64 %eq_ext)
  %rcl_cube = load i64, ptr @rcl_cube, align 8
  %5 = call i64 @forge_closure_call_1(i64 %rcl_cube, i64 3)
  %eq1 = icmp eq i64 %5, 27
  %eq_ext2 = zext i1 %eq1 to i64
  %6 = call i64 @forge_test_run_then(ptr @spec_str.2, i64 %eq_ext2)
  %7 = call i32 @forge_test_end_spec(ptr @spec_str)
  %widen3 = sext i32 %7 to i64
  %8 = call i32 @forge_test_summary()
  %widen4 = sext i32 %8 to i64
  call void @forge_rc_collect()
  ret i64 0
}

define i64 @__lambda_0(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  ret i64 1
}

define i64 @__lambda_1(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  ret i64 %x1
}

define i64 @__lambda_2(i64 %0, i64 %1) {
entry:
  %sub = alloca ptr, align 8
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %cast = inttoptr i64 %1 to ptr
  store ptr %cast, ptr %sub, align 8
  %x1 = load i64, ptr %x, align 8
  %sub2 = load i64, ptr %sub, align 8
  %x3 = load i64, ptr %x, align 8
  %2 = call i64 @forge_closure_call_1(i64 %sub2, i64 %x3)
  %mul = mul i64 %x1, %2
  ret i64 %mul
}
