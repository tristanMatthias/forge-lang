; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Inner = type { i64 }
%Outer = type { ptr, ptr }

@o = global i64 0
@new_inner = global i64 0
@.str = private unnamed_addr constant [5 x i8] c"test\00", align 1
@fld_name = private unnamed_addr constant [6 x i8] c"inner\00", align 1
@sty_name = private unnamed_addr constant [6 x i8] c"Outer\00", align 1
@src_file = private unnamed_addr constant [104 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/break_with_nested.av\00", align 1
@fld_name.1 = private unnamed_addr constant [6 x i8] c"value\00", align 1
@sty_name.2 = private unnamed_addr constant [6 x i8] c"Inner\00", align 1
@src_file.3 = private unnamed_addr constant [104 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/break_with_nested.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name.4 = private unnamed_addr constant [6 x i8] c"inner\00", align 1
@sty_name.5 = private unnamed_addr constant [6 x i8] c"Outer\00", align 1
@src_file.6 = private unnamed_addr constant [104 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/break_with_nested.av\00", align 1
@fld_name.7 = private unnamed_addr constant [6 x i8] c"value\00", align 1
@sty_name.8 = private unnamed_addr constant [6 x i8] c"Inner\00", align 1
@src_file.9 = private unnamed_addr constant [104 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/break_with_nested.av\00", align 1
@.i2s_fmt.10 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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
  %0 = call ptr @avra_rc_alloc(i64 16)
  %1 = call ptr @avra_rc_alloc(i64 8)
  %fld_ptr = getelementptr inbounds nuw %Inner, ptr %1, i32 0, i32 0
  store i64 10, ptr %fld_ptr, align 8
  %cast = ptrtoint ptr %1 to i64
  %fld_ptr1 = getelementptr inbounds nuw %Outer, ptr %0, i32 0, i32 0
  %cast2 = inttoptr i64 %cast to ptr
  store ptr %cast2, ptr %fld_ptr1, align 8
  %fld_ptr3 = getelementptr inbounds nuw %Outer, ptr %0, i32 0, i32 1
  store ptr @.str, ptr %fld_ptr3, align 8
  %cast4 = ptrtoint ptr %0 to i64
  store i64 %cast4, ptr @o, align 8
  %o = load ptr, ptr @o, align 8
  %cast5 = ptrtoint ptr %o to i64
  %null_chk = icmp eq i64 %cast5, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 5, ptr @sty_name, i64 5, i64 %null_ext, ptr @src_file, i64 103, i64 6)
  %inner_ptr = getelementptr inbounds nuw %Outer, ptr %o, i32 0, i32 0
  %inner = load ptr, ptr %inner_ptr, align 8
  %2 = call ptr @avra_rc_alloc(i64 8)
  %with_cp_src = getelementptr inbounds nuw %Inner, ptr %inner, i32 0, i32 0
  %with_cp_val = load i64, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %Inner, ptr %2, i32 0, i32 0
  store i64 %with_cp_val, ptr %with_cp_dst, align 8
  %with_ovr = getelementptr inbounds nuw %Inner, ptr %2, i32 0, i32 0
  store i64 99, ptr %with_ovr, align 8
  %cast6 = ptrtoint ptr %2 to i64
  store i64 %cast6, ptr @new_inner, align 8
  %new_inner = load ptr, ptr @new_inner, align 8
  %cast7 = ptrtoint ptr %new_inner to i64
  %null_chk8 = icmp eq i64 %cast7, 0
  %null_ext9 = zext i1 %null_chk8 to i64
  call void @avra_null_deref_trap(ptr @fld_name.1, i64 5, ptr @sty_name.2, i64 5, i64 %null_ext9, ptr @src_file.3, i64 103, i64 7)
  %value_ptr = getelementptr inbounds nuw %Inner, ptr %new_inner, i32 0, i32 0
  %value = load i64, ptr %value_ptr, align 8
  %3 = call ptr @avra_rc_alloc(i64 32)
  %4 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %3, i64 32, ptr @.i2s_fmt, i64 %value)
  %widen = sext i32 %4 to i64
  %5 = call i32 @puts(ptr %3)
  %widen10 = sext i32 %5 to i64
  %o11 = load ptr, ptr @o, align 8
  %cast12 = ptrtoint ptr %o11 to i64
  %null_chk13 = icmp eq i64 %cast12, 0
  %null_ext14 = zext i1 %null_chk13 to i64
  call void @avra_null_deref_trap(ptr @fld_name.4, i64 5, ptr @sty_name.5, i64 5, i64 %null_ext14, ptr @src_file.6, i64 103, i64 9)
  %inner_ptr15 = getelementptr inbounds nuw %Outer, ptr %o11, i32 0, i32 0
  %inner16 = load ptr, ptr %inner_ptr15, align 8
  %cast17 = ptrtoint ptr %inner16 to i64
  %null_chk18 = icmp eq i64 %cast17, 0
  %null_ext19 = zext i1 %null_chk18 to i64
  call void @avra_null_deref_trap(ptr @fld_name.7, i64 5, ptr @sty_name.8, i64 5, i64 %null_ext19, ptr @src_file.9, i64 103, i64 9)
  %value_ptr20 = getelementptr inbounds nuw %Inner, ptr %inner16, i32 0, i32 0
  %value21 = load i64, ptr %value_ptr20, align 8
  %6 = call ptr @avra_rc_alloc(i64 32)
  %7 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %6, i64 32, ptr @.i2s_fmt.10, i64 %value21)
  %widen22 = sext i32 %7 to i64
  %8 = call i32 @puts(ptr %6)
  %widen23 = sext i32 %8 to i64
  %9 = call i32 @avra_test_summary()
  %widen24 = sext i32 %9 to i64
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Outer(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_inner_ptr = getelementptr inbounds nuw %Outer, ptr %0, i32 0, i32 0
  %rel_inner = load ptr, ptr %rel_inner_ptr, align 8
  %is_null_inner = icmp eq ptr %rel_inner, null
  br i1 %is_null_inner, label %rel_inner_skip, label %rel_inner_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_label_skip
  ret i64 0

rel_inner_skip:                                   ; preds = %rel_inner_do, %do_free
  %rel_label_ptr = getelementptr inbounds nuw %Outer, ptr %0, i32 0, i32 1
  %rel_label = load ptr, ptr %rel_label_ptr, align 8
  %is_null_label = icmp eq ptr %rel_label, null
  br i1 %is_null_label, label %rel_label_skip, label %rel_label_do

rel_inner_do:                                     ; preds = %do_free
  call void @avra_rc_release(ptr %rel_inner)
  br label %rel_inner_skip

rel_label_skip:                                   ; preds = %rel_label_do, %rel_inner_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_label_do:                                     ; preds = %rel_inner_skip
  call void @avra_rc_release(ptr %rel_label)
  br label %rel_label_skip
}
