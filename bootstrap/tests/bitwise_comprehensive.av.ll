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
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.9 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.10 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.11 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.12 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.13 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.14 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.15 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@dz_file = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/bitwise_comprehensive.av\00", align 1
@.i2s_fmt.16 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@dz_file.17 = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/bitwise_comprehensive.av\00", align 1
@.i2s_fmt.18 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@dz_file.19 = private unnamed_addr constant [108 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/bitwise_comprehensive.av\00", align 1
@.i2s_fmt.20 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.21 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.22 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.23 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.24 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.25 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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
  %0 = call ptr @avra_rc_alloc(i64 32)
  %1 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %0, i64 32, ptr @.i2s_fmt, i64 15)
  %widen = sext i32 %1 to i64
  %2 = call i32 @puts(ptr %0)
  %widen1 = sext i32 %2 to i64
  %3 = call ptr @avra_rc_alloc(i64 32)
  %4 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %3, i64 32, ptr @.i2s_fmt.1, i64 0)
  %widen2 = sext i32 %4 to i64
  %5 = call i32 @puts(ptr %3)
  %widen3 = sext i32 %5 to i64
  %6 = call ptr @avra_rc_alloc(i64 32)
  %7 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %6, i64 32, ptr @.i2s_fmt.2, i64 255)
  %widen4 = sext i32 %7 to i64
  %8 = call i32 @puts(ptr %6)
  %widen5 = sext i32 %8 to i64
  %9 = call ptr @avra_rc_alloc(i64 32)
  %10 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %9, i64 32, ptr @.i2s_fmt.3, i64 255)
  %widen6 = sext i32 %10 to i64
  %11 = call i32 @puts(ptr %9)
  %widen7 = sext i32 %11 to i64
  %12 = call ptr @avra_rc_alloc(i64 32)
  %13 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %12, i64 32, ptr @.i2s_fmt.4, i64 0)
  %widen8 = sext i32 %13 to i64
  %14 = call i32 @puts(ptr %12)
  %widen9 = sext i32 %14 to i64
  %15 = call ptr @avra_rc_alloc(i64 32)
  %16 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %15, i64 32, ptr @.i2s_fmt.5, i64 129)
  %widen10 = sext i32 %16 to i64
  %17 = call i32 @puts(ptr %15)
  %widen11 = sext i32 %17 to i64
  %18 = call ptr @avra_rc_alloc(i64 32)
  %19 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %18, i64 32, ptr @.i2s_fmt.6, i64 0)
  %widen12 = sext i32 %19 to i64
  %20 = call i32 @puts(ptr %18)
  %widen13 = sext i32 %20 to i64
  %21 = call ptr @avra_rc_alloc(i64 32)
  %22 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %21, i64 32, ptr @.i2s_fmt.7, i64 255)
  %widen14 = sext i32 %22 to i64
  %23 = call i32 @puts(ptr %21)
  %widen15 = sext i32 %23 to i64
  %24 = call ptr @avra_rc_alloc(i64 32)
  %25 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %24, i64 32, ptr @.i2s_fmt.8, i64 255)
  %widen16 = sext i32 %25 to i64
  %26 = call i32 @puts(ptr %24)
  %widen17 = sext i32 %26 to i64
  %27 = call ptr @avra_rc_alloc(i64 32)
  %28 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %27, i64 32, ptr @.i2s_fmt.9, i64 1)
  %widen18 = sext i32 %28 to i64
  %29 = call i32 @puts(ptr %27)
  %widen19 = sext i32 %29 to i64
  %30 = call ptr @avra_rc_alloc(i64 32)
  %31 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %30, i64 32, ptr @.i2s_fmt.10, i64 256)
  %widen20 = sext i32 %31 to i64
  %32 = call i32 @puts(ptr %30)
  %widen21 = sext i32 %32 to i64
  %33 = call ptr @avra_rc_alloc(i64 32)
  %34 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %33, i64 32, ptr @.i2s_fmt.11, i64 65536)
  %widen22 = sext i32 %34 to i64
  %35 = call i32 @puts(ptr %33)
  %widen23 = sext i32 %35 to i64
  %36 = call ptr @avra_rc_alloc(i64 32)
  %37 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %36, i64 32, ptr @.i2s_fmt.12, i64 256)
  %widen24 = sext i32 %37 to i64
  %38 = call i32 @puts(ptr %36)
  %widen25 = sext i32 %38 to i64
  %39 = call ptr @avra_rc_alloc(i64 32)
  %40 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %39, i64 32, ptr @.i2s_fmt.13, i64 15)
  %widen26 = sext i32 %40 to i64
  %41 = call i32 @puts(ptr %39)
  %widen27 = sext i32 %41 to i64
  %42 = call ptr @avra_rc_alloc(i64 32)
  %43 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %42, i64 32, ptr @.i2s_fmt.14, i64 255)
  %widen28 = sext i32 %43 to i64
  %44 = call i32 @puts(ptr %42)
  %widen29 = sext i32 %44 to i64
  %45 = call ptr @avra_rc_alloc(i64 32)
  %46 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %45, i64 32, ptr @.i2s_fmt.15, i64 0)
  %widen30 = sext i32 %46 to i64
  %47 = call i32 @puts(ptr %45)
  %widen31 = sext i32 %47 to i64
  call void @avra_div_by_zero_trap(i64 0, ptr @dz_file, i64 107, i64 30)
  %48 = call ptr @avra_rc_alloc(i64 32)
  %49 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %48, i64 32, ptr @.i2s_fmt.16, i64 1)
  %widen32 = sext i32 %49 to i64
  %50 = call i32 @puts(ptr %48)
  %widen33 = sext i32 %50 to i64
  call void @avra_div_by_zero_trap(i64 0, ptr @dz_file.17, i64 107, i64 31)
  %51 = call ptr @avra_rc_alloc(i64 32)
  %52 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %51, i64 32, ptr @.i2s_fmt.18, i64 0)
  %widen34 = sext i32 %52 to i64
  %53 = call i32 @puts(ptr %51)
  %widen35 = sext i32 %53 to i64
  call void @avra_div_by_zero_trap(i64 0, ptr @dz_file.19, i64 107, i64 32)
  %54 = call ptr @avra_rc_alloc(i64 32)
  %55 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %54, i64 32, ptr @.i2s_fmt.20, i64 15)
  %widen36 = sext i32 %55 to i64
  %56 = call i32 @puts(ptr %54)
  %widen37 = sext i32 %56 to i64
  %57 = call ptr @avra_rc_alloc(i64 32)
  %58 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %57, i64 32, ptr @.i2s_fmt.21, i64 243)
  %widen38 = sext i32 %58 to i64
  %59 = call i32 @puts(ptr %57)
  %widen39 = sext i32 %59 to i64
  %60 = call ptr @avra_rc_alloc(i64 32)
  %61 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %60, i64 32, ptr @.i2s_fmt.22, i64 19)
  %widen40 = sext i32 %61 to i64
  %62 = call i32 @puts(ptr %60)
  %widen41 = sext i32 %62 to i64
  %63 = call ptr @avra_rc_alloc(i64 32)
  %64 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %63, i64 32, ptr @.i2s_fmt.23, i64 30)
  %widen42 = sext i32 %64 to i64
  %65 = call i32 @puts(ptr %63)
  %widen43 = sext i32 %65 to i64
  %66 = call ptr @avra_rc_alloc(i64 32)
  %67 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %66, i64 32, ptr @.i2s_fmt.24, i64 1)
  %widen44 = sext i32 %67 to i64
  %68 = call i32 @puts(ptr %66)
  %widen45 = sext i32 %68 to i64
  %69 = call ptr @avra_rc_alloc(i64 32)
  %70 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %69, i64 32, ptr @.i2s_fmt.25, i64 1)
  %widen46 = sext i32 %70 to i64
  %71 = call i32 @puts(ptr %69)
  %widen47 = sext i32 %71 to i64
  %72 = call i32 @avra_test_summary()
  %widen48 = sext i32 %72 to i64
  call void @avra_rc_collect()
  ret i64 0
}
