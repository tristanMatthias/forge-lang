; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/float_lit/example.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

@.float_str = private unnamed_addr constant [5 x i8] c"3.14\00", align 1
@.float_str.1 = private unnamed_addr constant [6 x i8] c"2.718\00", align 1
@.float_str.2 = private unnamed_addr constant [4 x i8] c"0.5\00", align 1
@.str = private unnamed_addr constant [5 x i8] c"9.81\00", align 1
@.float_str.3 = private unnamed_addr constant [4 x i8] c"3.0\00", align 1
@.float_str.4 = private unnamed_addr constant [4 x i8] c"2.0\00", align 1
@.float_str.5 = private unnamed_addr constant [4 x i8] c"3.0\00", align 1
@.float_str.6 = private unnamed_addr constant [4 x i8] c"2.0\00", align 1
@.float_str.7 = private unnamed_addr constant [5 x i8] c"10.0\00", align 1
@.float_str.8 = private unnamed_addr constant [4 x i8] c"4.0\00", align 1
@.float_str.9 = private unnamed_addr constant [5 x i8] c"10.0\00", align 1
@.float_str.10 = private unnamed_addr constant [4 x i8] c"3.5\00", align 1
@.float_str.11 = private unnamed_addr constant [4 x i8] c"1.5\00", align 1
@.float_str.12 = private unnamed_addr constant [5 x i8] c"3.14\00", align 1
@.float_str.13 = private unnamed_addr constant [4 x i8] c"2.0\00", align 1
@.str.14 = private unnamed_addr constant [3 x i8] c"gt\00", align 1
@.float_str.15 = private unnamed_addr constant [4 x i8] c"1.0\00", align 1
@.float_str.16 = private unnamed_addr constant [4 x i8] c"2.0\00", align 1
@.str.17 = private unnamed_addr constant [3 x i8] c"lt\00", align 1
@.float_str.18 = private unnamed_addr constant [4 x i8] c"3.0\00", align 1
@.float_str.19 = private unnamed_addr constant [4 x i8] c"3.0\00", align 1
@.str.20 = private unnamed_addr constant [3 x i8] c"eq\00", align 1
@.float_str.21 = private unnamed_addr constant [5 x i8] c"3.14\00", align 1
@.flit_str = private unnamed_addr constant [4 x i8] c"1.0\00", align 1
@.str.22 = private unnamed_addr constant [4 x i8] c"one\00", align 1
@.flit_str.23 = private unnamed_addr constant [5 x i8] c"3.14\00", align 1
@.str.24 = private unnamed_addr constant [3 x i8] c"pi\00", align 1
@.str.25 = private unnamed_addr constant [6 x i8] c"other\00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [127 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/float_lit/example.fg\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_main = private global [101 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 101, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
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
  %pmatch_result = alloca i64, align 8
  %val = alloca double, align 8
  %sum = alloca double, align 8
  %b = alloca double, align 8
  %a = alloca double, align 8
  %z = alloca double, align 8
  %y = alloca double, align 8
  %x = alloca double, align 8
  %pgocount = load i64, ptr @__profc_main, align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr @__profc_main, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %3 = call i64 @forge_float_parse(ptr @.float_str)
  %cast = bitcast i64 %3 to double
  store double %cast, ptr %x, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %x1 = load double, ptr %x, align 8
  %cast2 = bitcast double %x1 to i64
  %8 = call i64 @forge_float_to_string(i64 %cast2)
  %cast3 = inttoptr i64 %8 to ptr
  %9 = call i32 @puts(ptr %cast3)
  %widen = sext i32 %9 to i64
  %pgocount7 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %10 = add i64 %pgocount7, 1
  store i64 %10, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %11 = add i64 %pgocount8, 1
  store i64 %11, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %12 = call i64 @forge_float_parse(ptr @.float_str.1)
  %cast4 = bitcast i64 %12 to double
  store double %cast4, ptr %y, align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %13 = add i64 %pgocount9, 1
  store i64 %13, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %14 = add i64 %pgocount10, 1
  store i64 %14, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %15 = add i64 %pgocount11, 1
  store i64 %15, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %16 = add i64 %pgocount12, 1
  store i64 %16, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %y5 = load double, ptr %y, align 8
  %cast6 = bitcast double %y5 to i64
  %17 = call i64 @forge_float_to_string(i64 %cast6)
  %cast7 = inttoptr i64 %17 to ptr
  %18 = call i32 @puts(ptr %cast7)
  %widen8 = sext i32 %18 to i64
  %pgocount13 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %19 = add i64 %pgocount13, 1
  store i64 %19, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %20 = add i64 %pgocount14, 1
  store i64 %20, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %21 = call i64 @forge_float_parse(ptr @.float_str.2)
  %cast9 = bitcast i64 %21 to double
  store double %cast9, ptr %z, align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %22 = add i64 %pgocount15, 1
  store i64 %22, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %pgocount16 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %23 = add i64 %pgocount16, 1
  store i64 %23, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %pgocount17 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %24 = add i64 %pgocount17, 1
  store i64 %24, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %25 = add i64 %pgocount18, 1
  store i64 %25, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %z10 = load double, ptr %z, align 8
  %cast11 = bitcast double %z10 to i64
  %26 = call i64 @forge_float_to_string(i64 %cast11)
  %cast12 = inttoptr i64 %26 to ptr
  %27 = call i32 @puts(ptr %cast12)
  %widen13 = sext i32 %27 to i64
  %pgocount19 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %28 = add i64 %pgocount19, 1
  store i64 %28, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %29 = add i64 %pgocount20, 1
  store i64 %29, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %30 = add i64 %pgocount21, 1
  store i64 %30, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %31 = call i64 @forge_float_parse(ptr @.str)
  %cast14 = bitcast i64 %31 to double
  store double %cast14, ptr %a, align 8
  %pgocount22 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %32 = add i64 %pgocount22, 1
  store i64 %32, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %pgocount23 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %33 = add i64 %pgocount23, 1
  store i64 %33, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %pgocount24 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %34 = add i64 %pgocount24, 1
  store i64 %34, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %pgocount25 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %35 = add i64 %pgocount25, 1
  store i64 %35, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %a15 = load double, ptr %a, align 8
  %cast16 = bitcast double %a15 to i64
  %36 = call i64 @forge_float_to_string(i64 %cast16)
  %cast17 = inttoptr i64 %36 to ptr
  %37 = call i32 @puts(ptr %cast17)
  %widen18 = sext i32 %37 to i64
  %pgocount26 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %38 = add i64 %pgocount26, 1
  store i64 %38, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %pgocount27 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %39 = add i64 %pgocount27, 1
  store i64 %39, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %pgocount28 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %40 = add i64 %pgocount28, 1
  store i64 %40, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  store double 1.000000e+02, ptr %b, align 8
  %pgocount29 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %41 = add i64 %pgocount29, 1
  store i64 %41, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %pgocount30 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %42 = add i64 %pgocount30, 1
  store i64 %42, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %pgocount31 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %43 = add i64 %pgocount31, 1
  store i64 %43, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %pgocount32 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %44 = add i64 %pgocount32, 1
  store i64 %44, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %b19 = load double, ptr %b, align 8
  %cast20 = bitcast double %b19 to i64
  %45 = call i64 @forge_float_to_string(i64 %cast20)
  %cast21 = inttoptr i64 %45 to ptr
  %46 = call i32 @puts(ptr %cast21)
  %widen22 = sext i32 %46 to i64
  %pgocount33 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %47 = add i64 %pgocount33, 1
  store i64 %47, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %pgocount34 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %48 = add i64 %pgocount34, 1
  store i64 %48, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %pgocount35 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %49 = add i64 %pgocount35, 1
  store i64 %49, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %50 = call i64 @forge_float_parse(ptr @.float_str.3)
  %cast23 = bitcast i64 %50 to double
  %pgocount36 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %51 = add i64 %pgocount36, 1
  store i64 %51, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %52 = call i64 @forge_float_parse(ptr @.float_str.4)
  %cast24 = bitcast i64 %52 to double
  %fadd = fadd double %cast23, %cast24
  store double %fadd, ptr %sum, align 8
  %pgocount37 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %53 = add i64 %pgocount37, 1
  store i64 %53, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %pgocount38 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %54 = add i64 %pgocount38, 1
  store i64 %54, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %pgocount39 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %55 = add i64 %pgocount39, 1
  store i64 %55, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %pgocount40 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %56 = add i64 %pgocount40, 1
  store i64 %56, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %sum25 = load double, ptr %sum, align 8
  %cast26 = bitcast double %sum25 to i64
  %57 = call i64 @forge_float_to_string(i64 %cast26)
  %cast27 = inttoptr i64 %57 to ptr
  %58 = call i32 @puts(ptr %cast27)
  %widen28 = sext i32 %58 to i64
  %pgocount41 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %59 = add i64 %pgocount41, 1
  store i64 %59, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %pgocount42 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %60 = add i64 %pgocount42, 1
  store i64 %60, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %pgocount43 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %61 = add i64 %pgocount43, 1
  store i64 %61, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %pgocount44 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %62 = add i64 %pgocount44, 1
  store i64 %62, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %pgocount45 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %63 = add i64 %pgocount45, 1
  store i64 %63, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %64 = call i64 @forge_float_parse(ptr @.float_str.5)
  %cast29 = bitcast i64 %64 to double
  %pgocount46 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %65 = add i64 %pgocount46, 1
  store i64 %65, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %66 = call i64 @forge_float_parse(ptr @.float_str.6)
  %cast30 = bitcast i64 %66 to double
  %fmul = fmul double %cast29, %cast30
  %cast31 = bitcast double %fmul to i64
  %67 = call i64 @forge_float_to_string(i64 %cast31)
  %cast32 = inttoptr i64 %67 to ptr
  %68 = call i32 @puts(ptr %cast32)
  %widen33 = sext i32 %68 to i64
  %pgocount47 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %69 = add i64 %pgocount47, 1
  store i64 %69, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %pgocount48 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %70 = add i64 %pgocount48, 1
  store i64 %70, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %pgocount49 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %71 = add i64 %pgocount49, 1
  store i64 %71, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %pgocount50 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %72 = add i64 %pgocount50, 1
  store i64 %72, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %pgocount51 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %73 = add i64 %pgocount51, 1
  store i64 %73, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %74 = call i64 @forge_float_parse(ptr @.float_str.7)
  %cast34 = bitcast i64 %74 to double
  %pgocount52 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 52), align 8
  %75 = add i64 %pgocount52, 1
  store i64 %75, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 52), align 8
  %76 = call i64 @forge_float_parse(ptr @.float_str.8)
  %cast35 = bitcast i64 %76 to double
  %fdiv = fdiv double %cast34, %cast35
  %cast36 = bitcast double %fdiv to i64
  %77 = call i64 @forge_float_to_string(i64 %cast36)
  %cast37 = inttoptr i64 %77 to ptr
  %78 = call i32 @puts(ptr %cast37)
  %widen38 = sext i32 %78 to i64
  %pgocount53 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 53), align 8
  %79 = add i64 %pgocount53, 1
  store i64 %79, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 53), align 8
  %pgocount54 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 54), align 8
  %80 = add i64 %pgocount54, 1
  store i64 %80, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 54), align 8
  %pgocount55 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 55), align 8
  %81 = add i64 %pgocount55, 1
  store i64 %81, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 55), align 8
  %pgocount56 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 56), align 8
  %82 = add i64 %pgocount56, 1
  store i64 %82, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 56), align 8
  %pgocount57 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 57), align 8
  %83 = add i64 %pgocount57, 1
  store i64 %83, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 57), align 8
  %84 = call i64 @forge_float_parse(ptr @.float_str.9)
  %cast39 = bitcast i64 %84 to double
  %pgocount58 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 58), align 8
  %85 = add i64 %pgocount58, 1
  store i64 %85, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 58), align 8
  %86 = call i64 @forge_float_parse(ptr @.float_str.10)
  %cast40 = bitcast i64 %86 to double
  %fsub = fsub double %cast39, %cast40
  %cast41 = bitcast double %fsub to i64
  %87 = call i64 @forge_float_to_string(i64 %cast41)
  %cast42 = inttoptr i64 %87 to ptr
  %88 = call i32 @puts(ptr %cast42)
  %widen43 = sext i32 %88 to i64
  %pgocount59 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 59), align 8
  %89 = add i64 %pgocount59, 1
  store i64 %89, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 59), align 8
  %pgocount60 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 60), align 8
  %90 = add i64 %pgocount60, 1
  store i64 %90, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 60), align 8
  %pgocount61 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 61), align 8
  %91 = add i64 %pgocount61, 1
  store i64 %91, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 61), align 8
  %pgocount62 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 62), align 8
  %92 = add i64 %pgocount62, 1
  store i64 %92, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 62), align 8
  %pgocount63 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 63), align 8
  %93 = add i64 %pgocount63, 1
  store i64 %93, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 63), align 8
  %94 = call i64 @forge_float_parse(ptr @.float_str.11)
  %cast44 = bitcast i64 %94 to double
  %fneg = fneg double %cast44
  %cast45 = bitcast double %fneg to i64
  %95 = call i64 @forge_float_to_string(i64 %cast45)
  %cast46 = inttoptr i64 %95 to ptr
  %96 = call i32 @puts(ptr %cast46)
  %widen47 = sext i32 %96 to i64
  %pgocount64 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 64), align 8
  %97 = add i64 %pgocount64, 1
  store i64 %97, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 64), align 8
  %pgocount65 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 65), align 8
  %98 = add i64 %pgocount65, 1
  store i64 %98, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 65), align 8
  %pgocount66 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 66), align 8
  %99 = add i64 %pgocount66, 1
  store i64 %99, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 66), align 8
  %pgocount67 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 67), align 8
  %100 = add i64 %pgocount67, 1
  store i64 %100, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 67), align 8
  %101 = call i64 @forge_float_parse(ptr @.float_str.12)
  %cast48 = bitcast i64 %101 to double
  %pgocount68 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 68), align 8
  %102 = add i64 %pgocount68, 1
  store i64 %102, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 68), align 8
  %103 = call i64 @forge_float_parse(ptr @.float_str.13)
  %cast49 = bitcast i64 %103 to double
  %fgt = fcmp ogt double %cast48, %cast49
  %fgt_ext = zext i1 %fgt to i64
  %if_cond = icmp ne i64 %fgt_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else, %if_then
  %pgocount69 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 74), align 8
  %104 = add i64 %pgocount69, 1
  store i64 %104, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 74), align 8
  %pgocount70 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 75), align 8
  %105 = add i64 %pgocount70, 1
  store i64 %105, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 75), align 8
  %pgocount71 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 76), align 8
  %106 = add i64 %pgocount71, 1
  store i64 %106, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 76), align 8
  %pgocount72 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 77), align 8
  %107 = add i64 %pgocount72, 1
  store i64 %107, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 77), align 8
  %108 = call i64 @forge_float_parse(ptr @.float_str.15)
  %cast51 = bitcast i64 %108 to double
  %pgocount73 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 78), align 8
  %109 = add i64 %pgocount73, 1
  store i64 %109, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 78), align 8
  %110 = call i64 @forge_float_parse(ptr @.float_str.16)
  %cast52 = bitcast i64 %110 to double
  %flt = fcmp olt double %cast51, %cast52
  %flt_ext = zext i1 %flt to i64
  %if_cond54 = icmp ne i64 %flt_ext, 0
  br i1 %if_cond54, label %if_then55, label %if_else56

