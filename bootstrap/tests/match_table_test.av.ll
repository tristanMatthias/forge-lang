; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%MtStatus = type { i64, ptr }

@.str = private unnamed_addr constant [6 x i8] c"label\00", align 1
@.str.1 = private unnamed_addr constant [7 x i8] c"active\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"code\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"A\00", align 1
@.str.4 = private unnamed_addr constant [6 x i8] c"label\00", align 1
@.str.5 = private unnamed_addr constant [8 x i8] c"pending\00", align 1
@.str.6 = private unnamed_addr constant [5 x i8] c"code\00", align 1
@.str.7 = private unnamed_addr constant [2 x i8] c"P\00", align 1
@.str.8 = private unnamed_addr constant [6 x i8] c"label\00", align 1
@.str.9 = private unnamed_addr constant [9 x i8] c"complete\00", align 1
@.str.10 = private unnamed_addr constant [5 x i8] c"code\00", align 1
@.str.11 = private unnamed_addr constant [2 x i8] c"D\00", align 1
@.match_fn = private unnamed_addr constant [13 x i8] c"mt_get_label\00", align 1
@mu_file = private unnamed_addr constant [26 x i8] c"tests/match_table_test.fg\00", align 1
@.str.12 = private unnamed_addr constant [6 x i8] c"label\00", align 1
@.str.13 = private unnamed_addr constant [6 x i8] c"label\00", align 1
@.str.14 = private unnamed_addr constant [7 x i8] c"active\00", align 1
@.str.15 = private unnamed_addr constant [5 x i8] c"code\00", align 1
@.str.16 = private unnamed_addr constant [2 x i8] c"A\00", align 1
@.str.17 = private unnamed_addr constant [6 x i8] c"label\00", align 1
@.str.18 = private unnamed_addr constant [8 x i8] c"pending\00", align 1
@.str.19 = private unnamed_addr constant [5 x i8] c"code\00", align 1
@.str.20 = private unnamed_addr constant [2 x i8] c"P\00", align 1
@.str.21 = private unnamed_addr constant [6 x i8] c"label\00", align 1
@.str.22 = private unnamed_addr constant [9 x i8] c"complete\00", align 1
@.str.23 = private unnamed_addr constant [5 x i8] c"code\00", align 1
@.str.24 = private unnamed_addr constant [2 x i8] c"D\00", align 1
@.match_fn.25 = private unnamed_addr constant [12 x i8] c"mt_get_code\00", align 1
@mu_file.26 = private unnamed_addr constant [26 x i8] c"tests/match_table_test.fg\00", align 1
@.str.27 = private unnamed_addr constant [5 x i8] c"code\00", align 1
@spec_str = private unnamed_addr constant [14 x i8] c"\22match table\22\00", align 1
@.str.28 = private unnamed_addr constant [7 x i8] c"active\00", align 1
@spec_str.29 = private unnamed_addr constant [15 x i8] c"\22active label\22\00", align 1
@.str.30 = private unnamed_addr constant [2 x i8] c"A\00", align 1
@spec_str.31 = private unnamed_addr constant [14 x i8] c"\22active code\22\00", align 1
@.str.32 = private unnamed_addr constant [9 x i8] c"complete\00", align 1
@spec_str.33 = private unnamed_addr constant [13 x i8] c"\22done label\22\00", align 1
@.str.34 = private unnamed_addr constant [2 x i8] c"D\00", align 1
@spec_str.35 = private unnamed_addr constant [12 x i8] c"\22done code\22\00", align 1

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

