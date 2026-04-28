; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/closures/tests/inline_lambda_match.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

%Expr = type { i64, ptr }
%Box = type { i64, ptr }
%Expr__Add = type { ptr, ptr }

@.match_fn = private unnamed_addr constant [9 x i8] c"map_expr\00", align 1
@mu_file = private unnamed_addr constant [144 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/closures/tests/inline_lambda_match.fg\00", align 1
@.match_fn.1 = private unnamed_addr constant [5 x i8] c"eval\00", align 1
@mu_file.2 = private unnamed_addr constant [144 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/closures/tests/inline_lambda_match.fg\00", align 1
@.match_fn.3 = private unnamed_addr constant [11 x i8] c"__lambda_0\00", align 1
@mu_file.4 = private unnamed_addr constant [144 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/closures/tests/inline_lambda_match.fg\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.match_fn.5 = private unnamed_addr constant [11 x i8] c"__lambda_1\00", align 1
@mu_file.6 = private unnamed_addr constant [144 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/closures/tests/inline_lambda_match.fg\00", align 1
@.i2s_fmt.7 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_apply = private global [4 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_apply = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 1068639213276341325, i64 210706734667, i64 sub (i64 ptrtoint (ptr @__profc_apply to i64), i64 ptrtoint (ptr @__profd_apply to i64)), i64 0, ptr null, ptr null, i32 4, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_map_expr = private global [17 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_map_expr = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 3911778229629281205, i64 7572659957022945, i64 sub (i64 ptrtoint (ptr @__profc_map_expr to i64), i64 ptrtoint (ptr @__profd_map_expr to i64)), i64 0, ptr null, ptr null, i32 17, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_eval = private global [11 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_eval = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 8418976871401647406, i64 6385202349, i64 sub (i64 ptrtoint (ptr @__profc_eval to i64), i64 ptrtoint (ptr @__profd_eval to i64)), i64 0, ptr null, ptr null, i32 11, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_main = private global [15 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 15, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___bs_top_level = private global [17 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___bs_top_level = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -3222087168638311179, i64 -7005428211549351871, i64 sub (i64 ptrtoint (ptr @__profc___bs_top_level to i64), i64 ptrtoint (ptr @__profd___bs_top_level to i64)), i64 0, ptr null, ptr null, i32 17, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___lambda_0 = private global [9 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___lambda_0 = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -204181057533209874, i64 8245973951994833619, i64 sub (i64 ptrtoint (ptr @__profc___lambda_0 to i64), i64 ptrtoint (ptr @__profd___lambda_0 to i64)), i64 0, ptr null, ptr null, i32 9, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___lambda_1 = private global [10 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___lambda_1 = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 6925786121186820513, i64 8245973951994833620, i64 sub (i64 ptrtoint (ptr @__profc___lambda_1 to i64), i64 ptrtoint (ptr @__profd___lambda_1 to i64)), i64 0, ptr null, ptr null, i32 10, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__llvm_prf_nm = private constant [60 x i8] c"=:x\DAK,(\C8\A9d\CCM,\88O\AD((bL-K\CC\01\F22\F3\18\E3\E3\93\8A\E3K\F2\0B\E2sR\CBRs\80\DC\9C\C4\DC\A4\94\C4x\03\04\D3\10\00\B2\87\15\EF", section "__DATA,__llvm_prf_names", align 1
@llvm.compiler.used = appending global [8 x ptr] [ptr @__llvm_profile_runtime_user, ptr @__profd_apply, ptr @__profd_map_expr, ptr @__profd_eval, ptr @__profd_main, ptr @__profd___bs_top_level, ptr @__profd___lambda_0, ptr @__profd___lambda_1], section "llvm.metadata"
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

define i64 @apply(ptr %0, ptr %1) {
entry:
  %f = alloca ptr, align 8
  %b = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_apply, align 8
  %2 = add i64 %pgocount, 1
  store i64 %2, ptr @__profc_apply, align 8
  store ptr %0, ptr %b, align 8
  store ptr %1, ptr %f, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_apply, i32 0, i32 1), align 8
  %3 = add i64 %pgocount1, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc_apply, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_apply, i32 0, i32 2), align 8
  %4 = add i64 %pgocount2, 1
  store i64 %4, ptr getelementptr inbounds ([4 x i64], ptr @__profc_apply, i32 0, i32 2), align 8
  %f1 = load i64, ptr %f, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_apply, i32 0, i32 3), align 8
  %5 = add i64 %pgocount3, 1
  store i64 %5, ptr getelementptr inbounds ([4 x i64], ptr @__profc_apply, i32 0, i32 3), align 8
  %b2 = load ptr, ptr %b, align 8
  %cast = ptrtoint ptr %b2 to i64
  %6 = call i64 @forge_closure_call_1(i64 %f1, i64 %cast)
  ret i64 %6
}

define ptr @map_expr(ptr %0, ptr %1) {
entry:
  %mapped = alloca ptr, align 8
  %r9 = alloca ptr, align 8
  %l6 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %f = alloca ptr, align 8
  %expr = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_map_expr, align 8
  %2 = add i64 %pgocount, 1
  store i64 %2, ptr @__profc_map_expr, align 8
  store ptr %0, ptr %expr, align 8
  store ptr %1, ptr %f, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_map_expr, i32 0, i32 1), align 8
  %3 = add i64 %pgocount1, 1
  store i64 %3, ptr getelementptr inbounds ([17 x i64], ptr @__profc_map_expr, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_map_expr, i32 0, i32 2), align 8
  %4 = add i64 %pgocount2, 1
  store i64 %4, ptr getelementptr inbounds ([17 x i64], ptr @__profc_map_expr, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_map_expr, i32 0, i32 3), align 8
  %5 = add i64 %pgocount3, 1
  store i64 %5, ptr getelementptr inbounds ([17 x i64], ptr @__profc_map_expr, i32 0, i32 3), align 8
  %expr1 = load ptr, ptr %expr, align 8
  %tag_ptr = getelementptr inbounds nuw %Expr, ptr %expr1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193465909
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm3, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast19 = inttoptr i64 %match_val to ptr
  store ptr %cast19, ptr %mapped, align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_map_expr, i32 0, i32 14), align 8
  %6 = add i64 %pgocount4, 1
  store i64 %6, ptr getelementptr inbounds ([17 x i64], ptr @__profc_map_expr, i32 0, i32 14), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_map_expr, i32 0, i32 15), align 8
  %7 = add i64 %pgocount5, 1
  store i64 %7, ptr getelementptr inbounds ([17 x i64], ptr @__profc_map_expr, i32 0, i32 15), align 8
  %f20 = load i64, ptr %f, align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_map_expr, i32 0, i32 16), align 8
  %8 = add i64 %pgocount6, 1
  store i64 %8, ptr getelementptr inbounds ([17 x i64], ptr @__profc_map_expr, i32 0, i32 16), align 8
  %mapped21 = load ptr, ptr %mapped, align 8
  %cast22 = ptrtoint ptr %mapped21 to i64
  %9 = call i64 @forge_closure_call_1(i64 %f20, i64 %cast22)
  %cast23 = inttoptr i64 %9 to ptr
  ret ptr %cast23

march_arm:                                        ; preds = %entry
  %pgocount7 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_map_expr, i32 0, i32 4), align 8
  %10 = add i64 %pgocount7, 1
  store i64 %10, ptr getelementptr inbounds ([17 x i64], ptr @__profc_map_expr, i32 0, i32 4), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_map_expr, i32 0, i32 5), align 8
  %11 = add i64 %pgocount8, 1
  store i64 %11, ptr getelementptr inbounds ([17 x i64], ptr @__profc_map_expr, i32 0, i32 5), align 8
  %expr2 = load ptr, ptr %expr, align 8
  %cast = ptrtoint ptr %expr2 to i64
  store i64 %cast, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq5 = icmp eq i64 %tag, 193451182
  br i1 %tag_eq5, label %march_arm3, label %march_next4

march_arm3:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %Expr, ptr %expr1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %l_slot_base = ptrtoint ptr %payload to i64
  %l_slot_addr = add i64 %l_slot_base, 0
  %l_slot = inttoptr i64 %l_slot_addr to ptr
  %l = load ptr, ptr %l_slot, align 8
  call void @forge_rc_retain(ptr %l)
  store ptr %l, ptr %l6, align 8
  %pay_slot7 = getelementptr inbounds nuw %Expr, ptr %expr1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %r_slot_base = ptrtoint ptr %payload8 to i64
  %r_slot_addr = add i64 %r_slot_base, 8
  %r_slot = inttoptr i64 %r_slot_addr to ptr
  %r = load ptr, ptr %r_slot, align 8
  call void @forge_rc_retain(ptr %r)
  store ptr %r, ptr %r9, align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_map_expr, i32 0, i32 6), align 8
  %12 = add i64 %pgocount9, 1
  store i64 %12, ptr getelementptr inbounds ([17 x i64], ptr @__profc_map_expr, i32 0, i32 6), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_map_expr, i32 0, i32 7), align 8
  %13 = add i64 %pgocount10, 1
  store i64 %13, ptr getelementptr inbounds ([17 x i64], ptr @__profc_map_expr, i32 0, i32 7), align 8
  %14 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr10 = getelementptr inbounds nuw %Expr, ptr %14, i32 0, i32 0
  store i64 193451182, ptr %tag_ptr10, align 8
  %pay_ptr = getelementptr inbounds nuw %Expr, ptr %14, i32 0, i32 1
  %15 = call ptr @forge_rc_alloc(i64 16)
  store ptr %15, ptr %pay_ptr, align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_map_expr, i32 0, i32 8), align 8
  %16 = add i64 %pgocount11, 1
  store i64 %16, ptr getelementptr inbounds ([17 x i64], ptr @__profc_map_expr, i32 0, i32 8), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_map_expr, i32 0, i32 9), align 8
  %17 = add i64 %pgocount12, 1
  store i64 %17, ptr getelementptr inbounds ([17 x i64], ptr @__profc_map_expr, i32 0, i32 9), align 8
  %l11 = load ptr, ptr %l6, align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_map_expr, i32 0, i32 10), align 8
  %18 = add i64 %pgocount13, 1
  store i64 %18, ptr getelementptr inbounds ([17 x i64], ptr @__profc_map_expr, i32 0, i32 10), align 8
  %f12 = load ptr, ptr %f, align 8
  %19 = call ptr @map_expr(ptr %l11, ptr %f12)
  %slot_base = ptrtoint ptr %15 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr %19, ptr %slot, align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_map_expr, i32 0, i32 11), align 8
  %20 = add i64 %pgocount14, 1
  store i64 %20, ptr getelementptr inbounds ([17 x i64], ptr @__profc_map_expr, i32 0, i32 11), align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_map_expr, i32 0, i32 12), align 8
  %21 = add i64 %pgocount15, 1
  store i64 %21, ptr getelementptr inbounds ([17 x i64], ptr @__profc_map_expr, i32 0, i32 12), align 8
  %r13 = load ptr, ptr %r9, align 8
  %pgocount16 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_map_expr, i32 0, i32 13), align 8
  %22 = add i64 %pgocount16, 1
  store i64 %22, ptr getelementptr inbounds ([17 x i64], ptr @__profc_map_expr, i32 0, i32 13), align 8
  %f14 = load ptr, ptr %f, align 8
  %23 = call ptr @map_expr(ptr %r13, ptr %f14)
  %slot_base15 = ptrtoint ptr %15 to i64
  %slot_addr16 = add i64 %slot_base15, 8
  %slot17 = inttoptr i64 %slot_addr16 to ptr
  store ptr %23, ptr %slot17, align 8
  %cast18 = ptrtoint ptr %14 to i64
  store i64 %cast18, ptr %match_result, align 8
  br label %match_end

