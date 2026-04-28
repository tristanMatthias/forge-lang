; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%PbConfig = type { ptr, i64, i64, i64, i64 }

@.str = private unnamed_addr constant [10 x i8] c"localhost\00", align 1
@.str.1 = private unnamed_addr constant [17 x i8] c"prod.example.com\00", align 1
@spec_str = private unnamed_addr constant [15 x i8] c"\22prod builder\22\00", align 1
@fld_name = private unnamed_addr constant [5 x i8] c"host\00", align 1
@sty_name = private unnamed_addr constant [9 x i8] c"PbConfig\00", align 1
@src_file = private unnamed_addr constant [27 x i8] c"tests/prod_builder_test.fg\00", align 1
@.str.2 = private unnamed_addr constant [17 x i8] c"prod.example.com\00", align 1
@spec_str.3 = private unnamed_addr constant [12 x i8] c"\22prod host\22\00", align 1
@fld_name.4 = private unnamed_addr constant [5 x i8] c"port\00", align 1
@sty_name.5 = private unnamed_addr constant [9 x i8] c"PbConfig\00", align 1
@src_file.6 = private unnamed_addr constant [27 x i8] c"tests/prod_builder_test.fg\00", align 1
@spec_str.7 = private unnamed_addr constant [12 x i8] c"\22prod port\22\00", align 1
@fld_name.8 = private unnamed_addr constant [6 x i8] c"debug\00", align 1
@sty_name.9 = private unnamed_addr constant [9 x i8] c"PbConfig\00", align 1
@src_file.10 = private unnamed_addr constant [27 x i8] c"tests/prod_builder_test.fg\00", align 1
@spec_str.11 = private unnamed_addr constant [17 x i8] c"\22prod debug off\22\00", align 1
@fld_name.12 = private unnamed_addr constant [6 x i8] c"debug\00", align 1
@sty_name.13 = private unnamed_addr constant [9 x i8] c"PbConfig\00", align 1
@src_file.14 = private unnamed_addr constant [27 x i8] c"tests/prod_builder_test.fg\00", align 1
@spec_str.15 = private unnamed_addr constant [15 x i8] c"\22dev debug on\22\00", align 1
@fld_name.16 = private unnamed_addr constant [5 x i8] c"host\00", align 1
@sty_name.17 = private unnamed_addr constant [9 x i8] c"PbConfig\00", align 1
@src_file.18 = private unnamed_addr constant [27 x i8] c"tests/prod_builder_test.fg\00", align 1
@.str.19 = private unnamed_addr constant [10 x i8] c"localhost\00", align 1
@spec_str.20 = private unnamed_addr constant [19 x i8] c"\22dev host default\22\00", align 1

declare i32 @puts(ptr)

declare void @forge_eprintln(ptr)

declare i64 @strlen(ptr)

declare ptr @malloc(i64)

declare ptr @forge_rc_alloc(i64)

declare void @forge_rc_retain(ptr)

declare void @forge_rc_release(ptr)

declare i64 @forge_rc_should_free(ptr)

declare void @forge_rc_free(ptr)

declare void @forge_rc_suspect(ptr)

declare void @forge_rc_collect()

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @strcmp(ptr, ptr)

declare i32 @snprintf(ptr, i64, ptr, ...)

declare i32 @atoi(ptr)

declare void @exit(i32)

declare void @forge_null_arg_check(ptr, i64, ptr, i64, i64)

declare void @forge_null_deref_trap(ptr, i64, ptr, i64, i64, ptr, i64, i64)

declare void @forge_div_by_zero_trap(i64, ptr, i64, i64)

declare ptr @forge_array_new()

declare void @forge_array_push(ptr, i64)

declare i64 @forge_array_get(ptr, i64)

declare i64 @forge_array_len(ptr)

declare void @forge_array_set(ptr, i64, i64)

declare i64 @forge_array_pop(ptr)

declare ptr @forge_array_slice(ptr, i64, i64)

declare i64 @forge_closure_get_fn(i64)

declare i64 @forge_closure_num_captures(i64)

declare i64 @forge_closure_get_capture(ptr, i64)

declare i64 @forge_closure_call_0(i64)

