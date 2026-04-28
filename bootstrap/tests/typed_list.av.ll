; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Point = type { i64, i64 }

@users = global i64 0
@points = global i64 0
@first = global i64 0
@high = global i64 0
@sum = global i64 0
@.str = private unnamed_addr constant [5 x i8] c"name\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"alice\00", align 1
@.str.2 = private unnamed_addr constant [6 x i8] c"score\00", align 1
@.str.3 = private unnamed_addr constant [3 x i8] c"90\00", align 1
@.str.4 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@.str.5 = private unnamed_addr constant [4 x i8] c"bob\00", align 1
@.str.6 = private unnamed_addr constant [6 x i8] c"score\00", align 1
@.str.7 = private unnamed_addr constant [3 x i8] c"85\00", align 1
@.str.8 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@.str.9 = private unnamed_addr constant [6 x i8] c"carol\00", align 1
@.str.10 = private unnamed_addr constant [6 x i8] c"score\00", align 1
@.str.11 = private unnamed_addr constant [3 x i8] c"95\00", align 1
@.str.12 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@fld_name = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file = private unnamed_addr constant [97 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/typed_list.av\00", align 1
@fld_name.13 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@sty_name.14 = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file.15 = private unnamed_addr constant [97 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/typed_list.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.16 = private unnamed_addr constant [6 x i8] c"score\00", align 1
@.i2s_fmt.17 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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
  %s = alloca i64, align 8
  %forin_i34 = alloca i64, align 8
  %forin_len33 = alloca i64, align 8
  %p = alloca i64, align 8
  %forin_i11 = alloca i64, align 8
  %forin_len10 = alloca i64, align 8
  %user = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %0 = call ptr @avra_array_new()
  %1 = call ptr @avra_map_new_cstr()
  call void @avra_map_set_cstr(ptr %1, ptr @.str, i64 ptrtoint (ptr @.str.1 to i64))
  call void @avra_map_set_cstr(ptr %1, ptr @.str.2, i64 ptrtoint (ptr @.str.3 to i64))
  %cast = ptrtoint ptr %1 to i64
  call void @avra_array_push(ptr %0, i64 %cast)
  %2 = call ptr @avra_map_new_cstr()
  call void @avra_map_set_cstr(ptr %2, ptr @.str.4, i64 ptrtoint (ptr @.str.5 to i64))
  call void @avra_map_set_cstr(ptr %2, ptr @.str.6, i64 ptrtoint (ptr @.str.7 to i64))
  %cast1 = ptrtoint ptr %2 to i64
  call void @avra_array_push(ptr %0, i64 %cast1)
  %3 = call ptr @avra_map_new_cstr()
  call void @avra_map_set_cstr(ptr %3, ptr @.str.8, i64 ptrtoint (ptr @.str.9 to i64))
  call void @avra_map_set_cstr(ptr %3, ptr @.str.10, i64 ptrtoint (ptr @.str.11 to i64))
  %cast2 = ptrtoint ptr %3 to i64
  call void @avra_array_push(ptr %0, i64 %cast2)
  store ptr %0, ptr @users, align 8
  %users = load ptr, ptr @users, align 8
  %4 = call i64 @avra_array_len(ptr %users)
  store i64 %4, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %entry
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %5 = call i64 @avra_array_get(ptr %users, i64 %forin_i_val)
  store i64 %5, ptr %user, align 8
  %user3 = load ptr, ptr %user, align 8
  %6 = call i64 @avra_map_get_cstr(ptr %user3, ptr @.str.12)
  %cast4 = inttoptr i64 %6 to ptr
  %7 = call i32 @puts(ptr %cast4)
  %widen = sext i32 %7 to i64
  br label %forin.incr

forin.incr:                                       ; preds = %forin.body
  %forin_i_old = load i64, ptr %forin_i, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  %8 = call ptr @avra_array_new()
  %9 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %Point, ptr %9, i32 0, i32 0
  store i64 1, ptr %fld_ptr, align 8
  %fld_ptr5 = getelementptr inbounds nuw %Point, ptr %9, i32 0, i32 1
  store i64 2, ptr %fld_ptr5, align 8
  %cast6 = ptrtoint ptr %9 to i64
  call void @avra_array_push(ptr %8, i64 %cast6)
  %10 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr7 = getelementptr inbounds nuw %Point, ptr %10, i32 0, i32 0
  store i64 3, ptr %fld_ptr7, align 8
  %fld_ptr8 = getelementptr inbounds nuw %Point, ptr %10, i32 0, i32 1
  store i64 4, ptr %fld_ptr8, align 8
  %cast9 = ptrtoint ptr %10 to i64
  call void @avra_array_push(ptr %8, i64 %cast9)
  store ptr %8, ptr @points, align 8
  %points = load ptr, ptr @points, align 8
  %11 = call i64 @avra_array_len(ptr %points)
  store i64 %11, ptr %forin_len10, align 8
  store i64 0, ptr %forin_i11, align 8
  br label %forin.cond12

forin.cond12:                                     ; preds = %forin.incr14, %forin.exit
  %forin_i_val16 = load i64, ptr %forin_i11, align 8
  %forin_len_val17 = load i64, ptr %forin_len10, align 8
  %forin_cmp18 = icmp slt i64 %forin_i_val16, %forin_len_val17
  br i1 %forin_cmp18, label %forin.body13, label %forin.exit15

forin.body13:                                     ; preds = %forin.cond12
  %12 = call i64 @avra_array_get(ptr %points, i64 %forin_i_val16)
  store i64 %12, ptr %p, align 8
  %p19 = load ptr, ptr %p, align 8
  %cast20 = ptrtoint ptr %p19 to i64
  %null_chk = icmp eq i64 %cast20, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 1, ptr @sty_name, i64 5, i64 %null_ext, ptr @src_file, i64 96, i64 16)
  %x_ptr = getelementptr inbounds nuw %Point, ptr %p19, i32 0, i32 0
  %x = load i64, ptr %x_ptr, align 8
  %p21 = load ptr, ptr %p, align 8
  %cast22 = ptrtoint ptr %p21 to i64
  %null_chk23 = icmp eq i64 %cast22, 0
  %null_ext24 = zext i1 %null_chk23 to i64
  call void @avra_null_deref_trap(ptr @fld_name.13, i64 1, ptr @sty_name.14, i64 5, i64 %null_ext24, ptr @src_file.15, i64 96, i64 16)
  %y_ptr = getelementptr inbounds nuw %Point, ptr %p21, i32 0, i32 1
  %y = load i64, ptr %y_ptr, align 8
  %add = add i64 %x, %y
  %13 = call ptr @avra_rc_alloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @.i2s_fmt, i64 %add)
  %widen25 = sext i32 %14 to i64
  %15 = call i32 @puts(ptr %13)
  %widen26 = sext i32 %15 to i64
  br label %forin.incr14

