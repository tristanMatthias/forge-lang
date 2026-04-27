; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/spawn_expr/example.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

@.str = private unnamed_addr constant [17 x i8] c"hello from spawn\00", align 1
@.str.2 = private unnamed_addr constant [12 x i8] c"after spawn\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.3 = private unnamed_addr constant [9 x i8] c"result: \00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_main = private global [12 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 12, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___bs_top_level = private global [13 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___bs_top_level = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -3222087168638311179, i64 -7005428211549351871, i64 sub (i64 ptrtoint (ptr @__profc___bs_top_level to i64), i64 ptrtoint (ptr @__profd___bs_top_level to i64)), i64 0, ptr null, ptr null, i32 13, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___lambda_0 = private global [3 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___lambda_0 = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -204181057533209874, i64 8245973951994833619, i64 sub (i64 ptrtoint (ptr @__profc___lambda_0 to i64), i64 ptrtoint (ptr @__profd___lambda_0 to i64)), i64 0, ptr null, ptr null, i32 3, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___lambda_1 = private global [5 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___lambda_1 = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 6925786121186820513, i64 8245973951994833620, i64 sub (i64 ptrtoint (ptr @__profc___lambda_1 to i64), i64 ptrtoint (ptr @__profd___lambda_1 to i64)), i64 0, ptr null, ptr null, i32 5, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___lambda_2 = private global [3 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___lambda_2 = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 6511828798704078813, i64 8245973951994833621, i64 sub (i64 ptrtoint (ptr @__profc___lambda_2 to i64), i64 ptrtoint (ptr @__profd___lambda_2 to i64)), i64 0, ptr null, ptr null, i32 3, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__llvm_prf_nm = private constant [44 x i8] c"4*x\DA\CBM\CC\CCc\8C\8FO*\8E/\C9/\88\CFI-K\CD\01rs\12s\93R\12\E3\0D\10LC\04\D3\08\00\F4]\12s", section "__DATA,__llvm_prf_names", align 1
@llvm.compiler.used = appending global [6 x ptr] [ptr @__llvm_profile_runtime_user, ptr @__profd_main, ptr @__profd___bs_top_level, ptr @__profd___lambda_0, ptr @__profd___lambda_1, ptr @__profd___lambda_2], section "llvm.metadata"
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

declare i64 @forge_thread_join.1(i64)

define i64 @main() {
entry:
  %result = alloca i64, align 8
  %task = alloca i64, align 8
  %h2 = alloca i64, align 8
  %x = alloca i64, align 8
  %h = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_main, align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr @__profc_main, align 8
  %1 = call ptr @forge_task_group_new()
  %pgocount1 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %4 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %4, i64 -559038737)
  call void @forge_array_push(ptr %4, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast = ptrtoint ptr %4 to i64
  %cast1 = inttoptr i64 %cast to ptr
  %5 = call i64 @forge_spawn(ptr %cast1)
  %cast2 = inttoptr i64 %5 to ptr
  call void @forge_task_group_add(ptr %1, ptr %cast2)
  store i64 %5, ptr %h, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %6 = add i64 %pgocount3, 1
  store i64 %6, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %7 = add i64 %pgocount4, 1
  store i64 %7, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %8 = add i64 %pgocount5, 1
  store i64 %8, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %h3 = load i64, ptr %h, align 8
  %cast4 = inttoptr i64 %h3 to ptr
  %9 = call i32 @forge_thread_join(ptr %cast4)
  %widen = sext i32 %9 to i64
  %pgocount6 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %10 = add i64 %pgocount6, 1
  store i64 %10, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %11 = add i64 %pgocount7, 1
  store i64 %11, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %12 = call i32 @puts(ptr @.str.2)
  %widen5 = sext i32 %12 to i64
  %pgocount8 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %13 = add i64 %pgocount8, 1
  store i64 %13, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %14 = add i64 %pgocount9, 1
  store i64 %14, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  store i64 42, ptr %x, align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %15 = add i64 %pgocount10, 1
  store i64 %15, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %16 = add i64 %pgocount11, 1
  store i64 %16, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %17 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %17, i64 -559038737)
  call void @forge_array_push(ptr %17, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cap_val = load i64, ptr %x, align 8
  call void @forge_array_push(ptr %17, i64 %cap_val)
  %cast6 = ptrtoint ptr %17 to i64
  %cast7 = inttoptr i64 %cast6 to ptr
  %18 = call i64 @forge_spawn(ptr %cast7)
  %cast8 = inttoptr i64 %18 to ptr
  call void @forge_task_group_add(ptr %1, ptr %cast8)
  store i64 %18, ptr %h2, align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %19 = add i64 %pgocount12, 1
  store i64 %19, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %20 = add i64 %pgocount13, 1
  store i64 %20, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %21 = add i64 %pgocount14, 1
  store i64 %21, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %h29 = load i64, ptr %h2, align 8
  %cast10 = inttoptr i64 %h29 to ptr
  %22 = call i32 @forge_thread_join(ptr %cast10)
  %widen11 = sext i32 %22 to i64
  %pgocount15 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %23 = add i64 %pgocount15, 1
  store i64 %23, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %pgocount16 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %24 = add i64 %pgocount16, 1
  store i64 %24, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %25 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %25, i64 -559038737)
  call void @forge_array_push(ptr %25, i64 ptrtoint (ptr @__lambda_2 to i64))
  %cast12 = ptrtoint ptr %25 to i64
  %cast13 = inttoptr i64 %cast12 to ptr
  %26 = call i64 @forge_spawn(ptr %cast13)
  %cast14 = inttoptr i64 %26 to ptr
  call void @forge_task_group_add(ptr %1, ptr %cast14)
  store i64 %26, ptr %task, align 8
  %pgocount17 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %27 = add i64 %pgocount17, 1
  store i64 %27, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %28 = add i64 %pgocount18, 1
  store i64 %28, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %29 = add i64 %pgocount19, 1
  store i64 %29, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %task15 = load i64, ptr %task, align 8
  %cast16 = inttoptr i64 %task15 to ptr
  %30 = call i64 @forge_task_await(ptr %cast16)
  store i64 %30, ptr %result, align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %31 = add i64 %pgocount20, 1
  store i64 %31, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %32 = add i64 %pgocount21, 1
  store i64 %32, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pgocount22 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %33 = add i64 %pgocount22, 1
  store i64 %33, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %pgocount23 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %34 = add i64 %pgocount23, 1
  store i64 %34, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %pgocount24 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %35 = add i64 %pgocount24, 1
  store i64 %35, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %pgocount25 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %36 = add i64 %pgocount25, 1
  store i64 %36, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %result17 = load i64, ptr %result, align 8
  %37 = call ptr @forge_rc_alloc(i64 32)
  %38 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %37, i64 32, ptr @.i2s_fmt.4, i64 %result17)
  %widen18 = sext i32 %38 to i64
  %39 = call i64 @strlen(ptr @.str.3)
  %40 = call i64 @strlen(ptr %37)
  %concat_total = add i64 %39, %40
  %concat_size = add i64 %concat_total, 1
  %41 = call ptr @forge_rc_alloc(i64 %concat_size)
  %42 = call ptr @memcpy(ptr %41, ptr @.str.3, i64 %39)
  %cast19 = ptrtoint ptr %41 to i64
  %dst2_int = add i64 %cast19, %39
  %cast20 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %40, 1
  %43 = call ptr @memcpy(ptr %cast20, ptr %37, i64 %rhs_len_p1)
  %44 = call i32 @puts(ptr %41)
  %widen21 = sext i32 %44 to i64
  call void @forge_task_group_await_all(ptr %1)
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  %pgocount = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc___bs_top_level, i32 0, i32 12), align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr getelementptr inbounds ([13 x i64], ptr @__profc___bs_top_level, i32 0, i32 12), align 8
  %1 = call i32 @forge_test_summary()
  %widen = sext i32 %1 to i64
  call void @forge_rc_collect()
  ret i64 0
}

define i64 @__lambda_0() {
entry:
  %pgocount = load i64, ptr @__profc___lambda_0, align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr @__profc___lambda_0, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([3 x i64], ptr @__profc___lambda_0, i32 0, i32 1), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([3 x i64], ptr @__profc___lambda_0, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([3 x i64], ptr @__profc___lambda_0, i32 0, i32 2), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([3 x i64], ptr @__profc___lambda_0, i32 0, i32 2), align 8
  %3 = call i32 @puts(ptr @.str)
  %widen = sext i32 %3 to i64
  ret i64 0
}

define i64 @__lambda_1(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %pgocount = load i64, ptr @__profc___lambda_1, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc___lambda_1, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([5 x i64], ptr @__profc___lambda_1, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([5 x i64], ptr @__profc___lambda_1, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([5 x i64], ptr @__profc___lambda_1, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([5 x i64], ptr @__profc___lambda_1, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([5 x i64], ptr @__profc___lambda_1, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([5 x i64], ptr @__profc___lambda_1, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([5 x i64], ptr @__profc___lambda_1, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([5 x i64], ptr @__profc___lambda_1, i32 0, i32 4), align 8
  %x1 = load i64, ptr %x, align 8
  %6 = call ptr @forge_rc_alloc(i64 32)
  %7 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %6, i64 32, ptr @.i2s_fmt, i64 %x1)
  %widen = sext i32 %7 to i64
  %8 = call i32 @puts(ptr %6)
  %widen2 = sext i32 %8 to i64
  ret i64 0
}

define i64 @__lambda_2() {
entry:
  %pgocount = load i64, ptr @__profc___lambda_2, align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr @__profc___lambda_2, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([3 x i64], ptr @__profc___lambda_2, i32 0, i32 1), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([3 x i64], ptr @__profc___lambda_2, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([3 x i64], ptr @__profc___lambda_2, i32 0, i32 2), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([3 x i64], ptr @__profc___lambda_2, i32 0, i32 2), align 8
  ret i64 99
}

; Function Attrs: noinline
define linkonce_odr hidden i32 @__llvm_profile_runtime_user() #1 {
  %1 = load i32, ptr @__llvm_profile_runtime, align 4
  ret i32 %1
}

attributes #0 = { nounwind }
attributes #1 = { noinline }
