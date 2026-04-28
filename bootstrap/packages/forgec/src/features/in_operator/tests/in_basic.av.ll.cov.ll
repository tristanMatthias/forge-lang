; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/in_operator/tests/in_basic.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

%Color = type { i64, ptr }

@.str = private unnamed_addr constant [9 x i8] c"pass_int\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.2 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.3 = private unnamed_addr constant [6 x i8] c"world\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c"foo\00", align 1
@.str.5 = private unnamed_addr constant [12 x i8] c"pass_string\00", align 1
@.str.6 = private unnamed_addr constant [10 x i8] c"pass_enum\00", align 1
@.str.7 = private unnamed_addr constant [14 x i8] c"pass_negative\00", align 1
@.str.8 = private unnamed_addr constant [11 x i8] c"pass_empty\00", align 1
@.str.9 = private unnamed_addr constant [12 x i8] c"pass_single\00", align 1
@.str.10 = private unnamed_addr constant [10 x i8] c"pass_expr\00", align 1
@.str.11 = private unnamed_addr constant [6 x i8] c"small\00", align 1
@.str.12 = private unnamed_addr constant [4 x i8] c"big\00", align 1
@.str.13 = private unnamed_addr constant [6 x i8] c"small\00", align 1
@.str.14 = private unnamed_addr constant [11 x i8] c"pass_in_if\00", align 1
@.str.15 = private unnamed_addr constant [5 x i8] c"tens\00", align 1
@.str.16 = private unnamed_addr constant [6 x i8] c"small\00", align 1
@.str.17 = private unnamed_addr constant [6 x i8] c"other\00", align 1
@.str.18 = private unnamed_addr constant [6 x i8] c"small\00", align 1
@.str.19 = private unnamed_addr constant [14 x i8] c"pass_in_match\00", align 1
@.str.20 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.21 = private unnamed_addr constant [6 x i8] c"world\00", align 1
@.str.22 = private unnamed_addr constant [11 x i8] c"pass_combo\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_main = private global [198 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 198, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___bs_top_level = private global [199 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___bs_top_level = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -3222087168638311179, i64 -7005428211549351871, i64 sub (i64 ptrtoint (ptr @__profc___bs_top_level to i64), i64 ptrtoint (ptr @__profd___bs_top_level to i64)), i64 0, ptr null, ptr null, i32 199, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__llvm_prf_nm = private constant [29 x i8] c"\13\1Bx\DA\CBM\CC\CCc\8C\8FO*\8E/\C9/\88\CFI-K\CD\01\00GF\07c", section "__DATA,__llvm_prf_names", align 1
@llvm.compiler.used = appending global [3 x ptr] [ptr @__llvm_profile_runtime_user, ptr @__profd_main, ptr @__profd___bs_top_level], section "llvm.metadata"
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
  %sif_result = alloca i64, align 8
  %result = alloca ptr, align 8
  %when_result = alloca i64, align 8
  %label = alloca ptr, align 8
  %ife_result = alloca i64, align 8
  %a = alloca i64, align 8
  %y = alloca i64, align 8
  %g = alloca ptr, align 8
  %r = alloca ptr, align 8
  %c = alloca ptr, align 8
  %s = alloca ptr, align 8
  %x = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_main, align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr @__profc_main, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  store i64 3, ptr %x, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %3 = add i64 %pgocount3, 1
  store i64 %3, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %4 = add i64 %pgocount4, 1
  store i64 %4, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %5 = add i64 %pgocount5, 1
  store i64 %5, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %6 = add i64 %pgocount6, 1
  store i64 %6, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %x1 = load i64, ptr %x, align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %7 = add i64 %pgocount7, 1
  store i64 %7, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %eq = icmp eq i64 %x1, 1
  %eq_ext = zext i1 %eq to i64
  %pgocount8 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %8 = add i64 %pgocount8, 1
  store i64 %8, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %x2 = load i64, ptr %x, align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %9 = add i64 %pgocount9, 1
  store i64 %9, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %eq3 = icmp eq i64 %x2, 2
  %eq_ext4 = zext i1 %eq3 to i64
  %pgocount10 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %10 = add i64 %pgocount10, 1
  store i64 %10, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %x5 = load i64, ptr %x, align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %11 = add i64 %pgocount11, 1
  store i64 %11, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %eq6 = icmp eq i64 %x5, 3
  %eq_ext7 = zext i1 %eq6 to i64
  %pgocount12 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %12 = add i64 %pgocount12, 1
  store i64 %12, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %x8 = load i64, ptr %x, align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %13 = add i64 %pgocount13, 1
  store i64 %13, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %eq9 = icmp eq i64 %x8, 4
  %eq_ext10 = zext i1 %eq9 to i64
  %pgocount14 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %14 = add i64 %pgocount14, 1
  store i64 %14, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %x11 = load i64, ptr %x, align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %15 = add i64 %pgocount15, 1
  store i64 %15, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %eq12 = icmp eq i64 %x11, 5
  %eq_ext13 = zext i1 %eq12 to i64
  %in_or = or i64 %eq_ext13, 0
  %in_or14 = or i64 %eq_ext10, %in_or
  %in_or15 = or i64 %eq_ext7, %in_or14
  %in_or16 = or i64 %eq_ext4, %in_or15
  %in_or17 = or i64 %eq_ext, %in_or16
  %if_cond = icmp ne i64 %in_or17, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else, %if_then
  %pgocount16 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %16 = add i64 %pgocount16, 1
  store i64 %16, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %pgocount17 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %17 = add i64 %pgocount17, 1
  store i64 %17, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  store ptr @.str.1, ptr %s, align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %18 = add i64 %pgocount18, 1
  store i64 %18, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %19 = add i64 %pgocount19, 1
  store i64 %19, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %20 = add i64 %pgocount20, 1
  store i64 %20, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %21 = add i64 %pgocount21, 1
  store i64 %21, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %s18 = load ptr, ptr %s, align 8
  %pgocount22 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %22 = add i64 %pgocount22, 1
  store i64 %22, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %23 = call i32 @strcmp(ptr %s18, ptr @.str.2)
  %widen19 = sext i32 %23 to i64
  %streq_cmp = icmp eq i64 %widen19, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %pgocount23 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %24 = add i64 %pgocount23, 1
  store i64 %24, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %s20 = load ptr, ptr %s, align 8
  %pgocount24 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %25 = add i64 %pgocount24, 1
  store i64 %25, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %26 = call i32 @strcmp(ptr %s20, ptr @.str.3)
  %widen21 = sext i32 %26 to i64
  %streq_cmp22 = icmp eq i64 %widen21, 0
  %streq_ext23 = zext i1 %streq_cmp22 to i64
  %pgocount25 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %27 = add i64 %pgocount25, 1
  store i64 %27, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %s24 = load ptr, ptr %s, align 8
  %pgocount26 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %28 = add i64 %pgocount26, 1
  store i64 %28, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %29 = call i32 @strcmp(ptr %s24, ptr @.str.4)
  %widen25 = sext i32 %29 to i64
  %streq_cmp26 = icmp eq i64 %widen25, 0
  %streq_ext27 = zext i1 %streq_cmp26 to i64
  %in_or28 = or i64 %streq_ext27, 0
  %in_or29 = or i64 %streq_ext23, %in_or28
  %in_or30 = or i64 %streq_ext, %in_or29
  %if_cond32 = icmp ne i64 %in_or30, 0
  br i1 %if_cond32, label %if_then33, label %if_else34

