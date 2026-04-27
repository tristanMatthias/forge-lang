; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/guard_aggressive.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

%Expr = type { i64, ptr }
%Response = type { i64, ptr }
%Response__Error = type { i64, ptr }
%Expr__Add = type { ptr, ptr }

@scores = global i64 0
@grades = global i64 0
@.match_fn = private unnamed_addr constant [5 x i8] c"eval\00", align 1
@mu_file = private unnamed_addr constant [143 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/guard_aggressive.fg\00", align 1
@.str = private unnamed_addr constant [5 x i8] c"zero\00", align 1
@.str.1 = private unnamed_addr constant [15 x i8] c"small positive\00", align 1
@.str.2 = private unnamed_addr constant [15 x i8] c"large positive\00", align 1
@.str.3 = private unnamed_addr constant [9 x i8] c"negative\00", align 1
@.str.4 = private unnamed_addr constant [8 x i8] c"big sum\00", align 1
@.str.5 = private unnamed_addr constant [4 x i8] c"sum\00", align 1
@.match_fn.6 = private unnamed_addr constant [14 x i8] c"classify_expr\00", align 1
@mu_file.7 = private unnamed_addr constant [143 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/guard_aggressive.fg\00", align 1
@.match_fn.8 = private unnamed_addr constant [4 x i8] c"abs\00", align 1
@mu_file.9 = private unnamed_addr constant [143 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/guard_aggressive.fg\00", align 1
@.str.10 = private unnamed_addr constant [6 x i8] c"empty\00", align 1
@.str.11 = private unnamed_addr constant [6 x i8] c"short\00", align 1
@.str.12 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.13 = private unnamed_addr constant [11 x i8] c"multi-word\00", align 1
@.str.14 = private unnamed_addr constant [12 x i8] c"single word\00", align 1
@.match_fn.15 = private unnamed_addr constant [11 x i8] c"categorize\00", align 1
@mu_file.16 = private unnamed_addr constant [143 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/guard_aggressive.fg\00", align 1
@.str.17 = private unnamed_addr constant [3 x i8] c"OK\00", align 1
@.str.18 = private unnamed_addr constant [8 x i8] c"Created\00", align 1
@.str.19 = private unnamed_addr constant [9 x i8] c"Success \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.20 = private unnamed_addr constant [15 x i8] c"Server error: \00", align 1
@.str.21 = private unnamed_addr constant [10 x i8] c"Not found\00", align 1
@.str.22 = private unnamed_addr constant [7 x i8] c"Error \00", align 1
@.i2s_fmt.23 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.24 = private unnamed_addr constant [3 x i8] c": \00", align 1
@.match_fn.25 = private unnamed_addr constant [18 x i8] c"describe_response\00", align 1
@mu_file.26 = private unnamed_addr constant [143 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/guard_aggressive.fg\00", align 1
@.i2s_fmt.27 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.28 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.29 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.30 = private unnamed_addr constant [3 x i8] c"hi\00", align 1
@.str.31 = private unnamed_addr constant [12 x i8] c"hello world\00", align 1
@.str.32 = private unnamed_addr constant [21 x i8] c"supercalifragilistic\00", align 1
@.str.33 = private unnamed_addr constant [2 x i8] c"A\00", align 1
@.str.34 = private unnamed_addr constant [2 x i8] c"B\00", align 1
@.str.35 = private unnamed_addr constant [2 x i8] c"C\00", align 1
@.str.36 = private unnamed_addr constant [2 x i8] c"D\00", align 1
@.str.37 = private unnamed_addr constant [2 x i8] c"F\00", align 1
@.match_fn.38 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.39 = private unnamed_addr constant [143 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/guard_aggressive.fg\00", align 1
@.str.40 = private unnamed_addr constant [9 x i8] c"internal\00", align 1
@.str.41 = private unnamed_addr constant [8 x i8] c"missing\00", align 1
@.str.42 = private unnamed_addr constant [10 x i8] c"forbidden\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_eval = private global [11 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_eval = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 8418976871401647406, i64 6385202349, i64 sub (i64 ptrtoint (ptr @__profc_eval to i64), i64 ptrtoint (ptr @__profd_eval to i64)), i64 0, ptr null, ptr null, i32 11, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_classify_expr = private global [39 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_classify_expr = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -7875901852572344936, i64 -4065029082934195551, i64 sub (i64 ptrtoint (ptr @__profc_classify_expr to i64), i64 ptrtoint (ptr @__profd_classify_expr to i64)), i64 0, ptr null, ptr null, i32 39, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_abs = private global [9 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_abs = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -238465663743841031, i64 193485979, i64 sub (i64 ptrtoint (ptr @__profc_abs to i64), i64 ptrtoint (ptr @__profd_abs to i64)), i64 0, ptr null, ptr null, i32 9, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_categorize = private global [18 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_categorize = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 4964095237254911996, i64 8246162756644210994, i64 sub (i64 ptrtoint (ptr @__profc_categorize to i64), i64 ptrtoint (ptr @__profd_categorize to i64)), i64 0, ptr null, ptr null, i32 18, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_describe_response = private global [43 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_describe_response = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 7054656464022431707, i64 -832798467139318892, i64 sub (i64 ptrtoint (ptr @__profc_describe_response to i64), i64 ptrtoint (ptr @__profd_describe_response to i64)), i64 0, ptr null, ptr null, i32 43, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_main = private global [185 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 185, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__llvm_prf_nm = private constant [60 x i8] c"8:x\DA\05\C1\01\0A\80 \10\04@\EE\A5\B2^\9B\1C\98\CAmH\F5\FAf\B8\D1\CD;\A48\DF\C2g\A5\A1\CA\1C7\DB\CC\F8h\07\E5\19\95%\A95\87h\17b\FCY\DA\15A", section "__DATA,__llvm_prf_names", align 1
@llvm.compiler.used = appending global [7 x ptr] [ptr @__llvm_profile_runtime_user, ptr @__profd_eval, ptr @__profd_classify_expr, ptr @__profd_abs, ptr @__profd_categorize, ptr @__profd_describe_response, ptr @__profd_main], section "llvm.metadata"
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

define i64 @eval(ptr %0) {
entry:
  %b12 = alloca ptr, align 8
  %a9 = alloca ptr, align 8
  %n2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %e = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_eval, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_eval, align 8
  store ptr %0, ptr %e, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_eval, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([11 x i64], ptr @__profc_eval, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_eval, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([11 x i64], ptr @__profc_eval, i32 0, i32 2), align 8
  %e1 = load ptr, ptr %e, align 8
  %tag_ptr = getelementptr inbounds nuw %Expr, ptr %e1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193465909
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm4, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Expr, ptr %e1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %n_slot_base = ptrtoint ptr %payload to i64
  %n_slot_addr = add i64 %n_slot_base, 0
  %n_slot = inttoptr i64 %n_slot_addr to ptr
  %n = load i64, ptr %n_slot, align 8
  store i64 %n, ptr %n2, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_eval, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([11 x i64], ptr @__profc_eval, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_eval, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([11 x i64], ptr @__profc_eval, i32 0, i32 4), align 8
  %n3 = load i64, ptr %n2, align 8
  store i64 %n3, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq6 = icmp eq i64 %tag, 193451182
  br i1 %tag_eq6, label %march_arm4, label %march_next5

march_arm4:                                       ; preds = %march_next
  %pay_slot7 = getelementptr inbounds nuw %Expr, ptr %e1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %a_slot_base = ptrtoint ptr %payload8 to i64
  %a_slot_addr = add i64 %a_slot_base, 0
  %a_slot = inttoptr i64 %a_slot_addr to ptr
  %a = load ptr, ptr %a_slot, align 8
  call void @forge_rc_retain(ptr %a)
  store ptr %a, ptr %a9, align 8
  %pay_slot10 = getelementptr inbounds nuw %Expr, ptr %e1, i32 0, i32 1
  %payload11 = load ptr, ptr %pay_slot10, align 8
  %b_slot_base = ptrtoint ptr %payload11 to i64
  %b_slot_addr = add i64 %b_slot_base, 8
  %b_slot = inttoptr i64 %b_slot_addr to ptr
  %b = load ptr, ptr %b_slot, align 8
  call void @forge_rc_retain(ptr %b)
  store ptr %b, ptr %b12, align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_eval, i32 0, i32 5), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([11 x i64], ptr @__profc_eval, i32 0, i32 5), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_eval, i32 0, i32 6), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([11 x i64], ptr @__profc_eval, i32 0, i32 6), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_eval, i32 0, i32 7), align 8
  %8 = add i64 %pgocount7, 1
  store i64 %8, ptr getelementptr inbounds ([11 x i64], ptr @__profc_eval, i32 0, i32 7), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_eval, i32 0, i32 8), align 8
  %9 = add i64 %pgocount8, 1
  store i64 %9, ptr getelementptr inbounds ([11 x i64], ptr @__profc_eval, i32 0, i32 8), align 8
  %a13 = load ptr, ptr %a9, align 8
  %10 = call i64 @eval(ptr %a13)
  %pgocount9 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_eval, i32 0, i32 9), align 8
  %11 = add i64 %pgocount9, 1
  store i64 %11, ptr getelementptr inbounds ([11 x i64], ptr @__profc_eval, i32 0, i32 9), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_eval, i32 0, i32 10), align 8
  %12 = add i64 %pgocount10, 1
  store i64 %12, ptr getelementptr inbounds ([11 x i64], ptr @__profc_eval, i32 0, i32 10), align 8
  %b14 = load ptr, ptr %b12, align 8
  %13 = call i64 @eval(ptr %b14)
  %add = add i64 %10, %13
  store i64 %add, ptr %match_result, align 8
  br label %match_end

march_next5:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 8)
  unreachable
}

define ptr @classify_expr(ptr %0) {
entry:
  %b42 = alloca ptr, align 8
  %a39 = alloca ptr, align 8
  %n27 = alloca i64, align 8
  %n13 = alloca i64, align 8
  %n2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %e = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_classify_expr, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_classify_expr, align 8
  store ptr %0, ptr %e, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 2), align 8
  %e1 = load ptr, ptr %e, align 8
  %tag_ptr = getelementptr inbounds nuw %Expr, ptr %e1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193465909
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm49, %guard_pass48, %march_arm31, %guard_pass30, %guard_pass17, %guard_pass
  %match_val = load i64, ptr %match_result, align 8
  %cast = inttoptr i64 %match_val to ptr
  ret ptr %cast

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Expr, ptr %e1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %n_slot_base = ptrtoint ptr %payload to i64
  %n_slot_addr = add i64 %n_slot_base, 0
  %n_slot = inttoptr i64 %n_slot_addr to ptr
  %n = load i64, ptr %n_slot, align 8
  store i64 %n, ptr %n2, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 4), align 8
  %n3 = load i64, ptr %n2, align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 5), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 5), align 8
  %eq = icmp eq i64 %n3, 0
  %eq_ext = zext i1 %eq to i64
  %guard = icmp ne i64 %eq_ext, 0
  br i1 %guard, label %guard_pass, label %march_next

