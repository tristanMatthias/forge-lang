; ModuleID = '/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/generics/tests/generics.fg.ll'
source_filename = "bootstrap"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx"

%Pair__int__int = type { i64, i64 }
%Option__int = type { i64, ptr }

@x = global i64 0
@p = global i64 0
@opt = global i64 0
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name = private unnamed_addr constant [6 x i8] c"first\00", align 1
@sty_name = private unnamed_addr constant [15 x i8] c"Pair__int__int\00", align 1
@src_file = private unnamed_addr constant [133 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/generics/tests/generics.fg\00", align 1
@fld_name.1 = private unnamed_addr constant [7 x i8] c"second\00", align 1
@sty_name.2 = private unnamed_addr constant [15 x i8] c"Pair__int__int\00", align 1
@src_file.3 = private unnamed_addr constant [133 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/generics/tests/generics.fg\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.5 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.match_fn = private unnamed_addr constant [5 x i8] c"main\00", align 1
@mu_file = private unnamed_addr constant [133 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/forgec/src/features/generics/tests/generics.fg\00", align 1
@__llvm_profile_runtime = external hidden global i32
@__profc_identity__int = private global [3 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_identity__int = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -6961916823063176772, i64 5543866837681885496, i64 sub (i64 ptrtoint (ptr @__profc_identity__int to i64), i64 ptrtoint (ptr @__profd_identity__int to i64)), i64 0, ptr null, ptr null, i32 3, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__profc_main = private global [34 x i64] zeroinitializer, section "__DATA,__llvm_prf_cnts", align 8
@__profd_main = private global { i64, i64, i64, i64, ptr, ptr, i32, [3 x i16], i32 } { i64 -2624081020897602054, i64 6385467242, i64 sub (i64 ptrtoint (ptr @__profc_main to i64), i64 ptrtoint (ptr @__profd_main to i64)), i64 0, ptr null, ptr null, i32 34, [3 x i16] zeroinitializer, i32 0 }, section "__DATA,__llvm_prf_data,regular,live_support", align 8
@__llvm_prf_nm = private constant [28 x i8] c"\12\1Ax\DA\CBLI\CD+\C9,\A9\8C\8F\CF\CC+a\CCM\CC\CC\03\00EU\07\1A", section "__DATA,__llvm_prf_names", align 1
@llvm.compiler.used = appending global [3 x ptr] [ptr @__llvm_profile_runtime_user, ptr @__profd_identity__int, ptr @__profd_main], section "llvm.metadata"
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

define i64 @identity__int(i64 %0) {
entry:
  %x = alloca i64, align 8
  %pgocount = load i64, ptr @__profc_identity__int, align 8
  %1 = add i64 %pgocount, 1
  store i64 %1, ptr @__profc_identity__int, align 8
  store i64 %0, ptr %x, align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([3 x i64], ptr @__profc_identity__int, i32 0, i32 1), align 8
  %2 = add i64 %pgocount1, 1
  store i64 %2, ptr getelementptr inbounds ([3 x i64], ptr @__profc_identity__int, i32 0, i32 1), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([3 x i64], ptr @__profc_identity__int, i32 0, i32 2), align 8
  %3 = add i64 %pgocount2, 1
  store i64 %3, ptr getelementptr inbounds ([3 x i64], ptr @__profc_identity__int, i32 0, i32 2), align 8
  %x1 = load i64, ptr %x, align 8
  ret i64 %x1
}

define i64 @main() {
entry:
  %v17 = alloca i64, align 8
  %match_stmt_discard = alloca i64, align 8
  %pgocount = load i64, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %0 = add i64 %pgocount, 1
  store i64 %0, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 3), align 8
  %pgocount1 = load i64, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %1 = add i64 %pgocount1, 1
  store i64 %1, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 4), align 8
  %pgocount2 = load i64, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %2 = add i64 %pgocount2, 1
  store i64 %2, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 5), align 8
  %pgocount3 = load i64, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %3 = add i64 %pgocount3, 1
  store i64 %3, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 6), align 8
  %4 = call i64 @identity__int(i64 42)
  store i64 %4, ptr @x, align 8
  %pgocount4 = load i64, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %5 = add i64 %pgocount4, 1
  store i64 %5, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 7), align 8
  %pgocount5 = load i64, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %6 = add i64 %pgocount5, 1
  store i64 %6, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 8), align 8
  %pgocount6 = load i64, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %7 = add i64 %pgocount6, 1
  store i64 %7, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 9), align 8
  %pgocount7 = load i64, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %8 = add i64 %pgocount7, 1
  store i64 %8, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 10), align 8
  %x = load i64, ptr @x, align 8
  %9 = call ptr @forge_rc_alloc(i64 32)
  %10 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %9, i64 32, ptr @.i2s_fmt, i64 %x)
  %widen = sext i32 %10 to i64
  %11 = call i32 @puts(ptr %9)
  %widen1 = sext i32 %11 to i64
  %pgocount8 = load i64, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %12 = add i64 %pgocount8, 1
  store i64 %12, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 11), align 8
  %13 = call ptr @forge_rc_alloc(i64 16)
  %pgocount9 = load i64, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %14 = add i64 %pgocount9, 1
  store i64 %14, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 12), align 8
  %fld_ptr = getelementptr inbounds nuw %Pair__int__int, ptr %13, i32 0, i32 0
  store i64 10, ptr %fld_ptr, align 8
  %pgocount10 = load i64, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %15 = add i64 %pgocount10, 1
  store i64 %15, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 13), align 8
  %fld_ptr2 = getelementptr inbounds nuw %Pair__int__int, ptr %13, i32 0, i32 1
  store i64 20, ptr %fld_ptr2, align 8
  %cast = ptrtoint ptr %13 to i64
  store i64 %cast, ptr @p, align 8
  %pgocount11 = load i64, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %16 = add i64 %pgocount11, 1
  store i64 %16, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 14), align 8
  %pgocount12 = load i64, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %17 = add i64 %pgocount12, 1
  store i64 %17, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 15), align 8
  %pgocount13 = load i64, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %18 = add i64 %pgocount13, 1
  store i64 %18, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 16), align 8
  %pgocount14 = load i64, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %19 = add i64 %pgocount14, 1
  store i64 %19, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 17), align 8
  %pgocount15 = load i64, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %20 = add i64 %pgocount15, 1
  store i64 %20, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 18), align 8
  %pgocount16 = load i64, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %21 = add i64 %pgocount16, 1
  store i64 %21, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 19), align 8
  %p = load ptr, ptr @p, align 8
  %cast3 = ptrtoint ptr %p to i64
  %null_chk = icmp eq i64 %cast3, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name, i64 5, ptr @sty_name, i64 14, i64 %null_ext, ptr @src_file, i64 132, i64 22)
  %first_ptr = getelementptr inbounds nuw %Pair__int__int, ptr %p, i32 0, i32 0
  %first = load i64, ptr %first_ptr, align 8
  %pgocount17 = load i64, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %22 = add i64 %pgocount17, 1
  store i64 %22, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 20), align 8
  %pgocount18 = load i64, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %23 = add i64 %pgocount18, 1
  store i64 %23, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 21), align 8
  %p4 = load ptr, ptr @p, align 8
  %cast5 = ptrtoint ptr %p4 to i64
  %null_chk6 = icmp eq i64 %cast5, 0
  %null_ext7 = zext i1 %null_chk6 to i64
  call void @forge_null_deref_trap(ptr @fld_name.1, i64 6, ptr @sty_name.2, i64 14, i64 %null_ext7, ptr @src_file.3, i64 132, i64 22)
  %second_ptr = getelementptr inbounds nuw %Pair__int__int, ptr %p4, i32 0, i32 1
  %second = load i64, ptr %second_ptr, align 8
  %add = add i64 %first, %second
  %24 = call ptr @forge_rc_alloc(i64 32)
  %25 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %24, i64 32, ptr @.i2s_fmt.4, i64 %add)
  %widen8 = sext i32 %25 to i64
  %26 = call i32 @puts(ptr %24)
  %widen9 = sext i32 %26 to i64
  %pgocount19 = load i64, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %27 = add i64 %pgocount19, 1
  store i64 %27, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 22), align 8
  %28 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %Option__int, ptr %28, i32 0, i32 0
  store i64 6384548249, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %Option__int, ptr %28, i32 0, i32 1
  %29 = call ptr @forge_rc_alloc(i64 8)
  store ptr %29, ptr %pay_ptr, align 8
  %pgocount20 = load i64, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %30 = add i64 %pgocount20, 1
  store i64 %30, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 23), align 8
  %slot_base = ptrtoint ptr %29 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store i64 99, ptr %slot, align 8
  %cast10 = ptrtoint ptr %28 to i64
  store i64 %cast10, ptr @opt, align 8
  %pgocount21 = load i64, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %31 = add i64 %pgocount21, 1
  store i64 %31, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 24), align 8
  %pgocount22 = load i64, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %32 = add i64 %pgocount22, 1
  store i64 %32, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 25), align 8
  %opt = load ptr, ptr @opt, align 8
  %tag_ptr11 = getelementptr inbounds nuw %Option__int, ptr %opt, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr11, align 8
  %tag_eq = icmp eq i64 %tag, 6384368597
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm14, %march_arm
  %33 = call i32 @forge_test_summary()
  %widen21 = sext i32 %33 to i64
  call void @forge_rc_collect()
  ret i64 0