if_then:                                          ; preds = %entry
  %pgocount27 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %30 = add i64 %pgocount27, 1
  store i64 %30, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %pgocount28 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %31 = add i64 %pgocount28, 1
  store i64 %31, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %pgocount29 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %32 = add i64 %pgocount29, 1
  store i64 %32, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %pgocount30 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %33 = add i64 %pgocount30, 1
  store i64 %33, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %34 = call i32 @puts(ptr @.str)
  %widen = sext i32 %34 to i64
  br label %ifcont

if_else:                                          ; preds = %entry
  %pgocount31 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %35 = add i64 %pgocount31, 1
  store i64 %35, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  br label %ifcont

ifcont31:                                         ; preds = %if_else34, %if_then33
  %pgocount32 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %36 = add i64 %pgocount32, 1
  store i64 %36, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %pgocount33 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %37 = add i64 %pgocount33, 1
  store i64 %37, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %38 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Color, ptr %38, i32 0, i32 0
  store i64 210675960374, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Color, ptr %38, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %38 to i64
  %cast36 = inttoptr i64 %cast to ptr
  store ptr %cast36, ptr %c, align 8
  %pgocount34 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %39 = add i64 %pgocount34, 1
  store i64 %39, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %pgocount35 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %40 = add i64 %pgocount35, 1
  store i64 %40, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %41 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr37 = getelementptr inbounds nuw %Color, ptr %41, i32 0, i32 0
  store i64 193469728, ptr %tag_ptr37, align 8
  %pay_ptr38 = getelementptr inbounds nuw %Color, ptr %41, i32 0, i32 1
  store ptr null, ptr %pay_ptr38, align 8
  %cast39 = ptrtoint ptr %41 to i64
  %cast40 = inttoptr i64 %cast39 to ptr
  store ptr %cast40, ptr %r, align 8
  %pgocount36 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %42 = add i64 %pgocount36, 1
  store i64 %42, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %pgocount37 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %43 = add i64 %pgocount37, 1
  store i64 %43, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %44 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr41 = getelementptr inbounds nuw %Color, ptr %44, i32 0, i32 0
  store i64 210675960374, ptr %tag_ptr41, align 8
  %pay_ptr42 = getelementptr inbounds nuw %Color, ptr %44, i32 0, i32 1
  store ptr null, ptr %pay_ptr42, align 8
  %cast43 = ptrtoint ptr %44 to i64
  %cast44 = inttoptr i64 %cast43 to ptr
  store ptr %cast44, ptr %g, align 8
  %pgocount38 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %45 = add i64 %pgocount38, 1
  store i64 %45, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %pgocount39 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %46 = add i64 %pgocount39, 1
  store i64 %46, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %pgocount40 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %47 = add i64 %pgocount40, 1
  store i64 %47, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %pgocount41 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %48 = add i64 %pgocount41, 1
  store i64 %48, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %x45 = load i64, ptr %x, align 8
  %pgocount42 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %49 = add i64 %pgocount42, 1
  store i64 %49, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %eq46 = icmp eq i64 %x45, 1
  %eq_ext47 = zext i1 %eq46 to i64
  %pgocount43 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %50 = add i64 %pgocount43, 1
  store i64 %50, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %x48 = load i64, ptr %x, align 8
  %pgocount44 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %51 = add i64 %pgocount44, 1
  store i64 %51, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %eq49 = icmp eq i64 %x48, 2
  %eq_ext50 = zext i1 %eq49 to i64
  %pgocount45 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %52 = add i64 %pgocount45, 1
  store i64 %52, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %x51 = load i64, ptr %x, align 8
  %pgocount46 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %53 = add i64 %pgocount46, 1
  store i64 %53, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %eq52 = icmp eq i64 %x51, 3
  %eq_ext53 = zext i1 %eq52 to i64
  %in_or54 = or i64 %eq_ext53, 0
  %in_or55 = or i64 %eq_ext50, %in_or54
  %in_or56 = or i64 %eq_ext47, %in_or55
  %if_cond58 = icmp ne i64 %in_or56, 0
  br i1 %if_cond58, label %if_then59, label %if_else60