march_next:                                       ; preds = %march_arm, %entry
  %tag_eq6 = icmp eq i64 %tag, 193465909
  br i1 %tag_eq6, label %march_arm4, label %march_next5

guard_pass:                                       ; preds = %march_arm
  %pgocount6 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 6), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 6), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 7), align 8
  %8 = add i64 %pgocount7, 1
  store i64 %8, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 7), align 8
  store i64 ptrtoint (ptr @.str to i64), ptr %match_result, align 8
  br label %match_end

march_arm4:                                       ; preds = %march_next
  %pay_slot7 = getelementptr inbounds nuw %Expr, ptr %e1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %n_slot_base9 = ptrtoint ptr %payload8 to i64
  %n_slot_addr10 = add i64 %n_slot_base9, 0
  %n_slot11 = inttoptr i64 %n_slot_addr10 to ptr
  %n12 = load i64, ptr %n_slot11, align 8
  store i64 %n12, ptr %n13, align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 8), align 8
  %9 = add i64 %pgocount8, 1
  store i64 %9, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 8), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 9), align 8
  %10 = add i64 %pgocount9, 1
  store i64 %10, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 9), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 10), align 8
  %11 = add i64 %pgocount10, 1
  store i64 %11, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 10), align 8
  %n14 = load i64, ptr %n13, align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 11), align 8
  %12 = add i64 %pgocount11, 1
  store i64 %12, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 11), align 8
  %sgt = icmp sgt i64 %n14, 0
  %sgt_ext = zext i1 %sgt to i64
  %l_bool = icmp ne i64 %sgt_ext, 0
  br i1 %l_bool, label %sc_rhs, label %sc_short

march_next5:                                      ; preds = %sc_merge, %march_next
  %tag_eq20 = icmp eq i64 %tag, 193465909
  br i1 %tag_eq20, label %march_arm18, label %march_next19

sc_rhs:                                           ; preds = %march_arm4
  %pgocount12 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 13), align 8
  %13 = add i64 %pgocount12, 1
  store i64 %13, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 13), align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 14), align 8
  %14 = add i64 %pgocount13, 1
  store i64 %14, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 14), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 15), align 8
  %15 = add i64 %pgocount14, 1
  store i64 %15, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 15), align 8
  %n15 = load i64, ptr %n13, align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 16), align 8
  %16 = add i64 %pgocount15, 1
  store i64 %16, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 16), align 8
  %slt = icmp slt i64 %n15, 10
  %slt_ext = zext i1 %slt to i64
  %r_bool = icmp ne i64 %slt_ext, 0
  br i1 %r_bool, label %sc_r_true, label %sc_r_false

sc_short:                                         ; preds = %march_arm4
  %pgocount16 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 12), align 8
  %17 = add i64 %pgocount16, 1
  store i64 %17, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 12), align 8
  br label %sc_merge

sc_merge:                                         ; preds = %sc_r_merge, %sc_short
  %sc_phi = phi i1 [ false, %sc_short ], [ %r_bool, %sc_r_merge ]
  %sc_ext = zext i1 %sc_phi to i64
  %guard16 = icmp ne i64 %sc_ext, 0
  br i1 %guard16, label %guard_pass17, label %march_next5

sc_r_true:                                        ; preds = %sc_rhs
  %pgocount17 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 17), align 8
  %18 = add i64 %pgocount17, 1
  store i64 %18, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 17), align 8
  br label %sc_r_merge

sc_r_false:                                       ; preds = %sc_rhs
  %pgocount18 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 18), align 8
  %19 = add i64 %pgocount18, 1
  store i64 %19, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 18), align 8
  br label %sc_r_merge

sc_r_merge:                                       ; preds = %sc_r_false, %sc_r_true
  br label %sc_merge

guard_pass17:                                     ; preds = %sc_merge
  %pgocount19 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 19), align 8
  %20 = add i64 %pgocount19, 1
  store i64 %20, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 19), align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 20), align 8
  %21 = add i64 %pgocount20, 1
  store i64 %21, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 20), align 8
  store i64 ptrtoint (ptr @.str.1 to i64), ptr %match_result, align 8
  br label %match_end

march_arm18:                                      ; preds = %march_next5
  %pay_slot21 = getelementptr inbounds nuw %Expr, ptr %e1, i32 0, i32 1
  %payload22 = load ptr, ptr %pay_slot21, align 8
  %n_slot_base23 = ptrtoint ptr %payload22 to i64
  %n_slot_addr24 = add i64 %n_slot_base23, 0
  %n_slot25 = inttoptr i64 %n_slot_addr24 to ptr
  %n26 = load i64, ptr %n_slot25, align 8
  store i64 %n26, ptr %n27, align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 21), align 8
  %22 = add i64 %pgocount21, 1
  store i64 %22, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 21), align 8
  %pgocount22 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 22), align 8
  %23 = add i64 %pgocount22, 1
  store i64 %23, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 22), align 8
  %n28 = load i64, ptr %n27, align 8
  %pgocount23 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 23), align 8
  %24 = add i64 %pgocount23, 1
  store i64 %24, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 23), align 8
  %sge = icmp sge i64 %n28, 10
  %sge_ext = zext i1 %sge to i64
  %guard29 = icmp ne i64 %sge_ext, 0
  br i1 %guard29, label %guard_pass30, label %march_next19

march_next19:                                     ; preds = %march_arm18, %march_next5
  %tag_eq33 = icmp eq i64 %tag, 193465909
  br i1 %tag_eq33, label %march_arm31, label %march_next32

guard_pass30:                                     ; preds = %march_arm18
  %pgocount24 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 24), align 8
  %25 = add i64 %pgocount24, 1
  store i64 %25, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 24), align 8
  %pgocount25 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 25), align 8
  %26 = add i64 %pgocount25, 1
  store i64 %26, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 25), align 8
  store i64 ptrtoint (ptr @.str.2 to i64), ptr %match_result, align 8
  br label %match_end

march_arm31:                                      ; preds = %march_next19
  %pgocount26 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 26), align 8
  %27 = add i64 %pgocount26, 1
  store i64 %27, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 26), align 8
  %pgocount27 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 27), align 8
  %28 = add i64 %pgocount27, 1
  store i64 %28, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 27), align 8
  store i64 ptrtoint (ptr @.str.3 to i64), ptr %match_result, align 8
  br label %match_end

march_next32:                                     ; preds = %march_next19
  %tag_eq36 = icmp eq i64 %tag, 193451182
  br i1 %tag_eq36, label %march_arm34, label %march_next35

march_arm34:                                      ; preds = %march_next32
  %pay_slot37 = getelementptr inbounds nuw %Expr, ptr %e1, i32 0, i32 1
  %payload38 = load ptr, ptr %pay_slot37, align 8
  %a_slot_base = ptrtoint ptr %payload38 to i64
  %a_slot_addr = add i64 %a_slot_base, 0
  %a_slot = inttoptr i64 %a_slot_addr to ptr
  %a = load ptr, ptr %a_slot, align 8
  call void @forge_rc_retain(ptr %a)
  store ptr %a, ptr %a39, align 8
  %pay_slot40 = getelementptr inbounds nuw %Expr, ptr %e1, i32 0, i32 1
  %payload41 = load ptr, ptr %pay_slot40, align 8
  %b_slot_base = ptrtoint ptr %payload41 to i64
  %b_slot_addr = add i64 %b_slot_base, 8
  %b_slot = inttoptr i64 %b_slot_addr to ptr
  %b = load ptr, ptr %b_slot, align 8
  call void @forge_rc_retain(ptr %b)
  store ptr %b, ptr %b42, align 8
  %pgocount28 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 28), align 8
  %29 = add i64 %pgocount28, 1
  store i64 %29, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 28), align 8
  %pgocount29 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 29), align 8
  %30 = add i64 %pgocount29, 1
  store i64 %30, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 29), align 8
  %pgocount30 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 30), align 8
  %31 = add i64 %pgocount30, 1
  store i64 %31, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 30), align 8
  %pgocount31 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 31), align 8
  %32 = add i64 %pgocount31, 1
  store i64 %32, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 31), align 8
  %a43 = load ptr, ptr %a39, align 8
  %33 = call i64 @eval(ptr %a43)
  %pgocount32 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 32), align 8
  %34 = add i64 %pgocount32, 1
  store i64 %34, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 32), align 8
  %pgocount33 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 33), align 8
  %35 = add i64 %pgocount33, 1
  store i64 %35, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 33), align 8
  %b44 = load ptr, ptr %b42, align 8
  %36 = call i64 @eval(ptr %b44)
  %add = add i64 %33, %36
  %pgocount34 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 34), align 8
  %37 = add i64 %pgocount34, 1
  store i64 %37, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 34), align 8
  %sgt45 = icmp sgt i64 %add, 100
  %sgt_ext46 = zext i1 %sgt45 to i64
  %guard47 = icmp ne i64 %sgt_ext46, 0
  br i1 %guard47, label %guard_pass48, label %march_next35

march_next35:                                     ; preds = %march_arm34, %march_next32
  %tag_eq51 = icmp eq i64 %tag, 193451182
  br i1 %tag_eq51, label %march_arm49, label %march_next50

guard_pass48:                                     ; preds = %march_arm34
  %pgocount35 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 35), align 8
  %38 = add i64 %pgocount35, 1
  store i64 %38, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 35), align 8
  %pgocount36 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 36), align 8
  %39 = add i64 %pgocount36, 1
  store i64 %39, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 36), align 8
  store i64 ptrtoint (ptr @.str.4 to i64), ptr %match_result, align 8
  br label %match_end

march_arm49:                                      ; preds = %march_next35
  %pgocount37 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 37), align 8
  %40 = add i64 %pgocount37, 1
  store i64 %40, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 37), align 8
  %pgocount38 = load i64, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 38), align 8
  %41 = add i64 %pgocount38, 1
  store i64 %41, ptr getelementptr inbounds ([39 x i64], ptr @__profc_classify_expr, i32 0, i32 38), align 8
  store i64 ptrtoint (ptr @.str.5 to i64), ptr %match_result, align 8
  br label %match_end

march_next50:                                     ; preds = %march_next35
  call void @forge_match_unreachable(ptr @.match_fn.6, i64 %tag, ptr @mu_file.7, i64 15)
  unreachable
}

