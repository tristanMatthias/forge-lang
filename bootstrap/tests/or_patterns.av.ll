; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Size = type { i64, ptr }

@.str = private unnamed_addr constant [6 x i8] c"small\00", align 1
@.str.1 = private unnamed_addr constant [7 x i8] c"medium\00", align 1
@.match_fn = private unnamed_addr constant [9 x i8] c"classify\00", align 1
@mu_file = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/or_patterns.av\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"big\00", align 1
@.match_fn.3 = private unnamed_addr constant [9 x i8] c"classify\00", align 1
@mu_file.4 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/or_patterns.av\00", align 1
@.str.5 = private unnamed_addr constant [10 x i8] c"positive \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.6 = private unnamed_addr constant [10 x i8] c"negative \00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.8 = private unnamed_addr constant [5 x i8] c"zero\00", align 1
@.match_fn.9 = private unnamed_addr constant [12 x i8] c"check_guard\00", align 1
@mu_file.10 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/or_patterns.av\00", align 1
@.str.11 = private unnamed_addr constant [10 x i8] c"guarded: \00", align 1

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

define ptr @classify(ptr %0) {
entry:
  %match_result6 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %tag_ptr = getelementptr inbounds nuw %Size, ptr %s1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 210690007614
  br i1 %tag_eq, label %march_arm, label %or_mid

match_end:                                        ; preds = %march_arm13, %match_end7
  %match_val18 = load i64, ptr %match_result, align 8
  %cast = inttoptr i64 %match_val18 to ptr
  ret ptr %cast

march_arm:                                        ; preds = %or_mid, %entry
  %s3 = load ptr, ptr %s, align 8
  %tag_ptr4 = getelementptr inbounds nuw %Size, ptr %s3, i32 0, i32 0
  %tag5 = load i64, ptr %tag_ptr4, align 8
  store i64 0, ptr %match_result6, align 8
  %tag_eq10 = icmp eq i64 %tag5, 210690007614
  br i1 %tag_eq10, label %march_arm8, label %march_next9

march_next:                                       ; preds = %or_mid
  %tag_eq16 = icmp eq i64 %tag, 210681293264
  br i1 %tag_eq16, label %march_arm13, label %or_mid15

or_mid:                                           ; preds = %entry
  %tag_eq2 = icmp eq i64 %tag, 6952526056486
  br i1 %tag_eq2, label %march_arm, label %march_next

match_end7:                                       ; preds = %march_arm11, %march_arm8
  %match_val = load i64, ptr %match_result6, align 8
  store i64 %match_val, ptr %match_result, align 8
  br label %match_end

march_arm8:                                       ; preds = %march_arm
  store i64 ptrtoint (ptr @.str to i64), ptr %match_result6, align 8
  br label %match_end7

march_next9:                                      ; preds = %march_arm
  br label %march_arm11

march_arm11:                                      ; preds = %march_next9
  store i64 ptrtoint (ptr @.str.1 to i64), ptr %match_result6, align 8
  br label %match_end7

march_next12:                                     ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag5, ptr @mu_file, i64 12)
  unreachable

march_arm13:                                      ; preds = %or_mid15, %march_next
  store i64 ptrtoint (ptr @.str.2 to i64), ptr %match_result, align 8
  br label %match_end

march_next14:                                     ; preds = %or_mid15
  call void @avra_match_unreachable(ptr @.match_fn.3, i64 %tag, ptr @mu_file.4, i64 9)
  unreachable

or_mid15:                                         ; preds = %march_next
  %tag_eq17 = icmp eq i64 %tag, 6952926799304
  br i1 %tag_eq17, label %march_arm13, label %march_next14
}

define ptr @check_guard(i64 %0) {
entry:
  %pmatch_result = alloca i64, align 8
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  store i64 0, ptr %pmatch_result, align 8
  %x2 = load i64, ptr %x, align 8
  %sgt = icmp sgt i64 %x2, 0
  %sgt_ext = zext i1 %sgt to i64
  %pguard = icmp ne i64 %sgt_ext, 0
  br i1 %pguard, label %parm_body, label %parm_next

pmatch_end:                                       ; preds = %parm_body19, %parm_body6, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  %cast21 = inttoptr i64 %pmatch_val to ptr
  ret ptr %cast21

parm_body:                                        ; preds = %entry
  %x3 = load i64, ptr %x, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %x3)
  %widen = sext i32 %2 to i64
  %3 = call i64 @strlen(ptr @.str.5)
  %4 = call i64 @strlen(ptr %1)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @avra_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr @.str.5, i64 %3)
  %cast = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast, %3
  %cast4 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast4, ptr %1, i64 %rhs_len_p1)
  %cast5 = ptrtoint ptr %5 to i64
  store i64 %cast5, ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %entry
  %x8 = load i64, ptr %x, align 8
  %slt = icmp slt i64 %x8, 0
  %slt_ext = zext i1 %slt to i64
  %pguard9 = icmp ne i64 %slt_ext, 0
  br i1 %pguard9, label %parm_body6, label %parm_next7

