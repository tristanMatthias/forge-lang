; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Result__int__string = type { i64, ptr }
%Result__string__string = type { i64, ptr }
%Result__string__string__Ok = type { ptr }
%Result__string__string__Err = type { ptr }
%Result__int__string__Err = type { ptr }

@.str = private unnamed_addr constant [4 x i8] c"bad\00", align 1
@.str.1 = private unnamed_addr constant [13 x i8] c"parse failed\00", align 1
@.str.2 = private unnamed_addr constant [9 x i8] c"length: \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.3 = private unnamed_addr constant [11 x i8] c"doubled: [\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.5 = private unnamed_addr constant [3 x i8] c", \00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.7 = private unnamed_addr constant [3 x i8] c", \00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.9 = private unnamed_addr constant [2 x i8] c"]\00", align 1
@.str.10 = private unnamed_addr constant [4 x i8] c"bad\00", align 1
@.str.11 = private unnamed_addr constant [17 x i8] c"error propagated\00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [114 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_generic_closure_match.av\00", align 1
@dz_file = private unnamed_addr constant [114 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/combo_generic_closure_match.av\00", align 1
@.str.12 = private unnamed_addr constant [12 x i8] c"filtered: [\00", align 1
@.i2s_fmt.13 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.14 = private unnamed_addr constant [3 x i8] c", \00", align 1
@.i2s_fmt.15 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.16 = private unnamed_addr constant [2 x i8] c"]\00", align 1
@.str.17 = private unnamed_addr constant [10 x i8] c"chained: \00", align 1
@.i2s_fmt.18 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define ptr @try_parse(ptr %0) {
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
  store i64 5862623, ptr %tag_ptr3, align 8
  %pay_ptr4 = getelementptr inbounds nuw %Result__int__string, ptr %2, i32 0, i32 1
  %3 = call ptr @avra_rc_alloc(i64 8)
  store ptr %3, ptr %pay_ptr4, align 8
  %s5 = load ptr, ptr %s, align 8
  %4 = call i64 @strlen(ptr %s5)
  %slot_base6 = ptrtoint ptr %3 to i64
  %slot_addr7 = add i64 %slot_base6, 0
  %slot8 = inttoptr i64 %slot_addr7 to ptr
  store i64 %4, ptr %slot8, align 8
  %cast9 = ptrtoint ptr %2 to i64
  %cast10 = inttoptr i64 %cast9 to ptr
  %ret_tag_ptr = getelementptr inbounds nuw %Result__int__string, ptr %cast10, i32 0, i32 0
  %ret_tag = load i64, ptr %ret_tag_ptr, align 8
  %is_err_ret = icmp eq i64 %ret_tag, 193456014
  br i1 %is_err_ret, label %errdefer_path, label %defer_path

if_then:                                          ; preds = %entry
  %5 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Result__int__string, ptr %5, i32 0, i32 0
  store i64 193456014, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result__int__string, ptr %5, i32 0, i32 1
  %6 = call ptr @avra_rc_alloc(i64 8)
  store ptr %6, ptr %pay_ptr, align 8
  %slot_base = ptrtoint ptr %6 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr @.str.1, ptr %slot, align 8
  %cast = ptrtoint ptr %5 to i64
  %cast2 = inttoptr i64 %cast to ptr
  ret ptr %cast2

if_else:                                          ; preds = %entry
  br label %ifcont

errdefer_path:                                    ; preds = %ifcont
  br label %defer_done

defer_path:                                       ; preds = %ifcont
  br label %defer_done

defer_done:                                       ; preds = %defer_path, %errdefer_path
  %cast11 = inttoptr i64 %cast9 to ptr
  ret ptr %cast11
}

define ptr @process(ptr %0) {
entry:
  %len = alloca i64, align 8
  %input = alloca ptr, align 8
  store ptr %0, ptr %input, align 8
  %input1 = load ptr, ptr %input, align 8
  %1 = call ptr @try_parse(ptr %input1)
  %try_tag_ptr = getelementptr inbounds nuw %Result__int__string, ptr %1, i32 0, i32 0
  %try_tag = load i64, ptr %try_tag_ptr, align 8
  %try_is_ok = icmp eq i64 %try_tag, 5862623
  br i1 %try_is_ok, label %try_ok, label %try_err

try_ok:                                           ; preds = %entry
  %try_pay_slot = getelementptr inbounds nuw %Result__int__string, ptr %1, i32 0, i32 1
  %try_payload = load ptr, ptr %try_pay_slot, align 8
  %try_ok_val = load i64, ptr %try_payload, align 8
  store i64 %try_ok_val, ptr %len, align 8
  %2 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Result__string__string, ptr %2, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result__string__string, ptr %2, i32 0, i32 1
  %3 = call ptr @avra_rc_alloc(i64 8)
  store ptr %3, ptr %pay_ptr, align 8
  %len2 = load i64, ptr %len, align 8
  %4 = call ptr @avra_rc_alloc(i64 32)
  %5 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %4, i64 32, ptr @.i2s_fmt, i64 %len2)
  %widen = sext i32 %5 to i64
  %6 = call i64 @strlen(ptr @.str.2)
  %7 = call i64 @strlen(ptr %4)
  %concat_total = add i64 %6, %7
  %concat_size = add i64 %concat_total, 1
  %8 = call ptr @avra_rc_alloc(i64 %concat_size)
  %9 = call ptr @memcpy(ptr %8, ptr @.str.2, i64 %6)
  %cast = ptrtoint ptr %8 to i64
  %dst2_int = add i64 %cast, %6
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %7, 1
  %10 = call ptr @memcpy(ptr %cast3, ptr %4, i64 %rhs_len_p1)
  %slot_base = ptrtoint ptr %3 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr %8, ptr %slot, align 8
  %cast4 = ptrtoint ptr %2 to i64
  %cast5 = inttoptr i64 %cast4 to ptr
  %ret_tag_ptr = getelementptr inbounds nuw %Result__string__string, ptr %cast5, i32 0, i32 0
  %ret_tag = load i64, ptr %ret_tag_ptr, align 8
  %is_err_ret = icmp eq i64 %ret_tag, 193456014
  br i1 %is_err_ret, label %errdefer_path, label %defer_path

try_err:                                          ; preds = %entry
  ret ptr %1

errdefer_path:                                    ; preds = %try_ok
  br label %defer_done

defer_path:                                       ; preds = %try_ok
  br label %defer_done

defer_done:                                       ; preds = %defer_path, %errdefer_path
  %cast6 = inttoptr i64 %cast4 to ptr
  ret ptr %cast6
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %result = alloca i64, align 8
  %evens = alloca ptr, align 8
  %e48 = alloca ptr, align 8
  %v40 = alloca ptr, align 8
  %match_stmt_discard = alloca i64, align 8
  %doubled = alloca ptr, align 8
  %nums = alloca ptr, align 8
  %1 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %1, i64 1)
  call void @avra_array_push(ptr %1, i64 2)
  call void @avra_array_push(ptr %1, i64 3)
  store ptr %1, ptr %nums, align 8
  %nums1 = load ptr, ptr %nums, align 8
  %2 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %2, i64 -559038737)
  call void @avra_array_push(ptr %2, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast = ptrtoint ptr %2 to i64
  %3 = call ptr @avra_array_map(ptr %nums1, i64 %cast)
  store ptr %3, ptr %doubled, align 8
  %doubled2 = load ptr, ptr %doubled, align 8
  %4 = call i64 @avra_array_get(ptr %doubled2, i64 0)
  %5 = call ptr @avra_rc_alloc(i64 32)
  %6 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %5, i64 32, ptr @.i2s_fmt.4, i64 %4)
  %widen = sext i32 %6 to i64
  %7 = call i64 @strlen(ptr @.str.3)
  %8 = call i64 @strlen(ptr %5)
  %concat_total = add i64 %7, %8
  %concat_size = add i64 %concat_total, 1
  %9 = call ptr @avra_rc_alloc(i64 %concat_size)
  %10 = call ptr @memcpy(ptr %9, ptr @.str.3, i64 %7)
  %cast3 = ptrtoint ptr %9 to i64
  %dst2_int = add i64 %cast3, %7
  %cast4 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %8, 1
  %11 = call ptr @memcpy(ptr %cast4, ptr %5, i64 %rhs_len_p1)
  %12 = call i64 @strlen(ptr %9)
  %13 = call i64 @strlen(ptr @.str.5)
  %concat_total5 = add i64 %12, %13
  %concat_size6 = add i64 %concat_total5, 1
  %14 = call ptr @avra_rc_alloc(i64 %concat_size6)
  %15 = call ptr @memcpy(ptr %14, ptr %9, i64 %12)
  %cast7 = ptrtoint ptr %14 to i64
  %dst2_int8 = add i64 %cast7, %12
  %cast9 = inttoptr i64 %dst2_int8 to ptr
  %rhs_len_p110 = add i64 %13, 1
  %16 = call ptr @memcpy(ptr %cast9, ptr @.str.5, i64 %rhs_len_p110)
  %doubled11 = load ptr, ptr %doubled, align 8
  %17 = call i64 @avra_array_get(ptr %doubled11, i64 1)
  %18 = call ptr @avra_rc_alloc(i64 32)
  %19 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %18, i64 32, ptr @.i2s_fmt.6, i64 %17)
  %widen12 = sext i32 %19 to i64
  %20 = call i64 @strlen(ptr %14)
  %21 = call i64 @strlen(ptr %18)
  %concat_total13 = add i64 %20, %21
  %concat_size14 = add i64 %concat_total13, 1
  %22 = call ptr @avra_rc_alloc(i64 %concat_size14)
  %23 = call ptr @memcpy(ptr %22, ptr %14, i64 %20)
  %cast15 = ptrtoint ptr %22 to i64
  %dst2_int16 = add i64 %cast15, %20
  %cast17 = inttoptr i64 %dst2_int16 to ptr
  %rhs_len_p118 = add i64 %21, 1
  %24 = call ptr @memcpy(ptr %cast17, ptr %18, i64 %rhs_len_p118)
  %25 = call i64 @strlen(ptr %22)
  %26 = call i64 @strlen(ptr @.str.7)
  %concat_total19 = add i64 %25, %26
  %concat_size20 = add i64 %concat_total19, 1
  %27 = call ptr @avra_rc_alloc(i64 %concat_size20)
  %28 = call ptr @memcpy(ptr %27, ptr %22, i64 %25)
  %cast21 = ptrtoint ptr %27 to i64
  %dst2_int22 = add i64 %cast21, %25
  %cast23 = inttoptr i64 %dst2_int22 to ptr
  %rhs_len_p124 = add i64 %26, 1
  %29 = call ptr @memcpy(ptr %cast23, ptr @.str.7, i64 %rhs_len_p124)
  %doubled25 = load ptr, ptr %doubled, align 8
  %30 = call i64 @avra_array_get(ptr %doubled25, i64 2)
  %31 = call ptr @avra_rc_alloc(i64 32)
  %32 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %31, i64 32, ptr @.i2s_fmt.8, i64 %30)
  %widen26 = sext i32 %32 to i64
  %33 = call i64 @strlen(ptr %27)
  %34 = call i64 @strlen(ptr %31)
  %concat_total27 = add i64 %33, %34
  %concat_size28 = add i64 %concat_total27, 1
  %35 = call ptr @avra_rc_alloc(i64 %concat_size28)
  %36 = call ptr @memcpy(ptr %35, ptr %27, i64 %33)
  %cast29 = ptrtoint ptr %35 to i64
  %dst2_int30 = add i64 %cast29, %33
  %cast31 = inttoptr i64 %dst2_int30 to ptr
  %rhs_len_p132 = add i64 %34, 1
  %37 = call ptr @memcpy(ptr %cast31, ptr %31, i64 %rhs_len_p132)
  %38 = call i64 @strlen(ptr %35)
  %39 = call i64 @strlen(ptr @.str.9)
  %concat_total33 = add i64 %38, %39
  %concat_size34 = add i64 %concat_total33, 1
  %40 = call ptr @avra_rc_alloc(i64 %concat_size34)
  %41 = call ptr @memcpy(ptr %40, ptr %35, i64 %38)
  %cast35 = ptrtoint ptr %40 to i64
  %dst2_int36 = add i64 %cast35, %38
  %cast37 = inttoptr i64 %dst2_int36 to ptr
  %rhs_len_p138 = add i64 %39, 1
  %42 = call ptr @memcpy(ptr %cast37, ptr @.str.9, i64 %rhs_len_p138)
  %43 = call i32 @puts(ptr %40)
  %widen39 = sext i32 %43 to i64
  %44 = call ptr @process(ptr @.str.10)
  %tag_ptr = getelementptr inbounds nuw %Result__string__string, ptr %44, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %tag_eq = icmp eq i64 %tag, 5862623
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm43, %march_arm
  %45 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %45, i64 1)
  call void @avra_array_push(ptr %45, i64 2)
  call void @avra_array_push(ptr %45, i64 3)
  call void @avra_array_push(ptr %45, i64 4)
  call void @avra_array_push(ptr %45, i64 5)
  %46 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %46, i64 -559038737)
  call void @avra_array_push(ptr %46, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cast50 = ptrtoint ptr %46 to i64
  %47 = call ptr @avra_array_filter(ptr %45, i64 %cast50)
  store ptr %47, ptr %evens, align 8
  %evens51 = load ptr, ptr %evens, align 8
  %48 = call i64 @avra_array_get(ptr %evens51, i64 0)
  %49 = call ptr @avra_rc_alloc(i64 32)
  %50 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %49, i64 32, ptr @.i2s_fmt.13, i64 %48)
  %widen52 = sext i32 %50 to i64
  %51 = call i64 @strlen(ptr @.str.12)
  %52 = call i64 @strlen(ptr %49)
  %concat_total53 = add i64 %51, %52
  %concat_size54 = add i64 %concat_total53, 1
  %53 = call ptr @avra_rc_alloc(i64 %concat_size54)
  %54 = call ptr @memcpy(ptr %53, ptr @.str.12, i64 %51)
  %cast55 = ptrtoint ptr %53 to i64
  %dst2_int56 = add i64 %cast55, %51
  %cast57 = inttoptr i64 %dst2_int56 to ptr
  %rhs_len_p158 = add i64 %52, 1
  %55 = call ptr @memcpy(ptr %cast57, ptr %49, i64 %rhs_len_p158)
  %56 = call i64 @strlen(ptr %53)
  %57 = call i64 @strlen(ptr @.str.14)
  %concat_total59 = add i64 %56, %57
  %concat_size60 = add i64 %concat_total59, 1
  %58 = call ptr @avra_rc_alloc(i64 %concat_size60)
  %59 = call ptr @memcpy(ptr %58, ptr %53, i64 %56)
  %cast61 = ptrtoint ptr %58 to i64
  %dst2_int62 = add i64 %cast61, %56
  %cast63 = inttoptr i64 %dst2_int62 to ptr
  %rhs_len_p164 = add i64 %57, 1
  %60 = call ptr @memcpy(ptr %cast63, ptr @.str.14, i64 %rhs_len_p164)
  %evens65 = load ptr, ptr %evens, align 8
  %61 = call i64 @avra_array_get(ptr %evens65, i64 1)
  %62 = call ptr @avra_rc_alloc(i64 32)
  %63 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %62, i64 32, ptr @.i2s_fmt.15, i64 %61)
  %widen66 = sext i32 %63 to i64
  %64 = call i64 @strlen(ptr %58)
  %65 = call i64 @strlen(ptr %62)
  %concat_total67 = add i64 %64, %65
  %concat_size68 = add i64 %concat_total67, 1
  %66 = call ptr @avra_rc_alloc(i64 %concat_size68)
  %67 = call ptr @memcpy(ptr %66, ptr %58, i64 %64)
  %cast69 = ptrtoint ptr %66 to i64
  %dst2_int70 = add i64 %cast69, %64
  %cast71 = inttoptr i64 %dst2_int70 to ptr
  %rhs_len_p172 = add i64 %65, 1
  %68 = call ptr @memcpy(ptr %cast71, ptr %62, i64 %rhs_len_p172)
  %69 = call i64 @strlen(ptr %66)
  %70 = call i64 @strlen(ptr @.str.16)
  %concat_total73 = add i64 %69, %70
  %concat_size74 = add i64 %concat_total73, 1
  %71 = call ptr @avra_rc_alloc(i64 %concat_size74)
  %72 = call ptr @memcpy(ptr %71, ptr %66, i64 %69)
  %cast75 = ptrtoint ptr %71 to i64
  %dst2_int76 = add i64 %cast75, %69
  %cast77 = inttoptr i64 %dst2_int76 to ptr
  %rhs_len_p178 = add i64 %70, 1
  %73 = call ptr @memcpy(ptr %cast77, ptr @.str.16, i64 %rhs_len_p178)
  %74 = call i32 @puts(ptr %71)
  %widen79 = sext i32 %74 to i64
  %75 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %75, i64 1)
  call void @avra_array_push(ptr %75, i64 2)
  call void @avra_array_push(ptr %75, i64 3)
  call void @avra_array_push(ptr %75, i64 4)
  call void @avra_array_push(ptr %75, i64 5)
  %76 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %76, i64 -559038737)
  call void @avra_array_push(ptr %76, i64 ptrtoint (ptr @__lambda_2 to i64))
  %cast80 = ptrtoint ptr %76 to i64
  %77 = call ptr @avra_array_map(ptr %75, i64 %cast80)
  %78 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %78, i64 -559038737)
  call void @avra_array_push(ptr %78, i64 ptrtoint (ptr @__lambda_3 to i64))
  %cast81 = ptrtoint ptr %78 to i64
  %79 = call ptr @avra_array_filter(ptr %77, i64 %cast81)
  %80 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %80, i64 -559038737)
  call void @avra_array_push(ptr %80, i64 ptrtoint (ptr @__lambda_4 to i64))
  %cast82 = ptrtoint ptr %80 to i64
  %81 = call i64 @avra_array_reduce(ptr %79, i64 0, i64 %cast82)
  store i64 %81, ptr %result, align 8
  %result83 = load i64, ptr %result, align 8
  %82 = call ptr @avra_rc_alloc(i64 32)
  %83 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %82, i64 32, ptr @.i2s_fmt.18, i64 %result83)
  %widen84 = sext i32 %83 to i64
  %84 = call i64 @strlen(ptr @.str.17)
  %85 = call i64 @strlen(ptr %82)
  %concat_total85 = add i64 %84, %85
  %concat_size86 = add i64 %concat_total85, 1
  %86 = call ptr @avra_rc_alloc(i64 %concat_size86)
  %87 = call ptr @memcpy(ptr %86, ptr @.str.17, i64 %84)
  %cast87 = ptrtoint ptr %86 to i64
  %dst2_int88 = add i64 %cast87, %84
  %cast89 = inttoptr i64 %dst2_int88 to ptr
  %rhs_len_p190 = add i64 %85, 1
  %88 = call ptr @memcpy(ptr %cast89, ptr %82, i64 %rhs_len_p190)
  %89 = call i32 @puts(ptr %86)
  %widen91 = sext i32 %89 to i64
  ret i64 0

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Result__string__string, ptr %44, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load ptr, ptr %v_slot, align 8
  call void @avra_rc_retain(ptr %v)
  store ptr %v, ptr %v40, align 8
  %v41 = load ptr, ptr %v40, align 8
  %90 = call i32 @puts(ptr %v41)
  %widen42 = sext i32 %90 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq45 = icmp eq i64 %tag, 193456014
  br i1 %tag_eq45, label %march_arm43, label %march_next44

