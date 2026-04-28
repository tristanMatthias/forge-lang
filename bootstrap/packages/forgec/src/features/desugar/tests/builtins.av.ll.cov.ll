; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/desugar/tests/builtins.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

@.str = private unnamed_addr constant [6 x i8] c"min: \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"max: \00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.3 = private unnamed_addr constant [10 x i8] c"min_neg: \00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.5 = private unnamed_addr constant [11 x i8] c"max_same: \00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.7 = private unnamed_addr constant [11 x i8] c"min_expr: \00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.9 = private unnamed_addr constant [22 x i8] c"not yet implemented: \00", align 1
@.str.10 = private unnamed_addr constant [21 x i8] c"implement this later\00", align 1
@.panic_prefix = private unnamed_addr constant [8 x i8] c"panic: \00", align 1
@.str.11 = private unnamed_addr constant [13 x i8] c"todo_skipped\00", align 1
@.str.12 = private unnamed_addr constant [14 x i8] c"unreachable: \00", align 1
@.str.13 = private unnamed_addr constant [21 x i8] c"x should be positive\00", align 1
@.panic_prefix.14 = private unnamed_addr constant [8 x i8] c"panic: \00", align 1
@.str.15 = private unnamed_addr constant [20 x i8] c"unreachable_skipped\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_main = private global [138 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 138, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
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
  %x = alloca i64, align 8
  %use_todo = alloca i1, align 1
  %ife_result79 = alloca i64, align 8
  %__b74 = alloca i64, align 8
  %__a72 = alloca i64, align 8
  %b = alloca i64, align 8
  %a = alloca i64, align 8
  %ife_result55 = alloca i64, align 8
  %__b50 = alloca i64, align 8
  %__a49 = alloca i64, align 8
  %ife_result33 = alloca i64, align 8
  %__b28 = alloca i64, align 8
  %__a27 = alloca i64, align 8
  %ife_result11 = alloca i64, align 8
  %__b8 = alloca i64, align 8
  %__a7 = alloca i64, align 8
  %ife_result = alloca i64, align 8
  %__b = alloca i64, align 8
  %__a = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_main, align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr @__profc_main, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %3 = add i64 %pgocount3, 1
  store i64 %3, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %4 = add i64 %pgocount4, 1
  store i64 %4, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %5 = add i64 %pgocount5, 1
  store i64 %5, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %6 = add i64 %pgocount6, 1
  store i64 %6, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %7 = add i64 %pgocount7, 1
  store i64 %7, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %8 = add i64 %pgocount8, 1
  store i64 %8, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %9 = add i64 %pgocount9, 1
  store i64 %9, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  store i64 3, ptr %__a, align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %10 = add i64 %pgocount10, 1
  store i64 %10, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %11 = add i64 %pgocount11, 1
  store i64 %11, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  store i64 10, ptr %__b, align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %12 = add i64 %pgocount12, 1
  store i64 %12, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %13 = add i64 %pgocount13, 1
  store i64 %13, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %14 = add i64 %pgocount14, 1
  store i64 %14, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %15 = add i64 %pgocount15, 1
  store i64 %15, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %__a1 = load i64, ptr %__a, align 8
  %pgocount16 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %16 = add i64 %pgocount16, 1
  store i64 %16, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %__b2 = load i64, ptr %__b, align 8
  %slt = icmp slt i64 %__a1, %__b2
  %slt_ext = zext i1 %slt to i64
  %ife_cond = icmp ne i64 %slt_ext, 0
  br i1 %ife_cond, label %ife_then, label %ife_else

