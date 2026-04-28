; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@dz_file = private unnamed_addr constant [97 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/std_stream.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str = private unnamed_addr constant [20 x i8] c"the quick brown fox\00", align 1
@.str.9 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.10 = private unnamed_addr constant [2 x i8] c" \00", align 1

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
  %0 = call i64 @__bs_top_level()
  %uppers = alloca ptr, align 8
  %words = alloca ptr, align 8
  %mx = alloca i64, align 8
  %big_doubled = alloca ptr, align 8
  %sum = alloca i64, align 8
  %doubled = alloca ptr, align 8
  %evens = alloca ptr, align 8
  %nums = alloca ptr, align 8
  %1 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %1, i64 1)
  call void @avra_array_push(ptr %1, i64 2)
  call void @avra_array_push(ptr %1, i64 3)
  call void @avra_array_push(ptr %1, i64 4)
  call void @avra_array_push(ptr %1, i64 5)
  call void @avra_array_push(ptr %1, i64 6)
  call void @avra_array_push(ptr %1, i64 7)
  call void @avra_array_push(ptr %1, i64 8)
  call void @avra_array_push(ptr %1, i64 9)
  call void @avra_array_push(ptr %1, i64 10)
  store ptr %1, ptr %nums, align 8
  %nums1 = load ptr, ptr %nums, align 8
  %2 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %2, i64 -559038737)
  call void @avra_array_push(ptr %2, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast = ptrtoint ptr %2 to i64
  %3 = call ptr @avra_array_filter(ptr %nums1, i64 %cast)
  store ptr %3, ptr %evens, align 8
  %evens2 = load ptr, ptr %evens, align 8
  %4 = call i64 @avra_array_len(ptr %evens2)
  %5 = call ptr @avra_rc_alloc(i64 32)
  %6 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %5, i64 32, ptr @.i2s_fmt, i64 %4)
  %widen = sext i32 %6 to i64
  %7 = call i32 @puts(ptr %5)
  %widen3 = sext i32 %7 to i64
  %evens4 = load ptr, ptr %evens, align 8
  %8 = call i64 @avra_array_get(ptr %evens4, i64 0)
  %9 = call ptr @avra_rc_alloc(i64 32)
  %10 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %9, i64 32, ptr @.i2s_fmt.1, i64 %8)
  %widen5 = sext i32 %10 to i64
  %11 = call i32 @puts(ptr %9)
  %widen6 = sext i32 %11 to i64
  %evens7 = load ptr, ptr %evens, align 8
  %12 = call i64 @avra_array_get(ptr %evens7, i64 1)
  %13 = call ptr @avra_rc_alloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @.i2s_fmt.2, i64 %12)
  %widen8 = sext i32 %14 to i64
  %15 = call i32 @puts(ptr %13)
  %widen9 = sext i32 %15 to i64
  %nums10 = load ptr, ptr %nums, align 8
  %16 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %16, i64 -559038737)
  call void @avra_array_push(ptr %16, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cast11 = ptrtoint ptr %16 to i64
  %17 = call ptr @avra_array_map(ptr %nums10, i64 %cast11)
  store ptr %17, ptr %doubled, align 8
  %doubled12 = load ptr, ptr %doubled, align 8
  %18 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %18, i64 -559038737)
  call void @avra_array_push(ptr %18, i64 ptrtoint (ptr @__lambda_2 to i64))
  %cast13 = ptrtoint ptr %18 to i64
  %19 = call i64 @avra_array_reduce(ptr %doubled12, i64 0, i64 %cast13)
  store i64 %19, ptr %sum, align 8
  %sum14 = load i64, ptr %sum, align 8
  %20 = call ptr @avra_rc_alloc(i64 32)
  %21 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %20, i64 32, ptr @.i2s_fmt.3, i64 %sum14)
  %widen15 = sext i32 %21 to i64
  %22 = call i32 @puts(ptr %20)
  %widen16 = sext i32 %22 to i64
  %nums17 = load ptr, ptr %nums, align 8
  %23 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %23, i64 -559038737)
  call void @avra_array_push(ptr %23, i64 ptrtoint (ptr @__lambda_3 to i64))
  %cast18 = ptrtoint ptr %23 to i64
  %24 = call ptr @avra_array_filter(ptr %nums17, i64 %cast18)
  %25 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %25, i64 -559038737)
  call void @avra_array_push(ptr %25, i64 ptrtoint (ptr @__lambda_4 to i64))
  %cast19 = ptrtoint ptr %25 to i64
  %26 = call ptr @avra_array_map(ptr %24, i64 %cast19)
  store ptr %26, ptr %big_doubled, align 8
  %big_doubled20 = load ptr, ptr %big_doubled, align 8
  %27 = call i64 @avra_array_len(ptr %big_doubled20)
  %28 = call ptr @avra_rc_alloc(i64 32)
  %29 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %28, i64 32, ptr @.i2s_fmt.4, i64 %27)
  %widen21 = sext i32 %29 to i64
  %30 = call i32 @puts(ptr %28)
  %widen22 = sext i32 %30 to i64
  %big_doubled23 = load ptr, ptr %big_doubled, align 8
  %31 = call i64 @avra_array_get(ptr %big_doubled23, i64 0)
  %32 = call ptr @avra_rc_alloc(i64 32)
  %33 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %32, i64 32, ptr @.i2s_fmt.5, i64 %31)
  %widen24 = sext i32 %33 to i64
  %34 = call i32 @puts(ptr %32)
  %widen25 = sext i32 %34 to i64
  %big_doubled26 = load ptr, ptr %big_doubled, align 8
  %35 = call i64 @avra_array_get(ptr %big_doubled26, i64 1)
  %36 = call ptr @avra_rc_alloc(i64 32)
  %37 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %36, i64 32, ptr @.i2s_fmt.6, i64 %35)
  %widen27 = sext i32 %37 to i64
  %38 = call i32 @puts(ptr %36)
  %widen28 = sext i32 %38 to i64
  %big_doubled29 = load ptr, ptr %big_doubled, align 8
  %39 = call i64 @avra_array_get(ptr %big_doubled29, i64 4)
  %40 = call ptr @avra_rc_alloc(i64 32)
  %41 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %40, i64 32, ptr @.i2s_fmt.7, i64 %39)
  %widen30 = sext i32 %41 to i64
  %42 = call i32 @puts(ptr %40)
  %widen31 = sext i32 %42 to i64
  %nums32 = load ptr, ptr %nums, align 8
  %43 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %43, i64 -559038737)
  call void @avra_array_push(ptr %43, i64 ptrtoint (ptr @__lambda_5 to i64))
  %cast33 = ptrtoint ptr %43 to i64
  %44 = call i64 @avra_array_reduce(ptr %nums32, i64 0, i64 %cast33)
  store i64 %44, ptr %mx, align 8
  %mx34 = load i64, ptr %mx, align 8
  %45 = call ptr @avra_rc_alloc(i64 32)
  %46 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %45, i64 32, ptr @.i2s_fmt.8, i64 %mx34)
  %widen35 = sext i32 %46 to i64
  %47 = call i32 @puts(ptr %45)
  %widen36 = sext i32 %47 to i64
  %48 = call ptr @avra_str_split(ptr @.str, ptr @.str.9)
  store ptr %48, ptr %words, align 8
  %words37 = load ptr, ptr %words, align 8
  %49 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %49, i64 -559038737)
  call void @avra_array_push(ptr %49, i64 ptrtoint (ptr @__lambda_6 to i64))
  %cast38 = ptrtoint ptr %49 to i64
  %50 = call ptr @avra_array_map(ptr %words37, i64 %cast38)
  store ptr %50, ptr %uppers, align 8
  %uppers39 = load ptr, ptr %uppers, align 8
  %51 = call ptr @avra_str_join(ptr %uppers39, ptr @.str.10)
  %52 = call i32 @puts(ptr %51)
  %widen40 = sext i32 %52 to i64
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__lambda_0(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  call void @avra_div_by_zero_trap(i64 0, ptr @dz_file, i64 96, i64 10)
  %mod = srem i64 %x1, 2
  %eq = icmp eq i64 %mod, 0
  %eq_ext = zext i1 %eq to i64
  ret i64 %eq_ext
}