declare i64 @forge_closure_call_1(i64, i64)

declare i64 @forge_closure_call_2(i64, i64, i64)

declare i64 @forge_closure_call_3(i64, i64, i64, i64)

declare i64 @forge_closure_call_4(i64, i64, i64, i64, i64)

declare i64 @forge_closure_call_5(i64, i64, i64, i64, i64, i64)

declare ptr @forge_array_map(ptr, i64)

declare ptr @forge_array_filter(ptr, i64)

declare void @forge_array_foreach(ptr, i64)

declare i64 @forge_array_reduce(ptr, i64, i64)

declare i64 @forge_array_contains(ptr, i64)

declare i64 @forge_array_index_of(ptr, i64)

declare ptr @forge_array_reverse(ptr)

declare i64 @forge_str_contains(ptr, ptr)

declare i64 @forge_str_starts_with(ptr, ptr)

declare i64 @forge_str_ends_with(ptr, ptr)

declare i64 @forge_str_index_of(ptr, ptr)

declare ptr @forge_str_split(ptr, ptr)

declare ptr @forge_str_replace(ptr, ptr, ptr)

declare ptr @forge_str_trim(ptr)

declare ptr @forge_str_to_upper(ptr)

declare ptr @forge_str_to_lower(ptr)

declare ptr @forge_str_join(ptr, ptr)

declare ptr @forge_str_char_at(ptr, i64)

declare ptr @forge_str_substring(ptr, i64, i64)

declare ptr @forge_str_repeat(ptr, i64)

declare ptr @forge_str_reverse(ptr)

declare ptr @forge_map_new_cstr()

declare void @forge_map_set_cstr(ptr, ptr, i64)

declare i64 @forge_map_get_cstr(ptr, ptr)

declare i64 @forge_map_has_cstr(ptr, ptr)

declare i64 @forge_map_len_cstr(ptr)

declare ptr @forge_map_keys_cstr(ptr)

declare ptr @forge_map_values_cstr(ptr)

declare i64 @forge_map_remove_cstr(ptr, ptr)

declare ptr @forge_file_read(ptr)

declare i64 @forge_file_write(ptr, ptr)

declare i64 @forge_file_exists(ptr)

declare ptr @forge_intmap_new()

declare void @forge_intmap_set(ptr, i64, i64)

declare i64 @forge_intmap_get(ptr, i64)

declare i64 @forge_intmap_has(ptr, i64)

declare i64 @forge_float_parse(ptr)

declare i64 @forge_float_to_string(i64)

declare ptr @forge_format_float(i64, ptr)

declare ptr @forge_format_int(i64, ptr)

declare void @forge_ptr_store_byte(ptr, i64, i64)

declare i64 @forge_string_from_ptr(ptr, i64)

declare i64 @forge_trait_object_new(ptr, i64)

declare i64 @forge_trait_object_value(ptr)

declare ptr @forge_trait_object_vtable(ptr)

declare i64 @forge_datetime_now()

declare i64 @forge_datetime_format(ptr, i64)

declare i64 @forge_datetime_year(ptr)

declare i64 @forge_datetime_month(ptr)

declare i64 @forge_datetime_day(ptr)

declare i64 @forge_datetime_hour(ptr)

declare i64 @forge_datetime_minute(ptr)

declare i64 @forge_datetime_second(ptr)

declare ptr @forge_json_stringify_int(ptr)

declare ptr @forge_json_stringify_string(ptr)

declare ptr @forge_json_stringify_bool(ptr)

declare i64 @forge_json_get_int(ptr, i64)

declare i64 @forge_json_get_string(ptr, i64)

declare i64 @forge_json_get_bool(ptr, i64)

declare i64 @forge_semver_major(ptr)

declare i64 @forge_semver_minor(ptr)

declare i64 @forge_semver_patch(ptr)

declare i64 @forge_semver_compare(ptr, i64)

declare i64 @forge_validate_not_null(ptr, i64)

declare i64 @forge_validate_positive(ptr, i64)

declare i64 @forge_validate_not_empty(ptr, i64)

declare i64 @forge_toml_get_string(ptr, i64)

