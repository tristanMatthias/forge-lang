; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%CgcmResult = type { i64, ptr }
%CgcmResult__CgcmOk = type { ptr }
%CgcmResult__CgcmErr = type { ptr }

@.str = private unnamed_addr constant [4 x i8] c"bad\00", align 1
@.str.1 = private unnamed_addr constant [13 x i8] c"parse failed\00", align 1
@.str.2 = private unnamed_addr constant [9 x i8] c"length: \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.match_fn = private unnamed_addr constant [13 x i8] c"cgcm_process\00", align 1
@mu_file = private unnamed_addr constant [42 x i8] c"tests/combo_generic_closure_match_test.fg\00", align 1
@.str.3 = private unnamed_addr constant [8 x i8] c"error: \00", align 1
@.match_fn.4 = private unnamed_addr constant [14 x i8] c"cgcm_describe\00", align 1
@mu_file.5 = private unnamed_addr constant [42 x i8] c"tests/combo_generic_closure_match_test.fg\00", align 1
@spec_str = private unnamed_addr constant [30 x i8] c"\22combo generic closure match\22\00", align 1
@spec_str.6 = private unnamed_addr constant [19 x i8] c"\22map doubles list\22\00", align 1
@spec_str.7 = private unnamed_addr constant [21 x i8] c"\22map doubles second\22\00", align 1
@.str.8 = private unnamed_addr constant [4 x i8] c"bad\00", align 1
@.str.9 = private unnamed_addr constant [20 x i8] c"error: parse failed\00", align 1
@spec_str.10 = private unnamed_addr constant [27 x i8] c"\22result error propagation\22\00", align 1
@dz_file = private unnamed_addr constant [42 x i8] c"tests/combo_generic_closure_match_test.fg\00", align 1
@spec_str.11 = private unnamed_addr constant [15 x i8] c"\22filter evens\22\00", align 1
@spec_str.12 = private unnamed_addr constant [28 x i8] c"\22chained map filter reduce\22\00", align 1

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

define ptr @cgcm_try_parse(ptr %0) {
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
  %2 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr3 = getelementptr inbounds nuw %CgcmResult, ptr %2, i32 0, i32 0
  store i64 6952137041561, ptr %tag_ptr3, align 8
  %pay_ptr4 = getelementptr inbounds nuw %CgcmResult, ptr %2, i32 0, i32 1
  %3 = call ptr @forge_rc_alloc(i64 8)
  store ptr %3, ptr %pay_ptr4, align 8
  %s5 = load ptr, ptr %s, align 8
  %4 = call i64 @strlen(ptr %s5)
  %5 = call ptr @forge_rc_alloc(i64 32)
  %6 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %5, i64 32, ptr @.i2s_fmt, i64 %4)
  %widen6 = sext i32 %6 to i64
  %7 = call i64 @strlen(ptr @.str.2)
  %8 = call i64 @strlen(ptr %5)
  %concat_total = add i64 %7, %8
  %concat_size = add i64 %concat_total, 1
  %9 = call ptr @forge_rc_alloc(i64 %concat_size)
  %10 = call ptr @memcpy(ptr %9, ptr @.str.2, i64 %7)
  %cast7 = ptrtoint ptr %9 to i64
  %dst2_int = add i64 %cast7, %7
  %cast8 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %8, 1
  %11 = call ptr @memcpy(ptr %cast8, ptr %5, i64 %rhs_len_p1)
  %slot_base9 = ptrtoint ptr %3 to i64
  %slot_addr10 = add i64 %slot_base9, 0
  %slot11 = inttoptr i64 %slot_addr10 to ptr
  store ptr %9, ptr %slot11, align 8
  %cast12 = ptrtoint ptr %2 to i64
  %cast13 = inttoptr i64 %cast12 to ptr
  ret ptr %cast13

if_then:                                          ; preds = %entry
  %12 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %CgcmResult, ptr %12, i32 0, i32 0
  store i64 229420522360968, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %CgcmResult, ptr %12, i32 0, i32 1
  %13 = call ptr @forge_rc_alloc(i64 8)
  store ptr %13, ptr %pay_ptr, align 8
  %slot_base = ptrtoint ptr %13 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr @.str.1, ptr %slot, align 8
  %cast = ptrtoint ptr %12 to i64
  %cast2 = inttoptr i64 %cast to ptr
  ret ptr %cast2

if_else:                                          ; preds = %entry
  br label %ifcont
}

