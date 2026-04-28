; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str = private unnamed_addr constant [8 x i8] c": even=\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.2 = private unnamed_addr constant [6 x i8] c" odd=\00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define i64 @is_even(i64 %0) {
entry:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  %n1 = load i64, ptr %n, align 8
  %eq = icmp eq i64 %n1, 0
  %eq_ext = zext i1 %eq to i64
  %if_cond = icmp ne i64 %eq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %n2 = load i64, ptr %n, align 8
  %slt = icmp slt i64 %n2, 0
  %slt_ext = zext i1 %slt to i64
  %if_cond4 = icmp ne i64 %slt_ext, 0
  br i1 %if_cond4, label %if_then5, label %if_else6

if_then:                                          ; preds = %entry
  ret i64 1

if_else:                                          ; preds = %entry
  br label %ifcont

ifcont3:                                          ; preds = %if_else6
  %n8 = load i64, ptr %n, align 8
  %sub = sub i64 %n8, 1
  %1 = call i64 @is_odd(i64 %sub)
  ret i64 %1

if_then5:                                         ; preds = %ifcont
  %n7 = load i64, ptr %n, align 8
  %neg = sub i64 0, %n7
  %2 = call i64 @is_even(i64 %neg)
  ret i64 %2

if_else6:                                         ; preds = %ifcont
  br label %ifcont3
}

define i64 @is_odd(i64 %0) {
entry:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  %n1 = load i64, ptr %n, align 8
  %eq = icmp eq i64 %n1, 0
  %eq_ext = zext i1 %eq to i64
  %if_cond = icmp ne i64 %eq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %n2 = load i64, ptr %n, align 8
  %slt = icmp slt i64 %n2, 0
  %slt_ext = zext i1 %slt to i64
  %if_cond4 = icmp ne i64 %slt_ext, 0
  br i1 %if_cond4, label %if_then5, label %if_else6

if_then:                                          ; preds = %entry
  ret i64 0

if_else:                                          ; preds = %entry
  br label %ifcont

ifcont3:                                          ; preds = %if_else6
  %n8 = load i64, ptr %n, align 8
  %sub = sub i64 %n8, 1
  %1 = call i64 @is_even(i64 %sub)
  ret i64 %1

if_then5:                                         ; preds = %ifcont
  %n7 = load i64, ptr %n, align 8
  %neg = sub i64 0, %n7
  %2 = call i64 @is_odd(i64 %neg)
  ret i64 %2

if_else6:                                         ; preds = %ifcont
  br label %ifcont3
}

define i64 @main() {
entry:
  %for_end = alloca i64, align 8
  %i = alloca i64, align 8
  store i64 0, ptr %i, align 8
  store i64 8, ptr %for_end, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.incr, %entry
  %i1 = load i64, ptr %i, align 8
  %for_end_val = load i64, ptr %for_end, align 8
  %for_cmp = icmp slt i64 %i1, %for_end_val
  br i1 %for_cmp, label %for.body, label %for.exit

for.body:                                         ; preds = %for.cond
  %i2 = load i64, ptr %i, align 8
  %0 = call ptr @avra_rc_alloc(i64 32)
  %1 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %0, i64 32, ptr @.i2s_fmt, i64 %i2)
  %widen = sext i32 %1 to i64
  %2 = call i64 @strlen(ptr %0)
  %3 = call i64 @strlen(ptr @.str)
  %concat_total = add i64 %2, %3
  %concat_size = add i64 %concat_total, 1
  %4 = call ptr @avra_rc_alloc(i64 %concat_size)
  %5 = call ptr @memcpy(ptr %4, ptr %0, i64 %2)
  %cast = ptrtoint ptr %4 to i64
  %dst2_int = add i64 %cast, %2
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %3, 1
  %6 = call ptr @memcpy(ptr %cast3, ptr @.str, i64 %rhs_len_p1)
  %i4 = load i64, ptr %i, align 8
  %7 = call i64 @is_even(i64 %i4)
  %8 = call ptr @avra_rc_alloc(i64 32)
  %9 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %8, i64 32, ptr @.i2s_fmt.1, i64 %7)
  %widen5 = sext i32 %9 to i64
  %10 = call i64 @strlen(ptr %4)
  %11 = call i64 @strlen(ptr %8)
  %concat_total6 = add i64 %10, %11
  %concat_size7 = add i64 %concat_total6, 1
  %12 = call ptr @avra_rc_alloc(i64 %concat_size7)
  %13 = call ptr @memcpy(ptr %12, ptr %4, i64 %10)
  %cast8 = ptrtoint ptr %12 to i64
  %dst2_int9 = add i64 %cast8, %10
  %cast10 = inttoptr i64 %dst2_int9 to ptr
  %rhs_len_p111 = add i64 %11, 1
  %14 = call ptr @memcpy(ptr %cast10, ptr %8, i64 %rhs_len_p111)
  %15 = call i64 @strlen(ptr %12)
  %16 = call i64 @strlen(ptr @.str.2)
  %concat_total12 = add i64 %15, %16
  %concat_size13 = add i64 %concat_total12, 1
  %17 = call ptr @avra_rc_alloc(i64 %concat_size13)
  %18 = call ptr @memcpy(ptr %17, ptr %12, i64 %15)
  %cast14 = ptrtoint ptr %17 to i64
  %dst2_int15 = add i64 %cast14, %15
  %cast16 = inttoptr i64 %dst2_int15 to ptr
  %rhs_len_p117 = add i64 %16, 1
  %19 = call ptr @memcpy(ptr %cast16, ptr @.str.2, i64 %rhs_len_p117)
  %i18 = load i64, ptr %i, align 8
  %20 = call i64 @is_odd(i64 %i18)
  %21 = call ptr @avra_rc_alloc(i64 32)
  %22 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %21, i64 32, ptr @.i2s_fmt.3, i64 %20)
  %widen19 = sext i32 %22 to i64
  %23 = call i64 @strlen(ptr %17)
  %24 = call i64 @strlen(ptr %21)
  %concat_total20 = add i64 %23, %24
  %concat_size21 = add i64 %concat_total20, 1
  %25 = call ptr @avra_rc_alloc(i64 %concat_size21)
  %26 = call ptr @memcpy(ptr %25, ptr %17, i64 %23)
  %cast22 = ptrtoint ptr %25 to i64
  %dst2_int23 = add i64 %cast22, %23
  %cast24 = inttoptr i64 %dst2_int23 to ptr
  %rhs_len_p125 = add i64 %24, 1
  %27 = call ptr @memcpy(ptr %cast24, ptr %21, i64 %rhs_len_p125)
  %28 = call i32 @puts(ptr %25)
  %widen26 = sext i32 %28 to i64
  br label %for.incr

for.incr:                                         ; preds = %for.body
  %i27 = load i64, ptr %i, align 8
  %for_next = add i64 %i27, 1
  store i64 %for_next, ptr %i, align 8
  br label %for.cond

for.exit:                                         ; preds = %for.cond
  %29 = call i32 @avra_test_summary()
  %widen28 = sext i32 %29 to i64
  call void @avra_rc_collect()
  ret i64 0
}
