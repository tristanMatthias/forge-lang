; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@m = global i64 0
@k = global i64 0
@weird = global i64 0
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str = private unnamed_addr constant [2 x i8] c"7\00", align 1
@.str.3 = private unnamed_addr constant [3 x i8] c"49\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.7 = private unnamed_addr constant [2 x i8] c"7\00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.9 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.10 = private unnamed_addr constant [10 x i8] c"empty_key\00", align 1
@.str.11 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.12 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.i2s_fmt.13 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.14 = private unnamed_addr constant [4 x i8] c"999\00", align 1
@.i2s_fmt.15 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.16 = private unnamed_addr constant [4 x i8] c"999\00", align 1
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

define i64 @main() {
entry:
  %for_end17 = alloca i64, align 8
  %i16 = alloca i64, align 8
  %for_end = alloca i64, align 8
  %i = alloca i64, align 8
  %0 = call ptr @avra_map_new_cstr()
  store ptr %0, ptr @m, align 8
  store i64 0, ptr %i, align 8
  store i64 50, ptr %for_end, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.incr, %entry
  %i1 = load i64, ptr %i, align 8
  %for_end_val = load i64, ptr %for_end, align 8
  %for_cmp = icmp slt i64 %i1, %for_end_val
  br i1 %for_cmp, label %for.body, label %for.exit

for.body:                                         ; preds = %for.cond
  %m = load ptr, ptr @m, align 8
  %i2 = load i64, ptr %i, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %i2)
  %widen = sext i32 %2 to i64
  %i3 = load i64, ptr %i, align 8
  %i4 = load i64, ptr %i, align 8
  %mul = mul i64 %i3, %i4
  %3 = call ptr @avra_rc_alloc(i64 32)
  %4 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %3, i64 32, ptr @.i2s_fmt.1, i64 %mul)
  %widen5 = sext i32 %4 to i64
  %cast = ptrtoint ptr %3 to i64
  call void @avra_map_set_cstr(ptr %m, ptr %1, i64 %cast)
  br label %for.incr

for.incr:                                         ; preds = %for.body
  %i6 = load i64, ptr %i, align 8
  %for_next = add i64 %i6, 1
  store i64 %for_next, ptr %i, align 8
  br label %for.cond

for.exit:                                         ; preds = %for.cond
  %m7 = load ptr, ptr @m, align 8
  %5 = call i64 @avra_map_len_cstr(ptr %m7)
  %6 = call ptr @avra_rc_alloc(i64 32)
  %7 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %6, i64 32, ptr @.i2s_fmt.2, i64 %5)
  %widen8 = sext i32 %7 to i64
  %8 = call i32 @puts(ptr %6)
  %widen9 = sext i32 %8 to i64
  %m10 = load ptr, ptr @m, align 8
  %9 = call i64 @avra_map_get_cstr(ptr %m10, ptr @.str)
  %cast11 = inttoptr i64 %9 to ptr
  %10 = call i32 @puts(ptr %cast11)
  %widen12 = sext i32 %10 to i64
  %m13 = load ptr, ptr @m, align 8
  %11 = call i64 @avra_map_get_cstr(ptr %m13, ptr @.str.3)
  %cast14 = inttoptr i64 %11 to ptr
  %12 = call i32 @puts(ptr %cast14)
  %widen15 = sext i32 %12 to i64
  store i64 0, ptr %i16, align 8
  store i64 50, ptr %for_end17, align 8
  br label %for.cond18

for.cond18:                                       ; preds = %for.incr20, %for.exit
  %i22 = load i64, ptr %i16, align 8
  %for_end_val23 = load i64, ptr %for_end17, align 8
  %for_cmp24 = icmp slt i64 %i22, %for_end_val23
  br i1 %for_cmp24, label %for.body19, label %for.exit21

