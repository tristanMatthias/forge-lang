; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/match_guards.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

%Shape = type { i64, ptr }
%Result = type { i64, ptr }

@.str = private unnamed_addr constant [11 x i8] c"big circle\00", align 1
@.str.1 = private unnamed_addr constant [14 x i8] c"medium circle\00", align 1
@.str.2 = private unnamed_addr constant [13 x i8] c"small circle\00", align 1
@.str.3 = private unnamed_addr constant [7 x i8] c"square\00", align 1
@.str.4 = private unnamed_addr constant [10 x i8] c"rectangle\00", align 1
@.match_fn = private unnamed_addr constant [9 x i8] c"classify\00", align 1
@mu_file = private unnamed_addr constant [139 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/match_guards.fg\00", align 1
@.str.5 = private unnamed_addr constant [5 x i8] c"huge\00", align 1
@.str.6 = private unnamed_addr constant [9 x i8] c"positive\00", align 1
@.str.7 = private unnamed_addr constant [13 x i8] c"non-positive\00", align 1
@.match_fn.8 = private unnamed_addr constant [6 x i8] c"check\00", align 1
@mu_file.9 = private unnamed_addr constant [139 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/match_guards.fg\00", align 1
@.str.10 = private unnamed_addr constant [5 x i8] c"ok: \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.11 = private unnamed_addr constant [21 x i8] c"ok: zero or negative\00", align 1
@.str.12 = private unnamed_addr constant [10 x i8] c"not found\00", align 1
@.str.13 = private unnamed_addr constant [8 x i8] c"error: \00", align 1
@.i2s_fmt.14 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.match_fn.15 = private unnamed_addr constant [9 x i8] c"describe\00", align 1
@mu_file.16 = private unnamed_addr constant [139 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/match_guards.fg\00", align 1
@.str.17 = private unnamed_addr constant [6 x i8] c"Alice\00", align 1
@.str.18 = private unnamed_addr constant [13 x i8] c"Hello Alice!\00", align 1
@.str.19 = private unnamed_addr constant [2 x i8] c"B\00", align 1
@.str.20 = private unnamed_addr constant [5 x i8] c"Hey \00", align 1
@.str.21 = private unnamed_addr constant [2 x i8] c"!\00", align 1
@.str.22 = private unnamed_addr constant [4 x i8] c"Hi \00", align 1
@.str.23 = private unnamed_addr constant [2 x i8] c"!\00", align 1
@.match_fn.24 = private unnamed_addr constant [6 x i8] c"greet\00", align 1
@mu_file.25 = private unnamed_addr constant [139 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/match_guards.fg\00", align 1
@.str.26 = private unnamed_addr constant [6 x i8] c"Alice\00", align 1
@.str.27 = private unnamed_addr constant [4 x i8] c"Bob\00", align 1
@.str.28 = private unnamed_addr constant [6 x i8] c"Carol\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_classify = private global [22 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_classify = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -6761552294068852299, i64 7572247415914819, i64 sub (i64 ptrtoint (ptr @__profc_classify to i64), i64 ptrtoint (ptr @__profd_classify to i64)), i64 0, ptr null, ptr null, i32 22, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_check = private global [12 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_check = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -7102839714003835893, i64 210708806723, i64 sub (i64 ptrtoint (ptr @__profc_check to i64), i64 ptrtoint (ptr @__profd_check to i64)), i64 0, ptr null, ptr null, i32 12, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_describe = private global [25 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_describe = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -8671669404246534643, i64 7572281679508262, i64 sub (i64 ptrtoint (ptr @__profc_describe to i64), i64 ptrtoint (ptr @__profd_describe to i64)), i64 0, ptr null, ptr null, i32 25, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_greet = private global [22 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_greet = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 7134157818277131895, i64 210713909852, i64 sub (i64 ptrtoint (ptr @__profc_greet to i64), i64 ptrtoint (ptr @__profd_greet to i64)), i64 0, ptr null, ptr null, i32 22, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_main = private global [97 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 97, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__llvm_prf_nm = private constant [44 x i8] c"\22*x\DAK\CEI,.\CEL\ABdL\CEHM\CEfLI-N.\CALJeL/JM-a\CCM\CC\CC\03\00\DB\CD\0C^", section "__DATA,__llvm_prf_names", align 1
@llvm.compiler.used = appending global [6 x ptr] [ptr @__llvm_profile_runtime_user, ptr @__profd_classify, ptr @__profd_check, ptr @__profd_describe, ptr @__profd_greet, ptr @__profd_main], section "llvm.metadata"
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
  %h30 = alloca i64, align 8
  %w27 = alloca i64, align 8
  %r13 = alloca i64, align 8
  %r2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %s = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_classify, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_classify, align 8
  store ptr %0, ptr %s, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 2), align 8
  %s1 = load ptr, ptr %s, align 8
  %tag_ptr = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 6952139942519
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm35, %guard_pass34, %march_arm19, %guard_pass18, %guard_pass
  %match_val = load i64, ptr %match_result, align 8
  %cast = inttoptr i64 %match_val to ptr
  ret ptr %cast

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %r_slot_base = ptrtoint ptr %payload to i64
  %r_slot_addr = add i64 %r_slot_base, 0
  %r_slot = inttoptr i64 %r_slot_addr to ptr
  %r = load i64, ptr %r_slot, align 8
  store i64 %r, ptr %r2, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 4), align 8
  %r3 = load i64, ptr %r2, align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 5), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 5), align 8
  %sgt = icmp sgt i64 %r3, 10
  %sgt_ext = zext i1 %sgt to i64
  %guard = icmp ne i64 %sgt_ext, 0
  br i1 %guard, label %guard_pass, label %march_next

