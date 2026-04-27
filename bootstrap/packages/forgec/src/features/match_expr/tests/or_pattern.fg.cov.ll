; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/or_pattern.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

%Direction = type { i64, ptr }

@.match_fn = private unnamed_addr constant [14 x i8] c"is_horizontal\00", align 1
@mu_file = private unnamed_addr constant [137 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/or_pattern.fg\00", align 1
@.str = private unnamed_addr constant [9 x i8] c"not west\00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"west\00", align 1
@.match_fn.2 = private unnamed_addr constant [13 x i8] c"describe_dir\00", align 1
@mu_file.3 = private unnamed_addr constant [137 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/or_pattern.fg\00", align 1
@.str.4 = private unnamed_addr constant [18 x i8] c"even single digit\00", align 1
@.str.5 = private unnamed_addr constant [17 x i8] c"odd single digit\00", align 1
@.str.6 = private unnamed_addr constant [24 x i8] c"multi-digit or negative\00", align 1
@.match_fn.7 = private unnamed_addr constant [7 x i8] c"parity\00", align 1
@mu_file.8 = private unnamed_addr constant [137 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/or_pattern.fg\00", align 1
@.lit_str = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.lit_str.9 = private unnamed_addr constant [2 x i8] c"e\00", align 1
@.lit_str.10 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.lit_str.11 = private unnamed_addr constant [2 x i8] c"o\00", align 1
@.lit_str.12 = private unnamed_addr constant [2 x i8] c"u\00", align 1
@.match_fn.13 = private unnamed_addr constant [14 x i8] c"is_vowel_word\00", align 1
@mu_file.14 = private unnamed_addr constant [137 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/or_pattern.fg\00", align 1
@.str.15 = private unnamed_addr constant [15 x i8] c"small positive\00", align 1
@.str.16 = private unnamed_addr constant [6 x i8] c"other\00", align 1
@.match_fn.17 = private unnamed_addr constant [15 x i8] c"describe_small\00", align 1
@mu_file.18 = private unnamed_addr constant [137 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/or_pattern.fg\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.19 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.20 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.21 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.i2s_fmt.22 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.23 = private unnamed_addr constant [2 x i8] c"e\00", align 1
@.i2s_fmt.24 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.25 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@.i2s_fmt.26 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_is_horizontal = private global [7 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_is_horizontal = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 9012317860476752543, i64 6292523829945197994, i64 sub (i64 ptrtoint (ptr @__profc_is_horizontal to i64), i64 ptrtoint (ptr @__profd_is_horizontal to i64)), i64 0, ptr null, ptr null, i32 7, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_describe_dir = private global [7 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_describe_dir = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 3175250494313700813, i64 -3436502252430531196, i64 sub (i64 ptrtoint (ptr @__profc_describe_dir to i64), i64 ptrtoint (ptr @__profd_describe_dir to i64)), i64 0, ptr null, ptr null, i32 7, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_parity = private global [6 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_parity = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 8600256836972362410, i64 6953891554654, i64 sub (i64 ptrtoint (ptr @__profc_parity to i64), i64 ptrtoint (ptr @__profd_parity to i64)), i64 0, ptr null, ptr null, i32 6, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_is_vowel_word = private global [5 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_is_vowel_word = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 8911982159253009989, i64 6293173798086616648, i64 sub (i64 ptrtoint (ptr @__profc_is_vowel_word to i64), i64 ptrtoint (ptr @__profd_is_vowel_word to i64)), i64 0, ptr null, ptr null, i32 5, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_describe_small = private global [8 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_describe_small = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 8384529412581877883, i64 2338094066208423326, i64 sub (i64 ptrtoint (ptr @__profc_describe_small to i64), i64 ptrtoint (ptr @__profd_describe_small to i64)), i64 0, ptr null, ptr null, i32 8, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_main = private global [83 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 83, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__llvm_prf_nm = private constant [65 x i8] c"C?x\DAE\CAA\0A\C00\08\04@|\A9\D8*d\C1\C4\A2\A1!y}\8F\9D\F3\A0\B8E\E2\C4\98\E2\A4Vw\E22V$=\92\98\9BP\FC\C62\E7\15\A9\FF\A8.\EE\D4\05\E3\03z\81\19\E4", section "__DATA,__llvm_prf_names", align 1
@llvm.compiler.used = appending global [7 x ptr] [ptr @__llvm_profile_runtime_user, ptr @__profd_is_horizontal, ptr @__profd_describe_dir, ptr @__profd_parity, ptr @__profd_is_vowel_word, ptr @__profd_describe_small, ptr @__profd_main], section "llvm.metadata"
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

define i1 @is_horizontal(ptr %0) {
entry:
  %match_result = alloca i64, align 8
  %d = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_is_horizontal, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_is_horizontal, align 8
  store ptr %0, ptr %d, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([7 x i64], ptr @__profc_is_horizontal, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([7 x i64], ptr @__profc_is_horizontal, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([7 x i64], ptr @__profc_is_horizontal, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([7 x i64], ptr @__profc_is_horizontal, i32 0, i32 2), align 8
  %d1 = load ptr, ptr %d, align 8
  %tag_ptr = getelementptr inbounds nuw %Direction, ptr %d1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 6384030098
  br i1 %tag_eq, label %march_arm, label %or_mid

match_end:                                        ; preds = %march_arm3, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast = trunc i64 %match_val to i1
  ret i1 %cast

march_arm:                                        ; preds = %or_mid, %entry
  %pgocount3 = load i64, ptr getelementptr inbounds ([7 x i64], ptr @__profc_is_horizontal, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([7 x i64], ptr @__profc_is_horizontal, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([7 x i64], ptr @__profc_is_horizontal, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([7 x i64], ptr @__profc_is_horizontal, i32 0, i32 4), align 8
  store i64 1, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %or_mid
  br label %march_arm3

or_mid:                                           ; preds = %entry
  %tag_eq2 = icmp eq i64 %tag, 6384681320
  br i1 %tag_eq2, label %march_arm, label %march_next

march_arm3:                                       ; preds = %march_next
  %pgocount5 = load i64, ptr getelementptr inbounds ([7 x i64], ptr @__profc_is_horizontal, i32 0, i32 5), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([7 x i64], ptr @__profc_is_horizontal, i32 0, i32 5), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([7 x i64], ptr @__profc_is_horizontal, i32 0, i32 6), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([7 x i64], ptr @__profc_is_horizontal, i32 0, i32 6), align 8
  store i64 0, ptr %match_result, align 8
  br label %match_end

march_next4:                                      ; No predecessors!
  call void @forge_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 7)
  unreachable
}

define ptr @describe_dir(ptr %0) {
entry:
  %match_result = alloca i64, align 8
  %d = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_describe_dir, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_describe_dir, align 8
  store ptr %0, ptr %d, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([7 x i64], ptr @__profc_describe_dir, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([7 x i64], ptr @__profc_describe_dir, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([7 x i64], ptr @__profc_describe_dir, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([7 x i64], ptr @__profc_describe_dir, i32 0, i32 2), align 8
  %d1 = load ptr, ptr %d, align 8
  %tag_ptr = getelementptr inbounds nuw %Direction, ptr %d1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 210684168656
  br i1 %tag_eq, label %march_arm, label %or_mid

match_end:                                        ; preds = %march_arm5, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast = inttoptr i64 %match_val to ptr
  ret ptr %cast

march_arm:                                        ; preds = %or_mid2, %or_mid, %entry
  %pgocount3 = load i64, ptr getelementptr inbounds ([7 x i64], ptr @__profc_describe_dir, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([7 x i64], ptr @__profc_describe_dir, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([7 x i64], ptr @__profc_describe_dir, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([7 x i64], ptr @__profc_describe_dir, i32 0, i32 4), align 8
  store i64 ptrtoint (ptr @.str to i64), ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %or_mid2
  %tag_eq7 = icmp eq i64 %tag, 6384681320
  br i1 %tag_eq7, label %march_arm5, label %march_next6

or_mid:                                           ; preds = %entry
  %tag_eq3 = icmp eq i64 %tag, 210690101528
  br i1 %tag_eq3, label %march_arm, label %or_mid2

or_mid2:                                          ; preds = %or_mid
  %tag_eq4 = icmp eq i64 %tag, 6384030098
  br i1 %tag_eq4, label %march_arm, label %march_next

march_arm5:                                       ; preds = %march_next
  %pgocount5 = load i64, ptr getelementptr inbounds ([7 x i64], ptr @__profc_describe_dir, i32 0, i32 5), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([7 x i64], ptr @__profc_describe_dir, i32 0, i32 5), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([7 x i64], ptr @__profc_describe_dir, i32 0, i32 6), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([7 x i64], ptr @__profc_describe_dir, i32 0, i32 6), align 8
  store i64 ptrtoint (ptr @.str.1 to i64), ptr %match_result, align 8
  br label %match_end

march_next6:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn.2, i64 %tag, ptr @mu_file.3, i64 19)
  unreachable
}

define ptr @parity(i64 %0) {
entry:
  %pmatch_result = alloca i64, align 8
  %n = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_parity, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_parity, align 8
  store i64 %0, ptr %n, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_parity, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([6 x i64], ptr @__profc_parity, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_parity, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([6 x i64], ptr @__profc_parity, i32 0, i32 2), align 8
  %n1 = load i64, ptr %n, align 8
  store i64 0, ptr %pmatch_result, align 8
  %lit_eq = icmp eq i64 %n1, 0
  %lit_eq2 = icmp eq i64 %n1, 2
  %lit_eq3 = icmp eq i64 %n1, 4
  %lit_eq4 = icmp eq i64 %n1, 6
  %lit_eq5 = icmp eq i64 %n1, 8
  %or_cmp = or i1 %lit_eq4, %lit_eq5
  %or_cmp6 = or i1 %lit_eq3, %or_cmp
  %or_cmp7 = or i1 %lit_eq2, %or_cmp6
  %or_cmp8 = or i1 %lit_eq, %or_cmp7
  br i1 %or_cmp8, label %parm_body, label %parm_next

pmatch_end:                                       ; preds = %parm_body20, %parm_body9, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  %cast = inttoptr i64 %pmatch_val to ptr
  ret ptr %cast

parm_body:                                        ; preds = %entry
  %pgocount3 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_parity, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([6 x i64], ptr @__profc_parity, i32 0, i32 3), align 8
  store i64 ptrtoint (ptr @.str.4 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %entry
  %lit_eq11 = icmp eq i64 %n1, 1
  %lit_eq12 = icmp eq i64 %n1, 3
  %lit_eq13 = icmp eq i64 %n1, 5
  %lit_eq14 = icmp eq i64 %n1, 7
  %lit_eq15 = icmp eq i64 %n1, 9
  %or_cmp16 = or i1 %lit_eq14, %lit_eq15
  %or_cmp17 = or i1 %lit_eq13, %or_cmp16
  %or_cmp18 = or i1 %lit_eq12, %or_cmp17
  %or_cmp19 = or i1 %lit_eq11, %or_cmp18
  br i1 %or_cmp19, label %parm_body9, label %parm_next10

parm_body9:                                       ; preds = %parm_next
  %pgocount4 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_parity, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([6 x i64], ptr @__profc_parity, i32 0, i32 4), align 8
  store i64 ptrtoint (ptr @.str.5 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next10:                                      ; preds = %parm_next
  br label %parm_body20

parm_body20:                                      ; preds = %parm_next10
  %pgocount5 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_parity, i32 0, i32 5), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([6 x i64], ptr @__profc_parity, i32 0, i32 5), align 8
  store i64 ptrtoint (ptr @.str.6 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next21:                                      ; No predecessors!
  call void @forge_match_unreachable(ptr @.match_fn.7, i64 -1, ptr @mu_file.8, i64 32)
  unreachable
}

define i1 @is_vowel_word(ptr %0) {
entry:
  %pmatch_result = alloca i64, align 8
  %s = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_is_vowel_word, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_is_vowel_word, align 8
  store ptr %0, ptr %s, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([5 x i64], ptr @__profc_is_vowel_word, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([5 x i64], ptr @__profc_is_vowel_word, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([5 x i64], ptr @__profc_is_vowel_word, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([5 x i64], ptr @__profc_is_vowel_word, i32 0, i32 2), align 8
  %s1 = load ptr, ptr %s, align 8
  store i64 0, ptr %pmatch_result, align 8
  %4 = call i32 @strcmp(ptr %s1, ptr @.lit_str)
  %widen = sext i32 %4 to i64
  %str_eq = icmp eq i64 %widen, 0
  %5 = call i32 @strcmp(ptr %s1, ptr @.lit_str.9)
  %widen2 = sext i32 %5 to i64
  %str_eq3 = icmp eq i64 %widen2, 0
  %6 = call i32 @strcmp(ptr %s1, ptr @.lit_str.10)
  %widen4 = sext i32 %6 to i64
  %str_eq5 = icmp eq i64 %widen4, 0
  %7 = call i32 @strcmp(ptr %s1, ptr @.lit_str.11)
  %widen6 = sext i32 %7 to i64
  %str_eq7 = icmp eq i64 %widen6, 0
  %8 = call i32 @strcmp(ptr %s1, ptr @.lit_str.12)
  %widen8 = sext i32 %8 to i64
  %str_eq9 = icmp eq i64 %widen8, 0
  %or_cmp = or i1 %str_eq7, %str_eq9
  %or_cmp10 = or i1 %str_eq5, %or_cmp
  %or_cmp11 = or i1 %str_eq3, %or_cmp10
  %or_cmp12 = or i1 %str_eq, %or_cmp11
  br i1 %or_cmp12, label %parm_body, label %parm_next

pmatch_end:                                       ; preds = %parm_body13, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  %cast = trunc i64 %pmatch_val to i1
  ret i1 %cast

parm_body:                                        ; preds = %entry
  %pgocount3 = load i64, ptr getelementptr inbounds ([5 x i64], ptr @__profc_is_vowel_word, i32 0, i32 3), align 8
  %9 = add i64 %pgocount3, 1
  store i64 %9, ptr getelementptr inbounds ([5 x i64], ptr @__profc_is_vowel_word, i32 0, i32 3), align 8
  store i64 1, ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %entry
  br label %parm_body13

parm_body13:                                      ; preds = %parm_next
  %pgocount4 = load i64, ptr getelementptr inbounds ([5 x i64], ptr @__profc_is_vowel_word, i32 0, i32 4), align 8
  %10 = add i64 %pgocount4, 1
  store i64 %10, ptr getelementptr inbounds ([5 x i64], ptr @__profc_is_vowel_word, i32 0, i32 4), align 8
  store i64 0, ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next14:                                      ; No predecessors!
  call void @forge_match_unreachable(ptr @.match_fn.13, i64 -1, ptr @mu_file.14, i64 46)
  unreachable
}

define ptr @describe_small(i64 %0) {
entry:
  %pmatch_result = alloca i64, align 8
  %n = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_describe_small, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_describe_small, align 8
  store i64 %0, ptr %n, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_describe_small, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([8 x i64], ptr @__profc_describe_small, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_describe_small, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([8 x i64], ptr @__profc_describe_small, i32 0, i32 2), align 8
  %n1 = load i64, ptr %n, align 8
  store i64 0, ptr %pmatch_result, align 8
  %lit_eq = icmp eq i64 %n1, 1
  %lit_eq2 = icmp eq i64 %n1, 2
  %or_cmp = or i1 %lit_eq, %lit_eq2
  br i1 %or_cmp, label %lit_guard, label %parm_next

pmatch_end:                                       ; preds = %parm_body4, %parm_body
  %pmatch_val = load i64, ptr %pmatch_result, align 8
  %cast = inttoptr i64 %pmatch_val to ptr
  ret ptr %cast

parm_body:                                        ; preds = %lit_guard
  %pgocount3 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_describe_small, i32 0, i32 6), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([8 x i64], ptr @__profc_describe_small, i32 0, i32 6), align 8
  store i64 ptrtoint (ptr @.str.15 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next:                                        ; preds = %lit_guard, %entry
  br label %parm_body4

lit_guard:                                        ; preds = %entry
  %pgocount4 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_describe_small, i32 0, i32 3), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([8 x i64], ptr @__profc_describe_small, i32 0, i32 3), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_describe_small, i32 0, i32 4), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([8 x i64], ptr @__profc_describe_small, i32 0, i32 4), align 8
  %n3 = load i64, ptr %n, align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_describe_small, i32 0, i32 5), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([8 x i64], ptr @__profc_describe_small, i32 0, i32 5), align 8
  %sgt = icmp sgt i64 %n3, 0
  %sgt_ext = zext i1 %sgt to i64
  %pguard = icmp ne i64 %sgt_ext, 0
  br i1 %pguard, label %parm_body, label %parm_next

parm_body4:                                       ; preds = %parm_next
  %pgocount7 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_describe_small, i32 0, i32 7), align 8
  %8 = add i64 %pgocount7, 1
  store i64 %8, ptr getelementptr inbounds ([8 x i64], ptr @__profc_describe_small, i32 0, i32 7), align 8
  store i64 ptrtoint (ptr @.str.16 to i64), ptr %pmatch_result, align 8
  br label %pmatch_end

parm_next5:                                       ; No predecessors!
  call void @forge_match_unreachable(ptr @.match_fn.17, i64 -1, ptr @mu_file.18, i64 58)
  unreachable
}

define i64 @main() {
entry:
  %pgocount = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %3 = add i64 %pgocount3, 1
  store i64 %3, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %4 = add i64 %pgocount4, 1
  store i64 %4, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %5 = add i64 %pgocount5, 1
  store i64 %5, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %6 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Direction, ptr %6, i32 0, i32 0
  store i64 6384030098, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Direction, ptr %6, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %6 to i64
  %cast1 = inttoptr i64 %cast to ptr
  %7 = call i1 @is_horizontal(ptr %cast1)
  %widen = zext i1 %7 to i64
  %8 = call ptr @forge_rc_alloc(i64 32)
  %9 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %8, i64 32, ptr @.i2s_fmt, i64 %widen)
  %widen2 = sext i32 %9 to i64
  %10 = call i32 @puts(ptr %8)
  %widen3 = sext i32 %10 to i64
  %pgocount6 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %11 = add i64 %pgocount6, 1
  store i64 %11, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %12 = add i64 %pgocount7, 1
  store i64 %12, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %13 = add i64 %pgocount8, 1
  store i64 %13, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %14 = add i64 %pgocount9, 1
  store i64 %14, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %15 = add i64 %pgocount10, 1
  store i64 %15, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %16 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr4 = getelementptr inbounds nuw %Direction, ptr %16, i32 0, i32 0
  store i64 6384681320, ptr %tag_ptr4, align 8
  %pay_ptr5 = getelementptr inbounds nuw %Direction, ptr %16, i32 0, i32 1
  store ptr null, ptr %pay_ptr5, align 8
  %cast6 = ptrtoint ptr %16 to i64
  %cast7 = inttoptr i64 %cast6 to ptr
  %17 = call i1 @is_horizontal(ptr %cast7)
  %widen8 = zext i1 %17 to i64
  %18 = call ptr @forge_rc_alloc(i64 32)
  %19 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %18, i64 32, ptr @.i2s_fmt.19, i64 %widen8)
  %widen9 = sext i32 %19 to i64
  %20 = call i32 @puts(ptr %18)
  %widen10 = sext i32 %20 to i64
  %pgocount11 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %21 = add i64 %pgocount11, 1
  store i64 %21, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %22 = add i64 %pgocount12, 1
  store i64 %22, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %23 = add i64 %pgocount13, 1
  store i64 %23, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %24 = add i64 %pgocount14, 1
  store i64 %24, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %25 = add i64 %pgocount15, 1
  store i64 %25, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %26 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr11 = getelementptr inbounds nuw %Direction, ptr %26, i32 0, i32 0
  store i64 210684168656, ptr %tag_ptr11, align 8
  %pay_ptr12 = getelementptr inbounds nuw %Direction, ptr %26, i32 0, i32 1
  store ptr null, ptr %pay_ptr12, align 8
  %cast13 = ptrtoint ptr %26 to i64
  %cast14 = inttoptr i64 %cast13 to ptr
  %27 = call i1 @is_horizontal(ptr %cast14)
  %widen15 = zext i1 %27 to i64
  %28 = call ptr @forge_rc_alloc(i64 32)
  %29 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %28, i64 32, ptr @.i2s_fmt.20, i64 %widen15)
  %widen16 = sext i32 %29 to i64
  %30 = call i32 @puts(ptr %28)
  %widen17 = sext i32 %30 to i64
  %pgocount16 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %31 = add i64 %pgocount16, 1
  store i64 %31, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %pgocount17 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %32 = add i64 %pgocount17, 1
  store i64 %32, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %33 = add i64 %pgocount18, 1
  store i64 %33, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %34 = add i64 %pgocount19, 1
  store i64 %34, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %35 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr18 = getelementptr inbounds nuw %Direction, ptr %35, i32 0, i32 0
  store i64 210684168656, ptr %tag_ptr18, align 8
  %pay_ptr19 = getelementptr inbounds nuw %Direction, ptr %35, i32 0, i32 1
  store ptr null, ptr %pay_ptr19, align 8
  %cast20 = ptrtoint ptr %35 to i64
  %cast21 = inttoptr i64 %cast20 to ptr
  %36 = call ptr @describe_dir(ptr %cast21)
  %37 = call i32 @puts(ptr %36)
  %widen22 = sext i32 %37 to i64
  %pgocount20 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %38 = add i64 %pgocount20, 1
  store i64 %38, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %39 = add i64 %pgocount21, 1
  store i64 %39, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %pgocount22 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %40 = add i64 %pgocount22, 1
  store i64 %40, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %pgocount23 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %41 = add i64 %pgocount23, 1
  store i64 %41, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %42 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr23 = getelementptr inbounds nuw %Direction, ptr %42, i32 0, i32 0
  store i64 210690101528, ptr %tag_ptr23, align 8
  %pay_ptr24 = getelementptr inbounds nuw %Direction, ptr %42, i32 0, i32 1
  store ptr null, ptr %pay_ptr24, align 8
  %cast25 = ptrtoint ptr %42 to i64
  %cast26 = inttoptr i64 %cast25 to ptr
  %43 = call ptr @describe_dir(ptr %cast26)
  %44 = call i32 @puts(ptr %43)
  %widen27 = sext i32 %44 to i64
  %pgocount24 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %45 = add i64 %pgocount24, 1
  store i64 %45, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %pgocount25 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %46 = add i64 %pgocount25, 1
  store i64 %46, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %pgocount26 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %47 = add i64 %pgocount26, 1
  store i64 %47, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %pgocount27 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %48 = add i64 %pgocount27, 1
  store i64 %48, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %49 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr28 = getelementptr inbounds nuw %Direction, ptr %49, i32 0, i32 0
  store i64 6384030098, ptr %tag_ptr28, align 8
  %pay_ptr29 = getelementptr inbounds nuw %Direction, ptr %49, i32 0, i32 1
  store ptr null, ptr %pay_ptr29, align 8
  %cast30 = ptrtoint ptr %49 to i64
  %cast31 = inttoptr i64 %cast30 to ptr
  %50 = call ptr @describe_dir(ptr %cast31)
  %51 = call i32 @puts(ptr %50)
  %widen32 = sext i32 %51 to i64
  %pgocount28 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %52 = add i64 %pgocount28, 1
  store i64 %52, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %pgocount29 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %53 = add i64 %pgocount29, 1
  store i64 %53, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %pgocount30 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %54 = add i64 %pgocount30, 1
  store i64 %54, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %pgocount31 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %55 = add i64 %pgocount31, 1
  store i64 %55, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %56 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr33 = getelementptr inbounds nuw %Direction, ptr %56, i32 0, i32 0
  store i64 6384681320, ptr %tag_ptr33, align 8
  %pay_ptr34 = getelementptr inbounds nuw %Direction, ptr %56, i32 0, i32 1
  store ptr null, ptr %pay_ptr34, align 8
  %cast35 = ptrtoint ptr %56 to i64
  %cast36 = inttoptr i64 %cast35 to ptr
  %57 = call ptr @describe_dir(ptr %cast36)
  %58 = call i32 @puts(ptr %57)
  %widen37 = sext i32 %58 to i64
  %pgocount32 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %59 = add i64 %pgocount32, 1
  store i64 %59, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %pgocount33 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %60 = add i64 %pgocount33, 1
  store i64 %60, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %pgocount34 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %61 = add i64 %pgocount34, 1
  store i64 %61, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %pgocount35 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %62 = add i64 %pgocount35, 1
  store i64 %62, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %63 = call ptr @parity(i64 0)
  %64 = call i32 @puts(ptr %63)
  %widen38 = sext i32 %64 to i64
  %pgocount36 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %65 = add i64 %pgocount36, 1
  store i64 %65, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %pgocount37 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %66 = add i64 %pgocount37, 1
  store i64 %66, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %pgocount38 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %67 = add i64 %pgocount38, 1
  store i64 %67, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %pgocount39 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %68 = add i64 %pgocount39, 1
  store i64 %68, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %69 = call ptr @parity(i64 3)
  %70 = call i32 @puts(ptr %69)
  %widen39 = sext i32 %70 to i64
  %pgocount40 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %71 = add i64 %pgocount40, 1
  store i64 %71, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %pgocount41 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %72 = add i64 %pgocount41, 1
  store i64 %72, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %pgocount42 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %73 = add i64 %pgocount42, 1
  store i64 %73, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %pgocount43 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %74 = add i64 %pgocount43, 1
  store i64 %74, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %75 = call ptr @parity(i64 7)
  %76 = call i32 @puts(ptr %75)
  %widen40 = sext i32 %76 to i64
  %pgocount44 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 52), align 8
  %77 = add i64 %pgocount44, 1
  store i64 %77, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 52), align 8
  %pgocount45 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 53), align 8
  %78 = add i64 %pgocount45, 1
  store i64 %78, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 53), align 8
  %pgocount46 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 54), align 8
  %79 = add i64 %pgocount46, 1
  store i64 %79, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 54), align 8
  %pgocount47 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 55), align 8
  %80 = add i64 %pgocount47, 1
  store i64 %80, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 55), align 8
  %81 = call ptr @parity(i64 42)
  %82 = call i32 @puts(ptr %81)
  %widen41 = sext i32 %82 to i64
  %pgocount48 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 56), align 8
  %83 = add i64 %pgocount48, 1
  store i64 %83, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 56), align 8
  %pgocount49 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 57), align 8
  %84 = add i64 %pgocount49, 1
  store i64 %84, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 57), align 8
  %pgocount50 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 58), align 8
  %85 = add i64 %pgocount50, 1
  store i64 %85, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 58), align 8
  %pgocount51 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 59), align 8
  %86 = add i64 %pgocount51, 1
  store i64 %86, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 59), align 8
  %pgocount52 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 60), align 8
  %87 = add i64 %pgocount52, 1
  store i64 %87, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 60), align 8
  %88 = call i1 @is_vowel_word(ptr @.str.21)
  %widen42 = zext i1 %88 to i64
  %89 = call ptr @forge_rc_alloc(i64 32)
  %90 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %89, i64 32, ptr @.i2s_fmt.22, i64 %widen42)
  %widen43 = sext i32 %90 to i64
  %91 = call i32 @puts(ptr %89)
  %widen44 = sext i32 %91 to i64
  %pgocount53 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 61), align 8
  %92 = add i64 %pgocount53, 1
  store i64 %92, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 61), align 8
  %pgocount54 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 62), align 8
  %93 = add i64 %pgocount54, 1
  store i64 %93, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 62), align 8
  %pgocount55 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 63), align 8
  %94 = add i64 %pgocount55, 1
  store i64 %94, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 63), align 8
  %pgocount56 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 64), align 8
  %95 = add i64 %pgocount56, 1
  store i64 %95, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 64), align 8
  %pgocount57 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 65), align 8
  %96 = add i64 %pgocount57, 1
  store i64 %96, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 65), align 8
  %97 = call i1 @is_vowel_word(ptr @.str.23)
  %widen45 = zext i1 %97 to i64
  %98 = call ptr @forge_rc_alloc(i64 32)
  %99 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %98, i64 32, ptr @.i2s_fmt.24, i64 %widen45)
  %widen46 = sext i32 %99 to i64
  %100 = call i32 @puts(ptr %98)
  %widen47 = sext i32 %100 to i64
  %pgocount58 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 66), align 8
  %101 = add i64 %pgocount58, 1
  store i64 %101, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 66), align 8
  %pgocount59 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 67), align 8
  %102 = add i64 %pgocount59, 1
  store i64 %102, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 67), align 8
  %pgocount60 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 68), align 8
  %103 = add i64 %pgocount60, 1
  store i64 %103, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 68), align 8
  %pgocount61 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 69), align 8
  %104 = add i64 %pgocount61, 1
  store i64 %104, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 69), align 8
  %pgocount62 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 70), align 8
  %105 = add i64 %pgocount62, 1
  store i64 %105, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 70), align 8
  %106 = call i1 @is_vowel_word(ptr @.str.25)
  %widen48 = zext i1 %106 to i64
  %107 = call ptr @forge_rc_alloc(i64 32)
  %108 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %107, i64 32, ptr @.i2s_fmt.26, i64 %widen48)
  %widen49 = sext i32 %108 to i64
  %109 = call i32 @puts(ptr %107)
  %widen50 = sext i32 %109 to i64
  %pgocount63 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 71), align 8
  %110 = add i64 %pgocount63, 1
  store i64 %110, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 71), align 8
  %pgocount64 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 72), align 8
  %111 = add i64 %pgocount64, 1
  store i64 %111, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 72), align 8
  %pgocount65 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 73), align 8
  %112 = add i64 %pgocount65, 1
  store i64 %112, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 73), align 8
  %pgocount66 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 74), align 8
  %113 = add i64 %pgocount66, 1
  store i64 %113, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 74), align 8
  %114 = call ptr @describe_small(i64 1)
  %115 = call i32 @puts(ptr %114)
  %widen51 = sext i32 %115 to i64
  %pgocount67 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 75), align 8
  %116 = add i64 %pgocount67, 1
  store i64 %116, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 75), align 8
  %pgocount68 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 76), align 8
  %117 = add i64 %pgocount68, 1
  store i64 %117, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 76), align 8
  %pgocount69 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 77), align 8
  %118 = add i64 %pgocount69, 1
  store i64 %118, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 77), align 8
  %pgocount70 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 78), align 8
  %119 = add i64 %pgocount70, 1
  store i64 %119, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 78), align 8
  %120 = call ptr @describe_small(i64 2)
  %121 = call i32 @puts(ptr %120)
  %widen52 = sext i32 %121 to i64
  %pgocount71 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 79), align 8
  %122 = add i64 %pgocount71, 1
  store i64 %122, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 79), align 8
  %pgocount72 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 80), align 8
  %123 = add i64 %pgocount72, 1
  store i64 %123, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 80), align 8
  %pgocount73 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 81), align 8
  %124 = add i64 %pgocount73, 1
  store i64 %124, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 81), align 8
  %pgocount74 = load i64, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 82), align 8
  %125 = add i64 %pgocount74, 1
  store i64 %125, ptr getelementptr inbounds ([83 x i64], ptr @__profc_main, i32 0, i32 82), align 8
  %126 = call ptr @describe_small(i64 5)
  %127 = call i32 @puts(ptr %126)
  %widen53 = sext i32 %127 to i64
  %128 = call i32 @forge_test_summary()
  %widen54 = sext i32 %128 to i64
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
