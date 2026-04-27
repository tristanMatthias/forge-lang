; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/closures/tests/capture_in_match.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

%Box = type { i64, ptr }

@.match_fn = private unnamed_addr constant [11 x i8] c"__lambda_0\00", align 1
@mu_file = private unnamed_addr constant [141 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/closures/tests/capture_in_match.fg\00", align 1
@.str = private unnamed_addr constant [7 x i8] c" world\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_test_match_capture = private global [13 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_test_match_capture = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -5938218430127413611, i64 -7983405376400791676, i64 sub (i64 ptrtoint (ptr @__profc_test_match_capture to i64), i64 ptrtoint (ptr @__profd_test_match_capture to i64)), i64 0, ptr null, ptr null, i32 13, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_test_if_else_capture = private global [13 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_test_if_else_capture = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -5537299123778435690, i64 -2344999613198405554, i64 sub (i64 ptrtoint (ptr @__profc_test_if_else_capture to i64), i64 ptrtoint (ptr @__profd_test_if_else_capture to i64)), i64 0, ptr null, ptr null, i32 13, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_test_enum_ctor_capture = private global [7 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_test_enum_ctor_capture = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 8080143295836875296, i64 -7071231672454559069, i64 sub (i64 ptrtoint (ptr @__profc_test_enum_ctor_capture to i64), i64 ptrtoint (ptr @__profd_test_enum_ctor_capture to i64)), i64 0, ptr null, ptr null, i32 7, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_main = private global [12 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 12, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___bs_top_level = private global [13 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___bs_top_level = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -3222087168638311179, i64 -7005428211549351871, i64 sub (i64 ptrtoint (ptr @__profc___bs_top_level to i64), i64 ptrtoint (ptr @__profd___bs_top_level to i64)), i64 0, ptr null, ptr null, i32 13, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___lambda_0 = private global [9 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___lambda_0 = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -204181057533209874, i64 8245973951994833619, i64 sub (i64 ptrtoint (ptr @__profc___lambda_0 to i64), i64 ptrtoint (ptr @__profd___lambda_0 to i64)), i64 0, ptr null, ptr null, i32 9, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___lambda_1 = private global [9 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___lambda_1 = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 6925786121186820513, i64 8245973951994833620, i64 sub (i64 ptrtoint (ptr @__profc___lambda_1 to i64), i64 ptrtoint (ptr @__profd___lambda_1 to i64)), i64 0, ptr null, ptr null, i32 9, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___lambda_2 = private global [4 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___lambda_2 = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 6511828798704078813, i64 8245973951994833621, i64 sub (i64 ptrtoint (ptr @__profc___lambda_2 to i64), i64 ptrtoint (ptr @__profd___lambda_2 to i64)), i64 0, ptr null, ptr null, i32 4, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__llvm_prf_nm = private constant [79 x i8] c"sMx\DAU\C8A\0E\80 \0C\05\D1p#\F5B?\A5\D6H\D2\02\81\E2\F9\D5\8D\C4\DD\CCs\E9\0E#\E7\13L\D5G\93\E0/\A5\03\A2]\FE(y\18\D8K\FB\D8(\E5\00\C4\0E/\15*\97\E8\B3J\16w\C22s\9D\B9\DD5\13+|", section "__DATA,__llvm_prf_names", align 1
@llvm.compiler.used = appending global [9 x ptr] [ptr @__llvm_profile_runtime_user, ptr @__profd_test_match_capture, ptr @__profd_test_if_else_capture, ptr @__profd_test_enum_ctor_capture, ptr @__profd_main, ptr @__profd___bs_top_level, ptr @__profd___lambda_0, ptr @__profd___lambda_1, ptr @__profd___lambda_2], section "llvm.metadata"
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

define i64 @test_match_capture() {
entry:
  %f = alloca ptr, align 8
  %factor = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_test_match_capture, align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr @__profc_test_match_capture, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_test_match_capture, i32 0, i32 1), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([13 x i64], ptr @__profc_test_match_capture, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_test_match_capture, i32 0, i32 2), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([13 x i64], ptr @__profc_test_match_capture, i32 0, i32 2), align 8
  store i64 3, ptr %factor, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_test_match_capture, i32 0, i32 3), align 8
  %3 = add i64 %pgocount3, 1
  store i64 %3, ptr getelementptr inbounds ([13 x i64], ptr @__profc_test_match_capture, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_test_match_capture, i32 0, i32 4), align 8
  %4 = add i64 %pgocount4, 1
  store i64 %4, ptr getelementptr inbounds ([13 x i64], ptr @__profc_test_match_capture, i32 0, i32 4), align 8
  %5 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %5, i64 -559038737)
  call void @forge_array_push(ptr %5, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cap_val = load i64, ptr %factor, align 8
  call void @forge_array_push(ptr %5, i64 %cap_val)
  %cast = ptrtoint ptr %5 to i64
  %cast1 = inttoptr i64 %cast to ptr
  store ptr %cast1, ptr %f, align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_test_match_capture, i32 0, i32 9), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([13 x i64], ptr @__profc_test_match_capture, i32 0, i32 9), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_test_match_capture, i32 0, i32 10), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([13 x i64], ptr @__profc_test_match_capture, i32 0, i32 10), align 8
  %f2 = load i64, ptr %f, align 8
  %cast3 = inttoptr i64 %f2 to ptr
  %8 = call i64 @forge_array_get(ptr %cast3, i64 1)
  %fn_ptr = inttoptr i64 %8 to ptr
  %pgocount7 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_test_match_capture, i32 0, i32 11), align 8
  %9 = add i64 %pgocount7, 1
  store i64 %9, ptr getelementptr inbounds ([13 x i64], ptr @__profc_test_match_capture, i32 0, i32 11), align 8
  %10 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Box, ptr %10, i32 0, i32 0
  store i64 193473960, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Box, ptr %10, i32 0, i32 1
  %11 = call ptr @forge_rc_alloc(i64 8)
  store ptr %11, ptr %pay_ptr, align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_test_match_capture, i32 0, i32 12), align 8
  %12 = add i64 %pgocount8, 1
  store i64 %12, ptr getelementptr inbounds ([13 x i64], ptr @__profc_test_match_capture, i32 0, i32 12), align 8
  %slot_base = ptrtoint ptr %11 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 10, ptr %slot, align 8
  %cast4 = ptrtoint ptr %10 to i64
  %13 = call i64 @forge_array_get(ptr %cast3, i64 2)
  %closure_call = call i64 %fn_ptr(i64 %cast4, i64 %13)
  ret i64 %closure_call
}

