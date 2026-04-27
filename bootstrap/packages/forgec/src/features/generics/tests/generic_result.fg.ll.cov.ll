; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/generics/tests/generic_result.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

%Result__int__string = type { i64, ptr }
%Result__int__string__Err = type { ptr }

@.str = private unnamed_addr constant [17 x i8] c"division by zero\00", align 1
@dz_file = private unnamed_addr constant [139 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/generics/tests/generic_result.fg\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.1 = private unnamed_addr constant [8 x i8] c"error: \00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [139 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/generics/tests/generic_result.fg\00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.3 = private unnamed_addr constant [13 x i8] c"propagated: \00", align 1
@.match_fn.4 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file.5 = private unnamed_addr constant [139 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/generics/tests/generic_result.fg\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_divide = private global [17 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_divide = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -8275535420795798123, i64 6953431560506, i64 sub (i64 ptrtoint (ptr @__profc_divide to i64), i64 ptrtoint (ptr @__profd_divide to i64)), i64 0, ptr null, ptr null, i32 17, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_main = private global [29 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 29, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___bs_top_level = private global [30 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___bs_top_level = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -3222087168638311179, i64 -7005428211549351871, i64 sub (i64 ptrtoint (ptr @__profc___bs_top_level to i64), i64 ptrtoint (ptr @__profd___bs_top_level to i64)), i64 0, ptr null, ptr null, i32 30, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__llvm_prf_nm = private constant [36 x i8] c"\1A\22x\DAK\C9,\CBLIe\CCM\CC\CCc\8C\8FO*\8E/\C9/\88\CFI-K\CD\01\00\81*\09\D9", section "__DATA,__llvm_prf_names", align 1
@llvm.compiler.used = appending global [4 x ptr] [ptr @__llvm_profile_runtime_user, ptr @__profd_divide, ptr @__profd_main, ptr @__profd___bs_top_level], section "llvm.metadata"
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

define ptr @divide(i64 %0, i64 %1) {
entry:
  %b = alloca i64, align 8
  %a = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_divide, align 8
  %2 = add i64 %pgocount, 1
  store i64 %2, ptr @__profc_divide, align 8
  store i64 %0, ptr %a, align 8
  store i64 %1, ptr %b, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 1), align 8
  %3 = add i64 %pgocount1, 1
  store i64 %3, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 2), align 8
  %4 = add i64 %pgocount2, 1
  store i64 %4, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 3), align 8
  %5 = add i64 %pgocount3, 1
  store i64 %5, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 4), align 8
  %6 = add i64 %pgocount4, 1
  store i64 %6, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 4), align 8
  %b1 = load i64, ptr %b, align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 5), align 8
  %7 = add i64 %pgocount5, 1
  store i64 %7, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 5), align 8
  %eq = icmp eq i64 %b1, 0
  %eq_ext = zext i1 %eq to i64
  %if_cond = icmp ne i64 %eq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %pgocount6 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 12), align 8
  %8 = add i64 %pgocount6, 1
  store i64 %8, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 12), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 13), align 8
  %9 = add i64 %pgocount7, 1
  store i64 %9, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 13), align 8
  %10 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr3 = getelementptr inbounds nuw %Result__int__string, ptr %10, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr3, align 8
  %pay_ptr4 = getelementptr inbounds nuw %Result__int__string, ptr %10, i32 0, i32 1
  %11 = call ptr @forge_rc_alloc(i64 8)
  store ptr %11, ptr %pay_ptr4, align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 14), align 8
  %12 = add i64 %pgocount8, 1
  store i64 %12, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 14), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 15), align 8
  %13 = add i64 %pgocount9, 1
  store i64 %13, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 15), align 8
  %a5 = load i64, ptr %a, align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 16), align 8
  %14 = add i64 %pgocount10, 1
  store i64 %14, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 16), align 8
  %b6 = load i64, ptr %b, align 8
  %dz_chk = icmp eq i64 %b6, 0
  %dz_chk_ext = zext i1 %dz_chk to i64
  call void @forge_div_by_zero_trap(i64 %dz_chk_ext, ptr @dz_file, i64 138, i64 12)
  %div = sdiv i64 %a5, %b6
  %slot_base7 = ptrtoint ptr %11 to i64
  %slot_addr8 = add i64 %slot_base7, 0
  %slot9 = inttoptr i64 %slot_addr8 to ptr
  store i64 %div, ptr %slot9, align 8
  %cast10 = ptrtoint ptr %10 to i64
  %cast11 = inttoptr i64 %cast10 to ptr
  %ret_tag_ptr = getelementptr inbounds nuw %Result__int__string, ptr %cast11, i32 0, i32 0
  %ret_tag = load i64, ptr %ret_tag_ptr, align 8
  %is_err_ret = icmp eq i64 %ret_tag, 193456014
  br i1 %is_err_ret, label %errdefer_path, label %defer_path

