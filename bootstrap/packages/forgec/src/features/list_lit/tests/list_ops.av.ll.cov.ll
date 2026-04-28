; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/list_lit/tests/list_ops.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

@nums = global i64 0
@last = global i64 0
@empty = global i64 0
@sum = global i64 0
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
@__llvm_profile_runtime = external hidden global i32
@__profc_main = private global [77 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 77, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__llvm_prf_nm = private constant [14 x i8] c"\04\0Cx\DA\CBM\CC\CC\03\00\04\1B\01\A6", section "__DATA,__llvm_prf_names", align 1
@llvm.compiler.used = appending global [2 x ptr] [ptr @__llvm_profile_runtime_user, ptr @__profd_main], section "llvm.metadata"
@llvm.used = appending global [1 x ptr] [ptr @__llvm_prf_nm], section "llvm.metadata"

; Function Attrs: nounwind
declare void @llvm.instrprof.increment(ptr, i64, i32, i32) #0

declare i32 @puts(ptr)

declare void @forge_eprintln(ptr)

declare i64 @strlen(ptr)

declare ptr @malloc(i64)

declare ptr @forge_rc_alloc(i64)

declare void @forge_rc_retain(ptr)

declare void @forge_rc_release(ptr)

declare i64 @forge_rc_should_free(ptr)

declare void @forge_rc_free(ptr)

declare void @forge_rc_suspect(ptr)

declare void @forge_rc_collect()

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @strcmp(ptr, ptr)

declare i32 @snprintf(ptr, i64, ptr, ...)

declare i32 @atoi(ptr)

declare void @exit(i32)

declare void @forge_null_arg_check(ptr, i64, ptr, i64, i64)

declare void @forge_null_deref_trap(ptr, i64, ptr, i64, i64, ptr, i64, i64)

declare void @forge_div_by_zero_trap(i64, ptr, i64, i64)

declare ptr @forge_array_new()

declare void @forge_array_push(ptr, i64)

declare i64 @forge_array_get(ptr, i64)

declare i64 @forge_array_len(ptr)

declare void @forge_array_set(ptr, i64, i64)

declare i64 @forge_array_pop(ptr)

declare ptr @forge_array_slice(ptr, i64, i64)

declare i64 @forge_closure_get_fn(i64)

declare i64 @forge_closure_num_captures(i64)

declare i64 @forge_closure_get_capture(ptr, i64)

declare i64 @forge_closure_call_0(i64)

declare i64 @forge_closure_call_1(i64, i64)

declare i64 @forge_closure_call_2(i64, i64, i64)

declare i64 @forge_closure_call_3(i64, i64, i64, i64)

declare i64 @forge_closure_call_4(i64, i64, i64, i64, i64)

declare i64 @forge_closure_call_5(i64, i64, i64, i64, i64, i64)

declare ptr @forge_array_map(ptr, i64)

declare ptr @forge_array_filter(ptr, i64)

declare void @forge_array_foreach(ptr, i64)

declare i64 @forge_array_reduce(ptr, i64, i64)

declare i64 @forge_array_contains(ptr, i64)

declare i64 @forge_array_index_of(ptr, i64)

declare ptr @forge_array_reverse(ptr)

declare i64 @forge_str_contains(ptr, ptr)

declare i64 @forge_str_starts_with(ptr, ptr)

declare i64 @forge_str_ends_with(ptr, ptr)

declare i64 @forge_str_index_of(ptr, ptr)

declare ptr @forge_str_split(ptr, ptr)

declare ptr @forge_str_replace(ptr, ptr, ptr)

declare ptr @forge_str_trim(ptr)

declare ptr @forge_str_to_upper(ptr)

declare ptr @forge_str_to_lower(ptr)

declare ptr @forge_str_join(ptr, ptr)

declare ptr @forge_str_char_at(ptr, i64)

declare ptr @forge_str_substring(ptr, i64, i64)

declare ptr @forge_str_repeat(ptr, i64)

declare ptr @forge_str_reverse(ptr)

declare ptr @forge_map_new_cstr()

declare void @forge_map_set_cstr(ptr, ptr, i64)

declare i64 @forge_map_get_cstr(ptr, ptr)

declare i64 @forge_map_has_cstr(ptr, ptr)

declare i64 @forge_map_len_cstr(ptr)

declare ptr @forge_map_keys_cstr(ptr)

declare ptr @forge_map_values_cstr(ptr)

declare i64 @forge_map_remove_cstr(ptr, ptr)

declare ptr @forge_file_read(ptr)

declare i64 @forge_file_write(ptr, ptr)

declare i64 @forge_file_exists(ptr)

declare ptr @forge_intmap_new()

declare void @forge_intmap_set(ptr, i64, i64)

declare i64 @forge_intmap_get(ptr, i64)

declare i64 @forge_intmap_has(ptr, i64)

declare i64 @forge_float_parse(ptr)

declare i64 @forge_float_to_string(i64)

declare ptr @forge_format_float(i64, ptr)

declare ptr @forge_format_int(i64, ptr)

declare void @forge_ptr_store_byte(ptr, i64, i64)

declare i64 @forge_string_from_ptr(ptr, i64)

declare i64 @forge_trait_object_new(ptr, i64)

declare i64 @forge_trait_object_value(ptr)

declare ptr @forge_trait_object_vtable(ptr)

declare i64 @forge_datetime_now()

declare i64 @forge_datetime_format(ptr, i64)

declare i64 @forge_datetime_year(ptr)

declare i64 @forge_datetime_month(ptr)

declare i64 @forge_datetime_day(ptr)

declare i64 @forge_datetime_hour(ptr)

declare i64 @forge_datetime_minute(ptr)

declare i64 @forge_datetime_second(ptr)

declare ptr @forge_json_stringify_int(ptr)

declare ptr @forge_json_stringify_string(ptr)

declare ptr @forge_json_stringify_bool(ptr)

declare i64 @forge_json_get_int(ptr, i64)

declare i64 @forge_json_get_string(ptr, i64)

declare i64 @forge_json_get_bool(ptr, i64)

declare i64 @forge_semver_major(ptr)

declare i64 @forge_semver_minor(ptr)

declare i64 @forge_semver_patch(ptr)

declare i64 @forge_semver_compare(ptr, i64)

declare i64 @forge_validate_not_null(ptr, i64)

declare i64 @forge_validate_positive(ptr, i64)

declare i64 @forge_validate_not_empty(ptr, i64)

declare i64 @forge_toml_get_string(ptr, i64)

declare i64 @forge_toml_get_int(ptr, i64)

declare i64 @forge_toml_get_bool(ptr, i64)

declare i64 @forge_toml_get_section_string(ptr, i64, i64)

declare i64 @forge_toml_has_section(ptr, i64)

declare i64 @forge_spawn(ptr)

declare i64 @forge_task_await(ptr)

declare i32 @forge_thread_join(ptr)

declare void @forge_yield()

declare void @forge_scheduler_run()

declare ptr @forge_task_group_new()

declare void @forge_task_group_add(ptr, ptr)

declare void @forge_task_group_await_all(ptr)

declare ptr @forge_channel_new()

declare void @forge_channel_send(ptr, i64)

declare i64 @forge_channel_recv(ptr)

declare i32 @forge_channel_close(ptr)

declare i32 @forge_parallel_run(ptr)

declare i64 @forge_select(ptr, i64)

declare i64 @forge_select_index(ptr)

declare i64 @forge_select_value(ptr)

declare i32 @forge_test_start_spec(ptr)

declare i32 @forge_test_end_spec(ptr)

declare i32 @forge_test_start_given(ptr)

declare i32 @forge_test_end_given(ptr)

declare i64 @forge_test_run_then(ptr, i64)

declare i32 @forge_test_skip(ptr)

declare i32 @forge_test_todo(ptr)

declare i32 @forge_test_summary()

declare ptr @forge_arena_new()

declare ptr @forge_arena_alloc(ptr, i64)

declare void @forge_arena_destroy(ptr)

declare void @forge_match_unreachable(ptr, i64, ptr, i64)

declare i32 @forge_llvm_is_ptr_value(ptr)

declare ptr @forge_llvm_typeof(ptr)

declare ptr @forge_llvm_cast_to_type(ptr, ptr, ptr)

declare i32 @forge_llvm_is_void_value(ptr)

declare void @forge_llvm_build_store_cast(ptr, ptr, ptr)

declare i32 @forge_llvm_verify_function(ptr)

declare i64 @forge_llvm_type_kind(ptr)

declare i64 @forge_llvm_int_type_width(ptr)

declare ptr @forge_llvm_build_call_coerce(ptr, ptr, ptr, ptr, i64, ptr)

declare i64 @forge_test_roughly(double, double, double)

define i64 @main() {
entry:
  %for_end = alloca i64, align 8
  %i = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_main, align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr @__profc_main, align 8
  %1 = call ptr @forge_array_new()
  %pgocount1 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  call void @forge_array_push(ptr %1, i64 10)
  %pgocount2 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  call void @forge_array_push(ptr %1, i64 20)
  %pgocount3 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  call void @forge_array_push(ptr %1, i64 30)
  store ptr %1, ptr @nums, align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %8 = add i64 %pgocount7, 1
  store i64 %8, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %9 = add i64 %pgocount8, 1
  store i64 %9, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %nums = load ptr, ptr @nums, align 8
  %10 = call i64 @forge_array_len(ptr %nums)
  %11 = call ptr @forge_rc_alloc(i64 32)
  %12 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %11, i64 32, ptr @.i2s_fmt, i64 %10)
  %widen = sext i32 %12 to i64
  %13 = call i32 @puts(ptr %11)
  %widen1 = sext i32 %13 to i64
  %pgocount9 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %14 = add i64 %pgocount9, 1
  store i64 %14, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %15 = add i64 %pgocount10, 1
  store i64 %15, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %16 = add i64 %pgocount11, 1
  store i64 %16, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %17 = add i64 %pgocount12, 1
  store i64 %17, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %18 = add i64 %pgocount13, 1
  store i64 %18, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %nums2 = load ptr, ptr @nums, align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %19 = add i64 %pgocount14, 1
  store i64 %19, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %20 = call i64 @forge_array_get(ptr %nums2, i64 0)
  %21 = call ptr @forge_rc_alloc(i64 32)
  %22 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %21, i64 32, ptr @.i2s_fmt.1, i64 %20)
  %widen3 = sext i32 %22 to i64
  %23 = call i32 @puts(ptr %21)
  %widen4 = sext i32 %23 to i64
  %pgocount15 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %24 = add i64 %pgocount15, 1
  store i64 %24, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %pgocount16 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %25 = add i64 %pgocount16, 1
  store i64 %25, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %pgocount17 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %26 = add i64 %pgocount17, 1
  store i64 %26, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %27 = add i64 %pgocount18, 1
  store i64 %27, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %28 = add i64 %pgocount19, 1
  store i64 %28, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %nums5 = load ptr, ptr @nums, align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %29 = add i64 %pgocount20, 1
  store i64 %29, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %30 = call i64 @forge_array_get(ptr %nums5, i64 1)
  %31 = call ptr @forge_rc_alloc(i64 32)
  %32 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %31, i64 32, ptr @.i2s_fmt.2, i64 %30)
  %widen6 = sext i32 %32 to i64
  %33 = call i32 @puts(ptr %31)
  %widen7 = sext i32 %33 to i64
  %pgocount21 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %34 = add i64 %pgocount21, 1
  store i64 %34, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %pgocount22 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %35 = add i64 %pgocount22, 1
  store i64 %35, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %pgocount23 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %36 = add i64 %pgocount23, 1
  store i64 %36, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %pgocount24 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %37 = add i64 %pgocount24, 1
  store i64 %37, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %pgocount25 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %38 = add i64 %pgocount25, 1
  store i64 %38, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %nums8 = load ptr, ptr @nums, align 8
  %pgocount26 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %39 = add i64 %pgocount26, 1
  store i64 %39, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %40 = call i64 @forge_array_get(ptr %nums8, i64 2)
  %41 = call ptr @forge_rc_alloc(i64 32)
  %42 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %41, i64 32, ptr @.i2s_fmt.3, i64 %40)
  %widen9 = sext i32 %42 to i64
  %43 = call i32 @puts(ptr %41)
  %widen10 = sext i32 %43 to i64
  %pgocount27 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %44 = add i64 %pgocount27, 1
  store i64 %44, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %pgocount28 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %45 = add i64 %pgocount28, 1
  store i64 %45, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %pgocount29 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %46 = add i64 %pgocount29, 1
  store i64 %46, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %nums11 = load ptr, ptr @nums, align 8
  %pgocount30 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %47 = add i64 %pgocount30, 1
  store i64 %47, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  call void @forge_array_push(ptr %nums11, i64 40)
  %pgocount31 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %48 = add i64 %pgocount31, 1
  store i64 %48, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %pgocount32 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %49 = add i64 %pgocount32, 1
  store i64 %49, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %pgocount33 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %50 = add i64 %pgocount33, 1
  store i64 %50, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %pgocount34 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %51 = add i64 %pgocount34, 1
  store i64 %51, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %pgocount35 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %52 = add i64 %pgocount35, 1
  store i64 %52, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %nums12 = load ptr, ptr @nums, align 8
  %53 = call i64 @forge_array_len(ptr %nums12)
  %54 = call ptr @forge_rc_alloc(i64 32)
  %55 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %54, i64 32, ptr @.i2s_fmt.4, i64 %53)
  %widen13 = sext i32 %55 to i64
  %56 = call i32 @puts(ptr %54)
  %widen14 = sext i32 %56 to i64
  %pgocount36 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %57 = add i64 %pgocount36, 1
  store i64 %57, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %pgocount37 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %58 = add i64 %pgocount37, 1
  store i64 %58, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %pgocount38 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %59 = add i64 %pgocount38, 1
  store i64 %59, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %pgocount39 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %60 = add i64 %pgocount39, 1
  store i64 %60, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %pgocount40 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %61 = add i64 %pgocount40, 1
  store i64 %61, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %nums15 = load ptr, ptr @nums, align 8
  %pgocount41 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %62 = add i64 %pgocount41, 1
  store i64 %62, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %63 = call i64 @forge_array_get(ptr %nums15, i64 3)
  %64 = call ptr @forge_rc_alloc(i64 32)
  %65 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %64, i64 32, ptr @.i2s_fmt.5, i64 %63)
  %widen16 = sext i32 %65 to i64
  %66 = call i32 @puts(ptr %64)
  %widen17 = sext i32 %66 to i64
  %pgocount42 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %67 = add i64 %pgocount42, 1
  store i64 %67, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %pgocount43 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %68 = add i64 %pgocount43, 1
  store i64 %68, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %nums18 = load ptr, ptr @nums, align 8
  %69 = call i64 @forge_array_pop(ptr %nums18)
  store i64 %69, ptr @last, align 8
  %pgocount44 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %70 = add i64 %pgocount44, 1
  store i64 %70, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %pgocount45 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %71 = add i64 %pgocount45, 1
  store i64 %71, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %pgocount46 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %72 = add i64 %pgocount46, 1
  store i64 %72, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %pgocount47 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %73 = add i64 %pgocount47, 1
  store i64 %73, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %last = load i64, ptr @last, align 8
  %74 = call ptr @forge_rc_alloc(i64 32)
  %75 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %74, i64 32, ptr @.i2s_fmt.6, i64 %last)
  %widen19 = sext i32 %75 to i64
  %76 = call i32 @puts(ptr %74)
  %widen20 = sext i32 %76 to i64
  %pgocount48 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %77 = add i64 %pgocount48, 1
  store i64 %77, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %pgocount49 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %78 = add i64 %pgocount49, 1
  store i64 %78, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %pgocount50 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %79 = add i64 %pgocount50, 1
  store i64 %79, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %pgocount51 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %80 = add i64 %pgocount51, 1
  store i64 %80, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %pgocount52 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 52), align 8
  %81 = add i64 %pgocount52, 1
  store i64 %81, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 52), align 8
  %nums21 = load ptr, ptr @nums, align 8
  %82 = call i64 @forge_array_len(ptr %nums21)
  %83 = call ptr @forge_rc_alloc(i64 32)
  %84 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %83, i64 32, ptr @.i2s_fmt.7, i64 %82)
  %widen22 = sext i32 %84 to i64
  %85 = call i32 @puts(ptr %83)
  %widen23 = sext i32 %85 to i64
  %pgocount53 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 53), align 8
  %86 = add i64 %pgocount53, 1
  store i64 %86, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 53), align 8
  %87 = call ptr @forge_array_new()
  store ptr %87, ptr @empty, align 8
  %pgocount54 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 54), align 8
  %88 = add i64 %pgocount54, 1
  store i64 %88, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 54), align 8
  %pgocount55 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 55), align 8
  %89 = add i64 %pgocount55, 1
  store i64 %89, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 55), align 8
  %pgocount56 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 56), align 8
  %90 = add i64 %pgocount56, 1
  store i64 %90, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 56), align 8
  %pgocount57 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 57), align 8
  %91 = add i64 %pgocount57, 1
  store i64 %91, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 57), align 8
  %pgocount58 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 58), align 8
  %92 = add i64 %pgocount58, 1
  store i64 %92, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 58), align 8
  %empty = load ptr, ptr @empty, align 8
  %93 = call i64 @forge_array_len(ptr %empty)
  %94 = call ptr @forge_rc_alloc(i64 32)
  %95 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %94, i64 32, ptr @.i2s_fmt.8, i64 %93)
  %widen24 = sext i32 %95 to i64
  %96 = call i32 @puts(ptr %94)
  %widen25 = sext i32 %96 to i64
  %pgocount59 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 59), align 8
  %97 = add i64 %pgocount59, 1
  store i64 %97, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 59), align 8
  store i64 0, ptr @sum, align 8
  %pgocount60 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 60), align 8
  %98 = add i64 %pgocount60, 1
  store i64 %98, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 60), align 8
  %pgocount61 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 61), align 8
  %99 = add i64 %pgocount61, 1
  store i64 %99, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 61), align 8
  %pgocount62 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 62), align 8
  %100 = add i64 %pgocount62, 1
  store i64 %100, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 62), align 8
  %pgocount63 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 63), align 8
  %101 = add i64 %pgocount63, 1
  store i64 %101, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 63), align 8
  %pgocount64 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 64), align 8
  %102 = add i64 %pgocount64, 1
  store i64 %102, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 64), align 8
  %nums26 = load ptr, ptr @nums, align 8
  %103 = call i64 @forge_array_len(ptr %nums26)
  store i64 0, ptr %i, align 8
  store i64 %103, ptr %for_end, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.incr, %entry
  %i27 = load i64, ptr %i, align 8
  %for_end_val = load i64, ptr %for_end, align 8
  %for_cmp = icmp slt i64 %i27, %for_end_val
  br i1 %for_cmp, label %for.body, label %for.exit

