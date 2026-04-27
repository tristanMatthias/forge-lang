; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/null_safety/tests/try_nested.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

@r = global i64 0
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_inner = private global [3 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_inner = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 4738244524459464682, i64 210716147745, i64 sub (i64 ptrtoint (ptr @__profc_inner to i64), i64 ptrtoint (ptr @__profd_inner to i64)), i64 0, ptr null, ptr null, i32 3, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_middle = private global [4 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_middle = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -4955733377819192246, i64 6953783126996, i64 sub (i64 ptrtoint (ptr @__profc_middle to i64), i64 ptrtoint (ptr @__profd_middle to i64)), i64 0, ptr null, ptr null, i32 4, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_outer = private global [4 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_outer = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 9141591552168950908, i64 210723521364, i64 sub (i64 ptrtoint (ptr @__profc_outer to i64), i64 ptrtoint (ptr @__profd_outer to i64)), i64 0, ptr null, ptr null, i32 4, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_main = private global [12 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 12, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__llvm_prf_nm = private constant [30 x i8] c"\17\1Cx\DA\CB\CC\CBK-b\CC\CDLI\C9Ie\CC/-\01q\123\F3\00en\08c", section "__DATA,__llvm_prf_names", align 1
@llvm.compiler.used = appending global [5 x ptr] [ptr @__llvm_profile_runtime_user, ptr @__profd_inner, ptr @__profd_middle, ptr @__profd_outer, ptr @__profd_main], section "llvm.metadata"
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

define i64 @inner() {
entry:
  %pgocount = load i64, ptr @__profc_inner, align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr @__profc_inner, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([3 x i64], ptr @__profc_inner, i32 0, i32 1), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([3 x i64], ptr @__profc_inner, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([3 x i64], ptr @__profc_inner, i32 0, i32 2), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([3 x i64], ptr @__profc_inner, i32 0, i32 2), align 8
  ret i64 0
}

define i64 @middle() {
entry:
  %pgocount = load i64, ptr @__profc_middle, align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr @__profc_middle, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_middle, i32 0, i32 1), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([4 x i64], ptr @__profc_middle, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_middle, i32 0, i32 2), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([4 x i64], ptr @__profc_middle, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_middle, i32 0, i32 3), align 8
  %3 = add i64 %pgocount3, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc_middle, i32 0, i32 3), align 8
  %4 = call i64 @inner()
  %try_null = icmp eq i64 %4, 0
  br i1 %try_null, label %try_ret, label %try_ok

try_ok:                                           ; preds = %entry
  ret i64 %4

try_ret:                                          ; preds = %entry
  ret i64 0
}

define i64 @outer() {
entry:
  %pgocount = load i64, ptr @__profc_outer, align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr @__profc_outer, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_outer, i32 0, i32 1), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([4 x i64], ptr @__profc_outer, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_outer, i32 0, i32 2), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([4 x i64], ptr @__profc_outer, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_outer, i32 0, i32 3), align 8
  %3 = add i64 %pgocount3, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc_outer, i32 0, i32 3), align 8
  %4 = call i64 @middle()
  %try_null = icmp eq i64 %4, 0
  br i1 %try_null, label %try_ret, label %try_ok

try_ok:                                           ; preds = %entry
  ret i64 %4

try_ret:                                          ; preds = %entry
  ret i64 0
}

define i64 @main() {
entry:
  %nc_result = alloca i64, align 8
  %pgocount = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %1 = call i64 @outer()
  store i64 %1, ptr @r, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %r = load i64, ptr @r, align 8
  %nc_null = icmp eq i64 %r, 0
  store i64 %r, ptr %nc_result, align 8
  br i1 %nc_null, label %nc_rhs, label %nc_end

nc_rhs:                                           ; preds = %entry
  %pgocount6 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %8 = add i64 %pgocount7, 1
  store i64 %8, ptr getelementptr inbounds ([12 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  store i64 -1, ptr %nc_result, align 8
  br label %nc_end

nc_end:                                           ; preds = %nc_rhs, %entry
  %nc_val = load i64, ptr %nc_result, align 8
  %9 = call ptr @forge_rc_alloc(i64 32)
  %10 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %9, i64 32, ptr @.i2s_fmt, i64 %nc_val)
  %widen = sext i32 %10 to i64
  %11 = call i32 @puts(ptr %9)
  %widen1 = sext i32 %11 to i64
  %12 = call i32 @forge_test_summary()
  %widen2 = sext i32 %12 to i64
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