if_then:                                          ; preds = %entry
  %pgocount74 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 69), align 8
  %111 = add i64 %pgocount74, 1
  store i64 %111, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 69), align 8
  %pgocount75 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 70), align 8
  %112 = add i64 %pgocount75, 1
  store i64 %112, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 70), align 8
  %pgocount76 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 71), align 8
  %113 = add i64 %pgocount76, 1
  store i64 %113, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 71), align 8
  %pgocount77 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 72), align 8
  %114 = add i64 %pgocount77, 1
  store i64 %114, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 72), align 8
  %115 = call i32 @puts(ptr @.str.14)
  %widen50 = sext i32 %115 to i64
  br label %ifcont

if_else:                                          ; preds = %entry
  %pgocount78 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 73), align 8
  %116 = add i64 %pgocount78, 1
  store i64 %116, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 73), align 8
  br label %ifcont

ifcont53:                                         ; preds = %if_else56, %if_then55
  %pgocount79 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 84), align 8
  %117 = add i64 %pgocount79, 1
  store i64 %117, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 84), align 8
  %pgocount80 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 85), align 8
  %118 = add i64 %pgocount80, 1
  store i64 %118, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 85), align 8
  %pgocount81 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 86), align 8
  %119 = add i64 %pgocount81, 1
  store i64 %119, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 86), align 8
  %pgocount82 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 87), align 8
  %120 = add i64 %pgocount82, 1
  store i64 %120, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 87), align 8
  %121 = call i64 @forge_float_parse(ptr @.float_str.18)
  %cast58 = bitcast i64 %121 to double
  %pgocount83 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 88), align 8
  %122 = add i64 %pgocount83, 1
  store i64 %122, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 88), align 8
  %123 = call i64 @forge_float_parse(ptr @.float_str.19)
  %cast59 = bitcast i64 %123 to double
  %feq = fcmp oeq double %cast58, %cast59
  %feq_ext = zext i1 %feq to i64
  %if_cond61 = icmp ne i64 %feq_ext, 0
  br i1 %if_cond61, label %if_then62, label %if_else63