define i64 @test_if_else_capture() {
entry:
  %f = alloca ptr, align 8
  %default_val = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_test_if_else_capture, align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr @__profc_test_if_else_capture, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_test_if_else_capture, i32 0, i32 1), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([13 x i64], ptr @__profc_test_if_else_capture, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_test_if_else_capture, i32 0, i32 2), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([13 x i64], ptr @__profc_test_if_else_capture, i32 0, i32 2), align 8
  store i64 99, ptr %default_val, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_test_if_else_capture, i32 0, i32 3), align 8
  %3 = add i64 %pgocount3, 1
  store i64 %3, ptr getelementptr inbounds ([13 x i64], ptr @__profc_test_if_else_capture, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_test_if_else_capture, i32 0, i32 4), align 8
  %4 = add i64 %pgocount4, 1
  store i64 %4, ptr getelementptr inbounds ([13 x i64], ptr @__profc_test_if_else_capture, i32 0, i32 4), align 8
  %5 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %5, i64 -559038737)
  call void @forge_array_push(ptr %5, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cap_val = load i64, ptr %default_val, align 8
  call void @forge_array_push(ptr %5, i64 %cap_val)
  %cast = ptrtoint ptr %5 to i64
  %cast1 = inttoptr i64 %cast to ptr
  store ptr %cast1, ptr %f, align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_test_if_else_capture, i32 0, i32 9), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([13 x i64], ptr @__profc_test_if_else_capture, i32 0, i32 9), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_test_if_else_capture, i32 0, i32 10), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([13 x i64], ptr @__profc_test_if_else_capture, i32 0, i32 10), align 8
  %f2 = load i64, ptr %f, align 8
  %cast3 = inttoptr i64 %f2 to ptr
  %8 = call i64 @forge_array_get(ptr %cast3, i64 1)
  %fn_ptr = inttoptr i64 %8 to ptr
  %pgocount7 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_test_if_else_capture, i32 0, i32 11), align 8
  %9 = add i64 %pgocount7, 1
  store i64 %9, ptr getelementptr inbounds ([13 x i64], ptr @__profc_test_if_else_capture, i32 0, i32 11), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([13 x i64], ptr @__profc_test_if_else_capture, i32 0, i32 12), align 8
  %10 = add i64 %pgocount8, 1
  store i64 %10, ptr getelementptr inbounds ([13 x i64], ptr @__profc_test_if_else_capture, i32 0, i32 12), align 8
  %11 = call i64 @forge_array_get(ptr %cast3, i64 2)
  %closure_call = call i64 %fn_ptr(i64 -1, i64 %11)
  ret i64 %closure_call
}