declare i64 @forge_toml_get_int(ptr, i64)

declare i64 @forge_toml_get_bool(ptr, i64)

declare i64 @forge_toml_get_section_string(ptr, i64, i64)

declare i64 @forge_toml_has_section(ptr, i64)

declare i64 @forge_spawn(ptr)

declare i64 @forge_task_await(ptr)

declare i32 @forge_thread_join(ptr)

declare void @forge_yield()

declare void @forge_scheduler_run()

declare ptr @forge_task_group_new()

declare void @forge_task_group_add(ptr, ptr)

declare void @forge_task_group_await_all(ptr)

declare ptr @forge_channel_new()

declare void @forge_channel_send(ptr, i64)

declare i64 @forge_channel_recv(ptr)

declare i32 @forge_channel_close(ptr)

declare i32 @forge_parallel_run(ptr)

declare i64 @forge_select(ptr, i64)

declare i64 @forge_select_index(ptr)

declare i64 @forge_select_value(ptr)

declare i32 @forge_test_start_spec(ptr)

declare i32 @forge_test_end_spec(ptr)

declare i32 @forge_test_start_given(ptr)

declare i32 @forge_test_end_given(ptr)

declare i64 @forge_test_run_then(ptr, i64)

declare i32 @forge_test_skip(ptr)

declare i32 @forge_test_todo(ptr)

declare i32 @forge_test_summary()

declare void @forge_test_flush()

declare ptr @forge_arena_new()

declare ptr @forge_arena_alloc(ptr, i64)

declare void @forge_arena_destroy(ptr)

declare void @forge_match_unreachable(ptr, i64, ptr, i64)

declare i32 @forge_llvm_is_ptr_value(ptr)

declare ptr @forge_llvm_typeof(ptr)

declare ptr @forge_llvm_cast_to_type(ptr, ptr, ptr)

declare i32 @forge_llvm_is_void_value(ptr)

declare void @forge_llvm_build_store_cast(ptr, ptr, ptr)

declare i32 @forge_llvm_verify_function(ptr)

declare i64 @forge_llvm_type_kind(ptr)

declare i64 @forge_llvm_int_type_width(ptr)

declare ptr @forge_llvm_build_call_coerce(ptr, ptr, ptr, ptr, i64, ptr)

declare i64 @forge_test_roughly(double, double, double)

define ptr @pb_default_config() {
entry:
  %0 = call ptr @forge_rc_alloc(i64 40)
  %fld_ptr = getelementptr inbounds nuw %PbConfig, ptr %0, i32 0, i32 0
  store ptr @.str, ptr %fld_ptr, align 8
  %fld_ptr1 = getelementptr inbounds nuw %PbConfig, ptr %0, i32 0, i32 1
  store i64 8080, ptr %fld_ptr1, align 8
  %fld_ptr2 = getelementptr inbounds nuw %PbConfig, ptr %0, i32 0, i32 2
  store i64 4, ptr %fld_ptr2, align 8
  %fld_ptr3 = getelementptr inbounds nuw %PbConfig, ptr %0, i32 0, i32 3
  store i64 0, ptr %fld_ptr3, align 8
  %fld_ptr4 = getelementptr inbounds nuw %PbConfig, ptr %0, i32 0, i32 4
  store i64 30, ptr %fld_ptr4, align 8
  %cast = ptrtoint ptr %0 to i64
  %cast5 = inttoptr i64 %cast to ptr
  ret ptr %cast5
}

