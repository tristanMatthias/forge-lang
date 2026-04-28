; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@dz_file = private unnamed_addr constant [95 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/std_test.av\00", align 1
@spec_str = private unnamed_addr constant [7 x i8] c"\22math\22\00", align 1
@spec_str.1 = private unnamed_addr constant [17 x i8] c"\22absolute value\22\00", align 1
@spec_str.2 = private unnamed_addr constant [26 x i8] c"\22positive stays positive\22\00", align 1
@spec_str.3 = private unnamed_addr constant [28 x i8] c"\22negative becomes positive\22\00", align 1
@spec_str.4 = private unnamed_addr constant [18 x i8] c"\22zero stays zero\22\00", align 1
@spec_str.5 = private unnamed_addr constant [11 x i8] c"\22even/odd\22\00", align 1
@spec_str.6 = private unnamed_addr constant [12 x i8] c"\222 is even\22\00", align 1
@spec_str.7 = private unnamed_addr constant [16 x i8] c"\223 is not even\22\00", align 1
@spec_str.8 = private unnamed_addr constant [12 x i8] c"\220 is even\22\00", align 1
@spec_str.9 = private unnamed_addr constant [12 x i8] c"\22fibonacci\22\00", align 1
@spec_str.10 = private unnamed_addr constant [13 x i8] c"\22fib(0) = 0\22\00", align 1
@spec_str.11 = private unnamed_addr constant [13 x i8] c"\22fib(1) = 1\22\00", align 1
@spec_str.12 = private unnamed_addr constant [15 x i8] c"\22fib(10) = 55\22\00", align 1
@spec_str.13 = private unnamed_addr constant [14 x i8] c"\22comparisons\22\00", align 1
@spec_str.14 = private unnamed_addr constant [11 x i8] c"\22ordering\22\00", align 1
@spec_str.15 = private unnamed_addr constant [12 x i8] c"\22less than\22\00", align 1
@spec_str.16 = private unnamed_addr constant [15 x i8] c"\22greater than\22\00", align 1
@spec_str.17 = private unnamed_addr constant [11 x i8] c"\22equality\22\00", align 1
@spec_str.18 = private unnamed_addr constant [12 x i8] c"\22not equal\22\00", align 1

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

define i64 @abs(i64 %0) {
entry:
  %sif_result = alloca i64, align 8
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %slt = icmp slt i64 %x1, 0
  %slt_ext = zext i1 %slt to i64
  %sif_cond = icmp ne i64 %slt_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

sif_then:                                         ; preds = %entry
  %x2 = load i64, ptr %x, align 8
  %neg = sub i64 0, %x2
  store i64 %neg, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %entry
  %x3 = load i64, ptr %x, align 8
  store i64 %x3, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  ret i64 %sif_val
}

define i1 @is_even(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  call void @avra_div_by_zero_trap(i64 0, ptr @dz_file, i64 94, i64 7)
  %mod = srem i64 %x1, 2
  %eq = icmp eq i64 %mod, 0
  %eq_ext = zext i1 %eq to i64
  %cast = trunc i64 %eq_ext to i1
  ret i1 %cast
}

define i64 @fib(i64 %0) {
entry:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  %n1 = load i64, ptr %n, align 8
  %sle = icmp sle i64 %n1, 1
  %sle_ext = zext i1 %sle to i64
  %if_cond = icmp ne i64 %sle_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %n3 = load i64, ptr %n, align 8
  %sub = sub i64 %n3, 1
  %1 = call i64 @fib(i64 %sub)
  %n4 = load i64, ptr %n, align 8
  %sub5 = sub i64 %n4, 2
  %2 = call i64 @fib(i64 %sub5)
  %add = add i64 %1, %2
  ret i64 %add

if_then:                                          ; preds = %entry
  %n2 = load i64, ptr %n, align 8
  ret i64 %n2

if_else:                                          ; preds = %entry
  br label %ifcont
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %1 = call i32 @avra_test_start_spec(ptr @spec_str)
  %widen = sext i32 %1 to i64
  %2 = call i32 @avra_test_start_given(ptr @spec_str.1)
  %widen1 = sext i32 %2 to i64
  %3 = call i64 @abs(i64 5)
  %eq = icmp eq i64 %3, 5
  %eq_ext = zext i1 %eq to i64
  %4 = call i64 @avra_test_run_then(ptr @spec_str.2, i64 %eq_ext)
  %5 = call i64 @abs(i64 -3)
  %eq2 = icmp eq i64 %5, 3
  %eq_ext3 = zext i1 %eq2 to i64
  %6 = call i64 @avra_test_run_then(ptr @spec_str.3, i64 %eq_ext3)
  %7 = call i64 @abs(i64 0)
  %eq4 = icmp eq i64 %7, 0
  %eq_ext5 = zext i1 %eq4 to i64
  %8 = call i64 @avra_test_run_then(ptr @spec_str.4, i64 %eq_ext5)
  %9 = call i32 @avra_test_end_given(ptr @spec_str.1)
  %widen6 = sext i32 %9 to i64
  %10 = call i32 @avra_test_start_given(ptr @spec_str.5)
  %widen7 = sext i32 %10 to i64
  %11 = call i1 @is_even(i64 2)
  %widen8 = zext i1 %11 to i64
  %12 = call i64 @avra_test_run_then(ptr @spec_str.6, i64 %widen8)
  %13 = call i1 @is_even(i64 3)
  %widen9 = zext i1 %13 to i64
  %not_cmp = icmp eq i64 %widen9, 0
  %not_cmp_ext = zext i1 %not_cmp to i64
  %14 = call i64 @avra_test_run_then(ptr @spec_str.7, i64 %not_cmp_ext)
  %15 = call i1 @is_even(i64 0)
  %widen10 = zext i1 %15 to i64
  %16 = call i64 @avra_test_run_then(ptr @spec_str.8, i64 %widen10)
  %17 = call i32 @avra_test_end_given(ptr @spec_str.5)
  %widen11 = sext i32 %17 to i64
  %18 = call i32 @avra_test_start_given(ptr @spec_str.9)
  %widen12 = sext i32 %18 to i64
  %19 = call i64 @fib(i64 0)
  %eq13 = icmp eq i64 %19, 0
  %eq_ext14 = zext i1 %eq13 to i64
  %20 = call i64 @avra_test_run_then(ptr @spec_str.10, i64 %eq_ext14)
  %21 = call i64 @fib(i64 1)
  %eq15 = icmp eq i64 %21, 1
  %eq_ext16 = zext i1 %eq15 to i64
  %22 = call i64 @avra_test_run_then(ptr @spec_str.11, i64 %eq_ext16)
  %23 = call i64 @fib(i64 10)
  %eq17 = icmp eq i64 %23, 55
  %eq_ext18 = zext i1 %eq17 to i64
  %24 = call i64 @avra_test_run_then(ptr @spec_str.12, i64 %eq_ext18)
  %25 = call i32 @avra_test_end_given(ptr @spec_str.9)
  %widen19 = sext i32 %25 to i64
  %26 = call i32 @avra_test_end_spec(ptr @spec_str)
  %widen20 = sext i32 %26 to i64
  %27 = call i32 @avra_test_start_spec(ptr @spec_str.13)
  %widen21 = sext i32 %27 to i64
  %28 = call i32 @avra_test_start_given(ptr @spec_str.14)
  %widen22 = sext i32 %28 to i64
  %29 = call i64 @avra_test_run_then(ptr @spec_str.15, i64 1)
  %30 = call i64 @avra_test_run_then(ptr @spec_str.16, i64 1)
  %31 = call i64 @avra_test_run_then(ptr @spec_str.17, i64 1)
  %32 = call i64 @avra_test_run_then(ptr @spec_str.18, i64 1)
  %33 = call i32 @avra_test_end_given(ptr @spec_str.14)
  %widen23 = sext i32 %33 to i64
  %34 = call i32 @avra_test_end_spec(ptr @spec_str.13)
  %widen24 = sext i32 %34 to i64
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}
