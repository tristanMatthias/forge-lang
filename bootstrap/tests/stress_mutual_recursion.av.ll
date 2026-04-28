; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@dz_file = private unnamed_addr constant [110 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/stress_mutual_recursion.av\00", align 1
@dz_file.1 = private unnamed_addr constant [110 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/stress_mutual_recursion.av\00", align 1
@.str = private unnamed_addr constant [7 x i8] c"even: \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.2 = private unnamed_addr constant [6 x i8] c"odd: \00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.4 = private unnamed_addr constant [14 x i8] c"collatz(27): \00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define i1 @is_even(i64 %0) {
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
  %sub = sub i64 %n2, 1
  %1 = call i1 @is_odd(i64 %sub)
  %widen = zext i1 %1 to i64
  %cast = trunc i64 %widen to i1
  ret i1 %cast

if_then:                                          ; preds = %entry
  ret i1 true

if_else:                                          ; preds = %entry
  br label %ifcont
}

define i1 @is_odd(i64 %0) {
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
  %sub = sub i64 %n2, 1
  %1 = call i1 @is_even(i64 %sub)
  %widen = zext i1 %1 to i64
  %cast = trunc i64 %widen to i1
  ret i1 %cast

if_then:                                          ; preds = %entry
  ret i1 false

if_else:                                          ; preds = %entry
  br label %ifcont
}

define i64 @collatz_len(i64 %0) {
entry:
  %sif_result = alloca i64, align 8
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  %n1 = load i64, ptr %n, align 8
  %sle = icmp sle i64 %n1, 1
  %sle_ext = zext i1 %sle to i64
  %if_cond = icmp ne i64 %sle_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %n2 = load i64, ptr %n, align 8
  call void @avra_div_by_zero_trap(i64 0, ptr @dz_file, i64 109, i64 18)
  %mod = srem i64 %n2, 2
  %eq = icmp eq i64 %mod, 0
  %eq_ext = zext i1 %eq to i64
  %sif_cond = icmp ne i64 %eq_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

if_then:                                          ; preds = %entry
  ret i64 0

if_else:                                          ; preds = %entry
  br label %ifcont

sif_then:                                         ; preds = %ifcont
  %n3 = load i64, ptr %n, align 8
  call void @avra_div_by_zero_trap(i64 0, ptr @dz_file.1, i64 109, i64 18)
  %div = sdiv i64 %n3, 2
  %1 = call i64 @collatz_len(i64 %div)
  %add = add i64 1, %1
  store i64 %add, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %ifcont
  %n4 = load i64, ptr %n, align 8
  %mul = mul i64 3, %n4
  %add5 = add i64 %mul, 1
  %2 = call i64 @collatz_len(i64 %add5)
  %add6 = add i64 1, %2
  store i64 %add6, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  ret i64 %sif_val
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %1 = call i1 @is_even(i64 100)
  %widen = zext i1 %1 to i64
  %2 = call ptr @avra_rc_alloc(i64 32)
  %3 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %2, i64 32, ptr @.i2s_fmt, i64 %widen)
  %widen1 = sext i32 %3 to i64
  %4 = call i64 @strlen(ptr @.str)
  %5 = call i64 @strlen(ptr %2)
  %concat_total = add i64 %4, %5
  %concat_size = add i64 %concat_total, 1
  %6 = call ptr @avra_rc_alloc(i64 %concat_size)
  %7 = call ptr @memcpy(ptr %6, ptr @.str, i64 %4)
  %cast = ptrtoint ptr %6 to i64
  %dst2_int = add i64 %cast, %4
  %cast2 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %5, 1
  %8 = call ptr @memcpy(ptr %cast2, ptr %2, i64 %rhs_len_p1)
  %9 = call i32 @puts(ptr %6)
  %widen3 = sext i32 %9 to i64
  %10 = call i1 @is_odd(i64 100)
  %widen4 = zext i1 %10 to i64
  %11 = call ptr @avra_rc_alloc(i64 32)
  %12 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %11, i64 32, ptr @.i2s_fmt.3, i64 %widen4)
  %widen5 = sext i32 %12 to i64
  %13 = call i64 @strlen(ptr @.str.2)
  %14 = call i64 @strlen(ptr %11)
  %concat_total6 = add i64 %13, %14
  %concat_size7 = add i64 %concat_total6, 1
  %15 = call ptr @avra_rc_alloc(i64 %concat_size7)
  %16 = call ptr @memcpy(ptr %15, ptr @.str.2, i64 %13)
  %cast8 = ptrtoint ptr %15 to i64
  %dst2_int9 = add i64 %cast8, %13
  %cast10 = inttoptr i64 %dst2_int9 to ptr
  %rhs_len_p111 = add i64 %14, 1
  %17 = call ptr @memcpy(ptr %cast10, ptr %11, i64 %rhs_len_p111)
  %18 = call i32 @puts(ptr %15)
  %widen12 = sext i32 %18 to i64
  %19 = call i64 @collatz_len(i64 27)
  %20 = call ptr @avra_rc_alloc(i64 32)
  %21 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %20, i64 32, ptr @.i2s_fmt.5, i64 %19)
  %widen13 = sext i32 %21 to i64
  %22 = call i64 @strlen(ptr @.str.4)
  %23 = call i64 @strlen(ptr %20)
  %concat_total14 = add i64 %22, %23
  %concat_size15 = add i64 %concat_total14, 1
  %24 = call ptr @avra_rc_alloc(i64 %concat_size15)
  %25 = call ptr @memcpy(ptr %24, ptr @.str.4, i64 %22)
  %cast16 = ptrtoint ptr %24 to i64
  %dst2_int17 = add i64 %cast16, %22
  %cast18 = inttoptr i64 %dst2_int17 to ptr
  %rhs_len_p119 = add i64 %23, 1
  %26 = call ptr @memcpy(ptr %cast18, ptr %20, i64 %rhs_len_p119)
  %27 = call i32 @puts(ptr %24)
  %widen20 = sext i32 %27 to i64
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}