define ptr @pb_with_host(ptr %0, ptr %1) {
entry:
  %host = alloca ptr, align 8
  %cfg = alloca ptr, align 8
  store ptr %0, ptr %cfg, align 8
  store ptr %1, ptr %host, align 8
  %cfg1 = load ptr, ptr %cfg, align 8
  %2 = call ptr @forge_rc_alloc(i64 40)
  %with_cp_src = getelementptr inbounds nuw %PbConfig, ptr %cfg1, i32 0, i32 0
  %with_cp_val = load ptr, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %PbConfig, ptr %2, i32 0, i32 0
  store ptr %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src2 = getelementptr inbounds nuw %PbConfig, ptr %cfg1, i32 0, i32 1
  %with_cp_val3 = load i64, ptr %with_cp_src2, align 8
  %with_cp_dst4 = getelementptr inbounds nuw %PbConfig, ptr %2, i32 0, i32 1
  store i64 %with_cp_val3, ptr %with_cp_dst4, align 8
  %with_cp_src5 = getelementptr inbounds nuw %PbConfig, ptr %cfg1, i32 0, i32 2
  %with_cp_val6 = load i64, ptr %with_cp_src5, align 8
  %with_cp_dst7 = getelementptr inbounds nuw %PbConfig, ptr %2, i32 0, i32 2
  store i64 %with_cp_val6, ptr %with_cp_dst7, align 8
  %with_cp_src8 = getelementptr inbounds nuw %PbConfig, ptr %cfg1, i32 0, i32 3
  %with_cp_val9 = load i64, ptr %with_cp_src8, align 8
  %with_cp_dst10 = getelementptr inbounds nuw %PbConfig, ptr %2, i32 0, i32 3
  store i64 %with_cp_val9, ptr %with_cp_dst10, align 8
  %with_cp_src11 = getelementptr inbounds nuw %PbConfig, ptr %cfg1, i32 0, i32 4
  %with_cp_val12 = load i64, ptr %with_cp_src11, align 8
  %with_cp_dst13 = getelementptr inbounds nuw %PbConfig, ptr %2, i32 0, i32 4
  store i64 %with_cp_val12, ptr %with_cp_dst13, align 8
  %host14 = load ptr, ptr %host, align 8
  %with_ovr = getelementptr inbounds nuw %PbConfig, ptr %2, i32 0, i32 0
  store ptr %host14, ptr %with_ovr, align 8
  %cast = ptrtoint ptr %2 to i64
  %cast15 = inttoptr i64 %cast to ptr
  ret ptr %cast15
}

define ptr @pb_with_port(ptr %0, i64 %1) {
entry:
  %port = alloca i64, align 8
  %cfg = alloca ptr, align 8
  store ptr %0, ptr %cfg, align 8
  store i64 %1, ptr %port, align 8
  %cfg1 = load ptr, ptr %cfg, align 8
  %2 = call ptr @forge_rc_alloc(i64 40)
  %with_cp_src = getelementptr inbounds nuw %PbConfig, ptr %cfg1, i32 0, i32 0
  %with_cp_val = load ptr, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %PbConfig, ptr %2, i32 0, i32 0
  store ptr %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src2 = getelementptr inbounds nuw %PbConfig, ptr %cfg1, i32 0, i32 1
  %with_cp_val3 = load i64, ptr %with_cp_src2, align 8
  %with_cp_dst4 = getelementptr inbounds nuw %PbConfig, ptr %2, i32 0, i32 1
  store i64 %with_cp_val3, ptr %with_cp_dst4, align 8
  %with_cp_src5 = getelementptr inbounds nuw %PbConfig, ptr %cfg1, i32 0, i32 2
  %with_cp_val6 = load i64, ptr %with_cp_src5, align 8
  %with_cp_dst7 = getelementptr inbounds nuw %PbConfig, ptr %2, i32 0, i32 2
  store i64 %with_cp_val6, ptr %with_cp_dst7, align 8
  %with_cp_src8 = getelementptr inbounds nuw %PbConfig, ptr %cfg1, i32 0, i32 3
  %with_cp_val9 = load i64, ptr %with_cp_src8, align 8
  %with_cp_dst10 = getelementptr inbounds nuw %PbConfig, ptr %2, i32 0, i32 3
  store i64 %with_cp_val9, ptr %with_cp_dst10, align 8
  %with_cp_src11 = getelementptr inbounds nuw %PbConfig, ptr %cfg1, i32 0, i32 4
  %with_cp_val12 = load i64, ptr %with_cp_src11, align 8
  %with_cp_dst13 = getelementptr inbounds nuw %PbConfig, ptr %2, i32 0, i32 4
  store i64 %with_cp_val12, ptr %with_cp_dst13, align 8
  %port14 = load i64, ptr %port, align 8
  %with_ovr = getelementptr inbounds nuw %PbConfig, ptr %2, i32 0, i32 1
  store i64 %port14, ptr %with_ovr, align 8
  %cast = ptrtoint ptr %2 to i64
  %cast15 = inttoptr i64 %cast to ptr
  ret ptr %cast15
}

