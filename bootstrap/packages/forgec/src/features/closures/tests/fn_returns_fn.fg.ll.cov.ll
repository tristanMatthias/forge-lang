; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/closures/tests/fn_returns_fn.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

@make = global ptr null
@add5 = global i64 0
@triple = global i64 0
@inc = global i64 0
@dbl = global i64 0
@pipeline = global i64 0
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_make_multiplier = private global [4 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_make_multiplier = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 2302480827387720469, i64 -5531391666249333431, i64 sub (i64 ptrtoint (ptr @__profc_make_multiplier to i64), i64 ptrtoint (ptr @__profd_make_multiplier to i64)), i64 0, ptr null, ptr null, i32 4, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_compose = private global [4 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_compose = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -6838486859405610221, i64 229462174431899, i64 sub (i64 ptrtoint (ptr @__profc_compose to i64), i64 ptrtoint (ptr @__profd_compose to i64)), i64 0, ptr null, ptr null, i32 4, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_main = private global [12 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 12, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
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
@__profc___lambda_5 = private global [4 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___lambda_5 = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 7378821250420521822, i64 8245973951994833624, i64 sub (i64 ptrtoint (ptr @__profc___lambda_5 to i64), i64 ptrtoint (ptr @__profd___lambda_5 to i64)), i64 0, ptr null, ptr null, i32 4, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__llvm_prf_nm = private constant [62 x i8] c"^<x\DA\CBM\CCN\8D\CF-\CD)\C9,\C8\C9L-bL\CE\CF-\C8/Ne\CCM\CC\CCc\8C\8F\CFI\CCMJI\8C7@0\0D\11L#\04\D3\18\C14A0M\01P\9C!\0B", section "__DATA,__llvm_prf_names", align 1
@llvm.compiler.used = appending global [10 x ptr] [ptr @__llvm_profile_runtime_user, ptr @__profd_make_multiplier, ptr @__profd_compose, ptr @__profd_main, ptr @__profd___lambda_0, ptr @__profd___lambda_1, ptr @__profd___lambda_2, ptr @__profd___lambda_3, ptr @__profd___lambda_4, ptr @__profd___lambda_5], section "llvm.metadata"
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

define ptr @make_multiplier(i64 %0) {
entry:
  %n = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_make_multiplier, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_make_multiplier, align 8
  store i64 %0, ptr %n, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_make_multiplier, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([4 x i64], ptr @__profc_make_multiplier, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_make_multiplier, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc_make_multiplier, i32 0, i32 2), align 8
  %4 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %4, i64 -559038737)
  call void @forge_array_push(ptr %4, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cap_val = load i64, ptr %n, align 8
  call void @forge_array_push(ptr %4, i64 %cap_val)
  %cast = ptrtoint ptr %4 to i64
  %cast1 = inttoptr i64 %cast to ptr
  ret ptr %cast1
}

define ptr @compose(ptr %0, ptr %1) {
entry:
  %g = alloca ptr, align 8
  %f = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_compose, align 8
  %2 = add i64 %pgocount, 1
  store i64 %2, ptr @__profc_compose, align 8
  store ptr %0, ptr %f, align 8
  store ptr %1, ptr %g, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_compose, i32 0, i32 1), align 8
  %3 = add i64 %pgocount1, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc_compose, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_compose, i32 0, i32 2), align 8
  %4 = add i64 %pgocount2, 1
  store i64 %4, ptr getelementptr inbounds ([4 x i64], ptr @__profc_compose, i32 0, i32 2), align 8
  %5 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %5, i64 -559038737)
  call void @forge_array_push(ptr %5, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cap_val = load i64, ptr %g, align 8
  call void @forge_array_push(ptr %5, i64 %cap_val)
  %cap_val1 = load i64, ptr %f, align 8
  call void @forge_array_push(ptr %5, i64 %cap_val1)
  %cast = ptrtoint ptr %5 to i64
  %cast2 = inttoptr i64 %cast to ptr
  ret ptr %cast2
}

define i64 @main() {
entry:
  %pgocount = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %1 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %1, i64 -559038737)
  call void @forge_array_push(ptr %1, i64 ptrtoint (ptr @__lambda_2 to i64))
  %cast = ptrtoint ptr %1 to i64
  store i64 %cast, ptr @make, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %make = load i64, ptr @make, align 8
  %cast1 = inttoptr i64 %make to ptr
  %3 = call i64 @forge_array_get(ptr %cast1, i64 1)
  %fn_ptr = inttoptr i64 %3 to ptr
  %pgocount2 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %4 = add i64 %pgocount2, 1
  store i64 %4, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %closure_call = call i64 %fn_ptr(i64 5)
  store i64 %closure_call, ptr @add5, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %5 = add i64 %pgocount3, 1
  store i64 %5, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %6 = add i64 %pgocount4, 1
  store i64 %6, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %7 = add i64 %pgocount5, 1
  store i64 %7, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %8 = add i64 %pgocount6, 1
  store i64 %8, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %add5 = load i64, ptr @add5, align 8
  %cast2 = inttoptr i64 %add5 to ptr
  %9 = call i64 @forge_array_get(ptr %cast2, i64 1)
  %fn_ptr3 = inttoptr i64 %9 to ptr
  %pgocount7 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %10 = add i64 %pgocount7, 1
  store i64 %10, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %11 = call i64 @forge_array_get(ptr %cast2, i64 2)
  %closure_call4 = call i64 %fn_ptr3(i64 10, i64 %11)
  %12 = call ptr @forge_rc_alloc(i64 32)
  %13 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %12, i64 32, ptr @.i2s_fmt, i64 %closure_call4)
  %widen = sext i32 %13 to i64
  %14 = call i32 @puts(ptr %12)
  %widen5 = sext i32 %14 to i64
  %pgocount8 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %15 = add i64 %pgocount8, 1
  store i64 %15, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %16 = add i64 %pgocount9, 1
  store i64 %16, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %17 = add i64 %pgocount10, 1
  store i64 %17, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %18 = add i64 %pgocount11, 1
  store i64 %18, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %add56 = load i64, ptr @add5, align 8
  %cast7 = inttoptr i64 %add56 to ptr
  %19 = call i64 @forge_array_get(ptr %cast7, i64 1)
  %fn_ptr8 = inttoptr i64 %19 to ptr
  %pgocount12 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %20 = add i64 %pgocount12, 1
  store i64 %20, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %21 = call i64 @forge_array_get(ptr %cast7, i64 2)
  %closure_call9 = call i64 %fn_ptr8(i64 20, i64 %21)
  %22 = call ptr @forge_rc_alloc(i64 32)
  %23 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %22, i64 32, ptr @.i2s_fmt.1, i64 %closure_call9)
  %widen10 = sext i32 %23 to i64
  %24 = call i32 @puts(ptr %22)
  %widen11 = sext i32 %24 to i64
  %pgocount13 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %25 = add i64 %pgocount13, 1
  store i64 %25, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %26 = add i64 %pgocount14, 1
  store i64 %26, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %27 = call ptr @make_multiplier(i64 3)
  store ptr %27, ptr @triple, align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %28 = add i64 %pgocount15, 1
  store i64 %28, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %pgocount16 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %29 = add i64 %pgocount16, 1
  store i64 %29, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %pgocount17 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %30 = add i64 %pgocount17, 1
  store i64 %30, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %31 = add i64 %pgocount18, 1
  store i64 %31, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %triple = load i64, ptr @triple, align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %32 = add i64 %pgocount19, 1
  store i64 %32, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %33 = call i64 @forge_closure_call_1(i64 %triple, i64 7)
  %34 = call ptr @forge_rc_alloc(i64 32)
  %35 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %34, i64 32, ptr @.i2s_fmt.2, i64 %33)
  %widen12 = sext i32 %35 to i64
  %36 = call i32 @puts(ptr %34)
  %widen13 = sext i32 %36 to i64
  %pgocount20 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %37 = add i64 %pgocount20, 1
  store i64 %37, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %38 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %38, i64 -559038737)
  call void @forge_array_push(ptr %38, i64 ptrtoint (ptr @__lambda_4 to i64))
  %cast14 = ptrtoint ptr %38 to i64
  store i64 %cast14, ptr @inc, align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %39 = add i64 %pgocount21, 1
  store i64 %39, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %40 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %40, i64 -559038737)
  call void @forge_array_push(ptr %40, i64 ptrtoint (ptr @__lambda_5 to i64))
  %cast15 = ptrtoint ptr %40 to i64
  store i64 %cast15, ptr @dbl, align 8
  %pgocount22 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %41 = add i64 %pgocount22, 1
  store i64 %41, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %pgocount23 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %42 = add i64 %pgocount23, 1
  store i64 %42, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %dbl = load ptr, ptr @dbl, align 8
  %pgocount24 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %43 = add i64 %pgocount24, 1
  store i64 %43, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %inc = load ptr, ptr @inc, align 8
  %44 = call ptr @compose(ptr %dbl, ptr %inc)
  store ptr %44, ptr @pipeline, align 8
  %pgocount25 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %45 = add i64 %pgocount25, 1
  store i64 %45, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pgocount26 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %46 = add i64 %pgocount26, 1
  store i64 %46, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %pgocount27 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %47 = add i64 %pgocount27, 1
  store i64 %47, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %pgocount28 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %48 = add i64 %pgocount28, 1
  store i64 %48, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %pipeline = load i64, ptr @pipeline, align 8
  %pgocount29 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %49 = add i64 %pgocount29, 1
  store i64 %49, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %50 = call i64 @forge_closure_call_1(i64 %pipeline, i64 5)
  %51 = call ptr @forge_rc_alloc(i64 32)
  %52 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %51, i64 32, ptr @.i2s_fmt.3, i64 %50)
  %widen16 = sext i32 %52 to i64
  %53 = call i32 @puts(ptr %51)
  %widen17 = sext i32 %53 to i64
  %54 = call i32 @forge_test_summary()
  %widen18 = sext i32 %54 to i64
  call void @forge_rc_collect()
  ret i64 0
}

