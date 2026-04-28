; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define i64 @triple(i64 %0) {
entry:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  %n1 = load i64, ptr %n, align 8
  %mul = mul i64 %n1, 3
  ret i64 %mul
}

define i64 @negate(i64 %0) {
entry:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  %n1 = load i64, ptr %n, align 8
  %sub = sub i64 0, %n1
  ret i64 %sub
}

define i64 @apply(ptr %0, i64 %1) {
entry:
  %x = alloca i64, align 8
  %f = alloca ptr, align 8
  store ptr %0, ptr %f, align 8
  store i64 %1, ptr %x, align 8
  %f1 = load i64, ptr %f, align 8
  %x2 = load i64, ptr %x, align 8
  %2 = call i64 @avra_closure_call_1(i64 %f1, i64 %x2)
  ret i64 %2
}

define ptr @pick(i1 %0) {
entry:
  %sif_result = alloca i64, align 8
  %use_double = alloca i1, align 1
  store i1 %0, ptr %use_double, align 8
  %use_double1 = load i1, ptr %use_double, align 8
  store i64 0, ptr %sif_result, align 8
  br i1 %use_double1, label %sif_then, label %sif_else

sif_then:                                         ; preds = %entry
  %1 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %1, i64 -559038737)
  call void @avra_array_push(ptr %1, i64 ptrtoint (ptr @double to i64))
  %cast = ptrtoint ptr %1 to i64
  store i64 %cast, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %entry
  %2 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %2, i64 -559038737)
  call void @avra_array_push(ptr %2, i64 ptrtoint (ptr @triple to i64))
  %cast2 = ptrtoint ptr %2 to i64
  store i64 %cast2, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  %cast3 = inttoptr i64 %sif_val to ptr
  ret ptr %cast3
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %j = alloca ptr, align 8
  %h = alloca ptr, align 8
  %g = alloca ptr, align 8
  %f = alloca ptr, align 8
  %1 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %1, i64 -559038737)
  call void @avra_array_push(ptr %1, i64 ptrtoint (ptr @double to i64))
  %cast = ptrtoint ptr %1 to i64
  %cast1 = inttoptr i64 %cast to ptr
  store ptr %cast1, ptr %f, align 8
  %f2 = load i64, ptr %f, align 8
  %cast3 = inttoptr i64 %f2 to ptr
  %2 = call i64 @avra_array_get(ptr %cast3, i64 1)
  %fn_ptr = inttoptr i64 %2 to ptr
  %closure_call = call i64 %fn_ptr(i64 5)
  %3 = call ptr @avra_rc_alloc(i64 32)
  %4 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %3, i64 32, ptr @.i2s_fmt, i64 %closure_call)
  %widen = sext i32 %4 to i64
  %5 = call i32 @puts(ptr %3)
  %widen4 = sext i32 %5 to i64
  %6 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %6, i64 -559038737)
  call void @avra_array_push(ptr %6, i64 ptrtoint (ptr @double to i64))
  %cast5 = ptrtoint ptr %6 to i64
  %cast6 = inttoptr i64 %cast5 to ptr
  %7 = call i64 @apply(ptr %cast6, i64 7)
  %8 = call ptr @avra_rc_alloc(i64 32)
  %9 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %8, i64 32, ptr @.i2s_fmt.1, i64 %7)
  %widen7 = sext i32 %9 to i64
  %10 = call i32 @puts(ptr %8)
  %widen8 = sext i32 %10 to i64
  %11 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %11, i64 -559038737)
  call void @avra_array_push(ptr %11, i64 ptrtoint (ptr @triple to i64))
  %cast9 = ptrtoint ptr %11 to i64
  %cast10 = inttoptr i64 %cast9 to ptr
  %12 = call i64 @apply(ptr %cast10, i64 4)
  %13 = call ptr @avra_rc_alloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @.i2s_fmt.2, i64 %12)
  %widen11 = sext i32 %14 to i64
  %15 = call i32 @puts(ptr %13)
  %widen12 = sext i32 %15 to i64
  %16 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %16, i64 -559038737)
  call void @avra_array_push(ptr %16, i64 ptrtoint (ptr @negate to i64))
  %cast13 = ptrtoint ptr %16 to i64
  %cast14 = inttoptr i64 %cast13 to ptr
  %17 = call i64 @apply(ptr %cast14, i64 10)
  %18 = call ptr @avra_rc_alloc(i64 32)
  %19 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %18, i64 32, ptr @.i2s_fmt.3, i64 %17)
  %widen15 = sext i32 %19 to i64
  %20 = call i32 @puts(ptr %18)
  %widen16 = sext i32 %20 to i64
  %21 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %21, i64 -559038737)
  call void @avra_array_push(ptr %21, i64 ptrtoint (ptr @double to i64))
  %cast17 = ptrtoint ptr %21 to i64
  %cast18 = inttoptr i64 %cast17 to ptr
  store ptr %cast18, ptr %g, align 8
  %g19 = load i64, ptr %g, align 8
  %cast20 = inttoptr i64 %g19 to ptr
  %22 = call i64 @avra_array_get(ptr %cast20, i64 1)
  %fn_ptr21 = inttoptr i64 %22 to ptr
  %closure_call22 = call i64 %fn_ptr21(i64 3)
  %23 = call ptr @avra_rc_alloc(i64 32)
  %24 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %23, i64 32, ptr @.i2s_fmt.4, i64 %closure_call22)
  %widen23 = sext i32 %24 to i64
  %25 = call i32 @puts(ptr %23)
  %widen24 = sext i32 %25 to i64
  %26 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %26, i64 -559038737)
  call void @avra_array_push(ptr %26, i64 ptrtoint (ptr @triple to i64))
  %cast25 = ptrtoint ptr %26 to i64
  %cast26 = inttoptr i64 %cast25 to ptr
  store ptr %cast26, ptr %g, align 8
  %g27 = load i64, ptr %g, align 8
  %cast28 = inttoptr i64 %g27 to ptr
  %27 = call i64 @avra_array_get(ptr %cast28, i64 1)
  %fn_ptr29 = inttoptr i64 %27 to ptr
  %closure_call30 = call i64 %fn_ptr29(i64 3)
  %28 = call ptr @avra_rc_alloc(i64 32)
  %29 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %28, i64 32, ptr @.i2s_fmt.5, i64 %closure_call30)
  %widen31 = sext i32 %29 to i64
  %30 = call i32 @puts(ptr %28)
  %widen32 = sext i32 %30 to i64
  %31 = call ptr @pick(i1 true)
  store ptr %31, ptr %h, align 8
  %h33 = load i64, ptr %h, align 8
  %32 = call i64 @avra_closure_call_1(i64 %h33, i64 6)
  %33 = call ptr @avra_rc_alloc(i64 32)
  %34 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %33, i64 32, ptr @.i2s_fmt.6, i64 %32)
  %widen34 = sext i32 %34 to i64
  %35 = call i32 @puts(ptr %33)
  %widen35 = sext i32 %35 to i64
  %36 = call ptr @pick(i1 false)
  store ptr %36, ptr %j, align 8
  %j36 = load i64, ptr %j, align 8
  %37 = call i64 @avra_closure_call_1(i64 %j36, i64 6)
  %38 = call ptr @avra_rc_alloc(i64 32)
  %39 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %38, i64 32, ptr @.i2s_fmt.7, i64 %37)
  %widen37 = sext i32 %39 to i64
  %40 = call i32 @puts(ptr %38)
  %widen38 = sext i32 %40 to i64
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}