define i64 @abs(i64 %0) {
entry:
  %pmatch_result = alloca i64, align 8
  %x = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_abs, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_abs, align 8
  store i64 %0, ptr %x, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc_abs, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([9 x i64], ptr @__profc_abs, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc_abs, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([9 x i64], ptr @__profc_abs, i32 0, i32 2), align 8
  %x1 = load i64, ptr %x, align 8
  store i64 0, ptr %pmatch_result, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc_abs, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([9 x i64], ptr @__profc_abs, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc_abs, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([9 x i64], ptr @__profc_abs, i32 0, i32 4), align 8
  %x2 = load i64, ptr %x, align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc_abs, i32 0, i32 5), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([9 x i64], ptr @__profc_abs, i32 0, i32 5), align 8
  %sge = icmp sge i64 %x2, 0
  %sge_ext = zext i1 %sge to i64
  %pguard = icmp ne i64 %sge_ext, 0
  br i1 %pguard, label %parm_body, label %parm_next

pmatch_end:                                       ; preds = %parm_body4, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  ret i64 %pmatch_val

parm_body:                                        ; preds = %entry
  %pgocount6 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc_abs, i32 0, i32 6), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([9 x i64], ptr @__profc_abs, i32 0, i32 6), align 8
  %x3 = load i64, ptr %x, align 8
  store i64 %x3, ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %entry
  br label %parm_body4

parm_body4:                                       ; preds = %parm_next
  %pgocount7 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc_abs, i32 0, i32 7), align 8
  %8 = add i64 %pgocount7, 1
  store i64 %8, ptr getelementptr inbounds ([9 x i64], ptr @__profc_abs, i32 0, i32 7), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc_abs, i32 0, i32 8), align 8
  %9 = add i64 %pgocount8, 1
  store i64 %9, ptr getelementptr inbounds ([9 x i64], ptr @__profc_abs, i32 0, i32 8), align 8
  %x6 = load i64, ptr %x, align 8
  %neg = sub i64 0, %x6
  store i64 %neg, ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next5:                                       ; No predecessors!
  call void @forge_match_unreachable(ptr @.match_fn.8, i64 -1, ptr @mu_file.9, i64 34)
  unreachable
}

define ptr @categorize(ptr %0) {
entry:
  %pmatch_result = alloca i64, align 8
  %s = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_categorize, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_categorize, align 8
  store ptr %0, ptr %s, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 2), align 8
  %s1 = load ptr, ptr %s, align 8
  store i64 0, ptr %pmatch_result, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 4), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 5), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 5), align 8
  %s2 = load ptr, ptr %s, align 8
  %7 = call i64 @strlen(ptr %s2)
  %pgocount6 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 6), align 8
  %8 = add i64 %pgocount6, 1
  store i64 %8, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 6), align 8
  %eq = icmp eq i64 %7, 0
  %eq_ext = zext i1 %eq to i64
  %pguard = icmp ne i64 %eq_ext, 0
  br i1 %pguard, label %parm_body, label %parm_next

pmatch_end:                                       ; preds = %parm_body11, %parm_body7, %parm_body3, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  %cast = inttoptr i64 %pmatch_val to ptr
  ret ptr %cast

parm_body:                                        ; preds = %entry
  %pgocount7 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 7), align 8
  %9 = add i64 %pgocount7, 1
  store i64 %9, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 7), align 8
  store i64 ptrtoint (ptr @.str.10 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %entry
  %pgocount8 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 8), align 8
  %10 = add i64 %pgocount8, 1
  store i64 %10, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 8), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 9), align 8
  %11 = add i64 %pgocount9, 1
  store i64 %11, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 9), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 10), align 8
  %12 = add i64 %pgocount10, 1
  store i64 %12, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 10), align 8
  %s5 = load ptr, ptr %s, align 8
  %13 = call i64 @strlen(ptr %s5)
  %pgocount11 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 11), align 8
  %14 = add i64 %pgocount11, 1
  store i64 %14, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 11), align 8
  %slt = icmp slt i64 %13, 5
  %slt_ext = zext i1 %slt to i64
  %pguard6 = icmp ne i64 %slt_ext, 0
  br i1 %pguard6, label %parm_body3, label %parm_next4

parm_body3:                                       ; preds = %parm_next
  %pgocount12 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 12), align 8
  %15 = add i64 %pgocount12, 1
  store i64 %15, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 12), align 8
  store i64 ptrtoint (ptr @.str.11 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next4:                                       ; preds = %parm_next
  %pgocount13 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 13), align 8
  %16 = add i64 %pgocount13, 1
  store i64 %16, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 13), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 14), align 8
  %17 = add i64 %pgocount14, 1
  store i64 %17, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 14), align 8
  %s9 = load ptr, ptr %s, align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 15), align 8
  %18 = add i64 %pgocount15, 1
  store i64 %18, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 15), align 8
  %19 = call i64 @forge_str_contains(ptr %s9, ptr @.str.12)
  %pguard10 = icmp ne i64 %19, 0
  br i1 %pguard10, label %parm_body7, label %parm_next8

parm_body7:                                       ; preds = %parm_next4
  %pgocount16 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 16), align 8
  %20 = add i64 %pgocount16, 1
  store i64 %20, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 16), align 8
  store i64 ptrtoint (ptr @.str.13 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next8:                                       ; preds = %parm_next4
  br label %parm_body11

parm_body11:                                      ; preds = %parm_next8
  %pgocount17 = load i64, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 17), align 8
  %21 = add i64 %pgocount17, 1
  store i64 %21, ptr getelementptr inbounds ([18 x i64], ptr @__profc_categorize, i32 0, i32 17), align 8
  store i64 ptrtoint (ptr @.str.14 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next12:                                      ; No predecessors!
  call void @forge_match_unreachable(ptr @.match_fn.15, i64 -1, ptr @mu_file.16, i64 44)
  unreachable
}

define ptr @describe_response(ptr %0) {
entry:
  %msg94 = alloca ptr, align 8
  %code87 = alloca i64, align 8
  %msg72 = alloca ptr, align 8
  %code65 = alloca i64, align 8
  %msg44 = alloca ptr, align 8
  %code41 = alloca i64, align 8
  %code28 = alloca i64, align 8
  %code13 = alloca i64, align 8
  %code2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %r = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_describe_response, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_describe_response, align 8
  store ptr %0, ptr %r, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 2), align 8
  %r1 = load ptr, ptr %r, align 8
  %tag_ptr = getelementptr inbounds nuw %Response, ptr %r1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 229441733419486
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm78, %guard_pass77, %guard_pass47, %march_arm19, %guard_pass18, %guard_pass
  %match_val = load i64, ptr %match_result, align 8
  %cast117 = inttoptr i64 %match_val to ptr
  ret ptr %cast117

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Response, ptr %r1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %code_slot_base = ptrtoint ptr %payload to i64
  %code_slot_addr = add i64 %code_slot_base, 0
  %code_slot = inttoptr i64 %code_slot_addr to ptr
  %code = load i64, ptr %code_slot, align 8
  store i64 %code, ptr %code2, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 4), align 8
  %code3 = load i64, ptr %code2, align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 5), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 5), align 8
  %eq = icmp eq i64 %code3, 200
  %eq_ext = zext i1 %eq to i64
  %guard = icmp ne i64 %eq_ext, 0
  br i1 %guard, label %guard_pass, label %march_next

march_next:                                       ; preds = %march_arm, %entry
  %tag_eq6 = icmp eq i64 %tag, 229441733419486
  br i1 %tag_eq6, label %march_arm4, label %march_next5

guard_pass:                                       ; preds = %march_arm
  %pgocount6 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 6), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 6), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 7), align 8
  %8 = add i64 %pgocount7, 1
  store i64 %8, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 7), align 8
  store i64 ptrtoint (ptr @.str.17 to i64), ptr %match_result, align 8
  br label %match_end

march_arm4:                                       ; preds = %march_next
  %pay_slot7 = getelementptr inbounds nuw %Response, ptr %r1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %code_slot_base9 = ptrtoint ptr %payload8 to i64
  %code_slot_addr10 = add i64 %code_slot_base9, 0
  %code_slot11 = inttoptr i64 %code_slot_addr10 to ptr
  %code12 = load i64, ptr %code_slot11, align 8
  store i64 %code12, ptr %code13, align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 8), align 8
  %9 = add i64 %pgocount8, 1
  store i64 %9, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 8), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 9), align 8
  %10 = add i64 %pgocount9, 1
  store i64 %10, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 9), align 8
  %code14 = load i64, ptr %code13, align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 10), align 8
  %11 = add i64 %pgocount10, 1
  store i64 %11, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 10), align 8
  %eq15 = icmp eq i64 %code14, 201
  %eq_ext16 = zext i1 %eq15 to i64
  %guard17 = icmp ne i64 %eq_ext16, 0
  br i1 %guard17, label %guard_pass18, label %march_next5

march_next5:                                      ; preds = %march_arm4, %march_next
  %tag_eq21 = icmp eq i64 %tag, 229441733419486
  br i1 %tag_eq21, label %march_arm19, label %march_next20

guard_pass18:                                     ; preds = %march_arm4
  %pgocount11 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 11), align 8
  %12 = add i64 %pgocount11, 1
  store i64 %12, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 11), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 12), align 8
  %13 = add i64 %pgocount12, 1
  store i64 %13, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 12), align 8
  store i64 ptrtoint (ptr @.str.18 to i64), ptr %match_result, align 8
  br label %match_end

march_arm19:                                      ; preds = %march_next5
  %pay_slot22 = getelementptr inbounds nuw %Response, ptr %r1, i32 0, i32 1
  %payload23 = load ptr, ptr %pay_slot22, align 8
  %code_slot_base24 = ptrtoint ptr %payload23 to i64
  %code_slot_addr25 = add i64 %code_slot_base24, 0
  %code_slot26 = inttoptr i64 %code_slot_addr25 to ptr
  %code27 = load i64, ptr %code_slot26, align 8
  store i64 %code27, ptr %code28, align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 13), align 8
  %14 = add i64 %pgocount13, 1
  store i64 %14, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 13), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 14), align 8
  %15 = add i64 %pgocount14, 1
  store i64 %15, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 14), align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 15), align 8
  %16 = add i64 %pgocount15, 1
  store i64 %16, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 15), align 8
  %pgocount16 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 16), align 8
  %17 = add i64 %pgocount16, 1
  store i64 %17, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 16), align 8
  %pgocount17 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 17), align 8
  %18 = add i64 %pgocount17, 1
  store i64 %18, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 17), align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 18), align 8
  %19 = add i64 %pgocount18, 1
  store i64 %19, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 18), align 8
  %code29 = load i64, ptr %code28, align 8
  %20 = call ptr @forge_rc_alloc(i64 32)
  %21 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %20, i64 32, ptr @.i2s_fmt, i64 %code29)
  %widen = sext i32 %21 to i64
  %22 = call i64 @strlen(ptr @.str.19)
  %23 = call i64 @strlen(ptr %20)
  %concat_total = add i64 %22, %23
  %concat_size = add i64 %concat_total, 1
  %24 = call ptr @forge_rc_alloc(i64 %concat_size)
  %25 = call ptr @memcpy(ptr %24, ptr @.str.19, i64 %22)
  %cast = ptrtoint ptr %24 to i64
  %dst2_int = add i64 %cast, %22
  %cast30 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %23, 1
  %26 = call ptr @memcpy(ptr %cast30, ptr %20, i64 %rhs_len_p1)
  %cast31 = ptrtoint ptr %24 to i64
  store i64 %cast31, ptr %match_result, align 8
  br label %match_end

