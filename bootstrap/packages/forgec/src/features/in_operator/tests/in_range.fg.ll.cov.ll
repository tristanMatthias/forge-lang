; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/in_operator/tests/in_range.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"9\00", align 1
@.str.2 = private unnamed_addr constant [6 x i8] c"digit\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"z\00", align 1
@.str.5 = private unnamed_addr constant [6 x i8] c"lower\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"A\00", align 1
@.str.7 = private unnamed_addr constant [2 x i8] c"Z\00", align 1
@.str.8 = private unnamed_addr constant [6 x i8] c"upper\00", align 1
@.str.9 = private unnamed_addr constant [6 x i8] c"other\00", align 1
@.str.10 = private unnamed_addr constant [2 x i8] c"5\00", align 1
@.str.11 = private unnamed_addr constant [2 x i8] c"m\00", align 1
@.str.12 = private unnamed_addr constant [2 x i8] c"G\00", align 1
@.str.13 = private unnamed_addr constant [2 x i8] c"!\00", align 1
@.str.14 = private unnamed_addr constant [9 x i8] c"in_range\00", align 1
@.str.15 = private unnamed_addr constant [13 x i8] c"not_in_range\00", align 1
@.str.16 = private unnamed_addr constant [13 x i8] c"boundary_low\00", align 1
@.str.17 = private unnamed_addr constant [14 x i8] c"boundary_high\00", align 1
@.str.18 = private unnamed_addr constant [2 x i8] c"A\00", align 1
@.str.19 = private unnamed_addr constant [2 x i8] c"B\00", align 1
@.str.20 = private unnamed_addr constant [2 x i8] c"C\00", align 1
@.str.21 = private unnamed_addr constant [2 x i8] c"F\00", align 1
@.str.22 = private unnamed_addr constant [2 x i8] c"B\00", align 1
@.str.23 = private unnamed_addr constant [12 x i8] c"match_range\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_classify = private global [44 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_classify = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -6761552294068852299, i64 7572247415914819, i64 sub (i64 ptrtoint (ptr @__profc_classify to i64), i64 ptrtoint (ptr @__profd_classify to i64)), i64 0, ptr null, ptr null, i32 44, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_main = private global [145 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 145, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__llvm_prf_nm = private constant [23 x i8] c"\0D\15x\DAK\CEI,.\CEL\ABd\CCM\CC\CC\03\00#\DC\05\05", section "__DATA,__llvm_prf_names", align 1
@llvm.compiler.used = appending global [3 x ptr] [ptr @__llvm_profile_runtime_user, ptr @__profd_classify, ptr @__profd_main], section "llvm.metadata"
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

define ptr @classify(ptr %0) {
entry:
  %when_result = alloca i64, align 8
  %ch = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_classify, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_classify, align 8
  store ptr %0, ptr %ch, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 2), align 8
  store i64 0, ptr %when_result, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 4), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 5), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 5), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 6), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 6), align 8
  %ch1 = load ptr, ptr %ch, align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 7), align 8
  %8 = add i64 %pgocount7, 1
  store i64 %8, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 7), align 8
  %9 = call i32 @strcmp(ptr %ch1, ptr @.str)
  %widen = sext i32 %9 to i64
  %scmp_cmp = icmp sge i64 %widen, 0
  %scmp_ext = zext i1 %scmp_cmp to i64
  %l_bool = icmp ne i64 %scmp_ext, 0
  br i1 %l_bool, label %sc_rhs, label %sc_short

when_end:                                         ; preds = %when_next47, %when_arm46, %when_arm25, %when_arm
  %when_val = load i64, ptr %when_result, align 8
  %cast = inttoptr i64 %when_val to ptr
  ret ptr %cast

sc_rhs:                                           ; preds = %entry
  %pgocount8 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 9), align 8
  %10 = add i64 %pgocount8, 1
  store i64 %10, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 9), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 10), align 8
  %11 = add i64 %pgocount9, 1
  store i64 %11, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 10), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 11), align 8
  %12 = add i64 %pgocount10, 1
  store i64 %12, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 11), align 8
  %ch2 = load ptr, ptr %ch, align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 12), align 8
  %13 = add i64 %pgocount11, 1
  store i64 %13, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 12), align 8
  %14 = call i32 @strcmp(ptr %ch2, ptr @.str.1)
  %widen3 = sext i32 %14 to i64
  %scmp_cmp4 = icmp sle i64 %widen3, 0
  %scmp_ext5 = zext i1 %scmp_cmp4 to i64
  %r_bool = icmp ne i64 %scmp_ext5, 0
  br i1 %r_bool, label %sc_r_true, label %sc_r_false

sc_short:                                         ; preds = %entry
  %pgocount12 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 8), align 8
  %15 = add i64 %pgocount12, 1
  store i64 %15, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 8), align 8
  br label %sc_merge

sc_merge:                                         ; preds = %sc_r_merge, %sc_short
  %sc_phi = phi i1 [ false, %sc_short ], [ %r_bool, %sc_r_merge ]
  %sc_ext = zext i1 %sc_phi to i64
  %when_cond = icmp ne i64 %sc_ext, 0
  br i1 %when_cond, label %when_arm, label %when_next

sc_r_true:                                        ; preds = %sc_rhs
  %pgocount13 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 13), align 8
  %16 = add i64 %pgocount13, 1
  store i64 %16, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 13), align 8
  br label %sc_r_merge

