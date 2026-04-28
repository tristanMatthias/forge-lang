; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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
  %0 = call i64 @__bs_top_level()
  %big = alloca ptr, align 8
  %x10 = alloca i64, align 8
  %forin_i9 = alloca i64, align 8
  %forin_len8 = alloca i64, align 8
  %__lc6 = alloca ptr, align 8
  %all = alloca ptr, align 8
  %doubled = alloca ptr, align 8
  %x = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %__lc = alloca ptr, align 8
  %nums = alloca ptr, align 8
  %1 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %1, i64 1)
  call void @avra_array_push(ptr %1, i64 2)
  call void @avra_array_push(ptr %1, i64 3)
  store ptr %1, ptr %nums, align 8
  %2 = call ptr @avra_array_new()
  store ptr %2, ptr %__lc, align 8
  %nums1 = load ptr, ptr %nums, align 8
  %3 = call i64 @avra_array_len(ptr %nums1)
  store i64 %3, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %entry
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %4 = call i64 @avra_array_get(ptr %nums1, i64 %forin_i_val)
  store i64 %4, ptr %x, align 8
  %__lc2 = load ptr, ptr %__lc, align 8
  %x3 = load i64, ptr %x, align 8
  %mul = mul i64 %x3, 2
  call void @avra_array_push(ptr %__lc2, i64 %mul)
  br label %forin.incr

forin.incr:                                       ; preds = %forin.body
  %forin_i_old = load i64, ptr %forin_i, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  %__lc4 = load ptr, ptr %__lc, align 8
  store ptr %__lc4, ptr %doubled, align 8
  %doubled5 = load ptr, ptr %doubled, align 8
  %5 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %5, i64 -559038737)
  call void @avra_array_push(ptr %5, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast = ptrtoint ptr %5 to i64
  call void @avra_array_foreach(ptr %doubled5, i64 %cast)
  %6 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %6, i64 1)
  call void @avra_array_push(ptr %6, i64 2)
  call void @avra_array_push(ptr %6, i64 3)
  call void @avra_array_push(ptr %6, i64 4)
  call void @avra_array_push(ptr %6, i64 5)
  store ptr %6, ptr %all, align 8
  %7 = call ptr @avra_array_new()
  store ptr %7, ptr %__lc6, align 8
  %all7 = load ptr, ptr %all, align 8
  %8 = call i64 @avra_array_len(ptr %all7)
  store i64 %8, ptr %forin_len8, align 8
  store i64 0, ptr %forin_i9, align 8
  br label %forin.cond11

forin.cond11:                                     ; preds = %forin.incr13, %forin.exit
  %forin_i_val15 = load i64, ptr %forin_i9, align 8
  %forin_len_val16 = load i64, ptr %forin_len8, align 8
  %forin_cmp17 = icmp slt i64 %forin_i_val15, %forin_len_val16
  br i1 %forin_cmp17, label %forin.body12, label %forin.exit14

forin.body12:                                     ; preds = %forin.cond11
  %9 = call i64 @avra_array_get(ptr %all7, i64 %forin_i_val15)
  store i64 %9, ptr %x10, align 8
  %x18 = load i64, ptr %x10, align 8
  %sgt = icmp sgt i64 %x18, 3
  %sgt_ext = zext i1 %sgt to i64
  %if_cond = icmp ne i64 %sgt_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

forin.incr13:                                     ; preds = %ifcont
  %forin_i_old21 = load i64, ptr %forin_i9, align 8
  %forin_next22 = add i64 %forin_i_old21, 1
  store i64 %forin_next22, ptr %forin_i9, align 8
  br label %forin.cond11

forin.exit14:                                     ; preds = %forin.cond11
  %__lc23 = load ptr, ptr %__lc6, align 8
  store ptr %__lc23, ptr %big, align 8
  %big24 = load ptr, ptr %big, align 8
  %10 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %10, i64 -559038737)
  call void @avra_array_push(ptr %10, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cast25 = ptrtoint ptr %10 to i64
  call void @avra_array_foreach(ptr %big24, i64 %cast25)
  ret i64 0

ifcont:                                           ; preds = %if_else, %if_then
  br label %forin.incr13

if_then:                                          ; preds = %forin.body12
  %__lc19 = load ptr, ptr %__lc6, align 8
  %x20 = load i64, ptr %x10, align 8
  call void @avra_array_push(ptr %__lc19, i64 %x20)
  br label %ifcont

if_else:                                          ; preds = %forin.body12
  br label %ifcont
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__lambda_0(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %x1)
  %widen = sext i32 %2 to i64
  %3 = call i32 @puts(ptr %1)
  %widen2 = sext i32 %3 to i64
  ret i64 0
}

define i64 @__lambda_1(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt.1, i64 %x1)
  %widen = sext i32 %2 to i64
  %3 = call i32 @puts(ptr %1)
  %widen2 = sext i32 %3 to i64
  ret i64 0
}
