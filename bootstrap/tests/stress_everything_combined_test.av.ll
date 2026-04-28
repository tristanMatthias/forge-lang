; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%SecTree = type { i64, ptr }
%SecResult = type { i64, ptr }
%SecTree__SecNode = type { ptr, ptr }
%SecResult__SecOk = type { ptr }
%SecResult__SecErr = type { ptr }

@.match_fn = private unnamed_addr constant [13 x i8] c"sec_sum_tree\00", align 1
@mu_file = private unnamed_addr constant [41 x i8] c"tests/stress_everything_combined_test.fg\00", align 1
@.str = private unnamed_addr constant [13 x i8] c"divide error\00", align 1
@dz_file = private unnamed_addr constant [41 x i8] c"tests/stress_everything_combined_test.fg\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"result: \00", align 1
@.match_fn.2 = private unnamed_addr constant [14 x i8] c"sec_chain_ops\00", align 1
@mu_file.3 = private unnamed_addr constant [41 x i8] c"tests/stress_everything_combined_test.fg\00", align 1
@.str.4 = private unnamed_addr constant [5 x i8] c"ok: \00", align 1
@.str.5 = private unnamed_addr constant [9 x i8] c"caught: \00", align 1
@.match_fn.6 = private unnamed_addr constant [20 x i8] c"sec_describe_result\00", align 1
@mu_file.7 = private unnamed_addr constant [41 x i8] c"tests/stress_everything_combined_test.fg\00", align 1
@spec_str = private unnamed_addr constant [29 x i8] c"\22stress everything combined\22\00", align 1
@spec_str.8 = private unnamed_addr constant [25 x i8] c"\22pipeline filter reduce\22\00", align 1
@spec_str.9 = private unnamed_addr constant [17 x i8] c"\22pipeline count\22\00", align 1
@spec_str.10 = private unnamed_addr constant [11 x i8] c"\22tree sum\22\00", align 1
@.str.11 = private unnamed_addr constant [21 x i8] c"caught: divide error\00", align 1
@spec_str.12 = private unnamed_addr constant [26 x i8] c"\22error chain div by zero\22\00", align 1

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

define i64 @sec_sum_tree(ptr %0) {
entry:
  %r12 = alloca ptr, align 8
  %l9 = alloca ptr, align 8
  %v2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %t = alloca ptr, align 8
  store ptr %0, ptr %t, align 8
  %t1 = load ptr, ptr %t, align 8
  %tag_ptr = getelementptr inbounds nuw %SecTree, ptr %t1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 229441106426040
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm4, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %SecTree, ptr %t1, i32 0, i32 1
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
  %tag_eq6 = icmp eq i64 %tag, 229441106508902
  br i1 %tag_eq6, label %march_arm4, label %march_next5

march_arm4:                                       ; preds = %march_next
  %pay_slot7 = getelementptr inbounds nuw %SecTree, ptr %t1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %l_slot_base = ptrtoint ptr %payload8 to i64
  %l_slot_addr = add i64 %l_slot_base, 0
  %l_slot = inttoptr i64 %l_slot_addr to ptr
  %l = load ptr, ptr %l_slot, align 8
  call void @forge_rc_retain(ptr %l)
  store ptr %l, ptr %l9, align 8
  %pay_slot10 = getelementptr inbounds nuw %SecTree, ptr %t1, i32 0, i32 1
  %payload11 = load ptr, ptr %pay_slot10, align 8
  %r_slot_base = ptrtoint ptr %payload11 to i64
  %r_slot_addr = add i64 %r_slot_base, 8
  %r_slot = inttoptr i64 %r_slot_addr to ptr
  %r = load ptr, ptr %r_slot, align 8
  call void @forge_rc_retain(ptr %r)
  store ptr %r, ptr %r12, align 8
  %l13 = load ptr, ptr %l9, align 8
  %1 = call i64 @sec_sum_tree(ptr %l13)
  %r14 = load ptr, ptr %r12, align 8
  %2 = call i64 @sec_sum_tree(ptr %r14)
  %add = add i64 %1, %2
  store i64 %add, ptr %match_result, align 8
  br label %match_end

march_next5:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 7)
  unreachable
}

