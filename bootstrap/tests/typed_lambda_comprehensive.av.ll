; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str = private unnamed_addr constant [7 x i8] c"hello \00", align 1
@.str.2 = private unnamed_addr constant [6 x i8] c"world\00", align 1
@.float_str = private unnamed_addr constant [5 x i8] c"3.14\00", align 1
@.float_str.3 = private unnamed_addr constant [5 x i8] c"10.0\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.5 = private unnamed_addr constant [4 x i8] c"yes\00", align 1
@.str.6 = private unnamed_addr constant [3 x i8] c"no\00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define i64 @apply(ptr %0, i64 %1) {
entry:
  %x = alloca i64, align 8
  %f = alloca ptr, align 8
  store ptr %0, ptr %f, align 8
  store i64 %1, ptr %x, align 8
  %f1 = load i64, ptr %f, align 8
  %x2 = load i64, ptr %x, align 8
  %2 = call i64 @avra_closure_call_1(i64 %f1, i64 %x2)
  ret i64 %2
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %check = alloca ptr, align 8
  %add_n = alloca ptr, align 8
  %n = alloca i64, align 8
  %area = alloca ptr, align 8
  %greet = alloca ptr, align 8
  %add = alloca ptr, align 8
  %double = alloca ptr, align 8
  %1 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %1, i64 -559038737)
  call void @avra_array_push(ptr %1, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast = ptrtoint ptr %1 to i64
  %cast1 = inttoptr i64 %cast to ptr
  store ptr %cast1, ptr %double, align 8
  %double2 = load i64, ptr %double, align 8
  %cast3 = inttoptr i64 %double2 to ptr
  %2 = call i64 @avra_array_get(ptr %cast3, i64 1)
  %fn_ptr = inttoptr i64 %2 to ptr
  %closure_call = call i64 %fn_ptr(i64 5)
  %3 = call ptr @avra_rc_alloc(i64 32)
  %4 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %3, i64 32, ptr @.i2s_fmt, i64 %closure_call)
  %widen = sext i32 %4 to i64
  %5 = call i32 @puts(ptr %3)
  %widen4 = sext i32 %5 to i64
  %6 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %6, i64 -559038737)
  call void @avra_array_push(ptr %6, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cast5 = ptrtoint ptr %6 to i64
  %cast6 = inttoptr i64 %cast5 to ptr
  store ptr %cast6, ptr %add, align 8
  %add7 = load i64, ptr %add, align 8
  %cast8 = inttoptr i64 %add7 to ptr
  %7 = call i64 @avra_array_get(ptr %cast8, i64 1)
  %fn_ptr9 = inttoptr i64 %7 to ptr
  %closure_call10 = call i64 %fn_ptr9(i64 3, i64 4)
  %8 = call ptr @avra_rc_alloc(i64 32)
  %9 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %8, i64 32, ptr @.i2s_fmt.1, i64 %closure_call10)
  %widen11 = sext i32 %9 to i64
  %10 = call i32 @puts(ptr %8)
  %widen12 = sext i32 %10 to i64
  %11 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %11, i64 -559038737)
  call void @avra_array_push(ptr %11, i64 ptrtoint (ptr @__lambda_2 to i64))
  %cast13 = ptrtoint ptr %11 to i64
  %cast14 = inttoptr i64 %cast13 to ptr
  store ptr %cast14, ptr %greet, align 8
  %greet15 = load i64, ptr %greet, align 8
  %cast16 = inttoptr i64 %greet15 to ptr
  %12 = call i64 @avra_array_get(ptr %cast16, i64 1)
  %fn_ptr17 = inttoptr i64 %12 to ptr
  %closure_call18 = call i64 %fn_ptr17(ptr @.str.2)
  %cast19 = inttoptr i64 %closure_call18 to ptr
  %13 = call i32 @puts(ptr %cast19)
  %widen20 = sext i32 %13 to i64
  %14 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %14, i64 -559038737)
  call void @avra_array_push(ptr %14, i64 ptrtoint (ptr @__lambda_3 to i64))
  %cast21 = ptrtoint ptr %14 to i64
  %cast22 = inttoptr i64 %cast21 to ptr
  store ptr %cast22, ptr %area, align 8
  %area23 = load i64, ptr %area, align 8
  %cast24 = inttoptr i64 %area23 to ptr
  %15 = call i64 @avra_array_get(ptr %cast24, i64 1)
  %fn_ptr25 = inttoptr i64 %15 to ptr
  %16 = call i64 @avra_float_parse(ptr @.float_str.3)
  %cast26 = bitcast i64 %16 to double
  %closure_call27 = call i64 %fn_ptr25(double %cast26)
  %17 = call i64 @avra_float_to_string(i64 %closure_call27)
  %cast28 = inttoptr i64 %17 to ptr
  %18 = call i32 @puts(ptr %cast28)
  %widen29 = sext i32 %18 to i64
  store i64 10, ptr %n, align 8
  %19 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %19, i64 -559038737)
  call void @avra_array_push(ptr %19, i64 ptrtoint (ptr @__lambda_4 to i64))
  %cap_val = load i64, ptr %n, align 8
  call void @avra_array_push(ptr %19, i64 %cap_val)
  %cast30 = ptrtoint ptr %19 to i64
  %cast31 = inttoptr i64 %cast30 to ptr
  store ptr %cast31, ptr %add_n, align 8
  %add_n32 = load i64, ptr %add_n, align 8
  %cast33 = inttoptr i64 %add_n32 to ptr
  %20 = call i64 @avra_array_get(ptr %cast33, i64 1)
  %fn_ptr34 = inttoptr i64 %20 to ptr
  %21 = call i64 @avra_array_get(ptr %cast33, i64 2)
  %closure_call35 = call i64 %fn_ptr34(i64 5, i64 %21)
  %22 = call ptr @avra_rc_alloc(i64 32)
  %23 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %22, i64 32, ptr @.i2s_fmt.4, i64 %closure_call35)
  %widen36 = sext i32 %23 to i64
  %24 = call i32 @puts(ptr %22)
  %widen37 = sext i32 %24 to i64
  %25 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %25, i64 -559038737)
  call void @avra_array_push(ptr %25, i64 ptrtoint (ptr @__lambda_5 to i64))
  %cast38 = ptrtoint ptr %25 to i64
  %cast39 = inttoptr i64 %cast38 to ptr
  store ptr %cast39, ptr %check, align 8
  %check40 = load i64, ptr %check, align 8
  %cast41 = inttoptr i64 %check40 to ptr
  %26 = call i64 @avra_array_get(ptr %cast41, i64 1)
  %fn_ptr42 = inttoptr i64 %26 to ptr
  %closure_call43 = call i64 %fn_ptr42(i64 1)
  %cast44 = inttoptr i64 %closure_call43 to ptr
  %27 = call i32 @puts(ptr %cast44)
  %widen45 = sext i32 %27 to i64
  %28 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %28, i64 -559038737)
  call void @avra_array_push(ptr %28, i64 ptrtoint (ptr @__lambda_6 to i64))
  %cast46 = ptrtoint ptr %28 to i64
  %cast47 = inttoptr i64 %cast46 to ptr
  %29 = call i64 @apply(ptr %cast47, i64 3)
  %30 = call ptr @avra_rc_alloc(i64 32)
  %31 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %30, i64 32, ptr @.i2s_fmt.7, i64 %29)
  %widen48 = sext i32 %31 to i64
  %32 = call i32 @puts(ptr %30)
  %widen49 = sext i32 %32 to i64
  ret i64 0
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
  %mul = mul i64 %x1, 2
  ret i64 %mul
}

