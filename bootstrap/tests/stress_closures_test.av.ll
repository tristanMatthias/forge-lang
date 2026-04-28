; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@stcl_classify = global i64 0
@stcl_double = global i64 0
@spec_str = private unnamed_addr constant [18 x i8] c"\22stress closures\22\00", align 1
@spec_str.1 = private unnamed_addr constant [15 x i8] c"\22classify 150\22\00", align 1
@spec_str.2 = private unnamed_addr constant [14 x i8] c"\22classify 75\22\00", align 1
@spec_str.3 = private unnamed_addr constant [14 x i8] c"\22classify 25\22\00", align 1
@spec_str.4 = private unnamed_addr constant [20 x i8] c"\22classify negative\22\00", align 1
@spec_str.5 = private unnamed_addr constant [19 x i8] c"\22map chain filter\22\00", align 1
@spec_str.6 = private unnamed_addr constant [17 x i8] c"\22reduce product\22\00", align 1
@spec_str.7 = private unnamed_addr constant [22 x i8] c"\22nested closure call\22\00", align 1
@dz_file = private unnamed_addr constant [30 x i8] c"tests/stress_closures_test.fg\00", align 1
@spec_str.8 = private unnamed_addr constant [29 x i8] c"\22map filter reduce pipeline\22\00", align 1

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

