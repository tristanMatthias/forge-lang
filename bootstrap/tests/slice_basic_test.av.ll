; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@spec_str = private unnamed_addr constant [14 x i8] c"\22slice basic\22\00", align 1
@spec_str.1 = private unnamed_addr constant [19 x i8] c"\22mid slice length\22\00", align 1
@spec_str.2 = private unnamed_addr constant [18 x i8] c"\22mid slice first\22\00", align 1
@spec_str.3 = private unnamed_addr constant [17 x i8] c"\22mid slice last\22\00", align 1
@spec_str.4 = private unnamed_addr constant [19 x i8] c"\22slice from start\22\00", align 1
@spec_str.5 = private unnamed_addr constant [15 x i8] c"\22slice to end\22\00", align 1
@spec_str.6 = private unnamed_addr constant [14 x i8] c"\22empty slice\22\00", align 1
@spec_str.7 = private unnamed_addr constant [18 x i8] c"\22full slice copy\22\00", align 1

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

define i64 @slb_mid_len() {
entry:
  %mid = alloca ptr, align 8
  %nums = alloca ptr, align 8
  %0 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %0, i64 10)
  call void @forge_array_push(ptr %0, i64 20)
  call void @forge_array_push(ptr %0, i64 30)
  call void @forge_array_push(ptr %0, i64 40)
  call void @forge_array_push(ptr %0, i64 50)
  store ptr %0, ptr %nums, align 8
  %nums1 = load ptr, ptr %nums, align 8
  %1 = call ptr @forge_array_slice(ptr %nums1, i64 1, i64 4)
  store ptr %1, ptr %mid, align 8
  %mid2 = load ptr, ptr %mid, align 8
  %2 = call i64 @forge_array_len(ptr %mid2)
  ret i64 %2
}

define i64 @slb_mid_first() {
entry:
  %mid = alloca ptr, align 8
  %nums = alloca ptr, align 8
  %0 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %0, i64 10)
  call void @forge_array_push(ptr %0, i64 20)
  call void @forge_array_push(ptr %0, i64 30)
  call void @forge_array_push(ptr %0, i64 40)
  call void @forge_array_push(ptr %0, i64 50)
  store ptr %0, ptr %nums, align 8
  %nums1 = load ptr, ptr %nums, align 8
  %1 = call ptr @forge_array_slice(ptr %nums1, i64 1, i64 4)
  store ptr %1, ptr %mid, align 8
  %mid2 = load ptr, ptr %mid, align 8
  %2 = call i64 @forge_array_get(ptr %mid2, i64 0)
  ret i64 %2
}

define i64 @slb_mid_last() {
entry:
  %mid = alloca ptr, align 8
  %nums = alloca ptr, align 8
  %0 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %0, i64 10)
  call void @forge_array_push(ptr %0, i64 20)
  call void @forge_array_push(ptr %0, i64 30)
  call void @forge_array_push(ptr %0, i64 40)
  call void @forge_array_push(ptr %0, i64 50)
  store ptr %0, ptr %nums, align 8
  %nums1 = load ptr, ptr %nums, align 8
  %1 = call ptr @forge_array_slice(ptr %nums1, i64 1, i64 4)
  store ptr %1, ptr %mid, align 8
  %mid2 = load ptr, ptr %mid, align 8
  %2 = call i64 @forge_array_get(ptr %mid2, i64 2)
  ret i64 %2
}

define i64 @slb_from_start_len() {
entry:
  %first2 = alloca ptr, align 8
  %nums = alloca ptr, align 8
  %0 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %0, i64 10)
  call void @forge_array_push(ptr %0, i64 20)
  call void @forge_array_push(ptr %0, i64 30)
  call void @forge_array_push(ptr %0, i64 40)
  call void @forge_array_push(ptr %0, i64 50)
  store ptr %0, ptr %nums, align 8
  %nums1 = load ptr, ptr %nums, align 8
  %1 = call ptr @forge_array_slice(ptr %nums1, i64 0, i64 2)
  store ptr %1, ptr %first2, align 8
  %first22 = load ptr, ptr %first2, align 8
  %2 = call i64 @forge_array_len(ptr %first22)
  ret i64 %2
}

