; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%User = type { ptr, i64 }

@.str = private unnamed_addr constant [10 x i8] c"{\22name\22:\22\00", align 1
@fld_name = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name = private unnamed_addr constant [5 x i8] c"User\00", align 1
@src_file = private unnamed_addr constant [109 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/stress_trait_hierarchy.av\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"\22,\22age\22:\00", align 1
@fld_name.2 = private unnamed_addr constant [4 x i8] c"age\00", align 1
@sty_name.3 = private unnamed_addr constant [5 x i8] c"User\00", align 1
@src_file.4 = private unnamed_addr constant [109 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/stress_trait_hierarchy.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"}\00", align 1
@fld_name.6 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.7 = private unnamed_addr constant [5 x i8] c"User\00", align 1
@src_file.8 = private unnamed_addr constant [109 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/stress_trait_hierarchy.av\00", align 1
@.str.9 = private unnamed_addr constant [2 x i8] c",\00", align 1
@fld_name.10 = private unnamed_addr constant [4 x i8] c"age\00", align 1
@sty_name.11 = private unnamed_addr constant [5 x i8] c"User\00", align 1
@src_file.12 = private unnamed_addr constant [109 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/stress_trait_hierarchy.av\00", align 1
@.i2s_fmt.13 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.14 = private unnamed_addr constant [6 x i8] c"User(\00", align 1
@fld_name.15 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.16 = private unnamed_addr constant [5 x i8] c"User\00", align 1
@src_file.17 = private unnamed_addr constant [109 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/stress_trait_hierarchy.av\00", align 1
@.str.18 = private unnamed_addr constant [3 x i8] c", \00", align 1
@fld_name.19 = private unnamed_addr constant [4 x i8] c"age\00", align 1
@sty_name.20 = private unnamed_addr constant [5 x i8] c"User\00", align 1
@src_file.21 = private unnamed_addr constant [109 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/stress_trait_hierarchy.av\00", align 1
@.i2s_fmt.22 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.23 = private unnamed_addr constant [2 x i8] c")\00", align 1
@.str.24 = private unnamed_addr constant [7 x i8] c"json: \00", align 1
@.str.25 = private unnamed_addr constant [6 x i8] c"csv: \00", align 1
@.str.26 = private unnamed_addr constant [10 x i8] c"display: \00", align 1
@.str.27 = private unnamed_addr constant [6 x i8] c"Alice\00", align 1

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

define ptr @User__to_json(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 4, ptr @sty_name, i64 4, i64 %null_ext, ptr @src_file, i64 108, i64 13)
  %name_ptr = getelementptr inbounds nuw %User, ptr %self1, i32 0, i32 0
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
  call void @avra_null_deref_trap(ptr @fld_name.2, i64 3, ptr @sty_name.3, i64 4, i64 %null_ext13, ptr @src_file.4, i64 108, i64 13)
  %age_ptr = getelementptr inbounds nuw %User, ptr %self10, i32 0, i32 1
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

define ptr @User__to_csv(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.6, i64 4, ptr @sty_name.7, i64 4, i64 %null_ext, ptr @src_file.8, i64 108, i64 18)
  %name_ptr = getelementptr inbounds nuw %User, ptr %self1, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %1 = call i64 @strlen(ptr %name)
  %2 = call i64 @strlen(ptr @.str.9)
  %concat_total = add i64 %1, %2
  %concat_size = add i64 %concat_total, 1
  %3 = call ptr @avra_rc_alloc(i64 %concat_size)
  %4 = call ptr @memcpy(ptr %3, ptr %name, i64 %1)
  %cast2 = ptrtoint ptr %3 to i64
  %dst2_int = add i64 %cast2, %1
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %2, 1
  %5 = call ptr @memcpy(ptr %cast3, ptr @.str.9, i64 %rhs_len_p1)
  %self4 = load ptr, ptr %self, align 8
  %cast5 = ptrtoint ptr %self4 to i64
  %null_chk6 = icmp eq i64 %cast5, 0
  %null_ext7 = zext i1 %null_chk6 to i64
  call void @avra_null_deref_trap(ptr @fld_name.10, i64 3, ptr @sty_name.11, i64 4, i64 %null_ext7, ptr @src_file.12, i64 108, i64 18)
  %age_ptr = getelementptr inbounds nuw %User, ptr %self4, i32 0, i32 1
  %age = load i64, ptr %age_ptr, align 8
  %6 = call ptr @avra_rc_alloc(i64 32)
  %7 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %6, i64 32, ptr @.i2s_fmt.13, i64 %age)
  %widen = sext i32 %7 to i64
  %8 = call i64 @strlen(ptr %3)
  %9 = call i64 @strlen(ptr %6)
  %concat_total8 = add i64 %8, %9
  %concat_size9 = add i64 %concat_total8, 1
  %10 = call ptr @avra_rc_alloc(i64 %concat_size9)
  %11 = call ptr @memcpy(ptr %10, ptr %3, i64 %8)
  %cast10 = ptrtoint ptr %10 to i64
  %dst2_int11 = add i64 %cast10, %8
  %cast12 = inttoptr i64 %dst2_int11 to ptr
  %rhs_len_p113 = add i64 %9, 1
  %12 = call ptr @memcpy(ptr %cast12, ptr %6, i64 %rhs_len_p113)
  ret ptr %10
}

define ptr @User__display(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.15, i64 4, ptr @sty_name.16, i64 4, i64 %null_ext, ptr @src_file.17, i64 108, i64 22)
  %name_ptr = getelementptr inbounds nuw %User, ptr %self1, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %1 = call i64 @strlen(ptr @.str.14)
  %2 = call i64 @strlen(ptr %name)
  %concat_total = add i64 %1, %2
  %concat_size = add i64 %concat_total, 1
  %3 = call ptr @avra_rc_alloc(i64 %concat_size)
  %4 = call ptr @memcpy(ptr %3, ptr @.str.14, i64 %1)
  %cast2 = ptrtoint ptr %3 to i64
  %dst2_int = add i64 %cast2, %1
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %2, 1
  %5 = call ptr @memcpy(ptr %cast3, ptr %name, i64 %rhs_len_p1)
  %6 = call i64 @strlen(ptr %3)
  %7 = call i64 @strlen(ptr @.str.18)
  %concat_total4 = add i64 %6, %7
  %concat_size5 = add i64 %concat_total4, 1
  %8 = call ptr @avra_rc_alloc(i64 %concat_size5)
  %9 = call ptr @memcpy(ptr %8, ptr %3, i64 %6)
  %cast6 = ptrtoint ptr %8 to i64
  %dst2_int7 = add i64 %cast6, %6
  %cast8 = inttoptr i64 %dst2_int7 to ptr
  %rhs_len_p19 = add i64 %7, 1
  %10 = call ptr @memcpy(ptr %cast8, ptr @.str.18, i64 %rhs_len_p19)
  %self10 = load ptr, ptr %self, align 8
  %cast11 = ptrtoint ptr %self10 to i64
  %null_chk12 = icmp eq i64 %cast11, 0
  %null_ext13 = zext i1 %null_chk12 to i64
  call void @avra_null_deref_trap(ptr @fld_name.19, i64 3, ptr @sty_name.20, i64 4, i64 %null_ext13, ptr @src_file.21, i64 108, i64 22)
  %age_ptr = getelementptr inbounds nuw %User, ptr %self10, i32 0, i32 1
  %age = load i64, ptr %age_ptr, align 8
  %11 = call ptr @avra_rc_alloc(i64 32)
  %12 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %11, i64 32, ptr @.i2s_fmt.22, i64 %age)
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
  %19 = call i64 @strlen(ptr @.str.23)
  %concat_total20 = add i64 %18, %19
  %concat_size21 = add i64 %concat_total20, 1
  %20 = call ptr @avra_rc_alloc(i64 %concat_size21)
  %21 = call ptr @memcpy(ptr %20, ptr %15, i64 %18)
  %cast22 = ptrtoint ptr %20 to i64
  %dst2_int23 = add i64 %cast22, %18
  %cast24 = inttoptr i64 %dst2_int23 to ptr
  %rhs_len_p125 = add i64 %19, 1
  %22 = call ptr @memcpy(ptr %cast24, ptr @.str.23, i64 %rhs_len_p125)
  ret ptr %20
}

define i64 @show_json(i64 %0) {
entry:
  %item = alloca ptr, align 8
  %cast = inttoptr i64 %0 to ptr
  store ptr %cast, ptr %item, align 8
  %item1 = load ptr, ptr %item, align 8
  %1 = call i64 @avra_trait_object_value(ptr %item1)
  %2 = call ptr @avra_trait_object_vtable(ptr %item1)
  %3 = call i64 @avra_array_get(ptr %2, i64 0)
  %4 = call i64 @avra_closure_call_1(i64 %3, i64 %1)
  %cast2 = inttoptr i64 %4 to ptr
  %5 = call i64 @strlen(ptr @.str.24)
  %6 = call i64 @strlen(ptr %cast2)
  %concat_total = add i64 %5, %6
  %concat_size = add i64 %concat_total, 1
  %7 = call ptr @avra_rc_alloc(i64 %concat_size)
  %8 = call ptr @memcpy(ptr %7, ptr @.str.24, i64 %5)
  %cast3 = ptrtoint ptr %7 to i64
  %dst2_int = add i64 %cast3, %5
  %cast4 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %6, 1
  %9 = call ptr @memcpy(ptr %cast4, ptr %cast2, i64 %rhs_len_p1)
  %10 = call i32 @puts(ptr %7)
  %widen = sext i32 %10 to i64
  ret i64 0
}

define i64 @show_csv(i64 %0) {
entry:
  %item = alloca ptr, align 8
  %cast = inttoptr i64 %0 to ptr
  store ptr %cast, ptr %item, align 8
  %item1 = load ptr, ptr %item, align 8
  %1 = call i64 @avra_trait_object_value(ptr %item1)
  %2 = call ptr @avra_trait_object_vtable(ptr %item1)
  %3 = call i64 @avra_array_get(ptr %2, i64 0)
  %4 = call i64 @avra_closure_call_1(i64 %3, i64 %1)
  %cast2 = inttoptr i64 %4 to ptr
  %5 = call i64 @strlen(ptr @.str.25)
  %6 = call i64 @strlen(ptr %cast2)
  %concat_total = add i64 %5, %6
  %concat_size = add i64 %concat_total, 1
  %7 = call ptr @avra_rc_alloc(i64 %concat_size)
  %8 = call ptr @memcpy(ptr %7, ptr @.str.25, i64 %5)
  %cast3 = ptrtoint ptr %7 to i64
  %dst2_int = add i64 %cast3, %5
  %cast4 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %6, 1
  %9 = call ptr @memcpy(ptr %cast4, ptr %cast2, i64 %rhs_len_p1)
  %10 = call i32 @puts(ptr %7)
  %widen = sext i32 %10 to i64
  ret i64 0
}

define i64 @show_display(i64 %0) {
entry:
  %item = alloca ptr, align 8
  %cast = inttoptr i64 %0 to ptr
  store ptr %cast, ptr %item, align 8
  %item1 = load ptr, ptr %item, align 8
  %1 = call i64 @avra_trait_object_value(ptr %item1)
  %2 = call ptr @avra_trait_object_vtable(ptr %item1)
  %3 = call i64 @avra_array_get(ptr %2, i64 0)
  %4 = call i64 @avra_closure_call_1(i64 %3, i64 %1)
  %cast2 = inttoptr i64 %4 to ptr
  %5 = call i64 @strlen(ptr @.str.26)
  %6 = call i64 @strlen(ptr %cast2)
  %concat_total = add i64 %5, %6
  %concat_size = add i64 %concat_total, 1
  %7 = call ptr @avra_rc_alloc(i64 %concat_size)
  %8 = call ptr @memcpy(ptr %7, ptr @.str.26, i64 %5)
  %cast3 = ptrtoint ptr %7 to i64
  %dst2_int = add i64 %cast3, %5
  %cast4 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %6, 1
  %9 = call ptr @memcpy(ptr %cast4, ptr %cast2, i64 %rhs_len_p1)
  %10 = call i32 @puts(ptr %7)
  %widen = sext i32 %10 to i64
  ret i64 0
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %u = alloca ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %User, ptr %1, i32 0, i32 0
  store ptr @.str.27, ptr %fld_ptr, align 8
  %fld_ptr1 = getelementptr inbounds nuw %User, ptr %1, i32 0, i32 1
  store i64 30, ptr %fld_ptr1, align 8
  %cast = ptrtoint ptr %1 to i64
  %cast2 = inttoptr i64 %cast to ptr
  store ptr %cast2, ptr %u, align 8
  %u3 = load ptr, ptr %u, align 8
  %2 = call ptr @avra_array_new()
  %3 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %3, i64 -559038737)
  call void @avra_array_push(ptr %3, i64 ptrtoint (ptr @User__to_json to i64))
  %cast4 = ptrtoint ptr %3 to i64
  call void @avra_array_push(ptr %2, i64 %cast4)
  %cast5 = ptrtoint ptr %2 to i64
  %4 = call i64 @avra_trait_object_new(ptr %u3, i64 %cast5)
  %5 = call i64 @show_json(i64 %4)
  %u6 = load ptr, ptr %u, align 8
  %6 = call ptr @avra_array_new()
  %7 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %7, i64 -559038737)
  call void @avra_array_push(ptr %7, i64 ptrtoint (ptr @User__to_csv to i64))
  %cast7 = ptrtoint ptr %7 to i64
  call void @avra_array_push(ptr %6, i64 %cast7)
  %cast8 = ptrtoint ptr %6 to i64
  %8 = call i64 @avra_trait_object_new(ptr %u6, i64 %cast8)
  %9 = call i64 @show_csv(i64 %8)
  %u9 = load ptr, ptr %u, align 8
  %10 = call ptr @avra_array_new()
  %11 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %11, i64 -559038737)
  call void @avra_array_push(ptr %11, i64 ptrtoint (ptr @User__display to i64))
  %cast10 = ptrtoint ptr %11 to i64
  call void @avra_array_push(ptr %10, i64 %cast10)
  %cast11 = ptrtoint ptr %10 to i64
  %12 = call i64 @avra_trait_object_new(ptr %u9, i64 %cast11)
  %13 = call i64 @show_display(i64 %12)
  ret i64 %13
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_User(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %User, ptr %0, i32 0, i32 0
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
