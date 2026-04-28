; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%IntList = type { ptr }

@fld_name = private unnamed_addr constant [5 x i8] c"data\00", align 1
@sty_name = private unnamed_addr constant [8 x i8] c"IntList\00", align 1
@src_file = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/assoc_types.av\00", align 1
@fld_name.1 = private unnamed_addr constant [5 x i8] c"data\00", align 1
@sty_name.2 = private unnamed_addr constant [8 x i8] c"IntList\00", align 1
@src_file.3 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/assoc_types.av\00", align 1
@fld_name.4 = private unnamed_addr constant [5 x i8] c"size\00", align 1
@sty_name.5 = private unnamed_addr constant [8 x i8] c"IntList\00", align 1
@src_file.6 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/assoc_types.av\00", align 1
@fld_name.7 = private unnamed_addr constant [4 x i8] c"get\00", align 1
@sty_name.8 = private unnamed_addr constant [8 x i8] c"IntList\00", align 1
@src_file.9 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/assoc_types.av\00", align 1
@.str = private unnamed_addr constant [5 x i8] c"sum=\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.10 = private unnamed_addr constant [11 x i8] c"item=hello\00", align 1

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

define i64 @IntList__get(ptr %0, i64 %1) {
entry:
  %idx = alloca i64, align 8
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  store i64 %1, ptr %idx, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 4, ptr @sty_name, i64 7, i64 %null_ext, ptr @src_file, i64 97, i64 15)
  %data_ptr = getelementptr inbounds nuw %IntList, ptr %self1, i32 0, i32 0
  %data = load ptr, ptr %data_ptr, align 8
  %idx2 = load i64, ptr %idx, align 8
  %2 = call i64 @avra_array_get(ptr %data, i64 %idx2)
  ret i64 %2
}

define i64 @IntList__size(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.1, i64 4, ptr @sty_name.2, i64 7, i64 %null_ext, ptr @src_file.3, i64 97, i64 18)
  %data_ptr = getelementptr inbounds nuw %IntList, ptr %self1, i32 0, i32 0
  %data = load ptr, ptr %data_ptr, align 8
  %1 = call i64 @avra_array_len(ptr %data)
  ret i64 %1
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %i = alloca i64, align 8
  %total = alloca i64, align 8
  %c = alloca ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 8)
  %2 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %2, i64 1)
  call void @avra_array_push(ptr %2, i64 2)
  call void @avra_array_push(ptr %2, i64 3)
  call void @avra_array_push(ptr %2, i64 4)
  call void @avra_array_push(ptr %2, i64 5)
  %fld_ptr = getelementptr inbounds nuw %IntList, ptr %1, i32 0, i32 0
  store ptr %2, ptr %fld_ptr, align 8
  %cast = ptrtoint ptr %1 to i64
  %cast1 = inttoptr i64 %cast to ptr
  store ptr %cast1, ptr %c, align 8
  store i64 0, ptr %total, align 8
  store i64 0, ptr %i, align 8
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %i2 = load i64, ptr %i, align 8
  %c3 = load ptr, ptr %c, align 8
  %cast4 = ptrtoint ptr %c3 to i64
  %null_chk = icmp eq i64 %cast4, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.4, i64 4, ptr @sty_name.5, i64 7, i64 %null_ext, ptr @src_file.6, i64 97, i64 26)
  %3 = call i64 @IntList__size(ptr %c3)
  %slt = icmp slt i64 %i2, %3
  %slt_ext = zext i1 %slt to i64
  %while_cond = icmp ne i64 %slt_ext, 0
  br i1 %while_cond, label %while.body, label %while.exit

while.body:                                       ; preds = %while.cond
  %total5 = load i64, ptr %total, align 8
  %c6 = load ptr, ptr %c, align 8
  %cast7 = ptrtoint ptr %c6 to i64
  %null_chk8 = icmp eq i64 %cast7, 0
  %null_ext9 = zext i1 %null_chk8 to i64
  call void @avra_null_deref_trap(ptr @fld_name.7, i64 3, ptr @sty_name.8, i64 7, i64 %null_ext9, ptr @src_file.9, i64 97, i64 27)
  %i10 = load i64, ptr %i, align 8
  %4 = call i64 @IntList__get(ptr %c6, i64 %i10)
  %add = add i64 %total5, %4
  store i64 %add, ptr %total, align 8
  %i11 = load i64, ptr %i, align 8
  %add12 = add i64 %i11, 1
  store i64 %add12, ptr %i, align 8
  br label %while.cond

while.exit:                                       ; preds = %while.cond
  %total13 = load i64, ptr %total, align 8
  %5 = call ptr @avra_rc_alloc(i64 32)
  %6 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %5, i64 32, ptr @.i2s_fmt, i64 %total13)
  %widen = sext i32 %6 to i64
  %7 = call i64 @strlen(ptr @.str)
  %8 = call i64 @strlen(ptr %5)
  %concat_total = add i64 %7, %8
  %concat_size = add i64 %concat_total, 1
  %9 = call ptr @avra_rc_alloc(i64 %concat_size)
  %10 = call ptr @memcpy(ptr %9, ptr @.str, i64 %7)
  %cast14 = ptrtoint ptr %9 to i64
  %dst2_int = add i64 %cast14, %7
  %cast15 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %8, 1
  %11 = call ptr @memcpy(ptr %cast15, ptr %5, i64 %rhs_len_p1)
  %12 = call i32 @puts(ptr %9)
  %widen16 = sext i32 %12 to i64
  %13 = call i32 @puts(ptr @.str.10)
  %widen17 = sext i32 %13 to i64
  %c_cleanup = load ptr, ptr %c, align 8
  %14 = call i64 @__release_IntList(ptr %c_cleanup)
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_IntList(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_data_ptr = getelementptr inbounds nuw %IntList, ptr %0, i32 0, i32 0
  %rel_data = load ptr, ptr %rel_data_ptr, align 8
  %is_null_data = icmp eq ptr %rel_data, null
  br i1 %is_null_data, label %rel_data_skip, label %rel_data_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_data_skip
  ret i64 0

rel_data_skip:                                    ; preds = %rel_data_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_data_do:                                      ; preds = %do_free
  call void @avra_rc_release(ptr %rel_data)
  br label %rel_data_skip
}