if_then33:                                        ; preds = %ifcont
  %pgocount47 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %54 = add i64 %pgocount47, 1
  store i64 %54, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %pgocount48 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %55 = add i64 %pgocount48, 1
  store i64 %55, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %pgocount49 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %56 = add i64 %pgocount49, 1
  store i64 %56, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %pgocount50 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %57 = add i64 %pgocount50, 1
  store i64 %57, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %58 = call i32 @puts(ptr @.str.5)
  %widen35 = sext i32 %58 to i64
  br label %ifcont31

if_else34:                                        ; preds = %ifcont
  %pgocount51 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %59 = add i64 %pgocount51, 1
  store i64 %59, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  br label %ifcont31

ifcont57:                                         ; preds = %if_else60, %if_then59
  %pgocount52 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 57), align 8
  %60 = add i64 %pgocount52, 1
  store i64 %60, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 57), align 8
  %pgocount53 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 58), align 8
  %61 = add i64 %pgocount53, 1
  store i64 %61, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 58), align 8
  store i64 99, ptr %y, align 8
  %pgocount54 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 59), align 8
  %62 = add i64 %pgocount54, 1
  store i64 %62, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 59), align 8
  %pgocount55 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 60), align 8
  %63 = add i64 %pgocount55, 1
  store i64 %63, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 60), align 8
  %pgocount56 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 61), align 8
  %64 = add i64 %pgocount56, 1
  store i64 %64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 61), align 8
  %pgocount57 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 62), align 8
  %65 = add i64 %pgocount57, 1
  store i64 %65, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 62), align 8
  %pgocount58 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 63), align 8
  %66 = add i64 %pgocount58, 1
  store i64 %66, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 63), align 8
  %pgocount59 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 64), align 8
  %67 = add i64 %pgocount59, 1
  store i64 %67, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 64), align 8
  %y62 = load i64, ptr %y, align 8
  %pgocount60 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 65), align 8
  %68 = add i64 %pgocount60, 1
  store i64 %68, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 65), align 8
  %eq63 = icmp eq i64 %y62, 1
  %eq_ext64 = zext i1 %eq63 to i64
  %pgocount61 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 66), align 8
  %69 = add i64 %pgocount61, 1
  store i64 %69, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 66), align 8
  %y65 = load i64, ptr %y, align 8
  %pgocount62 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 67), align 8
  %70 = add i64 %pgocount62, 1
  store i64 %70, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 67), align 8
  %eq66 = icmp eq i64 %y65, 2
  %eq_ext67 = zext i1 %eq66 to i64
  %pgocount63 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 68), align 8
  %71 = add i64 %pgocount63, 1
  store i64 %71, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 68), align 8
  %y68 = load i64, ptr %y, align 8
  %pgocount64 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 69), align 8
  %72 = add i64 %pgocount64, 1
  store i64 %72, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 69), align 8
  %eq69 = icmp eq i64 %y68, 3
  %eq_ext70 = zext i1 %eq69 to i64
  %in_or71 = or i64 %eq_ext70, 0
  %in_or72 = or i64 %eq_ext67, %in_or71
  %in_or73 = or i64 %eq_ext64, %in_or72
  %not_cmp = icmp eq i64 %in_or73, 0
  %not_cmp_ext = zext i1 %not_cmp to i64
  %if_cond75 = icmp ne i64 %not_cmp_ext, 0
  br i1 %if_cond75, label %if_then76, label %if_else77

if_then59:                                        ; preds = %ifcont31
  %pgocount65 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 52), align 8
  %73 = add i64 %pgocount65, 1
  store i64 %73, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 52), align 8
  %pgocount66 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 53), align 8
  %74 = add i64 %pgocount66, 1
  store i64 %74, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 53), align 8
  %pgocount67 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 54), align 8
  %75 = add i64 %pgocount67, 1
  store i64 %75, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 54), align 8
  %pgocount68 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 55), align 8
  %76 = add i64 %pgocount68, 1
  store i64 %76, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 55), align 8
  %77 = call i32 @puts(ptr @.str.6)
  %widen61 = sext i32 %77 to i64
  br label %ifcont57

if_else60:                                        ; preds = %ifcont31
  %pgocount69 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 56), align 8
  %78 = add i64 %pgocount69, 1
  store i64 %78, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 56), align 8
  br label %ifcont57

ifcont74:                                         ; preds = %if_else77, %if_then76
  %pgocount70 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 75), align 8
  %79 = add i64 %pgocount70, 1
  store i64 %79, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 75), align 8
  %pgocount71 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 76), align 8
  %80 = add i64 %pgocount71, 1
  store i64 %80, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 76), align 8
  %pgocount72 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 77), align 8
  %81 = add i64 %pgocount72, 1
  store i64 %81, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 77), align 8
  %pgocount73 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 78), align 8
  %82 = add i64 %pgocount73, 1
  store i64 %82, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 78), align 8
  %pgocount74 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 79), align 8
  %83 = add i64 %pgocount74, 1
  store i64 %83, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 79), align 8
  br i1 true, label %if_then80, label %if_else81

