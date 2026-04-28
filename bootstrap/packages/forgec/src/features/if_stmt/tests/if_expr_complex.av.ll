; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Pair = type { i64, i64 }

@x = global i64 0
@label = global i64 0
@p = global i64 0
@.str = private unnamed_addr constant [5 x i8] c"high\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"mid\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"low\00", align 1
@.str.3 = private unnamed_addr constant [4 x i8] c"yes\00", align 1
@.str.4 = private unnamed_addr constant [3 x i8] c"no\00", align 1
@fld_name = private unnamed_addr constant [2 x i8] c"a\00", align 1
@sty_name = private unnamed_addr constant [5 x i8] c"Pair\00", align 1
@src_file = private unnamed_addr constant [139 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/if_stmt/tests/if_expr_complex.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name.5 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@sty_name.6 = private unnamed_addr constant [5 x i8] c"Pair\00", align 1
@src_file.7 = private unnamed_addr constant [139 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/if_stmt/tests/if_expr_complex.av\00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define i64 @greet(ptr %0) {
entry:
  %msg = alloca ptr, align 8
  store ptr %0, ptr %msg, align 8
  %msg1 = load ptr, ptr %msg, align 8
  %1 = call i32 @puts(ptr %msg1)
  %widen = sext i32 %1 to i64
  ret i64 0
}

define i64 @main() {
entry:
  %ife_result20 = alloca i64, align 8
  %ife_result15 = alloca i64, align 8
  %ife_result10 = alloca i64, align 8
  %ife_result4 = alloca i64, align 8
  %ife_result = alloca i64, align 8
  store i64 15, ptr @x, align 8
  %x = load i64, ptr @x, align 8
  %sgt = icmp sgt i64 %x, 20
  %sgt_ext = zext i1 %sgt to i64
  %ife_cond = icmp ne i64 %sgt_ext, 0
  br i1 %ife_cond, label %ife_then, label %ife_else

ife_end:                                          ; preds = %ife_end5, %ife_then
  %ife_val9 = load i64, ptr %ife_result, align 8
  store i64 %ife_val9, ptr @label, align 8
  %label = load ptr, ptr @label, align 8
  %0 = call i32 @puts(ptr %label)
  %widen = sext i32 %0 to i64
  br i1 true, label %ife_then12, label %ife_else13

ife_then:                                         ; preds = %entry
  store i64 ptrtoint (ptr @.str to i64), ptr %ife_result, align 8
  br label %ife_end

ife_else:                                         ; preds = %entry
  %x1 = load i64, ptr @x, align 8
  %sgt2 = icmp sgt i64 %x1, 10
  %sgt_ext3 = zext i1 %sgt2 to i64
  %ife_cond6 = icmp ne i64 %sgt_ext3, 0
  br i1 %ife_cond6, label %ife_then7, label %ife_else8

ife_end5:                                         ; preds = %ife_else8, %ife_then7
  %ife_val = load i64, ptr %ife_result4, align 8
  store i64 %ife_val, ptr %ife_result, align 8
  br label %ife_end

ife_then7:                                        ; preds = %ife_else
  store i64 ptrtoint (ptr @.str.1 to i64), ptr %ife_result4, align 8
  br label %ife_end5

ife_else8:                                        ; preds = %ife_else
  store i64 ptrtoint (ptr @.str.2 to i64), ptr %ife_result4, align 8
  br label %ife_end5

ife_end11:                                        ; preds = %ife_else13, %ife_then12
  %ife_val14 = load i64, ptr %ife_result10, align 8
  %cast = inttoptr i64 %ife_val14 to ptr
  %1 = call i64 @greet(ptr %cast)
  %2 = call ptr @avra_rc_alloc(i64 16)
  br i1 true, label %ife_then17, label %ife_else18

ife_then12:                                       ; preds = %ife_end
  store i64 ptrtoint (ptr @.str.3 to i64), ptr %ife_result10, align 8
  br label %ife_end11

ife_else13:                                       ; preds = %ife_end
  store i64 ptrtoint (ptr @.str.4 to i64), ptr %ife_result10, align 8
  br label %ife_end11

ife_end16:                                        ; preds = %ife_else18, %ife_then17
  %ife_val19 = load i64, ptr %ife_result15, align 8
  %fld_ptr = getelementptr inbounds nuw %Pair, ptr %2, i32 0, i32 0
  store i64 %ife_val19, ptr %fld_ptr, align 8
  br i1 false, label %ife_then22, label %ife_else23

ife_then17:                                       ; preds = %ife_end11
  store i64 1, ptr %ife_result15, align 8
  br label %ife_end16

ife_else18:                                       ; preds = %ife_end11
  store i64 0, ptr %ife_result15, align 8
  br label %ife_end16

ife_end21:                                        ; preds = %ife_else23, %ife_then22
  %ife_val24 = load i64, ptr %ife_result20, align 8
  %fld_ptr25 = getelementptr inbounds nuw %Pair, ptr %2, i32 0, i32 1
  store i64 %ife_val24, ptr %fld_ptr25, align 8
  %cast26 = ptrtoint ptr %2 to i64
  store i64 %cast26, ptr @p, align 8
  %p = load ptr, ptr @p, align 8
  %cast27 = ptrtoint ptr %p to i64
  %null_chk = icmp eq i64 %cast27, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 1, ptr @sty_name, i64 4, i64 %null_ext, ptr @src_file, i64 138, i64 14)
  %a_ptr = getelementptr inbounds nuw %Pair, ptr %p, i32 0, i32 0
  %a = load i64, ptr %a_ptr, align 8
  %3 = call ptr @avra_rc_alloc(i64 32)
  %4 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %3, i64 32, ptr @.i2s_fmt, i64 %a)
  %widen28 = sext i32 %4 to i64
  %5 = call i32 @puts(ptr %3)
  %widen29 = sext i32 %5 to i64
  %p30 = load ptr, ptr @p, align 8
  %cast31 = ptrtoint ptr %p30 to i64
  %null_chk32 = icmp eq i64 %cast31, 0
  %null_ext33 = zext i1 %null_chk32 to i64
  call void @avra_null_deref_trap(ptr @fld_name.5, i64 1, ptr @sty_name.6, i64 4, i64 %null_ext33, ptr @src_file.7, i64 138, i64 15)
  %b_ptr = getelementptr inbounds nuw %Pair, ptr %p30, i32 0, i32 1
  %b = load i64, ptr %b_ptr, align 8
  %6 = call ptr @avra_rc_alloc(i64 32)
  %7 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %6, i64 32, ptr @.i2s_fmt.8, i64 %b)
  %widen34 = sext i32 %7 to i64
  %8 = call i32 @puts(ptr %6)
  %widen35 = sext i32 %8 to i64
  %9 = call i32 @avra_test_summary()
  %widen36 = sext i32 %9 to i64
  call void @avra_rc_collect()
  ret i64 0

ife_then22:                                       ; preds = %ife_end16
  store i64 1, ptr %ife_result20, align 8
  br label %ife_end21

ife_else23:                                       ; preds = %ife_end16
  store i64 0, ptr %ife_result20, align 8
  br label %ife_end21
}
