; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Dog = type { ptr, i64 }
%Cat = type { ptr, i64 }
%Point = type { i64, i64 }

@.str = private unnamed_addr constant [6 x i8] c"Dog: \00", align 1
@fld_name = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name = private unnamed_addr constant [4 x i8] c"Dog\00", align 1
@src_file = private unnamed_addr constant [110 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_trait_struct_with.av\00", align 1
@.str.1 = private unnamed_addr constant [7 x i8] c" (age \00", align 1
@fld_name.2 = private unnamed_addr constant [4 x i8] c"age\00", align 1
@sty_name.3 = private unnamed_addr constant [4 x i8] c"Dog\00", align 1
@src_file.4 = private unnamed_addr constant [110 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_trait_struct_with.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c")\00", align 1
@.str.6 = private unnamed_addr constant [6 x i8] c"Cat: \00", align 1
@fld_name.7 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.8 = private unnamed_addr constant [4 x i8] c"Cat\00", align 1
@src_file.9 = private unnamed_addr constant [110 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_trait_struct_with.av\00", align 1
@.str.10 = private unnamed_addr constant [7 x i8] c" (age \00", align 1
@fld_name.11 = private unnamed_addr constant [4 x i8] c"age\00", align 1
@sty_name.12 = private unnamed_addr constant [4 x i8] c"Cat\00", align 1
@src_file.13 = private unnamed_addr constant [110 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_trait_struct_with.av\00", align 1
@.i2s_fmt.14 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.15 = private unnamed_addr constant [2 x i8] c")\00", align 1
@fld_name.16 = private unnamed_addr constant [4 x i8] c"age\00", align 1
@sty_name.17 = private unnamed_addr constant [4 x i8] c"Dog\00", align 1
@src_file.18 = private unnamed_addr constant [110 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_trait_struct_with.av\00", align 1
@.str.19 = private unnamed_addr constant [4 x i8] c"Rex\00", align 1
@.str.20 = private unnamed_addr constant [9 x i8] c"Whiskers\00", align 1
@fld_name.21 = private unnamed_addr constant [9 x i8] c"describe\00", align 1
@sty_name.22 = private unnamed_addr constant [4 x i8] c"Dog\00", align 1
@src_file.23 = private unnamed_addr constant [110 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_trait_struct_with.av\00", align 1
@fld_name.24 = private unnamed_addr constant [9 x i8] c"describe\00", align 1
@sty_name.25 = private unnamed_addr constant [4 x i8] c"Cat\00", align 1
@src_file.26 = private unnamed_addr constant [110 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_trait_struct_with.av\00", align 1
@.str.27 = private unnamed_addr constant [10 x i8] c"updated: \00", align 1
@fld_name.28 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.29 = private unnamed_addr constant [4 x i8] c"Dog\00", align 1
@src_file.30 = private unnamed_addr constant [110 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_trait_struct_with.av\00", align 1
@.str.31 = private unnamed_addr constant [7 x i8] c" (age \00", align 1
@fld_name.32 = private unnamed_addr constant [4 x i8] c"age\00", align 1
@sty_name.33 = private unnamed_addr constant [4 x i8] c"Dog\00", align 1
@src_file.34 = private unnamed_addr constant [110 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_trait_struct_with.av\00", align 1
@.i2s_fmt.35 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.36 = private unnamed_addr constant [2 x i8] c")\00", align 1
@.str.37 = private unnamed_addr constant [16 x i8] c"builder: Point(\00", align 1
@fld_name.38 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name.39 = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file.40 = private unnamed_addr constant [110 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_trait_struct_with.av\00", align 1
@.i2s_fmt.41 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.42 = private unnamed_addr constant [3 x i8] c", \00", align 1
@fld_name.43 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@sty_name.44 = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file.45 = private unnamed_addr constant [110 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_trait_struct_with.av\00", align 1
@.i2s_fmt.46 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.47 = private unnamed_addr constant [2 x i8] c")\00", align 1
@.str.48 = private unnamed_addr constant [30 x i8] c"defer order: inner then outer\00", align 1

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

define ptr @Dog__describe(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 4, ptr @sty_name, i64 3, i64 %null_ext, ptr @src_file, i64 109, i64 15)
  %name_ptr = getelementptr inbounds nuw %Dog, ptr %self1, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %1 = call i64 @strlen(ptr @.str)
  %2 = call i64 @strlen(ptr %name)
  %concat_total = add i64 %1, %2
  %concat_size = add i64 %concat_total, 1
  %3 = call ptr @avra_rc_alloc(i64 %concat_size)
  %4 = call ptr @memcpy(ptr %3, ptr @.str, i64 %1)
  %cast2 = ptrtoint ptr %3 to i64
  %dst2_int = add i64 %cast2, %1
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %2, 1
  %5 = call ptr @memcpy(ptr %cast3, ptr %name, i64 %rhs_len_p1)
  %6 = call i64 @strlen(ptr %3)
  %7 = call i64 @strlen(ptr @.str.1)
  %concat_total4 = add i64 %6, %7
  %concat_size5 = add i64 %concat_total4, 1
  %8 = call ptr @avra_rc_alloc(i64 %concat_size5)
  %9 = call ptr @memcpy(ptr %8, ptr %3, i64 %6)
  %cast6 = ptrtoint ptr %8 to i64
  %dst2_int7 = add i64 %cast6, %6
  %cast8 = inttoptr i64 %dst2_int7 to ptr
  %rhs_len_p19 = add i64 %7, 1
  %10 = call ptr @memcpy(ptr %cast8, ptr @.str.1, i64 %rhs_len_p19)
  %self10 = load ptr, ptr %self, align 8
  %cast11 = ptrtoint ptr %self10 to i64
  %null_chk12 = icmp eq i64 %cast11, 0
  %null_ext13 = zext i1 %null_chk12 to i64
  call void @avra_null_deref_trap(ptr @fld_name.2, i64 3, ptr @sty_name.3, i64 3, i64 %null_ext13, ptr @src_file.4, i64 109, i64 15)
  %age_ptr = getelementptr inbounds nuw %Dog, ptr %self10, i32 0, i32 1
  %age = load i64, ptr %age_ptr, align 8
  %11 = call ptr @avra_rc_alloc(i64 32)
  %12 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %11, i64 32, ptr @.i2s_fmt, i64 %age)
  %widen = sext i32 %12 to i64
  %13 = call i64 @strlen(ptr %8)
  %14 = call i64 @strlen(ptr %11)
  %concat_total14 = add i64 %13, %14
  %concat_size15 = add i64 %concat_total14, 1
  %15 = call ptr @avra_rc_alloc(i64 %concat_size15)
  %16 = call ptr @memcpy(ptr %15, ptr %8, i64 %13)
  %cast16 = ptrtoint ptr %15 to i64
  %dst2_int17 = add i64 %cast16, %13
  %cast18 = inttoptr i64 %dst2_int17 to ptr
  %rhs_len_p119 = add i64 %14, 1
  %17 = call ptr @memcpy(ptr %cast18, ptr %11, i64 %rhs_len_p119)
  %18 = call i64 @strlen(ptr %15)
  %19 = call i64 @strlen(ptr @.str.5)
  %concat_total20 = add i64 %18, %19
  %concat_size21 = add i64 %concat_total20, 1
  %20 = call ptr @avra_rc_alloc(i64 %concat_size21)
  %21 = call ptr @memcpy(ptr %20, ptr %15, i64 %18)
  %cast22 = ptrtoint ptr %20 to i64
  %dst2_int23 = add i64 %cast22, %18
  %cast24 = inttoptr i64 %dst2_int23 to ptr
  %rhs_len_p125 = add i64 %19, 1
  %22 = call ptr @memcpy(ptr %cast24, ptr @.str.5, i64 %rhs_len_p125)
  ret ptr %20
}

define ptr @Cat__describe(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.7, i64 4, ptr @sty_name.8, i64 3, i64 %null_ext, ptr @src_file.9, i64 109, i64 18)
  %name_ptr = getelementptr inbounds nuw %Cat, ptr %self1, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %1 = call i64 @strlen(ptr @.str.6)
  %2 = call i64 @strlen(ptr %name)
  %concat_total = add i64 %1, %2
  %concat_size = add i64 %concat_total, 1
  %3 = call ptr @avra_rc_alloc(i64 %concat_size)
  %4 = call ptr @memcpy(ptr %3, ptr @.str.6, i64 %1)
  %cast2 = ptrtoint ptr %3 to i64
  %dst2_int = add i64 %cast2, %1
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %2, 1
  %5 = call ptr @memcpy(ptr %cast3, ptr %name, i64 %rhs_len_p1)
  %6 = call i64 @strlen(ptr %3)
  %7 = call i64 @strlen(ptr @.str.10)
  %concat_total4 = add i64 %6, %7
  %concat_size5 = add i64 %concat_total4, 1
  %8 = call ptr @avra_rc_alloc(i64 %concat_size5)
  %9 = call ptr @memcpy(ptr %8, ptr %3, i64 %6)
  %cast6 = ptrtoint ptr %8 to i64
  %dst2_int7 = add i64 %cast6, %6
  %cast8 = inttoptr i64 %dst2_int7 to ptr
  %rhs_len_p19 = add i64 %7, 1
  %10 = call ptr @memcpy(ptr %cast8, ptr @.str.10, i64 %rhs_len_p19)
  %self10 = load ptr, ptr %self, align 8
  %cast11 = ptrtoint ptr %self10 to i64
  %null_chk12 = icmp eq i64 %cast11, 0
  %null_ext13 = zext i1 %null_chk12 to i64
  call void @avra_null_deref_trap(ptr @fld_name.11, i64 3, ptr @sty_name.12, i64 3, i64 %null_ext13, ptr @src_file.13, i64 109, i64 18)
  %age_ptr = getelementptr inbounds nuw %Cat, ptr %self10, i32 0, i32 1
  %age = load i64, ptr %age_ptr, align 8
  %11 = call ptr @avra_rc_alloc(i64 32)
  %12 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %11, i64 32, ptr @.i2s_fmt.14, i64 %age)
  %widen = sext i32 %12 to i64
  %13 = call i64 @strlen(ptr %8)
  %14 = call i64 @strlen(ptr %11)
  %concat_total14 = add i64 %13, %14
  %concat_size15 = add i64 %concat_total14, 1
  %15 = call ptr @avra_rc_alloc(i64 %concat_size15)
  %16 = call ptr @memcpy(ptr %15, ptr %8, i64 %13)
  %cast16 = ptrtoint ptr %15 to i64
  %dst2_int17 = add i64 %cast16, %13
  %cast18 = inttoptr i64 %dst2_int17 to ptr
  %rhs_len_p119 = add i64 %14, 1
  %17 = call ptr @memcpy(ptr %cast18, ptr %11, i64 %rhs_len_p119)
  %18 = call i64 @strlen(ptr %15)
  %19 = call i64 @strlen(ptr @.str.15)
  %concat_total20 = add i64 %18, %19
  %concat_size21 = add i64 %concat_total20, 1
  %20 = call ptr @avra_rc_alloc(i64 %concat_size21)
  %21 = call ptr @memcpy(ptr %20, ptr %15, i64 %18)
  %cast22 = ptrtoint ptr %20 to i64
  %dst2_int23 = add i64 %cast22, %18
  %cast24 = inttoptr i64 %dst2_int23 to ptr
  %rhs_len_p125 = add i64 %19, 1
  %22 = call ptr @memcpy(ptr %cast24, ptr @.str.15, i64 %rhs_len_p125)
  ret ptr %20
}

define ptr @birthday(ptr %0) {
entry:
  %d = alloca ptr, align 8
  store ptr %0, ptr %d, align 8
  %d1 = load ptr, ptr %d, align 8
  %1 = call ptr @avra_rc_alloc(i64 16)
  %with_cp_src = getelementptr inbounds nuw %Dog, ptr %d1, i32 0, i32 0
  %with_cp_val = load ptr, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %Dog, ptr %1, i32 0, i32 0
  store ptr %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src2 = getelementptr inbounds nuw %Dog, ptr %d1, i32 0, i32 1
  %with_cp_val3 = load i64, ptr %with_cp_src2, align 8
  %with_cp_dst4 = getelementptr inbounds nuw %Dog, ptr %1, i32 0, i32 1
  store i64 %with_cp_val3, ptr %with_cp_dst4, align 8
  %d5 = load ptr, ptr %d, align 8
  %cast = ptrtoint ptr %d5 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.16, i64 3, ptr @sty_name.17, i64 3, i64 %null_ext, ptr @src_file.18, i64 109, i64 23)
  %age_ptr = getelementptr inbounds nuw %Dog, ptr %d5, i32 0, i32 1
  %age = load i64, ptr %age_ptr, align 8
  %add = add i64 %age, 1
  %with_ovr = getelementptr inbounds nuw %Dog, ptr %1, i32 0, i32 1
  store i64 %add, ptr %with_ovr, align 8
  %cast6 = ptrtoint ptr %1 to i64
  %cast7 = inttoptr i64 %cast6 to ptr
  ret ptr %cast7
}

define ptr @set_x(ptr %0, i64 %1) {
entry:
  %x = alloca i64, align 8
  %p = alloca ptr, align 8
  store ptr %0, ptr %p, align 8
  store i64 %1, ptr %x, align 8
  %p1 = load ptr, ptr %p, align 8
  %2 = call ptr @avra_rc_alloc(i64 16)
  %with_cp_src = getelementptr inbounds nuw %Point, ptr %p1, i32 0, i32 0
  %with_cp_val = load i64, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %Point, ptr %2, i32 0, i32 0
  store i64 %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src2 = getelementptr inbounds nuw %Point, ptr %p1, i32 0, i32 1
  %with_cp_val3 = load i64, ptr %with_cp_src2, align 8
  %with_cp_dst4 = getelementptr inbounds nuw %Point, ptr %2, i32 0, i32 1
  store i64 %with_cp_val3, ptr %with_cp_dst4, align 8
  %x5 = load i64, ptr %x, align 8
  %with_ovr = getelementptr inbounds nuw %Point, ptr %2, i32 0, i32 0
  store i64 %x5, ptr %with_ovr, align 8
  %cast = ptrtoint ptr %2 to i64
  %cast6 = inttoptr i64 %cast to ptr
  ret ptr %cast6
}

define ptr @set_y(ptr %0, i64 %1) {
entry:
  %y = alloca i64, align 8
  %p = alloca ptr, align 8
  store ptr %0, ptr %p, align 8
  store i64 %1, ptr %y, align 8
  %p1 = load ptr, ptr %p, align 8
  %2 = call ptr @avra_rc_alloc(i64 16)
  %with_cp_src = getelementptr inbounds nuw %Point, ptr %p1, i32 0, i32 0
  %with_cp_val = load i64, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %Point, ptr %2, i32 0, i32 0
  store i64 %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src2 = getelementptr inbounds nuw %Point, ptr %p1, i32 0, i32 1
  %with_cp_val3 = load i64, ptr %with_cp_src2, align 8
  %with_cp_dst4 = getelementptr inbounds nuw %Point, ptr %2, i32 0, i32 1
  store i64 %with_cp_val3, ptr %with_cp_dst4, align 8
  %y5 = load i64, ptr %y, align 8
  %with_ovr = getelementptr inbounds nuw %Point, ptr %2, i32 0, i32 1
  store i64 %y5, ptr %with_ovr, align 8
  %cast = ptrtoint ptr %2 to i64
  %cast6 = inttoptr i64 %cast to ptr
  ret ptr %cast6
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %p2 = alloca ptr, align 8
  %p = alloca ptr, align 8
  %older = alloca ptr, align 8
  %c = alloca ptr, align 8
  %d = alloca ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %Dog, ptr %1, i32 0, i32 0
  store ptr @.str.19, ptr %fld_ptr, align 8
  %fld_ptr1 = getelementptr inbounds nuw %Dog, ptr %1, i32 0, i32 1
  store i64 5, ptr %fld_ptr1, align 8
  %cast = ptrtoint ptr %1 to i64
  %cast2 = inttoptr i64 %cast to ptr
  store ptr %cast2, ptr %d, align 8
  %2 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr3 = getelementptr inbounds nuw %Cat, ptr %2, i32 0, i32 0
  store ptr @.str.20, ptr %fld_ptr3, align 8
  %fld_ptr4 = getelementptr inbounds nuw %Cat, ptr %2, i32 0, i32 1
  store i64 3, ptr %fld_ptr4, align 8
  %cast5 = ptrtoint ptr %2 to i64
  %cast6 = inttoptr i64 %cast5 to ptr
  store ptr %cast6, ptr %c, align 8
  %d7 = load ptr, ptr %d, align 8
  %cast8 = ptrtoint ptr %d7 to i64
  %null_chk = icmp eq i64 %cast8, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.21, i64 8, ptr @sty_name.22, i64 3, i64 %null_ext, ptr @src_file.23, i64 109, i64 36)
  %3 = call ptr @Dog__describe(ptr %d7)
  %4 = call i32 @puts(ptr %3)
  %widen = sext i32 %4 to i64
  %c9 = load ptr, ptr %c, align 8
  %cast10 = ptrtoint ptr %c9 to i64
  %null_chk11 = icmp eq i64 %cast10, 0
  %null_ext12 = zext i1 %null_chk11 to i64
  call void @avra_null_deref_trap(ptr @fld_name.24, i64 8, ptr @sty_name.25, i64 3, i64 %null_ext12, ptr @src_file.26, i64 109, i64 37)
  %5 = call ptr @Cat__describe(ptr %c9)
  %6 = call i32 @puts(ptr %5)
  %widen13 = sext i32 %6 to i64
  %d14 = load ptr, ptr %d, align 8
  %7 = call ptr @birthday(ptr %d14)
  store ptr %7, ptr %older, align 8
  %older15 = load ptr, ptr %older, align 8
  %cast16 = ptrtoint ptr %older15 to i64
  %null_chk17 = icmp eq i64 %cast16, 0
  %null_ext18 = zext i1 %null_chk17 to i64
  call void @avra_null_deref_trap(ptr @fld_name.28, i64 4, ptr @sty_name.29, i64 3, i64 %null_ext18, ptr @src_file.30, i64 109, i64 41)
  %name_ptr = getelementptr inbounds nuw %Dog, ptr %older15, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %8 = call i64 @strlen(ptr @.str.27)
  %9 = call i64 @strlen(ptr %name)
  %concat_total = add i64 %8, %9
  %concat_size = add i64 %concat_total, 1
  %10 = call ptr @avra_rc_alloc(i64 %concat_size)
  %11 = call ptr @memcpy(ptr %10, ptr @.str.27, i64 %8)
  %cast19 = ptrtoint ptr %10 to i64
  %dst2_int = add i64 %cast19, %8
  %cast20 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %9, 1
  %12 = call ptr @memcpy(ptr %cast20, ptr %name, i64 %rhs_len_p1)
  %13 = call i64 @strlen(ptr %10)
  %14 = call i64 @strlen(ptr @.str.31)
  %concat_total21 = add i64 %13, %14
  %concat_size22 = add i64 %concat_total21, 1
  %15 = call ptr @avra_rc_alloc(i64 %concat_size22)
  %16 = call ptr @memcpy(ptr %15, ptr %10, i64 %13)
  %cast23 = ptrtoint ptr %15 to i64
  %dst2_int24 = add i64 %cast23, %13
  %cast25 = inttoptr i64 %dst2_int24 to ptr
  %rhs_len_p126 = add i64 %14, 1
  %17 = call ptr @memcpy(ptr %cast25, ptr @.str.31, i64 %rhs_len_p126)
  %older27 = load ptr, ptr %older, align 8
  %cast28 = ptrtoint ptr %older27 to i64
  %null_chk29 = icmp eq i64 %cast28, 0
  %null_ext30 = zext i1 %null_chk29 to i64
  call void @avra_null_deref_trap(ptr @fld_name.32, i64 3, ptr @sty_name.33, i64 3, i64 %null_ext30, ptr @src_file.34, i64 109, i64 41)
  %age_ptr = getelementptr inbounds nuw %Dog, ptr %older27, i32 0, i32 1
  %age = load i64, ptr %age_ptr, align 8
  %18 = call ptr @avra_rc_alloc(i64 32)
  %19 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %18, i64 32, ptr @.i2s_fmt.35, i64 %age)
  %widen31 = sext i32 %19 to i64
  %20 = call i64 @strlen(ptr %15)
  %21 = call i64 @strlen(ptr %18)
  %concat_total32 = add i64 %20, %21
  %concat_size33 = add i64 %concat_total32, 1
  %22 = call ptr @avra_rc_alloc(i64 %concat_size33)
  %23 = call ptr @memcpy(ptr %22, ptr %15, i64 %20)
  %cast34 = ptrtoint ptr %22 to i64
  %dst2_int35 = add i64 %cast34, %20
  %cast36 = inttoptr i64 %dst2_int35 to ptr
  %rhs_len_p137 = add i64 %21, 1
  %24 = call ptr @memcpy(ptr %cast36, ptr %18, i64 %rhs_len_p137)
  %25 = call i64 @strlen(ptr %22)
  %26 = call i64 @strlen(ptr @.str.36)
  %concat_total38 = add i64 %25, %26
  %concat_size39 = add i64 %concat_total38, 1
  %27 = call ptr @avra_rc_alloc(i64 %concat_size39)
  %28 = call ptr @memcpy(ptr %27, ptr %22, i64 %25)
  %cast40 = ptrtoint ptr %27 to i64
  %dst2_int41 = add i64 %cast40, %25
  %cast42 = inttoptr i64 %dst2_int41 to ptr
  %rhs_len_p143 = add i64 %26, 1
  %29 = call ptr @memcpy(ptr %cast42, ptr @.str.36, i64 %rhs_len_p143)
  %30 = call i32 @puts(ptr %27)
  %widen44 = sext i32 %30 to i64
  %31 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr45 = getelementptr inbounds nuw %Point, ptr %31, i32 0, i32 0
  store i64 0, ptr %fld_ptr45, align 8
  %fld_ptr46 = getelementptr inbounds nuw %Point, ptr %31, i32 0, i32 1
  store i64 0, ptr %fld_ptr46, align 8
  %cast47 = ptrtoint ptr %31 to i64
  %cast48 = inttoptr i64 %cast47 to ptr
  store ptr %cast48, ptr %p, align 8
  %p49 = load ptr, ptr %p, align 8
  %32 = call ptr @set_x(ptr %p49, i64 10)
  %33 = call ptr @set_y(ptr %32, i64 20)
  store ptr %33, ptr %p2, align 8
  %p250 = load ptr, ptr %p2, align 8
  %cast51 = ptrtoint ptr %p250 to i64
  %null_chk52 = icmp eq i64 %cast51, 0
  %null_ext53 = zext i1 %null_chk52 to i64
  call void @avra_null_deref_trap(ptr @fld_name.38, i64 1, ptr @sty_name.39, i64 5, i64 %null_ext53, ptr @src_file.40, i64 109, i64 46)
  %x_ptr = getelementptr inbounds nuw %Point, ptr %p250, i32 0, i32 0
  %x = load i64, ptr %x_ptr, align 8
  %34 = call ptr @avra_rc_alloc(i64 32)
  %35 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %34, i64 32, ptr @.i2s_fmt.41, i64 %x)
  %widen54 = sext i32 %35 to i64
  %36 = call i64 @strlen(ptr @.str.37)
  %37 = call i64 @strlen(ptr %34)
  %concat_total55 = add i64 %36, %37
  %concat_size56 = add i64 %concat_total55, 1
  %38 = call ptr @avra_rc_alloc(i64 %concat_size56)
  %39 = call ptr @memcpy(ptr %38, ptr @.str.37, i64 %36)
  %cast57 = ptrtoint ptr %38 to i64
  %dst2_int58 = add i64 %cast57, %36
  %cast59 = inttoptr i64 %dst2_int58 to ptr
  %rhs_len_p160 = add i64 %37, 1
  %40 = call ptr @memcpy(ptr %cast59, ptr %34, i64 %rhs_len_p160)
  %41 = call i64 @strlen(ptr %38)
  %42 = call i64 @strlen(ptr @.str.42)
  %concat_total61 = add i64 %41, %42
  %concat_size62 = add i64 %concat_total61, 1
  %43 = call ptr @avra_rc_alloc(i64 %concat_size62)
  %44 = call ptr @memcpy(ptr %43, ptr %38, i64 %41)
  %cast63 = ptrtoint ptr %43 to i64
  %dst2_int64 = add i64 %cast63, %41
  %cast65 = inttoptr i64 %dst2_int64 to ptr
  %rhs_len_p166 = add i64 %42, 1
  %45 = call ptr @memcpy(ptr %cast65, ptr @.str.42, i64 %rhs_len_p166)
  %p267 = load ptr, ptr %p2, align 8
  %cast68 = ptrtoint ptr %p267 to i64
  %null_chk69 = icmp eq i64 %cast68, 0
  %null_ext70 = zext i1 %null_chk69 to i64
  call void @avra_null_deref_trap(ptr @fld_name.43, i64 1, ptr @sty_name.44, i64 5, i64 %null_ext70, ptr @src_file.45, i64 109, i64 46)
  %y_ptr = getelementptr inbounds nuw %Point, ptr %p267, i32 0, i32 1
  %y = load i64, ptr %y_ptr, align 8
  %46 = call ptr @avra_rc_alloc(i64 32)
  %47 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %46, i64 32, ptr @.i2s_fmt.46, i64 %y)
  %widen71 = sext i32 %47 to i64
  %48 = call i64 @strlen(ptr %43)
  %49 = call i64 @strlen(ptr %46)
  %concat_total72 = add i64 %48, %49
  %concat_size73 = add i64 %concat_total72, 1
  %50 = call ptr @avra_rc_alloc(i64 %concat_size73)
  %51 = call ptr @memcpy(ptr %50, ptr %43, i64 %48)
  %cast74 = ptrtoint ptr %50 to i64
  %dst2_int75 = add i64 %cast74, %48
  %cast76 = inttoptr i64 %dst2_int75 to ptr
  %rhs_len_p177 = add i64 %49, 1
  %52 = call ptr @memcpy(ptr %cast76, ptr %46, i64 %rhs_len_p177)
  %53 = call i64 @strlen(ptr %50)
  %54 = call i64 @strlen(ptr @.str.47)
  %concat_total78 = add i64 %53, %54
  %concat_size79 = add i64 %concat_total78, 1
  %55 = call ptr @avra_rc_alloc(i64 %concat_size79)
  %56 = call ptr @memcpy(ptr %55, ptr %50, i64 %53)
  %cast80 = ptrtoint ptr %55 to i64
  %dst2_int81 = add i64 %cast80, %53
  %cast82 = inttoptr i64 %dst2_int81 to ptr
  %rhs_len_p183 = add i64 %54, 1
  %57 = call ptr @memcpy(ptr %cast82, ptr @.str.47, i64 %rhs_len_p183)
  %58 = call i32 @puts(ptr %55)
  %widen84 = sext i32 %58 to i64
  %59 = call i32 @puts(ptr @.str.48)
  %widen85 = sext i32 %59 to i64
  %c_cleanup = load ptr, ptr %c, align 8
  %60 = call i64 @__release_Cat(ptr %c_cleanup)
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Cat(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %Cat, ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_name_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_name_do:                                      ; preds = %do_free
  call void @avra_rc_release(ptr %rel_name)
  br label %rel_name_skip
}

define i64 @__release_Dog(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %Dog, ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_name_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_name_do:                                      ; preds = %do_free
  call void @avra_rc_release(ptr %rel_name)
  br label %rel_name_skip
}
