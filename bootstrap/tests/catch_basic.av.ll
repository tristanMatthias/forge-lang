; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Result__int__string = type { i64, ptr }
%Result__int__string__Err = type { ptr }

@.str = private unnamed_addr constant [3 x i8] c"42\00", align 1
@.str.1 = private unnamed_addr constant [13 x i8] c"not a number\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"bad\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.3 = private unnamed_addr constant [4 x i8] c"bad\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.5 = private unnamed_addr constant [3 x i8] c"42\00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define ptr @parse_int(ptr %0) {
entry:
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %1 = call i32 @strcmp(ptr %s1, ptr @.str)
  %widen = sext i32 %1 to i64
  %streq_cmp = icmp eq i64 %widen, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %if_cond = icmp ne i64 %streq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %2 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr3 = getelementptr inbounds nuw %Result__int__string, ptr %2, i32 0, i32 0
  store i64 193456014, ptr %tag_ptr3, align 8
  %pay_ptr4 = getelementptr inbounds nuw %Result__int__string, ptr %2, i32 0, i32 1
  %3 = call ptr @avra_rc_alloc(i64 8)
  store ptr %3, ptr %pay_ptr4, align 8
  %slot_base5 = ptrtoint ptr %3 to i64
  %slot_addr6 = add i64 %slot_base5, 0
  %slot7 = inttoptr i64 %slot_addr6 to ptr
  store ptr @.str.1, ptr %slot7, align 8
  %cast8 = ptrtoint ptr %2 to i64
  %cast9 = inttoptr i64 %cast8 to ptr
  %ret_tag_ptr = getelementptr inbounds nuw %Result__int__string, ptr %cast9, i32 0, i32 0
  %ret_tag = load i64, ptr %ret_tag_ptr, align 8
  %is_err_ret = icmp eq i64 %ret_tag, 193456014
  br i1 %is_err_ret, label %errdefer_path, label %defer_path

if_then:                                          ; preds = %entry
  %4 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Result__int__string, ptr %4, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result__int__string, ptr %4, i32 0, i32 1
  %5 = call ptr @avra_rc_alloc(i64 8)
  store ptr %5, ptr %pay_ptr, align 8
  %slot_base = ptrtoint ptr %5 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 42, ptr %slot, align 8
  %cast = ptrtoint ptr %4 to i64
  %cast2 = inttoptr i64 %cast to ptr
  ret ptr %cast2

if_else:                                          ; preds = %entry
  br label %ifcont

errdefer_path:                                    ; preds = %ifcont
  br label %defer_done

defer_path:                                       ; preds = %ifcont
  br label %defer_done

defer_done:                                       ; preds = %defer_path, %errdefer_path
  %cast10 = inttoptr i64 %cast8 to ptr
  ret ptr %cast10
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %good = alloca i64, align 8
  %catch_result25 = alloca i64, align 8
  %val = alloca i64, align 8
  %e = alloca ptr, align 8
  %catch_result9 = alloca i64, align 8
  %port = alloca i64, align 8
  %catch_result = alloca i64, align 8
  %1 = call ptr @parse_int(ptr @.str.2)
  %catch_tag_ptr = getelementptr inbounds nuw %Result__int__string, ptr %1, i32 0, i32 0
  %catch_tag = load i64, ptr %catch_tag_ptr, align 8
  %catch_is_ok = icmp eq i64 %catch_tag, 5862623
  br i1 %catch_is_ok, label %catch_ok, label %catch_err

catch_ok:                                         ; preds = %entry
  %catch_pay_slot = getelementptr inbounds nuw %Result__int__string, ptr %1, i32 0, i32 1
  %catch_payload = load ptr, ptr %catch_pay_slot, align 8
  %catch_ok_val = load i64, ptr %catch_payload, align 8
  store i64 %catch_ok_val, ptr %catch_result, align 8
  br label %catch_merge

catch_err:                                        ; preds = %entry
  store i64 8080, ptr %catch_result, align 8
  br label %catch_merge

catch_merge:                                      ; preds = %catch_err, %catch_ok
  %catch_merged = load i64, ptr %catch_result, align 8
  store i64 %catch_merged, ptr %port, align 8
  %port1 = load i64, ptr %port, align 8
  %2 = call ptr @avra_rc_alloc(i64 32)
  %3 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %2, i64 32, ptr @.i2s_fmt, i64 %port1)
  %widen = sext i32 %3 to i64
  %4 = call i32 @puts(ptr %2)
  %widen2 = sext i32 %4 to i64
  %5 = call ptr @parse_int(ptr @.str.3)
  %catch_tag_ptr3 = getelementptr inbounds nuw %Result__int__string, ptr %5, i32 0, i32 0
  %catch_tag4 = load i64, ptr %catch_tag_ptr3, align 8
  %catch_is_ok5 = icmp eq i64 %catch_tag4, 5862623
  br i1 %catch_is_ok5, label %catch_ok6, label %catch_err7

