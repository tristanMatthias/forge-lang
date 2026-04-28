; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@ch = global ptr null
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.9 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str = private unnamed_addr constant [10 x i8] c"closed ok\00", align 1
@.str.10 = private unnamed_addr constant [6 x i8] c"ch1: \00", align 1
@.i2s_fmt.11 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.12 = private unnamed_addr constant [6 x i8] c"ch2: \00", align 1
@.i2s_fmt.13 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

declare i64 @avra_spawn.1(i64)

declare i64 @avra_thread_join.2(i64)

declare ptr @avra_channel_new.3()

declare i64 @avra_channel_send.4(ptr, i64)

declare i64 @avra_channel_recv.5(ptr)

declare i64 @avra_channel_close.6(ptr)

define i64 @producer() {
entry:
  %ch = load ptr, ptr @ch, align 8
  call void @avra_channel_send(ptr %ch, i64 1)
  %ch1 = load ptr, ptr @ch, align 8
  call void @avra_channel_send(ptr %ch1, i64 2)
  %ch2 = load ptr, ptr @ch, align 8
  call void @avra_channel_send(ptr %ch2, i64 3)
  ret i64 0
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %v41 = alloca i64, align 8
  %v = alloca i64, align 8
  %ch224 = alloca ptr, align 8
  %ch1 = alloca ptr, align 8
  %c = alloca i64, align 8
  %b = alloca i64, align 8
  %a = alloca i64, align 8
  %h = alloca i64, align 8
  %1 = call ptr @avra_channel_new()
  store ptr %1, ptr @ch, align 8
  %2 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %2, i64 -559038737)
  call void @avra_array_push(ptr %2, i64 ptrtoint (ptr @producer to i64))
  %cast = ptrtoint ptr %2 to i64
  %cast1 = inttoptr i64 %cast to ptr
  %3 = call i64 @avra_spawn(ptr %cast1)
  store i64 %3, ptr %h, align 8
  %ch = load ptr, ptr @ch, align 8
  %4 = call i64 @avra_channel_recv(ptr %ch)
  store i64 %4, ptr %a, align 8
  %ch2 = load ptr, ptr @ch, align 8
  %5 = call i64 @avra_channel_recv(ptr %ch2)
  store i64 %5, ptr %b, align 8
  %ch3 = load ptr, ptr @ch, align 8
  %6 = call i64 @avra_channel_recv(ptr %ch3)
  store i64 %6, ptr %c, align 8
  %h4 = load i64, ptr %h, align 8
  %cast5 = inttoptr i64 %h4 to ptr
  %7 = call i32 @avra_thread_join(ptr %cast5)
  %widen = sext i32 %7 to i64
  %a6 = load i64, ptr %a, align 8
  %8 = call ptr @avra_rc_alloc(i64 32)
  %9 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %8, i64 32, ptr @.i2s_fmt, i64 %a6)
  %widen7 = sext i32 %9 to i64
  %10 = call i32 @puts(ptr %8)
  %widen8 = sext i32 %10 to i64
  %b9 = load i64, ptr %b, align 8
  %11 = call ptr @avra_rc_alloc(i64 32)
  %12 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %11, i64 32, ptr @.i2s_fmt.7, i64 %b9)
  %widen10 = sext i32 %12 to i64
  %13 = call i32 @puts(ptr %11)
  %widen11 = sext i32 %13 to i64
  %c12 = load i64, ptr %c, align 8
  %14 = call ptr @avra_rc_alloc(i64 32)
  %15 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %14, i64 32, ptr @.i2s_fmt.8, i64 %c12)
  %widen13 = sext i32 %15 to i64
  %16 = call i32 @puts(ptr %14)
  %widen14 = sext i32 %16 to i64
  %a15 = load i64, ptr %a, align 8
  %b16 = load i64, ptr %b, align 8
  %add = add i64 %a15, %b16
  %c17 = load i64, ptr %c, align 8
  %add18 = add i64 %add, %c17
  %17 = call ptr @avra_rc_alloc(i64 32)
  %18 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %17, i64 32, ptr @.i2s_fmt.9, i64 %add18)
  %widen19 = sext i32 %18 to i64
  %19 = call i32 @puts(ptr %17)
  %widen20 = sext i32 %19 to i64
  %ch21 = load ptr, ptr @ch, align 8
  %20 = call i32 @avra_channel_close(ptr %ch21)
  %widen22 = sext i32 %20 to i64
  %21 = call i32 @puts(ptr @.str)
  %widen23 = sext i32 %21 to i64
  %22 = call ptr @avra_channel_new()
  store ptr %22, ptr %ch1, align 8
  %23 = call ptr @avra_channel_new()
  store ptr %23, ptr %ch224, align 8
  %ch125 = load ptr, ptr %ch1, align 8
  call void @avra_channel_send(ptr %ch125, i64 100)
  %24 = call ptr @avra_array_new()
  %ch126 = load ptr, ptr %ch1, align 8
  %cast27 = ptrtoint ptr %ch126 to i64
  call void @avra_array_push(ptr %24, i64 %cast27)
  %ch228 = load ptr, ptr %ch224, align 8
  %cast29 = ptrtoint ptr %ch228 to i64
  call void @avra_array_push(ptr %24, i64 %cast29)
  %25 = call i64 @avra_select(ptr %24, i64 2)
  %cast30 = inttoptr i64 %25 to ptr
  %26 = call i64 @avra_select_index(ptr %cast30)
  %cast31 = inttoptr i64 %25 to ptr
  %27 = call i64 @avra_select_value(ptr %cast31)
  %sel_cmp = icmp eq i64 %26, 0
  br i1 %sel_cmp, label %sel_then, label %sel_else