define ptr @test_enum_ctor_capture() {
entry:
  %f = alloca ptr, align 8
  %suffix = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_test_enum_ctor_capture, align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr @__profc_test_enum_ctor_capture, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([7 x i64], ptr @__profc_test_enum_ctor_capture, i32 0, i32 1), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([7 x i64], ptr @__profc_test_enum_ctor_capture, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([7 x i64], ptr @__profc_test_enum_ctor_capture, i32 0, i32 2), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([7 x i64], ptr @__profc_test_enum_ctor_capture, i32 0, i32 2), align 8
  store ptr @.str, ptr %suffix, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([7 x i64], ptr @__profc_test_enum_ctor_capture, i32 0, i32 3), align 8
  %3 = add i64 %pgocount3, 1
  store i64 %3, ptr getelementptr inbounds ([7 x i64], ptr @__profc_test_enum_ctor_capture, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([7 x i64], ptr @__profc_test_enum_ctor_capture, i32 0, i32 4), align 8
  %4 = add i64 %pgocount4, 1
  store i64 %4, ptr getelementptr inbounds ([7 x i64], ptr @__profc_test_enum_ctor_capture, i32 0, i32 4), align 8
  %5 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %5, i64 -559038737)
  call void @forge_array_push(ptr %5, i64 ptrtoint (ptr @__lambda_2 to i64))
  %cap_val = load i64, ptr %suffix, align 8
  call void @forge_array_push(ptr %5, i64 %cap_val)
  %cast = ptrtoint ptr %5 to i64
  %cast1 = inttoptr i64 %cast to ptr
  store ptr %cast1, ptr %f, align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([7 x i64], ptr @__profc_test_enum_ctor_capture, i32 0, i32 4), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([7 x i64], ptr @__profc_test_enum_ctor_capture, i32 0, i32 4), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([7 x i64], ptr @__profc_test_enum_ctor_capture, i32 0, i32 5), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([7 x i64], ptr @__profc_test_enum_ctor_capture, i32 0, i32 5), align 8
  %f2 = load i64, ptr %f, align 8
  %cast3 = inttoptr i64 %f2 to ptr
  %8 = call i64 @forge_array_get(ptr %cast3, i64 1)
  %fn_ptr = inttoptr i64 %8 to ptr
  %pgocount7 = load i64, ptr getelementptr inbounds ([7 x i64], ptr @__profc_test_enum_ctor_capture, i32 0, i32 6), align 8
  %9 = add i64 %pgocount7, 1
  store i64 %9, ptr getelementptr inbounds ([7 x i64], ptr @__profc_test_enum_ctor_capture, i32 0, i32 6), align 8
  %10 = call i64 @forge_array_get(ptr %cast3, i64 2)
  %closure_call = call i64 %fn_ptr(ptr @.str.1, i64 %10)
  %cast4 = inttoptr i64 %closure_call to ptr
  ret ptr %cast4
}

define i64 @main() {
entry:
  %pgocount = load i64, ptr @__profc_main, align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr @__profc_main, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %3 = add i64 %pgocount3, 1
  store i64 %3, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %4 = add i64 %pgocount4, 1
  store i64 %4, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %5 = call i64 @test_match_capture()
  %6 = call ptr @forge_rc_alloc(i64 32)
  %7 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %6, i64 32, ptr @.i2s_fmt, i64 %5)
  %widen = sext i32 %7 to i64
  %8 = call i32 @puts(ptr %6)
  %widen1 = sext i32 %8 to i64
  %pgocount5 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %9 = add i64 %pgocount5, 1
  store i64 %9, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %10 = add i64 %pgocount6, 1
  store i64 %10, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %11 = add i64 %pgocount7, 1
  store i64 %11, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %12 = add i64 %pgocount8, 1
  store i64 %12, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %13 = call i64 @test_if_else_capture()
  %14 = call ptr @forge_rc_alloc(i64 32)
  %15 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %14, i64 32, ptr @.i2s_fmt.2, i64 %13)
  %widen2 = sext i32 %15 to i64
  %16 = call i32 @puts(ptr %14)
  %widen3 = sext i32 %16 to i64
  %pgocount9 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %17 = add i64 %pgocount9, 1
  store i64 %17, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %18 = add i64 %pgocount10, 1
  store i64 %18, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %19 = add i64 %pgocount11, 1
  store i64 %19, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %20 = call ptr @test_enum_ctor_capture()
  %21 = call i32 @puts(ptr %20)
  %widen4 = sext i32 %21 to i64
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