march_next20:                                     ; preds = %march_next5
  %tag_eq34 = icmp eq i64 %tag, 210673603023
  br i1 %tag_eq34, label %march_arm32, label %march_next33

march_arm32:                                      ; preds = %march_next20
  %pay_slot35 = getelementptr inbounds nuw %Response, ptr %r1, i32 0, i32 1
  %payload36 = load ptr, ptr %pay_slot35, align 8
  %code_slot_base37 = ptrtoint ptr %payload36 to i64
  %code_slot_addr38 = add i64 %code_slot_base37, 0
  %code_slot39 = inttoptr i64 %code_slot_addr38 to ptr
  %code40 = load i64, ptr %code_slot39, align 8
  store i64 %code40, ptr %code41, align 8
  %pay_slot42 = getelementptr inbounds nuw %Response, ptr %r1, i32 0, i32 1
  %payload43 = load ptr, ptr %pay_slot42, align 8
  %msg_slot_base = ptrtoint ptr %payload43 to i64
  %msg_slot_addr = add i64 %msg_slot_base, 8
  %msg_slot = inttoptr i64 %msg_slot_addr to ptr
  %msg = load ptr, ptr %msg_slot, align 8
  call void @forge_rc_retain(ptr %msg)
  store ptr %msg, ptr %msg44, align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 19), align 8
  %27 = add i64 %pgocount19, 1
  store i64 %27, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 19), align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 20), align 8
  %28 = add i64 %pgocount20, 1
  store i64 %28, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 20), align 8
  %code45 = load i64, ptr %code41, align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 21), align 8
  %29 = add i64 %pgocount21, 1
  store i64 %29, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 21), align 8
  %sge = icmp sge i64 %code45, 500
  %sge_ext = zext i1 %sge to i64
  %guard46 = icmp ne i64 %sge_ext, 0
  br i1 %guard46, label %guard_pass47, label %march_next33

march_next33:                                     ; preds = %march_arm32, %march_next20
  %tag_eq58 = icmp eq i64 %tag, 210673603023
  br i1 %tag_eq58, label %march_arm56, label %march_next57

guard_pass47:                                     ; preds = %march_arm32
  %pgocount22 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 22), align 8
  %30 = add i64 %pgocount22, 1
  store i64 %30, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 22), align 8
  %pgocount23 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 23), align 8
  %31 = add i64 %pgocount23, 1
  store i64 %31, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 23), align 8
  %pgocount24 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 24), align 8
  %32 = add i64 %pgocount24, 1
  store i64 %32, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 24), align 8
  %pgocount25 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 25), align 8
  %33 = add i64 %pgocount25, 1
  store i64 %33, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 25), align 8
  %pgocount26 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 26), align 8
  %34 = add i64 %pgocount26, 1
  store i64 %34, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 26), align 8
  %msg48 = load ptr, ptr %msg44, align 8
  %35 = call i64 @strlen(ptr @.str.20)
  %36 = call i64 @strlen(ptr %msg48)
  %concat_total49 = add i64 %35, %36
  %concat_size50 = add i64 %concat_total49, 1
  %37 = call ptr @forge_rc_alloc(i64 %concat_size50)
  %38 = call ptr @memcpy(ptr %37, ptr @.str.20, i64 %35)
  %cast51 = ptrtoint ptr %37 to i64
  %dst2_int52 = add i64 %cast51, %35
  %cast53 = inttoptr i64 %dst2_int52 to ptr
  %rhs_len_p154 = add i64 %36, 1
  %39 = call ptr @memcpy(ptr %cast53, ptr %msg48, i64 %rhs_len_p154)
  %cast55 = ptrtoint ptr %37 to i64
  store i64 %cast55, ptr %match_result, align 8
  br label %match_end

march_arm56:                                      ; preds = %march_next33
  %pay_slot59 = getelementptr inbounds nuw %Response, ptr %r1, i32 0, i32 1
  %payload60 = load ptr, ptr %pay_slot59, align 8
  %code_slot_base61 = ptrtoint ptr %payload60 to i64
  %code_slot_addr62 = add i64 %code_slot_base61, 0
  %code_slot63 = inttoptr i64 %code_slot_addr62 to ptr
  %code64 = load i64, ptr %code_slot63, align 8
  store i64 %code64, ptr %code65, align 8
  %pay_slot66 = getelementptr inbounds nuw %Response, ptr %r1, i32 0, i32 1
  %payload67 = load ptr, ptr %pay_slot66, align 8
  %msg_slot_base68 = ptrtoint ptr %payload67 to i64
  %msg_slot_addr69 = add i64 %msg_slot_base68, 8
  %msg_slot70 = inttoptr i64 %msg_slot_addr69 to ptr
  %msg71 = load ptr, ptr %msg_slot70, align 8
  call void @forge_rc_retain(ptr %msg71)
  store ptr %msg71, ptr %msg72, align 8
  %pgocount27 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 27), align 8
  %40 = add i64 %pgocount27, 1
  store i64 %40, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 27), align 8
  %pgocount28 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 28), align 8
  %41 = add i64 %pgocount28, 1
  store i64 %41, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 28), align 8
  %code73 = load i64, ptr %code65, align 8
  %pgocount29 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 29), align 8
  %42 = add i64 %pgocount29, 1
  store i64 %42, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 29), align 8
  %eq74 = icmp eq i64 %code73, 404
  %eq_ext75 = zext i1 %eq74 to i64
  %guard76 = icmp ne i64 %eq_ext75, 0
  br i1 %guard76, label %guard_pass77, label %march_next57

march_next57:                                     ; preds = %march_arm56, %march_next33
  %tag_eq80 = icmp eq i64 %tag, 210673603023
  br i1 %tag_eq80, label %march_arm78, label %march_next79

guard_pass77:                                     ; preds = %march_arm56
  %pgocount30 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 30), align 8
  %43 = add i64 %pgocount30, 1
  store i64 %43, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 30), align 8
  %pgocount31 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 31), align 8
  %44 = add i64 %pgocount31, 1
  store i64 %44, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 31), align 8
  store i64 ptrtoint (ptr @.str.21 to i64), ptr %match_result, align 8
  br label %match_end

march_arm78:                                      ; preds = %march_next57
  %pay_slot81 = getelementptr inbounds nuw %Response, ptr %r1, i32 0, i32 1
  %payload82 = load ptr, ptr %pay_slot81, align 8
  %code_slot_base83 = ptrtoint ptr %payload82 to i64
  %code_slot_addr84 = add i64 %code_slot_base83, 0
  %code_slot85 = inttoptr i64 %code_slot_addr84 to ptr
  %code86 = load i64, ptr %code_slot85, align 8
  store i64 %code86, ptr %code87, align 8
  %pay_slot88 = getelementptr inbounds nuw %Response, ptr %r1, i32 0, i32 1
  %payload89 = load ptr, ptr %pay_slot88, align 8
  %msg_slot_base90 = ptrtoint ptr %payload89 to i64
  %msg_slot_addr91 = add i64 %msg_slot_base90, 8
  %msg_slot92 = inttoptr i64 %msg_slot_addr91 to ptr
  %msg93 = load ptr, ptr %msg_slot92, align 8
  call void @forge_rc_retain(ptr %msg93)
  store ptr %msg93, ptr %msg94, align 8
  %pgocount32 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 32), align 8
  %45 = add i64 %pgocount32, 1
  store i64 %45, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 32), align 8
  %pgocount33 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 33), align 8
  %46 = add i64 %pgocount33, 1
  store i64 %46, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 33), align 8
  %pgocount34 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 34), align 8
  %47 = add i64 %pgocount34, 1
  store i64 %47, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 34), align 8
  %pgocount35 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 35), align 8
  %48 = add i64 %pgocount35, 1
  store i64 %48, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 35), align 8
  %pgocount36 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 36), align 8
  %49 = add i64 %pgocount36, 1
  store i64 %49, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 36), align 8
  %pgocount37 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 37), align 8
  %50 = add i64 %pgocount37, 1
  store i64 %50, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 37), align 8
  %pgocount38 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 38), align 8
  %51 = add i64 %pgocount38, 1
  store i64 %51, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 38), align 8
  %pgocount39 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 39), align 8
  %52 = add i64 %pgocount39, 1
  store i64 %52, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 39), align 8
  %code95 = load i64, ptr %code87, align 8
  %53 = call ptr @forge_rc_alloc(i64 32)
  %54 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %53, i64 32, ptr @.i2s_fmt.23, i64 %code95)
  %widen96 = sext i32 %54 to i64
  %55 = call i64 @strlen(ptr @.str.22)
  %56 = call i64 @strlen(ptr %53)
  %concat_total97 = add i64 %55, %56
  %concat_size98 = add i64 %concat_total97, 1
  %57 = call ptr @forge_rc_alloc(i64 %concat_size98)
  %58 = call ptr @memcpy(ptr %57, ptr @.str.22, i64 %55)
  %cast99 = ptrtoint ptr %57 to i64
  %dst2_int100 = add i64 %cast99, %55
  %cast101 = inttoptr i64 %dst2_int100 to ptr
  %rhs_len_p1102 = add i64 %56, 1
  %59 = call ptr @memcpy(ptr %cast101, ptr %53, i64 %rhs_len_p1102)
  %pgocount40 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 40), align 8
  %60 = add i64 %pgocount40, 1
  store i64 %60, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 40), align 8
  %61 = call i64 @strlen(ptr %57)
  %62 = call i64 @strlen(ptr @.str.24)
  %concat_total103 = add i64 %61, %62
  %concat_size104 = add i64 %concat_total103, 1
  %63 = call ptr @forge_rc_alloc(i64 %concat_size104)
  %64 = call ptr @memcpy(ptr %63, ptr %57, i64 %61)
  %cast105 = ptrtoint ptr %63 to i64
  %dst2_int106 = add i64 %cast105, %61
  %cast107 = inttoptr i64 %dst2_int106 to ptr
  %rhs_len_p1108 = add i64 %62, 1
  %65 = call ptr @memcpy(ptr %cast107, ptr @.str.24, i64 %rhs_len_p1108)
  %pgocount41 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 41), align 8
  %66 = add i64 %pgocount41, 1
  store i64 %66, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 41), align 8
  %pgocount42 = load i64, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 42), align 8
  %67 = add i64 %pgocount42, 1
  store i64 %67, ptr getelementptr inbounds ([43 x i64], ptr @__profc_describe_response, i32 0, i32 42), align 8
  %msg109 = load ptr, ptr %msg94, align 8
  %68 = call i64 @strlen(ptr %63)
  %69 = call i64 @strlen(ptr %msg109)
  %concat_total110 = add i64 %68, %69
  %concat_size111 = add i64 %concat_total110, 1
  %70 = call ptr @forge_rc_alloc(i64 %concat_size111)
  %71 = call ptr @memcpy(ptr %70, ptr %63, i64 %68)
  %cast112 = ptrtoint ptr %70 to i64
  %dst2_int113 = add i64 %cast112, %68
  %cast114 = inttoptr i64 %dst2_int113 to ptr
  %rhs_len_p1115 = add i64 %69, 1
  %72 = call ptr @memcpy(ptr %cast114, ptr %msg109, i64 %rhs_len_p1115)
  %cast116 = ptrtoint ptr %70 to i64
  store i64 %cast116, ptr %match_result, align 8
  br label %match_end

