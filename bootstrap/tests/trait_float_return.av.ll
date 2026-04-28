; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Circle = type { double }
%Rect = type { double, double }

@.float_str = private unnamed_addr constant [5 x i8] c"3.14\00", align 1
@fld_name = private unnamed_addr constant [2 x i8] c"r\00", align 1
@sty_name = private unnamed_addr constant [7 x i8] c"Circle\00", align 1
@src_file = private unnamed_addr constant [105 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_float_return.av\00", align 1
@fld_name.1 = private unnamed_addr constant [2 x i8] c"r\00", align 1
@sty_name.2 = private unnamed_addr constant [7 x i8] c"Circle\00", align 1
@src_file.3 = private unnamed_addr constant [105 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_float_return.av\00", align 1
@.str = private unnamed_addr constant [7 x i8] c"circle\00", align 1
@fld_name.4 = private unnamed_addr constant [2 x i8] c"w\00", align 1
@sty_name.5 = private unnamed_addr constant [5 x i8] c"Rect\00", align 1
@src_file.6 = private unnamed_addr constant [105 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_float_return.av\00", align 1
@fld_name.7 = private unnamed_addr constant [2 x i8] c"h\00", align 1
@sty_name.8 = private unnamed_addr constant [5 x i8] c"Rect\00", align 1
@src_file.9 = private unnamed_addr constant [105 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_float_return.av\00", align 1
@.str.10 = private unnamed_addr constant [5 x i8] c"rect\00", align 1
@.str.11 = private unnamed_addr constant [7 x i8] c" area=\00", align 1
@.float_str.12 = private unnamed_addr constant [4 x i8] c"2.0\00", align 1
@.float_str.13 = private unnamed_addr constant [5 x i8] c"3.14\00", align 1
@fld_name.14 = private unnamed_addr constant [2 x i8] c"r\00", align 1
@sty_name.15 = private unnamed_addr constant [7 x i8] c"Circle\00", align 1
@src_file.16 = private unnamed_addr constant [105 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_float_return.av\00", align 1
@.str.17 = private unnamed_addr constant [7 x i8] c"circle\00", align 1
@.str.18 = private unnamed_addr constant [12 x i8] c" perimeter=\00", align 1
@.float_str.19 = private unnamed_addr constant [4 x i8] c"2.0\00", align 1
@.float_str.20 = private unnamed_addr constant [4 x i8] c"2.0\00", align 1
@.float_str.21 = private unnamed_addr constant [4 x i8] c"3.0\00", align 1
@.float_str.22 = private unnamed_addr constant [4 x i8] c"1.0\00", align 1

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

define double @Circle__area(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %1 = call i64 @avra_float_parse(ptr @.float_str)
  %cast = bitcast i64 %1 to double
  %self1 = load ptr, ptr %self, align 8
  %cast2 = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast2, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 1, ptr @sty_name, i64 6, i64 %null_ext, ptr @src_file, i64 104, i64 14)
  %r_ptr = getelementptr inbounds nuw %Circle, ptr %self1, i32 0, i32 0
  %r = load double, ptr %r_ptr, align 8
  %fmul = fmul double %cast, %r
  %self3 = load ptr, ptr %self, align 8
  %cast4 = ptrtoint ptr %self3 to i64
  %null_chk5 = icmp eq i64 %cast4, 0
  %null_ext6 = zext i1 %null_chk5 to i64
  call void @avra_null_deref_trap(ptr @fld_name.1, i64 1, ptr @sty_name.2, i64 6, i64 %null_ext6, ptr @src_file.3, i64 104, i64 14)
  %r_ptr7 = getelementptr inbounds nuw %Circle, ptr %self3, i32 0, i32 0
  %r8 = load double, ptr %r_ptr7, align 8
  %fmul9 = fmul double %fmul, %r8
  ret double %fmul9
}

define ptr @Circle__name(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  ret ptr @.str
}

define double @Rect__area(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.4, i64 1, ptr @sty_name.5, i64 4, i64 %null_ext, ptr @src_file.6, i64 104, i64 19)
  %w_ptr = getelementptr inbounds nuw %Rect, ptr %self1, i32 0, i32 0
  %w = load double, ptr %w_ptr, align 8
  %self2 = load ptr, ptr %self, align 8
  %cast3 = ptrtoint ptr %self2 to i64
  %null_chk4 = icmp eq i64 %cast3, 0
  %null_ext5 = zext i1 %null_chk4 to i64
  call void @avra_null_deref_trap(ptr @fld_name.7, i64 1, ptr @sty_name.8, i64 4, i64 %null_ext5, ptr @src_file.9, i64 104, i64 19)
  %h_ptr = getelementptr inbounds nuw %Rect, ptr %self2, i32 0, i32 1
  %h = load double, ptr %h_ptr, align 8
  %fmul = fmul double %w, %h
  ret double %fmul
}

define ptr @Rect__name(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  ret ptr @.str.10
}

define i64 @describe(i64 %0) {
entry:
  %s = alloca ptr, align 8
  %cast = inttoptr i64 %0 to ptr
  store ptr %cast, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %1 = call i64 @avra_trait_object_value(ptr %s1)
  %2 = call ptr @avra_trait_object_vtable(ptr %s1)
  %3 = call i64 @avra_array_get(ptr %2, i64 1)
  %4 = call i64 @avra_closure_call_1(i64 %3, i64 %1)
  %cast2 = inttoptr i64 %4 to ptr
  %5 = call i64 @strlen(ptr %cast2)
  %6 = call i64 @strlen(ptr @.str.11)
  %concat_total = add i64 %5, %6
  %concat_size = add i64 %concat_total, 1
  %7 = call ptr @avra_rc_alloc(i64 %concat_size)
  %8 = call ptr @memcpy(ptr %7, ptr %cast2, i64 %5)
  %cast3 = ptrtoint ptr %7 to i64
  %dst2_int = add i64 %cast3, %5
  %cast4 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %6, 1
  %9 = call ptr @memcpy(ptr %cast4, ptr @.str.11, i64 %rhs_len_p1)
  %s5 = load ptr, ptr %s, align 8
  %10 = call i64 @avra_trait_object_value(ptr %s5)
  %11 = call ptr @avra_trait_object_vtable(ptr %s5)
  %12 = call i64 @avra_array_get(ptr %11, i64 0)
  %13 = call i64 @avra_closure_call_1(i64 %12, i64 %10)
  %cast6 = bitcast i64 %13 to double
  %cast7 = bitcast double %cast6 to i64
  %14 = call i64 @avra_float_to_string(i64 %cast7)
  %rhs_ptr = inttoptr i64 %14 to ptr
  %15 = call i64 @strlen(ptr %7)
  %16 = call i64 @strlen(ptr %rhs_ptr)
  %concat_total8 = add i64 %15, %16
  %concat_size9 = add i64 %concat_total8, 1
  %17 = call ptr @avra_rc_alloc(i64 %concat_size9)
  %18 = call ptr @memcpy(ptr %17, ptr %7, i64 %15)
  %cast10 = ptrtoint ptr %17 to i64
  %dst2_int11 = add i64 %cast10, %15
  %cast12 = inttoptr i64 %dst2_int11 to ptr
  %rhs_len_p113 = add i64 %16, 1
  %19 = call ptr @memcpy(ptr %cast12, ptr %rhs_ptr, i64 %rhs_len_p113)
  %20 = call i32 @puts(ptr %17)
  %widen = sext i32 %20 to i64
  ret i64 0
}

define double @Circle__perimeter(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %1 = call i64 @avra_float_parse(ptr @.float_str.12)
  %cast = bitcast i64 %1 to double
  %2 = call i64 @avra_float_parse(ptr @.float_str.13)
  %cast1 = bitcast i64 %2 to double
  %fmul = fmul double %cast, %cast1
  %self2 = load ptr, ptr %self, align 8
  %cast3 = ptrtoint ptr %self2 to i64
  %null_chk = icmp eq i64 %cast3, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.14, i64 1, ptr @sty_name.15, i64 6, i64 %null_ext, ptr @src_file.16, i64 104, i64 33)
  %r_ptr = getelementptr inbounds nuw %Circle, ptr %self2, i32 0, i32 0
  %r = load double, ptr %r_ptr, align 8
  %fmul4 = fmul double %fmul, %r
  ret double %fmul4
}

define ptr @Circle__label(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  ret ptr @.str.17
}

define i64 @show_perimeter(i64 %0) {
entry:
  %s = alloca ptr, align 8
  %cast = inttoptr i64 %0 to ptr
  store ptr %cast, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %1 = call i64 @avra_trait_object_value(ptr %s1)
  %2 = call ptr @avra_trait_object_vtable(ptr %s1)
  %3 = call i64 @avra_array_get(ptr %2, i64 1)
  %4 = call i64 @avra_closure_call_1(i64 %3, i64 %1)
  %cast2 = inttoptr i64 %4 to ptr
  %5 = call i64 @strlen(ptr %cast2)
  %6 = call i64 @strlen(ptr @.str.18)
  %concat_total = add i64 %5, %6
  %concat_size = add i64 %concat_total, 1
  %7 = call ptr @avra_rc_alloc(i64 %concat_size)
  %8 = call ptr @memcpy(ptr %7, ptr %cast2, i64 %5)
  %cast3 = ptrtoint ptr %7 to i64
  %dst2_int = add i64 %cast3, %5
  %cast4 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %6, 1
  %9 = call ptr @memcpy(ptr %cast4, ptr @.str.18, i64 %rhs_len_p1)
  %s5 = load ptr, ptr %s, align 8
  %10 = call i64 @avra_trait_object_value(ptr %s5)
  %11 = call ptr @avra_trait_object_vtable(ptr %s5)
  %12 = call i64 @avra_array_get(ptr %11, i64 0)
  %13 = call i64 @avra_closure_call_1(i64 %12, i64 %10)
  %cast6 = bitcast i64 %13 to double
  %cast7 = bitcast double %cast6 to i64
  %14 = call i64 @avra_float_to_string(i64 %cast7)
  %rhs_ptr = inttoptr i64 %14 to ptr
  %15 = call i64 @strlen(ptr %7)
  %16 = call i64 @strlen(ptr %rhs_ptr)
  %concat_total8 = add i64 %15, %16
  %concat_size9 = add i64 %concat_total8, 1
  %17 = call ptr @avra_rc_alloc(i64 %concat_size9)
  %18 = call ptr @memcpy(ptr %17, ptr %7, i64 %15)
  %cast10 = ptrtoint ptr %17 to i64
  %dst2_int11 = add i64 %cast10, %15
  %cast12 = inttoptr i64 %dst2_int11 to ptr
  %rhs_len_p113 = add i64 %16, 1
  %19 = call ptr @memcpy(ptr %cast12, ptr %rhs_ptr, i64 %rhs_len_p113)
  %20 = call i32 @puts(ptr %17)
  %widen = sext i32 %20 to i64
  ret i64 0
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %1 = call ptr @avra_rc_alloc(i64 8)
  %2 = call i64 @avra_float_parse(ptr @.float_str.19)
  %cast = bitcast i64 %2 to double
  %fld_ptr = getelementptr inbounds nuw %Circle, ptr %1, i32 0, i32 0
  store double %cast, ptr %fld_ptr, align 8
  %cast1 = ptrtoint ptr %1 to i64
  %3 = call ptr @avra_array_new()
  %4 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %4, i64 -559038737)
  call void @avra_array_push(ptr %4, i64 ptrtoint (ptr @Circle__area__vtable_wrap to i64))
  %cast2 = ptrtoint ptr %4 to i64
  call void @avra_array_push(ptr %3, i64 %cast2)
  %5 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %5, i64 -559038737)
  call void @avra_array_push(ptr %5, i64 ptrtoint (ptr @Circle__name to i64))
  %cast3 = ptrtoint ptr %5 to i64
  call void @avra_array_push(ptr %3, i64 %cast3)
  %cast4 = inttoptr i64 %cast1 to ptr
  %cast5 = ptrtoint ptr %3 to i64
  %6 = call i64 @avra_trait_object_new(ptr %cast4, i64 %cast5)
  %7 = call i64 @describe(i64 %6)
  %8 = call ptr @avra_rc_alloc(i64 16)
  %9 = call i64 @avra_float_parse(ptr @.float_str.20)
  %cast6 = bitcast i64 %9 to double
  %fld_ptr7 = getelementptr inbounds nuw %Rect, ptr %8, i32 0, i32 0
  store double %cast6, ptr %fld_ptr7, align 8
  %10 = call i64 @avra_float_parse(ptr @.float_str.21)
  %cast8 = bitcast i64 %10 to double
  %fld_ptr9 = getelementptr inbounds nuw %Rect, ptr %8, i32 0, i32 1
  store double %cast8, ptr %fld_ptr9, align 8
  %cast10 = ptrtoint ptr %8 to i64
  %11 = call ptr @avra_array_new()
  %12 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %12, i64 -559038737)
  call void @avra_array_push(ptr %12, i64 ptrtoint (ptr @Rect__area__vtable_wrap to i64))
  %cast11 = ptrtoint ptr %12 to i64
  call void @avra_array_push(ptr %11, i64 %cast11)
  %13 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %13, i64 -559038737)
  call void @avra_array_push(ptr %13, i64 ptrtoint (ptr @Rect__name to i64))
  %cast12 = ptrtoint ptr %13 to i64
  call void @avra_array_push(ptr %11, i64 %cast12)
  %cast13 = inttoptr i64 %cast10 to ptr
  %cast14 = ptrtoint ptr %11 to i64
  %14 = call i64 @avra_trait_object_new(ptr %cast13, i64 %cast14)
  %15 = call i64 @describe(i64 %14)
  %16 = call ptr @avra_rc_alloc(i64 8)
  %17 = call i64 @avra_float_parse(ptr @.float_str.22)
  %cast15 = bitcast i64 %17 to double
  %fld_ptr16 = getelementptr inbounds nuw %Circle, ptr %16, i32 0, i32 0
  store double %cast15, ptr %fld_ptr16, align 8
  %cast17 = ptrtoint ptr %16 to i64
  %18 = call ptr @avra_array_new()
  %19 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %19, i64 -559038737)
  call void @avra_array_push(ptr %19, i64 ptrtoint (ptr @Circle__perimeter__vtable_wrap to i64))
  %cast18 = ptrtoint ptr %19 to i64
  call void @avra_array_push(ptr %18, i64 %cast18)
  %20 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %20, i64 -559038737)
  call void @avra_array_push(ptr %20, i64 ptrtoint (ptr @Circle__label to i64))
  %cast19 = ptrtoint ptr %20 to i64
  call void @avra_array_push(ptr %18, i64 %cast19)
  %cast20 = inttoptr i64 %cast17 to ptr
  %cast21 = ptrtoint ptr %18 to i64
  %21 = call i64 @avra_trait_object_new(ptr %cast20, i64 %cast21)
  %22 = call i64 @show_perimeter(i64 %21)
  ret i64 %22
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @Circle__area__vtable_wrap(i64 %0) {
entry:
  %cast = inttoptr i64 %0 to ptr
  %vcall = call double @Circle__area(ptr %cast)
  %f2i = bitcast double %vcall to i64
  ret i64 %f2i
}

define i64 @Rect__area__vtable_wrap(i64 %0) {
entry:
  %cast = inttoptr i64 %0 to ptr
  %vcall = call double @Rect__area(ptr %cast)
  %f2i = bitcast double %vcall to i64
  ret i64 %f2i
}

define i64 @Circle__perimeter__vtable_wrap(i64 %0) {
entry:
  %cast = inttoptr i64 %0 to ptr
  %vcall = call double @Circle__perimeter(ptr %cast)
  %f2i = bitcast double %vcall to i64
  ret i64 %f2i
}
