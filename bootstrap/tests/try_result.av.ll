; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Result = type { i64, ptr }
%Result__Err = type { ptr }

@.str = private unnamed_addr constant [17 x i8] c"division by zero\00", align 1
@dz_file = private unnamed_addr constant [97 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/try_result.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.1 = private unnamed_addr constant [8 x i8] c"error: \00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [97 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/try_result.av\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.3 = private unnamed_addr constant [13 x i8] c"propagated: \00", align 1
@.match_fn.4 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.5 = private unnamed_addr constant [97 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/try_result.av\00", align 1
@.str.6 = private unnamed_addr constant [10 x i8] c"chained: \00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.8 = private unnamed_addr constant [16 x i8] c"chained error: \00", align 1
@.match_fn.9 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.10 = private unnamed_addr constant [97 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/try_result.av\00", align 1

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

define ptr @divide(i64 %0, i64 %1) {
entry:
  %b = alloca i64, align 8
  %a = alloca i64, align 8
  store i64 %0, ptr %a, align 8
  store i64 %1, ptr %b, align 8
  %b1 = load i64, ptr %b, align 8
  %eq = icmp eq i64 %b1, 0
  %eq_ext = zext i1 %eq to i64
  %if_cond = icmp ne i64 %eq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %2 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr3 = getelementptr inbounds nuw %Result, ptr %2, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr3, align 8
  %pay_ptr4 = getelementptr inbounds nuw %Result, ptr %2, i32 0, i32 1
  %3 = call ptr @avra_rc_alloc(i64 8)
  store ptr %3, ptr %pay_ptr4, align 8
  %a5 = load i64, ptr %a, align 8
  %b6 = load i64, ptr %b, align 8
  %dz_chk = icmp eq i64 %b6, 0
  %dz_chk_ext = zext i1 %dz_chk to i64
  call void @avra_div_by_zero_trap(i64 %dz_chk_ext, ptr @dz_file, i64 96, i64 11)
  %div = sdiv i64 %a5, %b6
  %slot_base7 = ptrtoint ptr %3 to i64
  %slot_addr8 = add i64 %slot_base7, 0
  %slot9 = inttoptr i64 %slot_addr8 to ptr
  store i64 %div, ptr %slot9, align 8
  %cast10 = ptrtoint ptr %2 to i64
  %cast11 = inttoptr i64 %cast10 to ptr
  %ret_tag_ptr = getelementptr inbounds nuw %Result, ptr %cast11, i32 0, i32 0
  %ret_tag = load i64, ptr %ret_tag_ptr, align 8
  %is_err_ret = icmp eq i64 %ret_tag, 193456014
  br i1 %is_err_ret, label %errdefer_path, label %defer_path

if_then:                                          ; preds = %entry
  %4 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Result, ptr %4, i32 0, i32 0
  store i64 193456014, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result, ptr %4, i32 0, i32 1
  %5 = call ptr @avra_rc_alloc(i64 8)
  store ptr %5, ptr %pay_ptr, align 8
  %slot_base = ptrtoint ptr %5 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr @.str, ptr %slot, align 8
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
  %cast12 = inttoptr i64 %cast10 to ptr
  ret ptr %cast12
}

define ptr @compute_ok() {
entry:
  %x = alloca i64, align 8
  %0 = call ptr @divide(i64 84, i64 2)
  %try_tag_ptr = getelementptr inbounds nuw %Result, ptr %0, i32 0, i32 0
  %try_tag = load i64, ptr %try_tag_ptr, align 8
  %try_is_ok = icmp eq i64 %try_tag, 5862623
  br i1 %try_is_ok, label %try_ok, label %try_err

try_ok:                                           ; preds = %entry
  %try_pay_slot = getelementptr inbounds nuw %Result, ptr %0, i32 0, i32 1
  %try_payload = load ptr, ptr %try_pay_slot, align 8
  %try_ok_val = load i64, ptr %try_payload, align 8
  store i64 %try_ok_val, ptr %x, align 8
  %1 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Result, ptr %1, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result, ptr %1, i32 0, i32 1
  %2 = call ptr @avra_rc_alloc(i64 8)
  store ptr %2, ptr %pay_ptr, align 8
  %x1 = load i64, ptr %x, align 8
  %slot_base = ptrtoint ptr %2 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 %x1, ptr %slot, align 8
  %cast = ptrtoint ptr %1 to i64
  %cast2 = inttoptr i64 %cast to ptr
  %ret_tag_ptr = getelementptr inbounds nuw %Result, ptr %cast2, i32 0, i32 0
  %ret_tag = load i64, ptr %ret_tag_ptr, align 8
  %is_err_ret = icmp eq i64 %ret_tag, 193456014
  br i1 %is_err_ret, label %errdefer_path, label %defer_path

try_err:                                          ; preds = %entry
  ret ptr %0

errdefer_path:                                    ; preds = %try_ok
  br label %defer_done

defer_path:                                       ; preds = %try_ok
  br label %defer_done

defer_done:                                       ; preds = %defer_path, %errdefer_path
  %cast3 = inttoptr i64 %cast to ptr
  ret ptr %cast3
}

define ptr @compute_fail() {
entry:
  %x = alloca i64, align 8
  %0 = call ptr @divide(i64 10, i64 0)
  %try_tag_ptr = getelementptr inbounds nuw %Result, ptr %0, i32 0, i32 0
  %try_tag = load i64, ptr %try_tag_ptr, align 8
  %try_is_ok = icmp eq i64 %try_tag, 5862623
  br i1 %try_is_ok, label %try_ok, label %try_err

try_ok:                                           ; preds = %entry
  %try_pay_slot = getelementptr inbounds nuw %Result, ptr %0, i32 0, i32 1
  %try_payload = load ptr, ptr %try_pay_slot, align 8
  %try_ok_val = load i64, ptr %try_payload, align 8
  store i64 %try_ok_val, ptr %x, align 8
  %1 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Result, ptr %1, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result, ptr %1, i32 0, i32 1
  %2 = call ptr @avra_rc_alloc(i64 8)
  store ptr %2, ptr %pay_ptr, align 8
  %x1 = load i64, ptr %x, align 8
  %add = add i64 %x1, 999
  %slot_base = ptrtoint ptr %2 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 %add, ptr %slot, align 8
  %cast = ptrtoint ptr %1 to i64
  %cast2 = inttoptr i64 %cast to ptr
  %ret_tag_ptr = getelementptr inbounds nuw %Result, ptr %cast2, i32 0, i32 0
  %ret_tag = load i64, ptr %ret_tag_ptr, align 8
  %is_err_ret = icmp eq i64 %ret_tag, 193456014
  br i1 %is_err_ret, label %errdefer_path, label %defer_path

try_err:                                          ; preds = %entry
  ret ptr %0

errdefer_path:                                    ; preds = %try_ok
  br label %defer_done

defer_path:                                       ; preds = %try_ok
  br label %defer_done

defer_done:                                       ; preds = %defer_path, %errdefer_path
  %cast3 = inttoptr i64 %cast to ptr
  ret ptr %cast3
}

define ptr @chained() {
entry:
  %b = alloca i64, align 8
  %a = alloca i64, align 8
  %0 = call ptr @divide(i64 200, i64 2)
  %try_tag_ptr = getelementptr inbounds nuw %Result, ptr %0, i32 0, i32 0
  %try_tag = load i64, ptr %try_tag_ptr, align 8
  %try_is_ok = icmp eq i64 %try_tag, 5862623
  br i1 %try_is_ok, label %try_ok, label %try_err

try_ok:                                           ; preds = %entry
  %try_pay_slot = getelementptr inbounds nuw %Result, ptr %0, i32 0, i32 1
  %try_payload = load ptr, ptr %try_pay_slot, align 8
  %try_ok_val = load i64, ptr %try_payload, align 8
  store i64 %try_ok_val, ptr %a, align 8
  %a1 = load i64, ptr %a, align 8
  %1 = call ptr @divide(i64 %a1, i64 1)
  %try_tag_ptr2 = getelementptr inbounds nuw %Result, ptr %1, i32 0, i32 0
  %try_tag3 = load i64, ptr %try_tag_ptr2, align 8
  %try_is_ok4 = icmp eq i64 %try_tag3, 5862623
  br i1 %try_is_ok4, label %try_ok5, label %try_err6

try_err:                                          ; preds = %entry
  ret ptr %0

try_ok5:                                          ; preds = %try_ok
  %try_pay_slot7 = getelementptr inbounds nuw %Result, ptr %1, i32 0, i32 1
  %try_payload8 = load ptr, ptr %try_pay_slot7, align 8
  %try_ok_val9 = load i64, ptr %try_payload8, align 8
  store i64 %try_ok_val9, ptr %b, align 8
  %2 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Result, ptr %2, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result, ptr %2, i32 0, i32 1
  %3 = call ptr @avra_rc_alloc(i64 8)
  store ptr %3, ptr %pay_ptr, align 8
  %b10 = load i64, ptr %b, align 8
  %slot_base = ptrtoint ptr %3 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 %b10, ptr %slot, align 8
  %cast = ptrtoint ptr %2 to i64
  %cast11 = inttoptr i64 %cast to ptr
  %ret_tag_ptr = getelementptr inbounds nuw %Result, ptr %cast11, i32 0, i32 0
  %ret_tag = load i64, ptr %ret_tag_ptr, align 8
  %is_err_ret = icmp eq i64 %ret_tag, 193456014
  br i1 %is_err_ret, label %errdefer_path, label %defer_path

try_err6:                                         ; preds = %try_ok
  ret ptr %1

errdefer_path:                                    ; preds = %try_ok5
  br label %defer_done

defer_path:                                       ; preds = %try_ok5
  br label %defer_done

defer_done:                                       ; preds = %defer_path, %errdefer_path
  %cast12 = inttoptr i64 %cast to ptr
  ret ptr %cast12
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %e79 = alloca ptr, align 8
  %v60 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %e39 = alloca ptr, align 8
  %v26 = alloca i64, align 8
  %match_stmt_discard16 = alloca i64, align 8
  %e9 = alloca ptr, align 8
  %v1 = alloca i64, align 8
  %match_stmt_discard = alloca i64, align 8
  %1 = call ptr @compute_ok()
  %tag_ptr = getelementptr inbounds nuw %Result, ptr %1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %tag_eq = icmp eq i64 %tag, 5862623
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm4, %march_arm
  %2 = call ptr @compute_fail()
  %tag_ptr13 = getelementptr inbounds nuw %Result, ptr %2, i32 0, i32 0
  %tag14 = load i64, ptr %tag_ptr13, align 8
  %tag_eq19 = icmp eq i64 %tag14, 5862623
  br i1 %tag_eq19, label %march_arm17, label %march_next18

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Result, ptr %1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load i64, ptr %v_slot, align 8
  store i64 %v, ptr %v1, align 8
  %v2 = load i64, ptr %v1, align 8
  %3 = call ptr @avra_rc_alloc(i64 32)
  %4 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %3, i64 32, ptr @.i2s_fmt, i64 %v2)
  %widen = sext i32 %4 to i64
  %5 = call i32 @puts(ptr %3)
  %widen3 = sext i32 %5 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq6 = icmp eq i64 %tag, 193456014
  br i1 %tag_eq6, label %march_arm4, label %march_next5

march_arm4:                                       ; preds = %march_next
  %pay_slot7 = getelementptr inbounds nuw %Result, ptr %1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %e_slot_base = ptrtoint ptr %payload8 to i64
  %e_slot_addr = add i64 %e_slot_base, 0
  %e_slot = inttoptr i64 %e_slot_addr to ptr
  %e = load ptr, ptr %e_slot, align 8
  call void @avra_rc_retain(ptr %e)
  store ptr %e, ptr %e9, align 8
  %e10 = load ptr, ptr %e9, align 8
  %6 = call i64 @strlen(ptr @.str.1)
  %7 = call i64 @strlen(ptr %e10)
  %concat_total = add i64 %6, %7
  %concat_size = add i64 %concat_total, 1
  %8 = call ptr @avra_rc_alloc(i64 %concat_size)
  %9 = call ptr @memcpy(ptr %8, ptr @.str.1, i64 %6)
  %cast = ptrtoint ptr %8 to i64
  %dst2_int = add i64 %cast, %6
  %cast11 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %7, 1
  %10 = call ptr @memcpy(ptr %cast11, ptr %e10, i64 %rhs_len_p1)
  %11 = call i32 @puts(ptr %8)
  %widen12 = sext i32 %11 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next5:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 32)
  unreachable

match_end15:                                      ; preds = %march_arm30, %march_arm17
  %12 = call ptr @chained()
  %tag_ptr48 = getelementptr inbounds nuw %Result, ptr %12, i32 0, i32 0
  %tag49 = load i64, ptr %tag_ptr48, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq53 = icmp eq i64 %tag49, 5862623
  br i1 %tag_eq53, label %march_arm51, label %march_next52

march_arm17:                                      ; preds = %match_end
  %pay_slot20 = getelementptr inbounds nuw %Result, ptr %2, i32 0, i32 1
  %payload21 = load ptr, ptr %pay_slot20, align 8
  %v_slot_base22 = ptrtoint ptr %payload21 to i64
  %v_slot_addr23 = add i64 %v_slot_base22, 0
  %v_slot24 = inttoptr i64 %v_slot_addr23 to ptr
  %v25 = load i64, ptr %v_slot24, align 8
  store i64 %v25, ptr %v26, align 8
  %v27 = load i64, ptr %v26, align 8
  %13 = call ptr @avra_rc_alloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @.i2s_fmt.2, i64 %v27)
  %widen28 = sext i32 %14 to i64
  %15 = call i32 @puts(ptr %13)
  %widen29 = sext i32 %15 to i64
  store i64 0, ptr %match_stmt_discard16, align 8
  br label %match_end15

march_next18:                                     ; preds = %match_end
  %tag_eq32 = icmp eq i64 %tag14, 193456014
  br i1 %tag_eq32, label %march_arm30, label %march_next31

march_arm30:                                      ; preds = %march_next18
  %pay_slot33 = getelementptr inbounds nuw %Result, ptr %2, i32 0, i32 1
  %payload34 = load ptr, ptr %pay_slot33, align 8
  %e_slot_base35 = ptrtoint ptr %payload34 to i64
  %e_slot_addr36 = add i64 %e_slot_base35, 0
  %e_slot37 = inttoptr i64 %e_slot_addr36 to ptr
  %e38 = load ptr, ptr %e_slot37, align 8
  call void @avra_rc_retain(ptr %e38)
  store ptr %e38, ptr %e39, align 8
  %e40 = load ptr, ptr %e39, align 8
  %16 = call i64 @strlen(ptr @.str.3)
  %17 = call i64 @strlen(ptr %e40)
  %concat_total41 = add i64 %16, %17
  %concat_size42 = add i64 %concat_total41, 1
  %18 = call ptr @avra_rc_alloc(i64 %concat_size42)
  %19 = call ptr @memcpy(ptr %18, ptr @.str.3, i64 %16)
  %cast43 = ptrtoint ptr %18 to i64
  %dst2_int44 = add i64 %cast43, %16
  %cast45 = inttoptr i64 %dst2_int44 to ptr
  %rhs_len_p146 = add i64 %17, 1
  %20 = call ptr @memcpy(ptr %cast45, ptr %e40, i64 %rhs_len_p146)
  %21 = call i32 @puts(ptr %18)
  %widen47 = sext i32 %21 to i64
  store i64 0, ptr %match_stmt_discard16, align 8
  br label %match_end15

march_next31:                                     ; preds = %march_next18
  call void @avra_match_unreachable(ptr @.match_fn.4, i64 %tag14, ptr @mu_file.5, i64 37)
  unreachable

match_end50:                                      ; preds = %march_arm70, %march_arm51
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm51:                                      ; preds = %match_end15
  %pay_slot54 = getelementptr inbounds nuw %Result, ptr %12, i32 0, i32 1
  %payload55 = load ptr, ptr %pay_slot54, align 8
  %v_slot_base56 = ptrtoint ptr %payload55 to i64
  %v_slot_addr57 = add i64 %v_slot_base56, 0
  %v_slot58 = inttoptr i64 %v_slot_addr57 to ptr
  %v59 = load i64, ptr %v_slot58, align 8
  store i64 %v59, ptr %v60, align 8
  %v61 = load i64, ptr %v60, align 8
  %22 = call ptr @avra_rc_alloc(i64 32)
  %23 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %22, i64 32, ptr @.i2s_fmt.7, i64 %v61)
  %widen62 = sext i32 %23 to i64
  %24 = call i64 @strlen(ptr @.str.6)
  %25 = call i64 @strlen(ptr %22)
  %concat_total63 = add i64 %24, %25
  %concat_size64 = add i64 %concat_total63, 1
  %26 = call ptr @avra_rc_alloc(i64 %concat_size64)
  %27 = call ptr @memcpy(ptr %26, ptr @.str.6, i64 %24)
  %cast65 = ptrtoint ptr %26 to i64
  %dst2_int66 = add i64 %cast65, %24
  %cast67 = inttoptr i64 %dst2_int66 to ptr
  %rhs_len_p168 = add i64 %25, 1
  %28 = call ptr @memcpy(ptr %cast67, ptr %22, i64 %rhs_len_p168)
  %29 = call i32 @puts(ptr %26)
  %widen69 = sext i32 %29 to i64
  store i64 0, ptr %match_result, align 8
  br label %match_end50