ife_end:                                          ; preds = %ife_else, %ife_then
  %ife_val = load i64, ptr %ife_result, align 8
  %17 = call ptr @forge_rc_alloc(i64 32)
  %18 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %17, i64 32, ptr @.i2s_fmt, i64 %ife_val)
  %widen = sext i32 %18 to i64
  %19 = call i64 @strlen(ptr @.str)
  %20 = call i64 @strlen(ptr %17)
  %concat_total = add i64 %19, %20
  %concat_size = add i64 %concat_total, 1
  %21 = call ptr @forge_rc_alloc(i64 %concat_size)
  %22 = call ptr @memcpy(ptr %21, ptr @.str, i64 %19)
  %cast = ptrtoint ptr %21 to i64
  %dst2_int = add i64 %cast, %19
  %cast5 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %20, 1
  %23 = call ptr @memcpy(ptr %cast5, ptr %17, i64 %rhs_len_p1)
  %24 = call i32 @puts(ptr %21)
  %widen6 = sext i32 %24 to i64
  %pgocount17 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %25 = add i64 %pgocount17, 1
  store i64 %25, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %26 = add i64 %pgocount18, 1
  store i64 %26, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %27 = add i64 %pgocount19, 1
  store i64 %27, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %28 = add i64 %pgocount20, 1
  store i64 %28, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %29 = add i64 %pgocount21, 1
  store i64 %29, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %pgocount22 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %30 = add i64 %pgocount22, 1
  store i64 %30, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %pgocount23 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %31 = add i64 %pgocount23, 1
  store i64 %31, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %pgocount24 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %32 = add i64 %pgocount24, 1
  store i64 %32, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %pgocount25 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %33 = add i64 %pgocount25, 1
  store i64 %33, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  store i64 3, ptr %__a7, align 8
  %pgocount26 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %34 = add i64 %pgocount26, 1
  store i64 %34, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %pgocount27 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %35 = add i64 %pgocount27, 1
  store i64 %35, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  store i64 10, ptr %__b8, align 8
  %pgocount28 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %36 = add i64 %pgocount28, 1
  store i64 %36, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %pgocount29 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %37 = add i64 %pgocount29, 1
  store i64 %37, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %pgocount30 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %38 = add i64 %pgocount30, 1
  store i64 %38, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %pgocount31 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %39 = add i64 %pgocount31, 1
  store i64 %39, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %__a9 = load i64, ptr %__a7, align 8
  %pgocount32 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %40 = add i64 %pgocount32, 1
  store i64 %40, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %__b10 = load i64, ptr %__b8, align 8
  %sgt = icmp sgt i64 %__a9, %__b10
  %sgt_ext = zext i1 %sgt to i64
  %ife_cond13 = icmp ne i64 %sgt_ext, 0
  br i1 %ife_cond13, label %ife_then14, label %ife_else15

ife_then:                                         ; preds = %entry
  %pgocount33 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %41 = add i64 %pgocount33, 1
  store i64 %41, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %pgocount34 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %42 = add i64 %pgocount34, 1
  store i64 %42, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %__a3 = load i64, ptr %__a, align 8
  store i64 %__a3, ptr %ife_result, align 8
  br label %ife_end

ife_else:                                         ; preds = %entry
  %pgocount35 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %43 = add i64 %pgocount35, 1
  store i64 %43, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %pgocount36 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %44 = add i64 %pgocount36, 1
  store i64 %44, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %__b4 = load i64, ptr %__b, align 8
  store i64 %__b4, ptr %ife_result, align 8
  br label %ife_end

