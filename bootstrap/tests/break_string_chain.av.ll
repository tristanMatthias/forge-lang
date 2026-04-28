; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@result = global i64 0
@parts = global i64 0
@joined = global i64 0
@.str = private unnamed_addr constant [18 x i8] c"  Hello, World!  \00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"World\00", align 1
@.str.2 = private unnamed_addr constant [6 x i8] c"Forge\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.3 = private unnamed_addr constant [6 x i8] c"FORGE\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.5 = private unnamed_addr constant [6 x i8] c"HELLO\00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.7 = private unnamed_addr constant [6 x i8] c"FORGE\00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.9 = private unnamed_addr constant [8 x i8] c"a:b:c:d\00", align 1
@.str.10 = private unnamed_addr constant [2 x i8] c":\00", align 1
@.str.11 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.12 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.13 = private unnamed_addr constant [2 x i8] c"-\00", align 1

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

define i64 @main() {
entry:
  %0 = call ptr @avra_str_trim(ptr @.str)
  %1 = call ptr @avra_str_replace(ptr %0, ptr @.str.1, ptr @.str.2)
  %2 = call ptr @avra_str_to_upper(ptr %1)
  store ptr %2, ptr @result, align 8
  %result = load ptr, ptr @result, align 8
  %3 = call i32 @puts(ptr %result)
  %widen = sext i32 %3 to i64
  %result1 = load ptr, ptr @result, align 8
  %4 = call i64 @strlen(ptr %result1)
  %5 = call ptr @avra_rc_alloc(i64 32)
  %6 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %5, i64 32, ptr @.i2s_fmt, i64 %4)
  %widen2 = sext i32 %6 to i64
  %7 = call i32 @puts(ptr %5)
  %widen3 = sext i32 %7 to i64
  %result4 = load ptr, ptr @result, align 8
  %8 = call i64 @avra_str_contains(ptr %result4, ptr @.str.3)
  %9 = call ptr @avra_rc_alloc(i64 32)
  %10 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %9, i64 32, ptr @.i2s_fmt.4, i64 %8)
  %widen5 = sext i32 %10 to i64
  %11 = call i32 @puts(ptr %9)
  %widen6 = sext i32 %11 to i64
  %result7 = load ptr, ptr @result, align 8
  %12 = call i64 @avra_str_starts_with(ptr %result7, ptr @.str.5)
  %13 = call ptr @avra_rc_alloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @.i2s_fmt.6, i64 %12)
  %widen8 = sext i32 %14 to i64
  %15 = call i32 @puts(ptr %13)
  %widen9 = sext i32 %15 to i64
  %result10 = load ptr, ptr @result, align 8
  %16 = call i64 @avra_str_index_of(ptr %result10, ptr @.str.7)
  %17 = call ptr @avra_rc_alloc(i64 32)
  %18 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %17, i64 32, ptr @.i2s_fmt.8, i64 %16)
  %widen11 = sext i32 %18 to i64
  %19 = call i32 @puts(ptr %17)
  %widen12 = sext i32 %19 to i64
  %20 = call ptr @avra_str_split(ptr @.str.9, ptr @.str.10)
  store ptr %20, ptr @parts, align 8
  %parts = load ptr, ptr @parts, align 8
  %21 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %21, i64 -559038737)
  call void @avra_array_push(ptr %21, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast = ptrtoint ptr %21 to i64
  %22 = call i64 @avra_array_reduce(ptr %parts, i64 ptrtoint (ptr @.str.11 to i64), i64 %cast)
  store i64 %22, ptr @joined, align 8
  %joined = load i64, ptr @joined, align 8
  %cast13 = inttoptr i64 %joined to ptr
  %23 = call i32 @puts(ptr %cast13)
  %widen14 = sext i32 %23 to i64
  %24 = call i32 @avra_test_summary()
  %widen15 = sext i32 %24 to i64
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__lambda_0(ptr %0, ptr %1) {
entry:
  %x = alloca ptr, align 8
  %acc = alloca ptr, align 8
  store ptr %0, ptr %acc, align 8
  store ptr %1, ptr %x, align 8
  %acc1 = load ptr, ptr %acc, align 8
  %2 = call i32 @strcmp(ptr %acc1, ptr @.str.12)
  %widen = sext i32 %2 to i64
  %streq_cmp = icmp eq i64 %widen, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %if_cond = icmp ne i64 %streq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %acc3 = load ptr, ptr %acc, align 8
  %3 = call i64 @strlen(ptr %acc3)
  %4 = call i64 @strlen(ptr @.str.13)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @avra_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr %acc3, i64 %3)
  %cast4 = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast4, %3
  %cast5 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast5, ptr @.str.13, i64 %rhs_len_p1)
  %x6 = load ptr, ptr %x, align 8
  %8 = call i64 @strlen(ptr %5)
  %9 = call i64 @strlen(ptr %x6)
  %concat_total7 = add i64 %8, %9
  %concat_size8 = add i64 %concat_total7, 1
  %10 = call ptr @avra_rc_alloc(i64 %concat_size8)
  %11 = call ptr @memcpy(ptr %10, ptr %5, i64 %8)
  %cast9 = ptrtoint ptr %10 to i64
  %dst2_int10 = add i64 %cast9, %8
  %cast11 = inttoptr i64 %dst2_int10 to ptr
  %rhs_len_p112 = add i64 %9, 1
  %12 = call ptr @memcpy(ptr %cast11, ptr %x6, i64 %rhs_len_p112)
  %cast13 = ptrtoint ptr %10 to i64
  ret i64 %cast13

if_then:                                          ; preds = %entry
  %x2 = load ptr, ptr %x, align 8
  %cast = ptrtoint ptr %x2 to i64
  ret i64 %cast

if_else:                                          ; preds = %entry
  br label %ifcont
}
