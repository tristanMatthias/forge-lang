; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str = private unnamed_addr constant [2 x i8] c"7\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.8 = private unnamed_addr constant [2 x i8] c"7\00", align 1
@.i2s_fmt.9 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.10 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.11 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.12 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@spec_str = private unnamed_addr constant [14 x i8] c"\22stress maps\22\00", align 1
@spec_str.13 = private unnamed_addr constant [13 x i8] c"\2250 entries\22\00", align 1
@.str.14 = private unnamed_addr constant [3 x i8] c"49\00", align 1
@spec_str.15 = private unnamed_addr constant [16 x i8] c"\22lookup square\22\00", align 1
@spec_str.16 = private unnamed_addr constant [29 x i8] c"\22overwrite length unchanged\22\00", align 1
@.str.17 = private unnamed_addr constant [4 x i8] c"107\00", align 1
@spec_str.18 = private unnamed_addr constant [18 x i8] c"\22overwrite value\22\00", align 1
@.i2s_fmt.19 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.20 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@spec_str.21 = private unnamed_addr constant [19 x i8] c"\22keys list length\22\00", align 1
@.str.22 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.23 = private unnamed_addr constant [10 x i8] c"empty_key\00", align 1
@.str.24 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.25 = private unnamed_addr constant [10 x i8] c"empty_key\00", align 1
@spec_str.26 = private unnamed_addr constant [19 x i8] c"\22empty string key\22\00", align 1
@.str.27 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.28 = private unnamed_addr constant [10 x i8] c"empty_key\00", align 1
@.str.29 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@spec_str.30 = private unnamed_addr constant [23 x i8] c"\22empty string key has\22\00", align 1
@.str.31 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.32 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@.str.33 = private unnamed_addr constant [4 x i8] c"999\00", align 1
@spec_str.34 = private unnamed_addr constant [23 x i8] c"\22non-existent key has\22\00", align 1

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

define i64 @stm_build_map_length() {
entry:
  %for_end = alloca i64, align 8
  %i = alloca i64, align 8
  %m = alloca ptr, align 8
  %0 = call ptr @forge_map_new_cstr()
  store ptr %0, ptr %m, align 8
  store i64 0, ptr %i, align 8
  store i64 50, ptr %for_end, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.incr, %entry
  %i1 = load i64, ptr %i, align 8
  %for_end_val = load i64, ptr %for_end, align 8
  %for_cmp = icmp slt i64 %i1, %for_end_val
  br i1 %for_cmp, label %for.body, label %for.exit

for.body:                                         ; preds = %for.cond
  %m2 = load ptr, ptr %m, align 8
  %i3 = load i64, ptr %i, align 8
  %1 = call ptr @forge_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %i3)
  %widen = sext i32 %2 to i64
  %i4 = load i64, ptr %i, align 8
  %i5 = load i64, ptr %i, align 8
  %mul = mul i64 %i4, %i5
  %3 = call ptr @forge_rc_alloc(i64 32)
  %4 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %3, i64 32, ptr @.i2s_fmt.1, i64 %mul)
  %widen6 = sext i32 %4 to i64
  %cast = ptrtoint ptr %3 to i64
  call void @forge_map_set_cstr(ptr %m2, ptr %1, i64 %cast)
  br label %for.incr

for.incr:                                         ; preds = %for.body
  %i7 = load i64, ptr %i, align 8
  %for_next = add i64 %i7, 1
  store i64 %for_next, ptr %i, align 8
  br label %for.cond

for.exit:                                         ; preds = %for.cond
  %m8 = load ptr, ptr %m, align 8
  %5 = call i64 @forge_map_len_cstr(ptr %m8)
  ret i64 %5
}

define ptr @stm_lookup_square() {
entry:
  %for_end = alloca i64, align 8
  %i = alloca i64, align 8
  %m = alloca ptr, align 8
  %0 = call ptr @forge_map_new_cstr()
  store ptr %0, ptr %m, align 8
  store i64 0, ptr %i, align 8
  store i64 50, ptr %for_end, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.incr, %entry
  %i1 = load i64, ptr %i, align 8
  %for_end_val = load i64, ptr %for_end, align 8
  %for_cmp = icmp slt i64 %i1, %for_end_val
  br i1 %for_cmp, label %for.body, label %for.exit

for.body:                                         ; preds = %for.cond
  %m2 = load ptr, ptr %m, align 8
  %i3 = load i64, ptr %i, align 8
  %1 = call ptr @forge_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt.2, i64 %i3)
  %widen = sext i32 %2 to i64
  %i4 = load i64, ptr %i, align 8
  %i5 = load i64, ptr %i, align 8
  %mul = mul i64 %i4, %i5
  %3 = call ptr @forge_rc_alloc(i64 32)
  %4 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %3, i64 32, ptr @.i2s_fmt.3, i64 %mul)
  %widen6 = sext i32 %4 to i64
  %cast = ptrtoint ptr %3 to i64
  call void @forge_map_set_cstr(ptr %m2, ptr %1, i64 %cast)
  br label %for.incr