march_next:                                       ; preds = %march_arm, %entry
  %tag_eq6 = icmp eq i64 %tag, 6952139942519
  br i1 %tag_eq6, label %march_arm4, label %march_next5

guard_pass:                                       ; preds = %march_arm
  %pgocount6 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 6), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 6), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 7), align 8
  %8 = add i64 %pgocount7, 1
  store i64 %8, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 7), align 8
  store i64 ptrtoint (ptr @.str to i64), ptr %match_result, align 8
  br label %match_end

march_arm4:                                       ; preds = %march_next
  %pay_slot7 = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %r_slot_base9 = ptrtoint ptr %payload8 to i64
  %r_slot_addr10 = add i64 %r_slot_base9, 0
  %r_slot11 = inttoptr i64 %r_slot_addr10 to ptr
  %r12 = load i64, ptr %r_slot11, align 8
  store i64 %r12, ptr %r13, align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 8), align 8
  %9 = add i64 %pgocount8, 1
  store i64 %9, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 8), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 9), align 8
  %10 = add i64 %pgocount9, 1
  store i64 %10, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 9), align 8
  %r14 = load i64, ptr %r13, align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 10), align 8
  %11 = add i64 %pgocount10, 1
  store i64 %11, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 10), align 8
  %sgt15 = icmp sgt i64 %r14, 5
  %sgt_ext16 = zext i1 %sgt15 to i64
  %guard17 = icmp ne i64 %sgt_ext16, 0
  br i1 %guard17, label %guard_pass18, label %march_next5

march_next5:                                      ; preds = %march_arm4, %march_next
  %tag_eq21 = icmp eq i64 %tag, 6952139942519
  br i1 %tag_eq21, label %march_arm19, label %march_next20

guard_pass18:                                     ; preds = %march_arm4
  %pgocount11 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 11), align 8
  %12 = add i64 %pgocount11, 1
  store i64 %12, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 11), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 12), align 8
  %13 = add i64 %pgocount12, 1
  store i64 %13, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 12), align 8
  store i64 ptrtoint (ptr @.str.1 to i64), ptr %match_result, align 8
  br label %match_end

march_arm19:                                      ; preds = %march_next5
  %pgocount13 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 13), align 8
  %14 = add i64 %pgocount13, 1
  store i64 %14, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 13), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 14), align 8
  %15 = add i64 %pgocount14, 1
  store i64 %15, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 14), align 8
  store i64 ptrtoint (ptr @.str.2 to i64), ptr %match_result, align 8
  br label %match_end

march_next20:                                     ; preds = %march_next5
  %tag_eq24 = icmp eq i64 %tag, 6384501107
  br i1 %tag_eq24, label %march_arm22, label %march_next23

march_arm22:                                      ; preds = %march_next20
  %pay_slot25 = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 1
  %payload26 = load ptr, ptr %pay_slot25, align 8
  %w_slot_base = ptrtoint ptr %payload26 to i64
  %w_slot_addr = add i64 %w_slot_base, 0
  %w_slot = inttoptr i64 %w_slot_addr to ptr
  %w = load i64, ptr %w_slot, align 8
  store i64 %w, ptr %w27, align 8
  %pay_slot28 = getelementptr inbounds nuw %Shape, ptr %s1, i32 0, i32 1
  %payload29 = load ptr, ptr %pay_slot28, align 8
  %h_slot_base = ptrtoint ptr %payload29 to i64
  %h_slot_addr = add i64 %h_slot_base, 8
  %h_slot = inttoptr i64 %h_slot_addr to ptr
  %h = load i64, ptr %h_slot, align 8
  store i64 %h, ptr %h30, align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 15), align 8
  %16 = add i64 %pgocount15, 1
  store i64 %16, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 15), align 8
  %pgocount16 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 16), align 8
  %17 = add i64 %pgocount16, 1
  store i64 %17, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 16), align 8
  %w31 = load i64, ptr %w27, align 8
  %pgocount17 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 17), align 8
  %18 = add i64 %pgocount17, 1
  store i64 %18, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 17), align 8
  %h32 = load i64, ptr %h30, align 8
  %eq = icmp eq i64 %w31, %h32
  %eq_ext = zext i1 %eq to i64
  %guard33 = icmp ne i64 %eq_ext, 0
  br i1 %guard33, label %guard_pass34, label %march_next23

march_next23:                                     ; preds = %march_arm22, %march_next20
  %tag_eq37 = icmp eq i64 %tag, 6384501107
  br i1 %tag_eq37, label %march_arm35, label %march_next36

guard_pass34:                                     ; preds = %march_arm22
  %pgocount18 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 18), align 8
  %19 = add i64 %pgocount18, 1
  store i64 %19, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 18), align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 19), align 8
  %20 = add i64 %pgocount19, 1
  store i64 %20, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 19), align 8
  store i64 ptrtoint (ptr @.str.3 to i64), ptr %match_result, align 8
  br label %match_end

march_arm35:                                      ; preds = %march_next23
  %pgocount20 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 20), align 8
  %21 = add i64 %pgocount20, 1
  store i64 %21, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 20), align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 21), align 8
  %22 = add i64 %pgocount21, 1
  store i64 %22, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 21), align 8
  store i64 ptrtoint (ptr @.str.4 to i64), ptr %match_result, align 8
  br label %match_end

march_next36:                                     ; preds = %march_next23
  call void @forge_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 8)
  unreachable
}