if_then76:                                        ; preds = %ifcont57
  %pgocount75 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 70), align 8
  %84 = add i64 %pgocount75, 1
  store i64 %84, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 70), align 8
  %pgocount76 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 71), align 8
  %85 = add i64 %pgocount76, 1
  store i64 %85, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 71), align 8
  %pgocount77 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 72), align 8
  %86 = add i64 %pgocount77, 1
  store i64 %86, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 72), align 8
  %pgocount78 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 73), align 8
  %87 = add i64 %pgocount78, 1
  store i64 %87, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 73), align 8
  %88 = call i32 @puts(ptr @.str.7)
  %widen78 = sext i32 %88 to i64
  br label %ifcont74

if_else77:                                        ; preds = %ifcont57
  %pgocount79 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 74), align 8
  %89 = add i64 %pgocount79, 1
  store i64 %89, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 74), align 8
  br label %ifcont74

ifcont79:                                         ; preds = %if_else81, %if_then80
  %pgocount80 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 85), align 8
  %90 = add i64 %pgocount80, 1
  store i64 %90, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 85), align 8
  %pgocount81 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 86), align 8
  %91 = add i64 %pgocount81, 1
  store i64 %91, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 86), align 8
  %pgocount82 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 87), align 8
  %92 = add i64 %pgocount82, 1
  store i64 %92, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 87), align 8
  %pgocount83 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 88), align 8
  %93 = add i64 %pgocount83, 1
  store i64 %93, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 88), align 8
  %x83 = load i64, ptr %x, align 8
  %pgocount84 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 89), align 8
  %94 = add i64 %pgocount84, 1
  store i64 %94, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 89), align 8
  %eq84 = icmp eq i64 %x83, 3
  %eq_ext85 = zext i1 %eq84 to i64
  %in_or86 = or i64 %eq_ext85, 0
  %if_cond88 = icmp ne i64 %in_or86, 0
  br i1 %if_cond88, label %if_then89, label %if_else90

if_then80:                                        ; preds = %ifcont74
  %pgocount85 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 80), align 8
  %95 = add i64 %pgocount85, 1
  store i64 %95, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 80), align 8
  %pgocount86 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 81), align 8
  %96 = add i64 %pgocount86, 1
  store i64 %96, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 81), align 8
  %pgocount87 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 82), align 8
  %97 = add i64 %pgocount87, 1
  store i64 %97, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 82), align 8
  %pgocount88 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 83), align 8
  %98 = add i64 %pgocount88, 1
  store i64 %98, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 83), align 8
  %99 = call i32 @puts(ptr @.str.8)
  %widen82 = sext i32 %99 to i64
  br label %ifcont79

if_else81:                                        ; preds = %ifcont74
  %pgocount89 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 84), align 8
  %100 = add i64 %pgocount89, 1
  store i64 %100, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 84), align 8
  br label %ifcont79

ifcont87:                                         ; preds = %if_else90, %if_then89
  %pgocount90 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 95), align 8
  %101 = add i64 %pgocount90, 1
  store i64 %101, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 95), align 8
  %pgocount91 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 96), align 8
  %102 = add i64 %pgocount91, 1
  store i64 %102, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 96), align 8
  store i64 2, ptr %a, align 8
  %pgocount92 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 97), align 8
  %103 = add i64 %pgocount92, 1
  store i64 %103, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 97), align 8
  %pgocount93 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 98), align 8
  %104 = add i64 %pgocount93, 1
  store i64 %104, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 98), align 8
  %pgocount94 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 99), align 8
  %105 = add i64 %pgocount94, 1
  store i64 %105, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 99), align 8
  %pgocount95 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 100), align 8
  %106 = add i64 %pgocount95, 1
  store i64 %106, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 100), align 8
  %x92 = load i64, ptr %x, align 8
  %pgocount96 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 101), align 8
  %107 = add i64 %pgocount96, 1
  store i64 %107, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 101), align 8
  %pgocount97 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 102), align 8
  %108 = add i64 %pgocount97, 1
  store i64 %108, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 102), align 8
  %a93 = load i64, ptr %a, align 8
  %pgocount98 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 103), align 8
  %109 = add i64 %pgocount98, 1
  store i64 %109, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 103), align 8
  %add = add i64 %a93, 1
  %eq94 = icmp eq i64 %x92, %add
  %eq_ext95 = zext i1 %eq94 to i64
  %pgocount99 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 104), align 8
  %110 = add i64 %pgocount99, 1
  store i64 %110, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 104), align 8
  %x96 = load i64, ptr %x, align 8
  %pgocount100 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 105), align 8
  %111 = add i64 %pgocount100, 1
  store i64 %111, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 105), align 8
  %pgocount101 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 106), align 8
  %112 = add i64 %pgocount101, 1
  store i64 %112, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 106), align 8
  %a97 = load i64, ptr %a, align 8
  %pgocount102 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 107), align 8
  %113 = add i64 %pgocount102, 1
  store i64 %113, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 107), align 8
  %mul = mul i64 %a97, 2
  %eq98 = icmp eq i64 %x96, %mul
  %eq_ext99 = zext i1 %eq98 to i64
  %pgocount103 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 108), align 8
  %114 = add i64 %pgocount103, 1
  store i64 %114, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 108), align 8
  %x100 = load i64, ptr %x, align 8
  %pgocount104 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 109), align 8
  %115 = add i64 %pgocount104, 1
  store i64 %115, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 109), align 8
  %eq101 = icmp eq i64 %x100, 10
  %eq_ext102 = zext i1 %eq101 to i64
  %in_or103 = or i64 %eq_ext102, 0
  %in_or104 = or i64 %eq_ext99, %in_or103
  %in_or105 = or i64 %eq_ext95, %in_or104
  %if_cond107 = icmp ne i64 %in_or105, 0
  br i1 %if_cond107, label %if_then108, label %if_else109

