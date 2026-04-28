; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@.str = private unnamed_addr constant [7 x i8] c"[dbg] \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"result: \00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.3 = private unnamed_addr constant [7 x i8] c"[dbg] \00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.5 = private unnamed_addr constant [7 x i8] c"[dbg] \00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.7 = private unnamed_addr constant [10 x i8] c"chained: \00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define i64 @add(i64 %0, i64 %1) {
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

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %y = alloca i64, align 8
  %__dbg27 = alloca i64, align 8
  %__dbg15 = alloca i64, align 8
  %x = alloca i64, align 8
  %__dbg = alloca i64, align 8
  %1 = call i64 @add(i64 2, i64 3)
  store i64 %1, ptr %__dbg, align 8
  %__dbg1 = load i64, ptr %__dbg, align 8
  %2 = call ptr @avra_rc_alloc(i64 32)
  %3 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %2, i64 32, ptr @.i2s_fmt, i64 %__dbg1)
  %widen = sext i32 %3 to i64
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
  %__dbg4 = load i64, ptr %__dbg, align 8
  store i64 %__dbg4, ptr %x, align 8
  %x5 = load i64, ptr %x, align 8
  %10 = call ptr @avra_rc_alloc(i64 32)
  %11 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %10, i64 32, ptr @.i2s_fmt.2, i64 %x5)
  %widen6 = sext i32 %11 to i64
  %12 = call i64 @strlen(ptr @.str.1)
  %13 = call i64 @strlen(ptr %10)
  %concat_total7 = add i64 %12, %13
  %concat_size8 = add i64 %concat_total7, 1
  %14 = call ptr @avra_rc_alloc(i64 %concat_size8)
  %15 = call ptr @memcpy(ptr %14, ptr @.str.1, i64 %12)
  %cast9 = ptrtoint ptr %14 to i64
  %dst2_int10 = add i64 %cast9, %12
  %cast11 = inttoptr i64 %dst2_int10 to ptr
  %rhs_len_p112 = add i64 %13, 1
  %16 = call ptr @memcpy(ptr %cast11, ptr %10, i64 %rhs_len_p112)
  %17 = call i32 @puts(ptr %14)
  %widen13 = sext i32 %17 to i64
  %x14 = load i64, ptr %x, align 8
  store i64 %x14, ptr %__dbg15, align 8
  %__dbg16 = load i64, ptr %__dbg15, align 8
  %18 = call ptr @avra_rc_alloc(i64 32)
  %19 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %18, i64 32, ptr @.i2s_fmt.4, i64 %__dbg16)
  %widen17 = sext i32 %19 to i64
  %20 = call i64 @strlen(ptr @.str.3)
  %21 = call i64 @strlen(ptr %18)
  %concat_total18 = add i64 %20, %21
  %concat_size19 = add i64 %concat_total18, 1
  %22 = call ptr @avra_rc_alloc(i64 %concat_size19)
  %23 = call ptr @memcpy(ptr %22, ptr @.str.3, i64 %20)
  %cast20 = ptrtoint ptr %22 to i64
  %dst2_int21 = add i64 %cast20, %20
  %cast22 = inttoptr i64 %dst2_int21 to ptr
  %rhs_len_p123 = add i64 %21, 1
  %24 = call ptr @memcpy(ptr %cast22, ptr %18, i64 %rhs_len_p123)
  %25 = call i32 @puts(ptr %22)
  %widen24 = sext i32 %25 to i64
  %__dbg25 = load i64, ptr %__dbg15, align 8
  %x26 = load i64, ptr %x, align 8
  store i64 %x26, ptr %__dbg27, align 8
  %__dbg28 = load i64, ptr %__dbg27, align 8
  %26 = call ptr @avra_rc_alloc(i64 32)
  %27 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %26, i64 32, ptr @.i2s_fmt.6, i64 %__dbg28)
  %widen29 = sext i32 %27 to i64
  %28 = call i64 @strlen(ptr @.str.5)
  %29 = call i64 @strlen(ptr %26)
  %concat_total30 = add i64 %28, %29
  %concat_size31 = add i64 %concat_total30, 1
  %30 = call ptr @avra_rc_alloc(i64 %concat_size31)
  %31 = call ptr @memcpy(ptr %30, ptr @.str.5, i64 %28)
  %cast32 = ptrtoint ptr %30 to i64
  %dst2_int33 = add i64 %cast32, %28
  %cast34 = inttoptr i64 %dst2_int33 to ptr
  %rhs_len_p135 = add i64 %29, 1
  %32 = call ptr @memcpy(ptr %cast34, ptr %26, i64 %rhs_len_p135)
  %33 = call i32 @puts(ptr %30)
  %widen36 = sext i32 %33 to i64
  %__dbg37 = load i64, ptr %__dbg27, align 8
  %add = add i64 %__dbg25, %__dbg37
  store i64 %add, ptr %y, align 8
  %y38 = load i64, ptr %y, align 8
  %34 = call ptr @avra_rc_alloc(i64 32)
  %35 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %34, i64 32, ptr @.i2s_fmt.8, i64 %y38)
  %widen39 = sext i32 %35 to i64
  %36 = call i64 @strlen(ptr @.str.7)
  %37 = call i64 @strlen(ptr %34)
  %concat_total40 = add i64 %36, %37
  %concat_size41 = add i64 %concat_total40, 1
  %38 = call ptr @avra_rc_alloc(i64 %concat_size41)
  %39 = call ptr @memcpy(ptr %38, ptr @.str.7, i64 %36)
  %cast42 = ptrtoint ptr %38 to i64
  %dst2_int43 = add i64 %cast42, %36
  %cast44 = inttoptr i64 %dst2_int43 to ptr
  %rhs_len_p145 = add i64 %37, 1
  %40 = call ptr @memcpy(ptr %cast44, ptr %34, i64 %rhs_len_p145)
  %41 = call i32 @puts(ptr %38)
  %widen46 = sext i32 %41 to i64
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}
