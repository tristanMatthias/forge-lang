; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%EhrtResult = type { i64, ptr }
%EhrtIoError = type { ptr }
%EhrtParseError = type { ptr, ptr }
%EhrtResult__EhrtOk = type { ptr }
%EhrtResult__EhrtErr = type { ptr }

@.str = private unnamed_addr constant [9 x i8] c"negative\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"positive\00", align 1
@fld_name = private unnamed_addr constant [4 x i8] c"msg\00", align 1
@sty_name = private unnamed_addr constant [12 x i8] c"EhrtIoError\00", align 1
@src_file = private unnamed_addr constant [38 x i8] c"tests/error_handling_red_team_test.fg\00", align 1
@.str.2 = private unnamed_addr constant [3 x i8] c"io\00", align 1
@fld_name.3 = private unnamed_addr constant [4 x i8] c"msg\00", align 1
@sty_name.4 = private unnamed_addr constant [15 x i8] c"EhrtParseError\00", align 1
@src_file.5 = private unnamed_addr constant [38 x i8] c"tests/error_handling_red_team_test.fg\00", align 1
@.str.6 = private unnamed_addr constant [5 x i8] c" in \00", align 1
@fld_name.7 = private unnamed_addr constant [5 x i8] c"file\00", align 1
@sty_name.8 = private unnamed_addr constant [15 x i8] c"EhrtParseError\00", align 1
@src_file.9 = private unnamed_addr constant [38 x i8] c"tests/error_handling_red_team_test.fg\00", align 1
@.str.10 = private unnamed_addr constant [6 x i8] c"parse\00", align 1
@.str.11 = private unnamed_addr constant [10 x i8] c"chained: \00", align 1
@.str.12 = private unnamed_addr constant [8 x i8] c" error \00", align 1
@.match_fn = private unnamed_addr constant [15 x i8] c"ehrt_unwrap_or\00", align 1
@mu_file = private unnamed_addr constant [38 x i8] c"tests/error_handling_red_team_test.fg\00", align 1
@spec_str = private unnamed_addr constant [26 x i8] c"\22error handling red team\22\00", align 1
@.str.13 = private unnamed_addr constant [14 x i8] c"default value\00", align 1
@.str.14 = private unnamed_addr constant [14 x i8] c"default value\00", align 1
@spec_str.15 = private unnamed_addr constant [24 x i8] c"\22error returns default\22\00", align 1
@.str.16 = private unnamed_addr constant [10 x i8] c"disk full\00", align 1
@fld_name.17 = private unnamed_addr constant [5 x i8] c"kind\00", align 1
@sty_name.18 = private unnamed_addr constant [12 x i8] c"EhrtIoError\00", align 1
@src_file.19 = private unnamed_addr constant [38 x i8] c"tests/error_handling_red_team_test.fg\00", align 1
@.str.20 = private unnamed_addr constant [3 x i8] c"io\00", align 1
@spec_str.21 = private unnamed_addr constant [19 x i8] c"\22error trait kind\22\00", align 1
@.str.22 = private unnamed_addr constant [10 x i8] c"disk full\00", align 1
@fld_name.23 = private unnamed_addr constant [8 x i8] c"message\00", align 1
@sty_name.24 = private unnamed_addr constant [12 x i8] c"EhrtIoError\00", align 1
@src_file.25 = private unnamed_addr constant [38 x i8] c"tests/error_handling_red_team_test.fg\00", align 1
@.str.26 = private unnamed_addr constant [10 x i8] c"disk full\00", align 1
@spec_str.27 = private unnamed_addr constant [22 x i8] c"\22error trait message\22\00", align 1
@.str.28 = private unnamed_addr constant [12 x i8] c"parse error\00", align 1
@.str.29 = private unnamed_addr constant [12 x i8] c"config.json\00", align 1
@.str.30 = private unnamed_addr constant [48 x i8] c"chained: parse error parse error in config.json\00", align 1
@spec_str.31 = private unnamed_addr constant [25 x i8] c"\22error context chaining\22\00", align 1

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