sc_r_false:                                       ; preds = %sc_rhs
  %pgocount14 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 14), align 8
  %17 = add i64 %pgocount14, 1
  store i64 %17, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 14), align 8
  br label %sc_r_merge

sc_r_merge:                                       ; preds = %sc_r_false, %sc_r_true
  br label %sc_merge

when_arm:                                         ; preds = %sc_merge
  %pgocount15 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 15), align 8
  %18 = add i64 %pgocount15, 1
  store i64 %18, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 15), align 8
  store i64 ptrtoint (ptr @.str.2 to i64), ptr %when_result, align 8
  br label %when_end

when_next:                                        ; preds = %sc_merge
  %pgocount16 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 16), align 8
  %19 = add i64 %pgocount16, 1
  store i64 %19, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 16), align 8
  %pgocount17 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 17), align 8
  %20 = add i64 %pgocount17, 1
  store i64 %20, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 17), align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 18), align 8
  %21 = add i64 %pgocount18, 1
  store i64 %21, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 18), align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 19), align 8
  %22 = add i64 %pgocount19, 1
  store i64 %22, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 19), align 8
  %ch6 = load ptr, ptr %ch, align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 20), align 8
  %23 = add i64 %pgocount20, 1
  store i64 %23, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 20), align 8
  %24 = call i32 @strcmp(ptr %ch6, ptr @.str.3)
  %widen7 = sext i32 %24 to i64
  %scmp_cmp8 = icmp sge i64 %widen7, 0
  %scmp_ext9 = zext i1 %scmp_cmp8 to i64
  %l_bool10 = icmp ne i64 %scmp_ext9, 0
  br i1 %l_bool10, label %sc_rhs11, label %sc_short12

sc_rhs11:                                         ; preds = %when_next
  %pgocount21 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 22), align 8
  %25 = add i64 %pgocount21, 1
  store i64 %25, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 22), align 8
  %pgocount22 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 23), align 8
  %26 = add i64 %pgocount22, 1
  store i64 %26, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 23), align 8
  %pgocount23 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 24), align 8
  %27 = add i64 %pgocount23, 1
  store i64 %27, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 24), align 8
  %ch14 = load ptr, ptr %ch, align 8
  %pgocount24 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 25), align 8
  %28 = add i64 %pgocount24, 1
  store i64 %28, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 25), align 8
  %29 = call i32 @strcmp(ptr %ch14, ptr @.str.4)
  %widen15 = sext i32 %29 to i64
  %scmp_cmp16 = icmp sle i64 %widen15, 0
  %scmp_ext17 = zext i1 %scmp_cmp16 to i64
  %r_bool18 = icmp ne i64 %scmp_ext17, 0
  br i1 %r_bool18, label %sc_r_true19, label %sc_r_false20

sc_short12:                                       ; preds = %when_next
  %pgocount25 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 21), align 8
  %30 = add i64 %pgocount25, 1
  store i64 %30, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 21), align 8
  br label %sc_merge13

sc_merge13:                                       ; preds = %sc_r_merge21, %sc_short12
  %sc_phi22 = phi i1 [ false, %sc_short12 ], [ %r_bool18, %sc_r_merge21 ]
  %sc_ext23 = zext i1 %sc_phi22 to i64
  %when_cond24 = icmp ne i64 %sc_ext23, 0
  br i1 %when_cond24, label %when_arm25, label %when_next26

sc_r_true19:                                      ; preds = %sc_rhs11
  %pgocount26 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 26), align 8
  %31 = add i64 %pgocount26, 1
  store i64 %31, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 26), align 8
  br label %sc_r_merge21

sc_r_false20:                                     ; preds = %sc_rhs11
  %pgocount27 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 27), align 8
  %32 = add i64 %pgocount27, 1
  store i64 %32, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 27), align 8
  br label %sc_r_merge21

sc_r_merge21:                                     ; preds = %sc_r_false20, %sc_r_true19
  br label %sc_merge13

when_arm25:                                       ; preds = %sc_merge13
  %pgocount28 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 28), align 8
  %33 = add i64 %pgocount28, 1
  store i64 %33, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 28), align 8
  store i64 ptrtoint (ptr @.str.5 to i64), ptr %when_result, align 8
  br label %when_end

when_next26:                                      ; preds = %sc_merge13
  %pgocount29 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 29), align 8
  %34 = add i64 %pgocount29, 1
  store i64 %34, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 29), align 8
  %pgocount30 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 30), align 8
  %35 = add i64 %pgocount30, 1
  store i64 %35, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 30), align 8
  %pgocount31 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 31), align 8
  %36 = add i64 %pgocount31, 1
  store i64 %36, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 31), align 8
  %pgocount32 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 32), align 8
  %37 = add i64 %pgocount32, 1
  store i64 %37, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 32), align 8
  %ch27 = load ptr, ptr %ch, align 8
  %pgocount33 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 33), align 8
  %38 = add i64 %pgocount33, 1
  store i64 %38, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 33), align 8
  %39 = call i32 @strcmp(ptr %ch27, ptr @.str.6)
  %widen28 = sext i32 %39 to i64
  %scmp_cmp29 = icmp sge i64 %widen28, 0
  %scmp_ext30 = zext i1 %scmp_cmp29 to i64
  %l_bool31 = icmp ne i64 %scmp_ext30, 0
  br i1 %l_bool31, label %sc_rhs32, label %sc_short33

