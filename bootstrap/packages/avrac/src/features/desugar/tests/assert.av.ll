; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@.str = private unnamed_addr constant [19 x i8] c"x must be positive\00", align 1
@.panic_prefix = private unnamed_addr constant [8 x i8] c"panic: \00", align 1
@.str.1 = private unnamed_addr constant [17 x i8] c"assertion failed\00", align 1
@.panic_prefix.2 = private unnamed_addr constant [8 x i8] c"panic: \00", align 1
@.str.3 = private unnamed_addr constant [11 x i8] c"pass_basic\00", align 1
@.str.4 = private unnamed_addr constant [17 x i8] c"assertion failed\00", align 1
@.panic_prefix.5 = private unnamed_addr constant [8 x i8] c"panic: \00", align 1
@.str.6 = private unnamed_addr constant [10 x i8] c"pass_expr\00", align 1
@.str.7 = private unnamed_addr constant [32 x i8] c"ten should be greater than five\00", align 1
@.panic_prefix.8 = private unnamed_addr constant [8 x i8] c"panic: \00", align 1
@.str.9 = private unnamed_addr constant [13 x i8] c"pass_message\00", align 1
@.str.10 = private unnamed_addr constant [17 x i8] c"assertion failed\00", align 1
@.panic_prefix.11 = private unnamed_addr constant [8 x i8] c"panic: \00", align 1
@.str.12 = private unnamed_addr constant [14 x i8] c"pass_variable\00", align 1
@.str.13 = private unnamed_addr constant [17 x i8] c"pass_in_function\00", align 1

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