if_then:                                          ; preds = %entry
  %pgocount11 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 6), align 8
  %15 = add i64 %pgocount11, 1
  store i64 %15, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 6), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 7), align 8
  %16 = add i64 %pgocount12, 1
  store i64 %16, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 7), align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 8), align 8
  %17 = add i64 %pgocount13, 1
  store i64 %17, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 8), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 9), align 8
  %18 = add i64 %pgocount14, 1
  store i64 %18, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 9), align 8
  %19 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Result__int__string, ptr %19, i32 0, i32 0
  store i64 193456014, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result__int__string, ptr %19, i32 0, i32 1
  %20 = call ptr @forge_rc_alloc(i64 8)
  store ptr %20, ptr %pay_ptr, align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 10), align 8
  %21 = add i64 %pgocount15, 1
  store i64 %21, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 10), align 8
  %slot_base = ptrtoint ptr %20 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr @.str, ptr %slot, align 8
  %cast = ptrtoint ptr %19 to i64
  %cast2 = inttoptr i64 %cast to ptr
  ret ptr %cast2

if_else:                                          ; preds = %entry
  %pgocount16 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 11), align 8
  %22 = add i64 %pgocount16, 1
  store i64 %22, ptr getelementptr inbounds ([17 x i64], ptr @__profc_divide, i32 0, i32 11), align 8
  br label %ifcont

errdefer_path:                                    ; preds = %ifcont
  br label %defer_done

defer_path:                                       ; preds = %ifcont
  br label %defer_done

defer_done:                                       ; preds = %defer_path, %errdefer_path
  %cast12 = inttoptr i64 %cast10 to ptr
  ret ptr %cast12
}

define i64 @main() {
entry:
  %e38 = alloca ptr, align 8
  %v25 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %e9 = alloca ptr, align 8
  %v1 = alloca i64, align 8
  %match_stmt_discard = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_main, align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr @__profc_main, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %3 = add i64 %pgocount3, 1
  store i64 %3, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %4 = add i64 %pgocount4, 1
  store i64 %4, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %5 = call ptr @divide(i64 84, i64 2)
  %tag_ptr = getelementptr inbounds nuw %Result__int__string, ptr %5, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %tag_eq = icmp eq i64 %tag, 5862623
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm4, %march_arm
  %pgocount5 = load i64, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %8 = add i64 %pgocount7, 1
  store i64 %8, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %9 = add i64 %pgocount8, 1
  store i64 %9, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %10 = call ptr @divide(i64 10, i64 0)
  %tag_ptr13 = getelementptr inbounds nuw %Result__int__string, ptr %10, i32 0, i32 0
  %tag14 = load i64, ptr %tag_ptr13, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq18 = icmp eq i64 %tag14, 5862623
  br i1 %tag_eq18, label %march_arm16, label %march_next17

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Result__int__string, ptr %5, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load i64, ptr %v_slot, align 8
  store i64 %v, ptr %v1, align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %11 = add i64 %pgocount9, 1
  store i64 %11, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %12 = add i64 %pgocount10, 1
  store i64 %12, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %13 = add i64 %pgocount11, 1
  store i64 %13, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %14 = add i64 %pgocount12, 1
  store i64 %14, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %v2 = load i64, ptr %v1, align 8
  %15 = call ptr @forge_rc_alloc(i64 32)
  %16 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %15, i64 32, ptr @.i2s_fmt, i64 %v2)
  %widen = sext i32 %16 to i64
  %17 = call i32 @puts(ptr %15)
  %widen3 = sext i32 %17 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq6 = icmp eq i64 %tag, 193456014
  br i1 %tag_eq6, label %march_arm4, label %march_next5

