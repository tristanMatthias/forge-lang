; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%App = type { ptr, ptr }
%Cmd = type { ptr, ptr }

@.str = private unnamed_addr constant [6 x i8] c"0.0.0\00", align 1
@.str.1 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.2 = private unnamed_addr constant [7 x i8] c"my_app\00", align 1
@.str.3 = private unnamed_addr constant [4 x i8] c"1.0\00", align 1
@fld_name = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name = private unnamed_addr constant [4 x i8] c"App\00", align 1
@src_file = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/component_nested/main.av\00", align 1
@fld_name.4 = private unnamed_addr constant [8 x i8] c"version\00", align 1
@sty_name.5 = private unnamed_addr constant [4 x i8] c"App\00", align 1
@src_file.6 = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/component_nested/main.av\00", align 1
@.str.7 = private unnamed_addr constant [10 x i8] c"build_cmd\00", align 1
@.str.8 = private unnamed_addr constant [18 x i8] c"Build the project\00", align 1
@fld_name.9 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.10 = private unnamed_addr constant [4 x i8] c"Cmd\00", align 1
@src_file.11 = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/component_nested/main.av\00", align 1
@.str.12 = private unnamed_addr constant [9 x i8] c"test_cmd\00", align 1
@.str.13 = private unnamed_addr constant [10 x i8] c"Run tests\00", align 1
@fld_name.14 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.15 = private unnamed_addr constant [4 x i8] c"Cmd\00", align 1
@src_file.16 = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/component_nested/main.av\00", align 1

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

define ptr @app_new(ptr %0) {
entry:
  %name = alloca ptr, align 8
  store ptr %0, ptr %name, align 8
  %1 = call ptr @avra_rc_alloc(i64 16)
  %name1 = load ptr, ptr %name, align 8
  %fld_ptr = getelementptr inbounds nuw %App, ptr %1, i32 0, i32 0
  store ptr %name1, ptr %fld_ptr, align 8
  %fld_ptr2 = getelementptr inbounds nuw %App, ptr %1, i32 0, i32 1
  store ptr @.str, ptr %fld_ptr2, align 8
  %cast = ptrtoint ptr %1 to i64
  %cast3 = inttoptr i64 %cast to ptr
  ret ptr %cast3
}