march_arm:                                        ; preds = %entry
  %pgocount23 = load i64, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %34 = add i64 %pgocount23, 1
  store i64 %34, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 26), align 8
  %pgocount24 = load i64, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %35 = add i64 %pgocount24, 1
  store i64 %35, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 27), align 8
  %pgocount25 = load i64, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %36 = add i64 %pgocount25, 1
  store i64 %36, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 28), align 8
  %pgocount26 = load i64, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %37 = add i64 %pgocount26, 1
  store i64 %37, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 29), align 8
  %38 = call ptr @forge_rc_alloc(i64 32)
  %39 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %38, i64 32, ptr @.i2s_fmt.5, i64 0)
  %widen12 = sext i32 %39 to i64
  %40 = call i32 @puts(ptr %38)
  %widen13 = sext i32 %40 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq16 = icmp eq i64 %tag, 6384548249
  br i1 %tag_eq16, label %march_arm14, label %march_next15

march_arm14:                                      ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %Option__int, ptr %opt, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %v_slot_base = ptrtoint ptr %payload to i64
  %v_slot_addr = add i64 %v_slot_base, 0
  %v_slot = inttoptr i64 %v_slot_addr to ptr
  %v = load i64, ptr %v_slot, align 8
  store i64 %v, ptr %v17, align 8
  %pgocount27 = load i64, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %41 = add i64 %pgocount27, 1
  store i64 %41, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 30), align 8
  %pgocount28 = load i64, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %42 = add i64 %pgocount28, 1
  store i64 %42, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 31), align 8
  %pgocount29 = load i64, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %43 = add i64 %pgocount29, 1
  store i64 %43, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 32), align 8
  %pgocount30 = load i64, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %44 = add i64 %pgocount30, 1
  store i64 %44, ptr getelementptr inbounds ([34 x i64], ptr @__profc_main, i32 0, i32 33), align 8
  %v18 = load i64, ptr %v17, align 8
  %45 = call ptr @forge_rc_alloc(i64 32)
  %46 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %45, i64 32, ptr @.i2s_fmt.6, i64 %v18)
  %widen19 = sext i32 %46 to i64
  %47 = call i32 @puts(ptr %45)
  %widen20 = sext i32 %47 to i64
  store i64 0, ptr %match_stmt_discard, align 8
  br label %match_end

march_next15:                                     ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 25)
  unreachable
}

; Function Attrs: noinline
define linkonce_odr hidden i32 @__llvm_profile_runtime_user() #1 {
  %1 = load i32, ptr @__llvm_profile_runtime, align 4
  ret i32 %1
}

attributes #0 = { nounwind }
attributes #1 = { noinline }
