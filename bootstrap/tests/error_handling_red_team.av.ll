; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Result__string__string = type { i64, ptr }
%IoError = type { ptr }
%ParseError = type { ptr, ptr }
%Result__string__string__Ok = type { ptr }
%Result__string__string__Err = type { ptr }

@.str = private unnamed_addr constant [9 x i8] c"negative\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"positive\00", align 1
@fld_name = private unnamed_addr constant [4 x i8] c"msg\00", align 1
@sty_name = private unnamed_addr constant [8 x i8] c"IoError\00", align 1
@src_file = private unnamed_addr constant [110 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_handling_red_team.av\00", align 1
@.str.2 = private unnamed_addr constant [3 x i8] c"io\00", align 1
@.str.3 = private unnamed_addr constant [13 x i8] c"write failed\00", align 1
@.str.4 = private unnamed_addr constant [19 x i8] c"released resource \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.5 = private unnamed_addr constant [12 x i8] c"cleanup ran\00", align 1
@.str.6 = private unnamed_addr constant [8 x i8] c"success\00", align 1
@.str.7 = private unnamed_addr constant [19 x i8] c"released resource \00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.9 = private unnamed_addr constant [12 x i8] c"cleanup ran\00", align 1
@.str.10 = private unnamed_addr constant [12 x i8] c"cleanup ran\00", align 1
@fld_name.11 = private unnamed_addr constant [4 x i8] c"msg\00", align 1
@sty_name.12 = private unnamed_addr constant [11 x i8] c"ParseError\00", align 1
@src_file.13 = private unnamed_addr constant [110 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_handling_red_team.av\00", align 1
@.str.14 = private unnamed_addr constant [5 x i8] c" in \00", align 1
@fld_name.15 = private unnamed_addr constant [5 x i8] c"file\00", align 1
@sty_name.16 = private unnamed_addr constant [11 x i8] c"ParseError\00", align 1
@src_file.17 = private unnamed_addr constant [110 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_handling_red_team.av\00", align 1
@.str.18 = private unnamed_addr constant [6 x i8] c"parse\00", align 1
@.str.19 = private unnamed_addr constant [10 x i8] c"chained: \00", align 1
@.str.20 = private unnamed_addr constant [8 x i8] c" error \00", align 1
@.str.21 = private unnamed_addr constant [14 x i8] c"default value\00", align 1
@.str.22 = private unnamed_addr constant [10 x i8] c"disk full\00", align 1
@.str.23 = private unnamed_addr constant [8 x i8] c"error: \00", align 1
@fld_name.24 = private unnamed_addr constant [5 x i8] c"kind\00", align 1
@sty_name.25 = private unnamed_addr constant [8 x i8] c"IoError\00", align 1
@src_file.26 = private unnamed_addr constant [110 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_handling_red_team.av\00", align 1
@.str.27 = private unnamed_addr constant [3 x i8] c": \00", align 1
@fld_name.28 = private unnamed_addr constant [8 x i8] c"message\00", align 1
@sty_name.29 = private unnamed_addr constant [8 x i8] c"IoError\00", align 1
@src_file.30 = private unnamed_addr constant [110 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_handling_red_team.av\00", align 1
@.str.31 = private unnamed_addr constant [5 x i8] c"ok: \00", align 1
@.str.32 = private unnamed_addr constant [8 x i8] c"error: \00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [110 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/error_handling_red_team.av\00", align 1
@.str.33 = private unnamed_addr constant [12 x i8] c"parse error\00", align 1
@.str.34 = private unnamed_addr constant [12 x i8] c"config.json\00", align 1

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

define ptr @might_fail(i64 %0) {
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
  %1 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Result__string__string, ptr %1, i32 0, i32 0
  store i64 193456014, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result__string__string, ptr %1, i32 0, i32 1
  %2 = call ptr @avra_rc_alloc(i64 8)
  store ptr %2, ptr %pay_ptr, align 8
  %slot_base = ptrtoint ptr %2 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr @.str, ptr %slot, align 8
  %cast = ptrtoint ptr %1 to i64
  store i64 %cast, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %entry
  %3 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr2 = getelementptr inbounds nuw %Result__string__string, ptr %3, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr2, align 8
  %pay_ptr3 = getelementptr inbounds nuw %Result__string__string, ptr %3, i32 0, i32 1
  %4 = call ptr @avra_rc_alloc(i64 8)
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
  %ret_tag_ptr = getelementptr inbounds nuw %Result__string__string, ptr %cast8, i32 0, i32 0
  %ret_tag = load i64, ptr %ret_tag_ptr, align 8
  %is_err_ret = icmp eq i64 %ret_tag, 193456014
  br i1 %is_err_ret, label %errdefer_path, label %defer_path

errdefer_path:                                    ; preds = %sif_end
  br label %defer_done

defer_path:                                       ; preds = %sif_end
  br label %defer_done

defer_done:                                       ; preds = %defer_path, %errdefer_path
  %cast9 = inttoptr i64 %sif_val to ptr
  ret ptr %cast9
}

define ptr @IoError__message(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 3, ptr @sty_name, i64 7, i64 %null_ext, ptr @src_file, i64 109, i64 24)
  %msg_ptr = getelementptr inbounds nuw %IoError, ptr %self1, i32 0, i32 0
  %msg = load ptr, ptr %msg_ptr, align 8
  ret ptr %msg
}

define ptr @IoError__kind(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  ret ptr @.str.2
}

define ptr @with_cleanup(i1 %0) {
entry:
  %resource = alloca i64, align 8
  %fail = alloca i1, align 1
  store i1 %0, ptr %fail, align 8
  store i64 42, ptr %resource, align 8
  %fail1 = load i1, ptr %fail, align 8
  br i1 %fail1, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %1 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr8 = getelementptr inbounds nuw %Result__string__string, ptr %1, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr8, align 8
  %pay_ptr9 = getelementptr inbounds nuw %Result__string__string, ptr %1, i32 0, i32 1
  %2 = call ptr @avra_rc_alloc(i64 8)
  store ptr %2, ptr %pay_ptr9, align 8
  %slot_base10 = ptrtoint ptr %2 to i64
  %slot_addr11 = add i64 %slot_base10, 0
  %slot12 = inttoptr i64 %slot_addr11 to ptr
  store ptr @.str.6, ptr %slot12, align 8
  %cast13 = ptrtoint ptr %1 to i64
  %cast14 = inttoptr i64 %cast13 to ptr
  %ret_tag_ptr = getelementptr inbounds nuw %Result__string__string, ptr %cast14, i32 0, i32 0
  %ret_tag = load i64, ptr %ret_tag_ptr, align 8
  %is_err_ret = icmp eq i64 %ret_tag, 193456014
  br i1 %is_err_ret, label %errdefer_path, label %defer_path

if_then:                                          ; preds = %entry
  %3 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Result__string__string, ptr %3, i32 0, i32 0
  store i64 193456014, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result__string__string, ptr %3, i32 0, i32 1
  %4 = call ptr @avra_rc_alloc(i64 8)
  store ptr %4, ptr %pay_ptr, align 8
  %slot_base = ptrtoint ptr %4 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr @.str.3, ptr %slot, align 8
  %cast = ptrtoint ptr %3 to i64
  %resource2 = load i64, ptr %resource, align 8
  %5 = call ptr @avra_rc_alloc(i64 32)
  %6 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %5, i64 32, ptr @.i2s_fmt, i64 %resource2)
  %widen = sext i32 %6 to i64
  %7 = call i64 @strlen(ptr @.str.4)
  %8 = call i64 @strlen(ptr %5)
  %concat_total = add i64 %7, %8
  %concat_size = add i64 %concat_total, 1
  %9 = call ptr @avra_rc_alloc(i64 %concat_size)
  %10 = call ptr @memcpy(ptr %9, ptr @.str.4, i64 %7)
  %cast3 = ptrtoint ptr %9 to i64
  %dst2_int = add i64 %cast3, %7
  %cast4 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %8, 1
  %11 = call ptr @memcpy(ptr %cast4, ptr %5, i64 %rhs_len_p1)
  %12 = call i32 @puts(ptr %9)
  %widen5 = sext i32 %12 to i64
  %13 = call i32 @puts(ptr @.str.5)
  %widen6 = sext i32 %13 to i64
  %cast7 = inttoptr i64 %cast to ptr
  ret ptr %cast7

if_else:                                          ; preds = %entry
  br label %ifcont

errdefer_path:                                    ; preds = %ifcont
  %resource15 = load i64, ptr %resource, align 8
  %14 = call ptr @avra_rc_alloc(i64 32)
  %15 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %14, i64 32, ptr @.i2s_fmt.8, i64 %resource15)
  %widen16 = sext i32 %15 to i64
  %16 = call i64 @strlen(ptr @.str.7)
  %17 = call i64 @strlen(ptr %14)
  %concat_total17 = add i64 %16, %17
  %concat_size18 = add i64 %concat_total17, 1
  %18 = call ptr @avra_rc_alloc(i64 %concat_size18)
  %19 = call ptr @memcpy(ptr %18, ptr @.str.7, i64 %16)
  %cast19 = ptrtoint ptr %18 to i64
  %dst2_int20 = add i64 %cast19, %16
  %cast21 = inttoptr i64 %dst2_int20 to ptr
  %rhs_len_p122 = add i64 %17, 1
  %20 = call ptr @memcpy(ptr %cast21, ptr %14, i64 %rhs_len_p122)
  %21 = call i32 @puts(ptr %18)
  %widen23 = sext i32 %21 to i64
  %22 = call i32 @puts(ptr @.str.9)
  %widen24 = sext i32 %22 to i64
  br label %defer_done

defer_path:                                       ; preds = %ifcont
  %23 = call i32 @puts(ptr @.str.10)
  %widen25 = sext i32 %23 to i64
  br label %defer_done

defer_done:                                       ; preds = %defer_path, %errdefer_path
  %cast26 = inttoptr i64 %cast13 to ptr
  ret ptr %cast26
}

define ptr @ParseError__message(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.11, i64 3, ptr @sty_name.12, i64 10, i64 %null_ext, ptr @src_file.13, i64 109, i64 40)
  %msg_ptr = getelementptr inbounds nuw %ParseError, ptr %self1, i32 0, i32 0
  %msg = load ptr, ptr %msg_ptr, align 8
  %1 = call i64 @strlen(ptr %msg)
  %2 = call i64 @strlen(ptr @.str.14)
  %concat_total = add i64 %1, %2
  %concat_size = add i64 %concat_total, 1
  %3 = call ptr @avra_rc_alloc(i64 %concat_size)
  %4 = call ptr @memcpy(ptr %3, ptr %msg, i64 %1)
  %cast2 = ptrtoint ptr %3 to i64
  %dst2_int = add i64 %cast2, %1
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %2, 1
  %5 = call ptr @memcpy(ptr %cast3, ptr @.str.14, i64 %rhs_len_p1)
  %self4 = load ptr, ptr %self, align 8
  %cast5 = ptrtoint ptr %self4 to i64
  %null_chk6 = icmp eq i64 %cast5, 0
  %null_ext7 = zext i1 %null_chk6 to i64
  call void @avra_null_deref_trap(ptr @fld_name.15, i64 4, ptr @sty_name.16, i64 10, i64 %null_ext7, ptr @src_file.17, i64 109, i64 40)
  %file_ptr = getelementptr inbounds nuw %ParseError, ptr %self4, i32 0, i32 1
  %file = load ptr, ptr %file_ptr, align 8
  %6 = call i64 @strlen(ptr %3)
  %7 = call i64 @strlen(ptr %file)
  %concat_total8 = add i64 %6, %7
  %concat_size9 = add i64 %concat_total8, 1
  %8 = call ptr @avra_rc_alloc(i64 %concat_size9)
  %9 = call ptr @memcpy(ptr %8, ptr %3, i64 %6)
  %cast10 = ptrtoint ptr %8 to i64
  %dst2_int11 = add i64 %cast10, %6
  %cast12 = inttoptr i64 %dst2_int11 to ptr
  %rhs_len_p113 = add i64 %7, 1
  %10 = call ptr @memcpy(ptr %cast12, ptr %file, i64 %rhs_len_p113)
  ret ptr %8
}

define ptr @ParseError__kind(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  ret ptr @.str.18
}

define ptr @show_error(i64 %0) {
entry:
  %e = alloca ptr, align 8
  %cast = inttoptr i64 %0 to ptr
  store ptr %cast, ptr %e, align 8
  %e1 = load ptr, ptr %e, align 8
  %1 = call i64 @avra_trait_object_value(ptr %e1)
  %2 = call ptr @avra_trait_object_vtable(ptr %e1)
  %3 = call i64 @avra_array_get(ptr %2, i64 1)
  %4 = call i64 @avra_closure_call_1(i64 %3, i64 %1)
  %cast2 = inttoptr i64 %4 to ptr
  %5 = call i64 @strlen(ptr @.str.19)
  %6 = call i64 @strlen(ptr %cast2)
  %concat_total = add i64 %5, %6
  %concat_size = add i64 %concat_total, 1
  %7 = call ptr @avra_rc_alloc(i64 %concat_size)
  %8 = call ptr @memcpy(ptr %7, ptr @.str.19, i64 %5)
  %cast3 = ptrtoint ptr %7 to i64
  %dst2_int = add i64 %cast3, %5
  %cast4 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %6, 1
  %9 = call ptr @memcpy(ptr %cast4, ptr %cast2, i64 %rhs_len_p1)
  %10 = call i64 @strlen(ptr %7)
  %11 = call i64 @strlen(ptr @.str.20)
  %concat_total5 = add i64 %10, %11
  %concat_size6 = add i64 %concat_total5, 1
  %12 = call ptr @avra_rc_alloc(i64 %concat_size6)
  %13 = call ptr @memcpy(ptr %12, ptr %7, i64 %10)
  %cast7 = ptrtoint ptr %12 to i64
  %dst2_int8 = add i64 %cast7, %10
  %cast9 = inttoptr i64 %dst2_int8 to ptr
  %rhs_len_p110 = add i64 %11, 1
  %14 = call ptr @memcpy(ptr %cast9, ptr @.str.20, i64 %rhs_len_p110)
  %e11 = load ptr, ptr %e, align 8
  %15 = call i64 @avra_trait_object_value(ptr %e11)
  %16 = call ptr @avra_trait_object_vtable(ptr %e11)
  %17 = call i64 @avra_array_get(ptr %16, i64 0)
  %18 = call i64 @avra_closure_call_1(i64 %17, i64 %15)
  %cast12 = inttoptr i64 %18 to ptr
  %19 = call i64 @strlen(ptr %12)
  %20 = call i64 @strlen(ptr %cast12)
  %concat_total13 = add i64 %19, %20
  %concat_size14 = add i64 %concat_total13, 1
  %21 = call ptr @avra_rc_alloc(i64 %concat_size14)
  %22 = call ptr @memcpy(ptr %21, ptr %12, i64 %19)
  %cast15 = ptrtoint ptr %21 to i64
  %dst2_int16 = add i64 %cast15, %19
  %cast17 = inttoptr i64 %dst2_int16 to ptr
  %rhs_len_p118 = add i64 %20, 1
  %23 = call ptr @memcpy(ptr %cast17, ptr %cast12, i64 %rhs_len_p118)
  ret ptr %21
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %pe = alloca ptr, align 8
  %e40 = alloca ptr, align 8
  %v25 = alloca ptr, align 8
  %match_stmt_discard = alloca i64, align 8
  %e = alloca ptr, align 8
  %val = alloca ptr, align 8
  %catch_result = alloca i64, align 8
  %1 = call ptr @might_fail(i64 -1)
  %catch_tag_ptr = getelementptr inbounds nuw %Result__string__string, ptr %1, i32 0, i32 0
  %catch_tag = load i64, ptr %catch_tag_ptr, align 8
  %catch_is_ok = icmp eq i64 %catch_tag, 5862623
  br i1 %catch_is_ok, label %catch_ok, label %catch_err

catch_ok:                                         ; preds = %entry
  %catch_pay_slot = getelementptr inbounds nuw %Result__string__string, ptr %1, i32 0, i32 1
  %catch_payload = load ptr, ptr %catch_pay_slot, align 8
  %catch_ok_val = load i64, ptr %catch_payload, align 8
  store i64 %catch_ok_val, ptr %catch_result, align 8
  br label %catch_merge

catch_err:                                        ; preds = %entry
  store i64 ptrtoint (ptr @.str.21 to i64), ptr %catch_result, align 8
  br label %catch_merge

catch_merge:                                      ; preds = %catch_err, %catch_ok
  %catch_merged = load i64, ptr %catch_result, align 8
  %cast = inttoptr i64 %catch_merged to ptr
  store ptr %cast, ptr %val, align 8
  %val1 = load ptr, ptr %val, align 8
  %2 = call i32 @puts(ptr %val1)
  %widen = sext i32 %2 to i64
  %3 = call ptr @avra_rc_alloc(i64 8)
  %fld_ptr = getelementptr inbounds nuw %IoError, ptr %3, i32 0, i32 0
  store ptr @.str.22, ptr %fld_ptr, align 8
  %cast2 = ptrtoint ptr %3 to i64
  %cast3 = inttoptr i64 %cast2 to ptr
  store ptr %cast3, ptr %e, align 8
  %e4 = load ptr, ptr %e, align 8
  %cast5 = ptrtoint ptr %e4 to i64
  %null_chk = icmp eq i64 %cast5, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.24, i64 4, ptr @sty_name.25, i64 7, i64 %null_ext, ptr @src_file.26, i64 109, i64 55)
  %4 = call ptr @IoError__kind(ptr %e4)
  %5 = call i64 @strlen(ptr @.str.23)
  %6 = call i64 @strlen(ptr %4)
  %concat_total = add i64 %5, %6
  %concat_size = add i64 %concat_total, 1
  %7 = call ptr @avra_rc_alloc(i64 %concat_size)
  %8 = call ptr @memcpy(ptr %7, ptr @.str.23, i64 %5)
  %cast6 = ptrtoint ptr %7 to i64
  %dst2_int = add i64 %cast6, %5
  %cast7 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %6, 1
  %9 = call ptr @memcpy(ptr %cast7, ptr %4, i64 %rhs_len_p1)
  %10 = call i64 @strlen(ptr %7)
  %11 = call i64 @strlen(ptr @.str.27)
  %concat_total8 = add i64 %10, %11
  %concat_size9 = add i64 %concat_total8, 1
  %12 = call ptr @avra_rc_alloc(i64 %concat_size9)
  %13 = call ptr @memcpy(ptr %12, ptr %7, i64 %10)
  %cast10 = ptrtoint ptr %12 to i64
  %dst2_int11 = add i64 %cast10, %10
  %cast12 = inttoptr i64 %dst2_int11 to ptr
  %rhs_len_p113 = add i64 %11, 1
  %14 = call ptr @memcpy(ptr %cast12, ptr @.str.27, i64 %rhs_len_p113)
  %e14 = load ptr, ptr %e, align 8
  %cast15 = ptrtoint ptr %e14 to i64
  %null_chk16 = icmp eq i64 %cast15, 0
  %null_ext17 = zext i1 %null_chk16 to i64
  call void @avra_null_deref_trap(ptr @fld_name.28, i64 7, ptr @sty_name.29, i64 7, i64 %null_ext17, ptr @src_file.30, i64 109, i64 55)
  %15 = call ptr @IoError__message(ptr %e14)
  %16 = call i64 @strlen(ptr %12)
  %17 = call i64 @strlen(ptr %15)
  %concat_total18 = add i64 %16, %17
  %concat_size19 = add i64 %concat_total18, 1
  %18 = call ptr @avra_rc_alloc(i64 %concat_size19)
  %19 = call ptr @memcpy(ptr %18, ptr %12, i64 %16)
  %cast20 = ptrtoint ptr %18 to i64
  %dst2_int21 = add i64 %cast20, %16
  %cast22 = inttoptr i64 %dst2_int21 to ptr
  %rhs_len_p123 = add i64 %17, 1
  %20 = call ptr @memcpy(ptr %cast22, ptr %15, i64 %rhs_len_p123)
  %21 = call i32 @puts(ptr %18)
  %widen24 = sext i32 %21 to i64
  %22 = call ptr @with_cleanup(i1 true)
  %tag_ptr = getelementptr inbounds nuw %Result__string__string, ptr %22, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %tag_eq = icmp eq i64 %tag, 5862623
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm34, %march_arm
  %23 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr49 = getelementptr inbounds nuw %ParseError, ptr %23, i32 0, i32 0
  store ptr @.str.33, ptr %fld_ptr49, align 8
  %fld_ptr50 = getelementptr inbounds nuw %ParseError, ptr %23, i32 0, i32 1
  store ptr @.str.34, ptr %fld_ptr50, align 8
  %cast51 = ptrtoint ptr %23 to i64
  %cast52 = inttoptr i64 %cast51 to ptr
  store ptr %cast52, ptr %pe, align 8
  %pe53 = load ptr, ptr %pe, align 8
  %24 = call ptr @avra_array_new()
  %25 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %25, i64 -559038737)
  call void @avra_array_push(ptr %25, i64 ptrtoint (ptr @ParseError__message to i64))
  %cast54 = ptrtoint ptr %25 to i64
  call void @avra_array_push(ptr %24, i64 %cast54)
  %26 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %26, i64 -559038737)
  call void @avra_array_push(ptr %26, i64 ptrtoint (ptr @ParseError__kind to i64))
  %cast55 = ptrtoint ptr %26 to i64
  call void @avra_array_push(ptr %24, i64 %cast55)
  %cast56 = ptrtoint ptr %24 to i64
  %27 = call i64 @avra_trait_object_new(ptr %pe53, i64 %cast56)
  %28 = call ptr @show_error(i64 %27)
  %29 = call i32 @puts(ptr %28)
  %widen57 = sext i32 %29 to i64
  %e_cleanup = load ptr, ptr %e40, align 8
  call void @avra_rc_release(ptr %e_cleanup)
  %e_cleanup58 = load ptr, ptr %e, align 8
  %30 = call i64 @__release_IoError(ptr %e_cleanup58)
  ret i64 0

