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
@.str = private unnamed_addr constant [5 x i8] c"name\00", align 1
@.str.15 = private unnamed_addr constant [6 x i8] c"Alice\00", align 1
@.str.16 = private unnamed_addr constant [5 x i8] c"city\00", align 1
@.str.17 = private unnamed_addr constant [4 x i8] c"NYC\00", align 1
@.i2s_fmt.18 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.19 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@.str.20 = private unnamed_addr constant [5 x i8] c"city\00", align 1
@.i2s_fmt.21 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.22 = private unnamed_addr constant [4 x i8] c"age\00", align 1
@.i2s_fmt.23 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.24 = private unnamed_addr constant [4 x i8] c"age\00", align 1
@.str.25 = private unnamed_addr constant [3 x i8] c"30\00", align 1
@.i2s_fmt.26 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.27 = private unnamed_addr constant [4 x i8] c"age\00", align 1
@.i2s_fmt.28 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.29 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.30 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.i2s_fmt.31 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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
  %k = alloca ptr, align 8
  %m = alloca ptr, align 8
  %sum = alloca i64, align 8
  %big = alloca ptr, align 8
  %doubled = alloca ptr, align 8
  %sliced = alloca ptr, align 8
  %popped = alloca i64, align 8
  %nums = alloca ptr, align 8
  %1 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %1, i64 10)
  call void @avra_array_push(ptr %1, i64 20)
  call void @avra_array_push(ptr %1, i64 30)
  call void @avra_array_push(ptr %1, i64 40)
  call void @avra_array_push(ptr %1, i64 50)
  store ptr %1, ptr %nums, align 8
  %nums1 = load ptr, ptr %nums, align 8
  %2 = call i64 @avra_array_len(ptr %nums1)
  %3 = call ptr @avra_rc_alloc(i64 32)
  %4 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %3, i64 32, ptr @.i2s_fmt, i64 %2)
  %widen = sext i32 %4 to i64
  %5 = call i32 @puts(ptr %3)
  %widen2 = sext i32 %5 to i64
  %nums3 = load ptr, ptr %nums, align 8
  %6 = call i64 @avra_array_get(ptr %nums3, i64 0)
  %7 = call ptr @avra_rc_alloc(i64 32)
  %8 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %7, i64 32, ptr @.i2s_fmt.1, i64 %6)
  %widen4 = sext i32 %8 to i64
  %9 = call i32 @puts(ptr %7)
  %widen5 = sext i32 %9 to i64
  %nums6 = load ptr, ptr %nums, align 8
  %10 = call i64 @avra_array_get(ptr %nums6, i64 4)
  %11 = call ptr @avra_rc_alloc(i64 32)
  %12 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %11, i64 32, ptr @.i2s_fmt.2, i64 %10)
  %widen7 = sext i32 %12 to i64
  %13 = call i32 @puts(ptr %11)
  %widen8 = sext i32 %13 to i64
  %nums9 = load ptr, ptr %nums, align 8
  call void @avra_array_push(ptr %nums9, i64 60)
  %nums10 = load ptr, ptr %nums, align 8
  %14 = call i64 @avra_array_len(ptr %nums10)
  %15 = call ptr @avra_rc_alloc(i64 32)
  %16 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %15, i64 32, ptr @.i2s_fmt.3, i64 %14)
  %widen11 = sext i32 %16 to i64
  %17 = call i32 @puts(ptr %15)
  %widen12 = sext i32 %17 to i64
  %nums13 = load ptr, ptr %nums, align 8
  %18 = call i64 @avra_array_pop(ptr %nums13)
  store i64 %18, ptr %popped, align 8
  %popped14 = load i64, ptr %popped, align 8
  %19 = call ptr @avra_rc_alloc(i64 32)
  %20 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %19, i64 32, ptr @.i2s_fmt.4, i64 %popped14)
  %widen15 = sext i32 %20 to i64
  %21 = call i32 @puts(ptr %19)
  %widen16 = sext i32 %21 to i64
  %nums17 = load ptr, ptr %nums, align 8
  %22 = call i64 @avra_array_len(ptr %nums17)
  %23 = call ptr @avra_rc_alloc(i64 32)
  %24 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %23, i64 32, ptr @.i2s_fmt.5, i64 %22)
  %widen18 = sext i32 %24 to i64
  %25 = call i32 @puts(ptr %23)
  %widen19 = sext i32 %25 to i64
  %nums20 = load ptr, ptr %nums, align 8
  %26 = call ptr @avra_array_slice(ptr %nums20, i64 1, i64 3)
  store ptr %26, ptr %sliced, align 8
  %sliced21 = load ptr, ptr %sliced, align 8
  %27 = call i64 @avra_array_len(ptr %sliced21)
  %28 = call ptr @avra_rc_alloc(i64 32)
  %29 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %28, i64 32, ptr @.i2s_fmt.6, i64 %27)
  %widen22 = sext i32 %29 to i64
  %30 = call i32 @puts(ptr %28)
  %widen23 = sext i32 %30 to i64
  %sliced24 = load ptr, ptr %sliced, align 8
  %31 = call i64 @avra_array_get(ptr %sliced24, i64 0)
  %32 = call ptr @avra_rc_alloc(i64 32)
  %33 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %32, i64 32, ptr @.i2s_fmt.7, i64 %31)
  %widen25 = sext i32 %33 to i64
  %34 = call i32 @puts(ptr %32)
  %widen26 = sext i32 %34 to i64
  %sliced27 = load ptr, ptr %sliced, align 8
  %35 = call i64 @avra_array_get(ptr %sliced27, i64 1)
  %36 = call ptr @avra_rc_alloc(i64 32)
  %37 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %36, i64 32, ptr @.i2s_fmt.8, i64 %35)
  %widen28 = sext i32 %37 to i64
  %38 = call i32 @puts(ptr %36)
  %widen29 = sext i32 %38 to i64
  %nums30 = load ptr, ptr %nums, align 8
  %39 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %39, i64 -559038737)
  call void @avra_array_push(ptr %39, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast = ptrtoint ptr %39 to i64
  %40 = call ptr @avra_array_map(ptr %nums30, i64 %cast)
  store ptr %40, ptr %doubled, align 8
  %doubled31 = load ptr, ptr %doubled, align 8
  %41 = call i64 @avra_array_get(ptr %doubled31, i64 0)
  %42 = call ptr @avra_rc_alloc(i64 32)
  %43 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %42, i64 32, ptr @.i2s_fmt.9, i64 %41)
  %widen32 = sext i32 %43 to i64
  %44 = call i32 @puts(ptr %42)
  %widen33 = sext i32 %44 to i64
  %doubled34 = load ptr, ptr %doubled, align 8
  %45 = call i64 @avra_array_get(ptr %doubled34, i64 1)
  %46 = call ptr @avra_rc_alloc(i64 32)
  %47 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %46, i64 32, ptr @.i2s_fmt.10, i64 %45)
  %widen35 = sext i32 %47 to i64
  %48 = call i32 @puts(ptr %46)
  %widen36 = sext i32 %48 to i64
  %nums37 = load ptr, ptr %nums, align 8
  %49 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %49, i64 -559038737)
  call void @avra_array_push(ptr %49, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cast38 = ptrtoint ptr %49 to i64
  %50 = call ptr @avra_array_filter(ptr %nums37, i64 %cast38)
  store ptr %50, ptr %big, align 8
  %big39 = load ptr, ptr %big, align 8
  %51 = call i64 @avra_array_len(ptr %big39)
  %52 = call ptr @avra_rc_alloc(i64 32)
  %53 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %52, i64 32, ptr @.i2s_fmt.11, i64 %51)
  %widen40 = sext i32 %53 to i64
  %54 = call i32 @puts(ptr %52)
  %widen41 = sext i32 %54 to i64
  %big42 = load ptr, ptr %big, align 8
  %55 = call i64 @avra_array_get(ptr %big42, i64 0)
  %56 = call ptr @avra_rc_alloc(i64 32)
  %57 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %56, i64 32, ptr @.i2s_fmt.12, i64 %55)
  %widen43 = sext i32 %57 to i64
  %58 = call i32 @puts(ptr %56)
  %widen44 = sext i32 %58 to i64
  %nums45 = load ptr, ptr %nums, align 8
  %59 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %59, i64 -559038737)
  call void @avra_array_push(ptr %59, i64 ptrtoint (ptr @__lambda_2 to i64))
  %cast46 = ptrtoint ptr %59 to i64
  %60 = call i64 @avra_array_reduce(ptr %nums45, i64 0, i64 %cast46)
  store i64 %60, ptr %sum, align 8
  %sum47 = load i64, ptr %sum, align 8
  %61 = call ptr @avra_rc_alloc(i64 32)
  %62 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %61, i64 32, ptr @.i2s_fmt.13, i64 %sum47)
  %widen48 = sext i32 %62 to i64
  %63 = call i32 @puts(ptr %61)
  %widen49 = sext i32 %63 to i64
  %nums50 = load ptr, ptr %nums, align 8
  %64 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %64, i64 -559038737)
  call void @avra_array_push(ptr %64, i64 ptrtoint (ptr @__lambda_3 to i64))
  %cast51 = ptrtoint ptr %64 to i64
  call void @avra_array_foreach(ptr %nums50, i64 %cast51)
  %65 = call ptr @avra_map_new_cstr()
  call void @avra_map_set_cstr(ptr %65, ptr @.str, i64 ptrtoint (ptr @.str.15 to i64))
  call void @avra_map_set_cstr(ptr %65, ptr @.str.16, i64 ptrtoint (ptr @.str.17 to i64))
  store ptr %65, ptr %m, align 8
  %m52 = load ptr, ptr %m, align 8
  %66 = call i64 @avra_map_len_cstr(ptr %m52)
  %67 = call ptr @avra_rc_alloc(i64 32)
  %68 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %67, i64 32, ptr @.i2s_fmt.18, i64 %66)
  %widen53 = sext i32 %68 to i64
  %69 = call i32 @puts(ptr %67)
  %widen54 = sext i32 %69 to i64
  %m55 = load ptr, ptr %m, align 8
  %70 = call i64 @avra_map_get_cstr(ptr %m55, ptr @.str.19)
  %cast56 = inttoptr i64 %70 to ptr
  %71 = call i32 @puts(ptr %cast56)
  %widen57 = sext i32 %71 to i64
  %m58 = load ptr, ptr %m, align 8
  %72 = call i64 @avra_map_has_cstr(ptr %m58, ptr @.str.20)
  %73 = call ptr @avra_rc_alloc(i64 32)
  %74 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %73, i64 32, ptr @.i2s_fmt.21, i64 %72)
  %widen59 = sext i32 %74 to i64
  %75 = call i32 @puts(ptr %73)
  %widen60 = sext i32 %75 to i64
  %m61 = load ptr, ptr %m, align 8
  %76 = call i64 @avra_map_has_cstr(ptr %m61, ptr @.str.22)
  %77 = call ptr @avra_rc_alloc(i64 32)
  %78 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %77, i64 32, ptr @.i2s_fmt.23, i64 %76)
  %widen62 = sext i32 %78 to i64
  %79 = call i32 @puts(ptr %77)
  %widen63 = sext i32 %79 to i64
  %m64 = load ptr, ptr %m, align 8
  call void @avra_map_set_cstr(ptr %m64, ptr @.str.24, i64 ptrtoint (ptr @.str.25 to i64))
  %m65 = load ptr, ptr %m, align 8
  %80 = call i64 @avra_map_len_cstr(ptr %m65)
  %81 = call ptr @avra_rc_alloc(i64 32)
  %82 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %81, i64 32, ptr @.i2s_fmt.26, i64 %80)
  %widen66 = sext i32 %82 to i64
  %83 = call i32 @puts(ptr %81)
  %widen67 = sext i32 %83 to i64
  %m68 = load ptr, ptr %m, align 8
  %84 = call i64 @avra_map_get_cstr(ptr %m68, ptr @.str.27)
  %cast69 = inttoptr i64 %84 to ptr
  %85 = call i32 @puts(ptr %cast69)
  %widen70 = sext i32 %85 to i64
  %m71 = load ptr, ptr %m, align 8
  %86 = call ptr @avra_map_keys_cstr(ptr %m71)
  store ptr %86, ptr %k, align 8
  %k72 = load ptr, ptr %k, align 8
  %87 = call i64 @avra_array_len(ptr %k72)
  %88 = call ptr @avra_rc_alloc(i64 32)
  %89 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %88, i64 32, ptr @.i2s_fmt.28, i64 %87)
  %widen73 = sext i32 %89 to i64
  %90 = call i32 @puts(ptr %88)
  %widen74 = sext i32 %90 to i64
  %91 = call ptr @avra_map_new_cstr()
  store ptr %91, ptr %empty, align 8
  %empty75 = load ptr, ptr %empty, align 8
  %92 = call i64 @avra_map_len_cstr(ptr %empty75)
  %93 = call ptr @avra_rc_alloc(i64 32)
  %94 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %93, i64 32, ptr @.i2s_fmt.29, i64 %92)
  %widen76 = sext i32 %94 to i64
  %95 = call i32 @puts(ptr %93)
  %widen77 = sext i32 %95 to i64
  %empty78 = load ptr, ptr %empty, align 8
  %96 = call i64 @avra_map_has_cstr(ptr %empty78, ptr @.str.30)
  %97 = call ptr @avra_rc_alloc(i64 32)
  %98 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %97, i64 32, ptr @.i2s_fmt.31, i64 %96)
  %widen79 = sext i32 %98 to i64
  %99 = call i32 @puts(ptr %97)
  %widen80 = sext i32 %99 to i64
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
  %mul = mul i64 %x1, 2
  ret i64 %mul
}

define i64 @__lambda_1(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %sgt = icmp sgt i64 %x1, 25
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
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt.14, i64 %x1)
  %widen = sext i32 %2 to i64
  %3 = call i32 @puts(ptr %1)
  %widen2 = sext i32 %3 to i64
  ret i64 0
}
