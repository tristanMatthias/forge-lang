; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@log_output = global i64 0
@.str = private unnamed_addr constant [7 x i8] c"root: \00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"main_app\00", align 1
@.str.2 = private unnamed_addr constant [8 x i8] c"child: \00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"sub1\00", align 1
@.str.4 = private unnamed_addr constant [9 x i8] c" parent=\00", align 1
@.str.5 = private unnamed_addr constant [9 x i8] c"main_app\00", align 1
@.str.6 = private unnamed_addr constant [8 x i8] c"child: \00", align 1
@.str.7 = private unnamed_addr constant [5 x i8] c"sub2\00", align 1
@.str.8 = private unnamed_addr constant [9 x i8] c" parent=\00", align 1
@.str.9 = private unnamed_addr constant [9 x i8] c"main_app\00", align 1
@.str.10 = private unnamed_addr constant [5 x i8] c"done\00", align 1
@.str.11 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

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

declare i64 @avra_process_exit(i64)

define i64 @log(ptr %0) {
entry:
  %msg = alloca ptr, align 8
  store ptr %0, ptr %msg, align 8
  %msg1 = load ptr, ptr %msg, align 8
  %1 = call i32 @puts(ptr %msg1)
  %widen = sext i32 %1 to i64
  ret i64 0
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %main_app = alloca i64, align 8
  store i64 0, ptr %main_app, align 8
  %1 = call i64 @strlen(ptr @.str)
  %2 = call i64 @strlen(ptr @.str.1)
  %concat_total = add i64 %1, %2
  %concat_size = add i64 %concat_total, 1
  %3 = call ptr @avra_rc_alloc(i64 %concat_size)
  %4 = call ptr @memcpy(ptr %3, ptr @.str, i64 %1)
  %cast = ptrtoint ptr %3 to i64
  %dst2_int = add i64 %cast, %1
  %cast1 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %2, 1
  %5 = call ptr @memcpy(ptr %cast1, ptr @.str.1, i64 %rhs_len_p1)
  %6 = call i64 @log(ptr %3)
  %7 = call i64 @strlen(ptr @.str.2)
  %8 = call i64 @strlen(ptr @.str.3)
  %concat_total2 = add i64 %7, %8
  %concat_size3 = add i64 %concat_total2, 1
  %9 = call ptr @avra_rc_alloc(i64 %concat_size3)
  %10 = call ptr @memcpy(ptr %9, ptr @.str.2, i64 %7)
  %cast4 = ptrtoint ptr %9 to i64
  %dst2_int5 = add i64 %cast4, %7
  %cast6 = inttoptr i64 %dst2_int5 to ptr
  %rhs_len_p17 = add i64 %8, 1
  %11 = call ptr @memcpy(ptr %cast6, ptr @.str.3, i64 %rhs_len_p17)
  %12 = call i64 @strlen(ptr %9)
  %13 = call i64 @strlen(ptr @.str.4)
  %concat_total8 = add i64 %12, %13
  %concat_size9 = add i64 %concat_total8, 1
  %14 = call ptr @avra_rc_alloc(i64 %concat_size9)
  %15 = call ptr @memcpy(ptr %14, ptr %9, i64 %12)
  %cast10 = ptrtoint ptr %14 to i64
  %dst2_int11 = add i64 %cast10, %12
  %cast12 = inttoptr i64 %dst2_int11 to ptr
  %rhs_len_p113 = add i64 %13, 1
  %16 = call ptr @memcpy(ptr %cast12, ptr @.str.4, i64 %rhs_len_p113)
  %17 = call i64 @strlen(ptr %14)
  %18 = call i64 @strlen(ptr @.str.5)
  %concat_total14 = add i64 %17, %18
  %concat_size15 = add i64 %concat_total14, 1
  %19 = call ptr @avra_rc_alloc(i64 %concat_size15)
  %20 = call ptr @memcpy(ptr %19, ptr %14, i64 %17)
  %cast16 = ptrtoint ptr %19 to i64
  %dst2_int17 = add i64 %cast16, %17
  %cast18 = inttoptr i64 %dst2_int17 to ptr
  %rhs_len_p119 = add i64 %18, 1
  %21 = call ptr @memcpy(ptr %cast18, ptr @.str.5, i64 %rhs_len_p119)
  %22 = call i64 @log(ptr %19)
  %23 = call i64 @strlen(ptr @.str.6)
  %24 = call i64 @strlen(ptr @.str.7)
  %concat_total20 = add i64 %23, %24
  %concat_size21 = add i64 %concat_total20, 1
  %25 = call ptr @avra_rc_alloc(i64 %concat_size21)
  %26 = call ptr @memcpy(ptr %25, ptr @.str.6, i64 %23)
  %cast22 = ptrtoint ptr %25 to i64
  %dst2_int23 = add i64 %cast22, %23
  %cast24 = inttoptr i64 %dst2_int23 to ptr
  %rhs_len_p125 = add i64 %24, 1
  %27 = call ptr @memcpy(ptr %cast24, ptr @.str.7, i64 %rhs_len_p125)
  %28 = call i64 @strlen(ptr %25)
  %29 = call i64 @strlen(ptr @.str.8)
  %concat_total26 = add i64 %28, %29
  %concat_size27 = add i64 %concat_total26, 1
  %30 = call ptr @avra_rc_alloc(i64 %concat_size27)
  %31 = call ptr @memcpy(ptr %30, ptr %25, i64 %28)
  %cast28 = ptrtoint ptr %30 to i64
  %dst2_int29 = add i64 %cast28, %28
  %cast30 = inttoptr i64 %dst2_int29 to ptr
  %rhs_len_p131 = add i64 %29, 1
  %32 = call ptr @memcpy(ptr %cast30, ptr @.str.8, i64 %rhs_len_p131)
  %33 = call i64 @strlen(ptr %30)
  %34 = call i64 @strlen(ptr @.str.9)
  %concat_total32 = add i64 %33, %34
  %concat_size33 = add i64 %concat_total32, 1
  %35 = call ptr @avra_rc_alloc(i64 %concat_size33)
  %36 = call ptr @memcpy(ptr %35, ptr %30, i64 %33)
  %cast34 = ptrtoint ptr %35 to i64
  %dst2_int35 = add i64 %cast34, %33
  %cast36 = inttoptr i64 %dst2_int35 to ptr
  %rhs_len_p137 = add i64 %34, 1
  %37 = call ptr @memcpy(ptr %cast36, ptr @.str.9, i64 %rhs_len_p137)
  %38 = call i64 @log(ptr %35)
  %39 = call i32 @puts(ptr @.str.10)
  %widen = sext i32 %39 to i64
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  store ptr @.str.11, ptr @log_output, align 8
  call void @avra_rc_collect()
  ret i64 0
}