march_next4:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 13)
  unreachable
}

define i64 @eval(ptr %0) {
entry:
  %r12 = alloca ptr, align 8
  %l9 = alloca ptr, align 8
  %v2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %expr = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_eval, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_eval, align 8
  store ptr %0, ptr %expr, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_eval, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([11 x i64], ptr @__profc_eval, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_eval, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([11 x i64], ptr @__profc_eval, i32 0, i32 2), align 8
  %expr1 = load ptr, ptr %expr, align 8
  %tag_ptr = getelementptr inbounds nuw %Expr, ptr %expr1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193465909
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm4, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Expr, ptr %expr1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load i64, ptr %v_slot, align 8
  store i64 %v, ptr %v2, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_eval, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([11 x i64], ptr @__profc_eval, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_eval, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([11 x i64], ptr @__profc_eval, i32 0, i32 4), align 8
  %v3 = load i64, ptr %v2, align 8
  store i64 %v3, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq6 = icmp eq i64 %tag, 193451182
  br i1 %tag_eq6, label %march_arm4, label %march_next5

march_arm4:                                       ; preds = %march_next
  %pay_slot7 = getelementptr inbounds nuw %Expr, ptr %expr1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %l_slot_base = ptrtoint ptr %payload8 to i64
  %l_slot_addr = add i64 %l_slot_base, 0
  %l_slot = inttoptr i64 %l_slot_addr to ptr
  %l = load ptr, ptr %l_slot, align 8
  call void @forge_rc_retain(ptr %l)
  store ptr %l, ptr %l9, align 8
  %pay_slot10 = getelementptr inbounds nuw %Expr, ptr %expr1, i32 0, i32 1
  %payload11 = load ptr, ptr %pay_slot10, align 8
  %r_slot_base = ptrtoint ptr %payload11 to i64
  %r_slot_addr = add i64 %r_slot_base, 8
  %r_slot = inttoptr i64 %r_slot_addr to ptr
  %r = load ptr, ptr %r_slot, align 8
  call void @forge_rc_retain(ptr %r)
  store ptr %r, ptr %r12, align 8
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
  %l13 = load ptr, ptr %l9, align 8
  %10 = call i64 @eval(ptr %l13)
  %pgocount9 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_eval, i32 0, i32 9), align 8
  %11 = add i64 %pgocount9, 1
  store i64 %11, ptr getelementptr inbounds ([11 x i64], ptr @__profc_eval, i32 0, i32 9), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_eval, i32 0, i32 10), align 8
  %12 = add i64 %pgocount10, 1
  store i64 %12, ptr getelementptr inbounds ([11 x i64], ptr @__profc_eval, i32 0, i32 10), align 8
  %r14 = load ptr, ptr %r12, align 8
  %13 = call i64 @eval(ptr %r14)
  %add = add i64 %10, %13
  store i64 %add, ptr %match_result, align 8
  br label %match_end

march_next5:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn.1, i64 %tag, ptr @mu_file.2, i64 21)
  unreachable
}