define ptr @cmd_new(ptr %0) {
entry:
  %name = alloca ptr, align 8
  store ptr %0, ptr %name, align 8
  %1 = call ptr @avra_rc_alloc(i64 16)
  %name1 = load ptr, ptr %name, align 8
  %fld_ptr = getelementptr inbounds nuw %Cmd, ptr %1, i32 0, i32 0
  store ptr %name1, ptr %fld_ptr, align 8
  %fld_ptr2 = getelementptr inbounds nuw %Cmd, ptr %1, i32 0, i32 1
  store ptr @.str.1, ptr %fld_ptr2, align 8
  %cast = ptrtoint ptr %1 to i64
  %cast3 = inttoptr i64 %cast to ptr
  ret ptr %cast3
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %test_cmd = alloca ptr, align 8
  %build_cmd = alloca ptr, align 8
  %my_app = alloca ptr, align 8
  %1 = call ptr @app_new(ptr @.str.2)
  %2 = call ptr @avra_rc_alloc(i64 16)
  %with_cp_src = getelementptr inbounds nuw %App, ptr %1, i32 0, i32 0
  %with_cp_val = load ptr, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %App, ptr %2, i32 0, i32 0
  store ptr %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src1 = getelementptr inbounds nuw %App, ptr %1, i32 0, i32 1
  %with_cp_val2 = load ptr, ptr %with_cp_src1, align 8
  %with_cp_dst3 = getelementptr inbounds nuw %App, ptr %2, i32 0, i32 1
  store ptr %with_cp_val2, ptr %with_cp_dst3, align 8
  %with_ovr = getelementptr inbounds nuw %App, ptr %2, i32 0, i32 1
  store ptr @.str.3, ptr %with_ovr, align 8
  %cast = ptrtoint ptr %2 to i64
  %cast4 = inttoptr i64 %cast to ptr
  store ptr %cast4, ptr %my_app, align 8
  %my_app5 = load ptr, ptr %my_app, align 8
  %cast6 = ptrtoint ptr %my_app5 to i64
  %null_chk = icmp eq i64 %cast6, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 4, ptr @sty_name, i64 3, i64 %null_ext, ptr @src_file, i64 107, i64 22)
  %name_ptr = getelementptr inbounds nuw %App, ptr %my_app5, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %3 = call i32 @puts(ptr %name)
  %widen = sext i32 %3 to i64
  %my_app7 = load ptr, ptr %my_app, align 8
  %cast8 = ptrtoint ptr %my_app7 to i64
  %null_chk9 = icmp eq i64 %cast8, 0
  %null_ext10 = zext i1 %null_chk9 to i64
  call void @avra_null_deref_trap(ptr @fld_name.4, i64 7, ptr @sty_name.5, i64 3, i64 %null_ext10, ptr @src_file.6, i64 107, i64 23)
  %version_ptr = getelementptr inbounds nuw %App, ptr %my_app7, i32 0, i32 1
  %version = load ptr, ptr %version_ptr, align 8
  %4 = call i32 @puts(ptr %version)
  %widen11 = sext i32 %4 to i64
  %5 = call ptr @cmd_new(ptr @.str.7)
  %6 = call ptr @avra_rc_alloc(i64 16)
  %with_cp_src12 = getelementptr inbounds nuw %Cmd, ptr %5, i32 0, i32 0
  %with_cp_val13 = load ptr, ptr %with_cp_src12, align 8
  %with_cp_dst14 = getelementptr inbounds nuw %Cmd, ptr %6, i32 0, i32 0
  store ptr %with_cp_val13, ptr %with_cp_dst14, align 8
  %with_cp_src15 = getelementptr inbounds nuw %Cmd, ptr %5, i32 0, i32 1
  %with_cp_val16 = load ptr, ptr %with_cp_src15, align 8
  %with_cp_dst17 = getelementptr inbounds nuw %Cmd, ptr %6, i32 0, i32 1
  store ptr %with_cp_val16, ptr %with_cp_dst17, align 8
  %with_ovr18 = getelementptr inbounds nuw %Cmd, ptr %6, i32 0, i32 1
  store ptr @.str.8, ptr %with_ovr18, align 8
  %cast19 = ptrtoint ptr %6 to i64
  %cast20 = inttoptr i64 %cast19 to ptr
  store ptr %cast20, ptr %build_cmd, align 8
  %build_cmd21 = load ptr, ptr %build_cmd, align 8
  %cast22 = ptrtoint ptr %build_cmd21 to i64
  %null_chk23 = icmp eq i64 %cast22, 0
  %null_ext24 = zext i1 %null_chk23 to i64
  call void @avra_null_deref_trap(ptr @fld_name.9, i64 4, ptr @sty_name.10, i64 3, i64 %null_ext24, ptr @src_file.11, i64 107, i64 29)
  %name_ptr25 = getelementptr inbounds nuw %Cmd, ptr %build_cmd21, i32 0, i32 0
  %name26 = load ptr, ptr %name_ptr25, align 8
  %7 = call i32 @puts(ptr %name26)
  %widen27 = sext i32 %7 to i64
  %8 = call ptr @cmd_new(ptr @.str.12)
  %9 = call ptr @avra_rc_alloc(i64 16)
  %with_cp_src28 = getelementptr inbounds nuw %Cmd, ptr %8, i32 0, i32 0
  %with_cp_val29 = load ptr, ptr %with_cp_src28, align 8
  %with_cp_dst30 = getelementptr inbounds nuw %Cmd, ptr %9, i32 0, i32 0
  store ptr %with_cp_val29, ptr %with_cp_dst30, align 8
  %with_cp_src31 = getelementptr inbounds nuw %Cmd, ptr %8, i32 0, i32 1
  %with_cp_val32 = load ptr, ptr %with_cp_src31, align 8
  %with_cp_dst33 = getelementptr inbounds nuw %Cmd, ptr %9, i32 0, i32 1
  store ptr %with_cp_val32, ptr %with_cp_dst33, align 8
  %with_ovr34 = getelementptr inbounds nuw %Cmd, ptr %9, i32 0, i32 1
  store ptr @.str.13, ptr %with_ovr34, align 8
  %cast35 = ptrtoint ptr %9 to i64
  %cast36 = inttoptr i64 %cast35 to ptr
  store ptr %cast36, ptr %test_cmd, align 8
  %test_cmd37 = load ptr, ptr %test_cmd, align 8
  %cast38 = ptrtoint ptr %test_cmd37 to i64
  %null_chk39 = icmp eq i64 %cast38, 0
  %null_ext40 = zext i1 %null_chk39 to i64
  call void @avra_null_deref_trap(ptr @fld_name.14, i64 4, ptr @sty_name.15, i64 3, i64 %null_ext40, ptr @src_file.16, i64 107, i64 34)
  %name_ptr41 = getelementptr inbounds nuw %Cmd, ptr %test_cmd37, i32 0, i32 0
  %name42 = load ptr, ptr %name_ptr41, align 8
  %10 = call i32 @puts(ptr %name42)
  %widen43 = sext i32 %10 to i64
  %test_cmd_cleanup = load ptr, ptr %test_cmd, align 8
  %11 = call i64 @__release_Cmd(ptr %test_cmd_cleanup)
  %build_cmd_cleanup = load ptr, ptr %build_cmd, align 8
  %12 = call i64 @__release_Cmd(ptr %build_cmd_cleanup)
  %my_app_cleanup = load ptr, ptr %my_app, align 8
  %13 = call i64 @__release_App(ptr %my_app_cleanup)
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Cmd(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %Cmd, ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_description_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  %rel_description_ptr = getelementptr inbounds nuw %Cmd, ptr %0, i32 0, i32 1
  %rel_description = load ptr, ptr %rel_description_ptr, align 8
  %is_null_description = icmp eq ptr %rel_description, null
  br i1 %is_null_description, label %rel_description_skip, label %rel_description_do

rel_name_do:                                      ; preds = %do_free
  call void @avra_rc_release(ptr %rel_name)
  br label %rel_name_skip

rel_description_skip:                             ; preds = %rel_description_do, %rel_name_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_description_do:                               ; preds = %rel_name_skip
  call void @avra_rc_release(ptr %rel_description)
  br label %rel_description_skip
}

define i64 @__release_App(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %App, ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_version_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  %rel_version_ptr = getelementptr inbounds nuw %App, ptr %0, i32 0, i32 1
  %rel_version = load ptr, ptr %rel_version_ptr, align 8
  %is_null_version = icmp eq ptr %rel_version, null
  br i1 %is_null_version, label %rel_version_skip, label %rel_version_do

rel_name_do:                                      ; preds = %do_free
  call void @avra_rc_release(ptr %rel_name)
  br label %rel_name_skip

rel_version_skip:                                 ; preds = %rel_version_do, %rel_name_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_version_do:                                   ; preds = %rel_name_skip
  call void @avra_rc_release(ptr %rel_version)
  br label %rel_version_skip
}