ife_end12:                                        ; preds = %ife_else15, %ife_then14
  %ife_val18 = load i64, ptr %ife_result11, align 8
  %45 = call ptr @forge_rc_alloc(i64 32)
  %46 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %45, i64 32, ptr @.i2s_fmt.2, i64 %ife_val18)
  %widen19 = sext i32 %46 to i64
  %47 = call i64 @strlen(ptr @.str.1)
  %48 = call i64 @strlen(ptr %45)
  %concat_total20 = add i64 %47, %48
  %concat_size21 = add i64 %concat_total20, 1
  %49 = call ptr @forge_rc_alloc(i64 %concat_size21)
  %50 = call ptr @memcpy(ptr %49, ptr @.str.1, i64 %47)
  %cast22 = ptrtoint ptr %49 to i64
  %dst2_int23 = add i64 %cast22, %47
  %cast24 = inttoptr i64 %dst2_int23 to ptr
  %rhs_len_p125 = add i64 %48, 1
  %51 = call ptr @memcpy(ptr %cast24, ptr %45, i64 %rhs_len_p125)
  %52 = call i32 @puts(ptr %49)
  %widen26 = sext i32 %52 to i64
  %pgocount37 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %53 = add i64 %pgocount37, 1
  store i64 %53, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %pgocount38 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %54 = add i64 %pgocount38, 1
  store i64 %54, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %pgocount39 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %55 = add i64 %pgocount39, 1
  store i64 %55, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %pgocount40 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %56 = add i64 %pgocount40, 1
  store i64 %56, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %pgocount41 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %57 = add i64 %pgocount41, 1
  store i64 %57, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %pgocount42 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %58 = add i64 %pgocount42, 1
  store i64 %58, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %pgocount43 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %59 = add i64 %pgocount43, 1
  store i64 %59, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %pgocount44 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %60 = add i64 %pgocount44, 1
  store i64 %60, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %pgocount45 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %61 = add i64 %pgocount45, 1
  store i64 %61, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %pgocount46 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %62 = add i64 %pgocount46, 1
  store i64 %62, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  store i64 -5, ptr %__a27, align 8
  %pgocount47 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %63 = add i64 %pgocount47, 1
  store i64 %63, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %pgocount48 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 52), align 8
  %64 = add i64 %pgocount48, 1
  store i64 %64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 52), align 8
  store i64 5, ptr %__b28, align 8
  %pgocount49 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 53), align 8
  %65 = add i64 %pgocount49, 1
  store i64 %65, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 53), align 8
  %pgocount50 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 54), align 8
  %66 = add i64 %pgocount50, 1
  store i64 %66, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 54), align 8
  %pgocount51 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 55), align 8
  %67 = add i64 %pgocount51, 1
  store i64 %67, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 55), align 8
  %pgocount52 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 56), align 8
  %68 = add i64 %pgocount52, 1
  store i64 %68, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 56), align 8
  %__a29 = load i64, ptr %__a27, align 8
  %pgocount53 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 57), align 8
  %69 = add i64 %pgocount53, 1
  store i64 %69, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 57), align 8
  %__b30 = load i64, ptr %__b28, align 8
  %slt31 = icmp slt i64 %__a29, %__b30
  %slt_ext32 = zext i1 %slt31 to i64
  %ife_cond35 = icmp ne i64 %slt_ext32, 0
  br i1 %ife_cond35, label %ife_then36, label %ife_else37

ife_then14:                                       ; preds = %ife_end
  %pgocount54 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %70 = add i64 %pgocount54, 1
  store i64 %70, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %pgocount55 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %71 = add i64 %pgocount55, 1
  store i64 %71, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %__a16 = load i64, ptr %__a7, align 8
  store i64 %__a16, ptr %ife_result11, align 8
  br label %ife_end12

ife_else15:                                       ; preds = %ife_end
  %pgocount56 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %72 = add i64 %pgocount56, 1
  store i64 %72, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %pgocount57 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %73 = add i64 %pgocount57, 1
  store i64 %73, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %__b17 = load i64, ptr %__b8, align 8
  store i64 %__b17, ptr %ife_result11, align 8
  br label %ife_end12