define ptr @sec_safe_div(i64 %0, i64 %1) {
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
  %2 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %SecResult, ptr %2, i32 0, i32 0
  store i64 6952760793609, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %SecResult, ptr %2, i32 0, i32 1
  %3 = call ptr @forge_rc_alloc(i64 8)
  store ptr %3, ptr %pay_ptr, align 8
  %slot_base = ptrtoint ptr %3 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr @.str, ptr %slot, align 8
  %cast = ptrtoint ptr %2 to i64
  store i64 %cast, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %entry
  %4 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr2 = getelementptr inbounds nuw %SecResult, ptr %4, i32 0, i32 0
  store i64 210689721338, ptr %tag_ptr2, align 8
  %pay_ptr3 = getelementptr inbounds nuw %SecResult, ptr %4, i32 0, i32 1
  %5 = call ptr @forge_rc_alloc(i64 8)
  store ptr %5, ptr %pay_ptr3, align 8
  %a4 = load i64, ptr %a, align 8
  %b5 = load i64, ptr %b, align 8
  %dz_chk = icmp eq i64 %b5, 0
  %dz_chk_ext = zext i1 %dz_chk to i64
  call void @forge_div_by_zero_trap(i64 %dz_chk_ext, ptr @dz_file, i64 40, i64 15)
  %div = sdiv i64 %a4, %b5
  %6 = call ptr @forge_rc_alloc(i64 32)
  %7 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %6, i64 32, ptr @.i2s_fmt, i64 %div)
  %widen = sext i32 %7 to i64
  %slot_base6 = ptrtoint ptr %5 to i64
  %slot_addr7 = add i64 %slot_base6, 0
  %slot8 = inttoptr i64 %slot_addr7 to ptr
  store ptr %6, ptr %slot8, align 8
  %cast9 = ptrtoint ptr %4 to i64
  store i64 %cast9, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  %cast10 = inttoptr i64 %sif_val to ptr
  ret ptr %cast10
}

define ptr @sec_chain_ops(i64 %0) {
entry:
  %e13 = alloca ptr, align 8
  %v3 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %a = alloca ptr, align 8
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %1 = call ptr @sec_safe_div(i64 100, i64 %x1)
  store ptr %1, ptr %a, align 8
  %a2 = load ptr, ptr %a, align 8
  %tag_ptr = getelementptr inbounds nuw %SecResult, ptr %a2, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 210689721338
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm8, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast21 = inttoptr i64 %match_val to ptr
  ret ptr %cast21

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %SecResult, ptr %a2, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load ptr, ptr %v_slot, align 8
  call void @forge_rc_retain(ptr %v)
  store ptr %v, ptr %v3, align 8
  %2 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr4 = getelementptr inbounds nuw %SecResult, ptr %2, i32 0, i32 0
  store i64 210689721338, ptr %tag_ptr4, align 8
  %pay_ptr = getelementptr inbounds nuw %SecResult, ptr %2, i32 0, i32 1
  %3 = call ptr @forge_rc_alloc(i64 8)
  store ptr %3, ptr %pay_ptr, align 8
  %v5 = load ptr, ptr %v3, align 8
  %4 = call i64 @strlen(ptr @.str.1)
  %5 = call i64 @strlen(ptr %v5)
  %concat_total = add i64 %4, %5
  %concat_size = add i64 %concat_total, 1
  %6 = call ptr @forge_rc_alloc(i64 %concat_size)
  %7 = call ptr @memcpy(ptr %6, ptr @.str.1, i64 %4)
  %cast = ptrtoint ptr %6 to i64
  %dst2_int = add i64 %cast, %4
  %cast6 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %5, 1
  %8 = call ptr @memcpy(ptr %cast6, ptr %v5, i64 %rhs_len_p1)
  %slot_base = ptrtoint ptr %3 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr %6, ptr %slot, align 8
  %cast7 = ptrtoint ptr %2 to i64
  store i64 %cast7, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq10 = icmp eq i64 %tag, 6952760793609
  br i1 %tag_eq10, label %march_arm8, label %march_next9

march_arm8:                                       ; preds = %march_next
  %pay_slot11 = getelementptr inbounds nuw %SecResult, ptr %a2, i32 0, i32 1
  %payload12 = load ptr, ptr %pay_slot11, align 8
  %e_slot_base = ptrtoint ptr %payload12 to i64
  %e_slot_addr = add i64 %e_slot_base, 0
  %e_slot = inttoptr i64 %e_slot_addr to ptr
  %e = load ptr, ptr %e_slot, align 8
  call void @forge_rc_retain(ptr %e)
  store ptr %e, ptr %e13, align 8
  %9 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr14 = getelementptr inbounds nuw %SecResult, ptr %9, i32 0, i32 0
  store i64 6952760793609, ptr %tag_ptr14, align 8
  %pay_ptr15 = getelementptr inbounds nuw %SecResult, ptr %9, i32 0, i32 1
  %10 = call ptr @forge_rc_alloc(i64 8)
  store ptr %10, ptr %pay_ptr15, align 8
  %e16 = load ptr, ptr %e13, align 8
  %slot_base17 = ptrtoint ptr %10 to i64
  %slot_addr18 = add i64 %slot_base17, 0
  %slot19 = inttoptr i64 %slot_addr18 to ptr
  store ptr %e16, ptr %slot19, align 8
  %cast20 = ptrtoint ptr %9 to i64
  store i64 %cast20, ptr %match_result, align 8
  br label %match_end

march_next9:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn.2, i64 %tag, ptr @mu_file.3, i64 20)
  unreachable
}