march_arm4:                                       ; preds = %march_next
  %pay_slot7 = getelementptr inbounds nuw %Result__int__string, ptr %5, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %e_slot_base = ptrtoint ptr %payload8 to i64
  %e_slot_addr = add i64 %e_slot_base, 0
  %e_slot = inttoptr i64 %e_slot_addr to ptr
  %e = load ptr, ptr %e_slot, align 8
  call void @forge_rc_retain(ptr %e)
  store ptr %e, ptr %e9, align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %18 = add i64 %pgocount13, 1
  store i64 %18, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %19 = add i64 %pgocount14, 1
  store i64 %19, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %20 = add i64 %pgocount15, 1
  store i64 %20, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %pgocount16 = load i64, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %21 = add i64 %pgocount16, 1
  store i64 %21, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %pgocount17 = load i64, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %22 = add i64 %pgocount17, 1
  store i64 %22, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %23 = add i64 %pgocount18, 1
  store i64 %23, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %e10 = load ptr, ptr %e9, align 8
  %24 = call i64 @strlen(ptr @.str.1)
  %25 = call i64 @strlen(ptr %e10)
  %concat_total = add i64 %24, %25
  %concat_size = add i64 %concat_total, 1
  %26 = call ptr @forge_rc_alloc(i64 %concat_size)
  %27 = call ptr @memcpy(ptr %26, ptr @.str.1, i64 %24)
  %cast = ptrtoint ptr %26 to i64
  %dst2_int = add i64 %cast, %24
  %cast11 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %25, 1
  %28 = call ptr @memcpy(ptr %cast11, ptr %e10, i64 %rhs_len_p1)
  %29 = call i32 @puts(ptr %26)
  %widen12 = sext i32 %29 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next5:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 16)
  unreachable

match_end15:                                      ; preds = %march_arm29, %march_arm16
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm16:                                      ; preds = %match_end
  %pay_slot19 = getelementptr inbounds nuw %Result__int__string, ptr %10, i32 0, i32 1
  %payload20 = load ptr, ptr %pay_slot19, align 8
  %v_slot_base21 = ptrtoint ptr %payload20 to i64
  %v_slot_addr22 = add i64 %v_slot_base21, 0
  %v_slot23 = inttoptr i64 %v_slot_addr22 to ptr
  %v24 = load i64, ptr %v_slot23, align 8
  store i64 %v24, ptr %v25, align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %30 = add i64 %pgocount19, 1
  store i64 %30, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %31 = add i64 %pgocount20, 1
  store i64 %31, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %32 = add i64 %pgocount21, 1
  store i64 %32, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %pgocount22 = load i64, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %33 = add i64 %pgocount22, 1
  store i64 %33, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %v26 = load i64, ptr %v25, align 8
  %34 = call ptr @forge_rc_alloc(i64 32)
  %35 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %34, i64 32, ptr @.i2s_fmt.2, i64 %v26)
  %widen27 = sext i32 %35 to i64
  %36 = call i32 @puts(ptr %34)
  %widen28 = sext i32 %36 to i64
  store i64 0, ptr %match_result, align 8
  br label %match_end15

march_next17:                                     ; preds = %match_end
  %tag_eq31 = icmp eq i64 %tag14, 193456014
  br i1 %tag_eq31, label %march_arm29, label %march_next30

