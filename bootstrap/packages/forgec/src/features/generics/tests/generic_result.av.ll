; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Result__int__string = type { i64, ptr }
%Result__int__string__Err = type { ptr }

@.str = private unnamed_addr constant [17 x i8] c"division by zero\00", align 1
@dz_file = private unnamed_addr constant [139 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/generics/tests/generic_result.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.1 = private unnamed_addr constant [8 x i8] c"error: \00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [139 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/generics/tests/generic_result.av\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.3 = private unnamed_addr constant [13 x i8] c"propagated: \00", align 1
@.match_fn.4 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.5 = private unnamed_addr constant [139 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/generics/tests/generic_result.av\00", align 1

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
  %tag_ptr3 = getelementptr inbounds nuw %Result__int__string, ptr %2, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr3, align 8
  %pay_ptr4 = getelementptr inbounds nuw %Result__int__string, ptr %2, i32 0, i32 1
  %3 = call ptr @avra_rc_alloc(i64 8)
  store ptr %3, ptr %pay_ptr4, align 8
  %a5 = load i64, ptr %a, align 8
  %b6 = load i64, ptr %b, align 8
  %dz_chk = icmp eq i64 %b6, 0
  %dz_chk_ext = zext i1 %dz_chk to i64
  call void @avra_div_by_zero_trap(i64 %dz_chk_ext, ptr @dz_file, i64 138, i64 12)
  %div = sdiv i64 %a5, %b6
  %slot_base7 = ptrtoint ptr %3 to i64
  %slot_addr8 = add i64 %slot_base7, 0
  %slot9 = inttoptr i64 %slot_addr8 to ptr
  store i64 %div, ptr %slot9, align 8
  %cast10 = ptrtoint ptr %2 to i64
  %cast11 = inttoptr i64 %cast10 to ptr
  %ret_tag_ptr = getelementptr inbounds nuw %Result__int__string, ptr %cast11, i32 0, i32 0
  %ret_tag = load i64, ptr %ret_tag_ptr, align 8
  %is_err_ret = icmp eq i64 %ret_tag, 193456014
  br i1 %is_err_ret, label %errdefer_path, label %defer_path

if_then:                                          ; preds = %entry
  %4 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Result__int__string, ptr %4, i32 0, i32 0
  store i64 193456014, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result__int__string, ptr %4, i32 0, i32 1
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

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %e38 = alloca ptr, align 8
  %v25 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %e9 = alloca ptr, align 8
  %v1 = alloca i64, align 8
  %match_stmt_discard = alloca i64, align 8
  %1 = call ptr @divide(i64 84, i64 2)
  %tag_ptr = getelementptr inbounds nuw %Result__int__string, ptr %1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %tag_eq = icmp eq i64 %tag, 5862623
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm4, %march_arm
  %2 = call ptr @divide(i64 10, i64 0)
  %tag_ptr13 = getelementptr inbounds nuw %Result__int__string, ptr %2, i32 0, i32 0
  %tag14 = load i64, ptr %tag_ptr13, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq18 = icmp eq i64 %tag14, 5862623
  br i1 %tag_eq18, label %march_arm16, label %march_next17

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Result__int__string, ptr %1, i32 0, i32 1
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
  %pay_slot7 = getelementptr inbounds nuw %Result__int__string, ptr %1, i32 0, i32 1
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
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 16)
  unreachable

match_end15:                                      ; preds = %march_arm29, %march_arm16
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm16:                                      ; preds = %match_end
  %pay_slot19 = getelementptr inbounds nuw %Result__int__string, ptr %2, i32 0, i32 1
  %payload20 = load ptr, ptr %pay_slot19, align 8
  %v_slot_base21 = ptrtoint ptr %payload20 to i64
  %v_slot_addr22 = add i64 %v_slot_base21, 0
  %v_slot23 = inttoptr i64 %v_slot_addr22 to ptr
  %v24 = load i64, ptr %v_slot23, align 8
  store i64 %v24, ptr %v25, align 8
  %v26 = load i64, ptr %v25, align 8
  %12 = call ptr @avra_rc_alloc(i64 32)
  %13 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %12, i64 32, ptr @.i2s_fmt.2, i64 %v26)
  %widen27 = sext i32 %13 to i64
  %14 = call i32 @puts(ptr %12)
  %widen28 = sext i32 %14 to i64
  store i64 0, ptr %match_result, align 8
  br label %match_end15

march_next17:                                     ; preds = %match_end
  %tag_eq31 = icmp eq i64 %tag14, 193456014
  br i1 %tag_eq31, label %march_arm29, label %march_next30

march_arm29:                                      ; preds = %march_next17
  %pay_slot32 = getelementptr inbounds nuw %Result__int__string, ptr %2, i32 0, i32 1
  %payload33 = load ptr, ptr %pay_slot32, align 8
  %e_slot_base34 = ptrtoint ptr %payload33 to i64
  %e_slot_addr35 = add i64 %e_slot_base34, 0
  %e_slot36 = inttoptr i64 %e_slot_addr35 to ptr
  %e37 = load ptr, ptr %e_slot36, align 8
  call void @avra_rc_retain(ptr %e37)
  store ptr %e37, ptr %e38, align 8
  %e39 = load ptr, ptr %e38, align 8
  %15 = call i64 @strlen(ptr @.str.3)
  %16 = call i64 @strlen(ptr %e39)
  %concat_total40 = add i64 %15, %16
  %concat_size41 = add i64 %concat_total40, 1
  %17 = call ptr @avra_rc_alloc(i64 %concat_size41)
  %18 = call ptr @memcpy(ptr %17, ptr @.str.3, i64 %15)
  %cast42 = ptrtoint ptr %17 to i64
  %dst2_int43 = add i64 %cast42, %15
  %cast44 = inttoptr i64 %dst2_int43 to ptr
  %rhs_len_p145 = add i64 %16, 1
  %19 = call ptr @memcpy(ptr %cast44, ptr %e39, i64 %rhs_len_p145)
  %20 = call i32 @puts(ptr %17)
  %widen46 = sext i32 %20 to i64
  store i64 0, ptr %match_result, align 8
  br label %match_end15

march_next30:                                     ; preds = %march_next17
  call void @avra_match_unreachable(ptr @.match_fn.4, i64 %tag14, ptr @mu_file.5, i64 20)
  unreachable
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