sc_rhs32:                                         ; preds = %when_next26
  %pgocount34 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 35), align 8
  %40 = add i64 %pgocount34, 1
  store i64 %40, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 35), align 8
  %pgocount35 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 36), align 8
  %41 = add i64 %pgocount35, 1
  store i64 %41, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 36), align 8
  %pgocount36 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 37), align 8
  %42 = add i64 %pgocount36, 1
  store i64 %42, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 37), align 8
  %ch35 = load ptr, ptr %ch, align 8
  %pgocount37 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 38), align 8
  %43 = add i64 %pgocount37, 1
  store i64 %43, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 38), align 8
  %44 = call i32 @strcmp(ptr %ch35, ptr @.str.7)
  %widen36 = sext i32 %44 to i64
  %scmp_cmp37 = icmp sle i64 %widen36, 0
  %scmp_ext38 = zext i1 %scmp_cmp37 to i64
  %r_bool39 = icmp ne i64 %scmp_ext38, 0
  br i1 %r_bool39, label %sc_r_true40, label %sc_r_false41

sc_short33:                                       ; preds = %when_next26
  %pgocount38 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 34), align 8
  %45 = add i64 %pgocount38, 1
  store i64 %45, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 34), align 8
  br label %sc_merge34

sc_merge34:                                       ; preds = %sc_r_merge42, %sc_short33
  %sc_phi43 = phi i1 [ false, %sc_short33 ], [ %r_bool39, %sc_r_merge42 ]
  %sc_ext44 = zext i1 %sc_phi43 to i64
  %when_cond45 = icmp ne i64 %sc_ext44, 0
  br i1 %when_cond45, label %when_arm46, label %when_next47

sc_r_true40:                                      ; preds = %sc_rhs32
  %pgocount39 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 39), align 8
  %46 = add i64 %pgocount39, 1
  store i64 %46, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 39), align 8
  br label %sc_r_merge42

sc_r_false41:                                     ; preds = %sc_rhs32
  %pgocount40 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 40), align 8
  %47 = add i64 %pgocount40, 1
  store i64 %47, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 40), align 8
  br label %sc_r_merge42

sc_r_merge42:                                     ; preds = %sc_r_false41, %sc_r_true40
  br label %sc_merge34

when_arm46:                                       ; preds = %sc_merge34
  %pgocount41 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 41), align 8
  %48 = add i64 %pgocount41, 1
  store i64 %48, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 41), align 8
  store i64 ptrtoint (ptr @.str.8 to i64), ptr %when_result, align 8
  br label %when_end

when_next47:                                      ; preds = %sc_merge34
  %pgocount42 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 42), align 8
  %49 = add i64 %pgocount42, 1
  store i64 %49, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 42), align 8
  %pgocount43 = load i64, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 43), align 8
  %50 = add i64 %pgocount43, 1
  store i64 %50, ptr getelementptr inbounds ([44 x i64], ptr @__profc_classify, i32 0, i32 43), align 8
  store i64 ptrtoint (ptr @.str.9 to i64), ptr %when_result, align 8
  br label %when_end
}