define i64 @main() {
entry:
  %even_squares = alloca i64, align 8
  %data = alloca ptr, align 8
  %product = alloca i64, align 8
  %step3 = alloca ptr, align 8
  %step2 = alloca ptr, align 8
  %step1 = alloca ptr, align 8
  %nums = alloca ptr, align 8
  %0 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %0, i64 -559038737)
  call void @forge_array_push(ptr %0, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast = ptrtoint ptr %0 to i64
  store i64 %cast, ptr @stcl_classify, align 8
  %1 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %1, i64 -559038737)
  call void @forge_array_push(ptr %1, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cast1 = ptrtoint ptr %1 to i64
  store i64 %cast1, ptr @stcl_double, align 8
  %2 = call i32 @forge_test_start_spec(ptr @spec_str)
  %widen = sext i32 %2 to i64
  %stcl_classify = load i64, ptr @stcl_classify, align 8
  %cast2 = inttoptr i64 %stcl_classify to ptr
  %3 = call i64 @forge_array_get(ptr %cast2, i64 1)
  %fn_ptr = inttoptr i64 %3 to ptr
  %closure_call = call i64 %fn_ptr(i64 150)
  %eq = icmp eq i64 %closure_call, 3
  %eq_ext = zext i1 %eq to i64
  %4 = call i64 @forge_test_run_then(ptr @spec_str.1, i64 %eq_ext)
  %stcl_classify3 = load i64, ptr @stcl_classify, align 8
  %cast4 = inttoptr i64 %stcl_classify3 to ptr
  %5 = call i64 @forge_array_get(ptr %cast4, i64 1)
  %fn_ptr5 = inttoptr i64 %5 to ptr
  %closure_call6 = call i64 %fn_ptr5(i64 75)
  %eq7 = icmp eq i64 %closure_call6, 2
  %eq_ext8 = zext i1 %eq7 to i64
  %6 = call i64 @forge_test_run_then(ptr @spec_str.2, i64 %eq_ext8)
  %stcl_classify9 = load i64, ptr @stcl_classify, align 8
  %cast10 = inttoptr i64 %stcl_classify9 to ptr
  %7 = call i64 @forge_array_get(ptr %cast10, i64 1)
  %fn_ptr11 = inttoptr i64 %7 to ptr
  %closure_call12 = call i64 %fn_ptr11(i64 25)
  %eq13 = icmp eq i64 %closure_call12, 1
  %eq_ext14 = zext i1 %eq13 to i64
  %8 = call i64 @forge_test_run_then(ptr @spec_str.3, i64 %eq_ext14)
  %stcl_classify15 = load i64, ptr @stcl_classify, align 8
  %cast16 = inttoptr i64 %stcl_classify15 to ptr
  %9 = call i64 @forge_array_get(ptr %cast16, i64 1)
  %fn_ptr17 = inttoptr i64 %9 to ptr
  %closure_call18 = call i64 %fn_ptr17(i64 -5)
  %eq19 = icmp eq i64 %closure_call18, 0
  %eq_ext20 = zext i1 %eq19 to i64
  %10 = call i64 @forge_test_run_then(ptr @spec_str.4, i64 %eq_ext20)
  %11 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %11, i64 1)
  call void @forge_array_push(ptr %11, i64 2)
  call void @forge_array_push(ptr %11, i64 3)
  call void @forge_array_push(ptr %11, i64 4)
  call void @forge_array_push(ptr %11, i64 5)
  store ptr %11, ptr %nums, align 8
  %nums21 = load ptr, ptr %nums, align 8
  %12 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %12, i64 -559038737)
  call void @forge_array_push(ptr %12, i64 ptrtoint (ptr @__lambda_2 to i64))
  %cast22 = ptrtoint ptr %12 to i64
  %13 = call ptr @forge_array_map(ptr %nums21, i64 %cast22)
  store ptr %13, ptr %step1, align 8
  %step123 = load ptr, ptr %step1, align 8
  %14 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %14, i64 -559038737)
  call void @forge_array_push(ptr %14, i64 ptrtoint (ptr @__lambda_3 to i64))
  %cast24 = ptrtoint ptr %14 to i64
  %15 = call ptr @forge_array_map(ptr %step123, i64 %cast24)
  store ptr %15, ptr %step2, align 8
  %step225 = load ptr, ptr %step2, align 8
  %16 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %16, i64 -559038737)
  call void @forge_array_push(ptr %16, i64 ptrtoint (ptr @__lambda_4 to i64))
  %cast26 = ptrtoint ptr %16 to i64
  %17 = call ptr @forge_array_filter(ptr %step225, i64 %cast26)
  store ptr %17, ptr %step3, align 8
  %step327 = load ptr, ptr %step3, align 8
  %18 = call i64 @forge_array_len(ptr %step327)
  %eq28 = icmp eq i64 %18, 3
  %eq_ext29 = zext i1 %eq28 to i64
  %19 = call i64 @forge_test_run_then(ptr @spec_str.5, i64 %eq_ext29)
  %20 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %20, i64 2)
  call void @forge_array_push(ptr %20, i64 3)
  call void @forge_array_push(ptr %20, i64 4)
  call void @forge_array_push(ptr %20, i64 5)
  %21 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %21, i64 -559038737)
  call void @forge_array_push(ptr %21, i64 ptrtoint (ptr @__lambda_5 to i64))
  %cast30 = ptrtoint ptr %21 to i64
  %22 = call i64 @forge_array_reduce(ptr %20, i64 1, i64 %cast30)
  store i64 %22, ptr %product, align 8
  %product31 = load i64, ptr %product, align 8
  %eq32 = icmp eq i64 %product31, 120
  %eq_ext33 = zext i1 %eq32 to i64
  %23 = call i64 @forge_test_run_then(ptr @spec_str.6, i64 %eq_ext33)
  %stcl_double = load i64, ptr @stcl_double, align 8
  %cast34 = inttoptr i64 %stcl_double to ptr
  %24 = call i64 @forge_array_get(ptr %cast34, i64 1)
  %fn_ptr35 = inttoptr i64 %24 to ptr
  %stcl_double36 = load i64, ptr @stcl_double, align 8
  %cast37 = inttoptr i64 %stcl_double36 to ptr
  %25 = call i64 @forge_array_get(ptr %cast37, i64 1)
  %fn_ptr38 = inttoptr i64 %25 to ptr
  %closure_call39 = call i64 %fn_ptr38(i64 3)
  %closure_call40 = call i64 %fn_ptr35(i64 %closure_call39)
  %eq41 = icmp eq i64 %closure_call40, 12
  %eq_ext42 = zext i1 %eq41 to i64
  %26 = call i64 @forge_test_run_then(ptr @spec_str.7, i64 %eq_ext42)
  %27 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %27, i64 1)
  call void @forge_array_push(ptr %27, i64 2)
  call void @forge_array_push(ptr %27, i64 3)
  call void @forge_array_push(ptr %27, i64 4)
  call void @forge_array_push(ptr %27, i64 5)
  call void @forge_array_push(ptr %27, i64 6)
  call void @forge_array_push(ptr %27, i64 7)
  call void @forge_array_push(ptr %27, i64 8)
  call void @forge_array_push(ptr %27, i64 9)
  call void @forge_array_push(ptr %27, i64 10)
  store ptr %27, ptr %data, align 8
  %data43 = load ptr, ptr %data, align 8
  %28 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %28, i64 -559038737)
  call void @forge_array_push(ptr %28, i64 ptrtoint (ptr @__lambda_6 to i64))
  %cast44 = ptrtoint ptr %28 to i64
  %29 = call ptr @forge_array_filter(ptr %data43, i64 %cast44)
  %30 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %30, i64 -559038737)
  call void @forge_array_push(ptr %30, i64 ptrtoint (ptr @__lambda_7 to i64))
  %cast45 = ptrtoint ptr %30 to i64
  %31 = call ptr @forge_array_map(ptr %29, i64 %cast45)
  %32 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %32, i64 -559038737)
  call void @forge_array_push(ptr %32, i64 ptrtoint (ptr @__lambda_8 to i64))
  %cast46 = ptrtoint ptr %32 to i64
  %33 = call i64 @forge_array_reduce(ptr %31, i64 0, i64 %cast46)
  store i64 %33, ptr %even_squares, align 8
  %even_squares47 = load i64, ptr %even_squares, align 8
  %eq48 = icmp eq i64 %even_squares47, 220
  %eq_ext49 = zext i1 %eq48 to i64
  %34 = call i64 @forge_test_run_then(ptr @spec_str.8, i64 %eq_ext49)
  %35 = call i32 @forge_test_end_spec(ptr @spec_str)
  %widen50 = sext i32 %35 to i64
  %36 = call i32 @forge_test_summary()
  %widen51 = sext i32 %36 to i64
  call void @forge_rc_collect()
  ret i64 0
}

