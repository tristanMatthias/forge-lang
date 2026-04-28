; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Tree = type { i64, ptr }
%Result__int__string = type { i64, ptr }
%Result__string__string = type { i64, ptr }
%Tree__Node = type { ptr, ptr }
%Result__string__string__Ok = type { ptr }
%Result__string__string__Err = type { ptr }
%Result__int__string__Err = type { ptr }

@.match_fn = private unnamed_addr constant [9 x i8] c"sum_tree\00", align 1
@mu_file = private unnamed_addr constant [113 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/stress_everything_combined.av\00", align 1
@.str = private unnamed_addr constant [13 x i8] c"divide error\00", align 1
@dz_file = private unnamed_addr constant [113 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/stress_everything_combined.av\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"result: \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.2 = private unnamed_addr constant [21 x i8] c"pipeline: processed \00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.4 = private unnamed_addr constant [15 x i8] c" items, total=\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.6 = private unnamed_addr constant [11 x i8] c"tree sum: \00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.8 = private unnamed_addr constant [5 x i8] c"ok: \00", align 1
@.str.9 = private unnamed_addr constant [22 x i8] c"error chain: caught: \00", align 1
@.match_fn.10 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.11 = private unnamed_addr constant [113 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/stress_everything_combined.av\00", align 1

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

define i64 @sum_tree(ptr %0) {
entry:
  %r12 = alloca ptr, align 8
  %l9 = alloca ptr, align 8
  %v2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %t = alloca ptr, align 8
  store ptr %0, ptr %t, align 8
  %t1 = load ptr, ptr %t, align 8
  %tag_ptr = getelementptr inbounds nuw %Tree, ptr %t1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 6384285405
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm4, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Tree, ptr %t1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load i64, ptr %v_slot, align 8
  store i64 %v, ptr %v2, align 8
  %v3 = load i64, ptr %v2, align 8
  store i64 %v3, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq6 = icmp eq i64 %tag, 6384368267
  br i1 %tag_eq6, label %march_arm4, label %march_next5

march_arm4:                                       ; preds = %march_next
  %pay_slot7 = getelementptr inbounds nuw %Tree, ptr %t1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %l_slot_base = ptrtoint ptr %payload8 to i64
  %l_slot_addr = add i64 %l_slot_base, 0
  %l_slot = inttoptr i64 %l_slot_addr to ptr
  %l = load ptr, ptr %l_slot, align 8
  call void @avra_rc_retain(ptr %l)
  store ptr %l, ptr %l9, align 8
  %pay_slot10 = getelementptr inbounds nuw %Tree, ptr %t1, i32 0, i32 1
  %payload11 = load ptr, ptr %pay_slot10, align 8
  %r_slot_base = ptrtoint ptr %payload11 to i64
  %r_slot_addr = add i64 %r_slot_base, 8
  %r_slot = inttoptr i64 %r_slot_addr to ptr
  %r = load ptr, ptr %r_slot, align 8
  call void @avra_rc_retain(ptr %r)
  store ptr %r, ptr %r12, align 8
  %l13 = load ptr, ptr %l9, align 8
  %1 = call i64 @sum_tree(ptr %l13)
  %r14 = load ptr, ptr %r12, align 8
  %2 = call i64 @sum_tree(ptr %r14)
  %add = add i64 %1, %2
  store i64 %add, ptr %match_result, align 8
  br label %match_end

march_next5:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 9)
  unreachable
}

define ptr @safe_div(i64 %0, i64 %1) {
entry:
  %sif_result = alloca i64, align 8
  %b = alloca i64, align 8
  %a = alloca i64, align 8
  store i64 %0, ptr %a, align 8
  store i64 %1, ptr %b, align 8
  %b1 = load i64, ptr %b, align 8
  %eq = icmp eq i64 %b1, 0
  %eq_ext = zext i1 %eq to i64
  %sif_cond = icmp ne i64 %eq_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

sif_then:                                         ; preds = %entry
  %2 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Result__int__string, ptr %2, i32 0, i32 0
  store i64 193456014, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result__int__string, ptr %2, i32 0, i32 1
  %3 = call ptr @avra_rc_alloc(i64 8)
  store ptr %3, ptr %pay_ptr, align 8
  %slot_base = ptrtoint ptr %3 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr @.str, ptr %slot, align 8
  %cast = ptrtoint ptr %2 to i64
  store i64 %cast, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %entry
  %4 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr2 = getelementptr inbounds nuw %Result__int__string, ptr %4, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr2, align 8
  %pay_ptr3 = getelementptr inbounds nuw %Result__int__string, ptr %4, i32 0, i32 1
  %5 = call ptr @avra_rc_alloc(i64 8)
  store ptr %5, ptr %pay_ptr3, align 8
  %a4 = load i64, ptr %a, align 8
  %b5 = load i64, ptr %b, align 8
  %dz_chk = icmp eq i64 %b5, 0
  %dz_chk_ext = zext i1 %dz_chk to i64
  call void @avra_div_by_zero_trap(i64 %dz_chk_ext, ptr @dz_file, i64 112, i64 17)
  %div = sdiv i64 %a4, %b5
  %slot_base6 = ptrtoint ptr %5 to i64
  %slot_addr7 = add i64 %slot_base6, 0
  %slot8 = inttoptr i64 %slot_addr7 to ptr
  store i64 %div, ptr %slot8, align 8
  %cast9 = ptrtoint ptr %4 to i64
  store i64 %cast9, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  %cast10 = inttoptr i64 %sif_val to ptr
  %ret_tag_ptr = getelementptr inbounds nuw %Result__int__string, ptr %cast10, i32 0, i32 0
  %ret_tag = load i64, ptr %ret_tag_ptr, align 8
  %is_err_ret = icmp eq i64 %ret_tag, 193456014
  br i1 %is_err_ret, label %errdefer_path, label %defer_path

errdefer_path:                                    ; preds = %sif_end
  br label %defer_done

defer_path:                                       ; preds = %sif_end
  br label %defer_done

defer_done:                                       ; preds = %defer_path, %errdefer_path
  %cast11 = inttoptr i64 %sif_val to ptr
  ret ptr %cast11
}

define ptr @chain_ops(i64 %0) {
entry:
  %b = alloca i64, align 8
  %a = alloca i64, align 8
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %1 = call ptr @safe_div(i64 100, i64 %x1)
  %try_tag_ptr = getelementptr inbounds nuw %Result__int__string, ptr %1, i32 0, i32 0
  %try_tag = load i64, ptr %try_tag_ptr, align 8
  %try_is_ok = icmp eq i64 %try_tag, 5862623
  br i1 %try_is_ok, label %try_ok, label %try_err

try_ok:                                           ; preds = %entry
  %try_pay_slot = getelementptr inbounds nuw %Result__int__string, ptr %1, i32 0, i32 1
  %try_payload = load ptr, ptr %try_pay_slot, align 8
  %try_ok_val = load i64, ptr %try_payload, align 8
  store i64 %try_ok_val, ptr %a, align 8
  %a2 = load i64, ptr %a, align 8
  %x3 = load i64, ptr %x, align 8
  %2 = call ptr @safe_div(i64 %a2, i64 %x3)
  %try_tag_ptr4 = getelementptr inbounds nuw %Result__int__string, ptr %2, i32 0, i32 0
  %try_tag5 = load i64, ptr %try_tag_ptr4, align 8
  %try_is_ok6 = icmp eq i64 %try_tag5, 5862623
  br i1 %try_is_ok6, label %try_ok7, label %try_err8

try_err:                                          ; preds = %entry
  ret ptr %1

try_ok7:                                          ; preds = %try_ok
  %try_pay_slot9 = getelementptr inbounds nuw %Result__int__string, ptr %2, i32 0, i32 1
  %try_payload10 = load ptr, ptr %try_pay_slot9, align 8
  %try_ok_val11 = load i64, ptr %try_payload10, align 8
  store i64 %try_ok_val11, ptr %b, align 8
  %3 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Result__string__string, ptr %3, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result__string__string, ptr %3, i32 0, i32 1
  %4 = call ptr @avra_rc_alloc(i64 8)
  store ptr %4, ptr %pay_ptr, align 8
  %b12 = load i64, ptr %b, align 8
  %5 = call ptr @avra_rc_alloc(i64 32)
  %6 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %5, i64 32, ptr @.i2s_fmt, i64 %b12)
  %widen = sext i32 %6 to i64
  %7 = call i64 @strlen(ptr @.str.1)
  %8 = call i64 @strlen(ptr %5)
  %concat_total = add i64 %7, %8
  %concat_size = add i64 %concat_total, 1
  %9 = call ptr @avra_rc_alloc(i64 %concat_size)
  %10 = call ptr @memcpy(ptr %9, ptr @.str.1, i64 %7)
  %cast = ptrtoint ptr %9 to i64
  %dst2_int = add i64 %cast, %7
  %cast13 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %8, 1
  %11 = call ptr @memcpy(ptr %cast13, ptr %5, i64 %rhs_len_p1)
  %slot_base = ptrtoint ptr %4 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr %9, ptr %slot, align 8
  %cast14 = ptrtoint ptr %3 to i64
  %cast15 = inttoptr i64 %cast14 to ptr
  %ret_tag_ptr = getelementptr inbounds nuw %Result__string__string, ptr %cast15, i32 0, i32 0
  %ret_tag = load i64, ptr %ret_tag_ptr, align 8
  %is_err_ret = icmp eq i64 %ret_tag, 193456014
  br i1 %is_err_ret, label %errdefer_path, label %defer_path

try_err8:                                         ; preds = %try_ok
  ret ptr %2

errdefer_path:                                    ; preds = %try_ok7
  br label %defer_done

defer_path:                                       ; preds = %try_ok7
  br label %defer_done

defer_done:                                       ; preds = %defer_path, %errdefer_path
  %cast16 = inttoptr i64 %cast14 to ptr
  ret ptr %cast16
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %e117 = alloca ptr, align 8
  %v103 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %tree = alloca ptr, align 8
  %total = alloca i64, align 8
  %processed = alloca ptr, align 8
  %data = alloca ptr, align 8
  %1 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %1, i64 5)
  call void @avra_array_push(ptr %1, i64 10)
  call void @avra_array_push(ptr %1, i64 15)
  call void @avra_array_push(ptr %1, i64 20)
  call void @avra_array_push(ptr %1, i64 25)
  store ptr %1, ptr %data, align 8
  %data1 = load ptr, ptr %data, align 8
  %2 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %2, i64 -559038737)
  call void @avra_array_push(ptr %2, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast = ptrtoint ptr %2 to i64
  %3 = call ptr @avra_array_map(ptr %data1, i64 %cast)
  %4 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %4, i64 -559038737)
  call void @avra_array_push(ptr %4, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cast2 = ptrtoint ptr %4 to i64
  %5 = call ptr @avra_array_filter(ptr %3, i64 %cast2)
  store ptr %5, ptr %processed, align 8
  %processed3 = load ptr, ptr %processed, align 8
  %6 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %6, i64 -559038737)
  call void @avra_array_push(ptr %6, i64 ptrtoint (ptr @__lambda_2 to i64))
  %cast4 = ptrtoint ptr %6 to i64
  %7 = call i64 @avra_array_reduce(ptr %processed3, i64 0, i64 %cast4)
  store i64 %7, ptr %total, align 8
  %processed5 = load ptr, ptr %processed, align 8
  %8 = call i64 @avra_array_len(ptr %processed5)
  %9 = call ptr @avra_rc_alloc(i64 32)
  %10 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %9, i64 32, ptr @.i2s_fmt.3, i64 %8)
  %widen = sext i32 %10 to i64
  %11 = call i64 @strlen(ptr @.str.2)
  %12 = call i64 @strlen(ptr %9)
  %concat_total = add i64 %11, %12
  %concat_size = add i64 %concat_total, 1
  %13 = call ptr @avra_rc_alloc(i64 %concat_size)
  %14 = call ptr @memcpy(ptr %13, ptr @.str.2, i64 %11)
  %cast6 = ptrtoint ptr %13 to i64
  %dst2_int = add i64 %cast6, %11
  %cast7 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %12, 1
  %15 = call ptr @memcpy(ptr %cast7, ptr %9, i64 %rhs_len_p1)
  %16 = call i64 @strlen(ptr %13)
  %17 = call i64 @strlen(ptr @.str.4)
  %concat_total8 = add i64 %16, %17
  %concat_size9 = add i64 %concat_total8, 1
  %18 = call ptr @avra_rc_alloc(i64 %concat_size9)
  %19 = call ptr @memcpy(ptr %18, ptr %13, i64 %16)
  %cast10 = ptrtoint ptr %18 to i64
  %dst2_int11 = add i64 %cast10, %16
  %cast12 = inttoptr i64 %dst2_int11 to ptr
  %rhs_len_p113 = add i64 %17, 1
  %20 = call ptr @memcpy(ptr %cast12, ptr @.str.4, i64 %rhs_len_p113)
  %total14 = load i64, ptr %total, align 8
  %21 = call ptr @avra_rc_alloc(i64 32)
  %22 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %21, i64 32, ptr @.i2s_fmt.5, i64 %total14)
  %widen15 = sext i32 %22 to i64
  %23 = call i64 @strlen(ptr %18)
  %24 = call i64 @strlen(ptr %21)
  %concat_total16 = add i64 %23, %24
  %concat_size17 = add i64 %concat_total16, 1
  %25 = call ptr @avra_rc_alloc(i64 %concat_size17)
  %26 = call ptr @memcpy(ptr %25, ptr %18, i64 %23)
  %cast18 = ptrtoint ptr %25 to i64
  %dst2_int19 = add i64 %cast18, %23
  %cast20 = inttoptr i64 %dst2_int19 to ptr
  %rhs_len_p121 = add i64 %24, 1
  %27 = call ptr @memcpy(ptr %cast20, ptr %21, i64 %rhs_len_p121)
  %28 = call i32 @puts(ptr %25)
  %widen22 = sext i32 %28 to i64
  %29 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Tree, ptr %29, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Tree, ptr %29, i32 0, i32 1
  %30 = call ptr @avra_rc_alloc(i64 16)
  store ptr %30, ptr %pay_ptr, align 8
  %31 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr23 = getelementptr inbounds nuw %Tree, ptr %31, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr23, align 8
  %pay_ptr24 = getelementptr inbounds nuw %Tree, ptr %31, i32 0, i32 1
  %32 = call ptr @avra_rc_alloc(i64 16)
  store ptr %32, ptr %pay_ptr24, align 8
  %33 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr25 = getelementptr inbounds nuw %Tree, ptr %33, i32 0, i32 0
  store i64 6384285405, ptr %tag_ptr25, align 8
  %pay_ptr26 = getelementptr inbounds nuw %Tree, ptr %33, i32 0, i32 1
  %34 = call ptr @avra_rc_alloc(i64 8)
  store ptr %34, ptr %pay_ptr26, align 8
  %slot_base = ptrtoint ptr %34 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 1, ptr %slot, align 8
  %cast27 = ptrtoint ptr %33 to i64
  %slot_base28 = ptrtoint ptr %32 to i64
  %slot_addr29 = add i64 %slot_base28, 0
  %slot30 = inttoptr i64 %slot_addr29 to ptr
  %cast31 = inttoptr i64 %cast27 to ptr
  store ptr %cast31, ptr %slot30, align 8
  %35 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr32 = getelementptr inbounds nuw %Tree, ptr %35, i32 0, i32 0
  store i64 6384285405, ptr %tag_ptr32, align 8
  %pay_ptr33 = getelementptr inbounds nuw %Tree, ptr %35, i32 0, i32 1
  %36 = call ptr @avra_rc_alloc(i64 8)
  store ptr %36, ptr %pay_ptr33, align 8
  %slot_base34 = ptrtoint ptr %36 to i64
  %slot_addr35 = add i64 %slot_base34, 0
  %slot36 = inttoptr i64 %slot_addr35 to ptr
  store i64 2, ptr %slot36, align 8
  %cast37 = ptrtoint ptr %35 to i64
  %slot_base38 = ptrtoint ptr %32 to i64
  %slot_addr39 = add i64 %slot_base38, 8
  %slot40 = inttoptr i64 %slot_addr39 to ptr
  %cast41 = inttoptr i64 %cast37 to ptr
  store ptr %cast41, ptr %slot40, align 8
  %cast42 = ptrtoint ptr %31 to i64
  %slot_base43 = ptrtoint ptr %30 to i64
  %slot_addr44 = add i64 %slot_base43, 0
  %slot45 = inttoptr i64 %slot_addr44 to ptr
  %cast46 = inttoptr i64 %cast42 to ptr
  store ptr %cast46, ptr %slot45, align 8
  %37 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr47 = getelementptr inbounds nuw %Tree, ptr %37, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr47, align 8
  %pay_ptr48 = getelementptr inbounds nuw %Tree, ptr %37, i32 0, i32 1
  %38 = call ptr @avra_rc_alloc(i64 16)
  store ptr %38, ptr %pay_ptr48, align 8
  %39 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr49 = getelementptr inbounds nuw %Tree, ptr %39, i32 0, i32 0
  store i64 6384285405, ptr %tag_ptr49, align 8
  %pay_ptr50 = getelementptr inbounds nuw %Tree, ptr %39, i32 0, i32 1
  %40 = call ptr @avra_rc_alloc(i64 8)
  store ptr %40, ptr %pay_ptr50, align 8
  %slot_base51 = ptrtoint ptr %40 to i64
  %slot_addr52 = add i64 %slot_base51, 0
  %slot53 = inttoptr i64 %slot_addr52 to ptr
  store i64 3, ptr %slot53, align 8
  %cast54 = ptrtoint ptr %39 to i64
  %slot_base55 = ptrtoint ptr %38 to i64
  %slot_addr56 = add i64 %slot_base55, 0
  %slot57 = inttoptr i64 %slot_addr56 to ptr
  %cast58 = inttoptr i64 %cast54 to ptr
  store ptr %cast58, ptr %slot57, align 8
  %41 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr59 = getelementptr inbounds nuw %Tree, ptr %41, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr59, align 8
  %pay_ptr60 = getelementptr inbounds nuw %Tree, ptr %41, i32 0, i32 1
  %42 = call ptr @avra_rc_alloc(i64 16)
  store ptr %42, ptr %pay_ptr60, align 8
  %43 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr61 = getelementptr inbounds nuw %Tree, ptr %43, i32 0, i32 0
  store i64 6384285405, ptr %tag_ptr61, align 8
  %pay_ptr62 = getelementptr inbounds nuw %Tree, ptr %43, i32 0, i32 1
  %44 = call ptr @avra_rc_alloc(i64 8)
  store ptr %44, ptr %pay_ptr62, align 8
  %slot_base63 = ptrtoint ptr %44 to i64
  %slot_addr64 = add i64 %slot_base63, 0
  %slot65 = inttoptr i64 %slot_addr64 to ptr
  store i64 6, ptr %slot65, align 8
  %cast66 = ptrtoint ptr %43 to i64
  %slot_base67 = ptrtoint ptr %42 to i64
  %slot_addr68 = add i64 %slot_base67, 0
  %slot69 = inttoptr i64 %slot_addr68 to ptr
  %cast70 = inttoptr i64 %cast66 to ptr
  store ptr %cast70, ptr %slot69, align 8
  %45 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr71 = getelementptr inbounds nuw %Tree, ptr %45, i32 0, i32 0
  store i64 6384285405, ptr %tag_ptr71, align 8
  %pay_ptr72 = getelementptr inbounds nuw %Tree, ptr %45, i32 0, i32 1
  %46 = call ptr @avra_rc_alloc(i64 8)
  store ptr %46, ptr %pay_ptr72, align 8
  %slot_base73 = ptrtoint ptr %46 to i64
  %slot_addr74 = add i64 %slot_base73, 0
  %slot75 = inttoptr i64 %slot_addr74 to ptr
  store i64 9, ptr %slot75, align 8
  %cast76 = ptrtoint ptr %45 to i64
  %slot_base77 = ptrtoint ptr %42 to i64
  %slot_addr78 = add i64 %slot_base77, 8
  %slot79 = inttoptr i64 %slot_addr78 to ptr
  %cast80 = inttoptr i64 %cast76 to ptr
  store ptr %cast80, ptr %slot79, align 8
  %cast81 = ptrtoint ptr %41 to i64
  %slot_base82 = ptrtoint ptr %38 to i64
  %slot_addr83 = add i64 %slot_base82, 8
  %slot84 = inttoptr i64 %slot_addr83 to ptr
  %cast85 = inttoptr i64 %cast81 to ptr
  store ptr %cast85, ptr %slot84, align 8
  %cast86 = ptrtoint ptr %37 to i64
  %slot_base87 = ptrtoint ptr %30 to i64
  %slot_addr88 = add i64 %slot_base87, 8
  %slot89 = inttoptr i64 %slot_addr88 to ptr
  %cast90 = inttoptr i64 %cast86 to ptr
  store ptr %cast90, ptr %slot89, align 8
  %cast91 = ptrtoint ptr %29 to i64
  %cast92 = inttoptr i64 %cast91 to ptr
  store ptr %cast92, ptr %tree, align 8
  %tree93 = load ptr, ptr %tree, align 8
  %47 = call i64 @sum_tree(ptr %tree93)
  %48 = call ptr @avra_rc_alloc(i64 32)
  %49 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %48, i64 32, ptr @.i2s_fmt.7, i64 %47)
  %widen94 = sext i32 %49 to i64
  %50 = call i64 @strlen(ptr @.str.6)
  %51 = call i64 @strlen(ptr %48)
  %concat_total95 = add i64 %50, %51
  %concat_size96 = add i64 %concat_total95, 1
  %52 = call ptr @avra_rc_alloc(i64 %concat_size96)
  %53 = call ptr @memcpy(ptr %52, ptr @.str.6, i64 %50)
  %cast97 = ptrtoint ptr %52 to i64
  %dst2_int98 = add i64 %cast97, %50
  %cast99 = inttoptr i64 %dst2_int98 to ptr
  %rhs_len_p1100 = add i64 %51, 1
  %54 = call ptr @memcpy(ptr %cast99, ptr %48, i64 %rhs_len_p1100)
  %55 = call i32 @puts(ptr %52)
  %widen101 = sext i32 %55 to i64
  %56 = call ptr @chain_ops(i64 0)
  %tag_ptr102 = getelementptr inbounds nuw %Result__string__string, ptr %56, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr102, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 5862623
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm112, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Result__string__string, ptr %56, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load ptr, ptr %v_slot, align 8
  call void @avra_rc_retain(ptr %v)
  store ptr %v, ptr %v103, align 8
  %v104 = load ptr, ptr %v103, align 8
  %57 = call i64 @strlen(ptr @.str.8)
  %58 = call i64 @strlen(ptr %v104)
  %concat_total105 = add i64 %57, %58
  %concat_size106 = add i64 %concat_total105, 1
  %59 = call ptr @avra_rc_alloc(i64 %concat_size106)
  %60 = call ptr @memcpy(ptr %59, ptr @.str.8, i64 %57)
  %cast107 = ptrtoint ptr %59 to i64
  %dst2_int108 = add i64 %cast107, %57
  %cast109 = inttoptr i64 %dst2_int108 to ptr
  %rhs_len_p1110 = add i64 %58, 1
  %61 = call ptr @memcpy(ptr %cast109, ptr %v104, i64 %rhs_len_p1110)
  %62 = call i32 @puts(ptr %59)
  %widen111 = sext i32 %62 to i64
  store i64 0, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq114 = icmp eq i64 %tag, 193456014
  br i1 %tag_eq114, label %march_arm112, label %march_next113