define i64 @main() {
entry:
  %sif_result = alloca i64, align 8
  %label = alloca ptr, align 8
  %when_result = alloca i64, align 8
  %grade = alloca i64, align 8
  %x = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_main, align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr @__profc_main, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %3 = add i64 %pgocount3, 1
  store i64 %3, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %4 = add i64 %pgocount4, 1
  store i64 %4, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %5 = call ptr @classify(ptr @.str.10)
  %6 = call i32 @puts(ptr %5)
  %widen = sext i32 %6 to i64
  %pgocount5 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %7 = add i64 %pgocount5, 1
  store i64 %7, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %8 = add i64 %pgocount6, 1
  store i64 %8, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %9 = add i64 %pgocount7, 1
  store i64 %9, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %10 = add i64 %pgocount8, 1
  store i64 %10, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %11 = call ptr @classify(ptr @.str.11)
  %12 = call i32 @puts(ptr %11)
  %widen1 = sext i32 %12 to i64
  %pgocount9 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %13 = add i64 %pgocount9, 1
  store i64 %13, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %14 = add i64 %pgocount10, 1
  store i64 %14, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %15 = add i64 %pgocount11, 1
  store i64 %15, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %16 = add i64 %pgocount12, 1
  store i64 %16, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %17 = call ptr @classify(ptr @.str.12)
  %18 = call i32 @puts(ptr %17)
  %widen2 = sext i32 %18 to i64
  %pgocount13 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %19 = add i64 %pgocount13, 1
  store i64 %19, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %20 = add i64 %pgocount14, 1
  store i64 %20, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %21 = add i64 %pgocount15, 1
  store i64 %21, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %pgocount16 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %22 = add i64 %pgocount16, 1
  store i64 %22, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %23 = call ptr @classify(ptr @.str.13)
  %24 = call i32 @puts(ptr %23)
  %widen3 = sext i32 %24 to i64
  %pgocount17 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %25 = add i64 %pgocount17, 1
  store i64 %25, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %26 = add i64 %pgocount18, 1
  store i64 %26, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  store i64 42, ptr %x, align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %27 = add i64 %pgocount19, 1
  store i64 %27, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %28 = add i64 %pgocount20, 1
  store i64 %28, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %29 = add i64 %pgocount21, 1
  store i64 %29, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %pgocount22 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %30 = add i64 %pgocount22, 1
  store i64 %30, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %pgocount23 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %31 = add i64 %pgocount23, 1
  store i64 %31, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %x4 = load i64, ptr %x, align 8
  %pgocount24 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %32 = add i64 %pgocount24, 1
  store i64 %32, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %sge = icmp sge i64 %x4, 1
  %sge_ext = zext i1 %sge to i64
  %l_bool = icmp ne i64 %sge_ext, 0
  br i1 %l_bool, label %sc_rhs, label %sc_short

sc_rhs:                                           ; preds = %entry
  %pgocount25 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %33 = add i64 %pgocount25, 1
  store i64 %33, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %pgocount26 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %34 = add i64 %pgocount26, 1
  store i64 %34, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %pgocount27 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %35 = add i64 %pgocount27, 1
  store i64 %35, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %x5 = load i64, ptr %x, align 8
  %pgocount28 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %36 = add i64 %pgocount28, 1
  store i64 %36, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %sle = icmp sle i64 %x5, 100
  %sle_ext = zext i1 %sle to i64
  %r_bool = icmp ne i64 %sle_ext, 0
  br i1 %r_bool, label %sc_r_true, label %sc_r_false

sc_short:                                         ; preds = %entry
  %pgocount29 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %37 = add i64 %pgocount29, 1
  store i64 %37, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  br label %sc_merge

sc_merge:                                         ; preds = %sc_r_merge, %sc_short
  %sc_phi = phi i1 [ false, %sc_short ], [ %r_bool, %sc_r_merge ]
  %sc_ext = zext i1 %sc_phi to i64
  %if_cond = icmp ne i64 %sc_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

sc_r_true:                                        ; preds = %sc_rhs
  %pgocount30 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %38 = add i64 %pgocount30, 1
  store i64 %38, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  br label %sc_r_merge

sc_r_false:                                       ; preds = %sc_rhs
  %pgocount31 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %39 = add i64 %pgocount31, 1
  store i64 %39, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  br label %sc_r_merge

sc_r_merge:                                       ; preds = %sc_r_false, %sc_r_true
  br label %sc_merge

ifcont:                                           ; preds = %if_else, %if_then
  %pgocount32 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %40 = add i64 %pgocount32, 1
  store i64 %40, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %pgocount33 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %41 = add i64 %pgocount33, 1
  store i64 %41, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %pgocount34 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %42 = add i64 %pgocount34, 1
  store i64 %42, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %pgocount35 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %43 = add i64 %pgocount35, 1
  store i64 %43, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %pgocount36 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %44 = add i64 %pgocount36, 1
  store i64 %44, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %pgocount37 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %45 = add i64 %pgocount37, 1
  store i64 %45, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %pgocount38 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %46 = add i64 %pgocount38, 1
  store i64 %46, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %x7 = load i64, ptr %x, align 8
  %pgocount39 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %47 = add i64 %pgocount39, 1
  store i64 %47, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %sge8 = icmp sge i64 %x7, 200
  %sge_ext9 = zext i1 %sge8 to i64
  %l_bool10 = icmp ne i64 %sge_ext9, 0
  br i1 %l_bool10, label %sc_rhs11, label %sc_short12

if_then:                                          ; preds = %sc_merge
  %pgocount40 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %48 = add i64 %pgocount40, 1
  store i64 %48, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %pgocount41 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %49 = add i64 %pgocount41, 1
  store i64 %49, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %pgocount42 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %50 = add i64 %pgocount42, 1
  store i64 %50, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %pgocount43 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %51 = add i64 %pgocount43, 1
  store i64 %51, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %52 = call i32 @puts(ptr @.str.14)
  %widen6 = sext i32 %52 to i64
  br label %ifcont

if_else:                                          ; preds = %sc_merge
  %pgocount44 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %53 = add i64 %pgocount44, 1
  store i64 %53, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  br label %ifcont

sc_rhs11:                                         ; preds = %ifcont
  %pgocount45 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %54 = add i64 %pgocount45, 1
  store i64 %54, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %pgocount46 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %55 = add i64 %pgocount46, 1
  store i64 %55, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %pgocount47 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %56 = add i64 %pgocount47, 1
  store i64 %56, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %x14 = load i64, ptr %x, align 8
  %pgocount48 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %57 = add i64 %pgocount48, 1
  store i64 %57, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %sle15 = icmp sle i64 %x14, 300
  %sle_ext16 = zext i1 %sle15 to i64
  %r_bool17 = icmp ne i64 %sle_ext16, 0
  br i1 %r_bool17, label %sc_r_true18, label %sc_r_false19

sc_short12:                                       ; preds = %ifcont
  %pgocount49 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %58 = add i64 %pgocount49, 1
  store i64 %58, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  br label %sc_merge13

sc_merge13:                                       ; preds = %sc_r_merge20, %sc_short12
  %sc_phi21 = phi i1 [ false, %sc_short12 ], [ %r_bool17, %sc_r_merge20 ]
  %sc_ext22 = zext i1 %sc_phi21 to i64
  %not_cmp = icmp eq i64 %sc_ext22, 0
  %not_cmp_ext = zext i1 %not_cmp to i64
  %if_cond24 = icmp ne i64 %not_cmp_ext, 0
  br i1 %if_cond24, label %if_then25, label %if_else26

sc_r_true18:                                      ; preds = %sc_rhs11
  %pgocount50 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %59 = add i64 %pgocount50, 1
  store i64 %59, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  br label %sc_r_merge20

sc_r_false19:                                     ; preds = %sc_rhs11
  %pgocount51 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %60 = add i64 %pgocount51, 1
  store i64 %60, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  br label %sc_r_merge20

sc_r_merge20:                                     ; preds = %sc_r_false19, %sc_r_true18
  br label %sc_merge13

ifcont23:                                         ; preds = %if_else26, %if_then25
  %pgocount52 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 57), align 8
  %61 = add i64 %pgocount52, 1
  store i64 %61, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 57), align 8
  %pgocount53 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 58), align 8
  %62 = add i64 %pgocount53, 1
  store i64 %62, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 58), align 8
  %pgocount54 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 59), align 8
  %63 = add i64 %pgocount54, 1
  store i64 %63, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 59), align 8
  %pgocount55 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 60), align 8
  %64 = add i64 %pgocount55, 1
  store i64 %64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 60), align 8
  %pgocount56 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 61), align 8
  %65 = add i64 %pgocount56, 1
  store i64 %65, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 61), align 8
  %pgocount57 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 62), align 8
  %66 = add i64 %pgocount57, 1
  store i64 %66, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 62), align 8
  br i1 true, label %sc_rhs28, label %sc_short29

