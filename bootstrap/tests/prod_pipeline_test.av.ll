; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%PplStudent = type { ptr, i64 }

@ppl_data = global i64 0
@fld_name = private unnamed_addr constant [6 x i8] c"score\00", align 1
@sty_name = private unnamed_addr constant [11 x i8] c"PplStudent\00", align 1
@src_file = private unnamed_addr constant [28 x i8] c"tests/prod_pipeline_test.fg\00", align 1
@fld_name.1 = private unnamed_addr constant [6 x i8] c"score\00", align 1
@sty_name.2 = private unnamed_addr constant [11 x i8] c"PplStudent\00", align 1
@src_file.3 = private unnamed_addr constant [28 x i8] c"tests/prod_pipeline_test.fg\00", align 1
@.str = private unnamed_addr constant [6 x i8] c"Alice\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c"Bob\00", align 1
@.str.5 = private unnamed_addr constant [6 x i8] c"Carol\00", align 1
@.str.6 = private unnamed_addr constant [5 x i8] c"Dave\00", align 1
@.str.7 = private unnamed_addr constant [4 x i8] c"Eve\00", align 1
@spec_str = private unnamed_addr constant [16 x i8] c"\22prod pipeline\22\00", align 1
@spec_str.8 = private unnamed_addr constant [14 x i8] c"\22total score\22\00", align 1
@spec_str.9 = private unnamed_addr constant [18 x i8] c"\22high performers\22\00", align 1
@dz_file = private unnamed_addr constant [28 x i8] c"tests/prod_pipeline_test.fg\00", align 1
@spec_str.10 = private unnamed_addr constant [16 x i8] c"\22average score\22\00", align 1

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

define i64 @ppl_count_high(ptr %0) {
entry:
  %s = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %count = alloca i64, align 8
  %data = alloca ptr, align 8
  store ptr %0, ptr %data, align 8
  store i64 0, ptr %count, align 8
  %data1 = load ptr, ptr %data, align 8
  %1 = call i64 @forge_array_len(ptr %data1)
  store i64 %1, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %entry
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %2 = call i64 @forge_array_get(ptr %data1, i64 %forin_i_val)
  store i64 %2, ptr %s, align 8
  %s2 = load ptr, ptr %s, align 8
  %cast = ptrtoint ptr %s2 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name, i64 5, ptr @sty_name, i64 10, i64 %null_ext, ptr @src_file, i64 27, i64 8)
  %score_ptr = getelementptr inbounds nuw %PplStudent, ptr %s2, i32 0, i32 1
  %score = load i64, ptr %score_ptr, align 8
  %sge = icmp sge i64 %score, 90
  %sge_ext = zext i1 %sge to i64
  %if_cond = icmp ne i64 %sge_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

forin.incr:                                       ; preds = %ifcont
  %forin_i_old = load i64, ptr %forin_i, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  %count4 = load i64, ptr %count, align 8
  ret i64 %count4

ifcont:                                           ; preds = %if_else, %if_then
  br label %forin.incr

if_then:                                          ; preds = %forin.body
  %count3 = load i64, ptr %count, align 8
  %add = add i64 %count3, 1
  store i64 %add, ptr %count, align 8
  br label %ifcont

if_else:                                          ; preds = %forin.body
  br label %ifcont
}

define i64 @ppl_total_score(ptr %0) {
entry:
  %s = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %total = alloca i64, align 8
  %data = alloca ptr, align 8
  store ptr %0, ptr %data, align 8
  store i64 0, ptr %total, align 8
  %data1 = load ptr, ptr %data, align 8
  %1 = call i64 @forge_array_len(ptr %data1)
  store i64 %1, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %entry
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %2 = call i64 @forge_array_get(ptr %data1, i64 %forin_i_val)
  store i64 %2, ptr %s, align 8
  %total2 = load i64, ptr %total, align 8
  %s3 = load ptr, ptr %s, align 8
  %cast = ptrtoint ptr %s3 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name.1, i64 5, ptr @sty_name.2, i64 10, i64 %null_ext, ptr @src_file.3, i64 27, i64 18)
  %score_ptr = getelementptr inbounds nuw %PplStudent, ptr %s3, i32 0, i32 1
  %score = load i64, ptr %score_ptr, align 8
  %add = add i64 %total2, %score
  store i64 %add, ptr %total, align 8
  br label %forin.incr

forin.incr:                                       ; preds = %forin.body
  %forin_i_old = load i64, ptr %forin_i, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  %total4 = load i64, ptr %total, align 8
  ret i64 %total4
}