define i64 @main() {
entry:
  %scaled = alloca ptr, align 8
  %tree = alloca ptr, align 8
  %factor = alloca i64, align 8
  %r = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_main, align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr @__profc_main, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %3 = add i64 %pgocount3, 1
  store i64 %3, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %4 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Box, ptr %4, i32 0, i32 0
  store i64 193473960, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Box, ptr %4, i32 0, i32 1
  %5 = call ptr @forge_rc_alloc(i64 8)
  store ptr %5, ptr %pay_ptr, align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %6 = add i64 %pgocount4, 1
  store i64 %6, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %slot_base = ptrtoint ptr %5 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 21, ptr %slot, align 8
  %cast = ptrtoint ptr %4 to i64
  %7 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %7, i64 -559038737)
  call void @forge_array_push(ptr %7, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast1 = ptrtoint ptr %7 to i64
  %cast2 = inttoptr i64 %cast to ptr
  %cast3 = inttoptr i64 %cast1 to ptr
  %8 = call i64 @apply(ptr %cast2, ptr %cast3)
  store i64 %8, ptr %r, align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %9 = add i64 %pgocount5, 1
  store i64 %9, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %10 = add i64 %pgocount6, 1
  store i64 %10, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %11 = add i64 %pgocount7, 1
  store i64 %11, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %12 = add i64 %pgocount8, 1
  store i64 %12, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %r4 = load i64, ptr %r, align 8
  %13 = call ptr @forge_rc_alloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @.i2s_fmt, i64 %r4)
  %widen = sext i32 %14 to i64
  %15 = call i32 @puts(ptr %13)
  %widen5 = sext i32 %15 to i64
  %pgocount9 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %16 = add i64 %pgocount9, 1
  store i64 %16, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %17 = add i64 %pgocount10, 1
  store i64 %17, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  store i64 3, ptr %factor, align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %18 = add i64 %pgocount11, 1
  store i64 %18, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %19 = add i64 %pgocount12, 1
  store i64 %19, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %20 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr6 = getelementptr inbounds nuw %Expr, ptr %20, i32 0, i32 0
  store i64 193451182, ptr %tag_ptr6, align 8
  %pay_ptr7 = getelementptr inbounds nuw %Expr, ptr %20, i32 0, i32 1
  %21 = call ptr @forge_rc_alloc(i64 16)
  store ptr %21, ptr %pay_ptr7, align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %22 = add i64 %pgocount13, 1
  store i64 %22, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %23 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr8 = getelementptr inbounds nuw %Expr, ptr %23, i32 0, i32 0
  store i64 193465909, ptr %tag_ptr8, align 8
  %pay_ptr9 = getelementptr inbounds nuw %Expr, ptr %23, i32 0, i32 1
  %24 = call ptr @forge_rc_alloc(i64 8)
  store ptr %24, ptr %pay_ptr9, align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %25 = add i64 %pgocount14, 1
  store i64 %25, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %slot_base10 = ptrtoint ptr %24 to i64
  %slot_addr11 = add i64 %slot_base10, 0
  %slot12 = inttoptr i64 %slot_addr11 to ptr
  store i64 1, ptr %slot12, align 8
  %cast13 = ptrtoint ptr %23 to i64
  %slot_base14 = ptrtoint ptr %21 to i64
  %slot_addr15 = add i64 %slot_base14, 0
  %slot16 = inttoptr i64 %slot_addr15 to ptr
  %cast17 = inttoptr i64 %cast13 to ptr
  store ptr %cast17, ptr %slot16, align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %26 = add i64 %pgocount15, 1
  store i64 %26, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %27 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr18 = getelementptr inbounds nuw %Expr, ptr %27, i32 0, i32 0
  store i64 193451182, ptr %tag_ptr18, align 8
  %pay_ptr19 = getelementptr inbounds nuw %Expr, ptr %27, i32 0, i32 1
  %28 = call ptr @forge_rc_alloc(i64 16)
  store ptr %28, ptr %pay_ptr19, align 8
  %pgocount16 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %29 = add i64 %pgocount16, 1
  store i64 %29, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %30 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr20 = getelementptr inbounds nuw %Expr, ptr %30, i32 0, i32 0
  store i64 193465909, ptr %tag_ptr20, align 8
  %pay_ptr21 = getelementptr inbounds nuw %Expr, ptr %30, i32 0, i32 1
  %31 = call ptr @forge_rc_alloc(i64 8)
  store ptr %31, ptr %pay_ptr21, align 8
  %pgocount17 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %32 = add i64 %pgocount17, 1
  store i64 %32, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %slot_base22 = ptrtoint ptr %31 to i64
  %slot_addr23 = add i64 %slot_base22, 0
  %slot24 = inttoptr i64 %slot_addr23 to ptr
  store i64 2, ptr %slot24, align 8
  %cast25 = ptrtoint ptr %30 to i64
  %slot_base26 = ptrtoint ptr %28 to i64
  %slot_addr27 = add i64 %slot_base26, 0
  %slot28 = inttoptr i64 %slot_addr27 to ptr
  %cast29 = inttoptr i64 %cast25 to ptr
  store ptr %cast29, ptr %slot28, align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %33 = add i64 %pgocount18, 1
  store i64 %33, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %34 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr30 = getelementptr inbounds nuw %Expr, ptr %34, i32 0, i32 0
  store i64 193465909, ptr %tag_ptr30, align 8
  %pay_ptr31 = getelementptr inbounds nuw %Expr, ptr %34, i32 0, i32 1
  %35 = call ptr @forge_rc_alloc(i64 8)
  store ptr %35, ptr %pay_ptr31, align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %36 = add i64 %pgocount19, 1
  store i64 %36, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %slot_base32 = ptrtoint ptr %35 to i64
  %slot_addr33 = add i64 %slot_base32, 0
  %slot34 = inttoptr i64 %slot_addr33 to ptr
  store i64 3, ptr %slot34, align 8
  %cast35 = ptrtoint ptr %34 to i64
  %slot_base36 = ptrtoint ptr %28 to i64
  %slot_addr37 = add i64 %slot_base36, 8
  %slot38 = inttoptr i64 %slot_addr37 to ptr
  %cast39 = inttoptr i64 %cast35 to ptr
  store ptr %cast39, ptr %slot38, align 8
  %cast40 = ptrtoint ptr %27 to i64
  %slot_base41 = ptrtoint ptr %21 to i64
  %slot_addr42 = add i64 %slot_base41, 8
  %slot43 = inttoptr i64 %slot_addr42 to ptr
  %cast44 = inttoptr i64 %cast40 to ptr
  store ptr %cast44, ptr %slot43, align 8
  %cast45 = ptrtoint ptr %20 to i64
  %cast46 = inttoptr i64 %cast45 to ptr
  store ptr %cast46, ptr %tree, align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %37 = add i64 %pgocount20, 1
  store i64 %37, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %38 = add i64 %pgocount21, 1
  store i64 %38, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %pgocount22 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %39 = add i64 %pgocount22, 1
  store i64 %39, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %tree47 = load ptr, ptr %tree, align 8
  %40 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %40, i64 -559038737)
  call void @forge_array_push(ptr %40, i64 ptrtoint (ptr @__lambda_1 to i64))
  %cap_val = load i64, ptr %factor, align 8
  call void @forge_array_push(ptr %40, i64 %cap_val)
  %cast48 = ptrtoint ptr %40 to i64
  %cast49 = inttoptr i64 %cast48 to ptr
  %41 = call ptr @map_expr(ptr %tree47, ptr %cast49)
  store ptr %41, ptr %scaled, align 8
  %pgocount23 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %42 = add i64 %pgocount23, 1
  store i64 %42, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %pgocount24 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %43 = add i64 %pgocount24, 1
  store i64 %43, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %pgocount25 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %44 = add i64 %pgocount25, 1
  store i64 %44, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %pgocount26 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %45 = add i64 %pgocount26, 1
  store i64 %45, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %pgocount27 = load i64, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %46 = add i64 %pgocount27, 1
  store i64 %46, ptr getelementptr inbounds ([15 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %scaled50 = load ptr, ptr %scaled, align 8
  %47 = call i64 @eval(ptr %scaled50)
  %48 = call ptr @forge_rc_alloc(i64 32)
  %49 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %48, i64 32, ptr @.i2s_fmt.7, i64 %47)
  %widen51 = sext i32 %49 to i64
  %50 = call i32 @puts(ptr %48)
  %widen52 = sext i32 %50 to i64
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  %pgocount = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc___bs_top_level, i32 0, i32 15), align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr getelementptr inbounds ([17 x i64], ptr @__profc___bs_top_level, i32 0, i32 15), align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc___bs_top_level, i32 0, i32 16), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([17 x i64], ptr @__profc___bs_top_level, i32 0, i32 16), align 8
  %2 = call i32 @forge_test_summary()
  %widen = sext i32 %2 to i64
  call void @forge_rc_collect()
  ret i64 0
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