define i64 @__lambda_1(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %mul = mul i64 %x1, 2
  ret i64 %mul
}

define i64 @__lambda_2(i64 %0, i64 %1) {
entry:
  %x = alloca i64, align 8
  %acc = alloca i64, align 8
  store i64 %0, ptr %acc, align 8
  store i64 %1, ptr %x, align 8
  %acc1 = load i64, ptr %acc, align 8
  %x2 = load i64, ptr %x, align 8
  %add = add i64 %acc1, %x2
  ret i64 %add
}

define i64 @__lambda_3(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %sgt = icmp sgt i64 %x1, 5
  %sgt_ext = zext i1 %sgt to i64
  ret i64 %sgt_ext
}

define i64 @__lambda_4(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %mul = mul i64 %x1, 10
  ret i64 %mul
}

define i64 @__lambda_5(i64 %0, i64 %1) {
entry:
  %ife_result = alloca i64, align 8
  %x = alloca i64, align 8
  %best = alloca i64, align 8
  store i64 %0, ptr %best, align 8
  store i64 %1, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %best2 = load i64, ptr %best, align 8
  %sgt = icmp sgt i64 %x1, %best2
  %sgt_ext = zext i1 %sgt to i64
  %ife_cond = icmp ne i64 %sgt_ext, 0
  br i1 %ife_cond, label %ife_then, label %ife_else

ife_end:                                          ; preds = %ife_else, %ife_then
  %ife_val = load i64, ptr %ife_result, align 8
  ret i64 %ife_val

ife_then:                                         ; preds = %entry
  %x3 = load i64, ptr %x, align 8
  store i64 %x3, ptr %ife_result, align 8
  br label %ife_end

ife_else:                                         ; preds = %entry
  %best4 = load i64, ptr %best, align 8
  store i64 %best4, ptr %ife_result, align 8
  br label %ife_end
}

define i64 @__lambda_6(ptr %0) {
entry:
  %w = alloca ptr, align 8
  store ptr %0, ptr %w, align 8
  %w1 = load ptr, ptr %w, align 8
  %1 = call ptr @avra_str_to_upper(ptr %w1)
  %cast = ptrtoint ptr %1 to i64
  ret i64 %cast
}