define ptr @sec_describe_result(ptr %0) {
entry:
  %e11 = alloca ptr, align 8
  %v2 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %r = alloca ptr, align 8
  store ptr %0, ptr %r, align 8
  %r1 = load ptr, ptr %r, align 8
  %tag_ptr = getelementptr inbounds nuw %SecResult, ptr %r1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 210689721338
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm6, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast20 = inttoptr i64 %match_val to ptr
  ret ptr %cast20

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %SecResult, ptr %r1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load ptr, ptr %v_slot, align 8
  call void @forge_rc_retain(ptr %v)
  store ptr %v, ptr %v2, align 8
  %v3 = load ptr, ptr %v2, align 8
  %1 = call i64 @strlen(ptr @.str.4)
  %2 = call i64 @strlen(ptr %v3)
  %concat_total = add i64 %1, %2
  %concat_size = add i64 %concat_total, 1
  %3 = call ptr @forge_rc_alloc(i64 %concat_size)
  %4 = call ptr @memcpy(ptr %3, ptr @.str.4, i64 %1)
  %cast = ptrtoint ptr %3 to i64
  %dst2_int = add i64 %cast, %1
  %cast4 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %2, 1
  %5 = call ptr @memcpy(ptr %cast4, ptr %v3, i64 %rhs_len_p1)
  %cast5 = ptrtoint ptr %3 to i64
  store i64 %cast5, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq8 = icmp eq i64 %tag, 6952760793609
  br i1 %tag_eq8, label %march_arm6, label %march_next7

march_arm6:                                       ; preds = %march_next
  %pay_slot9 = getelementptr inbounds nuw %SecResult, ptr %r1, i32 0, i32 1
  %payload10 = load ptr, ptr %pay_slot9, align 8
  %e_slot_base = ptrtoint ptr %payload10 to i64
  %e_slot_addr = add i64 %e_slot_base, 0
  %e_slot = inttoptr i64 %e_slot_addr to ptr
  %e = load ptr, ptr %e_slot, align 8
  call void @forge_rc_retain(ptr %e)
  store ptr %e, ptr %e11, align 8
  %e12 = load ptr, ptr %e11, align 8
  %6 = call i64 @strlen(ptr @.str.5)
  %7 = call i64 @strlen(ptr %e12)
  %concat_total13 = add i64 %6, %7
  %concat_size14 = add i64 %concat_total13, 1
  %8 = call ptr @forge_rc_alloc(i64 %concat_size14)
  %9 = call ptr @memcpy(ptr %8, ptr @.str.5, i64 %6)
  %cast15 = ptrtoint ptr %8 to i64
  %dst2_int16 = add i64 %cast15, %6
  %cast17 = inttoptr i64 %dst2_int16 to ptr
  %rhs_len_p118 = add i64 %7, 1
  %10 = call ptr @memcpy(ptr %cast17, ptr %e12, i64 %rhs_len_p118)
  %cast19 = ptrtoint ptr %8 to i64
  store i64 %cast19, ptr %match_result, align 8
  br label %match_end

march_next7:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn.6, i64 %tag, ptr @mu_file.7, i64 27)
  unreachable
}

