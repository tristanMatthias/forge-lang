; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%ParseResult = type { i64, ptr }
%ParseResult__Err = type { ptr }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.1 = private unnamed_addr constant [13 x i8] c"empty string\00", align 1
@dz_file = private unnamed_addr constant [106 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/prod_error_handling.av\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c" -> \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.3 = private unnamed_addr constant [8 x i8] c" / 2 = \00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.5 = private unnamed_addr constant [8 x i8] c"error: \00", align 1
@.match_fn = private unnamed_addr constant [8 x i8] c"process\00", align 1
@mu_file = private unnamed_addr constant [106 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/prod_error_handling.av\00", align 1
@.str.6 = private unnamed_addr constant [3 x i8] c"42\00", align 1
@.str.7 = private unnamed_addr constant [4 x i8] c"100\00", align 1
@.str.8 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.9 = private unnamed_addr constant [2 x i8] c"7\00", align 1
@.i2s_fmt.10 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.11 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.12 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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
  %tag_ptr3 = getelementptr inbounds nuw %ParseResult, ptr %2, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr3, align 8
  %pay_ptr4 = getelementptr inbounds nuw %ParseResult, ptr %2, i32 0, i32 1
  %3 = call ptr @avra_rc_alloc(i64 8)
  store ptr %3, ptr %pay_ptr4, align 8
  %s5 = load ptr, ptr %s, align 8
  %4 = call i64 @avra_parse_int(ptr %s5)
  %slot_base6 = ptrtoint ptr %3 to i64
  %slot_addr7 = add i64 %slot_base6, 0
  %slot8 = inttoptr i64 %slot_addr7 to ptr
  store i64 %4, ptr %slot8, align 8
  %cast9 = ptrtoint ptr %2 to i64
  %cast10 = inttoptr i64 %cast9 to ptr
  ret ptr %cast10

if_then:                                          ; preds = %entry
  %5 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %ParseResult, ptr %5, i32 0, i32 0
  store i64 193456014, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %ParseResult, ptr %5, i32 0, i32 1
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
}

define i64 @safe_divide(i64 %0, i64 %1) {
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
  call void @avra_div_by_zero_trap(i64 %dz_chk_ext, ptr @dz_file, i64 105, i64 14)
  %div = sdiv i64 %a2, %b3
  ret i64 %div

if_then:                                          ; preds = %entry
  ret i64 0

if_else:                                          ; preds = %entry
  br label %ifcont
}

define ptr @process(ptr %0) {
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
  %1 = call ptr @parse_int(ptr %input1)
  store ptr %1, ptr %parsed, align 8
  %parsed2 = load ptr, ptr %parsed, align 8
  %tag_ptr = getelementptr inbounds nuw %ParseResult, ptr %parsed2, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 5862623
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm29, %nc_end
  %match_val = load i64, ptr %match_result, align 8
  %cast43 = inttoptr i64 %match_val to ptr
  ret ptr %cast43

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %ParseResult, ptr %parsed2, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load i64, ptr %v_slot, align 8
  store i64 %v, ptr %v3, align 8
  %v4 = load i64, ptr %v3, align 8
  %2 = call i64 @safe_divide(i64 %v4, i64 2)
  %nc_null = icmp eq i64 %2, 0
  store i64 %2, ptr %nc_result, align 8
  br i1 %nc_null, label %nc_rhs, label %nc_end

march_next:                                       ; preds = %entry
  %tag_eq31 = icmp eq i64 %tag, 193456014
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
  %5 = call ptr @avra_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr %input5, i64 %3)
  %cast = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast, %3
  %cast6 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast6, ptr @.str.2, i64 %rhs_len_p1)
  %v7 = load i64, ptr %v3, align 8
  %8 = call ptr @avra_rc_alloc(i64 32)
  %9 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %8, i64 32, ptr @.i2s_fmt, i64 %v7)
  %widen = sext i32 %9 to i64
  %10 = call i64 @strlen(ptr %5)
  %11 = call i64 @strlen(ptr %8)
  %concat_total8 = add i64 %10, %11
  %concat_size9 = add i64 %concat_total8, 1
  %12 = call ptr @avra_rc_alloc(i64 %concat_size9)
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
  %17 = call ptr @avra_rc_alloc(i64 %concat_size15)
  %18 = call ptr @memcpy(ptr %17, ptr %12, i64 %15)
  %cast16 = ptrtoint ptr %17 to i64
  %dst2_int17 = add i64 %cast16, %15
  %cast18 = inttoptr i64 %dst2_int17 to ptr
  %rhs_len_p119 = add i64 %16, 1
  %19 = call ptr @memcpy(ptr %cast18, ptr @.str.3, i64 %rhs_len_p119)
  %half20 = load i64, ptr %half, align 8
  %20 = call ptr @avra_rc_alloc(i64 32)
  %21 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %20, i64 32, ptr @.i2s_fmt.4, i64 %half20)
  %widen21 = sext i32 %21 to i64
  %22 = call i64 @strlen(ptr %17)
  %23 = call i64 @strlen(ptr %20)
  %concat_total22 = add i64 %22, %23
  %concat_size23 = add i64 %concat_total22, 1
  %24 = call ptr @avra_rc_alloc(i64 %concat_size23)
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
  %pay_slot32 = getelementptr inbounds nuw %ParseResult, ptr %parsed2, i32 0, i32 1
  %payload33 = load ptr, ptr %pay_slot32, align 8
  %msg_slot_base = ptrtoint ptr %payload33 to i64
  %msg_slot_addr = add i64 %msg_slot_base, 0
  %msg_slot = inttoptr i64 %msg_slot_addr to ptr
  %msg = load ptr, ptr %msg_slot, align 8
  call void @avra_rc_retain(ptr %msg)
  store ptr %msg, ptr %msg34, align 8
  %msg35 = load ptr, ptr %msg34, align 8
  %27 = call i64 @strlen(ptr @.str.5)
  %28 = call i64 @strlen(ptr %msg35)
  %concat_total36 = add i64 %27, %28
  %concat_size37 = add i64 %concat_total36, 1
  %29 = call ptr @avra_rc_alloc(i64 %concat_size37)
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
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 19)
  unreachable
}