march_next79:                                     ; preds = %march_next57
  call void @forge_match_unreachable(ptr @.match_fn.25, i64 %tag, ptr @mu_file.26, i64 80)
  unreachable
}

define i64 @main() {
entry:
  %g = alloca i64, align 8
  %forin_i111 = alloca i64, align 8
  %forin_len110 = alloca i64, align 8
  %grade = alloca ptr, align 8
  %pmatch_result = alloca i64, align 8
  %s = alloca i64, align 8
  %forin_i = alloca i64, align 8
  %forin_len = alloca i64, align 8
  %pgocount = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %3 = add i64 %pgocount3, 1
  store i64 %3, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %4 = add i64 %pgocount4, 1
  store i64 %4, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %5 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Expr, ptr %5, i32 0, i32 0
  store i64 193465909, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Expr, ptr %5, i32 0, i32 1
  %6 = call ptr @forge_rc_alloc(i64 8)
  store ptr %6, ptr %pay_ptr, align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %7 = add i64 %pgocount5, 1
  store i64 %7, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %slot_base = ptrtoint ptr %6 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 0, ptr %slot, align 8
  %cast = ptrtoint ptr %5 to i64
  %cast1 = inttoptr i64 %cast to ptr
  %8 = call ptr @classify_expr(ptr %cast1)
  %9 = call i32 @puts(ptr %8)
  %widen = sext i32 %9 to i64
  %pgocount6 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %10 = add i64 %pgocount6, 1
  store i64 %10, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %11 = add i64 %pgocount7, 1
  store i64 %11, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %12 = add i64 %pgocount8, 1
  store i64 %12, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 52), align 8
  %13 = add i64 %pgocount9, 1
  store i64 %13, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 52), align 8
  %14 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr2 = getelementptr inbounds nuw %Expr, ptr %14, i32 0, i32 0
  store i64 193465909, ptr %tag_ptr2, align 8
  %pay_ptr3 = getelementptr inbounds nuw %Expr, ptr %14, i32 0, i32 1
  %15 = call ptr @forge_rc_alloc(i64 8)
  store ptr %15, ptr %pay_ptr3, align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 53), align 8
  %16 = add i64 %pgocount10, 1
  store i64 %16, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 53), align 8
  %slot_base4 = ptrtoint ptr %15 to i64
  %slot_addr5 = add i64 %slot_base4, 0
  %slot6 = inttoptr i64 %slot_addr5 to ptr
  store i64 5, ptr %slot6, align 8
  %cast7 = ptrtoint ptr %14 to i64
  %cast8 = inttoptr i64 %cast7 to ptr
  %17 = call ptr @classify_expr(ptr %cast8)
  %18 = call i32 @puts(ptr %17)
  %widen9 = sext i32 %18 to i64
  %pgocount11 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 54), align 8
  %19 = add i64 %pgocount11, 1
  store i64 %19, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 54), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 55), align 8
  %20 = add i64 %pgocount12, 1
  store i64 %20, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 55), align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 56), align 8
  %21 = add i64 %pgocount13, 1
  store i64 %21, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 56), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 57), align 8
  %22 = add i64 %pgocount14, 1
  store i64 %22, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 57), align 8
  %23 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr10 = getelementptr inbounds nuw %Expr, ptr %23, i32 0, i32 0
  store i64 193465909, ptr %tag_ptr10, align 8
  %pay_ptr11 = getelementptr inbounds nuw %Expr, ptr %23, i32 0, i32 1
  %24 = call ptr @forge_rc_alloc(i64 8)
  store ptr %24, ptr %pay_ptr11, align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 58), align 8
  %25 = add i64 %pgocount15, 1
  store i64 %25, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 58), align 8
  %slot_base12 = ptrtoint ptr %24 to i64
  %slot_addr13 = add i64 %slot_base12, 0
  %slot14 = inttoptr i64 %slot_addr13 to ptr
  store i64 42, ptr %slot14, align 8
  %cast15 = ptrtoint ptr %23 to i64
  %cast16 = inttoptr i64 %cast15 to ptr
  %26 = call ptr @classify_expr(ptr %cast16)
  %27 = call i32 @puts(ptr %26)
  %widen17 = sext i32 %27 to i64
  %pgocount16 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 59), align 8
  %28 = add i64 %pgocount16, 1
  store i64 %28, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 59), align 8
  %pgocount17 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 60), align 8
  %29 = add i64 %pgocount17, 1
  store i64 %29, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 60), align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 61), align 8
  %30 = add i64 %pgocount18, 1
  store i64 %30, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 61), align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 62), align 8
  %31 = add i64 %pgocount19, 1
  store i64 %31, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 62), align 8
  %32 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr18 = getelementptr inbounds nuw %Expr, ptr %32, i32 0, i32 0
  store i64 193465909, ptr %tag_ptr18, align 8
  %pay_ptr19 = getelementptr inbounds nuw %Expr, ptr %32, i32 0, i32 1
  %33 = call ptr @forge_rc_alloc(i64 8)
  store ptr %33, ptr %pay_ptr19, align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 63), align 8
  %34 = add i64 %pgocount20, 1
  store i64 %34, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 63), align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 64), align 8
  %35 = add i64 %pgocount21, 1
  store i64 %35, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 64), align 8
  %slot_base20 = ptrtoint ptr %33 to i64
  %slot_addr21 = add i64 %slot_base20, 0
  %slot22 = inttoptr i64 %slot_addr21 to ptr
  store i64 -3, ptr %slot22, align 8
  %cast23 = ptrtoint ptr %32 to i64
  %cast24 = inttoptr i64 %cast23 to ptr
  %36 = call ptr @classify_expr(ptr %cast24)
  %37 = call i32 @puts(ptr %36)
  %widen25 = sext i32 %37 to i64
  %pgocount22 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 65), align 8
  %38 = add i64 %pgocount22, 1
  store i64 %38, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 65), align 8
  %pgocount23 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 66), align 8
  %39 = add i64 %pgocount23, 1
  store i64 %39, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 66), align 8
  %pgocount24 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 67), align 8
  %40 = add i64 %pgocount24, 1
  store i64 %40, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 67), align 8
  %pgocount25 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 68), align 8
  %41 = add i64 %pgocount25, 1
  store i64 %41, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 68), align 8
  %42 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr26 = getelementptr inbounds nuw %Expr, ptr %42, i32 0, i32 0
  store i64 193451182, ptr %tag_ptr26, align 8
  %pay_ptr27 = getelementptr inbounds nuw %Expr, ptr %42, i32 0, i32 1
  %43 = call ptr @forge_rc_alloc(i64 16)
  store ptr %43, ptr %pay_ptr27, align 8
  %pgocount26 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 69), align 8
  %44 = add i64 %pgocount26, 1
  store i64 %44, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 69), align 8
  %45 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr28 = getelementptr inbounds nuw %Expr, ptr %45, i32 0, i32 0
  store i64 193465909, ptr %tag_ptr28, align 8
  %pay_ptr29 = getelementptr inbounds nuw %Expr, ptr %45, i32 0, i32 1
  %46 = call ptr @forge_rc_alloc(i64 8)
  store ptr %46, ptr %pay_ptr29, align 8
  %pgocount27 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 70), align 8
  %47 = add i64 %pgocount27, 1
  store i64 %47, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 70), align 8
  %slot_base30 = ptrtoint ptr %46 to i64
  %slot_addr31 = add i64 %slot_base30, 0
  %slot32 = inttoptr i64 %slot_addr31 to ptr
  store i64 50, ptr %slot32, align 8
  %cast33 = ptrtoint ptr %45 to i64
  %slot_base34 = ptrtoint ptr %43 to i64
  %slot_addr35 = add i64 %slot_base34, 0
  %slot36 = inttoptr i64 %slot_addr35 to ptr
  %cast37 = inttoptr i64 %cast33 to ptr
  store ptr %cast37, ptr %slot36, align 8
  %pgocount28 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 71), align 8
  %48 = add i64 %pgocount28, 1
  store i64 %48, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 71), align 8
  %49 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr38 = getelementptr inbounds nuw %Expr, ptr %49, i32 0, i32 0
  store i64 193465909, ptr %tag_ptr38, align 8
  %pay_ptr39 = getelementptr inbounds nuw %Expr, ptr %49, i32 0, i32 1
  %50 = call ptr @forge_rc_alloc(i64 8)
  store ptr %50, ptr %pay_ptr39, align 8
  %pgocount29 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 72), align 8
  %51 = add i64 %pgocount29, 1
  store i64 %51, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 72), align 8
  %slot_base40 = ptrtoint ptr %50 to i64
  %slot_addr41 = add i64 %slot_base40, 0
  %slot42 = inttoptr i64 %slot_addr41 to ptr
  store i64 60, ptr %slot42, align 8
  %cast43 = ptrtoint ptr %49 to i64
  %slot_base44 = ptrtoint ptr %43 to i64
  %slot_addr45 = add i64 %slot_base44, 8
  %slot46 = inttoptr i64 %slot_addr45 to ptr
  %cast47 = inttoptr i64 %cast43 to ptr
  store ptr %cast47, ptr %slot46, align 8
  %cast48 = ptrtoint ptr %42 to i64
  %cast49 = inttoptr i64 %cast48 to ptr
  %52 = call ptr @classify_expr(ptr %cast49)
  %53 = call i32 @puts(ptr %52)
  %widen50 = sext i32 %53 to i64
  %pgocount30 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 73), align 8
  %54 = add i64 %pgocount30, 1
  store i64 %54, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 73), align 8
  %pgocount31 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 74), align 8
  %55 = add i64 %pgocount31, 1
  store i64 %55, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 74), align 8
  %pgocount32 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 75), align 8
  %56 = add i64 %pgocount32, 1
  store i64 %56, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 75), align 8
  %pgocount33 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 76), align 8
  %57 = add i64 %pgocount33, 1
  store i64 %57, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 76), align 8
  %58 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr51 = getelementptr inbounds nuw %Expr, ptr %58, i32 0, i32 0
  store i64 193451182, ptr %tag_ptr51, align 8
  %pay_ptr52 = getelementptr inbounds nuw %Expr, ptr %58, i32 0, i32 1
  %59 = call ptr @forge_rc_alloc(i64 16)
  store ptr %59, ptr %pay_ptr52, align 8
  %pgocount34 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 77), align 8
  %60 = add i64 %pgocount34, 1
  store i64 %60, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 77), align 8
  %61 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr53 = getelementptr inbounds nuw %Expr, ptr %61, i32 0, i32 0
  store i64 193465909, ptr %tag_ptr53, align 8
  %pay_ptr54 = getelementptr inbounds nuw %Expr, ptr %61, i32 0, i32 1
  %62 = call ptr @forge_rc_alloc(i64 8)
  store ptr %62, ptr %pay_ptr54, align 8
  %pgocount35 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 78), align 8
  %63 = add i64 %pgocount35, 1
  store i64 %63, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 78), align 8
  %slot_base55 = ptrtoint ptr %62 to i64
  %slot_addr56 = add i64 %slot_base55, 0
  %slot57 = inttoptr i64 %slot_addr56 to ptr
  store i64 1, ptr %slot57, align 8
  %cast58 = ptrtoint ptr %61 to i64
  %slot_base59 = ptrtoint ptr %59 to i64
  %slot_addr60 = add i64 %slot_base59, 0
  %slot61 = inttoptr i64 %slot_addr60 to ptr
  %cast62 = inttoptr i64 %cast58 to ptr
  store ptr %cast62, ptr %slot61, align 8
  %pgocount36 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 79), align 8
  %64 = add i64 %pgocount36, 1
  store i64 %64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 79), align 8
  %65 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr63 = getelementptr inbounds nuw %Expr, ptr %65, i32 0, i32 0
  store i64 193465909, ptr %tag_ptr63, align 8
  %pay_ptr64 = getelementptr inbounds nuw %Expr, ptr %65, i32 0, i32 1
  %66 = call ptr @forge_rc_alloc(i64 8)
  store ptr %66, ptr %pay_ptr64, align 8
  %pgocount37 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 80), align 8
  %67 = add i64 %pgocount37, 1
  store i64 %67, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 80), align 8
  %slot_base65 = ptrtoint ptr %66 to i64
  %slot_addr66 = add i64 %slot_base65, 0
  %slot67 = inttoptr i64 %slot_addr66 to ptr
  store i64 2, ptr %slot67, align 8
  %cast68 = ptrtoint ptr %65 to i64
  %slot_base69 = ptrtoint ptr %59 to i64
  %slot_addr70 = add i64 %slot_base69, 8
  %slot71 = inttoptr i64 %slot_addr70 to ptr
  %cast72 = inttoptr i64 %cast68 to ptr
  store ptr %cast72, ptr %slot71, align 8
  %cast73 = ptrtoint ptr %58 to i64
  %cast74 = inttoptr i64 %cast73 to ptr
  %68 = call ptr @classify_expr(ptr %cast74)
  %69 = call i32 @puts(ptr %68)
  %widen75 = sext i32 %69 to i64
  %pgocount38 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 81), align 8
  %70 = add i64 %pgocount38, 1
  store i64 %70, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 81), align 8
  %pgocount39 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 82), align 8
  %71 = add i64 %pgocount39, 1
  store i64 %71, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 82), align 8
  %pgocount40 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 83), align 8
  %72 = add i64 %pgocount40, 1
  store i64 %72, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 83), align 8
  %pgocount41 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 84), align 8
  %73 = add i64 %pgocount41, 1
  store i64 %73, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 84), align 8
  %pgocount42 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 85), align 8
  %74 = add i64 %pgocount42, 1
  store i64 %74, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 85), align 8
  %75 = call i64 @abs(i64 42)
  %76 = call ptr @forge_rc_alloc(i64 32)
  %77 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %76, i64 32, ptr @.i2s_fmt.27, i64 %75)
  %widen76 = sext i32 %77 to i64
  %78 = call i32 @puts(ptr %76)
  %widen77 = sext i32 %78 to i64
  %pgocount43 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 86), align 8
  %79 = add i64 %pgocount43, 1
  store i64 %79, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 86), align 8
  %pgocount44 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 87), align 8
  %80 = add i64 %pgocount44, 1
  store i64 %80, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 87), align 8
  %pgocount45 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 88), align 8
  %81 = add i64 %pgocount45, 1
  store i64 %81, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 88), align 8
  %pgocount46 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 89), align 8
  %82 = add i64 %pgocount46, 1
  store i64 %82, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 89), align 8
  %pgocount47 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 90), align 8
  %83 = add i64 %pgocount47, 1
  store i64 %83, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 90), align 8
  %pgocount48 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 91), align 8
  %84 = add i64 %pgocount48, 1
  store i64 %84, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 91), align 8
  %85 = call i64 @abs(i64 -42)
  %86 = call ptr @forge_rc_alloc(i64 32)
  %87 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %86, i64 32, ptr @.i2s_fmt.28, i64 %85)
  %widen78 = sext i32 %87 to i64
  %88 = call i32 @puts(ptr %86)
  %widen79 = sext i32 %88 to i64
  %pgocount49 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 92), align 8
  %89 = add i64 %pgocount49, 1
  store i64 %89, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 92), align 8
  %pgocount50 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 93), align 8
  %90 = add i64 %pgocount50, 1
  store i64 %90, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 93), align 8
  %pgocount51 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 94), align 8
  %91 = add i64 %pgocount51, 1
  store i64 %91, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 94), align 8
  %pgocount52 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 95), align 8
  %92 = add i64 %pgocount52, 1
  store i64 %92, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 95), align 8
  %93 = call ptr @categorize(ptr @.str.29)
  %94 = call i32 @puts(ptr %93)
  %widen80 = sext i32 %94 to i64
  %pgocount53 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 96), align 8
  %95 = add i64 %pgocount53, 1
  store i64 %95, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 96), align 8
  %pgocount54 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 97), align 8
  %96 = add i64 %pgocount54, 1
  store i64 %96, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 97), align 8
  %pgocount55 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 98), align 8
  %97 = add i64 %pgocount55, 1
  store i64 %97, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 98), align 8
  %pgocount56 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 99), align 8
  %98 = add i64 %pgocount56, 1
  store i64 %98, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 99), align 8
  %99 = call ptr @categorize(ptr @.str.30)
  %100 = call i32 @puts(ptr %99)
  %widen81 = sext i32 %100 to i64
  %pgocount57 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 100), align 8
  %101 = add i64 %pgocount57, 1
  store i64 %101, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 100), align 8
  %pgocount58 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 101), align 8
  %102 = add i64 %pgocount58, 1
  store i64 %102, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 101), align 8
  %pgocount59 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 102), align 8
  %103 = add i64 %pgocount59, 1
  store i64 %103, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 102), align 8
  %pgocount60 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 103), align 8
  %104 = add i64 %pgocount60, 1
  store i64 %104, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 103), align 8
  %105 = call ptr @categorize(ptr @.str.31)
  %106 = call i32 @puts(ptr %105)
  %widen82 = sext i32 %106 to i64
  %pgocount61 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 104), align 8
  %107 = add i64 %pgocount61, 1
  store i64 %107, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 104), align 8
  %pgocount62 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 105), align 8
  %108 = add i64 %pgocount62, 1
  store i64 %108, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 105), align 8
  %pgocount63 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 106), align 8
  %109 = add i64 %pgocount63, 1
  store i64 %109, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 106), align 8
  %pgocount64 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 107), align 8
  %110 = add i64 %pgocount64, 1
  store i64 %110, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 107), align 8
  %111 = call ptr @categorize(ptr @.str.32)
  %112 = call i32 @puts(ptr %111)
  %widen83 = sext i32 %112 to i64
  %pgocount65 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 108), align 8
  %113 = add i64 %pgocount65, 1
  store i64 %113, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 108), align 8
  %114 = call ptr @forge_array_new()
  %pgocount66 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 109), align 8
  %115 = add i64 %pgocount66, 1
  store i64 %115, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 109), align 8
  call void @forge_array_push(ptr %114, i64 95)
  %pgocount67 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 110), align 8
  %116 = add i64 %pgocount67, 1
  store i64 %116, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 110), align 8
  call void @forge_array_push(ptr %114, i64 82)
  %pgocount68 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 111), align 8
  %117 = add i64 %pgocount68, 1
  store i64 %117, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 111), align 8
  call void @forge_array_push(ptr %114, i64 67)
  %pgocount69 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 112), align 8
  %118 = add i64 %pgocount69, 1
  store i64 %118, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 112), align 8
  call void @forge_array_push(ptr %114, i64 91)
  %pgocount70 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 113), align 8
  %119 = add i64 %pgocount70, 1
  store i64 %119, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 113), align 8
  call void @forge_array_push(ptr %114, i64 43)
  %pgocount71 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 114), align 8
  %120 = add i64 %pgocount71, 1
  store i64 %120, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 114), align 8
  call void @forge_array_push(ptr %114, i64 78)
  store ptr %114, ptr @scores, align 8
  %pgocount72 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 115), align 8
  %121 = add i64 %pgocount72, 1
  store i64 %121, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 115), align 8
  %122 = call ptr @forge_array_new()
  store ptr %122, ptr @grades, align 8
  %pgocount73 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 116), align 8
  %123 = add i64 %pgocount73, 1
  store i64 %123, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 116), align 8
  %pgocount74 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 117), align 8
  %124 = add i64 %pgocount74, 1
  store i64 %124, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 117), align 8
  %pgocount75 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 118), align 8
  %125 = add i64 %pgocount75, 1
  store i64 %125, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 118), align 8
  %scores = load ptr, ptr @scores, align 8
  %126 = call i64 @forge_array_len(ptr %scores)
  store i64 %126, ptr %forin_len, align 8
  store i64 0, ptr %forin_i, align 8
  br label %forin.cond