define i64 @sec_pipeline_total() {
entry:
  %processed1 = alloca ptr, align 8
  %data1 = alloca ptr, align 8
  %0 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %0, i64 5)
  call void @forge_array_push(ptr %0, i64 10)
  call void @forge_array_push(ptr %0, i64 15)
  call void @forge_array_push(ptr %0, i64 20)
  call void @forge_array_push(ptr %0, i64 25)
  store ptr %0, ptr %data1, align 8
  %data11 = load ptr, ptr %data1, align 8
  %1 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %1, i64 -559038737)
  call void @forge_array_push(ptr %1, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast = ptrtoint ptr %1 to i64
  %2 = call ptr @forge_array_map(ptr %data11, i64 %cast)
  %3 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %3, i64 -559038737)
  call void @forge_array_push(ptr %3, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cast2 = ptrtoint ptr %3 to i64
  %4 = call ptr @forge_array_filter(ptr %2, i64 %cast2)
  store ptr %4, ptr %processed1, align 8
  %processed13 = load ptr, ptr %processed1, align 8
  %5 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %5, i64 -559038737)
  call void @forge_array_push(ptr %5, i64 ptrtoint (ptr @__lambda_2 to i64))
  %cast4 = ptrtoint ptr %5 to i64
  %6 = call i64 @forge_array_reduce(ptr %processed13, i64 0, i64 %cast4)
  ret i64 %6
}

define i64 @sec_pipeline_count() {
entry:
  %processed2 = alloca ptr, align 8
  %data2 = alloca ptr, align 8
  %0 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %0, i64 5)
  call void @forge_array_push(ptr %0, i64 10)
  call void @forge_array_push(ptr %0, i64 15)
  call void @forge_array_push(ptr %0, i64 20)
  call void @forge_array_push(ptr %0, i64 25)
  store ptr %0, ptr %data2, align 8
  %data21 = load ptr, ptr %data2, align 8
  %1 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %1, i64 -559038737)
  call void @forge_array_push(ptr %1, i64 ptrtoint (ptr @__lambda_3 to i64))
  %cast = ptrtoint ptr %1 to i64
  %2 = call ptr @forge_array_map(ptr %data21, i64 %cast)
  %3 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %3, i64 -559038737)
  call void @forge_array_push(ptr %3, i64 ptrtoint (ptr @__lambda_4 to i64))
  %cast2 = ptrtoint ptr %3 to i64
  %4 = call ptr @forge_array_filter(ptr %2, i64 %cast2)
  store ptr %4, ptr %processed2, align 8
  %processed23 = load ptr, ptr %processed2, align 8
  %5 = call i64 @forge_array_len(ptr %processed23)
  ret i64 %5
}

