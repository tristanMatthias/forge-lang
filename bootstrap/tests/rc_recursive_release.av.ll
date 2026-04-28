; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Outer = type { ptr, ptr }
%Inner = type { ptr }

@.str = private unnamed_addr constant [5 x i8] c"test\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@fld_name = private unnamed_addr constant [6 x i8] c"child\00", align 1
@sty_name = private unnamed_addr constant [6 x i8] c"Outer\00", align 1
@src_file = private unnamed_addr constant [107 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/rc_recursive_release.av\00", align 1
@fld_name.2 = private unnamed_addr constant [6 x i8] c"value\00", align 1
@sty_name.3 = private unnamed_addr constant [6 x i8] c"Inner\00", align 1
@src_file.4 = private unnamed_addr constant [107 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/rc_recursive_release.av\00", align 1
@.str.5 = private unnamed_addr constant [5 x i8] c"deep\00", align 1
@.str.6 = private unnamed_addr constant [6 x i8] c"world\00", align 1
@fld_name.7 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.8 = private unnamed_addr constant [6 x i8] c"Outer\00", align 1
@src_file.9 = private unnamed_addr constant [107 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/rc_recursive_release.av\00", align 1

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

define ptr @test_struct_release() {
entry:
  %outer = alloca ptr, align 8
  %0 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %Outer, ptr %0, i32 0, i32 0
  store ptr @.str, ptr %fld_ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 8)
  %fld_ptr1 = getelementptr inbounds nuw %Inner, ptr %1, i32 0, i32 0
  store ptr @.str.1, ptr %fld_ptr1, align 8
  %cast = ptrtoint ptr %1 to i64
  %fld_ptr2 = getelementptr inbounds nuw %Outer, ptr %0, i32 0, i32 1
  %cast3 = inttoptr i64 %cast to ptr
  store ptr %cast3, ptr %fld_ptr2, align 8
  %cast4 = ptrtoint ptr %0 to i64
  %cast5 = inttoptr i64 %cast4 to ptr
  store ptr %cast5, ptr %outer, align 8
  %outer6 = load ptr, ptr %outer, align 8
  %cast7 = ptrtoint ptr %outer6 to i64
  %null_chk = icmp eq i64 %cast7, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 5, ptr @sty_name, i64 5, i64 %null_ext, ptr @src_file, i64 106, i64 16)
  %child_ptr = getelementptr inbounds nuw %Outer, ptr %outer6, i32 0, i32 1
  %child = load ptr, ptr %child_ptr, align 8
  %cast8 = ptrtoint ptr %child to i64
  %null_chk9 = icmp eq i64 %cast8, 0
  %null_ext10 = zext i1 %null_chk9 to i64
  call void @avra_null_deref_trap(ptr @fld_name.2, i64 5, ptr @sty_name.3, i64 5, i64 %null_ext10, ptr @src_file.4, i64 106, i64 16)
  %value_ptr = getelementptr inbounds nuw %Inner, ptr %child, i32 0, i32 0
  %value = load ptr, ptr %value_ptr, align 8
  %outer_cleanup = load ptr, ptr %outer, align 8
  %2 = call i64 @__release_Outer(ptr %outer_cleanup)
  ret ptr %value
}

define ptr @test_nested() {
entry:
  %deep = alloca ptr, align 8
  %0 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %Outer, ptr %0, i32 0, i32 0
  store ptr @.str.5, ptr %fld_ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 8)
  %fld_ptr1 = getelementptr inbounds nuw %Inner, ptr %1, i32 0, i32 0
  store ptr @.str.6, ptr %fld_ptr1, align 8
  %cast = ptrtoint ptr %1 to i64
  %fld_ptr2 = getelementptr inbounds nuw %Outer, ptr %0, i32 0, i32 1
  %cast3 = inttoptr i64 %cast to ptr
  store ptr %cast3, ptr %fld_ptr2, align 8
  %cast4 = ptrtoint ptr %0 to i64
  %cast5 = inttoptr i64 %cast4 to ptr
  store ptr %cast5, ptr %deep, align 8
  %deep6 = load ptr, ptr %deep, align 8
  %cast7 = ptrtoint ptr %deep6 to i64
  %null_chk = icmp eq i64 %cast7, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.7, i64 4, ptr @sty_name.8, i64 5, i64 %null_ext, ptr @src_file.9, i64 106, i64 21)
  %name_ptr = getelementptr inbounds nuw %Outer, ptr %deep6, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %deep_cleanup = load ptr, ptr %deep, align 8
  %2 = call i64 @__release_Outer(ptr %deep_cleanup)
  ret ptr %name
}

define i64 @main() {
entry:
  %0 = call ptr @test_struct_release()
  %1 = call i32 @puts(ptr %0)
  %widen = sext i32 %1 to i64
  %2 = call ptr @test_nested()
  %3 = call i32 @puts(ptr %2)
  %widen1 = sext i32 %3 to i64
  %4 = call i32 @avra_test_summary()
  %widen2 = sext i32 %4 to i64
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Outer(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %Outer, ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_child_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  %rel_child_ptr = getelementptr inbounds nuw %Outer, ptr %0, i32 0, i32 1
  %rel_child = load ptr, ptr %rel_child_ptr, align 8
  %is_null_child = icmp eq ptr %rel_child, null
  br i1 %is_null_child, label %rel_child_skip, label %rel_child_do

rel_name_do:                                      ; preds = %do_free
  call void @avra_rc_release(ptr %rel_name)
  br label %rel_name_skip

rel_child_skip:                                   ; preds = %rel_child_do, %rel_name_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_child_do:                                     ; preds = %rel_name_skip
  %2 = call i64 @__release_Inner(ptr %rel_child)
  br label %rel_child_skip
}

define i64 @__release_Inner(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_value_ptr = getelementptr inbounds nuw %Inner, ptr %0, i32 0, i32 0
  %rel_value = load ptr, ptr %rel_value_ptr, align 8
  %is_null_value = icmp eq ptr %rel_value, null
  br i1 %is_null_value, label %rel_value_skip, label %rel_value_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_value_skip
  ret i64 0

rel_value_skip:                                   ; preds = %rel_value_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_value_do:                                     ; preds = %do_free
  call void @avra_rc_release(ptr %rel_value)
  br label %rel_value_skip
}