if_then25:                                        ; preds = %sc_merge13
  %pgocount58 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 52), align 8
  %67 = add i64 %pgocount58, 1
  store i64 %67, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 52), align 8
  %pgocount59 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 53), align 8
  %68 = add i64 %pgocount59, 1
  store i64 %68, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 53), align 8
  %pgocount60 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 54), align 8
  %69 = add i64 %pgocount60, 1
  store i64 %69, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 54), align 8
  %pgocount61 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 55), align 8
  %70 = add i64 %pgocount61, 1
  store i64 %70, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 55), align 8
  %71 = call i32 @puts(ptr @.str.15)
  %widen27 = sext i32 %71 to i64
  br label %ifcont23

if_else26:                                        ; preds = %sc_merge13
  %pgocount62 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 56), align 8
  %72 = add i64 %pgocount62, 1
  store i64 %72, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 56), align 8
  br label %ifcont23

sc_rhs28:                                         ; preds = %ifcont23
  %pgocount63 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 64), align 8
  %73 = add i64 %pgocount63, 1
  store i64 %73, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 64), align 8
  %pgocount64 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 65), align 8
  %74 = add i64 %pgocount64, 1
  store i64 %74, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 65), align 8
  %pgocount65 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 66), align 8
  %75 = add i64 %pgocount65, 1
  store i64 %75, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 66), align 8
  %pgocount66 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 67), align 8
  %76 = add i64 %pgocount66, 1
  store i64 %76, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 67), align 8
  br i1 true, label %sc_r_true31, label %sc_r_false32

sc_short29:                                       ; preds = %ifcont23
  %pgocount67 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 63), align 8
  %77 = add i64 %pgocount67, 1
  store i64 %77, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 63), align 8
  br label %sc_merge30

sc_merge30:                                       ; preds = %sc_r_merge33, %sc_short29
  %sc_phi34 = phi i1 [ false, %sc_short29 ], [ true, %sc_r_merge33 ]
  %sc_ext35 = zext i1 %sc_phi34 to i64
  %if_cond37 = icmp ne i64 %sc_ext35, 0
  br i1 %if_cond37, label %if_then38, label %if_else39

sc_r_true31:                                      ; preds = %sc_rhs28
  %pgocount68 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 68), align 8
  %78 = add i64 %pgocount68, 1
  store i64 %78, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 68), align 8
  br label %sc_r_merge33

sc_r_false32:                                     ; preds = %sc_rhs28
  %pgocount69 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 69), align 8
  %79 = add i64 %pgocount69, 1
  store i64 %79, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 69), align 8
  br label %sc_r_merge33

sc_r_merge33:                                     ; preds = %sc_r_false32, %sc_r_true31
  br label %sc_merge30

ifcont36:                                         ; preds = %if_else39, %if_then38
  %pgocount70 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 75), align 8
  %80 = add i64 %pgocount70, 1
  store i64 %80, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 75), align 8
  %pgocount71 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 76), align 8
  %81 = add i64 %pgocount71, 1
  store i64 %81, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 76), align 8
  %pgocount72 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 77), align 8
  %82 = add i64 %pgocount72, 1
  store i64 %82, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 77), align 8
  %pgocount73 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 78), align 8
  %83 = add i64 %pgocount73, 1
  store i64 %83, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 78), align 8
  %pgocount74 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 79), align 8
  %84 = add i64 %pgocount74, 1
  store i64 %84, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 79), align 8
  %pgocount75 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 80), align 8
  %85 = add i64 %pgocount75, 1
  store i64 %85, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 80), align 8
  br i1 true, label %sc_rhs41, label %sc_short42

if_then38:                                        ; preds = %sc_merge30
  %pgocount76 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 70), align 8
  %86 = add i64 %pgocount76, 1
  store i64 %86, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 70), align 8
  %pgocount77 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 71), align 8
  %87 = add i64 %pgocount77, 1
  store i64 %87, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 71), align 8
  %pgocount78 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 72), align 8
  %88 = add i64 %pgocount78, 1
  store i64 %88, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 72), align 8
  %pgocount79 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 73), align 8
  %89 = add i64 %pgocount79, 1
  store i64 %89, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 73), align 8
  %90 = call i32 @puts(ptr @.str.16)
  %widen40 = sext i32 %90 to i64
  br label %ifcont36