if_then89:                                        ; preds = %ifcont79
  %pgocount105 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 90), align 8
  %116 = add i64 %pgocount105, 1
  store i64 %116, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 90), align 8
  %pgocount106 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 91), align 8
  %117 = add i64 %pgocount106, 1
  store i64 %117, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 91), align 8
  %pgocount107 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 92), align 8
  %118 = add i64 %pgocount107, 1
  store i64 %118, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 92), align 8
  %pgocount108 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 93), align 8
  %119 = add i64 %pgocount108, 1
  store i64 %119, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 93), align 8
  %120 = call i32 @puts(ptr @.str.9)
  %widen91 = sext i32 %120 to i64
  br label %ifcont87

if_else90:                                        ; preds = %ifcont79
  %pgocount109 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 94), align 8
  %121 = add i64 %pgocount109, 1
  store i64 %121, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 94), align 8
  br label %ifcont87

ifcont106:                                        ; preds = %if_else109, %if_then108
  %pgocount110 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 115), align 8
  %122 = add i64 %pgocount110, 1
  store i64 %122, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 115), align 8
  %pgocount111 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 116), align 8
  %123 = add i64 %pgocount111, 1
  store i64 %123, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 116), align 8
  %pgocount112 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 117), align 8
  %124 = add i64 %pgocount112, 1
  store i64 %124, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 117), align 8
  %pgocount113 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 118), align 8
  %125 = add i64 %pgocount113, 1
  store i64 %125, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 118), align 8
  %pgocount114 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 119), align 8
  %126 = add i64 %pgocount114, 1
  store i64 %126, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 119), align 8
  %x111 = load i64, ptr %x, align 8
  %pgocount115 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 120), align 8
  %127 = add i64 %pgocount115, 1
  store i64 %127, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 120), align 8
  %eq112 = icmp eq i64 %x111, 1
  %eq_ext113 = zext i1 %eq112 to i64
  %pgocount116 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 121), align 8
  %128 = add i64 %pgocount116, 1
  store i64 %128, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 121), align 8
  %x114 = load i64, ptr %x, align 8
  %pgocount117 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 122), align 8
  %129 = add i64 %pgocount117, 1
  store i64 %129, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 122), align 8
  %eq115 = icmp eq i64 %x114, 2
  %eq_ext116 = zext i1 %eq115 to i64
  %pgocount118 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 123), align 8
  %130 = add i64 %pgocount118, 1
  store i64 %130, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 123), align 8
  %x117 = load i64, ptr %x, align 8
  %pgocount119 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 124), align 8
  %131 = add i64 %pgocount119, 1
  store i64 %131, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 124), align 8
  %eq118 = icmp eq i64 %x117, 3
  %eq_ext119 = zext i1 %eq118 to i64
  %in_or120 = or i64 %eq_ext119, 0
  %in_or121 = or i64 %eq_ext116, %in_or120
  %in_or122 = or i64 %eq_ext113, %in_or121
  %ife_cond = icmp ne i64 %in_or122, 0
  br i1 %ife_cond, label %ife_then, label %ife_else

if_then108:                                       ; preds = %ifcont87
  %pgocount120 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 110), align 8
  %132 = add i64 %pgocount120, 1
  store i64 %132, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 110), align 8
  %pgocount121 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 111), align 8
  %133 = add i64 %pgocount121, 1
  store i64 %133, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 111), align 8
  %pgocount122 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 112), align 8
  %134 = add i64 %pgocount122, 1
  store i64 %134, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 112), align 8
  %pgocount123 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 113), align 8
  %135 = add i64 %pgocount123, 1
  store i64 %135, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 113), align 8
  %136 = call i32 @puts(ptr @.str.10)
  %widen110 = sext i32 %136 to i64
  br label %ifcont106

if_else109:                                       ; preds = %ifcont87
  %pgocount124 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 114), align 8
  %137 = add i64 %pgocount124, 1
  store i64 %137, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 114), align 8
  br label %ifcont106

ife_end:                                          ; preds = %ife_else, %ife_then
  %ife_val = load i64, ptr %ife_result, align 8
  %cast123 = inttoptr i64 %ife_val to ptr
  store ptr %cast123, ptr %label, align 8
  %pgocount125 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 131), align 8
  %138 = add i64 %pgocount125, 1
  store i64 %138, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 131), align 8
  %pgocount126 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 132), align 8
  %139 = add i64 %pgocount126, 1
  store i64 %139, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 132), align 8
  %pgocount127 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 133), align 8
  %140 = add i64 %pgocount127, 1
  store i64 %140, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 133), align 8
  %pgocount128 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 134), align 8
  %141 = add i64 %pgocount128, 1
  store i64 %141, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 134), align 8
  %label124 = load ptr, ptr %label, align 8
  %pgocount129 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 135), align 8
  %142 = add i64 %pgocount129, 1
  store i64 %142, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 135), align 8
  %143 = call i32 @strcmp(ptr %label124, ptr @.str.13)
  %widen125 = sext i32 %143 to i64
  %streq_cmp126 = icmp eq i64 %widen125, 0
  %streq_ext127 = zext i1 %streq_cmp126 to i64
  %if_cond129 = icmp ne i64 %streq_ext127, 0
  br i1 %if_cond129, label %if_then130, label %if_else131

