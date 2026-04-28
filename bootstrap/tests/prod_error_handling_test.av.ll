; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%PehParseResult = type { i64, ptr }
%PehParseResult__PehErr = type { ptr }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.1 = private unnamed_addr constant [13 x i8] c"empty string\00", align 1
@dz_file = private unnamed_addr constant [34 x i8] c"tests/prod_error_handling_test.fg\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c" -> \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.3 = private unnamed_addr constant [8 x i8] c" / 2 = \00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.5 = private unnamed_addr constant [8 x i8] c"error: \00", align 1
@.match_fn = private unnamed_addr constant [12 x i8] c"peh_process\00", align 1
@mu_file = private unnamed_addr constant [34 x i8] c"tests/prod_error_handling_test.fg\00", align 1
@spec_str = private unnamed_addr constant [22 x i8] c"\22prod error handling\22\00", align 1
@.str.6 = private unnamed_addr constant [3 x i8] c"42\00", align 1
@.str.7 = private unnamed_addr constant [18 x i8] c"42 -> 42 / 2 = 21\00", align 1
@spec_str.8 = private unnamed_addr constant [11 x i8] c"\22parse 42\22\00", align 1
@.str.9 = private unnamed_addr constant [4 x i8] c"100\00", align 1
@.str.10 = private unnamed_addr constant [20 x i8] c"100 -> 100 / 2 = 50\00", align 1
@spec_str.11 = private unnamed_addr constant [12 x i8] c"\22parse 100\22\00", align 1
@.str.12 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.13 = private unnamed_addr constant [20 x i8] c"error: empty string\00", align 1
@spec_str.14 = private unnamed_addr constant [14 x i8] c"\22parse empty\22\00", align 1
@.str.15 = private unnamed_addr constant [2 x i8] c"7\00", align 1
@.str.16 = private unnamed_addr constant [15 x i8] c"7 -> 7 / 2 = 3\00", align 1
@spec_str.17 = private unnamed_addr constant [10 x i8] c"\22parse 7\22\00", align 1
@spec_str.18 = private unnamed_addr constant [28 x i8] c"\22nullable pipeline success\22\00", align 1
@spec_str.19 = private unnamed_addr constant [31 x i8] c"\22nullable pipeline fail step1\22\00", align 1
@spec_str.20 = private unnamed_addr constant [31 x i8] c"\22nullable pipeline fail step2\22\00", align 1

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

define ptr @peh_parse_int(ptr %0) {
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
  %tag_ptr3 = getelementptr inbounds nuw %PehParseResult, ptr %2, i32 0, i32 0
  store i64 210686169020, ptr %tag_ptr3, align 8
  %pay_ptr4 = getelementptr inbounds nuw %PehParseResult, ptr %2, i32 0, i32 1
  %3 = call ptr @forge_rc_alloc(i64 8)
  store ptr %3, ptr %pay_ptr4, align 8
  %s5 = load ptr, ptr %s, align 8
  %4 = call i32 @atoi(ptr %s5)
  %widen6 = sext i32 %4 to i64
  %slot_base7 = ptrtoint ptr %3 to i64
  %slot_addr8 = add i64 %slot_base7, 0
  %slot9 = inttoptr i64 %slot_addr8 to ptr
  store i64 %widen6, ptr %slot9, align 8
  %cast10 = ptrtoint ptr %2 to i64
  %cast11 = inttoptr i64 %cast10 to ptr
  ret ptr %cast11

if_then:                                          ; preds = %entry
  %5 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %PehParseResult, ptr %5, i32 0, i32 0
  store i64 6952643567115, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %PehParseResult, ptr %5, i32 0, i32 1
  %6 = call ptr @forge_rc_alloc(i64 8)
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
}

define i64 @peh_safe_divide(i64 %0, i64 %1) {
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
  %a2 = load i64, ptr %a, align 8
  %b3 = load i64, ptr %b, align 8
  %dz_chk = icmp eq i64 %b3, 0
  %dz_chk_ext = zext i1 %dz_chk to i64
  call void @forge_div_by_zero_trap(i64 %dz_chk_ext, ptr @dz_file, i64 33, i64 15)
  %div = sdiv i64 %a2, %b3
  ret i64 %div

if_then:                                          ; preds = %entry
  ret i64 0

if_else:                                          ; preds = %entry
  br label %ifcont
}

