; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Task = type { ptr, i64, i64 }

@tasks = global i64 0
@READ = global i64 0
@WRITE = global i64 0
@EXEC = global i64 0
@perms = global i64 0
@results = global i64 0
@sum = global i64 0
@fld_name = private unnamed_addr constant [6 x i8] c"title\00", align 1
@sty_name = private unnamed_addr constant [5 x i8] c"Task\00", align 1
@src_file = private unnamed_addr constant [101 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_ultimate.av\00", align 1
@.str = private unnamed_addr constant [4 x i8] c" (p\00", align 1
@fld_name.1 = private unnamed_addr constant [9 x i8] c"priority\00", align 1
@sty_name.2 = private unnamed_addr constant [5 x i8] c"Task\00", align 1
@src_file.3 = private unnamed_addr constant [101 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_ultimate.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c")\00", align 1
@fld_name.5 = private unnamed_addr constant [9 x i8] c"priority\00", align 1
@sty_name.6 = private unnamed_addr constant [5 x i8] c"Task\00", align 1
@src_file.7 = private unnamed_addr constant [101 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_ultimate.av\00", align 1
@.str.8 = private unnamed_addr constant [7 x i8] c"design\00", align 1
@.str.9 = private unnamed_addr constant [10 x i8] c"implement\00", align 1
@.str.10 = private unnamed_addr constant [5 x i8] c"test\00", align 1
@.str.11 = private unnamed_addr constant [5 x i8] c"docs\00", align 1
@.str.12 = private unnamed_addr constant [7 x i8] c"deploy\00", align 1
@fld_name.13 = private unnamed_addr constant [17 x i8] c"is_high_priority\00", align 1
@sty_name.14 = private unnamed_addr constant [5 x i8] c"Task\00", align 1
@src_file.15 = private unnamed_addr constant [101 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_ultimate.av\00", align 1
@fld_name.16 = private unnamed_addr constant [5 x i8] c"done\00", align 1
@sty_name.17 = private unnamed_addr constant [5 x i8] c"Task\00", align 1
@src_file.18 = private unnamed_addr constant [101 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_ultimate.av\00", align 1
@fld_name.19 = private unnamed_addr constant [9 x i8] c"describe\00", align 1
@sty_name.20 = private unnamed_addr constant [5 x i8] c"Task\00", align 1
@src_file.21 = private unnamed_addr constant [101 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_ultimate.av\00", align 1
@.i2s_fmt.22 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.23 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.24 = private unnamed_addr constant [5 x i8] c"pass\00", align 1
@.str.25 = private unnamed_addr constant [2 x i8] c"3\00", align 1
@.str.26 = private unnamed_addr constant [5 x i8] c"fail\00", align 1
@.str.27 = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.28 = private unnamed_addr constant [5 x i8] c"skip\00", align 1
@.str.29 = private unnamed_addr constant [2 x i8] c"1\00", align 1
@.str.30 = private unnamed_addr constant [5 x i8] c"pass\00", align 1
@.str.31 = private unnamed_addr constant [3 x i8] c"x=\00", align 1
@.i2s_fmt.32 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.33 = private unnamed_addr constant [5 x i8] c", y=\00", align 1
@.i2s_fmt.34 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.35 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.36 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define ptr @Task__describe(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 5, ptr @sty_name, i64 4, i64 %null_ext, ptr @src_file, i64 100, i64 10)
  %title_ptr = getelementptr inbounds nuw %Task, ptr %self1, i32 0, i32 0
  %title = load ptr, ptr %title_ptr, align 8
  %1 = call i64 @strlen(ptr %title)
  %2 = call i64 @strlen(ptr @.str)
  %concat_total = add i64 %1, %2
  %concat_size = add i64 %concat_total, 1
  %3 = call ptr @avra_rc_alloc(i64 %concat_size)
  %4 = call ptr @memcpy(ptr %3, ptr %title, i64 %1)
  %cast2 = ptrtoint ptr %3 to i64
  %dst2_int = add i64 %cast2, %1
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %2, 1
  %5 = call ptr @memcpy(ptr %cast3, ptr @.str, i64 %rhs_len_p1)
  %self4 = load ptr, ptr %self, align 8
  %cast5 = ptrtoint ptr %self4 to i64
  %null_chk6 = icmp eq i64 %cast5, 0
  %null_ext7 = zext i1 %null_chk6 to i64
  call void @avra_null_deref_trap(ptr @fld_name.1, i64 8, ptr @sty_name.2, i64 4, i64 %null_ext7, ptr @src_file.3, i64 100, i64 10)
  %priority_ptr = getelementptr inbounds nuw %Task, ptr %self4, i32 0, i32 1
  %priority = load i64, ptr %priority_ptr, align 8
  %6 = call ptr @avra_rc_alloc(i64 32)
  %7 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %6, i64 32, ptr @.i2s_fmt, i64 %priority)
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

define i1 @Task__is_high_priority(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.5, i64 8, ptr @sty_name.6, i64 4, i64 %null_ext, ptr @src_file.7, i64 100, i64 16)
  %priority_ptr = getelementptr inbounds nuw %Task, ptr %self1, i32 0, i32 1
  %priority = load i64, ptr %priority_ptr, align 8
  %sge = icmp sge i64 %priority, 3
  %sge_ext = zext i1 %sge to i64
  %cast2 = trunc i64 %sge_ext to i1
  ret i1 %cast2
}

define i64 @main() {
entry:
  %n = alloca i64, align 8
  %forin_i74 = alloca i64, align 8
  %forin_len73 = alloca i64, align 8
  %y50 = alloca i64, align 8
  %x49 = alloca i64, align 8
  %t = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %0 = call ptr @avra_array_new()
  %1 = call ptr @avra_rc_alloc(i64 24)
  %fld_ptr = getelementptr inbounds nuw %Task, ptr %1, i32 0, i32 0
  store ptr @.str.8, ptr %fld_ptr, align 8
  %fld_ptr1 = getelementptr inbounds nuw %Task, ptr %1, i32 0, i32 1
  store i64 5, ptr %fld_ptr1, align 8
  %fld_ptr2 = getelementptr inbounds nuw %Task, ptr %1, i32 0, i32 2
  store i64 1, ptr %fld_ptr2, align 8
  %cast = ptrtoint ptr %1 to i64
  call void @avra_array_push(ptr %0, i64 %cast)
  %2 = call ptr @avra_rc_alloc(i64 24)
  %fld_ptr3 = getelementptr inbounds nuw %Task, ptr %2, i32 0, i32 0
  store ptr @.str.9, ptr %fld_ptr3, align 8
  %fld_ptr4 = getelementptr inbounds nuw %Task, ptr %2, i32 0, i32 1
  store i64 4, ptr %fld_ptr4, align 8
  %fld_ptr5 = getelementptr inbounds nuw %Task, ptr %2, i32 0, i32 2
  store i64 0, ptr %fld_ptr5, align 8
  %cast6 = ptrtoint ptr %2 to i64
  call void @avra_array_push(ptr %0, i64 %cast6)
  %3 = call ptr @avra_rc_alloc(i64 24)
  %fld_ptr7 = getelementptr inbounds nuw %Task, ptr %3, i32 0, i32 0
  store ptr @.str.10, ptr %fld_ptr7, align 8
  %fld_ptr8 = getelementptr inbounds nuw %Task, ptr %3, i32 0, i32 1
  store i64 3, ptr %fld_ptr8, align 8
  %fld_ptr9 = getelementptr inbounds nuw %Task, ptr %3, i32 0, i32 2
  store i64 0, ptr %fld_ptr9, align 8
  %cast10 = ptrtoint ptr %3 to i64
  call void @avra_array_push(ptr %0, i64 %cast10)
  %4 = call ptr @avra_rc_alloc(i64 24)
  %fld_ptr11 = getelementptr inbounds nuw %Task, ptr %4, i32 0, i32 0
  store ptr @.str.11, ptr %fld_ptr11, align 8
  %fld_ptr12 = getelementptr inbounds nuw %Task, ptr %4, i32 0, i32 1
  store i64 1, ptr %fld_ptr12, align 8
  %fld_ptr13 = getelementptr inbounds nuw %Task, ptr %4, i32 0, i32 2
  store i64 1, ptr %fld_ptr13, align 8
  %cast14 = ptrtoint ptr %4 to i64
  call void @avra_array_push(ptr %0, i64 %cast14)
  %5 = call ptr @avra_rc_alloc(i64 24)
  %fld_ptr15 = getelementptr inbounds nuw %Task, ptr %5, i32 0, i32 0
  store ptr @.str.12, ptr %fld_ptr15, align 8
  %fld_ptr16 = getelementptr inbounds nuw %Task, ptr %5, i32 0, i32 1
  store i64 5, ptr %fld_ptr16, align 8
  %fld_ptr17 = getelementptr inbounds nuw %Task, ptr %5, i32 0, i32 2
  store i64 0, ptr %fld_ptr17, align 8
  %cast18 = ptrtoint ptr %5 to i64
  call void @avra_array_push(ptr %0, i64 %cast18)
  store ptr %0, ptr @tasks, align 8
  %tasks = load ptr, ptr @tasks, align 8
  %6 = call i64 @avra_array_len(ptr %tasks)
  store i64 %6, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %entry
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %7 = call i64 @avra_array_get(ptr %tasks, i64 %forin_i_val)
  store i64 %7, ptr %t, align 8
  %t19 = load ptr, ptr %t, align 8
  %cast20 = ptrtoint ptr %t19 to i64
  %null_chk = icmp eq i64 %cast20, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.13, i64 16, ptr @sty_name.14, i64 4, i64 %null_ext, ptr @src_file.15, i64 100, i64 31)
  %8 = call i1 @Task__is_high_priority(ptr %t19)
  %widen = zext i1 %8 to i64
  %l_bool = icmp ne i64 %widen, 0
  br i1 %l_bool, label %sc_rhs, label %sc_short

forin.incr:                                       ; preds = %ifcont
  %forin_i_old = load i64, ptr %forin_i, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  store i64 1, ptr @READ, align 8
  store i64 2, ptr @WRITE, align 8
  store i64 4, ptr @EXEC, align 8
  %READ = load i64, ptr @READ, align 8
  %WRITE = load i64, ptr @WRITE, align 8
  %bor = or i64 %READ, %WRITE
  store i64 %bor, ptr @perms, align 8
  %perms = load i64, ptr @perms, align 8
  %READ30 = load i64, ptr @READ, align 8
  %band = and i64 %perms, %READ30
  %ne = icmp ne i64 %band, 0
  %ne_ext = zext i1 %ne to i64
  %9 = call ptr @avra_rc_alloc(i64 32)
  %10 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %9, i64 32, ptr @.i2s_fmt.22, i64 %ne_ext)
  %widen31 = sext i32 %10 to i64
  %11 = call i32 @puts(ptr %9)
  %widen32 = sext i32 %11 to i64
  %perms33 = load i64, ptr @perms, align 8
  %EXEC = load i64, ptr @EXEC, align 8
  %band34 = and i64 %perms33, %EXEC
  %ne35 = icmp ne i64 %band34, 0
  %ne_ext36 = zext i1 %ne35 to i64
  %12 = call ptr @avra_rc_alloc(i64 32)
  %13 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %12, i64 32, ptr @.i2s_fmt.23, i64 %ne_ext36)
  %widen37 = sext i32 %13 to i64
  %14 = call i32 @puts(ptr %12)
  %widen38 = sext i32 %14 to i64
  %15 = call ptr @avra_map_new_cstr()
  store ptr %15, ptr @results, align 8
  %results = load ptr, ptr @results, align 8
  call void @avra_map_set_cstr(ptr %results, ptr @.str.24, i64 ptrtoint (ptr @.str.25 to i64))
  %results39 = load ptr, ptr @results, align 8
  call void @avra_map_set_cstr(ptr %results39, ptr @.str.26, i64 ptrtoint (ptr @.str.27 to i64))
  %results40 = load ptr, ptr @results, align 8
  call void @avra_map_set_cstr(ptr %results40, ptr @.str.28, i64 ptrtoint (ptr @.str.29 to i64))
  %results41 = load ptr, ptr @results, align 8
  %16 = call i64 @avra_map_get_cstr(ptr %results41, ptr @.str.30)
  %cast42 = inttoptr i64 %16 to ptr
  %17 = call i32 @puts(ptr %cast42)
  %widen43 = sext i32 %17 to i64
  %18 = call ptr @avra_rc_alloc(i64 16)
  %slot_base = ptrtoint ptr %18 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 42, ptr %slot, align 8
  %slot_base44 = ptrtoint ptr %18 to i64
  %slot_addr45 = add i64 %slot_base44, 8
  %slot46 = inttoptr i64 %slot_addr45 to ptr
  store i64 99, ptr %slot46, align 8
  %cast47 = ptrtoint ptr %18 to i64
  %cast48 = inttoptr i64 %cast47 to ptr
  %x_slot_base = ptrtoint ptr %cast48 to i64
  %x_slot_addr = add i64 %x_slot_base, 0
  %x_slot = inttoptr i64 %x_slot_addr to ptr
  %x = load i64, ptr %x_slot, align 8
  store i64 %x, ptr %x49, align 8
  %y_slot_base = ptrtoint ptr %cast48 to i64
  %y_slot_addr = add i64 %y_slot_base, 8
  %y_slot = inttoptr i64 %y_slot_addr to ptr
  %y = load i64, ptr %y_slot, align 8
  store i64 %y, ptr %y50, align 8
  %x51 = load i64, ptr %x49, align 8
  %19 = call ptr @avra_rc_alloc(i64 32)
  %20 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %19, i64 32, ptr @.i2s_fmt.32, i64 %x51)
  %widen52 = sext i32 %20 to i64
  %21 = call i64 @strlen(ptr @.str.31)
  %22 = call i64 @strlen(ptr %19)
  %concat_total = add i64 %21, %22
  %concat_size = add i64 %concat_total, 1
  %23 = call ptr @avra_rc_alloc(i64 %concat_size)
  %24 = call ptr @memcpy(ptr %23, ptr @.str.31, i64 %21)
  %cast53 = ptrtoint ptr %23 to i64
  %dst2_int = add i64 %cast53, %21
  %cast54 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %22, 1
  %25 = call ptr @memcpy(ptr %cast54, ptr %19, i64 %rhs_len_p1)
  %26 = call i64 @strlen(ptr %23)
  %27 = call i64 @strlen(ptr @.str.33)
  %concat_total55 = add i64 %26, %27
  %concat_size56 = add i64 %concat_total55, 1
  %28 = call ptr @avra_rc_alloc(i64 %concat_size56)
  %29 = call ptr @memcpy(ptr %28, ptr %23, i64 %26)
  %cast57 = ptrtoint ptr %28 to i64
  %dst2_int58 = add i64 %cast57, %26
  %cast59 = inttoptr i64 %dst2_int58 to ptr
  %rhs_len_p160 = add i64 %27, 1
  %30 = call ptr @memcpy(ptr %cast59, ptr @.str.33, i64 %rhs_len_p160)
  %y61 = load i64, ptr %y50, align 8
  %31 = call ptr @avra_rc_alloc(i64 32)
  %32 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %31, i64 32, ptr @.i2s_fmt.34, i64 %y61)
  %widen62 = sext i32 %32 to i64
  %33 = call i64 @strlen(ptr %28)
  %34 = call i64 @strlen(ptr %31)
  %concat_total63 = add i64 %33, %34
  %concat_size64 = add i64 %concat_total63, 1
  %35 = call ptr @avra_rc_alloc(i64 %concat_size64)
  %36 = call ptr @memcpy(ptr %35, ptr %28, i64 %33)
  %cast65 = ptrtoint ptr %35 to i64
  %dst2_int66 = add i64 %cast65, %33
  %cast67 = inttoptr i64 %dst2_int66 to ptr
  %rhs_len_p168 = add i64 %34, 1
  %37 = call ptr @memcpy(ptr %cast67, ptr %31, i64 %rhs_len_p168)
  %38 = call i32 @puts(ptr %35)
  %widen69 = sext i32 %38 to i64
  %39 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %39, i64 1)
  call void @avra_array_push(ptr %39, i64 2)
  call void @avra_array_push(ptr %39, i64 3)
  call void @avra_array_push(ptr %39, i64 4)
  call void @avra_array_push(ptr %39, i64 5)
  %40 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %40, i64 -559038737)
  call void @avra_array_push(ptr %40, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast70 = ptrtoint ptr %40 to i64
  %41 = call i64 @avra_array_reduce(ptr %39, i64 0, i64 %cast70)
  store i64 %41, ptr @sum, align 8
  %sum = load i64, ptr @sum, align 8
  %42 = call ptr @avra_rc_alloc(i64 32)
  %43 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %42, i64 32, ptr @.i2s_fmt.35, i64 %sum)
  %widen71 = sext i32 %43 to i64
  %44 = call i32 @puts(ptr %42)
  %widen72 = sext i32 %44 to i64
  %45 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %45, i64 10)
  call void @avra_array_push(ptr %45, i64 20)
  call void @avra_array_push(ptr %45, i64 30)
  call void @avra_array_push(ptr %45, i64 40)
  call void @avra_array_push(ptr %45, i64 50)
  %46 = call ptr @avra_array_slice(ptr %45, i64 1, i64 4)
  %47 = call i64 @avra_array_len(ptr %46)
  store i64 %47, ptr %forin_len73, align 8
  store i64 0, ptr %forin_i74, align 8
  br label %forin.cond75

