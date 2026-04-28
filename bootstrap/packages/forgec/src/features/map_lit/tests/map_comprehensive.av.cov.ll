; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/map_lit/tests/map_comprehensive.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

@m = global i64 0
@e = global i64 0
@k = global i64 0
@nums = global i64 0
@sum = global i64 0
@.str = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.str.1 = private unnamed_addr constant [3 x i8] c"10\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@.str.3 = private unnamed_addr constant [3 x i8] c"20\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"z\00", align 1
@.str.5 = private unnamed_addr constant [3 x i8] c"30\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.str.7 = private unnamed_addr constant [2 x i8] c"z\00", align 1
@.str.8 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.i2s_fmt.9 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.10 = private unnamed_addr constant [2 x i8] c"w\00", align 1
@.i2s_fmt.11 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.12 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.str.13 = private unnamed_addr constant [3 x i8] c"99\00", align 1
@.str.14 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.i2s_fmt.15 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.16 = private unnamed_addr constant [9 x i8] c"anything\00", align 1
@.i2s_fmt.17 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.18 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.19 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.20 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@.str.21 = private unnamed_addr constant [2 x i8] c"c\00", align 1
@.str.22 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.23 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@.str.24 = private unnamed_addr constant [2 x i8] c"c\00", align 1
@.i2s_fmt.25 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_main = private global [85 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 85, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
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
  %pgocount = load i64, ptr @__profc_main, align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr @__profc_main, align 8
  %1 = call ptr @forge_map_new_cstr()
  %pgocount1 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  call void @forge_map_set_cstr(ptr %1, ptr @.str, i64 ptrtoint (ptr @.str.1 to i64))
  %pgocount3 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  call void @forge_map_set_cstr(ptr %1, ptr @.str.2, i64 ptrtoint (ptr @.str.3 to i64))
  %pgocount5 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  call void @forge_map_set_cstr(ptr %1, ptr @.str.4, i64 ptrtoint (ptr @.str.5 to i64))
  store ptr %1, ptr @m, align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %8 = add i64 %pgocount7, 1
  store i64 %8, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %9 = add i64 %pgocount8, 1
  store i64 %9, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %10 = add i64 %pgocount9, 1
  store i64 %10, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %11 = add i64 %pgocount10, 1
  store i64 %11, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %12 = add i64 %pgocount11, 1
  store i64 %12, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %m = load ptr, ptr @m, align 8
  %13 = call i64 @forge_map_len_cstr(ptr %m)
  %14 = call ptr @forge_rc_alloc(i64 32)
  %15 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %14, i64 32, ptr @.i2s_fmt, i64 %13)
  %widen = sext i32 %15 to i64
  %16 = call i32 @puts(ptr %14)
  %widen1 = sext i32 %16 to i64
  %pgocount12 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %17 = add i64 %pgocount12, 1
  store i64 %17, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %18 = add i64 %pgocount13, 1
  store i64 %18, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %19 = add i64 %pgocount14, 1
  store i64 %19, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %20 = add i64 %pgocount15, 1
  store i64 %20, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %m2 = load ptr, ptr @m, align 8
  %pgocount16 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %21 = add i64 %pgocount16, 1
  store i64 %21, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %22 = call i64 @forge_map_get_cstr(ptr %m2, ptr @.str.6)
  %cast = inttoptr i64 %22 to ptr
  %23 = call i32 @puts(ptr %cast)
  %widen3 = sext i32 %23 to i64
  %pgocount17 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %24 = add i64 %pgocount17, 1
  store i64 %24, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %25 = add i64 %pgocount18, 1
  store i64 %25, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %26 = add i64 %pgocount19, 1
  store i64 %26, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %27 = add i64 %pgocount20, 1
  store i64 %27, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %m4 = load ptr, ptr @m, align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %28 = add i64 %pgocount21, 1
  store i64 %28, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %29 = call i64 @forge_map_get_cstr(ptr %m4, ptr @.str.7)
  %cast5 = inttoptr i64 %29 to ptr
  %30 = call i32 @puts(ptr %cast5)
  %widen6 = sext i32 %30 to i64
  %pgocount22 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %31 = add i64 %pgocount22, 1
  store i64 %31, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %pgocount23 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %32 = add i64 %pgocount23, 1
  store i64 %32, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %pgocount24 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %33 = add i64 %pgocount24, 1
  store i64 %33, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %pgocount25 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %34 = add i64 %pgocount25, 1
  store i64 %34, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %pgocount26 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %35 = add i64 %pgocount26, 1
  store i64 %35, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %m7 = load ptr, ptr @m, align 8
  %pgocount27 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %36 = add i64 %pgocount27, 1
  store i64 %36, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %37 = call i64 @forge_map_has_cstr(ptr %m7, ptr @.str.8)
  %38 = call ptr @forge_rc_alloc(i64 32)
  %39 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %38, i64 32, ptr @.i2s_fmt.9, i64 %37)
  %widen8 = sext i32 %39 to i64
  %40 = call i32 @puts(ptr %38)
  %widen9 = sext i32 %40 to i64
  %pgocount28 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %41 = add i64 %pgocount28, 1
  store i64 %41, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %pgocount29 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %42 = add i64 %pgocount29, 1
  store i64 %42, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %pgocount30 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %43 = add i64 %pgocount30, 1
  store i64 %43, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %pgocount31 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %44 = add i64 %pgocount31, 1
  store i64 %44, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %pgocount32 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %45 = add i64 %pgocount32, 1
  store i64 %45, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %m10 = load ptr, ptr @m, align 8
  %pgocount33 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %46 = add i64 %pgocount33, 1
  store i64 %46, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %47 = call i64 @forge_map_has_cstr(ptr %m10, ptr @.str.10)
  %48 = call ptr @forge_rc_alloc(i64 32)
  %49 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %48, i64 32, ptr @.i2s_fmt.11, i64 %47)
  %widen11 = sext i32 %49 to i64
  %50 = call i32 @puts(ptr %48)
  %widen12 = sext i32 %50 to i64
  %pgocount34 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %51 = add i64 %pgocount34, 1
  store i64 %51, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %pgocount35 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %52 = add i64 %pgocount35, 1
  store i64 %52, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %pgocount36 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %53 = add i64 %pgocount36, 1
  store i64 %53, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %m13 = load ptr, ptr @m, align 8
  %pgocount37 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %54 = add i64 %pgocount37, 1
  store i64 %54, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %pgocount38 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %55 = add i64 %pgocount38, 1
  store i64 %55, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  call void @forge_map_set_cstr(ptr %m13, ptr @.str.12, i64 ptrtoint (ptr @.str.13 to i64))
  %pgocount39 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %56 = add i64 %pgocount39, 1
  store i64 %56, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %pgocount40 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %57 = add i64 %pgocount40, 1
  store i64 %57, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %pgocount41 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %58 = add i64 %pgocount41, 1
  store i64 %58, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %pgocount42 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %59 = add i64 %pgocount42, 1
  store i64 %59, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %m14 = load ptr, ptr @m, align 8
  %pgocount43 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %60 = add i64 %pgocount43, 1
  store i64 %60, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %61 = call i64 @forge_map_get_cstr(ptr %m14, ptr @.str.14)
  %cast15 = inttoptr i64 %61 to ptr
  %62 = call i32 @puts(ptr %cast15)
  %widen16 = sext i32 %62 to i64
  %pgocount44 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %63 = add i64 %pgocount44, 1
  store i64 %63, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %64 = call ptr @forge_map_new_cstr()
  store ptr %64, ptr @e, align 8
  %pgocount45 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %65 = add i64 %pgocount45, 1
  store i64 %65, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %pgocount46 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %66 = add i64 %pgocount46, 1
  store i64 %66, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %pgocount47 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %67 = add i64 %pgocount47, 1
  store i64 %67, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %pgocount48 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %68 = add i64 %pgocount48, 1
  store i64 %68, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %pgocount49 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %69 = add i64 %pgocount49, 1
  store i64 %69, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %e = load ptr, ptr @e, align 8
  %70 = call i64 @forge_map_len_cstr(ptr %e)
  %71 = call ptr @forge_rc_alloc(i64 32)
  %72 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %71, i64 32, ptr @.i2s_fmt.15, i64 %70)
  %widen17 = sext i32 %72 to i64
  %73 = call i32 @puts(ptr %71)
  %widen18 = sext i32 %73 to i64
  %pgocount50 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %74 = add i64 %pgocount50, 1
  store i64 %74, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %pgocount51 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %75 = add i64 %pgocount51, 1
  store i64 %75, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %pgocount52 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 52), align 8
  %76 = add i64 %pgocount52, 1
  store i64 %76, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 52), align 8
  %pgocount53 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 53), align 8
  %77 = add i64 %pgocount53, 1
  store i64 %77, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 53), align 8
  %pgocount54 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 54), align 8
  %78 = add i64 %pgocount54, 1
  store i64 %78, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 54), align 8
  %e19 = load ptr, ptr @e, align 8
  %pgocount55 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 55), align 8
  %79 = add i64 %pgocount55, 1
  store i64 %79, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 55), align 8
  %80 = call i64 @forge_map_has_cstr(ptr %e19, ptr @.str.16)
  %81 = call ptr @forge_rc_alloc(i64 32)
  %82 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %81, i64 32, ptr @.i2s_fmt.17, i64 %80)
  %widen20 = sext i32 %82 to i64
  %83 = call i32 @puts(ptr %81)
  %widen21 = sext i32 %83 to i64
  %pgocount56 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 56), align 8
  %84 = add i64 %pgocount56, 1
  store i64 %84, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 56), align 8
  %pgocount57 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 57), align 8
  %85 = add i64 %pgocount57, 1
  store i64 %85, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 57), align 8
  %m22 = load ptr, ptr @m, align 8
  %86 = call ptr @forge_map_keys_cstr(ptr %m22)
  store ptr %86, ptr @k, align 8
  %pgocount58 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 58), align 8
  %87 = add i64 %pgocount58, 1
  store i64 %87, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 58), align 8
  %pgocount59 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 59), align 8
  %88 = add i64 %pgocount59, 1
  store i64 %88, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 59), align 8
  %pgocount60 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 60), align 8
  %89 = add i64 %pgocount60, 1
  store i64 %89, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 60), align 8
  %pgocount61 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 61), align 8
  %90 = add i64 %pgocount61, 1
  store i64 %90, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 61), align 8
  %pgocount62 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 62), align 8
  %91 = add i64 %pgocount62, 1
  store i64 %91, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 62), align 8
  %k = load ptr, ptr @k, align 8
  %92 = call i64 @forge_array_len(ptr %k)
  %93 = call ptr @forge_rc_alloc(i64 32)
  %94 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %93, i64 32, ptr @.i2s_fmt.18, i64 %92)
  %widen23 = sext i32 %94 to i64
  %95 = call i32 @puts(ptr %93)
  %widen24 = sext i32 %95 to i64
  %pgocount63 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 63), align 8
  %96 = add i64 %pgocount63, 1
  store i64 %96, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 63), align 8
  %97 = call ptr @forge_map_new_cstr()
  %pgocount64 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 64), align 8
  %98 = add i64 %pgocount64, 1
  store i64 %98, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 64), align 8
  %pgocount65 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 65), align 8
  %99 = add i64 %pgocount65, 1
  store i64 %99, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 65), align 8
  call void @forge_map_set_cstr(ptr %97, ptr @.str.19, i64 1)
  %pgocount66 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 66), align 8
  %100 = add i64 %pgocount66, 1
  store i64 %100, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 66), align 8
  %pgocount67 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 67), align 8
  %101 = add i64 %pgocount67, 1
  store i64 %101, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 67), align 8
  call void @forge_map_set_cstr(ptr %97, ptr @.str.20, i64 2)
  %pgocount68 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 68), align 8
  %102 = add i64 %pgocount68, 1
  store i64 %102, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 68), align 8
  %pgocount69 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 69), align 8
  %103 = add i64 %pgocount69, 1
  store i64 %103, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 69), align 8
  call void @forge_map_set_cstr(ptr %97, ptr @.str.21, i64 3)
  store ptr %97, ptr @nums, align 8
  %pgocount70 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 70), align 8
  %104 = add i64 %pgocount70, 1
  store i64 %104, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 70), align 8
  %pgocount71 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 71), align 8
  %105 = add i64 %pgocount71, 1
  store i64 %105, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 71), align 8
  %pgocount72 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 72), align 8
  %106 = add i64 %pgocount72, 1
  store i64 %106, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 72), align 8
  %pgocount73 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 73), align 8
  %107 = add i64 %pgocount73, 1
  store i64 %107, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 73), align 8
  %nums = load ptr, ptr @nums, align 8
  %pgocount74 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 74), align 8
  %108 = add i64 %pgocount74, 1
  store i64 %108, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 74), align 8
  %109 = call i64 @forge_map_get_cstr(ptr %nums, ptr @.str.22)
  %pgocount75 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 75), align 8
  %110 = add i64 %pgocount75, 1
  store i64 %110, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 75), align 8
  %pgocount76 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 76), align 8
  %111 = add i64 %pgocount76, 1
  store i64 %111, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 76), align 8
  %nums25 = load ptr, ptr @nums, align 8
  %pgocount77 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 77), align 8
  %112 = add i64 %pgocount77, 1
  store i64 %112, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 77), align 8
  %113 = call i64 @forge_map_get_cstr(ptr %nums25, ptr @.str.23)
  %add = add i64 %109, %113
  %pgocount78 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 78), align 8
  %114 = add i64 %pgocount78, 1
  store i64 %114, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 78), align 8
  %pgocount79 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 79), align 8
  %115 = add i64 %pgocount79, 1
  store i64 %115, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 79), align 8
  %nums26 = load ptr, ptr @nums, align 8
  %pgocount80 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 80), align 8
  %116 = add i64 %pgocount80, 1
  store i64 %116, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 80), align 8
  %117 = call i64 @forge_map_get_cstr(ptr %nums26, ptr @.str.24)
  %add27 = add i64 %add, %117
  store i64 %add27, ptr @sum, align 8
  %pgocount81 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 81), align 8
  %118 = add i64 %pgocount81, 1
  store i64 %118, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 81), align 8
  %pgocount82 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 82), align 8
  %119 = add i64 %pgocount82, 1
  store i64 %119, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 82), align 8
  %pgocount83 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 83), align 8
  %120 = add i64 %pgocount83, 1
  store i64 %120, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 83), align 8
  %pgocount84 = load i64, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 84), align 8
  %121 = add i64 %pgocount84, 1
  store i64 %121, ptr getelementptr inbounds ([85 x i64], ptr @__profc_main, i32 0, i32 84), align 8
  %sum = load i64, ptr @sum, align 8
  %122 = call ptr @forge_rc_alloc(i64 32)
  %123 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %122, i64 32, ptr @.i2s_fmt.25, i64 %sum)
  %widen28 = sext i32 %123 to i64
  %124 = call i32 @puts(ptr %122)
  %widen29 = sext i32 %124 to i64
  %125 = call i32 @forge_test_summary()
  %widen30 = sext i32 %125 to i64
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