if_then55:                                        ; preds = %ifcont
  %pgocount84 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 79), align 8
  %124 = add i64 %pgocount84, 1
  store i64 %124, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 79), align 8
  %pgocount85 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 80), align 8
  %125 = add i64 %pgocount85, 1
  store i64 %125, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 80), align 8
  %pgocount86 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 81), align 8
  %126 = add i64 %pgocount86, 1
  store i64 %126, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 81), align 8
  %pgocount87 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 82), align 8
  %127 = add i64 %pgocount87, 1
  store i64 %127, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 82), align 8
  %128 = call i32 @puts(ptr @.str.17)
  %widen57 = sext i32 %128 to i64
  br label %ifcont53

if_else56:                                        ; preds = %ifcont
  %pgocount88 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 83), align 8
  %129 = add i64 %pgocount88, 1
  store i64 %129, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 83), align 8
  br label %ifcont53

ifcont60:                                         ; preds = %if_else63, %if_then62
  %pgocount89 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 94), align 8
  %130 = add i64 %pgocount89, 1
  store i64 %130, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 94), align 8
  %pgocount90 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 95), align 8
  %131 = add i64 %pgocount90, 1
  store i64 %131, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 95), align 8
  %132 = call i64 @forge_float_parse(ptr @.float_str.21)
  %cast65 = bitcast i64 %132 to double
  store double %cast65, ptr %val, align 8
  %pgocount91 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 96), align 8
  %133 = add i64 %pgocount91, 1
  store i64 %133, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 96), align 8
  %pgocount92 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 97), align 8
  %134 = add i64 %pgocount92, 1
  store i64 %134, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 97), align 8
  %val66 = load double, ptr %val, align 8
  store i64 0, ptr %pmatch_result, align 8
  %135 = call i64 @forge_float_parse(ptr @.flit_str)
  %cast67 = bitcast i64 %135 to double
  %flit_eq = fcmp oeq double %val66, %cast67
  br i1 %flit_eq, label %parm_body, label %parm_next