define ptr @check(i64 %0) {
entry:
  %pmatch_result = alloca i64, align 8
  %x = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_check, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_check, align 8
  store i64 %0, ptr %x, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_check, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([12 x i64], ptr @__profc_check, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_check, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([12 x i64], ptr @__profc_check, i32 0, i32 2), align 8
  %x1 = load i64, ptr %x, align 8
  store i64 0, ptr %pmatch_result, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_check, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([12 x i64], ptr @__profc_check, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_check, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([12 x i64], ptr @__profc_check, i32 0, i32 4), align 8
  %x2 = load i64, ptr %x, align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_check, i32 0, i32 5), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([12 x i64], ptr @__profc_check, i32 0, i32 5), align 8
  %sgt = icmp sgt i64 %x2, 100
  %sgt_ext = zext i1 %sgt to i64
  %pguard = icmp ne i64 %sgt_ext, 0
  br i1 %pguard, label %parm_body, label %parm_next

pmatch_end:                                       ; preds = %parm_body9, %parm_body3, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  %cast = inttoptr i64 %pmatch_val to ptr
  ret ptr %cast

parm_body:                                        ; preds = %entry
  %pgocount6 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_check, i32 0, i32 6), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([12 x i64], ptr @__profc_check, i32 0, i32 6), align 8
  store i64 ptrtoint (ptr @.str.5 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %entry
  %pgocount7 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_check, i32 0, i32 7), align 8
  %8 = add i64 %pgocount7, 1
  store i64 %8, ptr getelementptr inbounds ([12 x i64], ptr @__profc_check, i32 0, i32 7), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_check, i32 0, i32 8), align 8
  %9 = add i64 %pgocount8, 1
  store i64 %9, ptr getelementptr inbounds ([12 x i64], ptr @__profc_check, i32 0, i32 8), align 8
  %x5 = load i64, ptr %x, align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_check, i32 0, i32 9), align 8
  %10 = add i64 %pgocount9, 1
  store i64 %10, ptr getelementptr inbounds ([12 x i64], ptr @__profc_check, i32 0, i32 9), align 8
  %sgt6 = icmp sgt i64 %x5, 0
  %sgt_ext7 = zext i1 %sgt6 to i64
  %pguard8 = icmp ne i64 %sgt_ext7, 0
  br i1 %pguard8, label %parm_body3, label %parm_next4

parm_body3:                                       ; preds = %parm_next
  %pgocount10 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_check, i32 0, i32 10), align 8
  %11 = add i64 %pgocount10, 1
  store i64 %11, ptr getelementptr inbounds ([12 x i64], ptr @__profc_check, i32 0, i32 10), align 8
  store i64 ptrtoint (ptr @.str.6 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next4:                                       ; preds = %parm_next
  br label %parm_body9

parm_body9:                                       ; preds = %parm_next4
  %pgocount11 = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc_check, i32 0, i32 11), align 8
  %12 = add i64 %pgocount11, 1
  store i64 %12, ptr getelementptr inbounds ([12 x i64], ptr @__profc_check, i32 0, i32 11), align 8
  store i64 ptrtoint (ptr @.str.7 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next10:                                      ; No predecessors!
  call void @forge_match_unreachable(ptr @.match_fn.8, i64 -1, ptr @mu_file.9, i64 25)
  unreachable
}

define ptr @describe(ptr %0) {
entry:
  %c28 = alloca i64, align 8
  %c15 = alloca i64, align 8
  %v2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %r = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_describe, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_describe, align 8
  store ptr %0, ptr %r, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 2), align 8
  %r1 = load ptr, ptr %r, align 8
  %tag_ptr = getelementptr inbounds nuw %Result, ptr %r1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 5862623
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm19, %guard_pass18, %march_arm7, %guard_pass
  %match_val = load i64, ptr %match_result, align 8
  %cast38 = inttoptr i64 %match_val to ptr
  ret ptr %cast38

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Result, ptr %r1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load i64, ptr %v_slot, align 8
  store i64 %v, ptr %v2, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 4), align 8
  %v3 = load i64, ptr %v2, align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 5), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 5), align 8
  %sgt = icmp sgt i64 %v3, 0
  %sgt_ext = zext i1 %sgt to i64
  %guard = icmp ne i64 %sgt_ext, 0
  br i1 %guard, label %guard_pass, label %march_next

march_next:                                       ; preds = %march_arm, %entry
  %tag_eq9 = icmp eq i64 %tag, 5862623
  br i1 %tag_eq9, label %march_arm7, label %march_next8

guard_pass:                                       ; preds = %march_arm
  %pgocount6 = load i64, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 6), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 6), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 7), align 8
  %8 = add i64 %pgocount7, 1
  store i64 %8, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 7), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 8), align 8
  %9 = add i64 %pgocount8, 1
  store i64 %9, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 8), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 9), align 8
  %10 = add i64 %pgocount9, 1
  store i64 %10, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 9), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 10), align 8
  %11 = add i64 %pgocount10, 1
  store i64 %11, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 10), align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 11), align 8
  %12 = add i64 %pgocount11, 1
  store i64 %12, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 11), align 8
  %v4 = load i64, ptr %v2, align 8
  %13 = call ptr @forge_rc_alloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @.i2s_fmt, i64 %v4)
  %widen = sext i32 %14 to i64
  %15 = call i64 @strlen(ptr @.str.10)
  %16 = call i64 @strlen(ptr %13)
  %concat_total = add i64 %15, %16
  %concat_size = add i64 %concat_total, 1
  %17 = call ptr @forge_rc_alloc(i64 %concat_size)
  %18 = call ptr @memcpy(ptr %17, ptr @.str.10, i64 %15)
  %cast = ptrtoint ptr %17 to i64
  %dst2_int = add i64 %cast, %15
  %cast5 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %16, 1
  %19 = call ptr @memcpy(ptr %cast5, ptr %13, i64 %rhs_len_p1)
  %cast6 = ptrtoint ptr %17 to i64
  store i64 %cast6, ptr %match_result, align 8
  br label %match_end

