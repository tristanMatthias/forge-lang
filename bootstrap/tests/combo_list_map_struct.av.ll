; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%User = type { ptr, i64 }

@users = global i64 0
@names = global i64 0
@ages = global i64 0
@adult_ages = global i64 0
@total_age = global i64 0
@displays = global i64 0
@data = global i64 0
@fld_name = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name = private unnamed_addr constant [5 x i8] c"User\00", align 1
@src_file = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_list_map_struct.av\00", align 1
@.str = private unnamed_addr constant [3 x i8] c" (\00", align 1
@fld_name.1 = private unnamed_addr constant [4 x i8] c"age\00", align 1
@sty_name.2 = private unnamed_addr constant [5 x i8] c"User\00", align 1
@src_file.3 = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_list_map_struct.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c")\00", align 1
@fld_name.5 = private unnamed_addr constant [4 x i8] c"age\00", align 1
@sty_name.6 = private unnamed_addr constant [5 x i8] c"User\00", align 1
@src_file.7 = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_list_map_struct.av\00", align 1
@.str.8 = private unnamed_addr constant [6 x i8] c"Alice\00", align 1
@.str.9 = private unnamed_addr constant [4 x i8] c"Bob\00", align 1
@.str.10 = private unnamed_addr constant [8 x i8] c"Charlie\00", align 1
@.str.11 = private unnamed_addr constant [6 x i8] c"Diana\00", align 1
@fld_name.12 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.13 = private unnamed_addr constant [5 x i8] c"User\00", align 1
@src_file.14 = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_list_map_struct.av\00", align 1
@fld_name.15 = private unnamed_addr constant [4 x i8] c"age\00", align 1
@sty_name.16 = private unnamed_addr constant [5 x i8] c"User\00", align 1
@src_file.17 = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_list_map_struct.av\00", align 1
@.i2s_fmt.18 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.19 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.20 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.21 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name.22 = private unnamed_addr constant [8 x i8] c"display\00", align 1
@sty_name.23 = private unnamed_addr constant [5 x i8] c"User\00", align 1
@src_file.24 = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_list_map_struct.av\00", align 1
@.str.25 = private unnamed_addr constant [6 x i8] c"count\00", align 1
@.i2s_fmt.26 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.27 = private unnamed_addr constant [7 x i8] c"oldest\00", align 1
@.str.28 = private unnamed_addr constant [6 x i8] c"Alice\00", align 1
@.str.29 = private unnamed_addr constant [6 x i8] c"count\00", align 1
@.str.30 = private unnamed_addr constant [7 x i8] c"oldest\00", align 1

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

define ptr @User__display(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 4, ptr @sty_name, i64 4, i64 %null_ext, ptr @src_file, i64 107, i64 6)
  %name_ptr = getelementptr inbounds nuw %User, ptr %self1, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %1 = call i64 @strlen(ptr %name)
  %2 = call i64 @strlen(ptr @.str)
  %concat_total = add i64 %1, %2
  %concat_size = add i64 %concat_total, 1
  %3 = call ptr @avra_rc_alloc(i64 %concat_size)
  %4 = call ptr @memcpy(ptr %3, ptr %name, i64 %1)
  %cast2 = ptrtoint ptr %3 to i64
  %dst2_int = add i64 %cast2, %1
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %2, 1
  %5 = call ptr @memcpy(ptr %cast3, ptr @.str, i64 %rhs_len_p1)
  %self4 = load ptr, ptr %self, align 8
  %cast5 = ptrtoint ptr %self4 to i64
  %null_chk6 = icmp eq i64 %cast5, 0
  %null_ext7 = zext i1 %null_chk6 to i64
  call void @avra_null_deref_trap(ptr @fld_name.1, i64 3, ptr @sty_name.2, i64 4, i64 %null_ext7, ptr @src_file.3, i64 107, i64 6)
  %age_ptr = getelementptr inbounds nuw %User, ptr %self4, i32 0, i32 1
  %age = load i64, ptr %age_ptr, align 8
  %6 = call ptr @avra_rc_alloc(i64 32)
  %7 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %6, i64 32, ptr @.i2s_fmt, i64 %age)
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
  %13 = call i64 @strlen(ptr %10)
  %14 = call i64 @strlen(ptr @.str.4)
  %concat_total14 = add i64 %13, %14
  %concat_size15 = add i64 %concat_total14, 1
  %15 = call ptr @avra_rc_alloc(i64 %concat_size15)
  %16 = call ptr @memcpy(ptr %15, ptr %10, i64 %13)
  %cast16 = ptrtoint ptr %15 to i64
  %dst2_int17 = add i64 %cast16, %13
  %cast18 = inttoptr i64 %dst2_int17 to ptr
  %rhs_len_p119 = add i64 %14, 1
  %17 = call ptr @memcpy(ptr %cast18, ptr @.str.4, i64 %rhs_len_p119)
  ret ptr %15
}

