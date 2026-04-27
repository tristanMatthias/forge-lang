; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/generics/tests/generic_combo.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

%Result__int__string = type { i64, ptr }
%Result__int__string__Err = type { ptr }

@.str = private unnamed_addr constant [4 x i8] c"bad\00", align 1
@dz_file = private unnamed_addr constant [138 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/generics/tests/generic_combo.fg\00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"ok: \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.2 = private unnamed_addr constant [6 x i8] c"err: \00", align 1
@.match_fn = private unnamed_addr constant [12 x i8] c"show_result\00", align 1
@mu_file = private unnamed_addr constant [138 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/generics/tests/generic_combo.fg\00", align 1
@.i2s_fmt.3 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.4 = private unnamed_addr constant [10 x i8] c"doubled: \00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_wrap__ = private global [3 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_wrap__ = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 9124680010795151650, i64 6954185059037, i64 sub (i64 ptrtoint (ptr @__profc_wrap__ to i64), i64 ptrtoint (ptr @__profd_wrap__ to i64)), i64 0, ptr null, ptr null, i32 3, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_double_wrap__int = private global [4 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_double_wrap__int = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -5717702016563273888, i64 -8769476894663460158, i64 sub (i64 ptrtoint (ptr @__profc_double_wrap__int to i64), i64 ptrtoint (ptr @__profd_double_wrap__int to i64)), i64 0, ptr null, ptr null, i32 4, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_transform__int = private global [4 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_transform__int = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -3500849426833321643, i64 -117005740792843446, i64 sub (i64 ptrtoint (ptr @__profc_transform__int to i64), i64 ptrtoint (ptr @__profd_transform__int to i64)), i64 0, ptr null, ptr null, i32 4, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_safe_div = private global [17 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_safe_div = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 9145871025480991537, i64 7572915283204774, i64 sub (i64 ptrtoint (ptr @__profc_safe_div to i64), i64 ptrtoint (ptr @__profd_safe_div to i64)), i64 0, ptr null, ptr null, i32 17, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_show_result = private global [16 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_show_result = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -347660607815996094, i64 -4552966267369784476, i64 sub (i64 ptrtoint (ptr @__profc_show_result to i64), i64 ptrtoint (ptr @__profd_show_result to i64)), i64 0, ptr null, ptr null, i32 16, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_main = private global [11 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 11, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___bs_top_level = private global [12 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___bs_top_level = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -3222087168638311179, i64 -7005428211549351871, i64 sub (i64 ptrtoint (ptr @__profc___bs_top_level to i64), i64 ptrtoint (ptr @__profd___bs_top_level to i64)), i64 0, ptr null, ptr null, i32 12, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc___lambda_0 = private global [4 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd___lambda_0 = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -204181057533209874, i64 8245973951994833619, i64 sub (i64 ptrtoint (ptr @__profc___lambda_0 to i64), i64 ptrtoint (ptr @__profd___lambda_0 to i64)), i64 0, ptr null, ptr null, i32 4, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__llvm_prf_nm = private constant [79 x i8] c"ZMx\DA%\C7K\0A\C0 \0C\05@r\A3\DE\E8\111R!~H\A2^\BF\A5\9D\DD\1C\E3\09P\1E+\A9\E0|\AB=(\8C\BB\97a\ED\AFs\11\E4\BA\C9\EFq`\E2K\83\1A\D7N@r\C4\98P\D9\A2o\95[\CA\8C\EB\01#\EF\22\11", section "__DATA,__llvm_prf_names", align 1
@llvm.compiler.used = appending global [9 x ptr] [ptr @__llvm_profile_runtime_user, ptr @__profd_wrap__, ptr @__profd_double_wrap__int, ptr @__profd_transform__int, ptr @__profd_safe_div, ptr @__profd_show_result, ptr @__profd_main, ptr @__profd___bs_top_level, ptr @__profd___lambda_0], section "llvm.metadata"
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

define i64 @wrap__(i64 %0) {
entry:
  %x = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_wrap__, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_wrap__, align 8
  store i64 %0, ptr %x, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([3 x i64], ptr @__profc_wrap__, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([3 x i64], ptr @__profc_wrap__, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([3 x i64], ptr @__profc_wrap__, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([3 x i64], ptr @__profc_wrap__, i32 0, i32 2), align 8
  %x1 = load i64, ptr %x, align 8
  ret i64 %x1
}

define i64 @double_wrap__int(i64 %0) {
entry:
  %x = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_double_wrap__int, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_double_wrap__int, align 8
  store i64 %0, ptr %x, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_double_wrap__int, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([4 x i64], ptr @__profc_double_wrap__int, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_double_wrap__int, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc_double_wrap__int, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_double_wrap__int, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([4 x i64], ptr @__profc_double_wrap__int, i32 0, i32 3), align 8
  %x1 = load i64, ptr %x, align 8
  %5 = call i64 @wrap__(i64 %x1)
  ret i64 %5
}

define i64 @transform__int(i64 %0, ptr %1) {
entry:
  %f = alloca ptr, align 8
  %x = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_transform__int, align 8
  %2 = add i64 %pgocount, 1
  store i64 %2, ptr @__profc_transform__int, align 8
  store i64 %0, ptr %x, align 8
  store ptr %1, ptr %f, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_transform__int, i32 0, i32 1), align 8
  %3 = add i64 %pgocount1, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc_transform__int, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_transform__int, i32 0, i32 2), align 8
  %4 = add i64 %pgocount2, 1
  store i64 %4, ptr getelementptr inbounds ([4 x i64], ptr @__profc_transform__int, i32 0, i32 2), align 8
  %f1 = load i64, ptr %f, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc_transform__int, i32 0, i32 3), align 8
  %5 = add i64 %pgocount3, 1
  store i64 %5, ptr getelementptr inbounds ([4 x i64], ptr @__profc_transform__int, i32 0, i32 3), align 8
  %x2 = load i64, ptr %x, align 8
  %6 = call i64 @forge_closure_call_1(i64 %f1, i64 %x2)
  ret i64 %6
}

define ptr @safe_div(i64 %0, i64 %1) {
entry:
  %b = alloca i64, align 8
  %a = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_safe_div, align 8
  %2 = add i64 %pgocount, 1
  store i64 %2, ptr @__profc_safe_div, align 8
  store i64 %0, ptr %a, align 8
  store i64 %1, ptr %b, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_safe_div, i32 0, i32 1), align 8
  %3 = add i64 %pgocount1, 1
  store i64 %3, ptr getelementptr inbounds ([17 x i64], ptr @__profc_safe_div, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_safe_div, i32 0, i32 2), align 8
  %4 = add i64 %pgocount2, 1
  store i64 %4, ptr getelementptr inbounds ([17 x i64], ptr @__profc_safe_div, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_safe_div, i32 0, i32 3), align 8
  %5 = add i64 %pgocount3, 1
  store i64 %5, ptr getelementptr inbounds ([17 x i64], ptr @__profc_safe_div, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_safe_div, i32 0, i32 4), align 8
  %6 = add i64 %pgocount4, 1
  store i64 %6, ptr getelementptr inbounds ([17 x i64], ptr @__profc_safe_div, i32 0, i32 4), align 8
  %b1 = load i64, ptr %b, align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_safe_div, i32 0, i32 5), align 8
  %7 = add i64 %pgocount5, 1
  store i64 %7, ptr getelementptr inbounds ([17 x i64], ptr @__profc_safe_div, i32 0, i32 5), align 8
  %eq = icmp eq i64 %b1, 0
  %eq_ext = zext i1 %eq to i64
  %if_cond = icmp ne i64 %eq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %pgocount6 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_safe_div, i32 0, i32 12), align 8
  %8 = add i64 %pgocount6, 1
  store i64 %8, ptr getelementptr inbounds ([17 x i64], ptr @__profc_safe_div, i32 0, i32 12), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_safe_div, i32 0, i32 13), align 8
  %9 = add i64 %pgocount7, 1
  store i64 %9, ptr getelementptr inbounds ([17 x i64], ptr @__profc_safe_div, i32 0, i32 13), align 8
  %10 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr3 = getelementptr inbounds nuw %Result__int__string, ptr %10, i32 0, i32 0
  store i64 5862623, ptr %tag_ptr3, align 8
  %pay_ptr4 = getelementptr inbounds nuw %Result__int__string, ptr %10, i32 0, i32 1
  %11 = call ptr @forge_rc_alloc(i64 8)
  store ptr %11, ptr %pay_ptr4, align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_safe_div, i32 0, i32 14), align 8
  %12 = add i64 %pgocount8, 1
  store i64 %12, ptr getelementptr inbounds ([17 x i64], ptr @__profc_safe_div, i32 0, i32 14), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_safe_div, i32 0, i32 15), align 8
  %13 = add i64 %pgocount9, 1
  store i64 %13, ptr getelementptr inbounds ([17 x i64], ptr @__profc_safe_div, i32 0, i32 15), align 8
  %a5 = load i64, ptr %a, align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_safe_div, i32 0, i32 16), align 8
  %14 = add i64 %pgocount10, 1
  store i64 %14, ptr getelementptr inbounds ([17 x i64], ptr @__profc_safe_div, i32 0, i32 16), align 8
  %b6 = load i64, ptr %b, align 8
  %dz_chk = icmp eq i64 %b6, 0
  %dz_chk_ext = zext i1 %dz_chk to i64
  call void @forge_div_by_zero_trap(i64 %dz_chk_ext, ptr @dz_file, i64 137, i64 14)
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
  %pgocount11 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_safe_div, i32 0, i32 6), align 8
  %15 = add i64 %pgocount11, 1
  store i64 %15, ptr getelementptr inbounds ([17 x i64], ptr @__profc_safe_div, i32 0, i32 6), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_safe_div, i32 0, i32 7), align 8
  %16 = add i64 %pgocount12, 1
  store i64 %16, ptr getelementptr inbounds ([17 x i64], ptr @__profc_safe_div, i32 0, i32 7), align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_safe_div, i32 0, i32 8), align 8
  %17 = add i64 %pgocount13, 1
  store i64 %17, ptr getelementptr inbounds ([17 x i64], ptr @__profc_safe_div, i32 0, i32 8), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_safe_div, i32 0, i32 9), align 8
  %18 = add i64 %pgocount14, 1
  store i64 %18, ptr getelementptr inbounds ([17 x i64], ptr @__profc_safe_div, i32 0, i32 9), align 8
  %19 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Result__int__string, ptr %19, i32 0, i32 0
  store i64 193456014, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Result__int__string, ptr %19, i32 0, i32 1
  %20 = call ptr @forge_rc_alloc(i64 8)
  store ptr %20, ptr %pay_ptr, align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_safe_div, i32 0, i32 10), align 8
  %21 = add i64 %pgocount15, 1
  store i64 %21, ptr getelementptr inbounds ([17 x i64], ptr @__profc_safe_div, i32 0, i32 10), align 8
  %slot_base = ptrtoint ptr %20 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr @.str, ptr %slot, align 8
  %cast = ptrtoint ptr %19 to i64
  %cast2 = inttoptr i64 %cast to ptr
  ret ptr %cast2

if_else:                                          ; preds = %entry
  %pgocount16 = load i64, ptr getelementptr inbounds ([17 x i64], ptr @__profc_safe_div, i32 0, i32 11), align 8
  %22 = add i64 %pgocount16, 1
  store i64 %22, ptr getelementptr inbounds ([17 x i64], ptr @__profc_safe_div, i32 0, i32 11), align 8
  br label %ifcont

errdefer_path:                                    ; preds = %ifcont
  br label %defer_done

defer_path:                                       ; preds = %ifcont
  br label %defer_done

defer_done:                                       ; preds = %defer_path, %errdefer_path
  %cast12 = inttoptr i64 %cast10 to ptr
  ret ptr %cast12
}

define i64 @show_result(ptr %0) {
entry:
  %e11 = alloca ptr, align 8
  %v2 = alloca i64, align 8
  %match_result = alloca i64, align 8
  %r = alloca ptr, align 8
  %pgocount = load i64, ptr @__profc_show_result, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_show_result, align 8
  store ptr %0, ptr %r, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([16 x i64], ptr @__profc_show_result, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([16 x i64], ptr @__profc_show_result, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([16 x i64], ptr @__profc_show_result, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([16 x i64], ptr @__profc_show_result, i32 0, i32 2), align 8
  %r1 = load ptr, ptr %r, align 8
  %tag_ptr = getelementptr inbounds nuw %Result__int__string, ptr %r1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 5862623
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm6, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  %pay_slot = getelementptr inbounds nuw %Result__int__string, ptr %r1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load i64, ptr %v_slot, align 8
  store i64 %v, ptr %v2, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([16 x i64], ptr @__profc_show_result, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([16 x i64], ptr @__profc_show_result, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([16 x i64], ptr @__profc_show_result, i32 0, i32 4), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([16 x i64], ptr @__profc_show_result, i32 0, i32 4), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([16 x i64], ptr @__profc_show_result, i32 0, i32 5), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([16 x i64], ptr @__profc_show_result, i32 0, i32 5), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([16 x i64], ptr @__profc_show_result, i32 0, i32 6), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([16 x i64], ptr @__profc_show_result, i32 0, i32 6), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([16 x i64], ptr @__profc_show_result, i32 0, i32 7), align 8
  %8 = add i64 %pgocount7, 1
  store i64 %8, ptr getelementptr inbounds ([16 x i64], ptr @__profc_show_result, i32 0, i32 7), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([16 x i64], ptr @__profc_show_result, i32 0, i32 8), align 8
  %9 = add i64 %pgocount8, 1
  store i64 %9, ptr getelementptr inbounds ([16 x i64], ptr @__profc_show_result, i32 0, i32 8), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([16 x i64], ptr @__profc_show_result, i32 0, i32 9), align 8
  %10 = add i64 %pgocount9, 1
  store i64 %10, ptr getelementptr inbounds ([16 x i64], ptr @__profc_show_result, i32 0, i32 9), align 8
  %v3 = load i64, ptr %v2, align 8
  %11 = call ptr @forge_rc_alloc(i64 32)
  %12 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %11, i64 32, ptr @.i2s_fmt, i64 %v3)
  %widen = sext i32 %12 to i64
  %13 = call i64 @strlen(ptr @.str.1)
  %14 = call i64 @strlen(ptr %11)
  %concat_total = add i64 %13, %14
  %concat_size = add i64 %concat_total, 1
  %15 = call ptr @forge_rc_alloc(i64 %concat_size)
  %16 = call ptr @memcpy(ptr %15, ptr @.str.1, i64 %13)
  %cast = ptrtoint ptr %15 to i64
  %dst2_int = add i64 %cast, %13
  %cast4 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %14, 1
  %17 = call ptr @memcpy(ptr %cast4, ptr %11, i64 %rhs_len_p1)
  %18 = call i32 @puts(ptr %15)
  %widen5 = sext i32 %18 to i64
  store i64 0, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq8 = icmp eq i64 %tag, 193456014
  br i1 %tag_eq8, label %march_arm6, label %march_next7

march_arm6:                                       ; preds = %march_next
  %pay_slot9 = getelementptr inbounds nuw %Result__int__string, ptr %r1, i32 0, i32 1
  %payload10 = load ptr, ptr %pay_slot9, align 8
  %e_slot_base = ptrtoint ptr %payload10 to i64
  %e_slot_addr = add i64 %e_slot_base, 0
  %e_slot = inttoptr i64 %e_slot_addr to ptr
  %e = load ptr, ptr %e_slot, align 8
  call void @forge_rc_retain(ptr %e)
  store ptr %e, ptr %e11, align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([16 x i64], ptr @__profc_show_result, i32 0, i32 10), align 8
  %19 = add i64 %pgocount10, 1
  store i64 %19, ptr getelementptr inbounds ([16 x i64], ptr @__profc_show_result, i32 0, i32 10), align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([16 x i64], ptr @__profc_show_result, i32 0, i32 11), align 8
  %20 = add i64 %pgocount11, 1
  store i64 %20, ptr getelementptr inbounds ([16 x i64], ptr @__profc_show_result, i32 0, i32 11), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([16 x i64], ptr @__profc_show_result, i32 0, i32 12), align 8
  %21 = add i64 %pgocount12, 1
  store i64 %21, ptr getelementptr inbounds ([16 x i64], ptr @__profc_show_result, i32 0, i32 12), align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([16 x i64], ptr @__profc_show_result, i32 0, i32 13), align 8
  %22 = add i64 %pgocount13, 1
  store i64 %22, ptr getelementptr inbounds ([16 x i64], ptr @__profc_show_result, i32 0, i32 13), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([16 x i64], ptr @__profc_show_result, i32 0, i32 14), align 8
  %23 = add i64 %pgocount14, 1
  store i64 %23, ptr getelementptr inbounds ([16 x i64], ptr @__profc_show_result, i32 0, i32 14), align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([16 x i64], ptr @__profc_show_result, i32 0, i32 15), align 8
  %24 = add i64 %pgocount15, 1
  store i64 %24, ptr getelementptr inbounds ([16 x i64], ptr @__profc_show_result, i32 0, i32 15), align 8
  %e12 = load ptr, ptr %e11, align 8
  %25 = call i64 @strlen(ptr @.str.2)
  %26 = call i64 @strlen(ptr %e12)
  %concat_total13 = add i64 %25, %26
  %concat_size14 = add i64 %concat_total13, 1
  %27 = call ptr @forge_rc_alloc(i64 %concat_size14)
  %28 = call ptr @memcpy(ptr %27, ptr @.str.2, i64 %25)
  %cast15 = ptrtoint ptr %27 to i64
  %dst2_int16 = add i64 %cast15, %25
  %cast17 = inttoptr i64 %dst2_int16 to ptr
  %rhs_len_p118 = add i64 %26, 1
  %29 = call ptr @memcpy(ptr %cast17, ptr %e12, i64 %rhs_len_p118)
  %30 = call i32 @puts(ptr %27)
  %widen19 = sext i32 %30 to i64
  store i64 0, ptr %match_result, align 8
  br label %match_end

march_next7:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 26)
  unreachable
}

define i64 @main() {
entry:
  %doubled = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_main, align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr @__profc_main, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 2), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %3 = add i64 %pgocount3, 1
  store i64 %3, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %4 = add i64 %pgocount4, 1
  store i64 %4, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %5 = add i64 %pgocount5, 1
  store i64 %5, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %6 = call ptr @safe_div(i64 84, i64 2)
  %7 = call i64 @show_result(ptr %6)
  %pgocount6 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %8 = add i64 %pgocount6, 1
  store i64 %8, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %9 = add i64 %pgocount7, 1
  store i64 %9, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pgocount8 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %10 = add i64 %pgocount8, 1
  store i64 %10, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %pgocount9 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %11 = add i64 %pgocount9, 1
  store i64 %11, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %12 = add i64 %pgocount10, 1
  store i64 %12, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %13 = call ptr @safe_div(i64 1, i64 0)
  %14 = call i64 @show_result(ptr %13)
  %pgocount11 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %15 = add i64 %pgocount11, 1
  store i64 %15, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %16 = add i64 %pgocount12, 1
  store i64 %16, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %17 = add i64 %pgocount13, 1
  store i64 %17, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %18 = add i64 %pgocount14, 1
  store i64 %18, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %19 = add i64 %pgocount15, 1
  store i64 %19, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %20 = call i64 @double_wrap__int(i64 3)
  %21 = call ptr @forge_rc_alloc(i64 32)
  %22 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %21, i64 32, ptr @.i2s_fmt.3, i64 %20)
  %widen = sext i32 %22 to i64
  %23 = call i32 @puts(ptr %21)
  %widen1 = sext i32 %23 to i64
  %pgocount16 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %24 = add i64 %pgocount16, 1
  store i64 %24, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %pgocount17 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %25 = add i64 %pgocount17, 1
  store i64 %25, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %26 = add i64 %pgocount18, 1
  store i64 %26, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %27 = call ptr @forge_array_new()
  call void @forge_array_push(ptr %27, i64 -559038737)
  call void @forge_array_push(ptr %27, i64 ptrtoint (ptr @__lambda_0 to i64))
  %cast = ptrtoint ptr %27 to i64
  %cast2 = inttoptr i64 %cast to ptr
  %28 = call i64 @transform__int(i64 21, ptr %cast2)
  store i64 %28, ptr %doubled, align 8
  %pgocount19 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %29 = add i64 %pgocount19, 1
  store i64 %29, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %30 = add i64 %pgocount20, 1
  store i64 %30, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %31 = add i64 %pgocount21, 1
  store i64 %31, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %pgocount22 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %32 = add i64 %pgocount22, 1
  store i64 %32, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pgocount23 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %33 = add i64 %pgocount23, 1
  store i64 %33, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %pgocount24 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %34 = add i64 %pgocount24, 1
  store i64 %34, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %pgocount25 = load i64, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %35 = add i64 %pgocount25, 1
  store i64 %35, ptr getelementptr inbounds ([11 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %doubled3 = load i64, ptr %doubled, align 8
  %36 = call ptr @forge_rc_alloc(i64 32)
  %37 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %36, i64 32, ptr @.i2s_fmt.5, i64 %doubled3)
  %widen4 = sext i32 %37 to i64
  %38 = call i64 @strlen(ptr @.str.4)
  %39 = call i64 @strlen(ptr %36)
  %concat_total = add i64 %38, %39
  %concat_size = add i64 %concat_total, 1
  %40 = call ptr @forge_rc_alloc(i64 %concat_size)
  %41 = call ptr @memcpy(ptr %40, ptr @.str.4, i64 %38)
  %cast5 = ptrtoint ptr %40 to i64
  %dst2_int = add i64 %cast5, %38
  %cast6 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %39, 1
  %42 = call ptr @memcpy(ptr %cast6, ptr %36, i64 %rhs_len_p1)
  %43 = call i32 @puts(ptr %40)
  %widen7 = sext i32 %43 to i64
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  %pgocount = load i64, ptr getelementptr inbounds ([12 x i64], ptr @__profc___bs_top_level, i32 0, i32 11), align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr getelementptr inbounds ([12 x i64], ptr @__profc___bs_top_level, i32 0, i32 11), align 8
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

define i64 @__lambda_0(i64 %0) {
entry:
  %y = alloca i64, align 8
  store i64 %0, ptr %y, align 8
  %pgocount = load i64, ptr @__profc___lambda_0, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc___lambda_0, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_0, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_0, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_0, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_0, i32 0, i32 2), align 8
  %y1 = load i64, ptr %y, align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_0, i32 0, i32 3), align 8
  %4 = add i64 %pgocount3, 1
  store i64 %4, ptr getelementptr inbounds ([4 x i64], ptr @__profc___lambda_0, i32 0, i32 3), align 8
  %mul = mul i64 %y1, 2
  ret i64 %mul
}

; Function Attrs: noinline
define linkonce_odr hidden i32 @__llvm_profile_runtime_user() #1 {
  %1 = load i32, ptr @__llvm_profile_runtime, align 4
  ret i32 %1
}

attributes #0 = { nounwind }
attributes #1 = { noinline }
