; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Config = type { ptr, i64 }
%App = type { ptr, ptr }

@app = global i64 0
@fallback = global i64 0
@keep = global i64 0
@port = global i64 0
@name = global i64 0
@.str = private unnamed_addr constant [10 x i8] c"localhost\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"myapp\00", align 1
@.str.2 = private unnamed_addr constant [8 x i8] c"default\00", align 1
@.str.3 = private unnamed_addr constant [9 x i8] c"original\00", align 1
@.str.4 = private unnamed_addr constant [9 x i8] c"fallback\00", align 1
@fld_name = private unnamed_addr constant [7 x i8] c"config\00", align 1
@sty_name = private unnamed_addr constant [4 x i8] c"App\00", align 1
@src_file = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_nested_optional.av\00", align 1
@fld_name.5 = private unnamed_addr constant [5 x i8] c"port\00", align 1
@sty_name.6 = private unnamed_addr constant [7 x i8] c"Config\00", align 1
@src_file.7 = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_nested_optional.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.8 = private unnamed_addr constant [10 x i8] c"anonymous\00", align 1
@.str.9 = private unnamed_addr constant [7 x i8] c"user: \00", align 1

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
  %nc_result20 = alloca i64, align 8
  %ife_result = alloca i64, align 8
  %nc_result8 = alloca i64, align 8
  %nc_result = alloca i64, align 8
  %0 = call ptr @avra_rc_alloc(i64 16)
  %1 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %Config, ptr %1, i32 0, i32 0
  store ptr @.str, ptr %fld_ptr, align 8
  %fld_ptr1 = getelementptr inbounds nuw %Config, ptr %1, i32 0, i32 1
  store i64 8080, ptr %fld_ptr1, align 8
  %cast = ptrtoint ptr %1 to i64
  %fld_ptr2 = getelementptr inbounds nuw %App, ptr %0, i32 0, i32 0
  %cast3 = inttoptr i64 %cast to ptr
  store ptr %cast3, ptr %fld_ptr2, align 8
  %fld_ptr4 = getelementptr inbounds nuw %App, ptr %0, i32 0, i32 1
  store ptr @.str.1, ptr %fld_ptr4, align 8
  %cast5 = ptrtoint ptr %0 to i64
  store i64 %cast5, ptr @app, align 8
  store i64 0, ptr %nc_result, align 8
  br i1 true, label %nc_rhs, label %nc_end

nc_rhs:                                           ; preds = %entry
  store i64 ptrtoint (ptr @.str.2 to i64), ptr %nc_result, align 8
  br label %nc_end

nc_end:                                           ; preds = %nc_rhs, %entry
  %nc_val = load i64, ptr %nc_result, align 8
  store i64 %nc_val, ptr @fallback, align 8
  %fallback = load ptr, ptr @fallback, align 8
  %2 = call i32 @puts(ptr %fallback)
  %widen = sext i32 %2 to i64
  store i64 ptrtoint (ptr @.str.3 to i64), ptr %nc_result8, align 8
  br i1 false, label %nc_rhs6, label %nc_end7

nc_rhs6:                                          ; preds = %nc_end
  store i64 ptrtoint (ptr @.str.4 to i64), ptr %nc_result8, align 8
  br label %nc_end7

nc_end7:                                          ; preds = %nc_rhs6, %nc_end
  %nc_val9 = load i64, ptr %nc_result8, align 8
  store i64 %nc_val9, ptr @keep, align 8
  %keep = load ptr, ptr @keep, align 8
  %3 = call i32 @puts(ptr %keep)
  %widen10 = sext i32 %3 to i64
  br i1 true, label %ife_then, label %ife_else

ife_end:                                          ; preds = %ife_else, %ife_then
  %ife_val = load i64, ptr %ife_result, align 8
  store i64 %ife_val, ptr @port, align 8
  %port15 = load i64, ptr @port, align 8
  %4 = call ptr @avra_rc_alloc(i64 32)
  %5 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %4, i64 32, ptr @.i2s_fmt, i64 %port15)
  %widen16 = sext i32 %5 to i64
  %6 = call i32 @puts(ptr %4)
  %widen17 = sext i32 %6 to i64
  store i64 0, ptr %nc_result20, align 8
  br i1 true, label %nc_rhs18, label %nc_end19