define i1 @User__is_adult(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.5, i64 3, ptr @sty_name.6, i64 4, i64 %null_ext, ptr @src_file.7, i64 107, i64 9)
  %age_ptr = getelementptr inbounds nuw %User, ptr %self1, i32 0, i32 1
  %age = load i64, ptr %age_ptr, align 8
  %sge = icmp sge i64 %age, 18
  %sge_ext = zext i1 %sge to i64
  %cast2 = trunc i64 %sge_ext to i1
  ret i1 %cast2
}

define i64 @main() {
entry:
  %0 = call ptr @avra_array_new()
  %1 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %User, ptr %1, i32 0, i32 0
  store ptr @.str.8, ptr %fld_ptr, align 8
  %fld_ptr1 = getelementptr inbounds nuw %User, ptr %1, i32 0, i32 1
  store i64 30, ptr %fld_ptr1, align 8
  %cast = ptrtoint ptr %1 to i64
  call void @avra_array_push(ptr %0, i64 %cast)
  %2 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr2 = getelementptr inbounds nuw %User, ptr %2, i32 0, i32 0
  store ptr @.str.9, ptr %fld_ptr2, align 8
  %fld_ptr3 = getelementptr inbounds nuw %User, ptr %2, i32 0, i32 1
  store i64 15, ptr %fld_ptr3, align 8
  %cast4 = ptrtoint ptr %2 to i64
  call void @avra_array_push(ptr %0, i64 %cast4)
  %3 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr5 = getelementptr inbounds nuw %User, ptr %3, i32 0, i32 0
  store ptr @.str.10, ptr %fld_ptr5, align 8
  %fld_ptr6 = getelementptr inbounds nuw %User, ptr %3, i32 0, i32 1
  store i64 25, ptr %fld_ptr6, align 8
  %cast7 = ptrtoint ptr %3 to i64
  call void @avra_array_push(ptr %0, i64 %cast7)
  %4 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr8 = getelementptr inbounds nuw %User, ptr %4, i32 0, i32 0
  store ptr @.str.11, ptr %fld_ptr8, align 8
  %fld_ptr9 = getelementptr inbounds nuw %User, ptr %4, i32 0, i32 1
  store i64 12, ptr %fld_ptr9, align 8
  %cast10 = ptrtoint ptr %4 to i64
  call void @avra_array_push(ptr %0, i64 %cast10)
  store ptr %0, ptr @users, align 8
  %users = load ptr, ptr @users, align 8
  %5 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %5, i64 -559038737)
  call void @avra_array_push(ptr %5, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast11 = ptrtoint ptr %5 to i64
  %6 = call ptr @avra_array_map(ptr %users, i64 %cast11)
  store ptr %6, ptr @names, align 8
  %names = load ptr, ptr @names, align 8
  %7 = call i64 @avra_array_get(ptr %names, i64 0)
  %cast12 = inttoptr i64 %7 to ptr
  %8 = call i32 @puts(ptr %cast12)
  %widen = sext i32 %8 to i64
  %names13 = load ptr, ptr @names, align 8
  %9 = call i64 @avra_array_get(ptr %names13, i64 1)
  %cast14 = inttoptr i64 %9 to ptr
  %10 = call i32 @puts(ptr %cast14)
  %widen15 = sext i32 %10 to i64
  %names16 = load ptr, ptr @names, align 8
  %11 = call i64 @avra_array_get(ptr %names16, i64 2)
  %cast17 = inttoptr i64 %11 to ptr
  %12 = call i32 @puts(ptr %cast17)
  %widen18 = sext i32 %12 to i64
  %names19 = load ptr, ptr @names, align 8
  %13 = call i64 @avra_array_get(ptr %names19, i64 3)
  %cast20 = inttoptr i64 %13 to ptr
  %14 = call i32 @puts(ptr %cast20)
  %widen21 = sext i32 %14 to i64
  %users22 = load ptr, ptr @users, align 8
  %15 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %15, i64 -559038737)
  call void @avra_array_push(ptr %15, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cast23 = ptrtoint ptr %15 to i64
  %16 = call ptr @avra_array_map(ptr %users22, i64 %cast23)
  store ptr %16, ptr @ages, align 8
  %ages = load ptr, ptr @ages, align 8
  %17 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %17, i64 -559038737)
  call void @avra_array_push(ptr %17, i64 ptrtoint (ptr @__lambda_2 to i64))
  %cast24 = ptrtoint ptr %17 to i64
  %18 = call ptr @avra_array_filter(ptr %ages, i64 %cast24)
  store ptr %18, ptr @adult_ages, align 8
  %adult_ages = load ptr, ptr @adult_ages, align 8
  %19 = call i64 @avra_array_len(ptr %adult_ages)
  %20 = call ptr @avra_rc_alloc(i64 32)
  %21 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %20, i64 32, ptr @.i2s_fmt.18, i64 %19)
  %widen25 = sext i32 %21 to i64
  %22 = call i32 @puts(ptr %20)
  %widen26 = sext i32 %22 to i64
  %adult_ages27 = load ptr, ptr @adult_ages, align 8
  %23 = call i64 @avra_array_get(ptr %adult_ages27, i64 0)
  %24 = call ptr @avra_rc_alloc(i64 32)
  %25 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %24, i64 32, ptr @.i2s_fmt.19, i64 %23)
  %widen28 = sext i32 %25 to i64
  %26 = call i32 @puts(ptr %24)
  %widen29 = sext i32 %26 to i64
  %adult_ages30 = load ptr, ptr @adult_ages, align 8
  %27 = call i64 @avra_array_get(ptr %adult_ages30, i64 1)
  %28 = call ptr @avra_rc_alloc(i64 32)
  %29 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %28, i64 32, ptr @.i2s_fmt.20, i64 %27)
  %widen31 = sext i32 %29 to i64
  %30 = call i32 @puts(ptr %28)
  %widen32 = sext i32 %30 to i64
  %ages33 = load ptr, ptr @ages, align 8
  %31 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %31, i64 -559038737)
  call void @avra_array_push(ptr %31, i64 ptrtoint (ptr @__lambda_3 to i64))
  %cast34 = ptrtoint ptr %31 to i64
  %32 = call i64 @avra_array_reduce(ptr %ages33, i64 0, i64 %cast34)
  store i64 %32, ptr @total_age, align 8
  %total_age = load i64, ptr @total_age, align 8
  %33 = call ptr @avra_rc_alloc(i64 32)
  %34 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %33, i64 32, ptr @.i2s_fmt.21, i64 %total_age)
  %widen35 = sext i32 %34 to i64
  %35 = call i32 @puts(ptr %33)
  %widen36 = sext i32 %35 to i64
  %users37 = load ptr, ptr @users, align 8
  %36 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %36, i64 -559038737)
  call void @avra_array_push(ptr %36, i64 ptrtoint (ptr @__lambda_4 to i64))
  %cast38 = ptrtoint ptr %36 to i64
  %37 = call ptr @avra_array_map(ptr %users37, i64 %cast38)
  store ptr %37, ptr @displays, align 8
  %displays = load ptr, ptr @displays, align 8
  %38 = call i64 @avra_array_get(ptr %displays, i64 0)
  %cast39 = inttoptr i64 %38 to ptr
  %39 = call i32 @puts(ptr %cast39)
  %widen40 = sext i32 %39 to i64
  %displays41 = load ptr, ptr @displays, align 8
  %40 = call i64 @avra_array_get(ptr %displays41, i64 3)
  %cast42 = inttoptr i64 %40 to ptr
  %41 = call i32 @puts(ptr %cast42)
  %widen43 = sext i32 %41 to i64
  %42 = call ptr @avra_map_new_cstr()
  %users44 = load ptr, ptr @users, align 8
  %43 = call i64 @avra_array_len(ptr %users44)
  %44 = call ptr @avra_rc_alloc(i64 32)
  %45 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %44, i64 32, ptr @.i2s_fmt.26, i64 %43)
  %widen45 = sext i32 %45 to i64
  %cast46 = ptrtoint ptr %44 to i64
  call void @avra_map_set_cstr(ptr %42, ptr @.str.25, i64 %cast46)
  call void @avra_map_set_cstr(ptr %42, ptr @.str.27, i64 ptrtoint (ptr @.str.28 to i64))
  store ptr %42, ptr @data, align 8
  %data = load ptr, ptr @data, align 8
  %46 = call i64 @avra_map_get_cstr(ptr %data, ptr @.str.29)
  %cast47 = inttoptr i64 %46 to ptr
  %47 = call i32 @puts(ptr %cast47)
  %widen48 = sext i32 %47 to i64
  %data49 = load ptr, ptr @data, align 8
  %48 = call i64 @avra_map_get_cstr(ptr %data49, ptr @.str.30)
  %cast50 = inttoptr i64 %48 to ptr
  %49 = call i32 @puts(ptr %cast50)
  %widen51 = sext i32 %49 to i64
  %50 = call i32 @avra_test_summary()
  %widen52 = sext i32 %50 to i64
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