forin.cond:                                       ; preds = %forin.incr, %entry
  %forin_i_val = load i64, ptr %forin_i, align 8
  %forin_len_val = load i64, ptr %forin_len, align 8
  %forin_cmp = icmp slt i64 %forin_i_val, %forin_len_val
  br i1 %forin_cmp, label %forin.body, label %forin.exit

forin.body:                                       ; preds = %forin.cond
  %127 = call i64 @forge_array_get(ptr %scores, i64 %forin_i_val)
  store i64 %127, ptr %s, align 8
  %pgocount76 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 119), align 8
  %128 = add i64 %pgocount76, 1
  store i64 %128, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 119), align 8
  %pgocount77 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 120), align 8
  %129 = add i64 %pgocount77, 1
  store i64 %129, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 120), align 8
  %pgocount78 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 121), align 8
  %130 = add i64 %pgocount78, 1
  store i64 %130, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 121), align 8
  %pgocount79 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 122), align 8
  %131 = add i64 %pgocount79, 1
  store i64 %131, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 122), align 8
  %s84 = load i64, ptr %s, align 8
  store i64 0, ptr %pmatch_result, align 8
  %pgocount80 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 123), align 8
  %132 = add i64 %pgocount80, 1
  store i64 %132, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 123), align 8
  %pgocount81 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 124), align 8
  %133 = add i64 %pgocount81, 1
  store i64 %133, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 124), align 8
  %s85 = load i64, ptr %s, align 8
  %pgocount82 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 125), align 8
  %134 = add i64 %pgocount82, 1
  store i64 %134, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 125), align 8
  %sge = icmp sge i64 %s85, 90
  %sge_ext = zext i1 %sge to i64
  %pguard = icmp ne i64 %sge_ext, 0
  br i1 %pguard, label %parm_body, label %parm_next