ife_end34:                                        ; preds = %ife_else37, %ife_then36
  %ife_val40 = load i64, ptr %ife_result33, align 8
  %74 = call ptr @forge_rc_alloc(i64 32)
  %75 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %74, i64 32, ptr @.i2s_fmt.4, i64 %ife_val40)
  %widen41 = sext i32 %75 to i64
  %76 = call i64 @strlen(ptr @.str.3)
  %77 = call i64 @strlen(ptr %74)
  %concat_total42 = add i64 %76, %77
  %concat_size43 = add i64 %concat_total42, 1
  %78 = call ptr @forge_rc_alloc(i64 %concat_size43)
  %79 = call ptr @memcpy(ptr %78, ptr @.str.3, i64 %76)
  %cast44 = ptrtoint ptr %78 to i64
  %dst2_int45 = add i64 %cast44, %76
  %cast46 = inttoptr i64 %dst2_int45 to ptr
  %rhs_len_p147 = add i64 %77, 1
  %80 = call ptr @memcpy(ptr %cast46, ptr %74, i64 %rhs_len_p147)
  %81 = call i32 @puts(ptr %78)
  %widen48 = sext i32 %81 to i64
  %pgocount58 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 62), align 8
  %82 = add i64 %pgocount58, 1
  store i64 %82, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 62), align 8
  %pgocount59 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 63), align 8
  %83 = add i64 %pgocount59, 1
  store i64 %83, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 63), align 8
  %pgocount60 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 64), align 8
  %84 = add i64 %pgocount60, 1
  store i64 %84, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 64), align 8
  %pgocount61 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 65), align 8
  %85 = add i64 %pgocount61, 1
  store i64 %85, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 65), align 8
  %pgocount62 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 66), align 8
  %86 = add i64 %pgocount62, 1
  store i64 %86, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 66), align 8
  %pgocount63 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 67), align 8
  %87 = add i64 %pgocount63, 1
  store i64 %87, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 67), align 8
  %pgocount64 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 68), align 8
  %88 = add i64 %pgocount64, 1
  store i64 %88, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 68), align 8
  %pgocount65 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 69), align 8
  %89 = add i64 %pgocount65, 1
  store i64 %89, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 69), align 8
  %pgocount66 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 70), align 8
  %90 = add i64 %pgocount66, 1
  store i64 %90, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 70), align 8
  store i64 7, ptr %__a49, align 8
  %pgocount67 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 71), align 8
  %91 = add i64 %pgocount67, 1
  store i64 %91, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 71), align 8
  %pgocount68 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 72), align 8
  %92 = add i64 %pgocount68, 1
  store i64 %92, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 72), align 8
  store i64 7, ptr %__b50, align 8
  %pgocount69 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 73), align 8
  %93 = add i64 %pgocount69, 1
  store i64 %93, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 73), align 8
  %pgocount70 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 74), align 8
  %94 = add i64 %pgocount70, 1
  store i64 %94, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 74), align 8
  %pgocount71 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 75), align 8
  %95 = add i64 %pgocount71, 1
  store i64 %95, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 75), align 8
  %pgocount72 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 76), align 8
  %96 = add i64 %pgocount72, 1
  store i64 %96, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 76), align 8
  %__a51 = load i64, ptr %__a49, align 8
  %pgocount73 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 77), align 8
  %97 = add i64 %pgocount73, 1
  store i64 %97, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 77), align 8
  %__b52 = load i64, ptr %__b50, align 8
  %sgt53 = icmp sgt i64 %__a51, %__b52
  %sgt_ext54 = zext i1 %sgt53 to i64
  %ife_cond57 = icmp ne i64 %sgt_ext54, 0
  br i1 %ife_cond57, label %ife_then58, label %ife_else59

ife_then36:                                       ; preds = %ife_end12
  %pgocount74 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 58), align 8
  %98 = add i64 %pgocount74, 1
  store i64 %98, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 58), align 8
  %pgocount75 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 59), align 8
  %99 = add i64 %pgocount75, 1
  store i64 %99, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 59), align 8
  %__a38 = load i64, ptr %__a27, align 8
  store i64 %__a38, ptr %ife_result33, align 8
  br label %ife_end34

ife_else37:                                       ; preds = %ife_end12
  %pgocount76 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 60), align 8
  %100 = add i64 %pgocount76, 1
  store i64 %100, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 60), align 8
  %pgocount77 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 61), align 8
  %101 = add i64 %pgocount77, 1
  store i64 %101, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 61), align 8
  %__b39 = load i64, ptr %__b28, align 8
  store i64 %__b39, ptr %ife_result33, align 8
  br label %ife_end34