for.body19:                                       ; preds = %for.cond18
  %m25 = load ptr, ptr @m, align 8
  %i26 = load i64, ptr %i16, align 8
  %13 = call ptr @avra_rc_alloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @.i2s_fmt.4, i64 %i26)
  %widen27 = sext i32 %14 to i64
  %i28 = load i64, ptr %i16, align 8
  %add = add i64 %i28, 100
  %15 = call ptr @avra_rc_alloc(i64 32)
  %16 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %15, i64 32, ptr @.i2s_fmt.5, i64 %add)
  %widen29 = sext i32 %16 to i64
  %cast30 = ptrtoint ptr %15 to i64
  call void @avra_map_set_cstr(ptr %m25, ptr %13, i64 %cast30)
  br label %for.incr20

for.incr20:                                       ; preds = %for.body19
  %i31 = load i64, ptr %i16, align 8
  %for_next32 = add i64 %i31, 1
  store i64 %for_next32, ptr %i16, align 8
  br label %for.cond18

for.exit21:                                       ; preds = %for.cond18
  %m33 = load ptr, ptr @m, align 8
  %17 = call i64 @avra_map_len_cstr(ptr %m33)
  %18 = call ptr @avra_rc_alloc(i64 32)
  %19 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %18, i64 32, ptr @.i2s_fmt.6, i64 %17)
  %widen34 = sext i32 %19 to i64
  %20 = call i32 @puts(ptr %18)
  %widen35 = sext i32 %20 to i64
  %m36 = load ptr, ptr @m, align 8
  %21 = call i64 @avra_map_get_cstr(ptr %m36, ptr @.str.7)
  %cast37 = inttoptr i64 %21 to ptr
  %22 = call i32 @puts(ptr %cast37)
  %widen38 = sext i32 %22 to i64
  %m39 = load ptr, ptr @m, align 8
  %23 = call ptr @avra_map_keys_cstr(ptr %m39)
  store ptr %23, ptr @k, align 8
  %k = load ptr, ptr @k, align 8
  %24 = call i64 @avra_array_len(ptr %k)
  %25 = call ptr @avra_rc_alloc(i64 32)
  %26 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %25, i64 32, ptr @.i2s_fmt.8, i64 %24)
  %widen40 = sext i32 %26 to i64
  %27 = call i32 @puts(ptr %25)
  %widen41 = sext i32 %27 to i64
  %28 = call ptr @avra_map_new_cstr()
  store ptr %28, ptr @weird, align 8
  %weird = load ptr, ptr @weird, align 8
  call void @avra_map_set_cstr(ptr %weird, ptr @.str.9, i64 ptrtoint (ptr @.str.10 to i64))
  %weird42 = load ptr, ptr @weird, align 8
  %29 = call i64 @avra_map_get_cstr(ptr %weird42, ptr @.str.11)
  %cast43 = inttoptr i64 %29 to ptr
  %30 = call i32 @puts(ptr %cast43)
  %widen44 = sext i32 %30 to i64
  %weird45 = load ptr, ptr @weird, align 8
  %31 = call i64 @avra_map_has_cstr(ptr %weird45, ptr @.str.12)
  %32 = call ptr @avra_rc_alloc(i64 32)
  %33 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %32, i64 32, ptr @.i2s_fmt.13, i64 %31)
  %widen46 = sext i32 %33 to i64
  %34 = call i32 @puts(ptr %32)
  %widen47 = sext i32 %34 to i64
  %m48 = load ptr, ptr @m, align 8
  %35 = call i64 @avra_map_get_cstr(ptr %m48, ptr @.str.14)
  %36 = call ptr @avra_rc_alloc(i64 32)
  %37 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %36, i64 32, ptr @.i2s_fmt.15, i64 %35)
  %widen49 = sext i32 %37 to i64
  %38 = call i32 @puts(ptr %36)
  %widen50 = sext i32 %38 to i64
  %m51 = load ptr, ptr @m, align 8
  %39 = call i64 @avra_map_has_cstr(ptr %m51, ptr @.str.16)
  %40 = call ptr @avra_rc_alloc(i64 32)
  %41 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %40, i64 32, ptr @.i2s_fmt.17, i64 %39)
  %widen52 = sext i32 %41 to i64
  %42 = call i32 @puts(ptr %40)
  %widen53 = sext i32 %42 to i64
  %43 = call i32 @avra_test_summary()
  %widen54 = sext i32 %43 to i64
  call void @avra_rc_collect()
  ret i64 0
}
