; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@.str = private unnamed_addr constant [14 x i8] c"Hello, World!\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"World\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.3 = private unnamed_addr constant [4 x i8] c"xyz\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.5 = private unnamed_addr constant [6 x i8] c"Hello\00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.7 = private unnamed_addr constant [6 x i8] c"World\00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.9 = private unnamed_addr constant [2 x i8] c"!\00", align 1
@.i2s_fmt.10 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.11 = private unnamed_addr constant [6 x i8] c"Hello\00", align 1
@.i2s_fmt.12 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.13 = private unnamed_addr constant [6 x i8] c"World\00", align 1
@.i2s_fmt.14 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.15 = private unnamed_addr constant [4 x i8] c"xyz\00", align 1
@.i2s_fmt.16 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.17 = private unnamed_addr constant [6 x i8] c"World\00", align 1
@.str.18 = private unnamed_addr constant [5 x i8] c"Avra\00", align 1
@.str.19 = private unnamed_addr constant [11 x i8] c"  spaced  \00", align 1
@.str.20 = private unnamed_addr constant [6 x i8] c"Hello\00", align 1
@.str.21 = private unnamed_addr constant [8 x i8] c"a,b,c,d\00", align 1
@.str.22 = private unnamed_addr constant [2 x i8] c",\00", align 1
@.i2s_fmt.23 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.24 = private unnamed_addr constant [4 x i8] c" - \00", align 1
@.str.25 = private unnamed_addr constant [2 x i8] c"A\00", align 1
@.i2s_fmt.26 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.27 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.i2s_fmt.28 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.29 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.i2s_fmt.30 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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
  %empty = alloca ptr, align 8
  %ch = alloca ptr, align 8
  %sub = alloca ptr, align 8
  %joined = alloca ptr, align 8
  %parts = alloca ptr, align 8
  %csv = alloca ptr, align 8
  %mixed = alloca ptr, align 8
  %padded = alloca ptr, align 8
  %r = alloca ptr, align 8
  %s = alloca ptr, align 8
  store ptr @.str, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %1 = call i64 @strlen(ptr %s1)
  %2 = call ptr @avra_rc_alloc(i64 32)
  %3 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %2, i64 32, ptr @.i2s_fmt, i64 %1)
  %widen = sext i32 %3 to i64
  %4 = call i32 @puts(ptr %2)
  %widen2 = sext i32 %4 to i64
  %s3 = load ptr, ptr %s, align 8
  %5 = call i64 @avra_str_contains(ptr %s3, ptr @.str.1)
  %6 = call ptr @avra_rc_alloc(i64 32)
  %7 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %6, i64 32, ptr @.i2s_fmt.2, i64 %5)
  %widen4 = sext i32 %7 to i64
  %8 = call i32 @puts(ptr %6)
  %widen5 = sext i32 %8 to i64
  %s6 = load ptr, ptr %s, align 8
  %9 = call i64 @avra_str_contains(ptr %s6, ptr @.str.3)
  %10 = call ptr @avra_rc_alloc(i64 32)
  %11 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %10, i64 32, ptr @.i2s_fmt.4, i64 %9)
  %widen7 = sext i32 %11 to i64
  %12 = call i32 @puts(ptr %10)
  %widen8 = sext i32 %12 to i64
  %s9 = load ptr, ptr %s, align 8
  %13 = call i64 @avra_str_starts_with(ptr %s9, ptr @.str.5)
  %14 = call ptr @avra_rc_alloc(i64 32)
  %15 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %14, i64 32, ptr @.i2s_fmt.6, i64 %13)
  %widen10 = sext i32 %15 to i64
  %16 = call i32 @puts(ptr %14)
  %widen11 = sext i32 %16 to i64
  %s12 = load ptr, ptr %s, align 8
  %17 = call i64 @avra_str_starts_with(ptr %s12, ptr @.str.7)
  %18 = call ptr @avra_rc_alloc(i64 32)
  %19 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %18, i64 32, ptr @.i2s_fmt.8, i64 %17)
  %widen13 = sext i32 %19 to i64
  %20 = call i32 @puts(ptr %18)
  %widen14 = sext i32 %20 to i64
  %s15 = load ptr, ptr %s, align 8
  %21 = call i64 @avra_str_ends_with(ptr %s15, ptr @.str.9)
  %22 = call ptr @avra_rc_alloc(i64 32)
  %23 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %22, i64 32, ptr @.i2s_fmt.10, i64 %21)
  %widen16 = sext i32 %23 to i64
  %24 = call i32 @puts(ptr %22)
  %widen17 = sext i32 %24 to i64
  %s18 = load ptr, ptr %s, align 8
  %25 = call i64 @avra_str_ends_with(ptr %s18, ptr @.str.11)
  %26 = call ptr @avra_rc_alloc(i64 32)
  %27 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %26, i64 32, ptr @.i2s_fmt.12, i64 %25)
  %widen19 = sext i32 %27 to i64
  %28 = call i32 @puts(ptr %26)
  %widen20 = sext i32 %28 to i64
  %s21 = load ptr, ptr %s, align 8
  %29 = call i64 @avra_str_index_of(ptr %s21, ptr @.str.13)
  %30 = call ptr @avra_rc_alloc(i64 32)
  %31 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %30, i64 32, ptr @.i2s_fmt.14, i64 %29)
  %widen22 = sext i32 %31 to i64
  %32 = call i32 @puts(ptr %30)
  %widen23 = sext i32 %32 to i64
  %s24 = load ptr, ptr %s, align 8
  %33 = call i64 @avra_str_index_of(ptr %s24, ptr @.str.15)
  %34 = call ptr @avra_rc_alloc(i64 32)
  %35 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %34, i64 32, ptr @.i2s_fmt.16, i64 %33)
  %widen25 = sext i32 %35 to i64
  %36 = call i32 @puts(ptr %34)
  %widen26 = sext i32 %36 to i64
  %s27 = load ptr, ptr %s, align 8
  %37 = call ptr @avra_str_replace(ptr %s27, ptr @.str.17, ptr @.str.18)
  store ptr %37, ptr %r, align 8
  %r28 = load ptr, ptr %r, align 8
  %38 = call i32 @puts(ptr %r28)
  %widen29 = sext i32 %38 to i64
  store ptr @.str.19, ptr %padded, align 8
  %padded30 = load ptr, ptr %padded, align 8
  %39 = call ptr @avra_str_trim(ptr %padded30)
  %40 = call i32 @puts(ptr %39)
  %widen31 = sext i32 %40 to i64
  store ptr @.str.20, ptr %mixed, align 8
  %mixed32 = load ptr, ptr %mixed, align 8
  %41 = call ptr @avra_str_to_upper(ptr %mixed32)
  %42 = call i32 @puts(ptr %41)
  %widen33 = sext i32 %42 to i64
  %mixed34 = load ptr, ptr %mixed, align 8
  %43 = call ptr @avra_str_to_lower(ptr %mixed34)
  %44 = call i32 @puts(ptr %43)
  %widen35 = sext i32 %44 to i64
  store ptr @.str.21, ptr %csv, align 8
  %csv36 = load ptr, ptr %csv, align 8
  %45 = call ptr @avra_str_split(ptr %csv36, ptr @.str.22)
  store ptr %45, ptr %parts, align 8
  %parts37 = load ptr, ptr %parts, align 8
  %46 = call i64 @avra_array_len(ptr %parts37)
  %47 = call ptr @avra_rc_alloc(i64 32)
  %48 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %47, i64 32, ptr @.i2s_fmt.23, i64 %46)
  %widen38 = sext i32 %48 to i64
  %49 = call i32 @puts(ptr %47)
  %widen39 = sext i32 %49 to i64
  %parts40 = load ptr, ptr %parts, align 8
  %50 = call i64 @avra_array_get(ptr %parts40, i64 0)
  %cast = inttoptr i64 %50 to ptr
  %51 = call i32 @puts(ptr %cast)
  %widen41 = sext i32 %51 to i64
  %parts42 = load ptr, ptr %parts, align 8
  %52 = call i64 @avra_array_get(ptr %parts42, i64 1)
  %cast43 = inttoptr i64 %52 to ptr
  %53 = call i32 @puts(ptr %cast43)
  %widen44 = sext i32 %53 to i64
  %parts45 = load ptr, ptr %parts, align 8
  %54 = call i64 @avra_array_get(ptr %parts45, i64 2)
  %cast46 = inttoptr i64 %54 to ptr
  %55 = call i32 @puts(ptr %cast46)
  %widen47 = sext i32 %55 to i64
  %parts48 = load ptr, ptr %parts, align 8
  %56 = call i64 @avra_array_get(ptr %parts48, i64 3)
  %cast49 = inttoptr i64 %56 to ptr
  %57 = call i32 @puts(ptr %cast49)
  %widen50 = sext i32 %57 to i64
  %parts51 = load ptr, ptr %parts, align 8
  %58 = call ptr @avra_str_join(ptr %parts51, ptr @.str.24)
  store ptr %58, ptr %joined, align 8
  %joined52 = load ptr, ptr %joined, align 8
  %59 = call i32 @puts(ptr %joined52)
  %widen53 = sext i32 %59 to i64
  %s54 = load ptr, ptr %s, align 8
  %60 = call ptr @avra_rc_alloc(i64 6)
  %cast55 = ptrtoint ptr %s54 to i64
  %sub_off_int = add i64 %cast55, 0
  %cast56 = inttoptr i64 %sub_off_int to ptr
  %61 = call ptr @memcpy(ptr %60, ptr %cast56, i64 5)
  %cast57 = ptrtoint ptr %60 to i64
  %sub_nul_int = add i64 %cast57, 5
  %cast58 = inttoptr i64 %sub_nul_int to ptr
  store i8 0, ptr %cast58, align 8
  store ptr %60, ptr %sub, align 8
  %sub59 = load ptr, ptr %sub, align 8
  %62 = call i32 @puts(ptr %sub59)
  %widen60 = sext i32 %62 to i64
  store ptr @.str.25, ptr %ch, align 8
  %ch61 = load ptr, ptr %ch, align 8
  %char_byte = load i8, ptr %ch61, align 8
  %char_code = zext i8 %char_byte to i64
  %63 = call ptr @avra_rc_alloc(i64 32)
  %64 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %63, i64 32, ptr @.i2s_fmt.26, i64 %char_code)
  %widen62 = sext i32 %64 to i64
  %65 = call i32 @puts(ptr %63)
  %widen63 = sext i32 %65 to i64
  store ptr @.str.27, ptr %empty, align 8
  %empty64 = load ptr, ptr %empty, align 8
  %66 = call i64 @strlen(ptr %empty64)
  %67 = call ptr @avra_rc_alloc(i64 32)
  %68 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %67, i64 32, ptr @.i2s_fmt.28, i64 %66)
  %widen65 = sext i32 %68 to i64
  %69 = call i32 @puts(ptr %67)
  %widen66 = sext i32 %69 to i64
  %empty67 = load ptr, ptr %empty, align 8
  %70 = call i64 @avra_str_contains(ptr %empty67, ptr @.str.29)
  %71 = call ptr @avra_rc_alloc(i64 32)
  %72 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %71, i64 32, ptr @.i2s_fmt.30, i64 %70)
  %widen68 = sext i32 %72 to i64
  %73 = call i32 @puts(ptr %71)
  %widen69 = sext i32 %73 to i64
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}