fields_done:                                      ; preds = %vrel_right_skip, %try_next_Add
  call void @forge_rc_free(ptr %0)
  br label %done

rel_Add:                                          ; preds = %do_free
  %vrel_left_ptr = getelementptr inbounds nuw %Expr__Add, ptr %payload, i32 0, i32 0
  %vrel_left = load ptr, ptr %vrel_left_ptr, align 8
  %vrel_null_left = icmp eq ptr %vrel_left, null
  br i1 %vrel_null_left, label %vrel_left_skip, label %vrel_left_do

try_next_Add:                                     ; preds = %do_free
  br label %fields_done

vrel_left_skip:                                   ; preds = %vrel_left_do, %rel_Add
  %vrel_right_ptr = getelementptr inbounds nuw %Expr__Add, ptr %payload, i32 0, i32 1
  %vrel_right = load ptr, ptr %vrel_right_ptr, align 8
  %vrel_null_right = icmp eq ptr %vrel_right, null
  br i1 %vrel_null_right, label %vrel_right_skip, label %vrel_right_do

vrel_left_do:                                     ; preds = %rel_Add
  %2 = call i64 @__release_Expr(ptr %vrel_left)
  br label %vrel_left_skip

vrel_right_skip:                                  ; preds = %vrel_right_do, %vrel_left_skip
  br label %fields_done

