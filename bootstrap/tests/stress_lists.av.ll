; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@big = global i64 0
@result = global i64 0
@matrix = global i64 0
@flat = global i64 0
@nums = global i64 0
@mid = global i64 0
@inner = global i64 0
@empty = global i64 0
@mapped_empty = global i64 0
@filtered_empty = global i64 0
@reduced_empty = global i64 0
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.9 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.10 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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
  %val = alloca i64, align 8
  %forin_i21 = alloca i64, align 8
  %forin_len20 = alloca i64, align 8
  %row = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %for_end = alloca i64, align 8
  %i = alloca i64, align 8
  %0 = call ptr @avra_array_new()
  store ptr %0, ptr @big, align 8
  store i64 0, ptr %i, align 8
  store i64 100, ptr %for_end, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.incr, %entry
  %i1 = load i64, ptr %i, align 8
  %for_end_val = load i64, ptr %for_end, align 8
  %for_cmp = icmp slt i64 %i1, %for_end_val
  br i1 %for_cmp, label %for.body, label %for.exit

for.body:                                         ; preds = %for.cond
  %big = load ptr, ptr @big, align 8
  %i2 = load i64, ptr %i, align 8
  call void @avra_array_push(ptr %big, i64 %i2)
  br label %for.incr

for.incr:                                         ; preds = %for.body
  %i3 = load i64, ptr %i, align 8
  %for_next = add i64 %i3, 1
  store i64 %for_next, ptr %i, align 8
  br label %for.cond

for.exit:                                         ; preds = %for.cond
  %big4 = load ptr, ptr @big, align 8
  %1 = call i64 @avra_array_len(ptr %big4)
  %2 = call ptr @avra_rc_alloc(i64 32)
  %3 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %2, i64 32, ptr @.i2s_fmt, i64 %1)
  %widen = sext i32 %3 to i64
  %4 = call i32 @puts(ptr %2)
  %widen5 = sext i32 %4 to i64
  %big6 = load ptr, ptr @big, align 8
  %5 = call i64 @avra_array_get(ptr %big6, i64 0)
  %6 = call ptr @avra_rc_alloc(i64 32)
  %7 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %6, i64 32, ptr @.i2s_fmt.1, i64 %5)
  %widen7 = sext i32 %7 to i64
  %8 = call i32 @puts(ptr %6)
  %widen8 = sext i32 %8 to i64
  %big9 = load ptr, ptr @big, align 8
  %9 = call i64 @avra_array_get(ptr %big9, i64 99)
  %10 = call ptr @avra_rc_alloc(i64 32)
  %11 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %10, i64 32, ptr @.i2s_fmt.2, i64 %9)
  %widen10 = sext i32 %11 to i64
  %12 = call i32 @puts(ptr %10)
  %widen11 = sext i32 %12 to i64
  %13 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %13, i64 1)
  call void @avra_array_push(ptr %13, i64 2)
  call void @avra_array_push(ptr %13, i64 3)
  call void @avra_array_push(ptr %13, i64 4)
  call void @avra_array_push(ptr %13, i64 5)
  call void @avra_array_push(ptr %13, i64 6)
  call void @avra_array_push(ptr %13, i64 7)
  call void @avra_array_push(ptr %13, i64 8)
  call void @avra_array_push(ptr %13, i64 9)
  call void @avra_array_push(ptr %13, i64 10)
  %14 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %14, i64 -559038737)
  call void @avra_array_push(ptr %14, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast = ptrtoint ptr %14 to i64
  %15 = call ptr @avra_array_map(ptr %13, i64 %cast)
  %16 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %16, i64 -559038737)
  call void @avra_array_push(ptr %16, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cast12 = ptrtoint ptr %16 to i64
  %17 = call ptr @avra_array_filter(ptr %15, i64 %cast12)
  %18 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %18, i64 -559038737)
  call void @avra_array_push(ptr %18, i64 ptrtoint (ptr @__lambda_2 to i64))
  %cast13 = ptrtoint ptr %18 to i64
  %19 = call i64 @avra_array_reduce(ptr %17, i64 0, i64 %cast13)
  store i64 %19, ptr @result, align 8
  %result = load i64, ptr @result, align 8
  %20 = call ptr @avra_rc_alloc(i64 32)
  %21 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %20, i64 32, ptr @.i2s_fmt.3, i64 %result)
  %widen14 = sext i32 %21 to i64
  %22 = call i32 @puts(ptr %20)
  %widen15 = sext i32 %22 to i64
  %23 = call ptr @avra_array_new()
  %24 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %24, i64 1)
  call void @avra_array_push(ptr %24, i64 2)
  call void @avra_array_push(ptr %24, i64 3)
  %cast16 = ptrtoint ptr %24 to i64
  call void @avra_array_push(ptr %23, i64 %cast16)
  %25 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %25, i64 4)
  call void @avra_array_push(ptr %25, i64 5)
  call void @avra_array_push(ptr %25, i64 6)
  %cast17 = ptrtoint ptr %25 to i64
  call void @avra_array_push(ptr %23, i64 %cast17)
  %26 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %26, i64 7)
  call void @avra_array_push(ptr %26, i64 8)
  call void @avra_array_push(ptr %26, i64 9)
  %cast18 = ptrtoint ptr %26 to i64
  call void @avra_array_push(ptr %23, i64 %cast18)
  store ptr %23, ptr @matrix, align 8
  %27 = call ptr @avra_array_new()
  store ptr %27, ptr @flat, align 8
  %matrix = load ptr, ptr @matrix, align 8
  %28 = call i64 @avra_array_len(ptr %matrix)
  store i64 %28, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %for.exit
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %29 = call i64 @avra_array_get(ptr %matrix, i64 %forin_i_val)
  store i64 %29, ptr %row, align 8
  %row19 = load ptr, ptr %row, align 8
  %30 = call i64 @avra_array_len(ptr %row19)
  store i64 %30, ptr %forin_len20, align 8
  store i64 0, ptr %forin_i21, align 8
  br label %forin.cond22