define i64 @slb_to_end_val() {
entry:
  %last2 = alloca ptr, align 8
  %nums = alloca ptr, align 8
  %0 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %0, i64 10)
  call void @forge_array_push(ptr %0, i64 20)
  call void @forge_array_push(ptr %0, i64 30)
  call void @forge_array_push(ptr %0, i64 40)
  call void @forge_array_push(ptr %0, i64 50)
  store ptr %0, ptr %nums, align 8
  %nums1 = load ptr, ptr %nums, align 8
  %1 = call ptr @forge_array_slice(ptr %nums1, i64 3, i64 5)
  store ptr %1, ptr %last2, align 8
  %last22 = load ptr, ptr %last2, align 8
  %2 = call i64 @forge_array_get(ptr %last22, i64 0)
  ret i64 %2
}

define i64 @slb_empty_len() {
entry:
  %empty_s = alloca ptr, align 8
  %nums = alloca ptr, align 8
  %0 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %0, i64 10)
  call void @forge_array_push(ptr %0, i64 20)
  call void @forge_array_push(ptr %0, i64 30)
  call void @forge_array_push(ptr %0, i64 40)
  call void @forge_array_push(ptr %0, i64 50)
  store ptr %0, ptr %nums, align 8
  %nums1 = load ptr, ptr %nums, align 8
  %1 = call ptr @forge_array_slice(ptr %nums1, i64 2, i64 2)
  store ptr %1, ptr %empty_s, align 8
  %empty_s2 = load ptr, ptr %empty_s, align 8
  %2 = call i64 @forge_array_len(ptr %empty_s2)
  ret i64 %2
}

define i64 @slb_full_copy_len() {
entry:
  %copy = alloca ptr, align 8
  %nums = alloca ptr, align 8
  %0 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %0, i64 10)
  call void @forge_array_push(ptr %0, i64 20)
  call void @forge_array_push(ptr %0, i64 30)
  call void @forge_array_push(ptr %0, i64 40)
  call void @forge_array_push(ptr %0, i64 50)
  store ptr %0, ptr %nums, align 8
  %nums1 = load ptr, ptr %nums, align 8
  %1 = call ptr @forge_array_slice(ptr %nums1, i64 0, i64 5)
  store ptr %1, ptr %copy, align 8
  %copy2 = load ptr, ptr %copy, align 8
  %2 = call i64 @forge_array_len(ptr %copy2)
  ret i64 %2
}

define i64 @main() {
entry:
  %0 = call i32 @forge_test_start_spec(ptr @spec_str)
  %widen = sext i32 %0 to i64
  %1 = call i64 @slb_mid_len()
  %eq = icmp eq i64 %1, 3
  %eq_ext = zext i1 %eq to i64
  %2 = call i64 @forge_test_run_then(ptr @spec_str.1, i64 %eq_ext)
  %3 = call i64 @slb_mid_first()
  %eq1 = icmp eq i64 %3, 20
  %eq_ext2 = zext i1 %eq1 to i64
  %4 = call i64 @forge_test_run_then(ptr @spec_str.2, i64 %eq_ext2)
  %5 = call i64 @slb_mid_last()
  %eq3 = icmp eq i64 %5, 40
  %eq_ext4 = zext i1 %eq3 to i64
  %6 = call i64 @forge_test_run_then(ptr @spec_str.3, i64 %eq_ext4)
  %7 = call i64 @slb_from_start_len()
  %eq5 = icmp eq i64 %7, 2
  %eq_ext6 = zext i1 %eq5 to i64
  %8 = call i64 @forge_test_run_then(ptr @spec_str.4, i64 %eq_ext6)
  %9 = call i64 @slb_to_end_val()
  %eq7 = icmp eq i64 %9, 40
  %eq_ext8 = zext i1 %eq7 to i64
  %10 = call i64 @forge_test_run_then(ptr @spec_str.5, i64 %eq_ext8)
  %11 = call i64 @slb_empty_len()
  %eq9 = icmp eq i64 %11, 0
  %eq_ext10 = zext i1 %eq9 to i64
  %12 = call i64 @forge_test_run_then(ptr @spec_str.6, i64 %eq_ext10)
  %13 = call i64 @slb_full_copy_len()
  %eq11 = icmp eq i64 %13, 5
  %eq_ext12 = zext i1 %eq11 to i64
  %14 = call i64 @forge_test_run_then(ptr @spec_str.7, i64 %eq_ext12)
  %15 = call i32 @forge_test_end_spec(ptr @spec_str)
  %widen13 = sext i32 %15 to i64
  %16 = call i32 @forge_test_summary()
  %widen14 = sext i32 %16 to i64
  call void @forge_rc_collect()
  ret i64 0
}