for.body:                                         ; preds = %for.cond
  %pgocount65 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 65), align 8
  %104 = add i64 %pgocount65, 1
  store i64 %104, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 65), align 8
  %pgocount66 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 66), align 8
  %105 = add i64 %pgocount66, 1
  store i64 %105, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 66), align 8
  %pgocount67 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 67), align 8
  %106 = add i64 %pgocount67, 1
  store i64 %106, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 67), align 8
  %pgocount68 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 68), align 8
  %107 = add i64 %pgocount68, 1
  store i64 %107, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 68), align 8
  %pgocount69 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 69), align 8
  %108 = add i64 %pgocount69, 1
  store i64 %108, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 69), align 8
  %sum = load i64, ptr @sum, align 8
  %pgocount70 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 70), align 8
  %109 = add i64 %pgocount70, 1
  store i64 %109, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 70), align 8
  %pgocount71 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 71), align 8
  %110 = add i64 %pgocount71, 1
  store i64 %110, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 71), align 8
  %nums28 = load ptr, ptr @nums, align 8
  %pgocount72 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 72), align 8
  %111 = add i64 %pgocount72, 1
  store i64 %111, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 72), align 8
  %i29 = load i64, ptr %i, align 8
  %112 = call i64 @forge_array_get(ptr %nums28, i64 %i29)
  %add = add i64 %sum, %112
  store i64 %add, ptr @sum, align 8
  br label %for.incr