define ptr @ehrt_might_fail(i64 %0) {
entry:
  %sif_result = alloca i64, align 8
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %slt = icmp slt i64 %x1, 0
  %slt_ext = zext i1 %slt to i64
  %sif_cond = icmp ne i64 %slt_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

sif_then:                                         ; preds = %entry
  %1 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %EhrtResult, ptr %1, i32 0, i32 0
  store i64 229423162472673, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %EhrtResult, ptr %1, i32 0, i32 1
  %2 = call ptr @forge_rc_alloc(i64 8)
  store ptr %2, ptr %pay_ptr, align 8
  %slot_base = ptrtoint ptr %2 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr @.str, ptr %slot, align 8
  %cast = ptrtoint ptr %1 to i64
  store i64 %cast, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %entry
  %3 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr2 = getelementptr inbounds nuw %EhrtResult, ptr %3, i32 0, i32 0
  store i64 6952217044946, ptr %tag_ptr2, align 8
  %pay_ptr3 = getelementptr inbounds nuw %EhrtResult, ptr %3, i32 0, i32 1
  %4 = call ptr @forge_rc_alloc(i64 8)
  store ptr %4, ptr %pay_ptr3, align 8
  %slot_base4 = ptrtoint ptr %4 to i64
  %slot_addr5 = add i64 %slot_base4, 0
  %slot6 = inttoptr i64 %slot_addr5 to ptr
  store ptr @.str.1, ptr %slot6, align 8
  %cast7 = ptrtoint ptr %3 to i64
  store i64 %cast7, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  %cast8 = inttoptr i64 %sif_val to ptr
  ret ptr %cast8
}

define ptr @EhrtIoError__message(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name, i64 3, ptr @sty_name, i64 11, i64 %null_ext, ptr @src_file, i64 37, i64 17)
  %msg_ptr = getelementptr inbounds nuw %EhrtIoError, ptr %self1, i32 0, i32 0
  %msg = load ptr, ptr %msg_ptr, align 8
  ret ptr %msg
}

define ptr @EhrtIoError__kind(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  ret ptr @.str.2
}

define ptr @EhrtParseError__message(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name.3, i64 3, ptr @sty_name.4, i64 14, i64 %null_ext, ptr @src_file.5, i64 37, i64 23)
  %msg_ptr = getelementptr inbounds nuw %EhrtParseError, ptr %self1, i32 0, i32 0
  %msg = load ptr, ptr %msg_ptr, align 8
  %1 = call i64 @strlen(ptr %msg)
  %2 = call i64 @strlen(ptr @.str.6)
  %concat_total = add i64 %1, %2
  %concat_size = add i64 %concat_total, 1
  %3 = call ptr @forge_rc_alloc(i64 %concat_size)
  %4 = call ptr @memcpy(ptr %3, ptr %msg, i64 %1)
  %cast2 = ptrtoint ptr %3 to i64
  %dst2_int = add i64 %cast2, %1
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %2, 1
  %5 = call ptr @memcpy(ptr %cast3, ptr @.str.6, i64 %rhs_len_p1)
  %self4 = load ptr, ptr %self, align 8
  %cast5 = ptrtoint ptr %self4 to i64
  %null_chk6 = icmp eq i64 %cast5, 0
  %null_ext7 = zext i1 %null_chk6 to i64
  call void @forge_null_deref_trap(ptr @fld_name.7, i64 4, ptr @sty_name.8, i64 14, i64 %null_ext7, ptr @src_file.9, i64 37, i64 23)
  %file_ptr = getelementptr inbounds nuw %EhrtParseError, ptr %self4, i32 0, i32 1
  %file = load ptr, ptr %file_ptr, align 8
  %6 = call i64 @strlen(ptr %3)
  %7 = call i64 @strlen(ptr %file)
  %concat_total8 = add i64 %6, %7
  %concat_size9 = add i64 %concat_total8, 1
  %8 = call ptr @forge_rc_alloc(i64 %concat_size9)
  %9 = call ptr @memcpy(ptr %8, ptr %3, i64 %6)
  %cast10 = ptrtoint ptr %8 to i64
  %dst2_int11 = add i64 %cast10, %6
  %cast12 = inttoptr i64 %dst2_int11 to ptr
  %rhs_len_p113 = add i64 %7, 1
  %10 = call ptr @memcpy(ptr %cast12, ptr %file, i64 %rhs_len_p113)
  ret ptr %8
}

define ptr @EhrtParseError__kind(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  ret ptr @.str.10
}