march_arm112:                                     ; preds = %march_next
  %pay_slot115 = getelementptr inbounds nuw %Result__string__string, ptr %56, i32 0, i32 1
  %payload116 = load ptr, ptr %pay_slot115, align 8
  %e_slot_base = ptrtoint ptr %payload116 to i64
  %e_slot_addr = add i64 %e_slot_base, 0
  %e_slot = inttoptr i64 %e_slot_addr to ptr
  %e = load ptr, ptr %e_slot, align 8
  call void @avra_rc_retain(ptr %e)
  store ptr %e, ptr %e117, align 8
  %e118 = load ptr, ptr %e117, align 8
  %63 = call i64 @strlen(ptr @.str.9)
  %64 = call i64 @strlen(ptr %e118)
  %concat_total119 = add i64 %63, %64
  %concat_size120 = add i64 %concat_total119, 1
  %65 = call ptr @avra_rc_alloc(i64 %concat_size120)
  %66 = call ptr @memcpy(ptr %65, ptr @.str.9, i64 %63)
  %cast121 = ptrtoint ptr %65 to i64
  %dst2_int122 = add i64 %cast121, %63
  %cast123 = inttoptr i64 %dst2_int122 to ptr
  %rhs_len_p1124 = add i64 %64, 1
  %67 = call ptr @memcpy(ptr %cast123, ptr %e118, i64 %rhs_len_p1124)
  %68 = call i32 @puts(ptr %65)
  %widen125 = sext i32 %68 to i64
  store i64 0, ptr %match_result, align 8
  br label %match_end

