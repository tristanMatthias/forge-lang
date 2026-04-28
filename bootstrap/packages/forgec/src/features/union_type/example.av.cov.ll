; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/union_type/example.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

%__union = type { i64, ptr }

@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"show\00", align 1
@mu_file = private unnamed_addr constant [128 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/union_type/example.fg\00", align 1
@.str = private unnamed_addr constant [12 x i8] c"int value: \00", align 1
@.i2s_fmt.1 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.2 = private unnamed_addr constant [15 x i8] c"string value: \00", align 1
@.match_fn.3 = private unnamed_addr constant [9 x i8] c"describe\00", align 1
@mu_file.4 = private unnamed_addr constant [128 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/union_type/example.fg\00", align 1
@.str.5 = private unnamed_addr constant [10 x i8] c"got int: \00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.7 = private unnamed_addr constant [17 x i8] c"matched wildcard\00", align 1
@.str.8 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.9 = private unnamed_addr constant [6 x i8] c"world\00", align 1
@.str.10 = private unnamed_addr constant [9 x i8] c"anything\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_show = private global [6 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_show = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 2701510904323956135, i64 6385690694, i64 sub (i64 ptrtoint (ptr @__profc_show to i64), i64 ptrtoint (ptr @__profd_show to i64)), i64 0, ptr null, ptr null, i32 6, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_describe = private global [10 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_describe = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -8671669404246534643, i64 7572281679508262, i64 sub (i64 ptrtoint (ptr @__profc_describe to i64), i64 ptrtoint (ptr @__profd_describe to i64)), i64 0, ptr null, ptr null, i32 10, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_with_wildcard = private global [8 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_with_wildcard = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 7685103096728120105, i64 -7723791304585863574, i64 sub (i64 ptrtoint (ptr @__profc_with_wildcard to i64), i64 ptrtoint (ptr @__profd_with_wildcard to i64)), i64 0, ptr null, ptr null, i32 8, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_main = private global [21 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 21, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__llvm_prf_nm = private constant [42 x i8] c" (x\DA+\CE\C8/gLI-N.\CALJe,\CF,\C9\88/\CF\CCIIN,Ja\CCM\CC\CC\03\00\C7\C0\0C\10", section "__DATA,__llvm_prf_names", align 1
@llvm.compiler.used = appending global [5 x ptr] [ptr @__llvm_profile_runtime_user, ptr @__profd_show, ptr @__profd_describe, ptr @__profd_with_wildcard, ptr @__profd_main], section "llvm.metadata"
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

define ptr @show(ptr %0) {
entry:
  %s = alloca ptr, align 8
  %n = alloca i64, align 8
  %union_match_result = alloca i64, align 8
  %val = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_show, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_show, align 8
  store ptr %0, ptr %val, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_show, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([6 x i64], ptr @__profc_show, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_show, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([6 x i64], ptr @__profc_show, i32 0, i32 2), align 8
  %val1 = load ptr, ptr %val, align 8
  %union_tag_ptr = getelementptr inbounds nuw %__union, ptr %val1, i32 0, i32 0
  %union_tag = load i64, ptr %union_tag_ptr, align 8
  store i64 0, ptr %union_match_result, align 8
  %union_tag_eq = icmp eq i64 %union_tag, 193495088
  br i1 %union_tag_eq, label %union_arm, label %union_next

union_match_end:                                  ; preds = %union_arm3, %union_arm
  %union_match_val = load i64, ptr %union_match_result, align 8
  %cast14 = inttoptr i64 %union_match_val to ptr
  ret ptr %cast14

union_arm:                                        ; preds = %entry
  %union_pay_ptr = getelementptr inbounds nuw %__union, ptr %val1, i32 0, i32 1
  %union_payload = load ptr, ptr %union_pay_ptr, align 8
  %union_val_slot_base = ptrtoint ptr %union_payload to i64
  %union_val_slot_addr = add i64 %union_val_slot_base, 0
  %union_val_slot = inttoptr i64 %union_val_slot_addr to ptr
  %union_val = load i64, ptr %union_val_slot, align 8
  store i64 %union_val, ptr %n, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_show, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([6 x i64], ptr @__profc_show, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_show, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([6 x i64], ptr @__profc_show, i32 0, i32 4), align 8
  %n2 = load i64, ptr %n, align 8
  %6 = call ptr @forge_rc_alloc(i64 32)
  %7 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %6, i64 32, ptr @.i2s_fmt, i64 %n2)
  %widen = sext i32 %7 to i64
  %cast = ptrtoint ptr %6 to i64
  store i64 %cast, ptr %union_match_result, align 8
  br label %union_match_end

union_next:                                       ; preds = %entry
  %union_tag_eq5 = icmp eq i64 %union_tag, 6954031493116
  br i1 %union_tag_eq5, label %union_arm3, label %union_next4

union_arm3:                                       ; preds = %union_next
  %union_pay_ptr6 = getelementptr inbounds nuw %__union, ptr %val1, i32 0, i32 1
  %union_payload7 = load ptr, ptr %union_pay_ptr6, align 8
  %union_val_slot_base8 = ptrtoint ptr %union_payload7 to i64
  %union_val_slot_addr9 = add i64 %union_val_slot_base8, 0
  %union_val_slot10 = inttoptr i64 %union_val_slot_addr9 to ptr
  %union_val11 = load ptr, ptr %union_val_slot10, align 8
  store ptr %union_val11, ptr %s, align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([6 x i64], ptr @__profc_show, i32 0, i32 5), align 8
  %8 = add i64 %pgocount5, 1
  store i64 %8, ptr getelementptr inbounds ([6 x i64], ptr @__profc_show, i32 0, i32 5), align 8
  %s12 = load ptr, ptr %s, align 8
  %cast13 = ptrtoint ptr %s12 to i64
  store i64 %cast13, ptr %union_match_result, align 8
  br label %union_match_end

union_next4:                                      ; preds = %union_next
  call void @forge_match_unreachable(ptr @.match_fn, i64 %union_tag, ptr @mu_file, i64 8)
  unreachable
}

define ptr @describe(ptr %0) {
entry:
  %s = alloca ptr, align 8
  %n = alloca i64, align 8
  %union_match_result = alloca i64, align 8
  %val = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_describe, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_describe, align 8
  store ptr %0, ptr %val, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_describe, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([10 x i64], ptr @__profc_describe, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_describe, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([10 x i64], ptr @__profc_describe, i32 0, i32 2), align 8
  %val1 = load ptr, ptr %val, align 8
  %union_tag_ptr = getelementptr inbounds nuw %__union, ptr %val1, i32 0, i32 0
  %union_tag = load i64, ptr %union_tag_ptr, align 8
  store i64 0, ptr %union_match_result, align 8
  %union_tag_eq = icmp eq i64 %union_tag, 193495088
  br i1 %union_tag_eq, label %union_arm, label %union_next

union_match_end:                                  ; preds = %union_arm5, %union_arm
  %union_match_val = load i64, ptr %union_match_result, align 8
  %cast22 = inttoptr i64 %union_match_val to ptr
  ret ptr %cast22

union_arm:                                        ; preds = %entry
  %union_pay_ptr = getelementptr inbounds nuw %__union, ptr %val1, i32 0, i32 1
  %union_payload = load ptr, ptr %union_pay_ptr, align 8
  %union_val_slot_base = ptrtoint ptr %union_payload to i64
  %union_val_slot_addr = add i64 %union_val_slot_base, 0
  %union_val_slot = inttoptr i64 %union_val_slot_addr to ptr
  %union_val = load i64, ptr %union_val_slot, align 8
  store i64 %union_val, ptr %n, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_describe, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([10 x i64], ptr @__profc_describe, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_describe, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([10 x i64], ptr @__profc_describe, i32 0, i32 4), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_describe, i32 0, i32 5), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([10 x i64], ptr @__profc_describe, i32 0, i32 5), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_describe, i32 0, i32 6), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([10 x i64], ptr @__profc_describe, i32 0, i32 6), align 8
  %n2 = load i64, ptr %n, align 8
  %8 = call ptr @forge_rc_alloc(i64 32)
  %9 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %8, i64 32, ptr @.i2s_fmt.1, i64 %n2)
  %widen = sext i32 %9 to i64
  %10 = call i64 @strlen(ptr @.str)
  %11 = call i64 @strlen(ptr %8)
  %concat_total = add i64 %10, %11
  %concat_size = add i64 %concat_total, 1
  %12 = call ptr @forge_rc_alloc(i64 %concat_size)
  %13 = call ptr @memcpy(ptr %12, ptr @.str, i64 %10)
  %cast = ptrtoint ptr %12 to i64
  %dst2_int = add i64 %cast, %10
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %11, 1
  %14 = call ptr @memcpy(ptr %cast3, ptr %8, i64 %rhs_len_p1)
  %cast4 = ptrtoint ptr %12 to i64
  store i64 %cast4, ptr %union_match_result, align 8
  br label %union_match_end

union_next:                                       ; preds = %entry
  %union_tag_eq7 = icmp eq i64 %union_tag, 6954031493116
  br i1 %union_tag_eq7, label %union_arm5, label %union_next6

union_arm5:                                       ; preds = %union_next
  %union_pay_ptr8 = getelementptr inbounds nuw %__union, ptr %val1, i32 0, i32 1
  %union_payload9 = load ptr, ptr %union_pay_ptr8, align 8
  %union_val_slot_base10 = ptrtoint ptr %union_payload9 to i64
  %union_val_slot_addr11 = add i64 %union_val_slot_base10, 0
  %union_val_slot12 = inttoptr i64 %union_val_slot_addr11 to ptr
  %union_val13 = load ptr, ptr %union_val_slot12, align 8
  store ptr %union_val13, ptr %s, align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_describe, i32 0, i32 7), align 8
  %15 = add i64 %pgocount7, 1
  store i64 %15, ptr getelementptr inbounds ([10 x i64], ptr @__profc_describe, i32 0, i32 7), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_describe, i32 0, i32 8), align 8
  %16 = add i64 %pgocount8, 1
  store i64 %16, ptr getelementptr inbounds ([10 x i64], ptr @__profc_describe, i32 0, i32 8), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc_describe, i32 0, i32 9), align 8
  %17 = add i64 %pgocount9, 1
  store i64 %17, ptr getelementptr inbounds ([10 x i64], ptr @__profc_describe, i32 0, i32 9), align 8
  %s14 = load ptr, ptr %s, align 8
  %18 = call i64 @strlen(ptr @.str.2)
  %19 = call i64 @strlen(ptr %s14)
  %concat_total15 = add i64 %18, %19
  %concat_size16 = add i64 %concat_total15, 1
  %20 = call ptr @forge_rc_alloc(i64 %concat_size16)
  %21 = call ptr @memcpy(ptr %20, ptr @.str.2, i64 %18)
  %cast17 = ptrtoint ptr %20 to i64
  %dst2_int18 = add i64 %cast17, %18
  %cast19 = inttoptr i64 %dst2_int18 to ptr
  %rhs_len_p120 = add i64 %19, 1
  %22 = call ptr @memcpy(ptr %cast19, ptr %s14, i64 %rhs_len_p120)
  %cast21 = ptrtoint ptr %20 to i64
  store i64 %cast21, ptr %union_match_result, align 8
  br label %union_match_end

union_next6:                                      ; preds = %union_next
  call void @forge_match_unreachable(ptr @.match_fn.3, i64 %union_tag, ptr @mu_file.4, i64 15)
  unreachable
}