define i64 @__lambda_0(ptr %0) {
entry:
  %it = alloca ptr, align 8
  store ptr %0, ptr %it, align 8
  %it1 = load ptr, ptr %it, align 8
  %cast = ptrtoint ptr %it1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.12, i64 4, ptr @sty_name.13, i64 4, i64 %null_ext, ptr @src_file.14, i64 107, i64 21)
  %name_ptr = getelementptr inbounds nuw %User, ptr %it1, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %cast2 = ptrtoint ptr %name to i64
  ret i64 %cast2
}

define i64 @__lambda_1(ptr %0) {
entry:
  %it = alloca ptr, align 8
  store ptr %0, ptr %it, align 8
  %it1 = load ptr, ptr %it, align 8
  %cast = ptrtoint ptr %it1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.15, i64 3, ptr @sty_name.16, i64 4, i64 %null_ext, ptr @src_file.17, i64 107, i64 28)
  %age_ptr = getelementptr inbounds nuw %User, ptr %it1, i32 0, i32 1
  %age = load i64, ptr %age_ptr, align 8
  ret i64 %age
}

define i64 @__lambda_2(i64 %0) {
entry:
  %it = alloca i64, align 8
  store i64 %0, ptr %it, align 8
  %it1 = load i64, ptr %it, align 8
  %sge = icmp sge i64 %it1, 18
  %sge_ext = zext i1 %sge to i64
  ret i64 %sge_ext
}

define i64 @__lambda_3(i64 %0, i64 %1) {
entry:
  %a = alloca i64, align 8
  %acc = alloca i64, align 8
  store i64 %0, ptr %acc, align 8
  store i64 %1, ptr %a, align 8
  %acc1 = load i64, ptr %acc, align 8
  %a2 = load i64, ptr %a, align 8
  %add = add i64 %acc1, %a2
  ret i64 %add
}

define i64 @__lambda_4(ptr %0) {
entry:
  %it = alloca ptr, align 8
  store ptr %0, ptr %it, align 8
  %it1 = load ptr, ptr %it, align 8
  %cast = ptrtoint ptr %it1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.22, i64 7, ptr @sty_name.23, i64 4, i64 %null_ext, ptr @src_file.24, i64 107, i64 39)
  %1 = call ptr @User__display(ptr %it1)
  %cast2 = ptrtoint ptr %1 to i64
  ret i64 %cast2
}
