; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/desugar/tests/dbg.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

@.str = private unnamed_addr constant [7 x i8] c"[dbg] \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"result: \00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.3 = private unnamed_addr constant [7 x i8] c"[dbg] \00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.5 = private unnamed_addr constant [7 x i8] c"[dbg] \00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.7 = private unnamed_addr constant [10 x i8] c"chained: \00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_add = private global [5 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_add = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 2232412992676883508, i64 193486030, i64 sub (i64 ptrtoint (ptr @__profc_add to i64), i64 ptrtoint (ptr @__profd_add to i64)), i64 0, ptr null, ptr null, i32 5, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_main = private global [50 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 50, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__llvm_prf_nm = private constant [18 x i8] c"\08\10x\DAKLIa\CCM\CC\CC\03\00\0C@\02\D0", section "__DATA,__llvm_prf_names", align 1
@llvm.compiler.used = appending global [3 x ptr] [ptr @__llvm_profile_runtime_user, ptr @__profd_add, ptr @__profd_main], section "llvm.metadata"
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

define i64 @add(i64 %0, i64 %1) {
entry:
  %b = alloca i64, align 8
  %a = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_add, align 8
  %2 = add i64 %pgocount, 1
  store i64 %2, ptr @__profc_add, align 8
  store i64 %0, ptr %a, align 8
  store i64 %1, ptr %b, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([5 x i64], ptr @__profc_add, i32 0, i32 1), align 8
  %3 = add i64 %pgocount1, 1
  store i64 %3, ptr getelementptr inbounds ([5 x i64], ptr @__profc_add, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([5 x i64], ptr @__profc_add, i32 0, i32 2), align 8
  %4 = add i64 %pgocount2, 1
  store i64 %4, ptr getelementptr inbounds ([5 x i64], ptr @__profc_add, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([5 x i64], ptr @__profc_add, i32 0, i32 3), align 8
  %5 = add i64 %pgocount3, 1
  store i64 %5, ptr getelementptr inbounds ([5 x i64], ptr @__profc_add, i32 0, i32 3), align 8
  %a1 = load i64, ptr %a, align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([5 x i64], ptr @__profc_add, i32 0, i32 4), align 8
  %6 = add i64 %pgocount4, 1
  store i64 %6, ptr getelementptr inbounds ([5 x i64], ptr @__profc_add, i32 0, i32 4), align 8
  %b2 = load i64, ptr %b, align 8
  %add = add i64 %a1, %b2
  ret i64 %add
}

define i64 @main() {
entry:
  %y = alloca i64, align 8
  %__dbg27 = alloca i64, align 8
  %__dbg15 = alloca i64, align 8
  %x = alloca i64, align 8
  %__dbg = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_main, align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr @__profc_main, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %3 = add i64 %pgocount3, 1
  store i64 %3, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %4 = add i64 %pgocount4, 1
  store i64 %4, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %5 = add i64 %pgocount5, 1
  store i64 %5, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %6 = add i64 %pgocount6, 1
  store i64 %6, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %7 = call i64 @add(i64 2, i64 3)
  store i64 %7, ptr %__dbg, align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %8 = add i64 %pgocount7, 1
  store i64 %8, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %9 = add i64 %pgocount8, 1
  store i64 %9, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %10 = add i64 %pgocount9, 1
  store i64 %10, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %11 = add i64 %pgocount10, 1
  store i64 %11, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %12 = add i64 %pgocount11, 1
  store i64 %12, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %13 = add i64 %pgocount12, 1
  store i64 %13, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %__dbg1 = load i64, ptr %__dbg, align 8
  %14 = call ptr @forge_rc_alloc(i64 32)
  %15 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %14, i64 32, ptr @.i2s_fmt, i64 %__dbg1)
  %widen = sext i32 %15 to i64
  %16 = call i64 @strlen(ptr @.str)
  %17 = call i64 @strlen(ptr %14)
  %concat_total = add i64 %16, %17
  %concat_size = add i64 %concat_total, 1
  %18 = call ptr @forge_rc_alloc(i64 %concat_size)
  %19 = call ptr @memcpy(ptr %18, ptr @.str, i64 %16)
  %cast = ptrtoint ptr %18 to i64
  %dst2_int = add i64 %cast, %16
  %cast2 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %17, 1
  %20 = call ptr @memcpy(ptr %cast2, ptr %14, i64 %rhs_len_p1)
  %21 = call i32 @puts(ptr %18)
  %widen3 = sext i32 %21 to i64
  %pgocount13 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %22 = add i64 %pgocount13, 1
  store i64 %22, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %__dbg4 = load i64, ptr %__dbg, align 8
  store i64 %__dbg4, ptr %x, align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %23 = add i64 %pgocount14, 1
  store i64 %23, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %24 = add i64 %pgocount15, 1
  store i64 %24, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %pgocount16 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %25 = add i64 %pgocount16, 1
  store i64 %25, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %pgocount17 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %26 = add i64 %pgocount17, 1
  store i64 %26, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %27 = add i64 %pgocount18, 1
  store i64 %27, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %28 = add i64 %pgocount19, 1
  store i64 %28, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %29 = add i64 %pgocount20, 1
  store i64 %29, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %x5 = load i64, ptr %x, align 8
  %30 = call ptr @forge_rc_alloc(i64 32)
  %31 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %30, i64 32, ptr @.i2s_fmt.2, i64 %x5)
  %widen6 = sext i32 %31 to i64
  %32 = call i64 @strlen(ptr @.str.1)
  %33 = call i64 @strlen(ptr %30)
  %concat_total7 = add i64 %32, %33
  %concat_size8 = add i64 %concat_total7, 1
  %34 = call ptr @forge_rc_alloc(i64 %concat_size8)
  %35 = call ptr @memcpy(ptr %34, ptr @.str.1, i64 %32)
  %cast9 = ptrtoint ptr %34 to i64
  %dst2_int10 = add i64 %cast9, %32
  %cast11 = inttoptr i64 %dst2_int10 to ptr
  %rhs_len_p112 = add i64 %33, 1
  %36 = call ptr @memcpy(ptr %cast11, ptr %30, i64 %rhs_len_p112)
  %37 = call i32 @puts(ptr %34)
  %widen13 = sext i32 %37 to i64
  %pgocount21 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %38 = add i64 %pgocount21, 1
  store i64 %38, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %pgocount22 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %39 = add i64 %pgocount22, 1
  store i64 %39, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %pgocount23 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %40 = add i64 %pgocount23, 1
  store i64 %40, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %pgocount24 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %41 = add i64 %pgocount24, 1
  store i64 %41, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %pgocount25 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %42 = add i64 %pgocount25, 1
  store i64 %42, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %x14 = load i64, ptr %x, align 8
  store i64 %x14, ptr %__dbg15, align 8
  %pgocount26 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %43 = add i64 %pgocount26, 1
  store i64 %43, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %pgocount27 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %44 = add i64 %pgocount27, 1
  store i64 %44, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %pgocount28 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %45 = add i64 %pgocount28, 1
  store i64 %45, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %pgocount29 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %46 = add i64 %pgocount29, 1
  store i64 %46, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %pgocount30 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %47 = add i64 %pgocount30, 1
  store i64 %47, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %pgocount31 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %48 = add i64 %pgocount31, 1
  store i64 %48, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %__dbg16 = load i64, ptr %__dbg15, align 8
  %49 = call ptr @forge_rc_alloc(i64 32)
  %50 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %49, i64 32, ptr @.i2s_fmt.4, i64 %__dbg16)
  %widen17 = sext i32 %50 to i64
  %51 = call i64 @strlen(ptr @.str.3)
  %52 = call i64 @strlen(ptr %49)
  %concat_total18 = add i64 %51, %52
  %concat_size19 = add i64 %concat_total18, 1
  %53 = call ptr @forge_rc_alloc(i64 %concat_size19)
  %54 = call ptr @memcpy(ptr %53, ptr @.str.3, i64 %51)
  %cast20 = ptrtoint ptr %53 to i64
  %dst2_int21 = add i64 %cast20, %51
  %cast22 = inttoptr i64 %dst2_int21 to ptr
  %rhs_len_p123 = add i64 %52, 1
  %55 = call ptr @memcpy(ptr %cast22, ptr %49, i64 %rhs_len_p123)
  %56 = call i32 @puts(ptr %53)
  %widen24 = sext i32 %56 to i64
  %pgocount32 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %57 = add i64 %pgocount32, 1
  store i64 %57, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %__dbg25 = load i64, ptr %__dbg15, align 8
  %pgocount33 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %58 = add i64 %pgocount33, 1
  store i64 %58, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %pgocount34 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %59 = add i64 %pgocount34, 1
  store i64 %59, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %pgocount35 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %60 = add i64 %pgocount35, 1
  store i64 %60, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %x26 = load i64, ptr %x, align 8
  store i64 %x26, ptr %__dbg27, align 8
  %pgocount36 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %61 = add i64 %pgocount36, 1
  store i64 %61, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %pgocount37 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %62 = add i64 %pgocount37, 1
  store i64 %62, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %pgocount38 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %63 = add i64 %pgocount38, 1
  store i64 %63, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %pgocount39 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %64 = add i64 %pgocount39, 1
  store i64 %64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %pgocount40 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %65 = add i64 %pgocount40, 1
  store i64 %65, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %pgocount41 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %66 = add i64 %pgocount41, 1
  store i64 %66, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %__dbg28 = load i64, ptr %__dbg27, align 8
  %67 = call ptr @forge_rc_alloc(i64 32)
  %68 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %67, i64 32, ptr @.i2s_fmt.6, i64 %__dbg28)
  %widen29 = sext i32 %68 to i64
  %69 = call i64 @strlen(ptr @.str.5)
  %70 = call i64 @strlen(ptr %67)
  %concat_total30 = add i64 %69, %70
  %concat_size31 = add i64 %concat_total30, 1
  %71 = call ptr @forge_rc_alloc(i64 %concat_size31)
  %72 = call ptr @memcpy(ptr %71, ptr @.str.5, i64 %69)
  %cast32 = ptrtoint ptr %71 to i64
  %dst2_int33 = add i64 %cast32, %69
  %cast34 = inttoptr i64 %dst2_int33 to ptr
  %rhs_len_p135 = add i64 %70, 1
  %73 = call ptr @memcpy(ptr %cast34, ptr %67, i64 %rhs_len_p135)
  %74 = call i32 @puts(ptr %71)
  %widen36 = sext i32 %74 to i64
  %pgocount42 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %75 = add i64 %pgocount42, 1
  store i64 %75, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %__dbg37 = load i64, ptr %__dbg27, align 8
  %add = add i64 %__dbg25, %__dbg37
  store i64 %add, ptr %y, align 8
  %pgocount43 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %76 = add i64 %pgocount43, 1
  store i64 %76, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %pgocount44 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %77 = add i64 %pgocount44, 1
  store i64 %77, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %pgocount45 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %78 = add i64 %pgocount45, 1
  store i64 %78, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %pgocount46 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %79 = add i64 %pgocount46, 1
  store i64 %79, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %pgocount47 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %80 = add i64 %pgocount47, 1
  store i64 %80, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %pgocount48 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %81 = add i64 %pgocount48, 1
  store i64 %81, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %pgocount49 = load i64, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %82 = add i64 %pgocount49, 1
  store i64 %82, ptr getelementptr inbounds ([50 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %y38 = load i64, ptr %y, align 8
  %83 = call ptr @forge_rc_alloc(i64 32)
  %84 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %83, i64 32, ptr @.i2s_fmt.8, i64 %y38)
  %widen39 = sext i32 %84 to i64
  %85 = call i64 @strlen(ptr @.str.7)
  %86 = call i64 @strlen(ptr %83)
  %concat_total40 = add i64 %85, %86
  %concat_size41 = add i64 %concat_total40, 1
  %87 = call ptr @forge_rc_alloc(i64 %concat_size41)
  %88 = call ptr @memcpy(ptr %87, ptr @.str.7, i64 %85)
  %cast42 = ptrtoint ptr %87 to i64
  %dst2_int43 = add i64 %cast42, %85
  %cast44 = inttoptr i64 %dst2_int43 to ptr
  %rhs_len_p145 = add i64 %86, 1
  %89 = call ptr @memcpy(ptr %cast44, ptr %83, i64 %rhs_len_p145)
  %90 = call i32 @puts(ptr %87)
  %widen46 = sext i32 %90 to i64
  ret i64 0
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