define i64 @main() {
entry:
  %0 = call ptr @forge_array_new()
  %1 = call ptr @forge_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %PplStudent, ptr %1, i32 0, i32 0
  store ptr @.str, ptr %fld_ptr, align 8
  %fld_ptr1 = getelementptr inbounds nuw %PplStudent, ptr %1, i32 0, i32 1
  store i64 95, ptr %fld_ptr1, align 8
  %cast = ptrtoint ptr %1 to i64
  call void @forge_array_push(ptr %0, i64 %cast)
  %2 = call ptr @forge_rc_alloc(i64 16)
  %fld_ptr2 = getelementptr inbounds nuw %PplStudent, ptr %2, i32 0, i32 0
  store ptr @.str.4, ptr %fld_ptr2, align 8
  %fld_ptr3 = getelementptr inbounds nuw %PplStudent, ptr %2, i32 0, i32 1
  store i64 82, ptr %fld_ptr3, align 8
  %cast4 = ptrtoint ptr %2 to i64
  call void @forge_array_push(ptr %0, i64 %cast4)
  %3 = call ptr @forge_rc_alloc(i64 16)
  %fld_ptr5 = getelementptr inbounds nuw %PplStudent, ptr %3, i32 0, i32 0
  store ptr @.str.5, ptr %fld_ptr5, align 8
  %fld_ptr6 = getelementptr inbounds nuw %PplStudent, ptr %3, i32 0, i32 1
  store i64 91, ptr %fld_ptr6, align 8
  %cast7 = ptrtoint ptr %3 to i64
  call void @forge_array_push(ptr %0, i64 %cast7)
  %4 = call ptr @forge_rc_alloc(i64 16)
  %fld_ptr8 = getelementptr inbounds nuw %PplStudent, ptr %4, i32 0, i32 0
  store ptr @.str.6, ptr %fld_ptr8, align 8
  %fld_ptr9 = getelementptr inbounds nuw %PplStudent, ptr %4, i32 0, i32 1
  store i64 67, ptr %fld_ptr9, align 8
  %cast10 = ptrtoint ptr %4 to i64
  call void @forge_array_push(ptr %0, i64 %cast10)
  %5 = call ptr @forge_rc_alloc(i64 16)
  %fld_ptr11 = getelementptr inbounds nuw %PplStudent, ptr %5, i32 0, i32 0
  store ptr @.str.7, ptr %fld_ptr11, align 8
  %fld_ptr12 = getelementptr inbounds nuw %PplStudent, ptr %5, i32 0, i32 1
  store i64 88, ptr %fld_ptr12, align 8
  %cast13 = ptrtoint ptr %5 to i64
  call void @forge_array_push(ptr %0, i64 %cast13)
  store ptr %0, ptr @ppl_data, align 8
  %6 = call i32 @forge_test_start_spec(ptr @spec_str)
  %widen = sext i32 %6 to i64
  %ppl_data = load ptr, ptr @ppl_data, align 8
  %7 = call i64 @ppl_total_score(ptr %ppl_data)
  %eq = icmp eq i64 %7, 423
  %eq_ext = zext i1 %eq to i64
  %8 = call i64 @forge_test_run_then(ptr @spec_str.8, i64 %eq_ext)
  %ppl_data14 = load ptr, ptr @ppl_data, align 8
  %9 = call i64 @ppl_count_high(ptr %ppl_data14)
  %eq15 = icmp eq i64 %9, 2
  %eq_ext16 = zext i1 %eq15 to i64
  %10 = call i64 @forge_test_run_then(ptr @spec_str.9, i64 %eq_ext16)
  %ppl_data17 = load ptr, ptr @ppl_data, align 8
  %11 = call i64 @ppl_total_score(ptr %ppl_data17)
  call void @forge_div_by_zero_trap(i64 0, ptr @dz_file, i64 27, i64 39)
  %div = sdiv i64 %11, 5
  %eq18 = icmp eq i64 %div, 84
  %eq_ext19 = zext i1 %eq18 to i64
  %12 = call i64 @forge_test_run_then(ptr @spec_str.10, i64 %eq_ext19)
  %13 = call i32 @forge_test_end_spec(ptr @spec_str)
  %widen20 = sext i32 %13 to i64
  %14 = call i32 @forge_test_summary()
  %widen21 = sext i32 %14 to i64
  call void @forge_rc_collect()
  ret i64 0
}

define i64 @__release_PplStudent(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %PplStudent, ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_name_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  call void @forge_rc_free(ptr %0)
  br label %done

rel_name_do:                                      ; preds = %do_free
  call void @forge_rc_release(ptr %rel_name)
  br label %rel_name_skip
}