ife_then:                                         ; preds = %nc_end7
  %app = load ptr, ptr @app, align 8
  %cast11 = ptrtoint ptr %app to i64
  %null_chk = icmp eq i64 %cast11, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 6, ptr @sty_name, i64 3, i64 %null_ext, ptr @src_file, i64 107, i64 16)
  %config_ptr = getelementptr inbounds nuw %App, ptr %app, i32 0, i32 0
  %config = load ptr, ptr %config_ptr, align 8
  %cast12 = ptrtoint ptr %config to i64
  %null_chk13 = icmp eq i64 %cast12, 0
  %null_ext14 = zext i1 %null_chk13 to i64
  call void @avra_null_deref_trap(ptr @fld_name.5, i64 4, ptr @sty_name.6, i64 6, i64 %null_ext14, ptr @src_file.7, i64 107, i64 16)
  %port_ptr = getelementptr inbounds nuw %Config, ptr %config, i32 0, i32 1
  %port = load i64, ptr %port_ptr, align 8
  store i64 %port, ptr %ife_result, align 8
  br label %ife_end

ife_else:                                         ; preds = %nc_end7
  store i64 0, ptr %ife_result, align 8
  br label %ife_end

nc_rhs18:                                         ; preds = %ife_end
  store i64 ptrtoint (ptr @.str.8 to i64), ptr %nc_result20, align 8
  br label %nc_end19

nc_end19:                                         ; preds = %nc_rhs18, %ife_end
  %nc_val21 = load i64, ptr %nc_result20, align 8
  store i64 %nc_val21, ptr @name, align 8
  %name = load ptr, ptr @name, align 8
  %7 = call i64 @strlen(ptr @.str.9)
  %8 = call i64 @strlen(ptr %name)
  %concat_total = add i64 %7, %8
  %concat_size = add i64 %concat_total, 1
  %9 = call ptr @avra_rc_alloc(i64 %concat_size)
  %10 = call ptr @memcpy(ptr %9, ptr @.str.9, i64 %7)
  %cast22 = ptrtoint ptr %9 to i64
  %dst2_int = add i64 %cast22, %7
  %cast23 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %8, 1
  %11 = call ptr @memcpy(ptr %cast23, ptr %name, i64 %rhs_len_p1)
  %12 = call i32 @puts(ptr %9)
  %widen24 = sext i32 %12 to i64
  %13 = call i32 @avra_test_summary()
  %widen25 = sext i32 %13 to i64
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_App(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_config_ptr = getelementptr inbounds nuw %App, ptr %0, i32 0, i32 0
  %rel_config = load ptr, ptr %rel_config_ptr, align 8
  %is_null_config = icmp eq ptr %rel_config, null
  br i1 %is_null_config, label %rel_config_skip, label %rel_config_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_name_skip
  ret i64 0

rel_config_skip:                                  ; preds = %rel_config_do, %do_free
  %rel_name_ptr = getelementptr inbounds nuw %App, ptr %0, i32 0, i32 1
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

rel_config_do:                                    ; preds = %do_free
  %2 = call i64 @__release_Config(ptr %rel_config)
  br label %rel_config_skip

rel_name_skip:                                    ; preds = %rel_name_do, %rel_config_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_name_do:                                      ; preds = %rel_config_skip
  call void @avra_rc_release(ptr %rel_name)
  br label %rel_name_skip
}

define i64 @__release_Config(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_host_ptr = getelementptr inbounds nuw %Config, ptr %0, i32 0, i32 0
  %rel_host = load ptr, ptr %rel_host_ptr, align 8
  %is_null_host = icmp eq ptr %rel_host, null
  br i1 %is_null_host, label %rel_host_skip, label %rel_host_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_host_skip
  ret i64 0

rel_host_skip:                                    ; preds = %rel_host_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_host_do:                                      ; preds = %do_free
  call void @avra_rc_release(ptr %rel_host)
  br label %rel_host_skip
}