define i64 @__lambda_0(ptr %0, i64 %1) {
entry:
  %n2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %factor = alloca i64, align 8
  %b = alloca ptr, align 8
  store ptr %0, ptr %b, align 8
  store i64 %1, ptr %factor, align 8
  %pgocount = load i64, ptr @__profc___lambda_0, align 8
  %2 = add i64 %pgocount, 1
  store i64 %2, ptr @__profc___lambda_0, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_0, i32 0, i32 1), align 8
  %3 = add i64 %pgocount1, 1
  store i64 %3, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_0, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_0, i32 0, i32 2), align 8
  %4 = add i64 %pgocount2, 1
  store i64 %4, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_0, i32 0, i32 2), align 8
  %b1 = load ptr, ptr %b, align 8
  %tag_ptr = getelementptr inbounds nuw %Box, ptr %b1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193473960
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm5, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Box, ptr %b1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %n_slot_base = ptrtoint ptr %payload to i64
  %n_slot_addr = add i64 %n_slot_base, 0
  %n_slot = inttoptr i64 %n_slot_addr to ptr
  %n = load i64, ptr %n_slot, align 8
  store i64 %n, ptr %n2, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_0, i32 0, i32 3), align 8
  %5 = add i64 %pgocount3, 1
  store i64 %5, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_0, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_0, i32 0, i32 4), align 8
  %6 = add i64 %pgocount4, 1
  store i64 %6, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_0, i32 0, i32 4), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_0, i32 0, i32 5), align 8
  %7 = add i64 %pgocount5, 1
  store i64 %7, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_0, i32 0, i32 5), align 8
  %n3 = load i64, ptr %n2, align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_0, i32 0, i32 6), align 8
  %8 = add i64 %pgocount6, 1
  store i64 %8, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_0, i32 0, i32 6), align 8
  %factor4 = load i64, ptr %factor, align 8
  %mul = mul i64 %n3, %factor4
  store i64 %mul, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq7 = icmp eq i64 %tag, 210673421332
  br i1 %tag_eq7, label %march_arm5, label %march_next6

march_arm5:                                       ; preds = %march_next
  %pgocount7 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_0, i32 0, i32 7), align 8
  %9 = add i64 %pgocount7, 1
  store i64 %9, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_0, i32 0, i32 7), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_0, i32 0, i32 8), align 8
  %10 = add i64 %pgocount8, 1
  store i64 %10, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_0, i32 0, i32 8), align 8
  store i64 0, ptr %match_result, align 8
  br label %match_end