if_else39:                                        ; preds = %sc_merge30
  %pgocount80 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 74), align 8
  %91 = add i64 %pgocount80, 1
  store i64 %91, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 74), align 8
  br label %ifcont36

sc_rhs41:                                         ; preds = %ifcont36
  %pgocount81 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 82), align 8
  %92 = add i64 %pgocount81, 1
  store i64 %92, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 82), align 8
  %pgocount82 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 83), align 8
  %93 = add i64 %pgocount82, 1
  store i64 %93, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 83), align 8
  %pgocount83 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 84), align 8
  %94 = add i64 %pgocount83, 1
  store i64 %94, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 84), align 8
  %pgocount84 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 85), align 8
  %95 = add i64 %pgocount84, 1
  store i64 %95, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 85), align 8
  br i1 true, label %sc_r_true44, label %sc_r_false45

sc_short42:                                       ; preds = %ifcont36
  %pgocount85 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 81), align 8
  %96 = add i64 %pgocount85, 1
  store i64 %96, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 81), align 8
  br label %sc_merge43

sc_merge43:                                       ; preds = %sc_r_merge46, %sc_short42
  %sc_phi47 = phi i1 [ false, %sc_short42 ], [ true, %sc_r_merge46 ]
  %sc_ext48 = zext i1 %sc_phi47 to i64
  %if_cond50 = icmp ne i64 %sc_ext48, 0
  br i1 %if_cond50, label %if_then51, label %if_else52

sc_r_true44:                                      ; preds = %sc_rhs41
  %pgocount86 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 86), align 8
  %97 = add i64 %pgocount86, 1
  store i64 %97, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 86), align 8
  br label %sc_r_merge46

sc_r_false45:                                     ; preds = %sc_rhs41
  %pgocount87 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 87), align 8
  %98 = add i64 %pgocount87, 1
  store i64 %98, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 87), align 8
  br label %sc_r_merge46

sc_r_merge46:                                     ; preds = %sc_r_false45, %sc_r_true44
  br label %sc_merge43

ifcont49:                                         ; preds = %if_else52, %if_then51
  %pgocount88 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 93), align 8
  %99 = add i64 %pgocount88, 1
  store i64 %99, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 93), align 8
  %pgocount89 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 94), align 8
  %100 = add i64 %pgocount89, 1
  store i64 %100, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 94), align 8
  store i64 85, ptr %grade, align 8
  %pgocount90 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 95), align 8
  %101 = add i64 %pgocount90, 1
  store i64 %101, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 95), align 8
  %pgocount91 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 96), align 8
  %102 = add i64 %pgocount91, 1
  store i64 %102, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 96), align 8
  store i64 0, ptr %when_result, align 8
  %pgocount92 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 97), align 8
  %103 = add i64 %pgocount92, 1
  store i64 %103, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 97), align 8
  %pgocount93 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 98), align 8
  %104 = add i64 %pgocount93, 1
  store i64 %104, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 98), align 8
  %pgocount94 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 99), align 8
  %105 = add i64 %pgocount94, 1
  store i64 %105, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 99), align 8
  %pgocount95 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 100), align 8
  %106 = add i64 %pgocount95, 1
  store i64 %106, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 100), align 8
  %grade54 = load i64, ptr %grade, align 8
  %pgocount96 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 101), align 8
  %107 = add i64 %pgocount96, 1
  store i64 %107, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 101), align 8
  %sge55 = icmp sge i64 %grade54, 90
  %sge_ext56 = zext i1 %sge55 to i64
  %l_bool57 = icmp ne i64 %sge_ext56, 0
  br i1 %l_bool57, label %sc_rhs58, label %sc_short59

if_then51:                                        ; preds = %sc_merge43
  %pgocount97 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 88), align 8
  %108 = add i64 %pgocount97, 1
  store i64 %108, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 88), align 8
  %pgocount98 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 89), align 8
  %109 = add i64 %pgocount98, 1
  store i64 %109, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 89), align 8
  %pgocount99 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 90), align 8
  %110 = add i64 %pgocount99, 1
  store i64 %110, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 90), align 8
  %pgocount100 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 91), align 8
  %111 = add i64 %pgocount100, 1
  store i64 %111, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 91), align 8
  %112 = call i32 @puts(ptr @.str.17)
  %widen53 = sext i32 %112 to i64
  br label %ifcont49

if_else52:                                        ; preds = %sc_merge43
  %pgocount101 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 92), align 8
  %113 = add i64 %pgocount101, 1
  store i64 %113, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 92), align 8
  br label %ifcont49

when_end:                                         ; preds = %when_next107, %when_arm106, %when_arm87, %when_arm
  %when_val = load i64, ptr %when_result, align 8
  %cast = inttoptr i64 %when_val to ptr
  store ptr %cast, ptr %label, align 8
  %pgocount102 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 138), align 8
  %114 = add i64 %pgocount102, 1
  store i64 %114, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 138), align 8
  %pgocount103 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 139), align 8
  %115 = add i64 %pgocount103, 1
  store i64 %115, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 139), align 8
  %pgocount104 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 140), align 8
  %116 = add i64 %pgocount104, 1
  store i64 %116, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 140), align 8
  %label108 = load ptr, ptr %label, align 8
  %pgocount105 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 141), align 8
  %117 = add i64 %pgocount105, 1
  store i64 %117, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 141), align 8
  %118 = call i32 @strcmp(ptr %label108, ptr @.str.22)
  %widen109 = sext i32 %118 to i64
  %streq_cmp = icmp eq i64 %widen109, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %sif_cond = icmp ne i64 %streq_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