march_arm43:                                      ; preds = %march_next
  %pay_slot46 = getelementptr inbounds nuw %Result__string__string, ptr %44, i32 0, i32 1
  %payload47 = load ptr, ptr %pay_slot46, align 8
  %e_slot_base = ptrtoint ptr %payload47 to i64
  %e_slot_addr = add i64 %e_slot_base, 0
  %e_slot = inttoptr i64 %e_slot_addr to ptr
  %e = load ptr, ptr %e_slot, align 8
  call void @avra_rc_retain(ptr %e)
  store ptr %e, ptr %e48, align 8
  %91 = call i32 @puts(ptr @.str.11)
  %widen49 = sext i32 %91 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next44:                                     ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 25)
  unreachable
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
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
  call void @avra_div_by_zero_trap(i64 0, ptr @dz_file, i64 113, i64 31)
  %mod = srem i64 %x1, 2
  %eq = icmp eq i64 %mod, 0
  %eq_ext = zext i1 %eq to i64
  ret i64 %eq_ext
}

define i64 @__lambda_2(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %mul = mul i64 %x1, 2
  ret i64 %mul
}

define i64 @__lambda_3(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %sgt = icmp sgt i64 %x1, 4
  %sgt_ext = zext i1 %sgt to i64
  ret i64 %sgt_ext
}

define i64 @__lambda_4(i64 %0, i64 %1) {
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