parm_body6:                                       ; preds = %parm_next
  %x10 = load i64, ptr %x, align 8
  %8 = call ptr @avra_rc_alloc(i64 32)
  %9 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %8, i64 32, ptr @.i2s_fmt.7, i64 %x10)
  %widen11 = sext i32 %9 to i64
  %10 = call i64 @strlen(ptr @.str.6)
  %11 = call i64 @strlen(ptr %8)
  %concat_total12 = add i64 %10, %11
  %concat_size13 = add i64 %concat_total12, 1
  %12 = call ptr @avra_rc_alloc(i64 %concat_size13)
  %13 = call ptr @memcpy(ptr %12, ptr @.str.6, i64 %10)
  %cast14 = ptrtoint ptr %12 to i64
  %dst2_int15 = add i64 %cast14, %10
  %cast16 = inttoptr i64 %dst2_int15 to ptr
  %rhs_len_p117 = add i64 %11, 1
  %14 = call ptr @memcpy(ptr %cast16, ptr %8, i64 %rhs_len_p117)
  %cast18 = ptrtoint ptr %12 to i64
  store i64 %cast18, ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next7:                                       ; preds = %parm_next
  br label %parm_body19

parm_body19:                                      ; preds = %parm_next7
  store i64 ptrtoint (ptr @.str.8 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next20:                                      ; No predecessors!
  call void @avra_match_unreachable(ptr @.match_fn.9, i64 -1, ptr @mu_file.10, i64 19)
  unreachable
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %1 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Size, ptr %1, i32 0, i32 0
  store i64 210690007614, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Size, ptr %1, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %1 to i64
  %cast1 = inttoptr i64 %cast to ptr
  %2 = call ptr @classify(ptr %cast1)
  %3 = call i32 @puts(ptr %2)
  %widen = sext i32 %3 to i64
  %4 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr2 = getelementptr inbounds nuw %Size, ptr %4, i32 0, i32 0
  store i64 6952526056486, ptr %tag_ptr2, align 8
  %pay_ptr3 = getelementptr inbounds nuw %Size, ptr %4, i32 0, i32 1
  store ptr null, ptr %pay_ptr3, align 8
  %cast4 = ptrtoint ptr %4 to i64
  %cast5 = inttoptr i64 %cast4 to ptr
  %5 = call ptr @classify(ptr %cast5)
  %6 = call i32 @puts(ptr %5)
  %widen6 = sext i32 %6 to i64
  %7 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr7 = getelementptr inbounds nuw %Size, ptr %7, i32 0, i32 0
  store i64 210681293264, ptr %tag_ptr7, align 8
  %pay_ptr8 = getelementptr inbounds nuw %Size, ptr %7, i32 0, i32 1
  store ptr null, ptr %pay_ptr8, align 8
  %cast9 = ptrtoint ptr %7 to i64
  %cast10 = inttoptr i64 %cast9 to ptr
  %8 = call ptr @classify(ptr %cast10)
  %9 = call i32 @puts(ptr %8)
  %widen11 = sext i32 %9 to i64
  %10 = call ptr @check_guard(i64 5)
  %11 = call i64 @strlen(ptr @.str.11)
  %12 = call i64 @strlen(ptr %10)
  %concat_total = add i64 %11, %12
  %concat_size = add i64 %concat_total, 1
  %13 = call ptr @avra_rc_alloc(i64 %concat_size)
  %14 = call ptr @memcpy(ptr %13, ptr @.str.11, i64 %11)
  %cast12 = ptrtoint ptr %13 to i64
  %dst2_int = add i64 %cast12, %11
  %cast13 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %12, 1
  %15 = call ptr @memcpy(ptr %cast13, ptr %10, i64 %rhs_len_p1)
  %16 = call i32 @puts(ptr %13)
  %widen14 = sext i32 %16 to i64
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}