march_arm:                                        ; preds = %catch_merge
  %pay_slot = getelementptr inbounds nuw %Result__string__string, ptr %22, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load ptr, ptr %v_slot, align 8
  call void @avra_rc_retain(ptr %v)
  store ptr %v, ptr %v25, align 8
  %v26 = load ptr, ptr %v25, align 8
  %31 = call i64 @strlen(ptr @.str.31)
  %32 = call i64 @strlen(ptr %v26)
  %concat_total27 = add i64 %31, %32
  %concat_size28 = add i64 %concat_total27, 1
  %33 = call ptr @avra_rc_alloc(i64 %concat_size28)
  %34 = call ptr @memcpy(ptr %33, ptr @.str.31, i64 %31)
  %cast29 = ptrtoint ptr %33 to i64
  %dst2_int30 = add i64 %cast29, %31
  %cast31 = inttoptr i64 %dst2_int30 to ptr
  %rhs_len_p132 = add i64 %32, 1
  %35 = call ptr @memcpy(ptr %cast31, ptr %v26, i64 %rhs_len_p132)
  %36 = call i32 @puts(ptr %33)
  %widen33 = sext i32 %36 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next:                                       ; preds = %catch_merge
  %tag_eq36 = icmp eq i64 %tag, 193456014
  br i1 %tag_eq36, label %march_arm34, label %march_next35