if_then62:                                        ; preds = %ifcont53
  %pgocount93 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 89), align 8
  %136 = add i64 %pgocount93, 1
  store i64 %136, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 89), align 8
  %pgocount94 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 90), align 8
  %137 = add i64 %pgocount94, 1
  store i64 %137, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 90), align 8
  %pgocount95 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 91), align 8
  %138 = add i64 %pgocount95, 1
  store i64 %138, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 91), align 8
  %pgocount96 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 92), align 8
  %139 = add i64 %pgocount96, 1
  store i64 %139, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 92), align 8
  %140 = call i32 @puts(ptr @.str.20)
  %widen64 = sext i32 %140 to i64
  br label %ifcont60

if_else63:                                        ; preds = %ifcont53
  %pgocount97 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 93), align 8
  %141 = add i64 %pgocount97, 1
  store i64 %141, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 93), align 8
  br label %ifcont60

pmatch_end:                                       ; preds = %parm_body74, %parm_body69, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  ret i64 %pmatch_val

parm_body:                                        ; preds = %ifcont60
  %pgocount98 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 98), align 8
  %142 = add i64 %pgocount98, 1
  store i64 %142, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 98), align 8
  %143 = call i32 @puts(ptr @.str.22)
  %widen68 = sext i32 %143 to i64
  store i64 0, ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %ifcont60
  %144 = call i64 @forge_float_parse(ptr @.flit_str.23)
  %cast71 = bitcast i64 %144 to double
  %flit_eq72 = fcmp oeq double %val66, %cast71
  br i1 %flit_eq72, label %parm_body69, label %parm_next70

parm_body69:                                      ; preds = %parm_next
  %pgocount99 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 99), align 8
  %145 = add i64 %pgocount99, 1
  store i64 %145, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 99), align 8
  %146 = call i32 @puts(ptr @.str.24)
  %widen73 = sext i32 %146 to i64
  store i64 0, ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next70:                                      ; preds = %parm_next
  br label %parm_body74

parm_body74:                                      ; preds = %parm_next70
  %pgocount100 = load i64, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 100), align 8
  %147 = add i64 %pgocount100, 1
  store i64 %147, ptr getelementptr inbounds ([101 x i64], ptr @__profc_main, i32 0, i32 100), align 8
  %148 = call i32 @puts(ptr @.str.25)
  %widen76 = sext i32 %148 to i64
  store i64 0, ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next75:                                      ; No predecessors!
  call void @forge_match_unreachable(ptr @.match_fn, i64 -1, ptr @mu_file, i64 45)
  unreachable
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
