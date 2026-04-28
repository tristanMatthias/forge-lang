; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@pfn_inc = global i64 0
@pfn_dbl = global i64 0
@pfn_sqr = global i64 0
@pfn_inc_then_dbl = global i64 0
@pfn_dbl_then_sqr = global i64 0
@spec_str = private unnamed_addr constant [18 x i8] c"\22prod functional\22\00", align 1
@spec_str.1 = private unnamed_addr constant [23 x i8] c"\22compose inc then dbl\22\00", align 1
@spec_str.2 = private unnamed_addr constant [23 x i8] c"\22compose dbl then sqr\22\00", align 1
@spec_str.3 = private unnamed_addr constant [23 x i8] c"\22map with composed fn\22\00", align 1
@.str = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.4 = private unnamed_addr constant [6 x i8] c"world\00", align 1
@.str.5 = private unnamed_addr constant [5 x i8] c"from\00", align 1
@.str.6 = private unnamed_addr constant [6 x i8] c"forge\00", align 1
@.str.7 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.8 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.9 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.10 = private unnamed_addr constant [23 x i8] c"hello world from forge\00", align 1
@spec_str.11 = private unnamed_addr constant [21 x i8] c"\22reduce to sentence\22\00", align 1

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

define ptr @pfn_compose(ptr %0, ptr %1) {
entry:
  %g = alloca ptr, align 8
  %f = alloca ptr, align 8
  store ptr %0, ptr %f, align 8
  store ptr %1, ptr %g, align 8
  %2 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %2, i64 -559038737)
  call void @forge_array_push(ptr %2, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cap_val = load i64, ptr %g, align 8
  call void @forge_array_push(ptr %2, i64 %cap_val)
  %cap_val1 = load i64, ptr %f, align 8
  call void @forge_array_push(ptr %2, i64 %cap_val1)
  %cast = ptrtoint ptr %2 to i64
  %cast2 = inttoptr i64 %cast to ptr
  ret ptr %cast2
}

