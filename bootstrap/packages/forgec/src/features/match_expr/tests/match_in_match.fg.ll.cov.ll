; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/match_in_match.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

%Outer = type { i64, ptr }
%Inner = type { i64, ptr }

@.match_fn = private unnamed_addr constant [9 x i8] c"classify\00", align 1
@mu_file = private unnamed_addr constant [141 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/match_in_match.fg\00", align 1
@.match_fn.1 = private unnamed_addr constant [9 x i8] c"classify\00", align 1
@mu_file.2 = private unnamed_addr constant [141 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/match_in_match.fg\00", align 1
@.match_fn.3 = private unnamed_addr constant [9 x i8] c"classify\00", align 1
@mu_file.4 = private unnamed_addr constant [141 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/match_expr/tests/match_in_match.fg\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_classify = private global [22 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_classify = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -6761552294068852299, i64 7572247415914819, i64 sub (i64 ptrtoint (ptr @__profc_classify to i64), i64 ptrtoint (ptr @__profd_classify to i64)), i64 0, ptr null, ptr null, i32 22, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_main = private global [52 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 52, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
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

define i64 @classify(ptr %0, ptr %1) {
entry:
  %v40 = alloca i64, align 8
  %match_result26 = alloca i64, align 8
  %v17 = alloca i64, align 8
  %match_result6 = alloca i64, align 8
  %x2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %i = alloca ptr, align 8
  %o = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_classify, align 8
  %2 = add i64 %pgocount, 1
  store i64 %2, ptr @__profc_classify, align 8
  store ptr %0, ptr %o, align 8
  store ptr %1, ptr %i, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 1), align 8
  %3 = add i64 %pgocount1, 1
  store i64 %3, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 2), align 8
  %4 = add i64 %pgocount2, 1
  store i64 %4, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 2), align 8
  %o1 = load ptr, ptr %o, align 8
  %tag_ptr = getelementptr inbounds nuw %Outer, ptr %o1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 177638
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %match_end27, %match_end7
  %match_val43 = load i64, ptr %match_result, align 8
  ret i64 %match_val43

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Outer, ptr %o1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %x_slot_base = ptrtoint ptr %payload to i64
  %x_slot_addr = add i64 %x_slot_base, 0
  %x_slot = inttoptr i64 %x_slot_addr to ptr
  %x = load i64, ptr %x_slot, align 8
  store i64 %x, ptr %x2, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 3), align 8
  %5 = add i64 %pgocount3, 1
  store i64 %5, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 4), align 8
  %6 = add i64 %pgocount4, 1
  store i64 %6, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 4), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 5), align 8
  %7 = add i64 %pgocount5, 1
  store i64 %7, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 5), align 8
  %i3 = load ptr, ptr %i, align 8
  %tag_ptr4 = getelementptr inbounds nuw %Inner, ptr %i3, i32 0, i32 0
  %tag5 = load i64, ptr %tag_ptr4, align 8
  store i64 0, ptr %match_result6, align 8
  %tag_eq10 = icmp eq i64 %tag5, 177661
  br i1 %tag_eq10, label %march_arm8, label %march_next9

march_next:                                       ; preds = %entry
  %tag_eq22 = icmp eq i64 %tag, 177639
  br i1 %tag_eq22, label %march_arm20, label %march_next21

match_end7:                                       ; preds = %march_arm12, %march_arm8
  %match_val = load i64, ptr %match_result6, align 8
  store i64 %match_val, ptr %match_result, align 8
  br label %match_end

march_arm8:                                       ; preds = %march_arm
  %pgocount6 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 6), align 8
  %8 = add i64 %pgocount6, 1
  store i64 %8, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 6), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 7), align 8
  %9 = add i64 %pgocount7, 1
  store i64 %9, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 7), align 8
  %x11 = load i64, ptr %x2, align 8
  store i64 %x11, ptr %match_result6, align 8
  br label %match_end7

march_next9:                                      ; preds = %march_arm
  %tag_eq14 = icmp eq i64 %tag5, 177662
  br i1 %tag_eq14, label %march_arm12, label %march_next13