define ptr @ehrt_show_error(i64 %0) {
entry:
  %e = alloca ptr, align 8
  %cast = inttoptr i64 %0 to ptr
  store ptr %cast, ptr %e, align 8
  %e1 = load ptr, ptr %e, align 8
  %1 = call i64 @forge_trait_object_value(ptr %e1)
  %2 = call ptr @forge_trait_object_vtable(ptr %e1)
  %3 = call i64 @forge_array_get(ptr %2, i64 1)
  %4 = call i64 @forge_closure_call_1(i64 %3, i64 %1)
  %cast2 = inttoptr i64 %4 to ptr
  %5 = call i64 @strlen(ptr @.str.11)
  %6 = call i64 @strlen(ptr %cast2)
  %concat_total = add i64 %5, %6
  %concat_size = add i64 %concat_total, 1
  %7 = call ptr @forge_rc_alloc(i64 %concat_size)
  %8 = call ptr @memcpy(ptr %7, ptr @.str.11, i64 %5)
  %cast3 = ptrtoint ptr %7 to i64
  %dst2_int = add i64 %cast3, %5
  %cast4 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %6, 1
  %9 = call ptr @memcpy(ptr %cast4, ptr %cast2, i64 %rhs_len_p1)
  %10 = call i64 @strlen(ptr %7)
  %11 = call i64 @strlen(ptr @.str.12)
  %concat_total5 = add i64 %10, %11
  %concat_size6 = add i64 %concat_total5, 1
  %12 = call ptr @forge_rc_alloc(i64 %concat_size6)
  %13 = call ptr @memcpy(ptr %12, ptr %7, i64 %10)
  %cast7 = ptrtoint ptr %12 to i64
  %dst2_int8 = add i64 %cast7, %10
  %cast9 = inttoptr i64 %dst2_int8 to ptr
  %rhs_len_p110 = add i64 %11, 1
  %14 = call ptr @memcpy(ptr %cast9, ptr @.str.12, i64 %rhs_len_p110)
  %e11 = load ptr, ptr %e, align 8
  %15 = call i64 @forge_trait_object_value(ptr %e11)
  %16 = call ptr @forge_trait_object_vtable(ptr %e11)
  %17 = call i64 @forge_array_get(ptr %16, i64 0)
  %18 = call i64 @forge_closure_call_1(i64 %17, i64 %15)
  %cast12 = inttoptr i64 %18 to ptr
  %19 = call i64 @strlen(ptr %12)
  %20 = call i64 @strlen(ptr %cast12)
  %concat_total13 = add i64 %19, %20
  %concat_size14 = add i64 %concat_total13, 1
  %21 = call ptr @forge_rc_alloc(i64 %concat_size14)
  %22 = call ptr @memcpy(ptr %21, ptr %12, i64 %19)
  %cast15 = ptrtoint ptr %21 to i64
  %dst2_int16 = add i64 %cast15, %19
  %cast17 = inttoptr i64 %dst2_int16 to ptr
  %rhs_len_p118 = add i64 %20, 1
  %23 = call ptr @memcpy(ptr %cast17, ptr %cast12, i64 %rhs_len_p118)
  ret ptr %21
}

define ptr @ehrt_unwrap_or(ptr %0, ptr %1) {
entry:
  %v2 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %default_val = alloca ptr, align 8
  %r = alloca ptr, align 8
  store ptr %0, ptr %r, align 8
  store ptr %1, ptr %default_val, align 8
  %r1 = load ptr, ptr %r, align 8
  %tag_ptr = getelementptr inbounds nuw %EhrtResult, ptr %r1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 6952217044946
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm4, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast9 = inttoptr i64 %match_val to ptr
  ret ptr %cast9

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %EhrtResult, ptr %r1, i32 0, i32 1
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
  %tag_eq6 = icmp eq i64 %tag, 229423162472673
  br i1 %tag_eq6, label %march_arm4, label %march_next5

march_arm4:                                       ; preds = %march_next
  %default_val7 = load ptr, ptr %default_val, align 8
  %cast8 = ptrtoint ptr %default_val7 to i64
  store i64 %cast8, ptr %match_result, align 8
  br label %match_end

march_next5:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 32)
  unreachable
}