ife_end56:                                        ; preds = %ife_else59, %ife_then58
  %ife_val62 = load i64, ptr %ife_result55, align 8
  %102 = call ptr @forge_rc_alloc(i64 32)
  %103 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %102, i64 32, ptr @.i2s_fmt.6, i64 %ife_val62)
  %widen63 = sext i32 %103 to i64
  %104 = call i64 @strlen(ptr @.str.5)
  %105 = call i64 @strlen(ptr %102)
  %concat_total64 = add i64 %104, %105
  %concat_size65 = add i64 %concat_total64, 1
  %106 = call ptr @forge_rc_alloc(i64 %concat_size65)
  %107 = call ptr @memcpy(ptr %106, ptr @.str.5, i64 %104)
  %cast66 = ptrtoint ptr %106 to i64
  %dst2_int67 = add i64 %cast66, %104
  %cast68 = inttoptr i64 %dst2_int67 to ptr
  %rhs_len_p169 = add i64 %105, 1
  %108 = call ptr @memcpy(ptr %cast68, ptr %102, i64 %rhs_len_p169)
  %109 = call i32 @puts(ptr %106)
  %widen70 = sext i32 %109 to i64
  %pgocount78 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 82), align 8
  %110 = add i64 %pgocount78, 1
  store i64 %110, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 82), align 8
  %pgocount79 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 83), align 8
  %111 = add i64 %pgocount79, 1
  store i64 %111, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 83), align 8
  store i64 4, ptr %a, align 8
  %pgocount80 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 84), align 8
  %112 = add i64 %pgocount80, 1
  store i64 %112, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 84), align 8
  %pgocount81 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 85), align 8
  %113 = add i64 %pgocount81, 1
  store i64 %113, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 85), align 8
  store i64 8, ptr %b, align 8
  %pgocount82 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 86), align 8
  %114 = add i64 %pgocount82, 1
  store i64 %114, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 86), align 8
  %pgocount83 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 87), align 8
  %115 = add i64 %pgocount83, 1
  store i64 %115, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 87), align 8
  %pgocount84 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 88), align 8
  %116 = add i64 %pgocount84, 1
  store i64 %116, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 88), align 8
  %pgocount85 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 89), align 8
  %117 = add i64 %pgocount85, 1
  store i64 %117, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 89), align 8
  %pgocount86 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 90), align 8
  %118 = add i64 %pgocount86, 1
  store i64 %118, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 90), align 8
  %pgocount87 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 91), align 8
  %119 = add i64 %pgocount87, 1
  store i64 %119, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 91), align 8
  %pgocount88 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 92), align 8
  %120 = add i64 %pgocount88, 1
  store i64 %120, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 92), align 8
  %pgocount89 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 93), align 8
  %121 = add i64 %pgocount89, 1
  store i64 %121, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 93), align 8
  %pgocount90 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 94), align 8
  %122 = add i64 %pgocount90, 1
  store i64 %122, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 94), align 8
  %a71 = load i64, ptr %a, align 8
  store i64 %a71, ptr %__a72, align 8
  %pgocount91 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 95), align 8
  %123 = add i64 %pgocount91, 1
  store i64 %123, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 95), align 8
  %pgocount92 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 96), align 8
  %124 = add i64 %pgocount92, 1
  store i64 %124, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 96), align 8
  %b73 = load i64, ptr %b, align 8
  store i64 %b73, ptr %__b74, align 8
  %pgocount93 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 97), align 8
  %125 = add i64 %pgocount93, 1
  store i64 %125, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 97), align 8
  %pgocount94 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 98), align 8
  %126 = add i64 %pgocount94, 1
  store i64 %126, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 98), align 8
  %pgocount95 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 99), align 8
  %127 = add i64 %pgocount95, 1
  store i64 %127, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 99), align 8
  %pgocount96 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 100), align 8
  %128 = add i64 %pgocount96, 1
  store i64 %128, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 100), align 8
  %__a75 = load i64, ptr %__a72, align 8
  %pgocount97 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 101), align 8
  %129 = add i64 %pgocount97, 1
  store i64 %129, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 101), align 8
  %__b76 = load i64, ptr %__b74, align 8
  %slt77 = icmp slt i64 %__a75, %__b76
  %slt_ext78 = zext i1 %slt77 to i64
  %ife_cond81 = icmp ne i64 %slt_ext78, 0
  br i1 %ife_cond81, label %ife_then82, label %ife_else83