define i64 @__lambda_1(i64 %0, i64 %1) {
entry:
  %b = alloca i64, align 8
  %a = alloca i64, align 8
  store i64 %0, ptr %a, align 8
  store i64 %1, ptr %b, align 8
  %a1 = load i64, ptr %a, align 8
  %b2 = load i64, ptr %b, align 8
  %add = add i64 %a1, %b2
  ret i64 %add
}

define i64 @__lambda_2(ptr %0) {
entry:
  %name = alloca ptr, align 8
  store ptr %0, ptr %name, align 8
  %name1 = load ptr, ptr %name, align 8
  %1 = call i64 @strlen(ptr @.str)
  %2 = call i64 @strlen(ptr %name1)
  %concat_total = add i64 %1, %2
  %concat_size = add i64 %concat_total, 1
  %3 = call ptr @avra_rc_alloc(i64 %concat_size)
  %4 = call ptr @memcpy(ptr %3, ptr @.str, i64 %1)
  %cast = ptrtoint ptr %3 to i64
  %dst2_int = add i64 %cast, %1
  %cast2 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %2, 1
  %5 = call ptr @memcpy(ptr %cast2, ptr %name1, i64 %rhs_len_p1)
  %cast3 = ptrtoint ptr %3 to i64
  ret i64 %cast3
}

define i64 @__lambda_3(double %0) {
entry:
  %r = alloca double, align 8
  store double %0, ptr %r, align 8
  %1 = call i64 @avra_float_parse(ptr @.float_str)
  %cast = bitcast i64 %1 to double
  %r1 = load double, ptr %r, align 8
  %fmul = fmul double %cast, %r1
  %r2 = load double, ptr %r, align 8
  %fmul3 = fmul double %fmul, %r2
  %cast4 = bitcast double %fmul3 to i64
  ret i64 %cast4
}

define i64 @__lambda_4(i64 %0, i64 %1) {
entry:
  %n = alloca i64, align 8
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  store i64 %1, ptr %n, align 8
  %x1 = load i64, ptr %x, align 8
  %n2 = load i64, ptr %n, align 8
  %add = add i64 %x1, %n2
  ret i64 %add
}

define i64 @__lambda_5(i64 %0) {
entry:
  %ife_result = alloca i64, align 8
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %sgt = icmp sgt i64 %x1, 0
  %sgt_ext = zext i1 %sgt to i64
  %ife_cond = icmp ne i64 %sgt_ext, 0
  br i1 %ife_cond, label %ife_then, label %ife_else

ife_end:                                          ; preds = %ife_else, %ife_then
  %ife_val = load i64, ptr %ife_result, align 8
  ret i64 %ife_val

ife_then:                                         ; preds = %entry
  store i64 ptrtoint (ptr @.str.5 to i64), ptr %ife_result, align 8
  br label %ife_end

ife_else:                                         ; preds = %entry
  store i64 ptrtoint (ptr @.str.6 to i64), ptr %ife_result, align 8
  br label %ife_end
}

define i64 @__lambda_6(i64 %0) {
entry:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  %n1 = load i64, ptr %n, align 8
  %mul = mul i64 %n1, 2
  ret i64 %mul
}