define ptr @peh_process(ptr %0) {
entry:
  %msg34 = alloca ptr, align 8
  %half = alloca i64, align 8
  %nc_result = alloca i64, align 8
  %v3 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %parsed = alloca ptr, align 8
  %input = alloca ptr, align 8
  store ptr %0, ptr %input, align 8
  %input1 = load ptr, ptr %input, align 8
  %1 = call ptr @peh_parse_int(ptr %input1)
  store ptr %1, ptr %parsed, align 8
  %parsed2 = load ptr, ptr %parsed, align 8
  %tag_ptr = getelementptr inbounds nuw %PehParseResult, ptr %parsed2, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 210686169020
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm29, %nc_end
  %match_val = load i64, ptr %match_result, align 8
  %cast43 = inttoptr i64 %match_val to ptr
  ret ptr %cast43

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %PehParseResult, ptr %parsed2, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load i64, ptr %v_slot, align 8
  store i64 %v, ptr %v3, align 8
  %v4 = load i64, ptr %v3, align 8
  %2 = call i64 @peh_safe_divide(i64 %v4, i64 2)
  %nc_null = icmp eq i64 %2, 0
  store i64 %2, ptr %nc_result, align 8
  br i1 %nc_null, label %nc_rhs, label %nc_end

march_next:                                       ; preds = %entry
  %tag_eq31 = icmp eq i64 %tag, 6952643567115
  br i1 %tag_eq31, label %march_arm29, label %march_next30

nc_rhs:                                           ; preds = %march_arm
  store i64 -1, ptr %nc_result, align 8
  br label %nc_end

nc_end:                                           ; preds = %nc_rhs, %march_arm
  %nc_val = load i64, ptr %nc_result, align 8
  store i64 %nc_val, ptr %half, align 8
  %input5 = load ptr, ptr %input, align 8
  %3 = call i64 @strlen(ptr %input5)
  %4 = call i64 @strlen(ptr @.str.2)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @forge_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr %input5, i64 %3)
  %cast = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast, %3
  %cast6 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast6, ptr @.str.2, i64 %rhs_len_p1)
  %v7 = load i64, ptr %v3, align 8
  %8 = call ptr @forge_rc_alloc(i64 32)
  %9 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %8, i64 32, ptr @.i2s_fmt, i64 %v7)
  %widen = sext i32 %9 to i64
  %10 = call i64 @strlen(ptr %5)
  %11 = call i64 @strlen(ptr %8)
  %concat_total8 = add i64 %10, %11
  %concat_size9 = add i64 %concat_total8, 1
  %12 = call ptr @forge_rc_alloc(i64 %concat_size9)
  %13 = call ptr @memcpy(ptr %12, ptr %5, i64 %10)
  %cast10 = ptrtoint ptr %12 to i64
  %dst2_int11 = add i64 %cast10, %10
  %cast12 = inttoptr i64 %dst2_int11 to ptr
  %rhs_len_p113 = add i64 %11, 1
  %14 = call ptr @memcpy(ptr %cast12, ptr %8, i64 %rhs_len_p113)
  %15 = call i64 @strlen(ptr %12)
  %16 = call i64 @strlen(ptr @.str.3)
  %concat_total14 = add i64 %15, %16
  %concat_size15 = add i64 %concat_total14, 1
  %17 = call ptr @forge_rc_alloc(i64 %concat_size15)
  %18 = call ptr @memcpy(ptr %17, ptr %12, i64 %15)
  %cast16 = ptrtoint ptr %17 to i64
  %dst2_int17 = add i64 %cast16, %15
  %cast18 = inttoptr i64 %dst2_int17 to ptr
  %rhs_len_p119 = add i64 %16, 1
  %19 = call ptr @memcpy(ptr %cast18, ptr @.str.3, i64 %rhs_len_p119)
  %half20 = load i64, ptr %half, align 8
  %20 = call ptr @forge_rc_alloc(i64 32)
  %21 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %20, i64 32, ptr @.i2s_fmt.4, i64 %half20)
  %widen21 = sext i32 %21 to i64
  %22 = call i64 @strlen(ptr %17)
  %23 = call i64 @strlen(ptr %20)
  %concat_total22 = add i64 %22, %23
  %concat_size23 = add i64 %concat_total22, 1
  %24 = call ptr @forge_rc_alloc(i64 %concat_size23)
  %25 = call ptr @memcpy(ptr %24, ptr %17, i64 %22)
  %cast24 = ptrtoint ptr %24 to i64
  %dst2_int25 = add i64 %cast24, %22
  %cast26 = inttoptr i64 %dst2_int25 to ptr
  %rhs_len_p127 = add i64 %23, 1
  %26 = call ptr @memcpy(ptr %cast26, ptr %20, i64 %rhs_len_p127)
  %cast28 = ptrtoint ptr %24 to i64
  store i64 %cast28, ptr %match_result, align 8
  br label %match_end