march_arm12:                                      ; preds = %march_next9
  %pay_slot15 = getelementptr inbounds nuw %Inner, ptr %i3, i32 0, i32 1
  %payload16 = load ptr, ptr %pay_slot15, align 8
  %v_slot_base = ptrtoint ptr %payload16 to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load i64, ptr %v_slot, align 8
  store i64 %v, ptr %v17, align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 8), align 8
  %10 = add i64 %pgocount8, 1
  store i64 %10, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 8), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 9), align 8
  %11 = add i64 %pgocount9, 1
  store i64 %11, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 9), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 10), align 8
  %12 = add i64 %pgocount10, 1
  store i64 %12, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 10), align 8
  %x18 = load i64, ptr %x2, align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 11), align 8
  %13 = add i64 %pgocount11, 1
  store i64 %13, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 11), align 8
  %v19 = load i64, ptr %v17, align 8
  %add = add i64 %x18, %v19
  store i64 %add, ptr %match_result6, align 8
  br label %match_end7

march_next13:                                     ; preds = %march_next9
  call void @forge_match_unreachable(ptr @.match_fn, i64 %tag5, ptr @mu_file, i64 9)
  unreachable

march_arm20:                                      ; preds = %march_next
  %pgocount12 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 12), align 8
  %14 = add i64 %pgocount12, 1
  store i64 %14, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 12), align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 13), align 8
  %15 = add i64 %pgocount13, 1
  store i64 %15, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 13), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 14), align 8
  %16 = add i64 %pgocount14, 1
  store i64 %16, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 14), align 8
  %i23 = load ptr, ptr %i, align 8
  %tag_ptr24 = getelementptr inbounds nuw %Inner, ptr %i23, i32 0, i32 0
  %tag25 = load i64, ptr %tag_ptr24, align 8
  store i64 0, ptr %match_result26, align 8
  %tag_eq30 = icmp eq i64 %tag25, 177661
  br i1 %tag_eq30, label %march_arm28, label %march_next29

march_next21:                                     ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn.3, i64 %tag, ptr @mu_file.4, i64 6)
  unreachable

match_end27:                                      ; preds = %march_arm31, %march_arm28
  %match_val42 = load i64, ptr %match_result26, align 8
  store i64 %match_val42, ptr %match_result, align 8
  br label %match_end

march_arm28:                                      ; preds = %march_arm20
  %pgocount15 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 15), align 8
  %17 = add i64 %pgocount15, 1
  store i64 %17, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 15), align 8
  %pgocount16 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 16), align 8
  %18 = add i64 %pgocount16, 1
  store i64 %18, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 16), align 8
  %pgocount17 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 17), align 8
  %19 = add i64 %pgocount17, 1
  store i64 %19, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 17), align 8
  store i64 -1, ptr %match_result26, align 8
  br label %match_end27

march_next29:                                     ; preds = %march_arm20
  %tag_eq33 = icmp eq i64 %tag25, 177662
  br i1 %tag_eq33, label %march_arm31, label %march_next32

march_arm31:                                      ; preds = %march_next29
  %pay_slot34 = getelementptr inbounds nuw %Inner, ptr %i23, i32 0, i32 1
  %payload35 = load ptr, ptr %pay_slot34, align 8
  %v_slot_base36 = ptrtoint ptr %payload35 to i64
  %v_slot_addr37 = add i64 %v_slot_base36, 0
  %v_slot38 = inttoptr i64 %v_slot_addr37 to ptr
  %v39 = load i64, ptr %v_slot38, align 8
  store i64 %v39, ptr %v40, align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 18), align 8
  %20 = add i64 %pgocount18, 1
  store i64 %20, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 18), align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 19), align 8
  %21 = add i64 %pgocount19, 1
  store i64 %21, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 19), align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 20), align 8
  %22 = add i64 %pgocount20, 1
  store i64 %22, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 20), align 8
  %v41 = load i64, ptr %v40, align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 21), align 8
  %23 = add i64 %pgocount21, 1
  store i64 %23, ptr getelementptr inbounds ([22 x i64], ptr @__profc_classify, i32 0, i32 21), align 8
  %mul = mul i64 %v41, 10
  store i64 %mul, ptr %match_result26, align 8
  br label %match_end27

march_next32:                                     ; preds = %march_next29
  call void @forge_match_unreachable(ptr @.match_fn.1, i64 %tag25, ptr @mu_file.2, i64 16)
  unreachable
}