for.incr:                                         ; preds = %for.body
  %i30 = load i64, ptr %i, align 8
  %for_next = add i64 %i30, 1
  store i64 %for_next, ptr %i, align 8
  br label %for.cond

for.exit:                                         ; preds = %for.cond
  %pgocount73 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 73), align 8
  %113 = add i64 %pgocount73, 1
  store i64 %113, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 73), align 8
  %pgocount74 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 74), align 8
  %114 = add i64 %pgocount74, 1
  store i64 %114, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 74), align 8
  %pgocount75 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 75), align 8
  %115 = add i64 %pgocount75, 1
  store i64 %115, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 75), align 8
  %pgocount76 = load i64, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 76), align 8
  %116 = add i64 %pgocount76, 1
  store i64 %116, ptr getelementptr inbounds ([77 x i64], ptr @__profc_main, i32 0, i32 76), align 8
  %sum31 = load i64, ptr @sum, align 8
  %117 = call ptr @forge_rc_alloc(i64 32)
  %118 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %117, i64 32, ptr @.i2s_fmt.9, i64 %sum31)
  %widen32 = sext i32 %118 to i64
  %119 = call i32 @puts(ptr %117)
  %widen33 = sext i32 %119 to i64
  %120 = call i32 @forge_test_summary()
  %widen34 = sext i32 %120 to i64
  call void @forge_rc_collect()
  ret i64 0
}

; Function Attrs: noinline
define linkonce_odr hidden i32 @__llvm_profile_runtime_user() #1 {
  %1 = load i32, ptr @__llvm_profile_runtime, align 4
  ret i32 %1
}

attributes #0 = { nounwind }
attributes #1 = { noinline }
