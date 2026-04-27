; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/closures/tests/lambda_basic.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

@double = global i64 0
@add = global i64 0
@nums = global i64 0
@doubled = global i64 0
@big = global i64 0
@sum = global i64 0
@greet = global i64 0
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_main = private global [6 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 6, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___lambda_0 = private global [4 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___lambda_0 = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -204181057533209874, i64 8245973951994833619, i64 sub (i64 ptrtoint (ptr @__profc___lambda_0 to i64), i64 ptrtoint (ptr @__profd___lambda_0 to i64)), i64 0, ptr null, ptr null, i32 4, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___lambda_1 = private global [4 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___lambda_1 = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 6925786121186820513, i64 8245973951994833620, i64 sub (i64 ptrtoint (ptr @__profc___lambda_1 to i64), i64 ptrtoint (ptr @__profd___lambda_1 to i64)), i64 0, ptr null, ptr null, i32 4, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___lambda_2 = private global [4 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___lambda_2 = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 6511828798704078813, i64 8245973951994833621, i64 sub (i64 ptrtoint (ptr @__profc___lambda_2 to i64), i64 ptrtoint (ptr @__profd___lambda_2 to i64)), i64 0, ptr null, ptr null, i32 4, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___lambda_3 = private global [4 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___lambda_3 = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 2645571496225459039, i64 8245973951994833622, i64 sub (i64 ptrtoint (ptr @__profc___lambda_3 to i64), i64 ptrtoint (ptr @__profd___lambda_3 to i64)), i64 0, ptr null, ptr null, i32 4, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___lambda_4 = private global [4 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___lambda_4 = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 4544136157594864824, i64 8245973951994833623, i64 sub (i64 ptrtoint (ptr @__profc___lambda_4 to i64), i64 ptrtoint (ptr @__profd___lambda_4 to i64)), i64 0, ptr null, ptr null, i32 4, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___lambda_5 = private global [2 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___lambda_5 = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 7378821250420521822, i64 8245973951994833624, i64 sub (i64 ptrtoint (ptr @__profc___lambda_5 to i64), i64 ptrtoint (ptr @__profd___lambda_5 to i64)), i64 0, ptr null, ptr null, i32 2, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__llvm_prf_nm = private constant [38 x i8] c"F$x\DA\CBM\CC\CCc\8C\8F\CFI\CCMJI\8C7@0\0D\11L#\04\D3\18\C14A0M\01Q\1A\17\CF", section "__DATA,__llvm_prf_names", align 1
@llvm.compiler.used = appending global [8 x ptr] [ptr @__llvm_profile_runtime_user, ptr @__profd_main, ptr @__profd___lambda_0, ptr @__profd___lambda_1, ptr @__profd___lambda_2, ptr @__profd___lambda_3, ptr @__profd___lambda_4, ptr @__profd___lambda_5], section "llvm.metadata"
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
  %1 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %1, i64 -559038737)
  call void @forge_array_push(ptr %1, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast = ptrtoint ptr %1 to i64
  store i64 %cast, ptr @double, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %double = load i64, ptr @double, align 8
  %cast1 = inttoptr i64 %double to ptr
  %6 = call i64 @forge_array_get(ptr %cast1, i64 1)
  %fn_ptr = inttoptr i64 %6 to ptr
  %pgocount5 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %7 = add i64 %pgocount5, 1
  store i64 %7, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %closure_call = call i64 %fn_ptr(i64 5)
  %8 = call ptr @forge_rc_alloc(i64 32)
  %9 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %8, i64 32, ptr @.i2s_fmt, i64 %closure_call)
  %widen = sext i32 %9 to i64
  %10 = call i32 @puts(ptr %8)
  %widen2 = sext i32 %10 to i64
  %pgocount6 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %11 = add i64 %pgocount6, 1
  store i64 %11, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %12 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %12, i64 -559038737)
  call void @forge_array_push(ptr %12, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cast3 = ptrtoint ptr %12 to i64
  store i64 %cast3, ptr @add, align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %13 = add i64 %pgocount7, 1
  store i64 %13, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %14 = add i64 %pgocount8, 1
  store i64 %14, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %15 = add i64 %pgocount9, 1
  store i64 %15, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %16 = add i64 %pgocount10, 1
  store i64 %16, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %add = load i64, ptr @add, align 8
  %cast4 = inttoptr i64 %add to ptr
  %17 = call i64 @forge_array_get(ptr %cast4, i64 1)
  %fn_ptr5 = inttoptr i64 %17 to ptr
  %pgocount11 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %18 = add i64 %pgocount11, 1
  store i64 %18, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %19 = add i64 %pgocount12, 1
  store i64 %19, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %closure_call6 = call i64 %fn_ptr5(i64 3, i64 4)
  %20 = call ptr @forge_rc_alloc(i64 32)
  %21 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %20, i64 32, ptr @.i2s_fmt.1, i64 %closure_call6)
  %widen7 = sext i32 %21 to i64
  %22 = call i32 @puts(ptr %20)
  %widen8 = sext i32 %22 to i64
  %pgocount13 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %23 = add i64 %pgocount13, 1
  store i64 %23, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %24 = call ptr @forge_array_new()
  %pgocount14 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %25 = add i64 %pgocount14, 1
  store i64 %25, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  call void @forge_array_push(ptr %24, i64 1)
  %pgocount15 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %26 = add i64 %pgocount15, 1
  store i64 %26, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  call void @forge_array_push(ptr %24, i64 2)
  %pgocount16 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %27 = add i64 %pgocount16, 1
  store i64 %27, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  call void @forge_array_push(ptr %24, i64 3)
  %pgocount17 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %28 = add i64 %pgocount17, 1
  store i64 %28, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  call void @forge_array_push(ptr %24, i64 4)
  %pgocount18 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %29 = add i64 %pgocount18, 1
  store i64 %29, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  call void @forge_array_push(ptr %24, i64 5)
  store ptr %24, ptr @nums, align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %30 = add i64 %pgocount19, 1
  store i64 %30, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %31 = add i64 %pgocount20, 1
  store i64 %31, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %nums = load ptr, ptr @nums, align 8
  %32 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %32, i64 -559038737)
  call void @forge_array_push(ptr %32, i64 ptrtoint (ptr @__lambda_2 to i64))
  %cast9 = ptrtoint ptr %32 to i64
  %33 = call ptr @forge_array_map(ptr %nums, i64 %cast9)
  store ptr %33, ptr @doubled, align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %34 = add i64 %pgocount21, 1
  store i64 %34, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %pgocount22 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %35 = add i64 %pgocount22, 1
  store i64 %35, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount23 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %36 = add i64 %pgocount23, 1
  store i64 %36, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %pgocount24 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %37 = add i64 %pgocount24, 1
  store i64 %37, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pgocount25 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %38 = add i64 %pgocount25, 1
  store i64 %38, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %doubled = load ptr, ptr @doubled, align 8
  %pgocount26 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %39 = add i64 %pgocount26, 1
  store i64 %39, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %40 = call i64 @forge_array_get(ptr %doubled, i64 0)
  %41 = call ptr @forge_rc_alloc(i64 32)
  %42 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %41, i64 32, ptr @.i2s_fmt.2, i64 %40)
  %widen10 = sext i32 %42 to i64
  %43 = call i32 @puts(ptr %41)
  %widen11 = sext i32 %43 to i64
  %pgocount27 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %44 = add i64 %pgocount27, 1
  store i64 %44, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %pgocount28 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %45 = add i64 %pgocount28, 1
  store i64 %45, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %pgocount29 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %46 = add i64 %pgocount29, 1
  store i64 %46, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %pgocount30 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %47 = add i64 %pgocount30, 1
  store i64 %47, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %pgocount31 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %48 = add i64 %pgocount31, 1
  store i64 %48, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %doubled12 = load ptr, ptr @doubled, align 8
  %pgocount32 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %49 = add i64 %pgocount32, 1
  store i64 %49, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %50 = call i64 @forge_array_get(ptr %doubled12, i64 4)
  %51 = call ptr @forge_rc_alloc(i64 32)
  %52 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %51, i64 32, ptr @.i2s_fmt.3, i64 %50)
  %widen13 = sext i32 %52 to i64
  %53 = call i32 @puts(ptr %51)
  %widen14 = sext i32 %53 to i64
  %pgocount33 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %54 = add i64 %pgocount33, 1
  store i64 %54, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %pgocount34 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %55 = add i64 %pgocount34, 1
  store i64 %55, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %nums15 = load ptr, ptr @nums, align 8
  %56 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %56, i64 -559038737)
  call void @forge_array_push(ptr %56, i64 ptrtoint (ptr @__lambda_3 to i64))
  %cast16 = ptrtoint ptr %56 to i64
  %57 = call ptr @forge_array_filter(ptr %nums15, i64 %cast16)
  store ptr %57, ptr @big, align 8
  %pgocount35 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %58 = add i64 %pgocount35, 1
  store i64 %58, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %pgocount36 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %59 = add i64 %pgocount36, 1
  store i64 %59, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount37 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %60 = add i64 %pgocount37, 1
  store i64 %60, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %pgocount38 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %61 = add i64 %pgocount38, 1
  store i64 %61, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pgocount39 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %62 = add i64 %pgocount39, 1
  store i64 %62, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %big = load ptr, ptr @big, align 8
  %63 = call i64 @forge_array_len(ptr %big)
  %64 = call ptr @forge_rc_alloc(i64 32)
  %65 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %64, i64 32, ptr @.i2s_fmt.4, i64 %63)
  %widen17 = sext i32 %65 to i64
  %66 = call i32 @puts(ptr %64)
  %widen18 = sext i32 %66 to i64
  %pgocount40 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %67 = add i64 %pgocount40, 1
  store i64 %67, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %pgocount41 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %68 = add i64 %pgocount41, 1
  store i64 %68, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %pgocount42 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %69 = add i64 %pgocount42, 1
  store i64 %69, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %pgocount43 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %70 = add i64 %pgocount43, 1
  store i64 %70, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %pgocount44 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %71 = add i64 %pgocount44, 1
  store i64 %71, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %big19 = load ptr, ptr @big, align 8
  %pgocount45 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %72 = add i64 %pgocount45, 1
  store i64 %72, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %73 = call i64 @forge_array_get(ptr %big19, i64 0)
  %74 = call ptr @forge_rc_alloc(i64 32)
  %75 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %74, i64 32, ptr @.i2s_fmt.5, i64 %73)
  %widen20 = sext i32 %75 to i64
  %76 = call i32 @puts(ptr %74)
  %widen21 = sext i32 %76 to i64
  %pgocount46 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %77 = add i64 %pgocount46, 1
  store i64 %77, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %pgocount47 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %78 = add i64 %pgocount47, 1
  store i64 %78, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %nums22 = load ptr, ptr @nums, align 8
  %pgocount48 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %79 = add i64 %pgocount48, 1
  store i64 %79, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %80 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %80, i64 -559038737)
  call void @forge_array_push(ptr %80, i64 ptrtoint (ptr @__lambda_4 to i64))
  %cast23 = ptrtoint ptr %80 to i64
  %81 = call i64 @forge_array_reduce(ptr %nums22, i64 0, i64 %cast23)
  store i64 %81, ptr @sum, align 8
  %pgocount49 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %82 = add i64 %pgocount49, 1
  store i64 %82, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %pgocount50 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %83 = add i64 %pgocount50, 1
  store i64 %83, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount51 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %84 = add i64 %pgocount51, 1
  store i64 %84, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %pgocount52 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %85 = add i64 %pgocount52, 1
  store i64 %85, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %sum = load i64, ptr @sum, align 8
  %86 = call ptr @forge_rc_alloc(i64 32)
  %87 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %86, i64 32, ptr @.i2s_fmt.6, i64 %sum)
  %widen24 = sext i32 %87 to i64
  %88 = call i32 @puts(ptr %86)
  %widen25 = sext i32 %88 to i64
  %pgocount53 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %89 = add i64 %pgocount53, 1
  store i64 %89, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %90 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %90, i64 -559038737)
  call void @forge_array_push(ptr %90, i64 ptrtoint (ptr @__lambda_5 to i64))
  %cast26 = ptrtoint ptr %90 to i64
  store i64 %cast26, ptr @greet, align 8
  %pgocount54 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %91 = add i64 %pgocount54, 1
  store i64 %91, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %pgocount55 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %92 = add i64 %pgocount55, 1
  store i64 %92, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %pgocount56 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %93 = add i64 %pgocount56, 1
  store i64 %93, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %pgocount57 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %94 = add i64 %pgocount57, 1
  store i64 %94, ptr getelementptr inbounds ([6 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %greet = load i64, ptr @greet, align 8
  %cast27 = inttoptr i64 %greet to ptr
  %95 = call i64 @forge_array_get(ptr %cast27, i64 1)
  %fn_ptr28 = inttoptr i64 %95 to ptr
  %closure_call29 = call i64 %fn_ptr28()
  %96 = call ptr @forge_rc_alloc(i64 32)
  %97 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %96, i64 32, ptr @.i2s_fmt.7, i64 %closure_call29)
  %widen30 = sext i32 %97 to i64
  %98 = call i32 @puts(ptr %96)
  %widen31 = sext i32 %98 to i64
  %99 = call i32 @forge_test_summary()
  %widen32 = sext i32 %99 to i64
  call void @forge_rc_collect()
  ret i64 0
}