define ptr @cgcm_process(ptr %0) {
entry:
  %e11 = alloca ptr, align 8
  %v3 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %r = alloca ptr, align 8
  %input = alloca ptr, align 8
  store ptr %0, ptr %input, align 8
  %input1 = load ptr, ptr %input, align 8
  %1 = call ptr @cgcm_try_parse(ptr %input1)
  store ptr %1, ptr %r, align 8
  %r2 = load ptr, ptr %r, align 8
  %tag_ptr = getelementptr inbounds nuw %CgcmResult, ptr %r2, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 6952137041561
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm6, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast19 = inttoptr i64 %match_val to ptr
  ret ptr %cast19

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %CgcmResult, ptr %r2, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load ptr, ptr %v_slot, align 8
  call void @forge_rc_retain(ptr %v)
  store ptr %v, ptr %v3, align 8
  %2 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr4 = getelementptr inbounds nuw %CgcmResult, ptr %2, i32 0, i32 0
  store i64 6952137041561, ptr %tag_ptr4, align 8
  %pay_ptr = getelementptr inbounds nuw %CgcmResult, ptr %2, i32 0, i32 1
  %3 = call ptr @forge_rc_alloc(i64 8)
  store ptr %3, ptr %pay_ptr, align 8
  %v5 = load ptr, ptr %v3, align 8
  %slot_base = ptrtoint ptr %3 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr %v5, ptr %slot, align 8
  %cast = ptrtoint ptr %2 to i64
  store i64 %cast, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq8 = icmp eq i64 %tag, 229420522360968
  br i1 %tag_eq8, label %march_arm6, label %march_next7

march_arm6:                                       ; preds = %march_next
  %pay_slot9 = getelementptr inbounds nuw %CgcmResult, ptr %r2, i32 0, i32 1
  %payload10 = load ptr, ptr %pay_slot9, align 8
  %e_slot_base = ptrtoint ptr %payload10 to i64
  %e_slot_addr = add i64 %e_slot_base, 0
  %e_slot = inttoptr i64 %e_slot_addr to ptr
  %e = load ptr, ptr %e_slot, align 8
  call void @forge_rc_retain(ptr %e)
  store ptr %e, ptr %e11, align 8
  %4 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr12 = getelementptr inbounds nuw %CgcmResult, ptr %4, i32 0, i32 0
  store i64 229420522360968, ptr %tag_ptr12, align 8
  %pay_ptr13 = getelementptr inbounds nuw %CgcmResult, ptr %4, i32 0, i32 1
  %5 = call ptr @forge_rc_alloc(i64 8)
  store ptr %5, ptr %pay_ptr13, align 8
  %e14 = load ptr, ptr %e11, align 8
  %slot_base15 = ptrtoint ptr %5 to i64
  %slot_addr16 = add i64 %slot_base15, 0
  %slot17 = inttoptr i64 %slot_addr16 to ptr
  store ptr %e14, ptr %slot17, align 8
  %cast18 = ptrtoint ptr %4 to i64
  store i64 %cast18, ptr %match_result, align 8
  br label %match_end

march_next7:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 12)
  unreachable
}

define ptr @cgcm_describe(ptr %0) {
entry:
  %e9 = alloca ptr, align 8
  %v2 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %r = alloca ptr, align 8
  store ptr %0, ptr %r, align 8
  %r1 = load ptr, ptr %r, align 8
  %tag_ptr = getelementptr inbounds nuw %CgcmResult, ptr %r1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 6952137041561
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm4, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast14 = inttoptr i64 %match_val to ptr
  ret ptr %cast14

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %CgcmResult, ptr %r1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load ptr, ptr %v_slot, align 8
  call void @forge_rc_retain(ptr %v)
  store ptr %v, ptr %v2, align 8
  %v3 = load ptr, ptr %v2, align 8
  %cast = ptrtoint ptr %v3 to i64
  store i64 %cast, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq6 = icmp eq i64 %tag, 229420522360968
  br i1 %tag_eq6, label %march_arm4, label %march_next5

march_arm4:                                       ; preds = %march_next
  %pay_slot7 = getelementptr inbounds nuw %CgcmResult, ptr %r1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %e_slot_base = ptrtoint ptr %payload8 to i64
  %e_slot_addr = add i64 %e_slot_base, 0
  %e_slot = inttoptr i64 %e_slot_addr to ptr
  %e = load ptr, ptr %e_slot, align 8
  call void @forge_rc_retain(ptr %e)
  store ptr %e, ptr %e9, align 8
  %e10 = load ptr, ptr %e9, align 8
  %1 = call i64 @strlen(ptr @.str.3)
  %2 = call i64 @strlen(ptr %e10)
  %concat_total = add i64 %1, %2
  %concat_size = add i64 %concat_total, 1
  %3 = call ptr @forge_rc_alloc(i64 %concat_size)
  %4 = call ptr @memcpy(ptr %3, ptr @.str.3, i64 %1)
  %cast11 = ptrtoint ptr %3 to i64
  %dst2_int = add i64 %cast11, %1
  %cast12 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %2, 1
  %5 = call ptr @memcpy(ptr %cast12, ptr %e10, i64 %rhs_len_p1)
  %cast13 = ptrtoint ptr %3 to i64
  store i64 %cast13, ptr %match_result, align 8
  br label %match_end

march_next5:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn.4, i64 %tag, ptr @mu_file.5, i64 19)
  unreachable
}

