; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Circle = type { i64 }
%Rect = type { i64, i64 }

@.str = private unnamed_addr constant [10 x i8] c"circle r=\00", align 1
@fld_name = private unnamed_addr constant [2 x i8] c"r\00", align 1
@sty_name = private unnamed_addr constant [7 x i8] c"Circle\00", align 1
@src_file = private unnamed_addr constant [101 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/dyn_trait_list.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"rect \00", align 1
@fld_name.2 = private unnamed_addr constant [2 x i8] c"w\00", align 1
@sty_name.3 = private unnamed_addr constant [5 x i8] c"Rect\00", align 1
@src_file.4 = private unnamed_addr constant [101 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/dyn_trait_list.av\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@fld_name.7 = private unnamed_addr constant [2 x i8] c"h\00", align 1
@sty_name.8 = private unnamed_addr constant [5 x i8] c"Rect\00", align 1
@src_file.9 = private unnamed_addr constant [101 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/dyn_trait_list.av\00", align 1
@.i2s_fmt.10 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.11 = private unnamed_addr constant [9 x i8] c"shapes: \00", align 1
@.i2s_fmt.12 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.13 = private unnamed_addr constant [8 x i8] c"first: \00", align 1

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

define ptr @Circle__describe(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 1, ptr @sty_name, i64 6, i64 %null_ext, ptr @src_file, i64 100, i64 14)
  %r_ptr = getelementptr inbounds nuw %Circle, ptr %self1, i32 0, i32 0
  %r = load i64, ptr %r_ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %r)
  %widen = sext i32 %2 to i64
  %3 = call i64 @strlen(ptr @.str)
  %4 = call i64 @strlen(ptr %1)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @avra_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr @.str, i64 %3)
  %cast2 = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast2, %3
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast3, ptr %1, i64 %rhs_len_p1)
  ret ptr %5
}