define i64 @__lambda_0(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %pgocount = load i64, ptr @__profc___lambda_0, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc___lambda_0, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_0, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_0, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_0, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_0, i32 0, i32 2), align 8
  %x1 = load i64, ptr %x, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_0, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_0, i32 0, i32 3), align 8
  %mul = mul i64 %x1, 2
  ret i64 %mul
}

define i64 @__lambda_1(i64 %0, i64 %1) {
entry:
  %b = alloca i64, align 8
  %a = alloca i64, align 8
  store i64 %0, ptr %a, align 8
  store i64 %1, ptr %b, align 8
  %pgocount = load i64, ptr @__profc___lambda_1, align 8
  %2 = add i64 %pgocount, 1
  store i64 %2, ptr @__profc___lambda_1, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_1, i32 0, i32 1), align 8
  %3 = add i64 %pgocount1, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_1, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_1, i32 0, i32 2), align 8
  %4 = add i64 %pgocount2, 1
  store i64 %4, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_1, i32 0, i32 2), align 8
  %a1 = load i64, ptr %a, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_1, i32 0, i32 3), align 8
  %5 = add i64 %pgocount3, 1
  store i64 %5, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_1, i32 0, i32 3), align 8
  %b2 = load i64, ptr %b, align 8
  %add = add i64 %a1, %b2
  ret i64 %add
}

