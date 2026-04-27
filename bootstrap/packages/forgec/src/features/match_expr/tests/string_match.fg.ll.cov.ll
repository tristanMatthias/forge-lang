; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/string_match.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

@.lit_str = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str = private unnamed_addr constant [9 x i8] c"greeting\00", align 1
@.lit_str.1 = private unnamed_addr constant [4 x i8] c"bye\00", align 1
@.str.2 = private unnamed_addr constant [9 x i8] c"farewell\00", align 1
@.lit_str.3 = private unnamed_addr constant [4 x i8] c"yes\00", align 1
@.str.4 = private unnamed_addr constant [12 x i8] c"affirmative\00", align 1
@.lit_str.5 = private unnamed_addr constant [3 x i8] c"no\00", align 1
@.str.6 = private unnamed_addr constant [9 x i8] c"negative\00", align 1
@.str.7 = private unnamed_addr constant [8 x i8] c"unknown\00", align 1
@.match_fn = private unnamed_addr constant [9 x i8] c"classify\00", align 1
@mu_file = private unnamed_addr constant [139 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/string_match.fg\00", align 1
@.lit_str.8 = private unnamed_addr constant [6 x i8] c"start\00", align 1
@.str.9 = private unnamed_addr constant [12 x i8] c"starting...\00", align 1
@.lit_str.10 = private unnamed_addr constant [5 x i8] c"stop\00", align 1
@.str.11 = private unnamed_addr constant [12 x i8] c"stopping...\00", align 1
@.str.12 = private unnamed_addr constant [16 x i8] c"unknown command\00", align 1
@.match_fn.13 = private unnamed_addr constant [9 x i8] c"announce\00", align 1
@mu_file.14 = private unnamed_addr constant [139 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/string_match.fg\00", align 1
@.lit_str.15 = private unnamed_addr constant [2 x i8] c"A\00", align 1
@.str.16 = private unnamed_addr constant [10 x i8] c"excellent\00", align 1
@.lit_str.17 = private unnamed_addr constant [2 x i8] c"B\00", align 1
@.str.18 = private unnamed_addr constant [5 x i8] c"good\00", align 1
@.lit_str.19 = private unnamed_addr constant [2 x i8] c"C\00", align 1
@.str.20 = private unnamed_addr constant [8 x i8] c"average\00", align 1
@.str.21 = private unnamed_addr constant [6 x i8] c"other\00", align 1
@.match_fn.22 = private unnamed_addr constant [6 x i8] c"grade\00", align 1
@mu_file.23 = private unnamed_addr constant [139 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/string_match.fg\00", align 1
@.str.24 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.25 = private unnamed_addr constant [4 x i8] c"bye\00", align 1
@.str.26 = private unnamed_addr constant [4 x i8] c"yes\00", align 1
@.str.27 = private unnamed_addr constant [3 x i8] c"no\00", align 1
@.str.28 = private unnamed_addr constant [6 x i8] c"maybe\00", align 1
@.str.29 = private unnamed_addr constant [6 x i8] c"start\00", align 1
@.str.30 = private unnamed_addr constant [5 x i8] c"stop\00", align 1
@.str.31 = private unnamed_addr constant [6 x i8] c"pause\00", align 1
@.str.32 = private unnamed_addr constant [2 x i8] c"A\00", align 1
@.str.33 = private unnamed_addr constant [2 x i8] c"B\00", align 1
@.str.34 = private unnamed_addr constant [2 x i8] c"C\00", align 1
@.str.35 = private unnamed_addr constant [2 x i8] c"D\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_classify = private global [8 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_classify = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -6761552294068852299, i64 7572247415914819, i64 sub (i64 ptrtoint (ptr @__profc_classify to i64), i64 ptrtoint (ptr @__profd_classify to i64)), i64 0, ptr null, ptr null, i32 8, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_announce = private global [6 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_announce = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -7199645916756405092, i64 7572165266058428, i64 sub (i64 ptrtoint (ptr @__profc_announce to i64), i64 ptrtoint (ptr @__profd_announce to i64)), i64 0, ptr null, ptr null, i32 6, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_grade = private global [7 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_grade = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -345037195597288738, i64 210713905448, i64 sub (i64 ptrtoint (ptr @__profc_grade to i64), i64 ptrtoint (ptr @__profd_grade to i64)), i64 0, ptr null, ptr null, i32 7, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_main = private global [52 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 52, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__llvm_prf_nm = private constant [38 x i8] c"\1C$x\DAK\CEI,.\CEL\ABdL\CC\CB\CB/\CDKNeL/JLIe\CCM\CC\CC\03\00\9A\85\0Aa", section "__DATA,__llvm_prf_names", align 1
@llvm.compiler.used = appending global [5 x ptr] [ptr @__llvm_profile_runtime_user, ptr @__profd_classify, ptr @__profd_announce, ptr @__profd_grade, ptr @__profd_main], section "llvm.metadata"
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
  %pmatch_result = alloca i64, align 8
  %s = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_classify, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_classify, align 8
  store ptr %0, ptr %s, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_classify, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([8 x i64], ptr @__profc_classify, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_classify, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([8 x i64], ptr @__profc_classify, i32 0, i32 2), align 8
  %s1 = load ptr, ptr %s, align 8
  store i64 0, ptr %pmatch_result, align 8
  %4 = call i32 @strcmp(ptr %s1, ptr @.lit_str)
  %widen = sext i32 %4 to i64
  %str_eq = icmp eq i64 %widen, 0
  br i1 %str_eq, label %parm_body, label %parm_next

pmatch_end:                                       ; preds = %parm_body14, %parm_body10, %parm_body6, %parm_body2, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  %cast = inttoptr i64 %pmatch_val to ptr
  ret ptr %cast

parm_body:                                        ; preds = %entry
  %pgocount3 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_classify, i32 0, i32 3), align 8
  %5 = add i64 %pgocount3, 1
  store i64 %5, ptr getelementptr inbounds ([8 x i64], ptr @__profc_classify, i32 0, i32 3), align 8
  store i64 ptrtoint (ptr @.str to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %entry
  %6 = call i32 @strcmp(ptr %s1, ptr @.lit_str.1)
  %widen4 = sext i32 %6 to i64
  %str_eq5 = icmp eq i64 %widen4, 0
  br i1 %str_eq5, label %parm_body2, label %parm_next3

parm_body2:                                       ; preds = %parm_next
  %pgocount4 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_classify, i32 0, i32 4), align 8
  %7 = add i64 %pgocount4, 1
  store i64 %7, ptr getelementptr inbounds ([8 x i64], ptr @__profc_classify, i32 0, i32 4), align 8
  store i64 ptrtoint (ptr @.str.2 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next3:                                       ; preds = %parm_next
  %8 = call i32 @strcmp(ptr %s1, ptr @.lit_str.3)
  %widen8 = sext i32 %8 to i64
  %str_eq9 = icmp eq i64 %widen8, 0
  br i1 %str_eq9, label %parm_body6, label %parm_next7

parm_body6:                                       ; preds = %parm_next3
  %pgocount5 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_classify, i32 0, i32 5), align 8
  %9 = add i64 %pgocount5, 1
  store i64 %9, ptr getelementptr inbounds ([8 x i64], ptr @__profc_classify, i32 0, i32 5), align 8
  store i64 ptrtoint (ptr @.str.4 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next7:                                       ; preds = %parm_next3
  %10 = call i32 @strcmp(ptr %s1, ptr @.lit_str.5)
  %widen12 = sext i32 %10 to i64
  %str_eq13 = icmp eq i64 %widen12, 0
  br i1 %str_eq13, label %parm_body10, label %parm_next11

parm_body10:                                      ; preds = %parm_next7
  %pgocount6 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_classify, i32 0, i32 6), align 8
  %11 = add i64 %pgocount6, 1
  store i64 %11, ptr getelementptr inbounds ([8 x i64], ptr @__profc_classify, i32 0, i32 6), align 8
  store i64 ptrtoint (ptr @.str.6 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next11:                                      ; preds = %parm_next7
  br label %parm_body14

parm_body14:                                      ; preds = %parm_next11
  %pgocount7 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_classify, i32 0, i32 7), align 8
  %12 = add i64 %pgocount7, 1
  store i64 %12, ptr getelementptr inbounds ([8 x i64], ptr @__profc_classify, i32 0, i32 7), align 8
  store i64 ptrtoint (ptr @.str.7 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next15:                                      ; No predecessors!
  call void @forge_match_unreachable(ptr @.match_fn, i64 -1, ptr @mu_file, i64 4)
  unreachable
}

define i64 @announce(ptr %0) {
entry:
  %pmatch_result = alloca i64, align 8
  %cmd = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_announce, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_announce, align 8
  store ptr %0, ptr %cmd, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_announce, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([6 x i64], ptr @__profc_announce, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_announce, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([6 x i64], ptr @__profc_announce, i32 0, i32 2), align 8
  %cmd1 = load ptr, ptr %cmd, align 8
  store i64 0, ptr %pmatch_result, align 8
  %4 = call i32 @strcmp(ptr %cmd1, ptr @.lit_str.8)
  %widen = sext i32 %4 to i64
  %str_eq = icmp eq i64 %widen, 0
  br i1 %str_eq, label %parm_body, label %parm_next

pmatch_end:                                       ; preds = %parm_body8, %parm_body3, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  ret i64 %pmatch_val

parm_body:                                        ; preds = %entry
  %pgocount3 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_announce, i32 0, i32 3), align 8
  %5 = add i64 %pgocount3, 1
  store i64 %5, ptr getelementptr inbounds ([6 x i64], ptr @__profc_announce, i32 0, i32 3), align 8
  %6 = call i32 @puts(ptr @.str.9)
  %widen2 = sext i32 %6 to i64
  store i64 0, ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %entry
  %7 = call i32 @strcmp(ptr %cmd1, ptr @.lit_str.10)
  %widen5 = sext i32 %7 to i64
  %str_eq6 = icmp eq i64 %widen5, 0
  br i1 %str_eq6, label %parm_body3, label %parm_next4

parm_body3:                                       ; preds = %parm_next
  %pgocount4 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_announce, i32 0, i32 4), align 8
  %8 = add i64 %pgocount4, 1
  store i64 %8, ptr getelementptr inbounds ([6 x i64], ptr @__profc_announce, i32 0, i32 4), align 8
  %9 = call i32 @puts(ptr @.str.11)
  %widen7 = sext i32 %9 to i64
  store i64 0, ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next4:                                       ; preds = %parm_next
  br label %parm_body8

parm_body8:                                       ; preds = %parm_next4
  %pgocount5 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_announce, i32 0, i32 5), align 8
  %10 = add i64 %pgocount5, 1
  store i64 %10, ptr getelementptr inbounds ([6 x i64], ptr @__profc_announce, i32 0, i32 5), align 8
  %11 = call i32 @puts(ptr @.str.12)
  %widen10 = sext i32 %11 to i64
  store i64 0, ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next9:                                       ; No predecessors!
  call void @forge_match_unreachable(ptr @.match_fn.13, i64 -1, ptr @mu_file.14, i64 21)
  unreachable
}

define ptr @grade(ptr %0) {
entry:
  %pmatch_result = alloca i64, align 8
  %s = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_grade, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_grade, align 8
  store ptr %0, ptr %s, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([7 x i64], ptr @__profc_grade, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([7 x i64], ptr @__profc_grade, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([7 x i64], ptr @__profc_grade, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([7 x i64], ptr @__profc_grade, i32 0, i32 2), align 8
  %s1 = load ptr, ptr %s, align 8
  store i64 0, ptr %pmatch_result, align 8
  %4 = call i32 @strcmp(ptr %s1, ptr @.lit_str.15)
  %widen = sext i32 %4 to i64
  %str_eq = icmp eq i64 %widen, 0
  br i1 %str_eq, label %parm_body, label %parm_next

pmatch_end:                                       ; preds = %parm_body10, %parm_body6, %parm_body2, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  %cast = inttoptr i64 %pmatch_val to ptr
  ret ptr %cast

parm_body:                                        ; preds = %entry
  %pgocount3 = load i64, ptr getelementptr inbounds ([7 x i64], ptr @__profc_grade, i32 0, i32 3), align 8
  %5 = add i64 %pgocount3, 1
  store i64 %5, ptr getelementptr inbounds ([7 x i64], ptr @__profc_grade, i32 0, i32 3), align 8
  store i64 ptrtoint (ptr @.str.16 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %entry
  %6 = call i32 @strcmp(ptr %s1, ptr @.lit_str.17)
  %widen4 = sext i32 %6 to i64
  %str_eq5 = icmp eq i64 %widen4, 0
  br i1 %str_eq5, label %parm_body2, label %parm_next3

parm_body2:                                       ; preds = %parm_next
  %pgocount4 = load i64, ptr getelementptr inbounds ([7 x i64], ptr @__profc_grade, i32 0, i32 4), align 8
  %7 = add i64 %pgocount4, 1
  store i64 %7, ptr getelementptr inbounds ([7 x i64], ptr @__profc_grade, i32 0, i32 4), align 8
  store i64 ptrtoint (ptr @.str.18 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next3:                                       ; preds = %parm_next
  %8 = call i32 @strcmp(ptr %s1, ptr @.lit_str.19)
  %widen8 = sext i32 %8 to i64
  %str_eq9 = icmp eq i64 %widen8, 0
  br i1 %str_eq9, label %parm_body6, label %parm_next7

parm_body6:                                       ; preds = %parm_next3
  %pgocount5 = load i64, ptr getelementptr inbounds ([7 x i64], ptr @__profc_grade, i32 0, i32 5), align 8
  %9 = add i64 %pgocount5, 1
  store i64 %9, ptr getelementptr inbounds ([7 x i64], ptr @__profc_grade, i32 0, i32 5), align 8
  store i64 ptrtoint (ptr @.str.20 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next7:                                       ; preds = %parm_next3
  br label %parm_body10

parm_body10:                                      ; preds = %parm_next7
  %pgocount6 = load i64, ptr getelementptr inbounds ([7 x i64], ptr @__profc_grade, i32 0, i32 6), align 8
  %10 = add i64 %pgocount6, 1
  store i64 %10, ptr getelementptr inbounds ([7 x i64], ptr @__profc_grade, i32 0, i32 6), align 8
  store i64 ptrtoint (ptr @.str.21 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next11:                                      ; No predecessors!
  call void @forge_match_unreachable(ptr @.match_fn.22, i64 -1, ptr @mu_file.23, i64 34)
  unreachable
}

define i64 @main() {
entry:
  %pgocount = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %3 = add i64 %pgocount3, 1
  store i64 %3, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %4 = call ptr @classify(ptr @.str.24)
  %5 = call i32 @puts(ptr %4)
  %widen = sext i32 %5 to i64
  %pgocount4 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %6 = add i64 %pgocount4, 1
  store i64 %6, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %7 = add i64 %pgocount5, 1
  store i64 %7, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %8 = add i64 %pgocount6, 1
  store i64 %8, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %9 = add i64 %pgocount7, 1
  store i64 %9, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %10 = call ptr @classify(ptr @.str.25)
  %11 = call i32 @puts(ptr %10)
  %widen1 = sext i32 %11 to i64
  %pgocount8 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %12 = add i64 %pgocount8, 1
  store i64 %12, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %13 = add i64 %pgocount9, 1
  store i64 %13, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %14 = add i64 %pgocount10, 1
  store i64 %14, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %15 = add i64 %pgocount11, 1
  store i64 %15, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %16 = call ptr @classify(ptr @.str.26)
  %17 = call i32 @puts(ptr %16)
  %widen2 = sext i32 %17 to i64
  %pgocount12 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %18 = add i64 %pgocount12, 1
  store i64 %18, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %19 = add i64 %pgocount13, 1
  store i64 %19, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %20 = add i64 %pgocount14, 1
  store i64 %20, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %21 = add i64 %pgocount15, 1
  store i64 %21, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %22 = call ptr @classify(ptr @.str.27)
  %23 = call i32 @puts(ptr %22)
  %widen3 = sext i32 %23 to i64
  %pgocount16 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %24 = add i64 %pgocount16, 1
  store i64 %24, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %pgocount17 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %25 = add i64 %pgocount17, 1
  store i64 %25, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %26 = add i64 %pgocount18, 1
  store i64 %26, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %27 = add i64 %pgocount19, 1
  store i64 %27, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %28 = call ptr @classify(ptr @.str.28)
  %29 = call i32 @puts(ptr %28)
  %widen4 = sext i32 %29 to i64
  %pgocount20 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %30 = add i64 %pgocount20, 1
  store i64 %30, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %31 = add i64 %pgocount21, 1
  store i64 %31, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %pgocount22 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %32 = add i64 %pgocount22, 1
  store i64 %32, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %33 = call i64 @announce(ptr @.str.29)
  %pgocount23 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %34 = add i64 %pgocount23, 1
  store i64 %34, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %pgocount24 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %35 = add i64 %pgocount24, 1
  store i64 %35, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %pgocount25 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %36 = add i64 %pgocount25, 1
  store i64 %36, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %37 = call i64 @announce(ptr @.str.30)
  %pgocount26 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %38 = add i64 %pgocount26, 1
  store i64 %38, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %pgocount27 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %39 = add i64 %pgocount27, 1
  store i64 %39, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %pgocount28 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %40 = add i64 %pgocount28, 1
  store i64 %40, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %41 = call i64 @announce(ptr @.str.31)
  %pgocount29 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %42 = add i64 %pgocount29, 1
  store i64 %42, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %pgocount30 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %43 = add i64 %pgocount30, 1
  store i64 %43, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %pgocount31 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %44 = add i64 %pgocount31, 1
  store i64 %44, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %pgocount32 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %45 = add i64 %pgocount32, 1
  store i64 %45, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %46 = call ptr @grade(ptr @.str.32)
  %47 = call i32 @puts(ptr %46)
  %widen5 = sext i32 %47 to i64
  %pgocount33 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %48 = add i64 %pgocount33, 1
  store i64 %48, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %pgocount34 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %49 = add i64 %pgocount34, 1
  store i64 %49, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %pgocount35 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %50 = add i64 %pgocount35, 1
  store i64 %50, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %pgocount36 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %51 = add i64 %pgocount36, 1
  store i64 %51, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %52 = call ptr @grade(ptr @.str.33)
  %53 = call i32 @puts(ptr %52)
  %widen6 = sext i32 %53 to i64
  %pgocount37 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %54 = add i64 %pgocount37, 1
  store i64 %54, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %pgocount38 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %55 = add i64 %pgocount38, 1
  store i64 %55, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %pgocount39 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %56 = add i64 %pgocount39, 1
  store i64 %56, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %pgocount40 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %57 = add i64 %pgocount40, 1
  store i64 %57, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %58 = call ptr @grade(ptr @.str.34)
  %59 = call i32 @puts(ptr %58)
  %widen7 = sext i32 %59 to i64
  %pgocount41 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %60 = add i64 %pgocount41, 1
  store i64 %60, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %pgocount42 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %61 = add i64 %pgocount42, 1
  store i64 %61, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %pgocount43 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %62 = add i64 %pgocount43, 1
  store i64 %62, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %pgocount44 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %63 = add i64 %pgocount44, 1
  store i64 %63, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %64 = call ptr @grade(ptr @.str.35)
  %65 = call i32 @puts(ptr %64)
  %widen8 = sext i32 %65 to i64
  %66 = call i32 @forge_test_summary()
  %widen9 = sext i32 %66 to i64
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
