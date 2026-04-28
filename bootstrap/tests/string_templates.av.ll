; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@name = global i64 0
@greeting = global i64 0
@x = global i64 0
@msg = global i64 0
@a = global i64 0
@b = global i64 0
@sum = global i64 0
@empty = global i64 0
@plain = global i64 0
@p1 = global i64 0
@p2 = global i64 0
@.str = private unnamed_addr constant [6 x i8] c"world\00", align 1
@.str.1 = private unnamed_addr constant [7 x i8] c"hello \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.2 = private unnamed_addr constant [15 x i8] c"the answer is \00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.6 = private unnamed_addr constant [4 x i8] c" + \00", align 1
@.str.7 = private unnamed_addr constant [4 x i8] c" = \00", align 1
@.str.8 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.9 = private unnamed_addr constant [2 x i8] c"[\00", align 1
@.str.10 = private unnamed_addr constant [2 x i8] c"]\00", align 1
@.str.11 = private unnamed_addr constant [10 x i8] c"just text\00", align 1
@.str.12 = private unnamed_addr constant [3 x i8] c"ab\00", align 1
@.str.13 = private unnamed_addr constant [3 x i8] c"cd\00", align 1

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
  store ptr @.str, ptr @name, align 8
  %name = load ptr, ptr @name, align 8
  %0 = call i64 @strlen(ptr @.str.1)
  %1 = call i64 @strlen(ptr %name)
  %concat_total = add i64 %0, %1
  %concat_size = add i64 %concat_total, 1
  %2 = call ptr @avra_rc_alloc(i64 %concat_size)
  %3 = call ptr @memcpy(ptr %2, ptr @.str.1, i64 %0)
  %cast = ptrtoint ptr %2 to i64
  %dst2_int = add i64 %cast, %0
  %cast1 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %1, 1
  %4 = call ptr @memcpy(ptr %cast1, ptr %name, i64 %rhs_len_p1)
  store ptr %2, ptr @greeting, align 8
  %greeting = load ptr, ptr @greeting, align 8
  %5 = call i32 @puts(ptr %greeting)
  %widen = sext i32 %5 to i64
  %6 = call ptr @avra_rc_alloc(i64 32)
  %7 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %6, i64 32, ptr @.i2s_fmt, i64 42)
  %widen2 = sext i32 %7 to i64
  store ptr %6, ptr @x, align 8
  %x = load ptr, ptr @x, align 8
  %8 = call i64 @strlen(ptr @.str.2)
  %9 = call i64 @strlen(ptr %x)
  %concat_total3 = add i64 %8, %9
  %concat_size4 = add i64 %concat_total3, 1
  %10 = call ptr @avra_rc_alloc(i64 %concat_size4)
  %11 = call ptr @memcpy(ptr %10, ptr @.str.2, i64 %8)
  %cast5 = ptrtoint ptr %10 to i64
  %dst2_int6 = add i64 %cast5, %8
  %cast7 = inttoptr i64 %dst2_int6 to ptr
  %rhs_len_p18 = add i64 %9, 1
  %12 = call ptr @memcpy(ptr %cast7, ptr %x, i64 %rhs_len_p18)
  store ptr %10, ptr @msg, align 8
  %msg = load ptr, ptr @msg, align 8
  %13 = call i32 @puts(ptr %msg)
  %widen9 = sext i32 %13 to i64
  %14 = call ptr @avra_rc_alloc(i64 32)
  %15 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %14, i64 32, ptr @.i2s_fmt.3, i64 3)
  %widen10 = sext i32 %15 to i64
  store ptr %14, ptr @a, align 8
  %16 = call ptr @avra_rc_alloc(i64 32)
  %17 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %16, i64 32, ptr @.i2s_fmt.4, i64 4)
  %widen11 = sext i32 %17 to i64
  store ptr %16, ptr @b, align 8
  %18 = call ptr @avra_rc_alloc(i64 32)
  %19 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %18, i64 32, ptr @.i2s_fmt.5, i64 7)
  %widen12 = sext i32 %19 to i64
  store ptr %18, ptr @sum, align 8
  %a = load ptr, ptr @a, align 8
  %20 = call i64 @strlen(ptr %a)
  %21 = call i64 @strlen(ptr @.str.6)
  %concat_total13 = add i64 %20, %21
  %concat_size14 = add i64 %concat_total13, 1
  %22 = call ptr @avra_rc_alloc(i64 %concat_size14)
  %23 = call ptr @memcpy(ptr %22, ptr %a, i64 %20)
  %cast15 = ptrtoint ptr %22 to i64
  %dst2_int16 = add i64 %cast15, %20
  %cast17 = inttoptr i64 %dst2_int16 to ptr
  %rhs_len_p118 = add i64 %21, 1
  %24 = call ptr @memcpy(ptr %cast17, ptr @.str.6, i64 %rhs_len_p118)
  %b = load ptr, ptr @b, align 8
  %25 = call i64 @strlen(ptr %22)
  %26 = call i64 @strlen(ptr %b)
  %concat_total19 = add i64 %25, %26
  %concat_size20 = add i64 %concat_total19, 1
  %27 = call ptr @avra_rc_alloc(i64 %concat_size20)
  %28 = call ptr @memcpy(ptr %27, ptr %22, i64 %25)
  %cast21 = ptrtoint ptr %27 to i64
  %dst2_int22 = add i64 %cast21, %25
  %cast23 = inttoptr i64 %dst2_int22 to ptr
  %rhs_len_p124 = add i64 %26, 1
  %29 = call ptr @memcpy(ptr %cast23, ptr %b, i64 %rhs_len_p124)
  %30 = call i64 @strlen(ptr %27)
  %31 = call i64 @strlen(ptr @.str.7)
  %concat_total25 = add i64 %30, %31
  %concat_size26 = add i64 %concat_total25, 1
  %32 = call ptr @avra_rc_alloc(i64 %concat_size26)
  %33 = call ptr @memcpy(ptr %32, ptr %27, i64 %30)
  %cast27 = ptrtoint ptr %32 to i64
  %dst2_int28 = add i64 %cast27, %30
  %cast29 = inttoptr i64 %dst2_int28 to ptr
  %rhs_len_p130 = add i64 %31, 1
  %34 = call ptr @memcpy(ptr %cast29, ptr @.str.7, i64 %rhs_len_p130)
  %sum = load ptr, ptr @sum, align 8
  %35 = call i64 @strlen(ptr %32)
  %36 = call i64 @strlen(ptr %sum)
  %concat_total31 = add i64 %35, %36
  %concat_size32 = add i64 %concat_total31, 1
  %37 = call ptr @avra_rc_alloc(i64 %concat_size32)
  %38 = call ptr @memcpy(ptr %37, ptr %32, i64 %35)
  %cast33 = ptrtoint ptr %37 to i64
  %dst2_int34 = add i64 %cast33, %35
  %cast35 = inttoptr i64 %dst2_int34 to ptr
  %rhs_len_p136 = add i64 %36, 1
  %39 = call ptr @memcpy(ptr %cast35, ptr %sum, i64 %rhs_len_p136)
  %40 = call i32 @puts(ptr %37)
  %widen37 = sext i32 %40 to i64
  store ptr @.str.8, ptr @empty, align 8
  %empty = load ptr, ptr @empty, align 8
  %41 = call i64 @strlen(ptr @.str.9)
  %42 = call i64 @strlen(ptr %empty)
  %concat_total38 = add i64 %41, %42
  %concat_size39 = add i64 %concat_total38, 1
  %43 = call ptr @avra_rc_alloc(i64 %concat_size39)
  %44 = call ptr @memcpy(ptr %43, ptr @.str.9, i64 %41)
  %cast40 = ptrtoint ptr %43 to i64
  %dst2_int41 = add i64 %cast40, %41
  %cast42 = inttoptr i64 %dst2_int41 to ptr
  %rhs_len_p143 = add i64 %42, 1
  %45 = call ptr @memcpy(ptr %cast42, ptr %empty, i64 %rhs_len_p143)
  %46 = call i64 @strlen(ptr %43)
  %47 = call i64 @strlen(ptr @.str.10)
  %concat_total44 = add i64 %46, %47
  %concat_size45 = add i64 %concat_total44, 1
  %48 = call ptr @avra_rc_alloc(i64 %concat_size45)
  %49 = call ptr @memcpy(ptr %48, ptr %43, i64 %46)
  %cast46 = ptrtoint ptr %48 to i64
  %dst2_int47 = add i64 %cast46, %46
  %cast48 = inttoptr i64 %dst2_int47 to ptr
  %rhs_len_p149 = add i64 %47, 1
  %50 = call ptr @memcpy(ptr %cast48, ptr @.str.10, i64 %rhs_len_p149)
  %51 = call i32 @puts(ptr %48)
  %widen50 = sext i32 %51 to i64
  store ptr @.str.11, ptr @plain, align 8
  %plain = load ptr, ptr @plain, align 8
  %52 = call i32 @puts(ptr %plain)
  %widen51 = sext i32 %52 to i64
  store ptr @.str.12, ptr @p1, align 8
  store ptr @.str.13, ptr @p2, align 8
  %p1 = load ptr, ptr @p1, align 8
  %p2 = load ptr, ptr @p2, align 8
  %53 = call i64 @strlen(ptr %p1)
  %54 = call i64 @strlen(ptr %p2)
  %concat_total52 = add i64 %53, %54
  %concat_size53 = add i64 %concat_total52, 1
  %55 = call ptr @avra_rc_alloc(i64 %concat_size53)
  %56 = call ptr @memcpy(ptr %55, ptr %p1, i64 %53)
  %cast54 = ptrtoint ptr %55 to i64
  %dst2_int55 = add i64 %cast54, %53
  %cast56 = inttoptr i64 %dst2_int55 to ptr
  %rhs_len_p157 = add i64 %54, 1
  %57 = call ptr @memcpy(ptr %cast56, ptr %p2, i64 %rhs_len_p157)
  %58 = call i32 @puts(ptr %55)
  %widen58 = sext i32 %58 to i64
  %59 = call i32 @avra_test_summary()
  %widen59 = sext i32 %59 to i64
  call void @avra_rc_collect()
  ret i64 0
}