define ptr @mt_get_label(ptr %0) {
entry:
  %r = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %tag_ptr = getelementptr inbounds nuw %MtStatus, ptr %s1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 7571318870642210
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm6, %march_arm2, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast10 = inttoptr i64 %match_val to ptr
  store ptr %cast10, ptr %r, align 8
  %r11 = load ptr, ptr %r, align 8
  %1 = call i64 @forge_map_get_cstr(ptr %r11, ptr @.str.12)
  %cast12 = inttoptr i64 %1 to ptr
  ret ptr %cast12

march_arm:                                        ; preds = %entry
  %2 = call ptr @forge_map_new_cstr()
  call void @forge_map_set_cstr(ptr %2, ptr @.str, i64 ptrtoint (ptr @.str.1 to i64))
  call void @forge_map_set_cstr(ptr %2, ptr @.str.2, i64 ptrtoint (ptr @.str.3 to i64))
  %cast = ptrtoint ptr %2 to i64
  store i64 %cast, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 249853542174174283
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  %3 = call ptr @forge_map_new_cstr()
  call void @forge_map_set_cstr(ptr %3, ptr @.str.4, i64 ptrtoint (ptr @.str.5 to i64))
  call void @forge_map_set_cstr(ptr %3, ptr @.str.6, i64 ptrtoint (ptr @.str.7 to i64))
  %cast5 = ptrtoint ptr %3 to i64
  store i64 %cast5, ptr %match_result, align 8
  br label %match_end

march_next3:                                      ; preds = %march_next
  %tag_eq8 = icmp eq i64 %tag, 6952542701612
  br i1 %tag_eq8, label %march_arm6, label %march_next7

march_arm6:                                       ; preds = %march_next3
  %4 = call ptr @forge_map_new_cstr()
  call void @forge_map_set_cstr(ptr %4, ptr @.str.8, i64 ptrtoint (ptr @.str.9 to i64))
  call void @forge_map_set_cstr(ptr %4, ptr @.str.10, i64 ptrtoint (ptr @.str.11 to i64))
  %cast9 = ptrtoint ptr %4 to i64
  store i64 %cast9, ptr %match_result, align 8
  br label %match_end

march_next7:                                      ; preds = %march_next3
  call void @forge_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 6)
  unreachable
}

define ptr @mt_get_code(ptr %0) {
entry:
  %r = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %tag_ptr = getelementptr inbounds nuw %MtStatus, ptr %s1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 7571318870642210
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm6, %march_arm2, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast10 = inttoptr i64 %match_val to ptr
  store ptr %cast10, ptr %r, align 8
  %r11 = load ptr, ptr %r, align 8
  %1 = call i64 @forge_map_get_cstr(ptr %r11, ptr @.str.27)
  %cast12 = inttoptr i64 %1 to ptr
  ret ptr %cast12

march_arm:                                        ; preds = %entry
  %2 = call ptr @forge_map_new_cstr()
  call void @forge_map_set_cstr(ptr %2, ptr @.str.13, i64 ptrtoint (ptr @.str.14 to i64))
  call void @forge_map_set_cstr(ptr %2, ptr @.str.15, i64 ptrtoint (ptr @.str.16 to i64))
  %cast = ptrtoint ptr %2 to i64
  store i64 %cast, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 249853542174174283
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  %3 = call ptr @forge_map_new_cstr()
  call void @forge_map_set_cstr(ptr %3, ptr @.str.17, i64 ptrtoint (ptr @.str.18 to i64))
  call void @forge_map_set_cstr(ptr %3, ptr @.str.19, i64 ptrtoint (ptr @.str.20 to i64))
  %cast5 = ptrtoint ptr %3 to i64
  store i64 %cast5, ptr %match_result, align 8
  br label %match_end

march_next3:                                      ; preds = %march_next
  %tag_eq8 = icmp eq i64 %tag, 6952542701612
  br i1 %tag_eq8, label %march_arm6, label %march_next7

march_arm6:                                       ; preds = %march_next3
  %4 = call ptr @forge_map_new_cstr()
  call void @forge_map_set_cstr(ptr %4, ptr @.str.21, i64 ptrtoint (ptr @.str.22 to i64))
  call void @forge_map_set_cstr(ptr %4, ptr @.str.23, i64 ptrtoint (ptr @.str.24 to i64))
  %cast9 = ptrtoint ptr %4 to i64
  store i64 %cast9, ptr %match_result, align 8
  br label %match_end

march_next7:                                      ; preds = %march_next3
  call void @forge_match_unreachable(ptr @.match_fn.25, i64 %tag, ptr @mu_file.26, i64 16)
  unreachable
}

