; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@x = global i64 0
@clamped = global i64 0
@in_range = global i64 0
@result = global i64 0
@safe = global i64 0
@result2 = global i64 0
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
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

define i64 @clamp(i64 %0, i64 %1, i64 %2) {
entry:
  %hi = alloca i64, align 8
  %lo = alloca i64, align 8
  %val = alloca i64, align 8
  store i64 %0, ptr %val, align 8
  store i64 %1, ptr %lo, align 8
  store i64 %2, ptr %hi, align 8
  %val1 = load i64, ptr %val, align 8
  %lo2 = load i64, ptr %lo, align 8
  %slt = icmp slt i64 %val1, %lo2
  %slt_ext = zext i1 %slt to i64
  %if_cond = icmp ne i64 %slt_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %val4 = load i64, ptr %val, align 8
  %hi5 = load i64, ptr %hi, align 8
  %sgt = icmp sgt i64 %val4, %hi5
  %sgt_ext = zext i1 %sgt to i64
  %if_cond7 = icmp ne i64 %sgt_ext, 0
  br i1 %if_cond7, label %if_then8, label %if_else9

if_then:                                          ; preds = %entry
  %lo3 = load i64, ptr %lo, align 8
  ret i64 %lo3

if_else:                                          ; preds = %entry
  br label %ifcont

ifcont6:                                          ; preds = %if_else9
  %val11 = load i64, ptr %val, align 8
  ret i64 %val11

if_then8:                                         ; preds = %ifcont
  %hi10 = load i64, ptr %hi, align 8
  ret i64 %hi10

if_else9:                                         ; preds = %ifcont
  br label %ifcont6
}

define i64 @abs(i64 %0) {
entry:
  %sif_result = alloca i64, align 8
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  %n1 = load i64, ptr %n, align 8
  %slt = icmp slt i64 %n1, 0
  %slt_ext = zext i1 %slt to i64
  %sif_cond = icmp ne i64 %slt_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

sif_then:                                         ; preds = %entry
  %n2 = load i64, ptr %n, align 8
  %neg = sub i64 0, %n2
  store i64 %neg, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %entry
  %n3 = load i64, ptr %n, align 8
  store i64 %n3, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  ret i64 %sif_val
}

define i64 @maybe_double(i64 %0) {
entry:
  %sif_result = alloca i64, align 8
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  %n1 = load i64, ptr %n, align 8
  %sgt = icmp sgt i64 %n1, 10
  %sgt_ext = zext i1 %sgt to i64
  %sif_cond = icmp ne i64 %sgt_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

sif_then:                                         ; preds = %entry
  %n2 = load i64, ptr %n, align 8
  %mul = mul i64 %n2, 2
  store i64 %mul, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %entry
  store i64 0, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  ret i64 %sif_val
}

define i64 @main() {
entry:
  %nc_result = alloca i64, align 8
  store i64 15, ptr @x, align 8
  %x = load i64, ptr @x, align 8
  %mul = mul i64 %x, 2
  %sub = sub i64 %mul, 5
  %0 = call i64 @clamp(i64 %sub, i64 0, i64 50)
  store i64 %0, ptr @clamped, align 8
  %clamped = load i64, ptr @clamped, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %clamped)
  %widen = sext i32 %2 to i64
  %3 = call i32 @puts(ptr %1)
  %widen1 = sext i32 %3 to i64
  %x2 = load i64, ptr @x, align 8
  %sge = icmp sge i64 %x2, 10
  %sge_ext = zext i1 %sge to i64
  %l_bool = icmp ne i64 %sge_ext, 0
  br i1 %l_bool, label %sc_rhs, label %sc_short

sc_rhs:                                           ; preds = %entry
  %x3 = load i64, ptr @x, align 8
  %sle = icmp sle i64 %x3, 20
  %sle_ext = zext i1 %sle to i64
  %r_bool = icmp ne i64 %sle_ext, 0
  br i1 %r_bool, label %sc_r_true, label %sc_r_false

sc_short:                                         ; preds = %entry
  br label %sc_merge

sc_merge:                                         ; preds = %sc_r_merge, %sc_short
  %sc_phi = phi i1 [ false, %sc_short ], [ %r_bool, %sc_r_merge ]
  %sc_ext = zext i1 %sc_phi to i64
  store i64 %sc_ext, ptr @in_range, align 8
  %in_range = load i1, ptr @in_range, align 8
  %4 = call ptr @avra_rc_alloc(i64 32)
  %5 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %4, i64 32, ptr @.i2s_fmt.1, i1 %in_range)
  %widen4 = sext i32 %5 to i64
  %6 = call i32 @puts(ptr %4)
  %widen5 = sext i32 %6 to i64
  %7 = call i64 @maybe_double(i64 5)
  store i64 %7, ptr @result, align 8
  %result = load i64, ptr @result, align 8
  %nc_null = icmp eq i64 %result, 0
  store i64 %result, ptr %nc_result, align 8
  br i1 %nc_null, label %nc_rhs, label %nc_end

sc_r_true:                                        ; preds = %sc_rhs
  br label %sc_r_merge

sc_r_false:                                       ; preds = %sc_rhs
  br label %sc_r_merge

sc_r_merge:                                       ; preds = %sc_r_false, %sc_r_true
  br label %sc_merge

nc_rhs:                                           ; preds = %sc_merge
  store i64 99, ptr %nc_result, align 8
  br label %nc_end

nc_end:                                           ; preds = %nc_rhs, %sc_merge
  %nc_val = load i64, ptr %nc_result, align 8
  store i64 %nc_val, ptr @safe, align 8
  %safe = load i64, ptr @safe, align 8
  %8 = call ptr @avra_rc_alloc(i64 32)
  %9 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %8, i64 32, ptr @.i2s_fmt.2, i64 %safe)
  %widen6 = sext i32 %9 to i64
  %10 = call i32 @puts(ptr %8)
  %widen7 = sext i32 %10 to i64
  %11 = call i64 @maybe_double(i64 15)
  store i64 %11, ptr @result2, align 8
  %result2 = load i64, ptr @result2, align 8
  %12 = call ptr @avra_rc_alloc(i64 32)
  %13 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %12, i64 32, ptr @.i2s_fmt.3, i64 %result2)
  %widen8 = sext i32 %13 to i64
  %14 = call i32 @puts(ptr %12)
  %widen9 = sext i32 %14 to i64
  %15 = call i32 @avra_test_summary()
  %widen10 = sext i32 %15 to i64
  call void @avra_rc_collect()
  ret i64 0
}