define ptr @pb_with_debug(ptr %0) {
entry:
  %cfg = alloca ptr, align 8
  store ptr %0, ptr %cfg, align 8
  %cfg1 = load ptr, ptr %cfg, align 8
  %1 = call ptr @forge_rc_alloc(i64 40)
  %with_cp_src = getelementptr inbounds nuw %PbConfig, ptr %cfg1, i32 0, i32 0
  %with_cp_val = load ptr, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %PbConfig, ptr %1, i32 0, i32 0
  store ptr %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src2 = getelementptr inbounds nuw %PbConfig, ptr %cfg1, i32 0, i32 1
  %with_cp_val3 = load i64, ptr %with_cp_src2, align 8
  %with_cp_dst4 = getelementptr inbounds nuw %PbConfig, ptr %1, i32 0, i32 1
  store i64 %with_cp_val3, ptr %with_cp_dst4, align 8
  %with_cp_src5 = getelementptr inbounds nuw %PbConfig, ptr %cfg1, i32 0, i32 2
  %with_cp_val6 = load i64, ptr %with_cp_src5, align 8
  %with_cp_dst7 = getelementptr inbounds nuw %PbConfig, ptr %1, i32 0, i32 2
  store i64 %with_cp_val6, ptr %with_cp_dst7, align 8
  %with_cp_src8 = getelementptr inbounds nuw %PbConfig, ptr %cfg1, i32 0, i32 3
  %with_cp_val9 = load i64, ptr %with_cp_src8, align 8
  %with_cp_dst10 = getelementptr inbounds nuw %PbConfig, ptr %1, i32 0, i32 3
  store i64 %with_cp_val9, ptr %with_cp_dst10, align 8
  %with_cp_src11 = getelementptr inbounds nuw %PbConfig, ptr %cfg1, i32 0, i32 4
  %with_cp_val12 = load i64, ptr %with_cp_src11, align 8
  %with_cp_dst13 = getelementptr inbounds nuw %PbConfig, ptr %1, i32 0, i32 4
  store i64 %with_cp_val12, ptr %with_cp_dst13, align 8
  %with_ovr = getelementptr inbounds nuw %PbConfig, ptr %1, i32 0, i32 3
  store i64 1, ptr %with_ovr, align 8
  %cast = ptrtoint ptr %1 to i64
  %cast14 = inttoptr i64 %cast to ptr
  ret ptr %cast14
}

define ptr @pb_make_prod() {
entry:
  %0 = call ptr @pb_default_config()
  %1 = call ptr @pb_with_host(ptr %0, ptr @.str.1)
  %2 = call ptr @pb_with_port(ptr %1, i64 443)
  ret ptr %2
}

define ptr @pb_make_dev() {
entry:
  %0 = call ptr @pb_default_config()
  %1 = call ptr @pb_with_debug(ptr %0)
  ret ptr %1
}

