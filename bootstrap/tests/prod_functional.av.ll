; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@inc = global i64 0
@dbl = global i64 0
@sqr = global i64 0
@inc_then_dbl = global i64 0
@dbl_then_sqr = global i64 0
@nums = global i64 0
@results = global i64 0
@words = global i64 0
@sentence = global i64 0
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.3 = private unnamed_addr constant [6 x i8] c"world\00", align 1
@.str.4 = private unnamed_addr constant [5 x i8] c"from\00", align 1
@.str.5 = private unnamed_addr constant [5 x i8] c"avra\00", align 1
@.str.6 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.7 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.8 = private unnamed_addr constant [2 x i8] c" \00", align 1

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

define ptr @compose(ptr %0, ptr %1) {
entry:
  %g = alloca ptr, align 8
  %f = alloca ptr, align 8
  store ptr %0, ptr %f, align 8
  store ptr %1, ptr %g, align 8
  %2 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %2, i64 -559038737)
  call void @avra_array_push(ptr %2, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cap_val = load i64, ptr %g, align 8
  call void @avra_array_push(ptr %2, i64 %cap_val)
  %cap_val1 = load i64, ptr %f, align 8
  call void @avra_array_push(ptr %2, i64 %cap_val1)
  %cast = ptrtoint ptr %2 to i64
  %cast2 = inttoptr i64 %cast to ptr
  ret ptr %cast2
}

define i64 @pipe2(i64 %0, ptr %1, ptr %2) {
entry:
  %g = alloca ptr, align 8
  %f = alloca ptr, align 8
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  store ptr %1, ptr %f, align 8
  store ptr %2, ptr %g, align 8
  %g1 = load i64, ptr %g, align 8
  %f2 = load i64, ptr %f, align 8
  %x3 = load i64, ptr %x, align 8
  %3 = call i64 @avra_closure_call_1(i64 %f2, i64 %x3)
  %4 = call i64 @avra_closure_call_1(i64 %g1, i64 %3)
  ret i64 %4
}

define i64 @main() {
entry:
  %r = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %0 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %0, i64 -559038737)
  call void @avra_array_push(ptr %0, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cast = ptrtoint ptr %0 to i64
  store i64 %cast, ptr @inc, align 8
  %1 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %1, i64 -559038737)
  call void @avra_array_push(ptr %1, i64 ptrtoint (ptr @__lambda_2 to i64))
  %cast1 = ptrtoint ptr %1 to i64
  store i64 %cast1, ptr @dbl, align 8
  %2 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %2, i64 -559038737)
  call void @avra_array_push(ptr %2, i64 ptrtoint (ptr @__lambda_3 to i64))
  %cast2 = ptrtoint ptr %2 to i64
  store i64 %cast2, ptr @sqr, align 8
  %dbl = load ptr, ptr @dbl, align 8
  %inc = load ptr, ptr @inc, align 8
  %3 = call ptr @compose(ptr %dbl, ptr %inc)
  store ptr %3, ptr @inc_then_dbl, align 8
  %sqr = load ptr, ptr @sqr, align 8
  %dbl3 = load ptr, ptr @dbl, align 8
  %4 = call ptr @compose(ptr %sqr, ptr %dbl3)
  store ptr %4, ptr @dbl_then_sqr, align 8
  %inc_then_dbl = load i64, ptr @inc_then_dbl, align 8
  %5 = call i64 @avra_closure_call_1(i64 %inc_then_dbl, i64 5)
  %6 = call ptr @avra_rc_alloc(i64 32)
  %7 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %6, i64 32, ptr @.i2s_fmt, i64 %5)
  %widen = sext i32 %7 to i64
  %8 = call i32 @puts(ptr %6)
  %widen4 = sext i32 %8 to i64
  %dbl_then_sqr = load i64, ptr @dbl_then_sqr, align 8
  %9 = call i64 @avra_closure_call_1(i64 %dbl_then_sqr, i64 3)
  %10 = call ptr @avra_rc_alloc(i64 32)
  %11 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %10, i64 32, ptr @.i2s_fmt.1, i64 %9)
  %widen5 = sext i32 %11 to i64
  %12 = call i32 @puts(ptr %10)
  %widen6 = sext i32 %12 to i64
  %13 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %13, i64 1)
  call void @avra_array_push(ptr %13, i64 2)
  call void @avra_array_push(ptr %13, i64 3)
  call void @avra_array_push(ptr %13, i64 4)
  call void @avra_array_push(ptr %13, i64 5)
  store ptr %13, ptr @nums, align 8
  %nums = load ptr, ptr @nums, align 8
  %dbl7 = load ptr, ptr @dbl, align 8
  %inc8 = load ptr, ptr @inc, align 8
  %14 = call ptr @compose(ptr %dbl7, ptr %inc8)
  %cast9 = ptrtoint ptr %14 to i64
  %15 = call ptr @avra_array_map(ptr %nums, i64 %cast9)
  store ptr %15, ptr @results, align 8
  %results = load ptr, ptr @results, align 8
  %16 = call i64 @avra_array_len(ptr %results)
  store i64 %16, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %entry
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %17 = call i64 @avra_array_get(ptr %results, i64 %forin_i_val)
  store i64 %17, ptr %r, align 8
  %r10 = load i64, ptr %r, align 8
  %18 = call ptr @avra_rc_alloc(i64 32)
  %19 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %18, i64 32, ptr @.i2s_fmt.2, i64 %r10)
  %widen11 = sext i32 %19 to i64
  %20 = call i32 @puts(ptr %18)
  %widen12 = sext i32 %20 to i64
  br label %forin.incr