define i64 @main() {
entry:
  %result = alloca i64, align 8
  %evens = alloca ptr, align 8
  %doubled25 = alloca ptr, align 8
  %nums2 = alloca ptr, align 8
  %doubled = alloca ptr, align 8
  %nums = alloca ptr, align 8
  %0 = call i32 @forge_test_start_spec(ptr @spec_str)
  %widen = sext i32 %0 to i64
  %1 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %1, i64 1)
  call void @forge_array_push(ptr %1, i64 2)
  call void @forge_array_push(ptr %1, i64 3)
  store ptr %1, ptr %nums, align 8
  %nums1 = load ptr, ptr %nums, align 8
  %2 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %2, i64 -559038737)
  call void @forge_array_push(ptr %2, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast = ptrtoint ptr %2 to i64
  %3 = call ptr @forge_array_map(ptr %nums1, i64 %cast)
  store ptr %3, ptr %doubled, align 8
  %doubled2 = load ptr, ptr %doubled, align 8
  %4 = call i64 @forge_array_get(ptr %doubled2, i64 0)
  %eq = icmp eq i64 %4, 2
  %eq_ext = zext i1 %eq to i64
  %5 = call i64 @forge_test_run_then(ptr @spec_str.6, i64 %eq_ext)
  %6 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %6, i64 1)
  call void @forge_array_push(ptr %6, i64 2)
  call void @forge_array_push(ptr %6, i64 3)
  store ptr %6, ptr %nums2, align 8
  %nums23 = load ptr, ptr %nums2, align 8
  %7 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %7, i64 -559038737)
  call void @forge_array_push(ptr %7, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cast4 = ptrtoint ptr %7 to i64
  %8 = call ptr @forge_array_map(ptr %nums23, i64 %cast4)
  store ptr %8, ptr %doubled25, align 8
  %doubled26 = load ptr, ptr %doubled25, align 8
  %9 = call i64 @forge_array_get(ptr %doubled26, i64 1)
  %eq7 = icmp eq i64 %9, 4
  %eq_ext8 = zext i1 %eq7 to i64
  %10 = call i64 @forge_test_run_then(ptr @spec_str.7, i64 %eq_ext8)
  %11 = call ptr @cgcm_process(ptr @.str.8)
  %12 = call ptr @cgcm_describe(ptr %11)
  %13 = call i32 @strcmp(ptr %12, ptr @.str.9)
  %widen9 = sext i32 %13 to i64
  %streq_cmp = icmp eq i64 %widen9, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %14 = call i64 @forge_test_run_then(ptr @spec_str.10, i64 %streq_ext)
  %15 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %15, i64 1)
  call void @forge_array_push(ptr %15, i64 2)
  call void @forge_array_push(ptr %15, i64 3)
  call void @forge_array_push(ptr %15, i64 4)
  call void @forge_array_push(ptr %15, i64 5)
  %16 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %16, i64 -559038737)
  call void @forge_array_push(ptr %16, i64 ptrtoint (ptr @__lambda_2 to i64))
  %cast10 = ptrtoint ptr %16 to i64
  %17 = call ptr @forge_array_filter(ptr %15, i64 %cast10)
  store ptr %17, ptr %evens, align 8
  %evens11 = load ptr, ptr %evens, align 8
  %18 = call i64 @forge_array_get(ptr %evens11, i64 0)
  %eq12 = icmp eq i64 %18, 2
  %eq_ext13 = zext i1 %eq12 to i64
  %19 = call i64 @forge_test_run_then(ptr @spec_str.11, i64 %eq_ext13)
  %20 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %20, i64 1)
  call void @forge_array_push(ptr %20, i64 2)
  call void @forge_array_push(ptr %20, i64 3)
  call void @forge_array_push(ptr %20, i64 4)
  call void @forge_array_push(ptr %20, i64 5)
  %21 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %21, i64 -559038737)
  call void @forge_array_push(ptr %21, i64 ptrtoint (ptr @__lambda_3 to i64))
  %cast14 = ptrtoint ptr %21 to i64
  %22 = call ptr @forge_array_map(ptr %20, i64 %cast14)
  %23 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %23, i64 -559038737)
  call void @forge_array_push(ptr %23, i64 ptrtoint (ptr @__lambda_4 to i64))
  %cast15 = ptrtoint ptr %23 to i64
  %24 = call ptr @forge_array_filter(ptr %22, i64 %cast15)
  %25 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %25, i64 -559038737)
  call void @forge_array_push(ptr %25, i64 ptrtoint (ptr @__lambda_5 to i64))
  %cast16 = ptrtoint ptr %25 to i64
  %26 = call i64 @forge_array_reduce(ptr %24, i64 0, i64 %cast16)
  store i64 %26, ptr %result, align 8
  %result17 = load i64, ptr %result, align 8
  %eq18 = icmp eq i64 %result17, 24
  %eq_ext19 = zext i1 %eq18 to i64
  %27 = call i64 @forge_test_run_then(ptr @spec_str.12, i64 %eq_ext19)
  %28 = call i32 @forge_test_end_spec(ptr @spec_str)
  %widen20 = sext i32 %28 to i64
  %29 = call i32 @forge_test_summary()
  %widen21 = sext i32 %29 to i64
  call void @forge_rc_collect()
  ret i64 0
}

