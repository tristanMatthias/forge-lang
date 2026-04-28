; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@.str = private unnamed_addr constant [9 x i8] c"negative\00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"zero\00", align 1
@.str.2 = private unnamed_addr constant [6 x i8] c"small\00", align 1
@.str.3 = private unnamed_addr constant [6 x i8] c"large\00", align 1
@dz_file = private unnamed_addr constant [143 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/match_expr/tests/subjectless_match.av\00", align 1
@.str.4 = private unnamed_addr constant [9 x i8] c"fizzbuzz\00", align 1
@dz_file.5 = private unnamed_addr constant [143 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/match_expr/tests/subjectless_match.av\00", align 1
@.str.6 = private unnamed_addr constant [5 x i8] c"fizz\00", align 1
@dz_file.7 = private unnamed_addr constant [143 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/avrac/src/features/match_expr/tests/subjectless_match.av\00", align 1
@.str.8 = private unnamed_addr constant [5 x i8] c"buzz\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.9 = private unnamed_addr constant [5 x i8] c"pass\00", align 1
@.str.10 = private unnamed_addr constant [5 x i8] c"fail\00", align 1

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

define ptr @classify(i64 %0) {
entry:
  %when_result = alloca i64, align 8
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  store i64 0, ptr %when_result, align 8
  %n1 = load i64, ptr %n, align 8
  %slt = icmp slt i64 %n1, 0
  %slt_ext = zext i1 %slt to i64
  %when_cond = icmp ne i64 %slt_ext, 0
  br i1 %when_cond, label %when_arm, label %when_next

when_end:                                         ; preds = %when_next11, %when_arm10, %when_arm4, %when_arm
  %when_val = load i64, ptr %when_result, align 8
  %cast = inttoptr i64 %when_val to ptr
  ret ptr %cast

when_arm:                                         ; preds = %entry
  store i64 ptrtoint (ptr @.str to i64), ptr %when_result, align 8
  br label %when_end

when_next:                                        ; preds = %entry
  %n2 = load i64, ptr %n, align 8
  %eq = icmp eq i64 %n2, 0
  %eq_ext = zext i1 %eq to i64
  %when_cond3 = icmp ne i64 %eq_ext, 0
  br i1 %when_cond3, label %when_arm4, label %when_next5

when_arm4:                                        ; preds = %when_next
  store i64 ptrtoint (ptr @.str.1 to i64), ptr %when_result, align 8
  br label %when_end

when_next5:                                       ; preds = %when_next
  %n6 = load i64, ptr %n, align 8
  %slt7 = icmp slt i64 %n6, 10
  %slt_ext8 = zext i1 %slt7 to i64
  %when_cond9 = icmp ne i64 %slt_ext8, 0
  br i1 %when_cond9, label %when_arm10, label %when_next11

when_arm10:                                       ; preds = %when_next5
  store i64 ptrtoint (ptr @.str.2 to i64), ptr %when_result, align 8
  br label %when_end

when_next11:                                      ; preds = %when_next5
  store i64 ptrtoint (ptr @.str.3 to i64), ptr %when_result, align 8
  br label %when_end
}

define ptr @fizzbuzz(i64 %0) {
entry:
  %when_result = alloca i64, align 8
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  store i64 0, ptr %when_result, align 8
  %n1 = load i64, ptr %n, align 8
  call void @avra_div_by_zero_trap(i64 0, ptr @dz_file, i64 142, i64 24)
  %mod = srem i64 %n1, 15
  %eq = icmp eq i64 %mod, 0
  %eq_ext = zext i1 %eq to i64
  %when_cond = icmp ne i64 %eq_ext, 0
  br i1 %when_cond, label %when_arm, label %when_next

when_end:                                         ; preds = %when_next15, %when_arm14, %when_arm7, %when_arm
  %when_val = load i64, ptr %when_result, align 8
  %cast17 = inttoptr i64 %when_val to ptr
  ret ptr %cast17

when_arm:                                         ; preds = %entry
  store i64 ptrtoint (ptr @.str.4 to i64), ptr %when_result, align 8
  br label %when_end

when_next:                                        ; preds = %entry
  %n2 = load i64, ptr %n, align 8
  call void @avra_div_by_zero_trap(i64 0, ptr @dz_file.5, i64 142, i64 24)
  %mod3 = srem i64 %n2, 3
  %eq4 = icmp eq i64 %mod3, 0
  %eq_ext5 = zext i1 %eq4 to i64
  %when_cond6 = icmp ne i64 %eq_ext5, 0
  br i1 %when_cond6, label %when_arm7, label %when_next8

when_arm7:                                        ; preds = %when_next
  store i64 ptrtoint (ptr @.str.6 to i64), ptr %when_result, align 8
  br label %when_end

when_next8:                                       ; preds = %when_next
  %n9 = load i64, ptr %n, align 8
  call void @avra_div_by_zero_trap(i64 0, ptr @dz_file.7, i64 142, i64 24)
  %mod10 = srem i64 %n9, 5
  %eq11 = icmp eq i64 %mod10, 0
  %eq_ext12 = zext i1 %eq11 to i64
  %when_cond13 = icmp ne i64 %eq_ext12, 0
  br i1 %when_cond13, label %when_arm14, label %when_next15

when_arm14:                                       ; preds = %when_next8
  store i64 ptrtoint (ptr @.str.8 to i64), ptr %when_result, align 8
  br label %when_end

when_next15:                                      ; preds = %when_next8
  %n16 = load i64, ptr %n, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %n16)
  %widen = sext i32 %2 to i64
  %cast = ptrtoint ptr %1 to i64
  store i64 %cast, ptr %when_result, align 8
  br label %when_end
}

define ptr @grade(i64 %0) {
entry:
  %when_result = alloca i64, align 8
  %score = alloca i64, align 8
  store i64 %0, ptr %score, align 8
  store i64 0, ptr %when_result, align 8
  %score1 = load i64, ptr %score, align 8
  %sge = icmp sge i64 %score1, 90
  %sge_ext = zext i1 %sge to i64
  %when_cond = icmp ne i64 %sge_ext, 0
  br i1 %when_cond, label %when_arm, label %when_next

when_end:                                         ; preds = %when_next, %when_arm
  %when_val = load i64, ptr %when_result, align 8
  %cast = inttoptr i64 %when_val to ptr
  ret ptr %cast

when_arm:                                         ; preds = %entry
  store i64 ptrtoint (ptr @.str.9 to i64), ptr %when_result, align 8
  br label %when_end

when_next:                                        ; preds = %entry
  store i64 ptrtoint (ptr @.str.10 to i64), ptr %when_result, align 8
  br label %when_end
}

define i64 @main() {
entry:
  %0 = call ptr @classify(i64 -5)
  %1 = call i32 @puts(ptr %0)
  %widen = sext i32 %1 to i64
  %2 = call ptr @classify(i64 0)
  %3 = call i32 @puts(ptr %2)
  %widen1 = sext i32 %3 to i64
  %4 = call ptr @classify(i64 7)
  %5 = call i32 @puts(ptr %4)
  %widen2 = sext i32 %5 to i64
  %6 = call ptr @classify(i64 100)
  %7 = call i32 @puts(ptr %6)
  %widen3 = sext i32 %7 to i64
  %8 = call ptr @fizzbuzz(i64 15)
  %9 = call i32 @puts(ptr %8)
  %widen4 = sext i32 %9 to i64
  %10 = call ptr @fizzbuzz(i64 9)
  %11 = call i32 @puts(ptr %10)
  %widen5 = sext i32 %11 to i64
  %12 = call ptr @fizzbuzz(i64 10)
  %13 = call i32 @puts(ptr %12)
  %widen6 = sext i32 %13 to i64
  %14 = call ptr @fizzbuzz(i64 7)
  %15 = call i32 @puts(ptr %14)
  %widen7 = sext i32 %15 to i64
  %16 = call ptr @grade(i64 95)
  %17 = call i32 @puts(ptr %16)
  %widen8 = sext i32 %17 to i64
  %18 = call ptr @grade(i64 50)
  %19 = call i32 @puts(ptr %18)
  %widen9 = sext i32 %19 to i64
  %20 = call i32 @avra_test_summary()
  %widen10 = sext i32 %20 to i64
  call void @avra_rc_collect()
  ret i64 0
}
