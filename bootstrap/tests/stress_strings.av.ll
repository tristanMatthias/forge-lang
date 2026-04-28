; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@s = global i64 0
@clean = global i64 0
@shouting = global i64 0
@parts = global i64 0
@csv = global i64 0
@values = global i64 0
@.str = private unnamed_addr constant [18 x i8] c"  Hello, World!  \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.1 = private unnamed_addr constant [12 x i8] c"hello world\00", align 1
@.str.2 = private unnamed_addr constant [6 x i8] c"world\00", align 1
@.str.3 = private unnamed_addr constant [6 x i8] c"forge\00", align 1
@.str.4 = private unnamed_addr constant [8 x i8] c"a-b-c-d\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"-\00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.7 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.8 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.i2s_fmt.9 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.10 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.11 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.i2s_fmt.12 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.13 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.14 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.i2s_fmt.15 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.16 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.17 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.i2s_fmt.18 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.19 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.20 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.i2s_fmt.21 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.22 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.23 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.i2s_fmt.24 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.25 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.26 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.i2s_fmt.27 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.28 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.29 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.i2s_fmt.30 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.31 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.32 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.i2s_fmt.33 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.34 = private unnamed_addr constant [15 x i8] c"10,20,30,40,50\00", align 1
@.str.35 = private unnamed_addr constant [2 x i8] c",\00", align 1
@.i2s_fmt.36 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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
  %p = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  store ptr @.str, ptr @s, align 8
  %s = load ptr, ptr @s, align 8
  %0 = call ptr @avra_str_trim(ptr %s)
  store ptr %0, ptr @clean, align 8
  %clean = load ptr, ptr @clean, align 8
  %1 = call i32 @puts(ptr %clean)
  %widen = sext i32 %1 to i64
  %clean1 = load ptr, ptr @clean, align 8
  %2 = call i64 @strlen(ptr %clean1)
  %3 = call ptr @avra_rc_alloc(i64 32)
  %4 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %3, i64 32, ptr @.i2s_fmt, i64 %2)
  %widen2 = sext i32 %4 to i64
  %5 = call i32 @puts(ptr %3)
  %widen3 = sext i32 %5 to i64
  %6 = call ptr @avra_str_replace(ptr @.str.1, ptr @.str.2, ptr @.str.3)
  %7 = call ptr @avra_str_to_upper(ptr %6)
  store ptr %7, ptr @shouting, align 8
  %shouting = load ptr, ptr @shouting, align 8
  %8 = call i32 @puts(ptr %shouting)
  %widen4 = sext i32 %8 to i64
  %9 = call ptr @avra_str_split(ptr @.str.4, ptr @.str.5)
  store ptr %9, ptr @parts, align 8
  %parts = load ptr, ptr @parts, align 8
  %10 = call i64 @avra_array_len(ptr %parts)
  %11 = call ptr @avra_rc_alloc(i64 32)
  %12 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %11, i64 32, ptr @.i2s_fmt.6, i64 %10)
  %widen5 = sext i32 %12 to i64
  %13 = call i32 @puts(ptr %11)
  %widen6 = sext i32 %13 to i64
  %parts7 = load ptr, ptr @parts, align 8
  %14 = call i64 @avra_array_len(ptr %parts7)
  store i64 %14, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %entry
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %15 = call i64 @avra_array_get(ptr %parts7, i64 %forin_i_val)
  store i64 %15, ptr %p, align 8
  %p8 = load ptr, ptr %p, align 8
  %16 = call i32 @puts(ptr %p8)
  %widen9 = sext i32 %16 to i64
  br label %forin.incr