catch_ok6:                                        ; preds = %catch_merge
  %catch_pay_slot10 = getelementptr inbounds nuw %Result__int__string, ptr %5, i32 0, i32 1
  %catch_payload11 = load ptr, ptr %catch_pay_slot10, align 8
  %catch_ok_val12 = load i64, ptr %catch_payload11, align 8
  store i64 %catch_ok_val12, ptr %catch_result9, align 8
  br label %catch_merge8

catch_err7:                                       ; preds = %catch_merge
  %catch_err_pay_slot = getelementptr inbounds nuw %Result__int__string, ptr %5, i32 0, i32 1
  %catch_err_payload = load ptr, ptr %catch_err_pay_slot, align 8
  %catch_err_val = load i64, ptr %catch_err_payload, align 8
  %cast = inttoptr i64 %catch_err_val to ptr
  store ptr %cast, ptr %e, align 8
  %e13 = load ptr, ptr %e, align 8
  %6 = call i32 @puts(ptr %e13)
  %widen14 = sext i32 %6 to i64
  store i64 0, ptr %catch_result9, align 8
  br label %catch_merge8

catch_merge8:                                     ; preds = %catch_err7, %catch_ok6
  %catch_merged15 = load i64, ptr %catch_result9, align 8
  store i64 %catch_merged15, ptr %val, align 8
  %val16 = load i64, ptr %val, align 8
  %7 = call ptr @avra_rc_alloc(i64 32)
  %8 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %7, i64 32, ptr @.i2s_fmt.4, i64 %val16)
  %widen17 = sext i32 %8 to i64
  %9 = call i32 @puts(ptr %7)
  %widen18 = sext i32 %9 to i64
  %10 = call ptr @parse_int(ptr @.str.5)
  %catch_tag_ptr19 = getelementptr inbounds nuw %Result__int__string, ptr %10, i32 0, i32 0
  %catch_tag20 = load i64, ptr %catch_tag_ptr19, align 8
  %catch_is_ok21 = icmp eq i64 %catch_tag20, 5862623
  br i1 %catch_is_ok21, label %catch_ok22, label %catch_err23

catch_ok22:                                       ; preds = %catch_merge8
  %catch_pay_slot26 = getelementptr inbounds nuw %Result__int__string, ptr %10, i32 0, i32 1
  %catch_payload27 = load ptr, ptr %catch_pay_slot26, align 8
  %catch_ok_val28 = load i64, ptr %catch_payload27, align 8
  store i64 %catch_ok_val28, ptr %catch_result25, align 8
  br label %catch_merge24

catch_err23:                                      ; preds = %catch_merge8
  store i64 9999, ptr %catch_result25, align 8
  br label %catch_merge24

catch_merge24:                                    ; preds = %catch_err23, %catch_ok22
  %catch_merged29 = load i64, ptr %catch_result25, align 8
  store i64 %catch_merged29, ptr %good, align 8
  %good30 = load i64, ptr %good, align 8
  %11 = call ptr @avra_rc_alloc(i64 32)
  %12 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %11, i64 32, ptr @.i2s_fmt.6, i64 %good30)
  %widen31 = sext i32 %12 to i64
  %13 = call i32 @puts(ptr %11)
  %widen32 = sext i32 %13 to i64
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Result__int__string(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %Result__int__string, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result__int__string, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Err = icmp eq i64 %tag, 193456014
  br i1 %is_Err, label %rel_Err, label %try_next_Err

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Err, %vrel_error_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Err:                                          ; preds = %do_free
  %vrel_error_ptr = getelementptr inbounds nuw %Result__int__string__Err, ptr %payload, i32 0, i32 0
  %vrel_error = load ptr, ptr %vrel_error_ptr, align 8
  %vrel_null_error = icmp eq ptr %vrel_error, null
  br i1 %vrel_null_error, label %vrel_error_skip, label %vrel_error_do

try_next_Err:                                     ; preds = %do_free
  br label %fields_done

vrel_error_skip:                                  ; preds = %vrel_error_do, %rel_Err
  br label %fields_done

vrel_error_do:                                    ; preds = %rel_Err
  call void @avra_rc_release(ptr %vrel_error)
  br label %vrel_error_skip
}