forin.incr:                                       ; preds = %forin.body
  %forin_i_old = load i64, ptr %forin_i, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  %21 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %21, i64 ptrtoint (ptr @.str to i64))
  call void @avra_array_push(ptr %21, i64 ptrtoint (ptr @.str.3 to i64))
  call void @avra_array_push(ptr %21, i64 ptrtoint (ptr @.str.4 to i64))
  call void @avra_array_push(ptr %21, i64 ptrtoint (ptr @.str.5 to i64))
  store ptr %21, ptr @words, align 8
  %words = load ptr, ptr @words, align 8
  %22 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %22, i64 -559038737)
  call void @avra_array_push(ptr %22, i64 ptrtoint (ptr @__lambda_4 to i64))
  %cast13 = ptrtoint ptr %22 to i64
  %23 = call i64 @avra_array_reduce(ptr %words, i64 ptrtoint (ptr @.str.6 to i64), i64 %cast13)
  store i64 %23, ptr @sentence, align 8
  %sentence = load i64, ptr @sentence, align 8
  %cast14 = inttoptr i64 %sentence to ptr
  %24 = call i32 @puts(ptr %cast14)
  %widen15 = sext i32 %24 to i64
  %25 = call i32 @avra_test_summary()
  %widen16 = sext i32 %25 to i64
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__lambda_0(i64 %0, i64 %1, i64 %2) {
entry:
  %f = alloca ptr, align 8
  %g = alloca ptr, align 8
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %cast = inttoptr i64 %1 to ptr
  store ptr %cast, ptr %g, align 8
  %cast1 = inttoptr i64 %2 to ptr
  store ptr %cast1, ptr %f, align 8
  %f2 = load i64, ptr %f, align 8
  %g3 = load i64, ptr %g, align 8
  %x4 = load i64, ptr %x, align 8
  %3 = call i64 @avra_closure_call_1(i64 %g3, i64 %x4)
  %4 = call i64 @avra_closure_call_1(i64 %f2, i64 %3)
  ret i64 %4
}

define i64 @__lambda_1(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %add = add i64 %x1, 1
  ret i64 %add
}

define i64 @__lambda_2(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %mul = mul i64 %x1, 2
  ret i64 %mul
}

define i64 @__lambda_3(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %x2 = load i64, ptr %x, align 8
  %mul = mul i64 %x1, %x2
  ret i64 %mul
}

define i64 @__lambda_4(ptr %0, ptr %1) {
entry:
  %w = alloca ptr, align 8
  %acc = alloca ptr, align 8
  store ptr %0, ptr %acc, align 8
  store ptr %1, ptr %w, align 8
  %acc1 = load ptr, ptr %acc, align 8
  %2 = call i32 @strcmp(ptr %acc1, ptr @.str.7)
  %widen = sext i32 %2 to i64
  %streq_cmp = icmp eq i64 %widen, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %if_cond = icmp ne i64 %streq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %acc3 = load ptr, ptr %acc, align 8
  %3 = call i64 @strlen(ptr %acc3)
  %4 = call i64 @strlen(ptr @.str.8)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @avra_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr %acc3, i64 %3)
  %cast4 = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast4, %3
  %cast5 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast5, ptr @.str.8, i64 %rhs_len_p1)
  %w6 = load ptr, ptr %w, align 8
  %8 = call i64 @strlen(ptr %5)
  %9 = call i64 @strlen(ptr %w6)
  %concat_total7 = add i64 %8, %9
  %concat_size8 = add i64 %concat_total7, 1
  %10 = call ptr @avra_rc_alloc(i64 %concat_size8)
  %11 = call ptr @memcpy(ptr %10, ptr %5, i64 %8)
  %cast9 = ptrtoint ptr %10 to i64
  %dst2_int10 = add i64 %cast9, %8
  %cast11 = inttoptr i64 %dst2_int10 to ptr
  %rhs_len_p112 = add i64 %9, 1
  %12 = call ptr @memcpy(ptr %cast11, ptr %w6, i64 %rhs_len_p112)
  %cast13 = ptrtoint ptr %10 to i64
  ret i64 %cast13

if_then:                                          ; preds = %entry
  %w2 = load ptr, ptr %w, align 8
  %cast = ptrtoint ptr %w2 to i64
  ret i64 %cast

if_else:                                          ; preds = %entry
  br label %ifcont
}