sc_rhs:                                           ; preds = %forin.body
  %t21 = load ptr, ptr %t, align 8
  %cast22 = ptrtoint ptr %t21 to i64
  %null_chk23 = icmp eq i64 %cast22, 0
  %null_ext24 = zext i1 %null_chk23 to i64
  call void @avra_null_deref_trap(ptr @fld_name.16, i64 4, ptr @sty_name.17, i64 4, i64 %null_ext24, ptr @src_file.18, i64 100, i64 31)
  %done_ptr = getelementptr inbounds nuw %Task, ptr %t21, i32 0, i32 2
  %done = load i64, ptr %done_ptr, align 8
  %eq = icmp eq i64 %done, 0
  %eq_ext = zext i1 %eq to i64
  %r_bool = icmp ne i64 %eq_ext, 0
  br i1 %r_bool, label %sc_r_true, label %sc_r_false

sc_short:                                         ; preds = %forin.body
  br label %sc_merge

sc_merge:                                         ; preds = %sc_r_merge, %sc_short
  %sc_phi = phi i1 [ false, %sc_short ], [ %r_bool, %sc_r_merge ]
  %sc_ext = zext i1 %sc_phi to i64
  %if_cond = icmp ne i64 %sc_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

sc_r_true:                                        ; preds = %sc_rhs
  br label %sc_r_merge