ife_then58:                                       ; preds = %ife_end34
  %pgocount98 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 78), align 8
  %130 = add i64 %pgocount98, 1
  store i64 %130, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 78), align 8
  %pgocount99 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 79), align 8
  %131 = add i64 %pgocount99, 1
  store i64 %131, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 79), align 8
  %__a60 = load i64, ptr %__a49, align 8
  store i64 %__a60, ptr %ife_result55, align 8
  br label %ife_end56

ife_else59:                                       ; preds = %ife_end34
  %pgocount100 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 80), align 8
  %132 = add i64 %pgocount100, 1
  store i64 %132, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 80), align 8
  %pgocount101 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 81), align 8
  %133 = add i64 %pgocount101, 1
  store i64 %133, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 81), align 8
  %__b61 = load i64, ptr %__b50, align 8
  store i64 %__b61, ptr %ife_result55, align 8
  br label %ife_end56

ife_end80:                                        ; preds = %ife_else83, %ife_then82
  %ife_val86 = load i64, ptr %ife_result79, align 8
  %134 = call ptr @forge_rc_alloc(i64 32)
  %135 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %134, i64 32, ptr @.i2s_fmt.8, i64 %ife_val86)
  %widen87 = sext i32 %135 to i64
  %136 = call i64 @strlen(ptr @.str.7)
  %137 = call i64 @strlen(ptr %134)
  %concat_total88 = add i64 %136, %137
  %concat_size89 = add i64 %concat_total88, 1
  %138 = call ptr @forge_rc_alloc(i64 %concat_size89)
  %139 = call ptr @memcpy(ptr %138, ptr @.str.7, i64 %136)
  %cast90 = ptrtoint ptr %138 to i64
  %dst2_int91 = add i64 %cast90, %136
  %cast92 = inttoptr i64 %dst2_int91 to ptr
  %rhs_len_p193 = add i64 %137, 1
  %140 = call ptr @memcpy(ptr %cast92, ptr %134, i64 %rhs_len_p193)
  %141 = call i32 @puts(ptr %138)
  %widen94 = sext i32 %141 to i64
  %pgocount102 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 106), align 8
  %142 = add i64 %pgocount102, 1
  store i64 %142, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 106), align 8
  %pgocount103 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 107), align 8
  %143 = add i64 %pgocount103, 1
  store i64 %143, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 107), align 8
  store i1 false, ptr %use_todo, align 8
  %pgocount104 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 108), align 8
  %144 = add i64 %pgocount104, 1
  store i64 %144, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 108), align 8
  %pgocount105 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 109), align 8
  %145 = add i64 %pgocount105, 1
  store i64 %145, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 109), align 8
  %pgocount106 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 110), align 8
  %146 = add i64 %pgocount106, 1
  store i64 %146, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 110), align 8
  %use_todo95 = load i1, ptr %use_todo, align 8
  br i1 %use_todo95, label %if_then, label %if_else

ife_then82:                                       ; preds = %ife_end56
  %pgocount107 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 102), align 8
  %147 = add i64 %pgocount107, 1
  store i64 %147, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 102), align 8
  %pgocount108 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 103), align 8
  %148 = add i64 %pgocount108, 1
  store i64 %148, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 103), align 8
  %__a84 = load i64, ptr %__a72, align 8
  store i64 %__a84, ptr %ife_result79, align 8
  br label %ife_end80

ife_else83:                                       ; preds = %ife_end56
  %pgocount109 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 104), align 8
  %149 = add i64 %pgocount109, 1
  store i64 %149, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 104), align 8
  %pgocount110 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 105), align 8
  %150 = add i64 %pgocount110, 1
  store i64 %150, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 105), align 8
  %__b85 = load i64, ptr %__b74, align 8
  store i64 %__b85, ptr %ife_result79, align 8
  br label %ife_end80