march_arm7:                                       ; preds = %march_next
  %pgocount12 = load i64, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 12), align 8
  %20 = add i64 %pgocount12, 1
  store i64 %20, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 12), align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 13), align 8
  %21 = add i64 %pgocount13, 1
  store i64 %21, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 13), align 8
  store i64 ptrtoint (ptr @.str.11 to i64), ptr %match_result, align 8
  br label %match_end

march_next8:                                      ; preds = %march_next
  %tag_eq12 = icmp eq i64 %tag, 193456014
  br i1 %tag_eq12, label %march_arm10, label %march_next11

march_arm10:                                      ; preds = %march_next8
  %pay_slot13 = getelementptr inbounds nuw %Result, ptr %r1, i32 0, i32 1
  %payload14 = load ptr, ptr %pay_slot13, align 8
  %c_slot_base = ptrtoint ptr %payload14 to i64
  %c_slot_addr = add i64 %c_slot_base, 0
  %c_slot = inttoptr i64 %c_slot_addr to ptr
  %c = load i64, ptr %c_slot, align 8
  store i64 %c, ptr %c15, align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 14), align 8
  %22 = add i64 %pgocount14, 1
  store i64 %22, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 14), align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 15), align 8
  %23 = add i64 %pgocount15, 1
  store i64 %23, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 15), align 8
  %c16 = load i64, ptr %c15, align 8
  %pgocount16 = load i64, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 16), align 8
  %24 = add i64 %pgocount16, 1
  store i64 %24, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 16), align 8
  %eq = icmp eq i64 %c16, 404
  %eq_ext = zext i1 %eq to i64
  %guard17 = icmp ne i64 %eq_ext, 0
  br i1 %guard17, label %guard_pass18, label %march_next11

march_next11:                                     ; preds = %march_arm10, %march_next8
  %tag_eq21 = icmp eq i64 %tag, 193456014
  br i1 %tag_eq21, label %march_arm19, label %march_next20

guard_pass18:                                     ; preds = %march_arm10
  %pgocount17 = load i64, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 17), align 8
  %25 = add i64 %pgocount17, 1
  store i64 %25, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 17), align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 18), align 8
  %26 = add i64 %pgocount18, 1
  store i64 %26, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 18), align 8
  store i64 ptrtoint (ptr @.str.12 to i64), ptr %match_result, align 8
  br label %match_end

march_arm19:                                      ; preds = %march_next11
  %pay_slot22 = getelementptr inbounds nuw %Result, ptr %r1, i32 0, i32 1
  %payload23 = load ptr, ptr %pay_slot22, align 8
  %c_slot_base24 = ptrtoint ptr %payload23 to i64
  %c_slot_addr25 = add i64 %c_slot_base24, 0
  %c_slot26 = inttoptr i64 %c_slot_addr25 to ptr
  %c27 = load i64, ptr %c_slot26, align 8
  store i64 %c27, ptr %c28, align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 19), align 8
  %27 = add i64 %pgocount19, 1
  store i64 %27, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 19), align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 20), align 8
  %28 = add i64 %pgocount20, 1
  store i64 %28, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 20), align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 21), align 8
  %29 = add i64 %pgocount21, 1
  store i64 %29, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 21), align 8
  %pgocount22 = load i64, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 22), align 8
  %30 = add i64 %pgocount22, 1
  store i64 %30, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 22), align 8
  %pgocount23 = load i64, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 23), align 8
  %31 = add i64 %pgocount23, 1
  store i64 %31, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 23), align 8
  %pgocount24 = load i64, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 24), align 8
  %32 = add i64 %pgocount24, 1
  store i64 %32, ptr getelementptr inbounds ([25 x i64], ptr @__profc_describe, i32 0, i32 24), align 8
  %c29 = load i64, ptr %c28, align 8
  %33 = call ptr @forge_rc_alloc(i64 32)
  %34 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %33, i64 32, ptr @.i2s_fmt.14, i64 %c29)
  %widen30 = sext i32 %34 to i64
  %35 = call i64 @strlen(ptr @.str.13)
  %36 = call i64 @strlen(ptr %33)
  %concat_total31 = add i64 %35, %36
  %concat_size32 = add i64 %concat_total31, 1
  %37 = call ptr @forge_rc_alloc(i64 %concat_size32)
  %38 = call ptr @memcpy(ptr %37, ptr @.str.13, i64 %35)
  %cast33 = ptrtoint ptr %37 to i64
  %dst2_int34 = add i64 %cast33, %35
  %cast35 = inttoptr i64 %dst2_int34 to ptr
  %rhs_len_p136 = add i64 %36, 1
  %39 = call ptr @memcpy(ptr %cast35, ptr %33, i64 %rhs_len_p136)
  %cast37 = ptrtoint ptr %37 to i64
  store i64 %cast37, ptr %match_result, align 8
  br label %match_end

march_next20:                                     ; preds = %march_next11
  call void @forge_match_unreachable(ptr @.match_fn.15, i64 %tag, ptr @mu_file.16, i64 42)
  unreachable
}

define ptr @greet(ptr %0) {
entry:
  %pmatch_result = alloca i64, align 8
  %name = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_greet, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_greet, align 8
  store ptr %0, ptr %name, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 2), align 8
  %name1 = load ptr, ptr %name, align 8
  store i64 0, ptr %pmatch_result, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 4), align 8
  %name2 = load ptr, ptr %name, align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 5), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 5), align 8
  %7 = call i32 @strcmp(ptr %name2, ptr @.str.17)
  %widen = sext i32 %7 to i64
  %streq_cmp = icmp eq i64 %widen, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %pguard = icmp ne i64 %streq_ext, 0
  br i1 %pguard, label %parm_body, label %parm_next

pmatch_end:                                       ; preds = %parm_body16, %parm_body3, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  %cast32 = inttoptr i64 %pmatch_val to ptr
  ret ptr %cast32