for.incr:                                         ; preds = %for.body
  %i7 = load i64, ptr %i, align 8
  %for_next = add i64 %i7, 1
  store i64 %for_next, ptr %i, align 8
  br label %for.cond

for.exit:                                         ; preds = %for.cond
  %m8 = load ptr, ptr %m, align 8
  %5 = call i64 @forge_map_get_cstr(ptr %m8, ptr @.str)
  %cast9 = inttoptr i64 %5 to ptr
  ret ptr %cast9
}

define ptr @stm_overwrite_lookup() {
entry:
  %for_end9 = alloca i64, align 8
  %i8 = alloca i64, align 8
  %for_end = alloca i64, align 8
  %i = alloca i64, align 8
  %m = alloca ptr, align 8
  %0 = call ptr @forge_map_new_cstr()
  store ptr %0, ptr %m, align 8
  store i64 0, ptr %i, align 8
  store i64 50, ptr %for_end, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.incr, %entry
  %i1 = load i64, ptr %i, align 8
  %for_end_val = load i64, ptr %for_end, align 8
  %for_cmp = icmp slt i64 %i1, %for_end_val
  br i1 %for_cmp, label %for.body, label %for.exit

for.body:                                         ; preds = %for.cond
  %m2 = load ptr, ptr %m, align 8
  %i3 = load i64, ptr %i, align 8
  %1 = call ptr @forge_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt.4, i64 %i3)
  %widen = sext i32 %2 to i64
  %i4 = load i64, ptr %i, align 8
  %i5 = load i64, ptr %i, align 8
  %mul = mul i64 %i4, %i5
  %3 = call ptr @forge_rc_alloc(i64 32)
  %4 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %3, i64 32, ptr @.i2s_fmt.5, i64 %mul)
  %widen6 = sext i32 %4 to i64
  %cast = ptrtoint ptr %3 to i64
  call void @forge_map_set_cstr(ptr %m2, ptr %1, i64 %cast)
  br label %for.incr

for.incr:                                         ; preds = %for.body
  %i7 = load i64, ptr %i, align 8
  %for_next = add i64 %i7, 1
  store i64 %for_next, ptr %i, align 8
  br label %for.cond

for.exit:                                         ; preds = %for.cond
  store i64 0, ptr %i8, align 8
  store i64 50, ptr %for_end9, align 8
  br label %for.cond10

for.cond10:                                       ; preds = %for.incr12, %for.exit
  %i14 = load i64, ptr %i8, align 8
  %for_end_val15 = load i64, ptr %for_end9, align 8
  %for_cmp16 = icmp slt i64 %i14, %for_end_val15
  br i1 %for_cmp16, label %for.body11, label %for.exit13

for.body11:                                       ; preds = %for.cond10
  %m17 = load ptr, ptr %m, align 8
  %i18 = load i64, ptr %i8, align 8
  %5 = call ptr @forge_rc_alloc(i64 32)
  %6 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %5, i64 32, ptr @.i2s_fmt.6, i64 %i18)
  %widen19 = sext i32 %6 to i64
  %i20 = load i64, ptr %i8, align 8
  %add = add i64 %i20, 100
  %7 = call ptr @forge_rc_alloc(i64 32)
  %8 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %7, i64 32, ptr @.i2s_fmt.7, i64 %add)
  %widen21 = sext i32 %8 to i64
  %cast22 = ptrtoint ptr %7 to i64
  call void @forge_map_set_cstr(ptr %m17, ptr %5, i64 %cast22)
  br label %for.incr12

for.incr12:                                       ; preds = %for.body11
  %i23 = load i64, ptr %i8, align 8
  %for_next24 = add i64 %i23, 1
  store i64 %for_next24, ptr %i8, align 8
  br label %for.cond10

for.exit13:                                       ; preds = %for.cond10
  %m25 = load ptr, ptr %m, align 8
  %9 = call i64 @forge_map_get_cstr(ptr %m25, ptr @.str.8)
  %cast26 = inttoptr i64 %9 to ptr
  ret ptr %cast26
}