ifcont:                                           ; preds = %if_else, %if_then
  %pgocount111 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 119), align 8
  %151 = add i64 %pgocount111, 1
  store i64 %151, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 119), align 8
  %pgocount112 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 120), align 8
  %152 = add i64 %pgocount112, 1
  store i64 %152, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 120), align 8
  %153 = call i32 @puts(ptr @.str.11)
  %widen108 = sext i32 %153 to i64
  %pgocount113 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 121), align 8
  %154 = add i64 %pgocount113, 1
  store i64 %154, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 121), align 8
  %pgocount114 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 122), align 8
  %155 = add i64 %pgocount114, 1
  store i64 %155, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 122), align 8
  store i64 42, ptr %x, align 8
  %pgocount115 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 123), align 8
  %156 = add i64 %pgocount115, 1
  store i64 %156, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 123), align 8
  %pgocount116 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 124), align 8
  %157 = add i64 %pgocount116, 1
  store i64 %157, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 124), align 8
  %pgocount117 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 125), align 8
  %158 = add i64 %pgocount117, 1
  store i64 %158, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 125), align 8
  %pgocount118 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 126), align 8
  %159 = add i64 %pgocount118, 1
  store i64 %159, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 126), align 8
  %x109 = load i64, ptr %x, align 8
  %pgocount119 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 127), align 8
  %160 = add i64 %pgocount119, 1
  store i64 %160, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 127), align 8
  %slt110 = icmp slt i64 %x109, 0
  %slt_ext111 = zext i1 %slt110 to i64
  %if_cond = icmp ne i64 %slt_ext111, 0
  br i1 %if_cond, label %if_then113, label %if_else114

if_then:                                          ; preds = %ife_end80
  %pgocount120 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 111), align 8
  %161 = add i64 %pgocount120, 1
  store i64 %161, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 111), align 8
  %pgocount121 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 112), align 8
  %162 = add i64 %pgocount121, 1
  store i64 %162, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 112), align 8
  %pgocount122 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 113), align 8
  %163 = add i64 %pgocount122, 1
  store i64 %163, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 113), align 8
  %pgocount123 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 114), align 8
  %164 = add i64 %pgocount123, 1
  store i64 %164, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 114), align 8
  %pgocount124 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 115), align 8
  %165 = add i64 %pgocount124, 1
  store i64 %165, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 115), align 8
  %pgocount125 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 116), align 8
  %166 = add i64 %pgocount125, 1
  store i64 %166, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 116), align 8
  %pgocount126 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 117), align 8
  %167 = add i64 %pgocount126, 1
  store i64 %167, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 117), align 8
  %168 = call i64 @strlen(ptr @.str.9)
  %169 = call i64 @strlen(ptr @.str.10)
  %concat_total96 = add i64 %168, %169
  %concat_size97 = add i64 %concat_total96, 1
  %170 = call ptr @forge_rc_alloc(i64 %concat_size97)
  %171 = call ptr @memcpy(ptr %170, ptr @.str.9, i64 %168)
  %cast98 = ptrtoint ptr %170 to i64
  %dst2_int99 = add i64 %cast98, %168
  %cast100 = inttoptr i64 %dst2_int99 to ptr
  %rhs_len_p1101 = add i64 %169, 1
  %172 = call ptr @memcpy(ptr %cast100, ptr @.str.10, i64 %rhs_len_p1101)
  %173 = call i64 @strlen(ptr @.panic_prefix)
  %174 = call i64 @strlen(ptr %170)
  %concat_total102 = add i64 %173, %174
  %concat_size103 = add i64 %concat_total102, 1
  %175 = call ptr @forge_rc_alloc(i64 %concat_size103)
  %176 = call ptr @memcpy(ptr %175, ptr @.panic_prefix, i64 %173)
  %cast104 = ptrtoint ptr %175 to i64
  %dst2_int105 = add i64 %cast104, %173
  %cast106 = inttoptr i64 %dst2_int105 to ptr
  %rhs_len_p1107 = add i64 %174, 1
  %177 = call ptr @memcpy(ptr %cast106, ptr %170, i64 %rhs_len_p1107)
  call void @forge_eprintln(ptr %175)
  call void @exit(i32 1)
  br label %ifcont