define i64 @main() {
entry:
  %tree = alloca ptr, align 8
  %0 = call i32 @forge_test_start_spec(ptr @spec_str)
  %widen = sext i32 %0 to i64
  %1 = call i64 @sec_pipeline_total()
  %eq = icmp eq i64 %1, 140
  %eq_ext = zext i1 %eq to i64
  %2 = call i64 @forge_test_run_then(ptr @spec_str.8, i64 %eq_ext)
  %3 = call i64 @sec_pipeline_count()
  %eq1 = icmp eq i64 %3, 4
  %eq_ext2 = zext i1 %eq1 to i64
  %4 = call i64 @forge_test_run_then(ptr @spec_str.9, i64 %eq_ext2)
  %5 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %SecTree, ptr %5, i32 0, i32 0
  store i64 229441106508902, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %SecTree, ptr %5, i32 0, i32 1
  %6 = call ptr @forge_rc_alloc(i64 16)
  store ptr %6, ptr %pay_ptr, align 8
  %7 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr3 = getelementptr inbounds nuw %SecTree, ptr %7, i32 0, i32 0
  store i64 229441106508902, ptr %tag_ptr3, align 8
  %pay_ptr4 = getelementptr inbounds nuw %SecTree, ptr %7, i32 0, i32 1
  %8 = call ptr @forge_rc_alloc(i64 16)
  store ptr %8, ptr %pay_ptr4, align 8
  %9 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr5 = getelementptr inbounds nuw %SecTree, ptr %9, i32 0, i32 0
  store i64 229441106426040, ptr %tag_ptr5, align 8
  %pay_ptr6 = getelementptr inbounds nuw %SecTree, ptr %9, i32 0, i32 1
  %10 = call ptr @forge_rc_alloc(i64 8)
  store ptr %10, ptr %pay_ptr6, align 8
  %slot_base = ptrtoint ptr %10 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 1, ptr %slot, align 8
  %cast = ptrtoint ptr %9 to i64
  %slot_base7 = ptrtoint ptr %8 to i64
  %slot_addr8 = add i64 %slot_base7, 0
  %slot9 = inttoptr i64 %slot_addr8 to ptr
  %cast10 = inttoptr i64 %cast to ptr
  store ptr %cast10, ptr %slot9, align 8
  %11 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr11 = getelementptr inbounds nuw %SecTree, ptr %11, i32 0, i32 0
  store i64 229441106426040, ptr %tag_ptr11, align 8
  %pay_ptr12 = getelementptr inbounds nuw %SecTree, ptr %11, i32 0, i32 1
  %12 = call ptr @forge_rc_alloc(i64 8)
  store ptr %12, ptr %pay_ptr12, align 8
  %slot_base13 = ptrtoint ptr %12 to i64
  %slot_addr14 = add i64 %slot_base13, 0
  %slot15 = inttoptr i64 %slot_addr14 to ptr
  store i64 2, ptr %slot15, align 8
  %cast16 = ptrtoint ptr %11 to i64
  %slot_base17 = ptrtoint ptr %8 to i64
  %slot_addr18 = add i64 %slot_base17, 8
  %slot19 = inttoptr i64 %slot_addr18 to ptr
  %cast20 = inttoptr i64 %cast16 to ptr
  store ptr %cast20, ptr %slot19, align 8
  %cast21 = ptrtoint ptr %7 to i64
  %slot_base22 = ptrtoint ptr %6 to i64
  %slot_addr23 = add i64 %slot_base22, 0
  %slot24 = inttoptr i64 %slot_addr23 to ptr
  %cast25 = inttoptr i64 %cast21 to ptr
  store ptr %cast25, ptr %slot24, align 8
  %13 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr26 = getelementptr inbounds nuw %SecTree, ptr %13, i32 0, i32 0
  store i64 229441106508902, ptr %tag_ptr26, align 8
  %pay_ptr27 = getelementptr inbounds nuw %SecTree, ptr %13, i32 0, i32 1
  %14 = call ptr @forge_rc_alloc(i64 16)
  store ptr %14, ptr %pay_ptr27, align 8
  %15 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr28 = getelementptr inbounds nuw %SecTree, ptr %15, i32 0, i32 0
  store i64 229441106426040, ptr %tag_ptr28, align 8
  %pay_ptr29 = getelementptr inbounds nuw %SecTree, ptr %15, i32 0, i32 1
  %16 = call ptr @forge_rc_alloc(i64 8)
  store ptr %16, ptr %pay_ptr29, align 8
  %slot_base30 = ptrtoint ptr %16 to i64
  %slot_addr31 = add i64 %slot_base30, 0
  %slot32 = inttoptr i64 %slot_addr31 to ptr
  store i64 3, ptr %slot32, align 8
  %cast33 = ptrtoint ptr %15 to i64
  %slot_base34 = ptrtoint ptr %14 to i64
  %slot_addr35 = add i64 %slot_base34, 0
  %slot36 = inttoptr i64 %slot_addr35 to ptr
  %cast37 = inttoptr i64 %cast33 to ptr
  store ptr %cast37, ptr %slot36, align 8
  %17 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr38 = getelementptr inbounds nuw %SecTree, ptr %17, i32 0, i32 0
  store i64 229441106508902, ptr %tag_ptr38, align 8
  %pay_ptr39 = getelementptr inbounds nuw %SecTree, ptr %17, i32 0, i32 1
  %18 = call ptr @forge_rc_alloc(i64 16)
  store ptr %18, ptr %pay_ptr39, align 8
  %19 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr40 = getelementptr inbounds nuw %SecTree, ptr %19, i32 0, i32 0
  store i64 229441106426040, ptr %tag_ptr40, align 8
  %pay_ptr41 = getelementptr inbounds nuw %SecTree, ptr %19, i32 0, i32 1
  %20 = call ptr @forge_rc_alloc(i64 8)
  store ptr %20, ptr %pay_ptr41, align 8
  %slot_base42 = ptrtoint ptr %20 to i64
  %slot_addr43 = add i64 %slot_base42, 0
  %slot44 = inttoptr i64 %slot_addr43 to ptr
  store i64 6, ptr %slot44, align 8
  %cast45 = ptrtoint ptr %19 to i64
  %slot_base46 = ptrtoint ptr %18 to i64
  %slot_addr47 = add i64 %slot_base46, 0
  %slot48 = inttoptr i64 %slot_addr47 to ptr
  %cast49 = inttoptr i64 %cast45 to ptr
  store ptr %cast49, ptr %slot48, align 8
  %21 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr50 = getelementptr inbounds nuw %SecTree, ptr %21, i32 0, i32 0
  store i64 229441106426040, ptr %tag_ptr50, align 8
  %pay_ptr51 = getelementptr inbounds nuw %SecTree, ptr %21, i32 0, i32 1
  %22 = call ptr @forge_rc_alloc(i64 8)
  store ptr %22, ptr %pay_ptr51, align 8
  %slot_base52 = ptrtoint ptr %22 to i64
  %slot_addr53 = add i64 %slot_base52, 0
  %slot54 = inttoptr i64 %slot_addr53 to ptr
  store i64 9, ptr %slot54, align 8
  %cast55 = ptrtoint ptr %21 to i64
  %slot_base56 = ptrtoint ptr %18 to i64
  %slot_addr57 = add i64 %slot_base56, 8
  %slot58 = inttoptr i64 %slot_addr57 to ptr
  %cast59 = inttoptr i64 %cast55 to ptr
  store ptr %cast59, ptr %slot58, align 8
  %cast60 = ptrtoint ptr %17 to i64
  %slot_base61 = ptrtoint ptr %14 to i64
  %slot_addr62 = add i64 %slot_base61, 8
  %slot63 = inttoptr i64 %slot_addr62 to ptr
  %cast64 = inttoptr i64 %cast60 to ptr
  store ptr %cast64, ptr %slot63, align 8
  %cast65 = ptrtoint ptr %13 to i64
  %slot_base66 = ptrtoint ptr %6 to i64
  %slot_addr67 = add i64 %slot_base66, 8
  %slot68 = inttoptr i64 %slot_addr67 to ptr
  %cast69 = inttoptr i64 %cast65 to ptr
  store ptr %cast69, ptr %slot68, align 8
  %cast70 = ptrtoint ptr %5 to i64
  %cast71 = inttoptr i64 %cast70 to ptr
  store ptr %cast71, ptr %tree, align 8
  %tree72 = load ptr, ptr %tree, align 8
  %23 = call i64 @sec_sum_tree(ptr %tree72)
  %eq73 = icmp eq i64 %23, 21
  %eq_ext74 = zext i1 %eq73 to i64
  %24 = call i64 @forge_test_run_then(ptr @spec_str.10, i64 %eq_ext74)
  %25 = call ptr @sec_chain_ops(i64 0)
  %26 = call ptr @sec_describe_result(ptr %25)
  %27 = call i32 @strcmp(ptr %26, ptr @.str.11)
  %widen75 = sext i32 %27 to i64
  %streq_cmp = icmp eq i64 %widen75, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %28 = call i64 @forge_test_run_then(ptr @spec_str.12, i64 %streq_ext)
  %29 = call i32 @forge_test_end_spec(ptr @spec_str)
  %widen76 = sext i32 %29 to i64
  %30 = call i32 @forge_test_summary()
  %widen77 = sext i32 %30 to i64
  call void @forge_rc_collect()
  ret i64 0
}