define i64 @stm_overwrite_length() {
entry:
  %for_end9 = alloca i64, align 8
  %i8 = alloca i64, align 8
  %for_end = alloca i64, align 8
  %i = alloca i64, align 8
  %m = alloca ptr, align 8
  %0 = call ptr @forge_map_new_cstr()
  store ptr %0, ptr %m, align 8
  store i64 0, ptr %i, align 8
  store i64 50, ptr %for_end, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.incr, %entry
  %i1 = load i64, ptr %i, align 8
  %for_end_val = load i64, ptr %for_end, align 8
  %for_cmp = icmp slt i64 %i1, %for_end_val
  br i1 %for_cmp, label %for.body, label %for.exit

for.body:                                         ; preds = %for.cond
  %m2 = load ptr, ptr %m, align 8
  %i3 = load i64, ptr %i, align 8
  %1 = call ptr @forge_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt.9, i64 %i3)
  %widen = sext i32 %2 to i64
  %i4 = load i64, ptr %i, align 8
  %i5 = load i64, ptr %i, align 8
  %mul = mul i64 %i4, %i5
  %3 = call ptr @forge_rc_alloc(i64 32)
  %4 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %3, i64 32, ptr @.i2s_fmt.10, i64 %mul)
  %widen6 = sext i32 %4 to i64
  %cast = ptrtoint ptr %3 to i64
  call void @forge_map_set_cstr(ptr %m2, ptr %1, i64 %cast)
  br label %for.incr

for.incr:                                         ; preds = %for.body
  %i7 = load i64, ptr %i, align 8
  %for_next = add i64 %i7, 1
  store i64 %for_next, ptr %i, align 8
  br label %for.cond

for.exit:                                         ; preds = %for.cond
  store i64 0, ptr %i8, align 8
  store i64 50, ptr %for_end9, align 8
  br label %for.cond10

for.cond10:                                       ; preds = %for.incr12, %for.exit
  %i14 = load i64, ptr %i8, align 8
  %for_end_val15 = load i64, ptr %for_end9, align 8
  %for_cmp16 = icmp slt i64 %i14, %for_end_val15
  br i1 %for_cmp16, label %for.body11, label %for.exit13

for.body11:                                       ; preds = %for.cond10
  %m17 = load ptr, ptr %m, align 8
  %i18 = load i64, ptr %i8, align 8
  %5 = call ptr @forge_rc_alloc(i64 32)
  %6 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %5, i64 32, ptr @.i2s_fmt.11, i64 %i18)
  %widen19 = sext i32 %6 to i64
  %i20 = load i64, ptr %i8, align 8
  %add = add i64 %i20, 100
  %7 = call ptr @forge_rc_alloc(i64 32)
  %8 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %7, i64 32, ptr @.i2s_fmt.12, i64 %add)
  %widen21 = sext i32 %8 to i64
  %cast22 = ptrtoint ptr %7 to i64
  call void @forge_map_set_cstr(ptr %m17, ptr %5, i64 %cast22)
  br label %for.incr12

for.incr12:                                       ; preds = %for.body11
  %i23 = load i64, ptr %i8, align 8
  %for_next24 = add i64 %i23, 1
  store i64 %for_next24, ptr %i8, align 8
  br label %for.cond10

for.exit13:                                       ; preds = %for.cond10
  %m25 = load ptr, ptr %m, align 8
  %9 = call i64 @forge_map_len_cstr(ptr %m25)
  ret i64 %9
}

define i64 @main() {
entry:
  %m2 = alloca ptr, align 8
  %weird2 = alloca ptr, align 8
  %weird = alloca ptr, align 8
  %k = alloca ptr, align 8
  %for_end = alloca i64, align 8
  %i = alloca i64, align 8
  %m = alloca ptr, align 8
  %0 = call i32 @forge_test_start_spec(ptr @spec_str)
  %widen = sext i32 %0 to i64
  %1 = call i64 @stm_build_map_length()
  %eq = icmp eq i64 %1, 50
  %eq_ext = zext i1 %eq to i64
  %2 = call i64 @forge_test_run_then(ptr @spec_str.13, i64 %eq_ext)
  %3 = call ptr @stm_lookup_square()
  %4 = call i32 @strcmp(ptr %3, ptr @.str.14)
  %widen1 = sext i32 %4 to i64
  %streq_cmp = icmp eq i64 %widen1, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %5 = call i64 @forge_test_run_then(ptr @spec_str.15, i64 %streq_ext)
  %6 = call i64 @stm_overwrite_length()
  %eq2 = icmp eq i64 %6, 50
  %eq_ext3 = zext i1 %eq2 to i64
  %7 = call i64 @forge_test_run_then(ptr @spec_str.16, i64 %eq_ext3)
  %8 = call ptr @stm_overwrite_lookup()
  %9 = call i32 @strcmp(ptr %8, ptr @.str.17)
  %widen4 = sext i32 %9 to i64
  %streq_cmp5 = icmp eq i64 %widen4, 0
  %streq_ext6 = zext i1 %streq_cmp5 to i64
  %10 = call i64 @forge_test_run_then(ptr @spec_str.18, i64 %streq_ext6)
  %11 = call ptr @forge_map_new_cstr()
  store ptr %11, ptr %m, align 8
  store i64 0, ptr %i, align 8
  store i64 50, ptr %for_end, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.incr, %entry
  %i7 = load i64, ptr %i, align 8
  %for_end_val = load i64, ptr %for_end, align 8
  %for_cmp = icmp slt i64 %i7, %for_end_val
  br i1 %for_cmp, label %for.body, label %for.exit

for.body:                                         ; preds = %for.cond
  %m8 = load ptr, ptr %m, align 8
  %i9 = load i64, ptr %i, align 8
  %12 = call ptr @forge_rc_alloc(i64 32)
  %13 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %12, i64 32, ptr @.i2s_fmt.19, i64 %i9)
  %widen10 = sext i32 %13 to i64
  %i11 = load i64, ptr %i, align 8
  %14 = call ptr @forge_rc_alloc(i64 32)
  %15 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %14, i64 32, ptr @.i2s_fmt.20, i64 %i11)
  %widen12 = sext i32 %15 to i64
  %cast = ptrtoint ptr %14 to i64
  call void @forge_map_set_cstr(ptr %m8, ptr %12, i64 %cast)
  br label %for.incr