define i64 @main() {
entry:
  %pe = alloca ptr, align 8
  %e2 = alloca ptr, align 8
  %e = alloca ptr, align 8
  %0 = call i32 @forge_test_start_spec(ptr @spec_str)
  %widen = sext i32 %0 to i64
  %1 = call ptr @ehrt_might_fail(i64 -1)
  %2 = call ptr @ehrt_unwrap_or(ptr %1, ptr @.str.13)
  %3 = call i32 @strcmp(ptr %2, ptr @.str.14)
  %widen1 = sext i32 %3 to i64
  %streq_cmp = icmp eq i64 %widen1, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %4 = call i64 @forge_test_run_then(ptr @spec_str.15, i64 %streq_ext)
  %5 = call ptr @forge_rc_alloc(i64 8)
  %fld_ptr = getelementptr inbounds nuw %EhrtIoError, ptr %5, i32 0, i32 0
  store ptr @.str.16, ptr %fld_ptr, align 8
  %cast = ptrtoint ptr %5 to i64
  %cast2 = inttoptr i64 %cast to ptr
  store ptr %cast2, ptr %e, align 8
  %e3 = load ptr, ptr %e, align 8
  %cast4 = ptrtoint ptr %e3 to i64
  %null_chk = icmp eq i64 %cast4, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name.17, i64 4, ptr @sty_name.18, i64 11, i64 %null_ext, ptr @src_file.19, i64 37, i64 44)
  %6 = call ptr @EhrtIoError__kind(ptr %e3)
  %7 = call i32 @strcmp(ptr %6, ptr @.str.20)
  %widen5 = sext i32 %7 to i64
  %streq_cmp6 = icmp eq i64 %widen5, 0
  %streq_ext7 = zext i1 %streq_cmp6 to i64
  %8 = call i64 @forge_test_run_then(ptr @spec_str.21, i64 %streq_ext7)
  %9 = call ptr @forge_rc_alloc(i64 8)
  %fld_ptr8 = getelementptr inbounds nuw %EhrtIoError, ptr %9, i32 0, i32 0
  store ptr @.str.22, ptr %fld_ptr8, align 8
  %cast9 = ptrtoint ptr %9 to i64
  %cast10 = inttoptr i64 %cast9 to ptr
  store ptr %cast10, ptr %e2, align 8
  %e211 = load ptr, ptr %e2, align 8
  %cast12 = ptrtoint ptr %e211 to i64
  %null_chk13 = icmp eq i64 %cast12, 0
  %null_ext14 = zext i1 %null_chk13 to i64
  call void @forge_null_deref_trap(ptr @fld_name.23, i64 7, ptr @sty_name.24, i64 11, i64 %null_ext14, ptr @src_file.25, i64 37, i64 48)
  %10 = call ptr @EhrtIoError__message(ptr %e211)
  %11 = call i32 @strcmp(ptr %10, ptr @.str.26)
  %widen15 = sext i32 %11 to i64
  %streq_cmp16 = icmp eq i64 %widen15, 0
  %streq_ext17 = zext i1 %streq_cmp16 to i64
  %12 = call i64 @forge_test_run_then(ptr @spec_str.27, i64 %streq_ext17)
  %13 = call ptr @forge_rc_alloc(i64 16)
  %fld_ptr18 = getelementptr inbounds nuw %EhrtParseError, ptr %13, i32 0, i32 0
  store ptr @.str.28, ptr %fld_ptr18, align 8
  %fld_ptr19 = getelementptr inbounds nuw %EhrtParseError, ptr %13, i32 0, i32 1
  store ptr @.str.29, ptr %fld_ptr19, align 8
  %cast20 = ptrtoint ptr %13 to i64
  %cast21 = inttoptr i64 %cast20 to ptr
  store ptr %cast21, ptr %pe, align 8
  %pe22 = load ptr, ptr %pe, align 8
  %14 = call ptr @forge_array_new()
  %15 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %15, i64 -559038737)
  call void @forge_array_push(ptr %15, i64 ptrtoint (ptr @EhrtParseError__message to i64))
  %cast23 = ptrtoint ptr %15 to i64
  call void @forge_array_push(ptr %14, i64 %cast23)
  %16 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %16, i64 -559038737)
  call void @forge_array_push(ptr %16, i64 ptrtoint (ptr @EhrtParseError__kind to i64))
  %cast24 = ptrtoint ptr %16 to i64
  call void @forge_array_push(ptr %14, i64 %cast24)
  %cast25 = ptrtoint ptr %14 to i64
  %17 = call i64 @forge_trait_object_new(ptr %pe22, i64 %cast25)
  %18 = call ptr @ehrt_show_error(i64 %17)
  %19 = call i32 @strcmp(ptr %18, ptr @.str.30)
  %widen26 = sext i32 %19 to i64
  %streq_cmp27 = icmp eq i64 %widen26, 0
  %streq_ext28 = zext i1 %streq_cmp27 to i64
  %20 = call i64 @forge_test_run_then(ptr @spec_str.31, i64 %streq_ext28)
  %21 = call i32 @forge_test_end_spec(ptr @spec_str)
  %widen29 = sext i32 %21 to i64
  %22 = call i32 @forge_test_summary()
  %widen30 = sext i32 %22 to i64
  call void @forge_rc_collect()
  ret i64 0
}