ife_then:                                         ; preds = %ifcont106
  %pgocount130 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 125), align 8
  %144 = add i64 %pgocount130, 1
  store i64 %144, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 125), align 8
  %pgocount131 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 126), align 8
  %145 = add i64 %pgocount131, 1
  store i64 %145, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 126), align 8
  %pgocount132 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 127), align 8
  %146 = add i64 %pgocount132, 1
  store i64 %146, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 127), align 8
  store i64 ptrtoint (ptr @.str.11 to i64), ptr %ife_result, align 8
  br label %ife_end

ife_else:                                         ; preds = %ifcont106
  %pgocount133 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 128), align 8
  %147 = add i64 %pgocount133, 1
  store i64 %147, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 128), align 8
  %pgocount134 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 129), align 8
  %148 = add i64 %pgocount134, 1
  store i64 %148, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 129), align 8
  %pgocount135 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 130), align 8
  %149 = add i64 %pgocount135, 1
  store i64 %149, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 130), align 8
  store i64 ptrtoint (ptr @.str.12 to i64), ptr %ife_result, align 8
  br label %ife_end

ifcont128:                                        ; preds = %if_else131, %if_then130
  %pgocount136 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 141), align 8
  %150 = add i64 %pgocount136, 1
  store i64 %150, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 141), align 8
  %pgocount137 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 142), align 8
  %151 = add i64 %pgocount137, 1
  store i64 %151, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 142), align 8
  store i64 0, ptr %when_result, align 8
  %pgocount138 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 143), align 8
  %152 = add i64 %pgocount138, 1
  store i64 %152, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 143), align 8
  %pgocount139 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 144), align 8
  %153 = add i64 %pgocount139, 1
  store i64 %153, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 144), align 8
  %pgocount140 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 145), align 8
  %154 = add i64 %pgocount140, 1
  store i64 %154, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 145), align 8
  %x133 = load i64, ptr %x, align 8
  %pgocount141 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 146), align 8
  %155 = add i64 %pgocount141, 1
  store i64 %155, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 146), align 8
  %eq134 = icmp eq i64 %x133, 10
  %eq_ext135 = zext i1 %eq134 to i64
  %pgocount142 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 147), align 8
  %156 = add i64 %pgocount142, 1
  store i64 %156, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 147), align 8
  %x136 = load i64, ptr %x, align 8
  %pgocount143 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 148), align 8
  %157 = add i64 %pgocount143, 1
  store i64 %157, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 148), align 8
  %eq137 = icmp eq i64 %x136, 20
  %eq_ext138 = zext i1 %eq137 to i64
  %pgocount144 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 149), align 8
  %158 = add i64 %pgocount144, 1
  store i64 %158, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 149), align 8
  %x139 = load i64, ptr %x, align 8
  %pgocount145 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 150), align 8
  %159 = add i64 %pgocount145, 1
  store i64 %159, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 150), align 8
  %eq140 = icmp eq i64 %x139, 30
  %eq_ext141 = zext i1 %eq140 to i64
  %in_or142 = or i64 %eq_ext141, 0
  %in_or143 = or i64 %eq_ext138, %in_or142
  %in_or144 = or i64 %eq_ext135, %in_or143
  %when_cond = icmp ne i64 %in_or144, 0
  br i1 %when_cond, label %when_arm, label %when_next

if_then130:                                       ; preds = %ife_end
  %pgocount146 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 136), align 8
  %160 = add i64 %pgocount146, 1
  store i64 %160, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 136), align 8
  %pgocount147 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 137), align 8
  %161 = add i64 %pgocount147, 1
  store i64 %161, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 137), align 8
  %pgocount148 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 138), align 8
  %162 = add i64 %pgocount148, 1
  store i64 %162, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 138), align 8
  %pgocount149 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 139), align 8
  %163 = add i64 %pgocount149, 1
  store i64 %163, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 139), align 8
  %164 = call i32 @puts(ptr @.str.14)
  %widen132 = sext i32 %164 to i64
  br label %ifcont128

if_else131:                                       ; preds = %ife_end
  %pgocount150 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 140), align 8
  %165 = add i64 %pgocount150, 1
  store i64 %165, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 140), align 8
  br label %ifcont128

when_end:                                         ; preds = %when_next167, %when_arm166, %when_arm
  %when_val = load i64, ptr %when_result, align 8
  %cast168 = inttoptr i64 %when_val to ptr
  store ptr %cast168, ptr %result, align 8
  %pgocount151 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 167), align 8
  %166 = add i64 %pgocount151, 1
  store i64 %166, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 167), align 8
  %pgocount152 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 168), align 8
  %167 = add i64 %pgocount152, 1
  store i64 %167, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 168), align 8
  %pgocount153 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 169), align 8
  %168 = add i64 %pgocount153, 1
  store i64 %168, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 169), align 8
  %pgocount154 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 170), align 8
  %169 = add i64 %pgocount154, 1
  store i64 %169, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 170), align 8
  %result169 = load ptr, ptr %result, align 8
  %pgocount155 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 171), align 8
  %170 = add i64 %pgocount155, 1
  store i64 %170, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 171), align 8
  %171 = call i32 @strcmp(ptr %result169, ptr @.str.18)
  %widen170 = sext i32 %171 to i64
  %streq_cmp171 = icmp eq i64 %widen170, 0
  %streq_ext172 = zext i1 %streq_cmp171 to i64
  %if_cond174 = icmp ne i64 %streq_ext172, 0
  br i1 %if_cond174, label %if_then175, label %if_else176