march_next113:                                    ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn.10, i64 %tag, ptr @mu_file.11, i64 43)
  unreachable
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Tree(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %Tree, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Tree, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Node = icmp eq i64 %tag, 6384368267
  br i1 %is_Node, label %rel_Node, label %try_next_Node

alive:                                            ; preds = %entry
  call void @avra_rc_suspect(ptr %0)
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Node, %vrel_right_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Node:                                         ; preds = %do_free
  %vrel_left_ptr = getelementptr inbounds nuw %Tree__Node, ptr %payload, i32 0, i32 0
  %vrel_left = load ptr, ptr %vrel_left_ptr, align 8
  %vrel_null_left = icmp eq ptr %vrel_left, null
  br i1 %vrel_null_left, label %vrel_left_skip, label %vrel_left_do

try_next_Node:                                    ; preds = %do_free
  br label %fields_done

vrel_left_skip:                                   ; preds = %vrel_left_do, %rel_Node
  %vrel_right_ptr = getelementptr inbounds nuw %Tree__Node, ptr %payload, i32 0, i32 1
  %vrel_right = load ptr, ptr %vrel_right_ptr, align 8
  %vrel_null_right = icmp eq ptr %vrel_right, null
  br i1 %vrel_null_right, label %vrel_right_skip, label %vrel_right_do

vrel_left_do:                                     ; preds = %rel_Node
  %2 = call i64 @__release_Tree(ptr %vrel_left)
  br label %vrel_left_skip

vrel_right_skip:                                  ; preds = %vrel_right_do, %vrel_left_skip
  br label %fields_done

vrel_right_do:                                    ; preds = %vrel_left_skip
  %3 = call i64 @__release_Tree(ptr %vrel_right)
  br label %vrel_right_skip
}

