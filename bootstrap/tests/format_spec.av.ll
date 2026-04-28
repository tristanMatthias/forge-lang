; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@.float_str = private unnamed_addr constant [11 x i8] c"3.14159265\00", align 1
@.str = private unnamed_addr constant [7 x i8] c"pi is \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c".2f\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"sci \00", align 1
@.str.3 = private unnamed_addr constant [4 x i8] c".3e\00", align 1
@.str.4 = private unnamed_addr constant [5 x i8] c"hex \00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.str.6 = private unnamed_addr constant [8 x i8] c"padded \00", align 1
@.str.7 = private unnamed_addr constant [4 x i8] c"08d\00", align 1

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

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %x = alloca i64, align 8
  %pi = alloca double, align 8
  %1 = call i64 @avra_float_parse(ptr @.float_str)
  %cast = bitcast i64 %1 to double
  store double %cast, ptr %pi, align 8
  %pi1 = load double, ptr %pi, align 8
  %cast2 = bitcast double %pi1 to i64
  %2 = call ptr @avra_format_float(i64 %cast2, ptr @.str.1)
  %3 = call i64 @strlen(ptr @.str)
  %4 = call i64 @strlen(ptr %2)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @avra_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr @.str, i64 %3)
  %cast3 = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast3, %3
  %cast4 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast4, ptr %2, i64 %rhs_len_p1)
  %8 = call i32 @puts(ptr %5)
  %widen = sext i32 %8 to i64
  %pi5 = load double, ptr %pi, align 8
  %cast6 = bitcast double %pi5 to i64
  %9 = call ptr @avra_format_float(i64 %cast6, ptr @.str.3)
  %10 = call i64 @strlen(ptr @.str.2)
  %11 = call i64 @strlen(ptr %9)
  %concat_total7 = add i64 %10, %11
  %concat_size8 = add i64 %concat_total7, 1
  %12 = call ptr @avra_rc_alloc(i64 %concat_size8)
  %13 = call ptr @memcpy(ptr %12, ptr @.str.2, i64 %10)
  %cast9 = ptrtoint ptr %12 to i64
  %dst2_int10 = add i64 %cast9, %10
  %cast11 = inttoptr i64 %dst2_int10 to ptr
  %rhs_len_p112 = add i64 %11, 1
  %14 = call ptr @memcpy(ptr %cast11, ptr %9, i64 %rhs_len_p112)
  %15 = call i32 @puts(ptr %12)
  %widen13 = sext i32 %15 to i64
  store i64 255, ptr %x, align 8
  %x14 = load i64, ptr %x, align 8
  %16 = call ptr @avra_format_int(i64 %x14, ptr @.str.5)
  %17 = call i64 @strlen(ptr @.str.4)
  %18 = call i64 @strlen(ptr %16)
  %concat_total15 = add i64 %17, %18
  %concat_size16 = add i64 %concat_total15, 1
  %19 = call ptr @avra_rc_alloc(i64 %concat_size16)
  %20 = call ptr @memcpy(ptr %19, ptr @.str.4, i64 %17)
  %cast17 = ptrtoint ptr %19 to i64
  %dst2_int18 = add i64 %cast17, %17
  %cast19 = inttoptr i64 %dst2_int18 to ptr
  %rhs_len_p120 = add i64 %18, 1
  %21 = call ptr @memcpy(ptr %cast19, ptr %16, i64 %rhs_len_p120)
  %22 = call i32 @puts(ptr %19)
  %widen21 = sext i32 %22 to i64
  %23 = call ptr @avra_format_int(i64 42, ptr @.str.7)
  %24 = call i64 @strlen(ptr @.str.6)
  %25 = call i64 @strlen(ptr %23)
  %concat_total22 = add i64 %24, %25
  %concat_size23 = add i64 %concat_total22, 1
  %26 = call ptr @avra_rc_alloc(i64 %concat_size23)
  %27 = call ptr @memcpy(ptr %26, ptr @.str.6, i64 %24)
  %cast24 = ptrtoint ptr %26 to i64
  %dst2_int25 = add i64 %cast24, %24
  %cast26 = inttoptr i64 %dst2_int25 to ptr
  %rhs_len_p127 = add i64 %25, 1
  %28 = call ptr @memcpy(ptr %cast26, ptr %23, i64 %rhs_len_p127)
  %29 = call i32 @puts(ptr %26)
  %widen28 = sext i32 %29 to i64
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}