forin.incr:                                       ; preds = %forin.body
  %forin_i_old = load i64, ptr %forin_i, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  %17 = call i64 @avra_str_index_of(ptr @.str.7, ptr @.str.8)
  %18 = call ptr @avra_rc_alloc(i64 32)
  %19 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %18, i64 32, ptr @.i2s_fmt.9, i64 %17)
  %widen10 = sext i32 %19 to i64
  %20 = call i32 @puts(ptr %18)
  %widen11 = sext i32 %20 to i64
  %21 = call i64 @avra_str_index_of(ptr @.str.10, ptr @.str.11)
  %22 = call ptr @avra_rc_alloc(i64 32)
  %23 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %22, i64 32, ptr @.i2s_fmt.12, i64 %21)
  %widen12 = sext i32 %23 to i64
  %24 = call i32 @puts(ptr %22)
  %widen13 = sext i32 %24 to i64
  %25 = call i64 @avra_str_index_of(ptr @.str.13, ptr @.str.14)
  %26 = call ptr @avra_rc_alloc(i64 32)
  %27 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %26, i64 32, ptr @.i2s_fmt.15, i64 %25)
  %widen14 = sext i32 %27 to i64
  %28 = call i32 @puts(ptr %26)
  %widen15 = sext i32 %28 to i64
  %29 = call i64 @avra_str_contains(ptr @.str.16, ptr @.str.17)
  %30 = call ptr @avra_rc_alloc(i64 32)
  %31 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %30, i64 32, ptr @.i2s_fmt.18, i64 %29)
  %widen16 = sext i32 %31 to i64
  %32 = call i32 @puts(ptr %30)
  %widen17 = sext i32 %32 to i64
  %33 = call i64 @avra_str_contains(ptr @.str.19, ptr @.str.20)
  %34 = call ptr @avra_rc_alloc(i64 32)
  %35 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %34, i64 32, ptr @.i2s_fmt.21, i64 %33)
  %widen18 = sext i32 %35 to i64
  %36 = call i32 @puts(ptr %34)
  %widen19 = sext i32 %36 to i64
  %37 = call i64 @avra_str_contains(ptr @.str.22, ptr @.str.23)
  %38 = call ptr @avra_rc_alloc(i64 32)
  %39 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %38, i64 32, ptr @.i2s_fmt.24, i64 %37)
  %widen20 = sext i32 %39 to i64
  %40 = call i32 @puts(ptr %38)
  %widen21 = sext i32 %40 to i64
  %41 = call i64 @avra_str_starts_with(ptr @.str.25, ptr @.str.26)
  %42 = call ptr @avra_rc_alloc(i64 32)
  %43 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %42, i64 32, ptr @.i2s_fmt.27, i64 %41)
  %widen22 = sext i32 %43 to i64
  %44 = call i32 @puts(ptr %42)
  %widen23 = sext i32 %44 to i64
  %45 = call i64 @avra_str_ends_with(ptr @.str.28, ptr @.str.29)
  %46 = call ptr @avra_rc_alloc(i64 32)
  %47 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %46, i64 32, ptr @.i2s_fmt.30, i64 %45)
  %widen24 = sext i32 %47 to i64
  %48 = call i32 @puts(ptr %46)
  %widen25 = sext i32 %48 to i64
  %49 = call i64 @avra_str_starts_with(ptr @.str.31, ptr @.str.32)
  %50 = call ptr @avra_rc_alloc(i64 32)
  %51 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %50, i64 32, ptr @.i2s_fmt.33, i64 %49)
  %widen26 = sext i32 %51 to i64
  %52 = call i32 @puts(ptr %50)
  %widen27 = sext i32 %52 to i64
  store ptr @.str.34, ptr @csv, align 8
  %csv = load ptr, ptr @csv, align 8
  %53 = call ptr @avra_str_split(ptr %csv, ptr @.str.35)
  store ptr %53, ptr @values, align 8
  %values = load ptr, ptr @values, align 8
  %54 = call i64 @avra_array_len(ptr %values)
  %55 = call ptr @avra_rc_alloc(i64 32)
  %56 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %55, i64 32, ptr @.i2s_fmt.36, i64 %54)
  %widen28 = sext i32 %56 to i64
  %57 = call i32 @puts(ptr %55)
  %widen29 = sext i32 %57 to i64
  %values30 = load ptr, ptr @values, align 8
  %58 = call i64 @avra_array_get(ptr %values30, i64 0)
  %cast = inttoptr i64 %58 to ptr
  %59 = call i32 @puts(ptr %cast)
  %widen31 = sext i32 %59 to i64
  %values32 = load ptr, ptr @values, align 8
  %60 = call i64 @avra_array_get(ptr %values32, i64 4)
  %cast33 = inttoptr i64 %60 to ptr
  %61 = call i32 @puts(ptr %cast33)
  %widen34 = sext i32 %61 to i64
  %62 = call i32 @avra_test_summary()
  %widen35 = sext i32 %62 to i64
  call void @avra_rc_collect()
  ret i64 0
}
