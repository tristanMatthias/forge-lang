; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Point = type { i64, i64 }

@p = global i64 0
@x = global i64 0
@.str = private unnamed_addr constant [7 x i8] c"hello \00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"!\00", align 1
@.str.2 = private unnamed_addr constant [7 x i8] c"point(\00", align 1
@fld_name = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_template_complex.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.3 = private unnamed_addr constant [3 x i8] c", \00", align 1
@fld_name.4 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@sty_name.5 = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file.6 = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_template_complex.av\00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.8 = private unnamed_addr constant [2 x i8] c")\00", align 1
@.str.9 = private unnamed_addr constant [6 x i8] c"world\00", align 1
@.str.10 = private unnamed_addr constant [9 x i8] c"result: \00", align 1
@.str.11 = private unnamed_addr constant [6 x i8] c"forge\00", align 1
@.str.12 = private unnamed_addr constant [7 x i8] c"sign: \00", align 1
@.str.13 = private unnamed_addr constant [9 x i8] c"positive\00", align 1
@.str.14 = private unnamed_addr constant [9 x i8] c"negative\00", align 1

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

define ptr @greet(ptr %0) {
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
  %6 = call i64 @strlen(ptr %3)
  %7 = call i64 @strlen(ptr @.str.1)
  %concat_total3 = add i64 %6, %7
  %concat_size4 = add i64 %concat_total3, 1
  %8 = call ptr @avra_rc_alloc(i64 %concat_size4)
  %9 = call ptr @memcpy(ptr %8, ptr %3, i64 %6)
  %cast5 = ptrtoint ptr %8 to i64
  %dst2_int6 = add i64 %cast5, %6
  %cast7 = inttoptr i64 %dst2_int6 to ptr
  %rhs_len_p18 = add i64 %7, 1
  %10 = call ptr @memcpy(ptr %cast7, ptr @.str.1, i64 %rhs_len_p18)
  ret ptr %8
}