march_next52:                                     ; preds = %match_end15
  %tag_eq72 = icmp eq i64 %tag49, 193456014
  br i1 %tag_eq72, label %march_arm70, label %march_next71

march_arm70:                                      ; preds = %march_next52
  %pay_slot73 = getelementptr inbounds nuw %Result, ptr %12, i32 0, i32 1
  %payload74 = load ptr, ptr %pay_slot73, align 8
  %e_slot_base75 = ptrtoint ptr %payload74 to i64
  %e_slot_addr76 = add i64 %e_slot_base75, 0
  %e_slot77 = inttoptr i64 %e_slot_addr76 to ptr
  %e78 = load ptr, ptr %e_slot77, align 8
  call void @avra_rc_retain(ptr %e78)
  store ptr %e78, ptr %e79, align 8
  %e80 = load ptr, ptr %e79, align 8
  %30 = call i64 @strlen(ptr @.str.8)
  %31 = call i64 @strlen(ptr %e80)
  %concat_total81 = add i64 %30, %31
  %concat_size82 = add i64 %concat_total81, 1
  %32 = call ptr @avra_rc_alloc(i64 %concat_size82)
  %33 = call ptr @memcpy(ptr %32, ptr @.str.8, i64 %30)
  %cast83 = ptrtoint ptr %32 to i64
  %dst2_int84 = add i64 %cast83, %30
  %cast85 = inttoptr i64 %dst2_int84 to ptr
  %rhs_len_p186 = add i64 %31, 1
  %34 = call ptr @memcpy(ptr %cast85, ptr %e80, i64 %rhs_len_p186)
  %35 = call i32 @puts(ptr %32)
  %widen87 = sext i32 %35 to i64
  store i64 0, ptr %match_result, align 8
  br label %match_end50

march_next71:                                     ; preds = %march_next52
  call void @avra_match_unreachable(ptr @.match_fn.9, i64 %tag49, ptr @mu_file.10, i64 42)
  unreachable
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

fields_done:                                      ; preds = %try_next_Err, %vrel_error_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Err:                                          ; preds = %do_free
  %vrel_error_ptr = getelementptr inbounds nuw %Result__Err, ptr %payload, i32 0, i32 0
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