vrel_right_do:                                    ; preds = %vrel_left_skip
  %3 = call i64 @__release_Expr(ptr %vrel_right)
  br label %vrel_right_skip
}

define i64 @__lambda_0(ptr %0) {
entry:
  %n2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %b = alloca ptr, align 8
  store ptr %0, ptr %b, align 8
  %pgocount = load i64, ptr @__profc___lambda_0, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc___lambda_0, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_0, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_0, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_0, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_0, i32 0, i32 2), align 8
  %b1 = load ptr, ptr %b, align 8
  %tag_ptr = getelementptr inbounds nuw %Box, ptr %b1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193473960
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm4, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Box, ptr %b1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %n_slot_base = ptrtoint ptr %payload to i64
  %n_slot_addr = add i64 %n_slot_base, 0
  %n_slot = inttoptr i64 %n_slot_addr to ptr
  %n = load i64, ptr %n_slot, align 8
  store i64 %n, ptr %n2, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_0, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_0, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_0, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_0, i32 0, i32 4), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_0, i32 0, i32 5), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_0, i32 0, i32 5), align 8
  %n3 = load i64, ptr %n2, align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_0, i32 0, i32 6), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_0, i32 0, i32 6), align 8
  %mul = mul i64 %n3, 2
  store i64 %mul, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  br label %march_arm4