define i64 @__release_EhrtParseError(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_msg_ptr = getelementptr inbounds nuw %EhrtParseError, ptr %0, i32 0, i32 0
  %rel_msg = load ptr, ptr %rel_msg_ptr, align 8
  %is_null_msg = icmp eq ptr %rel_msg, null
  br i1 %is_null_msg, label %rel_msg_skip, label %rel_msg_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_file_skip
  ret i64 0

rel_msg_skip:                                     ; preds = %rel_msg_do, %do_free
  %rel_file_ptr = getelementptr inbounds nuw %EhrtParseError, ptr %0, i32 0, i32 1
  %rel_file = load ptr, ptr %rel_file_ptr, align 8
  %is_null_file = icmp eq ptr %rel_file, null
  br i1 %is_null_file, label %rel_file_skip, label %rel_file_do

rel_msg_do:                                       ; preds = %do_free
  call void @forge_rc_release(ptr %rel_msg)
  br label %rel_msg_skip

rel_file_skip:                                    ; preds = %rel_file_do, %rel_msg_skip
  call void @forge_rc_free(ptr %0)
  br label %done

rel_file_do:                                      ; preds = %rel_msg_skip
  call void @forge_rc_release(ptr %rel_file)
  br label %rel_file_skip
}

define i64 @__release_EhrtIoError(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_msg_ptr = getelementptr inbounds nuw %EhrtIoError, ptr %0, i32 0, i32 0
  %rel_msg = load ptr, ptr %rel_msg_ptr, align 8
  %is_null_msg = icmp eq ptr %rel_msg, null
  br i1 %is_null_msg, label %rel_msg_skip, label %rel_msg_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_msg_skip
  ret i64 0

rel_msg_skip:                                     ; preds = %rel_msg_do, %do_free
  call void @forge_rc_free(ptr %0)
  br label %done

rel_msg_do:                                       ; preds = %do_free
  call void @forge_rc_release(ptr %rel_msg)
  br label %rel_msg_skip
}

define i64 @__release_EhrtResult(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %EhrtResult, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %EhrtResult, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_EhrtOk = icmp eq i64 %tag, 6952217044946
  br i1 %is_EhrtOk, label %rel_EhrtOk, label %try_next_EhrtOk

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_EhrtErr, %vrel_error_skip, %vrel_value_skip
  call void @forge_rc_free(ptr %0)
  br label %done

rel_EhrtOk:                                       ; preds = %do_free
  %vrel_value_ptr = getelementptr inbounds nuw %EhrtResult__EhrtOk, ptr %payload, i32 0, i32 0
  %vrel_value = load ptr, ptr %vrel_value_ptr, align 8
  %vrel_null_value = icmp eq ptr %vrel_value, null
  br i1 %vrel_null_value, label %vrel_value_skip, label %vrel_value_do

try_next_EhrtOk:                                  ; preds = %do_free
  %is_EhrtErr = icmp eq i64 %tag, 229423162472673
  br i1 %is_EhrtErr, label %rel_EhrtErr, label %try_next_EhrtErr

vrel_value_skip:                                  ; preds = %vrel_value_do, %rel_EhrtOk
  br label %fields_done

vrel_value_do:                                    ; preds = %rel_EhrtOk
  call void @forge_rc_release(ptr %vrel_value)
  br label %vrel_value_skip

rel_EhrtErr:                                      ; preds = %try_next_EhrtOk
  %vrel_error_ptr = getelementptr inbounds nuw %EhrtResult__EhrtErr, ptr %payload, i32 0, i32 0
  %vrel_error = load ptr, ptr %vrel_error_ptr, align 8
  %vrel_null_error = icmp eq ptr %vrel_error, null
  br i1 %vrel_null_error, label %vrel_error_skip, label %vrel_error_do

try_next_EhrtErr:                                 ; preds = %try_next_EhrtOk
  br label %fields_done

vrel_error_skip:                                  ; preds = %vrel_error_do, %rel_EhrtErr
  br label %fields_done

vrel_error_do:                                    ; preds = %rel_EhrtErr
  call void @forge_rc_release(ptr %vrel_error)
  br label %vrel_error_skip
}
