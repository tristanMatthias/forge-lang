; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Circle = type { double }
%Rect = type { double, double }
%Triangle = type { double }

@.str = private unnamed_addr constant [7 x i8] c"circle\00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"rect\00", align 1
@.str.2 = private unnamed_addr constant [9 x i8] c"triangle\00", align 1
@.float_str = private unnamed_addr constant [4 x i8] c"1.0\00", align 1
@.float_str.3 = private unnamed_addr constant [4 x i8] c"2.0\00", align 1
@.float_str.4 = private unnamed_addr constant [4 x i8] c"3.0\00", align 1
@.float_str.5 = private unnamed_addr constant [4 x i8] c"4.0\00", align 1
@.float_str.6 = private unnamed_addr constant [4 x i8] c"1.0\00", align 1
@.float_str.7 = private unnamed_addr constant [4 x i8] c"2.0\00", align 1
@.float_str.8 = private unnamed_addr constant [4 x i8] c"3.0\00", align 1
@.float_str.9 = private unnamed_addr constant [4 x i8] c"4.0\00", align 1

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

define ptr @Circle__name(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  ret ptr @.str
}

define ptr @Rect__name(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  ret ptr @.str.1
}

define ptr @Triangle__name(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  ret ptr @.str.2
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %s = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %shapes = alloca ptr, align 8
  %1 = call ptr @avra_array_new()
  %2 = call ptr @avra_rc_alloc(i64 8)
  %3 = call i64 @avra_float_parse(ptr @.float_str)
  %cast = bitcast i64 %3 to double
  %fld_ptr = getelementptr inbounds nuw %Circle, ptr %2, i32 0, i32 0
  store double %cast, ptr %fld_ptr, align 8
  %cast1 = ptrtoint ptr %2 to i64
  call void @avra_array_push(ptr %1, i64 %cast1)
  %4 = call ptr @avra_rc_alloc(i64 16)
  %5 = call i64 @avra_float_parse(ptr @.float_str.3)
  %cast2 = bitcast i64 %5 to double
  %fld_ptr3 = getelementptr inbounds nuw %Rect, ptr %4, i32 0, i32 0
  store double %cast2, ptr %fld_ptr3, align 8
  %6 = call i64 @avra_float_parse(ptr @.float_str.4)
  %cast4 = bitcast i64 %6 to double
  %fld_ptr5 = getelementptr inbounds nuw %Rect, ptr %4, i32 0, i32 1
  store double %cast4, ptr %fld_ptr5, align 8
  %cast6 = ptrtoint ptr %4 to i64
  call void @avra_array_push(ptr %1, i64 %cast6)
  %7 = call ptr @avra_rc_alloc(i64 8)
  %8 = call i64 @avra_float_parse(ptr @.float_str.5)
  %cast7 = bitcast i64 %8 to double
  %fld_ptr8 = getelementptr inbounds nuw %Triangle, ptr %7, i32 0, i32 0
  store double %cast7, ptr %fld_ptr8, align 8
  %cast9 = ptrtoint ptr %7 to i64
  call void @avra_array_push(ptr %1, i64 %cast9)
  %9 = call ptr @avra_array_new()
  %10 = call ptr @avra_rc_alloc(i64 8)
  %11 = call i64 @avra_float_parse(ptr @.float_str.6)
  %cast10 = bitcast i64 %11 to double
  %fld_ptr11 = getelementptr inbounds nuw %Circle, ptr %10, i32 0, i32 0
  store double %cast10, ptr %fld_ptr11, align 8
  %cast12 = ptrtoint ptr %10 to i64
  %12 = call ptr @avra_array_new()
  %13 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %13, i64 -559038737)
  call void @avra_array_push(ptr %13, i64 ptrtoint (ptr @Circle__name to i64))
  %cast13 = ptrtoint ptr %13 to i64
  call void @avra_array_push(ptr %12, i64 %cast13)
  %cast14 = inttoptr i64 %cast12 to ptr
  %cast15 = ptrtoint ptr %12 to i64
  %14 = call i64 @avra_trait_object_new(ptr %cast14, i64 %cast15)
  call void @avra_array_push(ptr %9, i64 %14)
  %15 = call ptr @avra_rc_alloc(i64 16)
  %16 = call i64 @avra_float_parse(ptr @.float_str.7)
  %cast16 = bitcast i64 %16 to double
  %fld_ptr17 = getelementptr inbounds nuw %Rect, ptr %15, i32 0, i32 0
  store double %cast16, ptr %fld_ptr17, align 8
  %17 = call i64 @avra_float_parse(ptr @.float_str.8)
  %cast18 = bitcast i64 %17 to double
  %fld_ptr19 = getelementptr inbounds nuw %Rect, ptr %15, i32 0, i32 1
  store double %cast18, ptr %fld_ptr19, align 8
  %cast20 = ptrtoint ptr %15 to i64
  %18 = call ptr @avra_array_new()
  %19 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %19, i64 -559038737)
  call void @avra_array_push(ptr %19, i64 ptrtoint (ptr @Rect__name to i64))
  %cast21 = ptrtoint ptr %19 to i64
  call void @avra_array_push(ptr %18, i64 %cast21)
  %cast22 = inttoptr i64 %cast20 to ptr
  %cast23 = ptrtoint ptr %18 to i64
  %20 = call i64 @avra_trait_object_new(ptr %cast22, i64 %cast23)
  call void @avra_array_push(ptr %9, i64 %20)
  %21 = call ptr @avra_rc_alloc(i64 8)
  %22 = call i64 @avra_float_parse(ptr @.float_str.9)
  %cast24 = bitcast i64 %22 to double
  %fld_ptr25 = getelementptr inbounds nuw %Triangle, ptr %21, i32 0, i32 0
  store double %cast24, ptr %fld_ptr25, align 8
  %cast26 = ptrtoint ptr %21 to i64
  %23 = call ptr @avra_array_new()
  %24 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %24, i64 -559038737)
  call void @avra_array_push(ptr %24, i64 ptrtoint (ptr @Triangle__name to i64))
  %cast27 = ptrtoint ptr %24 to i64
  call void @avra_array_push(ptr %23, i64 %cast27)
  %cast28 = inttoptr i64 %cast26 to ptr
  %cast29 = ptrtoint ptr %23 to i64
  %25 = call i64 @avra_trait_object_new(ptr %cast28, i64 %cast29)
  call void @avra_array_push(ptr %9, i64 %25)
  store ptr %9, ptr %shapes, align 8
  %shapes30 = load ptr, ptr %shapes, align 8
  %26 = call i64 @avra_array_len(ptr %shapes30)
  store i64 %26, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %entry
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %27 = call i64 @avra_array_get(ptr %shapes30, i64 %forin_i_val)
  store i64 %27, ptr %s, align 8
  %s31 = load ptr, ptr %s, align 8
  %28 = call i64 @avra_trait_object_value(ptr %s31)
  %29 = call ptr @avra_trait_object_vtable(ptr %s31)
  %30 = call i64 @avra_array_get(ptr %29, i64 0)
  %31 = call i64 @avra_closure_call_1(i64 %30, i64 %28)
  %cast32 = inttoptr i64 %31 to ptr
  %32 = call i32 @puts(ptr %cast32)
  %widen = sext i32 %32 to i64
  br label %forin.incr

forin.incr:                                       ; preds = %forin.body
  %forin_i_old = load i64, ptr %forin_i, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}