parm_body:                                        ; preds = %entry
  %pgocount6 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 6), align 8
  %8 = add i64 %pgocount6, 1
  store i64 %8, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 6), align 8
  store i64 ptrtoint (ptr @.str.18 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %entry
  %pgocount7 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 7), align 8
  %9 = add i64 %pgocount7, 1
  store i64 %9, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 7), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 8), align 8
  %10 = add i64 %pgocount8, 1
  store i64 %10, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 8), align 8
  %name5 = load ptr, ptr %name, align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 9), align 8
  %11 = add i64 %pgocount9, 1
  store i64 %11, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 9), align 8
  %12 = call i64 @forge_str_starts_with(ptr %name5, ptr @.str.19)
  %pguard6 = icmp ne i64 %12, 0
  br i1 %pguard6, label %parm_body3, label %parm_next4

parm_body3:                                       ; preds = %parm_next
  %pgocount10 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 10), align 8
  %13 = add i64 %pgocount10, 1
  store i64 %13, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 10), align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 11), align 8
  %14 = add i64 %pgocount11, 1
  store i64 %14, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 11), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 12), align 8
  %15 = add i64 %pgocount12, 1
  store i64 %15, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 12), align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 13), align 8
  %16 = add i64 %pgocount13, 1
  store i64 %16, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 13), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 14), align 8
  %17 = add i64 %pgocount14, 1
  store i64 %17, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 14), align 8
  %name7 = load ptr, ptr %name, align 8
  %18 = call i64 @strlen(ptr @.str.20)
  %19 = call i64 @strlen(ptr %name7)
  %concat_total = add i64 %18, %19
  %concat_size = add i64 %concat_total, 1
  %20 = call ptr @forge_rc_alloc(i64 %concat_size)
  %21 = call ptr @memcpy(ptr %20, ptr @.str.20, i64 %18)
  %cast = ptrtoint ptr %20 to i64
  %dst2_int = add i64 %cast, %18
  %cast8 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %19, 1
  %22 = call ptr @memcpy(ptr %cast8, ptr %name7, i64 %rhs_len_p1)
  %pgocount15 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 15), align 8
  %23 = add i64 %pgocount15, 1
  store i64 %23, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 15), align 8
  %24 = call i64 @strlen(ptr %20)
  %25 = call i64 @strlen(ptr @.str.21)
  %concat_total9 = add i64 %24, %25
  %concat_size10 = add i64 %concat_total9, 1
  %26 = call ptr @forge_rc_alloc(i64 %concat_size10)
  %27 = call ptr @memcpy(ptr %26, ptr %20, i64 %24)
  %cast11 = ptrtoint ptr %26 to i64
  %dst2_int12 = add i64 %cast11, %24
  %cast13 = inttoptr i64 %dst2_int12 to ptr
  %rhs_len_p114 = add i64 %25, 1
  %28 = call ptr @memcpy(ptr %cast13, ptr @.str.21, i64 %rhs_len_p114)
  %cast15 = ptrtoint ptr %26 to i64
  store i64 %cast15, ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next4:                                       ; preds = %parm_next
  br label %parm_body16

parm_body16:                                      ; preds = %parm_next4
  %pgocount16 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 16), align 8
  %29 = add i64 %pgocount16, 1
  store i64 %29, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 16), align 8
  %pgocount17 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 17), align 8
  %30 = add i64 %pgocount17, 1
  store i64 %30, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 17), align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 18), align 8
  %31 = add i64 %pgocount18, 1
  store i64 %31, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 18), align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 19), align 8
  %32 = add i64 %pgocount19, 1
  store i64 %32, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 19), align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 20), align 8
  %33 = add i64 %pgocount20, 1
  store i64 %33, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 20), align 8
  %name18 = load ptr, ptr %name, align 8
  %34 = call i64 @strlen(ptr @.str.22)
  %35 = call i64 @strlen(ptr %name18)
  %concat_total19 = add i64 %34, %35
  %concat_size20 = add i64 %concat_total19, 1
  %36 = call ptr @forge_rc_alloc(i64 %concat_size20)
  %37 = call ptr @memcpy(ptr %36, ptr @.str.22, i64 %34)
  %cast21 = ptrtoint ptr %36 to i64
  %dst2_int22 = add i64 %cast21, %34
  %cast23 = inttoptr i64 %dst2_int22 to ptr
  %rhs_len_p124 = add i64 %35, 1
  %38 = call ptr @memcpy(ptr %cast23, ptr %name18, i64 %rhs_len_p124)
  %pgocount21 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 21), align 8
  %39 = add i64 %pgocount21, 1
  store i64 %39, ptr getelementptr inbounds ([22 x i64], ptr @__profc_greet, i32 0, i32 21), align 8
  %40 = call i64 @strlen(ptr %36)
  %41 = call i64 @strlen(ptr @.str.23)
  %concat_total25 = add i64 %40, %41
  %concat_size26 = add i64 %concat_total25, 1
  %42 = call ptr @forge_rc_alloc(i64 %concat_size26)
  %43 = call ptr @memcpy(ptr %42, ptr %36, i64 %40)
  %cast27 = ptrtoint ptr %42 to i64
  %dst2_int28 = add i64 %cast27, %40
  %cast29 = inttoptr i64 %dst2_int28 to ptr
  %rhs_len_p130 = add i64 %41, 1
  %44 = call ptr @memcpy(ptr %cast29, ptr @.str.23, i64 %rhs_len_p130)
  %cast31 = ptrtoint ptr %42 to i64
  store i64 %cast31, ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next17:                                      ; No predecessors!
  call void @forge_match_unreachable(ptr @.match_fn.24, i64 -1, ptr @mu_file.25, i64 56)
  unreachable
}

