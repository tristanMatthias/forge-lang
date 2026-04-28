; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@empty_list = global i64 0
@empty_map = global i64 0
@empty_str = global i64 0
@filtered = global i64 0
@mapped = global i64 0
@reduced = global i64 0
@sliced = global i64 0
@split_empty = global i64 0
@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.7 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.9 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.i2s_fmt.10 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.11 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.12 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.i2s_fmt.13 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.14 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.15 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.str.16 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@.str.17 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.18 = private unnamed_addr constant [2 x i8] c",\00", align 1
@.i2s_fmt.19 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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
  %0 = call ptr @avra_array_new()
  store ptr %0, ptr @empty_list, align 8
  %1 = call ptr @avra_map_new_cstr()
  store ptr %1, ptr @empty_map, align 8
  store ptr @.str, ptr @empty_str, align 8
  %empty_list = load ptr, ptr @empty_list, align 8
  %2 = call i64 @avra_array_len(ptr %empty_list)
  %3 = call ptr @avra_rc_alloc(i64 32)
  %4 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %3, i64 32, ptr @.i2s_fmt, i64 %2)
  %widen = sext i32 %4 to i64
  %5 = call i32 @puts(ptr %3)
  %widen1 = sext i32 %5 to i64
  %empty_map = load ptr, ptr @empty_map, align 8
  %6 = call i64 @avra_map_len_cstr(ptr %empty_map)
  %7 = call ptr @avra_rc_alloc(i64 32)
  %8 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %7, i64 32, ptr @.i2s_fmt.1, i64 %6)
  %widen2 = sext i32 %8 to i64
  %9 = call i32 @puts(ptr %7)
  %widen3 = sext i32 %9 to i64
  %empty_str = load ptr, ptr @empty_str, align 8
  %10 = call i64 @strlen(ptr %empty_str)
  %11 = call ptr @avra_rc_alloc(i64 32)
  %12 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %11, i64 32, ptr @.i2s_fmt.2, i64 %10)
  %widen4 = sext i32 %12 to i64
  %13 = call i32 @puts(ptr %11)
  %widen5 = sext i32 %13 to i64
  %empty_list6 = load ptr, ptr @empty_list, align 8
  %14 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %14, i64 -559038737)
  call void @avra_array_push(ptr %14, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast = ptrtoint ptr %14 to i64
  %15 = call ptr @avra_array_filter(ptr %empty_list6, i64 %cast)
  store ptr %15, ptr @filtered, align 8
  %filtered = load ptr, ptr @filtered, align 8
  %16 = call i64 @avra_array_len(ptr %filtered)
  %17 = call ptr @avra_rc_alloc(i64 32)
  %18 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %17, i64 32, ptr @.i2s_fmt.3, i64 %16)
  %widen7 = sext i32 %18 to i64
  %19 = call i32 @puts(ptr %17)
  %widen8 = sext i32 %19 to i64
  %empty_list9 = load ptr, ptr @empty_list, align 8
  %20 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %20, i64 -559038737)
  call void @avra_array_push(ptr %20, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cast10 = ptrtoint ptr %20 to i64
  %21 = call ptr @avra_array_map(ptr %empty_list9, i64 %cast10)
  store ptr %21, ptr @mapped, align 8
  %mapped = load ptr, ptr @mapped, align 8
  %22 = call i64 @avra_array_len(ptr %mapped)
  %23 = call ptr @avra_rc_alloc(i64 32)
  %24 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %23, i64 32, ptr @.i2s_fmt.4, i64 %22)
  %widen11 = sext i32 %24 to i64
  %25 = call i32 @puts(ptr %23)
  %widen12 = sext i32 %25 to i64
  %empty_list13 = load ptr, ptr @empty_list, align 8
  %26 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %26, i64 -559038737)
  call void @avra_array_push(ptr %26, i64 ptrtoint (ptr @__lambda_2 to i64))
  %cast14 = ptrtoint ptr %26 to i64
  %27 = call i64 @avra_array_reduce(ptr %empty_list13, i64 99, i64 %cast14)
  store i64 %27, ptr @reduced, align 8
  %reduced = load i64, ptr @reduced, align 8
  %28 = call ptr @avra_rc_alloc(i64 32)
  %29 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %28, i64 32, ptr @.i2s_fmt.5, i64 %reduced)
  %widen15 = sext i32 %29 to i64
  %30 = call i32 @puts(ptr %28)
  %widen16 = sext i32 %30 to i64
  %empty_list17 = load ptr, ptr @empty_list, align 8
  %31 = call ptr @avra_array_slice(ptr %empty_list17, i64 0, i64 0)
  store ptr %31, ptr @sliced, align 8
  %sliced = load ptr, ptr @sliced, align 8
  %32 = call i64 @avra_array_len(ptr %sliced)
  %33 = call ptr @avra_rc_alloc(i64 32)
  %34 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %33, i64 32, ptr @.i2s_fmt.6, i64 %32)
  %widen18 = sext i32 %34 to i64
  %35 = call i32 @puts(ptr %33)
  %widen19 = sext i32 %35 to i64
  %empty_str20 = load ptr, ptr @empty_str, align 8
  %36 = call i64 @avra_str_contains(ptr %empty_str20, ptr @.str.7)
  %37 = call ptr @avra_rc_alloc(i64 32)
  %38 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %37, i64 32, ptr @.i2s_fmt.8, i64 %36)
  %widen21 = sext i32 %38 to i64
  %39 = call i32 @puts(ptr %37)
  %widen22 = sext i32 %39 to i64
  %empty_str23 = load ptr, ptr @empty_str, align 8
  %40 = call i64 @avra_str_starts_with(ptr %empty_str23, ptr @.str.9)
  %41 = call ptr @avra_rc_alloc(i64 32)
  %42 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %41, i64 32, ptr @.i2s_fmt.10, i64 %40)
  %widen24 = sext i32 %42 to i64
  %43 = call i32 @puts(ptr %41)
  %widen25 = sext i32 %43 to i64
  %44 = call i64 @avra_str_index_of(ptr @.str.11, ptr @.str.12)
  %45 = call ptr @avra_rc_alloc(i64 32)
  %46 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %45, i64 32, ptr @.i2s_fmt.13, i64 %44)
  %widen26 = sext i32 %46 to i64
  %47 = call i32 @puts(ptr %45)
  %widen27 = sext i32 %47 to i64
  %48 = call ptr @avra_str_replace(ptr @.str.14, ptr @.str.15, ptr @.str.16)
  %49 = call i32 @puts(ptr %48)
  %widen28 = sext i32 %49 to i64
  %50 = call ptr @avra_str_split(ptr @.str.17, ptr @.str.18)
  store ptr %50, ptr @split_empty, align 8
  %split_empty = load ptr, ptr @split_empty, align 8
  %51 = call i64 @avra_array_len(ptr %split_empty)
  %52 = call ptr @avra_rc_alloc(i64 32)
  %53 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %52, i64 32, ptr @.i2s_fmt.19, i64 %51)
  %widen29 = sext i32 %53 to i64
  %54 = call i32 @puts(ptr %52)
  %widen30 = sext i32 %54 to i64
  %55 = call i32 @avra_test_summary()
  %widen31 = sext i32 %55 to i64
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__lambda_0(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %sgt = icmp sgt i64 %x1, 0
  %sgt_ext = zext i1 %sgt to i64
  ret i64 %sgt_ext
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
  %b = alloca i64, align 8
  %a = alloca i64, align 8
  store i64 %0, ptr %a, align 8
  store i64 %1, ptr %b, align 8
  %a1 = load i64, ptr %a, align 8
  %b2 = load i64, ptr %b, align 8
  %add = add i64 %a1, %b2
  ret i64 %add
}