define ptr @with_wildcard(ptr %0) {
entry:
  %n = alloca i64, align 8
  %union_match_result = alloca i64, align 8
  %val = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_with_wildcard, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_with_wildcard, align 8
  store ptr %0, ptr %val, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_with_wildcard, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([8 x i64], ptr @__profc_with_wildcard, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_with_wildcard, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([8 x i64], ptr @__profc_with_wildcard, i32 0, i32 2), align 8
  %val1 = load ptr, ptr %val, align 8
  %union_tag_ptr = getelementptr inbounds nuw %__union, ptr %val1, i32 0, i32 0
  %union_tag = load i64, ptr %union_tag_ptr, align 8
  store i64 0, ptr %union_match_result, align 8
  %union_tag_eq = icmp eq i64 %union_tag, 193495088
  br i1 %union_tag_eq, label %union_arm, label %union_next

union_match_end:                                  ; preds = %union_next, %union_arm
  %union_match_val = load i64, ptr %union_match_result, align 8
  %cast5 = inttoptr i64 %union_match_val to ptr
  ret ptr %cast5

union_arm:                                        ; preds = %entry
  %union_pay_ptr = getelementptr inbounds nuw %__union, ptr %val1, i32 0, i32 1
  %union_payload = load ptr, ptr %union_pay_ptr, align 8
  %union_val_slot_base = ptrtoint ptr %union_payload to i64
  %union_val_slot_addr = add i64 %union_val_slot_base, 0
  %union_val_slot = inttoptr i64 %union_val_slot_addr to ptr
  %union_val = load i64, ptr %union_val_slot, align 8
  store i64 %union_val, ptr %n, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_with_wildcard, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([8 x i64], ptr @__profc_with_wildcard, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_with_wildcard, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([8 x i64], ptr @__profc_with_wildcard, i32 0, i32 4), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_with_wildcard, i32 0, i32 5), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([8 x i64], ptr @__profc_with_wildcard, i32 0, i32 5), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_with_wildcard, i32 0, i32 6), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([8 x i64], ptr @__profc_with_wildcard, i32 0, i32 6), align 8
  %n2 = load i64, ptr %n, align 8
  %8 = call ptr @forge_rc_alloc(i64 32)
  %9 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %8, i64 32, ptr @.i2s_fmt.6, i64 %n2)
  %widen = sext i32 %9 to i64
  %10 = call i64 @strlen(ptr @.str.5)
  %11 = call i64 @strlen(ptr %8)
  %concat_total = add i64 %10, %11
  %concat_size = add i64 %concat_total, 1
  %12 = call ptr @forge_rc_alloc(i64 %concat_size)
  %13 = call ptr @memcpy(ptr %12, ptr @.str.5, i64 %10)
  %cast = ptrtoint ptr %12 to i64
  %dst2_int = add i64 %cast, %10
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %11, 1
  %14 = call ptr @memcpy(ptr %cast3, ptr %8, i64 %rhs_len_p1)
  %cast4 = ptrtoint ptr %12 to i64
  store i64 %cast4, ptr %union_match_result, align 8
  br label %union_match_end