march_arm29:                                      ; preds = %march_next
  %pay_slot32 = getelementptr inbounds nuw %PehParseResult, ptr %parsed2, i32 0, i32 1
  %payload33 = load ptr, ptr %pay_slot32, align 8
  %msg_slot_base = ptrtoint ptr %payload33 to i64
  %msg_slot_addr = add i64 %msg_slot_base, 0
  %msg_slot = inttoptr i64 %msg_slot_addr to ptr
  %msg = load ptr, ptr %msg_slot, align 8
  call void @forge_rc_retain(ptr %msg)
  store ptr %msg, ptr %msg34, align 8
  %msg35 = load ptr, ptr %msg34, align 8
  %27 = call i64 @strlen(ptr @.str.5)
  %28 = call i64 @strlen(ptr %msg35)
  %concat_total36 = add i64 %27, %28
  %concat_size37 = add i64 %concat_total36, 1
  %29 = call ptr @forge_rc_alloc(i64 %concat_size37)
  %30 = call ptr @memcpy(ptr %29, ptr @.str.5, i64 %27)
  %cast38 = ptrtoint ptr %29 to i64
  %dst2_int39 = add i64 %cast38, %27
  %cast40 = inttoptr i64 %dst2_int39 to ptr
  %rhs_len_p141 = add i64 %28, 1
  %31 = call ptr @memcpy(ptr %cast40, ptr %msg35, i64 %rhs_len_p141)
  %cast42 = ptrtoint ptr %29 to i64
  store i64 %cast42, ptr %match_result, align 8
  br label %match_end

march_next30:                                     ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 20)
  unreachable
}

define i64 @peh_step1(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %sgt = icmp sgt i64 %x1, 0
  %sgt_ext = zext i1 %sgt to i64
  %if_cond = icmp ne i64 %sgt_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  ret i64 0

if_then:                                          ; preds = %entry
  %x2 = load i64, ptr %x, align 8
  %mul = mul i64 %x2, 2
  ret i64 %mul

if_else:                                          ; preds = %entry
  br label %ifcont
}

define i64 @peh_step2(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %slt = icmp slt i64 %x1, 100
  %slt_ext = zext i1 %slt to i64
  %if_cond = icmp ne i64 %slt_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  ret i64 0

if_then:                                          ; preds = %entry
  %x2 = load i64, ptr %x, align 8
  %add = add i64 %x2, 1
  ret i64 %add

if_else:                                          ; preds = %entry
  br label %ifcont
}

define i64 @peh_pipeline(i64 %0) {
entry:
  %b = alloca i64, align 8
  %a = alloca i64, align 8
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %1 = call i64 @peh_step1(i64 %x1)
  %try_null = icmp eq i64 %1, 0
  br i1 %try_null, label %try_ret, label %try_ok

try_ok:                                           ; preds = %entry
  store i64 %1, ptr %a, align 8
  %a2 = load i64, ptr %a, align 8
  %2 = call i64 @peh_step2(i64 %a2)
  %try_null3 = icmp eq i64 %2, 0
  br i1 %try_null3, label %try_ret5, label %try_ok4

try_ret:                                          ; preds = %entry
  ret i64 0

try_ok4:                                          ; preds = %try_ok
  store i64 %2, ptr %b, align 8
  %b6 = load i64, ptr %b, align 8
  ret i64 %b6

try_ret5:                                         ; preds = %try_ok
  ret i64 0
}