forin.incr:                                       ; preds = %forin.exit25
  %forin_i_old30 = load i64, ptr %forin_i, align 8
  %forin_next31 = add i64 %forin_i_old30, 1
  store i64 %forin_next31, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  %flat32 = load ptr, ptr @flat, align 8
  %31 = call i64 @avra_array_len(ptr %flat32)
  %32 = call ptr @avra_rc_alloc(i64 32)
  %33 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %32, i64 32, ptr @.i2s_fmt.4, i64 %31)
  %widen33 = sext i32 %33 to i64
  %34 = call i32 @puts(ptr %32)
  %widen34 = sext i32 %34 to i64
  %flat35 = load ptr, ptr @flat, align 8
  %35 = call i64 @avra_array_get(ptr %flat35, i64 4)
  %36 = call ptr @avra_rc_alloc(i64 32)
  %37 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %36, i64 32, ptr @.i2s_fmt.5, i64 %35)
  %widen36 = sext i32 %37 to i64
  %38 = call i32 @puts(ptr %36)
  %widen37 = sext i32 %38 to i64
  %39 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %39, i64 10)
  call void @avra_array_push(ptr %39, i64 20)
  call void @avra_array_push(ptr %39, i64 30)
  call void @avra_array_push(ptr %39, i64 40)
  call void @avra_array_push(ptr %39, i64 50)
  call void @avra_array_push(ptr %39, i64 60)
  call void @avra_array_push(ptr %39, i64 70)
  store ptr %39, ptr @nums, align 8
  %nums = load ptr, ptr @nums, align 8
  %40 = call ptr @avra_array_slice(ptr %nums, i64 2, i64 5)
  store ptr %40, ptr @mid, align 8
  %mid = load ptr, ptr @mid, align 8
  %41 = call ptr @avra_array_slice(ptr %mid, i64 1, i64 2)
  store ptr %41, ptr @inner, align 8
  %inner = load ptr, ptr @inner, align 8
  %42 = call i64 @avra_array_get(ptr %inner, i64 0)
  %43 = call ptr @avra_rc_alloc(i64 32)
  %44 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %43, i64 32, ptr @.i2s_fmt.6, i64 %42)
  %widen38 = sext i32 %44 to i64
  %45 = call i32 @puts(ptr %43)
  %widen39 = sext i32 %45 to i64
  %46 = call ptr @avra_array_new()
  store ptr %46, ptr @empty, align 8
  %empty = load ptr, ptr @empty, align 8
  %47 = call i64 @avra_array_len(ptr %empty)
  %48 = call ptr @avra_rc_alloc(i64 32)
  %49 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %48, i64 32, ptr @.i2s_fmt.7, i64 %47)
  %widen40 = sext i32 %49 to i64
  %50 = call i32 @puts(ptr %48)
  %widen41 = sext i32 %50 to i64
  %empty42 = load ptr, ptr @empty, align 8
  %51 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %51, i64 -559038737)
  call void @avra_array_push(ptr %51, i64 ptrtoint (ptr @__lambda_3 to i64))
  %cast43 = ptrtoint ptr %51 to i64
  %52 = call ptr @avra_array_map(ptr %empty42, i64 %cast43)
  store ptr %52, ptr @mapped_empty, align 8
  %mapped_empty = load ptr, ptr @mapped_empty, align 8
  %53 = call i64 @avra_array_len(ptr %mapped_empty)
  %54 = call ptr @avra_rc_alloc(i64 32)
  %55 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %54, i64 32, ptr @.i2s_fmt.8, i64 %53)
  %widen44 = sext i32 %55 to i64
  %56 = call i32 @puts(ptr %54)
  %widen45 = sext i32 %56 to i64
  %empty46 = load ptr, ptr @empty, align 8
  %57 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %57, i64 -559038737)
  call void @avra_array_push(ptr %57, i64 ptrtoint (ptr @__lambda_4 to i64))
  %cast47 = ptrtoint ptr %57 to i64
  %58 = call ptr @avra_array_filter(ptr %empty46, i64 %cast47)
  store ptr %58, ptr @filtered_empty, align 8
  %filtered_empty = load ptr, ptr @filtered_empty, align 8
  %59 = call i64 @avra_array_len(ptr %filtered_empty)
  %60 = call ptr @avra_rc_alloc(i64 32)
  %61 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %60, i64 32, ptr @.i2s_fmt.9, i64 %59)
  %widen48 = sext i32 %61 to i64
  %62 = call i32 @puts(ptr %60)
  %widen49 = sext i32 %62 to i64
  %empty50 = load ptr, ptr @empty, align 8
  %63 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %63, i64 -559038737)
  call void @avra_array_push(ptr %63, i64 ptrtoint (ptr @__lambda_5 to i64))
  %cast51 = ptrtoint ptr %63 to i64
  %64 = call i64 @avra_array_reduce(ptr %empty50, i64 42, i64 %cast51)
  store i64 %64, ptr @reduced_empty, align 8
  %reduced_empty = load i64, ptr @reduced_empty, align 8
  %65 = call ptr @avra_rc_alloc(i64 32)
  %66 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %65, i64 32, ptr @.i2s_fmt.10, i64 %reduced_empty)
  %widen52 = sext i32 %66 to i64
  %67 = call i32 @puts(ptr %65)
  %widen53 = sext i32 %67 to i64
  %68 = call i32 @avra_test_summary()
  %widen54 = sext i32 %68 to i64
  call void @avra_rc_collect()
  ret i64 0

