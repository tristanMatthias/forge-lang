; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%OcApp = type { ptr }
%OcConfig = type { ptr, i64 }

@fld_name = private unnamed_addr constant [7 x i8] c"config\00", align 1
@sty_name = private unnamed_addr constant [6 x i8] c"OcApp\00", align 1
@src_file = private unnamed_addr constant [29 x i8] c"tests/optional_chain_test.fg\00", align 1
@fld_name.1 = private unnamed_addr constant [5 x i8] c"host\00", align 1
@sty_name.2 = private unnamed_addr constant [9 x i8] c"OcConfig\00", align 1
@src_file.3 = private unnamed_addr constant [29 x i8] c"tests/optional_chain_test.fg\00", align 1
@.str = private unnamed_addr constant [14 x i8] c"null fallback\00", align 1
@spec_str = private unnamed_addr constant [17 x i8] c"\22optional chain\22\00", align 1
@.str.4 = private unnamed_addr constant [10 x i8] c"localhost\00", align 1
@.str.5 = private unnamed_addr constant [10 x i8] c"localhost\00", align 1
@spec_str.6 = private unnamed_addr constant [24 x i8] c"\22non-null returns host\22\00", align 1
@.str.7 = private unnamed_addr constant [14 x i8] c"null fallback\00", align 1
@spec_str.8 = private unnamed_addr constant [24 x i8] c"\22null returns fallback\22\00", align 1

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

define ptr @oc_get_host(ptr %0) {
entry:
  %app = alloca ptr, align 8
  store ptr %0, ptr %app, align 8
  %app1 = load ptr, ptr %app, align 8
  %ne = icmp ne ptr %app1, null
  %ne_ext = zext i1 %ne to i64
  %if_cond = icmp ne i64 %ne_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  ret ptr @.str

if_then:                                          ; preds = %entry
  %app2 = load ptr, ptr %app, align 8
  %cast = ptrtoint ptr %app2 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name, i64 6, ptr @sty_name, i64 5, i64 %null_ext, ptr @src_file, i64 28, i64 8)
  %config_ptr = getelementptr inbounds nuw %OcApp, ptr %app2, i32 0, i32 0
  %config = load ptr, ptr %config_ptr, align 8
  %cast3 = ptrtoint ptr %config to i64
  %null_chk4 = icmp eq i64 %cast3, 0
  %null_ext5 = zext i1 %null_chk4 to i64
  call void @forge_null_deref_trap(ptr @fld_name.1, i64 4, ptr @sty_name.2, i64 8, i64 %null_ext5, ptr @src_file.3, i64 28, i64 8)
  %host_ptr = getelementptr inbounds nuw %OcConfig, ptr %config, i32 0, i32 0
  %host = load ptr, ptr %host_ptr, align 8
  ret ptr %host

if_else:                                          ; preds = %entry
  br label %ifcont
}

define i64 @main() {
entry:
  %a = alloca ptr, align 8
  %0 = call i32 @forge_test_start_spec(ptr @spec_str)
  %widen = sext i32 %0 to i64
  %1 = call ptr @forge_rc_alloc(i64 8)
  %2 = call ptr @forge_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %OcConfig, ptr %2, i32 0, i32 0
  store ptr @.str.4, ptr %fld_ptr, align 8
  %fld_ptr1 = getelementptr inbounds nuw %OcConfig, ptr %2, i32 0, i32 1
  store i64 8080, ptr %fld_ptr1, align 8
  %cast = ptrtoint ptr %2 to i64
  %fld_ptr2 = getelementptr inbounds nuw %OcApp, ptr %1, i32 0, i32 0
  %cast3 = inttoptr i64 %cast to ptr
  store ptr %cast3, ptr %fld_ptr2, align 8
  %cast4 = ptrtoint ptr %1 to i64
  %cast5 = inttoptr i64 %cast4 to ptr
  store ptr %cast5, ptr %a, align 8
  %a6 = load ptr, ptr %a, align 8
  %3 = call ptr @oc_get_host(ptr %a6)
  %4 = call i32 @strcmp(ptr %3, ptr @.str.5)
  %widen7 = sext i32 %4 to i64
  %streq_cmp = icmp eq i64 %widen7, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %5 = call i64 @forge_test_run_then(ptr @spec_str.6, i64 %streq_ext)
  %6 = call ptr @oc_get_host(ptr null)
  %7 = call i32 @strcmp(ptr %6, ptr @.str.7)
  %widen8 = sext i32 %7 to i64
  %streq_cmp9 = icmp eq i64 %widen8, 0
  %streq_ext10 = zext i1 %streq_cmp9 to i64
  %8 = call i64 @forge_test_run_then(ptr @spec_str.8, i64 %streq_ext10)
  %9 = call i32 @forge_test_end_spec(ptr @spec_str)
  %widen11 = sext i32 %9 to i64
  %10 = call i32 @forge_test_summary()
  %widen12 = sext i32 %10 to i64
  call void @forge_rc_collect()
  ret i64 0
}

define i64 @__release_OcApp(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_config_ptr = getelementptr inbounds nuw %OcApp, ptr %0, i32 0, i32 0
  %rel_config = load ptr, ptr %rel_config_ptr, align 8
  %is_null_config = icmp eq ptr %rel_config, null
  br i1 %is_null_config, label %rel_config_skip, label %rel_config_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_config_skip
  ret i64 0

rel_config_skip:                                  ; preds = %rel_config_do, %do_free
  call void @forge_rc_free(ptr %0)
  br label %done

rel_config_do:                                    ; preds = %do_free
  %2 = call i64 @__release_OcConfig(ptr %rel_config)
  br label %rel_config_skip
}

define i64 @__release_OcConfig(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_host_ptr = getelementptr inbounds nuw %OcConfig, ptr %0, i32 0, i32 0
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