define i64 @main() {
entry:
  %nc_result21 = alloca i64, align 8
  %nc_result14 = alloca i64, align 8
  %nc_result = alloca i64, align 8
  %0 = call i32 @forge_test_start_spec(ptr @spec_str)
  %widen = sext i32 %0 to i64
  %1 = call ptr @peh_process(ptr @.str.6)
  %2 = call i32 @strcmp(ptr %1, ptr @.str.7)
  %widen1 = sext i32 %2 to i64
  %streq_cmp = icmp eq i64 %widen1, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %3 = call i64 @forge_test_run_then(ptr @spec_str.8, i64 %streq_ext)
  %4 = call ptr @peh_process(ptr @.str.9)
  %5 = call i32 @strcmp(ptr %4, ptr @.str.10)
  %widen2 = sext i32 %5 to i64
  %streq_cmp3 = icmp eq i64 %widen2, 0
  %streq_ext4 = zext i1 %streq_cmp3 to i64
  %6 = call i64 @forge_test_run_then(ptr @spec_str.11, i64 %streq_ext4)
  %7 = call ptr @peh_process(ptr @.str.12)
  %8 = call i32 @strcmp(ptr %7, ptr @.str.13)
  %widen5 = sext i32 %8 to i64
  %streq_cmp6 = icmp eq i64 %widen5, 0
  %streq_ext7 = zext i1 %streq_cmp6 to i64
  %9 = call i64 @forge_test_run_then(ptr @spec_str.14, i64 %streq_ext7)
  %10 = call ptr @peh_process(ptr @.str.15)
  %11 = call i32 @strcmp(ptr %10, ptr @.str.16)
  %widen8 = sext i32 %11 to i64
  %streq_cmp9 = icmp eq i64 %widen8, 0
  %streq_ext10 = zext i1 %streq_cmp9 to i64
  %12 = call i64 @forge_test_run_then(ptr @spec_str.17, i64 %streq_ext10)
  %13 = call i64 @peh_pipeline(i64 5)
  %nc_null = icmp eq i64 %13, 0
  store i64 %13, ptr %nc_result, align 8
  br i1 %nc_null, label %nc_rhs, label %nc_end

nc_rhs:                                           ; preds = %entry
  store i64 -1, ptr %nc_result, align 8
  br label %nc_end

nc_end:                                           ; preds = %nc_rhs, %entry
  %nc_val = load i64, ptr %nc_result, align 8
  %eq = icmp eq i64 %nc_val, 11
  %eq_ext = zext i1 %eq to i64
  %14 = call i64 @forge_test_run_then(ptr @spec_str.18, i64 %eq_ext)
  %15 = call i64 @peh_pipeline(i64 -1)
  %nc_null11 = icmp eq i64 %15, 0
  store i64 %15, ptr %nc_result14, align 8
  br i1 %nc_null11, label %nc_rhs12, label %nc_end13

nc_rhs12:                                         ; preds = %nc_end
  store i64 -1, ptr %nc_result14, align 8
  br label %nc_end13

nc_end13:                                         ; preds = %nc_rhs12, %nc_end
  %nc_val15 = load i64, ptr %nc_result14, align 8
  %eq16 = icmp eq i64 %nc_val15, -1
  %eq_ext17 = zext i1 %eq16 to i64
  %16 = call i64 @forge_test_run_then(ptr @spec_str.19, i64 %eq_ext17)
  %17 = call i64 @peh_pipeline(i64 60)
  %nc_null18 = icmp eq i64 %17, 0
  store i64 %17, ptr %nc_result21, align 8
  br i1 %nc_null18, label %nc_rhs19, label %nc_end20

nc_rhs19:                                         ; preds = %nc_end13
  store i64 -1, ptr %nc_result21, align 8
  br label %nc_end20

nc_end20:                                         ; preds = %nc_rhs19, %nc_end13
  %nc_val22 = load i64, ptr %nc_result21, align 8
  %eq23 = icmp eq i64 %nc_val22, -1
  %eq_ext24 = zext i1 %eq23 to i64
  %18 = call i64 @forge_test_run_then(ptr @spec_str.20, i64 %eq_ext24)
  %19 = call i32 @forge_test_end_spec(ptr @spec_str)
  %widen25 = sext i32 %19 to i64
  %20 = call i32 @forge_test_summary()
  %widen26 = sext i32 %20 to i64
  call void @forge_rc_collect()
  ret i64 0
}

define i64 @__release_PehParseResult(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %PehParseResult, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %PehParseResult, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_PehErr = icmp eq i64 %tag, 6952643567115
  br i1 %is_PehErr, label %rel_PehErr, label %try_next_PehErr

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_PehErr, %vrel_msg_skip
  call void @forge_rc_free(ptr %0)
  br label %done

rel_PehErr:                                       ; preds = %do_free
  %vrel_msg_ptr = getelementptr inbounds nuw %PehParseResult__PehErr, ptr %payload, i32 0, i32 0
  %vrel_msg = load ptr, ptr %vrel_msg_ptr, align 8
  %vrel_null_msg = icmp eq ptr %vrel_msg, null
  br i1 %vrel_null_msg, label %vrel_msg_skip, label %vrel_msg_do

try_next_PehErr:                                  ; preds = %do_free
  br label %fields_done

vrel_msg_skip:                                    ; preds = %vrel_msg_do, %rel_PehErr
  br label %fields_done

vrel_msg_do:                                      ; preds = %rel_PehErr
  call void @forge_rc_release(ptr %vrel_msg)
  br label %vrel_msg_skip
}