define i64 @__release_SecTree(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %SecTree, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %SecTree, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_SecNode = icmp eq i64 %tag, 229441106508902
  br i1 %is_SecNode, label %rel_SecNode, label %try_next_SecNode

alive:                                            ; preds = %entry
  call void @forge_rc_suspect(ptr %0)
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_SecNode, %vrel_right_skip
  call void @forge_rc_free(ptr %0)
  br label %done

rel_SecNode:                                      ; preds = %do_free
  %vrel_left_ptr = getelementptr inbounds nuw %SecTree__SecNode, ptr %payload, i32 0, i32 0
  %vrel_left = load ptr, ptr %vrel_left_ptr, align 8
  %vrel_null_left = icmp eq ptr %vrel_left, null
  br i1 %vrel_null_left, label %vrel_left_skip, label %vrel_left_do

try_next_SecNode:                                 ; preds = %do_free
  br label %fields_done

vrel_left_skip:                                   ; preds = %vrel_left_do, %rel_SecNode
  %vrel_right_ptr = getelementptr inbounds nuw %SecTree__SecNode, ptr %payload, i32 0, i32 1
  %vrel_right = load ptr, ptr %vrel_right_ptr, align 8
  %vrel_null_right = icmp eq ptr %vrel_right, null
  br i1 %vrel_null_right, label %vrel_right_skip, label %vrel_right_do

vrel_left_do:                                     ; preds = %rel_SecNode
  %2 = call i64 @__release_SecTree(ptr %vrel_left)
  br label %vrel_left_skip

vrel_right_skip:                                  ; preds = %vrel_right_do, %vrel_left_skip
  br label %fields_done

vrel_right_do:                                    ; preds = %vrel_left_skip
  %3 = call i64 @__release_SecTree(ptr %vrel_right)
  br label %vrel_right_skip
}