sc_rhs58:                                         ; preds = %ifcont49
  %pgocount106 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 103), align 8
  %119 = add i64 %pgocount106, 1
  store i64 %119, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 103), align 8
  %pgocount107 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 104), align 8
  %120 = add i64 %pgocount107, 1
  store i64 %120, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 104), align 8
  %pgocount108 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 105), align 8
  %121 = add i64 %pgocount108, 1
  store i64 %121, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 105), align 8
  %grade61 = load i64, ptr %grade, align 8
  %pgocount109 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 106), align 8
  %122 = add i64 %pgocount109, 1
  store i64 %122, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 106), align 8
  %sle62 = icmp sle i64 %grade61, 100
  %sle_ext63 = zext i1 %sle62 to i64
  %r_bool64 = icmp ne i64 %sle_ext63, 0
  br i1 %r_bool64, label %sc_r_true65, label %sc_r_false66

sc_short59:                                       ; preds = %ifcont49
  %pgocount110 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 102), align 8
  %123 = add i64 %pgocount110, 1
  store i64 %123, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 102), align 8
  br label %sc_merge60

sc_merge60:                                       ; preds = %sc_r_merge67, %sc_short59
  %sc_phi68 = phi i1 [ false, %sc_short59 ], [ %r_bool64, %sc_r_merge67 ]
  %sc_ext69 = zext i1 %sc_phi68 to i64
  %when_cond = icmp ne i64 %sc_ext69, 0
  br i1 %when_cond, label %when_arm, label %when_next

sc_r_true65:                                      ; preds = %sc_rhs58
  %pgocount111 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 107), align 8
  %124 = add i64 %pgocount111, 1
  store i64 %124, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 107), align 8
  br label %sc_r_merge67

sc_r_false66:                                     ; preds = %sc_rhs58
  %pgocount112 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 108), align 8
  %125 = add i64 %pgocount112, 1
  store i64 %125, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 108), align 8
  br label %sc_r_merge67

sc_r_merge67:                                     ; preds = %sc_r_false66, %sc_r_true65
  br label %sc_merge60

when_arm:                                         ; preds = %sc_merge60
  %pgocount113 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 109), align 8
  %126 = add i64 %pgocount113, 1
  store i64 %126, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 109), align 8
  store i64 ptrtoint (ptr @.str.18 to i64), ptr %when_result, align 8
  br label %when_end

when_next:                                        ; preds = %sc_merge60
  %pgocount114 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 110), align 8
  %127 = add i64 %pgocount114, 1
  store i64 %127, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 110), align 8
  %pgocount115 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 111), align 8
  %128 = add i64 %pgocount115, 1
  store i64 %128, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 111), align 8
  %pgocount116 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 112), align 8
  %129 = add i64 %pgocount116, 1
  store i64 %129, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 112), align 8
  %pgocount117 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 113), align 8
  %130 = add i64 %pgocount117, 1
  store i64 %130, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 113), align 8
  %grade70 = load i64, ptr %grade, align 8
  %pgocount118 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 114), align 8
  %131 = add i64 %pgocount118, 1
  store i64 %131, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 114), align 8
  %sge71 = icmp sge i64 %grade70, 80
  %sge_ext72 = zext i1 %sge71 to i64
  %l_bool73 = icmp ne i64 %sge_ext72, 0
  br i1 %l_bool73, label %sc_rhs74, label %sc_short75

sc_rhs74:                                         ; preds = %when_next
  %pgocount119 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 116), align 8
  %132 = add i64 %pgocount119, 1
  store i64 %132, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 116), align 8
  %pgocount120 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 117), align 8
  %133 = add i64 %pgocount120, 1
  store i64 %133, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 117), align 8
  %pgocount121 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 118), align 8
  %134 = add i64 %pgocount121, 1
  store i64 %134, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 118), align 8
  %grade77 = load i64, ptr %grade, align 8
  %pgocount122 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 119), align 8
  %135 = add i64 %pgocount122, 1
  store i64 %135, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 119), align 8
  %sle78 = icmp sle i64 %grade77, 89
  %sle_ext79 = zext i1 %sle78 to i64
  %r_bool80 = icmp ne i64 %sle_ext79, 0
  br i1 %r_bool80, label %sc_r_true81, label %sc_r_false82

sc_short75:                                       ; preds = %when_next
  %pgocount123 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 115), align 8
  %136 = add i64 %pgocount123, 1
  store i64 %136, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 115), align 8
  br label %sc_merge76

sc_merge76:                                       ; preds = %sc_r_merge83, %sc_short75
  %sc_phi84 = phi i1 [ false, %sc_short75 ], [ %r_bool80, %sc_r_merge83 ]
  %sc_ext85 = zext i1 %sc_phi84 to i64
  %when_cond86 = icmp ne i64 %sc_ext85, 0
  br i1 %when_cond86, label %when_arm87, label %when_next88