for.incr:                                         ; preds = %for.body
  %i13 = load i64, ptr %i, align 8
  %for_next = add i64 %i13, 1
  store i64 %for_next, ptr %i, align 8
  br label %for.cond

for.exit:                                         ; preds = %for.cond
  %m14 = load ptr, ptr %m, align 8
  %16 = call ptr @forge_map_keys_cstr(ptr %m14)
  store ptr %16, ptr %k, align 8
  %k15 = load ptr, ptr %k, align 8
  %17 = call i64 @forge_array_len(ptr %k15)
  %eq16 = icmp eq i64 %17, 50
  %eq_ext17 = zext i1 %eq16 to i64
  %18 = call i64 @forge_test_run_then(ptr @spec_str.21, i64 %eq_ext17)
  %19 = call ptr @forge_map_new_cstr()
  store ptr %19, ptr %weird, align 8
  %weird18 = load ptr, ptr %weird, align 8
  call void @forge_map_set_cstr(ptr %weird18, ptr @.str.22, i64 ptrtoint (ptr @.str.23 to i64))
  %weird19 = load ptr, ptr %weird, align 8
  %20 = call i64 @forge_map_get_cstr(ptr %weird19, ptr @.str.24)
  %lhs_ptr = inttoptr i64 %20 to ptr
  %21 = call i32 @strcmp(ptr %lhs_ptr, ptr @.str.25)
  %widen20 = sext i32 %21 to i64
  %streq_cmp21 = icmp eq i64 %widen20, 0
  %streq_ext22 = zext i1 %streq_cmp21 to i64
  %22 = call i64 @forge_test_run_then(ptr @spec_str.26, i64 %streq_ext22)
  %23 = call ptr @forge_map_new_cstr()
  store ptr %23, ptr %weird2, align 8
  %weird223 = load ptr, ptr %weird2, align 8
  call void @forge_map_set_cstr(ptr %weird223, ptr @.str.27, i64 ptrtoint (ptr @.str.28 to i64))
  %weird224 = load ptr, ptr %weird2, align 8
  %24 = call i64 @forge_map_has_cstr(ptr %weird224, ptr @.str.29)
  %eq25 = icmp eq i64 %24, 1
  %eq_ext26 = zext i1 %eq25 to i64
  %25 = call i64 @forge_test_run_then(ptr @spec_str.30, i64 %eq_ext26)
  %26 = call ptr @forge_map_new_cstr()
  store ptr %26, ptr %m2, align 8
  %m227 = load ptr, ptr %m2, align 8
  call void @forge_map_set_cstr(ptr %m227, ptr @.str.31, i64 ptrtoint (ptr @.str.32 to i64))
  %m228 = load ptr, ptr %m2, align 8
  %27 = call i64 @forge_map_has_cstr(ptr %m228, ptr @.str.33)
  %eq29 = icmp eq i64 %27, 0
  %eq_ext30 = zext i1 %eq29 to i64
  %28 = call i64 @forge_test_run_then(ptr @spec_str.34, i64 %eq_ext30)
  %29 = call i32 @forge_test_end_spec(ptr @spec_str)
  %widen31 = sext i32 %29 to i64
  %30 = call i32 @forge_test_summary()
  %widen32 = sext i32 %30 to i64
  call void @forge_rc_collect()
  ret i64 0
}