define ptr @Rect__describe(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.2, i64 1, ptr @sty_name.3, i64 4, i64 %null_ext, ptr @src_file.4, i64 100, i64 18)
  %w_ptr = getelementptr inbounds nuw %Rect, ptr %self1, i32 0, i32 0
  %w = load i64, ptr %w_ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt.5, i64 %w)
  %widen = sext i32 %2 to i64
  %3 = call i64 @strlen(ptr @.str.1)
  %4 = call i64 @strlen(ptr %1)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @avra_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr @.str.1, i64 %3)
  %cast2 = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast2, %3
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast3, ptr %1, i64 %rhs_len_p1)
  %8 = call i64 @strlen(ptr %5)
  %9 = call i64 @strlen(ptr @.str.6)
  %concat_total4 = add i64 %8, %9
  %concat_size5 = add i64 %concat_total4, 1
  %10 = call ptr @avra_rc_alloc(i64 %concat_size5)
  %11 = call ptr @memcpy(ptr %10, ptr %5, i64 %8)
  %cast6 = ptrtoint ptr %10 to i64
  %dst2_int7 = add i64 %cast6, %8
  %cast8 = inttoptr i64 %dst2_int7 to ptr
  %rhs_len_p19 = add i64 %9, 1
  %12 = call ptr @memcpy(ptr %cast8, ptr @.str.6, i64 %rhs_len_p19)
  %self10 = load ptr, ptr %self, align 8
  %cast11 = ptrtoint ptr %self10 to i64
  %null_chk12 = icmp eq i64 %cast11, 0
  %null_ext13 = zext i1 %null_chk12 to i64
  call void @avra_null_deref_trap(ptr @fld_name.7, i64 1, ptr @sty_name.8, i64 4, i64 %null_ext13, ptr @src_file.9, i64 100, i64 18)
  %h_ptr = getelementptr inbounds nuw %Rect, ptr %self10, i32 0, i32 1
  %h = load i64, ptr %h_ptr, align 8
  %13 = call ptr @avra_rc_alloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @.i2s_fmt.10, i64 %h)
  %widen14 = sext i32 %14 to i64
  %15 = call i64 @strlen(ptr %10)
  %16 = call i64 @strlen(ptr %13)
  %concat_total15 = add i64 %15, %16
  %concat_size16 = add i64 %concat_total15, 1
  %17 = call ptr @avra_rc_alloc(i64 %concat_size16)
  %18 = call ptr @memcpy(ptr %17, ptr %10, i64 %15)
  %cast17 = ptrtoint ptr %17 to i64
  %dst2_int18 = add i64 %cast17, %15
  %cast19 = inttoptr i64 %dst2_int18 to ptr
  %rhs_len_p120 = add i64 %16, 1
  %19 = call ptr @memcpy(ptr %cast19, ptr %13, i64 %rhs_len_p120)
  ret ptr %17
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %first = alloca ptr, align 8
  %shapes = alloca ptr, align 8
  %1 = call ptr @avra_array_new()
  %2 = call ptr @avra_rc_alloc(i64 8)
  %fld_ptr = getelementptr inbounds nuw %Circle, ptr %2, i32 0, i32 0
  store i64 5, ptr %fld_ptr, align 8
  %cast = ptrtoint ptr %2 to i64
  call void @avra_array_push(ptr %1, i64 %cast)
  %3 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr1 = getelementptr inbounds nuw %Rect, ptr %3, i32 0, i32 0
  store i64 3, ptr %fld_ptr1, align 8
  %fld_ptr2 = getelementptr inbounds nuw %Rect, ptr %3, i32 0, i32 1
  store i64 4, ptr %fld_ptr2, align 8
  %cast3 = ptrtoint ptr %3 to i64
  call void @avra_array_push(ptr %1, i64 %cast3)
  %4 = call ptr @avra_array_new()
  %5 = call ptr @avra_rc_alloc(i64 8)
  %fld_ptr4 = getelementptr inbounds nuw %Circle, ptr %5, i32 0, i32 0
  store i64 5, ptr %fld_ptr4, align 8
  %cast5 = ptrtoint ptr %5 to i64
  %6 = call ptr @avra_array_new()
  %7 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %7, i64 -559038737)
  call void @avra_array_push(ptr %7, i64 ptrtoint (ptr @Circle__describe to i64))
  %cast6 = ptrtoint ptr %7 to i64
  call void @avra_array_push(ptr %6, i64 %cast6)
  %cast7 = inttoptr i64 %cast5 to ptr
  %cast8 = ptrtoint ptr %6 to i64
  %8 = call i64 @avra_trait_object_new(ptr %cast7, i64 %cast8)
  call void @avra_array_push(ptr %4, i64 %8)
  %9 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr9 = getelementptr inbounds nuw %Rect, ptr %9, i32 0, i32 0
  store i64 3, ptr %fld_ptr9, align 8
  %fld_ptr10 = getelementptr inbounds nuw %Rect, ptr %9, i32 0, i32 1
  store i64 4, ptr %fld_ptr10, align 8
  %cast11 = ptrtoint ptr %9 to i64
  %10 = call ptr @avra_array_new()
  %11 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %11, i64 -559038737)
  call void @avra_array_push(ptr %11, i64 ptrtoint (ptr @Rect__describe to i64))
  %cast12 = ptrtoint ptr %11 to i64
  call void @avra_array_push(ptr %10, i64 %cast12)
  %cast13 = inttoptr i64 %cast11 to ptr
  %cast14 = ptrtoint ptr %10 to i64
  %12 = call i64 @avra_trait_object_new(ptr %cast13, i64 %cast14)
  call void @avra_array_push(ptr %4, i64 %12)
  store ptr %4, ptr %shapes, align 8
  %shapes15 = load ptr, ptr %shapes, align 8
  %13 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %13, i64 -559038737)
  call void @avra_array_push(ptr %13, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast16 = ptrtoint ptr %13 to i64
  call void @avra_array_foreach(ptr %shapes15, i64 %cast16)
  %shapes17 = load ptr, ptr %shapes, align 8
  %14 = call i64 @avra_array_len(ptr %shapes17)
  %15 = call ptr @avra_rc_alloc(i64 32)
  %16 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %15, i64 32, ptr @.i2s_fmt.12, i64 %14)
  %widen = sext i32 %16 to i64
  %17 = call i64 @strlen(ptr @.str.11)
  %18 = call i64 @strlen(ptr %15)
  %concat_total = add i64 %17, %18
  %concat_size = add i64 %concat_total, 1
  %19 = call ptr @avra_rc_alloc(i64 %concat_size)
  %20 = call ptr @memcpy(ptr %19, ptr @.str.11, i64 %17)
  %cast18 = ptrtoint ptr %19 to i64
  %dst2_int = add i64 %cast18, %17
  %cast19 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %18, 1
  %21 = call ptr @memcpy(ptr %cast19, ptr %15, i64 %rhs_len_p1)
  %22 = call i32 @puts(ptr %19)
  %widen20 = sext i32 %22 to i64
  %shapes21 = load ptr, ptr %shapes, align 8
  %23 = call i64 @avra_array_get(ptr %shapes21, i64 0)
  %cast22 = inttoptr i64 %23 to ptr
  store ptr %cast22, ptr %first, align 8
  %first23 = load ptr, ptr %first, align 8
  %24 = call i64 @avra_trait_object_value(ptr %first23)
  %25 = call ptr @avra_trait_object_vtable(ptr %first23)
  %26 = call i64 @avra_array_get(ptr %25, i64 0)
  %27 = call i64 @avra_closure_call_1(i64 %26, i64 %24)
  %cast24 = inttoptr i64 %27 to ptr
  %28 = call i64 @strlen(ptr @.str.13)
  %29 = call i64 @strlen(ptr %cast24)
  %concat_total25 = add i64 %28, %29
  %concat_size26 = add i64 %concat_total25, 1
  %30 = call ptr @avra_rc_alloc(i64 %concat_size26)
  %31 = call ptr @memcpy(ptr %30, ptr @.str.13, i64 %28)
  %cast27 = ptrtoint ptr %30 to i64
  %dst2_int28 = add i64 %cast27, %28
  %cast29 = inttoptr i64 %dst2_int28 to ptr
  %rhs_len_p130 = add i64 %29, 1
  %32 = call ptr @memcpy(ptr %cast29, ptr %cast24, i64 %rhs_len_p130)
  %33 = call i32 @puts(ptr %30)
  %widen31 = sext i32 %33 to i64
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__lambda_0(ptr %0) {
entry:
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %1 = call i64 @avra_trait_object_value(ptr %s1)
  %2 = call ptr @avra_trait_object_vtable(ptr %s1)
  %3 = call i64 @avra_array_get(ptr %2, i64 0)
  %4 = call i64 @avra_closure_call_1(i64 %3, i64 %1)
  %cast = inttoptr i64 %4 to ptr
  %5 = call i32 @puts(ptr %cast)
  %widen = sext i32 %5 to i64
  ret i64 0
}