march_arm29:                                      ; preds = %march_next17
  %pay_slot32 = getelementptr inbounds nuw %Result__int__string, ptr %10, i32 0, i32 1
  %payload33 = load ptr, ptr %pay_slot32, align 8
  %e_slot_base34 = ptrtoint ptr %payload33 to i64
  %e_slot_addr35 = add i64 %e_slot_base34, 0
  %e_slot36 = inttoptr i64 %e_slot_addr35 to ptr
  %e37 = load ptr, ptr %e_slot36, align 8
  call void @forge_rc_retain(ptr %e37)
  store ptr %e37, ptr %e38, align 8
  %pgocount23 = load i64, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %37 = add i64 %pgocount23, 1
  store i64 %37, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %pgocount24 = load i64, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %38 = add i64 %pgocount24, 1
  store i64 %38, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %pgocount25 = load i64, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %39 = add i64 %pgocount25, 1
  store i64 %39, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %pgocount26 = load i64, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %40 = add i64 %pgocount26, 1
  store i64 %40, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %pgocount27 = load i64, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %41 = add i64 %pgocount27, 1
  store i64 %41, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %pgocount28 = load i64, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %42 = add i64 %pgocount28, 1
  store i64 %42, ptr getelementptr inbounds ([29 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %e39 = load ptr, ptr %e38, align 8
  %43 = call i64 @strlen(ptr @.str.3)
  %44 = call i64 @strlen(ptr %e39)
  %concat_total40 = add i64 %43, %44
  %concat_size41 = add i64 %concat_total40, 1
  %45 = call ptr @forge_rc_alloc(i64 %concat_size41)
  %46 = call ptr @memcpy(ptr %45, ptr @.str.3, i64 %43)
  %cast42 = ptrtoint ptr %45 to i64
  %dst2_int43 = add i64 %cast42, %43
  %cast44 = inttoptr i64 %dst2_int43 to ptr
  %rhs_len_p145 = add i64 %44, 1
  %47 = call ptr @memcpy(ptr %cast44, ptr %e39, i64 %rhs_len_p145)
  %48 = call i32 @puts(ptr %45)
  %widen46 = sext i32 %48 to i64
  store i64 0, ptr %match_result, align 8
  br label %match_end15

march_next30:                                     ; preds = %march_next17
  call void @forge_match_unreachable(ptr @.match_fn.4, i64 %tag14, ptr @mu_file.5, i64 20)
  unreachable
}

define i64 @__bs_top_level() {
entry:
  %pgocount = load i64, ptr getelementptr inbounds ([30 x i64], ptr @__profc___bs_top_level, i32 0, i32 29), align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr getelementptr inbounds ([30 x i64], ptr @__profc___bs_top_level, i32 0, i32 29), align 8
  %1 = call i32 @forge_test_summary()
  %widen = sext i32 %1 to i64
  call void @forge_rc_collect()
  ret i64 0
}

define i64 @__release_Result__int__string(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %Result__int__string, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result__int__string, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Err = icmp eq i64 %tag, 193456014
  br i1 %is_Err, label %rel_Err, label %try_next_Err

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %fields_done, %alive
  ret i64 0

fields_done:                                      ; preds = %vrel_error_skip, %try_next_Err
  call void @forge_rc_free(ptr %0)
  br label %done

rel_Err:                                          ; preds = %do_free
  %vrel_error_ptr = getelementptr inbounds nuw %Result__int__string__Err, ptr %payload, i32 0, i32 0
  %vrel_error = load ptr, ptr %vrel_error_ptr, align 8
  %vrel_null_error = icmp eq ptr %vrel_error, null
  br i1 %vrel_null_error, label %vrel_error_skip, label %vrel_error_do

try_next_Err:                                     ; preds = %do_free
  br label %fields_done

vrel_error_skip:                                  ; preds = %vrel_error_do, %rel_Err
  br label %fields_done

vrel_error_do:                                    ; preds = %rel_Err
  call void @forge_rc_release(ptr %vrel_error)
  br label %vrel_error_skip
}

; Function Attrs: noinline
define linkonce_odr hidden i32 @__llvm_profile_runtime_user() #1 {
  %1 = load i32, ptr @__llvm_profile_runtime, align 4
  ret i32 %1
}

attributes #0 = { nounwind }
attributes #1 = { noinline }