sc_r_false:                                       ; preds = %sc_rhs
  br label %sc_r_merge

sc_r_merge:                                       ; preds = %sc_r_false, %sc_r_true
  br label %sc_merge

ifcont:                                           ; preds = %if_else, %if_then
  br label %forin.incr

if_then:                                          ; preds = %sc_merge
  %t25 = load ptr, ptr %t, align 8
  %cast26 = ptrtoint ptr %t25 to i64
  %null_chk27 = icmp eq i64 %cast26, 0
  %null_ext28 = zext i1 %null_chk27 to i64
  call void @avra_null_deref_trap(ptr @fld_name.19, i64 8, ptr @sty_name.20, i64 4, i64 %null_ext28, ptr @src_file.21, i64 100, i64 32)
  %48 = call ptr @Task__describe(ptr %t25)
  %49 = call i32 @puts(ptr %48)
  %widen29 = sext i32 %49 to i64
  br label %ifcont

if_else:                                          ; preds = %sc_merge
  br label %ifcont

forin.cond75:                                     ; preds = %forin.incr77, %forin.exit
  %forin_i_val79 = load i64, ptr %forin_i74, align 8
  %forin_len_val80 = load i64, ptr %forin_len73, align 8
  %forin_cmp81 = icmp slt i64 %forin_i_val79, %forin_len_val80
  br i1 %forin_cmp81, label %forin.body76, label %forin.exit78