march_arm34:                                      ; preds = %march_next
  %pay_slot37 = getelementptr inbounds nuw %Result__string__string, ptr %22, i32 0, i32 1
  %payload38 = load ptr, ptr %pay_slot37, align 8
  %e_slot_base = ptrtoint ptr %payload38 to i64
  %e_slot_addr = add i64 %e_slot_base, 0
  %e_slot = inttoptr i64 %e_slot_addr to ptr
  %e39 = load ptr, ptr %e_slot, align 8
  call void @avra_rc_retain(ptr %e39)
  store ptr %e39, ptr %e40, align 8
  %e41 = load ptr, ptr %e40, align 8
  %37 = call i64 @strlen(ptr @.str.32)
  %38 = call i64 @strlen(ptr %e41)
  %concat_total42 = add i64 %37, %38
  %concat_size43 = add i64 %concat_total42, 1
  %39 = call ptr @avra_rc_alloc(i64 %concat_size43)
  %40 = call ptr @memcpy(ptr %39, ptr @.str.32, i64 %37)
  %cast44 = ptrtoint ptr %39 to i64
  %dst2_int45 = add i64 %cast44, %37
  %cast46 = inttoptr i64 %dst2_int45 to ptr
  %rhs_len_p147 = add i64 %38, 1
  %41 = call ptr @memcpy(ptr %cast46, ptr %e41, i64 %rhs_len_p147)
  %42 = call i32 @puts(ptr %39)
  %widen48 = sext i32 %42 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next35:                                     ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 58)
  unreachable
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_ParseError(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_msg_ptr = getelementptr inbounds nuw %ParseError, ptr %0, i32 0, i32 0
  %rel_msg = load ptr, ptr %rel_msg_ptr, align 8
  %is_null_msg = icmp eq ptr %rel_msg, null
  br i1 %is_null_msg, label %rel_msg_skip, label %rel_msg_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_file_skip
  ret i64 0

rel_msg_skip:                                     ; preds = %rel_msg_do, %do_free
  %rel_file_ptr = getelementptr inbounds nuw %ParseError, ptr %0, i32 0, i32 1
  %rel_file = load ptr, ptr %rel_file_ptr, align 8
  %is_null_file = icmp eq ptr %rel_file, null
  br i1 %is_null_file, label %rel_file_skip, label %rel_file_do

rel_msg_do:                                       ; preds = %do_free
  call void @avra_rc_release(ptr %rel_msg)
  br label %rel_msg_skip

rel_file_skip:                                    ; preds = %rel_file_do, %rel_msg_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_file_do:                                      ; preds = %rel_msg_skip
  call void @avra_rc_release(ptr %rel_file)
  br label %rel_file_skip
}

define i64 @__release_IoError(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_msg_ptr = getelementptr inbounds nuw %IoError, ptr %0, i32 0, i32 0
  %rel_msg = load ptr, ptr %rel_msg_ptr, align 8
  %is_null_msg = icmp eq ptr %rel_msg, null
  br i1 %is_null_msg, label %rel_msg_skip, label %rel_msg_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_msg_skip
  ret i64 0

rel_msg_skip:                                     ; preds = %rel_msg_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_msg_do:                                       ; preds = %do_free
  call void @avra_rc_release(ptr %rel_msg)
  br label %rel_msg_skip
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