march_arm4:                                       ; preds = %march_next
  %pgocount7 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_0, i32 0, i32 7), align 8
  %8 = add i64 %pgocount7, 1
  store i64 %8, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_0, i32 0, i32 7), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_0, i32 0, i32 8), align 8
  %9 = add i64 %pgocount8, 1
  store i64 %9, ptr getelementptr inbounds ([9 x i64], ptr @__profc___lambda_0, i32 0, i32 8), align 8
  store i64 0, ptr %match_result, align 8
  br label %match_end

march_next5:                                      ; No predecessors!
  call void @forge_match_unreachable(ptr @.match_fn.3, i64 %tag, ptr @mu_file.4, i64 26)
  unreachable
}

define i64 @__lambda_1(ptr %0, i64 %1) {
entry:
  %v2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %factor = alloca i64, align 8
  %e = alloca ptr, align 8
  store ptr %0, ptr %e, align 8
  store i64 %1, ptr %factor, align 8
  %pgocount = load i64, ptr @__profc___lambda_1, align 8
  %2 = add i64 %pgocount, 1
  store i64 %2, ptr @__profc___lambda_1, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc___lambda_1, i32 0, i32 1), align 8
  %3 = add i64 %pgocount1, 1
  store i64 %3, ptr getelementptr inbounds ([10 x i64], ptr @__profc___lambda_1, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc___lambda_1, i32 0, i32 2), align 8
  %4 = add i64 %pgocount2, 1
  store i64 %4, ptr getelementptr inbounds ([10 x i64], ptr @__profc___lambda_1, i32 0, i32 2), align 8
  %e1 = load ptr, ptr %e, align 8
  %tag_ptr = getelementptr inbounds nuw %Expr, ptr %e1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193465909
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm6, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Expr, ptr %e1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load i64, ptr %v_slot, align 8
  store i64 %v, ptr %v2, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc___lambda_1, i32 0, i32 3), align 8
  %5 = add i64 %pgocount3, 1
  store i64 %5, ptr getelementptr inbounds ([10 x i64], ptr @__profc___lambda_1, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc___lambda_1, i32 0, i32 4), align 8
  %6 = add i64 %pgocount4, 1
  store i64 %6, ptr getelementptr inbounds ([10 x i64], ptr @__profc___lambda_1, i32 0, i32 4), align 8
  %7 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr3 = getelementptr inbounds nuw %Expr, ptr %7, i32 0, i32 0
  store i64 193465909, ptr %tag_ptr3, align 8
  %pay_ptr = getelementptr inbounds nuw %Expr, ptr %7, i32 0, i32 1
  %8 = call ptr @forge_rc_alloc(i64 8)
  store ptr %8, ptr %pay_ptr, align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc___lambda_1, i32 0, i32 5), align 8
  %9 = add i64 %pgocount5, 1
  store i64 %9, ptr getelementptr inbounds ([10 x i64], ptr @__profc___lambda_1, i32 0, i32 5), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc___lambda_1, i32 0, i32 6), align 8
  %10 = add i64 %pgocount6, 1
  store i64 %10, ptr getelementptr inbounds ([10 x i64], ptr @__profc___lambda_1, i32 0, i32 6), align 8
  %v4 = load i64, ptr %v2, align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc___lambda_1, i32 0, i32 7), align 8
  %11 = add i64 %pgocount7, 1
  store i64 %11, ptr getelementptr inbounds ([10 x i64], ptr @__profc___lambda_1, i32 0, i32 7), align 8
  %factor5 = load i64, ptr %factor, align 8
  %mul = mul i64 %v4, %factor5
  %slot_base = ptrtoint ptr %8 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 %mul, ptr %slot, align 8
  %cast = ptrtoint ptr %7 to i64
  store i64 %cast, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  br label %march_arm6

march_arm6:                                       ; preds = %march_next
  %pgocount8 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc___lambda_1, i32 0, i32 8), align 8
  %12 = add i64 %pgocount8, 1
  store i64 %12, ptr getelementptr inbounds ([10 x i64], ptr @__profc___lambda_1, i32 0, i32 8), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([10 x i64], ptr @__profc___lambda_1, i32 0, i32 9), align 8
  %13 = add i64 %pgocount9, 1
  store i64 %13, ptr getelementptr inbounds ([10 x i64], ptr @__profc___lambda_1, i32 0, i32 9), align 8
  %e8 = load ptr, ptr %e, align 8
  %cast9 = ptrtoint ptr %e8 to i64
  store i64 %cast9, ptr %match_result, align 8
  br label %match_end

march_next7:                                      ; No predecessors!
  call void @forge_match_unreachable(ptr @.match_fn.5, i64 %tag, ptr @mu_file.6, i64 32)
  unreachable
}

; Function Attrs: noinline
define linkonce_odr hidden i32 @__llvm_profile_runtime_user() #1 {
  %1 = load i32, ptr @__llvm_profile_runtime, align 4
  ret i32 %1
}

attributes #0 = { nounwind }
attributes #1 = { noinline }