define i64 @main() {
entry:
  %0 = call i32 @forge_test_start_spec(ptr @spec_str)
  %widen = sext i32 %0 to i64
  %1 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %MtStatus, ptr %1, i32 0, i32 0
  store i64 7571318870642210, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %MtStatus, ptr %1, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %1 to i64
  %cast1 = inttoptr i64 %cast to ptr
  %2 = call ptr @mt_get_label(ptr %cast1)
  %3 = call i32 @strcmp(ptr %2, ptr @.str.28)
  %widen2 = sext i32 %3 to i64
  %streq_cmp = icmp eq i64 %widen2, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %4 = call i64 @forge_test_run_then(ptr @spec_str.29, i64 %streq_ext)
  %5 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr3 = getelementptr inbounds nuw %MtStatus, ptr %5, i32 0, i32 0
  store i64 7571318870642210, ptr %tag_ptr3, align 8
  %pay_ptr4 = getelementptr inbounds nuw %MtStatus, ptr %5, i32 0, i32 1
  store ptr null, ptr %pay_ptr4, align 8
  %cast5 = ptrtoint ptr %5 to i64
  %cast6 = inttoptr i64 %cast5 to ptr
  %6 = call ptr @mt_get_code(ptr %cast6)
  %7 = call i32 @strcmp(ptr %6, ptr @.str.30)
  %widen7 = sext i32 %7 to i64
  %streq_cmp8 = icmp eq i64 %widen7, 0
  %streq_ext9 = zext i1 %streq_cmp8 to i64
  %8 = call i64 @forge_test_run_then(ptr @spec_str.31, i64 %streq_ext9)
  %9 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr10 = getelementptr inbounds nuw %MtStatus, ptr %9, i32 0, i32 0
  store i64 6952542701612, ptr %tag_ptr10, align 8
  %pay_ptr11 = getelementptr inbounds nuw %MtStatus, ptr %9, i32 0, i32 1
  store ptr null, ptr %pay_ptr11, align 8
  %cast12 = ptrtoint ptr %9 to i64
  %cast13 = inttoptr i64 %cast12 to ptr
  %10 = call ptr @mt_get_label(ptr %cast13)
  %11 = call i32 @strcmp(ptr %10, ptr @.str.32)
  %widen14 = sext i32 %11 to i64
  %streq_cmp15 = icmp eq i64 %widen14, 0
  %streq_ext16 = zext i1 %streq_cmp15 to i64
  %12 = call i64 @forge_test_run_then(ptr @spec_str.33, i64 %streq_ext16)
  %13 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr17 = getelementptr inbounds nuw %MtStatus, ptr %13, i32 0, i32 0
  store i64 6952542701612, ptr %tag_ptr17, align 8
  %pay_ptr18 = getelementptr inbounds nuw %MtStatus, ptr %13, i32 0, i32 1
  store ptr null, ptr %pay_ptr18, align 8
  %cast19 = ptrtoint ptr %13 to i64
  %cast20 = inttoptr i64 %cast19 to ptr
  %14 = call ptr @mt_get_code(ptr %cast20)
  %15 = call i32 @strcmp(ptr %14, ptr @.str.34)
  %widen21 = sext i32 %15 to i64
  %streq_cmp22 = icmp eq i64 %widen21, 0
  %streq_ext23 = zext i1 %streq_cmp22 to i64
  %16 = call i64 @forge_test_run_then(ptr @spec_str.35, i64 %streq_ext23)
  %17 = call i32 @forge_test_end_spec(ptr @spec_str)
  %widen24 = sext i32 %17 to i64
  %18 = call i32 @forge_test_summary()
  %widen25 = sext i32 %18 to i64
  call void @forge_rc_collect()
  ret i64 0
}