march_next6:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 12)
  unreachable
}

define i64 @__lambda_1(i64 %0, i64 %1) {
entry:
  %sif_result = alloca i64, align 8
  %default_val = alloca i64, align 8
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  store i64 %1, ptr %default_val, align 8
  %pgocount = load i64, ptr @__profc___lambda_1, align 8
  %2 = add i64 %pgocount, 1
  store i64 %2, ptr @__profc___lambda_1, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_1, i32 0, i32 1), align 8
  %3 = add i64 %pgocount1, 1
  store i64 %3, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_1, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_1, i32 0, i32 2), align 8
  %4 = add i64 %pgocount2, 1
  store i64 %4, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_1, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_1, i32 0, i32 3), align 8
  %5 = add i64 %pgocount3, 1
  store i64 %5, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_1, i32 0, i32 3), align 8
  %x1 = load i64, ptr %x, align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_1, i32 0, i32 4), align 8
  %6 = add i64 %pgocount4, 1
  store i64 %6, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_1, i32 0, i32 4), align 8
  %sgt = icmp sgt i64 %x1, 0
  %sgt_ext = zext i1 %sgt to i64
  %sif_cond = icmp ne i64 %sgt_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

sif_then:                                         ; preds = %entry
  %pgocount5 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_1, i32 0, i32 5), align 8
  %7 = add i64 %pgocount5, 1
  store i64 %7, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_1, i32 0, i32 5), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_1, i32 0, i32 6), align 8
  %8 = add i64 %pgocount6, 1
  store i64 %8, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_1, i32 0, i32 6), align 8
  %x2 = load i64, ptr %x, align 8
  store i64 %x2, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %entry
  %pgocount7 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_1, i32 0, i32 7), align 8
  %9 = add i64 %pgocount7, 1
  store i64 %9, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_1, i32 0, i32 7), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_1, i32 0, i32 8), align 8
  %10 = add i64 %pgocount8, 1
  store i64 %10, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_1, i32 0, i32 8), align 8
  %default_val3 = load i64, ptr %default_val, align 8
  store i64 %default_val3, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  ret i64 %sif_val
}

define i64 @__lambda_2(ptr %0, i64 %1) {
entry:
  %suffix = alloca ptr, align 8
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %cast = inttoptr i64 %1 to ptr
  store ptr %cast, ptr %suffix, align 8
  %pgocount = load i64, ptr @__profc___lambda_2, align 8
  %2 = add i64 %pgocount, 1
  store i64 %2, ptr @__profc___lambda_2, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_2, i32 0, i32 1), align 8
  %3 = add i64 %pgocount1, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_2, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_2, i32 0, i32 2), align 8
  %4 = add i64 %pgocount2, 1
  store i64 %4, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_2, i32 0, i32 2), align 8
  %s1 = load ptr, ptr %s, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_2, i32 0, i32 3), align 8
  %5 = add i64 %pgocount3, 1
  store i64 %5, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_2, i32 0, i32 3), align 8
  %suffix2 = load ptr, ptr %suffix, align 8
  %6 = call i64 @strlen(ptr %s1)
  %7 = call i64 @strlen(ptr %suffix2)
  %concat_total = add i64 %6, %7
  %concat_size = add i64 %concat_total, 1
  %8 = call ptr @forge_rc_alloc(i64 %concat_size)
  %9 = call ptr @memcpy(ptr %8, ptr %s1, i64 %6)
  %cast3 = ptrtoint ptr %8 to i64
  %dst2_int = add i64 %cast3, %6
  %cast4 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %7, 1
  %10 = call ptr @memcpy(ptr %cast4, ptr %suffix2, i64 %rhs_len_p1)
  %cast5 = ptrtoint ptr %8 to i64
  ret i64 %cast5
}

; Function Attrs: noinline
define linkonce_odr hidden i32 @__llvm_profile_runtime_user() #1 {
  %1 = load i32, ptr @__llvm_profile_runtime, align 4
  ret i32 %1
}

attributes #0 = { nounwind }
attributes #1 = { noinline }