define i64 @__release_SecResult(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %SecResult, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %SecResult, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_SecOk = icmp eq i64 %tag, 210689721338
  br i1 %is_SecOk, label %rel_SecOk, label %try_next_SecOk

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_SecErr, %vrel_error_skip, %vrel_value_skip
  call void @forge_rc_free(ptr %0)
  br label %done

rel_SecOk:                                        ; preds = %do_free
  %vrel_value_ptr = getelementptr inbounds nuw %SecResult__SecOk, ptr %payload, i32 0, i32 0
  %vrel_value = load ptr, ptr %vrel_value_ptr, align 8
  %vrel_null_value = icmp eq ptr %vrel_value, null
  br i1 %vrel_null_value, label %vrel_value_skip, label %vrel_value_do

try_next_SecOk:                                   ; preds = %do_free
  %is_SecErr = icmp eq i64 %tag, 6952760793609
  br i1 %is_SecErr, label %rel_SecErr, label %try_next_SecErr

vrel_value_skip:                                  ; preds = %vrel_value_do, %rel_SecOk
  br label %fields_done

vrel_value_do:                                    ; preds = %rel_SecOk
  call void @forge_rc_release(ptr %vrel_value)
  br label %vrel_value_skip

rel_SecErr:                                       ; preds = %try_next_SecOk
  %vrel_error_ptr = getelementptr inbounds nuw %SecResult__SecErr, ptr %payload, i32 0, i32 0
  %vrel_error = load ptr, ptr %vrel_error_ptr, align 8
  %vrel_null_error = icmp eq ptr %vrel_error, null
  br i1 %vrel_null_error, label %vrel_error_skip, label %vrel_error_do

try_next_SecErr:                                  ; preds = %try_next_SecOk
  br label %fields_done

vrel_error_skip:                                  ; preds = %vrel_error_do, %rel_SecErr
  br label %fields_done

vrel_error_do:                                    ; preds = %rel_SecErr
  call void @forge_rc_release(ptr %vrel_error)
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

define i64 @__lambda_3(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %mul = mul i64 %x1, 2
  ret i64 %mul
}

define i64 @__lambda_4(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %sgt = icmp sgt i64 %x1, 10
  %sgt_ext = zext i1 %sgt to i64
  ret i64 %sgt_ext
}
