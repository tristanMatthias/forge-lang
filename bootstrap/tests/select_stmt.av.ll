; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@ch1 = global ptr null
@ch2 = global ptr null
@.str = private unnamed_addr constant [3 x i8] c"a:\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.5 = private unnamed_addr constant [3 x i8] c"b:\00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.7 = private unnamed_addr constant [3 x i8] c"a:\00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.9 = private unnamed_addr constant [3 x i8] c"b:\00", align 1
@.i2s_fmt.10 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define i64 @send1() {
entry:
  %ch1 = load ptr, ptr @ch1, align 8
  call void @avra_channel_send(ptr %ch1, i64 10)
  ret i64 0
}

define i64 @send2() {
entry:
  %ch2 = load ptr, ptr @ch2, align 8
  call void @avra_channel_send(ptr %ch2, i64 20)
  ret i64 0
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %v56 = alloca i64, align 8
  %v42 = alloca i64, align 8
  %v22 = alloca i64, align 8
  %v = alloca i64, align 8
  %h2 = alloca i64, align 8
  %h1 = alloca i64, align 8
  %1 = call ptr @avra_channel_new()
  store ptr %1, ptr @ch1, align 8
  %2 = call ptr @avra_channel_new()
  store ptr %2, ptr @ch2, align 8
  %3 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %3, i64 -559038737)
  call void @avra_array_push(ptr %3, i64 ptrtoint (ptr @send1 to i64))
  %cast = ptrtoint ptr %3 to i64
  %cast1 = inttoptr i64 %cast to ptr
  %4 = call i64 @avra_spawn(ptr %cast1)
  store i64 %4, ptr %h1, align 8
  %5 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %5, i64 -559038737)
  call void @avra_array_push(ptr %5, i64 ptrtoint (ptr @send2 to i64))
  %cast2 = ptrtoint ptr %5 to i64
  %cast3 = inttoptr i64 %cast2 to ptr
  %6 = call i64 @avra_spawn(ptr %cast3)
  store i64 %6, ptr %h2, align 8
  %h14 = load i64, ptr %h1, align 8
  %cast5 = inttoptr i64 %h14 to ptr
  %7 = call i32 @avra_thread_join(ptr %cast5)
  %widen = sext i32 %7 to i64
  %h26 = load i64, ptr %h2, align 8
  %cast7 = inttoptr i64 %h26 to ptr
  %8 = call i32 @avra_thread_join(ptr %cast7)
  %widen8 = sext i32 %8 to i64
  %9 = call ptr @avra_array_new()
  %ch1 = load ptr, ptr @ch1, align 8
  %cast9 = ptrtoint ptr %ch1 to i64
  call void @avra_array_push(ptr %9, i64 %cast9)
  %ch2 = load ptr, ptr @ch2, align 8
  %cast10 = ptrtoint ptr %ch2 to i64
  call void @avra_array_push(ptr %9, i64 %cast10)
  %10 = call i64 @avra_select(ptr %9, i64 2)
  %cast11 = inttoptr i64 %10 to ptr
  %11 = call i64 @avra_select_index(ptr %cast11)
  %cast12 = inttoptr i64 %10 to ptr
  %12 = call i64 @avra_select_value(ptr %cast12)
  %sel_cmp = icmp eq i64 %11, 0
  br i1 %sel_cmp, label %sel_then, label %sel_else

sel_then:                                         ; preds = %entry
  store i64 %12, ptr %v, align 8
  %v13 = load i64, ptr %v, align 8
  %13 = call ptr @avra_rc_alloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @.i2s_fmt, i64 %v13)
  %widen14 = sext i32 %14 to i64
  %15 = call i64 @strlen(ptr @.str)
  %16 = call i64 @strlen(ptr %13)
  %concat_total = add i64 %15, %16
  %concat_size = add i64 %concat_total, 1
  %17 = call ptr @avra_rc_alloc(i64 %concat_size)
  %18 = call ptr @memcpy(ptr %17, ptr @.str, i64 %15)
  %cast15 = ptrtoint ptr %17 to i64
  %dst2_int = add i64 %cast15, %15
  %cast16 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %16, 1
  %19 = call ptr @memcpy(ptr %cast16, ptr %13, i64 %rhs_len_p1)
  %20 = call i32 @puts(ptr %17)
  %widen17 = sext i32 %20 to i64
  br label %sel_merge

sel_else:                                         ; preds = %entry
  %sel_cmp18 = icmp eq i64 %11, 1
  br i1 %sel_cmp18, label %sel_then19, label %sel_else20