union_next:                                       ; preds = %entry
  %pgocount7 = load i64, ptr getelementptr inbounds ([8 x i64], ptr @__profc_with_wildcard, i32 0, i32 7), align 8
  %15 = add i64 %pgocount7, 1
  store i64 %15, ptr getelementptr inbounds ([8 x i64], ptr @__profc_with_wildcard, i32 0, i32 7), align 8
  store i64 ptrtoint (ptr @.str.7 to i64), ptr %union_match_result, align 8
  br label %union_match_end
}

define i64 @main() {
entry:
  %pgocount = load i64, ptr @__profc_main, align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr @__profc_main, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %3 = add i64 %pgocount3, 1
  store i64 %3, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %4 = add i64 %pgocount4, 1
  store i64 %4, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %5 = call ptr @forge_rc_alloc(i64 16)
  %union_tag_ptr = getelementptr inbounds nuw %__union, ptr %5, i32 0, i32 0
  store i64 6954031493116, ptr %union_tag_ptr, align 8
  %6 = call ptr @forge_rc_alloc(i64 8)
  %slot_base = ptrtoint ptr %6 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr @.str.8, ptr %slot, align 8
  %union_pay_ptr = getelementptr inbounds nuw %__union, ptr %5, i32 0, i32 1
  store ptr %6, ptr %union_pay_ptr, align 8
  %cast = ptrtoint ptr %5 to i64
  %cast1 = inttoptr i64 %cast to ptr
  %7 = call ptr @show(ptr %cast1)
  %8 = call i32 @puts(ptr %7)
  %widen = sext i32 %8 to i64
  %pgocount5 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %9 = add i64 %pgocount5, 1
  store i64 %9, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %10 = add i64 %pgocount6, 1
  store i64 %10, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %11 = add i64 %pgocount7, 1
  store i64 %11, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %12 = add i64 %pgocount8, 1
  store i64 %12, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %13 = call ptr @forge_rc_alloc(i64 16)
  %union_tag_ptr2 = getelementptr inbounds nuw %__union, ptr %13, i32 0, i32 0
  store i64 193495088, ptr %union_tag_ptr2, align 8
  %14 = call ptr @forge_rc_alloc(i64 8)
  %slot_base3 = ptrtoint ptr %14 to i64
  %slot_addr4 = add i64 %slot_base3, 0
  %slot5 = inttoptr i64 %slot_addr4 to ptr
  store i64 42, ptr %slot5, align 8
  %union_pay_ptr6 = getelementptr inbounds nuw %__union, ptr %13, i32 0, i32 1
  store ptr %14, ptr %union_pay_ptr6, align 8
  %cast7 = ptrtoint ptr %13 to i64
  %cast8 = inttoptr i64 %cast7 to ptr
  %15 = call ptr @show(ptr %cast8)
  %16 = call i32 @puts(ptr %15)
  %widen9 = sext i32 %16 to i64
  %pgocount9 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %17 = add i64 %pgocount9, 1
  store i64 %17, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %18 = add i64 %pgocount10, 1
  store i64 %18, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %19 = add i64 %pgocount11, 1
  store i64 %19, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %20 = add i64 %pgocount12, 1
  store i64 %20, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %21 = call ptr @forge_rc_alloc(i64 16)
  %union_tag_ptr10 = getelementptr inbounds nuw %__union, ptr %21, i32 0, i32 0
  store i64 193495088, ptr %union_tag_ptr10, align 8
  %22 = call ptr @forge_rc_alloc(i64 8)
  %slot_base11 = ptrtoint ptr %22 to i64
  %slot_addr12 = add i64 %slot_base11, 0
  %slot13 = inttoptr i64 %slot_addr12 to ptr
  store i64 10, ptr %slot13, align 8
  %union_pay_ptr14 = getelementptr inbounds nuw %__union, ptr %21, i32 0, i32 1
  store ptr %22, ptr %union_pay_ptr14, align 8
  %cast15 = ptrtoint ptr %21 to i64
  %cast16 = inttoptr i64 %cast15 to ptr
  %23 = call ptr @describe(ptr %cast16)
  %24 = call i32 @puts(ptr %23)
  %widen17 = sext i32 %24 to i64
  %pgocount13 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %25 = add i64 %pgocount13, 1
  store i64 %25, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %26 = add i64 %pgocount14, 1
  store i64 %26, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %27 = add i64 %pgocount15, 1
  store i64 %27, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %pgocount16 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %28 = add i64 %pgocount16, 1
  store i64 %28, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %29 = call ptr @forge_rc_alloc(i64 16)
  %union_tag_ptr18 = getelementptr inbounds nuw %__union, ptr %29, i32 0, i32 0
  store i64 6954031493116, ptr %union_tag_ptr18, align 8
  %30 = call ptr @forge_rc_alloc(i64 8)
  %slot_base19 = ptrtoint ptr %30 to i64
  %slot_addr20 = add i64 %slot_base19, 0
  %slot21 = inttoptr i64 %slot_addr20 to ptr
  store ptr @.str.9, ptr %slot21, align 8
  %union_pay_ptr22 = getelementptr inbounds nuw %__union, ptr %29, i32 0, i32 1
  store ptr %30, ptr %union_pay_ptr22, align 8
  %cast23 = ptrtoint ptr %29 to i64
  %cast24 = inttoptr i64 %cast23 to ptr
  %31 = call ptr @describe(ptr %cast24)
  %32 = call i32 @puts(ptr %31)
  %widen25 = sext i32 %32 to i64
  %pgocount17 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %33 = add i64 %pgocount17, 1
  store i64 %33, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %34 = add i64 %pgocount18, 1
  store i64 %34, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %35 = add i64 %pgocount19, 1
  store i64 %35, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %36 = add i64 %pgocount20, 1
  store i64 %36, ptr getelementptr inbounds ([21 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %37 = call ptr @forge_rc_alloc(i64 16)
  %union_tag_ptr26 = getelementptr inbounds nuw %__union, ptr %37, i32 0, i32 0
  store i64 6954031493116, ptr %union_tag_ptr26, align 8
  %38 = call ptr @forge_rc_alloc(i64 8)
  %slot_base27 = ptrtoint ptr %38 to i64
  %slot_addr28 = add i64 %slot_base27, 0
  %slot29 = inttoptr i64 %slot_addr28 to ptr
  store ptr @.str.10, ptr %slot29, align 8
  %union_pay_ptr30 = getelementptr inbounds nuw %__union, ptr %37, i32 0, i32 1
  store ptr %38, ptr %union_pay_ptr30, align 8
  %cast31 = ptrtoint ptr %37 to i64
  %cast32 = inttoptr i64 %cast31 to ptr
  %39 = call ptr @with_wildcard(ptr %cast32)
  %40 = call i32 @puts(ptr %39)
  %widen33 = sext i32 %40 to i64
  ret i64 0
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