forin.incr:                                       ; preds = %pmatch_end
  %forin_i_old = load i64, ptr %forin_i, align 8
  %forin_next = add i64 %forin_i_old, 1
  store i64 %forin_next, ptr %forin_i, align 8
  br label %forin.cond

forin.exit:                                       ; preds = %forin.cond
  %pgocount83 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 144), align 8
  %135 = add i64 %pgocount83, 1
  store i64 %135, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 144), align 8
  %pgocount84 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 145), align 8
  %136 = add i64 %pgocount84, 1
  store i64 %136, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 145), align 8
  %pgocount85 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 146), align 8
  %137 = add i64 %pgocount85, 1
  store i64 %137, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 146), align 8
  %grades109 = load ptr, ptr @grades, align 8
  %138 = call i64 @forge_array_len(ptr %grades109)
  store i64 %138, ptr %forin_len110, align 8
  store i64 0, ptr %forin_i111, align 8
  br label %forin.cond112

pmatch_end:                                       ; preds = %parm_body104, %parm_body98, %parm_body92, %parm_body86, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  %cast106 = inttoptr i64 %pmatch_val to ptr
  store ptr %cast106, ptr %grade, align 8
  %pgocount86 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 140), align 8
  %139 = add i64 %pgocount86, 1
  store i64 %139, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 140), align 8
  %pgocount87 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 141), align 8
  %140 = add i64 %pgocount87, 1
  store i64 %140, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 141), align 8
  %pgocount88 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 142), align 8
  %141 = add i64 %pgocount88, 1
  store i64 %141, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 142), align 8
  %grades = load ptr, ptr @grades, align 8
  %pgocount89 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 143), align 8
  %142 = add i64 %pgocount89, 1
  store i64 %142, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 143), align 8
  %grade107 = load ptr, ptr %grade, align 8
  %cast108 = ptrtoint ptr %grade107 to i64
  call void @forge_array_push(ptr %grades, i64 %cast108)
  br label %forin.incr

parm_body:                                        ; preds = %forin.body
  %pgocount90 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 126), align 8
  %143 = add i64 %pgocount90, 1
  store i64 %143, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 126), align 8
  store i64 ptrtoint (ptr @.str.33 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %forin.body
  %pgocount91 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 127), align 8
  %144 = add i64 %pgocount91, 1
  store i64 %144, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 127), align 8
  %pgocount92 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 128), align 8
  %145 = add i64 %pgocount92, 1
  store i64 %145, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 128), align 8
  %s88 = load i64, ptr %s, align 8
  %pgocount93 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 129), align 8
  %146 = add i64 %pgocount93, 1
  store i64 %146, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 129), align 8
  %sge89 = icmp sge i64 %s88, 80
  %sge_ext90 = zext i1 %sge89 to i64
  %pguard91 = icmp ne i64 %sge_ext90, 0
  br i1 %pguard91, label %parm_body86, label %parm_next87

parm_body86:                                      ; preds = %parm_next
  %pgocount94 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 130), align 8
  %147 = add i64 %pgocount94, 1
  store i64 %147, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 130), align 8
  store i64 ptrtoint (ptr @.str.34 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next87:                                      ; preds = %parm_next
  %pgocount95 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 131), align 8
  %148 = add i64 %pgocount95, 1
  store i64 %148, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 131), align 8
  %pgocount96 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 132), align 8
  %149 = add i64 %pgocount96, 1
  store i64 %149, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 132), align 8
  %s94 = load i64, ptr %s, align 8
  %pgocount97 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 133), align 8
  %150 = add i64 %pgocount97, 1
  store i64 %150, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 133), align 8
  %sge95 = icmp sge i64 %s94, 70
  %sge_ext96 = zext i1 %sge95 to i64
  %pguard97 = icmp ne i64 %sge_ext96, 0
  br i1 %pguard97, label %parm_body92, label %parm_next93

parm_body92:                                      ; preds = %parm_next87
  %pgocount98 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 134), align 8
  %151 = add i64 %pgocount98, 1
  store i64 %151, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 134), align 8
  store i64 ptrtoint (ptr @.str.35 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next93:                                      ; preds = %parm_next87
  %pgocount99 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 135), align 8
  %152 = add i64 %pgocount99, 1
  store i64 %152, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 135), align 8
  %pgocount100 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 136), align 8
  %153 = add i64 %pgocount100, 1
  store i64 %153, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 136), align 8
  %s100 = load i64, ptr %s, align 8
  %pgocount101 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 137), align 8
  %154 = add i64 %pgocount101, 1
  store i64 %154, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 137), align 8
  %sge101 = icmp sge i64 %s100, 60
  %sge_ext102 = zext i1 %sge101 to i64
  %pguard103 = icmp ne i64 %sge_ext102, 0
  br i1 %pguard103, label %parm_body98, label %parm_next99

parm_body98:                                      ; preds = %parm_next93
  %pgocount102 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 138), align 8
  %155 = add i64 %pgocount102, 1
  store i64 %155, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 138), align 8
  store i64 ptrtoint (ptr @.str.36 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next99:                                      ; preds = %parm_next93
  br label %parm_body104

parm_body104:                                     ; preds = %parm_next99
  %pgocount103 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 139), align 8
  %156 = add i64 %pgocount103, 1
  store i64 %156, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 139), align 8
  store i64 ptrtoint (ptr @.str.37 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next105:                                     ; No predecessors!
  call void @forge_match_unreachable(ptr @.match_fn.38, i64 -1, ptr @mu_file.39, i64 60)
  unreachable

forin.cond112:                                    ; preds = %forin.incr114, %forin.exit
  %forin_i_val116 = load i64, ptr %forin_i111, align 8
  %forin_len_val117 = load i64, ptr %forin_len110, align 8
  %forin_cmp118 = icmp slt i64 %forin_i_val116, %forin_len_val117
  br i1 %forin_cmp118, label %forin.body113, label %forin.exit115

forin.body113:                                    ; preds = %forin.cond112
  %157 = call i64 @forge_array_get(ptr %grades109, i64 %forin_i_val116)
  store i64 %157, ptr %g, align 8
  %pgocount104 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 147), align 8
  %158 = add i64 %pgocount104, 1
  store i64 %158, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 147), align 8
  %pgocount105 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 148), align 8
  %159 = add i64 %pgocount105, 1
  store i64 %159, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 148), align 8
  %pgocount106 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 149), align 8
  %160 = add i64 %pgocount106, 1
  store i64 %160, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 149), align 8
  %pgocount107 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 150), align 8
  %161 = add i64 %pgocount107, 1
  store i64 %161, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 150), align 8
  %g119 = load i64, ptr %g, align 8
  %cast120 = inttoptr i64 %g119 to ptr
  %162 = call i32 @puts(ptr %cast120)
  %widen121 = sext i32 %162 to i64
  br label %forin.incr114

forin.incr114:                                    ; preds = %forin.body113
  %forin_i_old122 = load i64, ptr %forin_i111, align 8
  %forin_next123 = add i64 %forin_i_old122, 1
  store i64 %forin_next123, ptr %forin_i111, align 8
  br label %forin.cond112