sel_merge:                                        ; preds = %sel_merge21, %sel_then
  %21 = call ptr @avra_array_new()
  %ch132 = load ptr, ptr @ch1, align 8
  %cast33 = ptrtoint ptr %ch132 to i64
  call void @avra_array_push(ptr %21, i64 %cast33)
  %ch234 = load ptr, ptr @ch2, align 8
  %cast35 = ptrtoint ptr %ch234 to i64
  call void @avra_array_push(ptr %21, i64 %cast35)
  %22 = call i64 @avra_select(ptr %21, i64 2)
  %cast36 = inttoptr i64 %22 to ptr
  %23 = call i64 @avra_select_index(ptr %cast36)
  %cast37 = inttoptr i64 %22 to ptr
  %24 = call i64 @avra_select_value(ptr %cast37)
  %sel_cmp38 = icmp eq i64 %23, 0
  br i1 %sel_cmp38, label %sel_then39, label %sel_else40

sel_then19:                                       ; preds = %sel_else
  store i64 %12, ptr %v22, align 8
  %v23 = load i64, ptr %v22, align 8
  %25 = call ptr @avra_rc_alloc(i64 32)
  %26 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %25, i64 32, ptr @.i2s_fmt.6, i64 %v23)
  %widen24 = sext i32 %26 to i64
  %27 = call i64 @strlen(ptr @.str.5)
  %28 = call i64 @strlen(ptr %25)
  %concat_total25 = add i64 %27, %28
  %concat_size26 = add i64 %concat_total25, 1
  %29 = call ptr @avra_rc_alloc(i64 %concat_size26)
  %30 = call ptr @memcpy(ptr %29, ptr @.str.5, i64 %27)
  %cast27 = ptrtoint ptr %29 to i64
  %dst2_int28 = add i64 %cast27, %27
  %cast29 = inttoptr i64 %dst2_int28 to ptr
  %rhs_len_p130 = add i64 %28, 1
  %31 = call ptr @memcpy(ptr %cast29, ptr %25, i64 %rhs_len_p130)
  %32 = call i32 @puts(ptr %29)
  %widen31 = sext i32 %32 to i64
  br label %sel_merge21

sel_else20:                                       ; preds = %sel_else
  br label %sel_merge21

sel_merge21:                                      ; preds = %sel_else20, %sel_then19
  br label %sel_merge

sel_then39:                                       ; preds = %sel_merge
  store i64 %24, ptr %v42, align 8
  %v43 = load i64, ptr %v42, align 8
  %33 = call ptr @avra_rc_alloc(i64 32)
  %34 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %33, i64 32, ptr @.i2s_fmt.8, i64 %v43)
  %widen44 = sext i32 %34 to i64
  %35 = call i64 @strlen(ptr @.str.7)
  %36 = call i64 @strlen(ptr %33)
  %concat_total45 = add i64 %35, %36
  %concat_size46 = add i64 %concat_total45, 1
  %37 = call ptr @avra_rc_alloc(i64 %concat_size46)
  %38 = call ptr @memcpy(ptr %37, ptr @.str.7, i64 %35)
  %cast47 = ptrtoint ptr %37 to i64
  %dst2_int48 = add i64 %cast47, %35
  %cast49 = inttoptr i64 %dst2_int48 to ptr
  %rhs_len_p150 = add i64 %36, 1
  %39 = call ptr @memcpy(ptr %cast49, ptr %33, i64 %rhs_len_p150)
  %40 = call i32 @puts(ptr %37)
  %widen51 = sext i32 %40 to i64
  br label %sel_merge41

sel_else40:                                       ; preds = %sel_merge
  %sel_cmp52 = icmp eq i64 %23, 1
  br i1 %sel_cmp52, label %sel_then53, label %sel_else54

sel_merge41:                                      ; preds = %sel_merge55, %sel_then39
  ret i64 0

sel_then53:                                       ; preds = %sel_else40
  store i64 %24, ptr %v56, align 8
  %v57 = load i64, ptr %v56, align 8
  %41 = call ptr @avra_rc_alloc(i64 32)
  %42 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %41, i64 32, ptr @.i2s_fmt.10, i64 %v57)
  %widen58 = sext i32 %42 to i64
  %43 = call i64 @strlen(ptr @.str.9)
  %44 = call i64 @strlen(ptr %41)
  %concat_total59 = add i64 %43, %44
  %concat_size60 = add i64 %concat_total59, 1
  %45 = call ptr @avra_rc_alloc(i64 %concat_size60)
  %46 = call ptr @memcpy(ptr %45, ptr @.str.9, i64 %43)
  %cast61 = ptrtoint ptr %45 to i64
  %dst2_int62 = add i64 %cast61, %43
  %cast63 = inttoptr i64 %dst2_int62 to ptr
  %rhs_len_p164 = add i64 %44, 1
  %47 = call ptr @memcpy(ptr %cast63, ptr %41, i64 %rhs_len_p164)
  %48 = call i32 @puts(ptr %45)
  %widen65 = sext i32 %48 to i64
  br label %sel_merge55

sel_else54:                                       ; preds = %sel_else40
  br label %sel_merge55

sel_merge55:                                      ; preds = %sel_else54, %sel_then53
  br label %sel_merge41
}

define i64 @__bs_top_level() {
entry:
  store i64 0, ptr @ch1, align 8
  store i64 0, ptr @ch2, align 8
  call void @avra_rc_collect()
  ret i64 0
}
