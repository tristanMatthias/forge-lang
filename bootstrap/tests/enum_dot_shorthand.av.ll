; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Result = type { i64, ptr }
%Result__Err = type { ptr }

@.str = private unnamed_addr constant [5 x i8] c"nope\00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"ok: \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.2 = private unnamed_addr constant [6 x i8] c"err: \00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"show\00", align 1
@mu_file = private unnamed_addr constant [105 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/enum_dot_shorthand.av\00", align 1

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

define ptr @success() {
entry:
  %0 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Result, ptr %0, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result, ptr %0, i32 0, i32 1
  %1 = call ptr @avra_rc_alloc(i64 8)
  store ptr %1, ptr %pay_ptr, align 8
  %slot_base = ptrtoint ptr %1 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 42, ptr %slot, align 8
  %cast = ptrtoint ptr %0 to i64
  %cast1 = inttoptr i64 %cast to ptr
  %ret_tag_ptr = getelementptr inbounds nuw %Result, ptr %cast1, i32 0, i32 0
  %ret_tag = load i64, ptr %ret_tag_ptr, align 8
  %is_err_ret = icmp eq i64 %ret_tag, 193456014
  br i1 %is_err_ret, label %errdefer_path, label %defer_path

errdefer_path:                                    ; preds = %entry
  br label %defer_done

defer_path:                                       ; preds = %entry
  br label %defer_done

defer_done:                                       ; preds = %defer_path, %errdefer_path
  %cast2 = inttoptr i64 %cast to ptr
  ret ptr %cast2
}

define ptr @failure() {
entry:
  %0 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Result, ptr %0, i32 0, i32 0
  store i64 193456014, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result, ptr %0, i32 0, i32 1
  %1 = call ptr @avra_rc_alloc(i64 8)
  store ptr %1, ptr %pay_ptr, align 8
  %slot_base = ptrtoint ptr %1 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr @.str, ptr %slot, align 8
  %cast = ptrtoint ptr %0 to i64
  %cast1 = inttoptr i64 %cast to ptr
  %ret_tag_ptr = getelementptr inbounds nuw %Result, ptr %cast1, i32 0, i32 0
  %ret_tag = load i64, ptr %ret_tag_ptr, align 8
  %is_err_ret = icmp eq i64 %ret_tag, 193456014
  br i1 %is_err_ret, label %errdefer_path, label %defer_path

errdefer_path:                                    ; preds = %entry
  br label %defer_done

defer_path:                                       ; preds = %entry
  br label %defer_done

defer_done:                                       ; preds = %defer_path, %errdefer_path
  %cast2 = inttoptr i64 %cast to ptr
  ret ptr %cast2
}

define i64 @show(ptr %0) {
entry:
  %msg11 = alloca ptr, align 8
  %v2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %r = alloca ptr, align 8
  store ptr %0, ptr %r, align 8
  %r1 = load ptr, ptr %r, align 8
  %tag_ptr = getelementptr inbounds nuw %Result, ptr %r1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 5862623
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm6, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Result, ptr %r1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load i64, ptr %v_slot, align 8
  store i64 %v, ptr %v2, align 8
  %v3 = load i64, ptr %v2, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %v3)
  %widen = sext i32 %2 to i64
  %3 = call i64 @strlen(ptr @.str.1)
  %4 = call i64 @strlen(ptr %1)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @avra_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr @.str.1, i64 %3)
  %cast = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast, %3
  %cast4 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast4, ptr %1, i64 %rhs_len_p1)
  %8 = call i32 @puts(ptr %5)
  %widen5 = sext i32 %8 to i64
  store i64 0, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq8 = icmp eq i64 %tag, 193456014
  br i1 %tag_eq8, label %march_arm6, label %march_next7

march_arm6:                                       ; preds = %march_next
  %pay_slot9 = getelementptr inbounds nuw %Result, ptr %r1, i32 0, i32 1
  %payload10 = load ptr, ptr %pay_slot9, align 8
  %msg_slot_base = ptrtoint ptr %payload10 to i64
  %msg_slot_addr = add i64 %msg_slot_base, 0
  %msg_slot = inttoptr i64 %msg_slot_addr to ptr
  %msg = load ptr, ptr %msg_slot, align 8
  call void @avra_rc_retain(ptr %msg)
  store ptr %msg, ptr %msg11, align 8
  %msg12 = load ptr, ptr %msg11, align 8
  %9 = call i64 @strlen(ptr @.str.2)
  %10 = call i64 @strlen(ptr %msg12)
  %concat_total13 = add i64 %9, %10
  %concat_size14 = add i64 %concat_total13, 1
  %11 = call ptr @avra_rc_alloc(i64 %concat_size14)
  %12 = call ptr @memcpy(ptr %11, ptr @.str.2, i64 %9)
  %cast15 = ptrtoint ptr %11 to i64
  %dst2_int16 = add i64 %cast15, %9
  %cast17 = inttoptr i64 %dst2_int16 to ptr
  %rhs_len_p118 = add i64 %10, 1
  %13 = call ptr @memcpy(ptr %cast17, ptr %msg12, i64 %rhs_len_p118)
  %14 = call i32 @puts(ptr %11)
  %widen19 = sext i32 %14 to i64
  store i64 0, ptr %match_result, align 8
  br label %match_end

march_next7:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 13)
  unreachable
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %1 = call ptr @success()
  %2 = call i64 @show(ptr %1)
  %3 = call ptr @failure()
  %4 = call i64 @show(ptr %3)
  ret i64 %4
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Result(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %Result, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Err = icmp eq i64 %tag, 193456014
  br i1 %is_Err, label %rel_Err, label %try_next_Err

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Err, %vrel_msg_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Err:                                          ; preds = %do_free
  %vrel_msg_ptr = getelementptr inbounds nuw %Result__Err, ptr %payload, i32 0, i32 0
  %vrel_msg = load ptr, ptr %vrel_msg_ptr, align 8
  %vrel_null_msg = icmp eq ptr %vrel_msg, null
  br i1 %vrel_null_msg, label %vrel_msg_skip, label %vrel_msg_do

try_next_Err:                                     ; preds = %do_free
  br label %fields_done

vrel_msg_skip:                                    ; preds = %vrel_msg_do, %rel_Err
  br label %fields_done

vrel_msg_do:                                      ; preds = %rel_Err
  call void @avra_rc_release(ptr %vrel_msg)
  br label %vrel_msg_skip
}