define i64 @__lambda_2(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %pgocount = load i64, ptr @__profc___lambda_2, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc___lambda_2, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_2, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_2, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_2, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_2, i32 0, i32 2), align 8
  %x1 = load i64, ptr %x, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_2, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_2, i32 0, i32 3), align 8
  %mul = mul i64 %x1, 2
  ret i64 %mul
}

define i64 @__lambda_3(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %pgocount = load i64, ptr @__profc___lambda_3, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc___lambda_3, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_3, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_3, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_3, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_3, i32 0, i32 2), align 8
  %x1 = load i64, ptr %x, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_3, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_3, i32 0, i32 3), align 8
  %sgt = icmp sgt i64 %x1, 3
  %sgt_ext = zext i1 %sgt to i64
  ret i64 %sgt_ext
}

define i64 @__lambda_4(i64 %0, i64 %1) {
entry:
  %x = alloca i64, align 8
  %acc = alloca i64, align 8
  store i64 %0, ptr %acc, align 8
  store i64 %1, ptr %x, align 8
  %pgocount = load i64, ptr @__profc___lambda_4, align 8
  %2 = add i64 %pgocount, 1
  store i64 %2, ptr @__profc___lambda_4, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_4, i32 0, i32 1), align 8
  %3 = add i64 %pgocount1, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_4, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_4, i32 0, i32 2), align 8
  %4 = add i64 %pgocount2, 1
  store i64 %4, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_4, i32 0, i32 2), align 8
  %acc1 = load i64, ptr %acc, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_4, i32 0, i32 3), align 8
  %5 = add i64 %pgocount3, 1
  store i64 %5, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_4, i32 0, i32 3), align 8
  %x2 = load i64, ptr %x, align 8
  %add = add i64 %acc1, %x2
  ret i64 %add
}

define i64 @__lambda_5() {
entry:
  %pgocount = load i64, ptr @__profc___lambda_5, align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr @__profc___lambda_5, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([2 x i64], ptr @__profc___lambda_5, i32 0, i32 1), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([2 x i64], ptr @__profc___lambda_5, i32 0, i32 1), align 8
  ret i64 42
}

; Function Attrs: noinline
define linkonce_odr hidden i32 @__llvm_profile_runtime_user() #1 {
  %1 = load i32, ptr @__llvm_profile_runtime, align 4
  ret i32 %1
}

attributes #0 = { nounwind }
attributes #1 = { noinline }