define i64 @main() {
entry:
  %sentence = alloca i64, align 8
  %words = alloca ptr, align 8
  %results = alloca ptr, align 8
  %nums = alloca ptr, align 8
  %0 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %0, i64 -559038737)
  call void @forge_array_push(ptr %0, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cast = ptrtoint ptr %0 to i64
  store i64 %cast, ptr @pfn_inc, align 8
  %1 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %1, i64 -559038737)
  call void @forge_array_push(ptr %1, i64 ptrtoint (ptr @__lambda_2 to i64))
  %cast1 = ptrtoint ptr %1 to i64
  store i64 %cast1, ptr @pfn_dbl, align 8
  %2 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %2, i64 -559038737)
  call void @forge_array_push(ptr %2, i64 ptrtoint (ptr @__lambda_3 to i64))
  %cast2 = ptrtoint ptr %2 to i64
  store i64 %cast2, ptr @pfn_sqr, align 8
  %pfn_dbl = load ptr, ptr @pfn_dbl, align 8
  %pfn_inc = load ptr, ptr @pfn_inc, align 8
  %3 = call ptr @pfn_compose(ptr %pfn_dbl, ptr %pfn_inc)
  store ptr %3, ptr @pfn_inc_then_dbl, align 8
  %pfn_sqr = load ptr, ptr @pfn_sqr, align 8
  %pfn_dbl3 = load ptr, ptr @pfn_dbl, align 8
  %4 = call ptr @pfn_compose(ptr %pfn_sqr, ptr %pfn_dbl3)
  store ptr %4, ptr @pfn_dbl_then_sqr, align 8
  %5 = call i32 @forge_test_start_spec(ptr @spec_str)
  %widen = sext i32 %5 to i64
  %pfn_inc_then_dbl = load i64, ptr @pfn_inc_then_dbl, align 8
  %6 = call i64 @forge_closure_call_1(i64 %pfn_inc_then_dbl, i64 5)
  %eq = icmp eq i64 %6, 12
  %eq_ext = zext i1 %eq to i64
  %7 = call i64 @forge_test_run_then(ptr @spec_str.1, i64 %eq_ext)
  %pfn_dbl_then_sqr = load i64, ptr @pfn_dbl_then_sqr, align 8
  %8 = call i64 @forge_closure_call_1(i64 %pfn_dbl_then_sqr, i64 3)
  %eq4 = icmp eq i64 %8, 36
  %eq_ext5 = zext i1 %eq4 to i64
  %9 = call i64 @forge_test_run_then(ptr @spec_str.2, i64 %eq_ext5)
  %10 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %10, i64 1)
  call void @forge_array_push(ptr %10, i64 2)
  call void @forge_array_push(ptr %10, i64 3)
  call void @forge_array_push(ptr %10, i64 4)
  call void @forge_array_push(ptr %10, i64 5)
  store ptr %10, ptr %nums, align 8
  %nums6 = load ptr, ptr %nums, align 8
  %pfn_dbl7 = load ptr, ptr @pfn_dbl, align 8
  %pfn_inc8 = load ptr, ptr @pfn_inc, align 8
  %11 = call ptr @pfn_compose(ptr %pfn_dbl7, ptr %pfn_inc8)
  %cast9 = ptrtoint ptr %11 to i64
  %12 = call ptr @forge_array_map(ptr %nums6, i64 %cast9)
  store ptr %12, ptr %results, align 8
  %results10 = load ptr, ptr %results, align 8
  %13 = call i64 @forge_array_get(ptr %results10, i64 0)
  %eq11 = icmp eq i64 %13, 4
  %eq_ext12 = zext i1 %eq11 to i64
  %14 = call i64 @forge_test_run_then(ptr @spec_str.3, i64 %eq_ext12)
  %15 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %15, i64 ptrtoint (ptr @.str to i64))
  call void @forge_array_push(ptr %15, i64 ptrtoint (ptr @.str.4 to i64))
  call void @forge_array_push(ptr %15, i64 ptrtoint (ptr @.str.5 to i64))
  call void @forge_array_push(ptr %15, i64 ptrtoint (ptr @.str.6 to i64))
  store ptr %15, ptr %words, align 8
  %words13 = load ptr, ptr %words, align 8
  %16 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %16, i64 -559038737)
  call void @forge_array_push(ptr %16, i64 ptrtoint (ptr @__lambda_4 to i64))
  %cast14 = ptrtoint ptr %16 to i64
  %17 = call i64 @forge_array_reduce(ptr %words13, i64 ptrtoint (ptr @.str.7 to i64), i64 %cast14)
  store i64 %17, ptr %sentence, align 8
  %sentence15 = load i64, ptr %sentence, align 8
  %lhs_ptr = inttoptr i64 %sentence15 to ptr
  %18 = call i32 @strcmp(ptr %lhs_ptr, ptr @.str.10)
  %widen16 = sext i32 %18 to i64
  %streq_cmp = icmp eq i64 %widen16, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %19 = call i64 @forge_test_run_then(ptr @spec_str.11, i64 %streq_ext)
  %20 = call i32 @forge_test_end_spec(ptr @spec_str)
  %widen17 = sext i32 %20 to i64
  %21 = call i32 @forge_test_summary()
  %widen18 = sext i32 %21 to i64
  call void @forge_rc_collect()
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
  %3 = call i64 @forge_closure_call_1(i64 %g3, i64 %x4)
  %4 = call i64 @forge_closure_call_1(i64 %f2, i64 %3)
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
  %2 = call i32 @strcmp(ptr %acc1, ptr @.str.8)
  %widen = sext i32 %2 to i64
  %streq_cmp = icmp eq i64 %widen, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %if_cond = icmp ne i64 %streq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %acc3 = load ptr, ptr %acc, align 8
  %3 = call i64 @strlen(ptr %acc3)
  %4 = call i64 @strlen(ptr @.str.9)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @forge_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr %acc3, i64 %3)
  %cast4 = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast4, %3
  %cast5 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast5, ptr @.str.9, i64 %rhs_len_p1)
  %w6 = load ptr, ptr %w, align 8
  %8 = call i64 @strlen(ptr %5)
  %9 = call i64 @strlen(ptr %w6)
  %concat_total7 = add i64 %8, %9
  %concat_size8 = add i64 %concat_total7, 1
  %10 = call ptr @forge_rc_alloc(i64 %concat_size8)
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