forin.exit115:                                    ; preds = %forin.cond112
  %pgocount108 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 151), align 8
  %163 = add i64 %pgocount108, 1
  store i64 %163, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 151), align 8
  %pgocount109 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 152), align 8
  %164 = add i64 %pgocount109, 1
  store i64 %164, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 152), align 8
  %pgocount110 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 153), align 8
  %165 = add i64 %pgocount110, 1
  store i64 %165, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 153), align 8
  %pgocount111 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 154), align 8
  %166 = add i64 %pgocount111, 1
  store i64 %166, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 154), align 8
  %pgocount112 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 155), align 8
  %167 = add i64 %pgocount112, 1
  store i64 %167, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 155), align 8
  %168 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr124 = getelementptr inbounds nuw %Response, ptr %168, i32 0, i32 0
  store i64 229441733419486, ptr %tag_ptr124, align 8
  %pay_ptr125 = getelementptr inbounds nuw %Response, ptr %168, i32 0, i32 1
  %169 = call ptr @forge_rc_alloc(i64 8)
  store ptr %169, ptr %pay_ptr125, align 8
  %pgocount113 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 156), align 8
  %170 = add i64 %pgocount113, 1
  store i64 %170, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 156), align 8
  %slot_base126 = ptrtoint ptr %169 to i64
  %slot_addr127 = add i64 %slot_base126, 0
  %slot128 = inttoptr i64 %slot_addr127 to ptr
  store i64 200, ptr %slot128, align 8
  %cast129 = ptrtoint ptr %168 to i64
  %cast130 = inttoptr i64 %cast129 to ptr
  %171 = call ptr @describe_response(ptr %cast130)
  %172 = call i32 @puts(ptr %171)
  %widen131 = sext i32 %172 to i64
  %pgocount114 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 157), align 8
  %173 = add i64 %pgocount114, 1
  store i64 %173, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 157), align 8
  %pgocount115 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 158), align 8
  %174 = add i64 %pgocount115, 1
  store i64 %174, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 158), align 8
  %pgocount116 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 159), align 8
  %175 = add i64 %pgocount116, 1
  store i64 %175, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 159), align 8
  %pgocount117 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 160), align 8
  %176 = add i64 %pgocount117, 1
  store i64 %176, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 160), align 8
  %177 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr132 = getelementptr inbounds nuw %Response, ptr %177, i32 0, i32 0
  store i64 229441733419486, ptr %tag_ptr132, align 8
  %pay_ptr133 = getelementptr inbounds nuw %Response, ptr %177, i32 0, i32 1
  %178 = call ptr @forge_rc_alloc(i64 8)
  store ptr %178, ptr %pay_ptr133, align 8
  %pgocount118 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 161), align 8
  %179 = add i64 %pgocount118, 1
  store i64 %179, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 161), align 8
  %slot_base134 = ptrtoint ptr %178 to i64
  %slot_addr135 = add i64 %slot_base134, 0
  %slot136 = inttoptr i64 %slot_addr135 to ptr
  store i64 201, ptr %slot136, align 8
  %cast137 = ptrtoint ptr %177 to i64
  %cast138 = inttoptr i64 %cast137 to ptr
  %180 = call ptr @describe_response(ptr %cast138)
  %181 = call i32 @puts(ptr %180)
  %widen139 = sext i32 %181 to i64
  %pgocount119 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 162), align 8
  %182 = add i64 %pgocount119, 1
  store i64 %182, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 162), align 8
  %pgocount120 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 163), align 8
  %183 = add i64 %pgocount120, 1
  store i64 %183, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 163), align 8
  %pgocount121 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 164), align 8
  %184 = add i64 %pgocount121, 1
  store i64 %184, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 164), align 8
  %pgocount122 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 165), align 8
  %185 = add i64 %pgocount122, 1
  store i64 %185, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 165), align 8
  %186 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr140 = getelementptr inbounds nuw %Response, ptr %186, i32 0, i32 0
  store i64 229441733419486, ptr %tag_ptr140, align 8
  %pay_ptr141 = getelementptr inbounds nuw %Response, ptr %186, i32 0, i32 1
  %187 = call ptr @forge_rc_alloc(i64 8)
  store ptr %187, ptr %pay_ptr141, align 8
  %pgocount123 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 166), align 8
  %188 = add i64 %pgocount123, 1
  store i64 %188, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 166), align 8
  %slot_base142 = ptrtoint ptr %187 to i64
  %slot_addr143 = add i64 %slot_base142, 0
  %slot144 = inttoptr i64 %slot_addr143 to ptr
  store i64 302, ptr %slot144, align 8
  %cast145 = ptrtoint ptr %186 to i64
  %cast146 = inttoptr i64 %cast145 to ptr
  %189 = call ptr @describe_response(ptr %cast146)
  %190 = call i32 @puts(ptr %189)
  %widen147 = sext i32 %190 to i64
  %pgocount124 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 167), align 8
  %191 = add i64 %pgocount124, 1
  store i64 %191, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 167), align 8
  %pgocount125 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 168), align 8
  %192 = add i64 %pgocount125, 1
  store i64 %192, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 168), align 8
  %pgocount126 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 169), align 8
  %193 = add i64 %pgocount126, 1
  store i64 %193, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 169), align 8
  %pgocount127 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 170), align 8
  %194 = add i64 %pgocount127, 1
  store i64 %194, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 170), align 8
  %195 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr148 = getelementptr inbounds nuw %Response, ptr %195, i32 0, i32 0
  store i64 210673603023, ptr %tag_ptr148, align 8
  %pay_ptr149 = getelementptr inbounds nuw %Response, ptr %195, i32 0, i32 1
  %196 = call ptr @forge_rc_alloc(i64 16)
  store ptr %196, ptr %pay_ptr149, align 8
  %pgocount128 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 171), align 8
  %197 = add i64 %pgocount128, 1
  store i64 %197, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 171), align 8
  %slot_base150 = ptrtoint ptr %196 to i64
  %slot_addr151 = add i64 %slot_base150, 0
  %slot152 = inttoptr i64 %slot_addr151 to ptr
  store i64 500, ptr %slot152, align 8
  %pgocount129 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 172), align 8
  %198 = add i64 %pgocount129, 1
  store i64 %198, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 172), align 8
  %slot_base153 = ptrtoint ptr %196 to i64
  %slot_addr154 = add i64 %slot_base153, 8
  %slot155 = inttoptr i64 %slot_addr154 to ptr
  store ptr @.str.40, ptr %slot155, align 8
  %cast156 = ptrtoint ptr %195 to i64
  %cast157 = inttoptr i64 %cast156 to ptr
  %199 = call ptr @describe_response(ptr %cast157)
  %200 = call i32 @puts(ptr %199)
  %widen158 = sext i32 %200 to i64
  %pgocount130 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 173), align 8
  %201 = add i64 %pgocount130, 1
  store i64 %201, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 173), align 8
  %pgocount131 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 174), align 8
  %202 = add i64 %pgocount131, 1
  store i64 %202, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 174), align 8
  %pgocount132 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 175), align 8
  %203 = add i64 %pgocount132, 1
  store i64 %203, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 175), align 8
  %pgocount133 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 176), align 8
  %204 = add i64 %pgocount133, 1
  store i64 %204, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 176), align 8
  %205 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr159 = getelementptr inbounds nuw %Response, ptr %205, i32 0, i32 0
  store i64 210673603023, ptr %tag_ptr159, align 8
  %pay_ptr160 = getelementptr inbounds nuw %Response, ptr %205, i32 0, i32 1
  %206 = call ptr @forge_rc_alloc(i64 16)
  store ptr %206, ptr %pay_ptr160, align 8
  %pgocount134 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 177), align 8
  %207 = add i64 %pgocount134, 1
  store i64 %207, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 177), align 8
  %slot_base161 = ptrtoint ptr %206 to i64
  %slot_addr162 = add i64 %slot_base161, 0
  %slot163 = inttoptr i64 %slot_addr162 to ptr
  store i64 404, ptr %slot163, align 8
  %pgocount135 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 178), align 8
  %208 = add i64 %pgocount135, 1
  store i64 %208, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 178), align 8
  %slot_base164 = ptrtoint ptr %206 to i64
  %slot_addr165 = add i64 %slot_base164, 8
  %slot166 = inttoptr i64 %slot_addr165 to ptr
  store ptr @.str.41, ptr %slot166, align 8
  %cast167 = ptrtoint ptr %205 to i64
  %cast168 = inttoptr i64 %cast167 to ptr
  %209 = call ptr @describe_response(ptr %cast168)
  %210 = call i32 @puts(ptr %209)
  %widen169 = sext i32 %210 to i64
  %pgocount136 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 179), align 8
  %211 = add i64 %pgocount136, 1
  store i64 %211, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 179), align 8
  %pgocount137 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 180), align 8
  %212 = add i64 %pgocount137, 1
  store i64 %212, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 180), align 8
  %pgocount138 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 181), align 8
  %213 = add i64 %pgocount138, 1
  store i64 %213, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 181), align 8
  %pgocount139 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 182), align 8
  %214 = add i64 %pgocount139, 1
  store i64 %214, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 182), align 8
  %215 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr170 = getelementptr inbounds nuw %Response, ptr %215, i32 0, i32 0
  store i64 210673603023, ptr %tag_ptr170, align 8
  %pay_ptr171 = getelementptr inbounds nuw %Response, ptr %215, i32 0, i32 1
  %216 = call ptr @forge_rc_alloc(i64 16)
  store ptr %216, ptr %pay_ptr171, align 8
  %pgocount140 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 183), align 8
  %217 = add i64 %pgocount140, 1
  store i64 %217, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 183), align 8
  %slot_base172 = ptrtoint ptr %216 to i64
  %slot_addr173 = add i64 %slot_base172, 0
  %slot174 = inttoptr i64 %slot_addr173 to ptr
  store i64 403, ptr %slot174, align 8
  %pgocount141 = load i64, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 184), align 8
  %218 = add i64 %pgocount141, 1
  store i64 %218, ptr getelementptr inbounds ([185 x i64], ptr @__profc_main, i32 0, i32 184), align 8
  %slot_base175 = ptrtoint ptr %216 to i64
  %slot_addr176 = add i64 %slot_base175, 8
  %slot177 = inttoptr i64 %slot_addr176 to ptr
  store ptr @.str.42, ptr %slot177, align 8
  %cast178 = ptrtoint ptr %215 to i64
  %cast179 = inttoptr i64 %cast178 to ptr
  %219 = call ptr @describe_response(ptr %cast179)
  %220 = call i32 @puts(ptr %219)
  %widen180 = sext i32 %220 to i64
  %221 = call i32 @forge_test_summary()
  %widen181 = sext i32 %221 to i64
  call void @forge_rc_collect()
  ret i64 0
}

define i64 @__release_Response(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %Response, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Response, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Error = icmp eq i64 %tag, 210673603023
  br i1 %is_Error, label %rel_Error, label %try_next_Error

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %fields_done, %alive
  ret i64 0

fields_done:                                      ; preds = %vrel_msg_skip, %try_next_Error
  call void @forge_rc_free(ptr %0)
  br label %done

rel_Error:                                        ; preds = %do_free
  %vrel_msg_ptr = getelementptr inbounds nuw %Response__Error, ptr %payload, i32 0, i32 1
  %vrel_msg = load ptr, ptr %vrel_msg_ptr, align 8
  %vrel_null_msg = icmp eq ptr %vrel_msg, null
  br i1 %vrel_null_msg, label %vrel_msg_skip, label %vrel_msg_do

try_next_Error:                                   ; preds = %do_free
  br label %fields_done

vrel_msg_skip:                                    ; preds = %vrel_msg_do, %rel_Error
  br label %fields_done

vrel_msg_do:                                      ; preds = %rel_Error
  call void @forge_rc_release(ptr %vrel_msg)
  br label %vrel_msg_skip
}

define i64 @__release_Expr(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %Expr, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Expr, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Add = icmp eq i64 %tag, 193451182
  br i1 %is_Add, label %rel_Add, label %try_next_Add

alive:                                            ; preds = %entry
  call void @forge_rc_suspect(ptr %0)
  br label %done

done:                                             ; preds = %fields_done, %alive
  ret i64 0

fields_done:                                      ; preds = %vrel_b_skip, %try_next_Add
  call void @forge_rc_free(ptr %0)
  br label %done

rel_Add:                                          ; preds = %do_free
  %vrel_a_ptr = getelementptr inbounds nuw %Expr__Add, ptr %payload, i32 0, i32 0
  %vrel_a = load ptr, ptr %vrel_a_ptr, align 8
  %vrel_null_a = icmp eq ptr %vrel_a, null
  br i1 %vrel_null_a, label %vrel_a_skip, label %vrel_a_do

try_next_Add:                                     ; preds = %do_free
  br label %fields_done

vrel_a_skip:                                      ; preds = %vrel_a_do, %rel_Add
  %vrel_b_ptr = getelementptr inbounds nuw %Expr__Add, ptr %payload, i32 0, i32 1
  %vrel_b = load ptr, ptr %vrel_b_ptr, align 8
  %vrel_null_b = icmp eq ptr %vrel_b, null
  br i1 %vrel_null_b, label %vrel_b_skip, label %vrel_b_do

vrel_a_do:                                        ; preds = %rel_Add
  %2 = call i64 @__release_Expr(ptr %vrel_a)
  br label %vrel_a_skip

vrel_b_skip:                                      ; preds = %vrel_b_do, %vrel_a_skip
  br label %fields_done

vrel_b_do:                                        ; preds = %vrel_a_skip
  %3 = call i64 @__release_Expr(ptr %vrel_b)
  br label %vrel_b_skip
}

; Function Attrs: noinline
define linkonce_odr hidden i32 @__llvm_profile_runtime_user() #1 {
  %1 = load i32, ptr @__llvm_profile_runtime, align 4
  ret i32 %1
}

attributes #0 = { nounwind }
attributes #1 = { noinline }