define i64 @__lambda_0(i64 %0, i64 %1) {
entry:
  %n = alloca i64, align 8
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  store i64 %1, ptr %n, align 8
  %pgocount = load i64, ptr @__profc___lambda_0, align 8
  %2 = add i64 %pgocount, 1
  store i64 %2, ptr @__profc___lambda_0, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_0, i32 0, i32 1), align 8
  %3 = add i64 %pgocount1, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_0, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_0, i32 0, i32 2), align 8
  %4 = add i64 %pgocount2, 1
  store i64 %4, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_0, i32 0, i32 2), align 8
  %x1 = load i64, ptr %x, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_0, i32 0, i32 3), align 8
  %5 = add i64 %pgocount3, 1
  store i64 %5, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_0, i32 0, i32 3), align 8
  %n2 = load i64, ptr %n, align 8
  %mul = mul i64 %x1, %n2
  ret i64 %mul
}

define i64 @__lambda_1(i64 %0, i64 %1, i64 %2) {
entry:
  %f = alloca ptr, align 8
  %g = alloca ptr, align 8
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %cast = inttoptr i64 %1 to ptr
  store ptr %cast, ptr %g, align 8
  %cast1 = inttoptr i64 %2 to ptr
  store ptr %cast1, ptr %f, align 8
  %pgocount = load i64, ptr @__profc___lambda_1, align 8
  %3 = add i64 %pgocount, 1
  store i64 %3, ptr @__profc___lambda_1, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_1, i32 0, i32 1), align 8
  %4 = add i64 %pgocount1, 1
  store i64 %4, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_1, i32 0, i32 1), align 8
  %f2 = load i64, ptr %f, align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_1, i32 0, i32 2), align 8
  %5 = add i64 %pgocount2, 1
  store i64 %5, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_1, i32 0, i32 2), align 8
  %g3 = load i64, ptr %g, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_1, i32 0, i32 3), align 8
  %6 = add i64 %pgocount3, 1
  store i64 %6, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_1, i32 0, i32 3), align 8
  %x4 = load i64, ptr %x, align 8
  %7 = call i64 @forge_closure_call_1(i64 %g3, i64 %x4)
  %8 = call i64 @forge_closure_call_1(i64 %f2, i64 %7)
  ret i64 %8
}