define i64 @__lambda_0(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %sgt = icmp sgt i64 %x1, 100
  %sgt_ext = zext i1 %sgt to i64
  %if_cond = icmp ne i64 %sgt_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %x2 = load i64, ptr %x, align 8
  %sgt3 = icmp sgt i64 %x2, 50
  %sgt_ext4 = zext i1 %sgt3 to i64
  %if_cond6 = icmp ne i64 %sgt_ext4, 0
  br i1 %if_cond6, label %if_then7, label %if_else8

if_then:                                          ; preds = %entry
  ret i64 3

if_else:                                          ; preds = %entry
  br label %ifcont

ifcont5:                                          ; preds = %if_else8
  %x9 = load i64, ptr %x, align 8
  %sgt10 = icmp sgt i64 %x9, 0
  %sgt_ext11 = zext i1 %sgt10 to i64
  %if_cond13 = icmp ne i64 %sgt_ext11, 0
  br i1 %if_cond13, label %if_then14, label %if_else15

if_then7:                                         ; preds = %ifcont
  ret i64 2

if_else8:                                         ; preds = %ifcont
  br label %ifcont5

ifcont12:                                         ; preds = %if_else15
  ret i64 0

if_then14:                                        ; preds = %ifcont5
  ret i64 1

if_else15:                                        ; preds = %ifcont5
  br label %ifcont12
}

define i64 @__lambda_1(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %mul = mul i64 %x1, 2
  ret i64 %mul
}

define i64 @__lambda_2(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %mul = mul i64 %x1, 10
  ret i64 %mul
}

define i64 @__lambda_3(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %add = add i64 %x1, 1
  ret i64 %add
}

define i64 @__lambda_4(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %sgt = icmp sgt i64 %x1, 21
  %sgt_ext = zext i1 %sgt to i64
  ret i64 %sgt_ext
}

define i64 @__lambda_5(i64 %0, i64 %1) {
entry:
  %x = alloca i64, align 8
  %acc = alloca i64, align 8
  store i64 %0, ptr %acc, align 8
  store i64 %1, ptr %x, align 8
  %acc1 = load i64, ptr %acc, align 8
  %x2 = load i64, ptr %x, align 8
  %mul = mul i64 %acc1, %x2
  ret i64 %mul
}

define i64 @__lambda_6(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  call void @forge_div_by_zero_trap(i64 0, ptr @dz_file, i64 29, i64 41)
  %mod = srem i64 %x1, 2
  %eq = icmp eq i64 %mod, 0
  %eq_ext = zext i1 %eq to i64
  ret i64 %eq_ext
}

define i64 @__lambda_7(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %x2 = load i64, ptr %x, align 8
  %mul = mul i64 %x1, %x2
  ret i64 %mul
}

define i64 @__lambda_8(i64 %0, i64 %1) {
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