define i64 @main() {
entry:
  %pgocount = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %3 = add i64 %pgocount3, 1
  store i64 %3, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %4 = add i64 %pgocount4, 1
  store i64 %4, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %5 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Shape, ptr %5, i32 0, i32 0
  store i64 6952139942519, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Shape, ptr %5, i32 0, i32 1
  %6 = call ptr @forge_rc_alloc(i64 8)
  store ptr %6, ptr %pay_ptr, align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %7 = add i64 %pgocount5, 1
  store i64 %7, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %slot_base = ptrtoint ptr %6 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 15, ptr %slot, align 8
  %cast = ptrtoint ptr %5 to i64
  %cast1 = inttoptr i64 %cast to ptr
  %8 = call ptr @classify(ptr %cast1)
  %9 = call i32 @puts(ptr %8)
  %widen = sext i32 %9 to i64
  %pgocount6 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %10 = add i64 %pgocount6, 1
  store i64 %10, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %11 = add i64 %pgocount7, 1
  store i64 %11, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %12 = add i64 %pgocount8, 1
  store i64 %12, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %13 = add i64 %pgocount9, 1
  store i64 %13, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %14 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr2 = getelementptr inbounds nuw %Shape, ptr %14, i32 0, i32 0
  store i64 6952139942519, ptr %tag_ptr2, align 8
  %pay_ptr3 = getelementptr inbounds nuw %Shape, ptr %14, i32 0, i32 1
  %15 = call ptr @forge_rc_alloc(i64 8)
  store ptr %15, ptr %pay_ptr3, align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %16 = add i64 %pgocount10, 1
  store i64 %16, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %slot_base4 = ptrtoint ptr %15 to i64
  %slot_addr5 = add i64 %slot_base4, 0
  %slot6 = inttoptr i64 %slot_addr5 to ptr
  store i64 7, ptr %slot6, align 8
  %cast7 = ptrtoint ptr %14 to i64
  %cast8 = inttoptr i64 %cast7 to ptr
  %17 = call ptr @classify(ptr %cast8)
  %18 = call i32 @puts(ptr %17)
  %widen9 = sext i32 %18 to i64
  %pgocount11 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %19 = add i64 %pgocount11, 1
  store i64 %19, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %20 = add i64 %pgocount12, 1
  store i64 %20, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %21 = add i64 %pgocount13, 1
  store i64 %21, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %22 = add i64 %pgocount14, 1
  store i64 %22, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %23 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr10 = getelementptr inbounds nuw %Shape, ptr %23, i32 0, i32 0
  store i64 6952139942519, ptr %tag_ptr10, align 8
  %pay_ptr11 = getelementptr inbounds nuw %Shape, ptr %23, i32 0, i32 1
  %24 = call ptr @forge_rc_alloc(i64 8)
  store ptr %24, ptr %pay_ptr11, align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %25 = add i64 %pgocount15, 1
  store i64 %25, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %slot_base12 = ptrtoint ptr %24 to i64
  %slot_addr13 = add i64 %slot_base12, 0
  %slot14 = inttoptr i64 %slot_addr13 to ptr
  store i64 2, ptr %slot14, align 8
  %cast15 = ptrtoint ptr %23 to i64
  %cast16 = inttoptr i64 %cast15 to ptr
  %26 = call ptr @classify(ptr %cast16)
  %27 = call i32 @puts(ptr %26)
  %widen17 = sext i32 %27 to i64
  %pgocount16 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %28 = add i64 %pgocount16, 1
  store i64 %28, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %pgocount17 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %29 = add i64 %pgocount17, 1
  store i64 %29, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %30 = add i64 %pgocount18, 1
  store i64 %30, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %31 = add i64 %pgocount19, 1
  store i64 %31, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %32 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr18 = getelementptr inbounds nuw %Shape, ptr %32, i32 0, i32 0
  store i64 6384501107, ptr %tag_ptr18, align 8
  %pay_ptr19 = getelementptr inbounds nuw %Shape, ptr %32, i32 0, i32 1
  %33 = call ptr @forge_rc_alloc(i64 16)
  store ptr %33, ptr %pay_ptr19, align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %34 = add i64 %pgocount20, 1
  store i64 %34, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %slot_base20 = ptrtoint ptr %33 to i64
  %slot_addr21 = add i64 %slot_base20, 0
  %slot22 = inttoptr i64 %slot_addr21 to ptr
  store i64 5, ptr %slot22, align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %35 = add i64 %pgocount21, 1
  store i64 %35, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %slot_base23 = ptrtoint ptr %33 to i64
  %slot_addr24 = add i64 %slot_base23, 8
  %slot25 = inttoptr i64 %slot_addr24 to ptr
  store i64 5, ptr %slot25, align 8
  %cast26 = ptrtoint ptr %32 to i64
  %cast27 = inttoptr i64 %cast26 to ptr
  %36 = call ptr @classify(ptr %cast27)
  %37 = call i32 @puts(ptr %36)
  %widen28 = sext i32 %37 to i64
  %pgocount22 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %38 = add i64 %pgocount22, 1
  store i64 %38, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %pgocount23 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %39 = add i64 %pgocount23, 1
  store i64 %39, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %pgocount24 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %40 = add i64 %pgocount24, 1
  store i64 %40, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %pgocount25 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %41 = add i64 %pgocount25, 1
  store i64 %41, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %42 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr29 = getelementptr inbounds nuw %Shape, ptr %42, i32 0, i32 0
  store i64 6384501107, ptr %tag_ptr29, align 8
  %pay_ptr30 = getelementptr inbounds nuw %Shape, ptr %42, i32 0, i32 1
  %43 = call ptr @forge_rc_alloc(i64 16)
  store ptr %43, ptr %pay_ptr30, align 8
  %pgocount26 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %44 = add i64 %pgocount26, 1
  store i64 %44, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %slot_base31 = ptrtoint ptr %43 to i64
  %slot_addr32 = add i64 %slot_base31, 0
  %slot33 = inttoptr i64 %slot_addr32 to ptr
  store i64 3, ptr %slot33, align 8
  %pgocount27 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %45 = add i64 %pgocount27, 1
  store i64 %45, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %slot_base34 = ptrtoint ptr %43 to i64
  %slot_addr35 = add i64 %slot_base34, 8
  %slot36 = inttoptr i64 %slot_addr35 to ptr
  store i64 7, ptr %slot36, align 8
  %cast37 = ptrtoint ptr %42 to i64
  %cast38 = inttoptr i64 %cast37 to ptr
  %46 = call ptr @classify(ptr %cast38)
  %47 = call i32 @puts(ptr %46)
  %widen39 = sext i32 %47 to i64
  %pgocount28 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %48 = add i64 %pgocount28, 1
  store i64 %48, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %pgocount29 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %49 = add i64 %pgocount29, 1
  store i64 %49, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %pgocount30 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 52), align 8
  %50 = add i64 %pgocount30, 1
  store i64 %50, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 52), align 8
  %pgocount31 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 53), align 8
  %51 = add i64 %pgocount31, 1
  store i64 %51, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 53), align 8
  %52 = call ptr @check(i64 200)
  %53 = call i32 @puts(ptr %52)
  %widen40 = sext i32 %53 to i64
  %pgocount32 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 54), align 8
  %54 = add i64 %pgocount32, 1
  store i64 %54, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 54), align 8
  %pgocount33 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 55), align 8
  %55 = add i64 %pgocount33, 1
  store i64 %55, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 55), align 8
  %pgocount34 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 56), align 8
  %56 = add i64 %pgocount34, 1
  store i64 %56, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 56), align 8
  %pgocount35 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 57), align 8
  %57 = add i64 %pgocount35, 1
  store i64 %57, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 57), align 8
  %58 = call ptr @check(i64 50)
  %59 = call i32 @puts(ptr %58)
  %widen41 = sext i32 %59 to i64
  %pgocount36 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 58), align 8
  %60 = add i64 %pgocount36, 1
  store i64 %60, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 58), align 8
  %pgocount37 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 59), align 8
  %61 = add i64 %pgocount37, 1
  store i64 %61, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 59), align 8
  %pgocount38 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 60), align 8
  %62 = add i64 %pgocount38, 1
  store i64 %62, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 60), align 8
  %pgocount39 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 61), align 8
  %63 = add i64 %pgocount39, 1
  store i64 %63, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 61), align 8
  %pgocount40 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 62), align 8
  %64 = add i64 %pgocount40, 1
  store i64 %64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 62), align 8
  %65 = call ptr @check(i64 -5)
  %66 = call i32 @puts(ptr %65)
  %widen42 = sext i32 %66 to i64
  %pgocount41 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 63), align 8
  %67 = add i64 %pgocount41, 1
  store i64 %67, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 63), align 8
  %pgocount42 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 64), align 8
  %68 = add i64 %pgocount42, 1
  store i64 %68, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 64), align 8
  %pgocount43 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 65), align 8
  %69 = add i64 %pgocount43, 1
  store i64 %69, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 65), align 8
  %pgocount44 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 66), align 8
  %70 = add i64 %pgocount44, 1
  store i64 %70, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 66), align 8
  %pgocount45 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 67), align 8
  %71 = add i64 %pgocount45, 1
  store i64 %71, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 67), align 8
  %72 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr43 = getelementptr inbounds nuw %Result, ptr %72, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr43, align 8
  %pay_ptr44 = getelementptr inbounds nuw %Result, ptr %72, i32 0, i32 1
  %73 = call ptr @forge_rc_alloc(i64 8)
  store ptr %73, ptr %pay_ptr44, align 8
  %pgocount46 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 68), align 8
  %74 = add i64 %pgocount46, 1
  store i64 %74, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 68), align 8
  %slot_base45 = ptrtoint ptr %73 to i64
  %slot_addr46 = add i64 %slot_base45, 0
  %slot47 = inttoptr i64 %slot_addr46 to ptr
  store i64 42, ptr %slot47, align 8
  %cast48 = ptrtoint ptr %72 to i64
  %cast49 = inttoptr i64 %cast48 to ptr
  %75 = call ptr @describe(ptr %cast49)
  %76 = call i32 @puts(ptr %75)
  %widen50 = sext i32 %76 to i64
  %pgocount47 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 69), align 8
  %77 = add i64 %pgocount47, 1
  store i64 %77, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 69), align 8
  %pgocount48 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 70), align 8
  %78 = add i64 %pgocount48, 1
  store i64 %78, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 70), align 8
  %pgocount49 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 71), align 8
  %79 = add i64 %pgocount49, 1
  store i64 %79, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 71), align 8
  %pgocount50 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 72), align 8
  %80 = add i64 %pgocount50, 1
  store i64 %80, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 72), align 8
  %81 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr51 = getelementptr inbounds nuw %Result, ptr %81, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr51, align 8
  %pay_ptr52 = getelementptr inbounds nuw %Result, ptr %81, i32 0, i32 1
  %82 = call ptr @forge_rc_alloc(i64 8)
  store ptr %82, ptr %pay_ptr52, align 8
  %pgocount51 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 73), align 8
  %83 = add i64 %pgocount51, 1
  store i64 %83, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 73), align 8
  %pgocount52 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 74), align 8
  %84 = add i64 %pgocount52, 1
  store i64 %84, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 74), align 8
  %slot_base53 = ptrtoint ptr %82 to i64
  %slot_addr54 = add i64 %slot_base53, 0
  %slot55 = inttoptr i64 %slot_addr54 to ptr
  store i64 -1, ptr %slot55, align 8
  %cast56 = ptrtoint ptr %81 to i64
  %cast57 = inttoptr i64 %cast56 to ptr
  %85 = call ptr @describe(ptr %cast57)
  %86 = call i32 @puts(ptr %85)
  %widen58 = sext i32 %86 to i64
  %pgocount53 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 75), align 8
  %87 = add i64 %pgocount53, 1
  store i64 %87, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 75), align 8
  %pgocount54 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 76), align 8
  %88 = add i64 %pgocount54, 1
  store i64 %88, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 76), align 8
  %pgocount55 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 77), align 8
  %89 = add i64 %pgocount55, 1
  store i64 %89, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 77), align 8
  %pgocount56 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 78), align 8
  %90 = add i64 %pgocount56, 1
  store i64 %90, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 78), align 8
  %91 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr59 = getelementptr inbounds nuw %Result, ptr %91, i32 0, i32 0
  store i64 193456014, ptr %tag_ptr59, align 8
  %pay_ptr60 = getelementptr inbounds nuw %Result, ptr %91, i32 0, i32 1
  %92 = call ptr @forge_rc_alloc(i64 8)
  store ptr %92, ptr %pay_ptr60, align 8
  %pgocount57 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 79), align 8
  %93 = add i64 %pgocount57, 1
  store i64 %93, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 79), align 8
  %slot_base61 = ptrtoint ptr %92 to i64
  %slot_addr62 = add i64 %slot_base61, 0
  %slot63 = inttoptr i64 %slot_addr62 to ptr
  store i64 404, ptr %slot63, align 8
  %cast64 = ptrtoint ptr %91 to i64
  %cast65 = inttoptr i64 %cast64 to ptr
  %94 = call ptr @describe(ptr %cast65)
  %95 = call i32 @puts(ptr %94)
  %widen66 = sext i32 %95 to i64
  %pgocount58 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 80), align 8
  %96 = add i64 %pgocount58, 1
  store i64 %96, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 80), align 8
  %pgocount59 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 81), align 8
  %97 = add i64 %pgocount59, 1
  store i64 %97, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 81), align 8
  %pgocount60 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 82), align 8
  %98 = add i64 %pgocount60, 1
  store i64 %98, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 82), align 8
  %pgocount61 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 83), align 8
  %99 = add i64 %pgocount61, 1
  store i64 %99, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 83), align 8
  %100 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr67 = getelementptr inbounds nuw %Result, ptr %100, i32 0, i32 0
  store i64 193456014, ptr %tag_ptr67, align 8
  %pay_ptr68 = getelementptr inbounds nuw %Result, ptr %100, i32 0, i32 1
  %101 = call ptr @forge_rc_alloc(i64 8)
  store ptr %101, ptr %pay_ptr68, align 8
  %pgocount62 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 84), align 8
  %102 = add i64 %pgocount62, 1
  store i64 %102, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 84), align 8
  %slot_base69 = ptrtoint ptr %101 to i64
  %slot_addr70 = add i64 %slot_base69, 0
  %slot71 = inttoptr i64 %slot_addr70 to ptr
  store i64 500, ptr %slot71, align 8
  %cast72 = ptrtoint ptr %100 to i64
  %cast73 = inttoptr i64 %cast72 to ptr
  %103 = call ptr @describe(ptr %cast73)
  %104 = call i32 @puts(ptr %103)
  %widen74 = sext i32 %104 to i64
  %pgocount63 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 85), align 8
  %105 = add i64 %pgocount63, 1
  store i64 %105, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 85), align 8
  %pgocount64 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 86), align 8
  %106 = add i64 %pgocount64, 1
  store i64 %106, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 86), align 8
  %pgocount65 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 87), align 8
  %107 = add i64 %pgocount65, 1
  store i64 %107, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 87), align 8
  %pgocount66 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 88), align 8
  %108 = add i64 %pgocount66, 1
  store i64 %108, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 88), align 8
  %109 = call ptr @greet(ptr @.str.26)
  %110 = call i32 @puts(ptr %109)
  %widen75 = sext i32 %110 to i64
  %pgocount67 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 89), align 8
  %111 = add i64 %pgocount67, 1
  store i64 %111, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 89), align 8
  %pgocount68 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 90), align 8
  %112 = add i64 %pgocount68, 1
  store i64 %112, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 90), align 8
  %pgocount69 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 91), align 8
  %113 = add i64 %pgocount69, 1
  store i64 %113, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 91), align 8
  %pgocount70 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 92), align 8
  %114 = add i64 %pgocount70, 1
  store i64 %114, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 92), align 8
  %115 = call ptr @greet(ptr @.str.27)
  %116 = call i32 @puts(ptr %115)
  %widen76 = sext i32 %116 to i64
  %pgocount71 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 93), align 8
  %117 = add i64 %pgocount71, 1
  store i64 %117, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 93), align 8
  %pgocount72 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 94), align 8
  %118 = add i64 %pgocount72, 1
  store i64 %118, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 94), align 8
  %pgocount73 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 95), align 8
  %119 = add i64 %pgocount73, 1
  store i64 %119, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 95), align 8
  %pgocount74 = load i64, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 96), align 8
  %120 = add i64 %pgocount74, 1
  store i64 %120, ptr getelementptr inbounds ([97 x i64], ptr @__profc_main, i32 0, i32 96), align 8
  %121 = call ptr @greet(ptr @.str.28)
  %122 = call i32 @puts(ptr %121)
  %widen77 = sext i32 %122 to i64
  %123 = call i32 @forge_test_summary()
  %widen78 = sext i32 %123 to i64
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