define i64 @__lambda_2(i64 %0) {
entry:
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  %pgocount = load i64, ptr @__profc___lambda_2, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc___lambda_2, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_2, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_2, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_2, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_2, i32 0, i32 2), align 8
  %4 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %4, i64 -559038737)
  call void @forge_array_push(ptr %4, i64 ptrtoint (ptr @__lambda_3 to i64))
  %cap_val = load i64, ptr %n, align 8
  call void @forge_array_push(ptr %4, i64 %cap_val)
  %cast = ptrtoint ptr %4 to i64
  ret i64 %cast
}

define i64 @__lambda_3(i64 %0, i64 %1) {
entry:
  %n = alloca i64, align 8
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  store i64 %1, ptr %n, align 8
  %pgocount = load i64, ptr @__profc___lambda_3, align 8
  %2 = add i64 %pgocount, 1
  store i64 %2, ptr @__profc___lambda_3, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_3, i32 0, i32 1), align 8
  %3 = add i64 %pgocount1, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_3, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_3, i32 0, i32 2), align 8
  %4 = add i64 %pgocount2, 1
  store i64 %4, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_3, i32 0, i32 2), align 8
  %x1 = load i64, ptr %x, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_3, i32 0, i32 3), align 8
  %5 = add i64 %pgocount3, 1
  store i64 %5, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_3, i32 0, i32 3), align 8
  %n2 = load i64, ptr %n, align 8
  %add = add i64 %x1, %n2
  ret i64 %add
}

define i64 @__lambda_4(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %pgocount = load i64, ptr @__profc___lambda_4, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc___lambda_4, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_4, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_4, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_4, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_4, i32 0, i32 2), align 8
  %x1 = load i64, ptr %x, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_4, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_4, i32 0, i32 3), align 8
  %add = add i64 %x1, 1
  ret i64 %add
}

define i64 @__lambda_5(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %pgocount = load i64, ptr @__profc___lambda_5, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc___lambda_5, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_5, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_5, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_5, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_5, i32 0, i32 2), align 8
  %x1 = load i64, ptr %x, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_5, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_5, i32 0, i32 3), align 8
  %mul = mul i64 %x1, 2
  ret i64 %mul
}

; Function Attrs: noinline
define linkonce_odr hidden i32 @__llvm_profile_runtime_user() #1 {
  %1 = load i32, ptr @__llvm_profile_runtime, align 4
  ret i32 %1
}

attributes #0 = { nounwind }
attributes #1 = { noinline }