when_arm:                                         ; preds = %ifcont128
  %pgocount156 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 151), align 8
  %172 = add i64 %pgocount156, 1
  store i64 %172, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 151), align 8
  store i64 ptrtoint (ptr @.str.15 to i64), ptr %when_result, align 8
  br label %when_end

when_next:                                        ; preds = %ifcont128
  %pgocount157 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 152), align 8
  %173 = add i64 %pgocount157, 1
  store i64 %173, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 152), align 8
  %pgocount158 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 153), align 8
  %174 = add i64 %pgocount158, 1
  store i64 %174, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 153), align 8
  %pgocount159 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 154), align 8
  %175 = add i64 %pgocount159, 1
  store i64 %175, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 154), align 8
  %x145 = load i64, ptr %x, align 8
  %pgocount160 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 155), align 8
  %176 = add i64 %pgocount160, 1
  store i64 %176, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 155), align 8
  %eq146 = icmp eq i64 %x145, 1
  %eq_ext147 = zext i1 %eq146 to i64
  %pgocount161 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 156), align 8
  %177 = add i64 %pgocount161, 1
  store i64 %177, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 156), align 8
  %x148 = load i64, ptr %x, align 8
  %pgocount162 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 157), align 8
  %178 = add i64 %pgocount162, 1
  store i64 %178, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 157), align 8
  %eq149 = icmp eq i64 %x148, 2
  %eq_ext150 = zext i1 %eq149 to i64
  %pgocount163 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 158), align 8
  %179 = add i64 %pgocount163, 1
  store i64 %179, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 158), align 8
  %x151 = load i64, ptr %x, align 8
  %pgocount164 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 159), align 8
  %180 = add i64 %pgocount164, 1
  store i64 %180, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 159), align 8
  %eq152 = icmp eq i64 %x151, 3
  %eq_ext153 = zext i1 %eq152 to i64
  %pgocount165 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 160), align 8
  %181 = add i64 %pgocount165, 1
  store i64 %181, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 160), align 8
  %x154 = load i64, ptr %x, align 8
  %pgocount166 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 161), align 8
  %182 = add i64 %pgocount166, 1
  store i64 %182, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 161), align 8
  %eq155 = icmp eq i64 %x154, 4
  %eq_ext156 = zext i1 %eq155 to i64
  %pgocount167 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 162), align 8
  %183 = add i64 %pgocount167, 1
  store i64 %183, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 162), align 8
  %x157 = load i64, ptr %x, align 8
  %pgocount168 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 163), align 8
  %184 = add i64 %pgocount168, 1
  store i64 %184, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 163), align 8
  %eq158 = icmp eq i64 %x157, 5
  %eq_ext159 = zext i1 %eq158 to i64
  %in_or160 = or i64 %eq_ext159, 0
  %in_or161 = or i64 %eq_ext156, %in_or160
  %in_or162 = or i64 %eq_ext153, %in_or161
  %in_or163 = or i64 %eq_ext150, %in_or162
  %in_or164 = or i64 %eq_ext147, %in_or163
  %when_cond165 = icmp ne i64 %in_or164, 0
  br i1 %when_cond165, label %when_arm166, label %when_next167

when_arm166:                                      ; preds = %when_next
  %pgocount169 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 164), align 8
  %185 = add i64 %pgocount169, 1
  store i64 %185, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 164), align 8
  store i64 ptrtoint (ptr @.str.16 to i64), ptr %when_result, align 8
  br label %when_end

when_next167:                                     ; preds = %when_next
  %pgocount170 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 165), align 8
  %186 = add i64 %pgocount170, 1
  store i64 %186, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 165), align 8
  %pgocount171 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 166), align 8
  %187 = add i64 %pgocount171, 1
  store i64 %187, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 166), align 8
  store i64 ptrtoint (ptr @.str.17 to i64), ptr %when_result, align 8
  br label %when_end

ifcont173:                                        ; preds = %if_else176, %if_then175
  %pgocount172 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 177), align 8
  %188 = add i64 %pgocount172, 1
  store i64 %188, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 177), align 8
  %pgocount173 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 178), align 8
  %189 = add i64 %pgocount173, 1
  store i64 %189, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 178), align 8
  %pgocount174 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 179), align 8
  %190 = add i64 %pgocount174, 1
  store i64 %190, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 179), align 8
  %pgocount175 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 180), align 8
  %191 = add i64 %pgocount175, 1
  store i64 %191, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 180), align 8
  %x178 = load i64, ptr %x, align 8
  %pgocount176 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 181), align 8
  %192 = add i64 %pgocount176, 1
  store i64 %192, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 181), align 8
  %eq179 = icmp eq i64 %x178, 1
  %eq_ext180 = zext i1 %eq179 to i64
  %pgocount177 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 182), align 8
  %193 = add i64 %pgocount177, 1
  store i64 %193, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 182), align 8
  %x181 = load i64, ptr %x, align 8
  %pgocount178 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 183), align 8
  %194 = add i64 %pgocount178, 1
  store i64 %194, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 183), align 8
  %eq182 = icmp eq i64 %x181, 2
  %eq_ext183 = zext i1 %eq182 to i64
  %pgocount179 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 184), align 8
  %195 = add i64 %pgocount179, 1
  store i64 %195, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 184), align 8
  %x184 = load i64, ptr %x, align 8
  %pgocount180 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 185), align 8
  %196 = add i64 %pgocount180, 1
  store i64 %196, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 185), align 8
  %eq185 = icmp eq i64 %x184, 3
  %eq_ext186 = zext i1 %eq185 to i64
  %in_or187 = or i64 %eq_ext186, 0
  %in_or188 = or i64 %eq_ext183, %in_or187
  %in_or189 = or i64 %eq_ext180, %in_or188
  %l_bool = icmp ne i64 %in_or189, 0
  br i1 %l_bool, label %sc_rhs, label %sc_short