define i64 @main() {
entry:
  %pgocount = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %3 = add i64 %pgocount3, 1
  store i64 %3, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %4 = add i64 %pgocount4, 1
  store i64 %4, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %5 = add i64 %pgocount5, 1
  store i64 %5, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %6 = add i64 %pgocount6, 1
  store i64 %6, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %7 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Outer, ptr %7, i32 0, i32 0
  store i64 177638, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Outer, ptr %7, i32 0, i32 1
  %8 = call ptr @forge_rc_alloc(i64 8)
  store ptr %8, ptr %pay_ptr, align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %9 = add i64 %pgocount7, 1
  store i64 %9, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %slot_base = ptrtoint ptr %8 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 5, ptr %slot, align 8
  %cast = ptrtoint ptr %7 to i64
  %pgocount8 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %10 = add i64 %pgocount8, 1
  store i64 %10, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %11 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr1 = getelementptr inbounds nuw %Inner, ptr %11, i32 0, i32 0
  store i64 177661, ptr %tag_ptr1, align 8
  %pay_ptr2 = getelementptr inbounds nuw %Inner, ptr %11, i32 0, i32 1
  store ptr null, ptr %pay_ptr2, align 8
  %cast3 = ptrtoint ptr %11 to i64
  %cast4 = inttoptr i64 %cast to ptr
  %cast5 = inttoptr i64 %cast3 to ptr
  %12 = call i64 @classify(ptr %cast4, ptr %cast5)
  %13 = call ptr @forge_rc_alloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @.i2s_fmt, i64 %12)
  %widen = sext i32 %14 to i64
  %15 = call i32 @puts(ptr %13)
  %widen6 = sext i32 %15 to i64
  %pgocount9 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %16 = add i64 %pgocount9, 1
  store i64 %16, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %17 = add i64 %pgocount10, 1
  store i64 %17, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %18 = add i64 %pgocount11, 1
  store i64 %18, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %19 = add i64 %pgocount12, 1
  store i64 %19, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 34), align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %20 = add i64 %pgocount13, 1
  store i64 %20, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 35), align 8
  %21 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr7 = getelementptr inbounds nuw %Outer, ptr %21, i32 0, i32 0
  store i64 177638, ptr %tag_ptr7, align 8
  %pay_ptr8 = getelementptr inbounds nuw %Outer, ptr %21, i32 0, i32 1
  %22 = call ptr @forge_rc_alloc(i64 8)
  store ptr %22, ptr %pay_ptr8, align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %23 = add i64 %pgocount14, 1
  store i64 %23, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 36), align 8
  %slot_base9 = ptrtoint ptr %22 to i64
  %slot_addr10 = add i64 %slot_base9, 0
  %slot11 = inttoptr i64 %slot_addr10 to ptr
  store i64 5, ptr %slot11, align 8
  %cast12 = ptrtoint ptr %21 to i64
  %pgocount15 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %24 = add i64 %pgocount15, 1
  store i64 %24, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 37), align 8
  %25 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr13 = getelementptr inbounds nuw %Inner, ptr %25, i32 0, i32 0
  store i64 177662, ptr %tag_ptr13, align 8
  %pay_ptr14 = getelementptr inbounds nuw %Inner, ptr %25, i32 0, i32 1
  %26 = call ptr @forge_rc_alloc(i64 8)
  store ptr %26, ptr %pay_ptr14, align 8
  %pgocount16 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %27 = add i64 %pgocount16, 1
  store i64 %27, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 38), align 8
  %slot_base15 = ptrtoint ptr %26 to i64
  %slot_addr16 = add i64 %slot_base15, 0
  %slot17 = inttoptr i64 %slot_addr16 to ptr
  store i64 3, ptr %slot17, align 8
  %cast18 = ptrtoint ptr %25 to i64
  %cast19 = inttoptr i64 %cast12 to ptr
  %cast20 = inttoptr i64 %cast18 to ptr
  %28 = call i64 @classify(ptr %cast19, ptr %cast20)
  %29 = call ptr @forge_rc_alloc(i64 32)
  %30 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %29, i64 32, ptr @.i2s_fmt.5, i64 %28)
  %widen21 = sext i32 %30 to i64
  %31 = call i32 @puts(ptr %29)
  %widen22 = sext i32 %31 to i64
  %pgocount17 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %32 = add i64 %pgocount17, 1
  store i64 %32, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 39), align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %33 = add i64 %pgocount18, 1
  store i64 %33, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 40), align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %34 = add i64 %pgocount19, 1
  store i64 %34, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 41), align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %35 = add i64 %pgocount20, 1
  store i64 %35, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 42), align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %36 = add i64 %pgocount21, 1
  store i64 %36, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 43), align 8
  %37 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr23 = getelementptr inbounds nuw %Outer, ptr %37, i32 0, i32 0
  store i64 177639, ptr %tag_ptr23, align 8
  %pay_ptr24 = getelementptr inbounds nuw %Outer, ptr %37, i32 0, i32 1
  store ptr null, ptr %pay_ptr24, align 8
  %cast25 = ptrtoint ptr %37 to i64
  %pgocount22 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %38 = add i64 %pgocount22, 1
  store i64 %38, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 44), align 8
  %39 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr26 = getelementptr inbounds nuw %Inner, ptr %39, i32 0, i32 0
  store i64 177661, ptr %tag_ptr26, align 8
  %pay_ptr27 = getelementptr inbounds nuw %Inner, ptr %39, i32 0, i32 1
  store ptr null, ptr %pay_ptr27, align 8
  %cast28 = ptrtoint ptr %39 to i64
  %cast29 = inttoptr i64 %cast25 to ptr
  %cast30 = inttoptr i64 %cast28 to ptr
  %40 = call i64 @classify(ptr %cast29, ptr %cast30)
  %41 = call ptr @forge_rc_alloc(i64 32)
  %42 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %41, i64 32, ptr @.i2s_fmt.6, i64 %40)
  %widen31 = sext i32 %42 to i64
  %43 = call i32 @puts(ptr %41)
  %widen32 = sext i32 %43 to i64
  %pgocount23 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %44 = add i64 %pgocount23, 1
  store i64 %44, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 45), align 8
  %pgocount24 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %45 = add i64 %pgocount24, 1
  store i64 %45, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 46), align 8
  %pgocount25 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %46 = add i64 %pgocount25, 1
  store i64 %46, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 47), align 8
  %pgocount26 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %47 = add i64 %pgocount26, 1
  store i64 %47, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 48), align 8
  %pgocount27 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %48 = add i64 %pgocount27, 1
  store i64 %48, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 49), align 8
  %49 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr33 = getelementptr inbounds nuw %Outer, ptr %49, i32 0, i32 0
  store i64 177639, ptr %tag_ptr33, align 8
  %pay_ptr34 = getelementptr inbounds nuw %Outer, ptr %49, i32 0, i32 1
  store ptr null, ptr %pay_ptr34, align 8
  %cast35 = ptrtoint ptr %49 to i64
  %pgocount28 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %50 = add i64 %pgocount28, 1
  store i64 %50, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 50), align 8
  %51 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr36 = getelementptr inbounds nuw %Inner, ptr %51, i32 0, i32 0
  store i64 177662, ptr %tag_ptr36, align 8
  %pay_ptr37 = getelementptr inbounds nuw %Inner, ptr %51, i32 0, i32 1
  %52 = call ptr @forge_rc_alloc(i64 8)
  store ptr %52, ptr %pay_ptr37, align 8
  %pgocount29 = load i64, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %53 = add i64 %pgocount29, 1
  store i64 %53, ptr getelementptr inbounds ([52 x i64], ptr @__profc_main, i32 0, i32 51), align 8
  %slot_base38 = ptrtoint ptr %52 to i64
  %slot_addr39 = add i64 %slot_base38, 0
  %slot40 = inttoptr i64 %slot_addr39 to ptr
  store i64 7, ptr %slot40, align 8
  %cast41 = ptrtoint ptr %51 to i64
  %cast42 = inttoptr i64 %cast35 to ptr
  %cast43 = inttoptr i64 %cast41 to ptr
  %54 = call i64 @classify(ptr %cast42, ptr %cast43)
  %55 = call ptr @forge_rc_alloc(i64 32)
  %56 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %55, i64 32, ptr @.i2s_fmt.7, i64 %54)
  %widen44 = sext i32 %56 to i64
  %57 = call i32 @puts(ptr %55)
  %widen45 = sext i32 %57 to i64
  %58 = call i32 @forge_test_summary()
  %widen46 = sext i32 %58 to i64
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