define i64 @main() {
entry:
  %0 = call i32 @forge_test_start_spec(ptr @spec_str)
  %widen = sext i32 %0 to i64
  %1 = call ptr @pb_make_prod()
  %cast = ptrtoint ptr %1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name, i64 4, ptr @sty_name, i64 8, i64 %null_ext, ptr @src_file, i64 26, i64 31)
  %host_ptr = getelementptr inbounds nuw %PbConfig, ptr %1, i32 0, i32 0
  %host = load ptr, ptr %host_ptr, align 8
  %2 = call i32 @strcmp(ptr %host, ptr @.str.2)
  %widen1 = sext i32 %2 to i64
  %streq_cmp = icmp eq i64 %widen1, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %3 = call i64 @forge_test_run_then(ptr @spec_str.3, i64 %streq_ext)
  %4 = call ptr @pb_make_prod()
  %cast2 = ptrtoint ptr %4 to i64
  %null_chk3 = icmp eq i64 %cast2, 0
  %null_ext4 = zext i1 %null_chk3 to i64
  call void @forge_null_deref_trap(ptr @fld_name.4, i64 4, ptr @sty_name.5, i64 8, i64 %null_ext4, ptr @src_file.6, i64 26, i64 34)
  %port_ptr = getelementptr inbounds nuw %PbConfig, ptr %4, i32 0, i32 1
  %port = load i64, ptr %port_ptr, align 8
  %eq = icmp eq i64 %port, 443
  %eq_ext = zext i1 %eq to i64
  %5 = call i64 @forge_test_run_then(ptr @spec_str.7, i64 %eq_ext)
  %6 = call ptr @pb_make_prod()
  %cast5 = ptrtoint ptr %6 to i64
  %null_chk6 = icmp eq i64 %cast5, 0
  %null_ext7 = zext i1 %null_chk6 to i64
  call void @forge_null_deref_trap(ptr @fld_name.8, i64 5, ptr @sty_name.9, i64 8, i64 %null_ext7, ptr @src_file.10, i64 26, i64 37)
  %debug_ptr = getelementptr inbounds nuw %PbConfig, ptr %6, i32 0, i32 3
  %debug = load i64, ptr %debug_ptr, align 8
  %eq8 = icmp eq i64 %debug, 0
  %eq_ext9 = zext i1 %eq8 to i64
  %7 = call i64 @forge_test_run_then(ptr @spec_str.11, i64 %eq_ext9)
  %8 = call ptr @pb_make_dev()
  %cast10 = ptrtoint ptr %8 to i64
  %null_chk11 = icmp eq i64 %cast10, 0
  %null_ext12 = zext i1 %null_chk11 to i64
  call void @forge_null_deref_trap(ptr @fld_name.12, i64 5, ptr @sty_name.13, i64 8, i64 %null_ext12, ptr @src_file.14, i64 26, i64 40)
  %debug_ptr13 = getelementptr inbounds nuw %PbConfig, ptr %8, i32 0, i32 3
  %debug14 = load i64, ptr %debug_ptr13, align 8
  %eq15 = icmp eq i64 %debug14, 1
  %eq_ext16 = zext i1 %eq15 to i64
  %9 = call i64 @forge_test_run_then(ptr @spec_str.15, i64 %eq_ext16)
  %10 = call ptr @pb_make_dev()
  %cast17 = ptrtoint ptr %10 to i64
  %null_chk18 = icmp eq i64 %cast17, 0
  %null_ext19 = zext i1 %null_chk18 to i64
  call void @forge_null_deref_trap(ptr @fld_name.16, i64 4, ptr @sty_name.17, i64 8, i64 %null_ext19, ptr @src_file.18, i64 26, i64 43)
  %host_ptr20 = getelementptr inbounds nuw %PbConfig, ptr %10, i32 0, i32 0
  %host21 = load ptr, ptr %host_ptr20, align 8
  %11 = call i32 @strcmp(ptr %host21, ptr @.str.19)
  %widen22 = sext i32 %11 to i64
  %streq_cmp23 = icmp eq i64 %widen22, 0
  %streq_ext24 = zext i1 %streq_cmp23 to i64
  %12 = call i64 @forge_test_run_then(ptr @spec_str.20, i64 %streq_ext24)
  %13 = call i32 @forge_test_end_spec(ptr @spec_str)
  %widen25 = sext i32 %13 to i64
  %14 = call i32 @forge_test_summary()
  %widen26 = sext i32 %14 to i64
  call void @forge_rc_collect()
  ret i64 0
}

define i64 @__release_PbConfig(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_host_ptr = getelementptr inbounds nuw %PbConfig, ptr %0, i32 0, i32 0
  %rel_host = load ptr, ptr %rel_host_ptr, align 8
  %is_null_host = icmp eq ptr %rel_host, null
  br i1 %is_null_host, label %rel_host_skip, label %rel_host_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_host_skip
  ret i64 0

rel_host_skip:                                    ; preds = %rel_host_do, %do_free
  call void @forge_rc_free(ptr %0)
  br label %done

rel_host_do:                                      ; preds = %do_free
  call void @forge_rc_release(ptr %rel_host)
  br label %rel_host_skip
}