define i64 @step1(i64 %0) {
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

define i64 @step2(i64 %0) {
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

define i64 @pipeline(i64 %0) {
entry:
  %b = alloca i64, align 8
  %a = alloca i64, align 8
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %1 = call i64 @step1(i64 %x1)
  %try_null = icmp eq i64 %1, 0
  br i1 %try_null, label %try_ret, label %try_ok

try_ok:                                           ; preds = %entry
  store i64 %1, ptr %a, align 8
  %a2 = load i64, ptr %a, align 8
  %2 = call i64 @step2(i64 %a2)
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
  %nc_result16 = alloca i64, align 8
  %nc_result9 = alloca i64, align 8
  %nc_result = alloca i64, align 8
  %0 = call ptr @process(ptr @.str.6)
  %1 = call i32 @puts(ptr %0)
  %widen = sext i32 %1 to i64
  %2 = call ptr @process(ptr @.str.7)
  %3 = call i32 @puts(ptr %2)
  %widen1 = sext i32 %3 to i64
  %4 = call ptr @process(ptr @.str.8)
  %5 = call i32 @puts(ptr %4)
  %widen2 = sext i32 %5 to i64
  %6 = call ptr @process(ptr @.str.9)
  %7 = call i32 @puts(ptr %6)
  %widen3 = sext i32 %7 to i64
  %8 = call i64 @pipeline(i64 5)
  %nc_null = icmp eq i64 %8, 0
  store i64 %8, ptr %nc_result, align 8
  br i1 %nc_null, label %nc_rhs, label %nc_end

nc_rhs:                                           ; preds = %entry
  store i64 -1, ptr %nc_result, align 8
  br label %nc_end

nc_end:                                           ; preds = %nc_rhs, %entry
  %nc_val = load i64, ptr %nc_result, align 8
  %9 = call ptr @avra_rc_alloc(i64 32)
  %10 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %9, i64 32, ptr @.i2s_fmt.10, i64 %nc_val)
  %widen4 = sext i32 %10 to i64
  %11 = call i32 @puts(ptr %9)
  %widen5 = sext i32 %11 to i64
  %12 = call i64 @pipeline(i64 -1)
  %nc_null6 = icmp eq i64 %12, 0
  store i64 %12, ptr %nc_result9, align 8
  br i1 %nc_null6, label %nc_rhs7, label %nc_end8

nc_rhs7:                                          ; preds = %nc_end
  store i64 -1, ptr %nc_result9, align 8
  br label %nc_end8

nc_end8:                                          ; preds = %nc_rhs7, %nc_end
  %nc_val10 = load i64, ptr %nc_result9, align 8
  %13 = call ptr @avra_rc_alloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @.i2s_fmt.11, i64 %nc_val10)
  %widen11 = sext i32 %14 to i64
  %15 = call i32 @puts(ptr %13)
  %widen12 = sext i32 %15 to i64
  %16 = call i64 @pipeline(i64 60)
  %nc_null13 = icmp eq i64 %16, 0
  store i64 %16, ptr %nc_result16, align 8
  br i1 %nc_null13, label %nc_rhs14, label %nc_end15

nc_rhs14:                                         ; preds = %nc_end8
  store i64 -1, ptr %nc_result16, align 8
  br label %nc_end15

nc_end15:                                         ; preds = %nc_rhs14, %nc_end8
  %nc_val17 = load i64, ptr %nc_result16, align 8
  %17 = call ptr @avra_rc_alloc(i64 32)
  %18 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %17, i64 32, ptr @.i2s_fmt.12, i64 %nc_val17)
  %widen18 = sext i32 %18 to i64
  %19 = call i32 @puts(ptr %17)
  %widen19 = sext i32 %19 to i64
  %20 = call i32 @avra_test_summary()
  %widen20 = sext i32 %20 to i64
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_ParseResult(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %ParseResult, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %ParseResult, ptr %0, i32 0, i32 1
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
  %vrel_msg_ptr = getelementptr inbounds nuw %ParseResult__Err, ptr %payload, i32 0, i32 0
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