sel_then:                                         ; preds = %entry
  store i64 %27, ptr %v, align 8
  %v32 = load i64, ptr %v, align 8
  %28 = call ptr @avra_rc_alloc(i64 32)
  %29 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %28, i64 32, ptr @.i2s_fmt.11, i64 %v32)
  %widen33 = sext i32 %29 to i64
  %30 = call i64 @strlen(ptr @.str.10)
  %31 = call i64 @strlen(ptr %28)
  %concat_total = add i64 %30, %31
  %concat_size = add i64 %concat_total, 1
  %32 = call ptr @avra_rc_alloc(i64 %concat_size)
  %33 = call ptr @memcpy(ptr %32, ptr @.str.10, i64 %30)
  %cast34 = ptrtoint ptr %32 to i64
  %dst2_int = add i64 %cast34, %30
  %cast35 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %31, 1
  %34 = call ptr @memcpy(ptr %cast35, ptr %28, i64 %rhs_len_p1)
  %35 = call i32 @puts(ptr %32)
  %widen36 = sext i32 %35 to i64
  br label %sel_merge

sel_else:                                         ; preds = %entry
  %sel_cmp37 = icmp eq i64 %26, 1
  br i1 %sel_cmp37, label %sel_then38, label %sel_else39

sel_merge:                                        ; preds = %sel_merge40, %sel_then
  ret i64 0

sel_then38:                                       ; preds = %sel_else
  store i64 %27, ptr %v41, align 8
  %v42 = load i64, ptr %v41, align 8
  %36 = call ptr @avra_rc_alloc(i64 32)
  %37 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %36, i64 32, ptr @.i2s_fmt.13, i64 %v42)
  %widen43 = sext i32 %37 to i64
  %38 = call i64 @strlen(ptr @.str.12)
  %39 = call i64 @strlen(ptr %36)
  %concat_total44 = add i64 %38, %39
  %concat_size45 = add i64 %concat_total44, 1
  %40 = call ptr @avra_rc_alloc(i64 %concat_size45)
  %41 = call ptr @memcpy(ptr %40, ptr @.str.12, i64 %38)
  %cast46 = ptrtoint ptr %40 to i64
  %dst2_int47 = add i64 %cast46, %38
  %cast48 = inttoptr i64 %dst2_int47 to ptr
  %rhs_len_p149 = add i64 %39, 1
  %42 = call ptr @memcpy(ptr %cast48, ptr %36, i64 %rhs_len_p149)
  %43 = call i32 @puts(ptr %40)
  %widen50 = sext i32 %43 to i64
  br label %sel_merge40

sel_else39:                                       ; preds = %sel_else
  br label %sel_merge40

sel_merge40:                                      ; preds = %sel_else39, %sel_then38
  br label %sel_merge
}

define i64 @__bs_top_level() {
entry:
  store i64 0, ptr @ch, align 8
  call void @avra_rc_collect()
  ret i64 0
}