if_then175:                                       ; preds = %when_end
  %pgocount181 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 172), align 8
  %197 = add i64 %pgocount181, 1
  store i64 %197, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 172), align 8
  %pgocount182 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 173), align 8
  %198 = add i64 %pgocount182, 1
  store i64 %198, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 173), align 8
  %pgocount183 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 174), align 8
  %199 = add i64 %pgocount183, 1
  store i64 %199, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 174), align 8
  %pgocount184 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 175), align 8
  %200 = add i64 %pgocount184, 1
  store i64 %200, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 175), align 8
  %201 = call i32 @puts(ptr @.str.19)
  %widen177 = sext i32 %201 to i64
  br label %ifcont173

if_else176:                                       ; preds = %when_end
  %pgocount185 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 176), align 8
  %202 = add i64 %pgocount185, 1
  store i64 %202, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 176), align 8
  br label %ifcont173

sc_rhs:                                           ; preds = %ifcont173
  %pgocount186 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 187), align 8
  %203 = add i64 %pgocount186, 1
  store i64 %203, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 187), align 8
  %pgocount187 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 188), align 8
  %204 = add i64 %pgocount187, 1
  store i64 %204, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 188), align 8
  %pgocount188 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 189), align 8
  %205 = add i64 %pgocount188, 1
  store i64 %205, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 189), align 8
  %s190 = load ptr, ptr %s, align 8
  %pgocount189 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 190), align 8
  %206 = add i64 %pgocount189, 1
  store i64 %206, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 190), align 8
  %207 = call i32 @strcmp(ptr %s190, ptr @.str.20)
  %widen191 = sext i32 %207 to i64
  %streq_cmp192 = icmp eq i64 %widen191, 0
  %streq_ext193 = zext i1 %streq_cmp192 to i64
  %pgocount190 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 191), align 8
  %208 = add i64 %pgocount190, 1
  store i64 %208, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 191), align 8
  %s194 = load ptr, ptr %s, align 8
  %pgocount191 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 192), align 8
  %209 = add i64 %pgocount191, 1
  store i64 %209, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 192), align 8
  %210 = call i32 @strcmp(ptr %s194, ptr @.str.21)
  %widen195 = sext i32 %210 to i64
  %streq_cmp196 = icmp eq i64 %widen195, 0
  %streq_ext197 = zext i1 %streq_cmp196 to i64
  %in_or198 = or i64 %streq_ext197, 0
  %in_or199 = or i64 %streq_ext193, %in_or198
  %r_bool = icmp ne i64 %in_or199, 0
  br i1 %r_bool, label %sc_r_true, label %sc_r_false

sc_short:                                         ; preds = %ifcont173
  %pgocount192 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 186), align 8
  %211 = add i64 %pgocount192, 1
  store i64 %211, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 186), align 8
  br label %sc_merge

sc_merge:                                         ; preds = %sc_r_merge, %sc_short
  %sc_phi = phi i1 [ false, %sc_short ], [ %r_bool, %sc_r_merge ]
  %sc_ext = zext i1 %sc_phi to i64
  %sif_cond = icmp ne i64 %sc_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

sc_r_true:                                        ; preds = %sc_rhs
  %pgocount193 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 193), align 8
  %212 = add i64 %pgocount193, 1
  store i64 %212, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 193), align 8
  br label %sc_r_merge

sc_r_false:                                       ; preds = %sc_rhs
  %pgocount194 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 194), align 8
  %213 = add i64 %pgocount194, 1
  store i64 %213, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 194), align 8
  br label %sc_r_merge

sc_r_merge:                                       ; preds = %sc_r_false, %sc_r_true
  br label %sc_merge

sif_then:                                         ; preds = %sc_merge
  %pgocount195 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 195), align 8
  %214 = add i64 %pgocount195, 1
  store i64 %214, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 195), align 8
  %pgocount196 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 196), align 8
  %215 = add i64 %pgocount196, 1
  store i64 %215, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 196), align 8
  %216 = call i32 @puts(ptr @.str.22)
  %widen200 = sext i32 %216 to i64
  store i64 0, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %sc_merge
  %pgocount197 = load i64, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 197), align 8
  %217 = add i64 %pgocount197, 1
  store i64 %217, ptr getelementptr inbounds ([198 x i64], ptr @__profc_main, i32 0, i32 197), align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  ret i64 %sif_val
}

define i64 @__bs_top_level() {
entry:
  %pgocount = load i64, ptr getelementptr inbounds ([199 x i64], ptr @__profc___bs_top_level, i32 0, i32 198), align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr getelementptr inbounds ([199 x i64], ptr @__profc___bs_top_level, i32 0, i32 198), align 8
  %1 = call i32 @forge_test_summary()
  %widen = sext i32 %1 to i64
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