forin.incr14:                                     ; preds = %forin.body13
  %forin_i_old27 = load i64, ptr %forin_i11, align 8
  %forin_next28 = add i64 %forin_i_old27, 1
  store i64 %forin_next28, ptr %forin_i11, align 8
  br label %forin.cond12

forin.exit15:                                     ; preds = %forin.cond12
  %users29 = load ptr, ptr @users, align 8
  %16 = call i64 @avra_array_get(ptr %users29, i64 0)
  store i64 %16, ptr @first, align 8
  %first = load ptr, ptr @first, align 8
  %17 = call i64 @avra_map_get_cstr(ptr %first, ptr @.str.16)
  %cast30 = inttoptr i64 %17 to ptr
  %18 = call i32 @puts(ptr %cast30)
  %widen31 = sext i32 %18 to i64
  %19 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %19, i64 90)
  call void @avra_array_push(ptr %19, i64 85)
  call void @avra_array_push(ptr %19, i64 95)
  call void @avra_array_push(ptr %19, i64 70)
  %20 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %20, i64 -559038737)
  call void @avra_array_push(ptr %20, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast32 = ptrtoint ptr %20 to i64
  %21 = call ptr @avra_array_filter(ptr %19, i64 %cast32)
  store ptr %21, ptr @high, align 8
  store i64 0, ptr @sum, align 8
  %high = load ptr, ptr @high, align 8
  %22 = call i64 @avra_array_len(ptr %high)
  store i64 %22, ptr %forin_len33, align 8
  store i64 0, ptr %forin_i34, align 8
  br label %forin.cond35

forin.cond35:                                     ; preds = %forin.incr37, %forin.exit15
  %forin_i_val39 = load i64, ptr %forin_i34, align 8
  %forin_len_val40 = load i64, ptr %forin_len33, align 8
  %forin_cmp41 = icmp slt i64 %forin_i_val39, %forin_len_val40
  br i1 %forin_cmp41, label %forin.body36, label %forin.exit38

forin.body36:                                     ; preds = %forin.cond35
  %23 = call i64 @avra_array_get(ptr %high, i64 %forin_i_val39)
  store i64 %23, ptr %s, align 8
  %sum = load i64, ptr @sum, align 8
  %s42 = load i64, ptr %s, align 8
  %add43 = add i64 %sum, %s42
  store i64 %add43, ptr @sum, align 8
  br label %forin.incr37

forin.incr37:                                     ; preds = %forin.body36
  %forin_i_old44 = load i64, ptr %forin_i34, align 8
  %forin_next45 = add i64 %forin_i_old44, 1
  store i64 %forin_next45, ptr %forin_i34, align 8
  br label %forin.cond35

forin.exit38:                                     ; preds = %forin.cond35
  %sum46 = load i64, ptr @sum, align 8
  %24 = call ptr @avra_rc_alloc(i64 32)
  %25 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %24, i64 32, ptr @.i2s_fmt.17, i64 %sum46)
  %widen47 = sext i32 %25 to i64
  %26 = call i32 @puts(ptr %24)
  %widen48 = sext i32 %26 to i64
  %27 = call i32 @avra_test_summary()
  %widen49 = sext i32 %27 to i64
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__lambda_0(i64 %0) {
entry:
  %s = alloca i64, align 8
  store i64 %0, ptr %s, align 8
  %s1 = load i64, ptr %s, align 8
  %sge = icmp sge i64 %s1, 90
  %sge_ext = zext i1 %sge to i64
  ret i64 %sge_ext
}