define i64 @main() {
entry:
  %ife_result = alloca i64, align 8
  %0 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %Point, ptr %0, i32 0, i32 0
  store i64 10, ptr %fld_ptr, align 8
  %fld_ptr1 = getelementptr inbounds nuw %Point, ptr %0, i32 0, i32 1
  store i64 20, ptr %fld_ptr1, align 8
  %cast = ptrtoint ptr %0 to i64
  store i64 %cast, ptr @p, align 8
  %p = load ptr, ptr @p, align 8
  %cast2 = ptrtoint ptr %p to i64
  %null_chk = icmp eq i64 %cast2, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 1, ptr @sty_name, i64 5, i64 %null_ext, ptr @src_file, i64 107, i64 4)
  %x_ptr = getelementptr inbounds nuw %Point, ptr %p, i32 0, i32 0
  %x = load i64, ptr %x_ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %x)
  %widen = sext i32 %2 to i64
  %3 = call i64 @strlen(ptr @.str.2)
  %4 = call i64 @strlen(ptr %1)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @avra_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr @.str.2, i64 %3)
  %cast3 = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast3, %3
  %cast4 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast4, ptr %1, i64 %rhs_len_p1)
  %8 = call i64 @strlen(ptr %5)
  %9 = call i64 @strlen(ptr @.str.3)
  %concat_total5 = add i64 %8, %9
  %concat_size6 = add i64 %concat_total5, 1
  %10 = call ptr @avra_rc_alloc(i64 %concat_size6)
  %11 = call ptr @memcpy(ptr %10, ptr %5, i64 %8)
  %cast7 = ptrtoint ptr %10 to i64
  %dst2_int8 = add i64 %cast7, %8
  %cast9 = inttoptr i64 %dst2_int8 to ptr
  %rhs_len_p110 = add i64 %9, 1
  %12 = call ptr @memcpy(ptr %cast9, ptr @.str.3, i64 %rhs_len_p110)
  %p11 = load ptr, ptr @p, align 8
  %cast12 = ptrtoint ptr %p11 to i64
  %null_chk13 = icmp eq i64 %cast12, 0
  %null_ext14 = zext i1 %null_chk13 to i64
  call void @avra_null_deref_trap(ptr @fld_name.4, i64 1, ptr @sty_name.5, i64 5, i64 %null_ext14, ptr @src_file.6, i64 107, i64 4)
  %y_ptr = getelementptr inbounds nuw %Point, ptr %p11, i32 0, i32 1
  %y = load i64, ptr %y_ptr, align 8
  %13 = call ptr @avra_rc_alloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @.i2s_fmt.7, i64 %y)
  %widen15 = sext i32 %14 to i64
  %15 = call i64 @strlen(ptr %10)
  %16 = call i64 @strlen(ptr %13)
  %concat_total16 = add i64 %15, %16
  %concat_size17 = add i64 %concat_total16, 1
  %17 = call ptr @avra_rc_alloc(i64 %concat_size17)
  %18 = call ptr @memcpy(ptr %17, ptr %10, i64 %15)
  %cast18 = ptrtoint ptr %17 to i64
  %dst2_int19 = add i64 %cast18, %15
  %cast20 = inttoptr i64 %dst2_int19 to ptr
  %rhs_len_p121 = add i64 %16, 1
  %19 = call ptr @memcpy(ptr %cast20, ptr %13, i64 %rhs_len_p121)
  %20 = call i64 @strlen(ptr %17)
  %21 = call i64 @strlen(ptr @.str.8)
  %concat_total22 = add i64 %20, %21
  %concat_size23 = add i64 %concat_total22, 1
  %22 = call ptr @avra_rc_alloc(i64 %concat_size23)
  %23 = call ptr @memcpy(ptr %22, ptr %17, i64 %20)
  %cast24 = ptrtoint ptr %22 to i64
  %dst2_int25 = add i64 %cast24, %20
  %cast26 = inttoptr i64 %dst2_int25 to ptr
  %rhs_len_p127 = add i64 %21, 1
  %24 = call ptr @memcpy(ptr %cast26, ptr @.str.8, i64 %rhs_len_p127)
  %25 = call i32 @puts(ptr %22)
  %widen28 = sext i32 %25 to i64
  %26 = call ptr @greet(ptr @.str.9)
  %27 = call i32 @puts(ptr %26)
  %widen29 = sext i32 %27 to i64
  %28 = call ptr @greet(ptr @.str.11)
  %29 = call i64 @strlen(ptr @.str.10)
  %30 = call i64 @strlen(ptr %28)
  %concat_total30 = add i64 %29, %30
  %concat_size31 = add i64 %concat_total30, 1
  %31 = call ptr @avra_rc_alloc(i64 %concat_size31)
  %32 = call ptr @memcpy(ptr %31, ptr @.str.10, i64 %29)
  %cast32 = ptrtoint ptr %31 to i64
  %dst2_int33 = add i64 %cast32, %29
  %cast34 = inttoptr i64 %dst2_int33 to ptr
  %rhs_len_p135 = add i64 %30, 1
  %33 = call ptr @memcpy(ptr %cast34, ptr %28, i64 %rhs_len_p135)
  %34 = call i32 @puts(ptr %31)
  %widen36 = sext i32 %34 to i64
  store i64 5, ptr @x, align 8
  %x37 = load i64, ptr @x, align 8
  %sgt = icmp sgt i64 %x37, 0
  %sgt_ext = zext i1 %sgt to i64
  %ife_cond = icmp ne i64 %sgt_ext, 0
  br i1 %ife_cond, label %ife_then, label %ife_else

ife_end:                                          ; preds = %ife_else, %ife_then
  %ife_val = load i64, ptr %ife_result, align 8
  %rhs_ptr = inttoptr i64 %ife_val to ptr
  %35 = call i64 @strlen(ptr @.str.12)
  %36 = call i64 @strlen(ptr %rhs_ptr)
  %concat_total38 = add i64 %35, %36
  %concat_size39 = add i64 %concat_total38, 1
  %37 = call ptr @avra_rc_alloc(i64 %concat_size39)
  %38 = call ptr @memcpy(ptr %37, ptr @.str.12, i64 %35)
  %cast40 = ptrtoint ptr %37 to i64
  %dst2_int41 = add i64 %cast40, %35
  %cast42 = inttoptr i64 %dst2_int41 to ptr
  %rhs_len_p143 = add i64 %36, 1
  %39 = call ptr @memcpy(ptr %cast42, ptr %rhs_ptr, i64 %rhs_len_p143)
  %40 = call i32 @puts(ptr %37)
  %widen44 = sext i32 %40 to i64
  %41 = call i32 @avra_test_summary()
  %widen45 = sext i32 %41 to i64
  call void @avra_rc_collect()
  ret i64 0

ife_then:                                         ; preds = %entry
  store i64 ptrtoint (ptr @.str.13 to i64), ptr %ife_result, align 8
  br label %ife_end

ife_else:                                         ; preds = %entry
  store i64 ptrtoint (ptr @.str.14 to i64), ptr %ife_result, align 8
  br label %ife_end
}