forin.body76:                                     ; preds = %forin.cond75
  %50 = call i64 @avra_array_get(ptr %46, i64 %forin_i_val79)
  store i64 %50, ptr %n, align 8
  %n82 = load i64, ptr %n, align 8
  %51 = call ptr @avra_rc_alloc(i64 32)
  %52 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %51, i64 32, ptr @.i2s_fmt.36, i64 %n82)
  %widen83 = sext i32 %52 to i64
  %53 = call i32 @puts(ptr %51)
  %widen84 = sext i32 %53 to i64
  br label %forin.incr77

forin.incr77:                                     ; preds = %forin.body76
  %forin_i_old85 = load i64, ptr %forin_i74, align 8
  %forin_next86 = add i64 %forin_i_old85, 1
  store i64 %forin_next86, ptr %forin_i74, align 8
  br label %forin.cond75

forin.exit78:                                     ; preds = %forin.cond75
  %54 = call i32 @avra_test_summary()
  %widen87 = sext i32 %54 to i64
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Task(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_title_ptr = getelementptr inbounds nuw %Task, ptr %0, i32 0, i32 0
  %rel_title = load ptr, ptr %rel_title_ptr, align 8
  %is_null_title = icmp eq ptr %rel_title, null
  br i1 %is_null_title, label %rel_title_skip, label %rel_title_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_title_skip
  ret i64 0

rel_title_skip:                                   ; preds = %rel_title_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_title_do:                                     ; preds = %do_free
  call void @avra_rc_release(ptr %rel_title)
  br label %rel_title_skip
}

define i64 @__lambda_0(i64 %0, i64 %1) {
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