define i1 @check(i64 %0) {
entry:
  %ife_result = alloca i64, align 8
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %sgt = icmp sgt i64 %x1, 0
  %sgt_ext = zext i1 %sgt to i64
  %not_cmp = icmp eq i64 %sgt_ext, 0
  %not_cmp_ext = zext i1 %not_cmp to i64
  %ife_cond = icmp ne i64 %not_cmp_ext, 0
  br i1 %ife_cond, label %ife_then, label %ife_else

ife_end:                                          ; preds = %ife_else, %ife_then
  %ife_val = load i64, ptr %ife_result, align 8
  ret i1 true

ife_then:                                         ; preds = %entry
  %1 = call i64 @strlen(ptr @.panic_prefix)
  %2 = call i64 @strlen(ptr @.str)
  %concat_total = add i64 %1, %2
  %concat_size = add i64 %concat_total, 1
  %3 = call ptr @avra_rc_alloc(i64 %concat_size)
  %4 = call ptr @memcpy(ptr %3, ptr @.panic_prefix, i64 %1)
  %cast = ptrtoint ptr %3 to i64
  %dst2_int = add i64 %cast, %1
  %cast2 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %2, 1
  %5 = call ptr @memcpy(ptr %cast2, ptr @.str, i64 %rhs_len_p1)
  call void @avra_eprintln(ptr %3)
  call void @exit(i32 1)
  store i64 0, ptr %ife_result, align 8
  br label %ife_end

ife_else:                                         ; preds = %entry
  store i64 0, ptr %ife_result, align 8
  br label %ife_end
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %ife_result27 = alloca i64, align 8
  %x = alloca i64, align 8
  %ife_result14 = alloca i64, align 8
  %ife_result2 = alloca i64, align 8
  %ife_result = alloca i64, align 8
  br i1 false, label %ife_then, label %ife_else

ife_end:                                          ; preds = %ife_else, %ife_then
  %ife_val = load i64, ptr %ife_result, align 8
  %1 = call i32 @puts(ptr @.str.3)
  %widen = sext i32 %1 to i64
  br i1 false, label %ife_then4, label %ife_else5

ife_then:                                         ; preds = %entry
  %2 = call i64 @strlen(ptr @.panic_prefix.2)
  %3 = call i64 @strlen(ptr @.str.1)
  %concat_total = add i64 %2, %3
  %concat_size = add i64 %concat_total, 1
  %4 = call ptr @avra_rc_alloc(i64 %concat_size)
  %5 = call ptr @memcpy(ptr %4, ptr @.panic_prefix.2, i64 %2)
  %cast = ptrtoint ptr %4 to i64
  %dst2_int = add i64 %cast, %2
  %cast1 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %3, 1
  %6 = call ptr @memcpy(ptr %cast1, ptr @.str.1, i64 %rhs_len_p1)
  call void @avra_eprintln(ptr %4)
  call void @exit(i32 1)
  store i64 0, ptr %ife_result, align 8
  br label %ife_end

ife_else:                                         ; preds = %entry
  store i64 0, ptr %ife_result, align 8
  br label %ife_end

ife_end3:                                         ; preds = %ife_else5, %ife_then4
  %ife_val12 = load i64, ptr %ife_result2, align 8
  %7 = call i32 @puts(ptr @.str.6)
  %widen13 = sext i32 %7 to i64
  br i1 false, label %ife_then16, label %ife_else17

ife_then4:                                        ; preds = %ife_end
  %8 = call i64 @strlen(ptr @.panic_prefix.5)
  %9 = call i64 @strlen(ptr @.str.4)
  %concat_total6 = add i64 %8, %9
  %concat_size7 = add i64 %concat_total6, 1
  %10 = call ptr @avra_rc_alloc(i64 %concat_size7)
  %11 = call ptr @memcpy(ptr %10, ptr @.panic_prefix.5, i64 %8)
  %cast8 = ptrtoint ptr %10 to i64
  %dst2_int9 = add i64 %cast8, %8
  %cast10 = inttoptr i64 %dst2_int9 to ptr
  %rhs_len_p111 = add i64 %9, 1
  %12 = call ptr @memcpy(ptr %cast10, ptr @.str.4, i64 %rhs_len_p111)
  call void @avra_eprintln(ptr %10)
  call void @exit(i32 1)
  store i64 0, ptr %ife_result2, align 8
  br label %ife_end3

ife_else5:                                        ; preds = %ife_end
  store i64 0, ptr %ife_result2, align 8
  br label %ife_end3

ife_end15:                                        ; preds = %ife_else17, %ife_then16
  %ife_val24 = load i64, ptr %ife_result14, align 8
  %13 = call i32 @puts(ptr @.str.9)
  %widen25 = sext i32 %13 to i64
  store i64 42, ptr %x, align 8
  %x26 = load i64, ptr %x, align 8
  %sgt = icmp sgt i64 %x26, 0
  %sgt_ext = zext i1 %sgt to i64
  %not_cmp = icmp eq i64 %sgt_ext, 0
  %not_cmp_ext = zext i1 %not_cmp to i64
  %ife_cond = icmp ne i64 %not_cmp_ext, 0
  br i1 %ife_cond, label %ife_then29, label %ife_else30

ife_then16:                                       ; preds = %ife_end3
  %14 = call i64 @strlen(ptr @.panic_prefix.8)
  %15 = call i64 @strlen(ptr @.str.7)
  %concat_total18 = add i64 %14, %15
  %concat_size19 = add i64 %concat_total18, 1
  %16 = call ptr @avra_rc_alloc(i64 %concat_size19)
  %17 = call ptr @memcpy(ptr %16, ptr @.panic_prefix.8, i64 %14)
  %cast20 = ptrtoint ptr %16 to i64
  %dst2_int21 = add i64 %cast20, %14
  %cast22 = inttoptr i64 %dst2_int21 to ptr
  %rhs_len_p123 = add i64 %15, 1
  %18 = call ptr @memcpy(ptr %cast22, ptr @.str.7, i64 %rhs_len_p123)
  call void @avra_eprintln(ptr %16)
  call void @exit(i32 1)
  store i64 0, ptr %ife_result14, align 8
  br label %ife_end15

ife_else17:                                       ; preds = %ife_end3
  store i64 0, ptr %ife_result14, align 8
  br label %ife_end15

ife_end28:                                        ; preds = %ife_else30, %ife_then29
  %ife_val37 = load i64, ptr %ife_result27, align 8
  %19 = call i32 @puts(ptr @.str.12)
  %widen38 = sext i32 %19 to i64
  %20 = call i1 @check(i64 10)
  %widen39 = zext i1 %20 to i64
  %21 = call i32 @puts(ptr @.str.13)
  %widen40 = sext i32 %21 to i64
  ret i64 0

ife_then29:                                       ; preds = %ife_end15
  %22 = call i64 @strlen(ptr @.panic_prefix.11)
  %23 = call i64 @strlen(ptr @.str.10)
  %concat_total31 = add i64 %22, %23
  %concat_size32 = add i64 %concat_total31, 1
  %24 = call ptr @avra_rc_alloc(i64 %concat_size32)
  %25 = call ptr @memcpy(ptr %24, ptr @.panic_prefix.11, i64 %22)
  %cast33 = ptrtoint ptr %24 to i64
  %dst2_int34 = add i64 %cast33, %22
  %cast35 = inttoptr i64 %dst2_int34 to ptr
  %rhs_len_p136 = add i64 %23, 1
  %26 = call ptr @memcpy(ptr %cast35, ptr @.str.10, i64 %rhs_len_p136)
  call void @avra_eprintln(ptr %24)
  call void @exit(i32 1)
  store i64 0, ptr %ife_result27, align 8
  br label %ife_end28

ife_else30:                                       ; preds = %ife_end15
  store i64 0, ptr %ife_result27, align 8
  br label %ife_end28
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}