forin.cond22:                                     ; preds = %forin.incr24, %forin.body
  %forin_i_val26 = load i64, ptr %forin_i21, align 8
  %forin_len_val27 = load i64, ptr %forin_len20, align 8
  %forin_cmp28 = icmp slt i64 %forin_i_val26, %forin_len_val27
  br i1 %forin_cmp28, label %forin.body23, label %forin.exit25

forin.body23:                                     ; preds = %forin.cond22
  %69 = call i64 @avra_array_get(ptr %row19, i64 %forin_i_val26)
  store i64 %69, ptr %val, align 8
  %flat = load ptr, ptr @flat, align 8
  %val29 = load i64, ptr %val, align 8
  call void @avra_array_push(ptr %flat, i64 %val29)
  br label %forin.incr24

forin.incr24:                                     ; preds = %forin.body23
  %forin_i_old = load i64, ptr %forin_i21, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i21, align 8
  br label %forin.cond22

forin.exit25:                                     ; preds = %forin.cond22
  br label %forin.incr
}

define i64 @__lambda_0(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %x2 = load i64, ptr %x, align 8
  %mul = mul i64 %x1, %x2
  ret i64 %mul
}

define i64 @__lambda_1(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %sgt = icmp sgt i64 %x1, 20
  %sgt_ext = zext i1 %sgt to i64
  ret i64 %sgt_ext
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
  %mul = mul i64 %x1, 2
  ret i64 %mul
}

define i64 @__lambda_4(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %sgt = icmp sgt i64 %x1, 0
  %sgt_ext = zext i1 %sgt to i64
  ret i64 %sgt_ext
}

define i64 @__lambda_5(i64 %0, i64 %1) {
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