define i64 @__release_CgcmResult(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %CgcmResult, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %CgcmResult, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_CgcmOk = icmp eq i64 %tag, 6952137041561
  br i1 %is_CgcmOk, label %rel_CgcmOk, label %try_next_CgcmOk

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_CgcmErr, %vrel_error_skip, %vrel_value_skip
  call void @forge_rc_free(ptr %0)
  br label %done

rel_CgcmOk:                                       ; preds = %do_free
  %vrel_value_ptr = getelementptr inbounds nuw %CgcmResult__CgcmOk, ptr %payload, i32 0, i32 0
  %vrel_value = load ptr, ptr %vrel_value_ptr, align 8
  %vrel_null_value = icmp eq ptr %vrel_value, null
  br i1 %vrel_null_value, label %vrel_value_skip, label %vrel_value_do

try_next_CgcmOk:                                  ; preds = %do_free
  %is_CgcmErr = icmp eq i64 %tag, 229420522360968
  br i1 %is_CgcmErr, label %rel_CgcmErr, label %try_next_CgcmErr

vrel_value_skip:                                  ; preds = %vrel_value_do, %rel_CgcmOk
  br label %fields_done

vrel_value_do:                                    ; preds = %rel_CgcmOk
  call void @forge_rc_release(ptr %vrel_value)
  br label %vrel_value_skip

rel_CgcmErr:                                      ; preds = %try_next_CgcmOk
  %vrel_error_ptr = getelementptr inbounds nuw %CgcmResult__CgcmErr, ptr %payload, i32 0, i32 0
  %vrel_error = load ptr, ptr %vrel_error_ptr, align 8
  %vrel_null_error = icmp eq ptr %vrel_error, null
  br i1 %vrel_null_error, label %vrel_error_skip, label %vrel_error_do

try_next_CgcmErr:                                 ; preds = %try_next_CgcmOk
  br label %fields_done

vrel_error_skip:                                  ; preds = %vrel_error_do, %rel_CgcmErr
  br label %fields_done

vrel_error_do:                                    ; preds = %rel_CgcmErr
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
  %mul = mul i64 %x1, 2
  ret i64 %mul
}

define i64 @__lambda_2(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  call void @forge_div_by_zero_trap(i64 0, ptr @dz_file, i64 41, i64 40)
  %mod = srem i64 %x1, 2
  %eq = icmp eq i64 %mod, 0
  %eq_ext = zext i1 %eq to i64
  ret i64 %eq_ext
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
  %sgt = icmp sgt i64 %x1, 4
  %sgt_ext = zext i1 %sgt to i64
  ret i64 %sgt_ext
}

define i64 @__lambda_5(i64 %0, i64 %1) {
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