sc_r_true81:                                      ; preds = %sc_rhs74
  %pgocount124 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 120), align 8
  %137 = add i64 %pgocount124, 1
  store i64 %137, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 120), align 8
  br label %sc_r_merge83

sc_r_false82:                                     ; preds = %sc_rhs74
  %pgocount125 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 121), align 8
  %138 = add i64 %pgocount125, 1
  store i64 %138, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 121), align 8
  br label %sc_r_merge83

sc_r_merge83:                                     ; preds = %sc_r_false82, %sc_r_true81
  br label %sc_merge76

when_arm87:                                       ; preds = %sc_merge76
  %pgocount126 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 122), align 8
  %139 = add i64 %pgocount126, 1
  store i64 %139, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 122), align 8
  store i64 ptrtoint (ptr @.str.19 to i64), ptr %when_result, align 8
  br label %when_end

when_next88:                                      ; preds = %sc_merge76
  %pgocount127 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 123), align 8
  %140 = add i64 %pgocount127, 1
  store i64 %140, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 123), align 8
  %pgocount128 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 124), align 8
  %141 = add i64 %pgocount128, 1
  store i64 %141, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 124), align 8
  %pgocount129 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 125), align 8
  %142 = add i64 %pgocount129, 1
  store i64 %142, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 125), align 8
  %pgocount130 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 126), align 8
  %143 = add i64 %pgocount130, 1
  store i64 %143, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 126), align 8
  %grade89 = load i64, ptr %grade, align 8
  %pgocount131 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 127), align 8
  %144 = add i64 %pgocount131, 1
  store i64 %144, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 127), align 8
  %sge90 = icmp sge i64 %grade89, 70
  %sge_ext91 = zext i1 %sge90 to i64
  %l_bool92 = icmp ne i64 %sge_ext91, 0
  br i1 %l_bool92, label %sc_rhs93, label %sc_short94

sc_rhs93:                                         ; preds = %when_next88
  %pgocount132 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 129), align 8
  %145 = add i64 %pgocount132, 1
  store i64 %145, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 129), align 8
  %pgocount133 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 130), align 8
  %146 = add i64 %pgocount133, 1
  store i64 %146, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 130), align 8
  %pgocount134 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 131), align 8
  %147 = add i64 %pgocount134, 1
  store i64 %147, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 131), align 8
  %grade96 = load i64, ptr %grade, align 8
  %pgocount135 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 132), align 8
  %148 = add i64 %pgocount135, 1
  store i64 %148, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 132), align 8
  %sle97 = icmp sle i64 %grade96, 79
  %sle_ext98 = zext i1 %sle97 to i64
  %r_bool99 = icmp ne i64 %sle_ext98, 0
  br i1 %r_bool99, label %sc_r_true100, label %sc_r_false101

sc_short94:                                       ; preds = %when_next88
  %pgocount136 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 128), align 8
  %149 = add i64 %pgocount136, 1
  store i64 %149, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 128), align 8
  br label %sc_merge95

sc_merge95:                                       ; preds = %sc_r_merge102, %sc_short94
  %sc_phi103 = phi i1 [ false, %sc_short94 ], [ %r_bool99, %sc_r_merge102 ]
  %sc_ext104 = zext i1 %sc_phi103 to i64
  %when_cond105 = icmp ne i64 %sc_ext104, 0
  br i1 %when_cond105, label %when_arm106, label %when_next107

sc_r_true100:                                     ; preds = %sc_rhs93
  %pgocount137 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 133), align 8
  %150 = add i64 %pgocount137, 1
  store i64 %150, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 133), align 8
  br label %sc_r_merge102

sc_r_false101:                                    ; preds = %sc_rhs93
  %pgocount138 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 134), align 8
  %151 = add i64 %pgocount138, 1
  store i64 %151, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 134), align 8
  br label %sc_r_merge102

sc_r_merge102:                                    ; preds = %sc_r_false101, %sc_r_true100
  br label %sc_merge95

when_arm106:                                      ; preds = %sc_merge95
  %pgocount139 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 135), align 8
  %152 = add i64 %pgocount139, 1
  store i64 %152, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 135), align 8
  store i64 ptrtoint (ptr @.str.20 to i64), ptr %when_result, align 8
  br label %when_end

when_next107:                                     ; preds = %sc_merge95
  %pgocount140 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 136), align 8
  %153 = add i64 %pgocount140, 1
  store i64 %153, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 136), align 8
  %pgocount141 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 137), align 8
  %154 = add i64 %pgocount141, 1
  store i64 %154, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 137), align 8
  store i64 ptrtoint (ptr @.str.21 to i64), ptr %when_result, align 8
  br label %when_end

sif_then:                                         ; preds = %when_end
  %pgocount142 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 142), align 8
  %155 = add i64 %pgocount142, 1
  store i64 %155, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 142), align 8
  %pgocount143 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 143), align 8
  %156 = add i64 %pgocount143, 1
  store i64 %156, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 143), align 8
  %157 = call i32 @puts(ptr @.str.23)
  %widen110 = sext i32 %157 to i64
  store i64 0, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %when_end
  %pgocount144 = load i64, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 144), align 8
  %158 = add i64 %pgocount144, 1
  store i64 %158, ptr getelementptr inbounds ([145 x i64], ptr @__profc_main, i32 0, i32 144), align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  ret i64 %sif_val
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
