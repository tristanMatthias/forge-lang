; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Dir = type { i64, ptr }

@d = global i64 0
@val = global i64 0
@label = global i64 0
@score = global i64 0
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [140 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/match_as_expr.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str = private unnamed_addr constant [6 x i8] c"north\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"south\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"east\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"west\00", align 1
@.match_fn.4 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.5 = private unnamed_addr constant [140 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/match_as_expr.av\00", align 1
@.match_fn.6 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.7 = private unnamed_addr constant [140 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/match_as_expr.av\00", align 1
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

define i64 @double(i64 %0) {
entry:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  %n1 = load i64, ptr %n, align 8
  %mul = mul i64 %n1, 2
  ret i64 %mul
}

define i64 @main() {
entry:
  %match_result34 = alloca i64, align 8
  %match_result15 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %0 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Dir, ptr %0, i32 0, i32 0
  store i64 177642, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Dir, ptr %0, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %0 to i64
  store i64 %cast, ptr @d, align 8
  %d = load ptr, ptr @d, align 8
  %tag_ptr1 = getelementptr inbounds nuw %Dir, ptr %d, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr1, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 177651
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm8, %march_arm5, %march_arm2, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %1 = call i64 @double(i64 %match_val)
  store i64 %1, ptr @val, align 8
  %val = load i64, ptr @val, align 8
  %2 = call ptr @avra_rc_alloc(i64 32)
  %3 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %2, i64 32, ptr @.i2s_fmt, i64 %val)
  %widen = sext i32 %3 to i64
  %4 = call i32 @puts(ptr %2)
  %widen11 = sext i32 %4 to i64
  %d12 = load ptr, ptr @d, align 8
  %tag_ptr13 = getelementptr inbounds nuw %Dir, ptr %d12, i32 0, i32 0
  %tag14 = load i64, ptr %tag_ptr13, align 8
  store i64 0, ptr %match_result15, align 8
  %tag_eq19 = icmp eq i64 %tag14, 177651
  br i1 %tag_eq19, label %march_arm17, label %march_next18

march_arm:                                        ; preds = %entry
  store i64 1, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 177656
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  store i64 2, ptr %match_result, align 8
  br label %match_end

march_next3:                                      ; preds = %march_next
  %tag_eq7 = icmp eq i64 %tag, 177642
  br i1 %tag_eq7, label %march_arm5, label %march_next6

march_arm5:                                       ; preds = %march_next3
  store i64 3, ptr %match_result, align 8
  br label %match_end

march_next6:                                      ; preds = %march_next3
  %tag_eq10 = icmp eq i64 %tag, 177660
  br i1 %tag_eq10, label %march_arm8, label %march_next9

march_arm8:                                       ; preds = %march_next6
  store i64 4, ptr %match_result, align 8
  br label %match_end

march_next9:                                      ; preds = %march_next6
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 7)
  unreachable

match_end16:                                      ; preds = %march_arm26, %march_arm23, %march_arm20, %march_arm17
  %match_val29 = load i64, ptr %match_result15, align 8
  store i64 %match_val29, ptr @label, align 8
  %label = load ptr, ptr @label, align 8
  %5 = call i32 @puts(ptr %label)
  %widen30 = sext i32 %5 to i64
  %d31 = load ptr, ptr @d, align 8
  %tag_ptr32 = getelementptr inbounds nuw %Dir, ptr %d31, i32 0, i32 0
  %tag33 = load i64, ptr %tag_ptr32, align 8
  store i64 0, ptr %match_result34, align 8
  %tag_eq38 = icmp eq i64 %tag33, 177651
  br i1 %tag_eq38, label %march_arm36, label %march_next37

march_arm17:                                      ; preds = %match_end
  store i64 ptrtoint (ptr @.str to i64), ptr %match_result15, align 8
  br label %match_end16

march_next18:                                     ; preds = %match_end
  %tag_eq22 = icmp eq i64 %tag14, 177656
  br i1 %tag_eq22, label %march_arm20, label %march_next21

march_arm20:                                      ; preds = %march_next18
  store i64 ptrtoint (ptr @.str.1 to i64), ptr %match_result15, align 8
  br label %match_end16

march_next21:                                     ; preds = %march_next18
  %tag_eq25 = icmp eq i64 %tag14, 177642
  br i1 %tag_eq25, label %march_arm23, label %march_next24

march_arm23:                                      ; preds = %march_next21
  store i64 ptrtoint (ptr @.str.2 to i64), ptr %match_result15, align 8
  br label %match_end16

march_next24:                                     ; preds = %march_next21
  %tag_eq28 = icmp eq i64 %tag14, 177660
  br i1 %tag_eq28, label %march_arm26, label %march_next27

march_arm26:                                      ; preds = %march_next24
  store i64 ptrtoint (ptr @.str.3 to i64), ptr %match_result15, align 8
  br label %match_end16

march_next27:                                     ; preds = %march_next24
  call void @avra_match_unreachable(ptr @.match_fn.4, i64 %tag14, ptr @mu_file.5, i64 11)
  unreachable

match_end35:                                      ; preds = %march_arm45, %march_arm42, %march_arm39, %march_arm36
  %match_val48 = load i64, ptr %match_result34, align 8
  %add = add i64 100, %match_val48
  store i64 %add, ptr @score, align 8
  %score = load i64, ptr @score, align 8
  %6 = call ptr @avra_rc_alloc(i64 32)
  %7 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %6, i64 32, ptr @.i2s_fmt.8, i64 %score)
  %widen49 = sext i32 %7 to i64
  %8 = call i32 @puts(ptr %6)
  %widen50 = sext i32 %8 to i64
  %9 = call i32 @avra_test_summary()
  %widen51 = sext i32 %9 to i64
  call void @avra_rc_collect()
  ret i64 0

march_arm36:                                      ; preds = %match_end16
  store i64 1, ptr %match_result34, align 8
  br label %match_end35

march_next37:                                     ; preds = %match_end16
  %tag_eq41 = icmp eq i64 %tag33, 177656
  br i1 %tag_eq41, label %march_arm39, label %march_next40

march_arm39:                                      ; preds = %march_next37
  store i64 2, ptr %match_result34, align 8
  br label %match_end35

march_next40:                                     ; preds = %march_next37
  %tag_eq44 = icmp eq i64 %tag33, 177642
  br i1 %tag_eq44, label %march_arm42, label %march_next43

march_arm42:                                      ; preds = %march_next40
  store i64 3, ptr %match_result34, align 8
  br label %match_end35

march_next43:                                     ; preds = %march_next40
  %tag_eq47 = icmp eq i64 %tag33, 177660
  br i1 %tag_eq47, label %march_arm45, label %march_next46

march_arm45:                                      ; preds = %march_next43
  store i64 4, ptr %match_result34, align 8
  br label %match_end35

march_next46:                                     ; preds = %march_next43
  call void @avra_match_unreachable(ptr @.match_fn.6, i64 %tag33, ptr @mu_file.7, i64 20)
  unreachable
}
