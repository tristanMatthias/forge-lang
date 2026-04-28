; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@dz_file = private unnamed_addr constant [113 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/stress_string_manipulation.av\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"fizzbuzz\00", align 1
@dz_file.2 = private unnamed_addr constant [113 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/stress_string_manipulation.av\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"fizz\00", align 1
@dz_file.4 = private unnamed_addr constant [113 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/stress_string_manipulation.av\00", align 1
@.str.5 = private unnamed_addr constant [5 x i8] c"buzz\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.6 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.7 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.8 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.9 = private unnamed_addr constant [11 x i8] c"fizzbuzz: \00", align 1
@.str.10 = private unnamed_addr constant [11 x i8] c"reversed: \00", align 1
@.str.11 = private unnamed_addr constant [14 x i8] c"Hello, world!\00", align 1
@.str.12 = private unnamed_addr constant [8 x i8] c"words: \00", align 1
@.str.13 = private unnamed_addr constant [14 x i8] c"one two three\00", align 1
@.i2s_fmt.14 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.15 = private unnamed_addr constant [13 x i8] c"palindrome: \00", align 1
@.str.16 = private unnamed_addr constant [8 x i8] c"racecar\00", align 1
@.i2s_fmt.17 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define ptr @fizzbuzz(i64 %0) {
entry:
  %s = alloca ptr, align 8
  %when_result = alloca i64, align 8
  %for_end = alloca i64, align 8
  %i = alloca i64, align 8
  %result = alloca ptr, align 8
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  store ptr @.str, ptr %result, align 8
  %n1 = load i64, ptr %n, align 8
  %add = add i64 %n1, 1
  store i64 1, ptr %i, align 8
  store i64 %add, ptr %for_end, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.incr, %entry
  %i2 = load i64, ptr %i, align 8
  %for_end_val = load i64, ptr %for_end, align 8
  %for_cmp = icmp slt i64 %i2, %for_end_val
  br i1 %for_cmp, label %for.body, label %for.exit

for.body:                                         ; preds = %for.cond
  store i64 0, ptr %when_result, align 8
  %i3 = load i64, ptr %i, align 8
  call void @avra_div_by_zero_trap(i64 0, ptr @dz_file, i64 112, i64 9)
  %mod = srem i64 %i3, 15
  %eq = icmp eq i64 %mod, 0
  %eq_ext = zext i1 %eq to i64
  %when_cond = icmp ne i64 %eq_ext, 0
  br i1 %when_cond, label %when_arm, label %when_next

for.incr:                                         ; preds = %ifcont
  %i33 = load i64, ptr %i, align 8
  %for_next = add i64 %i33, 1
  store i64 %for_next, ptr %i, align 8
  br label %for.cond

for.exit:                                         ; preds = %for.cond
  %result34 = load ptr, ptr %result, align 8
  ret ptr %result34

when_end:                                         ; preds = %when_next17, %when_arm16, %when_arm9, %when_arm
  %when_val = load i64, ptr %when_result, align 8
  %cast19 = inttoptr i64 %when_val to ptr
  store ptr %cast19, ptr %s, align 8
  %result20 = load ptr, ptr %result, align 8
  %1 = call i32 @strcmp(ptr %result20, ptr @.str.6)
  %widen21 = sext i32 %1 to i64
  %streq_cmp = icmp eq i64 %widen21, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %if_cond = icmp ne i64 %streq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

when_arm:                                         ; preds = %for.body
  store i64 ptrtoint (ptr @.str.1 to i64), ptr %when_result, align 8
  br label %when_end

when_next:                                        ; preds = %for.body
  %i4 = load i64, ptr %i, align 8
  call void @avra_div_by_zero_trap(i64 0, ptr @dz_file.2, i64 112, i64 9)
  %mod5 = srem i64 %i4, 3
  %eq6 = icmp eq i64 %mod5, 0
  %eq_ext7 = zext i1 %eq6 to i64
  %when_cond8 = icmp ne i64 %eq_ext7, 0
  br i1 %when_cond8, label %when_arm9, label %when_next10

when_arm9:                                        ; preds = %when_next
  store i64 ptrtoint (ptr @.str.3 to i64), ptr %when_result, align 8
  br label %when_end

when_next10:                                      ; preds = %when_next
  %i11 = load i64, ptr %i, align 8
  call void @avra_div_by_zero_trap(i64 0, ptr @dz_file.4, i64 112, i64 9)
  %mod12 = srem i64 %i11, 5
  %eq13 = icmp eq i64 %mod12, 0
  %eq_ext14 = zext i1 %eq13 to i64
  %when_cond15 = icmp ne i64 %eq_ext14, 0
  br i1 %when_cond15, label %when_arm16, label %when_next17

when_arm16:                                       ; preds = %when_next10
  store i64 ptrtoint (ptr @.str.5 to i64), ptr %when_result, align 8
  br label %when_end

when_next17:                                      ; preds = %when_next10
  %i18 = load i64, ptr %i, align 8
  %2 = call ptr @avra_rc_alloc(i64 32)
  %3 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %2, i64 32, ptr @.i2s_fmt, i64 %i18)
  %widen = sext i32 %3 to i64
  %cast = ptrtoint ptr %2 to i64
  store i64 %cast, ptr %when_result, align 8
  br label %when_end

ifcont:                                           ; preds = %if_else, %if_then
  br label %for.incr

if_then:                                          ; preds = %when_end
  %s22 = load ptr, ptr %s, align 8
  store ptr %s22, ptr %result, align 8
  br label %ifcont

if_else:                                          ; preds = %when_end
  %result23 = load ptr, ptr %result, align 8
  %4 = call i64 @strlen(ptr %result23)
  %5 = call i64 @strlen(ptr @.str.7)
  %concat_total = add i64 %4, %5
  %concat_size = add i64 %concat_total, 1
  %6 = call ptr @avra_rc_alloc(i64 %concat_size)
  %7 = call ptr @memcpy(ptr %6, ptr %result23, i64 %4)
  %cast24 = ptrtoint ptr %6 to i64
  %dst2_int = add i64 %cast24, %4
  %cast25 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %5, 1
  %8 = call ptr @memcpy(ptr %cast25, ptr @.str.7, i64 %rhs_len_p1)
  %s26 = load ptr, ptr %s, align 8
  %9 = call i64 @strlen(ptr %6)
  %10 = call i64 @strlen(ptr %s26)
  %concat_total27 = add i64 %9, %10
  %concat_size28 = add i64 %concat_total27, 1
  %11 = call ptr @avra_rc_alloc(i64 %concat_size28)
  %12 = call ptr @memcpy(ptr %11, ptr %6, i64 %9)
  %cast29 = ptrtoint ptr %11 to i64
  %dst2_int30 = add i64 %cast29, %9
  %cast31 = inttoptr i64 %dst2_int30 to ptr
  %rhs_len_p132 = add i64 %10, 1
  %13 = call ptr @memcpy(ptr %cast31, ptr %s26, i64 %rhs_len_p132)
  store ptr %11, ptr %result, align 8
  br label %ifcont
}

define i1 @is_palindrome(ptr %0) {
entry:
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %s2 = load ptr, ptr %s, align 8
  %1 = call ptr @avra_str_reverse(ptr %s2)
  %2 = call i32 @strcmp(ptr %s1, ptr %1)
  %widen = sext i32 %2 to i64
  %streq_cmp = icmp eq i64 %widen, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %cast = trunc i64 %streq_ext to i1
  ret i1 %cast
}

define i64 @count_words(ptr %0) {
entry:
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %1 = call ptr @avra_str_split(ptr %s1, ptr @.str.8)
  %2 = call i64 @avra_array_len(ptr %1)
  ret i64 %2
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %1 = call ptr @fizzbuzz(i64 15)
  %2 = call i64 @strlen(ptr @.str.9)
  %3 = call i64 @strlen(ptr %1)
  %concat_total = add i64 %2, %3
  %concat_size = add i64 %concat_total, 1
  %4 = call ptr @avra_rc_alloc(i64 %concat_size)
  %5 = call ptr @memcpy(ptr %4, ptr @.str.9, i64 %2)
  %cast = ptrtoint ptr %4 to i64
  %dst2_int = add i64 %cast, %2
  %cast1 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %3, 1
  %6 = call ptr @memcpy(ptr %cast1, ptr %1, i64 %rhs_len_p1)
  %7 = call i32 @puts(ptr %4)
  %widen = sext i32 %7 to i64
  %8 = call ptr @avra_str_reverse(ptr @.str.11)
  %9 = call i64 @strlen(ptr @.str.10)
  %10 = call i64 @strlen(ptr %8)
  %concat_total2 = add i64 %9, %10
  %concat_size3 = add i64 %concat_total2, 1
  %11 = call ptr @avra_rc_alloc(i64 %concat_size3)
  %12 = call ptr @memcpy(ptr %11, ptr @.str.10, i64 %9)
  %cast4 = ptrtoint ptr %11 to i64
  %dst2_int5 = add i64 %cast4, %9
  %cast6 = inttoptr i64 %dst2_int5 to ptr
  %rhs_len_p17 = add i64 %10, 1
  %13 = call ptr @memcpy(ptr %cast6, ptr %8, i64 %rhs_len_p17)
  %14 = call i32 @puts(ptr %11)
  %widen8 = sext i32 %14 to i64
  %15 = call i64 @count_words(ptr @.str.13)
  %16 = call ptr @avra_rc_alloc(i64 32)
  %17 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %16, i64 32, ptr @.i2s_fmt.14, i64 %15)
  %widen9 = sext i32 %17 to i64
  %18 = call i64 @strlen(ptr @.str.12)
  %19 = call i64 @strlen(ptr %16)
  %concat_total10 = add i64 %18, %19
  %concat_size11 = add i64 %concat_total10, 1
  %20 = call ptr @avra_rc_alloc(i64 %concat_size11)
  %21 = call ptr @memcpy(ptr %20, ptr @.str.12, i64 %18)
  %cast12 = ptrtoint ptr %20 to i64
  %dst2_int13 = add i64 %cast12, %18
  %cast14 = inttoptr i64 %dst2_int13 to ptr
  %rhs_len_p115 = add i64 %19, 1
  %22 = call ptr @memcpy(ptr %cast14, ptr %16, i64 %rhs_len_p115)
  %23 = call i32 @puts(ptr %20)
  %widen16 = sext i32 %23 to i64
  %24 = call i1 @is_palindrome(ptr @.str.16)
  %widen17 = zext i1 %24 to i64
  %25 = call ptr @avra_rc_alloc(i64 32)
  %26 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %25, i64 32, ptr @.i2s_fmt.17, i64 %widen17)
  %widen18 = sext i32 %26 to i64
  %27 = call i64 @strlen(ptr @.str.15)
  %28 = call i64 @strlen(ptr %25)
  %concat_total19 = add i64 %27, %28
  %concat_size20 = add i64 %concat_total19, 1
  %29 = call ptr @avra_rc_alloc(i64 %concat_size20)
  %30 = call ptr @memcpy(ptr %29, ptr @.str.15, i64 %27)
  %cast21 = ptrtoint ptr %29 to i64
  %dst2_int22 = add i64 %cast21, %27
  %cast23 = inttoptr i64 %dst2_int22 to ptr
  %rhs_len_p124 = add i64 %28, 1
  %31 = call ptr @memcpy(ptr %cast23, ptr %25, i64 %rhs_len_p124)
  %32 = call i32 @puts(ptr %29)
  %widen25 = sext i32 %32 to i64
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}