if_else:                                          ; preds = %ife_end80
  %pgocount127 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 118), align 8
  %178 = add i64 %pgocount127, 1
  store i64 %178, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 118), align 8
  br label %ifcont

ifcont112:                                        ; preds = %if_else114, %if_then113
  %pgocount128 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 136), align 8
  %179 = add i64 %pgocount128, 1
  store i64 %179, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 136), align 8
  %pgocount129 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 137), align 8
  %180 = add i64 %pgocount129, 1
  store i64 %180, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 137), align 8
  %181 = call i32 @puts(ptr @.str.15)
  %widen127 = sext i32 %181 to i64
  ret i64 0

if_then113:                                       ; preds = %ifcont
  %pgocount130 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 128), align 8
  %182 = add i64 %pgocount130, 1
  store i64 %182, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 128), align 8
  %pgocount131 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 129), align 8
  %183 = add i64 %pgocount131, 1
  store i64 %183, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 129), align 8
  %pgocount132 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 130), align 8
  %184 = add i64 %pgocount132, 1
  store i64 %184, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 130), align 8
  %pgocount133 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 131), align 8
  %185 = add i64 %pgocount133, 1
  store i64 %185, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 131), align 8
  %pgocount134 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 132), align 8
  %186 = add i64 %pgocount134, 1
  store i64 %186, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 132), align 8
  %pgocount135 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 133), align 8
  %187 = add i64 %pgocount135, 1
  store i64 %187, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 133), align 8
  %pgocount136 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 134), align 8
  %188 = add i64 %pgocount136, 1
  store i64 %188, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 134), align 8
  %189 = call i64 @strlen(ptr @.str.12)
  %190 = call i64 @strlen(ptr @.str.13)
  %concat_total115 = add i64 %189, %190
  %concat_size116 = add i64 %concat_total115, 1
  %191 = call ptr @forge_rc_alloc(i64 %concat_size116)
  %192 = call ptr @memcpy(ptr %191, ptr @.str.12, i64 %189)
  %cast117 = ptrtoint ptr %191 to i64
  %dst2_int118 = add i64 %cast117, %189
  %cast119 = inttoptr i64 %dst2_int118 to ptr
  %rhs_len_p1120 = add i64 %190, 1
  %193 = call ptr @memcpy(ptr %cast119, ptr @.str.13, i64 %rhs_len_p1120)
  %194 = call i64 @strlen(ptr @.panic_prefix.14)
  %195 = call i64 @strlen(ptr %191)
  %concat_total121 = add i64 %194, %195
  %concat_size122 = add i64 %concat_total121, 1
  %196 = call ptr @forge_rc_alloc(i64 %concat_size122)
  %197 = call ptr @memcpy(ptr %196, ptr @.panic_prefix.14, i64 %194)
  %cast123 = ptrtoint ptr %196 to i64
  %dst2_int124 = add i64 %cast123, %194
  %cast125 = inttoptr i64 %dst2_int124 to ptr
  %rhs_len_p1126 = add i64 %195, 1
  %198 = call ptr @memcpy(ptr %cast125, ptr %191, i64 %rhs_len_p1126)
  call void @forge_eprintln(ptr %196)
  call void @exit(i32 1)
  br label %ifcont112

if_else114:                                       ; preds = %ifcont
  %pgocount137 = load i64, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 135), align 8
  %199 = add i64 %pgocount137, 1
  store i64 %199, ptr getelementptr inbounds ([138 x i64], ptr @__profc_main, i32 0, i32 135), align 8
  br label %ifcont112
}

define i64 @__bs_top_level() {
entry:
  %0 = call i32 @forge_test_summary()
  %widen = sext i32 %0 to i64
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