define i64 @__release_Result__string__string(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %Result__string__string, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result__string__string, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Ok = icmp eq i64 %tag, 5862623
  br i1 %is_Ok, label %rel_Ok, label %try_next_Ok

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Err, %vrel_error_skip, %vrel_value_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Ok:                                           ; preds = %do_free
  %vrel_value_ptr = getelementptr inbounds nuw %Result__string__string__Ok, ptr %payload, i32 0, i32 0
  %vrel_value = load ptr, ptr %vrel_value_ptr, align 8
  %vrel_null_value = icmp eq ptr %vrel_value, null
  br i1 %vrel_null_value, label %vrel_value_skip, label %vrel_value_do

try_next_Ok:                                      ; preds = %do_free
  %is_Err = icmp eq i64 %tag, 193456014
  br i1 %is_Err, label %rel_Err, label %try_next_Err

vrel_value_skip:                                  ; preds = %vrel_value_do, %rel_Ok
  br label %fields_done

vrel_value_do:                                    ; preds = %rel_Ok
  call void @avra_rc_release(ptr %vrel_value)
  br label %vrel_value_skip

rel_Err:                                          ; preds = %try_next_Ok
  %vrel_error_ptr = getelementptr inbounds nuw %Result__string__string__Err, ptr %payload, i32 0, i32 0
  %vrel_error = load ptr, ptr %vrel_error_ptr, align 8
  %vrel_null_error = icmp eq ptr %vrel_error, null
  br i1 %vrel_null_error, label %vrel_error_skip, label %vrel_error_do

try_next_Err:                                     ; preds = %try_next_Ok
  br label %fields_done

vrel_error_skip:                                  ; preds = %vrel_error_do, %rel_Err
  br label %fields_done

vrel_error_do:                                    ; preds = %rel_Err
  call void @avra_rc_release(ptr %vrel_error)
  br label %vrel_error_skip
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

define i64 @__lambda_0(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %mul = mul i64 %x1, 2
  ret i64 %mul
}

define i64 @__lambda_1(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %sgt = icmp sgt i64 %x1, 10
  %sgt_ext = zext i1 %sgt to i64
  ret i64 %sgt_ext
}

define i64 @__lambda_2(i64 %0, i64 %1) {
entry:
  %x = alloca i64, align 8
  %acc = alloca i64, align 8
  store i64 %0, ptr %acc, align 8
  store i64 %1, ptr %x, align 8
  %acc1 = load i64, ptr %acc, align 8
  %x2 = load i64, ptr %x, align 8
  %add = add i64 %acc1, %x2
  ret i64 %add
}
